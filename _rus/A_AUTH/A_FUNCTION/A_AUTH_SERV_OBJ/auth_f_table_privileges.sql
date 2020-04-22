DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_table_privileges ( public.t_sysname );
CREATE OR REPLACE FUNCTION auth_serv_obj.auth_f_table_privileges (
        p_user_login    public.t_sysname    -- логин пользователя
)
  RETURNS table (username    public.t_sysname
               , tablename   public.t_text
               , privieleges public.t_arr_code
  )
AS
$$
    /*======================================================================*/
    /* DBMS name:      PostgreSQL 8                                         */
    /* Created on:     09.08.2015 12:14:00                                  */
    /* Модификация: 2015-08-18                                              */
    /*      Вывод всех привелегий роли пользователя для таблиц.  Роман.     */
    /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
    /*=======================================================================*/
  BEGIN
      --RAISE NOTICE 'DO auth_f_table_privileges(%)', p_user_login;
      RETURN QUERY WITH iuser AS (
          SELECT BTRIM(p_user_login)::text AS uname
      ),iclass AS(
      SELECT c.oid::oid, c.relnamespace, CAST(
          (CASE WHEN CAST( c.oid::regclass AS text) ~ '^\S+\.\S+'::text
          THEN CAST( c.oid::regclass AS text)
          ELSE n.nspname || '.' || CAST( c.oid::regclass AS text) END ) AS public.t_text) AS tblname
          FROM pg_class c
          INNER JOIN pg_namespace n on c.relnamespace=n.oid
          WHERE (c.oid >= 16384 OR c.relnamespace =2200)
          AND c.relkind='r'
          ORDER BY c.relnamespace
      ),table_priv AS (
      SELECT
          iuser.uname,
          c.tblname,
          --accepted,
          array(select privs from unnest(ARRAY [
          (CASE WHEN has_table_privilege (iuser.uname, c.oid,'SELECT') THEN 'SELECT' ELSE NULL END),
          (CASE WHEN has_table_privilege (iuser.uname, c.oid,'INSERT') THEN 'INSERT' ELSE NULL END),
          (CASE WHEN has_table_privilege (iuser.uname, c.oid,'UPDATE') THEN 'UPDATE' ELSE NULL END),
          (CASE WHEN has_table_privilege (iuser.uname, c.oid,'DELETE') THEN 'DELETE' ELSE NULL END),
          (CASE WHEN has_table_privilege (iuser.uname, c.oid,'TRUNCATE') THEN 'TRUNCATE' ELSE NULL END),
          (CASE WHEN has_table_privilege (iuser.uname, c.oid,'REFERENCES') THEN 'REFERENCES' ELSE NULL END),
          (CASE WHEN has_table_privilege (iuser.uname, c.oid,'TRIGGER') THEN 'TRIGGER' ELSE NULL END)]) foo(privs) where privs is not null) AS priv
  
          FROM iclass c
          , iuser
          , LATERAL has_table_privilege(iuser.uname, c.oid,'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER') AS accepted
          WHERE accepted
  
      )
      SELECT
          CAST(uname AS public.t_sysname),
          CAST(tblname AS public.t_text ),
          CAST(priv AS public.t_arr_code)
      FROM table_priv tp(uname, tblname, priv)
      ORDER BY tblname;
  
  END;
$$ 
  LANGUAGE plpgsql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_serv_obj.auth_f_table_privileges ( public.t_sysname ) IS '114: Вывод всех привелегий роли пользователя для последовательностей.
Входные параметры:
    1)  p_user_login    public.t_sysname    -- логин пользователя

Выходные параметры:
    1)  username        public.t_sysname,   -- имя пользователя
    2)  tablename       public.t_text,      -- наименование таблицы
    3)  privieleges     public.t_arr_code   -- строковый масив с перечислением доступных привилегий';


-- SELECT * FROM auth_f_table_privileges('postgres');
-- SELECT * FROM plpgsql_check_function_tb ('auth_serv_obj.auth_f_table_privileges (public.t_sysname)');
-- SELECT * FROM plpgsql_show_dependency_tb ('auth_serv_obj.auth_f_table_privileges (public.t_sysname)') 
-- -----------------------------------------------------------------------------------------------------
-- 'RELATION'|1259|'pg_catalog'|'pg_class'|''
-- 'RELATION'|2615|'pg_catalog'|'pg_namespace'|''

