DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 (text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 (
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
                ,0 AS type_object
		        ,aa.tree_d
		        ,aa.level_d
                
             FROM gar_tmp.xxx_adr_area aa 
                    WHERE (aa.obj_level < 8)  
		        ORDER BY tree_d
      )
                INSERT INTO %I
                       SELECT 
                              nt.id_area      AS id_obj        
                             ,x.id_obj_fias   AS id_obj_fias   
                             ,x.obj_guid_fias AS obj_guid      
                             ,x.type_object   AS type_object   
                             --
                             ,x.tree_d
                             ,x.level_d
                       FROM x
                         LEFT JOIN LATERAL 
                              ( SELECT z.id_area, z.nm_fias_guid FROM ONLY %I.adr_area z
                                   WHERE (z.id_data_etalon IS NULL) AND (z.dt_data_del IS NULL) 
                                            AND
                                         (z.nm_fias_guid = x.obj_guid_fias)
                                ORDER BY z.id_area 
             
                              ) nt ON TRUE;                                 
            $_$;
            
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-06 Nick  АДРЕСНЫЕ ОБЪЕКТЫ БЕЗ УЛИЦ
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_obj_fias"
    -- --------------------------------------------------------------------------
    --     p_schema_name text -- Имя схемы-источника._
    -- --------------------------------------------------------------------------
    -- 2022-12-13 Условие выбора (aa.obj_level < 8)
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
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 (text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 (text) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_obj_fias"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE 
--      SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 ('unnsi') 
--              WHERE (obj_guid = 'ab4ac1b4-165d-4bab-be36-a974c4241902');
--     INSERT INTO gar_tmp.xxx_obj_fias 
--        SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 ('unsi'); 
--   SELECT * FROM gar_tmp.xxx_obj_fias;
-- CREATE INDEX IF NOT EXISTS _xxx_adr_area_ie3 
--     ON gar_tmp.xxx_adr_area USING btree (obj_level);
-- -------------------------------------------------------------------------------

