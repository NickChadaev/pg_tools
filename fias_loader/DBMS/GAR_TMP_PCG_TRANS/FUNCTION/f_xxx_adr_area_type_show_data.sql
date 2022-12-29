DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data (text, date, text[]);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data (text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data (
        p_schema_name  text  
)
    RETURNS SETOF gar_tmp.xxx_adr_area_type
    LANGUAGE plpgsql
 AS
  $$
      -- ----------------------------------------------------------------------------------------
    --  2021-12-01 Nick    
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_adr_area_type"
    -- ----------------------------------------------------------------------------------------
    --     p_schema_name text -- Имя схемы-источника._
    --     p_date      date   -- Дата на которую формируется выборка    
    -- ----------------------------------------------------------------------------------------
    --    2021-12-13 активная запись, со истёкшим сроком действия, но в таблице 
    --        с данными есть ссылки на "просроченый тип".
    --    Убран DISTINCT  отношение n <-> 1  (тип фиас тип adr_area).
    -- ----------------------------------------------------------------------------------------
    --   2022-02-18 Добавлен stop_list. Расширенный список ТИПОВ форимруется на эталонной базе,  
    --     типы попавшие в stop_list нужно вычистить в эталоне сразу-же. В функции типа SET они 
    --     будут вычищены на остальных базах.
    -- ----------------------------------------------------------------------------------------
    --  2022-11-11 Меняю USE CASE таблицы, теперь это буфер для последующего дополнения 
    --             адресного справочника.
    -- ---------------------------------------------------------------------------------
    --  2022-12-29 Убрана проверка -- (gar_fias.as_addr_obj_type.is_active) 
    --                     В ФИАС полно противоречий, эта проверка углубляет их.
    -- ----------------------------------------------------------------------------------
   DECLARE
    _exec   text;
    _select text = $_$
       WITH x (
               fias_id            
              ,fias_type_name     
              ,fias_type_shortname
              ,fias_row_key
      
      ) AS (
             SELECT
                 at.id            
                ,at.type_name     
                ,at.type_shortname
                ,gar_tmp_pcg_trans.f_xxx_replace_char (at.type_name) AS row_key
                
             FROM gar_fias.as_addr_obj_type at 
             WHERE (at.type_level::integer <= 7) -- (at.is_active) AND 2022-12-29               
             
                  AND ((gar_tmp_pcg_trans.f_xxx_replace_char (at.type_name) NOT IN
                        (SELECT fias_row_key FROM gar_fias.as_addr_obj_type_black_list
                               WHERE (object_kind = '0')
                         )
                       )
                     )              
             
               ORDER BY at.type_name, at.id                          
      ),
         z (
               fias_ids  
              ,fias_type_names
              ,fias_type_shortnames
              ,fias_row_key       
         ) 
            AS (
                  SELECT array_agg (x.fias_id)
				        ,array_agg (fias_type_name)
				        ,array_agg (fias_type_shortname)
				        ,x.fias_row_key  
                  FROM x GROUP BY x.fias_row_key      
               )
         , y (
                  fias_ids             
                 ,id_area_type        
                 ,fias_type_name      
                 ,nm_area_type        
                 ,fias_type_shortname
                 ,nm_area_type_short  
                 ,pr_lead        
                 ,fias_row_key        
                 ,is_twin                          
         ) AS (
                SELECT 
                       z.fias_ids  
                      ,nt.id_area_type
                      --
                      ,z.fias_type_names[1] 
                      ,nt.nm_area_type 
                      --
                      ,z.fias_type_shortnames[1]
                      ,nt.nm_area_type_short
                      ,nt.pr_lead
                      --
                      ,COALESCE (z.fias_row_key, gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_area_type))                      
                      ,FALSE          
                
                FROM z
                  FULL JOIN %I.adr_area_type nt 
                      ON (z.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_area_type)
                         ) AND (nt.dt_data_del IS NULL)
                         ORDER BY z.fias_type_names[1] 
             )
                INSERT INTO %I  (
                          fias_ids            
                         ,id_area_type        
                         ,fias_type_name      
                         ,nm_area_type        
                         ,fias_type_shortname 
                         ,nm_area_type_short  
                         ,pr_lead             
                         ,fias_row_key        
                         ,is_twin                             
                 )
                   SELECT y.fias_ids           
                         ,y.id_area_type       
                         ,y.fias_type_name     
                         ,y.nm_area_type       
                         ,y.fias_type_shortname
                         ,y.nm_area_type_short 
                         ,y.pr_lead            
                         ,y.fias_row_key       
                         ,y.is_twin  
                         
                FROM y;           
    $_$;
    
   BEGIN
    CREATE TEMP TABLE IF NOT EXISTS __adr_area_type_x (LIKE gar_tmp.xxx_adr_area_type)
       ON COMMIT DROP;
    DELETE FROM __adr_area_type_x;   
    --
    _exec := format (_select,  p_schema_name, '__adr_area_type_x');
    EXECUTE (_exec);
    --
    RETURN QUERY SELECT * FROM __adr_area_type_x ORDER BY id_area_type;
   
   END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data (text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data (text) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_adr_area_type"';
----------------------------------------------------------------------------------
-- USE CASE:
--  SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data ('gar_tmp') ORDER BY 4;
--  SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data ('unnsi');
