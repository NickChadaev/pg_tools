/*--------------------------------------------------------------------------------------------- 
   Описание:  f_show_unique_descr 
      Получаем описание ограничение уникальности, в нашем случае это первичный ключ и          
      альтернативный ключ. С альтернативным ключом всё просто, с первичным немного сложнее:   
      PK является CONSTRAINT и для него строится индекс по умолчанию. Поэтому он упоминается  
      сразу в двух таблицах: PG_INDEX и PG_CONSTRAINT. Описание его хранится в PG_DESCRIPTION 
      и связано только с PG_CONSTRAINT, запрос получился довольно громоздким.                 
  ---------------------------------------------------------------------------------------------     
   Входные параметры:
   	 p_schema_name  VARCHAR (20) -- Наименование схемы
      ,p_table_name   VARCHAR (64) -- Наименование объекта
      ,p_unique_name  VARCHAR (64) -- Наименование ограничения

   Выходные параметры: 
	 (
                   schema_name  VARCHAR  (20) -- Наименование схемы
                 , table_oid    INTEGER       -- OID таблицы
                 , table_name   VARCHAR  (64) -- Наименование таблицы
                 , table_desc   VARCHAR (250) -- Описание таблицы
                 , attr_number  SMALLINT      -- Номер атрибута 
                 , field_name   VARCHAR  (64) -- Наименование атрибута
                 , field_desc   VARCHAR (250) -- Описание атрибута
                 , index_oid    INTEGER       -- OID индекса  -- Nick 2014-04-16 
                 , index_name   VARCHAR  (64) -- Наименование уникальности 
                 , index_type   VARCHAR  (20) -- Тип уникальности
                 , index_desc   VARCHAR (250) -- Описание уникальности
	 )
    Пример использования:    
                  SELECT * FROM f_show_unique_descr ();       -- Все об уникальностях во всех схемах
                  SELECT * FROM f_show_unique_descr ( 'nso'); -- Уникальности в схеме НСО
                  SELECT * FROM f_show_unique_descr ( 'ind', 'ind_indicator'); -- Уникальности в схеме ПОКАЗАТЕЛЬ, таблица IND_INDICATOR

    История:
 	 Дата: 22.08.2013  NIck
 	       09/02/2014 - Выводит не только описания уникальностей, но и поисковые индексы
               16/04/2014 - Добавлен OID индекса.
    -- ------------------------
    2015-04-05  Добавлены: STABLE SECURITY DEFINER  
    2016-01-22  Типы сущностей согласованы с проектом ASK_U, 
    2016-01-07  Имя сущности - поиск по строгому соответствию.
    2016-01-12  Nick Опечатка в тексте. 
    ---------------------------------------------------------------------------------------------
     За основу взят текст из статьи: Лихачёв В. Н. "ОБРАБОТКА ОШИБОК ОГРАНИЧЕНИЙ ДЛЯ БАЗ ДАННЫХ   
                 POSTGRESQL".   Калужский университет.                                                        
    ----------------------------------------------------------------------------------------------*/
SET search_path=db_info, public, pg_catalog;    
DROP FUNCTION IF EXISTS f_show_unique_descr ( varchar, varchar, varchar );
CREATE OR REPLACE FUNCTION f_show_unique_descr  
	 (
       p_schema_name  VARCHAR (20) = NULL -- Наименование схемы
      ,p_table_name   VARCHAR (64) = NULL -- Наименование объекта
      ,p_unique_name  VARCHAR (64) = NULL -- Наименование ограничения
 	 ) 
RETURNS TABLE (
                 schema_name  VARCHAR  (20) -- Наименование схемы
               , table_oid    INTEGER       -- OID таблицы
               , table_name   VARCHAR  (64) -- Наименование таблицы
               , table_desc   VARCHAR (250) -- Описание таблицы
               , attr_number  SMALLINT      -- Номер атрибута 
               , field_name   VARCHAR  (64) -- Наименование атрибута
               , field_desc   VARCHAR (250) -- Описание атрибута
               , index_oid    INTEGER       -- OID индекса  -- Nick 2014-04-16 
               , index_name   VARCHAR  (64) -- Наименование уникальности 
               , index_type   VARCHAR  (20) -- Тип уникальности
               , index_desc   VARCHAR (250) -- Описание уникальности
              )
AS $$
	 BEGIN
	  RETURN QUERY 
               SELECT n.nspname::VARCHAR (20) AS schema_name
                     ,t.oid::INTEGER AS table_oid 
                     ,t.relname::VARCHAR (64) AS table_name
                     ,dt.description::VARCHAR (250) AS table_desc
                     ,a.attnum::SMALLINT AS attr_number 
                     ,a.attname::VARCHAR (64) AS field_name
                     ,df.description::VARCHAR (250) AS field_desc
                     ,i.indexrelid::INTEGER AS index_oid    -- Nick 2014-04-16 
                     ,c.relname::VARCHAR (64) AS index_name
                     , CASE
                           WHEN indisunique AND indisprimary THEN 'C_PRIMARY_KEY' -- 2016-01-12  Nick Опечатка в тексте. 
                           WHEN indisunique THEN 'C_UNIQUE_INDEX'
                           ELSE 'C_INDEX'
                       END::VARCHAR(20) AS index_type
                     , CASE 
                           WHEN di.description IS NULL THEN dc.description 
                           ELSE
                                di.description 
                       END::VARCHAR (250) AS index_desc 

               FROM pg_index i 
                       JOIN pg_class c ON ( c.oid = i.indexrelid )
                       JOIN pg_class t ON ( t.oid = i.indrelid )
                       JOIN pg_namespace n ON ( n.oid = t.relnamespace )
                       JOIN pg_attribute a ON (( t.oid = a.attrelid ) AND ( a.attnum = ANY ( i.indkey )))
                       LEFT OUTER JOIN pg_constraint cc ON ( cc.conindid  = c.oid ) AND ( c.relname = cc.conname )
                       --
                       LEFT OUTER JOIN pg_description df ON (( df.objoid = t.oid ) AND ( df.objsubid = a.attnum ))
                       LEFT OUTER JOIN pg_description dt ON (( dt.objoid = t.oid ) AND ( dt.objsubid = 0 ))
                       LEFT OUTER JOIN pg_description di ON ( di.objoid = i.indexrelid )
                       LEFT OUTER JOIN pg_description dc ON ( dc.objoid = cc.oid )    
               WHERE
                    ( n.nspname = COALESCE ( lower ( p_schema_name ), n.nspname  ) )
                AND ( t.relname = COALESCE ( lower ( p_table_name ), t.relname )) -- Nick 2016-01-07
                AND ( c.relname LIKE ( '%' || COALESCE ( lower ( p_unique_name ), c.relname ) || '%') ); 
    END;
	$$
	        STABLE            
                SECURITY DEFINER  
		LANGUAGE plpgsql;
--
COMMENT ON FUNCTION f_show_unique_descr ( varchar, varchar, varchar ) IS '4829: Получаем описание ограничение уникальности

   Область применения: Сервис.
   Входные параметры:
          p_schema_name  VARCHAR (20) -- Наименование схемы
         ,p_table_name   VARCHAR (64) -- Наименование объекта
         ,p_unique_name  VARCHAR (64) -- Наименование ограничения (не строгий поиск)

   Выходные параметры: 
	 (
                   schema_name  VARCHAR  (20) -- Наименование схемы
                 , table_oid    INTEGER       -- OID таблицы
                 , table_name   VARCHAR  (64) -- Наименование таблицы
                 , table_desc   VARCHAR (250) -- Описание таблицы
                 , attr_number  SMALLINT      -- Номер атрибута 
                 , field_name   VARCHAR  (64) -- Наименование атрибута
                 , field_desc   VARCHAR (250) -- Описание атрибута
                 , index_oid    INTEGER       -- OID индекса  -- Nick 2014-04-16 
                 , index_name   VARCHAR  (64) -- Наименование уникальности 
                 , index_type   VARCHAR  (20) -- Тип уникальности
                 , index_desc   VARCHAR (250) -- Описание уникальности
	 )
    Пример использования:    
                  SELECT * FROM f_show_unique_descr ();       -- Все об уникальностях во всех схемах
                  SELECT * FROM f_show_unique_descr ( ''nso''); -- Уникальности в схеме НСО
                  SELECT * FROM f_show_unique_descr ( ''ind'', ''ind_indicator''); -- Уникальности в схеме ПОКАЗАТЕЛЬ, таблица IND_INDICATOR

';
-- SELECT * FROM f_show_unique_descr ( 'nso') WHERE ( index_type= 'C_INDEX');
