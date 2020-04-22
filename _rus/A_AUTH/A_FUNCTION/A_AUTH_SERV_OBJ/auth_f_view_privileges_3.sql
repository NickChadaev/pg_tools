DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_view_privileges_3 (public.t_sysname);
CREATE OR REPLACE FUNCTION auth_serv_obj.auth_f_view_privileges_3 (
        p_role_name    public.t_sysname    -- логин пользователя
)
  RETURNS TABLE (rolename      public.t_sysname
               , sch_name      public.t_sysname
               , tablename     public.t_text
               , is_select     public.t_boolean          
               , is_insert     public.t_boolean          
               , is_update     public.t_boolean           
               , is_delete     public.t_boolean          
               , is_truncate   public.t_boolean            
               , is_references public.t_boolean              
               , is_trigger    public.t_boolean           
  )
AS
$$
    /*=======================================================================*/
    /* DBMS name:      PostgreSQL 8                                          */
    /* Created on:     09.08.2015 12:14:00                                   */
    /* Модификация: 2015-08-18                                               */
    /*     Отображение эффективных привелегий роли для view       Роман.     */
    /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
    /* 2019-07-07 Nick        Новое ядро                                     */
    /*=======================================================================*/
    WITH iuser AS ( SELECT btrim (p_role_name) AS uname
          )
          ,iclass AS
           (          
             SELECT
                 c.oid 
                ,n.nspname 
                ,c.relname 
                ,c.relnamespace
              FROM pg_namespace n 
                     JOIN pg_class c ON n.oid = c.relnamespace
              WHERE ( (c.relkind IN ('v', 'm'))
                AND ( n.nspname <> 'information_schema' )
                AND ( n.nspname !~ '^pg_temp.*' )  
              )
            )
              SELECT
               u.uname::public.t_sysname
              ,c.nspname::public.t_sysname
              ,c.relname::public.t_text    
               --
              ,has_table_privilege (u.uname, c.oid,'SELECT')::public.t_boolean     AS is_select
              ,has_table_privilege (u.uname, c.oid,'INSERT')::public.t_boolean     AS is_insert
              ,has_table_privilege (u.uname, c.oid,'UPDATE')::public.t_boolean     AS is_update 
              ,has_table_privilege (u.uname, c.oid,'DELETE')::public.t_boolean     AS is_delete
              ,has_table_privilege (u.uname, c.oid,'TRUNCATE')::public.t_boolean   AS is_truncate
              ,has_table_privilege (u.uname, c.oid,'REFERENCES')::public.t_boolean AS is_references
              ,has_table_privilege (u.uname, c.oid,'TRIGGER')::public.t_boolean    AS is_trigger
                
             FROM iclass c, iuser u
              WHERE has_table_privilege (u.uname, c.oid, 'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER' )
                      AND
                    has_schema_privilege (u.uname, c.relnamespace,'USAGE') 
             ORDER BY c.nspname,c.relname;       
$$ 
  LANGUAGE sql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_serv_obj.auth_f_view_privileges_3 ( public.t_sysname ) 
 IS '114: Отображение эффективных привелегий роли для view.

Входные параметры:
    1)  p_role_name    public.t_sysname    -- Имя роли

Выходные параметры:
    1)  username        public.t_sysname    -- Имя роли
    2) ,sch_name        public.t_sysname    -- Имя схемы
    3) ,tablename       public.t_text,      -- Имя view
    4) ,is_select       public.t_boolean    -- Права на select 
    5) ,is_insert       public.t_boolean    -- Права на insert
    6) ,is_update       public.t_boolean    -- Права на update
    7) ,is_delete       public.t_boolean    -- Права на delete 
    8) ,is_truncate     public.t_boolean    -- Права на truncate 
    9) ,is_references   public.t_boolean    -- Права на references  
   10) ,is_trigger      public.t_boolean    -- Права на trigger
    
';  
--- SELECT * FROM auth_f_view_privileges_3('postgres');


