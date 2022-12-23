--
--  2022-12-22
--
SELECT '*** 1 ***' AS areas;
SELECT a.nm_area_full, ga.* FROM gar_tmp.xxx_adr_area_gap ga
   LEFT JOIN gar_tmp.adr_area a ON (a.nm_fias_guid = ga.nm_fias_guid_parent);
--
SELECT '*** 2 ***' AS streets;
SELECT a.nm_area_full, gs.* FROM gar_tmp.xxx_adr_street_gap gs
   LEFT JOIN gar_tmp.adr_area a ON (a.nm_fias_guid = gs.nm_fias_guid_area);
--  
SELECT '*** 3 ***' AS houses;
SELECT a.nm_area_full, gh.* FROM gar_tmp.xxx_adr_house_gap gh
   LEFT JOIN gar_tmp.adr_street s ON (s.nm_fias_guid = gh.nm_fias_guid_parent)
   LEFT JOIN gar_tmp.adr_area a ON (s.id_area = a.id_area);