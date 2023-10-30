SELECT h.id_area, h.nm_area, h.nm_area_full, h.id_area_type, h.id_area_parent, h.nm_fias_guid, h.dt_data_del, h.id_data_etalon, id_region,
       a.id_area, a.nm_area, a.nm_area_full, a.id_area_type, a.id_area_parent, a.nm_fias_guid
   FROM gar_tmp.adr_area_hist h   
INNER JOIN gar_tmp.adr_area a ON (a.id_area = h.id_area)

WHERE NOT (h.nm_fias_guid = a.nm_fias_guid) 
ORDER BY a.id_area_type, a.id_area_parent, a.nm_area_full, h.dt_data_del DESC;
