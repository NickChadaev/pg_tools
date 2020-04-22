DROP FUNCTION IF EXISTS auth.auth_f_sequence_privileges (public.t_sysname);
DROP FUNCTION IF EXISTS auth_f_sequence_privileges (varchar(120));
--
DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_sequence_privileges_3 (public.t_sysname);
CREATE OR REPLACE FUNCTION auth_serv_obj.auth_f_sequence_privileges_3 (
        p_role_name    public.t_sysname    -- логин пользователя
)
  RETURNS TABLE (rolename      public.t_sysname
               , sch_name      public.t_sysname 
               , seqname       public.t_text
               , is_select     public.t_boolean          
               , is_update     public.t_boolean          
               , is_usage      public.t_boolean           
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
  /* 2019-07-07  Новое ядро                                                */
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
               u.uname::public.t_sysname
              ,c.sch_name::public.t_sysname 
              ,c.seqname::public.t_text
              ,has_sequence_privilege (u.uname, c.oid,'SELECT')::public.t_boolean AS is_select
              ,has_sequence_privilege (u.uname, c.oid,'UPDATE')::public.t_boolean AS is_update
              ,has_sequence_privilege (u.uname, c.oid,'USAGE')::public.t_boolean  AS is_usage 
                
             FROM iclass c, iuser u
              WHERE has_sequence_privilege (u.uname, c.oid, 'SELECT,UPDATE,USAGE')
                      AND
                    has_schema_privilege (u.uname, c.relnamespace,'USAGE') 

              ORDER BY c.seqname;       
$$ 
   LANGUAGE sql 
   STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_serv_obj.auth_f_sequence_privileges_3 ( public.t_sysname ) 
IS '114: Отображение эффективных привелегий роли для последовательностей.

Входные параметры:
    1)  p_user_login    public.t_sysname    -- Имя роли

Выходные параметры:
    1)   username        public.t_sysname   -- Имя роли
    2)  ,sch_name        public.t_sysname   -- Имя схемы 
    3)  ,sequencename    public.t_text           -- Наименование последовательности
    4)  ,is_select       public.t_boolean        -- Права на SELECT 
    5)  ,is_update       public.t_boolean        -- Права на UPDATE 
    6)  ,is_usage        public.t_boolean        -- Права на USAGE  
';

--- SELECT * FROM auth_serv_obj.auth_f_sequence_privileges_3('postgres');
--- SELECT * FROM auth.auth_f_sequence_privileges('auth_manager');

