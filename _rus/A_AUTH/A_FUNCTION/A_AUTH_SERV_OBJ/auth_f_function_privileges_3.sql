DROP FUNCTION IF EXISTS auth.auth_f_function_privileges (public.t_sysname);
DROP FUNCTION IF EXISTS auth_f_function_privileges ( varchar(120) );

DROP FUNCTION IF EXISTS auth_serv_obj.uth_f_function_privileges_3 (public.t_sysname);
CREATE OR REPLACE FUNCTION auth_serv_obj.auth_f_function_privileges_3 (
        p_role_name    public.t_sysname    -- логин пользователя
)
  RETURNS TABLE (rolename      public.t_sysname
               , sch_name      public.t_text
               , func_name     public.t_text
               , lang_name     public.t_text
               , func_type     public.t_text
               , is_execute    public.t_boolean          
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
                      ,t.protype::public.t_text
                      ,l.lanname::public.t_text
                      ,n.nspname::public.t_text
                      ,p.proname::public.t_text
                      
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
               u.uname::public.t_sysname
              ,f.nspname 
              ,f.proname
              ,f.lanname
              ,f.protype
              ,has_function_privilege (u.uname, f.oid, 'EXECUTE')::public.t_boolean AS is_execute
                
             FROM iclass f, iuser u
              WHERE has_function_privilege ( u.uname, f.oid, 'EXECUTE') AND
                    has_schema_privilege (u.uname, f.nspname,'USAGE') 
                 ORDER BY f.nspname;       
$$ 
  LANGUAGE sql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_serv_obj.auth_f_function_privileges_3 ( public.t_sysname ) 
 IS '114: Отображение эффективных привелегий роли для функций.

Входные параметры:
    1)  p_role_name    public.t_sysname    -- Имя роли

Выходные параметры:
       1)      sch_name      public.t_text    -- Имя схемы
       2)    , func_name     public.t_text    -- Имя функции
       3)    , lang_name     public.t_text    -- Язык
       4)    , func_type     public.t_text    -- Тип функции 
       5)    , is_execute    public.t_boolean -- Признак выполнения          
';  

-- SELECT * FROM auth_f_function_privileges_3 ('postgres') WHERE ( lang_name ~* 'sql|python')

     
