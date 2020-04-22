DROP FUNCTION IF EXISTS auth.auth_f_schema_privileges (public.t_sysname);
DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_schema_privileges (public.t_sysname);

DROP FUNCTION IF EXISTS auth_f_schema_privileges ( varchar(120) );
CREATE OR REPLACE FUNCTION auth_f_schema_privileges (
        p_role_name    varchar(120)    -- логин пользователя
)
  RETURNS TABLE (rolename      varchar(120)
               , sch_name      text
               , is_create     boolean          
               , is_usage      boolean          
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
               u.uname
              ,n.nspname::text
              ,has_schema_privilege (u.uname, n.oid,'CREATE') AS is_create
              ,has_schema_privilege (u.uname, n.oid,'USAGE')  AS is_usage
                
             FROM iclass n, iuser u
              WHERE ( n.nspname !~ '(^information_schema|^pg_t.*)' ) AND
                      ( has_schema_privilege (u.uname, n.oid, 'CREATE,USAGE'))
                 ORDER BY n.nspname;       
$$ 
  LANGUAGE sql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_f_schema_privileges ( varchar(120) ) 
 IS '114: Отображение эффективных привелегий роли для схем.

Входные параметры:
    1)  p_role_name    varchar(120)    -- Имя роли

Выходные параметры:
    1)  username        varchar(120),   -- Имя роли
    2) ,sch_name        text,           -- Имя схемы
    3) ,is_select       boolean         -- Права на CREATE 
    4) ,is_insert       boolean         -- Права на USAGE
';  
--- SELECT * FROM auth_f_schema_privileges('postgres');


