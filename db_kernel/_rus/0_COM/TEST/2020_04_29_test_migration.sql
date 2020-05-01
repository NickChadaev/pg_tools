-- -----------------------------------------------
--  2020-04-29 Многосекционный LOG. Первый тест.
-- -----------------------------------------------
-- SELECT * FROM db_info.f_show_tbv_descr('nso');
-- SELECT * FROM com.all_log;
DROP VIEW com.x_log_1; 
CREATE OR REPLACE VIEW com.x_log_1 ( 
      schema_name  
     ,id_log       
     ,impact_type  
     ,impact_date  
     ,impact_descr
     ,user_name    
     ,host_name  	
)
  AS
    SELECT  
       lower (schema_name)
      ,id_log
      ,impact_type
      ,impact_date
      ,impact_descr
      ,user_name
      ,host_name
    FROM com.all_log;

SELECT * FROM com.x_log_1;
INSERT INTO com.all_log_1 SELECT * FROM com.x_log_1;-- 814
-- SELECT * FROM com.com_log_1; -- 803   
UPDATE com.com_log_1 SET schema_name = 'com';
-- SELECT * FROM nso.nso_log_1; -- 11
--
-- SELECT * FROM com.com_log_1_19_op;  -- 655
-- SELECT * FROM com.com_log_1_19_er;  -- 138
-- SELECT * FROM com.com_log_1_20_op;  -- 9
-- SELECT * FROM com.com_log_1_20_er;  -- 1
--
-- SELECT * FROM nso.nso_log_1_19_op;  -- 0
-- SELECT * FROM nso.nso_log_1_19_er;  -- 0 
-- SELECT * FROM nso.nso_log_1_20_op;  -- 9 
-- SELECT * FROM nso.nso_log_1_20_er;  -- 2 