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