DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_sequence_privileges ( public.t_sysname );
CREATE OR REPLACE FUNCTION auth_serv_obj.auth_f_sequence_privileges (
            p_user_login1   public.t_sysname    -- логин пользователя
) RETURNS 
        TABLE ( username     public.t_sysname
              , sequencename public.t_text
              , privieleges  public.t_arr_code
        )
AS
$$
  /*======================================================================*/
  /* DBMS name:      PostgreSQL 8                                         */
  /* Created on:     09.08.2015 12:14:00                                  */
  /* Модификация: 2015-08-18                                              */
  /*    Вывод всех привелегий роли пользователя для последовательностей.  */
  /*                          Роман.                                      */
  /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
  /*=======================================================================*/
   BEGIN
       --RAISE NOTICE 'DO auth_f_sequence_privileges(%)', p_user_login1;
       RETURN QUERY
   
       WITH pref AS (
           SELECT BTRIM(p_user_login1)::text AS uname
       )
       , sequence_info AS(
   
           SELECT  pref.uname,
                   CAST(
                       (CASE WHEN CAST( c.oid::regclass AS text) ~ '^\S+\.\S+'::text THEN CAST( c.oid::regclass AS text)
                           ELSE n.nspname || '.' || CAST( c.oid::regclass AS text) END ) AS public.t_text)
                   AS seqname,
               array(select privs from unnest(ARRAY [
                   (CASE WHEN has_sequence_privilege(pref.uname, c.oid,'SELECT') THEN 'SELECT' ELSE NULL END),
                   (CASE WHEN has_sequence_privilege(pref.uname, c.oid,'UPDATE') THEN 'UPDATE' ELSE NULL END),
                   (CASE WHEN has_sequence_privilege(pref.uname, c.oid,'USAGE') THEN 'USAGE' ELSE NULL END)]) foo(privs) where privs is not null) AS priv
               FROM pref
               ,pg_class c
               JOIN pg_namespace n on c.relnamespace=n.oid
               WHERE ( n.nspname !~ ('^(information_schema|pg_t.*)$') )
                   --and n.nspowner=0
                   and (c.relkind='S')
                   and (has_sequence_privilege( pref.uname, c.oid, 'SELECT,UPDATE,USAGE')=true)
                   AND (has_schema_privilege( pref.uname, c.relnamespace, 'USAGE')=true)
       )
       SELECT
           CAST( si.uname AS public.t_sysname),
           CAST( si.seqname AS public.t_text),
           CAST( si.priv AS public.t_arr_code)
       FROM sequence_info si
       ORDER BY seqname;
   END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_serv_obj.auth_f_sequence_privileges ( public.t_sysname ) IS '114: Вывод всех привелегий роли пользователя для последовательностей.
Входные параметры:
    1)  p_user_login    public.t_sysname    -- логин пользователя

Выходные параметры:
    1)  username        public.t_sysname,   -- имя пользователя
    2)  sequencename    public.t_text,      -- наименование последовательности
    3)  privieleges     public.t_arr_code   -- строковый масив с перечислением доступных привилегий';


--- SELECT * FROM auth.auth_f_sequence_privileges('postgres');
--- SELECT * FROM auth.auth_f_sequence_privileges('auth_manager');

