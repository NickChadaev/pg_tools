/*	Входные параметры
			    nso - ИД НСО
			    priznak - Признак:  true  - вывести только ключевые колонки НСО
				    	        false - полный заголовк НСО ( значение по умолчанию)
*/

DROP FUNCTION IF EXISTS nso_structure.nso_f_column_head_nso_s ( public.id_t, public.t_boolean );
CREATE OR REPLACE FUNCTION nso_structure.nso_f_column_head_nso_s ( p_nso_id public.id_t, p_priznak public.t_boolean = FALSE )
RETURNS TABLE ( 
                col_id              public.id_t        -- ID колонки
               ,parent_col_id       public.id_t        -- ID родительской колонки
               ,number_col          public.small_t     -- Номер колонки
               --
               ,attr_id             public.id_t        -- ID атрибута
               ,attr_code           public.t_str60     -- Код атрибута                               
               ,attr_name           public.t_str250    -- Наименование атрибута    
               --   
               ,attr_type_id        public.id_t        -- Код типа атрибута 
               ,attr_type_scode     public.t_code1     -- Краткий код типа атрибута
               ,attr_type_code      public.t_str60     -- Код типа атрибута            
               ,attr_type_name      public.t_str250    -- Название типа атрибута  
               -- 
               ,mandatory           public.t_boolean   -- Обязательность заполнения колонки
               --
               ,key_id              public.id_t        -- ID ключа         
               ,on_off              public.t_boolean   -- Признак активности ключа   
               ,key_col_num         public.small_t     -- Номер ключевой колонки 
               -- 
               ,key_type_id         public.id_t         -- ID типа ключа  
               ,key_type_scode      public.t_code1      -- Краткий код типа ключа               
               ,key_type_code       public.t_str60      -- Код типа ключа
               ,key_type_name       public.t_str250     -- Название типа ключа
               --
               ,level_h             public.small_t      -- Уровень
 )
 SET SEARCH_PATH=nso, nso_structure, com, public, pg_catalog
AS
 $$
     -- ===========================================================================
     -- Author:		ANNA
     -- Create date: 2013-10-17 (полностью переделанная NSO_F_COLUMN_HEAD_ListAttr)
     -- Description:	Выводит список атрибутов НСО
     --              2014-07-31 Перенос на версию 3.0 Nick
     -- ---------------------------------------------------------------------------
     --  2015-03-14  Nick Переход на домен EBD.
     --  2015-04-21  краткие коды
     --  2015-05-30  Перенос nso_domain_column в COM
     --  2016-05-12  Nick функция-перегрузка.   
     --  2019-07-18  Nick Новое ядро
     -- ===========================================================================
 
  DECLARE
    _nso_id  public.id_t;
    
  BEGIN
     _nso_id := p_nso_id;

     IF ( p_priznak )
   	THEN 
   	 RETURN QUERY
                      WITH RECURSIVE x (
                                 nso_id
                                ,col_id
                                ,parent_col_id
                                ,number_col 
                                 --
                                ,attr_id
                                ,attr_code
                                ,attr_name
                                --
                                ,attr_type_id
                                ,attr_type_scode
                                ,attr_type_code 
                                ,attr_type_name  
                                --
                                ,mandatory
                                ,tree_d
                                ,level_d
                                ,cicle_d
                        ) AS (
                              SELECT h.nso_id
                                    ,h.col_id  
                                    ,h.parent_col_id
                                    ,h.number_col
                                     --
                                    ,d.attr_id
                                    ,h.col_code   -- d.attr_code
                                    ,h.col_name   -- d.attr_name
                                    -- 
                                    ,c.codif_id
                                    ,c.small_code::public.t_code1
                                    ,c.codif_code::public.t_str60 
                                    ,c.codif_name::public.t_str250  
                                    -- 
                                    ,h.mandatory 
                                    --
                                    ,CAST (ARRAY [h.col_id] AS public.t_arr_id) AS tree_d
                                    ,0::public.small_t
                                    ,FALSE
                                   FROM ONLY nso.nso_column_head h, ONLY com.nso_domain_column d, ONLY com.obj_codifier c 
                                 WHERE ( d.attr_id      = h.attr_id ) 
                                   AND ( d.attr_type_id = c.codif_id ) 
                                   AND ( h.nso_id       = _nso_id )   
                                   AND ( h.parent_col_id IS NULL )
                   
                                 UNION ALL
                   
                                 SELECT h.nso_id
                                       ,h.col_id  
                                       ,h.parent_col_id
                                       ,h.number_col
                                       --
                                       ,d.attr_id
                                       ,h.col_code   -- d.attr_code
                                       ,h.col_name  -- d.attr_name
                                       -- 
                                       ,c.codif_id
                                       ,c.small_code::public.t_code1
                                       ,c.codif_code::public.t_str60
                                       ,c.codif_name::public.t_str250 
                                       -- 
                                       ,h.mandatory 
                                       --
                                       ,CAST ((x.tree_d::int8[] || h.col_id::int8) AS t_arr_id )
                                       ,(x.level_d + 1)::public.small_t
                                       ,h.col_id = ANY ( x.tree_d )
                                      FROM ONLY nso.nso_column_head h, ONLY com.nso_domain_column d, ONLY com.obj_codifier c, x 
                                 WHERE    ( d.attr_id      = h.attr_id ) 
                                      AND ( d.attr_type_id = c.codif_id ) 
                                      AND ( x.col_id    = h.parent_col_id )
                                      AND ( x.nso_id    = h.nso_id )
                                      AND ( NOT x.cicle_d )  
                             ),
                             y (
                                 key_id
                                 --
                                ,nso_id
                                ,on_off
                                ,col_id
                                ,key_col_num 
                                --
                                ,key_type_id
                                ,key_type_scode
                                ,key_type_code
                                ,key_type_name
                               )      
                                AS (
                                     SELECT k.key_id
                                           ,k.nso_id
                                           ,k.on_off 
                                           ,a.col_id     AS col_id
                                           ,a.column_nm  AS key_col_num
                                           ,c.codif_id   AS key_type_id
                                           ,c.small_code AS key_type_scode
                                           ,c.codif_code AS key_type_code
                                           ,c.codif_name AS key_type_name
                                      FROM ONLY nso.nso_key k, ONLY nso.nso_key_attr a, ONLY com.obj_codifier c 
                                            WHERE ( k.key_id   = a.key_id ) 
                                              AND ( c.codif_id = k.key_type_id ) 
                                              AND ( k.nso_id   = _nso_id )
                                   )
                                         SELECT
                                             x.col_id::public.id_t   -- ID колонки                                                         
                                            ,x.parent_col_id         -- ID родительской колонки    
                                            ,x.number_col            -- Номер колонки                                                 
                                            --
                                            ,x.attr_id::public.id_t  -- ID атрибута                                                       
                                            ,x.attr_code             -- Код атрибута                                                   
                                            ,x.attr_name             -- Наименование атрибута     
                                            --                        
                                            ,x.attr_type_id::public.id_t -- Код типа атрибута    
                                            ,x.attr_type_scode           -- Краткий код типа атрибута                                      
                                            ,x.attr_type_code            -- Код типа атрибута                                          
                                            ,x.attr_type_name            -- Название типа атрибута                                
                                             --
                                            ,x.mandatory  -- Обязательность заполнения колонки     
                                            --                              
                                            ,y.key_id::public.id_t -- ID ключа                                                             
                                            ,y.on_off              -- Признак активности ключа                            
                                            ,y.key_col_num         -- Номер ключевой колонки   
                                            --                             
                                            ,y.key_type_id::public.id_t -- ID типа ключа    
                                            ,y.key_type_scode           -- Краткий код типа ключа                                            
                                            ,y.key_type_code            -- Код типа ключа                                                
                                            ,y.key_type_name            -- Название типа ключа
                                            --
                                            ,x.level_d        -- Уровень        
                                          FROM x 
                                               LEFT OUTER JOIN y ON ( x.nso_id = y.nso_id ) AND ( y.col_id = x.col_id )
                                                 WHERE ( y.key_id IS NOT  NULL ) ORDER BY x.level_d, x.parent_col_id, x.number_col ;
     ELSE
   	RETURN QUERY
           WITH RECURSIVE x (
                          nso_id
                         ,col_id
                         ,parent_col_id
                         ,number_col 
                          --
                         ,attr_id
                         ,attr_code
                         ,attr_name
                         --
                         ,attr_type_id
                         ,attr_type_scode
                         ,attr_type_code 
                         ,attr_type_name 
                         --
                         ,mandatory
                         ,tree_d
                         ,level_d
                         ,cicle_d
           ) AS (
                   SELECT h.nso_id
                         ,h.col_id  
                         ,h.parent_col_id
                         ,h.number_col
                          --
                         ,d.attr_id
                         ,h.col_code   -- d.attr_code
                         ,h.col_name  -- d.attr_name
                         -- 
                         ,c.codif_id
                         ,c.small_code::public.t_code1
                         ,c.codif_code::public.t_str60 
                         ,c.codif_name::public.t_str250  
                         -- 
                         ,h.mandatory 
                         ,CAST (ARRAY [h.col_id] AS public.t_arr_id) AS tree_d
                         ,0::public.small_t
                         ,FALSE
                        FROM ONLY nso.nso_object n, ONLY nso.nso_column_head h, ONLY com.nso_domain_column d, ONLY com.obj_codifier c 
                      WHERE ( n.nso_id  = h.nso_id )
                        AND ( d.attr_id = h.attr_id ) 
                        AND ( h.parent_col_id IS NULL )
                        AND ( d.attr_type_id     = c.codif_id ) 
                        AND ( n.nso_id = _nso_id ) -- Nick 2016-05-13  
        
                    UNION ALL
        
                          SELECT h.nso_id
                                ,h.col_id  
                                ,h.parent_col_id
                                ,h.number_col
                                --
                                ,d.attr_id
                                ,h.col_code   -- d.attr_code
                                ,h.col_name   -- d.attr_name
                                -- 
                                ,c.codif_id
                                ,c.small_code::public.t_code1
                                ,c.codif_code::public.t_str60
                                ,c.codif_name::public.t_str250 
                                -- 
                                ,h.mandatory 
                                ,CAST ( (x.tree_d::int8[] || h.col_id::int8) AS public.t_arr_id )
                                ,(x.level_d + 1)::public.small_t
                                ,h.col_id = ANY ( x.tree_d )
                               FROM ONLY nso.nso_column_head h, ONLY com.nso_domain_column d, ONLY com.obj_codifier c, x 
                          WHERE    ( d.attr_id      = h.attr_id ) 
                               AND ( d.attr_type_id = c.codif_id ) 
                               AND ( x.col_id    = h.parent_col_id )
                               AND ( x.nso_id    = h.nso_id )
                               AND ( NOT x.cicle_d )  
                ),
                      y (
                          key_id
                         ,nso_id
                         ,on_off
                         ,col_id
                         ,key_col_num  
                         ,key_type_id
                         ,key_type_scode
                         ,key_type_code
                         ,key_type_name
                        )      
                         AS (
                              SELECT k.key_id
                                    ,k.nso_id
                                    ,k.on_off 
                                    ,a.col_id     AS col_id
                                    ,a.column_nm  AS key_col_num
                                    ,c.codif_id   AS key_type_id
                                    ,c.small_code AS key_type_scode
                                    ,c.codif_code AS key_type_code
                                    ,c.codif_name AS key_type_name
                               FROM ONLY nso.nso_key k, ONLY nso.nso_key_attr a, ONLY com.obj_codifier c 
                                     WHERE ( k.key_id   = a.key_id ) 
                                       AND ( c.codif_id = k.key_type_id ) 
                                       AND ( k.nso_id   = _nso_id )
                            )
                                   SELECT
                                       x.col_id::public.id_t  -- ID колонки                                                         
                                      ,x.parent_col_id        -- ID родительской колонки    
                                      ,x.number_col           -- Номер колонки                                                 
                                       --
                                      ,x.attr_id::public.id_t  -- ID атрибута                                                       
                                      ,x.attr_code             -- Код атрибута                                                   
                                      ,x.attr_name             -- Наименование атрибута     
                                      --                        
                                      ,x.attr_type_id::public.id_t -- Код типа атрибута    
                                      ,x.attr_type_scode           -- Краткий код                                       
                                      ,x.attr_type_code            -- Код типа атрибута                                          
                                      ,x.attr_type_name            -- Название типа атрибута                                
                                      --
                                      ,x.mandatory  -- Обязательность заполнения колонки     
                                      --                              
                                      ,y.key_id::public.id_t  -- ID ключа                                                             
                                      ,y.on_off               -- Признак активности ключа                            
                                      ,y.key_col_num          -- Номер ключевой колонки   
                                      --                             
                                      ,y.key_type_id::public.id_t -- ID типа ключа     
                                      ,y.key_type_scode           -- Краткий код типа ключа                                           
                                      ,y.key_type_code            -- Код типа ключа                                                
                                      ,y.key_type_name            -- Название типа ключа
                                      --
                                      ,x.level_d        -- Уровень        
                                    FROM x 
                                         LEFT OUTER JOIN y ON ( x.nso_id = y.nso_id ) AND ( x.col_id = y.col_id )
                                            ORDER BY x.level_d, x.parent_col_id, x.number_col ;
   END IF;
  END;
 $$
    STABLE
    SECURITY DEFINER -- 2015-04-05 Nick
    LANGUAGE plpgsql;
COMMENT ON FUNCTION nso_structure.nso_f_column_head_nso_s ( public.id_t, public.t_boolean) IS '179: Построение списка колонок НСО. Аргумент ID НСО';

-- SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_f_column_head_nso_s ( public.id_t, public.t_boolean )', security_warnings := true, fatal_errors := false);
-- SELECT * FROM nso_structure.nso_f_column_head_nso_s (34); 

-- SELECT * FROM nso.nso_key;SELECT * FROM nso_structure.nso_f_column_head_nso_s (34); 

-- Пример выполнения:
--     SELECt * FROM nso_structure.nso_f_column_head_nso_s ('Cl_OKv'); 
--       SELECT * FROM nso_data.nso_f_record_s ( 14 );
