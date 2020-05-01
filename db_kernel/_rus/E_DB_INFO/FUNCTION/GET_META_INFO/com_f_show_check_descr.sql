/*------------------------------------------------------------------------------------ 
   Описание:  f_show_check_descr 
   Получаем описание ограничения CHECK.
   Раздел или область применения: Сервис

   Входные параметры:
   	 p_schema_name  VARCHAR (20) 	 -- Наименование схемы
      ,p_obj_name     VARCHAR (64)   -- Наименование объекта
      ,p_check_name   VARCHAR (64)   -- Наименование ограничения

   Выходные параметры: 
	 (
                   schema_name  VARCHAR  (20)  -- Наименование схемы
                 , table_oid    INTEGER        -- OID таблицы
                 , table_name   VARCHAR  (64)  -- Наименование таблицы
                 , table_desc   VARCHAR (250)  -- Описание таблицы
                 , attr_number  SMALLINT       -- Номер атрибута 
                 , field_name   VARCHAR  (64)  -- Наименование атрибута
                 , field_desc   VARCHAR (250)  -- Описание атрибута
                 , check_name   VARCHAR  (64)  -- Наименование ограничения
                 , check_desc   VARCHAR (250)  -- Описание ограничения
                 , check_expr   VARCHAR (250)  -- Выражение ограничения
	 )
    Пример использования:    
                  SELECT * FROM f_show_check_descr ( 'obj', 'mil', 'chk' );

    История:
 	 Дата: 22.08.2013  NIck
    -- ------------------------
    2015-04-05  Добаввлены: STABLE  SECURITY DEFINER  
    2016-01-22  Типы сущностей согласованы с проектом ASK_U.       
     ---------------------------------------------------------------------------------------------
     За основу взят текст из статьи: Лихачёв В. Н. "ОБРАБОТКА ОШИБОК ОГРАНИЧЕНИЙ ДЛЯ БАЗ ДАННЫХ   
                 POSTGRESQL".   Калужский университет.                                                        
    ----------------------------------------------------------------------------------------------*/
SET search_path=db_info,public,pg_catalog;
DROP FUNCTION IF EXISTS f_show_check_descr ( varchar, varchar, varchar );
CREATE OR REPLACE FUNCTION f_show_check_descr  
	 (
   	 p_schema_name  VARCHAR (20) = NULL	 -- Наименование схемы
      ,p_table_name   VARCHAR (64) = NULL  -- Наименование таблицы
      ,p_check_name   VARCHAR (64) = NULL  -- Наименование ограничения
	 ) 
RETURNS TABLE (
                   schema_name  VARCHAR  (20) -- Наименование схемы
                 , table_oid    INTEGER       -- OID таблицы
                 , table_name   VARCHAR  (64) -- Наименование таблицы
                 , table_desc   VARCHAR (250) -- Описание таблицы
                 , attr_number  SMALLINT      -- Номер атрибута 
                 , field_name   VARCHAR  (64) -- Наименование атрибута
                 , field_desc   VARCHAR (250) -- Описание атрибута
                 , check_name   VARCHAR  (64) -- Наименование ограничения
                 , check_desc   VARCHAR (250) -- Описание ограничения
                 , check_expr   VARCHAR (250) -- Выражение ограничения
              )
AS $$
	 BEGIN
	  RETURN QUERY 
               SELECT n.nspname::VARCHAR (20)       AS schema_name
                     ,t.oid::INTEGER                AS table_oid 
                     ,t.relname::VARCHAR (64)       AS table_name
                     ,dt.description::VARCHAR (250) AS table_desc
                     ,a.attnum::SMALLINT            AS attr_number 
                     ,a.attname::VARCHAR  (64)      AS field_name
                     ,df.description::VARCHAR (250) AS field_desc
                     ,c.conname::VARCHAR  (64)      AS check_name
                     ,dc.description::VARCHAR (250) AS check_desc
                     ,c.consrc::VARCHAR (250)       AS check_expr 
               FROM pg_constraint c 
                       JOIN pg_class t ON ( t.oid = c.conrelid )
                       JOIN pg_namespace n ON ( n.oid = t.relnamespace )
                       JOIN pg_attribute a ON ( t.oid = a.attrelid ) AND ( a.attnum = ALL ( c.conkey) )   
                       -- 
                       LEFT OUTER JOIN pg_description df ON (( df.objoid = t.oid ) AND ( df.objsubid = a.attnum ))
                       LEFT OUTER JOIN pg_description dt ON (( dt.objoid = t.oid ) AND ( dt.objsubid = 0 ))
                       LEFT OUTER JOIN pg_description dc ON ( dc.objoid = c.oid )
               WHERE ( c.contype = 'c' )
                      AND ( n.nspname = COALESCE ( lower ( p_schema_name ), n.nspname ) ) 
                      AND ( t.relname LIKE ( '%' || COALESCE ( lower ( p_table_name ), t.relname ) || '%' ))
                      AND ( c.conname LIKE ( '%' || COALESCE ( lower ( p_check_name ), c.conname ) || '%' ));
    END;
	$$
		LANGUAGE plpgsql
      STABLE             -- 2015-04-05 Nick
      SECURITY DEFINER ;
--
COMMENT ON FUNCTION f_show_check_descr ( varchar, varchar, varchar ) IS 'Получаем описание ограничения CHECK

   Раздел или область применения: Сервис
   Входные параметры:
   	 p_schema_name  VARCHAR (20)   -- Наименование схемы
        ,p_obj_name     VARCHAR (64)   -- Наименование объекта
        ,p_check_name   VARCHAR (64)   -- Наименование ограничения

   Выходные параметры: 
	 (
                   schema_name  VARCHAR  (20)  -- Наименование схемы
                 , table_oid    INTEGER        -- OID таблицы
                 , table_name   VARCHAR  (64)  -- Наименование таблицы
                 , table_desc   VARCHAR (250)  -- Описание таблицы
                 , attr_number  SMALLINT       -- Номер атрибута 
                 , field_name   VARCHAR  (64)  -- Наименование атрибута
                 , field_desc   VARCHAR (250)  -- Описание атрибута
                 , check_name   VARCHAR  (64)  -- Наименование ограничения
                 , check_desc   VARCHAR (250)  -- Описание ограничения
                 , check_expr   VARCHAR (250)  -- Выражение ограничения
	 )
    Пример использования:    
                   SELECT * FROM f_show_check_descr ( ''obj'', ''mil'', ''chk'' );
';
--
-- SELECT * FROM db_info.f_show_check_descr ( 'com');
--
