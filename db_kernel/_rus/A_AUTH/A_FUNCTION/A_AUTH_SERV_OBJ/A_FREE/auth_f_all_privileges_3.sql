DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_all_privileges_3 ( public.t_sysname );
CREATE OR REPLACE FUNCTION auth_serv_obj.auth_f_all_privileges_3 (
            p_user_login    public.t_sysname    -- роль/профиль пользователя
            
) RETURNS TABLE ( username         public.t_sysname  -- Роль/профиль пользователя
                , object_type      public.t_str60    -- Тип защищаемого объекта
                , object_type_name public.t_str250   -- Наименование типа объекта
                , object_name      public.t_str1024  -- Наименование защищаемого объекта
                  -- --------------------------------
                , can_usage        public.t_boolean  --  Возможность использования
                , can_create       public.t_boolean  --  Возможность создания объектов
                , can_execute      public.t_boolean  --  Возможность выполнения
                , can_select       public.t_boolean  --  Возможность выборки      
                  --                                                           
                , can_insert       public.t_boolean  --  Возможность создания данных
                , can_update       public.t_boolean  --  Возможность обновления
                , can_delete       public.t_boolean  --  Возможность удаления
                , can_truncate     public.t_boolean  --  Возможность очистки от данных
                  --
                , can_reference    public.t_boolean  --  Возможность создания ограничений
                , can_trigger      public.t_boolean  --  Возможность создания/управления триггерами
                , can_connect      public.t_boolean  --  Возможность соединения с внешними объектами
                , can_temp         public.t_boolean  --  Возможность создания временных объектов
)
AS
 $$
     /*========================================================================== */
     /* DBMS name:      PostgreSQL 8                                              */
     /* Created on:     09.08.2015 12:14:00                                       */
     /* Модификация: 2015-08-18                                                   */
     /*            Вывод всех привелегий роли пользователя. Роман.                */
     /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.    */
     /* ------------------------------------------------------------------------- */
     /* 2015-12-10 Nick Типизация должна выполняться строго в соответствии с      */
     /*                 кодификатором.                                            */
     /*     SELECT * FROM com.com_f_obj_codifier_s_sys ('C_BD_TYPE');             */ 
     /*        'C_BD_TYPE'                                                        */
     /*        'C_BD'                                                             */
     /*        'C_SCHEMA'                                                         */ 
     /*        'C_TABLE'                                                          */
     /*        'C_VIEW'                                                           */
     /*        'C_FUNCTION'                                                       */
     /*        'C_TRIGGER'                                                        */
     /*        'C_CHECK'                                                          */ 
     /*        'C_SEQUENCE'                                                       */
     /*        -- Добавить роль в кодификатор 'C_ROLE'                            */
     /* ------------------------------------------------------------------------- */
     /* 2016-01-16 Единый формат выходных данных. Права планируемые и фактические */
     /*========================================================================== */
   DECLARE
     _u_login PUBLIC.t_sysname := lower (btrim ( p_user_login ));
       
   BEGIN
       IF ( _u_login = 'public' ) THEN
          RETURN QUERY
          (
              WITH preference AS (
                  SELECT _u_login::t_text AS uname
              )
              ,union_privs AS (
                      
                  --- Объединяем со всеми публичными привелегиями
                  SELECT 0 AS ordr
                            , fsch.username::public.t_sysname
                            , 'C_SCHEMA'::public.t_str60 AS object_type
                            , fsch.schemaname::public.t_str1024  AS object_name
                            , fsch.privieleges
                      FROM auth_serv_obj.auth_f_schema_privileges ( 'public'::public.t_sysname ) fsch ( username, schemaname, privieleges )
      
                  UNION ALL
      
                  SELECT 1 AS ordr
                            , fsct.username::public.t_sysname
                            , 'C_TABLE'::public.t_str60 AS object_type
                            , fsct.tablename::public.t_str1024 AS object_name 
                            , fsct.privieleges
                      FROM auth_serv_obj.auth_f_table_privileges ( 'public'::public.t_sysname ) fsct ( username, tablename, privieleges )
      
                  UNION ALL
      
                  SELECT 2 AS ordr
                            , fscf.username::public.t_sysname
                            , 'C_FUNCTION'::public.t_str60 AS object_type
                            , fscf.functionname::public.t_str1024 AS object_name
                            , fscf.privieleges
                      FROM auth_serv_obj.auth_f_function_privileges ( 'public'::public.t_sysname )  fscf ( username, functionname, privieleges )
      
                  UNION ALL
      
                  SELECT 3 AS ordr
                             , fscq.username::public.t_sysname
                             , 'C_SEQUENCE'::public.t_str60 AS object_type
                             , fscq.sequencename::public.t_str1024 AS object_name
                             , fscq.privieleges
                      FROM auth_serv_obj.auth_f_sequence_privileges ( 'public'::public.t_sysname ) fscq ( username, sequencename, privieleges )
      
                  UNION ALL
      
                  SELECT 4 AS ordr
                            , fscv.username::public.t_sysname
                            , 'C_VIEW'::public.t_str60 AS object_type
                            , fscv.viewname::public.t_str1024 AS object_name
                            , fscv.privieleges
                      FROM auth_serv_obj.auth_f_view_privileges ('public'::public.t_sysname)  fscv ( username, viewname, privieleges )
              )
                  SELECT u.username
                       , u.object_type
                       , c.codif_name      AS object_type_name
                       , u.object_name
                       -- --------------------------------------------------------------------
                       , ( 'USAGE'    = ANY (u.privieleges))::public.t_boolean   AS can_usage
                       , ( 'CREATE'   = ANY (u.privieleges))::public.t_boolean   AS can_create
                       , ( 'EXECUTE'  = ANY (u.privieleges))::public.t_boolean   AS can_trigger
                       , ( 'SELECT'   = ANY (u.privieleges))::public.t_boolean   AS can_select  
                          --                        
                       , ( 'INSERT'   = ANY (u.privieleges))::public.t_boolean   AS can_insert               
                       , ( 'UPDATE'   = ANY (u.privieleges))::public.t_boolean   AS can_update  
                       , ( 'DELETE'   = ANY (u.privieleges))::public.t_boolean   AS can_delete
                       , ( 'TRUNCATE' = ANY (u.privieleges))::public.t_boolean   AS can_truncate
                          --
                       , ( 'REFERENCE'= ANY (u.privieleges))::public.t_boolean   AS can_truncate
                       , ( 'TRIGGER'  = ANY (u.privieleges))::public.t_boolean   AS can_trigger
                       , ( 'CONNECT'  = ANY (u.privieleges))::public.t_boolean   AS can_connect
                       , ( 'TEMP'     = ANY (u.privieleges))::public.t_boolean   AS can_temp
   
                      FROM union_privs u, ONLY com.obj_codifier c WHERE ( u.object_type = c.codif_code )
                  ORDER BY u.ordr, u.object_name 
       );
       ELSE
          RETURN QUERY
          (
              WITH preference AS (
                  SELECT _u_login::t_text AS uname
              )
              ,union_privs AS (
                SELECT 0 AS ordr
                              , foo.username::public.t_sysname
                              , 'C_SCHEMA'::public.t_str60 AS object_type
                              , foo.schemaname::public.t_str1024 AS object_name
                              , foo.privieleges
                    FROM preference
                       , auth_serv_obj.auth_f_schema_privileges ( preference.uname ) foo (username, schemaname, privieleges )
   
                UNION ALL
   
                SELECT 1 AS ordr
                              , foo.username::public.t_sysname
                              , 'C_TABLE'::public.t_str60 AS object_type
                              , foo.tablename::public.t_str1024 AS object_name
                              , foo.privieleges
    			    FROM preference
                   , auth_serv_obj.auth_f_table_privileges ( preference.uname ) foo ( username, tablename, privieleges )
   
    		    	UNION ALL
             
    		    	SELECT 2 AS ordr
                          , foo.username::public.t_sysname
                          , 'C_VIEW'::public.t_str60 AS object_type
                          , foo.viewname::public.t_str1024 AS object_name
                          , foo.privieleges::t_arr_code  
    		    	    FROM preference
                        , auth_serv_obj.auth_f_view_privileges ( preference.uname ) foo ( username, viewname, privieleges )
             
    		    	UNION ALL
             
    		    	SELECT 3 AS ordr
                          , foo.username::public.t_sysname
                          , 'C_FUNCTION'::public.t_str60 AS object_type
                          , foo.functionname::public.t_str1024 AS object_name
                          , foo.privieleges::t_arr_code  
    		    	    FROM preference, auth_serv_obj.auth_f_function_privileges ( preference.uname ) foo ( username, functionname, privieleges )
             
    		    	UNION ALL
             
    		    	SELECT 4 AS ordr
                          , foo.username::public.t_sysname
                          , 'C_SEQUENCE'::public.t_str60 AS object_type
                          , foo.sequencename::public.t_str1024 AS object_name
                          , foo.privieleges::t_arr_code  
    		    	    FROM preference
                                     , auth_serv_obj.auth_f_sequence_privileges ( preference.uname ) foo ( username, sequencename, privieleges) 
                                     
    		    	UNION ALL
    		    	
    		    	SELECT 5 AS ordr
                          , foo.username::public.t_sysname
                          , 'C_ROLE'::public.t_str60 AS object_type
                          , CAST( foo.rolename AS public.t_str1024 ) AS object_name
                          , (CASE 
                                  WHEN foo.is_full_priv THEN '{USAGE}'::public.t_arr_code 
                                  ELSE '{MEMBER}'::public.t_arr_code 
                             END) AS privieleges
                        FROM preference
                             , auth_serv_obj.auth_f_user_membership ( preference.uname ) foo ( username, rolename, is_full_priv )
             
                 )
                  SELECT u.username
                       , u.object_type
                       , c.codif_name      AS object_type_name
                       , u.object_name
                       -- --------------------------------------------------------------------
                       , ( 'USAGE'    = ANY (u.privieleges))::public.t_boolean   AS can_usage
                       , ( 'CREATE'   = ANY (u.privieleges))::public.t_boolean   AS can_create
                       , ( 'EXECUTE'  = ANY (u.privieleges))::public.t_boolean   AS can_trigger
                       , ( 'SELECT'   = ANY (u.privieleges))::public.t_boolean   AS can_select  
                          --                        
                       , ( 'INSERT'   = ANY (u.privieleges))::public.t_boolean   AS can_insert               
                       , ( 'UPDATE'   = ANY (u.privieleges))::public.t_boolean   AS can_update  
                       , ( 'DELETE'   = ANY (u.privieleges))::public.t_boolean   AS can_delete
                       , ( 'TRUNCATE' = ANY (u.privieleges))::public.t_boolean   AS can_truncate
                          --
                       , ( 'REFERENCE'= ANY (u.privieleges))::public.t_boolean   AS can_truncate
                       , ( 'TRIGGER'  = ANY (u.privieleges))::public.t_boolean   AS can_trigger
                       , ( 'CONNECT'  = ANY (u.privieleges))::public.t_boolean   AS can_connect
                       , ( 'TEMP'     = ANY (u.privieleges))::public.t_boolean   AS can_temp
   
                      FROM union_privs u, ONLY com.obj_codifier c WHERE ( u.object_type = c.codif_code )
                  ORDER BY u.ordr, u.object_name 
       );
       END IF;
   
   END;
 $$ LANGUAGE plpgsql
        STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_serv_obj.auth_f_all_privileges_3 ( public.t_sysname ) IS 'Вывод всех привелегий роли пользователя	.
Входные параметры:
             1)  public.t_sysname    -- профиль пользователя/имя роли

Выходные параметры:
            1)    username         public.t_sysname  --  Роль/профиль пользователя
            2)  , object_type      public.t_str60    --  Тип защищаемого объекта
            3)  , object_type_name public.t_str250   --  Наименование типа объекта
            4)  , object_name      public.t_str1024  --  Наименование защищаемого объекта
                  -- --------------------------------------------------------------------
            5)  , can_usage        public.t_boolean  --  Возможность использования
            6)  , can_create       public.t_boolean  --  Возможность создания объектов
            7)  , can_execute      public.t_boolean  --  Возможность выполнения
            8)  , can_select       public.t_boolean  --  Возможность выборки 
                  -- --------------------------------------------------------------------                                                                
            9)  , can_insert       public.t_boolean  --  Возможность создания данных
           10)  , can_update       public.t_boolean  --  Возможность обновления
           11)  , can_delete       public.t_boolean  --  Возможность удаления
           12)  , can_truncate     public.t_boolean  --  Возможность очистки от данных
                  -- --------------------------------------------------------------------
           13)  , can_reference    public.t_boolean  --  Возможность создания ограничений
           14)  , can_trigger      public.t_boolean  --  Возможность создания/управления триггерами
           15)  , can_connect      public.t_boolean  --  Возможность соединения с внешними объектами
           16)  , can_temp         public.t_boolean  --  Возможность создания временных объектов
)';

--- SELECT * FROM auth_f_all_privileges_3 ('public');

--- REVOKE ALL PRIVILEGES ON SCHEMA ind FROM auth_manager;
--- SELECT * FROM auth_f_all_privileges_3 ('auth_manager');

--- SELECT * FROM auth_f_all_privileges_3 ('writer');
--  SELECT * FROM auth_f_all_privileges_3 ('dummy');
--  SELECT * FROM auth_f_all_privileges_3 ('almaz1');
