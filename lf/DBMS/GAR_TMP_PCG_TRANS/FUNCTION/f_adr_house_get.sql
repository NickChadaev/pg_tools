DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_get (text, uuid);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_house_get (
               p_schema        text -- Имя схемы
              ,p_nm_fias_guid  uuid -- аргумент
	          ,OUT rr          gar_tmp.adr_house_t 
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
                        WHERE (nm_fias_guid = %L)
                             AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --   2021-12-15 Nick.
    --   2022-02-07  Переход на базовые типы.
    --   2022-02-21  ONLY 
    --   2023-11-10 Дополнительный поиск в таблице "gar_fias.twin_addr_objects".        
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_nm_fias_guid);  
     EXECUTE _exec INTO rr;
     
     IF (rr.id_house IS NULL) 
       THEN
        --
        -- Хрен во всю морду, пробуем искать в таблице двойников.
        --
        _exec := format (  _select
                         , p_schema
                         , (SELECT t.fias_guid_new FROM gar_fias.twin_addr_objects t 
                                       INNER JOIN gar_fias.as_houses h ON (t.fias_guid_new = h.object_guid)
                            WHERE ((h.end_date > current_date) AND (t.fias_guid_old = p_nm_fias_guid)) 
                           ) 
         );  
        EXECUTE _exec INTO rr;
  END IF;     
     
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_house_get (text, uuid) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_house_get (text, uuid) 
IS 'Получить запись из таблицы адресов ДОМОВ. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_house_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_house_get ('gar_tmp', '5f63f750-777f-4d7f-855f-bc2d13dbd6c9'::uuid);
--               '(24583675,192263,942690,2,26,,,,,367014,"д. 26",82701362,eb783cda-5615-43f5-8a12-5f6906e2163d,,,82401362000,,)'

--       SELECT gar_tmp_pcg_trans.f_adr_house_get ('gar_tmp', 'eb783cda-5615-43f5-8a12-5f6906e2163d'::uuid);
--               '(24583675,192263,942690,2,26,,,,,367014,"д. 26",82701362,eb783cda-5615-43f5-8a12-5f6906e2163d,,,82401362000,,)'

--       SELECT gar_tmp_pcg_trans.f_adr_house_get ('gar_tmp', 'eb783cda-5615-43f5-8992-5f6906e2163d'::uuid);
--           '(,,,,,,,,,,,,,,,,,)'

--       SELECT gar_tmp_pcg_trans.f_adr_house_get ('gar_tmp', 'c0e84a0b-a00c-4f1c-beec-fba22f64bf31'::uuid);
--           '(466809,125,10673,2,13,,,,,450007,"д. 13",80701000001,c0e84a0b-a00c-4f1c-beec-fba22f64bf31,,,80401380000,,)'

--       SELECT gar_tmp_pcg_trans.f_adr_house_get ('gar_tmp', 'f38c7e80-cf78-43d1-92db-ebbc10f0088d'::uuid);
--   '(766210,125,10673,2,23,,,,,450007,"д. 23",80701000001,f38c7e80-cf78-43d1-92db-ebbc10f0088d,,,80401380000,,)'

 --       '23f6da51-e5a2-42a2-aa41-b6448ff7b690'|'f38c7e80-cf78-43d1-92db-ebbc10f0088d'|2|'2023-11-14'
    
