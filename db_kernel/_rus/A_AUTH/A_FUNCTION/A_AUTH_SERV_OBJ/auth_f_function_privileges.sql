DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_function_privileges ( public.t_sysname );
CREATE OR REPLACE FUNCTION auth_serv_obj.auth_f_function_privileges ( 
				p_user_login		public.t_sysname	-- логин пользователя
)RETURNS TABLE (username     public.t_sysname
              , functionname public.t_text
              , privieleges  public.t_arr_code
)
AS
 $$
   /*======================================================================*/
   /* DBMS name:      PostgreSQL 8                                         */
   /* Created on:     09.08.2015 12:14:00                                  */
   /* Модификация: 2015-08-18                                              */
   /*  Вывод всех привелегий роли пользователя для функций.   Роман.       */
   /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
   /*=======================================================================*/
   BEGIN
   	--RAISE NOTICE 'DO auth_f_function_privileges(%)', p_user_login;
   	RETURN QUERY (
   		WITH preference AS(
   			SELECT BTRIM(p_user_login)::text AS uname
   		), proc AS (
   			SELECT oid, pronamespace 
   			FROM pg_proc 
   			WHERE (oid >= 16384 OR pronamespace =2200) ORDER BY pronamespace
   		), function_info AS (
   			SELECT
   				preference.uname,
   				obj.IDENTITY As object_identity,
   				array(select privs from unnest(ARRAY [ 
   							(CASE WHEN has_function_privilege(preference.uname, proc.oid, 'EXECUTE') THEN 'EXECUTE' ELSE NULL END)
   							]) foo(privs) where privs is not null) AS priveleges
   			FROM preference
   			,proc
   			,LATERAL pg_identify_object(1255, oid, 0) AS obj
   			WHERE	has_function_privilege( preference.uname,oid,'EXECUTE' ) AND
   				has_schema_privilege( preference.uname, proc.pronamespace,'USAGE' )
   		)SELECT 
   			CAST( f.uname AS public.t_sysname )
   			, CAST( f.object_identity AS public.t_text)
   			, CAST( f.priveleges AS public.t_arr_code)
   		FROM function_info f(uname, object_identity, priveleges)
   		ORDER BY object_identity
   	);
   END;	
 $$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_serv_obj.auth_f_function_privileges ( public.t_sysname ) IS '114: Вывод всех привелегий роли пользователя для функций.
Входные параметры:
	1)	p_user_login	public.t_sysname	-- логин пользователя

	
Выходные параметры:
	1)	username	public.t_sysname,	-- имя пользователя
	2)	functionname	public.t_text,		-- наименование функции с определением типов аргументов
	3)	privieleges	public.t_arr_code	-- строковый масив с перечислением доступных привилегий';



-- SELECT * FROM auth_f_function_privileges('postgres'::text);

--- GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA ind TO "auth_manager";
--- GRANT USAGE ON SCHEMA ind TO "auth_manager";

--- REVOKE ALL ON ALL FUNCTIONS IN SCHEMA nso FROM "auth_manager" 
--- REVOKE USAGE ON SCHEMA ind FROM auth_manager

