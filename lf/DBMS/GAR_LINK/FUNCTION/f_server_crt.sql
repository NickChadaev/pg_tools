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

