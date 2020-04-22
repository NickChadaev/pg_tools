DROP FUNCTION IF EXISTS auth.auth_f_schema_privileges (public.t_sysname);
DROP FUNCTION IF EXISTS auth_f_schema_privileges (varchar(120));

DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_schema_privileges_3 (public.t_sysname);
CREATE OR REPLACE FUNCTION auth_serv_obj.auth_f_schema_privileges_3 (
        p_role_name   public.t_sysname   -- логин пользователя
)
  RETURNS TABLE (rolename      public.t_sysname
               , sch_name      public.t_text
               , is_create     public.t_boolean          
               , is_usage      public.t_boolean          
  )
AS
$$
    /*=======================================================================*/
    /* DBMS name:      PostgreSQL 8                                          */
    /* Created on:     09.08.2015 12:14:00                                   */
    /* Модификация: 2015-08-18                                               */
    /*      Отображение эффективных привелегий роли для схем.  Роман.        */
    /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
    /*=======================================================================*/
    WITH iuser AS ( SELECT btrim (p_role_name) AS uname
          )
          ,iclass AS
           (          
             SELECT
                 n.oid 
                ,n.nspname
                
              FROM pg_namespace n 
              WHERE ( n.nspname <> 'information_schema' )
                AND ( n.nspname !~ '^pg_temp.*' )  
              )
              SELECT
               u.uname::public.t_sysname
              ,n.nspname::public.t_text
              ,has_schema_privilege (u.uname, n.oid,'CREATE')::public.t_boolean AS is_create
              ,has_schema_privilege (u.uname, n.oid,'USAGE')::public.t_boolean  AS is_usage
                
             FROM iclass n, iuser u
              WHERE ( n.nspname !~ '(^information_schema|^pg_t.*)' ) AND
                      ( has_schema_privilege (u.uname, n.oid, 'CREATE,USAGE'))
                 ORDER BY n.nspname;       
$$ 
  LANGUAGE sql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_serv_obj.auth_f_schema_privileges_3 (public.t_sysname) 
 IS '114: Отображение эффективных привелегий роли для схем.

Входные параметры:
    1)  p_role_name   public.t_sysname   -- Имя роли

Выходные параметры:
    1)  username        public.t_sysname,   -- Имя роли
    2) ,sch_name        public.t_text,      -- Имя схемы
    3) ,is_select       public.t_boolean    -- Права на CREATE 
    4) ,is_insert       public.t_boolean    -- Права на USAGE
';  
--- SELECT * FROM auth_f_schema_privileges_3('postgres');


