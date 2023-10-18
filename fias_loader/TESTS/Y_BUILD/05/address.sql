SELECT * FROM unnsi.adr_area LIMIT 10;
SELECT * FROM unnsi.adr_area WHERE (nm_area_full ilike '%Махачкала%Ленинский%');
-- 
-- "id_area"	"id_country"	"nm_area"	"nm_area_full"	"id_area_type"	"id_area_parent"	"kd_timezone"	"pr_detailed"	"kd_oktmo"	"nm_fias_guid"	"dt_data_del"	"id_data_etalon"	"kd_okato"	"nm_zipcode"	"kd_kladr"	"vl_addr_latitude"	"vl_addr_longitude"
-- 600071693	185	"Домостроитель"	"Дагестан Респ, Махачкала г., Ленинский район р-н, Домостроитель кв-л"	23	600071692	2	0	"82701365"	"10545955-a1c6-4d6c-8fdf-858ad88e5e44"			"82401365000"		

SELECT * FROM unnsi.adr_street WHERE (nm_street_full ilike '%Монтажный%туп%');

-- "id_street"	"id_area"	"nm_street"	"id_street_type"	"nm_street_full"	"nm_fias_guid"	"dt_data_del"	"id_data_etalon"	"kd_kladr"	"vl_addr_latitude"	"vl_addr_longitude"
-- 600071910	600071693	"5-й Монтажный"	37	"5-й Монтажный туп."	"c62ae0c3-7ea2-4f41-8603-cb15d7532cf8"					

SELECT * FROM unnsi.adr_house WHERE (id_street = 600071910) AND (nm_house_1 = '3');

-- "id_house"	"id_area"	"id_street"	"id_house_type_1"	"nm_house_1"	"id_house_type_2"	"nm_house_2"	"id_house_type_3"	"nm_house_3"	"nm_zipcode"	"nm_house_full"	"kd_oktmo"	"nm_fias_guid"	"dt_data_del"	"id_data_etalon"	"kd_okato"	"vl_addr_latitude"	"vl_addr_longitude"
-- 600077601	600071693	600071910	2	"3"					"367010"	"д. 3"	"82701365"	"1fc57b91-c02f-4f70-9c7e-06236239397e"			"82401365000"		
------------------------------------
------------------------------------
-- 
-- "id_area"	"id_country"	"nm_area"	"nm_area_full"	"id_area_type"	"id_area_parent"	"kd_timezone"	"pr_detailed"	"kd_oktmo"	"nm_fias_guid"	"dt_data_del"	"id_data_etalon"	"kd_okato"	"nm_zipcode"	"kd_kladr"	"vl_addr_latitude"	"vl_addr_longitude"
-- 600071693	185	"Домостроитель"	"Дагестан Респ, Махачкала г., Ленинский район р-н, Домостроитель кв-л"	23	600071692	2	0	"82701365"	"10545955-a1c6-4d6c-8fdf-858ad88e5e44"			"82401365000"		

-- "id_street"	"id_area"	"nm_street"	"id_street_type"	"nm_street_full"	"nm_fias_guid"	"dt_data_del"	"id_data_etalon"	"kd_kladr"	"vl_addr_latitude"	"vl_addr_longitude"
-- 600071910	600071693	"5-й Монтажный"	37	"5-й Монтажный туп."	"c62ae0c3-7ea2-4f41-8603-cb15d7532cf8"					

-- "id_house"	"id_area"	"id_street"	"id_house_type_1"	"nm_house_1"	"id_house_type_2"	"nm_house_2"	"id_house_type_3"	"nm_house_3"	"nm_zipcode"	"nm_house_full"	"kd_oktmo"	"nm_fias_guid"	"dt_data_del"	"id_data_etalon"	"kd_okato"	"vl_addr_latitude"	"vl_addr_longitude"
-- 600077601	600071693	600071910	2	"3"					"367010"	"д. 3"	"82701365"	"1fc57b91-c02f-4f70-9c7e-06236239397e"			"82401365000"		
---------------

SELECT a.nm_area_full, s.nm_street_full, h.nm_house_full FROM unnsi.adr_area a 
  INNER JOIN unnsi.adr_street s ON (a.id_area = s.id_area) AND (s.id_street = 600071910)
  INNER JOIN unnsi.adr_house h ON (a.id_area = h.id_area) AND (s.id_street = h.id_street)

  WHERE (a.id_area = 600071693) AND (h.id_house = 600077601);
 
------------------------------------------------------------------------- 
SELECT * FROM gar_tmp.adr_area WHERE (nm_area_full ilike '%Махачкала%Ленинский%');    -- 600070876
SELECT * FROM gar_tmp.adr_street WHERE (nm_street_full ilike '%Монтажный%туп%');      -- 600071591
SELECT * FROM gar_tmp.adr_house WHERE (id_street = 600071591) AND (nm_house_1 = '3'); -- 600083147
 
 SELECT a.nm_area_full, s.nm_street_full, h.nm_house_full FROM gar_tmp.adr_area a 
  INNER JOIN gar_tmp.adr_street s ON (a.id_area = s.id_area) AND (s.id_street = 600071591)
  INNER JOIN gar_tmp.adr_house h ON (a.id_area = h.id_area) AND (s.id_street = h.id_street)
  WHERE (a.id_area = 600070876) AND (h.id_house = 600083147);
 
  
-- "nm_area_full"	"nm_street_full"	"nm_house_full"
-- "Дагестан Респ, Махачкала г., Ленинский район р-н, Домостроитель кв-л"	"5-й Монтажный туп."	"д. 3"  
 
 SELECT a.nm_area_full, s.nm_street_full, h.nm_house_full, 'Участок: ' || d.stead_num, 'Кадастровый номер участка: ' || d.stead_cadastr_num 
 FROM gar_tmp.adr_area a 
  INNER JOIN gar_tmp.adr_street s ON (a.id_area = s.id_area) AND (s.id_street = 600071591)
  INNER JOIN gar_tmp.adr_house h ON (a.id_area = h.id_area) AND (s.id_street = h.id_street)
  LEFT OUTER JOIN gar_tmp.adr_stead d ON (a.id_area = d.id_area) AND (s.id_street = d.id_street)    
 WHERE (a.id_area = 600070876) AND (h.id_house = 600083147) and (d.id_stead = 601015733); 

--Дагестан Респ, Махачкала г., Ленинский район р-н, Домостроитель кв-л, 5-й Монтажный туп. д. 3,   Участок: 5б Кадастровый номер участка: 05:40:000075:3083|
