--
--  2023-11-08  -- 05
--
       --       Дополняю массив "fias_ids"  недостающими кодами.
       --       Они берутся из соответствующих таблиц базы 05, 23, 50.   

SELECT g.*, x.* FROM gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data ('gar_tmp') x  
INNER JOIN gar_tmp.xxx_adr_area_gap g ON (lower(x.nm_street_type_short) = lower(g.nm_area_type)) 
 WHERE NOT(g.id_area_type = ANY(x.fias_ids));       -- 326
 --
 BEGIN;
  UPDATE gar_tmp.xxx_adr_street_type SET fias_ids = fias_ids || 326::bigint WHERE (id_street_type = 38); --'Улица'
  SELECT * FROM gar_tmp.xxx_adr_street_type WHERE (id_street_type = 38);
ROLLBACK;  
--
SELECT  DISTINCT on (g.nm_street_full)  g.*, x.* FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp') x
   INNER JOIN gar_tmp.xxx_adr_street_gap g ON (lower(x.fias_type_shortname) = lower(g.nm_street_type))
WHERE NOT(g.id_street_type = ANY(x.fias_ids));	
--
 SELECT  DISTINCT on (g.id_street_type)  g.id_street_type, g.nm_street_type, x.* FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp') x
   INNER JOIN gar_tmp.xxx_adr_street_gap g ON (lower(x.fias_type_shortname) = lower(g.nm_street_type))
 WHERE NOT(g.id_street_type = ANY(x.fias_ids));	
---------------------------------------------------
-- 113|'а/я'|84|'Абонентский ящик'|'а/я'|0|''|'{240}'|84|'Абонентский ящик'
-- 130|'ж/д_оп'|14|'ж/д останов. (обгонный) пункт'|'ж/д_оп'|0|''|'{69}'|14|'ж/д останов. (обгонный) пункт'
-- 150|'местность'|98|'Местность'|'местность'|0|''|'{267}'|98|'Местность'
-- 158|'п'|34|'Поселок'|'п.'|0|''|'{33,90,276,440}'|34|'Поселок'
--
 BEGIN;
  UPDATE gar_tmp.xxx_adr_area_type SET fias_ids = fias_ids || 113::bigint WHERE (id_area_type = 84); -- Абонентский ящик
  UPDATE gar_tmp.xxx_adr_area_type SET fias_ids = fias_ids || 130::bigint WHERE (id_area_type = 14); -- ж/д останов. (обгонный) пункт
  UPDATE gar_tmp.xxx_adr_area_type SET fias_ids = fias_ids || 150::bigint WHERE (id_area_type = 98); -- Местность
  UPDATE gar_tmp.xxx_adr_area_type SET fias_ids = fias_ids || 158::bigint WHERE (id_area_type = 34); -- Поселок
  SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type IN (84, 14, 98, 34));
ROLLBACK;  
--
 SELECT  DISTINCT on (g.nm_parent_obj)  g.*, x.* FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp') x
   INNER JOIN gar_tmp.xxx_adr_house_gap g ON (lower(x.fias_type_shortname) = lower(g.parent_type_shortname))  
 WHERE NOT(g.parent_type_id = ANY(x.fias_ids));
--
--  2023-11-08  -- 23
--
       --       Дополняю массив "fias_ids"  недостающими кодами.
       --       Они берутся из соответствующих таблиц базы 05, 23, 50.   

SELECT  DISTINCT on (g.nm_street_full)  g.*, x.* FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp') x
   INNER JOIN gar_tmp.xxx_adr_street_gap g ON (lower(x.fias_type_shortname) = lower(g.nm_street_type))
WHERE NOT(g.id_street_type = ANY(x.fias_ids));	
--
 SELECT  DISTINCT on (g.id_street_type)  g.id_street_type, g.nm_street_type, x.* FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp') x
   INNER JOIN gar_tmp.xxx_adr_street_gap g ON (lower(x.fias_type_shortname) = lower(g.nm_street_type))
 WHERE NOT(g.id_street_type = ANY(x.fias_ids));	
---------------------------------------------------
-- 158|'п'|35|'Поселение'|'поселение' --это будет посёлком
--
--
 SELECT  DISTINCT on (g.parent_type_id)  g.parent_type_id, parent_type_name, x.* FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp') x
   INNER JOIN gar_tmp.xxx_adr_house_gap g ON (lower(x.fias_type_shortname) = lower(g.parent_type_shortname))  
 WHERE NOT(g.parent_type_id = ANY(x.fias_ids)); 
-- 300|'Садовое товарищество'|51|'Садовое неком-е товарищество'|'снт'|0|''|'{105,194,402}'|51

 BEGIN;
  UPDATE gar_tmp.xxx_adr_area_type SET fias_ids = fias_ids || 300::bigint WHERE (id_area_type = 51); -- 'снт'
  SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type IN (51));
ROLLBACK;  

SELECT id, type_level, type_name,  gar_tmp_pcg_trans.f_xxx_replace_char(type_name)  FROM gar_fias.as_addr_obj_type
where (id IN (112,329,449,209))

WITH z (
          qty
         ,fias_row_key
       )
     AS (    
           SELECT  count(1)
                ,  gar_tmp_pcg_trans.f_xxx_replace_char(type_name)  FROM gar_fias.as_addr_obj_type GROUP BY type_name  
         )
          SELECT z.fias_row_key, t.*  FROM z 
            INNER JOIN gar_fias.as_addr_obj_type t ON (gar_tmp_pcg_trans.f_xxx_replace_char(t.type_name) = z.fias_row_key)

          WHERE (z.qty > 1) ORDER BY z.fias_row_key  ;        
         
