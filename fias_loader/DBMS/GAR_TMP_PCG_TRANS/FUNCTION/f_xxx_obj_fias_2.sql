DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 (text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 (
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
                 --
                ,id_area
                ,tree_d
                ,level_d
      ) AS (
             SELECT
                 ah.id_house 
                ,ah.fias_guid     
                ,2 AS type_object
                --
                ,aa.id_addr_obj
		        ,aa.tree_d
		        ,aa.level_d
                
             FROM gar_tmp.xxx_adr_house ah 
                INNER JOIN gar_tmp.xxx_adr_area aa 
                           ON (aa.id_addr_obj = ah.id_addr_parent) -- INNER  2022-03-02
		        ORDER BY aa.tree_d    
      )
            INSERT INTO %I
               SELECT 
                      nh.id_house     AS id_obj        
                     ,x.id_obj_fias   AS id_obj_fias   
                     ,x.obj_guid_fias AS obj_guid      
                     ,x.type_object   AS type_object   
                     --
                     ,x.tree_d
		             ,x.level_d
               FROM x
                      LEFT JOIN LATERAL 
                           ( SELECT z.id_house, z.nm_fias_guid FROM ONLY %I.adr_house z
                                WHERE (z.id_data_etalon IS NULL) AND (z.dt_data_del IS NULL) 
                                         AND
                                      (z.nm_fias_guid = x.obj_guid_fias)
                             ORDER BY z.id_house
                   
                           ) nh ON TRUE;                    
            $_$;
            
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-09 Nick  ДОМА
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_obj_fias"
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
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 (text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 (text) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_obj_fias"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE 
-- --     SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 ('unsi') -- 96167
--  SELECT * FROM gar_tmp.xxx_obj_fias WHERE (TYPE_OBJECT = 2)  ORDER BY 1; -- LIMIT 10;
--  ALTER TABLE gar_tmp.xxx_obj_fias ALTER COLUMN tree_d DROP NOT NULL;
--  ALTER TABLE gar_tmp.xxx_obj_fias ALTER COLUMN level_d DROP NOT NULL;
 
--  INSERT INTO gar_tmp.xxx_obj_fias 
--        SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 ('gar_tmp') -- 'unnsi' 2022-01-28
--  ON CONFLICT (obj_guid) DO NOTHING;  + 104
-- -------------------------------------------------------------------------------
-- count	type_object
--   420	0
-- 96167	2
--  5611	1


