--
--  2022-12-06
--
WITH z AS (
    SELECT count(1) AS qty, id_house_type_1 
	  FROM gar_tmp.adr_house GROUP BY id_house_type_1
)
SELECT z.qty, z.id_house_type_1, t.nm_house_type, t.nm_house_type_short
  FROM z
      LEFT JOIN gar_tmp.adr_HOUSE_type t ON (t.id_house_type = z.id_house_type_1)
   ORDER BY z.qty DESC;       
--
WITH z AS (
    SELECT count(1) AS qty, id_house_type_2 
	  FROM gar_tmp.adr_house GROUP BY id_house_type_2
)
SELECT z.qty, z.id_house_type_2, t.nm_house_type, t.nm_house_type_short
  FROM z
      LEFT JOIN gar_tmp.adr_HOUSE_type t ON (t.id_house_type = z.id_house_type_2)
   ORDER BY z.qty DESC;      
--
WITH z AS (
    SELECT count(1) AS qty, id_house_type_3 
	  FROM gar_tmp.adr_house GROUP BY id_house_type_3
)
SELECT z.qty, z.id_house_type_3, t.nm_house_type, t.nm_house_type_short
  FROM z
      LEFT JOIN gar_tmp.adr_HOUSE_type t ON (t.id_house_type = z.id_house_type_3)
   ORDER BY z.qty DESC;
--
