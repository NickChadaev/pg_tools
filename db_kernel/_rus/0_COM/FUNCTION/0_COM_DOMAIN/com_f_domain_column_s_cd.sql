DROP FUNCTION IF EXISTS com_domain.nso_f_domain_column_s ( public.t_str60, public.t_timestamp, public.t_int);
CREATE OR REPLACE FUNCTION com_domain.nso_f_domain_column_s ( 
                      p_attr_code public.t_str60             -- Код атрибута
                    , p_date      public.t_timestamp         -- Дата
                    , p_level_d   public.t_int       = 99999 -- Уровень вложенности   
) 
 RETURNS TABLE  (
                    attr_id           public.id_t     -- Идентификатор атрибута
                   ,parent_attr_id    public.id_t        -- Идентификатор родительского атрибута
                    --
                   ,impact_type       public.t_code1     -- Код воздействия -- Nick 2015-08-29
                   ,attr_status       public.t_str20     -- Статус атрибута
                    --
                   ,attr_code         public.t_str60     -- Код атрибута
                   ,attr_name         public.t_str250    -- Наименование атрибута
                   ,attr_type_id      public.id_t      -- Тип атрибута
                   ,attr_type_code    public.t_str60     -- Код типа атрибута
                   ,attr_type_name    public.t_str250    -- Наименование типа атрибута
                    -- Nick 2017-11-25
                   ,type_len          public.t_int       -- Длина типа
                   ,type_prec         public.t_int       -- Точность поля
                   ,base_name         public.t_str60     -- Имя базового типа
                   ,type_category     public.t_code1     -- Категория типа
                    -- Nick 2017-11-25
                   ,attr_uuid         public.t_guid      -- UUID атрибута
                   ,attr_create_date  public.t_timestamp -- Дата создания
                   ,is_intra_op       public.t_boolean   -- Признак итраоперабельности
                   ,date_from         public.t_timestamp -- Дата начала актуальности
                   ,date_to           public.t_timestamp -- Дата конца актуальности
                   -- 
                   ,tree_d            public.t_arr_id    -- массив ID от текущей позиции
                   ,level_d           public.small_t     -- уровень от текущей позиции
                   ,tree_name_d       public.t_str2048   -- путь от текущей позиции
                    --
                   ,domain_nso_id     public.id_t        -- Идентификатор НСО домена
                   ,domain_nso_code   public.t_str60     -- Код НСО домена
                   ,domain_nso_name   public.t_str250    -- Наименование домена   
                   ,id_log            public.id_t        -- Идентификатор журнала
 )
  AS
   $$
      -- ==================================================== --
      -- Author Nick. Отображение списка атрибутов с типами.  --
      -- Date create 2014-09-24                               --
      -- 2015-02-26 Переход на домен ЕБД.                     --
      --             2015-05-30  Перенос в схему COM.         -- 
      -- 2015-07-20 Gregory Модифицирована под "на дату"      --
      -- 2015-11-17 Новый атрибут типа "ссылка на документ"   -- 
      -- 2016-02-02 goback Nick                               --
      -- ---------------------------------------------------- -- 
      --  2016-06-19 Nick  Дополнительный атрибут  nso_code   --
      --  2017-11-25 Nick  Вводится связь с системными типами --
      --  2019-07-03 Nick  Новое ядро.                        -- 
      -- ==================================================== --
     BEGIN
      RETURN QUERY
        SELECT * FROM (
            WITH RECURSIVE cd (   
                        attr_id           
                       ,parent_attr_id    
                        --
                       ,impact_type       -- Nick 2015-08-29
                       ,attr_status     
                        --
                       ,attr_code         
                       ,attr_name         
                       ,attr_type_id      
                       ,attr_type_code    
                       ,attr_type_name  
                        -- Nick 2017-11-25
                       ,type_len          -- Длина типа
                       ,type_prec         -- Точность поля
                       ,base_name         -- Имя базового типа
                       ,type_category     -- Категория типа
                        -- Nick 2017-11-25
                       ,attr_uuid
                       ,attr_create_date  
                       ,is_intra_op       
                       ,date_from         
                       ,date_to           
                        -- 
                       ,tree_d            
                       ,level_d           
                       ,tree_name_d       
                       ,cycle_d
                       --
                       ,domain_nso_id    
                       ,domain_nso_code  
                       ,domain_nso_name  
                        --
                       ,id_log
                    ) AS ( SELECT 
                              d.attr_id::public.id_t         
                             ,d.parent_attr_id   
                              --  
                             ,l.impact_type    
                             ,CASE l.impact_type  
                                 WHEN '3' THEN  'Активный' 
                                 WHEN '4' THEN  'Удалённый' 
                                 WHEN '5' THEN  'Обновлённый' 
                                 WHEN '0' THEN  'Начальное состояние' 
                              END::public.t_str20 AS attr_status  
                              --
                           	,d.attr_code       
                           	,d.attr_name       
                           	,c.codif_id::public.id_t
                           	,c.codif_code::public.t_str60 
                           	,c.codif_name::public.t_str250
                               -- Nick 2017-11-25
                              ,CASE
                                WHEN ( t1.typname NOT IN ( 't_money', 't_decimal' ))
                                  THEN
                                    CASE  
                                       WHEN ((t1.typlen = -1) AND ( NOT t1.typbyval ) AND (t1.typcategory = 'S' ) AND (t1.typtypmod > 0)) 
                                       THEN
                                          (t1.typtypmod - 4)::public.t_int
                                       ELSE
                                            t1.typlen::public.t_int
                                    END
                                  ELSE
                                      t3.numeric_precision::public.t_int            
                               END AS type_len
                               --
                              ,CASE  
                                     WHEN ( t1.typname IN ( 't_money', 't_decimal' ) )
                                       THEN
                                           t3.numeric_scale::public.t_int 
                                       ELSE
                                           0::public.t_int            
                               END AS numerci_scale
                              ,t2.typname::public.t_str60
                              ,t1.typcategory::public.t_code1 
                               -- Nick 2017-11-25
                             ,d.attr_uuid
                             ,d.attr_create_date  
                             ,d.is_intra_op       
                             ,d.date_from         
                             ,d.date_to           
                             ,CAST ( ARRAY [d.attr_id::int8] AS public.t_arr_id)
                             ,1::public.small_t
                             ,btrim (CAST ( d.attr_name AS public.t_str250 ))
                             ,FALSE
                             --  Nick 2016-06-19
                             ,d.domain_nso_id
                             ,d.domain_nso_code
                             ,n.nso_name
                              --  Nick 2016-06-19
                             ,d.id_log
                            FROM com.nso_domain_column d
                               INNER JOIN      com.com_log l      ON ( d.id_log = l.id_log )  -- Nick 2015-08-29
                               INNER JOIN ONLY com.obj_codifier c ON (d.attr_type_id = c.codif_id)
                                      LEFT OUTER JOIN pg_type t1 ON (t1.typname = btrim(lower(c.codif_code)))  
                                           LEFT OUTER JOIN pg_type t2 ON ( t1.typbasetype = t2.oid )
                                      LEFT OUTER JOIN information_schema.domains t3 ON ( t3.domain_name = t1.typname )
                                      --
                               LEFT OUTER JOIN nso.nso_object n   ON ( d.domain_nso_id = n.nso_id )
                           WHERE ( d.attr_code = (upper (btrim (p_attr_code))))  

                           UNION ALL
                    
                           SELECT 
                                   d.attr_id::public.id_t          
                                  ,d.parent_attr_id  
                                   --  
                                  ,l.impact_type    
                                  ,CASE l.impact_type  
                                      WHEN '3' THEN  'Активный' 
                                      WHEN '4' THEN  'Удалённый' 
                                      WHEN '5' THEN  'Обновлённый' 
                                      WHEN '0' THEN  'Начальное состояние' 
                                   END::public.t_str20 AS attr_status  
                                   --
                                  ,d.attr_code       
                                  ,d.attr_name       
                                  ,c.codif_id::public.id_t 
                                  ,c.codif_code::public.t_str60 
                                  ,c.codif_name::public.t_str250
                                   -- Nick 2017-11-25
                                  ,CASE
                                    WHEN ( t1.typname NOT IN ( 't_money', 't_decimal' ))
                                      THEN
                                        CASE  
                                           WHEN ((t1.typlen = -1) AND ( NOT t1.typbyval ) AND (t1.typcategory = 'S' ) AND (t1.typtypmod > 0)) 
                                           THEN
                                              (t1.typtypmod - 4)::public.t_int
                                           ELSE
                                                t1.typlen::public.t_int
                                        END
                                      ELSE
                                          t3.numeric_precision::public.t_int            
                                   END AS type_len
                                   --
                                  ,CASE  
                                         WHEN ( t1.typname IN ( 't_money', 't_decimal' ) )
                                           THEN
                                               t3.numeric_scale::public.t_int 
                                           ELSE
                                               0::public.t_int            
                                   END AS numerci_scale
                                   --
                                  ,t2.typname::public.t_str60
                                  ,t1.typcategory::public.t_code1 
                                  -- Nick 2017-11-25
                                  ,d.attr_uuid
                                  ,d.attr_create_date  
                                  ,d.is_intra_op       
                                  ,d.date_from         
                                  ,d.date_to           
                                  ,CAST (x.tree_d::int8[] || d.attr_id::int8 AS public.t_arr_id)
                                  ,(x.level_d + 1)::public.small_t
                                  ,x.tree_name_d::public.t_str2048 || '-->' || d.attr_name::public.t_str250  
                                  ,d.attr_id = ANY ( x.tree_d )
                                  --  Nick 2016-06-19
                                  ,d.domain_nso_id
                                  ,d.domain_nso_code
                                  ,n.nso_name
                                   --  Nick 2016-06-19
                                  ,d.id_log

                             FROM com.nso_domain_column d
                               INNER JOIN com.com_log l      ON ( d.id_log = l.id_log )  -- Nick 2015-08-29
                               INNER JOIN com.obj_codifier c ON ( d.attr_type_id = c.codif_id )
                               LEFT OUTER JOIN pg_type t1 ON (t1.typname = btrim(lower(c.codif_code)))  
                                        LEFT OUTER JOIN pg_type t2 ON ( t1.typbasetype = t2.oid )
                               LEFT OUTER JOIN information_schema.domains t3 ON ( t3.domain_name = t1.typname )
                               --  
                               INNER JOIN cd x                  ON ( x.attr_id  = d.parent_attr_id ) AND ( NOT x.cycle_d ) 
                               LEFT OUTER JOIN nso.nso_object n ON ( d.domain_nso_id = n.nso_id )
                         ) 
                          SELECT  DISTINCT ON(s.attr_id) -- Nick 2015-08-29
                                   s.attr_id       
                                  ,s.parent_attr_id
                                   --  
                                  ,s.impact_type    
                                  ,s.attr_status  
                                   --
                                  ,s.attr_code        
                                  ,s.attr_name        
                                  ,s.attr_type_id           
                                  ,s.attr_type_code       
                                  ,s.attr_type_name  
                                   -- Nick 2017-11-25
                                  ,s.type_len         
                                  ,s.type_prec        
                                  ,s.base_name        
                                  ,s.type_category    
                                   -- Nick 2017-11-25   
                                  ,s.attr_uuid
                                  ,s.attr_create_date  
                                  ,s.is_intra_op       
                                  ,s.date_from         
                                  ,s.date_to           
                                  -- 
                                  ,s.tree_d       
                                  ,s.level_d::public.small_t      
                                  ,s.tree_name_d::public.t_str2048 
                                  --
                                  ,s.domain_nso_id
                                  ,s.domain_nso_code
                                  ,s.domain_nso_name
                                  ,s.id_log
                                  
                          FROM cd s
                          WHERE (s.date_from <= p_date) AND (s.level_d <= p_level_d)    --- AND p_date <= s.date_to Nick НА ДАТУ  2015-08-29
                       --   ORDER BY s.attr_id, s.date_from DESC, s.date_to DESC;
      ) AS u
             ORDER BY u.tree_d; --u.level_d, u.parent_attr_id, u.attr_id;
     END;
   $$
    STABLE
    SECURITY INVOKER -- 2015-04-05 Nick
    LANGUAGE plpgsql;


COMMENT ON FUNCTION com_domain.nso_f_domain_column_s ( public.t_str60, public.t_timestamp, public.t_int ) 
   IS '113: Список атрибутов, развёрнут по уровням иерархии, 
   
 Аргументы:
          1)   p_attr_code public.t_str60             -- Код атрибута
          2)  ,p_date      public.t_timestamp         -- Дата актуальности
          3)  ,p_level_d   public.t_int       = 99999 -- Уровень вложенности   
   
 Результат ТАБЛИЦА:

          1)    attr_id           public.id_t        -- Идентификатор атрибута
          2)   ,parent_attr_id    public.id_t        -- Идентификатор родительского атрибута

          3)    ,impact_type       public.t_code1     -- Код воздействия  
          4)    ,attr_status       public.t_str20     -- Статус атрибута

          5)   ,attr_code         public.t_str60     -- Код атрибута
          6)   ,attr_name         public.t_str250    -- Наименование атрибута
          7)   ,attr_type_id      public.id_t        -- Тип атрибута
          8)   ,attr_type_code    public.t_str60     -- Код типа атрибута
          9)   ,attr_type_name    public.t_str250    -- Наименование типа атрибута
                --  
         10)   ,type_len          public.t_int       -- Длина типа
         11)   ,type_prec         public.t_int       -- Точность поля
         12)   ,base_name         public.t_str60     -- Имя базового типа
         13)   ,type_category     public.t_code1     -- Категория типа
                --  
         14)   ,attr_uuid         public.t_guid      -- UUID атрибута
         15)   ,attr_create_date  public.t_timestamp -- Дата создания
         16)   ,is_intra_op       public.t_boolean   -- Признак итраоперабельности
         17)   ,date_from         public.t_timestamp -- Дата начала актуальности
         18)   ,date_to           public.t_timestamp -- Дата конца актуальности
                -- 
         19)   ,tree_d            public.t_arr_id    -- массив ID от текущей позиции
         20)   ,level_d           public.small_t     -- уровень от текущей позиции
         21)   ,tree_name_d       public.t_str2048   -- путь от текущей позиции
               --
         22)   ,domain_nso_id     public.id_t        -- Идентификатор НСО домена
         23)   ,domain_nso_code   public.t_str60     -- Код НСО домена
         24)   ,domain_nso_name   public.t_str250    -- Наименование домена   
         25)   ,id_log            public.id_t        -- Идентификатор журнала
';
-- ----------------------------------------------------------------------------------------------
-- SELECT * FROM plpgsql_check_function_tb ('com_domain.nso_f_domain_column_s (public.t_str60, public.t_timestamp, public.t_int)');	
-- ----------------------------------------------------------------------------------------------
-- SELECT * FROM com_domain.nso_f_domain_column_s ();
-- SELECT * FROM com_domain.nso_f_domain_column_s ('DOMAIN_NODE', '2019-05-24 11:03:09');
-- SELECT * FROM com_domain.nso_f_domain_column_s ('DOMAIN_NODE', '2016-12-01 10:00:00', 2);
-- SELECT * FROM com_domain.nso_f_domain_column_s ('APP_NODE');
-- SELECT * FROM com.nso_f_domain_column_s ('DOMAIN_NODE', '2015-09-01 10:00:00');
-- SELECT * FROM com.nso_f_domain_column_s ('APP_NODE', '2016-12-01 10:00:00');
-- SELECT * FROM com.nso_f_domain_column_s ('APP_NODE', now()::date, 2);
-- Суммарное время выполнения запроса: 200 ms.
-- 869 строк получено.
--
-- SELECT * FROM com.nso_f_domain_column_s ('DOMAIN_NODE');         -- 'Атрибуты для заполнения классификаторов'
-- SELECT * FROM com.nso_f_domain_column_s ('ATRIBUT_COMNON');     -- 'Общие атрибуты'
-- SELECT * FROM com.nso_f_domain_column_s ('TECHNICAL_ATRIBUTS'); -- 'Служебные атрибуты'
-- SELECT * FROM com.nso_f_domain_column_s ('ATR_OK');             -- 'Атрибуты Общероссийских классификаторов'
-- SELECT * FROM com.nso_f_domain_column_s ('TEST_ATR');           -- 'Тестовые атрибуты'
-- SELECT * FROM com.nso_f_domain_column_s ('ATR_CL_URI');         -- 'Атрибуты классификаторов УРИ'
-- SELECT * FROM com.nso_f_domain_column_s ('ATR_CL_URI');         -- 'Атрибуты классификаторов УРИ'
-- SELECT * FROM com.nso_f_domain_column_s ('xATR_CL_URI');        --  ОШИБКА, исключение не создаётся
--
-- SELECT * FROM com.nso_domain_column_hist;
--
-- select * from nso.nso_object;
