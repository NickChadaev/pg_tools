DROP FUNCTION IF EXISTS auth.auth_f_function_privileges (public.t_sysname);
DROP FUNCTION IF EXISTS auth_serv_obj.uth_f_function_privileges (public.t_sysname);

DROP FUNCTION IF EXISTS auth_f_function_privileges ( varchar(120) );
CREATE OR REPLACE FUNCTION auth_f_function_privileges (
        p_role_name    varchar(120)    -- логин пользователя
)
  RETURNS TABLE (rolename      varchar(120)
               , sch_name      text
               , func_name     text
               , lang_name     text
               , func_type     text
               , is_execute    boolean          
 )
AS
$$
    /*=======================================================================*/
    /* DBMS name:      PostgreSQL 8                                          */
    /* Created on:     09.08.2015 12:14:00                                   */
    /* Модификация: 2015-08-18                                               */
    /*      Отображение эффективных привелегий роли для функций.  Роман.     */
    /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
    /* 2017-12-26 Gregory  -- Модификация                                    */   
    /*=======================================================================*/
    WITH iuser AS ( SELECT btrim (p_role_name) AS uname
          )
          ,iclass AS
           (          
             SELECT
                       p.oid
                      ,t.protype::text
                      ,l.lanname::text
                      ,n.nspname::text
                      ,p.proname::text
                      
               FROM pg_proc p
                 JOIN pg_namespace n ON n.oid = p.pronamespace
                 JOIN pg_language  l ON l.oid = p.prolang
               JOIN LATERAL ( SELECT  
                                CASE
                                   WHEN p.prorettype = 'trigger'::regtype THEN 'trigger'
                                    ELSE 'normal'
                                END::public.t_sysname AS protype
               ) AS t
                      ON TRUE          
             WHERE ( n.nspname !~ '(^information_schema|^pg_cat.*)' )              
     )
              SELECT
               u.uname
              ,f.nspname 
              ,f.proname
              ,f.lanname
              ,f.protype
              ,has_function_privilege (u.uname, f.oid, 'EXECUTE') AS is_execute
                
             FROM iclass f, iuser u
              WHERE has_function_privilege ( u.uname, f.oid, 'EXECUTE') AND
                    has_schema_privilege (u.uname, f.nspname,'USAGE') 
                 ORDER BY f.nspname;       
$$ 
  LANGUAGE sql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_f_function_privileges ( varchar(120) ) 
 IS '114: Отображение эффективных привелегий роли для функций.

Входные параметры:
    1)  p_role_name    varchar(120)    -- Имя роли

Выходные параметры:
    1)  username        varchar(120),   -- Имя роли
    2) ,sch_name        text,           -- Имя функции
    3) ,is_select       boolean         -- Права на CREATE 
    4) ,is_insert       boolean         -- Права на USAGE
';  

-- SELECT * FROM auth_f_function_privileges ('postgres') WHERE ( lang_name ~* 'sql|python')

     
