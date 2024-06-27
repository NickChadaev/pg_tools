DROP VIEW if EXISTS public.zz4;
CREATE OR REPLACE VIEW  public.zz4 AS
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
              ,NULLIF (h1.parent_obj_id, 0)
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
              ,h1.region_code  -- 2021-12-01
              ,h1.area_code    
              ,h1.city_code    
              ,h1.place_code   
              ,h1.plan_code    
              ,h1.street_code    
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
              
            FROM gar_fias.as_adm_hierarchy h1
                 	            
              INNER JOIN gar_fias.as_addr_obj a ON (h1.object_id = a.object_id) AND            
                                                   (a.is_actual AND a.is_active)                 	            
              --                
              INNER JOIN gar_fias.as_object_level l 
                           ON (a.obj_level = l.level_id) AND (l.is_active) 
              --
              INNER JOIN gar_fias.as_operation_type ot 
                           ON (ot.oper_type_id = a.oper_type_id) AND (ot.is_active)                          
            
            WHERE (h1.parent_obj_id = 0) AND (h1.is_active) 
     
         
                     UNION ALL
        
            SELECT
               a.object_id
              ,h2.parent_obj_id
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
              ,h2.region_code  -- 2021-12-01
              ,h2.area_code    
              ,h2.city_code    
              ,h2.place_code   
              ,h2.plan_code    
              ,h2.street_code    
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
            
            FROM gar_fias.as_adm_hierarchy h2
                 	
              INNER JOIN aa1 ON (h2.parent_obj_id = aa1.id_addr_obj ) 
                       
              INNER JOIN gar_fias.as_addr_obj a ON (h2.object_id = a.object_id) AND (a.is_actual AND a.is_active)                        
              INNER JOIN gar_fias.as_addr_obj z ON (h2.parent_obj_id = z.object_id) AND (z.is_actual AND z.is_active) 
              INNER JOIN gar_fias.as_object_level l ON (a.obj_level = l.level_id) AND (l.is_active) 
              INNER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = a.oper_type_id) AND (ot.is_active) 
              
            WHERE (h2.is_active)-- AND (a.obj_level <= 10)
       )       
      , bb1 (   
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
               --
               ,rn
      )
       AS (
            SELECT  
                    aa1.id_addr_obj       
                   ,aa1.id_addr_parent 
                   --
                   ,aa1.fias_guid        
                   ,aa1.parent_fias_guid 
                   --   
                   ,aa1.nm_addr_obj    
                   ,aa1.addr_obj_type_id   
                   ,aa1.addr_obj_type               
                   --
                   ,aa1.obj_level
                   ,aa1.level_name
                    --
                   ,aa1.region_code  -- 2021-12-01
                   ,aa1.area_code    
                   ,aa1.city_code    
                   ,aa1.place_code   
                   ,aa1.plan_code    
                   ,aa1.street_code    
                    --             --
                   ,aa1.change_id
                   ,aa1.prev_id
                   --             --
                   ,aa1.oper_type_id
                   ,aa1.oper_type_name		 
                    --
                   ,aa1.start_date 
                   ,aa1.end_date              
                    --               
                   ,aa1.tree_d            
                   ,aa1.level_d

                  , max(aa1.change_id) OVER (PARTITION BY aa1.id_addr_parent 
                                            ,aa1.addr_obj_type-- _id  
                                            ,UPPER(aa1.nm_addr_obj) 
                                       ORDER BY aa1.change_id   
                    ) AS rn
                  
            FROM aa1 -- WHERE (aa1.obj_level <= 10)
		   ORDER BY aa1.tree_d
          )
           SELECT
                    bb1.id_addr_obj       
                   ,bb1.id_addr_parent 
                   --
                   ,bb1.fias_guid        
                   ,bb1.parent_fias_guid 
                   --   
                   ,bb1.nm_addr_obj    
                   ,COALESCE (bb1.addr_obj_type_id,
                     (
                       WITH z (
                                 type_id
                                ,type_level
                                ,is_active
                                ,fias_row_key
                       )
                         AS (
                             SELECT   t.id
                                     ,t.type_level
                                     ,t.is_active
                                     ,gar_tmp_pcg_trans.f_xxx_replace_char (t.type_name)
                             FROM gar_fias.as_addr_obj_type t 
                               WHERE (t.type_shortname = bb1.addr_obj_type) AND 
                                     (t.type_level::bigint = bb1.obj_level)            
                             )
                       , v (type_id)
                         AS (
                             SELECT r.id FROM gar_fias.as_addr_obj_type r, z 
                              WHERE (gar_tmp_pcg_trans.f_xxx_replace_char (r.type_name)
                                       = 
                                     z.fias_row_key
                                    ) 
                                           AND 
                                    (r.type_level = z.type_level) AND (r.is_active) -- 2022-12-29 
                           )  
                             SELECT 
                                 CASE 
                                   WHEN NOT z.is_active THEN (SELECT v.type_id FROM v)
                                      ELSE 
                                           z.type_id
                                 END AS type_id
                             FROM z
                      )
                    ) AS addr_obj_type_id
                   ,bb1.addr_obj_type               
                   --
                   ,bb1.obj_level
                   ,bb1.level_name
                    --
                   ,bb1.region_code  -- 2021-12-01
                   ,bb1.area_code    
                   ,bb1.city_code    
                   ,bb1.place_code   
                   ,bb1.plan_code    
                   ,bb1.street_code    
                  --             --
                   ,bb1.change_id
                   ,bb1.prev_id
                   --             --					
                   ,bb1.oper_type_id
                   ,bb1.oper_type_name		 
                    --
                   ,bb1.start_date 
                   ,bb1.end_date              
                    --               
                   ,bb1.tree_d            
                   ,bb1.level_d           
           FROM bb1 WHERE (bb1.change_id = bb1.rn);
           
          
-- SELECT * FROM public.zz1; -- 26250  /26514   514 - 250 = 264
-- SELECT * FROM public.zz2 WHERE (zz2.id_addr_obj IN (83006, 84195));
-- SELECT * FROM public.zz3 WHERE (zz3.obj_level > 10)   -- 26520 / 6
-- SELECT * FROM public.zz4;  -- 26520


       SELECT  
                    aa1.id_addr_obj       
                   ,aa1.id_addr_parent 
                   --
                   ,aa1.fias_guid        
                   ,aa1.parent_fias_guid 
                   --   
                   ,aa1.nm_addr_obj    
                   ,aa1.addr_obj_type_id   
                   ,aa1.addr_obj_type               
                   --
                   ,aa1.obj_level
                   ,aa1.level_name
                    --
                   ,aa1.region_code  -- 2021-12-01
                   ,aa1.area_code    
                   ,aa1.city_code    
                   ,aa1.place_code   
                   ,aa1.plan_code    
                   ,aa1.street_code    
                    --             --
                   ,aa1.change_id
                   ,aa1.prev_id
                   --             --
                   ,aa1.oper_type_id
                   ,aa1.oper_type_name		 
                    --
                   ,aa1.start_date 
                   ,aa1.end_date              
                    --               
                   ,aa1.tree_d            
                   ,aa1.level_d

                  , max(aa1.change_id) OVER (PARTITION BY aa1.id_addr_parent, aa1.addr_obj_type-- _id  
                                            ,UPPER(aa1.nm_addr_obj) 
                                       ORDER BY aa1.change_id   
                    ) AS rn
                  
            FROM public.zz2 AS aa1 ;  -- 26514
			
-- ================================================================================
       SELECT  
	                count(1)
                   ,aa1.id_addr_parent 
                   ,aa1.addr_obj_type  				   
                   ,aa1.nm_addr_obj    
                  
            FROM public.zz4 AS aa1 GROUP BY aa1.id_addr_parent, aa1.addr_obj_type, aa1.nm_addr_obj -- 26514
               ORDER BY 1 DESC;
			   
SELECT aa1.* FROM public.zz3 AS aa1 WHERE (aa1.nm_addr_obj IN 			   
('Садовод', 'Нефтекачка', 'Пинхаскала', 'Урожай', 'Локомотив')
) ORDER BY aa1.nm_addr_obj, aa1.addr_obj_type, aa1.change_id DESC;			-- 26514 -5 = 26509							   
			   
SELECT aa1.* FROM public.zz4 AS aa1 WHERE (aa1.nm_addr_obj IN 			   
('Садовод', 'Нефтекачка', 'Пинхаскала', 'Урожай', 'Локомотив')
) ORDER BY aa1.nm_addr_obj, aa1.addr_obj_type, aa1.change_id DESC;			   
			   
--
-- ================================================================================
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
     INNER JOIN  public.zz4 aa ON (aa.fias_guid = ah.parent_fias_guid);
	 
