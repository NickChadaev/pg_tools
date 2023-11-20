SELECT id_house, id_addr_parent, nm_fias_guid, nm_fias_guid_parent, nm_parent_obj, region_code, parent_type_id, parent_type_name, parent_type_shortname, parent_level_id, parent_level_name, parent_short_name, house_num, add_num1, add_num2, house_type, house_type_name, house_type_shortname, add_type1, add_type1_name, add_type1_shortname, add_type2, add_type2_name, add_type2_shortname, nm_zipcode, kd_oktmo, kd_okato, oper_type_id, oper_type_name, curr_date, check_kind
	FROM gar_tmp.xxx_adr_house_gap;
---
SELECT * FROM gar_tmp.adr_house WHERE (id_house = 98589535);
SELECT * FROM gar_fias.as_houses WHERE (object_id = 98589535);  -- OK -- bafb64c8-5e73-43a3-acb3-33f6382c74aa

SELECT * FROM gar_tmp.adr_street WHERE (nm_fias_guid = 'b4f4095d-d0d1-4014-861b-15e89e2805e6'); --OK
SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = 'f46ff548-2441-4e47-845f-0dfbc4b09bbc'); -- Металлист

SELECT * FROM unnsi.adr_street WHERE (nm_street_full ilike '%сквер%');  -- 281
SELECT * FROM unnsi.adr_area WHERE (nm_area_full ilike '%сквер%');-- 1186 ???
SELECT * FROM unnsi.adr_area WHERE (nm_area_full ilike '%полярников%');-- 1186 ???
SELECT * FROM unnsi.adr_area WHERE (nm_area_full ilike '%разъезд%');-- 136
SELECT * FROM unnsi.adr_street WHERE (nm_street_full ilike '%разъезд%');-- 60
--
SELECT a.id_area FROM unnsi.adr_area a
   INNER JOIN  unnsi.adr_house h ON (h.id_area = a.id_area)
WHERE (a.id_area_type = 115); -- 15 Обновлять, рстальное удалить

SELECT a.id_area FROM unnsi.adr_area a
   INNER JOIN  unnsi.adr_street s ON (s.id_area = a.id_area)
WHERE (a.id_area_type = 115); -- 2 Кемерово

--ORDER BY id_area; -- 1175

--
--  2023-11-20
--
SELECT * FROM unnsi.adr_street WHERE (id_street_type = 31); -- 1421                     -- дельта 246
SELECT * FROM unnsi.adr_area WHERE (id_area_type = 115); -- 1175
--
SELECT LOWER(nm_street) FROM unnsi.adr_street WHERE (id_street_type = 31) -- 1421
 INTERSECT  --   -- 
SELECT lower(nm_area) FROM unnsi.adr_area WHERE (id_area_type = 115) order by 1; -- 1175

SELECT a.id_area, A.NM_AREA_FULL, s.nm_street_full FROM unnsi.adr_area a
   INNER JOIN  unnsi.adr_street s ON (s.id_area = a.id_area)
WHERE (a.id_area_type = 115); -- 2 Кемерово
-- Обновлять !!

SELECT a.id_area, a.nm_area_full, b.id_area, b.nm_area_full FROM unnsi.adr_area a
   INNER JOIN  unnsi.adr_area b ON (a.id_area = b.id_area_parent)
WHERE (a.id_area_type = 115) ORDER BY 1; --нет
--
-- Дома
--
BEGIN;
ROLLBACK;
COMMIT;
  WITH x (
          id_area
         ,id_house
       )
       AS (    
            SELECT b.id_area, h.id_house FROM unnsi.adr_area a
                  INNER JOIN  unnsi.adr_area b ON (b.id_area = a.id_area_parent)
                  INNER JOIN  unnsi.adr_house h ON (h.id_area = a.id_area)
            WHERE (a.id_area_type = 115)
          )
           UPDATE unnsi.adr_house AS z SET id_area = x.id_area
                                           ,id_street = NULL
           FROM x
           WHERE (x.id_house = z.id_house);
             
  SELECT a.id_area, a.nm_area_full, h.id_house, h.nm_house_full, b.nm_area_full FROM unnsi.adr_area a
   INNER JOIN  unnsi.adr_house h ON (h.id_area = a.id_area)
                  INNER JOIN  unnsi.adr_area b ON (b.id_area = a.id_area_parent)   
  WHERE (a.id_area_type = 115) ORDER BY 1;

SELECT h.*, a.nm_area_full FROM unnsi.adr_house h 
  INNER JOIN unnsi.adr_area a ON (h.id_area = a.id_area)
WHERE (h.id_house IN (
  300020617
,1600011890
,3300022866
,3300022870
,3600057750
,3900099873
,4600066348
,4600077976
,4600066347
,5200094090
,5300037880
,8200016558
,8200016556
,8200016557
,8700035401
));
--
--Улицы
--
BEGIN;
ROLLBACK;
COMMIT;

SELECT a.id_area, A.NM_AREA_FULL, s.id_street, s.nm_street_full FROM unnsi.adr_area a
   INNER JOIN  unnsi.adr_street s ON (s.id_area = a.id_area)
WHERE (a.id_area_type = 115); -- 2 Кемерово
-- Обновлять !!

SELECT a.id_area, a.nm_area_full, b.id_area, b.nm_area_full FROM unnsi.adr_area a
   INNER JOIN  unnsi.adr_area b ON (a.id_area = b.id_area_parent)
WHERE (a.id_area_type = 115) ORDER BY 1; --нет

SELECT s.*, a.*, b.* FROM unnsi.adr_street s 
  INNER JOIN  unnsi.adr_area a ON (a.id_area = s.id_area)
  INNER JOIN  unnsi.adr_area b ON (b.id_area = a.id_area_parent)  
WHERE ( s.id_street IN (
 4100082785
,4100087948
));

SELECT * FROM unnsi.adr_HOUSE where (id_street IN (
 4100082785
,4100087948
));
--
BEGIN;
ROLLBACK;
COMMIT;
 DELETE FROM unnsi.adr_street WHERE (id_street In ( 4100082785
,4100087948
));

--
--  Остальная шелуха
--           
--  1=87  282-91
SELECT * FROM unnsi.adr_area WHERE (id_area_type = 91) ORDER BY 1; -- 282

WITH x (
          nm_object
 )
  AS (
        SELECT lower(nm_area) FROM unnsi.adr_area WHERE (id_area_type = 91)
           INTERSECT
        SELECT lower(nm_street) FROM unnsi.adr_street WHERE (id_street_type = 50)   -- 260
      )
       SELECT a.* FROM unnsi.adr_area a 
           INNER JOIN x ON (x.nm_object = lower(a.nm_area))
        WHERE (a.id_area_type = 91)


BEGIN;
ROLLBACK;

DELETE FROM unnsi.adr_area WHERE (id_area_type = 115);
--
-- пРОСПЕКТ, дорога, бульвар
--
SELECT * FROM unnsi.adr_street WHERE (id_area = 6300000653);  
SELECT * FROM unnsi.adr_house WHERE (id_area = 6300000653); 
-- 6300000653    Семизорова б-р

BEGIN;
SELECT * FROM unnsi.adr_area WHERE (id_area = 6300000653);
DELETE FROM unnsi.adr_area WHERE (id_area = 6300000653);
commit;

-- 50 дорога  2 бульвар

SELECT * FROM unnsi.adr_street WHERE (id_street_type In (2, 50));
SELECT * FROM unnsi.adr_street WHERE (id_street_type In (50));

SELECT nm_area FROM unnsi.adr_area WHERE (id_area_type = 87)
      INTERSECT
SELECT nm_street FROM unnsi.adr_street WHERE (id_street_type = 2)  

WITH x (
          nm_object
       )
    AS (
         SELECT lower(btrim(nm_area)) FROM unnsi.adr_area WHERE (id_area_type = 91)
                INTERSECT
         SELECT lower(btrim(nm_street)) FROM unnsi.adr_street WHERE (id_street_type = 50)
        )
         SELECT a.* FROM unnsi.adr_area a
             INNER JOIN x ON (x.nm_object = lower(btrim(a.nm_area)))
         WHERE (a.id_area_type = 91);  -- 282
------------------
BEGIN;
ROLLBACK;
   ``

WITH x (
          nm_object
       )
    AS (
         SELECT lower(btrim(nm_area)) FROM unnsi.adr_area WHERE (id_area_type = 91)
                INTERSECT
         SELECT lower(btrim(nm_street)) FROM unnsi.adr_street WHERE (id_street_type = 50)
        )
      , z (
            id_area 
        )  
        AS (
             SELECT a.id_area FROM unnsi.adr_area a
                      INNER JOIN x ON (x.nm_object = lower(btrim(a.nm_area)))
             WHERE (a.id_area_type = 91)
           )
        DELETE FROM unnsi.adr_area AS y
           USING z
        WHERE (z.id_area = y.id_area);
           
           
         ;  -- 282


                   ----
WITH x (
          nm_object
       )
    AS (
         SELECT lower(btrim(nm_area)) FROM unnsi.adr_area WHERE (id_area_type = 91)
                INTERSECT
         SELECT lower(btrim(nm_street)) FROM unnsi.adr_street WHERE (id_street_type = 50)
        )
         SELECT a.*, s.* FROM unnsi.adr_area a
             INNER JOIN x ON (x.nm_object = lower(btrim(a.nm_area)))
             INNER JOIN unnsi.adr_street s ON (s.id_area = a.id_area)  --23
         WHERE (a.id_area_type = 91);  

                            ----
WITH x (
          nm_object
       )
    AS (
         SELECT lower(btrim(nm_area)) FROM unnsi.adr_area WHERE (id_area_type = 91)
                INTERSECT
         SELECT lower(btrim(nm_street)) FROM unnsi.adr_street WHERE (id_street_type = 50)
        )
         SELECT a.*, s.*, h.* FROM unnsi.adr_area a
             INNER JOIN x ON (x.nm_object = lower(btrim(a.nm_area)))
             INNER JOIN unnsi.adr_street s ON (s.id_area = a.id_area)
             INNER JOIN unnsi.adr_house h ON (a.id_area = h.id_area) -- 102
         WHERE (a.id_area_type = 91) 

         -- AND (H.ID_HOUSE = 4600081385)
 ; 
------------------
BEGIN;
ROLLBACK;
COMMIT;
-----------------------------------------------------------------------------------------
WITH x (
          nm_object
       )
    AS (
         SELECT lower(btrim(nm_area)) FROM unnsi.adr_area WHERE (id_area_type = 91)
                INTERSECT
         SELECT lower(btrim(nm_street)) FROM unnsi.adr_street WHERE (id_street_type = 50)
        )
     ,z (
         id_street
        )
       AS (     
            SELECT s.id_street FROM unnsi.adr_area a
               INNER JOIN x ON (x.nm_object = lower(btrim(a.nm_area)))
               INNER JOIN unnsi.adr_street s ON (s.id_area = a.id_area)  --23
               WHERE (a.id_area_type = 91)
          )
           -- SELECT * FROM z;

           DELETE FROM unnsi.adr_street AS y
             USING z
           WHERE (z.id_street = y.id_street); 
         ; 
-----------------------------------------------------------------------------------------
WITH x (
          nm_object
       )
    AS (
         SELECT lower(btrim(nm_area)) FROM unnsi.adr_area WHERE (id_area_type = 91)
                INTERSECT
         SELECT lower(btrim(nm_street)) FROM unnsi.adr_street WHERE (id_street_type = 50)
        )
     ,z (
           id_house
        )   
       AS ( 
           SELECT h.id_house FROM unnsi.adr_area a
             INNER JOIN x ON (x.nm_object = lower(btrim(a.nm_area)))
             INNER JOIN unnsi.adr_street s ON (s.id_area = a.id_area)
             INNER JOIN unnsi.adr_house h ON (a.id_area = h.id_area) -- 102
           WHERE (a.id_area_type = 91) 
          )   
          --SELECT * FROM z        
           DELETE FROM unnsi.adr_house AS y
             USING z
           WHERE (y.id_house = z.id_house)   ;
           
-----------------------------------
         --
WITH x (
          nm_object
       )
    AS (
         SELECT lower(btrim(nm_area)) FROM unnsi.adr_area WHERE (id_area_type = 91)
                INTERSECT
         SELECT lower(btrim(nm_street)) FROM unnsi.adr_street WHERE (id_street_type = 50)
        )
         SELECT a.*, h.* FROM unnsi.adr_area a
             INNER JOIN x ON (x.nm_object = lower(btrim(a.nm_area)))
             INNER JOIN unnsi.adr_street s ON (s.id_area = a.id_area)
             INNER JOIN unnsi.adr_house h ON (a.id_area = h.id_area) AND (h.id_street = s.id_street)-- 12
         WHERE (a.id_area_type = 91) ; 

SELECT a.*, s.* from unnsi.adr_street s
  INNER JOIN unnsi.adr_area a ON (a.id_area = s.id_area)
 WHERE (s.nm_fias_guid IN ('8af637fa-5c8b-4039-a7ba-d6e63bcc42b0'
,'a874ac55-c317-4b52-85b0-07a68db53370'));
--

SELECT a.*, s.*, h.* from unnsi.adr_street s
  INNER JOIN unnsi.adr_area a ON (a.id_area = s.id_area)
    INNER JOIN unnsi.adr_house h ON (a.id_area = h.id_area)
 WHERE (s.nm_fias_guid IN ('8af637fa-5c8b-4039-a7ba-d6e63bcc42b0'
,'a874ac55-c317-4b52-85b0-07a68db53370'));

SELECT a.*, s.*, h.* FROM unnsi.adr_house h 
    INNER JOIN UNNSI.ADR_AREA A on (h.id_area = a.id_area)
    INNER JOIN unnsi.adr_street s ON (h.id_street = s.id_street)

WHERE (h.nm_fias_guid IN ('22dfc809-9b95-45f1-adf7-a372c20c2e23'
,'ac898ec9-de94-4546-b32c-c15599b1e329'
,'8f153ebb-75b3-42cd-9cd2-add47cbc73fd'
,'5941d60d-8f5d-41f2-a8be-9ea3cb03cd4f'
,'75bbf91b-d5cd-4eba-8d99-d2e682b9d69c'
,'a7c1e443-fd44-4261-bb36-0e54b658f95d'
,'40f026bf-5e75-4421-9b8e-5342b002be42'
,'e05b43c5-63ef-4cb8-83a5-6d543c68f453'
,'ea1b144b-f1de-4578-a11a-111be2ea7fe6'
,'5ecba199-a783-47fe-808c-aca5789624cc'
,'1ee4ce88-36d1-4327-a0ad-936cf885aa87'
,'1f6c7dbc-2ee7-44bf-8095-a6a827d8ca06'
));