-- SELECT id, object_id, object_guid, change_id, steads_number, oper_type_id, prev_id, next_id, update_date, start_date, end_date, is_actual, is_active
-- 	FROM gar_fias.as_steads;


DROP VIEW if EXISTS public.st5;
CREATE OR REPLACE VIEW  public.st5 AS
WITH aa (
             id_stead       
            ,id_addr_parent 
            -- 
            ,fias_guid        
            ,parent_fias_guid 
            --   
            ,nm_parent_obj  
            ,region_code
            --
            ,parent_type_id
            ,parent_type_name
            ,parent_type_shortname
            --
            ,parent_level_id
            ,parent_level_name
 --           ,parent_short_name	        
            --
            ,stead_num 
            --
            ,change_id
            --
            ,oper_type_id
            ,oper_type_name     
            --
            ,rn
            
 ) AS (
        SELECT
           s.object_id
          ,NULLIF (ia.parent_obj_id, 0)
          --
          ,s.object_guid
          ,y.object_guid
          --
          ,y.object_name     -- e.g.  parent_name
          ,ia.region_code
           --
          ,x.id
          ,x.type_name
          ,x.type_shortname
          --
          ,z.level_id
          ,z.level_name
         -- ,z.short_name
          --          
          ,s.steads_number
          --
          ,s.change_id
          --
          ,s.oper_type_id
          ,ot.oper_type_name
          --
          ,1
          ,s.is_actual 
		  ,s.is_active  
	 
        FROM gar_fias.as_steads s
          --
          INNER JOIN gar_fias.as_adm_hierarchy ia ON (ia.object_id = s.object_id) AND (ia.is_active) 
          INNER JOIN gar_fias.as_addr_obj       y ON (y.object_id = ia.parent_obj_id) AND (y.end_date > current_date)  
	 
          LEFT OUTER JOIN gar_fias.as_object_level z ON (z.level_id = y.obj_level) AND (z.is_active) 
          --
	      LEFT OUTER JOIN gar_fias.as_addr_obj_type x ON (x.id = y.type_id) -- AND (x.is_active) -- 2022-12-29
          --
          LEFT OUTER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = s.oper_type_id) AND (ot.is_active)
          
       WHERE ((s.is_actual AND s.is_active)
                ) ---  295177
 )
   SELECT 
             aa.id_stead       
            ,aa.id_addr_parent 
            --
            ,aa.fias_guid        
            ,aa.parent_fias_guid 
            --   
            ,aa.nm_parent_obj  
            ,aa.region_code
            --
            ,aa.parent_type_id
            ,aa.parent_type_name
            ,aa.parent_type_shortname
            --
            ,aa.parent_level_id
            ,aa.parent_level_name
      --      ,aa.parent_short_name	        
            --
            ,aa.stead_num
            --
            ,aa.oper_type_id
            ,aa.oper_type_name     
            --
          --  ,aa.user_id

			,aa.change_id
			,aa.rn

            ,aa.is_actual 
		    ,aa.is_active  
			
   
   FROM aa 
        --  WHERE (aa.rn =  aa.change_id ) -- 617506
             ORDER BY aa.id_addr_parent, aa.stead_num; 

--------------------------------------------------------
-- SELECT * FROM public.st5 ; -- 295177


-- SELECT * FROM public.st5 WHERE (NM_PARENT_OBJ ='Владимира Ильича Ленина');
-- SELECT * FROM public.st5 WHERE (change_id IN (
--  81898078
-- ,81911037
-- ,81729943
-- ,81899471

	
-- )) AND (rn =  change_id ) 

-- SELECT * FROM public.st5 WHERE ( id_house IN ( 7123678
-- , 9628810
-- , 9710166
-- , 15699762
-- , 15700509
-- , 15701549
-- , 54622834
-- , 54741298
-- , 78605083
-- , 104321781

--           )
--          ) AND (rn =  change_id )
-- ORDER BY 1
