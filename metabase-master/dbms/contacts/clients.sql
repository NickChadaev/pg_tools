CREATE OR REPLACE FUNCTION contacts.clients (
  p_dt_start timestamp,
  p_dt_end timestamp
)
RETURNS void AS
$body$
DECLARE
  v_dt_st timestamp;
  v_dt_en timestamp;
BEGIN

insert into clientdb.cdb_client (id_client, id_client_united, id_client_jur_parent, kd_tp_client,
                                 kd_system, kd_process, dt_reg, pr_jur_contact_only, pr_delete, data)
SELECT * 
  FROM dblink ('ccrm',
               format($$select id_client, 
                               id_client_united, 
                               id_client_jur_parent, 
                               kd_tp_client,
                               kd_system, 
                               kd_process, 
                               dt_reg, 
                               pr_jur_contact_only, 
                               pr_delete,
                               jsonb_insert(data, 
                                            '{ADDR_FIZ, nm_fias_guid}', 
                                            to_jsonb((select nm_fias_guid::text
                                                        from unnsi.adr_house ah 
                                                      where id_house = cast("data" -> 'ADDR_FIZ' ->> 'id_addr' as bigint))))
                          from clientdb.cdb_client
                        where (dt_change >= %1L
                          and  dt_change < %2L)
                           or (dt_reg >= %3L
                          and  dt_reg < %4L)$$, p_dt_start, p_dt_end, p_dt_start, p_dt_end)) 
  AS cdb_client (id_client bigint, 
                 id_client_united bigint, 
                 id_client_jur_parent bigint, 
                 kd_tp_client int4,
                 kd_system int4, 
                 kd_process bigint, 
                 dt_reg timestamp, 
                 pr_jur_contact_only boolean, 
                 pr_delete boolean,
                 data jsonb)
where id_client not in (select unnest(vl_param) id_client from dict.dct_spec_params where kd_param = 1)                   
on conflict (id_client) do
update set id_client_united = excluded.id_client_united,
           id_client_jur_parent = excluded.id_client_jur_parent,
           pr_jur_contact_only = excluded.pr_jur_contact_only,
           pr_delete = excluded.pr_delete,
           data = excluded.data
where cdb_client.id_client_united <> excluded.id_client_united
   or cdb_client.id_client_united is distinct from excluded.id_client_united
   or cdb_client.id_client_jur_parent <> excluded.id_client_jur_parent
   or cdb_client.id_client_jur_parent is distinct from excluded.id_client_jur_parent
   or cdb_client.pr_jur_contact_only <> excluded.pr_jur_contact_only
   or cdb_client.pr_delete <> excluded.pr_delete
   or cdb_client.data <> excluded.data;

insert into clientdb.cdb_ls (id_ls, id_dict_facility, id_client, dt_en, nm_ls, 
                                 id_ls_role, dt_create)
SELECT * 
  FROM dblink ('ccrm',
               format($$select id_ls,
                               id_dict_facility,
                               id_client,
                               dt_en,
                               nm_ls,
                               id_ls_role,
                               dt_create 
                          from clientdb.cdb_ls
                        where (dt_change >= %1L
                          and  dt_change < %2L)
                           or (dt_create >= %3L
                          and  dt_create < %4L)$$, p_dt_start, p_dt_end, p_dt_start, p_dt_end)) 
  AS cdb_ls (id_ls bigint,
                 id_dict_facility int4,
                 id_client bigint,
                 dt_en timestamp,
                 nm_ls text,
                 id_ls_role int4,
                 dt_create timestamp)
where id_client not in (select unnest(vl_param) id_client from dict.dct_spec_params where kd_param = 1)                     
on conflict (id_ls) do
update set dt_en = excluded.dt_en,
           id_ls_role = excluded.id_ls_role
where cdb_ls.dt_en <> excluded.dt_en
   or cdb_ls.dt_en is distinct from excluded.dt_en
   or cdb_ls.id_ls_role <> excluded.id_ls_role
   or cdb_ls.id_ls_role is distinct from excluded.id_ls_role;
 
insert into clientdb.cdb_client_additional (id_client_additional, id_client, kd_entity, data, id_ls)
SELECT * 
  FROM dblink ('ccrm',
               format($$select id_client_additional,
                               id_client,
                               kd_entity,
                               data,
                               id_ls
                          from clientdb.cdb_client_additional
                        where dt_change >= %1L
                          and dt_change < %2L$$, p_dt_start, p_dt_end)) 
  AS cdb_client_additional (id_client_additional bigint,
                            id_client bigint,
                            kd_entity int4,
                            data jsonb,
                            id_ls bigint)
where id_client not in (select unnest(vl_param) id_client from dict.dct_spec_params where kd_param = 1)                     
on conflict (id_client_additional) do
update set data = excluded.data
where cdb_client_additional.data <> excluded.data;

insert into clientdb.cdb_client_journal (id_client, dt_change, id_usr,
       					                 kd_oper, kd_attribute, new_value, old_value)
SELECT * 
  FROM dblink ('ccrm',
               format($$select id_entity id_client,
                               dt_change,
       					       id_usr,
       					       kd_oper,
       					       kd_attribute,
       					       new_value,
       					       old_value
  				          from (select cj.id_entity,
                                       cj.dt_change,
                                       cj.id_usr,
                                       cj.kd_oper,
                                       jsonb_array_elements(cj.vl_changes) ->> 'key' kd_attribute,
                                       jsonb_array_elements(cj.vl_changes) ->> 'new' new_value,
                                       jsonb_array_elements(cj.vl_changes) ->> 'old' old_value
          				          from clientdb.cdb_journal cj
                                where dt_change >= %1L
                                  and dt_change < %2L) as tbl
                          where kd_attribute ~ '^\d+$'$$, p_dt_start, p_dt_end)) 
    AS cdb_client_journal (id_client bigint,
                           dt_change timestamp,
                           id_usr integer,
                           kd_oper int4,
                           kd_attribute int8,
                           new_value text,
                           old_value text)
where kd_attribute in (20,21)
  and id_client not in (select unnest(vl_param) id_client from dict.dct_spec_params where kd_param = 1)      
on conflict (dt_change, id_client, kd_attribute) do nothing;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;