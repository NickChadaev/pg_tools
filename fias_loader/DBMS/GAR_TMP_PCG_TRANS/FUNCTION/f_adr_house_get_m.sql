DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_get (text, bigint, varchar(250), bigint);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_get (text, bigint, varchar(250), bigint, integer);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_house_get (
              p_schema         text -- Имя схемы
              --
             ,p_id_area         bigint       --  NOT NULL
             ,p_nm_house_full   varchar(250) --  NOT NULL
             ,p_id_street       bigint       --   NULL
             ,p_id_house_type_1 integer      --   NULL
              --
             ,OUT rr gar_tmp.adr_house_t 
)
    RETURNS gar_tmp.adr_house_t
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
         SELECT   
         
              id_house          
             ,id_area           
             ,id_street         
             ,id_house_type_1   
             ,nm_house_1        
             ,id_house_type_2   
             ,nm_house_2        
             ,id_house_type_3   
             ,nm_house_3        
             ,nm_zipcode        
             ,nm_house_full     
             ,kd_oktmo          
             ,nm_fias_guid      
             ,dt_data_del       
             ,id_data_etalon    
             ,kd_okato          
             ,vl_addr_latitude  
             ,vl_addr_longitude 
                 
         FROM ONLY %I.adr_house WHERE
              (id_area = %L::bigint) AND (upper(nm_house_full::text) = upper (%L)::text) AND
              (id_street IS NOT DISTINCT FROM %L::bigint) AND
              (id_house_type_1 IS NOT DISTINCT FROM %L::integer) AND
			  (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
      $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --     2022-01-27 Nick.
    --     2022-02-07 Переход на базовые типы.
    --     2022-02-11 В уникальность добавлен "id_house_type_1"
    --     2022-02-21  Опция ONLY
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_id_area, p_nm_house_full, p_id_street, p_id_house_type_1);  
     
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_house_get  (text, bigint, varchar(250), bigint, integer) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_house_get (text, bigint, varchar(250), bigint, integer)
IS 'Получить запись из таблицы адресов улиц. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_house_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_house_get ('gar_tmp', 1087, 'д. 74',  68730);
--       SELECT gar_tmp_pcg_trans.f_adr_house_get ('unnsi', 73908, 'д. 2', NULL, 2);
--       SELECT gar_tmp_pcg_trans.f_adr_house_get ('gar_tmp', 73908, 'д. 2', NULL);    
-- -----------------------------------------------------------------------------------
--  SELECT nm_fias_guid FROM unnsi.adr_house 
--                       WHERE ((id_area = 73908) AND (upper(nm_house_full::text) = upper('д. 2')) AND
--                              (id_street IS NOT DISTINCT FROM NULL) AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL)
--                       ); -- 001d7c82-92e0-4392-82f1-f9646e6c9f9f
-- SELECT * FROM unnsi.adr_house WHERE (nm_fias_guid = '001d7c82-92e0-4392-82f1-f9646e6c9f9f');
-- --
--  SELECT nm_fias_guid FROM unnsi.adr_house 
--                WHERE ((id_area = 91764) AND (upper(nm_house_full::text) = upper('дв. 10')) AND
--                       (id_street IS NOT DISTINCT FROM 588345) AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL)
--                       ); -- dfd85aa3-942b-4911-a8b9-a800514712d3
--
-- SELECT * FROM gar_tmp_pcg_trans.f_adr_house_get ('unnsi', 73908, 'д. 2', NULL, 2);
-- SELECT (gar_tmp_pcg_trans.f_adr_house_get ('unnsi', 73908, 'д. 2', NULL, 2)).id_house;
-- SELECT (gar_tmp_pcg_trans.f_adr_house_get ('unnsi', 73908, 'д. 2', NULL, 2)).nm_fias_guid;
