--
--  2020-04-29 Nick  Тест на вложенное секционирование. Схема NSO.
--
CREATE TABLE nso.nso_log_1 PARTITION OF com.all_log_1 
    FOR VALUES IN ( 'nso', 'nso_data', 'nso_exchange', 'nso_structure'
  )  PARTITION BY LIST (table_name) ;  
 --
 CREATE TABLE nso.nso_log_10 PARTITION OF nso.nso_log_1 
            FOR VALUES IN ('nso_object', 'nso_record', 'nso_section', 'nso_key', 'nso_key_attr'
                           ,'nso_column_head'
  );
 --
 CREATE TABLE nso.nso_log_20 PARTITION OF nso.nso_log_1 
           FOR VALUES IN ('nso_abs', 'nso_ref', 'nso_blob');

-- SELECT * FROM nso.nso_log_1;
