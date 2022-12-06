--
--  2022-12-06 Nick
--
WITH z AS (
    SELECT count(1) AS qty, id_area_type 
	  FROM gar_tmp.adr_area GROUP BY id_area_type
)
SELECT z.qty, z.id_area_type, t.nm_area_type, t.nm_area_type_short
  FROM z
     LEFT JOIN gar_tmp.adr_area_type t ON (t.id_area_type = z.id_area_type) 
   ORDER BY z.qty DESC;
   
