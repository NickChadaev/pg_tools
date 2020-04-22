/*------------------------------------------------------------------------------------ 
   Описание:  f_show_check_descr 
   Получаем описание ограничения FK.
   Раздел или область применения: Сервис

   Входные параметры:
   	 p_schema_name     VARCHAR (20) 	 -- Наименование схемы
      ,p_table_name      VARCHAR (64)   -- Наименование таблицы
      ,p_fk_name         VARCHAR (64)   -- Наименование ссылки
   	 p_ref_schema_name VARCHAR (20) 	 -- Наименование родительской схемы
      ,p_ref_table_name  VARCHAR (64)   -- Наименование родительской таблицы

   Выходные параметры: 
	 (
                 schema_name    VARCHAR  (20) -- Наименование схемы
                 table_name     VARCHAR  (64) -- Наименование таблицы
                 table_desc     VARCHAR (250) -- Описание таблицы
                 constr_name    VARCHAR  (64) -- Наименование ссылки
                 constr_descr   VARCHAR (250) -- Описание ссылки
                 attr_number    SMALLINT      -- Номер атрибута
                 field_name     VARCHAR  (64) -- Наименование атрибута
                 not_null       BOOLEAN       -- Признак NOT NULL
                 field_desc     VARCHAR (250) -- Описание атрибута
                 ref_schema     VARCHAR  (20) -- Наименование родительской схемы
                 ref_table      VARCHAR  (64) -- Наименование родительской таблицы
                 ref_table_desc VARCHAR (250) -- Описание родительской таблицы
                 ref_attr_num   SMALLINT      -- Номер родительского атрибута                
                 ref_field_name VARCHAR  (64) -- Наименование родительского атрибута 
                 ref_not_null   BOOLEAN       -- Признак NOT NULL                   
                 ref_field_desc VARCHAR (250) -- Описание родительского атрибута         
                 update_action  VARCHAR  (20) -- действия при обновлении
                 delete_action  VARCHAR  (20) -- действие при удалении
                 ct_conkey      VARCHAR  (64) -- индесный массив
                 ct_confkey     VARCHAR  (64) -- родительский индексный массив
	 )
    Пример использования:    
                  SELECT * FROM f_show_fk_descr ();   -- все FK во всех схемах.
                  SELECT * FROM f_show_fk_descr ('nso');  -- все FK в схеме НСО
                  SELECT * FROM f_show_fk_descr (null, null, null, 'nso', null);  -- все кто ссылается на схему НСО
    
    История:
 	 Дата: 22.08.2013  Nick
    -- ------------------------
    2015-04-05  Добаввлены:
          STABLE            
          SECURITY DEFINER  
    ---------------------------------------------------------------------------------------------
     За основу взят текст из статьи: Лихачёв В. Н. "ОБРАБОТКА ОШИБОК ОГРАНИЧЕНИЙ ДЛЯ БАЗ ДАННЫХ   
                 POSTGRESQL".   Калужский университет.                                                        
    ----------------------------------------------------------------------------------------------*/
SET search_path=db_info, public, pg_catalog;    
DROP FUNCTION IF EXISTS f_show_fk_descr ( varchar, varchar, varchar, varchar, varchar );
CREATE OR REPLACE FUNCTION f_show_fk_descr  
	 (
   	 p_schema_name     VARCHAR (20) = NULL	  -- Наименование схемы
      ,p_table_name      VARCHAR (64) = NULL   -- Наименование таблицы
      ,p_fk_name         VARCHAR (64) = NULL   -- Наименование ссылки
   	,p_ref_schema_name VARCHAR (20) = NULL   -- Наименование родительской схемы
      ,p_ref_table_name  VARCHAR (64) = NULL   -- Наименование родительской таблицы
	 ) 
RETURNS TABLE (
                  schema_name    VARCHAR  (20) -- Наименование схемы
                 ,table_name     VARCHAR  (64) -- Наименование таблицы
                 ,table_desc     VARCHAR (250) -- Описание таблицы
                 ,constr_name    VARCHAR  (64) -- Наименование ссылки
                 ,constr_descr   VARCHAR (250) -- Описание ссылки
                 ,attr_number    SMALLINT      -- Номер атрибута
                 ,field_name     VARCHAR  (64) -- Наименование атрибута
                 ,not_null       BOOLEAN       -- Признак NOT NULL
                 ,field_desc     VARCHAR (250) -- Описание атрибута
                 ,ref_schema     VARCHAR  (20) -- Наименование родительской схемы
                 ,ref_table      VARCHAR  (64) -- Наименование родительской таблицы
                 ,ref_table_desc VARCHAR (250) -- Описание родительской таблицы
                 ,ref_attr_num   SMALLINT      -- Номер родительского атрибута                
                 ,ref_field_name VARCHAR  (64) -- Наименование родительского атрибута 
                 ,ref_not_null   BOOLEAN       -- Признак NOT NULL                   
                 ,ref_field_desc VARCHAR (250) -- Описание родительского атрибута         
                 ,update_action  VARCHAR  (20) -- действия при обновлении
                 ,delete_action  VARCHAR  (20) -- действие при удалении
                 ,ct_conkey      VARCHAR  (64) -- индесный массив
                 ,ct_confkey     VARCHAR  (64) -- родительский индексный массив
              )
AS $$
	 BEGIN
	  RETURN QUERY 
               SELECT
                   nc.nspname::VARCHAR (20) AS schema_name
                  ,c.relname::VARCHAR (64) AS table_name
                  ,dst.description::VARCHAR (250) AS table_desc
                  -- 
                  ,ct.conname::VARCHAR (64) AS constr_name
                  ,dsfk.description::VARCHAR (250) AS constr_descr
                  -- 
                  ,a.attnum::SMALLINT AS attr_number  
                  ,a.attname::VARCHAR (64) AS field_name
                  ,a.attnotnull::BOOLEAN AS not_null
                  ,ds.description::VARCHAR (250) AS field_desc
                  --
                  ,nf.nspname::VARCHAR(20) AS ref_schema
                  ,cf.relname::VARCHAR(64) AS ref_table
                  ,dstf.description::VARCHAR(250) AS ref_table_desc
                  --
                  ,af.attnum::SMALLINT AS ref_attr_num 
                  ,af.attname::VARCHAR (64) AS ref_field_name
                  ,a.attnotnull::BOOLEAN  AS ref_not_null
                  ,dsf.description::VARCHAR (250) AS ref_field_desc
               
                  ,CASE confupdtype
                     WHEN 'a' THEN 'NO ACTION'
                     WHEN 'r' THEN 'RESTRICT'
                     WHEN 'c' THEN 'CASCADE'
                     WHEN 'n' THEN 'SET NULL'
                     WHEN 'd' THEN 'SET DEFAULT'
                   END::VARCHAR(20) AS update_action
               
                  ,CASE confdeltype
                     WHEN 'a' THEN 'NO ACTION'
                     WHEN 'r' THEN 'RESTRICT'
                     WHEN 'c' THEN 'CASCADE'
                     WHEN 'n' THEN 'SET NULL'
                     WHEN 'd' THEN 'SET DEFAULT'
                   END::VARCHAR(20) AS delete_action
               
                  ,( array_to_string ( ct.conkey, ',') )::VARCHAR(64)  AS ct_conkey
                  ,( array_to_string ( ct.confkey, ',') )::VARCHAR(64) AS ct_confkey
               
                  FROM pg_constraint ct
                     JOIN pg_class c      ON ( c.oid  = ct.conrelid )
                     JOIN pg_class cf     ON ( cf.oid = ct.confrelid ) -- Foreign table
                     -- 
                     JOIN pg_attribute a  ON (( a.attrelid = c.oid ) AND ( a.attnum = ANY ( ct.conkey )))
                     --               
                     JOIN pg_attribute af ON (( af.attrelid = cf.oid ) 
                                                 AND ( af.attnum = ANY ( ct.confkey )) 
                                                 AND ( position ( cast ( a.attnum AS VARCHAR ) IN array_to_string ( ct.conkey, ',' )) =
                                                       position ( cast ( af.attnum AS VARCHAR ) IN array_to_string ( ct.confkey, ',' )))
                                             )
                     --
                     JOIN pg_namespace nc  ON ( nc.oid = c.relnamespace  )
                     JOIN pg_namespace nf  ON ( nf.oid = cf.relnamespace )
                     --
                     LEFT OUTER JOIN pg_description ds   ON ( ds.objoid   = a.attrelid  ) AND ( a.attnum = ds.objsubid )
                     LEFT OUTER JOIN pg_description dsf  ON ( dsf.objoid  = af.attrelid ) AND ( af.attnum = dsf.objsubid )
                     LEFT OUTER JOIN pg_description dst  ON ( dst.objoid  = c.oid       ) AND ( dst.objsubid  = 0 )
                     LEFT OUTER JOIN pg_description dstf ON ( dstf.objoid = af.attrelid ) AND ( dstf.objsubid = 0 )
                     --
                     LEFT OUTER JOIN pg_description dsfk ON ( dsfk.objoid = ct.oid )
               WHERE ( contype = 'f' )
  	               AND ( nc.nspname = COALESCE ( p_schema_name, nc.nspname ))                      --  Наименование схемы
                  AND ( c.relname  LIKE '%' || COALESCE ( p_table_name, c.relname ) || '%' )      --  Наименование таблицы
                  AND ( ct.conname LIKE '%' || COALESCE ( p_fk_name, ct.conname ) || '%' )        --  Наименование ссылки
                  AND ( nf.nspname = COALESCE ( p_ref_schema_name, nf.nspname ))                  --  Наименование родительской схемы
                  AND ( cf.relname LIKE '%' || COALESCE ( p_ref_table_name, cf.relname ) || '%'); --  Наименование родительской таблицы
    END;
	$$
	        STABLE            
                SECURITY DEFINER  
		LANGUAGE plpgsql;
--
COMMENT ON FUNCTION f_show_fk_descr ( varchar, varchar, varchar, varchar, varchar ) IS 'Получаем описание ограничения FK

   Раздел или область применения: Сервис
   Входные параметры:
       p_schema_name     VARCHAR (20) 	 -- Наименование схемы
      ,p_table_name      VARCHAR (64)   -- Наименование таблицы
      ,p_fk_name         VARCHAR (64)   -- Наименование ссылки
      ,p_ref_schema_name VARCHAR (20) 	 -- Наименование родительской схемы
      ,p_ref_table_name  VARCHAR (64)   -- Наименование родительской таблицы

   Выходные параметры: 
	 (
                 schema_name    VARCHAR  (20) -- Наименование схемы
                 table_name     VARCHAR  (64) -- Наименование таблицы
                 table_desc     VARCHAR (250) -- Описание таблицы
                 constr_name    VARCHAR  (64) -- Наименование ссылки
                 constr_descr   VARCHAR (250) -- Описание ссылки
                 attr_number    SMALLINT      -- Номер атрибута
                 field_name     VARCHAR  (64) -- Наименование атрибута
                 not_null       BOOLEAN       -- Признак NOT NULL
                 field_desc     VARCHAR (250) -- Описание атрибута
                 ref_schema     VARCHAR  (20) -- Наименование родительской схемы
                 ref_table      VARCHAR  (64) -- Наименование родительской таблицы
                 ref_table_desc VARCHAR (250) -- Описание родительской таблицы
                 ref_attr_num   SMALLINT      -- Номер родительского атрибута                
                 ref_field_name VARCHAR  (64) -- Наименование родительского атрибута 
                 ref_not_null   BOOLEAN       -- Признак NOT NULL                   
                 ref_field_desc VARCHAR (250) -- Описание родительского атрибута         
                 update_action  VARCHAR  (20) -- действия при обновлении
                 delete_action  VARCHAR  (20) -- действие при удалении
                 ct_conkey      VARCHAR  (64) -- индесный массив
                 ct_confkey     VARCHAR  (64) -- родительский индексный массив
	 )
    Пример использования:    
                  SELECT * FROM f_show_fk_descr ();   -- все FK во всех схемах.
                  SELECT * FROM f_show_fk_descr (''nso'');  -- все FK в схеме НСО
                  SELECT * FROM f_show_fk_descr (null, null, null, ''nso'', null);  -- все кто ссылается на схему НСО
';

--   SELECT * FROM f_show_fk_descr (null, null, null, 'nso', null)