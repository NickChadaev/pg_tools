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
 
     SELECT h.* FROM v

     INNER JOIN gar_tmp.xxx_adr_house h ON (h.fias_guid = v.guid) -- 107  ( 148 - 107 = 41) (152 - 111 = 41)

    ORDER BY h.fias_guid;
    -- 2023-09-27 -- 111
--
-- ---------------------------------------  2023-09-28
--
