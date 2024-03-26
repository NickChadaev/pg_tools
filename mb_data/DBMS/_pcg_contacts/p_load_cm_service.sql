DROP PROCEDURE IF EXISTS pcg_contacts.p_load_cm_services (timestamp, timestamp,  bigint);
CREATE OR REPLACE PROCEDURE pcg_contacts.p_load_cm_services (
   p_dt_start    timestamp        -- NOT USED
  ,p_dt_end      timestamp
  ,p_id_facility bigint   
)  
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$$

 DECLARE -- либо kd_system  | 43  -- СИД Киров.
 
   _exec text = format ($_$ SELECT 
                                   cs.id_service
                                  ,cs.id_contact
                                  ,cs.id_service_parent
                                  ,cs.id_jur_contact
                                  ,cs.dt_create
                                  ,cs.id_crm_service 
                                  ,cs.kd_system 
                                  ,cs."data" 
                                  ,cs.nn_ls 
                                  ,cs.id_reg_ls 
                                  ,cs.id_reg 
                                  ,cs.id_usr_create 
                                  ,cs.pr_reject 
                                  ,si.id_scenario_instance 
                                  ,si.kd_status kd_scenario_status 
                                  ,CASE
                                       WHEN si.kd_status = 11 THEN TRUE
                                       ELSE FALSE
                                   END pr_ended 
                                  ,si.dt_complete
                             FROM contacts.cm_service cs
                             
                           INNER JOIN dict.acc_user u ON (cs.id_usr_create = u.acc_id_usr)
                           
                           -- Экземпляр сценария процесса 
                           LEFT JOIN scenery.bpe_scenario_instance si 
                                                     ON cs.id_service = si.id_sys_entity
                            AND si.kd_sys_entity = 9
                            AND si.id_scenario_instance_parent IS NULL
                           
                           WHERE (cs.dt_change < %1$L OR cs.dt_create < %1$L)
                             AND (cs.pr_previous = FALSE) AND (u.id_facility = %2$L)
          $_$, p_dt_end, p_id_facility
        );

 BEGIN

   INSERT INTO contacts.cm_service (
                id_service
              , id_contact
              , id_service_parent
              , id_jur_contact
              , dt_create
              , id_crm_service
              , kd_system
              , "data"
              , nn_ls
              , id_reg_ls
              , id_reg
              , id_usr_create
              , pr_reject
              , id_scenario_instance
              , kd_scenario_status
              , pr_ended
              , dt_complete
    )
   SELECT * 
     FROM dblink ('ccrm', _exec ) 
     AS cm_service ( id_service           bigint 
                    ,id_contact           bigint 
                    ,id_service_parent    bigint 
                    ,id_jur_contact       bigint 
                    ,dt_create            timestamp 
                    ,id_crm_service       uuid 
                    ,kd_system            int4 
                    ,"data"               jsonb 
                    ,nn_ls                text 
                    ,id_reg_ls            int8 
                    ,id_reg               int8 
                    ,id_usr_create        bigint 
                    ,pr_reject            boolean 
                    ,id_scenario_instance bigint 
                    ,kd_scenario_status   int4 
                    ,pr_ended             boolean
                    ,dt_complete          timestamp
                )
   WHERE id_usr_create NOT IN (
                    SELECT unnest(vl_param) id_user FROM dict.dct_spec_params WHERE kd_param = 2
    )
     AND CASE 
           WHEN id_contact IS NOT NULL 
             THEN EXISTS (SELECT 1 FROM contacts.cm_contact WHERE id_contact = cm_service.id_contact) 
           ELSE TRUE
         END
   ON CONFLICT (id_service) DO
   
   UPDATE SET  id_contact           = excluded.id_contact 
              ,id_jur_contact       = excluded.id_jur_contact 
              ,data                 = excluded.data 
              ,nn_ls                = excluded.nn_ls 
              ,id_reg_ls            = excluded.id_reg_ls 
              ,pr_reject            = excluded.pr_reject 
              ,id_scenario_instance = excluded.id_scenario_instance 
              ,kd_scenario_status   = excluded.kd_scenario_status 
              ,pr_ended             = excluded.pr_ended 
              ,dt_complete          = excluded.dt_complete
              
   WHERE cm_service.id_contact           IS DISTINCT FROM excluded.id_contact
      OR cm_service.id_jur_contact       IS DISTINCT FROM excluded.id_jur_contact
      OR cm_service.data                 IS DISTINCT FROM excluded.data
      OR cm_service.nn_ls                IS DISTINCT FROM excluded.nn_ls
      OR cm_service.id_reg_ls            IS DISTINCT FROM excluded.id_reg_ls
      OR cm_service.pr_reject       <> excluded.pr_reject
      OR cm_service.id_scenario_instance IS DISTINCT FROM excluded.id_scenario_instance
      OR cm_service.kd_scenario_status   IS DISTINCT FROM excluded.kd_scenario_status
      OR cm_service.pr_ended        <> excluded.pr_ended
      OR cm_service.dt_complete          IS DISTINCT FROM excluded.dt_complete;
   
  EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_CONTACTS.P_LOAD_CM_SERVICES: % -- %', SQLSTATE, SQLERRM;
        END; 
   
 END;
$$;

COMMENT ON PROCEDURE pcg_contacts.p_load_cm_services (timestamp, timestamp, bigint)
   IS 'Загрузка данных по процессам';
 
-- USE CASE:
--      CALL pcg_contacts.p_load_cm_services  ('2023-01-14', '2024-03-14', 22);
--      SELECT  count (1) FROM contacts.cm_service;   -- 227
