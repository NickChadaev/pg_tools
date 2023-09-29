CREATE OR REPLACE VIEW  public.zz1 AS
   WITH RECURSIVE aa1 (
                         id_addr_obj       
                        ,id_addr_parent 
                        --
                        ,fias_guid        
                        ,parent_fias_guid 
                        --   
                        ,nm_addr_obj   
                        ,addr_obj_type_id  
                        ,addr_obj_type   
                        --
                        ,obj_level
                        ,level_name
                        --
                        ,region_code  -- 2021-12-01
                        ,area_code    
                        ,city_code    
                        ,place_code   
                        ,plan_code    
                        ,street_code    
                        --
                        ,change_id
                        ,prev_id
                        --
                        ,oper_type_id
                        ,oper_type_name               
                        --
                        ,start_date 
                        ,end_date    
                        --
                        ,tree_d            
                        ,level_d
                        ,cicle_d  
     ) AS (
            SELECT
               a.object_id
              ,NULLIF (ia.parent_obj_id, 0)
              --
              ,a.object_guid
              ,NULL::uuid
              --
              ,a.object_name
              ,a.type_id
              ,a.type_name
              --
              ,a.obj_level
              ,l.level_name
               --
              ,ia.region_code  -- 2021-12-01
              ,ia.area_code    
              ,ia.city_code    
              ,ia.place_code   
              ,ia.plan_code    
              ,ia.street_code    
               --             --
              ,a.change_id
              ,a.prev_id
               --             --
              ,a.oper_type_id
              ,ot.oper_type_name
              --
              ,a.start_date 
              ,a.end_date              
              --
              ,CAST (ARRAY [a.object_id] AS bigint []) 
              ,1
              ,FALSE
              
            FROM gar_fias.as_adm_hierarchy ia
            
              INNER JOIN gar_fias.as_addr_obj a 
                           ON (ia.object_id = a.object_id) AND
                              ((a.is_actual AND a.is_active) AND (a.end_date > now()) AND
                                   (a.start_date <= now())
                              )
              --                
              INNER JOIN gar_fias.as_object_level l 
                           ON (a.obj_level = l.level_id) AND (l.is_active) AND
                              ((l.end_date > now()) AND (l.start_date <= now()))
              --
              INNER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = a.oper_type_id) AND 
                                              (ot.is_active) AND ((ot.end_date > now()) AND 
                                              (ot.start_date <= now()))                            
            
            WHERE ((ia.parent_obj_id = 0) OR (ia.parent_obj_id IS NULL)) AND
                  (ia.is_active) AND (ia.end_date > now()) AND (ia.start_date <= now())
      
         
                     UNION ALL
        
            SELECT
               a.object_id
              ,ia.parent_obj_id
              --
              ,a.object_guid
              ,z.object_guid
              --
              ,a.object_name
              ,a.type_id          
              ,a.type_name
              --
              ,a.obj_level
              ,l.level_name
               --
              ,ia.region_code  -- 2021-12-01
              ,ia.area_code    
              ,ia.city_code    
              ,ia.place_code   
              ,ia.plan_code    
              ,ia.street_code    
               --             --
              ,a.change_id
              ,a.prev_id
               --             --
              ,a.oper_type_id
              ,ot.oper_type_name
              --
              ,a.start_date 
              ,a.end_date              
              --	       
              ,CAST (aa1.tree_d || a.object_id AS bigint [])
              ,(aa1.level_d + 1) t
              ,a.object_id = ANY (aa1.tree_d)   
            
               FROM gar_fias.as_addr_obj a
                  INNER JOIN gar_fias.as_adm_hierarchy ia ON ((ia.object_id = a.object_id) AND (ia.is_active) 
                                                               AND (ia.end_date > now()) 
                                                               AND (ia.start_date <= now())
                                                             )
                  INNER JOIN gar_fias.as_addr_obj z ON (ia.parent_obj_id = z.object_id)
                                              AND ((z.is_actual AND z.is_active) AND (z.end_date > now()) 
                                                      AND (z.start_date <= now())
                                              )
                  INNER JOIN gar_fias.as_object_level l ON (a.obj_level = l.level_id) AND (l.is_active) 
                                                             AND ((l.end_date > now()) AND
                                                                  (l.start_date <= now())
                                                             )
                  INNER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = a.oper_type_id) AND 
                                              (ot.is_active) AND ((ot.end_date > now()) AND 
                                              (ot.start_date <= now()))
                                              
                  INNER JOIN aa1 ON (aa1.id_addr_obj = ia.parent_obj_id) AND (NOT aa1.cicle_d)
              
            WHERE (a.obj_level <= 10) 
                    AND ((a.is_actual AND a.is_active) AND (a.end_date > now()) 
                            AND (a.start_date <= now())
                    )
       )         
         SELECT * FROM aa1;

-- SELECT * FROM public.zz1; -- 26250