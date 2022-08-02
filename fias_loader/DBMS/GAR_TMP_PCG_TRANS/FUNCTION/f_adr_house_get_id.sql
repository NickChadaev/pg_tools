DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_get (text, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_house_get (
               p_schema    text -- Имя схемы
              ,p_id_house  bigint -- аргумент
	          ,OUT rr      gar_tmp.adr_house_t 
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
                          
                  FROM ONLY %I.adr_house
                        WHERE (id_house = %L);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --     2021-12-15 Nick.
    --     2022-02-07  Переход на базовые типы.
    --     2022-02-21  ONLY 
    --     2022-06-15 Выбираю запись любого типа, т.е актуальную, удалённую.    
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_id_house);  
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_house_get (text, bigint) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_house_get (text, bigint) 
IS 'Получить запись из таблицы адресов улиц. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_house_get(text,bigint) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT * FROM gar_tmp_pcg_trans.f_adr_house_get ('unnsi', 600033432);
--       SELECT * FROM gar_tmp_pcg_trans.f_adr_house_get ('unnsi', 600029845);
