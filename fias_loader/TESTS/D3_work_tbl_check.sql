  
   WITH RECURSIVE aa1 AS (

                 SELECT                
                        h1.object_id
                        --
                      , NULLIF (h1.parent_obj_id, 0)
                        --
                      , a.object_guid
                      , a.object_name
                      , a.type_id
                      , a.type_name
                      --
                      , a.obj_level
                       --
                      , h1.region_code  -- 2021-12-01
                      , h1.area_code    
                      , h1.city_code    
                      , h1.place_code   
                      , h1.plan_code    
                      , h1.street_code    
                       --             --
                      , a.change_id
                      , a.prev_id
                       --             --
                      , a.oper_type_id
                      --
                      , a.start_date 
                      , a.end_date              
                      --
                   --   , CAST (ARRAY [h1.object_id] AS bigint []) 
                   --   , 1
                   --   ,FALSE
              
                 	FROM gar_fias.as_adm_hierarchy h1
                 	
                    INNER JOIN gar_fias.as_addr_obj a ON (h1.object_id = a.object_id) AND
                                                         (a.is_actual AND a.is_active)                 	
                 	
                 WHERE (h1.parent_obj_id = 0) AND (h1.is_active)-- 83006

                 UNION ALL
                 
                 SELECT                         
                        h2.object_id
                        --
                      , h2.parent_obj_id
                        --
                      , a.object_guid
                      , a.object_name
                      , a.type_id
                      , a.type_name
                      --
                      , a.obj_level
                       --
                      , h2.region_code  -- 2021-12-01
                      , h2.area_code    
                      , h2.city_code    
                      , h2.place_code   
                      , h2.plan_code    
                      , h2.street_code    
                       --             --
                      , a.change_id
                      , a.prev_id
                       --             --
                      , a.oper_type_id
                      --
                      , a.start_date 
                      , a.end_date              
                      --
                    -- , CAST (aa1.tree_d || a.object_id AS bigint [])
                    -- , (aa1.level_d + 1) t
                    --  , a.object_id = ANY (aa1.tree_d)
                    
                 	FROM gar_fias.as_adm_hierarchy h2
                 	
                      INNER JOIN aa1 ON (h2.parent_obj_id = aa1.object_id) 
                       
                      INNER JOIN gar_fias.as_addr_obj a ON (h2.object_id = a.object_id)  AND
                                                         (a.is_actual AND a.is_active)                        
                       
                    WHERE (h2.is_active)   
                 
)
   SELECT * FROM aa1 WHERE ( aa1.object_id IN (83006, 84195)); -- 1415089 /1003550 rows affected.  -- 26520     520 -250 = 270
