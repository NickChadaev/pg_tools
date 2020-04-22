DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_view_privileges ( public.t_sysname );
CREATE OR REPLACE FUNCTION auth_serv_obj.auth_f_view_privileges ( 
				p_user_login		public.t_sysname						-- логин пользователя
)RETURNS TABLE (
                   username    public.t_sysname
                 , viewname    public.t_text
                 , privieleges public.t_arr_code
  )
AS
 $$
       /*======================================================================*/
       /* DBMS name:      PostgreSQL 8                                         */
       /* Created on:     09.08.2015 12:14:00                                  */
       /* Модификация: 2015-08-18                                              */
       /*    Вывод всех привелегий роли пользователя для представлений. Роман. */
       /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
       /*=======================================================================*/
  BEGIN
    --RAISE NOTICE 'DO auth_f_view_privileges(%)', p_user_login;
    RETURN QUERY
    WITH pref AS (
        SELECT BTRIM(p_user_login)::text AS username
    )
    , view_info AS (
        SELECT pref.username AS username,
        CAST( ( CASE WHEN CAST( c.oid::regclass AS text) ~ '^\S+\.\S+'::text
            THEN CAST( c.oid::regclass AS text)
            ELSE n.nspname || '.' || CAST( c.oid::regclass AS text) END ) AS public.t_text) AS viewname,
        array(select privs from unnest(ARRAY [
            (CASE WHEN has_table_privilege(pref.username,c.oid,'SELECT') THEN 'SELECT' ELSE NULL END),
            (CASE WHEN has_table_privilege(pref.username,c.oid,'INSERT') THEN 'INSERT' ELSE NULL END),
            (CASE WHEN has_table_privilege(pref.username,c.oid,'UPDATE') THEN 'UPDATE' ELSE NULL END),
            (CASE WHEN has_table_privilege(pref.username,c.oid,'DELETE') THEN 'DELETE' ELSE NULL END),
            (CASE WHEN has_table_privilege(pref.username,c.oid,'TRUNCATE') THEN 'TRUNCATE' ELSE NULL END),
            (CASE WHEN has_table_privilege(pref.username,c.oid,'REFERENCES') THEN 'REFERENCES' ELSE NULL END),
            (CASE WHEN has_table_privilege(pref.username,c.oid,'TRIGGER') THEN 'TRIGGER' ELSE NULL END)]) foo(privs) where privs is not null) AS privieleges
        FROM pref,
        pg_class c JOIN pg_namespace n on c.relnamespace=n.oid
        where n.nspname !~ ('^(information_schema|pg_t.*)$')
        --and n.nspowner=0
        and c.relkind='v'
        and has_table_privilege(pref.username,c.oid,'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER')
        AND has_schema_privilege(pref.username,c.relnamespace,'USAGE')
        ORDER BY n.nspname
    ) SELECT
        CAST ( vi.username AS public.t_sysname ),
        CAST ( vi.viewname AS public.t_text ),
        CAST ( vi.privieleges AS public.t_arr_code )
    FROM view_info vi
    ORDER BY vi.viewname;
  END;
 $$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_serv_obj.auth_f_view_privileges ( public.t_sysname ) IS '114: Вывод всех привелегий роли пользователя для представлений.
Входные параметры:
    1)  p_user_login    public.t_sysname    -- логин пользователя

Выходные параметры:
    1)  username        public.t_sysname,   -- имя пользователя
    2)  viewname        public.t_text,      -- наименование представления
    3)  privieleges     public.t_arr_code   -- строковый масив с перечислением доступных привилегий';


--- SELECT * FROM auth_f_view_privileges('postgres');

