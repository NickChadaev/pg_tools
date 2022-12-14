-- =======================================================================
--  2022-12-14 Из скрипта, родившегося в ходе "разбора полётов" получился
--              SQL-сценарий, кооректирующий ошибки, возникшие в ходе
--              создания промежуточных адресных структур.
-- =======================================================================
--
-- Adr_area
--
UPDATE gar_tmp.xxx_adr_area_type  -- Садовое неком-е товарищество
      SET fias_ids = COALESCE (fias_ids, ARRAY[]::bigint[]) || 340::bigint 
       ,fias_type_name = COALESCE (fias_type_name, nm_area_type)
       ,fias_type_shortname = COALESCE (fias_type_shortname, nm_area_type_short)
 WHERE (id_area_type = 51); 
SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type = 51); 
--
UPDATE gar_tmp.xxx_adr_area_type  -- Поселок и(при) станция(и)
      SET fias_ids = COALESCE (fias_ids, ARRAY[]::bigint[]) || 94::bigint 
       ,fias_type_name = COALESCE (fias_type_name, nm_area_type)
       ,fias_type_shortname = COALESCE (fias_type_shortname, nm_area_type_short)
 WHERE (id_area_type = 36); 
SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type = 36); 
--
UPDATE gar_tmp.xxx_adr_area_type  -- Железнодорожный путевой пост
    SET fias_ids = COALESCE (fias_ids, ARRAY[]::bigint[]) || 64::bigint 
       ,fias_type_name = COALESCE (fias_type_name, nm_area_type)
       ,fias_type_shortname = COALESCE (fias_type_shortname, nm_area_type_short)
 WHERE (id_area_type = 141); 
SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type = 141); 
--
UPDATE gar_tmp.xxx_adr_area_type  -- Платформа
    SET fias_ids = COALESCE (fias_ids, ARRAY[]::bigint[]) || 168::bigint || 283::bigint || 387::bigint 
       ,fias_type_name = COALESCE (fias_type_name, nm_area_type)
       ,fias_type_shortname = COALESCE (fias_type_shortname, nm_area_type_short)
 WHERE (id_area_type = 142);  
SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type = 142); 
--
UPDATE gar_tmp.xxx_adr_area_type   -- Порт 
    SET fias_ids = COALESCE (fias_ids, ARRAY[]::bigint[]) || 285::bigint 
       ,fias_type_name = COALESCE (fias_type_name, nm_area_type)
       ,fias_type_shortname = COALESCE (fias_type_shortname, nm_area_type_short)
 WHERE (id_area_type = 143); 
SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type = 143); 
--
UPDATE gar_tmp.xxx_adr_area_type   -- Погост 
    SET fias_ids = COALESCE (fias_ids, ARRAY[]::bigint[]) || 97::bigint 
       ,fias_type_name = COALESCE (fias_type_name, nm_area_type)
       ,fias_type_shortname = COALESCE (fias_type_shortname, nm_area_type_short)  
 WHERE (id_area_type = 144); 
SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type = 144); 
--
UPDATE gar_tmp.xxx_adr_area_type   -- Планировочный район
    SET fias_ids = COALESCE (fias_ids, ARRAY[]::bigint[]) ||  93::bigint || 160::bigint || 381::bigint 
       ,fias_type_name = COALESCE (fias_type_name, nm_area_type)
       ,fias_type_shortname = COALESCE (fias_type_shortname, nm_area_type_short)  
 WHERE (id_area_type = 145); 
SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type = 145); 
--
UPDATE gar_tmp.xxx_adr_area_type   -- Площадка                        
    SET fias_ids = COALESCE (fias_ids, ARRAY[]::bigint[]) || 169::bigint || 284::bigint || 388::bigint 
       ,fias_type_name = COALESCE (fias_type_name, nm_area_type)
       ,fias_type_shortname = COALESCE (fias_type_shortname, nm_area_type_short)
 WHERE (id_area_type = 147); 
SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type = 147); 
--
--  adr_street
--
UPDATE gar_tmp.xxx_adr_street_type   -- Ряды                        
    SET fias_ids = COALESCE (fias_ids, ARRAY[]::bigint[]) || 397::bigint 
       ,fias_type_name = COALESCE (fias_type_name,nm_street_type)
       ,fias_type_shortname = COALESCE (fias_type_shortname,nm_street_type_short)
 WHERE (id_street_type = 29); -- {32,85,397}
SELECT * FROM gar_tmp.xxx_adr_street_type WHERE (id_street_type = 29); 
