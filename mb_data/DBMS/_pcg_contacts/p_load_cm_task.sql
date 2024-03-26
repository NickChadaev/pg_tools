DROP PROCEDURE IF EXISTS pcg_contacts.p_load_cm_tasks (timestamp, timestamp, bigint);
CREATE OR REPLACE PROCEDURE pcg_contacts.p_load_cm_tasks (
         p_dt_start    timestamp 
        ,p_dt_end      timestamp
        ,p_id_facility bigint    
)

  LANGUAGE plpgsql
  SECURITY INVOKER
AS  
$$
 DECLARE
   _exec text = format ($_$
                          SELECT 
                              ct.id_task 
   						     ,ct.id_service 
                             ,ct.id_task_type 
                             ,ct.id_usr_create 
                             ,ct.id_log 
                             ,ct.id_task_parent 
                             ,ct.id_usr_executor 
                             ,ct.id_reg_executor 
                             ,ct.dt_create 
                             ,ct.dt_plan_beg
                             ,ct.dt_plan_end
                             ,ct.dt_fact_end
                             ,ct.id_task_solution 
                             ,ct.kd_status
                             ,sh.dt_change dt_status
                             ,il.id_step
                             
                        FROM contacts.cm_task ct
                        
                      JOIN contacts.cm_status_hist sh ON (ct.id_task = sh.id_sys_entity
                            AND sh.kd_sys_entity = 6
                            AND sh.dt_change = (SELECT max(dt_change) FROM contacts.cm_status_hist 
                                                WHERE id_sys_entity = sh.id_sys_entity
                                                  AND kd_sys_entity = 6
                                               )
                        ) 
                                            
                      -- Экземпляр шага сценария процесса.
                      LEFT JOIN scenery.bpe_scenario_instance_log il ON ct.id_log = il.id_log
                        
                      JOIN contacts.cm_service cs ON ct.id_service = cs.id_service AND NOT cs.pr_previous
                      JOIN dict.acc_user u ON (u.acc_id_usr = ct.id_usr_create) 
                      
                      WHERE ((ct.dt_change >= %1$L AND ct.dt_change < %2$L)
                                OR 
                             (ct.dt_create >= %1$L AND  ct.dt_create < %2$L)
                            ) AND (u.id_facility = %3$L)
                    $_$, p_dt_start, p_dt_end, p_id_facility);

 BEGIN
--
   INSERT INTO contacts.cm_task ( id_task
                                , id_service
                                , id_task_type
                                , id_usr_create
                                , id_log
                                , id_task_parent
                                , id_usr_executor
                                , id_reg_executor
                                , dt_create
                                , dt_plan_beg
                                , dt_plan_end
                                , dt_fact_end
                                , id_task_solution
                                , kd_status    -- + id_task_type  тип задачи -- опушен
                                , dt_status
                                , id_step)                    
   SELECT * 
     FROM dblink ('ccrm', _exec) 
                    
     AS cm_task ( id_task          bigint 
                 ,id_service       bigint 
                 ,id_task_type     int4 
                 ,id_usr_create    bigint
                 ,id_log           bigint
                 ,id_task_parent   bigint
                 ,id_usr_executor  bigint
                 ,id_reg_executor  int4
                 ,dt_create        timestamp
                 ,dt_plan_beg      timestamp
                 ,dt_plan_end      timestamp
                 ,dt_fact_end      timestamp
                 ,id_task_solution int4
                 ,kd_status        int4 
                 ,dt_status        timestamp 
                 ,id_step          uuid
     )
   WHERE id_usr_create NOT IN (SELECT unnest(vl_param) id_user FROM dict.dct_spec_params 
                                      WHERE kd_param = 2
                            )
--      -- хРЕНОТЕННЬ     сервисы заполнять. !!!!!!!   ЗАДАЧА ОПИРАЕТСЯ НА СЕРВИС        
--      AND EXISTS (SELECT 1 FROM contacts.cm_service WHERE id_service = cm_task.id_service)         
   
   ON CONFLICT (id_task) DO
   UPDATE SET  id_log           = excluded.id_log 
              ,id_task_parent   = excluded.id_task_parent 
              ,id_usr_executor  = excluded.id_usr_executor 
              ,id_reg_executor  = excluded.id_reg_executor 
              ,dt_plan_beg      = excluded.dt_plan_beg 
              ,dt_plan_end      = excluded.dt_plan_end 
              ,dt_fact_end      = excluded.dt_fact_end 
              ,id_task_solution = excluded.id_task_solution 
              ,kd_status        = excluded.kd_status 
              ,id_task_type     = excluded.id_task_type 
              ,dt_status        = excluded.dt_status 
              ,id_step          = excluded.id_step
              
   WHERE cm_task.id_log          IS DISTINCT FROM excluded.id_log
      OR cm_task.id_task_parent  IS DISTINCT FROM excluded.id_task_parent
      OR cm_task.id_usr_executor IS DISTINCT FROM excluded.id_usr_executor
      OR cm_task.id_reg_executor IS DISTINCT FROM excluded.id_reg_executor
      OR cm_task.dt_plan_beg <> excluded.dt_plan_beg
      OR cm_task.dt_plan_end <> excluded.dt_plan_end
      OR cm_task.dt_fact_end     IS DISTINCT FROM excluded.dt_fact_end
      OR cm_task.id_task_solution <> excluded.id_task_solution
      OR cm_task.kd_status        <> excluded.kd_status
      OR cm_task.id_task_type IS DISTINCT FROM excluded.id_task_type
      OR cm_task.dt_status    IS DISTINCT FROM excluded.dt_status
      OR cm_task.id_step      IS DISTINCT FROM excluded.id_step;

   EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
             RAISE 'PCG_CONTACTS.P_LOAD_CM_TASKS: % -- %', SQLSTATE, SQLERRM;
        END; 
   
 END;
$$;

COMMENT ON PROCEDURE pcg_contacts.p_load_cm_tasks (timestamp, timestamp, bigint)
   IS 'Загрузка данных по задачам';
   
   -- USE CASE:
   --          CALL pcg_contacts.p_load_cm_tasks ('2023-01-14', '2024-03-14', 22);
   --          SELECT * FROM contacts.cm_task;
   --          SELECT COUNT(1) FROM contacts.cm_task;
