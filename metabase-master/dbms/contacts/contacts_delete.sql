CREATE OR REPLACE FUNCTION contacts.contacts_delete (
)
RETURNS void AS
$body$
declare
v_id_clients integer[];
v_id_contacts integer[];
v_id_services integer[];
v_id_tasks integer[];
BEGIN

select array_agg(cl.id_client)
  into v_id_clients
  from clientdb.cdb_client cl
left join (SELECT id_client
             FROM dblink ('ccrm',
                  format($$select id_client
                             from clientdb.cdb_client$$)) 
                           AS cdb_client (id_client bigint)) ccrm_cl
  on cl.id_client = ccrm_cl.id_client
where ccrm_cl.id_client is null;

delete from clientdb.cdb_client_journal
where id_client in (select unnest(v_id_clients));

delete from clientdb.cdb_client_additional
where id_client in (select unnest(v_id_clients));

delete from clientdb.cdb_ls
where id_client in (select unnest(v_id_clients));

delete from clientdb.cdb_client
where id_client in (select unnest(v_id_clients));

select array_agg(cc.id_contact)
  into v_id_contacts
  from contacts.cm_contact cc
left join (SELECT id_contact
             FROM dblink ('ccrm',
                  format($$select id_contact
                             from contacts.cm_contact$$)) 
                           AS cm_contact (id_contact bigint)) ccrm_cont
  on cc.id_contact = ccrm_cont.id_contact
where ccrm_cont.id_contact is null;

delete from contacts.cm_contact_status_hist
where id_contact in (select unnest(v_id_contacts));

delete from contacts.cm_contact
where id_contact in (select unnest(v_id_contacts));
  
select array_agg(cs.id_service)
  into v_id_services
  from contacts.cm_service cs
left join (SELECT id_service
             FROM dblink ('ccrm',
                  format($$select id_service
                             from contacts.cm_service$$)) 
                           AS cm_service (id_service bigint)) ccrm_serv
  on cs.id_service = ccrm_serv.id_service
where ccrm_serv.id_service is null;

delete from contacts.cm_service_status_hist
where id_service in (select unnest(v_id_services));

delete from contacts.cm_service_journal
where id_service in (select unnest(v_id_services));

delete from contacts.cm_service_additional
where id_service in (select unnest(v_id_services));

delete from contacts.cm_service
where id_service in (select unnest(v_id_services));

delete from contacts.cm_contact_service
where id_service in (select unnest(v_id_services));

delete from contacts.cm_contact_service
where id_contact in (select unnest(v_id_services));

select array_agg(ct.id_task)
  into v_id_tasks
  from contacts.cm_task ct
left join (SELECT id_task
             FROM dblink ('ccrm',
                  format($$select id_task
                             from contacts.cm_task$$)) 
                           AS cm_task (id_task bigint)) ccrm_tsk
  on ct.id_task = ccrm_tsk.id_task
where ccrm_tsk.id_task is null;

delete from contacts.cm_task_status_hist
where id_task in (select unnest(v_id_tasks));

delete from contacts.cm_task
where id_task in (select unnest(v_id_tasks));

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;