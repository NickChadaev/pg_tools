SELECT id_area, id_country, nm_area, nm_area_full, id_area_type, id_area_parent, kd_timezone, pr_detailed, kd_oktmo, nm_fias_guid, dt_data_del, id_data_etalon, kd_okato, nm_zipcode, kd_kladr, vl_addr_latitude, vl_addr_longitude, id_area_hist, date_create, f_server_name, id_region
    FROM gar_tmp.adr_area_hist WHERE (date_create >= '2024-01-19 13:20:00') ORDER BY date_create;
    
SELECT a.*, h.* FROM gar_tmp.adr_area a
    JOIN gar_tmp.adr_area_hist h ON (a.id_area = h.id_area)
WHERE (h.date_create >= '2024-01-19 13:20:00') ORDER BY 3;

------------------------------------------------
--
--  Источник корректных ZIP-code  363112
--
WITH xx AS (
            SELECT object_id, value, end_date FROM gar_fias.as_houses_params
              WHERE (type_id = 5) AND (value = '363112')         
     )
     SELECT p.* FROM gar_fias.as_houses_params p
          JOIN xx ON (xx.object_id = p.object_id)
     WHERE (p.type_id = 5) AND (p.end_date > current_date);
