SELECT gar_link.f_server_crt ('unnsi_prd_et', '10.196.35.165', 'unnsi_prd_et', 5432, 'postgres', 'postgres', ''); --1
SELECT gar_link.f_schema_import ('unnsi_prd_et', 'unnsi', 'unsi', 'ЭТАЛОН от 2022-12-15'); -- 2

SELECT * FROM unsi.adr_street LIMIT 100;
------------------------------------------
-- Идиот, это другой регион.
-- 9046|97|'Медная 8-й'|23|'Медная 8-й проезд'|'15d90e1b-84a4-4d8d-8a36-2dbd463253a2'|''||''||
-- 9975|125|'Керченская'|38|'Керченская ул.'|'4547cbcc-997a-4cc0-9ca6-a983a5349879'|''||''||
-- 95211|1573|'13-й'|12|'13-й кв-л'|'023d0b12-9e2e-4a28-b59f-fe177faa2578'|''||''||
-- 95214|1573|'15А'|16|'15А мкр.'|'a9c0bc28-865e-48f6-9fd1-d596e30c44f9'|''||''||


SELECT * FROM gar_tmp.adr_street ;
-----------------------------------------------------------------------------------------------
-- 321237|26784|'Дружбы Народов'|40|'Дружбы Народов ш.'|'4de388fc-937e-47c4-aea3-f063aa55cef3'|'2023-10-20 18:04:09.30937'|931138
-- 931138|26784|'Дружбы Народов'|40|'Дружбы Народов ш.'|'b70a1ddf-ee1e-491c-806e-b109551555e2'|''|

SELECT * FROM gar_tmp.adr_street WHERE (nm_fias_guid = '4de388fc-937e-47c4-aea3-f063aa55cef3');

CALL gar_tmp_pcg_trans.p_adr_street_upd_single ('gar_tmp', 'gar_tmp', '4de388fc-937e-47c4-aea3-f063aa55cef3');

SELECT * FROM gar_tmp.adr_street WHERE (nm_fias_guid = 'b70a1ddf-ee1e-491c-806e-b109551555e2');

CALL gar_tmp_pcg_trans.p_adr_street_upd_single ('gar_tmp', 'gar_tmp', 'b70a1ddf-ee1e-491c-806e-b109551555e2');

CALL gar_tmp_pcg_trans.p_adr_street_upd_single ('gar_tmp', 'gar_tmp', 'b70a1ddf-ee1e-491c-806e-b109551555e2', p_kd_kladr := NULL); -- Сработал логический фильтр
--
SELECT * FROM gar_tmp.adr_street WHERE (nm_fias_guid = 'b70a1ddf-ee1e-491c-806e-b109551555e2'); -- дАЛЕЕ ВКЛЮЧАЮ режим прямой записи. тип улицы при этом, нужно указать явно
CALL gar_tmp_pcg_trans.p_adr_street_upd_single ('gar_tmp', 'gar_tmp', 'b70a1ddf-ee1e-491c-806e-b109551555e2', TRUE, p_id_street_type := 40); 

SELECT * FROM gar_tmp.adr_street WHERE (nm_fias_guid = 'b70a1ddf-ee1e-491c-806e-b109551555e2');
--
 