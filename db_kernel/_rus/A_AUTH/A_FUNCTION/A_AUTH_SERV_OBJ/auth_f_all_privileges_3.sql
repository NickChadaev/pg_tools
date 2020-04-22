DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_all_privileges_3 ( public.t_sysname );
CREATE OR REPLACE FUNCTION auth_serv_obj.auth_f_all_privileges_3 (
            p_user_login    public.t_sysname    -- роль 
            
) RETURNS TABLE ( rolename         public.t_sysname  -- Роль 
                , object_type      public.t_str60    -- Тип защищаемого объекта
                , sch_name         public.t_sysname  -- Имя схемы
                , object_name      public.t_text     -- Наименование защищаемого объекта
                  -- --------------------------------
                , can_create       public.t_boolean  --  Возможность создания объектов
                , can_usage        public.t_boolean  --  Возможность использования
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
     /* 2019-07-08 Новое ядро                                                     */ 
     /*========================================================================== */
   DECLARE
     _u_login PUBLIC.t_sysname := lower (btrim ( p_user_login ));
       
   BEGIN
      RETURN QUERY
        WITH x AS (
          SELECT 0 AS ordr
                         , sch.rolename
                         , 'C_SCHEMA'::public.t_str60 AS object_type
                         , sch.sch_name
                         , NULL::public.t_text AS obj_name   
                         , sch.is_create         
                         , sch.is_usage          
                         , FALSE AS is_execute-- EXECUTE
                         , FALSE AS is_select    -- is_select    
                         , FALSE AS is_insert    -- is_insert    
                         , FALSE AS is_update    -- is_update    
                         , FALSE AS is_delete    -- is_delete    
                         , FALSE AS is_truncate  -- is_truncate  
                         , FALSE AS is_references-- is_references
                         , FALSE AS is_trigger   -- is_trigger   

          FROM auth_serv_obj.auth_f_schema_privileges_3 (_u_login) sch
   
          UNION ALL
   
          SELECT 1 AS ordr
                        , tbl.rolename      
                        , 'C_TABLE'::public.t_str60 AS object_type
                        , tbl.sch_name      
                        , tbl.tablename AS obj_name    
                        , FALSE  AS is_create         -- create
                        , FALSE  AS is_usage          -- usage
                        , FALSE  AS is_execute        -- execute
                        , tbl.is_select               
                        , tbl.is_insert               
                        , tbl.is_update                
                        , tbl.is_delete               
                        , tbl.is_truncate               
                        , tbl.is_references               
                        , tbl.is_trigger               
                        
    	   FROM auth_serv_obj.auth_f_table_privileges_3 (_u_login) tbl
   
    	  	UNION ALL
        
    	   SELECT 2 AS ordr
                        , vw.rolename      
                        , 'C_VIEW'::public.t_str60 AS object_type
                        , vw.sch_name      
                        , vw.tablename  AS obj_name     
                        , FALSE  AS is_create
                        , FALSE  AS is_usage
                        , FALSE  AS is_execute
                        , vw.is_select               
                        , vw.is_insert               
                        , vw.is_update                
                        , vw.is_delete               
                        , vw.is_truncate               
                        , vw.is_references               
                        , vw.is_trigger               
    	  	FROM auth_serv_obj.auth_f_view_privileges_3 (_u_login) vw
        
    	  	UNION ALL
        
    	  	SELECT 3 AS ordr
                    , fnc.rolename      
                    , 'C_FUNCTION'::public.t_str60 AS object_type
                    , fnc.sch_name    
                    , fnc.func_name  AS obj_name     
                    , FALSE AS is_create
                    , FALSE AS is_usage
                    , is_execute    
                    , FALSE AS is_select    
                    , FALSE AS is_insert    
                    , FALSE AS is_update    
                    , FALSE AS is_delete    
                    , FALSE AS is_truncate  
                    , FALSE AS is_references
                    , FALSE AS is_trigger   
                    
            FROM auth_serv_obj.auth_f_function_privileges_3 (_u_login) fnc
        
    	  	UNION ALL
        
    	  	SELECT 4 AS ordr
                    , seq.rolename      
                    , 'C_SEQUENCE'::public.t_str60 AS object_type
                    , seq.sch_name   
                    , seq.seqname AS obj_name  
                    , FALSE       AS is_create
                    , seq.is_usage
                    , FALSE       AS is_execute
                    , seq.is_select           
                    , FALSE       AS is_insert 
                    , seq.is_update           
                    , FALSE       AS  is_delete    
                    , FALSE       AS  is_truncate  
                    , FALSE       AS  is_references
                    , FALSE       AS  is_trigger   
  
    	  	FROM auth_serv_obj.auth_f_sequence_privileges_3 (_u_login) seq
                               
--    	  	UNION ALL
    	  	
--    	  	SELECT 5 AS ordr
--                    , foo.username::public.t_sysname
--                    , 'C_ROLE'::public.t_str60 AS object_type
--                    , CAST( foo.rolename AS public.t_str1024 ) AS object_name
--                    , (CASE 
--                            WHEN foo.is_full_priv THEN '{USAGE}'::public.t_arr_code 
--                            ELSE '{MEMBER}'::public.t_arr_code 
--                       END) AS privieleges
--                  FROM prf
--                       , auth_serv_obj.auth_f_user_membership ( prf.uname ) foo ( username, rolename, is_full_priv )
               ORDER BY 1, 3 
        )  
          SELECT
                     x.rolename      
                    ,x.object_type
                    ,x.sch_name::public.t_sysname  
                    ,x.obj_name  
                    ,x.is_create::public.t_boolean 
                    ,x.is_usage::public.t_boolean 
                    ,x.is_execute::public.t_boolean 
                    ,x.is_select::public.t_boolean            
                    ,x.is_insert::public.t_boolean  
                    ,x.is_update::public.t_boolean            
                    ,x.is_delete::public.t_boolean     
                    ,x.is_truncate::public.t_boolean   
                    ,x.is_references::public.t_boolean 
                    ,x.is_trigger::public.t_boolean    
           FROM x;
   END;
 $$ LANGUAGE plpgsql
        STABLE SECURITY DEFINER;

COMMENT ON FUNCTION auth_serv_obj.auth_f_all_privileges_3 ( public.t_sysname ) IS '130: Вывод всех привелегий для выбранной роли

Входные параметры:
             1)  public.t_sysname    -- имя роли

Выходные параметры:
            1)    username         public.t_sysname  --  Роль 
            2)  , object_type      public.t_str60    --  Тип защищаемого объекта
            3)  , sch_name         public.t_sysname  --  Наименование схемы
            4)  , object_name      public.t_str1024  --  Наименование защищаемого объекта
                  -- --------------------------------------------------------------------
            5)  , can_create       public.t_boolean  --  Возможность создания объектов
            6)  , can_usage        public.t_boolean  --  Возможность использования
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
)';

--- SELECT * FROM auth_serv_obj.auth_f_all_privileges_3 ('public');
--- SELECT * FROM auth_serv_obj.auth_f_all_privileges_3 ('almaz20');
--- REVOKE ALL PRIVILEGES ON SCHEMA ind FROM auth_manager;
--- SELECT * FROM auth_f_all_privileges_3 ('auth_manager');

--- SELECT * FROM auth_f_all_privileges_3 ('writer');
--  SELECT * FROM auth_f_all_privileges_3 ('dummy');
--  SELECT * FROM auth_f_all_privileges_3 ('almaz1');
