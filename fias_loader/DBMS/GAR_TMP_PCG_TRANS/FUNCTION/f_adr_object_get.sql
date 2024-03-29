DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_object_get (text, uuid);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_object_get (
               p_schema        text -- Имя схемы
              ,p_nm_fias_guid  uuid -- аргумент
	          ,OUT rr          gar_tmp.adr_objects_t
)
    RETURNS gar_tmp.adr_objects_t -- record
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
                  SELECT 
                        id_object         --  bigint                      
                       ,id_area           --  bigint                      
                       ,id_house          --  bigint                      
                       ,id_object_type    --  integer                     
                       ,id_street         --  bigint                      
                       ,nm_object         --  varchar(250)                
                       ,nm_object_full    --  varchar(500)                
                       ,nm_description    --  varchar(150)                
                       ,dt_data_del       --  timestamp without time zone 
                       ,id_data_etalon    --  bigint                      
                       ,id_metro_station  --  integer                     
                       ,id_autoroad       --  integer                     
                       ,nn_autoroad_km    --  numeric                     
                       ,nm_fias_guid      --  uuid                        
                       ,nm_zipcode        --  varchar(20)                 
                       ,kd_oktmo          --  varchar(11)                 
                       ,kd_okato          --  varchar(11)                 
                       ,vl_addr_latitude  --  numeric                     
                       ,vl_addr_longitude --  numeric                     
    
                  FROM ONLY %I.adr_objects
                  
                        WHERE (nm_fias_guid = %L) 
                              AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-17 Nick  Дополнение адресных объектов. Поиск по UUID
    --  2022-02-21 Опция ONLY
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_nm_fias_guid);  
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_objects_get (text, uuid) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_object_get (text, uuid) 
IS 'Получить запись из таблицы адресных объектов. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_objects_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_object_get  ('unsi'::text, 'bb1060ca-8070-4dba-b86b-207e6521734b'::uuid);
    
