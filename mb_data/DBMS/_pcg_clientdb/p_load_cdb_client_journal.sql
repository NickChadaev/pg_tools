DROP PROCEDURE IF EXISTS pcg_clientdb.cdb_client_journal (timestamp, timestamp, bigint);
CREATE OR REPLACE PROCEDURE pcg_clientdb.cdb_client_journal (
        p_dt_start    timestamp
       ,p_dt_end      timestamp
       ,p_id_facility bigint    
)

  LANGUAGE plpgsql
  SECURITY INVOKER
AS  
$$
   BEGIN
     INSERT INTO clientdb.cdb_client_journal (id_client
                                            , dt_change
                                            , id_usr
                                            , kd_oper
                                            , kd_attribute
                                            , new_value
                                            , old_value
     )
     SELECT * 
       FROM dblink ('ccrm',
                    format ($_$ SELECT  id_entity AS id_client 
                                       ,dt_change 
            					       ,id_usr 
            					       ,kd_oper 
            					       ,kd_attribute 
            					       ,new_value 
            					       ,old_value
       				          FROM (SELECT  cj.id_entity 
                                           ,cj.dt_change 
                                           ,cj.id_usr 
                                           ,cj.kd_oper 
                                           ,jsonb_array_elements(cj.vl_changes) ->> 'key' kd_attribute
                                           ,jsonb_array_elements(cj.vl_changes) ->> 'new' new_value 
                                           ,jsonb_array_elements(cj.vl_changes) ->> 'old' old_value
                                           
               				          
               				          FROM clientdb.cdb_journal cj
                                      INNER JOIN dict.acc_user u ON (cj.id_usr = u.acc_id_usr )                                           
                                              WHERE (dt_change >= %1L AND dt_change < %2L) AND
                                                    (u.id_facility = %3L)
                                     ) AS tbl
                               WHERE kd_attribute ~ '^\d+$'
                            $_$, p_dt_start, p_dt_end, p_id_facility
                           )
                   ) 
         AS cdb_client_journal ( id_client    bigint 
                                ,dt_change    timestamp 
                                ,id_usr       integer 
                                ,kd_oper      int4 
                                ,kd_attribute int8 
                                ,new_value    text 
                                ,old_value    text
        )
     WHERE kd_attribute in (20,21)
       AND id_client NOT IN (SELECT unnest(vl_param) id_client 
                  FROM dict.dct_spec_params WHERE kd_param = 1)      
     ON conflict (dt_change, id_client, kd_attribute) DO NOTHING;

 END;
$$;

COMMENT ON PROCEDURE pcg_clientdb.cdb_client_journal (timestamp, timestamp, bigint) IS
'Загрузка журнала операци модуля Клиенты';

-- USE CASE 
--            CALL pcg_clientdb.cdb_client_journal ('2023-01-14', '2024-03-14', 22);
--            SELECT * FROM clientdb.cdb_client_journal;
--            SELECT count(1) FROM clientdb.cdb_client_journal;   -- 33
--            DELETE FROM clientdb.cdb_client_journal;  --   
