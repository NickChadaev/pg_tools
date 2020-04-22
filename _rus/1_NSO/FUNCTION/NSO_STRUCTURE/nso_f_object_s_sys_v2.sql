DROP FUNCTION IF EXISTS nso_structure.nso_f_object_s_sys ( public.id_t, public.t_str250, public.t_boolean, public.t_int, public.t_int, public.t_int );
CREATE OR REPLACE FUNCTION nso_structure.nso_f_object_s_sys
(
        p_nso_id      public.id_t      DEFAULT NULL  -- ID НСО
       ,p_nso_value   public.t_str250  DEFAULT NULL  -- Аргумент для поиска в имени НСО
       ,p_srch_strict public.t_boolean DEFAULT FALSE -- Переключатель строгий/контекстный поиск Nick 2017-05-24
       ,p_level_d     public.t_int     DEFAULT NULL  -- Уровень кооперации 
       ,p_limit       public.t_int     DEFAULT NULL  -- Количество записей
       ,p_offset      public.t_int     DEFAULT NULL  -- Смещение
) 
RETURNS TABLE
(
           nso_id                 public.id_t          -- ID НСО ( ID строки )   !!!!!!!!!!!!!                                 
          ,nso_code               public.t_str60       -- Код НСО                                        
          ,parent_nso_id          public.id_t          -- ID Код родительского НСО             
          ,parent_nso_code        public.t_str60       -- Код родительского НСО                                        
          ,nso_name               public.t_str250      -- Наименование                             
          ,date_create            public.t_timestamp   -- Дата создания                            
          ,nso_type_id            public.id_t          -- ID типа НСО             !!!!!!!!!!!!!                      
          ,nso_type_code          public.t_str60       -- Код типа НСО                                    
          ,nso_type_name          public.t_str250      -- Имя типа 
          ,nso_release            public.small_t       -- Версия                                         
          ,nso_uuid               public.t_guid        -- UUID                                                 
          ,active_sign            public.t_boolean     -- Признак активности                  
          ,is_group_nso           public.t_boolean     -- Признак группового НСО           
          ,is_intra_op            public.t_boolean     -- Признак интраоперабельности
          ,is_m_view              public.t_boolean     -- Признак наличия материализованного представления
          ,unique_check           public.t_boolean     -- Признак контроля уникальности  Nick 2016-07-14 
          ,count_rec              public.t_int         -- Количество строк                      
          ,date_from              public.t_timestamp   -- Дата начала актуальности       
          ,date_to                public.t_timestamp   -- Дата окончания актуальноси   
          ,tree_d                 public.t_arr_id      -- Массив ID от текущей позиции   
          ,level_d                public.small_t       -- Уровень от текущей позиции    
          ,tree_name_d            public.t_str2048     -- Путь от текущей позиции    
)
AS
 $$
    -- ============================================================================================= --
    -- Author Ann. Отображение списка НСО.                                                           --
    -- Date create 2014-02-19                                                                        --
    -- 2014-09-16 Nick Переписал всё.                                                                --
    -- 2014-09-24 Nick Добавлен ID типа НСО                                                          --
    -- 2015-09-20 Добавлен ONLY    Nick                                                              --
    -- 2016-07-20 Nick Добавлен признак контроля уникальности                                        --
    -- 2017-05-23 Gregory поиск, постраничность                                                      --
    -- 2018-06-27 Nick Добавлен код родительского элемента, добавлено управление уровнем кооперации. --
    -- ============================================================================================= --
 
   DECLARE
           _limit     public.t_int    := COALESCE ( p_limit, 200 ); -- По умолчанию - 200 первых записей
           _offset    public.t_int    := COALESCE ( p_offset, 0 );  -- По умолчанию - смещение 0
           _nso_value public.t_str250 := lower(CASE WHEN p_srch_strict THEN btrim(p_nso_value) ELSE '%' || btrim(p_nso_value) || '%' END);
   
   BEGIN
         RETURN QUERY
               WITH RECURSIVE cd ( 
                                    nso_id                -- ID НСО ( ID строки )                                    
                                   ,nso_code              -- Код НСО                                        
                                   ,parent_nso_id         -- id родительской строки             
                                   ,parent_nso_code       -- Код родительского НСО
                                   ,nso_name              -- Наименование                             
                                   ,date_create           -- Дата создания                            
                                   ,nso_type_id           -- ID типа НСО                                   
                                   ,nso_type_code         -- Код типа НСО
                                   ,nso_type_name         -- Имя типа                                      
                                   ,nso_release           -- Версия                                         
                                   ,nso_uuid              -- UUID                                                 
                                   ,active_sign           -- Признак активности                  
                                   ,is_group_nso          -- Признак группового НСО           
                                   ,is_intra_op           -- Признак интраоперабельности
                                   ,is_m_view             -- Признак наличия материализованного представления
                                   ,unique_check          -- Признак контроля уникальности  Nick 2016-07-14 
                                   ,count_rec             -- количество строк                      
                                   ,date_from             -- Дата начала катуальности       
                                   ,date_to               -- Дата окончания актуальноси   
                                   ,tree_d                -- массив ID от текущей позиции   
                                   ,level_d               -- уровень от текущей позиции    
                                   ,tree_name_d           -- путь от текущей позиции  
                                   ,cicle_d         
                   ) AS ( SELECT 
                                 o.nso_id 
                                ,o.nso_code  	
                                ,o.parent_nso_id 
                                ,p.nso_code  	
                                ,o.nso_name 
                                ,o.date_create
                                ,c.codif_id
                                ,c.codif_code::public.t_str60 
                                ,c.codif_name::public.t_str250 
                                ,o.nso_release
                                ,o.nso_uuid
                                ,o.active_sign
                                ,o.is_group_nso
                                ,o.is_intra_op
                                ,o.is_m_view
                                ,o.unique_check       -- Признак контроля уникальности  Nick 2016-07-14 
                                ,(SELECT count(rec_id) FROM ONLY nso.nso_record r WHERE r.nso_id = o.nso_id)
                                ,o.date_from
                                ,o.date_to
                                ,CAST ( ARRAY [o.nso_id] AS public.t_arr_id ) 
                                ,1::public.small_t 
                                ,btrim ( CAST( o.nso_name AS public.t_str2048))
                                ,FALSE
                           FROM ONLY nso.nso_object o
                             LEFT OUTER JOIN ONLY nso.nso_object p ON (o.parent_nso_id = p.nso_id)
                             INNER JOIN ONLY com.obj_codifier c ON ( o.nso_type_id = c.codif_id )
                          WHERE (( o.parent_nso_id IS NULL ) AND ( p_nso_id IS NULL )) OR
                                (( o.nso_id = p_nso_id ) AND ( p_nso_id IS NOT NULL ))   
   
                           UNION ALL
   
                          SELECT 
                                 o.nso_id 
                                ,o.nso_code  	
                                ,o.parent_nso_id 
                                ,d.nso_code  	
                                ,o.nso_name 
                                ,o.date_create
                                ,c.codif_id
                                ,c.codif_code::public.t_str60  
                                ,c.codif_name::public.t_str250 
                                ,o.nso_release
                                ,o.nso_uuid
                                ,o.active_sign
                                ,o.is_group_nso
                                ,o.is_intra_op
                                ,o.is_m_view
                                ,o.unique_check       -- Признак контроля уникальности  Nick 2016-07-14 
                                ,(SELECT count(rec_id) FROM ONLY nso.nso_record r WHERE r.nso_id = o.nso_id)
                                ,o.date_from
                                ,o.date_to
                                ,CAST (( d.tree_d::int8[] || o.nso_id::int8) AS public.t_arr_id)
                                ,(d.level_d + 1)::public.small_t
                                ,d.tree_name_d::public.t_str2048 || '-->' || o.nso_name::public.t_str250 
                                ,o.nso_id = ANY ( d.tree_d )
                           FROM ONLY nso.nso_object o
                             INNER JOIN ONLY com.obj_codifier c ON ( o.nso_type_id = c.codif_id )
                             INNER JOIN cd d ON ( d.nso_id  = o.parent_nso_id ) AND ( NOT d.cicle_d ) 
                     ) 
                       SELECT 
                                 s.nso_id::public.id_t              
                                ,s.nso_code            
                                ,s.parent_nso_id       
                                ,s.parent_nso_code            
                                ,s.nso_name            
                                ,s.date_create         
                                ,s.nso_type_id::public.id_t           
                                ,s.nso_type_code  
                                ,s.nso_type_name     
                                ,s.nso_release         
                                ,s.nso_uuid            
                                ,s.active_sign         
                                ,s.is_group_nso        
                                ,s.is_intra_op         
                                ,s.is_m_view
                                ,s.unique_check       -- Признак контроля уникальности  Nick 2016-07-14 
                                ,s.count_rec::public.t_int             
                                ,s.date_from           
                                ,s.date_to             
                                ,s.tree_d              
                                ,s.level_d             
                                ,s.tree_name_d::public.t_str2048         
                        FROM cd s
                           WHERE ((p_nso_value IS NULL) OR 
                                   ((p_nso_value IS NOT NULL) AND 
                                    (((p_srch_strict) AND lower (s.nso_name) = _nso_value) OR ((NOT p_srch_strict) AND lower (s.nso_name) LIKE _nso_value))
                                   )
                                  ) AND
                                  ((p_level_d IS NULL) OR ((s.level_d::public.t_int <= p_level_d) AND (p_level_d IS NOT NULL)))   
                       ORDER BY s.tree_d -- s.level_d, s.parent_nso_id, s.nso_id;
                           LIMIT _limit OFFSET _offset;
   END;
$$
STABLE
SECURITY INVOKER --DEFINER
SET search_path = nso_structure, nso, com, public 
LANGUAGE plpgsql;

COMMENT ON FUNCTION nso_structure.nso_f_object_s_sys (public.id_t, public.t_str250, public.t_boolean, public.t_int, public.t_int, public.t_int)
IS '151: Отображение списка объектов НСО по уровням иерархии, аргумент ID НСО
    Входные параметры:
                1)  p_nso_id      public.id_t      DEFAULT NULL  -- ID НСО
                2) ,p_nso_value   public.t_str250  DEFAULT NULL  -- Аргумент для поиска в имени НСО
                3) ,p_srch_strict public.t_boolean DEFAULT FALSE -- Переключатель строгий/контекстный поиск
                4) ,p_level_d     public.t_int     DEFAULT NULL  -- Уровень кооперации 
                5) ,p_limit       public.t_int     DEFAULT NULL  -- Количество записей
                6) ,p_offset      public.t_int     DEFAULT NULL  -- Смещение

    Выходные параметры:
                   1)  ,nso_id             public.id_t          -- ID НСО 
                   2)  ,nso_code           public.t_str60       -- Код НСО                                        
                   3)   parent_nso_id      public.id_t          -- ID Код родительского НСО             
                   4)  ,parent_nso_code    public.t_str60       -- Код родительского НСО                                        
                   5)  ,nso_name           public.t_str250      -- Наименование                             
                   6)  ,date_create        public.t_timestamp   -- Дата создания                            
                   7)  ,nso_type_id        public.id_t          -- ID типа НСО            
                   8)  ,nso_type_code      public.t_str60       -- Код типа НСО                                    
                   9)  ,nso_type_name      public.t_str250      -- Имя типа 
                  10)  ,nso_release        public.small_t       -- Версия                                         
                  11)  ,nso_uuid           public.t_guid        -- UUID                                                 
                  12)  ,active_sign        public.t_boolean     -- Признак активности                  
                  13)  ,is_group_nso       public.t_boolean     -- Признак группового НСО           
                  14)  ,is_intra_op        public.t_boolean     -- Признак интраоперабельности
                  15)  ,is_m_view          public.t_boolean     -- Признак наличия материализованного представления
                  16)  ,unique_check       public.t_boolean     -- Признак контроля уникальности 
                  17)  ,count_rec          public.t_int         -- Количество строк                      
                  18)  ,date_from          public.t_timestamp   -- Дата начала актуальности       
                  19)  ,date_to            public.t_timestamp   -- Дата окончания актуальноси   
                  20)  ,tree_d             public.t_arr_id      -- Массив ID от текущей позиции   
                  21)  ,level_d            public.small_t       -- Уровень от текущей позиции    
                  22)  ,tree_name_d        public.t_str2048     -- Путь от текущей позиции    
'; ---------------------------------------------------------------------------------
-- SELECT * FROM nso_structure.nso_f_object_s_sys();

-- SELECT * FROM nso.nso_f_object_s_sys2();
-- SELECT * FROM nso.nso_f_object_s_sys2();
-- SELECT * FROM nso.nso_f_object_s_sys2(9);

-- SELECT * FROM nso.nso_f_object_s_sys2(p_nso_value := 'норма', p_level_d := 1);  
-- 2;1;'NSO_NORM';'Норматив.'

-- SELECT * FROM nso.nso_f_object_s_sys2(5);
-- 5;1;'NSO_DIC';'Словарь.'

-- SELECT * FROM nso.nso_f_object_s_sys2(NULL, 'Словарь.', TRUE); -- Не работает

-- SELECT * FROM nso.nso_f_object_s_sys2 ( p_nso_value := 'валют');
-- 5;1;'NSO_DIC';'Словарь.'
-- 6;1;'NSO_UDF';'Унифицированная форма документа.'
-- 17;11;'THC_RANGE';'Технический справочник для ранжирования данных'

-- select * from nso.nso_f_object_s_sys ();
-- select * from nso.nso_f_object_s_sys (6);
-- SELECT * FROM nso.nso_object;
-- Суммарное время выполнения запроса: 570 ms.
-- 398 строк получено.
-- select * from nso.nso_f_object_s_sys (1);
-- select * from nso.nso_f_object_s_sys (6);
-- select * from nso.nso_f_object_s_sys (29);
-- select * from nso.nso_object;
-- SELECT * FROM nso.nso_f_record_select_all ('KL_SECR'); -- 'SPR_EMPLOYE' 'KL_SECR'
-- SELECT * FROM nso.nso_record WHERE (nso_id = 15);
-- ---------------------------------------------------------------------------------------------
--  9||'c9dff31b-5845-4722-a0fe-453e31743f04'|15|t|'2015-06-03 21:15:05'|'9999-12-31 00:00:00'|0
-- 10||'b0f44cec-16ec-480b-8c60-e968f94c84af'|15|t|'2015-06-03 21:15:05'|'9999-12-31 00:00:00'|0
-- 11||'d3f49dfd-53f6-4cde-84ee-daba75fbd7c5'|15|t|'2015-06-03 21:15:05'|'9999-12-31 00:00:00'|0
-- 12||'adb69fdb-6a1c-475d-af51-f46b4606bc32'|15|t|'2015-06-03 21:15:05'|'9999-12-31 00:00:00'|0
