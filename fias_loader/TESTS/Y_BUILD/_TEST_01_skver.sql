SELECT * FROM gar_tmp.adr_area WHERE (id_area_parent IS NULL);
SELECT * FROM gar_tmp.adr_street WHERE (nm_fias_guid = 'a874ac55-c317-4b52-85b0-07a68db53370');

SELECT x.* FROM (VALUES('a874ac55-c317-4b52-85b0-07a68db53370'::uuid), ('8af637fa-5c8b-4039-a7ba-d6e63bcc42b0'::uuid), ('816e9bc4-8957-4d42-8201-99140d96a074'::uuid)) AS x (nm_fias_guid);

SELECT z.* FROM gar_tmp.adr_street z -- WHERE (nm_fias_guid = 'a874ac55-c317-4b52-85b0-07a68db53370');
  INNER JOIN (VALUES('a874ac55-c317-4b52-85b0-07a68db53370'::uuid), ('8af637fa-5c8b-4039-a7ba-d6e63bcc42b0'::uuid), ('816e9bc4-8957-4d42-8201-99140d96a074'::uuid)) AS x (nm_fias_guid)
     ON (z.nm_fias_guid = x.nm_fias_guid);
--
 SELECT z.*, a.* FROM unnsi.adr_street z 
  INNER JOIN (VALUES('a874ac55-c317-4b52-85b0-07a68db53370'::uuid), ('8af637fa-5c8b-4039-a7ba-d6e63bcc42b0'::uuid), ('816e9bc4-8957-4d42-8201-99140d96a074'::uuid)) AS x (nm_fias_guid)
     ON (z.nm_fias_guid = x.nm_fias_guid)
  INNER JOIN unnsi.adr_area a ON (a.id_area = z.id_area)
 -- INNER JOIN unnsi.adr_house h ON (z.id_area = h.id_area) AND (h.id_street = z.id_street);
-- 
-- 2600037088|35367|'Патрокл-Седанка-Де-Фриз-п.Новый'|50|'Патрокл-Седанка-Де-Фриз-п.Новый дор'|'816e9bc4-8957-4d42-8201-99140d96a074'
-- 4600091221|1015|'Кольцевая автомобильная'|50|'Кольцевая автомобильная дор'|'a874ac55-c317-4b52-85b0-07a68db53370'
-- 4600091232|1029|'М-10 Россия'|50|'М-10 Россия дор'|'8af637fa-5c8b-4039-a7ba-d6e63bcc42b0'
-- 
 SELECT z.* FROM unnsi.adr_street z -- нет
  INNER JOIN (VALUES( 'bd1ea5b8-d375-4afd-a9e4-a40566b6fed8'::uuid)
                   , ('f27cd60e-46d5-4747-bc68-1789c456003c'::uuid)
                   , ('761a72d8-8616-4b47-ae6a-1589877d5fc2'::uuid)
                   , ('84fdfa94-5809-4675-9205-e32cce7b79e3'::uuid)
                   , ('eb20028e-a05e-44dc-b1b6-65ecf0770a6a'::uuid)
                   ) AS x (nm_fias_guid)
     ON (z.nm_fias_guid = x.nm_fias_guid)
 -- INNER JOIN unnsi.adr_area a ON (a.id_area = z.id_area);

 SELECT z.* FROM gar_fias.as_addr_obj z --  
  INNER JOIN (VALUES( 'bd1ea5b8-d375-4afd-a9e4-a40566b6fed8'::uuid)
                   , ('f27cd60e-46d5-4747-bc68-1789c456003c'::uuid)
                   , ('761a72d8-8616-4b47-ae6a-1589877d5fc2'::uuid)
                   , ('84fdfa94-5809-4675-9205-e32cce7b79e3'::uuid)
                   , ('eb20028e-a05e-44dc-b1b6-65ecf0770a6a'::uuid)
                   ) AS x (nm_fias_guid)
     ON (z.object_guid = x.nm_fias_guid)
--
 SELECT z.* FROM gar_fias.as_addr_obj z --  
  INNER JOIN (VALUES( 'a874ac55-c317-4b52-85b0-07a68db53370'::uuid)
                   , ('8af637fa-5c8b-4039-a7ba-d6e63bcc42b0'::uuid)
                   ) AS x (nm_fias_guid)
     ON (z.object_guid = x.nm_fias_guid)


-- 52069969|160296443|'a874ac55-c317-4b52-85b0-07a68db53370'|528139289|'Кольцевая автомобильная'|253|'дор.'|7|10|0|0|'2023-09-11'|'2023-09-11'|'2079-06-06'|t
-- 968428|799331|'8af637fa-5c8b-4039-a7ba-d6e63bcc42b0'|2100856|'М-10 Россия'|253|'дор.'|7|10|0|0|'2019-07-31'|'2019-07-31'|'2079-06-06'|t
   

-- 'bd1ea5b8-d375-4afd-a9e4-a40566b6fed8'|2087845|'671-й'|141|'км'
-- 'f27cd60e-46d5-4747-bc68-1789c456003c'|528270171|'103-й'|141|'км'
-- '761a72d8-8616-4b47-ae6a-1589877d5fc2'|528270161|'94-й'|141|'км'
-- '84fdfa94-5809-4675-9205-e32cce7b79e3'|528270165|'97-й'|141|'км'
-- 'eb20028e-a05e-44dc-b1b6-65ecf0770a6a'|528270167|'99-й'|141|'км'


a874ac55-c317-4b52-85b0-07a68db53370

 SELECT z.*, h.* FROM unnsi.adr_street z 
  INNER JOIN (VALUES('a874ac55-c317-4b52-85b0-07a68db53370'::uuid), ('8af637fa-5c8b-4039-a7ba-d6e63bcc42b0'::uuid), ('816e9bc4-8957-4d42-8201-99140d96a074'::uuid)) AS x (nm_fias_guid)
     ON (z.nm_fias_guid = x.nm_fias_guid)
  INNER JOIN unnsi.adr_house h ON (z.id_area = h.id_area) AND (h.id_street = z.id_street);
--
SELECT a.*, s.*, h.* FROM gar_tmp.adr_house h 
  INNER JOIN gar_tmp.adr_area a ON (a.id_area = h.id_area)
  INNER JOIN gar_tmp.adr_street s ON (H.id_area = s.id_area) AND (h.id_street = s.id_street)
WHERE (h.nm_fias_guid IN( -- нет их, что интересно
'22dfc809-9b95-45f1-adf7-a372c20c2e23'
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
--
SELECT * FROM gar_fias.as_houses WHERE (object_guid IN( -- 
'22dfc809-9b95-45f1-adf7-a372c20c2e23'
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
--
          SELECT 
                h.id_house
              , h.id_addr_parent
              , h.fias_guid         AS nm_fias_guid
              , h.parent_fias_guid  AS nm_fias_guid_parent
              , h.nm_parent_obj
              , h.region_code
              --
              , h.parent_type_id
              , h.parent_type_name
              , h.parent_type_shortname
              , h.parent_level_id
              , h.parent_level_name
              , h.parent_short_name
              -- 
              , h.house_num                AS house_num
              --
              , h.add_num1                 AS add_num1            
              , h.add_num2                 AS add_num2            
              , h.house_type               AS house_type          
              , h.house_type_name          AS house_type_name     
              , h.house_type_shortname     AS house_type_shortname
              --
              , h.add_type1                AS add_type1          
              , h.add_type1_name           AS add_type1_name     
              , h.add_type1_shortname      AS add_type1_shortname
              , h.add_type2                AS add_type2          
              , h.add_type2_name           AS add_type2_name     
              , h.add_type2_shortname      AS add_type2_shortname
                --
               ,(p.type_param_value -> '5'::text)  AS nm_zipcode   
               ,(p.type_param_value -> '7'::text)  AS kd_oktmo
               ,(p.type_param_value -> '6'::text)  AS kd_okato    
              --
              , h.oper_type_id
              , h.oper_type_name
              
           FROM gar_tmp.xxx_adr_house h  
              
              INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = h.fias_guid) 
              LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (h.id_house = p.object_id)              
              
            WHERE (f.id_obj IS NULL) AND (f.type_object = 2) AND
            (h.fias_guid IN (
'22dfc809-9b95-45f1-adf7-a372c20c2e23'
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
)
            );
--------------------------------------------------------------------------------------------------------
-- 54965687|794220|'a7c1e443-fd44-4261-bb36-0e54b658f95d'|'bd1ea5b8-d375-4afd-a9e4-a40566b6fed8'|'671-й'|'47'|141|'Километр'|'км'|8|'Элемент улично-дорожной сети'
-- 95882794|794220|'e05b43c5-63ef-4cb8-83a5-6d543c68f453'|'bd1ea5b8-d375-4afd-a9e4-a40566b6fed8'|'671-й'|'47'|141|'Километр'|'км'|8|'Элемент улично-дорожной сети'
-- 160345524|160330043|'1f6c7dbc-2ee7-44bf-8095-a6a827d8ca06'|'f27cd60e-46d5-4747-bc68-1789c456003c'|'103-й'|'47'|141|'Километр'|'км'|8|'Элемент улично-дорожной сети'
-- 160345534|160330033|'ea1b144b-f1de-4578-a11a-111be2ea7fe6'|'761a72d8-8616-4b47-ae6a-1589877d5fc2'|'94-й'|'47'|141|'Километр'|'км'|8|'Элемент улично-дорожной сети'
-- 160345556|160330037|'5ecba199-a783-47fe-808c-aca5789624cc'|'84fdfa94-5809-4675-9205-e32cce7b79e3'|'97-й'|'47'|141|'Километр'|'км'|8|'Элемент улично-дорожной сети'
-- 160345575|160330039|'1ee4ce88-36d1-4327-a0ad-936cf885aa87'|'eb20028e-a05e-44dc-b1b6-65ecf0770a6a'|'99-й'|'47'|141|'Километр'|'км'|8|'Элемент улично-дорожной сети'


SELECT * FROM unnsi.adr_area WHERE (id_area_type = 94) ORDER BY id_area DESC; -- 91
SELECT * FROM unnsi.adr_street WHERE (id_street_type = 42);      - 50   
94 ORDER BY id_area_type;
SELECT * FROM gar_tmp.xxx_adr_area_type ORDER BY id_area_type;
--
SELECT * FROM unnsi.adr_street_type WHERE (id_street_type = 42); --ORDER BY id_street_type;
SELECT * FROM gar_tmp.xxx_adr_area_type ORDER BY id_area_type;
SELECT * FROM gar_tmp.xxx_adr_street_type ORDER BY id_street_type;