
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_link.version
 AS
 SELECT '$Revision:c6ec2fd$ modified $RevDate:2022-12-29$'::text AS version; 

-- SELECT * FROM gar_link.version;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_link.f_show_col_descr ( varchar, varchar, char [], text );

CREATE OR REPLACE FUNCTION gar_link.f_show_col_descr
     (
       p_schema_name  VARCHAR (20) = NULL -- Наименование схемы
      ,p_obj_name     VARCHAR (64) = NULL -- Наименование объекта
      ,p_object_type  CHAR(1) []   = array ['r', 'v', 'm', 'c', 't', 'f', 'p'] -- Тип объекта 'r' - таблица, 'v' - представление.
      ,p_provider     text   = 'selinux'  -- Имя провайдера 
    )

RETURNS TABLE (
                  schema_name         VARCHAR  (64)  -- Наименование схемы
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
	2020-03-27 Nick Добавлен столбец "seclabel"
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
        STABLE
        SECURITY DEFINER
        LANGUAGE plpgsql;

COMMENT ON FUNCTION gar_link.f_show_col_descr (varchar, varchar, char[], text) 
                                IS '10: Получение описание столбцов таблицы/представления

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
             SELECT * FROM f_show_col_descr ( '''', NULL, ARRAY [''v'', ''r''] ) ORDER BY schema_name, obj_name, attr_number; -- Все представления в схеме "Объекты".

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
-- SELECT * FROM gar_link.f_show_col_descr ( 'gar_tmp', 'adr_area' ) ORDER BY attr_number;




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_link.f_server_crt (text, text, text, numeric(4), text, text, text);
CREATE OR REPLACE FUNCTION gar_link.f_server_crt (
            p_server_name_f text
           ,p_host_ip_f     text
           ,p_db_name_f     text
           ,p_port_f        numeric(4)     
             --
           ,p_user_name_l   text
           ,p_user_name_f   text
           ,p_user_passwd_f text
        )
        RETURNS integer
        LANGUAGE plpgsql
        SECURITY DEFINER
   AS 
 $$
   -- -----------------------------------------------------------------------------------
   --  2022-05-05 Создание стороннего сервера.
   -- -----------------------------------------------------------------------------------
   --     p_server_name_f -- Имя создаваемого стороннего сервера.
   --     p_host_ip_f     -- Адрес стороннего сервера.
   --     p_db_name_f     -- Имя сторонней базы
   --     p_port_f        -- Номер стороннего порта    
   --     p_user_name_l   -- Имя локального пользователя.
   --     p_user_name_f   -- Имя стороннего пользователя
   --     p_user_passwd_f -- Пароль стороннего пользователя.
   -- -----------------------------------------------------------------------------------
   
   DECLARE
     --
     _server_name_f  text := btrim(lower(p_server_name_f));
     _host_ip_f      text := btrim(lower(p_host_ip_f    ));
     _db_name_f      text := btrim(lower(p_db_name_f    ));
     _user_name_l    text := btrim(lower(p_user_name_l  ));
     _user_name_f    text := btrim(lower(p_user_name_f  ));
     _user_passwd_f  text := btrim(lower(p_user_passwd_f));   
     --
     _exec  text;
     
     _create_server  text = $_$   
          CREATE SERVER IF NOT EXISTS %I FOREIGN DATA WRAPPER postgres_fdw
            OPTIONS (host %L, dbname %L, port %L);
     $_$;   

     _create_user_mapping  text = $_$ 
          CREATE USER MAPPING IF NOT EXISTS FOR %I SERVER %I OPTIONS (user %L, password %L);     
     $_$;   
     
   BEGIN
     -- Существует ли сторонний сервер. ??
     IF EXISTS ( SELECT 1 FROM information_schema.foreign_servers 
                                WHERE (foreign_server_name = _server_name_f)
      )
         THEN
               RAISE ' Сторонний сервер "%", уже существует', _server_name_f;
     END IF;  
     
     _exec := format (_create_server, _server_name_f, _host_ip_f, _db_name_f, p_port_f);  
     EXECUTE _exec;
     --
     _exec = format (_create_user_mapping, _user_name_l, _server_name_f, _user_name_f, _user_passwd_f); 
     EXECUTE _exec;
            
    RETURN 1;
     
   END;
$$;   

COMMENT ON FUNCTION gar_link.f_server_crt (text, text, text, numeric(4), text, text, text) 
       IS 'Создание нового стороннего сервера';
-- ------------
-- USE CASE:
--            
--  unsi_old2=# SELECT gar_link.f_server_crt (
--              p_server_name_f := 'unnsi_m8l11'
--             ,p_host_ip_f     := '127.0.0.1'
--             ,p_db_name_f     := 'unnsi_m811'
--             ,p_port_f        := 5434      
--             ,p_user_name_l   := 'postgres'
--             ,p_user_name_f   := 'postgres'
--             ,p_user_passwd_f := ''
--  );  
--  ЗАМЕЧАНИЕ:     
--     CREATE SERVER IF NOT EXISTS unnsi_m8l11 FOREIGN DATA WRAPPER postgres_fdw
--              OPTIONS (host '127.0.0.1', dbname 'unnsi_m811', port '5434');
--       
--  ЗАМЕЧАНИЕ:   
--     CREATE USER MAPPING IF NOT EXISTS FOR postgres SERVER unnsi_m8l11 OPTIONS (user 'postgres', password '');     
--       
--   f_server_crt 
--  --------------
--              1


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_link.f_server_drp (text);
CREATE OR REPLACE FUNCTION gar_link.f_server_drp (
            p_server_name_f text
        )
        RETURNS numeric(3)
        LANGUAGE plpgsql
        SECURITY DEFINER
   AS 
 $$
   -- -----------------------------------------------------------------------------------
   --  2022-05-05 Удаление стороннего сервера.
   -- -----------------------------------------------------------------------------------
   --     p_server_name_f -- Имя удаляемого стороннего сервера.
   -- -----------------------------------------------------------------------------------
   
   DECLARE
     
     _server_name_f  text := btrim(lower(p_server_name_f));
     _node_id        numeric(3);
     
   BEGIN
    DROP SERVER IF EXISTS _server_name_f CASCADE; 

    DELETE FROM gar_link.foreign_servers WHERE (fserver_name = _server_name_f)
      RETURNING node_id INTO _node_id;
                        
    RETURN _node_id;
    
   END;
$$;   

COMMENT ON FUNCTION gar_link.f_server_drp (text) IS 'Удаление стороннего сервера';
-- ------------
-- USE CASE:
-- SELECT gar_link.f_server_drp ('unnsi_m2l');
-- SELECT gar_link.f_server_drp ('unnsi_m2l11');
-- SELECT gar_link.f_server_drp ('unnsi_m7l');
-- ----------------------------------------------
-- SELECT * FROM gar_link.f_schema_import (
--             p_fserver_name  := 'unnsi_m8l'
--            ,p_fschema_name  := 'unnsi'
--            ,p_lschema_name  := 'unnsi'
--            ,p_lschema_descr := 'Эталон 2022-05-21'     
--         );

-- SELECT * FROM GAR_LINK.v_servers_active;
    
-- ЗАМЕЧАНИЕ:  удаление распространяется на объект сопоставление для пользователя postgres на сервере unnsi_m8l11
--
-- f_server_drp 
--------------
--            1

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_link.f_active_fserver_set (text, text, text, text);

DROP FUNCTION IF EXISTS gar_link.f_schema_import (text, text, text, text);
CREATE OR REPLACE FUNCTION gar_link.f_schema_import (
            p_fserver_name  text
           ,p_fschema_name  text
           ,p_lschema_name  text
           ,p_lschema_descr text     
        )
        RETURNS numeric(3)
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path=gar_link
   AS 
 $$
   -- -----------------------------------------------------------------------------------
   --  2022-02-21 Импорт сторонней схемы.
   --    p_fserver_name  -- Сторонний сервер, должен быть создан.
   --    p_fschema_name  -- Схема на стороннем сервере.
   --    p_lschema_name  -- Локальная схема, в неё выполняется импорт из сторонней схемы.
   --    p_lschema_descr -- Описание локальная схемы.
   -- -----------------------------------------------------------------------------------
   DECLARE
     HOST     CONSTANT text := 'host';
     DBNAME   CONSTANT text := 'dbname';
     PORT     CONSTANT text := 'port';
     --  ADR_AREA CONSTANT text := 'adr_area';
     --
     _fserver_name  text := btrim (lower(p_fserver_name));
     _fschema_name  text := btrim (lower(p_fschema_name));
     --
     _lschema_name   text := btrim (lower(p_lschema_name));
     _lschema_descr  text := COALESCE (btrim (p_lschema_descr), '');
     --
     _node_id  numeric(3);
     _exec     text;
     
     _drop_sch text = $_$   
          DROP SCHEMA IF EXISTS %I CASCADE;
     $_$;
   
     _create_sch text = $_$   
          CREATE SCHEMA IF NOT EXISTS %I;
     $_$;   
   
     _coment_sch text = $_$   
             COMMENT ON SCHEMA %I IS %L;
     $_$;   

     _import_server  text = $_$
             IMPORT FOREIGN SCHEMA %I FROM SERVER %I INTO %I; 
     $_$;
     
   BEGIN
     -- Существует ли сторонний сервер. ??
     IF NOT EXISTS (
                    SELECT 1 FROM information_schema.foreign_servers 
                                   WHERE (foreign_server_name = _fserver_name)
      )
         THEN
               RAISE '"%", нет такого стороннего сервера', _fserver_name;
               
     END IF;  
     --  
     -- Связана ли сторонняя схема со сторонним сервером. ?? 
     --   (Хи-Хи, это будет известно только после выполнения импорта)
     --
     --  IF NOT EXISTS (
     --                  SELECT 1 FROM information_schema.foreign_tables
     --                     WHERE (foreign_server_name = _fserver_name) AND 
     --                           (foreign_table_schema = _fschema_name) AND
     --                           (foreign_table_name = ADR_AREA)
     --  )
     --    THEN
     --         RAISE 'Нет схемы "%", на стороннем сервере "%"', _fschema_name, _fserver_name;
     --  END IF;  
     
     -- Проверка на NULL, имени локальной схем.
     IF (_lschema_name IS NULL) 
        THEN
            RAISE 'Имя локальной схемы не может быть NULL';
     END IF;
     
     _exec := format (_drop_sch, _lschema_name);  
     EXECUTE _exec;
 
       -- Создаём требуемую схему.
     _exec := format (_create_sch, _lschema_name);  
     EXECUTE _exec;       
    
     _exec := format (_coment_sch, _lschema_name, _lschema_descr);
     EXECUTE _exec; 
     
     -- Импорт схемы из стороннего сервера

     _exec := format (_import_server, _fschema_name, _fserver_name, _lschema_name);
     EXECUTE _exec; 
    
    SELECT node_id INTO _node_id FROM  gar_link.foreign_servers WHERE (fserver_name = _fserver_name);
    IF (_node_id IS NOT NULL) 
      THEN
            UPDATE gar_link.foreign_servers SET active_sign = TRUE 
			                                   ,date_create = now() 
			   WHERE (node_id = _node_id);
      ELSE 
           -- Данных о внешем сервере нет в таблице, создаём запись.
           INSERT INTO gar_link.foreign_servers (
                        node_id
                       ,fserver_name
                       ,host
                       ,dbname
                       ,port
                       ,db_conn_name
                       ,local_sch_name
                       ,active_sign
           )
              VALUES ( COALESCE ((SELECT (max (node_id) +1) FROM gar_link.foreign_servers), 1)
                     ,_fserver_name
                     ,(SELECT option_value::inet FROM information_schema.foreign_server_options 
                          WHERE (foreign_server_name = _fserver_name) AND (option_name = HOST)
                      ) 
                     ,(SELECT option_value FROM information_schema.foreign_server_options 
                          WHERE (foreign_server_name = _fserver_name) AND (option_name = DBNAME)
                      )
                     , (SELECT option_value::numeric(4) FROM information_schema.foreign_server_options 
                          WHERE (foreign_server_name = _fserver_name) AND (option_name = PORT)
                      )
                     , ('c_' || _fserver_name) 
                     ,_lschema_name
                     , TRUE
                    )
               RETURNING node_id INTO _node_id;   
    END IF; -- node_id IS NOT NULL
            
    RETURN _node_id;
     
   END;
$$;   

COMMENT ON FUNCTION gar_link.f_schema_import (text, text, text, text) 
   IS 'Переключение локальной схемы на внешний сервер';
-- ------------
-- USE CASE:
--           SELECT * FROM gar_link.foreign_servers ;
--
-- SELECT * FROM gar_link.f_schema_import (
--             p_fserver_name  := 'unsi_l'
--            ,p_fschema_name  := 'unsi'
--            ,p_lschema_name  := 'unnsi'
--            ,p_lschema_descr := 'Отдалённая таблица'     
--         ); -- 6

-- SELECT * FROM gar_link.f_schema_import (
--             p_fserver_name  := 'unnsi_nl'
--            ,p_fschema_name  := 'unnsi'
--            ,p_lschema_name  := 'unnsi'
--            ,p_lschema_descr := 'Отдалённая таблица'     
--         ); -- 4
-- ERROR: ОШИБКА:  Нет схемы "unnsi", на стороннем сервере "unnsi_nl" ???		
-- ЗАМЕЧАНИЕ:  (RELATION,1600719,gar_link,foreign_servers,)
-- ЗАМЕЧАНИЕ:  (RELATION,13382,information_schema,foreign_server_options,)
-- ЗАМЕЧАНИЕ:  (RELATION,13385,information_schema,foreign_servers,)
-- ЗАМЕЧАНИЕ:  (RELATION,13395,information_schema,foreign_tables,)
-- ЗАМЕЧАНИЕ:  (RELATION,13378,information_schema,_pg_foreign_servers,)
-- ЗАМЕЧАНИЕ:  (RELATION,13388,information_schema,_pg_foreign_tables,)
-- ЗАМЕЧАНИЕ:  (RELATION,1260,pg_catalog,pg_authid,)
-- ЗАМЕЧАНИЕ:  (RELATION,1259,pg_catalog,pg_class,)
-- ЗАМЕЧАНИЕ:  (RELATION,2328,pg_catalog,pg_foreign_data_wrapper,)
-- ЗАМЕЧАНИЕ:  (RELATION,1417,pg_catalog,pg_foreign_server,)
-- ЗАМЕЧАНИЕ:  (RELATION,3118,pg_catalog,pg_foreign_table,)
-- ЗАМЕЧАНИЕ:  (RELATION,2615,pg_catalog,pg_namespace,)
-- COMMENT

-- Query returned successfully in 164 msec.


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_link.f_conn_set (text, text);
DROP FUNCTION IF EXISTS gar_link.f_conn_set (numeric(3));
CREATE OR REPLACE FUNCTION gar_link.f_conn_set (
              p_node_id  numeric(3)
             ,OUT conn text
        )
        RETURNS text
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path=gar_link
   AS 
 $$
 -- ----------------------------------------------------------------
 --    2021-12-31/2022-02-02  Установка соединения, 
 --
   DECLARE
     _status       text;
     _conn_name    text;
     _fserver_name text;
     
   BEGIN
     SELECT fserver_name, db_conn_name INTO _fserver_name, _conn_name
          FROM  gar_link.foreign_servers WHERE (node_id = p_node_id) AND (active_sign);
     
     IF _fserver_name IS NULL 
       THEN
         RAISE '"fserver_name" IS NULL';
     END IF;  
     --
     IF _conn_name IS NULL 
       THEN
         RAISE '"conn_name" IS NULL';
     END IF;
     --
     IF COALESCE ((_conn_name <> ALL (gar_link.dblink_get_connections ())), TRUE) 
     THEN
         BEGIN
            _status := gar_link.dblink_connect (_conn_name, _fserver_name);
            IF ( _status = 'OK' ) THEN
                  conn := _conn_name;
            END IF;
             
          EXCEPTION WHEN others 
          THEN
             RAISE 'GAR_LINK.F_CONN_SET: %: failed to open the connection: % %',
                     _conn_name, SQLSTATE, SQLERRM;
         END;
         
      ELSE   
                conn := _conn_name;
     END IF;
   END;
 $$;
-- dblink_is_busy или dblink_get_result, 

COMMENT ON FUNCTION gar_link.f_conn_set (numeric(3)) IS 'Установка соединения DBLINK';
-- --------------------------------
-- USE CASE:
--      SELECT  gar_link.f_conn_set (4); 
--      SELECT gar_link.dblink_get_connections ();
--      SELECT gar_link.dblink_disconnect ('c_unnsi_nl') ;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_link.f_active_set (numeric(3));
CREATE OR REPLACE FUNCTION gar_link.f_active_set (
              p_node_id  numeric(3)
        )
        RETURNS text
        LANGUAGE sql
   AS 
 $$
  -- ----------------------------------------------------------------
  --   2022-02-02. Установка активно соединения
  -- ----------------------------------------------------------------
  UPDATE gar_link.foreign_servers SET active_sign = TRUE WHERE (node_id = p_node_id)
    RETURNING  fserver_name;
  
 $$;


COMMENT ON FUNCTION gar_link.f_active_set (numeric(3)) IS 'Установка активно соединения';
-- --------------------------------
-- USE CASE:
--      SELECT  gar_link.f_active_set (4); 
--      SELECT  * FROM gar_link.foreign_servers ;        -- OK 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_link.f_server_is (text);
CREATE OR REPLACE FUNCTION gar_link.f_server_is (
              p_fschema_name text = 'unnsi'
        )
        RETURNS text
        LANGUAGE sql
   AS 
 $$
  -- ----------------------------------------------------------------
  --   2022-02-24. Определение текущего  стороннего сервера.
  -- ----------------------------------------------------------------
   SELECT foreign_server_name FROM  information_schema.foreign_tables
                    WHERE  (foreign_table_schema = p_fschema_name) AND 
                           (foreign_table_name = 'adr_area');
  
 $$;


COMMENT ON FUNCTION gar_link.f_server_is (text) IS 'Определение текущего стороннего сервера.';
-- --------------------------------
-- USE CASE:
--      SELECT  gar_link.f_server_is ('unnsi'); 
--      SELECT  * FROM gar_link.foreign_servers ;        -- OK 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP VIEW IF EXISTS gar_link.v_servers_active CASCADE;
CREATE VIEW gar_link.v_servers_active AS 
   SELECT  
            node_id        
          , fserver_name   
          , host           
          , dbname         
          , port           
          , db_conn_name   
          , local_sch_name 
          , date_create   
      FROM gar_link.foreign_servers    
   WHERE active_sign ORDER BY node_id;

COMMENT ON VIEW gar_link.v_servers_active IS 'Список АКТИВНЫХ внешних серверов';

COMMENT ON COLUMN gar_link.v_servers_active.node_id        IS 'Номер внешнего сервера';
COMMENT ON COLUMN gar_link.v_servers_active.fserver_name   IS 'Имя внешнего сервера';
COMMENT ON COLUMN gar_link.v_servers_active.host           IS 'IP-адрес';
COMMENT ON COLUMN gar_link.v_servers_active.dbname         IS 'Имя базы данных';
COMMENT ON COLUMN gar_link.v_servers_active.port           IS 'Порт';
COMMENT ON COLUMN gar_link.v_servers_active.db_conn_name   IS 'Имя DB-LINK соединения';
COMMENT ON COLUMN gar_link.v_servers_active.local_sch_name IS 'Имя локальной схемы';
COMMENT ON COLUMN gar_link.v_servers_active.date_create    IS 'Дата создания записи';
--
-- SELECT * FROM gar_link.v_servers_active;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_link.f_index_get (text, text, text, boolean, boolean, boolean);
CREATE OR REPLACE FUNCTION gar_link.f_index_get (
           p_schema_name text -- Имя схемы приёмника.
          ,p_table_name  text -- Имя таблицы 
          ,p_index_name  text    = NULL -- Имя индекса.   
          ,p_mode_c      boolean = TRUE -- Создание индексов FALSE - удаление
          ,p_kind_index  boolean = TRUE -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
          ,p_unique_sign boolean = NULL -- Используем признак уникальности из таблицы.
          ,OUT exec      text
)
    RETURNS setof text
    LANGUAGE plpgsql 
    SECURITY DEFINER
    AS 
  $$
   -- --------------------------------------------------------------------------
   --   2022-11-09  Формирование индексного выражения, создание/удаления.
   -- --------------------------------------------------------------------------                 
    DECLARE 
      _crt_idx    text := $_$ CREATE INDEX IF NOT EXISTS %s; $_$;  
      _crt_un_idx text := $_$ CREATE UNIQUE INDEX IF NOT EXISTS %s; $_$; 
      _drp_idx    text := $_$ DROP INDEX IF EXISTS %I.%s; $_$; 
      
      _rr record;
      _exec text;
      
      _schema_name text := lower(btrim(p_schema_name)); -- Имя схемы приёмника.
      _table_name  text := lower(btrim(p_table_name));  -- Имя таблицы 
      _index_name  text := lower(btrim(p_index_name));  -- Имя индекса.   
   
    BEGIN
     FOR _rr IN 
            SELECT i.table_name
                 , i.index_name
                 , i.index_body
                 , i.index_kind
                 , COALESCE (p_unique_sign, i.unique_sign) AS unique_sign
                 
                 FROM gar_link.adr_indecies i 
                 
                    WHERE (_table_name = i.table_name) AND 
                          (i.index_kind = p_kind_index) AND
                          (COALESCE (_index_name,i.index_name) = i.index_name)
      LOOP
        IF p_mode_c -- Create
          THEN 
             IF _rr.unique_sign
               THEN
                 _exec := format (_crt_un_idx, (_rr.index_name || ' ' || format (_rr.index_body, _schema_name)));
               ELSE
                 _exec := format (_crt_idx, (_rr.index_name || ' ' || format (_rr.index_body, _schema_name)));
             END IF;
            
           ELSE --Drop
                _exec := format (_drp_idx, _schema_name, _rr.index_name);
        END IF; --

        exec = _exec;        
        RETURN NEXT;

     END LOOP;    
    END;
  $$;
  
COMMENT ON FUNCTION gar_link.f_index_get (text, text, text, boolean, boolean, boolean) 
  IS 'Получить индексное выражение/Список индексных выражений';  
-- ----- ----------------------------------------------------
-- USE CASE:
--   SELECT gar_link.f_index_get ( 
--            p_schema_name := 'gar_tmp'  -- Имя схемы приёмника.
--           ,p_table_name  := 'adr_area' -- Имя таблицы 
--           ,p_index_name  := NULL       -- Имя индекса.   
--           ,p_mode_c      := TRUE -- Создание индексов FALSE - удаление
--           ,p_kind_index  := FALSE -- Вид индекса -- FALSE -- эксплуатационный.
-- );
--   SELECT gar_link.f_index_get ( 
--            p_schema_name := 'gar_tmp'  -- Имя схемы приёмника.
--           ,p_table_name  := 'adr_area' -- Имя таблицы 
--           ,p_index_name  := 'adr_area_i1'       -- Имя индекса.   
--           ,p_mode_c      := FALSE -- Создание индексов FALSE - удаление
--           ,p_kind_index  := TRUE -- Вид индекса -- FALSE -- эксплуатационный.
-- );
-- --
--   SELECT gar_link.f_index_get ( 
--            p_schema_name := 'gar_tmp'  -- Имя схемы приёмника.
--           ,p_table_name  := 'adr_area' -- Имя таблицы 
--           ,p_unique_sign    := FALSE       -- Имя индекса.   
--           ,p_mode_c      := TRUE -- Создание индексов FALSE - удаление
--           ,p_kind_index  := FALSE -- Вид индекса -- FALSE -- эксплуатационный.
-- );
--   SELECT gar_link.f_index_get ( 
--            p_schema_name := 'gar_tmp'  -- Имя схемы приёмника.
--           ,p_table_name  := 'adr_area' -- Имя таблицы 
--           ,p_index_name    := NULL       -- Имя индекса.   
--           ,p_mode_c      := FALSE -- Создание индексов FALSE - удаление
--           ,p_kind_index  := FALSE -- Вид индекса -- FALSE -- эксплуатационный.
-- );

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_link.p_execute_idx (text, text);
CREATE OR REPLACE PROCEDURE gar_link.p_execute_idx (
              p_exec  text        -- Исполняемое выражение.
             ,p_conn  text = NULL -- Именованное dblink-соединение   
           
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS 

  $$
   -- --------------------------------------------------------------------------
   --   2022-11-22  Использованиен индексного хранилища. 
   -- --------------------------------------------------------------------------                 
    DECLARE 
     _mess  text;
   
    BEGIN
        IF (p_conn IS NOT NULL) 
          THEN
             SELECT xx1.mess INTO _mess 
                        FROM gar_link.dblink (p_conn, p_exec) xx1 ( mess text);
          ELSE
               EXECUTE p_exec;
        END IF; 
        
        RAISE NOTICE '%', p_exec;
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_execute_idx (text, text) 
  IS 'Создание индексов в отдалённой/локальной таблице';  
-- ----- ----------------------------------------------------
-- USE CASE:
-- SELECT gar_link.f_server_is();
-- SELECT * FROM gar_link.v_servers_active;





 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_link.p_adr_objects_idx (text, text, boolean, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_link.p_adr_objects_idx (
           p_conn         text -- Именованное dblink-соединение   
          ,p_schema_name  text -- Имя отдалённой схемы 
          ,p_mode_t       boolean = TRUE -- Выбор типа индексов TRUE  - Эксплутационные
                                         --                    ,FALSE - Загрузочные
          ,p_mode_c       boolean = TRUE  -- Создание индексов FALSE - удаление  
          ,p_uniq_x2      boolean = TRUE  -- Уникальность второго загрузочного индекса.
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS 

  $$
   -- --------------------------------------------------------------------------
   --   2021-01-31  unnsi.adr_object  Управление индексами в отдалённой таблице.
   -- --------------------------------------------------------------------------                 
    DECLARE 
       _mess text;
       --
      _idx_name    text;

      _idx_names_0 text[] := ARRAY [
                                  'adr_objects_i1 '
                                 ,'adr_objects_i2 '
                                 ,'adr_objects_i3 '
                                 ,'adr_objects_i4 '
                                 ,'adr_objects_i8 '
                                 ]::text[];
       --
      _idx_signs_0 text[] := ARRAY [
                                  'ON %I.adr_objects USING btree (id_area)'
                                 ,'ON %I.adr_objects USING btree (id_street)'
                                 ,'ON %I.adr_objects USING btree (id_house)'
                                 ,'ON %I.adr_objects USING btree (id_object_type)'
                                 ,'ON %I.adr_objects USING btree (nm_fias_guid)'
                                 ]::text[];
                                        
      _u_idx_name_0 text := 'adr_objects_ak1 ';                           

      _u_idx_sign_0 text := 'ON %I.adr_objects USING btree (id_area, id_object_type, upper((nm_object_full)::text), id_street, id_house)
    WHERE (id_data_etalon IS NULL)';  
       --
       ---- 
       --
      _idx_name_1  text := '_xxx_adr_objects_ie2 ';

      _idx_sign_1  text := 'ON %I.adr_objects USING btree
                          (nm_fias_guid ASC NULLS LAST)
                          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL';
                     
      _u_idx_name_1 text := '_xxx_adr_objects_ak1 ';
       --
      _u_idx_sign_1 text := 'ON %I.adr_objects USING btree
                ( id_area ASC NULLS LAST
                , id_object_type ASC NULLS LAST
                , upper(nm_object_full::text) ASC NULLS LAST
                , id_street ASC NULLS LAST
                , id_house ASC NULLS LAST
                )
            WHERE id_data_etalon IS NULL AND dt_data_del IS NULL';          
       --                   
       ----
       --
      _crt_idx    text := $_$ CREATE INDEX IF NOT EXISTS %s; $_$;  
      _crt_un_idx text := $_$ CREATE UNIQUE INDEX IF NOT EXISTS %s; $_$; 
      _drp_idx    text := $_$ DROP INDEX IF EXISTS %I.%s; $_$; 
      
      _exec    text;
      _qty     integer;
      _i       integer := 1;
   
    BEGIN
     IF p_mode_t  -- Эксплутационные индексы
        THEN
        _qty := array_length (_idx_names_0, 1);
        
        LOOP
          _idx_name := _idx_names_0 [_i];
          IF p_mode_c -- Create
            THEN 
              _exec := format (_crt_idx, _idx_name || format (_idx_signs_0 [_i], p_schema_name));
              RAISE NOTICE '%', _exec;
               
              SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
              RAISE NOTICE '%', _mess;
                     
             ELSE --Drop
                  _exec := format (_drp_idx, p_schema_name, _idx_name);
                  RAISE NOTICE '%', _exec;
                     
                  SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
                  RAISE NOTICE '%', _mess;
          END IF; -- p_mode_c Create/Drop
          --
          _i := _i + 1;
          EXIT WHEN (_i > _qty);
        END LOOP;
        
        -- Уникальный индекс
        IF p_mode_c
         THEN
           _exec := format (_crt_un_idx, (_u_idx_name_0 || format (_u_idx_sign_0, p_schema_name)));
           RAISE NOTICE '%', _exec;
              
           SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
           RAISE NOTICE '%', _mess;
         ---  
         ELSE -- drop
             _exec := format (_drp_idx, p_schema_name, _u_idx_name_0);
             RAISE NOTICE '%', _exec;   
               
             SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
             RAISE NOTICE '%', _mess;            
        
        END IF; -- p_mode_c
        
      ELSE -- Загрузочные индексы.
      
        IF p_mode_c
         THEN
         -- Уникальный индекс переделанный из обычного.
           IF p_uniq_x2
             THEN
                 _exec := format (_crt_un_idx, (_idx_name_1 || format (_idx_sign_1, p_schema_name)));
             ELSE
                 _exec := format (_crt_idx, (_idx_name_1 || format (_idx_sign_1, p_schema_name)));
           END IF;
           RAISE NOTICE '%', _exec;
              
           SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
           RAISE NOTICE '%', _mess;           
           --
           -- Уникальный комплексный индекс.
           _exec := format (_crt_un_idx, (_u_idx_name_1 || format (_u_idx_sign_1, p_schema_name)));
           RAISE NOTICE '%', _exec;
              
           SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
           RAISE NOTICE '%', _mess;
         ---  
         ELSE -- drop
             _exec := format (_drp_idx, p_schema_name, _idx_name_1);
             RAISE NOTICE '%', _exec;   
               
             SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
             RAISE NOTICE '%', _mess;           
         
             _exec := format (_drp_idx, p_schema_name, _u_idx_name_1);
             RAISE NOTICE '%', _exec;   
               
             SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
             RAISE NOTICE '%', _mess;            
        
        END IF; -- p_mode_c      
        
     END IF; -- p_mode_t   
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_adr_objects_idx (text, text, boolean, boolean, boolean) 
  IS 'Управление индексами в отдалённой таблице "adr_objects".';  
-- ----- ----------------------------------------------------
-- USE CASE:
--
-- CALL gar_link.p_adr_objects_idx (gar_link.f_conn_set(4), 'unnsi', true, true); -- Создаю эксплуатационные
-- CALL gar_link.p_adr_objects_idx (gar_link.f_conn_set(4), 'unnsi', false, true, false); -- Создание загрузочных
--
-- CALL gar_link.p_adr_objects_idx (gar_link.f_conn_set(4), 'unnsi', true, false); -- Убираю эксплуатационные
-- CALL gar_link.p_adr_objects_idx (gar_link.f_conn_set(4), 'unnsi', false, false); -- Убираю загрузочные




 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_link.p_adr_house_idx_set_uniq (text, text, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_link.p_adr_house_idx_set_uniq (
         p_schema_name text -- Имя отдалённой схемы 
        ,p_conn        text    = NULL -- Именованное dblink-соединение  
        ,p_mode_t      boolean = TRUE -- Выбор типа индексов TRUE  - Эксплутационные
                                      --                    ,FALSE - Загрузочные
        ,p_uniq_sw     boolean = TRUE -- Уникальность "ak1", "ie2" - 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS 

  $$
   -- --------------------------------------------------------------------------
   --  2022-03-24  unnsi.adr_house  Управление уникальностью: 
   --     Эксплуатационные индексы - "ak1" - либо уникальный, либо нет.
   --     Загрузочные  индексы - "ie2" - либо уникальный либо нет.
   --     Фактически реализована пара последовательных команд: DROP/CREATE.
   -- --------------------------------------------------------------------------                 
    DECLARE 
      _mess text;
      _exec text;
      TABLE_NAME constant text = 'adr_house';
   
    BEGIN
     IF p_mode_t  -- Эксплуатационное покрытие
       THEN
         --
         _exec := gar_link.f_index_get ( 
                     p_schema_name := p_schema_name    -- Имя схемы приёмника.
                    ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                    ,p_index_name  := 'adr_house_ak1'  -- Имя индекса.   
                    ,p_mode_c      := FALSE            -- Создание индексов FALSE - удаление
                    ,p_kind_index  := TRUE             -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
         );
         CALL gar_link.p_execute_idx (_exec, p_conn);
         --  
         _exec := gar_link.f_index_get ( 
                     p_schema_name := p_schema_name    -- Имя схемы приёмника.
                    ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                    ,p_index_name  := 'adr_house_ak1' -- Имя индекса.   
                    ,p_mode_c      := TRUE         -- Создание индексов FALSE - удаление
                    ,p_kind_index  := TRUE         -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
                    ,p_unique_sign := p_uniq_sw
         );         
         CALL gar_link.p_execute_idx (_exec, p_conn);        
         
      ELSE -- Процессинговое покрытие.
         --
         _exec := gar_link.f_index_get ( 
                           p_schema_name := p_schema_name    -- Имя схемы приёмника.
                          ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                          ,p_index_name  := '_xxx_adr_house_ie2' -- Имя индекса.   
                          ,p_mode_c      := FALSE            -- Создание индексов FALSE - удаление
                          ,p_kind_index  := FALSE         -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
         );
         CALL gar_link.p_execute_idx (_exec, p_conn);
         --  
         _exec := gar_link.f_index_get ( 
                         p_schema_name := p_schema_name    -- Имя схемы приёмника.
                        ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                        ,p_index_name  := '_xxx_adr_house_ie2' -- Имя индекса.   
                        ,p_mode_c      := TRUE         -- Создание индексов FALSE - удаление
                        ,p_kind_index  := FALSE         -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
                        ,p_unique_sign := p_uniq_sw                          
         );
         CALL gar_link.p_execute_idx (_exec, p_conn);        
     END IF; -- p_mode_t   
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_adr_house_idx_set_uniq (text, text, boolean, boolean) 
  IS 'Управление индексами (Установка уникальности) в отдалённой таблице "adr_house".';  
-- ----- ------------------------------------------------------------------------------
-- USE CASE:
--
-- CALL gar_link.p_adr_house_idx_set_uniq (gar_link.f_conn_set(3), 'unnsi', true, true); 
--    Эксплуатационное покрытие, комплексный уникальный.
--
-- CALL gar_link.p_adr_house_idx_set_uniq (gar_link.f_conn_set(3), 'unnsi', true, false); 
--    Эксплуатационное покрытие, комплексный неуникальный.
--
-- CALL gar_link.p_adr_house_idx_set_uniq (gar_link.f_conn_set(4), 'unnsi', true, false); -- Убираю эксплуатационные
-- CALL gar_link.p_adr_house_idx_set_uniq (gar_link.f_conn_set(4), 'unnsi', false, false); -- Убираю загрузочные




 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_link.p_adr_house_idx (text, text, boolean, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_link.p_adr_house_idx (
         p_schema_name  text -- Имя отдалённой схемы 
        ,p_conn         text    = NULL -- Именованное dblink-соединение  
        ,p_mode_t       boolean = TRUE -- Выбор типа индексов TRUE  - Эксплутационные
                                       --                    ,FALSE - Загрузочные
        ,p_mode_c       boolean = TRUE -- Создание индексов FALSE   - удаление  
        ,p_uniq_sw      boolean = TRUE -- Уникальность "ak1", "ie2" - 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS 

  $$
   -- -----------------------------------------------------------------------------------
   --  2021-01-31  unnsi.adr_house  Управление индексами в отдалённой таблице.
   --  2022-02-11  В уникальный первого загрузочного индекса добавлен "id_house_type_1".
   --  2022-03-04  Изменения в управлении уникальности: 
   --     Эксплуатационные индексы - "ak1" - либо уникальный, либо нет.
   --     Загрузочные  индексы - "ie2" - либо уникальный либо нет.
   -- --------------------------------------------------------------------------
   --  2022-11-23  Использованиен индексного хранилища. 
------------------------------------------------------------------------------------                 
    DECLARE 
      _mess text;
      _exec text;

      TABLE_NAME constant text = 'adr_house';      
   
    BEGIN
     IF NOT p_mode_c -- Удаление.
       THEN
           FOR _exec IN  SELECT gar_link.f_index_get ( 
                 p_schema_name := p_schema_name -- Имя схемы приёмника.
                ,p_table_name  := TABLE_NAME    -- Имя таблицы 
                ,p_index_name  := NULL          -- Имя индекса.   
                ,p_mode_c      := FALSE         -- Создание индексов FALSE - удаление
                ,p_kind_index  := p_mode_t      -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
           )
            LOOP 
                 CALL gar_link.p_execute_idx (_exec, p_conn);
            END LOOP;    
    
      ELSIF p_mode_t -- Создание, эксплуатационные (начинается веселие).
          THEN
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_house_i1' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
             );
             CALL gar_link.p_execute_idx (_exec, p_conn);
             --
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_house_i2' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
             );             
             CALL gar_link.p_execute_idx (_exec, p_conn);
             --
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_house_i3' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
             );             
             CALL gar_link.p_execute_idx (_exec, p_conn);
             --
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_house_i4' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
              );             
             CALL gar_link.p_execute_idx (_exec, p_conn);
             --
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_house_i5' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
             );
             CALL gar_link.p_execute_idx (_exec, p_conn);
             --
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_house_i7' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
             );             
             CALL gar_link.p_execute_idx (_exec, p_conn);
             --
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_house_idx1' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
             );             
             CALL gar_link.p_execute_idx (_exec, p_conn);
             --        
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name    -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                       ,p_index_name  := 'adr_house_ak1' -- Имя индекса.   
                       ,p_mode_c      := TRUE             -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE             -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
                       ,p_unique_sign := p_uniq_sw                            
              );             
             CALL gar_link.p_execute_idx (_exec, p_conn);  
             
          ELSE -- Процессинговые индексы.
          
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name    -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                       ,p_index_name  := '_xxx_adr_house_ie2' -- Имя индекса.   
                       ,p_mode_c      := TRUE             -- Создание индексов FALSE - удаление
                       ,p_kind_index  := FALSE             -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
                       ,p_unique_sign := p_uniq_sw                       
             );
             CALL gar_link.p_execute_idx (_exec, p_conn);          
             --
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name    -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                       ,p_index_name  := '_xxx_adr_house_ak1' -- Имя индекса.   
                       ,p_mode_c      := TRUE             -- Создание индексов FALSE - удаление
                       ,p_kind_index  := FALSE             -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
             );             
             CALL gar_link.p_execute_idx (_exec, p_conn);               
     END IF; -- p_mode_c -- Удаление, создание.
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_adr_house_idx (text, text, boolean, boolean, boolean) 
  IS 'Управление индексами в отдалённой таблице "adr_house".';  
-- ----- ----------------------------------------------------
-- USE CASE:
--
-- CALL gar_link.p_adr_house_idx (gar_link.f_conn_set(4), 'unnsi', true, true); -- Создаю эксплуатационные
-- CALL gar_link.p_adr_house_idx (gar_link.f_conn_set(4), 'unnsi', false, true, false); -- Создание загрузочных
--
-- CALL gar_link.p_adr_house_idx (gar_link.f_conn_set(4), 'unnsi', true, false); -- Убираю эксплуатационные
-- CALL gar_link.p_adr_house_idx (gar_link.f_conn_set(4), 'unnsi', false, false); -- Убираю загрузочные




 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_link.p_adr_street_idx_set_uniq (text, text, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_link.p_adr_street_idx_set_uniq (
           p_schema_name  text -- Имя отдалённой схемы 
          ,p_conn         text -- Именованное dblink-соединение   
          ,p_mode_t       boolean = TRUE -- Выбор типа индексов TRUE  - Эксплутационные
                                         --                    ,FALSE - Загрузочные
          ,p_uniq_sw      boolean = TRUE -- Уникальность "ak1", "ie2" - 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS 

  $$
   -- --------------------------------------------------------------------------
   --  2022-03-24  unnsi.adr_house  Управление уникальностью: 
   --     Эксплуатационные индексы - "ak1" - либо уникальный, либо нет.
   --     Загрузочные  индексы - "ie2" - либо уникальный либо нет.
   --     Фактически реализована пара последовательных команд: DROP/CREATE.
   -- --------------------------------------------------------------------------     
   --  2022-11-22 Используется индексное хранилище.
   -- --------------------------------------------------------------------------                 
    DECLARE 
      _mess text;
      _exec text;
      TABLE_NAME constant text = 'adr_street';
   
    BEGIN
     IF p_mode_t  -- Эксплуатационное покрытие
       THEN
         _exec := gar_link.f_index_get ( 
                     p_schema_name := p_schema_name    -- Имя схемы приёмника.
                    ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                    ,p_index_name  := 'adr_street_ak1' -- Имя индекса.   
                    ,p_mode_c      := FALSE            -- Создание индексов FALSE - удаление
                    ,p_kind_index  := TRUE             -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
         );
         CALL gar_link.p_execute_idx (_exec, p_conn);
         --  
         _exec := gar_link.f_index_get ( 
                     p_schema_name := p_schema_name    -- Имя схемы приёмника.
                    ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                    ,p_index_name  := 'adr_street_ak1' -- Имя индекса.   
                    ,p_mode_c      := TRUE         -- Создание индексов FALSE - удаление
                    ,p_kind_index  := TRUE         -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
                    ,p_unique_sign := p_uniq_sw
         );         
         CALL gar_link.p_execute_idx (_exec, p_conn);        
         
      ELSE -- Процессинговое покрытие.
         --
         _exec := gar_link.f_index_get ( 
                      p_schema_name := p_schema_name    -- Имя схемы приёмника.
                     ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                     ,p_index_name  := '_xxx_adr_street_ie2' -- Имя индекса.   
                     ,p_mode_c      := FALSE            -- Создание индексов FALSE - удаление
                     ,p_kind_index  := FALSE         -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
         );         
         CALL gar_link.p_execute_idx (_exec, p_conn);
         --  
         _exec := gar_link.f_index_get ( 
                           p_schema_name := p_schema_name    -- Имя схемы приёмника.
                          ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                          ,p_index_name  := '_xxx_adr_street_ie2' -- Имя индекса.   
                          ,p_mode_c      := TRUE         -- Создание индексов FALSE - удаление
                          ,p_kind_index  := FALSE         -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
                          ,p_unique_sign := p_uniq_sw
         );         
         CALL gar_link.p_execute_idx (_exec, p_conn);        
     END IF; -- p_mode_t   
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_adr_street_idx_set_uniq (text, text, boolean, boolean) 
  IS 'Управление индексами (Установка уникальности) в отдалённой/локальной таблице "adr_street".';  
-- ----- ------------------------------------------------------------------------------
-- USE CASE:
--
-- CALL gar_link.p_adr_street_idx_set_uniq (gar_link.f_conn_set(3), 'unnsi', true, true); 
--
-- CALL gar_link.p_adr_street_idx_set_uniq ('gar_tmp', NULL, true, true);
--
-- SELECT gar_link.f_server_is();  
-- SELECT * FROM gar_link.v_servers_active;   

-- CALL gar_link.p_adr_street_idx_set_uniq (gar_link.f_conn_set(2), 'unnsi', true, false); -- Неуникальный эксплуатационный




 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_link.p_adr_street_idx (text, text, boolean, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_link.p_adr_street_idx (
      p_schema_name  text -- Имя отдалённой схемы 
     ,p_conn         text    = NULL -- Именованное dblink-соединение   
     ,p_mode_t       boolean = TRUE -- Выбор типа индексов TRUE  - Эксплутационные
                                    --                    ,FALSE - Загрузочные
     ,p_mode_c       boolean = TRUE  -- Создание индексов FALSE - удаление  
     ,p_uniq_sw      boolean = TRUE  -- Уникальность "ak1", "ie2" -          
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS 

  $$
   -- --------------------------------------------------------------------------
   --  2022-01-31  unnsi. adr_street  Управление индексами в отдалённой таблице.
   --  2022-04-29  Изменения в управлении уникальности, "p_uniq_sw": 
   --     Эксплуатационные индексы - "ak1" - либо уникальный, либо нет.
   --     Загрузочные  индексы - "ie2" - либо уникальный либо нет.
   -- --------------------------------------------------------------------------
   --  2022-11-10  Использованиен индексного хранилища. 
   -- --------------------------------------------------------------------------                 
    DECLARE 
      _mess text;
      _exec text;
      TABLE_NAME constant text = 'adr_street';
   
    BEGIN
     IF NOT p_mode_c -- Удаление.
       THEN
           FOR _exec IN  SELECT gar_link.f_index_get ( 
                 p_schema_name := p_schema_name -- Имя схемы приёмника.
                ,p_table_name  := TABLE_NAME    -- Имя таблицы 
                ,p_index_name  := NULL          -- Имя индекса.   
                ,p_mode_c      := FALSE         -- Создание индексов FALSE - удаление
                ,p_kind_index  := p_mode_t      -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
           )
            LOOP 
                 CALL gar_link.p_execute_idx (_exec, p_conn);
            END LOOP;    
    
      ELSIF p_mode_t -- Создание, эксплуатационные (начинается веселие).
          THEN
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_street_i1' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
             );
             CALL gar_link.p_execute_idx (_exec, p_conn);
             --
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_street_i2' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
             );
             CALL gar_link.p_execute_idx (_exec, p_conn);
             --
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_street_i3' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
             );
             CALL gar_link.p_execute_idx (_exec, p_conn);
             --
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_street_i4' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
             );
             CALL gar_link.p_execute_idx (_exec, p_conn);
             --             
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name    -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                       ,p_index_name  := 'adr_street_ak1' -- Имя индекса.   
                       ,p_mode_c      := TRUE             -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE             -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
                       ,p_unique_sign := p_uniq_sw                       
             );
             CALL gar_link.p_execute_idx (_exec, p_conn);             --
             
          ELSE -- Процессинговые индексы.
          
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name    -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                       ,p_index_name  := '_xxx_adr_street_ie2' -- Имя индекса.   
                       ,p_mode_c      := TRUE             -- Создание индексов FALSE - удаление
                       ,p_kind_index  := FALSE             -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
                       ,p_unique_sign := p_uniq_sw                        
             );
             CALL gar_link.p_execute_idx (_exec, p_conn);          
             --
             _exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name    -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                       ,p_index_name  := '_xxx_adr_street_ak1' -- Имя индекса.   
                       ,p_mode_c      := TRUE             -- Создание индексов FALSE - удаление
                       ,p_kind_index  := FALSE             -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
             );
             CALL gar_link.p_execute_idx (_exec, p_conn);               
     END IF; -- p_mode_c -- Удаление, создание.
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_adr_street_idx (text, text, boolean, boolean, boolean) 
  IS 'Управление индексами в отдалённой таблице "adr_street".';  
-- ----- ----------------------------------------------------
-- USE CASE:
--
-- SELECT gar_link.f_server_is(); -- unnsi_m12l
-- SELECT * FROM gar_link.v_servers_active;  -- 12
--
--     Убираю эксплуатационные
-- CALL gar_link.p_adr_street_idx ('gar_tmp', NULL, true, false); 

--     Создаю загрузочные
-- CALL gar_link.p_adr_street_idx ('gar_tmp', NULL, false, true); 

--     Убираю эксплуатационные
-- CALL gar_link.p_adr_street_idx ('unnsi', gar_link.f_conn_set(12), true, false); 

--     Создание загрузочных
-- CALL gar_link.p_adr_street_idx ('gar_tmp', gar_link.f_conn_set(12), false, true); 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_link.p_adr_area_idx (text, text, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_link.p_adr_area_idx (
              p_schema_name  text        -- Имя отдалённой/локальной схемы схемы 
             ,p_conn         text = NULL -- Именованное dblink-соединение   
             ,p_mode_t       boolean = TRUE -- Выбор типа индексов TRUE  - Эксплутационные
                                            --                    ,FALSE - Загрузочные
             ,p_mode_c       boolean = TRUE  -- Создание индексов FALSE - удаление             
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS 

  $$
   -- --------------------------------------------------------------------------
   --   2021-01-31  unnsi.adr_area  Управление индексами в отдалённой таблице.
   --   2022-11-10  Использованиен индексного хранилища. 
   -- --------------------------------------------------------------------------                 
    DECLARE 
     _mess    text;
     _exec    text;
     TABLE_NAME constant text = 'adr_area';
   
    BEGIN
     FOR _exec IN  SELECT gar_link.f_index_get ( 
                p_schema_name := p_schema_name  -- Имя схемы приёмника.
               ,p_table_name  := TABLE_NAME -- Имя таблицы 
               ,p_index_name  := NULL       -- Имя индекса.   
               ,p_mode_c      := p_mode_c -- Создание индексов FALSE - удаление
               ,p_kind_index  := p_mode_t -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
     )
      LOOP 
           CALL gar_link.p_execute_idx (_exec, p_conn);
      END LOOP;
      --
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_adr_area_idx (text, text, boolean, boolean) 
  IS 'Управление индексами в отдалённой/локальной таблице "adr_area".';  
-- ----- ----------------------------------------------------
-- USE CASE:
-- SELECT gar_link.f_server_is();
-- SELECT * FROM gar_link.v_servers_active;

-- CALL gar_link.p_adr_area_idx ('unnsi', gar_link.f_conn_set(12), true, true); -- Создаю эксплуатационные
-- CALL gar_link.p_adr_area_idx ('gar_tmp', NULL, false); -- Создание загрузочных
--
-- CALL gar_link.p_adr_area_idx ('gar_tmp', NULL, true, false); -- Убираю эксплуатационные
-- CALL gar_link.p_adr_area_idx ('gar_tmp', NULL, false, false); -- Убираю загрузочные




 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
