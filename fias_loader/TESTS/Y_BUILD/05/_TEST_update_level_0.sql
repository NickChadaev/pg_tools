SELECT level_id, level_name, short_name, update_date, start_date, end_date, is_active
FROM gar_tmp.v_object_level;

SELECT id_area, nm_area, nm_area_full, id_area_type, nm_area_type, id_area_parent, nm_fias_guid_parent, kd_oktmo, nm_fias_guid, kd_okato, nm_zipcode, kd_kladr, tree_d, level_d, obj_level, level_name, oper_type_id, oper_type_name, curr_date, check_kind
FROM gar_tmp.xxx_adr_area_gap;
--
SELECT id_house, id_addr_parent, nm_fias_guid, nm_fias_guid_parent, nm_parent_obj, region_code, parent_type_id, parent_type_name, parent_type_shortname, parent_level_id, parent_level_name, parent_short_name, house_num, add_num1, add_num2, house_type, house_type_name, house_type_shortname, add_type1, add_type1_name, add_type1_shortname, add_type2, add_type2_name, add_type2_shortname, nm_zipcode, kd_oktmo, kd_okato, oper_type_id, oper_type_name, curr_date, check_kind
FROM gar_tmp.xxx_adr_house_gap;
--
SELECT id_house, id_addr_parent, nm_fias_guid, nm_fias_guid_parent, nm_parent_obj, region_code, parent_type_id, parent_type_name, parent_type_shortname, parent_level_id, parent_level_name
     , parent_short_name, house_num, add_num1, add_num2, house_type, house_type_name, house_type_shortname, add_type1, add_type1_name, add_type1_shortname, add_type2, add_type2_name
     , add_type2_shortname, nm_zipcode, kd_oktmo, kd_okato, oper_type_id, oper_type_name, curr_date, check_kind
FROM gar_tmp.xxx_adr_house_gap
  ORDER BY nm_parent_obj, nm_fias_guid_parent;
  --
SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = 'efbb0998-3d73-4071-9ccb-09a86c293b86');  
--
SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid IN (
  '97299168-9004-412a-ae9c-558d4356c606'
,'58f733ae-fda3-4cf1-8f77-52409f62bc6e'
));

SELECT * FROM  gar_tmp.adr_area WHERE (nm_fias_guid = '806c00f0-64b1-496b-ac23-143664ef687d');
SELECT * FROM  gar_tmp.adr_street WHERE (nm_fias_guid = '806c00f0-64b1-496b-ac23-143664ef687d'); -- Нет 
SELECT * FROM  gar_tmp.adr_street WHERE (nm_street = 'Садовая'); -- Есть  278 

SELECT * FROM gar_fias_pcg_load.f_addr_obj_get_twins ('Садовая'); -- !!!???
SELECT * FROM gar_fias_pcg_load.f_addr_obj_get_parents ('806c00f0-64b1-496b-ac23-143664ef687d');  -- Садовая --> Локомотив --> Махачкала --> Дагестан.
------------------------------------------------------------------------------------------------------------------------------------------------------
-- 81088|84653|'806c00f0-64b1-496b-ac23-143664ef687d'|'aece773e-5c5a-4dbe-8455-aa542f548704'|'Садовая'|204|'ул'|8|'Элемент улично-дорожной сети'|'5'|229421|0|10|'Добавление'|'2016-10-19'|'2079-06-06'|t|t|'{81088}'|0
-- 84653|78727|'aece773e-5c5a-4dbe-8455-aa542f548704'|'727cdf1e-1b70-4e07-8995-9bf7ca9abefb'|'Локомотив'|262|'кв-л'|7|'Элемент планировочной структуры'|'5'|238149|0|10|'Добавление'|'2016-10-19'|'2079-06-06'|t|t|'{81088,84653}'|-1
-- 78727|78545|'727cdf1e-1b70-4e07-8995-9bf7ca9abefb'|'0bb7fa19-736d-49cf-ad0e-9774c4dae09b'|'Махачкала'|28|'г'|5|'Город'|'5'|223292|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|t|t|'{81088,84653,78727}'|-2
-- 78545|0|'0bb7fa19-736d-49cf-ad0e-9774c4dae09b'|''|'Дагестан'|13|'Респ'|1|'Субъект РФ'|'5'|222788|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|t|t|'{81088,84653,78727,78545}'|-3

--
-- '31524a8d-f5df-4a22-9697-1791caf72692'
SELECT * FROM gar_fias_pcg_load.f_addr_obj_get_parents ('31524a8d-f5df-4a22-9697-1791caf72692');  
------------------------------------------------------------------------------------------------
-- 77883|75729|'31524a8d-f5df-4a22-9697-1791caf72692'|'6a5b8826-dc74-4694-bbba-776daa464be1'|'Садовая'|204|'ул'|8|'Элемент улично-дорожной сети'|'5'|221038|0|10|'Добавление'|'2013-04-09'|'2079-06-06'|t|t|'{77883}'|0
-- 75729|78727|'6a5b8826-dc74-4694-bbba-776daa464be1'|'727cdf1e-1b70-4e07-8995-9bf7ca9abefb'|'Локомотив'|79|'кв-л'|6|'Населенный пункт'|'5'|214539|91108|20|'Изменение'|'2012-12-25'|'2079-06-06'|t|t|'{77883,75729}'|-1
-- 78727|78545|'727cdf1e-1b70-4e07-8995-9bf7ca9abefb'|'0bb7fa19-736d-49cf-ad0e-9774c4dae09b'|'Махачкала'|28|'г'|5|'Город'|'5'|223292|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|t|t|'{77883,75729,78727}'|-2
-- 78545|0|'0bb7fa19-736d-49cf-ad0e-9774c4dae09b'|''|'Дагестан'|13|'Респ'|1|'Субъект РФ'|'5'|222788|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|t|t|'{77883,75729,78727,78545}'|-3

