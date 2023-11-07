 SELECT * FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp'); 
 SELECT * FROM gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data ('gar_tmp'); 
 SELECT * FROM gar_tmp_pcg_trans.f_zzz_house_type_show_tmp_data ('gar_tmp'); 
----------------------------------------------------------------------------
SELECT * FROM gar_tmp.xxx_adr_street_gap;

SELECT * FROM gar_tmp.adr_area WHERE (ID_AREA_PARENT is null);

-- SELECT g.*, x.* FROM gar_tmp.xxx_adr_area_type x 
--    INNER JOIN gar_tmp.xxx_adr_street_gap g ON (x.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char (g.nm_street_type))
--     UNION 
SELECT  DISTINCT on (g.nm_street_full)  g.*, x.* FROM gar_tmp.xxx_adr_area_type x 
   INNER JOIN gar_tmp.xxx_adr_street_gap g ON (lower(x.fias_type_shortname) = lower(g.nm_street_type))
 --
 SELECT  DISTINCT on (g.nm_street_full)  g.*, x.* FROM gar_tmp.xxx_adr_area_type x 
   INNER JOIN gar_tmp.xxx_adr_street_gap g ON (lower(x.fias_type_shortname) = lower(g.nm_street_type))
 WHERE NOT(g.id_street_type = ANY(x.fias_ids));	
--
SELECT g.*, x.* FROM gar_tmp.xxx_adr_street_type x  
INNER JOIN gar_tmp.xxx_adr_area_gap g ON (x.nm_street_type_short = g.nm_area_type)
--
SELECT g.*, x.* FROM gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data ('gar_tmp') x  
INNER JOIN gar_tmp.xxx_adr_area_gap g ON (x.nm_street_type_short = g.nm_area_type) 
 WHERE NOT(g.id_area_type = ANY(x.fias_ids));	

--  SELECT * FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp') x;   
 SELECT  DISTINCT on (g.nm_street_full)  g.*, x.* FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp') x
   INNER JOIN gar_tmp.xxx_adr_street_gap g ON (lower(x.fias_type_shortname) = lower(g.nm_street_type))
 WHERE NOT(g.id_street_type = ANY(x.fias_ids));	
 --
 -- SELECT * FROM gar_tmp_pcg_trans.f_zzz_house_type_show_tmp_data ('gar_tmp') x;
 SELECT  DISTINCT on (g.nm_parent_obj)  g.*, x.* FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp') x
   INNER JOIN gar_tmp.xxx_adr_house_gap g ON (lower(x.fias_type_shortname) = lower(g.parent_type_shortname))
    WHERE NOT(g.parent_type_id = ANY(x.fias_ids));	