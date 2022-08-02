DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_street_type_show_data (text, date);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_street_type_show_data (text, date, text[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_show_data (
        p_schema_name  text  
       ,p_date         date   = current_date
       ,p_stop_list    text[] = NULL
)
    RETURNS SETOF gar_tmp.xxx_adr_street_type
    LANGUAGE plpgsql
 AS
  $$
    -- --------------------------------------------------------------------------
    --  2021-12-02 Nick 
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_street_type"
    --     + stop_list. Расширенный список ТИПОВ формируется на эталонной базе, то 
    --       типы попавшие в stop_list нужно вычистить сразу-же. В функции типа SET они 
    --       будут вычищены на остальных базах.
    -- --------------------------------------------------------------------------------------
    --     p_schema_name text   -- Имя схемы-источника._
    --     p_date        date   -- Дата на которую формируется выборка    
    --     p_stop_list   text[] -- список исключаемых типов
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
                
             FROM gar_fias.as_addr_obj_type at WHERE (at.is_active) -- AND at.end_date > %L) 
                 AND (at.type_level IN ('7','8'))                          -- 2021-12-14 Nick
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
          INSERT INTO __adr_street_type ( 
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
          
          FROM x WHERE ((NOT (x.fias_row_key = ANY (%L))) AND %L IS NOT NULL) OR (%L IS NULL);           ;
    $_$;
    --    
    _del_something text = $_$
          DELETE FROM %I.adr_street_type nt
                WHERE (gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_street_type) = ANY (%L));
    $_$;    
    
    BEGIN
      CREATE TEMP TABLE __adr_street_type (LIKE gar_tmp.xxx_adr_street_type)
        ON COMMIT DROP;
      --
      _exec := format (_select, p_date, p_schema_name, p_stop_list, p_stop_list, p_stop_list);-- p_date, 
      EXECUTE (_exec);
      --
      IF (p_stop_list IS NOT NULL)
        THEN
           _exec := format (_del_something, p_schema_name, p_stop_list);
           EXECUTE _exec;
      END IF;   
      
      RETURN QUERY SELECT * FROM __adr_street_type ORDER BY id_street_type;     
       
    END;
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_show_data (text, date, text[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_show_data (text, date, text[]) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_street_type"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE 
--           SELECT * FROM gar_tmp_pcg_trans.f_xxx_street_type_show_data ('unnsi'
--                 , p_stop_list := ARRAY ['юрты','усадьба']
-- ); -- 
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_street_type_show_data ('unnsi'); -- 
--   SELECT * FROM unsi.adr_street_type WHERE (id_street_type > 1000);
--   SELECT * FROM unnsi.adr_street_type WHERE (id_street_type > 1000);
--
--   delete FROM unsi.adr_street_type WHERE (id_street_type > 1000);
--   DELETE FROM unnsi.adr_street_type WHERE (id_street_type > 1000);
