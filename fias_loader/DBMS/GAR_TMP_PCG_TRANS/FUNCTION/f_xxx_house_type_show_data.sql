DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_house_type_show_data (text, date);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_house_type_show_data (text, date, text[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_show_data (
          p_schema_name  text  
         ,p_date         date   = current_date
         ,p_stop_list    text[] = NULL
)
    RETURNS SETOF gar_tmp.xxx_adr_house_type
    LANGUAGE plpgsql
 AS
  $$
    -- --------------------------------------------------------------------------------------
    --  2021-12-01/2021-12-14 Nick 
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_adr_house_type"
    --  2022-02-18 добавлен столбец kd_house_type_lvl - 'Уровень типа номера (1-основной)'
    --     + stop_list. Расширенный список ТИПОВ форимруется на эталонной базе, то 
    --       типы попавшие в stop_list нужно вычистить сразу-же. В функции типа SET они 
    --       будут вычищены на остальных базах.
    -- --------------------------------------------------------------------------------------
    --     p_schema_name text -- Имя схемы-источника._
    --     p_date        date -- Дата на которую формируется выборка       
    -- --------------------------------------------------------------------------------------
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
                      ht.house_type_id            
                     ,ht.type_name     
                     ,ht.type_shortname
                     ,gar_tmp_pcg_trans.f_xxx_replace_char (ht.type_name) AS row_key
                     
                  FROM gar_fias.as_house_type ht WHERE (ht.is_active) -- AND ht.end_date > %L) 
                    ORDER BY ht.type_name, ht.house_type_id           --  2021-12-14 Nick
           ),
              z (
                    fias_ids            
                   ,fias_type_names     
                   ,fias_type_shortnames
                   ,fias_row_key       
              ) 
                 AS (
                       SELECT  array_agg (x.fias_id)
                              ,array_agg (x.fias_type_name)     
                              ,array_agg (x.fias_type_shortname)
                              ,x.fias_row_key  
                       FROM x 
                               GROUP BY x.fias_row_key    
                    )
               ,y  (
                      fias_ids             
                     ,id_house_type       
                     ,fias_type_name      
                     ,nm_house_type       
                     ,fias_type_shortname 
                     ,nm_house_type_short 
                     ,kd_house_type_lvl
                     ,fias_row_key        
                     ,is_twin                           
                   )
               
                   AS (     
                        SELECT 
                            z.fias_ids  
                           ,nt.id_house_type
                           --
                           ,z.fias_type_names[1] 
                           ,nt.nm_house_type 
                           --
                           ,z.fias_type_shortnames[1]
                           ,nt.nm_house_type_short
                           ,nt.kd_house_type_lvl    
                           --
                           ,COALESCE (z.fias_row_key, gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_house_type))
                           ,FALSE          
                     
                        FROM z
                          FULL JOIN %I.adr_house_type nt
                              ON (z.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_house_type))
                                   AND
                                 (nt.dt_data_del IS NULL) ORDER BY z.fias_type_names[1]
                    ) 
                      INSERT INTO __adr_house_type ( 
                                                     fias_ids           
                                                    ,id_house_type      
                                                    ,fias_type_name     
                                                    ,nm_house_type      
                                                    ,fias_type_shortname
                                                    ,nm_house_type_short
                                                    ,kd_house_type_lvl  
                                                    ,fias_row_key       
                                                    ,is_twin            
                      )
                      SELECT  
                             y.fias_ids             
                            ,y.id_house_type       
                            ,y.fias_type_name      
                            ,y.nm_house_type       
                            ,y.fias_type_shortname 
                            ,y.nm_house_type_short 
                            ,y.kd_house_type_lvl
                            ,y.fias_row_key        
                            ,y.is_twin           
                            
                      FROM y WHERE ((NOT (y.fias_row_key = ANY (%L))) AND %L IS NOT NULL) OR (%L IS NULL);  
       $_$;

       _del_something text = $_$
                   DELETE FROM %I.adr_house_type nt
                              WHERE (gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_house_type) = ANY (%L));
       $_$;
       
    BEGIN
      CREATE TEMP TABLE __adr_house_type (LIKE gar_tmp.xxx_adr_house_type)
        ON COMMIT DROP;
      --
      _exec := format (_select, p_date, p_schema_name, p_stop_list, p_stop_list, p_stop_list);
      EXECUTE (_exec);

      IF (p_stop_list IS NOT NULL)
        THEN
             _exec := format (_del_something, p_schema_name, p_stop_list);
             EXECUTE _exec;
      END IF;
      --
      RETURN QUERY SELECT * FROM __adr_house_type ORDER BY id_house_type;                      
    END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_show_data (text, date, text[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_show_data (text, date, text[]) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_house_type"';
----------------------------------------------------------------------------------
--       STOP_LIST CONSTANT text [] := ARRAY ['гараж','шахта']::text[];  
-- USE CASE:
--   EXPLAIN ANALyZE 
--     SELECT * FROM gar_tmp_pcg_trans.f_xxx_house_type_show_data ('unnsi', p_stop_list := ARRAY ['гараж','шахта']); --8
--     SELECT * FROM gar_tmp_pcg_trans.f_xxx_house_type_show_data ('unnsi'); 
--     SELECT * FROM unnsi.adr_house_type ORDER BY 1;
-- CALL gar_tmp_pcg_trans.p_gar_fias_crt_idx ();
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_house_type_show_data (); 
-- SELECT count (1) FROM gar_tmp_pcg_trans.as_addr_obj; --7345  --- 1312 ?
-- SELECT count (1) FROM gar_tmp_pcg_trans.as_addr_obj a WHERE (a.is_actual AND a.is_active); -- 6093  -- 60 ??
--
-- SELECT count (1) FROM gar_tmp_pcg_trans.as_addr_obj a WHERE (a.is_actual AND a.is_active)  -- 6093 ??
-- AND (a.end_date > p_date) 
--                         AND (a.start_date <= p_date);
-- ------------------------------------------------------------
-- ALTER TABLE gar_tmp.xxx_adr_area ADD COLUMN addr_obj_type_id bigint;
-- COMMENT ON COLUMN gar_tmp.xxx_adr_area.addr_obj_type_id IS
-- 'ID типа объекта';
