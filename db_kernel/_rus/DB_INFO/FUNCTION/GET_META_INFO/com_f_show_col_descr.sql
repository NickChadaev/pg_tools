DROP FUNCTION IF EXISTS db_info.f_show_col_descr(character varying, character varying, character[]);

DROP FUNCTION IF EXISTS db_info.f_show_col_descr ( varchar, varchar, char [], text );

CREATE OR REPLACE FUNCTION db_info.f_show_col_descr

     (

       p_schema_name  VARCHAR (20) = NULL -- Наименование схемы

      ,p_obj_name     VARCHAR (64) = NULL -- Наименование объекта

      ,p_object_type  CHAR(1) []   = array ['r', 'v', 'm', 'c', 't', 'f', 'p'] -- Тип объекта 'r' - таблица, 'v' - представление.

      ,p_provider     text   = 'selinux'  -- Имя провайдера 

    )

RETURNS TABLE (

                  schema_name         VARCHAR  (20)  -- Наименование схемы

                , objoid              INTEGER        -- OID объекта

                , obj_type            VARCHAR  (20)  -- Тип объекта

                , obj_name            VARCHAR  (64)  -- Наименование объекта

                , attr_number         SMALLINT       -- Номер атрибута

                , column_name         VARCHAR  (64)  -- Наименование атрибута

                , type_name           VARCHAR  (64)  -- Наименование типа

                , type_len            INTEGER        -- Длина типа

                , type_prec           INTEGER        -- Точность поля

                , base_name           VARCHAR  (64)  -- Имя базового типа

                , type_category       CHAR(1)        -- Категория типа

                , column_description  VARCHAR (250)  -- Описание столбца

                , not_null            BOOLEAN        -- Признак NOT NULL

                , has_default         BOOLEAN        -- Признак DEFAULT VALUE

                , default_value       TEXT           -- Значение по умолчанию

                , seclabel            TEXT           -- Метка безопасности

              )

AS 

 $$

/*------------------------------------------------------------------------------------

   Описание  f_show_col_descr

   Получение описание столбцов таблицы/представления.

   Необходимо доработать блок, выводящий информацию о типе столбца.

   Раздел или область применения: Сервис



    История:

     Дата: 22.08.2013  NIck

     -- ------------------------

    2015-04-05  Добавлены:

                  STABLE  SECURITY DEFINER

    2016-01-22  Типы сущностей согласованы с проектом ASK_U,

                 добавлены новые типы: 't' - pg_toast, 'c' - user defined type

    2016-02-12 Roman - Длина отображается корректно.

    2017-05-19 Nick  - длина отображается ещё корректнее

    2019-02-26 Новый тип сущности: внешняя таблица.

    2020-01-23 Новый тип сущности: секционированная таблица 

    ---------------------------------------------------------------------------------------------

     За основу взят текст из статьи: Лихачёв В. Н. "ОБРАБОТКА ОШИБОК ОГРАНИЧЕНИЙ ДЛЯ БАЗ ДАННЫХ

                 POSTGRESQL".   Калужский университет.

    ----------------------------------------------------------------------------------------------*/



     DECLARE  

        C_NUM_TYPES text [] := ARRAY ['t_money', 't_decimal', 'money', 'numeric', 'decimal'];

       

     BEGIN

      RETURN QUERY

          SELECT

               n.nspname::VARCHAR(20) AS schema_name

             , c.oid::INTEGER AS objoid

             , CASE c.relkind

                    WHEN 'r' THEN 'C_TABLE'
                    WHEN 'v' THEN 'C_VIEW'
                    WHEN 'm' THEN 'C_MAT_VIEW'
                    WHEN 'c' THEN 'C_TYPE' 
                    WHEN 't' THEN 'C_PG_TOAST'
                    WHEN 'f' THEN 'C_FTABLE' -- 2019-02-26
                    WHEN 'p' THEN 'C_STABLE' -- 2020-01-23
                   ELSE 'C_UNDEF'
               END::varchar(20)         AS obj_type

             , c.relname::VARCHAR(64)   AS obj_name

             , a.attnum::SMALLINT       AS attr_number

             , a.attname::VARCHAR  (64) AS column_name

             , t1.typname::VARCHAR (64) AS type_name

               -- Nick 2017-05-19

             , 

               CASE

                WHEN NOT (t1.typname = ANY (C_NUM_TYPES))

                    THEN -- Nick 2019-02-27

                       COALESCE (t2.character_maximum_length, (

                          CASE  

                             WHEN ((t1.typlen = -1) AND ( NOT t1.typbyval ) and (t1.typcategory = 'S' ) AND 

                                   (t1.typtypmod > 0)

                                  ) 

                             THEN

                                (t1.typtypmod - 4)::INTEGER 

                             ELSE

                                  t1.typlen::INTEGER 

                          END

                         )

                       ) -- Nick 2019-02-27            

                         ELSE

                              t2.numeric_precision::INTEGER             

                END AS type_len

                --

              , CASE  

                     WHEN ( t1.typname = ANY (C_NUM_TYPES))

                       THEN

                           t2.numeric_scale::INTEGER 

                       ELSE

                           0::INTEGER             

                END AS numerci_scale

               -- 

             , t2.data_type::VARCHAR (64) AS base_name

             , t1.typcategory::CHAR(1)  

               -- Nick 2017-05-19

             , d.description::VARCHAR (250) AS column_description

             , a.attnotnull::BOOLEAN   AS not_null

             , a.atthasdef::BOOLEAN    AS has_default

             , t2.column_default::TEXT AS default_value

             , sl.label  AS seclabel

             

          FROM pg_namespace n

                INNER JOIN pg_class c     ON ( n.oid = c.relnamespace )

                INNER JOIN pg_attribute a ON (( a.attrelid = c.oid ) AND ( a.attnum > 0 ))

                INNER JOIN pg_type t1     ON ( a.atttypid = t1.oid )

                LEFT OUTER join information_schema.columns t2 ON 

                            (t2.table_schema = n.nspname) AND (t2.table_name = c.relname) AND

                            (t2.ordinal_position = a.attnum)

                LEFT OUTER JOIN pg_description d ON ((d.objoid = a.attrelid) AND (a.attnum = d.objsubid))

                LEFT OUTER JOIN                              

                 LATERAL ( SELECT s.label, s.objoid, s.objsubid FROM pg_seclabels s

                           WHERE (s.objoid = c.oid) AND (s.objsubid = a.attnum) AND

                                 (s.objtype = 'column') AND (s.provider = btrim(lower(p_provider)))            

            

            ) sl ON (sl.objoid = c.oid) AND (sl.objsubid = a.attnum)                            

          WHERE

               ( c.relkind = ANY (p_object_type ))

           AND ( n.nspname = COALESCE ( lower ( p_schema_name ), n.nspname ) )

           AND ( c.relname = COALESCE ( lower (btrim ( p_obj_name )), c.relname ))

        ORDER BY c.relname, a.attnum;

    END;

    $$

        SET search_path=db_info, public, pg_catalog

        STABLE

        SECURITY DEFINER

        LANGUAGE plpgsql;



COMMENT ON FUNCTION db_info.f_show_col_descr (varchar, varchar, char[], text) 

                                IS '286: Получение описание столбцов таблицы/представления



   Раздел или область применения: Сервис

   Входные параметры:

       p_schema_name    VARCHAR (20)    -- Наименование схемы

      ,p_obj_name       VARCHAR (64)    -- Наименование объекта

      ,p_object_type    CHAR(1) []      -- Тип объекта ''r'' - таблица, ''v'' - представление, ''t'' - pg_toast, ''c'' - user defined type.

      ,p_provider       TEXT   = ''selinux''  -- Имя провайдера безопасности



   Выходные параметры:

    (

                  schema_name         VARCHAR  (20)  -- Наименование схемы

                , objoid              INTEGER        -- OID объекта

                , obj_type            VARCHAR  (20)  -- Тип объекта

                , obj_name            VARCHAR  (64)  -- Наименование объекта

                , attr_number         SMALLINT       -- Номер атрибута

                , column_name         VARCHAR  (64)  -- Наименование атрибута

                , type_name           VARCHAR  (64)  -- Наименование типа

                , type_len            INTEGER        -- Длина типа

                , type_prec           INTEGER        -- Точность поля

                , base_name           VARCHAR  (64)  -- Имя базового типа

                , type_category       CHAR(1)        -- Категория типа

                , column_description  VARCHAR (250)  -- Описание столбца

                , not_null            BOOLEAN        -- Признак NOT NULL

                , has_default         BOOLEAN        -- Признак DEFAULT VALUE

                , default_value       TEXT           -- Значение по умолчанию 

		        ,seclabel            TEXT           -- Метка безопаснос                

    )

    Пример использования:

             SELECT * FROM f_show_col_descr (); -- Все таблицы во всех схемах.

             SELECT * FROM f_show_col_descr ( NULL, NULL, ARRAY[''v''] ) ORDER BY schema_name, obj_name;  -- Все представления.

             SELECT * FROM f_show_col_descr ( ''obj'', NULL, ARRAY [''v'', ''r''] ) ORDER BY schema_name, obj_name, attr_number; -- Все представления в схеме "Объекты".

    

    Категории типа:

          A - Массив

          B - Логический

          C - Составной

          D - Дата/время

          E - Перечисление

          G - Геометрический

          I - Сетевой адрес

          N - Число

          P - Псевдотип

          R - Диапазон 

          S - Строка

          T - Интервал

          U - Пользовательский

          V - Битовая строка

          X - Неизвестный тип (unknown)

';

--



