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
 WHERE(ss.nm_street_full ilike '%ленин%') 
