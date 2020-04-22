/*----------------------------------------------------------------------------------------- 
   Описание:  f_show_ufk_descr 
   Получаем описание UNIQUE CONSTRAINT которые определяются внешними ссылками.
   Раздел или область применения: Сервис

   Входные параметры:
   	 p_schema_name      VARCHAR (20) -- Наименование схемы
      ,p_table_name       VARCHAR (64) -- Наименование таблицы
      ,p_unique_name      VARCHAR (64) -- Наименование уникальности
      ,p_ref_name         VARCHAR (64) -- Наименование FK
   	 p_ref_schema_name  VARCHAR (20) -- Наименование родительской схемы
      ,p_ref_table_name   VARCHAR (64) -- Наименование родительской таблицы

   Выходные параметры: 
	 (
            schema_name           VARCHAR  (20) -- Наименование схемы
           ,table_name            VARCHAR  (64) -- Наименование таблицы
           ,table_desc            VARCHAR (250) -- Описание таблицы
           --
           ,attr_num              SMALLINT      -- Номер столбца
           ,attr_name             VARCHAR  (64) -- Наименование столбца
           ,not_null              BOOLEAN       -- Признак NOT NULL 
           ,attr_desc             VARCHAR (250) -- Описание атрибута
           --
           ,unique_name           VARCHAR  (64) -- Наименование ограничения уникальности
           ,unique_constrant_type VARCHAR  (20) -- Тип ограничения уникальности
           ,unique_description    VARCHAR (250) -- Описание уникальности
           --
           ,fk_constraint_name    VARCHAR  (64) -- Наименование ссылки
           ,fk_constraint_descr   VARCHAR (250) -- Описание ссылки
           --  
           ,ref_schema            VARCHAR  (20) -- Наименование родительской схемы
           ,ref_table             VARCHAR  (64) -- Наименование родительской таблицы
           ,ref_table_desc        VARCHAR (250) -- Описание родительской таблицы
           --
           ,ref_attr_num          SMALLINT      -- Номер родительского атрибута                
           ,ref_field_name        VARCHAR  (64) -- Наименование родительского атрибута 
           ,ref_not_null          BOOLEAN       -- Признак NOT NULL                   
           ,ref_field_desc        VARCHAR (250) -- Описание родительского атрибута         
	  )
    Пример использования:    
            SELECT * FROM f_show_ufk_descr ( );       -- Просматриваю все схемы
            SELECT * FROM f_show_ufk_descr ( 'ind' ); -- Только в пределах схемы IND
            SELECT * FROM f_show_ufk_descr ( 'ind', 'ind_indicator'); -- Только таблица IND_INDICATOR
            SELECT * FROM f_show_ufk_descr ( 'obj', null, null, null, 'obj', null ); -- Ссылки внутри схемы ОБЪЕКТЫ

    История:
 	 Дата: 22.08.2013  Nick
    -- ------------------------
    2015-04-05  Добавлены: STABLE SECURITY DEFINER   	 
    2016-01-22  Типы сущностей согласованы с проектом ASK_U, 
    2017-01-12  Исправления в типах сущностей.
    ---------------------------------------------------------------------------------------------
     За основу взят текст из статьи: Лихачёв В. Н. "ОБРАБОТКА ОШИБОК ОГРАНИЧЕНИЙ ДЛЯ БАЗ ДАННЫХ   
                 POSTGRESQL".   Калужский университет.                                                        
    ----------------------------------------------------------------------------------------------*/
SET search_path=db_info, public, pg_catalog;    
DROP FUNCTION IF EXISTS f_show_ufk_descr ( varchar, varchar, varchar, varchar, varchar, varchar );
CREATE OR REPLACE FUNCTION f_show_ufk_descr  
	 (
   	   p_schema_name     VARCHAR (20) = NULL   -- Наименование схемы
        ,p_table_name      VARCHAR (64) = NULL   -- Наименование таблицы
        ,p_unique_name     VARCHAR (64) = NULL   -- Наименование UNIQUE CONSTRAINT
   	  ,p_fk_name         VARCHAR (64) = NULL   -- Наименование FK
        ,p_ref_schema_name VARCHAR (20) = NULL   -- Наименование родительской схемы
        ,p_ref_table_name  VARCHAR (64) = NULL   -- Наименование родительской таблицы
	 ) 
RETURNS TABLE (
                  schema_name           VARCHAR  (20) -- Наименование схемы
                 ,table_name            VARCHAR  (64) -- Наименование таблицы
                 ,table_desc            VARCHAR (250) -- Описание таблицы
                 --
                 ,attr_num              SMALLINT      -- Номер столбца
                 ,attr_name             VARCHAR  (64) -- Наименование столбца
                 ,not_null              BOOLEAN       -- Признак NOT NULL 
                 ,attr_desc             VARCHAR (250) -- Описание атрибута
                 --
                 ,unique_name           VARCHAR  (64) -- Наименование ограничения уникальности
                 ,unique_constrant_type VARCHAR  (20) -- Тип ограничения уникальности
                 ,unique_description    VARCHAR (250) -- Описание уникальности
                 --
                 ,fk_constraint_name    VARCHAR  (64) -- Наименование ссылки
                 ,fk_constraint_descr   VARCHAR (250) -- Описание ссылки
                 --  
                 ,ref_schema            VARCHAR  (20) -- Наименование родительской схемы
                 ,ref_table             VARCHAR  (64) -- Наименование родительской таблицы
                 ,ref_table_desc        VARCHAR (250) -- Описание родительской таблицы
                 --
                 ,ref_attr_num          SMALLINT      -- Номер родительского атрибута                
                 ,ref_field_name        VARCHAR  (64) -- Наименование родительского атрибута 
                 ,ref_not_null          BOOLEAN       -- Признак NOT NULL                   
                 ,ref_field_desc        VARCHAR (250) -- Описание родительского атрибута         
              )
AS $$
	 BEGIN
	  RETURN QUERY 
        SELECT DISTINCT 
            ns.nspname::VARCHAR(20) AS schema_name
           ,t.relname::VARCHAR(64) AS table_name
           ,dst.description::VARCHAR(250) AS table_desc
            --
           ,a.attnum::SMALLINT AS attr_num  
           ,a.attname::VARCHAR (64) AS column_name
           ,a.attnotnull::BOOLEAN AS not_null
           ,ds.description::VARCHAR (250) AS column_desc
           --
           ,c.relname::VARCHAR(64)AS constrant_name
           --
           ,CASE
                WHEN i.indisunique AND i.indisprimary THEN 'C_PRIMARY_KEY' -- Nick 2017-01-12
                WHEN i.indisunique THEN 'C_UNIQUE_INDEX'
                ELSE 'C_INDEX'
            END::VARCHAR (20) AS unique_constrant_type
            ,CASE 
                   WHEN dsxk.description IS NULL THEN dspk.description 
                     ELSE
                          dsxk.description 
             END::VARCHAR (250) AS unique_description
           --
           ,f1.conname::VARCHAR (64) AS fk_constraint_name
           ,dsfk.description::VARCHAR (250) AS fk_constraint_descr 
           -- 
           ,nsf.nspname::VARCHAR (20) AS ref_schema_name
           ,tf.relname::VARCHAR (64) AS ref_table_name
           ,dstf.description::VARCHAR (250) AS ref_table_desc
           -- 
           ,af.attnum::SMALLINT AS ref_attr_num  
           ,af.attname::VARCHAR (64)AS ref_column_name
           ,af.attnotnull::BOOLEAN AS ref_not_null
           ,dsf.description::VARCHAR (250) AS ref_column_desc
        FROM pg_index i
             LEFT OUTER JOIN pg_description dsxk ON ( dsxk.objoid = i.indexrelid )  
             --
             JOIN pg_constraint f1 ON (( string_to_array ( array_to_string ( i.indkey, ','), ',' ) @> string_to_array ( array_to_string ( f1.conkey, ',' ), ',') )
                                         AND ( f1.contype = ANY ( ARRAY ['f'] ) )
                                         AND ( i.indrelid = f1.conrelid ) 
                                      )
             LEFT OUTER JOIN pg_description dsfk ON ( dsfk.objoid = f1.oid ) AND ( f1.contype = ANY ( ARRAY ['f'] ))
        
             JOIN pg_class t ON ( t.oid = i.indrelid )
             LEFT OUTER JOIN pg_description dst  ON ( dst.objoid  = t.oid ) AND ( dst.objsubid  = 0 )
             --
             JOIN pg_class tf ON ( tf.oid = f1.confrelid )          -- Foreing namespace
             JOIN pg_namespace nsf ON ( nsf.oid = tf.relnamespace ) -- Foreing namespace 
             LEFT OUTER JOIN pg_description dstf ON (( dstf.objoid = tf.oid ) AND ( dstf.objsubid = 0 ))
             -- 
             JOIN pg_class c ON (( t.oid = i.indrelid ) AND ( c.oid = i.indexrelid ))
             LEFT OUTER JOIN pg_namespace ns ON ( ns.oid = c.relnamespace )
             --
             JOIN pg_attribute a ON (( a.attrelid = t.oid ) AND ( a.attnum = ANY ( f1.conkey ))) 
             LEFT OUTER JOIN pg_description ds ON ( ds.objoid = a.attrelid  ) AND ( a.attnum = ds.objsubid )
             --
             LEFT OUTER JOIN pg_description dspk ON ( dspk.objoid = f1.oid ) -- Description of primary key
             --
             JOIN pg_attribute af  ON (( af.attrelid = tf.oid ) 
                                          AND ( af.attnum = ANY ( f1.confkey )) 
                                          AND ( position ( cast ( a.attnum AS VARCHAR ) IN array_to_string ( f1.conkey, ',' )) =
                                                position ( cast ( af.attnum AS VARCHAR ) IN array_to_string ( f1.confkey, ',' ))
                                              )
                                      ) -- Foreing attribute
             LEFT OUTER JOIN pg_description dsf  ON ( dsf.objoid  = af.attrelid ) AND ( af.attnum = dsf.objsubid )
        
        WHERE  ( i.indisunique OR i.indisprimary )  
  	               AND ( ns.nspname = COALESCE ( p_schema_name, ns.nspname ))                      --  Наименование схемы
                  AND ( t.relname  LIKE '%' || COALESCE ( p_table_name, t.relname ) || '%' )      --  Наименование таблицы
                  AND ( c.relname  LIKE '%' || COALESCE ( p_unique_name, c.relname ) || '%' )     --  Наименование UNIQUE
                  AND ( f1.conname LIKE '%' || COALESCE ( p_fk_name, f1.conname ) || '%' )        --  Наименование ссылки
                  AND ( nsf.nspname = COALESCE ( p_ref_schema_name, nsf.nspname ))                --  Наименование родительской схемы
                  AND ( tf.relname LIKE '%' || COALESCE ( p_ref_table_name, tf.relname ) || '%'); --  Наименование родительской таблицы
    END;
	$$    
          STABLE            
          SECURITY DEFINER  
	  LANGUAGE plpgsql;

COMMENT ON FUNCTION f_show_ufk_descr ( varchar, varchar, varchar, varchar, varchar, varchar ) IS '4841: Получаем описание UNIQUE CONSTRAINT которые определяются внешними ссылками

   Получаем описание UNIQUE CONSTRAINT которые определяются внешними ссылками.
   Раздел или область применения: Сервис

   Входные параметры:
       p_schema_name      VARCHAR (20) -- Наименование схемы
      ,p_table_name       VARCHAR (64) -- Наименование таблицы
      ,p_unique_name      VARCHAR (64) -- Наименование уникальности
      ,p_ref_name         VARCHAR (64) -- Наименование FK
      ,p_ref_schema_name  VARCHAR (20) -- Наименование родительской схемы
      ,p_ref_table_name   VARCHAR (64) -- Наименование родительской таблицы

   Выходные параметры: 
	 (
            schema_name           VARCHAR  (20) -- Наименование схемы
           ,table_name            VARCHAR  (64) -- Наименование таблицы
           ,table_desc            VARCHAR (250) -- Описание таблицы
           --
           ,attr_num              SMALLINT      -- Номер столбца
           ,attr_name             VARCHAR  (64) -- Наименование столбца
           ,not_null              BOOLEAN       -- Признак NOT NULL 
           ,attr_desc             VARCHAR (250) -- Описание атрибута
           --
           ,unique_name           VARCHAR  (64) -- Наименование ограничения уникальности
           ,unique_constrant_type VARCHAR  (20) -- Тип ограничения уникальности
           ,unique_description    VARCHAR (250) -- Описание уникальности
           --
           ,fk_constraint_name    VARCHAR  (64) -- Наименование ссылки
           ,fk_constraint_descr   VARCHAR (250) -- Описание ссылки
           --  
           ,ref_schema            VARCHAR  (20) -- Наименование родительской схемы
           ,ref_table             VARCHAR  (64) -- Наименование родительской таблицы
           ,ref_table_desc        VARCHAR (250) -- Описание родительской таблицы
           --
           ,ref_attr_num          SMALLINT      -- Номер родительского атрибута                
           ,ref_field_name        VARCHAR  (64) -- Наименование родительского атрибута 
           ,ref_not_null          BOOLEAN       -- Признак NOT NULL                   
           ,ref_field_desc        VARCHAR (250) -- Описание родительского атрибута         
	  )
    Пример использования:    
            SELECT * FROM f_show_ufk_descr ( );       -- Просматриваю все схемы
            SELECT * FROM f_show_ufk_descr ( ''ind'' ); -- Только в пределах схемы IND
            SELECT * FROM f_show_ufk_descr ( ''ind'', ''ind_indicator''); -- Только таблица IND_INDICATOR
            SELECT * FROM f_show_ufk_descr ( ''obj'', null, null, null, ''obj'', null ); -- Ссылки внутри схемы ОБЪЕКТЫ

';
-- SELECT * FROM  f_show_ufk_descr ('rsk'); 
