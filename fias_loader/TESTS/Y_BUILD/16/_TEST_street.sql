SELECT * FROM gar_tmp.adr_house WHERE (id_house = 30142211);
-- 30142211|14661|260329|2|'77'||''||''|''|'д. 77'|'92648455101'|'1aee8c90-f612-459c-a8bd-44a24e945e9d'
SELECT * FROM gar_tmp.adr_house_hist WHERE (id_house = 30142211);
-- 30142211|208600||2|'77'||''||''|''|'д. 77'|'92648455101'|'1aee8c90-f612-459c-a8bd-44a24e945e9d'|'2023-11-29 12:04:00.12209'|30142211
--
-- --------------------------------------------------------------------
SELECT a.nm_area_full, s.nm_street_full, h.* FROM gar_tmp.adr_house h 
    INNER JOIN gar_tmp.adr_area a ON (a.id_area = h.id_area) 
    INNER JOIN gar_tmp.adr_street s ON (s.id_street = h.id_street)
WHERE (h.id_house = 30142211);
-- 'Татарстан Респ, Пестречинский р-н, Пестрецы с'|'Сады Стрелка тер.'|30142211|14661|260329|2|'77'||''||''|''|'д. 77'|'92648455101'|'1aee8c90-f612-459c-a8bd-44a24e945e9d'
--
-- ????????????????????????
--
SELECT * FROM gar_tmp.adr_street WHERE (id_street = 260329);
-------------------------------------------------------------
-- 260329|14661|'Сады Стрелка'|34|'Сады Стрелка тер.'|'4eaec63a-5f26-4b1a-91fa-b487bb473608'|''||'160340000010105'|

SELECT * FROM gar_tmp.adr_street_hist WHERE (id_street = 260329); -- Не менялась  !!  Ввести в работу  запретную дату. 


SELECT * FROM gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data ('gar_tmp') WHERE (id_street_type = 34); 
-------------------------------------------------------------------------------------------------------
-- 34|'Территория'|'тер.'|'2023-11-15 00:00:00'|''||''|''|''|'' -- это так. тем не менеее.

SELECT a.nm_area_full, h.* FROM gar_tmp.adr_house_hist h 
    INNER JOIN gar_tmp.adr_area a ON (a.id_area = h.id_area) 
    --INNER JOIN gar_tmp.adr_street s ON (s.id_street = h.id_street)
WHERE (h.id_house = 30142211);
--
-- 'Татарстан Респ, Пестречинский р-н, Пестрецы с, Стрелка тер. ТСН'|30142211|208600||2|'77'||''||''|''|'д. 77'|'92648455101'|'1aee8c90-f612-459c-a8bd-44a24e945e9d'|'2023-11-29 12:04:00.12209'|30142211|'92248000001'|||118970|'2023-11-29 12:04:00.12209'|''|
--
SELECT * FROM gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data ('gar_tmp') WHERE (fias_ids IS NULL); 

--
-- Ещё раз
--
-- U  | 1700138370 |     174715 |     908113 |   2 | 135   |    |    |    | 423548     | д. 135           | 92644101116 | b66c8245-babe-43a7-b29

SELECT a.nm_area_full, s.nm_street_full, h.* FROM gar_tmp.adr_house_hist h 
    INNER JOIN gar_tmp.adr_area a ON (a.id_area = h.id_area) 
    INNER JOIN gar_tmp.adr_street s ON (s.id_street = h.id_street)
WHERE (h.id_house = 1700138370);
--
-- 'Татарстан Респ, Нижнекамский р-н, Нижнекамск г., Ильинка д.'|'СТ Строитель тер.'|1700138370|174715|908113|2|'135'||''||''|'423548'|'д. 135'|'92644101116'|'b66c8245-babe-43a7-b29b-ce1a56237057'|'2023-01-08 21:06:50.511549'|1700138370
--
SELECT a.nm_area_full, s.nm_street_full, h.* FROM gar_tmp.adr_house h 
    INNER JOIN gar_tmp.adr_area a ON (a.id_area = h.id_area) 
    INNER JOIN gar_tmp.adr_street s ON (s.id_street = h.id_street)
WHERE (h.id_house = 1700138370);

-- 'Татарстан Респ, Нижнекамский р-н, Нижнекамск г., Ильинка д.'|'СТ Строитель тер.'|1700138370|174715|908113|2|'135'||''||''|'423548'|'д. 135'|'92644101116'|'b66c8245-babe-43a7-b29b-ce1a56237057'|''||'92435000004'||

-- ====================================================================================
--       | 1700152523 |     174715 |     908118 |               2 | 407        |                 |            |                 |            | 423548     | д. 407           | 92644101116 | 4939c5f8-1563-4cc6-b89


SELECT a.nm_area_full, s.nm_street_full, h.* FROM gar_tmp.adr_house h 
    INNER JOIN gar_tmp.adr_area a ON (a.id_area = h.id_area) 
    INNER JOIN gar_tmp.adr_street s ON (s.id_street = h.id_street)
WHERE (h.id_house = 1700152523);
-------------------------------------------------------------------
-- 'Татарстан Респ, Нижнекамский р-н, Нижнекамск г., Ильинка д.'|'СТ Чайка тер.'|1700152523|174715|908118|2|'407'||''||''|'423548'|'д. 407'|'92644101116'|'4939c5f8-1563-4cc6-b89c-3b460e419aa9'|''||'92435000004'||
--
SELECT * FROM gar_tmp.adr_street WHERE (id_street = 908118);
------------------------------------------------------------
-- 908118|174715|'СТ Чайка'|34|'СТ Чайка тер.'|'70845625-a15c-47eb-8feb-6ac7ea98c9d0'|''||'160310010050008'||

SELECT * FROM gar_tmp.adr_street_hist WHERE (id_street = 908118); -- нет

SELECT a.nm_area_full, s.nm_street_full, h.* FROM gar_tmp.adr_house_hist h 
    INNER JOIN gar_tmp.adr_area a ON (a.id_area = h.id_area) 
    INNER JOIN gar_tmp.adr_street s ON (s.id_street = h.id_street)
WHERE (h.id_house = 1700152523);
--
-- 'Татарстан Респ, Нижнекамский р-н, Нижнекамск г., Ильинка д.'|'СТ Чайка тер.'|1700152523|174715|908118|2|'407'||''||''|''|'д. 407'|'92644101116'|'4939c5f8-1563-4cc6-b89c-3b460e419aa9'|'2023-01-08 21:06:50.511549'|1700152523|'92435000004'|||45290|'2023-01-08 21:06:50.511549'|''|
--
-- Старые данные (типы данных_ могут участвовать в игре, новые -- нет.

