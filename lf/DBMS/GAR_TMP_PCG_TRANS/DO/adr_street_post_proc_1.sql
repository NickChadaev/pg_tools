--
--   2022-12-06
--
WITH z AS (
    SELECT count(1) AS qty, id_street_type 
	  FROM gar_tmp.adr_street GROUP BY id_street_type
)
SELECT z.qty, z.id_street_type, t.nm_street_type, t.nm_street_type_short
  FROM z
      LEFT JOIN gar_tmp.adr_street_type t ON (t.id_street_type = z.id_street_type)
   ORDER BY z.qty DESC; 
