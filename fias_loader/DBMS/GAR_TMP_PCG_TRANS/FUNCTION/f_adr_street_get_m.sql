DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_street_get (text, bigint, varchar(255), integer);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_street_get (
               p_schema          text -- Имя схемы
              ,p_id_area         bigint
              ,p_nm_street       varchar(255) 
              ,p_id_street_type  integer
	          ,OUT rr            gar_tmp.adr_street_t 
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
                        WHERE (id_area = %L) AND 
                              (upper(nm_street::text) = upper(%L)) AND 
                              (id_street_type IS NOT DISTINCT FROM %L) AND 
                              (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --     2021-12-15/2022-01-28/2022-02-21   Nick.
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_id_area, p_nm_street, p_id_street_type); 
     
     EXECUTE _exec INTO rr;

     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_street_get (text, bigint, varchar(255), integer) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_street_get (text, bigint, varchar(255), integer) 
IS 'Получить запись из таблицы адресов улиц. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_street_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_street_get ('unnsi', 78, 'Речная', 38);
--       SELECT gar_tmp_pcg_trans.f_adr_street_get ('unnsi', 2311, 'Молодежный ГСК', 34);
    
--         SELECT nm_fias_guid FROM unnsi.adr_street 
--                               WHERE ((id_area = 78) AND 
--                                      (upper(nm_street::text) = upper('Речная')) AND 
--                                      (id_street_type IS NOT DISTINCT FROM 38) AND 
--                                      (id_data_etalon IS NULL) AND (dt_data_del IS NULL)
--                                     ); -- dbe358c4-4212-4103-9cea-d7c730d6da9a
