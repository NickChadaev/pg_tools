DROP PROCEDURE IF EXISTS pcg_contacts.p_load_cm_service_journal (timestamp, timestamp,  bigint);
CREATE OR REPLACE PROCEDURE pcg_contacts.p_load_cm_service_journal (
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
                             id_entity AS id_service
                            ,kd_entity
                            ,dt_change
          					,id_usr
          					,kd_oper
          					,kd_attribute
          					,new_value
          					,old_value
     				      FROM (
     				          SELECT 
     				               cj.id_entity 
                  			      ,cj.kd_entity 
                                  ,cj.dt_change 
                                  ,cj.id_usr 
                                  ,cj.kd_oper 
                                  ,jsonb_array_elements(cj.vl_changes) ->> 'key' kd_attribute
                                  ,jsonb_array_elements(cj.vl_changes) ->> 'new' new_value
                                  ,jsonb_array_elements(cj.vl_changes) ->> 'old' old_value
                                    
             				   FROM contacts.cm_journal cj
             				   INNER JOIN dict.acc_user u ON (cj.id_usr  = u.acc_id_usr)  
                               JOIN contacts.cm_service cs 
                                    ON cj.id_entity = cs.id_service AND NOT cs.pr_previous
                                    
                               WHERE cj.nm_table_name = 'CM_SERVICE'
                                 AND cj.kd_entity IS NOT NULL
                                 AND cj.kd_oper = 202 
                                 AND cj.dt_change >= %1L
                                 AND cj.dt_change < %2L
                                 AND u.id_facility = %3L 
                            ) AS tbl
                           WHERE kd_attribute ~ '^\d+$'
                              ORDER BY dt_change
                             
                         $_$, p_dt_start, p_dt_end, p_id_facility
                    );
 
 BEGIN
   
   INSERT INTO contacts.cm_service_journal (id_service
                                          , kd_entity
                                          , dt_change
                                          , id_usr
                                          , kd_oper
                                          , kd_attribute
                                          , new_value
                                          , old_value
   )
   SELECT * FROM dblink ('ccrm', _exec) 
                             
       AS cm_service_journal ( id_service   bigint 
                              ,kd_entity    int8 
                              ,dt_change    timestamp 
                              ,id_usr       integer 
                              ,kd_oper      int4
                              ,kd_attribute int8
                              ,new_value    text
                              ,old_value    text
        )
   WHERE EXISTS (SELECT 1 FROM contacts.cm_service
                 WHERE id_service = cm_service_journal.id_service
   )                      
   ON conflict (dt_change, id_service, kd_attribute) DO NOTHING;
   
   EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_CONTACTS.P_LOAD_CM_SERVICE_JOURNAL: % -- %', SQLSTATE, SQLERRM;
        END; 
     
 END;
$$;

COMMENT ON PROCEDURE pcg_contacts.p_load_cm_service_journal (timestamp, timestamp, bigint)
   IS 'Загрузка журнала операций модуля Управление контактами';
 
-- USE CASE:
--      CALL pcg_contacts.p_load_cm_service_journal ('2023-01-14', '2024-03-14', 22);
--      SELECT count (1) FROM contacts.cm_service_journal;   --   1790
