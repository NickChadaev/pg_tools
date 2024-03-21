DROP PROCEDURE IF EXISTS pcg_contacts.p_load_cm_tasks_hist (timestamp, timestamp, bigint);
CREATE OR REPLACE PROCEDURE pcg_contacts.p_load_cm_tasks_hist (
         p_dt_start    timestamp 
        ,p_dt_end      timestamp
        ,p_id_facility bigint    
)

  LANGUAGE plpgsql
  SECURITY INVOKER
AS  
$$
 DECLARE
   _exec text = format ($_$ SELECT  sh.id_sys_entity id_task, 
                                    sh.dt_change, 
           					        sh.kd_status, 
           					        sh.id_usr 
      				          FROM contacts.cm_status_hist sh
                                JOIN dict.acc_user u ON (u.acc_id_usr = sh.id_usr)      				          
    				        WHERE sh.kd_sys_entity = 6  AND sh.dt_change >= %1$L
                                  AND sh.dt_change < %2$L AND u.id_facility = %3$L
                        $_$, p_dt_start, p_dt_end, p_id_facility);

 BEGIN
    INSERT INTO contacts.cm_task_status_hist 
              ( id_task
              , dt_change
              , kd_status
              , id_usr
    )
    SELECT * 
      FROM dblink ('ccrm', _exec) 
      AS cm_task_status_hist ( id_task   bigint 
                              ,dt_change timestamp  
           					  ,kd_status int4  
           					  ,id_usr    integer
      )
    WHERE EXISTS (SELECT 1 FROM contacts.cm_task WHERE id_task = cm_task_status_hist.id_task)              
    ON CONFLICT (id_task, dt_change) DO NOTHING;
  
 END;
$$;

COMMENT ON PROCEDURE pcg_contacts.p_load_cm_tasks_hist (timestamp, timestamp, bigint)
   IS 'Загрузка истории изменения статуса задачи';
   
   -- USE CASE:
   --          CALL pcg_contacts.p_load_cm_tasks_hist ('2023-01-14', '2024-03-14', 22);
   --          SELECT * FROM contacts.cm_task_status_hist;
   --          SELECT COUNT(1) FROM contacts.cm_task_status_hist; -- 1016
