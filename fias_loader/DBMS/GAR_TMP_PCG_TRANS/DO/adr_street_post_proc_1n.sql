--
--   2022-12-06
--
WITH z AS (
    SELECT count(1) AS qty, id_street_type 
	  FROM unnsi.adr_street GROUP BY id_street_type
)
SELECT z.qty, z.id_street_type, t.nm_street_type, t.nm_street_type_short
  FROM z
      LEFT JOIN unnsi.adr_street_type t ON (t.id_street_type = z.id_street_type)
   ORDER BY z.id_street_type DESC; 
--
WITH z AS (
    SELECT count(1) AS qty, id_street_type 
	  FROM unnsi.adr_street GROUP BY id_street_type
)
SELECT z.qty, z.id_street_type, t.nm_street_type, t.nm_street_type_short
  FROM z
      LEFT JOIN unnsi.adr_street_type t ON (t.id_street_type = z.id_street_type)
   ORDER BY z.qty DESC; 
--
CREATE TABLE public.adr_street_gap AS
SELECT * FROM unnsi.adr_street WHERE (id_street_type IN (1194
,1193
,1187
,1169
,1159
,1158
,1156
,1134
,1133
,1129
,1128
,1113
)) ORDER BY id_street; -- 203
--
SELECT * FROM public.adr_street_gap;
SELECT * FROM unnsi.adr_area WHERE (id_area = 1090);-- Нижний Новгород
---
BEGIN;
DELETE FROM unnsi.adr_street WHERE (id_street_type IN (1194
,1193
,1187
,1169
,1159
,1158
,1156
,1134
,1133
,1129
,1128
,1113
));

ROLLBACK;
COMMIT;