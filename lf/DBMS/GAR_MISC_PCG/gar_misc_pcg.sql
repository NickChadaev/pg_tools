
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW public.version
 AS
 SELECT '$Revision:213568b$ modified $RevDate:2022-10-24$'::text AS version; 

-- SELECT * FROM public.version;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP EVENT TRIGGER IF EXISTS etg_check CASCADE;
CREATE OR REPLACE FUNCTION public.etg_check_func() RETURNS event_trigger
AS 
$$
-- --------------------------------------------------------------------------
--  2021-10-28 Nick Триггерная функция для проверки кода создаваемой функции,
--                  с использованием расширения plpgsql_check.
-- --------------------------------------------------------------------------
   DECLARE
   _x oid;
   _z text;
   
   BEGIN
    _x := (SELECT max(p.oid) FROM pg_catalog.pg_proc p);
     
    -- Проверка того факта, что новая функция написана на plpgsql 
    IF (EXISTS (SELECT 1 FROM pg_catalog.pg_proc p
                     JOIN pg_language l ON (l.oid = p.prolang)
                                  WHERE (l.lanname = 'plpgsql') AND (p.oid = _x)    
          )
    ) THEN      
        -- Проверка кода   
        FOR _z IN SELECT public.plpgsql_check_function ( _x
                                                 ,fatal_errors := true
                                                 ,format       := 'text'
                           )
           LOOP                
                RAISE NOTICE '%', _z;
        END LOOP; 
        
        -- Зависимости в коде
        FOR _z IN SELECT type || ' | ' || oid::text || ' | ' || schema || ' | ' || 
                         name || COALESCE ((' | ' || params), '')   
                  FROM public.plpgsql_show_dependency_tb (_x)
            LOOP                
                 RAISE NOTICE '%', _z;
         END LOOP;   
    END IF;
  END;
$$ 
   LANGUAGE plpgsql;

COMMENT ON FUNCTION public.etg_check_func() IS 
'Триггерная функция для проверки кода создаваемой функции, с использованием расширения plpgsql_check';   
 
ALTER FUNCTION public.etg_check_func() OWNER TO postgres;
 
CREATE EVENT TRIGGER etg_check ON ddl_command_end
    WHEN TAG IN ('CREATE FUNCTION', 'CREATE PROCEDURE')
                               EXECUTE PROCEDURE public.etg_check_func ();

ALTER EVENT TRIGGER etg_check OWNER TO postgres;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS public.f_check_uuids (p_uuid text);
CREATE OR REPLACE FUNCTION public.f_check_uuid (p_uuid text)
 RETURNS boolean
 AS
   --
   --  Nick 2021-09-17
   --
 $$
    SELECT (((p_uuid ~ '^[a-fA-F0-9]{8}(-[a-fA-F0-9]{4}){4}[a-fA-F0-9]{8}$') AND (p_uuid IS NOT NULL)) 
               OR
            (p_uuid IS NULL)
           );
 $$
   LANGUAGE sql STABLE;

 COMMENT ON FUNCTION public.f_check_uuid (text) IS 'Проверка корректности UUID';
--
--  USE CASE:
--
--     SELECT public.f_check_uuid (gen_random_uuid()::text); 
--            f_check_uuids 
--          ---------------
--                 t

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- --------------------------------
--    2018-10-26 Nick
-- --------------------------------
DROP FUNCTION IF EXISTS public.plpgsql_show_dependency_tb_1 (regprocedure, regclass);
CREATE OR REPLACE FUNCTION public.plpgsql_show_dependency_tb_1 (
    p_func_oid regprocedure
   ,p_relid    regclass DEFAULT 0
)
 RETURNS TABLE (
                 sch_name         name 
                ,proc_oid         oid
                ,proc_name        name
                ,child_type       text
                ,child_lang_name  name
                ,child_oid        oid
                ,child_sch        text
                ,child_name       text
                ,child_params     text
                ,tree_d           oid[]
                ,level_d          integer
 ) 
  LANGUAGE sql
  STABLE 
  AS
  $$

 WITH RECURSIVE aa1 (   sch_name   
                       ,proc_oid
                       ,proc_name
                       ,child_type
                       ,lang_name
                       ,child_oid
                       ,child_sch
                       ,child_name
                       ,child_params
                       ,tree_d
                       ,level_d
  ) AS (
          SELECT n.nspname
              ,p.oid
              ,p.proname
              ,ch.type
              ,lx.lanname
              ,ch.oid AS child_oid
              ,ch.schema
              ,ch.name
              ,ch.params
              ,CAST (ARRAY [p.oid] AS oid []) 
              ,1
       
          FROM pg_catalog.pg_namespace n
             JOIN pg_catalog.pg_proc     p ON (pronamespace = n.oid)
             JOIN pg_catalog.pg_language l ON (p.prolang = l.oid)
             LEFT OUTER JOIN LATERAL 
                        
                        (SELECT x.type
                               ,x.oid
                               ,x.schema
                               ,x.name
                               ,x.params
                               
                            FROM public.__plpgsql_show_dependency_tb (p.oid) x
                            
                         ORDER BY x.type, x.schema, x.name    
                             
                        ) ch on TRUE
                        
             LEFT OUTER JOIN pg_catalog.pg_proc     px ON (ch.oid = px.oid) 
             LEFT OUTER JOIN pg_catalog.pg_language lx ON (px.prolang = lx.oid)
       			 
         WHERE ((l.lanname = 'plpgsql') AND (p.prorettype <> 2279) AND (p.oid = p_func_oid)) -- p_func_oid 
         
            UNION ALL
            
          SELECT n.nspname
              ,p.oid
              ,p.proname
              ,ch.type
              ,lx.lanname
              ,ch.oid
              ,ch.schema
              ,ch.name
              ,ch.params
              ,CAST (aa1.tree_d || p.oid AS oid [])
              ,(aa1.level_d + 1) 
       
          FROM pg_catalog.pg_namespace n
             JOIN pg_catalog.pg_proc     p ON (pronamespace = n.oid)
             JOIN pg_catalog.pg_language l ON (p.prolang = l.oid)
             
             JOIN aa1 ON (p.oid = aa1.child_oid) AND ( NOT (p.oid = ANY (aa1.tree_d))) AND 
                         ((l.lanname = 'plpgsql') AND (p.prorettype <> 2279))
             
             LEFT OUTER JOIN LATERAL 
                        
                        (SELECT x.type
                               ,x.oid
                               ,x.schema
                               ,x.name
                               ,x.params
                            FROM public.__plpgsql_show_dependency_tb(p.oid) x
                            
                         ORDER BY x.type, x.schema, x.name    
                                                      
                        ) ch on TRUE
                        
             LEFT OUTER JOIN pg_catalog.pg_proc     px ON (ch.oid = px.oid) 
             LEFT OUTER JOIN pg_catalog.pg_language lx ON (px.prolang = lx.oid)
)         
 SELECT   aa1.sch_name   
         ,aa1.proc_oid
         ,aa1.proc_name
         ,aa1.child_type
         ,aa1.lang_name
         ,aa1.child_oid
         ,aa1.child_sch
         ,aa1.child_name
         ,aa1.child_params
         ,aa1.tree_d
         ,aa1.level_d
 
 FROM aa1 ORDER BY aa1.tree_d;
        
$$;

-- SELECT * FROM public.plpgsql_show_dependency_tb_1 ('clientdb_pcg_clients.fnc_confirm_attrs(integer, jsonb)'::regprocedure::oid)
-- SELECT * FROM public.plpgsql_show_dependency_tb ('clientdb_pcg_clients.fnc_confirm_attrs(integer, jsonb)'::regprocedure::oid)
-- SELECT * FROM public.plpgsql_show_dependency_tb_1 ('nso.nso_f_record_def_val(id_t, t_str60)'::regprocedure::oid);
-- SELECT * FROM public.plpgsql_show_dependency_tb ('nso.nso_f_record_def_val(id_t, t_str60)'); -- 25452
-- SELECT * FROM public.plpgsql_show_dependency_tb_1 (25452);
-- SELECT * FROM public.plpgsql_show_dependency_tb_1 ('nso.nso_f_select_c(t_str60)'::regprocedure::oid);

COMMENT ON FUNCTION public.plpgsql_show_dependency_tb_1 (regprocedure, regclass) 
IS 'Построение дерева зависимостей выбранной функции. Второй параметр игнорируется';

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
