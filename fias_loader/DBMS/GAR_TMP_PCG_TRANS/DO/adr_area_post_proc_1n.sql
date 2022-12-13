--
--  2022-12-06 Nick
-- 
CREATE table PUBLIC.adr_area_gap_3 AS
SELECT * FROM unnsi.adr_area WHERE (id_area_type > 1000) ORDER BY id_area;
BEGIN;
DELETE FROM unnsi.adr_area WHERE (id_area_type > 1000);
COMMIT;
SELECT * FROM unnsi.adr_street WHERE (id_street_type > 1000) ORDER BY id_area;
WITH z AS (
    SELECT count(1) AS qty, id_area_type 
	  FROM unnsi.adr_area GROUP BY id_area_type
)
SELECT z.qty, z.id_area_type, t.nm_area_type, t.nm_area_type_short
  FROM z
     LEFT JOIN unnsi.adr_area_type t ON (t.id_area_type = z.id_area_type) 
   ORDER BY z.qty DESC;
--    
SELECT * FROM unnsi.adr_area_type ORDER BY 1;
BEGIN;
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1340); -- Пермь, Саврополь, Белгород --882
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1306); -- Пермь, Краснодар --381
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1296); -- Пермь, МО --266
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1124); -- Пермь -- 607
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1107);  -- 178 Нижний
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 137);  -- 178 Нижний
--
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1272);  -- 29
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 135);  -- 378
 --
 --
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1274);  --  4
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 136);  -- 38 + 4 = 42
 --
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1327);  --  32 ???
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 138);   
 --
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1387);  --  32 ???
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 138);   -- 32
 -- 
 -- Последний бросок 
 --
 BEGIN;
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1322); -- 10
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 132); -- 715 + 10 = 725
 --
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1319); -- 5
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 133); -- 314 + 5=  319
 --
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1317); -- 6
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 131); -- 50 + 6 = 56    
  --
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1315); --  2
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 130); --  56 58
  --
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1313); --  1
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 128); --  58 59
  --
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1310); --  3
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 125); --   123 - 126
 --
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1261); --  27
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 99); --   1775 - 1802
--
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1342); --  4
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 95); --  101 - 105
 --
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1425); --  7
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 139); --  
 -- 
 UPDATE unnsi.adr_area SET id_area_type = 132 WHERE (id_area_type = 1322);
 UPDATE unnsi.adr_area SET id_area_type = 133 WHERE (id_area_type = 1319); 
 UPDATE unnsi.adr_area SET id_area_type = 131 WHERE (id_area_type = 1317);
 UPDATE unnsi.adr_area SET id_area_type = 130 WHERE (id_area_type = 1315);  
 UPDATE unnsi.adr_area SET id_area_type = 128 WHERE (id_area_type = 1313); 
 UPDATE unnsi.adr_area SET id_area_type = 125 WHERE (id_area_type = 1310); 
 UPDATE unnsi.adr_area SET id_area_type = 99 WHERE (id_area_type = 1261); 
 UPDATE unnsi.adr_area SET id_area_type = 95 WHERE (id_area_type = 1342); 
 
 BEGIN;
 ROLLBACK;
 COMMIT;
 
 UPDATE unnsi.adr_area SET id_area_type = 139 WHERE (id_area_type = 1425); --   
 UPDATE unnsi.adr_area SET id_area_type = 51 WHERE (id_area_type = 1340);
 UPDATE unnsi.adr_area SET id_area_type = 123 WHERE (id_area_type = 1306); -- 381
 UPDATE unnsi.adr_area SET id_area_type = 119 WHERE (id_area_type = 1296); --  266
 UPDATE unnsi.adr_area SET id_area_type = 80 WHERE (id_area_type = 1124); --   607
 UPDATE unnsi.adr_area SET id_area_type = 137 WHERE (id_area_type = 1107); --   178
 UPDATE unnsi.adr_area SET id_area_type = 135 WHERE (id_area_type = 1272); --  29  
 UPDATE unnsi.adr_area SET id_area_type = 136 WHERE (id_area_type = 1274); --  
 --
 UPDATE unnsi.adr_area SET id_area_type = 138 WHERE (id_area_type = 1327); --  
 --
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1337); --  17
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 140); --  
 -- 
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1064); --  4
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 141); --   --
 --
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1098); --  1
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 112); --  5
 --
  SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1387); --  14
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 142); -- 
 --
  SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1285); --  2
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 143); --    
  --
  SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1097); --  3
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 144); --    
  --
  SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1093); --  3 
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 145); --   
  --
  SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1034); --    
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 146); --    
   --
  SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1277); -- Пермь  
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 113); --  112  
   --
  SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1278); -- Пермь  
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 109); --  403   
    --
  SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1388); -- 
 SELECT * FROM unnsi.adr_area WHERE (id_area_type = 147); --   
 --
BEGIN;
UPDATE unnsi.adr_area SET id_area_type = 147 WHERE (id_area_type = 1388); --
UPDATE unnsi.adr_area SET id_area_type = 109 WHERE (id_area_type = 1278); --
UPDATE unnsi.adr_area SET id_area_type = 113 WHERE (id_area_type = 1277); --
UPDATE unnsi.adr_area SET id_area_type = 146 WHERE (id_area_type = 1034); --
 UPDATE unnsi.adr_area SET id_area_type = 145 WHERE (id_area_type = 1093); --
 UPDATE unnsi.adr_area SET id_area_type = 144 WHERE (id_area_type = 1097); --
 UPDATE unnsi.adr_area SET id_area_type = 143 WHERE (id_area_type = 1285); --
 UPDATE unnsi.adr_area SET id_area_type = 142 WHERE (id_area_type = 1387); --
 UPDATE unnsi.adr_area SET id_area_type = 112 WHERE (id_area_type = 1098); --   
 UPDATE unnsi.adr_area SET id_area_type = 140 WHERE (id_area_type = 1337); --   
 UPDATE unnsi.adr_area SET id_area_type = 141 WHERE (id_area_type = 1064); --    
COMMIT;
ROLLBACK;
SELECT * FROM unnsi.adr_area WHERE (id_area_type > 1000) ORDER BY id_area; -- 47
SELECT * FROM unnsi.adr_area WHERE (id_area_type = 1388) ORDER BY id_area;

CREATE TABLE public.adr_area_gap AS
 SELECT * FROM unnsi.adr_area WHERE (id_area_type > 1000) ORDER BY id_area; 
 
SELECT * FROM public.adr_area_gap ;
