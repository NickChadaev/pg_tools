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
-- SELECT * FROM v; -- 148 + 72 = 220    -- 2023-09-27 152   -- 45 (2023-10-05)
 
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


--
--   2023-10-05
--
SELECT u.guid FROM public.fias_not_found_06u u
  INNER JOIN gar_tmp.adr_house h ON (h.nm_fias_guid = u. guid) -- 175
--
SELECT u.guid FROM public.fias_not_found_06u u
  INNER JOIN gar_tmp.xxx_adr_house h ON (h.fias_guid = u. guid) -- 160
  
  -- 220 - 175 = 45
  
  SELECT u.guid FROM public.fias_not_found_06u u
  INNER JOIN gar_fias.as_houses h ON (h.object_guid = u. guid) -- 185    185 - 175 = 10
  	WHERE (h.is_active) AND (h.is_actual);
	
-- ---------------------------------------------------------------------------------------
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
 SELECT h.* FROM v   -- 148 + 72 = 220    -- 2023-09-27 152   -- 45 (2023-10-05)

  INNER JOIN gar_fias.as_houses h ON (h.object_guid = v.guid) -- 185    185 - 175 = 10
  	WHERE (h.is_active) AND (h.is_actual);

-- #1
SELECT a.*, s.*, h.* FROM gar_tmp.adr_house h
 INNER JOIN gar_tmp.adr_area a ON (a.id_area = h.id_area)
 INNER JOIN gar_tmp.adr_street s ON (s.id_street = h.id_street) 
WHERE (h.nm_fias_guid = 'c09b70db-a17a-48ea-b7a1-4ad0f3d77de8')

-- #2
SELECT * from gar_tmp.adr_street   WHERE (nm_street ilike '%Шахбанова%');

-- #3
SELECT h.* FROM gar_tmp.adr_house h
WHERE (h.nm_fias_guid = '2c3d7891-954f-48e2-b090-280488022a97');

SELECT h.* FROM gar_fias.as_steads h
WHERE (h.object_guid  = '2c3d7891-954f-48e2-b090-280488022a97');  -- steads

---------------------------------------------------------------------------
-- #1
SELECT a.*, s.*, h.* FROM unnsi.adr_house h
 INNER JOIN unnsi.adr_area a ON (a.id_area = h.id_area)
 INNER JOIN unnsi.adr_street s ON (s.id_street = h.id_street) 
WHERE (h.nm_fias_guid = 'c09b70db-a17a-48ea-b7a1-4ad0f3d77de8')

-- #2
SELECT * from unnsi.adr_street   WHERE (nm_street ilike '%Шахбанова%');

-- #3
SELECT h.* FROM unnsi.adr_house h
WHERE (h.nm_fias_guid = '2c3d7891-954f-48e2-b090-280488022a97'); -- steads

---------------------------------------------------------------------------
SELECT a.*, s.*, h.* FROM unnsi.adr_house h
 INNER JOIN unnsi.adr_area a ON (a.id_area = h.id_area)
 INNER JOIN unnsi.adr_street s ON (s.id_street = h.id_street) 
WHERE (h.nm_fias_guid = '1fc57b91-c02f-4f70-9c7e-06236239397e') ;
--
--  2023-10-06
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
 SELECT h.* FROM v   -- 148 + 72 = 220    -- 2023-09-27 152   -- 45 (2023-10-05)

  INNER JOIN gar_fias.as_houses h ON (h.object_guid = v.guid) -- 185    185 - 175 = 10
  	WHERE (h.is_active) AND (h.is_actual);