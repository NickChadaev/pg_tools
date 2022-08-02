DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_get (text, integer, bigint, integer, varchar(120));
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_area_get (
               p_schema         text         -- Имя схемы
              ,p_id_country     integer      -- NOT NULL
              ,p_id_area_parent bigint       --     NULL
              ,p_id_area_type   integer      --     NULL
              ,p_nm_area        varchar(120) -- NOT NULL
              --
	          ,OUT rr           gar_tmp.adr_area_t 
)

    RETURNS gar_tmp.adr_area_t
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
                  SELECT 
                           id_area           --  bigint                      -- NOT NULL
                          ,id_country        --  integer                     -- NOT NULL
                          ,nm_area           --  varchar(120)                -- NOT NULL
                          ,nm_area_full      --  varchar(4000)               -- NOT NULL
                          ,id_area_type      --  integer                     --   NULL
                          ,id_area_parent    --  bigint                      --   NULL
                          ,kd_timezone       --  integer                     --   NULL
                          ,pr_detailed       --  smallint                    -- NOT NULL 
                          ,kd_oktmo          --  varchar(11)                 --   NULL
                          ,nm_fias_guid      --  uuid                        --   NULL
                          ,dt_data_del       --  timestamp without time zone --   NULL
                          ,id_data_etalon    --  bigint                      --   NULL
                          ,kd_okato          --  varchar(11)                 --   NULL
                          ,nm_zipcode        --  varchar(20)                 --   NULL
                          ,kd_kladr          --  varchar(15)                 --   NULL
                          ,vl_addr_latitude  --  numeric                     --   NULL
                          ,vl_addr_longitude --  numeric                     --   NULL
    
                  FROM ONLY %I.adr_area
                  
                  WHERE (id_country = %L) AND (id_area_parent IS NOT DISTINCT FROM %L) AND 
                        (id_area_type IS NOT DISTINCT FROM %L) AND (upper(nm_area::text) = upper(%L)) AND
                        (id_data_etalon IS NULL) AND (dt_data_del IS NULL);  
              $_$;

           
   BEGIN
    -- -----------------------------------------------------------------------------------
    --  2021-12-10/2022-01-28/2022-02-21  Nick.  
    --              Дополнение адресных георегионов. Поиск по уникальным параметрам
    -- -----------------------------------------------------------------------------------
     _exec := format (_select, 
                          p_schema, p_id_country, p_id_area_parent, p_id_area_type, p_nm_area
     );  
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_area_get (text, integer, bigint, integer, varchar(120)) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_area_get (text, integer, bigint, integer, varchar(120)) 
IS 'Получить запись из таблицы адресных георегионов. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_area_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_area_get ('unnsi', 185, 77, 40, 'Угличский');
    
--           SELECT nm_fias_guid FROM unnsi.adr_area 
--                               WHERE ((id_country = 185) AND (id_area_parent IS NOT DISTINCT FROM 77) AND 
--                                      (id_area_type IS NOT DISTINCT FROM 40) AND (upper(nm_area::text) = upper('Угличский')) AND
--                                      (id_data_etalon IS NULL) AND (dt_data_del IS NULL)  
--                                     );
