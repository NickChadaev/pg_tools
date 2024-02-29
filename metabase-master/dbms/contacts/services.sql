CREATE OR REPLACE FUNCTION contacts.services (
  p_dt_start timestamp,
  p_dt_end timestamp
)
RETURNS void AS
$body$
BEGIN

insert into contacts.cm_service (id_service, id_contact, id_service_parent, id_jur_contact, dt_create,
                                 id_crm_service, kd_system, "data", nn_ls, id_reg_ls, 
                                 id_reg, id_usr_create, pr_reject, id_scenario_instance, kd_scenario_status,
                                 pr_ended, dt_complete)
SELECT * 
  FROM dblink ('ccrm',
               format($$select cs.id_service,
                               cs.id_contact,
                               cs.id_service_parent,
                               cs.id_jur_contact,
                               cs.dt_create,
                               cs.id_crm_service,
                               cs.kd_system,
                               cs."data",
                               cs.nn_ls,
                               cs.id_reg_ls,
                               cs.id_reg,
                               cs.id_usr_create,
                               cs.pr_reject,
                               si.id_scenario_instance,
                               si.kd_status kd_scenario_status,
                               case
                                 when si.kd_status = 11 then true
                                 else false
                               end pr_ended,
                               si.dt_complete
                          from contacts.cm_service cs
                        left join scenery.bpe_scenario_instance si
                          on cs.id_service = si.id_sys_entity
                         and si.kd_sys_entity = 9
                         and si.id_scenario_instance_parent is null
                       where (cs.dt_change < %1L
                          or cs.dt_create < %2L)
                         and cs.pr_previous = false$$, p_dt_end, p_dt_end)) 
  AS cm_service (id_service bigint,
                 id_contact bigint,
                 id_service_parent bigint,
                 id_jur_contact bigint,
                 dt_create timestamp,
                 id_crm_service uuid,
                 kd_system int4,
                 "data" jsonb,
                 nn_ls text,
                 id_reg_ls int8,
                 id_reg int8,
                 id_usr_create bigint,
                 pr_reject boolean,
                 id_scenario_instance bigint,
                 kd_scenario_status int4,
                 pr_ended boolean,
                 dt_complete timestamp)
where id_usr_create not in (select unnest(vl_param) id_user from dict.dct_spec_params where kd_param = 2)
  and case 
      when id_contact is not null 
        then exists (select from contacts.cm_contact
                     where id_contact = cm_service.id_contact) 
      else true
      end
on conflict (id_service) do
update set id_contact = excluded.id_contact,
           id_jur_contact = excluded.id_jur_contact,
           data = excluded.data,
           nn_ls = excluded.nn_ls,
           id_reg_ls = excluded.id_reg_ls,
           pr_reject = excluded.pr_reject,
           id_scenario_instance = excluded.id_scenario_instance,
           kd_scenario_status = excluded.kd_scenario_status,
           pr_ended = excluded.pr_ended,
           dt_complete = excluded.dt_complete
where cm_service.id_contact is distinct from excluded.id_contact
   or cm_service.id_jur_contact is distinct from excluded.id_jur_contact
   or cm_service.data is distinct from excluded.data
   or cm_service.nn_ls is distinct from excluded.nn_ls
   or cm_service.id_reg_ls is distinct from excluded.id_reg_ls
   or cm_service.pr_reject <> excluded.pr_reject
   or cm_service.id_scenario_instance is distinct from excluded.id_scenario_instance
   or cm_service.kd_scenario_status is distinct from excluded.kd_scenario_status
   or cm_service.pr_ended <> excluded.pr_ended
   or cm_service.dt_complete is distinct from excluded.dt_complete;

insert into contacts.cm_service_additional (kd_entity, nn_rownum, id_service, dt_change,
                                            id_usr, "data")
SELECT * 
  FROM dblink ('ccrm',
               format($$select csa.kd_entity, 
                               csa.nn_rownum, 
                               csa.id_service, 
                               csa.dt_change,
                               csa.id_usr,
                               csa."data"
                          from contacts.cm_service_additional csa
                        join contacts.cm_service cs
                          on csa.id_service = cs.id_service
                         and not cs.pr_previous
                        where csa.dt_change >= %1L
                          and csa.dt_change < %2L$$, p_dt_start, p_dt_end)) 
  AS cm_service_additional (kd_entity int4,
                            nn_rownum int4, 
                			id_service bigint, 
                			dt_change timestamp,
                			id_usr bigint,
                			"data" jsonb)
where exists (select from contacts.cm_service
              where id_service = cm_service_additional.id_service)                     
on conflict (id_service, kd_entity, nn_rownum) do
update set "data" = excluded."data",
           dt_change = excluded.dt_change,
           id_usr = excluded.id_usr
where cm_service_additional.id_usr <> excluded.id_usr
   or cm_service_additional.dt_change <> excluded.dt_change
   or cm_service_additional."data" is distinct from excluded."data";

insert into contacts.cm_contact_service (id_contact, id_service, dt_change, id_usr, pr_initial_contact)
SELECT * 
  FROM dblink ('ccrm',
               format($$select ccs.id_contact,
                               ccs.id_service,
                               ccs.dt_change,
                               ccs.id_usr,
                               ccs.pr_initial_contact
                          from contacts.cm_contact_service ccs
                        join contacts.cm_service cs
                          on ccs.id_service = cs.id_service
                         and not cs.pr_previous
                        where ccs.dt_change >= %1L
                          and ccs.dt_change < %2L$$, p_dt_start, p_dt_end)) 
  AS cm_contact_service (id_contact bigint,
                         id_service bigint,
                         dt_change timestamp,
                         id_usr integer,
                         pr_initial_contact boolean)
where exists (select from contacts.cm_service
              where id_service = cm_contact_service.id_service)                       
on conflict (id_contact, id_service) do nothing;

insert into contacts.cm_service_journal (id_service, kd_entity, dt_change, id_usr,
       					                 kd_oper, kd_attribute, new_value, old_value)
SELECT * 
  FROM dblink ('ccrm',
               format($$select id_entity id_service,
                               kd_entity,
                               dt_change,
       					       id_usr,
       					       kd_oper,
       					       kd_attribute,
       					       new_value,
       					       old_value
  				          from (select cj.id_entity,
               				           cj.kd_entity,
                                       cj.dt_change,
                                       cj.id_usr,
                                       cj.kd_oper,
                                       jsonb_array_elements(cj.vl_changes) ->> 'key' kd_attribute,
                                       jsonb_array_elements(cj.vl_changes) ->> 'new' new_value,
                                       jsonb_array_elements(cj.vl_changes) ->> 'old' old_value
          				          from contacts.cm_journal cj
                                join contacts.cm_service cs
                                  on cj.id_entity = cs.id_service
                                 and not cs.pr_previous
                                where cj.nm_table_name = 'CM_SERVICE'
                                  and cj.kd_entity is not null
                                  and cj.kd_oper = 202 
                                  and cj.dt_change >= %1L
                                  and cj.dt_change < %2L) as tbl
                          where kd_attribute ~ '^\d+$'
                          order by dt_change$$, p_dt_start, p_dt_end)) 
    AS cm_service_journal (id_service bigint,
                           kd_entity int8,
                           dt_change timestamp,
                           id_usr integer,
                           kd_oper int4,
                           kd_attribute int8,
                           new_value text,
                           old_value text)
where exists (select from contacts.cm_service
              where id_service = cm_service_journal.id_service)                      
on conflict (dt_change, id_service, kd_attribute) do nothing;

insert into contacts.cm_service_status_hist (id_service, dt_change, kd_status, id_usr)
SELECT * 
  FROM dblink ('ccrm',
               format($$select id_service, 
                               dt_change, 
       					       kd_service_status, 
       					       id_usr 
  				          from contacts.cm_service_status_hist sh
				        where sh.dt_change >= %1L
                          and sh.dt_change < %2L$$, p_dt_start, p_dt_end)) 
  AS cm_service_status_hist (id_service bigint, 
                             dt_change timestamp, 
       					     kd_status int4, 
       					     id_usr integer)
where exists (select from contacts.cm_service
              where id_service = cm_service_status_hist.id_service)                  
on conflict (id_service, dt_change) do nothing;

insert into contacts.cm_comment (id_comment, id_comment_parent, id_entity, kd_sys_entity, id_usr_create,
                                 nm_comment, dt_comment, pr_del)
SELECT * 
  FROM dblink ('ccrm',
               format($$select id_comment, 
                               id_comment_parent, 
                               id_entity, 
                               kd_sys_entity, 
                               id_usr_create,
                        	   nm_comment, 
                               dt_comment, 
                               case 
                                 when dt_del is not null then true
                                 else false
                               end pr_del
                          from contacts.cm_comment
                        where (dt_change >= %1L
                          and  dt_change < %2L)
                           or (dt_comment >= %3L
                          and  dt_comment < %4L)$$, p_dt_start, p_dt_end, p_dt_start, p_dt_end))
  AS cm_comment (id_comment bigint, 
                 id_comment_parent bigint, 
                 id_entity bigint, 
                 kd_sys_entity int4, 
                 id_usr_create integer,
                 nm_comment text, 
                 dt_comment timestamp, 
                 pr_del boolean)                    
on conflict (id_comment) do
update set id_comment_parent = excluded.id_comment_parent,
           nm_comment = excluded.nm_comment,
           pr_del = excluded.pr_del
where cm_comment.id_comment_parent is distinct from excluded.id_comment_parent
   or cm_comment.id_comment_parent <> excluded.id_comment_parent
   or cm_comment.nm_comment <> excluded.nm_comment
   or cm_comment.pr_del <> excluded.pr_del;
  
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;

ALTER FUNCTION contacts.services (p_dt_start timestamp, p_dt_end timestamp)
  OWNER TO mb_owner;