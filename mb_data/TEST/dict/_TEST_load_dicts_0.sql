CREATE OR REPLACE FUNCTION dict.load_dict (
)
RETURNS void AS
$body$
BEGIN
--
-- 2024-03-06  Причём это ???
--
INSERT INTO metamodel.m_entity_attribute (kd_entity
                                        , kd_attribute
                                        , nm_attribute
                                        , nm_attr_desc
                                        , nm_title
                                        , kd_dict_entity
                                        , nm_column_name
                                        , pr_active
                                        , kd_attr_type  --comment
                                        )
SELECT * 
  FROM dblink ('ccrm',
               $$SELECT DISTINCT
                        mea.kd_entity,
                        mea.kd_attribute,
                        ma.nm_attribute,
                        ma.nm_attr_desc,
                        CASE
                          WHEN mp.kd_entity IN (SELECT kd_entity FROM metamodel.m_entity 
                                                   WHERE kd_entity_parent in (3000,4000))
                            THEN REPLACE(REPLACE(ue.nm_title, '<b>', ''), '/b', '')
                          ELSE NULL
                        END nm_title,
                        
                        mea.kd_dict_entity,
                        mea.nm_column_name,
                        mea.pr_active,
                        ma.kd_attr_type
                        
                        FROM metamodel.m_entity_attribute mea
                           JOIN metamodel.m_attribute ma ON mea.kd_attribute = ma.kd_attribute
                           
                           LEFT JOIN uiconf.ui_element_mm_prop mp
                             ON mea.kd_entity = mp.kd_entity
                            AND mea.kd_attribute = mp.kd_attribute
                            AND mp.id_element = (SELECT max(id_element)
                                                   FROM uiconf.ui_element_mm_prop
                                                   WHERE mp.kd_entity = kd_entity
                                                    AND mp.kd_attribute = kd_attribute
                                                )
                           LEFT JOIN uiconf.ui_element ue ON mp.id_element = ue.id_element
                    $$ -- 2974 ROWS
                    
    ) 
     AS m_entity_attribute (kd_entity     int4,
                            kd_attribute   int4,
                            nm_attribute   text,
                            nm_attr_desc   text,
                            nm_title       text,
                            kd_dict_entity int4,
                            nm_column_name text,
                            pr_active      boolean,
                            kd_attr_type   int4
                            )                        
ON CONFLICT (kd_entity, kd_attribute) 
DO
UPDATE SET nm_attribute   = excluded.nm_attribute,
           nm_attr_desc   = excluded.nm_attr_desc,
           nm_title       = excluded.nm_title,
           kd_dict_entity = excluded.kd_dict_entity,
           nm_column_name = excluded.nm_column_name,
           pr_active      = excluded.pr_active,
           kd_attr_type   = excluded.kd_attr_type
           
WHERE m_entity_attribute.nm_attribute <> excluded.nm_attribute   -- ?? IS DISTINCT
   OR m_entity_attribute.nm_attr_desc   IS DISTINCT FROM excluded.nm_attr_desc
   OR m_entity_attribute.nm_title       IS DISTINCT FROM excluded.nm_title
   OR m_entity_attribute.kd_dict_entity IS DISTINCT FROM excluded.kd_dict_entity
   OR m_entity_attribute.nm_column_name <> excluded.nm_column_name
   OR m_entity_attribute.pr_active      <> excluded.pr_active
   OR m_entity_attribute.kd_attr_type   <> excluded.kd_attr_type; 
-- 
--
--
 
INSERT INTO dict.dct_dict (id_dict, id_dict_parent, kd_dict_entity, pr_delete,
                                nm_dict, nm_dict_full
                                )
SELECT * 
  FROM dblink ('ccrm',
               $$SELECT id_dict,
                        id_dict_parent,
                        kd_dict_entity,
                        pr_delete,
                        nm_dict,
                        nm_dict_full
                   FROM dict.d_dict
                   $$) 
  AS dct_dict (id_dict bigint,
                         id_dict_parent bigint,
                         kd_dict_entity int4,
                         pr_delete boolean,
                         nm_dict text,
                         nm_dict_full text)                      
ON conflict (id_dict, kd_dict_entity) 
DO
update set id_dict_parent = excluded.id_dict_parent,
           nm_dict        = excluded.nm_dict,
           nm_dict_full   = excluded.nm_dict_full,
           pr_delete      = excluded.pr_delete
           
where dct_dict.id_dict_parent is distinct from excluded.id_dict_parent
   or dct_dict.nm_dict <> excluded.nm_dict
   or dct_dict.nm_dict_full is distinct from excluded.nm_dict_full
   or dct_dict.pr_delete <> excluded.pr_delete;
    
    
    
insert into dict.dct_sys_entity (kd_sys_entity, nm_sys_entity, nm_description, nm_table_name)
SELECT * 
  FROM dblink ('ccrm',
               $$select kd_sys_entity, 
                        nm_sys_entity, 
                        nm_description, 
                        nm_table_name
                   from dict.d_sys_entity
                   $$) 
  AS dct_sys_entity (kd_sys_entity int4, 
                     nm_sys_entity text, 
                     nm_description text, 
                     nm_table_name text)                      
on conflict (kd_sys_entity) do
update set nm_sys_entity = excluded.nm_sys_entity,
           nm_description = excluded.nm_description,
           nm_table_name = excluded.nm_table_name
where dct_sys_entity.nm_sys_entity <> excluded.nm_sys_entity
   or dct_sys_entity.nm_description is distinct from excluded.nm_description
   or dct_sys_entity.nm_table_name <> excluded.nm_table_name;
      
      
      
insert into dict.dct_status (kd_status, nm_status, nm_description,
                                  kd_sys_entity, dt_change)
SELECT * 
  FROM dblink ('ccrm',
               $$select kd_status, 
                        nm_status, 
                        nm_description,
                        kd_sys_entity, 
                        dt_change
                   from dict.d_status$$) 
  AS dct_status (kd_status int4, 
                 nm_status text, 
                 nm_description text,
                 kd_sys_entity int4, 
                 dt_change timestamp)                      
on conflict (kd_status) do
update set nm_status = excluded.nm_status,
           nm_description = excluded.nm_description,
           dt_change = excluded.dt_change
where dct_status.nm_status <> excluded.nm_status
   or dct_status.nm_description is distinct from excluded.nm_description
   or dct_status.dt_change <> excluded.dt_change;
--
--   70
--

insert into dict.dct_service_status (kd_status, kd_dict_entity, nm_status, nm_description,
                                          dt_change)
SELECT * 
  FROM dblink ('ccrm',
               $$select id_dict,
                        kd_dict_entity,
                        nm_dict, 
                        nm_dict_full,
                        dt_change
                   from dict.d_service_status$$) 
  AS dct_status (kd_status int4,
                 kd_dict_entity int8, 
                 nm_status text, 
                 nm_description text,
                 dt_change timestamp)                      
on conflict (kd_status) do
update set nm_status = excluded.nm_status,
           nm_description = excluded.nm_description,
           dt_change = excluded.dt_change
where dct_service_status.nm_status <> excluded.nm_status
   or dct_service_status.nm_description is distinct from excluded.nm_description
   or dct_service_status.dt_change <> excluded.dt_change;

insert into dict.dct_tp_client (kd_tp_client, nm_tp_client, nm_abbreviation)
SELECT * 
  FROM dblink ('ccrm',
               $$select kd_tp_client, 
                        nm_tp_client, 
                        nm_abbreviation
                   from dict.d_tp_client$$) 
  AS dct_tp_client (kd_tp_client int4, 
                    nm_tp_client text, 
                    nm_abbreviation text)                      
on conflict (kd_tp_client) do
update set nm_tp_client = excluded.nm_tp_client,
           nm_abbreviation = excluded.nm_abbreviation
where dct_tp_client.nm_tp_client <> excluded.nm_tp_client
   or dct_tp_client.nm_abbreviation is distinct from excluded.nm_abbreviation;
 
insert into dict.dct_system (kd_system, nm_system, nm_description, pr_billing,
                                  pr_lk, kd_tp_client)
SELECT * 
  FROM dblink ('ccrm',
               $$select kd_system,
                        nm_system,
                        nm_description,
                        pr_billing,
                        pr_lk,
                        kd_tp_client
                   from dict.d_system$$) 
  AS dct_system (kd_system int4,
               nm_system text,
               nm_description text,
               pr_billing boolean,
               pr_lk boolean,
               kd_tp_client int4)                      
on conflict (kd_system) do
update set nm_system = excluded.nm_system,
           nm_description = excluded.nm_description,
           pr_billing = excluded.pr_billing,
           pr_lk = excluded.pr_lk,
           kd_tp_client = excluded.kd_tp_client
where dct_system.nm_description is distinct from excluded.nm_description
   or dct_system.kd_tp_client is distinct from excluded.kd_tp_client
   or dct_system.nm_system <> excluded.nm_system
   or dct_system.pr_billing <> excluded.pr_billing
   or dct_system.pr_lk <> excluded.pr_lk;

insert into dict.dct_crm_service (id_crm_service, nm_crm_service, id_dict_facility,
                                       kd_tp_client, kd_entity, pr_gro)
SELECT * 
  FROM dblink ('ccrm',
               $$select dcs.id_crm_service,
                        sn.nm_dict nm_crm_service,
                        dcs.id_dict_facility,
                        dcs.kd_tp_client,
                        dcs.kd_entity,
                        case
                          when dcs.kd_entity between 3200 and 3300
                            or dcs.kd_entity = 13340 then true
                          else false
                        end pr_gro
                   from dict_cm.d_crm_service dcs
                   join dict.d_crm_service_name sn
                     on dcs.id_dict_name = sn.id_dict$$) 
  AS dct_crm_service (id_crm_service uuid,
                      nm_crm_service text,
                      id_dict_facility int4,
                      kd_tp_client int4,
                      kd_entity int4,
                      pr_gro boolean)                      
on conflict (id_crm_service) do
update set nm_crm_service = excluded.nm_crm_service,
           id_dict_facility = excluded.id_dict_facility 
where dct_crm_service.nm_crm_service <> excluded.nm_crm_service
   or dct_crm_service.id_dict_facility <> excluded.id_dict_facility;

insert into dict.dct_tp_contact (kd_tp_contact, nm_tp_contact, nm_description)
SELECT * 
  FROM dblink ('ccrm',
               $$select kd_tp_contact,
                        nm_tp_contact,
                        nm_description
                   from dict_cm.d_tp_contact$$) 
  AS dct_tp_contact (kd_tp_contact int4,
                     nm_tp_contact text,
                     nm_description text)                      
on conflict (kd_tp_contact) do
update set nm_tp_contact = excluded.nm_tp_contact,
           nm_description = excluded.nm_description
where dct_tp_contact.nm_tp_contact <> excluded.nm_tp_contact
   or dct_tp_contact.nm_description is distinct from excluded.nm_description;

insert into dict.dct_step_service (id_step, nm_step)
SELECT * 
  FROM dblink ('ccrm',
               $$select bs.id_step,
                        bs.nm_step
                   from scenery.bp_step bs
                 where bs.kd_step_type = 2$$) 
    AS dct_step_service (id_step uuid,
                         nm_step text)                      
on conflict (id_step) do
update set nm_step = excluded.nm_step
where dct_step_service.nm_step is distinct from excluded.nm_step;

insert into dict.dct_users (acc_id_usr, nm_usr, fio, id_facility,
                                 pr_access, kd_otd, kd_otd_list)
SELECT * 
  FROM dblink ('ccrm',
               $$select acc_id_usr, 
                        nm_usr, 
                        concat_ws(' ', nm_last, nm_first, nm_middle) fio, 
                        id_facility,
                        pr_access, 
                        kd_otd,
                        kd_otd_list
                   from dict.acc_user$$) 
  AS dct_users (acc_id_usr bigint, 
                nm_usr text, 
                fio text, 
                id_facility int4,
                pr_access boolean, 
                kd_otd int8,
                kd_otd_list integer[])                      
on conflict (acc_id_usr) do
update set nm_usr = excluded.nm_usr,
           fio = excluded.fio,
           id_facility = excluded.id_facility,
           pr_access = excluded.pr_access,
           kd_otd = excluded.kd_otd,
           kd_otd_list = excluded.kd_otd_list
where dct_users.nm_usr <> excluded.nm_usr
   or dct_users.fio <> excluded.fio
   or dct_users.id_facility <> excluded.id_facility
   or dct_users.pr_access <> excluded.pr_access
   or dct_users.kd_otd <> excluded.kd_otd
   or dct_users.kd_otd_list is distinct from excluded.kd_otd_list;

insert into dict.dct_otdels (kd_otd, kd_otd_parent, nm_otd, id_facility)
SELECT * 
  FROM dblink ('ccrm',
               $$  select kd_otd,
                          kd_parent_otd,
                          nm_otd,
                          id_facility
                          from dict.otdel_mv$$) 
  AS dct_otdels (kd_otd bigint,
                 kd_otd_parent bigint,
                 nm_otd text,
                 id_facility int4)                      
on conflict (kd_otd) do
update set kd_otd_parent = excluded.kd_otd_parent,
           nm_otd = excluded.nm_otd,
           id_facility = excluded.id_facility
where dct_otdels.kd_otd_parent is distinct from excluded.kd_otd_parent
   or dct_otdels.nm_otd <> excluded.nm_otd
   or dct_otdels.id_facility <> excluded.id_facility;
   
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;
