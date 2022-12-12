--
--  2022-12-06
--
-- SELECT house_type_id, type_name, type_shortname, type_descr, update_date, start_date, end_date, is_active
-- 	FROM gar_fias.as_house_type ORDER BY house_type_id;

WITH z AS (
    SELECT count(1) AS qty, id_house_type_1 
	  FROM unnsi.adr_house GROUP BY id_house_type_1
)
SELECT z.qty, z.id_house_type_1, t.nm_house_type, t.nm_house_type_short
  FROM z
      LEFT JOIN unnsi.adr_HOUSE_type t ON (t.id_house_type = z.id_house_type_1)
   ORDER BY z.qty DESC;  
--
WITH z AS (
    SELECT count(1) AS qty, id_house_type_2 
	  FROM unnsi.adr_house GROUP BY id_house_type_2
)
SELECT z.qty, z.id_house_type_2, t.nm_house_type, t.nm_house_type_short
  FROM z
      LEFT JOIN unnsi.adr_HOUSE_type t ON (t.id_house_type = z.id_house_type_2)
   ORDER BY z.qty DESC; 
--
WITH z AS (
    SELECT count(1) AS qty, id_house_type_3
	  FROM unnsi.adr_house GROUP BY id_house_type_3
)
SELECT z.qty, z.id_house_type_3, t.nm_house_type, t.nm_house_type_short
  FROM z
      LEFT JOIN unnsi.adr_HOUSE_type t ON (t.id_house_type = z.id_house_type_3)
   ORDER BY z.qty DESC; 
   
--
-- Кандидаты на удаление
--
-- SELECT * FROM unnsi.adr_house WHERE (id_house_type_1 IN (1004, 1013,1014)) ORDER BY id_house_type_1, id_house;  -- 31968
SELECT * FROM unnsi.adr_house WHERE (id_house_type_1 IN (1013,1014)) ORDER BY id_house_type_1, id_house; -- 300

SELECT * FROM unnsi.adr_area WHERE (id_area IN (87, 204455)); -- Севастополь
SELECT * FROM unnsi.adr_house_type ORDER BY 1;
BEGIN;
 DELETE FROM unnsi.adr_house WHERE (id_house_type_1 IN (1013,1014));  
 SELECT * FROM unnsi.adr_house WHERE (id_house_type_1 IN (1013,1014)) ORDER BY id_house_type_1, id_house; -- 0
ROLLBACK;
COMMIT; 
-----------
-- Обновление без коррекции адресных справочников.
--
SELECT * FROM unnsi.adr_house WHERE (id_house_type_1 IN (1005,1009)) ORDER BY id_house_type_1 DESC, id_house;  -- 8473
SELECT * FROM unnsi.adr_house WHERE (id_house_type_1 IN (1004)); -- 31668
--
SELECT * FROM unnsi.adr_area WHERE (id_area IN (123761, 179141)); 
-- Московская обл., Воскресенск г.
-- Московская обл., Люберцы г., Томилино рп, Птицефабрика мкр.
SELECT * FROM unnsi.adr_house WHERE (id_area IN (123761, 179141)) ORDER BY id_house_type_1 DESC, id_house; -- 6031
------------------------------------------------------------------
SELECT * FROM unnsi.adr_house WHERE (id_house_type_1 IN (1004)) ORDER BY id_house_type_1 DESC, id_house;  -- 31668
SELECT * FROM unnsi.adr_house WHERE (id_house_type_1 IN (1011,1012)) ORDER BY id_house_type_1, id_house;  --  
SELECT * FROM unnsi.adr_house WHERE (id_area IN (87,2590, 2572))  ORDER BY id_house_type_1 desc;
SELECT * FROM unnsi.adr_area WHERE (id_area IN (87,2590, 2572)); --Севастополь
BEGIN;
 DELETE FROM unnsi.adr_house WHERE (id_house_type_1 IN (1011,1012)) ;  -- 1335
ROLLBACK;
COMMIT; 


BEGIN;
 UPDATE unnsi.adr_house SET id_house_type_1 = 10 WHERE (id_house_type_1 = 1009);  --78
 UPDATE unnsi.adr_house SET id_house_type_1 = 8 WHERE (id_house_type_1 = 1005);   -- 8395
 --
 UPDATE unnsi.adr_house SET id_house_type_1 = 9 WHERE (id_house_type_1 = 1004);   --  31668
ROLLBACK;
COMMIT;   
--
SELECT * FROM unnsi.adr_house WHERE (id_area IN (154298)) ORDER BY id_house_type_1 DESC, id_house; -- 3549
SELECT * FROM unnsi.adr_area WHERE (id_area IN (154298)); -- Тамбовская обл., Первомайский р-н, Первомайский рп
SELECT * FROM unnsi.adr_house_type ORDER BY 1;
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
WITH z AS (
    SELECT count(1) AS qty, id_house_type_2 
	  FROM unnsi.adr_house GROUP BY id_house_type_2
)
SELECT z.qty, z.id_house_type_2, t.nm_house_type, t.nm_house_type_short
  FROM z
      LEFT JOIN unnsi.adr_HOUSE_type t ON (t.id_house_type = z.id_house_type_2)
   ORDER BY z.id_house_type_2 DESC;  
  -- 
SELECT * FROM unnsi.adr_house_type ORDER BY 1;
BEGIN;
 UPDATE unnsi.adr_house SET id_house_type_2 = 10
         WHERE (id_house_type_2 = 1009);  
 SELECT * FROM unnsi.adr_house WHERE (id_house_type_2 = 10) AND (id_area IN (2310, 2311));  -- 128 	 
ROLLBACK;
COMMIT;   
   
   
--
WITH z AS (
    SELECT count(1) AS qty, id_house_type_3 
	  FROM unnsi.adr_house GROUP BY id_house_type_3
)
SELECT z.qty, z.id_house_type_3, t.nm_house_type, t.nm_house_type_short
  FROM z
      LEFT JOIN unnsi.adr_HOUSE_type t ON (t.id_house_type = z.id_house_type_3)
   ORDER BY z.id_house_type_3 DESC;
--
SELECT * FROM unnsi.adr_house WHERE (id_house_type_3 = 1009);  -- 20
SELECT * FROM unnsi.adr_area WHERE (id_area IN (1807, 1808)); -- Московская обл., Долгопрудный г., Московская обл., Химки г.
SELECT * FROM unnsi.adr_house_type ORDER BY 1;
BEGIN;
 UPDATE unnsi.adr_house SET id_house_type_3 = 10
         WHERE (id_house_type_3 = 1009);  
 SELECT * FROM unnsi.adr_house WHERE (id_house_type_3 = 10) AND (id_area IN (1807, 1808));  -- 13		 
ROLLBACK;
COMMIT;