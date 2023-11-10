DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_street_get (text, uuid);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_street_get (
               p_schema        text -- Имя схемы
              ,p_nm_fias_guid  uuid -- аргумент
	          ,OUT rr          gar_tmp.adr_street_t
)
    RETURNS gar_tmp.adr_street_t
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
                  SELECT   id_street
                          ,id_area
                          ,nm_street
                          ,id_street_type
                          ,nm_street_full
                          ,nm_fias_guid
                          ,dt_data_del
                          ,id_data_etalon
                          ,kd_kladr
                          ,vl_addr_latitude
                          ,vl_addr_longitude   
                          
                  FROM ONLY %I.adr_street
                        WHERE (nm_fias_guid = %L) 
                             AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-15/2022-02-21  Nick.
    --  2023-11-10 Дополнительный поиск в таблице "gar_fias.twin_addr_objects".    
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_nm_fias_guid);  
     EXECUTE _exec INTO rr;
     
     IF (rr.id_street IS NULL) 
       THEN
        --
        -- Хрен во всю морду, пробуем искать в таблице двойников.
        --
        _exec := format (  _select
                         , p_schema
                         , (SELECT fias_guid_new FROM gar_fias.twin_addr_objects
                            WHERE (fias_guid_old = p_nm_fias_guid)
                           ) 
         );  
        EXECUTE _exec INTO rr;
     END IF;     
     
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_street_get (text, uuid) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_street_get (text, uuid) 
IS 'Получить запись из таблицы адресов улиц. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_street_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_street_get ('gar_tmp', '58c40740-cac6-4c29-9f9b-6eac05b53717'::uuid);
--                         '(600002108,11357,Гаражная,38,"Гаражная ул.",7daa96c1-5e22-4f5a-a111-06cd36e229a9,,,,,)'
--
--       SELECT gar_tmp_pcg_trans.f_adr_street_get ('gar_tmp', '7daa96c1-5e22-4f5a-a111-06cd36e229a9'::uuid);
--                         '(600002108,11357,Гаражная,38,"Гаражная ул.",7daa96c1-5e22-4f5a-a111-06cd36e229a9,,,,,)'
    
