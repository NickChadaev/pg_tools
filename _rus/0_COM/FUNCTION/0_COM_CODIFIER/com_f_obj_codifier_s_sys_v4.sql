DROP FUNCTION IF EXISTS com_codifier.com_f_obj_codifier_s_sys ( public.id_t, public.t_timestamp, public.t_int, public.t_text );
CREATE OR REPLACE FUNCTION com_codifier.com_f_obj_codifier_s_sys 
                        (  p_codif_id     public.id_t        = NULL -- ID узла 
                          ,p_date_from    public.t_timestamp = NULL -- Дата начала актуальности  
                          ,p_level_d      public.t_int       = NULL -- Уровень кооперации
                          ,p_sort_hstore  public.t_text      = '1 => "tree_d ASC"' -- Сортировка (hstore)
                        ) 
 RETURNS TABLE  (
      codif_id        public.id_t        -- id элемента кодификатора ( ID строки )
    , parent_codif_id public.id_t        -- id родительской строки
    , small_code      public.t_code1     -- Краткий код
    , codif_code      public.t_str60     -- код элемента кодификатора
    , codif_name      public.t_str250    -- наименование элемента кодификатора
      -- 
    , date_from       public.t_timestamp -- Дата начала актуальности 
    , codif_uuid      public.t_guid      -- UUID кодификатора 
      --
    , tree_d          public.t_arr_id    -- массив ID от текущей позиции
    , level_d         public.t_int       -- уровень от текущей позиции
    , tree_name_d     public.t_str2048   -- путь от текущей позиции
    , qty_d           public.t_int       -- количество прямых потомков
    , is_node_d       public.t_boolean   -- признак узла
)
  AS
   $$
      -- =================================================================================== --
      -- Author Ann. Отображение кодификатора.                                               --
      -- Date create 2014-02-19                                                              --
      --             2014-09-16 Nick Переписал всё.                                          --
      --             2015-02-15 Nick Адаптация под домен EBD                                 --
      -- 2015-04-05 STABLE SECURITY INVOKER                                                  --
      -- 2015-05-30 Добавлены date_from, codif_uuid                                          --
      -- 2015-07-20 Gregory «FROM com.obj_codifier» изменено на «FROM ONLY com.obj_codifier» --
      -- 2017-07-11 Сортировка по столбцу "tree_d"                                           -- 
      -- 2017-10-20 Nick Новый вариант функции отбражения кодификатора.                      -- 
      -- 2018-06-12 Nick сортировка по умолчанию:  tree_d ASC.                               --
      -- 2018-07-12 Nick   qty_d      public.t_int       -- количество прямых потомков       --
      --                 , is_node_d  public.t_boolean   -- признак узла                     --
      -- =================================================================================== --
     DECLARE          
      _order    public.t_arr_text; -- Колонки на выходе, сортировка
      _idx_attr public.t_arr_nmb;  -- Массив индексов атрибутов
      _rev_idx  public.t_arr_nmb;  -- Массив позиций атрибутов

      c_DEBUG public.t_boolean := utl.f_debug_status();

    BEGIN
      WITH sort AS (
                     SELECT string_to_array ( value, ' ') AS col_mod 
                                  FROM each ( COALESCE (p_sort_hstore, '1 => "tree_d ASC"')::hstore ) 
                     ORDER BY key ASC
      )
        SELECT array_agg (col_mod::text) FROM sort INTO _order;
      --
      WITH idxs AS (
              SELECT
                      row_number() OVER() AS idx
                     ,(u::public.t_arr_text)[1] AS attr   
              FROM unnest(_order) u
      )
      SELECT avals ( hstore ( ROW (
                                    max (CASE attr WHEN 'codif_id'        THEN idx ELSE 0 END)
                                   ,max (CASE attr WHEN 'parent_codif_id' THEN idx ELSE 0 END)
                                   ,max (CASE attr WHEN 'small_code'      THEN idx ELSE 0 END)
                                   ,max (CASE attr WHEN 'codif_code'      THEN idx ELSE 0 END)
                                   ,max (CASE attr WHEN 'codif_name'      THEN idx ELSE 0 END)
                                   ,max (CASE attr WHEN 'date_from'       THEN idx ELSE 0 END)
                                   ,max (CASE attr WHEN 'codif_uuid'      THEN idx ELSE 0 END)
                                   ,max (CASE attr WHEN 'tree_d'          THEN idx ELSE 0 END)
                                   ,max (CASE attr WHEN 'level_d'         THEN idx ELSE 0 END)
                                   ,max (CASE attr WHEN 'qty_d'           THEN idx ELSE 0 END)     
                                   ,max (CASE attr WHEN 'is_node_d'       THEN idx ELSE 0 END)   
                                  )
                            )
                    )
      FROM idxs INTO _idx_attr;
      --
      WITH attrs AS ( SELECT (u::public.t_arr_text)[1] AS attr FROM unnest(_order) u )
      SELECT array_agg (
              CASE attr
                      WHEN 'codif_id'        THEN  1
                      WHEN 'parent_codif_id' THEN  2
                      WHEN 'small_code'      THEN  3
                      WHEN 'codif_code'      THEN  4
                      WHEN 'codif_name'      THEN  5
                      WHEN 'date_from'       THEN  6
                      WHEN 'codif_uuid'      THEN  7
                      WHEN 'tree_d'          THEN  8
                      WHEN 'level_d'         THEN  9
                      WHEN 'qty_d'           THEN 10
                      WHEN 'is_node_d'       THEN 11
              END
      )
      FROM attrs  INTO _rev_idx;

      IF c_DEBUG
      THEN
              RAISE NOTICE '<com.com_f_obj_codifier_s_sys> %', _order;
              RAISE NOTICE '<com.com_f_obj_codifier_s_sys> %', _idx_attr;
              RAISE NOTICE '<com.com_f_obj_codifier_s_sys> %', _rev_idx;
      END IF;

      RETURN QUERY
        WITH qr1 
           AS (
               WITH RECURSIVE cd (  codif_id
                                   ,parent_codif_id
                                   ,small_code 
                                   ,codif_code
                                   ,codif_name
                                   ,date_from   -- 2015-05-30 Nick 
                                   ,codif_uuid
                                   ,tree_d
                                   ,level_d
                                   ,tree_name_d
                                   ,cicle_d
                   ) AS ( SELECT 
                             c.codif_id
                           , c.parent_codif_id
                           , c.small_code
                           , c.codif_code
                           , c.codif_name
                           , c.date_from   -- 2015-05-30 Nick
                           , c.codif_uuid                    
                           , CAST ( ARRAY [c.codif_id] AS public.t_arr_id ) 
                           , 1::public.small_t
                           , btrim ( CAST( c.codif_name AS public.t_str2048))
                           , FALSE

                          FROM ONLY com.obj_codifier c 
                             WHERE ((p_codif_id IS NULL) AND c.parent_codif_id IS NULL) OR ((p_codif_id IS NOT NULL) AND ( c.codif_id = p_codif_id ))
     
                           UNION ALL
     
                          SELECT 
                             c.codif_id
                           , c.parent_codif_id
                           , c.small_code
                           , c.codif_code
                           , c.codif_name
                           , c.date_from   -- 2015-05-30 Nick
                           , c.codif_uuid                    
                           , CAST (d.tree_d::int8[] || c.codif_id::int8 AS public.t_arr_id) -- 2019-05-28 на 9.4 это работало.
                           , (d.level_d + 1)::public.small_t
                           , d.tree_name_d::public.t_str2048|| '-->' || c.codif_name::public.t_str250 
                           , c.codif_id = ANY ( d.tree_d )
                          FROM ONLY com.obj_codifier c 
                           INNER JOIN cd d ON ( d.codif_id  = c.parent_codif_id ) AND ( NOT cicle_d )
               ) -- cd
                 SELECT  s.codif_id::public.id_t     
                        ,s.parent_codif_id 
                        ,s.small_code   
                        ,s.codif_code   
                        ,s.codif_name  
                        ,s.date_from   -- 2015-05-30 Nick
                        ,s.codif_uuid                    
                        ,s.tree_d       
                        ,s.level_d::public.t_int      
                        ,s.tree_name_d::public.t_str2048
                  FROM cd s 
                      WHERE ((p_level_d IS NULL) OR ((s.level_d::public.t_int <= p_level_d) AND (p_level_d IS NOT NULL))) AND
                            ((p_date_from IS NULL) OR ((s.date_from >= p_date_from) AND (p_date_from IS NOT NULL))) 
        ) -- qr1
       , qr2 (  codif_id
               ,parent_codif_id
               ,small_code 
               ,codif_code
               ,codif_name
               ,date_from   -- 2015-05-30 Nick 
               ,codif_uuid
               ,tree_d
               ,level_d
               ,tree_name_d
               ,qty_d       -- 2018-07-12 Nick  -- количество прямых потомков
               ,is_node_d   -- 2018-07-12 Nick  -- признак узла
              )
               AS (
                 SELECT  s.codif_id::public.id_t     
                        ,s.parent_codif_id 
                        ,s.small_code   
                        ,s.codif_code   
                        ,s.codif_name  
                        ,s.date_from   -- 2015-05-30 Nick
                        ,s.codif_uuid                    
                        ,s.tree_d       
                        ,s.level_d::public.t_int      
                        ,s.tree_name_d::public.t_str2048
                        ,(SELECT count(*) FROM ONLY com.obj_codifier x WHERE ( x.parent_codif_id = s.codif_id ))::public.t_int AS qty_d   
                        ,(EXISTS (SELECT 1 FROM ONLY com.obj_codifier x WHERE ( x.parent_codif_id = s.codif_id )))::public.t_boolean AS is_node_d
                  FROM qr1 s 
        )
        ,sort AS (
                    SELECT  q.codif_id::public.id_t     
                           ,q.parent_codif_id 
                           ,q.small_code   
                           ,q.codif_code   
                           ,q.codif_name  
                           ,q.date_from   -- 2015-05-30 Nick
                           ,q.codif_uuid                    
                           ,q.tree_d       
                           ,q.level_d::public.t_int      
                           ,q.tree_name_d::public.t_str2048
                           ,q.qty_d       -- 2018-07-12 Nick  -- количество прямых потомков
                           ,q.is_node_d   -- 2018-07-12 Nick  -- признак узла
                       ,ARRAY [ 
                                s_obj_codifier_codif_id.num
                               ,s_obj_codifier_parent_codif_id.num
                               ,s_obj_codifier_small_code.num
                               ,s_obj_codifier_codif_code.num
                               ,s_obj_codifier_codif_name.num
                               ,s_obj_codifier_date_from.num
                               ,s_obj_codifier_codif_uuid.num
                               ,s_obj_codifier_tree_d.num
                               ,s_obj_codifier_level_d.num
                               ,s_obj_codifier_qty_d.num
                               ,s_obj_codifier_is_node_d.num
                     ] AS ordr                  
                FROM qr2 q 
                  LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[ 1]])::public.t_arr_text)[2] = 'DESC' THEN row_number() OVER (ORDER BY qs.codif_id        DESC) ELSE row_number() OVER (ORDER BY qs.codif_id        ASC) END AS num, qs.codif_id        FROM qr2 qs WHERE (_idx_attr[ 1] > 0) GROUP BY qs.codif_id       ) s_obj_codifier_codif_id        USING ( codif_id )
                  LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[ 2]])::public.t_arr_text)[2] = 'DESC' THEN row_number() OVER (ORDER BY qs.parent_codif_id DESC) ELSE row_number() OVER (ORDER BY qs.parent_codif_id ASC) END AS num, qs.parent_codif_id FROM qr2 qs WHERE (_idx_attr[ 2] > 0) GROUP BY qs.parent_codif_id) s_obj_codifier_parent_codif_id USING (parent_codif_id)
                  LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[ 3]])::public.t_arr_text)[2] = 'DESC' THEN row_number() OVER (ORDER BY qs.small_code      DESC) ELSE row_number() OVER (ORDER BY qs.small_code      ASC) END AS num, qs.small_code      FROM qr2 qs WHERE (_idx_attr[ 3] > 0) GROUP BY qs.small_code     ) s_obj_codifier_small_code      USING (small_code)
                  LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[ 4]])::public.t_arr_text)[2] = 'DESC' THEN row_number() OVER (ORDER BY qs.codif_code      DESC) ELSE row_number() OVER (ORDER BY qs.codif_code      ASC) END AS num, qs.codif_code      FROM qr2 qs WHERE (_idx_attr[ 4] > 0) GROUP BY qs.codif_code     ) s_obj_codifier_codif_code      USING (codif_code)
                  LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[ 5]])::public.t_arr_text)[2] = 'DESC' THEN row_number() OVER (ORDER BY qs.codif_name      DESC) ELSE row_number() OVER (ORDER BY qs.codif_name      ASC) END AS num, qs.codif_name      FROM qr2 qs WHERE (_idx_attr[ 5] > 0) GROUP BY qs.codif_name     ) s_obj_codifier_codif_name      USING (codif_name)
                  LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[ 6]])::public.t_arr_text)[2] = 'DESC' THEN row_number() OVER (ORDER BY qs.date_from       DESC) ELSE row_number() OVER (ORDER BY qs.date_from       ASC) END AS num, qs.date_from       FROM qr2 qs WHERE (_idx_attr[ 6] > 0) GROUP BY qs.date_from      ) s_obj_codifier_date_from       USING (date_from)
                  LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[ 7]])::public.t_arr_text)[2] = 'DESC' THEN row_number() OVER (ORDER BY qs.codif_uuid      DESC) ELSE row_number() OVER (ORDER BY qs.codif_uuid      ASC) END AS num, qs.codif_uuid      FROM qr2 qs WHERE (_idx_attr[ 7] > 0) GROUP BY qs.codif_uuid     ) s_obj_codifier_codif_uuid      USING (codif_uuid)
                  LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[ 8]])::public.t_arr_text)[2] = 'DESC' THEN row_number() OVER (ORDER BY qs.tree_d          DESC) ELSE row_number() OVER (ORDER BY qs.tree_d          ASC) END AS num, qs.tree_d          FROM qr2 qs WHERE (_idx_attr[ 8] > 0) GROUP BY qs.tree_d         ) s_obj_codifier_tree_d          USING (tree_d)
                  LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[ 9]])::public.t_arr_text)[2] = 'DESC' THEN row_number() OVER (ORDER BY qs.level_d         DESC) ELSE row_number() OVER (ORDER BY qs.level_d         ASC) END AS num, qs.level_d         FROM qr2 qs WHERE (_idx_attr[ 9] > 0) GROUP BY qs.level_d        ) s_obj_codifier_level_d         USING (level_d)
                  LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[10]])::public.t_arr_text)[2] = 'DESC' THEN row_number() OVER (ORDER BY qs.qty_d           DESC) ELSE row_number() OVER (ORDER BY qs.qty_d           ASC) END AS num, qs.qty_d           FROM qr2 qs WHERE (_idx_attr[10] > 0) GROUP BY qs.qty_d          ) s_obj_codifier_qty_d           USING (qty_d)
                  LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[11]])::public.t_arr_text)[2] = 'DESC' THEN row_number() OVER (ORDER BY qs.is_node_d       DESC) ELSE row_number() OVER (ORDER BY qs.is_node_d       ASC) END AS num, qs.is_node_d       FROM qr2 qs WHERE (_idx_attr[11] > 0) GROUP BY qs.is_node_d      ) s_obj_codifier_is_node_d       USING (is_node_d)
        ) -- sort
            SELECT 
                    s.codif_id          
                   ,s.parent_codif_id                
                   ,s.small_code                     
                   ,s.codif_code                     
                   ,s.codif_name                     
                   ,s.date_from    
                   ,s.codif_uuid                     
                   ,s.tree_d                         
                   ,s.level_d          
                   ,s.tree_name_d  
                   ,s.qty_d       -- 2018-07-12 Nick  -- количество прямых потомков
                   ,s.is_node_d   -- 2018-07-12 Nick  -- признак узла

            FROM sort s
            ORDER BY
                    ordr[_rev_idx[ 1]]
                   ,ordr[_rev_idx[ 2]]
                   ,ordr[_rev_idx[ 3]]
                   ,ordr[_rev_idx[ 4]]
                   ,ordr[_rev_idx[ 5]]
                   ,ordr[_rev_idx[ 6]]
                   ,ordr[_rev_idx[ 7]]
                   ,ordr[_rev_idx[ 8]]
                   ,ordr[_rev_idx[ 9]]
                   ,ordr[_rev_idx[10]]
                   ,ordr[_rev_idx[11]];
    END;
   $$
     SET search_path=com_codifier, com, public, pg_catalog
     STABLE 
     SECURITY INVOKER
     LANGUAGE plpgsql ;

COMMENT ON FUNCTION com_codifier.com_f_obj_codifier_s_sys ( public.id_t, public.t_timestamp, public.t_int, public.t_text ) 
   IS '45: Отображение кодификатора по уровням иерархии

   Аргументы:
      1)  p_codif_id     public.id_t        = NULL -- ID узла 
      2) ,p_date_from    public.t_timestamp = NULL -- Дата начала актуальности  
      3) ,p_level_d      public.t_int       = NULL -- Уровень кооперации
      4) ,p_sort_hstore  public.t_text      = ''1 => "tree_d ASC"'' -- Сортировка (hstore)
                     
   Выходный данные:
      1)   codif_id        public.id_t        -- id элемента кодификатора ( ID строки )
      2) , parent_codif_id public.id_t        -- id родительской строки
      3) , small_code      public.t_code1     -- Краткий код
      4) , codif_code      public.t_str60     -- Код элемента кодификатора
      5) , codif_name      public.t_str250    -- Наименование элемента кодификатора
           -- 
      6) , date_from       public.t_timestamp -- Дата начала актуальности 
      7) , codif_uuid      public.t_guid      -- UUID кодификатора 
           --
      8) , tree_d          public.t_arr_id    -- Массив ID от текущей позиции
      9) , level_d         public.t_int       -- Уровень от текущей позиции
     10) , tree_name_d     public.t_str2048   -- Путь от текущей позиции
     11) , qty_d           public.t_int       -- Количество прямых потомков
     12) , is_node_d       public.t_boolean   -- Признак узла
';
--	
-- -----------------------------------------------------------
--  SELECT utl.f_debug_on ();
	
-- select * from com_codifier.com_f_obj_codifier_s_sys ('C_KEY_TYPE');
-- select * from com_codifier.com_f_obj_codifier_s_sys ( 'C_OBJ_TYPE');
-- select * from com_codifier.com_f_obj_codifier_s_sys ( 'C_ATTR_TYPE');
-- select * from com_codifier.com_f_obj_codifier_s_sys (p_level_d := 3);
-- SELECT * FROM com_codifier.com_f_obj_codifier_s_sys (35);
-- SELECT * FROM com_codifier.com_f_obj_codifier_s_sys ();
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------
--  5|3|'W'|'C_KEY_TYPE'|'Типы ключей'           |'2015-10-12 13:57:27'|'4dd3a974-ae6d-4b07-b021-ab75d3ddbd94'|'{5}'   |1|'Типы ключей'                         |7|t
-- 45|5|'a'|'AKKEY1'    |'Уникальный ключ 1'     |'2015-10-12 14:02:03'|'d483fb9b-b6eb-4854-a0da-230171e60cc6'|'{5,45}'|2|'Типы ключей-->Уникальный ключ 1'     |0|f
-- 46|5|'b'|'AKKEY2'    |'Уникальный ключ 2'     |'2015-10-12 14:02:03'|'1879aa96-75d5-4298-a553-9e00eebadc28'|'{5,46}'|2|'Типы ключей-->Уникальный ключ 2'     |0|f
-- 47|5|'c'|'AKKEY3'    |'Уникальный ключ 3'     |'2015-10-12 14:02:03'|'75cd72f2-d38f-4e76-a440-374226e47416'|'{5,47}'|2|'Типы ключей-->Уникальный ключ 3'     |0|f
-- 48|5|'d'|'PKKEY'     |'Идентификационный ключ'|'2015-10-12 14:02:03'|'fec34114-1b24-45b1-824c-af8e8b1e7b43'|'{5,48}'|2|'Типы ключей-->Идентификационный ключ'|0|f
-- 49|5|'e'|'IEKEY'     |'Поисковый ключ'        |'2015-10-12 14:02:03'|'5dc34472-5ad2-4b0e-8504-86c631a909de'|'{5,49}'|2|'Типы ключей-->Поисковый ключ'        |0|f
-- 50|5|'f'|'FKKEY'     |'Ссылочный ключ'        |'2015-10-12 14:02:03'|'092f1092-f6b8-4c3a-8c13-18e25007fa69'|'{5,50}'|2|'Типы ключей-->Ссылочный ключ'        |0|f
-- 51|5|'g'|'DEFKEY'    |'Значение по умолчанию' |'2015-10-12 14:02:03'|'1c185a66-7f0a-417c-8094-1286e9a60706'|'{5,51}'|2|'Типы ключей-->Значение по умолчанию' |0|f

-- select * from com.com_f_obj_codifier_s_sys ( p_date_from := '2017-10-04', p_sort_hstore :=  '1 => "level_d ASC", 2 => "date_from DESC"'::t_text ); 
-- select * from com.com_f_obj_codifier_s_sys ( p_date_from := '2017-10-04', p_sort_hstore :=  '1 => "codif_name ASC"'::t_text ); 
-- SELECT com.f_debug_on();
-- --------------------------------------------------------------------------------------------------------------------------------
-- ЗАМЕЧАНИЕ:  <com.com_f_obj_codifier_s_sys> {"{codif_name,ASC}"} Направление сортировки
-- ЗАМЕЧАНИЕ:  <com.com_f_obj_codifier_s_sys> {0,0,0,0,1,0,0,0,0}  Пятый атрибут первый приоритет в сортировке
-- ЗАМЕЧАНИЕ:  <com.com_f_obj_codifier_s_sys> {5}                  Используем только пятый атрибут, последовательность сортировки.
-- Суммарное время выполнения запроса: 60 ms. 39 строк получено.
-- --------------------------------------------------------------------------------------------------------------------------------
-- SELECT * from com.com_f_obj_codifier_s_sys ( p_codif_id := 4, p_date_from := '2017-09-04'::t_timestamp, p_sort_hstore :=  '1 => "level_d ASC", 2 => "date_from DESC"'::t_text);
-- SELECT * from com.com_f_obj_codifier_s_sys ( p_sort_hstore :=  '1 => "tree_d ASC", 2 => "date_from DESC"'::t_text);
-- ---------------------------------------------------------------------------------
-- ЗАМЕЧАНИЕ:  <com.com_f_obj_codifier_s_sys> {"{level_d,ASC}","{date_from,DESC}"}
-- ЗАМЕЧАНИЕ:  <com.com_f_obj_codifier_s_sys> {0,0,0,0,0,2,0,0,1}
-- ЗАМЕЧАНИЕ:  <com.com_f_obj_codifier_s_sys> {9,6}
-- ------------------------------------------------	
-- select * from com.com_f_obj_codifier_s_sys ( p_level_d := 2);
-- select * from com.obj_codifier
