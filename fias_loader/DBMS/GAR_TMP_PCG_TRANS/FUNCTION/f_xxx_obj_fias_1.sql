DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 (text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 (
        p_schema_name  text  
)
    RETURNS SETOF gar_tmp.xxx_obj_fias
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    TMP_TABLE_NAME CONSTANT text = '__adr_area_fias';
    
    _select text = $_$
    
      WITH x (
                 id_obj_fias   
                ,obj_guid_fias 
                ,type_object 
		        ,tree_d
		        ,level_d
      ) AS (
             SELECT
                 aa.id_addr_obj   
                ,aa.fias_guid     
                ,1 AS type_object
		        ,aa.tree_d
		        ,aa.level_d
                
             FROM gar_tmp.xxx_adr_area aa WHERE (aa.obj_level = 1)  -- 2023-11-09 ..  Х ....тень была
		     ORDER BY tree_d
      )
                INSERT INTO %I
                       SELECT 
                              nt.id_street    AS id_obj        
                             ,x.id_obj_fias   AS id_obj_fias   
                             ,x.obj_guid_fias AS obj_guid      
                             ,x.type_object   AS type_object   
                             --
                             ,x.tree_d
                             ,x.level_d
                       FROM x
                         LEFT JOIN LATERAL 
                              ( SELECT z.id_street, z.nm_fias_guid FROM ONLY %I.adr_street z
                                   WHERE (z.id_data_etalon IS NULL) AND (z.dt_data_del IS NULL) 
                                            AND
                                         (z.nm_fias_guid = x.obj_guid_fias)
                                ORDER BY z.id_street
             
                              ) nt ON TRUE;                                
            $_$;
            
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-06 Nick    УЛИЦЫ
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_obj_fias"
    -- 2023-11-09 Отказ от разделения объектов по уровням ФИАС, .. ногу сломает.
    --   0 - адресные объекты, 1-  элементы дорожной структуры        
    -- --------------------------------------------------------------------------
    --     p_schema_name text -- Имя схемы-источника._
    -- --------------------------------------------------------------------------
    CREATE TEMP TABLE IF NOT EXISTS __adr_area_fias (LIKE gar_tmp.xxx_obj_fias)
        ON COMMIT DROP;
    TRUNCATE TABLE __adr_area_fias;
    --
    _exec := format (_select, TMP_TABLE_NAME, p_schema_name); -- p_date, 
    EXECUTE (_exec);
    --
    RETURN QUERY SELECT * FROM __adr_area_fias;
   
   END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 (text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 (text) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_obj_fias"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE 
--     SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 ('gar_tmp') -- 5611
--     INSERT INTO gar_tmp.xxx_obj_fias 
--           SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 ('unnsi'); 
--   SELECT * FROM gar_tmp.xxx_obj_fias; -- 6031
--   TRUNCATE TABLE gar_tmp.xxx_obj_fias;
-- ------------------------------------------------------------
-- SELECT gar_link.f_server_is ();
