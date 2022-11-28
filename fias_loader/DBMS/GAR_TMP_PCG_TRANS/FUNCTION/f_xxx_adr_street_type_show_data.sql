DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_street_type_show_data (text, date, text[]);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_street_type_show_data (text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_show_data (
        p_schema_name  text  
)
    RETURNS SETOF gar_tmp.xxx_adr_street_type
    LANGUAGE plpgsql
 AS
  $$
    -- --------------------------------------------------------------------------
    --  2021-12-02 Nick 
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_street_type"
    -- --------------------------------------------------------------------------
    --   2022-11-11 Меняю USE CASE таблицы, теперь это буфер для последующего дополнения 
    --             адресного справочника.    
    -- --------------------------------------------------------------------------------------
    --     p_schema_name text   -- Имя схемы-источника._
    -- --------------------------------------------------------------------------------------    

    DECLARE
    _exec   text;
    _select text = $_$
       WITH z (   
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
                
             FROM gar_fias.as_addr_obj_type at WHERE (at.is_active)   
                 AND (at.type_level::integer = 8)   
                 AND ((gar_tmp_pcg_trans.f_xxx_replace_char (at.type_name) NOT IN
                        (SELECT fias_row_key FROM gar_fias.as_addr_obj_type_black_list
                               WHERE (object_kind = '1')
                        )
                      )
                     )                       
               ORDER BY at.type_name, at.id 
      )
      , y (
               fias_ids            
              ,fias_type_names     
              ,fias_type_shortnames
              ,fias_row_key
          ) AS (
                 SELECT array_agg (z.fias_id)            
                       ,array_agg (z.fias_type_name)     
                       ,array_agg (z.fias_type_shortname)
                       ,z.fias_row_key
                       
                 FROM z GROUP BY z.fias_row_key
            )
       , x (
                fias_ids              
               ,id_street_type       
               ,fias_type_name       
               ,nm_street_type       
               ,fias_type_shortname  
               ,nm_street_type_short 
               ,fias_row_key         
               ,is_twin               
               
         ) AS (
                SELECT 
                 y.fias_ids    
                ,st.id_street_type  
                ,y.fias_type_names[1]  
                ,st.nm_street_type
                ,y.fias_type_shortnames[1]
                ,st.nm_street_type_short
                ,COALESCE (y.fias_row_key, gar_tmp_pcg_trans.f_xxx_replace_char (st.nm_street_type))                      
                ,FALSE
                
          FROM y
          
          FULL JOIN %I.adr_street_type st  
                  ON (y.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char (st.nm_street_type))
                           AND
                         (st.dt_data_del IS NULL) ORDER BY y.fias_row_key
         )
          INSERT INTO %I ( 
                                            fias_ids             
                                           ,id_street_type       
                                           ,fias_type_name       
                                           ,nm_street_type       
                                           ,fias_type_shortname  
                                           ,nm_street_type_short 
                                           ,fias_row_key         
                                           ,is_twin                 
          )
          
          SELECT      x.fias_ids             
                     ,x.id_street_type       
                     ,x.fias_type_name       
                     ,x.nm_street_type       
                     ,x.fias_type_shortname  
                     ,x.nm_street_type_short 
                     ,x.fias_row_key         
                     ,x.is_twin                   
          
          FROM x ;
    $_$;
    --    
    BEGIN
      CREATE TEMP TABLE IF NOT EXISTS __adr_street_type_x (LIKE gar_tmp.xxx_adr_street_type)
        ON COMMIT DROP;
      --
      DELETE FROM __adr_street_type_x;
      _exec := format (_select, p_schema_name, '__adr_street_type_x'); 
      EXECUTE (_exec);
      --
      RETURN QUERY SELECT * FROM __adr_street_type_x ORDER BY id_street_type;     
       
    END;
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_show_data (text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_show_data (text) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_street_type"';
----------------------------------------------------------------------------------
-- USE CASE:
--
--  SELECT * FROM gar_tmp_pcg_trans.f_xxx_street_type_show_data ('gar_tmp'); -- 
--  SELECT * FROM gar_tmp_pcg_trans.f_xxx_street_type_show_data ('unnsi'); -- 
