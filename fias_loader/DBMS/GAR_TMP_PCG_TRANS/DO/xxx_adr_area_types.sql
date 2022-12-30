--
-- 2022-12-30   -- Садовое неком-е товарищество 
--                 194, 300, 402  <---- Добавить
--
-- SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type = 51);
UPDATE gar_tmp.xxx_adr_area_type 

    SET fias_ids = COALESCE (fias_ids, ARRAY[]::bigint[]) || 
                                194::bigint || 300::bigint || 402::bigint  
       ,fias_type_name = COALESCE (fias_type_name, nm_area_type)
       ,fias_type_shortname = COALESCE (fias_type_shortname, nm_area_type_short)
       
 WHERE (id_area_type = 51); 
SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type = 51);