DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_schema_privileges ( public.t_sysname );
CREATE OR REPLACE FUNCTION auth_serv_obj.auth_f_schema_privileges (
            p_user_login    public.t_sysname    -- логин пользователя
				
)RETURNS TABLE (
                  username    public.t_sysname
                , schemaname  public.t_text
                , privieleges public.t_arr_code
 )
AS
 $$
    /*======================================================================*/
    /* DBMS name:      PostgreSQL 8                                         */
    /* Created on:     09.08.2015 12:14:00                                  */
    /* Модификация: 2015-08-18                                              */
    /*    Вывод всех привелегий роли пользователя для схем.  Роман.         */
    /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
    /*======================================================================*/
  BEGIN
    --RAISE NOTICE 'DO auth_f_schema_privileges(%)', p_user_login;
    RETURN QUERY (
        WITH preference AS (
            SELECT BTRIM(p_user_login)::text AS uname
        ), schema_inf AS (

            SELECT  preference.uname,
                pgc.nspname,
                ARRAY(
                    (SELECT privs FROM unnest( ARRAY[
                                ( CASE WHEN has_schema_privilege( preference.uname, pgc.oid, 'CREATE') THEN 'CREATE'::text ELSE NULL::text END ),
                                ( CASE WHEN has_schema_privilege( preference.uname, pgc.oid, 'USAGE' ) THEN 'USAGE'::text  ELSE NULL::text END )
                                ])p(privs) WHERE privs IS NOT NULL)
                )::text[] AS priv
                FROM preference,
                pg_namespace pgc
                WHERE ( has_schema_privilege( preference.uname, pgc.oid,'CREATE,USAGE') ) AND
                    ( pgc.nspname !~ '(^information_schema|^pg_t.*)' )
                ORDER BY pgc.oid, pgc.nspname

        ) SELECT
            CAST( uname AS public.t_sysname )
            , CAST( nspname AS public.t_text )
            , CAST( priv AS public.t_arr_code )
        FROM schema_inf
        ORDER BY nspname
    );
  END;
 $$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_serv_obj.auth_f_schema_privileges ( public.t_sysname ) IS '114: Вывод всех привелегий роли пользователя для схем.
Входные параметры:
    1)  p_user_login    public.t_sysname    -- логин пользователя

	
Выходные параметры:
    1)  username        public.t_sysname,   -- имя пользователя
    2)  sequencename    public.t_text,      -- наименование схемы
    3)  privieleges     public.t_arr_code   -- строковый масив с перечислением доступных привилегий';


-- SELECT * FROM auth_f_schema_privileges('postgres');
--- "postgres";"public";"{CREATE,USAGE}"
--- "postgres";"app";"{CREATE,USAGE}"
--- "postgres";"auth";"{CREATE,USAGE}"
--- "postgres";"com";"{CREATE,USAGE}"
--- "postgres";"drc";"{CREATE,USAGE}"
--- "postgres";"exn";"{CREATE,USAGE}"
--- "postgres";"nso";"{CREATE,USAGE}"
--- "postgres";"rsk";"{CREATE,USAGE}"
--- "postgres";"sch";"{CREATE,USAGE}"
--- "postgres";"uio";"{CREATE,USAGE}"
--- "postgres";"db_info";"{CREATE,USAGE}"
--- "postgres";"ind";"{CREATE,USAGE}"

-- SELECT * FROM auth_f_schema_privileges('auth_manager');
--- "auth_manager";"public";"{USAGE}"
--- "auth_manager";"auth";"{USAGE}"

