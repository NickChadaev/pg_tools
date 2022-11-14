DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_house_type_show_data (text, date, text[]);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_house_type_show_data (text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_show_data (
          p_schema_name  text  
)
    RETURNS SETOF gar_tmp.xxx_adr_house_type
    LANGUAGE plpgsql
 AS
  $$
    -- --------------------------------------------------------------------------------------
    --  2021-12-01/2021-12-14 Nick 
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_adr_house_type"
    -- --------------------------------------------------------------------------------------
    --     p_schema_name text -- Имя схемы-источника._
    -- --------------------------------------------------------------------------------------
    --  2022-02-18 добавлен столбец kd_house_type_lvl - 'Уровень типа номера (1-основной)'
    --     + stop_list. Расширенный список ТИПОВ формируется на эталонной базе, то 
    --       типы попавшие в stop_list нужно вычистить сразу-же. В функции типа SET они 
    --       будут вычищены в основной базе.
    --  2022-09-26 
    --       Тип дома всегда принимается в работу, даже если он неактуальный и просроченный
    -- --------------------------------------------------------------------------------------
    --  2022-11-11 Меняю USE CASE таблицы, теперь это буфер для последующего дополнения 
    --             адресного справочника.
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
                     
                  FROM gar_fias.as_house_type ht 
                     WHERE ((gar_tmp_pcg_trans.f_xxx_replace_char (ht.type_name) NOT IN
                                 (SELECT fias_row_key FROM gar_fias.as_house_type_black_list))
                           ) 
                    ORDER BY ht.type_name, ht.house_type_id          
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
                            
                      FROM y ;  
       $_$;

    BEGIN
      CREATE TEMP TABLE __adr_house_type (LIKE gar_tmp.xxx_adr_house_type)
        ON COMMIT DROP;
      --
      _exec := format (_select, p_schema_name);
      EXECUTE (_exec);
      --
      RETURN QUERY SELECT * FROM __adr_house_type ORDER BY id_house_type;                      
    END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_show_data (text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_show_data (text) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_house_type"';
----------------------------------------------------------------------------------
-- USE CASE:
--           SELECT * FROM gar_tmp_pcg_trans.f_xxx_house_type_show_data ('gar_tmp'); 
--           SELECT * FROM gar_tmp_pcg_trans.f_xxx_house_type_show_data ('unnsi'); 
--
