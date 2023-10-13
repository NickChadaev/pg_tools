  
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
   SELECT * FROM aa1 
   
   WHERE ( aa1.object_id IN (15701549
                                              ,104321781
                                              ,9710166
                                              ,9628810
                                              ,7123678
                                              ,15699762
                                              ,54741298
                                              ,54622834
                                              ,15700509
                                              ,78605083
)); -- 1415089 /1003550 rows affected.  -- 26520     520 -250 = 270

SELECT * FROM gar_fias.as_adm_hierarchy h2
WHERE ( h2.object_id IN (15701549
                                              ,104321781
                                              ,9710166
                                              ,9628810
                                              ,7123678
                                              ,15699762
                                              ,54741298
                                              ,54622834
                                              ,15700509
                                              ,78605083
)); -- А это дома

SELECT * FROM gar_tmp_pcg_trans."_OLD_f_xxx_adr_house_show_data" () where (id_house IN (15701549
                                              ,104321781
                                              ,9710166  --+
                                              ,9628810  --+
                                              ,7123678  --++
                                              ,15699762
                                              ,54741298
                                              ,54622834
                                              ,15700509
                                              ,78605083 --+
));

SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_house_show_data ()
 where (id_house IN (15701549
                                              ,104321781
                                              ,9710166  --+
                                              ,9628810  --+
                                              ,7123678  --++
                                              ,15699762
                                              ,54741298
                                              ,54622834
                                              ,15700509
                                              ,78605083 --+
));
select * from gar_fias.as_reestr_objects r where (r.object_id IN (15701549
                                              ,104321781
                                              ,9710166  --+
                                              ,9628810  --+
                                              ,7123678  --++
                                              ,15699762
                                              ,54741298
                                              ,54622834
                                              ,15700509
                                              ,78605083 --+
)) order by r.object_id;
select * from gar_fias.as_adm_hierarchy r where (r.object_id IN (15701549
                                              ,104321781
                                              ,9710166  --+
                                              ,9628810  --+
                                              ,7123678  --++
                                              ,15699762
                                              ,54741298
                                              ,54622834
                                              ,15700509
                                              ,78605083 --+
)) order by r.object_id;

SELECT u.guid FROM public.fias_not_found_06u u
  INNER JOIN gar_tmp.adr_house h ON (h.nm_fias_guid = u. guid) -- 175
--
SELECT u.guid FROM public.fias_not_found_06u u
  INNER JOIN gar_tmp.xxx_adr_house h ON (h.fias_guid = u. guid) -- 160
  
  -- 220 - 175 = 45
  
  SELECT u.guid FROM public.fias_not_found_06u u
  INNER JOIN gar_fias.as_houses h ON (h.object_guid = u. guid) -- 185    185 - 175 = 10
  	WHERE (h.is_active) AND (h.is_actual);