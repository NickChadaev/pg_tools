DROP FUNCTION IF EXISTS db_info.f_show_tbv_descr(character varying, character[]);
DROP FUNCTION IF EXISTS db_info.f_show_tbv_descr ( text, char[], text );
CREATE OR REPLACE FUNCTION db_info.f_show_tbv_descr  
	 (
	   p_schema_name  text   = NULL -- Наименование схемы    
      ,p_object_type  CHAR[] = array ['r', 'v', 'm', 'c', 't', 'f', 'p'] -- тип объекта 'r' - таблица, 'v' - представление, 'm' - материализованное представление.  
	  ,p_provider     text   = 'selinux'  -- Имя провайдера 
	 ) 
RETURNS TABLE (
		           schema_name     VARCHAR  (64)  -- Наименование схемы
		          ,objoid          oid      -- OID объекта
		          ,obj_type        VARCHAR  (20)  -- Тип объекта
		          ,obj_name        VARCHAR  (64)  -- Наименование объекта
		          ,obj_description VARCHAR  (250) -- Описание объекта
		          ,seclabel        text           -- Метка безопасности
			     ) 
AS
 $$
    -- --------------------------------------------------------------------------------------------- --
 	--  Дата: 22.08.2013  Nick                                                                       --
    -- --------------------------------------------------------------------------------------------- --
    --  За основу взят текст из статьи: Лихачёв В. Н. "ОБРАБОТКА ОШИБОК ОГРАНИЧЕНИЙ ДЛЯ БАЗ ДАННЫХ   -- 
    --              POSTGRESQL".   Калужский университет.                                            --             
    -- --------------------------------------------------------------------------------------------- --
    --     Применение:                                                                               --
    --        SELECT * FROM f_show_tbv_descr (); -- Все схемы и таблицы.                             --
    --        SELECT * FROM f_show_tbv_descr('nso'); -- Все таблицы из схемы НСО                     --
    --        SELECT * FROM f_show_tbv_descr('nso', 'v'); -- Все представленя из схемы НСО           --
    --        SELECT * FROM f_show_tbv_descr ( null, 'v'); -- Все схемы и представления.             --
    -- --------------------------------------------------------------------------------------------- --
    -- 2015.02.15 Адаптация под домен EBD                                                            --
    -- 2015-04-05  Добавлены: STABLE SECURITY DEFINER ;                                              --
    -- 2015-10-13 Материализованные представления                                                    --
    -- 2016-01-22 Типы сущностей согласованы с проектом ASK_U.                                       --
    --                 добавлены новые типы: 't' - pg_toast, 'c' - user defined type                 --
    -- 2019-02-26 Новый тип сущности: внешняя таблица.    
    -- 2020-01-23 Новый тип сущности: секционированная таблица. 
    -- --------------------------------------------------------------------------------------------- --
	BEGIN
	 RETURN QUERY 
         SELECT
           n.nspname::VARCHAR  (64)   AS schema_name 
          ,c.oid::oid        AS objoid   
          ,CASE c.relkind
              WHEN 'r' THEN 'C_TABLE'
              WHEN 'v' THEN 'C_VIEW'
              WHEN 'm' THEN 'C_MAT_VIEW'
              WHEN 'c' THEN 'C_TYPE' 
              WHEN 't' THEN 'C_PG_TOAST'
              WHEN 'f' THEN 'C_FTABLE' -- 2019-02-26
              WHEN 'p' THEN 'C_STABLE' -- 2020-01-23
              ELSE 'C_UNDEF'
           END::VARCHAR  (20)            AS obj_type    
          ,c.relname::VARCHAR  (64)      AS obj_name 
          ,d.description::VARCHAR  (250) AS obj_description 
          ,sl.label

       FROM pg_namespace n 
            JOIN pg_class c ON n.oid = c.relnamespace
            LEFT OUTER JOIN pg_description d ON (( d.objoid = c.oid ) AND ( d.objsubid = 0 ))
            LEFT OUTER JOIN 
                 LATERAL ( SELECT s.label, s.objoid FROM pg_seclabels s
                           WHERE (s.objoid = c.oid)    AND 
                                 (s.objtype = CASE c.relkind
                                                 WHEN 'r' THEN 'table'
                                                 WHEN 'v' THEN 'view'
                                                 WHEN 'm' THEN 'mat_view' -- ???
                                                 WHEN 'c' THEN 'type' 
                                                 WHEN 't' THEN 'pg_toast'
                                                 WHEN 'f' THEN 'table'  -- 2019-02-26
                                                 WHEN 'p' THEN 'table'  -- 2020-01-23
                                                 ELSE 'undef'
                                              END
                                  ) AND (s.provider = btrim(lower(p_provider)))            
            
            ) sl ON (c.oid = sl.objoid) 
              
       WHERE (
              ( n.nspname <> 'information_schema' )
          AND ( n.nspname <> 'pg_catalog' )
          AND ( n.nspname NOT LIKE 'pg_temp%' )
          AND (n.nspname = COALESCE (BTRIM (LOWER (p_schema_name )), n.nspname )) 
          AND (c.relkind = ANY(p_object_type)) 
          );  
   END;
 $$
    SET search_path=db_info, public, pg_catalog
    STABLE            
    SECURITY DEFINER
    LANGUAGE plpgsql;

COMMENT ON FUNCTION db_info.f_show_tbv_descr ( text, char[], text ) IS '286: Получение описание таблицы/представления

  Раздел или область применения: Сервис
  Входные параметры:
   	 p_schema_name    VARCHAR  	 -- Наименование схемы
    ,p_object_type    CHAR(1)[]  -- тип объекта ''r'' - таблица, ''v'' - представление. ''t'' - pg_toast, ''c'' - user defined type   
    ,p_provider       TEXT   = ''selinux''  -- Имя провайдера безопасности

  Выходные параметры: 
	(
		  schema_name     VARCHAR  (20)  NOT NULL - Наименование схемы
		 ,objoid          INTEGER        NOT NULL - OID объекта
		 ,obj_type        VARCHAR  (20)  NOT NULL - Тип объекта
		 ,obj_name        VARCHAR  (64)  NOT NULL - Наименование объекта
		 ,obj_description VARCHAR (250)      NULL - Описание объекта
		 ,seclabel        TEXT           NOT NULL - Метка безопасности     
	)

  Пример использования: 
        SELECT * FROM f_show_tbv_descr ( ''com'', ARRAY[''r'',''v'',''f'']);
        SELECT * FROM f_show_tbv_descr ( NULL, ARRAY[''r'',''v'',''f'']) ORDER BY schema_name, obj_name;
';
-- ----------------------------------------------------------
-- SELECT * FROM f_show_tbv_descr ( 'nso', ARRAY['r','v','p']);