DROP PROCEDURE IF EXISTS pcg_contacts.p_load_cm_services_add (timestamp, timestamp,  bigint);
CREATE OR REPLACE PROCEDURE pcg_contacts.p_load_cm_services_add (
   p_dt_start    timestamp         
  ,p_dt_end      timestamp
  ,p_id_facility bigint   
)  
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$$

 DECLARE -- либо kd_system  | 43  -- СИД Киров.
 
  _exec  text = format ($_$ SELECT 
                                   csa.kd_entity  
                                  ,csa.nn_rownum 
                                  ,csa.id_service  
                                  ,csa.dt_change 
                                  ,csa.id_usr 
                                  ,csa."data"
                                  
                             FROM contacts.cm_service_additional csa
                               JOIN contacts.cm_service cs  
                                   ON csa.id_service = cs.id_service AND (NOT cs.pr_previous)
                                   
                               INNER JOIN dict.acc_user u ON (csa.id_usr = u.acc_id_usr)                                   
                            
                           WHERE (csa.dt_change >= %1L AND csa.dt_change < %2L AND u.id_facility = %3L)
                    $_$, p_dt_start, p_dt_end, p_id_facility);
 
 BEGIN
   INSERT INTO contacts.cm_service_additional (
                  kd_entity
                , nn_rownum
                , id_service
                , dt_change
                , id_usr
                , "data"
   )
   SELECT * FROM dblink ('ccrm', _exec) 
                             
     AS cm_service_additional (  kd_entity  int4 
                                ,nn_rownum  int4  
                   			    ,id_service bigint 
                   			    ,dt_change  timestamp 
                   			    ,id_usr     bigint 
                   			    ,"data"     jsonb
                   			)
   WHERE EXISTS (SELECT 1 FROM contacts.cm_service WHERE id_service = cm_service_additional.id_service
    )  
                 
   ON CONFLICT (id_service, kd_entity, nn_rownum) DO
   UPDATE SET "data"    = excluded."data",
              dt_change = excluded.dt_change,
              id_usr    = excluded.id_usr
              
   WHERE cm_service_additional.id_usr    <> excluded.id_usr
      OR cm_service_additional.dt_change <> excluded.dt_change
      OR cm_service_additional."data" IS DISTINCT FROM excluded."data";

 END;
$$;

COMMENT ON PROCEDURE pcg_contacts.p_load_cm_services_add (timestamp, timestamp, bigint)
   IS 'Загрузка дополнительных сущностей МЕТАМОДЕЛИ';
 
-- USE CASE:
--      CALL pcg_contacts.p_load_cm_services_add ('2023-01-14', '2024-03-14', 22);
--      SELECT count (1) FROM contacts.cm_service_additional;   -- 18
