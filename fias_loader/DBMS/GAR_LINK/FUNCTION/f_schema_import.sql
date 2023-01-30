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

