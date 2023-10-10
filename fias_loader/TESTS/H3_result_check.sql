SELECT ax.*, aa.* FROM gar_tmp.adr_area aa
   INNER JOIN gar_tmp.adr_area_aux ax ON (aa.id_area = ax.id_area);
 --
 SELECT sx.op_sign, aa.nm_area_full, ss.* FROM gar_tmp.adr_street ss
   INNER JOIN gar_tmp.adr_area aa ON (aa.id_area = ss.id_area)
   INNER JOIN gar_tmp.adr_street_aux sx ON (ss.id_street = sx.id_street);
--
 SELECT sx.op_sign, aa.nm_area_full, ss.* FROM gar_tmp.adr_street ss
   INNER JOIN gar_tmp.adr_area aa ON (aa.id_area = ss.id_area)
   INNER JOIN gar_tmp.adr_street_aux sx ON (ss.id_street = sx.id_street)
 WHERE(ss.nm_street_full ilike '%ленин%');   
--
 SELECT hx.op_sign, aa.nm_area_full, ss.nm_street_full, hh.* FROM gar_tmp.adr_house hh
   INNER JOIN gar_tmp.adr_house_aux hx ON (hh.id_house = hx.id_house) 
   INNER JOIN gar_tmp.adr_area aa ON (aa.id_area = hh.id_area)
   LEFT OUTER JOIN gar_tmp.adr_street ss ON (ss.id_street = hh.id_street);
--
 SELECT hx.op_sign, aa.nm_area_full, ss.nm_street_full, hh.* FROM gar_tmp.adr_house hh
   INNER JOIN gar_tmp.adr_house_aux hx ON (hh.id_house = hx.id_house) 
   INNER JOIN gar_tmp.adr_area aa ON (aa.id_area = hh.id_area)
   LEFT OUTER JOIN gar_tmp.adr_street ss ON (ss.id_street = hh.id_street)
 WHERE(ss.nm_street_full ilike '%ленин%') ;
--
 SELECT id, object_id, object_guid, change_id, object_name, type_id, type_name, obj_level, oper_type_id, prev_id, next_id, update_date, start_date, end_date, is_actual, is_active
	FROM gar_fias.as_addr_obj WHERE (end_date > NOW() AND (not is_actual));

 SELECT hx.op_sign, aa.nm_area_full, ss.nm_street_full, ss.nm_fias_guid, hh.* FROM gar_tmp.adr_house hh
   INNER JOIN gar_tmp.adr_house_aux hx ON (hh.id_house = hx.id_house) 
   INNER JOIN gar_tmp.adr_area aa ON (aa.id_area = hh.id_area)
   LEFT OUTER JOIN gar_tmp.adr_street ss ON (ss.id_street = hh.id_street)
 WHERE(ss.nm_fias_guid IN ('d2f48256-c10a-4806-b281-9b5b85d56616'
,'c74b60e5-9e44-49de-8989-2f51a50d0ada'
,'b70a1ddf-ee1e-491c-806e-b109551555e2'
,'ddf6a4e7-5207-42fd-8af3-89c905d0f368'
,'bb301a7c-c4f5-4c00-a564-b4854377bfbb'
,'a669b619-6016-48be-8564-e05ccac82a4a'
,'bcdff115-70b6-464b-8e86-76a9bd64468d'
,'80513d5c-ebf2-4f4f-a9ec-2c3356329c09'
,'8418d308-bf4a-4d5f-a7a4-5d46032692c5'
,'6e876e17-68a5-4d63-b078-1dc2202c7173'
)) ;



