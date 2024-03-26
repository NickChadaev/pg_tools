DROP PROCEDURE IF EXISTS pcg_contacts.p_load_cm_services_hist (timestamp, timestamp,  bigint);
CREATE OR REPLACE PROCEDURE pcg_contacts.p_load_cm_services_hist (
   p_dt_start    timestamp         
  ,p_dt_end      timestamp
  ,p_id_facility bigint   
)  
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$$
 BEGIN 
    INSERT INTO contacts.cm_service_status_hist (id_service
                                               , dt_change
                                               , kd_status
                                               , id_usr
    )
    SELECT * 
      FROM dblink ('ccrm',
                   format ($_$ SELECT 
                                    id_service  
                                   ,dt_change  
           					       ,kd_service_status 
           					       ,id_usr 
      				          FROM contacts.cm_service_status_hist sh
      				                         INNER JOIN dict.acc_user u ON (sh.id_usr = u.acc_id_usr)   
      				          
    				        WHERE (sh.dt_change >= %1L AND sh.dt_change < %2L AND u.id_facility = %3L)
                              
                              $_$, p_dt_start, p_dt_end, p_id_facility
                          )
        ) 
      AS cm_service_status_hist ( id_service bigint  
                                 ,dt_change  timestamp 
           					     ,kd_status  int4  
           					     ,id_usr     integer
        )
    WHERE EXISTS (SELECT 1 FROM contacts.cm_service 
                                WHERE id_service = cm_service_status_hist.id_service
                 )                  
    ON CONFLICT (id_service, dt_change) DO NOTHING;
   
   EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_CONTACTS.P_LOAD_CM_SERVICES_HIST: % -- %', SQLSTATE, SQLERRM;
        END; 
    
 END;
$$;

COMMENT ON PROCEDURE pcg_contacts.p_load_cm_services_hist (timestamp, timestamp, bigint)
   IS 'Загрузка история изменения статуса процесса';
 
-- USE CASE:
--      CALL pcg_contacts.p_load_cm_services_hist ('2023-01-14', '2024-03-14', 22);
--      SELECT count (1) FROM contacts.cm_service_status_hist;   -- 467
