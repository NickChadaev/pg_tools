SELECT aa.* FROM gar_tmp.xxx_adr_area aa --  19
   INNER JOIN gar_tmp.xxx_obj_fias xx ON (aa.fias_guid = xx.obj_guid) 
WHERE ((xx.type_object = 0) AND (xx.id_obj IS NULL));  

           SELECT 
                x.id_addr_obj AS id_area     
                --
               ,x.nm_addr_obj AS nm_area     
               ,x.nm_addr_obj AS nm_area_full
               --
               ,x.addr_obj_type_id AS id_area_type
               ,x.addr_obj_type    AS nm_area_type 
			   -- ---------------------------------------
			   ,EXISTS (SELECT 1 FROM gar_tmp.xxx_adr_area_type 
                                  WHERE (x.addr_obj_type_id = ANY (fias_ids))
               ) AS type_exists
					  
               -- ----------------------------------------
               ,x.id_addr_parent   AS id_area_parent     
               ,x.parent_fias_guid AS nm_fias_guid_parent
			   
			   ,(SELECT (id_area IS not NULL) FROM gar_tmp_pcg_trans.f_adr_area_get ('gar_tmp'::text, x.parent_fias_guid)) AS parent_exists
               --
               ,(p.type_param_value -> '7'::text)  AS kd_oktmo
               --
               ,x.fias_guid AS nm_fias_guid  
                --
               ,(p.type_param_value -> '6'::text)  AS kd_okato    --  varchar(11) null,
               ,(p.type_param_value -> '5'::text)  AS nm_zipcode  --  varchar(20) null,
               ,(p.type_param_value -> '11::text') AS kd_kladr    --  varchar(15) null,
                --
               ,x.tree_d                
               ,x.level_d               
                --
               ,x.obj_level       
               ,x.level_name      
               --
               ,x.oper_type_id    
               ,x.oper_type_name  
               
            FROM gar_tmp.xxx_adr_area x  
               INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = x.fias_guid) 
               LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (x.id_addr_obj = p.object_id)
	            
	        WHERE (f.id_obj IS NULL) AND (f.type_object = 0) 
	                 AND
	              (((x.fias_guid = ANY (NULL)) AND 
	               (NULL IS NOT NULL)) OR (NULL IS NULL)
	              )
	        ORDER BY x.tree_d ;   -- 19 - 1 = 18
--
SELECT * FROM gar_tmp.xxx_adr_area WHERE (fias_guid = '727cdf1e-1b70-4e07-8995-9bf7ca9abefb')

SELECT id_area_type, nm_area_type_short -- 30 мкр
FROM gar_tmp_pcg_trans.f_adr_type_get ('gar_tmp', 270);

SELECT 1 FROM gar_tmp_pcg_trans.f_adr_area_get ('gar_tmp'::text, '19e29ea6-2bb0-48ba-86e6-aa9d4b88bc14'::uuid);
--
--   2023-10-04
--
SELECT * FROM public.hh5 ; -- 617502   
--
SELECT * FROM gar_tmp.xxx_adr_area WHERE (fias_guid IN ('19e29ea6-2bb0-48ba-86e6-aa9d4b88bc14'--   ??? -- 14
,'c0856292-889c-4bb9-8141-561f1aee19e3'));

SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_show_data() WHERE (fias_guid = '19e29ea6-2bb0-48ba-86e6-aa9d4b88bc14');   -- 14
SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_show_data() WHERE (fias_guid = '727cdf1e-1b70-4e07-8995-9bf7ca9abefb');   -- 5

          SELECT   x.id_addr_obj      
                  ,x.id_addr_parent   
                  ,x.fias_guid        
                  ,x.parent_fias_guid 
                  ,x.nm_addr_obj  
                  ,x.addr_obj_type_id     
                  ,x.addr_obj_type    
                  ,x.obj_level        
                  ,x.level_name
                   --
                  ,x.region_code  -- 2021-12-01
                  ,x.area_code    
                  ,x.city_code    
                  ,x.place_code   
                  ,x.plan_code    
                  ,x.street_code    
                   --                                 
                  ,x.oper_type_id     
                  ,x.oper_type_name  
                   --
                  ,x.start_date 
                  ,x.end_date  
                   --                  
                  ,x.tree_d           
                  ,x.level_d          
          
          FROM gar_tmp_pcg_trans.f_xxx_adr_area_show_data (
                  p_date          := current_date
                 ,p_obj_level     := 14
                 ,p_oper_type_ids := NULL::bigint[]
          ) x -- 26515
     WHERE (x.obj_level >= 10) --    26509 + 6 = 26515
-----------------------------------------------------------------
