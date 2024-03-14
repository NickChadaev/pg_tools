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
