-- =================================================================================== --
-- Author Ann. Отображение кодификатора.                                               --
-- Date create 2014-02-19                                                              --
--             2014-09-16 Nick Переписал всё.                                          --
--  2014-09-17 Дополнительная функция, аргумент - код кодификатора.                    --
--  2015-02-15 Nick Адаптация под домен EBD                                            --
--  2015-04-05  STABLE SECURITY INVOKER                                                --
-- 2015-05-30 Добавлены date_from, codif_uuid                                          --
-- 2015-07-20 Gregory «FROM com.obj_codifier» изменено на «FROM ONLY com.obj_codifier» --
-- 2017-07-11  Сортировка по столбцу "tree_d"                                          -- 
-- 2017-10-20 Nick Новый вариант функции отбражения кодификатора.                      -- 
-- 2017-12-04 Nick Аргумент - массив кодов                                             --
-- 2018-06-12 Nick сортировка по умоланию:  tree_d ASC.                                --
-- 2018-07-12 Nick   qty_d      public.t_int       -- количество прямых потомков       --
--                 , is_node_d  public.t_boolean   -- признак узла                     --
-- =================================================================================== --
SET search_path=com,PUBLIC;

-- DROP FUNCTION IF EXISTS com.com_f_obj_codifier_s_sys ( t_str60 ) CASCADE;
-- ----------------------------------------------------------------------------------------------------
-- ERROR:  cannot drop function com_f_obj_codifier_s_sys(t_str60) because other objects depend on it
-- DETAIL:  view pmt.v_payment_reestr_canlist depends on function com_f_obj_codifier_s_sys(t_str60)
-- function pmt.pmt_f_payments_reestr_s_canlist(id_t,id_t) depends on type pmt.v_payment_reestr_canlist
-- view pmt.v_payment_reestr depends on function com_f_obj_codifier_s_sys(t_str60)
-- HINT:  Use DROP ... CASCADE to drop the dependent objects too.
-- ----------------------------------------------------------------------------------------------------
-- ЗАМЕЧАНИЕ:  удаление распространяется на ещё 5 объектов
-- DETAIL:  
-- удаление распространяется на объект представление  pmt.v_payment_reestr
-- удаление распространяется на объект функция        pmt.pmt_f_payment_reestr_s(id_t)
-- удаление распространяется на объект функция        pmt.pmt_f_payment_reestr_s(t_guid)
-- удаление распространяется на объект представление  pmt.v_payment_reestr_canlist
-- удаление распространяется на объект функция        pmt.pmt_f_payments_reestr_s_canlist(id_t,id_t)
-- ----------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS com.com_f_obj_codifier_s_sys (public.t_arr_code, public.t_timestamp, public.t_int, public.t_text);
CREATE OR REPLACE FUNCTION com.com_f_obj_codifier_s_sys 
                        (  p_arr_code     public.t_arr_code         -- Массив кодов. 
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
     DECLARE          
      _order    public.t_arr_text; -- Колонки на выходе, сортировка
      _idx_attr public.t_arr_nmb;  -- Массив индексов атрибутов
      _rev_idx  public.t_arr_nmb;  -- Массив позиций атрибутов

      c_DEBUG public.t_boolean := com.f_debug_status();

      _arr_code public.t_arr_code;

     BEGIN
      _arr_code := (SELECT array_agg (upper(x)) FROM unnest (p_arr_code) x);

      WITH sort AS (
                     SELECT string_to_array ( value, ' ') AS col_mod 
                                  FROM each ( COALESCE (p_sort_hstore, '1 => "tree_d ASC"')::hstore ) -- Nick 2018-06-12 
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
              RAISE NOTICE '<com.com_f_obj_codifier_s_sys> %', _arr_code;
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
                         WHERE ( c.codif_code = ANY ( _arr_code )) 
     
                           UNION ALL
     
                          SELECT 
                             c.codif_id
                           , c.parent_codif_id
                           , c.small_code
                           , c.codif_code
                           , c.codif_name
                           , c.date_from   -- 2015-05-30 Nick
                           , c.codif_uuid                    
                           , CAST (  d.tree_d || c.codif_id AS public.t_arr_id )
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
     STABLE 
     SECURITY INVOKER
     LANGUAGE plpgsql ;

COMMENT ON FUNCTION com.com_f_obj_codifier_s_sys ( public.t_arr_code, public.t_timestamp, public.t_int, public.t_text ) 
   IS '9424/512: Отображение кодификатора по уровням иерархии

   Аргументы:
      1)  p_arr_code     public.t_arr_code         -- Массив кодов узлов
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
-- 	
-- select * from com.com_f_obj_codifier_s_sys ();
-- select * from com.com_f_obj_codifier_s_sys (ARRAY['C_OBJ_TYPE']);
-- select * from com.com_f_obj_codifier_s_sys (ARRAY['C_OBJ_TYPE'], p_level_d := 1);
-- select * from com.com_f_obj_codifier_s_sys ( p_arr_code := ARRAY['C_BD_TYPE', 'C_EXN_TYPE', 'C_NSO_CLASS', 'C_NSO_TTH'], p_level_d := 2);
-- select * from com.com_f_obj_codifier_s_sys ( p_arr_code := ARRAY['C_BD_TYPE', 'C_EXN_TYPE', 'C_NSO_CLASS', 'C_NSO_TTH'], p_sort_hstore :=  '1 => "tree_d ASC"'::t_text);
 
-- select * from com.com_f_obj_codifier_s_sys ('C_PM');
-- select * from com.com_f_obj_codifier_s_sys ('C_CODIF_ROOT');
-- select * from com.com_f_obj_codifier_s_sys ('zggfd');

-- select * from com.com_f_obj_codifier_s_sys ( p_codif_id := 364, p_sort_hstore :=  '1 => "tree_d ASC"'::t_text);
