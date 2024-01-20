SELECT id_area, id_country, nm_area, nm_area_full, id_area_type, id_area_parent, kd_timezone, pr_detailed, kd_oktmo, nm_fias_guid, dt_data_del, id_data_etalon, kd_okato, nm_zipcode, kd_kladr, vl_addr_latitude, vl_addr_longitude, id_area_hist, date_create, f_server_name, id_region
    FROM gar_tmp.adr_area_hist WHERE (date_create >= '2024-01-19 13:20:00') ORDER BY date_create;
    
SELECT a.*, h.* FROM gar_tmp.adr_area a
    JOIN gar_tmp.adr_area_hist h ON (a.id_area = h.id_area)
WHERE (h.date_create >= '2024-01-19 13:20:00') ORDER BY 3;
-- 4176
 
SELECT a.*, h.* FROM gar_tmp.adr_area a
    JOIN gar_tmp.adr_area_hist h ON (a.id_area = h.id_area)
WHERE (h.date_create >= '2024-01-19 13:20:00') ORDER BY a.id_area ; -- DESC;
-- 4176
 
SELECT count(1) FROM  gar_tmp.adr_area a; -- 11217
SELECT a.* FROM  gar_tmp.adr_area a ORDER BY id_area DESC;
SELECT a.* FROM  gar_tmp.adr_area a WHERE (a.id_area = 400153774);
SELECT h.* FROM  gar_tmp.adr_house h WHERE (h.id_area = 400153774); bnnn
