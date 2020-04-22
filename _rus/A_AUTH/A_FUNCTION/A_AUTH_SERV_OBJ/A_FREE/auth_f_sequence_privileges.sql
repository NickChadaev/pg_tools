DROP FUNCTION IF EXISTS auth.auth_f_sequence_privileges (public.t_sysname);
DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_sequence_privileges (public.t_sysname);
--
DROP FUNCTION IF EXISTS auth_f_sequence_privileges ( varchar(120) );
CREATE OR REPLACE FUNCTION auth_f_sequence_privileges (
        p_role_name    varchar(120)    -- логин пользователя
)
  RETURNS TABLE (rolename      varchar(120)
               , sch_name      varchar(120) 
               , seqname       text
               , is_select     boolean          
               , is_update     boolean          
               , is_usage      boolean           
  )
AS
$$
  /*====================================================================== */
  /* DBMS name:      PostgreSQL 8                                          */
  /* Created on:     09.08.2015 12:14:00                                   */
  /* Модификация: 2015-08-18                                               */
  /*   Отображение эффективных привелегий роли для последовательностей.    */
  /*                          Роман.                                       */
  /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
  /*=======================================================================*/
    WITH iuser AS ( SELECT btrim (p_role_name) AS uname
          )
          ,iclass AS
           (          
             SELECT
                 c.oid 
                ,n.nspname AS sch_name 
                ,c.relname AS seqname
                ,c.relnamespace
                
              FROM pg_namespace n 
                     JOIN pg_class c ON n.oid = c.relnamespace
              WHERE ( (c.relkind = 'S')
                AND ( n.nspname <> 'information_schema' )
                AND ( n.nspname !~ '^pg_temp.*' )  
              )
            )
              SELECT
               u.uname::varchar(120)
              ,c.sch_name::varchar(120) 
              ,c.seqname::text
              ,has_sequence_privilege (u.uname, c.oid,'SELECT') AS is_select
              ,has_sequence_privilege (u.uname, c.oid,'UPDATE') AS is_update
              ,has_sequence_privilege (u.uname, c.oid,'USAGE')  AS is_usage 
                
             FROM iclass c, iuser u
              WHERE has_sequence_privilege (u.uname, c.oid, 'SELECT,UPDATE,USAGE')
                      AND
                    has_schema_privilege (u.uname, c.relnamespace,'USAGE') 

              ORDER BY c.seqname;       
$$ 
   LANGUAGE sql 
   STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_f_sequence_privileges ( varchar(120) ) 
IS '114: Отображение эффективных привелегий роли для последовательностей.

Входные параметры:
    1)  p_user_login    varchar(120)    -- Имя роли

Выходные параметры:
    1)   username        varchar(120)   -- Имя роли
    2)  ,sch_name        varchar(120)   -- Имя схемы 
    3)  ,sequencename    text           -- Наименование последовательности
    4)  ,is_select       boolean        -- Права на SELECT 
    5)  ,is_update       boolean        -- Права на UPDATE 
    6)  ,is_usage        boolean        -- Права на USAGE  
';

--- SELECT * FROM auth_f_sequence_privileges('postgres');
--- SELECT * FROM auth.auth_f_sequence_privileges('auth_manager');

