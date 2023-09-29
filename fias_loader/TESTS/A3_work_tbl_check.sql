--
--  2023-09-26
--

SELECT  
--
 h.*
    
FROM public.fias_not_found_06u n

INNER JOIN gar_tmp.xxx_adr_house h ON (h.fias_guid = n.guid)

; -- 160

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
		  
  -- SELECT * FROM z; -- 72   2023-09-27  -- 68
  -- SELECT * FROM v; -- 148 + 72 = 220    -- 2023-09-27 152
 
     SELECT ah.id_house
          , ah.fias_guid
          , ah.parent_fias_guid
          , aa.*     
     FROM v
     
     INNER JOIN gar_tmp.xxx_adr_house ah ON (ah.fias_guid = v.guid)      
     INNER JOIN gar_fias.as_addr_obj  aa ON (ah.parent_fias_guid = aa.object_guid) -- 107  ( 148 - 107 = 41) (152 - 111 = 41)

     WHERE ( aa.is_active)AND (aa.is_actual)     
     
     ORDER BY aa.object_name, ah.fias_guid;
    -- 2023-09-27 -- 111
--
-- ---------------------------------------  2023-09-28
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
		  
  -- SELECT * FROM z; -- 72   2023-09-27  -- 68
  -- SELECT * FROM v; -- 148 + 72 = 220    -- 2023-09-27 152
 
     SELECT ah.id_house
          , ah.fias_guid
          , ah.parent_fias_guid
          , ia.*  
           --
          , l.*
          ,ot.*
          
     FROM v
     
     INNER JOIN gar_tmp.xxx_adr_house ah ON (ah.fias_guid = v.guid)      
     INNER JOIN gar_fias.as_addr_obj  aa ON (ah.parent_fias_guid = aa.object_guid) -- 107  ( 148 - 107 = 41) (152 - 111 = 41)
     INNER JOIN  gar_fias.as_adm_hierarchy ia ON (ia.object_id = aa.object_id) 
     INNER JOIN gar_fias.as_object_level l    ON (aa.obj_level = l.level_id) AND (l.is_active) 
     INNER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = aa.oper_type_id) AND (ot.is_active)     
     
     
     WHERE ( aa.is_active)AND (aa.is_actual) AND (ia.is_active)
     
    ORDER BY aa.object_name, ah.fias_guid;;

-- ----------------------------------------------------------------------------------------------------------------------------
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
             
     SELECT ah.*
	        ,aa.* 
	 FROM v
     
     INNER JOIN gar_tmp.xxx_adr_house ah ON (ah.fias_guid = v.guid)   
     INNER JOIN gar_tmp_pcg_trans.f_xxx_adr_area_show_data() aa ON (aa.fias_guid = ah.parent_fias_guid)
     ;

SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_show_data(); -- 26250
