DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_get (text, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_area_get (
               p_schema   text   -- Имя схемы
              ,p_id_area  bigint -- аргумент
	          ,OUT rr     gar_tmp.adr_area_t 
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
    
                  FROM ONLY %I.adr_area WHERE (id_area = %L);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-10 Nick  Дополнение адресных георегионов. Поиск по ID
    --  2022-02-21 Опция ONLY.
    --  2022-06-15 Выбираю запись любого типа, т.е актуальную, удалённую.
    -- --------------------------------------------------------------------------
    
     _exec := format (_select, p_schema, p_id_area);  
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_area_get (text, bigint) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_area_get (text, bigint) 
  IS 'Получить запись из таблицы адресных георегионов. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_area_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT * FROM gar_tmp_pcg_trans.f_adr_area_get ('unnsi', 271088);
--       SELECT * FROM gar_tmp_pcg_trans.f_adr_area_get ('unnsi', 199007);
    
