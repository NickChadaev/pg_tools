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
  SELECT * FROM aa1; -- 26250
  
  -- 
  -- =======================================================================================
   --
   WITH z AS (
            SELECT  
               --
               h.nm_fias_guid AS guid
                
            FROM public.fias_not_found_06u n
            INNER JOIN gar_tmp.adr_house h ON (h.nm_fias_guid = n.guid)
          )
          
      , v AS ( SELECT m.guid
                 
               FROM public.fias_not_found_06u m
          
               EXCEPT
               
               SELECT z.guid
                 
               FROM z
             )  
             
     SELECT  ah.*
	        ,aa.* 
	 FROM v
     
     INNER JOIN gar_tmp.xxx_adr_house ah ON (ah.fias_guid = v.guid) 
     INNER JOIN  public.zz1 aa ON (aa.fias_guid = ah.parent_fias_guid)
--
-- =========================================================================================
--
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
          
        FROM gar_fias.as_addr_obj a 
        
          INNER JOIN gar_fias.as_adm_hierarchy ia
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
        
        WHERE (ia.object_id = 83006) AND  --  ((ia.parent_obj_id = 0) OR (ia.parent_obj_id IS NULL)) AND
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
                                          
              INNER JOIN aa1 ON (aa1.id_addr_parent = a.object_id) AND (NOT aa1.cicle_d)
          
        WHERE (a.obj_level <= 10) 
                AND ((a.is_actual AND a.is_active) AND (a.end_date > now()) 
                        AND (a.start_date <= now())
                )
       )         
  SELECT * FROM aa1; -- 26250
--  
--   2023-10-06
--

SELECT h.object_id, ia.parent_obj_id, aa.* FROM  gar_fias.as_houses h
          --    Проверить      -- LEFT OUTER                             
          INNER JOIN gar_fias.as_adm_hierarchy ia ON ((ia.object_id = h.object_id) AND (ia.is_active))
          INNER JOIN gar_fias.as_addr_obj aa ON (aa.object_id = ia.parent_obj_id ) AND (aa.is_active)		  
 WHERE ( h.object_id IN ( 7123678
, 9628810
, 9710166
, 15699762
, 15700509
, 15701549
, 54622834
, 54741298
, 78605083
, 104321781

          )
         )
ORDER BY 1;
--
-- ------------------------------------------------------
--
WITH x AS (
SELECT h.object_id, h.is_active, ia.parent_obj_id, aa.* FROM  gar_fias.as_houses h
          --    Проверить      -- LEFT OUTER                             
          INNER JOIN gar_fias.as_adm_hierarchy ia ON ((ia.object_id = h.object_id) AND (ia.is_active))
          INNER JOIN gar_fias.as_addr_obj aa ON (aa.object_id = ia.parent_obj_id ) AND (aa.end_date > current_date) --AND (aa.is_active)		  
 WHERE ( h.object_id IN ( 7123678
, 9628810
, 9710166
, 15699762
, 15700509
, 15701549
, 54622834
, 54741298
, 78605083
, 104321781

          )
         )
ORDER BY 1
)  
,  z AS (
SELECT h.object_id, ia.parent_obj_id FROM  gar_fias.as_houses h
          --    Проверить      -- LEFT OUTER                             
          INNER JOIN gar_fias.as_adm_hierarchy ia ON ((ia.object_id = h.object_id) AND (ia.is_active))
          INNER JOIN gar_fias.as_addr_obj aa ON (aa.object_id = ia.parent_obj_id ) AND (aa.is_active) -- AND (ia.is_active)		  
 WHERE ( h.object_id IN ( 7123678
, 9628810
, 9710166
, 15699762
, 15700509
, 15701549
, 54622834
, 54741298
, 78605083
, 104321781

          )
         )
ORDER BY 1
) 
-- SELECT * FROM x

--    EXCLUDE

SELECT * FROM z;

--
-- -----------------------------------------
--
SELECT h.*, ia.*, aa.* FROM  gar_fias.as_houses h
          --    Проверить      -- LEFT OUTER                             
          INNER JOIN gar_fias.as_adm_hierarchy ia ON ((ia.object_id = h.object_id) AND (ia.is_active))
          INNER JOIN gar_fias.as_addr_obj aa ON (aa.object_id = ia.parent_obj_id ) AND (aa.end_date > current_date) --AND (aa.is_active)		  
 WHERE ( h.object_id IN ( 7123678
, 9628810
, 9710166
, 15699762
, 15700509
, 15701549
, 54622834
, 54741298
, 78605083
, 104321781

          )
         )
ORDER BY 1