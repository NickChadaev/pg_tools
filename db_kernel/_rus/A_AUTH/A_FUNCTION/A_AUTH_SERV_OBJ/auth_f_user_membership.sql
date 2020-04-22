DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_user_membership( public.t_sysname );
CREATE OR REPLACE FUNCTION auth_serv_obj.auth_f_user_membership (
              p_role_name    public.t_sysname    -- Имя выбранной роли
)  RETURNS table (
                  username      public.t_sysname
                , rolename      public.t_sysname
                , is_full_priv  public.t_boolean
    )
AS
 $$
   /*======================================================================*/
   /* DBMS name:      PostgreSQL 8                                         */
   /* Created on:     08.12.2015                                           */
   /* Модификация:                                                         */
   /*    Вывод всех ролей привилегии которых прямо или косвенно наследует  */
   /* выбранная роль в момент вызова функции.  Роман.                      */
   /*----------------------------------------------------------------------*/
   /*    Примечание:                                                       */
   /*    Данная функция выводит реальные роли связанные с указанным        */
   /*    пользователем, а не планируемые(отношение auth.auth_user_role).   */
   /*======================================================================*/
    WITH ir AS (
                  SELECT btrim(p_role_name)::text AS rnm
     )
     ,irs AS (
              SELECT rolname FROM pg_catalog.pg_roles, ir 
                    WHERE ((rolname != ir.rnm) AND (ir.rnm !~ 'public'))
     )
     ,members AS (
                   SELECT
                       ir.rnm,
                       irs.rolname,
                       pg_has_role (ir.rnm, irs.rolname,'USAGE'::text) AS priv
                   FROM irs
                       ,ir
                  WHERE pg_has_role (ir.rnm, irs.rolname,'MEMBER'::text)
     )
      SELECT
         CAST (rnm     AS public.t_sysname) AS rnm 
        ,CAST (rolname AS public.t_sysname) AS rolname
        ,CAST (priv    AS public.t_boolean) AS priv
      FROM members 
     
     UNION ALL 
     
     SELECT
           CAST (rnm      AS public.t_sysname) AS rnm 
          ,CAST ('public' AS public.t_sysname) AS rolname
          ,CAST (true     AS public.t_boolean) AS priv
     FROM ir
 
     ORDER BY priv, rolname;
 $$ 
    LANGUAGE sql STABLE 
    SET search_path = auth_serv_obj, auth, nso, com, public, pg_catalog
    SECURITY DEFINER;

COMMENT ON FUNCTION auth_serv_obj.auth_f_user_membership ( public.t_sysname ) 
IS '130: Вывод всех ролей, чьи привилегии прямо или косвенно наследует выбранная роль.

   Входные параметры:
       1)  p_role_name    public.t_sysname    -- Имя выбранной роли

   Выходные параметры:
       1)  username      public.t_sysname,   --  Имя выбранной роли
       2)  rolename      public.t_sysname,   --  имя наследуемой роли
       3)  is_full_priv  public.t_boolean    --  TRUE полное наследование(прямое),
                                                FALSE доступ ко всем объектам можно
                                                получить только после вызова SET ROLE
';

--- До подключения сессии пользователя
/*
    SELECT * FROM auth_f_user_membership('almaz20');

    --- "admin_su_4";"IDLE";t
*/

--- После подключения сессии пользователя
/*
    SELECT auth.auth_p_user_con('admin_su_4', '123456', '0.0.0.0');
    SELECT * FROM auth_f_user_membership('admin_su_4');

    --- "admin_su_4";"dummy";t
    --- "admin_su_4";"rootadmin";t
*/

--- После отключения сессии пользователя
/*
    SELECT auth.auth_p_user_dis('admin_su_4');
    SELECT * FROM auth_f_user_membership('admin_su_4');

    --- "admin_su_4";"IDLE";t
*/

--- SELECT * FROM auth_f_user_membership('rootadmin');
    --- "rootadmin";"dummy";t

--- SELECT * FROM auth_f_user_membership('writer');
    --- "writer";"dummy";t
    --- "writer";"reader";t

--- SELECT * FROM auth_f_user_membership('reader');

---- 
-- SELECT * FROM auth.auth_f_user_s(); -- 'user_knz_1'
--
-- SELECT * FROM auth_f_user_membership('user_knz_1'); -- но почему не dummy ??? Nick 2015-12-10
-- SELECT * FROM auth.auth_p_user_con ('user_knz_1', '123456', '192.168.10.23');
-- SELECT * FROM auth_f_user_membership('user_knz_1');
--
-- 'user_knz_1'|'iddle'|t
-- 'user_knz_1'|'reader'|t
-- 'user_knz_1'|'writer'|t
--
-- SELECT * FROM auth.auth_p_user_dis ('user_knz_1');
-- SELECT * FROM auth_f_user_membership('user_knz_1');
    --- "reader";"dummy";t

--- SELECT * FROM auth_f_user_membership('dummy');
    --- "writer";"dummy";t
    --- "writer";"reader";t



