-- ================================================================ 
--  Author:		 Nick 
--  Create date: 2015-12-22
--  Description:	Выбор описания текущей БД
/* -- ============================================================= 
	Входные параметры: отсутствуют.
   ---------------------------------------------------------------- 
	Выходные параметры
			              Строка описания базы  t_description
   -- ============================================================= */
SET search_path=db_info,public,pg_catalog;

DROP FUNCTION IF EXISTS f_get_db_descr ();
CREATE OR REPLACE FUNCTION f_get_db_descr ()
  RETURNS t_description
AS
 $$
   BEGIN
       RETURN ( SELECT de.description FROM pg_database d
                    JOIN pg_shdescription de ON ( de.objoid = d.oid )
                 WHERE ( d.datname = current_database())
               );
   END;
 $$
    STRICT STABLE  -- Пока 
    SECURITY DEFINER -- 2015-04-05 Nick
    LANGUAGE plpgsql;

COMMENT ON FUNCTION f_get_db_descr () IS 'Выбор описания текущей БД
	Входные параметры: отсутствуют.
   ------------------------------------------------------- 
	Выходные параметры
			              Строка описания базы  t_description
';
-- ----------------------------------------------------------------------------------------------------
--
-- SELECT db_info.f_get_db_descr ();
-- ------------------------------------------------------------------------------------------------------
-- current_catalog 	name 	name of current database (called "catalog" in the SQL standard)
-- current_database() 	name 	name of current database
-- current_query() 	text 	text of the currently executing query, as submitted by the client (might contain more than one statement)
-- current_schema[()] 	name 	name of current schema
-- current_schemas(boolean) 	name[] 	names of schemas in search path, optionally including implicit schemas
-- current_user 	name 	user name of current execution context
-- inet_client_addr() 	inet 	address of the remote connection
-- inet_client_port() 	int 	port of the remote connection
-- inet_server_addr() 	inet 	address of the local connection
-- inet_server_port() 	int 	port of the local connection
-- pg_backend_pid() 	int 	Process ID of the server process attached to the current session
-- pg_conf_load_time() 	timestamp with time zone 	configuration load time
-- pg_is_other_temp_schema(oid) 	boolean 	is schema another session's temporary schema?
-- pg_listening_channels() 	setof text 	channel names that the session is currently listening on
-- pg_my_temp_schema() 	oid 	OID of session's temporary schema, or 0 if none
-- pg_postmaster_start_time() 	timestamp with time zone 	server start time
-- pg_trigger_depth() 	int 	current nesting level of PostgreSQL triggers (0 if not called, directly or indirectly, from inside a trigger)
-- session_user 	name 	session user name
-- user 	name 	equivalent to current_user
-- version() 	text 	PostgreSQL version information
      