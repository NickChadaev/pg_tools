DROP FUNCTION IF EXISTS auth.auth_f_view_privileges (public.t_sysname);
DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_view_privileges (public.t_sysname);

DROP FUNCTION IF EXISTS auth_f_view_privileges ( varchar(120) );
CREATE OR REPLACE FUNCTION auth_f_view_privileges (
        p_role_name    varchar(120)    -- логин пользователя
)
  RETURNS TABLE (rolename      varchar(120)
               , sch_name      varchar(120)
               , tablename     text
               , is_select     boolean          
               , is_insert     boolean          
               , is_update     boolean           
               , is_delete     boolean          
               , is_truncate   boolean            
               , is_references boolean              
               , is_trigger    boolean           
  )
AS
$$
    /*=======================================================================*/
    /* DBMS name:      PostgreSQL 8                                          */
    /* Created on:     09.08.2015 12:14:00                                   */
    /* Модификация: 2015-08-18                                               */
    /*     Отображение эффективных привелегий роли для view       Роман.     */
    /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
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
               u.uname::varchar(120)
              ,c.nspname::varchar(120)
              ,c.relname::text               
              ,has_table_privilege (u.uname, c.oid,'SELECT')       AS is_select
              ,has_table_privilege (u.uname, c.oid,'INSERT')       AS is_insert
              ,has_table_privilege (u.uname, c.oid,'UPDATE')       AS is_update 
              ,has_table_privilege (u.uname, c.oid,'DELETE')       AS is_delete
              ,has_table_privilege (u.uname, c.oid,'TRUNCATE')     AS is_truncate
              ,has_table_privilege (u.uname, c.oid,'REFERENCES')   AS is_references
              ,has_table_privilege (u.uname, c.oid,'TRIGGER')      AS is_trigger
                
             FROM iclass c, iuser u
              WHERE has_table_privilege (u.uname, c.oid, 'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER' )
                      AND
                    has_schema_privilege (u.uname, c.relnamespace,'USAGE') 
             ORDER BY c.nspname,c.relname;       
$$ 
  LANGUAGE sql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_f_view_privileges ( varchar(120) ) 
 IS '114: Отображение эффективных привелегий роли для view.

Входные параметры:
    1)  p_role_name    varchar(120)    -- Имя роли

Выходные параметры:
    1)  username        varchar(120)    -- Имя роли
    2) ,sch_name        varchar(120)    -- Имя схемы
    3) ,tablename       text,           -- Имя view
    4) ,is_select       boolean         -- Права на select 
    5) ,is_insert       boolean         -- Права на insert
    6) ,is_update       boolean         -- Права на update
    7) ,is_delete       boolean         -- Права на delete 
    8) ,is_truncate     boolean         -- Права на truncate 
    9) ,is_references   boolean         -- Права на references  
   10) ,is_trigger      boolean         -- Права на trigger
    
';  
--- SELECT * FROM auth_f_view_privileges('postgres');


