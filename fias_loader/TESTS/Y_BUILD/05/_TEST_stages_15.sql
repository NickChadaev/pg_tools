-- 2023-10-03   Формирование буферной таблицы.  
-- ----------
--    unnsi - сторонняя схема, таблицы в ней не изменяются.
--    gar_tmp - локальная схема, таблицы в ней модифицируются.
--    
--    Этапы:
--           -- формирование буферной  таблицы, контроль log.
--           -- обновления:
--                 -- адресные пространства,
--                 -- улицы,
--                 -- дома.
--                 
--    LOGs
-- 
-- [22:14:17] ...     -- Очистка данных во временной схеме.   
--    
-- [22:14:39] ...     -- Агрегация данных
-- [22:14:39] ...     -- Агрегация параметров
-- [22:14:48] ...     -- Агрегация адресных пространств
-- [22:14:49] ...     -- Агрегация домовладений
-- [22:14:57] ...     -- Заполнение управляющей таблицы "gar_tmp.xxx_obj_fias"
--    
--    
-- Это потом:
-- 
-- [22:15:06] ...  -- stage_41r (Обработка данных)
-- [22:15:06] ...     -- Адресные регионы, дополнение
-- [22:15:06] ...     -- Адресные регионы, обновление
-- [22:15:09] ...     -- Элемент улично-дорожной сети, дополнение
-- [22:15:10] ...     -- Элемент улично-дорожной сети, обновление
-- [22:15:33] ...     -- Здания (сооружения), дополнение
-- [22:15:34] ...     -- Здания (сооружения), обновление
-- 
-- 
-- 
-- 
--  f_xxx_adr_area_set_data 
-- -------------------------
--                    26250
-- (1 row)
-- 
--  f_xxx_adr_house_set_data 
-- --------------------------
--                    617502
-- (1 row)
-- 
--  f_xxx_obj_fias_set_data 
-- -------------------------
--                     2065
--                    24185
--                   611622
-- (3 rows)
-- 
--  id_un_export | dt_gar_version | kd_export_type | id_region | nm_area_full  |         dt_export          | nm_user  | seq_value | node_id | id_un_export_by_obj | sch_name | nm_object  | qty_main | qty_aux |                               file_path                                | fserver_name |   host    |     dbname     | port | db_conn_name  
-- --------------+----------------+----------------+-----------+---------------+----------------------------+----------+-----------+---------+---------------------+----------+------------+----------+---------+------------------------------------------------------------------------+--------------+-----------+----------------+------+---------------
--            67 | 0223-09-25     | f              |         6 | Дагестан Респ | 2023-09-26 22:21:46.893425 | postgres | 600071179 |       1 |                 199 | gar_tmp  | adr_area   |     2096 |       7 | /home/n.chadaev@abrr.local/tmp/up_prds_2230925/DATA/adr_area_06.sql    | unnsi_prd_s  | 127.0.0.1 | unnsi_prd_test | 5432 | c_unnsi_prd_s
--            67 | 0223-09-25     | f              |         6 | Дагестан Респ | 2023-09-26 22:21:46.893425 | postgres | 600071179 |       1 |                 200 | gar_tmp  | adr_street |    25477 |      55 | /home/n.chadaev@abrr.local/tmp/up_prds_2230925/DATA/adr_street_06.sql  | unnsi_prd_s  | 127.0.0.1 | unnsi_prd_test | 5432 | c_unnsi_prd_s
--            67 | 0223-09-25     | f              |         6 | Дагестан Респ | 2023-09-26 22:21:46.893425 | postgres | 600071179 |       1 |                 201 | gar_tmp  | adr_house  |   663156 |     356 | /home/n.chadaev@abrr.local/tmp/up_prds_2230925/DATA/adr_house_06.sql   | unnsi_prd_s  | 127.0.0.1 | unnsi_prd_test | 5432 | c_unnsi_prd_s
-- 
-- ----------------------------------------------------------------- 
 
DELETE FROM ONLY gar_tmp.xxx_adr_area;         -- Временная таблица. заполняется данными из "AS_ADDR_OBJ", "AS_REESTR_OBJECTS", "AS_ADM_HIERARCHY", "AS_MUN_HIERARCHY", "AS_OBJECT_LEVEL", "AS_STEADS_PARAMS"
DELETE FROM ONLY gar_tmp.xxx_adr_house;	       -- Адреса домов 
DELETE FROM ONLY gar_tmp.xxx_obj_fias;         -- Дополнительная связь адресных объектов с ГАР-ФИАС
DELETE FROM ONLY gar_tmp.xxx_type_param_value; -- Для каждого объекта хранятся агрегированные пары "Тип" - "Значение"

SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_set_data();
SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_house_set_data();
SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_set_data('gar_tmp','gar_tmp','gar_tmp');
SELECT * FROM gar_tmp_pcg_trans.f_set_params_value();

-------------------------------------------------------------------------------------

DELETE FROM ONLY gar_tmp.xxx_adr_area;         --   26250
DELETE FROM ONLY gar_tmp.xxx_adr_house;	       --  617502
DELETE FROM ONLY gar_tmp.xxx_obj_fias;         --  637872
DELETE FROM ONLY gar_tmp.xxx_type_param_value; -- 1065890

-- Идиот, обновлять aux !!!
SELECT * FROM gar_tmp.adr_area_aux;
------------------------------------
id_area	op_sign
192259	U
192263	U     <----- Старьё  
192331	U
22872	U
----------
208140	U
208184	U
208173	U

SELECT * FROM gar_tmp.adr_street_aux;
DELETE FROM gar_tmp.adr_street_aux;
--
SELECT * FROM gar_tmp.adr_house_aux;
DELETE FROM gar_tmp.adr_house_aux;



SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_set_data();   --  26509
SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_house_set_data();  -- 617502
SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_set_data('gar_tmp','gar_tmp','gar_tmp');

   --   2076
   --  24433
   -- 617487  --  15 ??

SELECT * FROM gar_tmp_pcg_trans.f_set_params_value(); -- 1065890

             SELECT
                 aa.id_addr_obj   
                ,aa.fias_guid     
                ,0 AS type_object
		        ,aa.tree_d
		        ,aa.level_d
                
             FROM gar_tmp.xxx_adr_area aa  
                    WHERE (aa.obj_level <> 8)  -- 2023-10-04 ..  Х ....тень была
		        ORDER BY tree_d -- 2082
------------------------------------------------------------------------------
             SELECT
                 aa.id_addr_obj   
                ,aa.fias_guid     
                ,1 AS type_object
		        ,aa.tree_d
		        ,aa.level_d
                
             FROM gar_tmp.xxx_adr_area aa  
                    WHERE (aa.obj_level = 8)  -- 2023-10-04 ..  Х ....тень была
		     ORDER BY tree_d
				

SELECT * FROM gar_tmp.xxx_obj_fias;
SELECT * FROM gar_tmp.xxx_obj_fias WHERE (type_object = 2) AND (id_obj IS NULL); -- 6494
SELECT * FROM gar_tmp.xxx_obj_fias WHERE (type_object = 1) AND (id_obj IS NULL); --  298
SELECT * FROM gar_tmp.xxx_obj_fias WHERE (type_object = 0) AND (id_obj IS NULL); --   19

SELECT * FROM gar_tmp.xxx_obj_fias f
   INNER JOIN public.fias_not_found_06u u ON (u.guid = f.obj_guid) -- 160   60 ??

SELECT * FROM public.fias_not_found_06u; -- 220
--
--  Установка последовательностей.
--
SELECT gar_tmp_pcg_trans.f_xxx_obj_seq_crt (
              p_seq_name      := 'gar_tmp.obj_seq' -- Имя последовательности
             ,p_id_region     := 6                 -- ID региона
             ,p_init_value    := 100000000         -- Начальное значение
);

Что произошло с функционалом обновления/дополнения.

SELECT * FROM gar_tmp.xxx_obj_fias WHERE (type_object = 2) AND (id_obj IS NULL); -- 6494
SELECT * FROM gar_tmp.xxx_obj_fias WHERE (type_object = 1) AND (id_obj IS NULL); --  298 -- 296/249
SELECT * FROM gar_tmp.xxx_obj_fias WHERE (type_object = 0) AND (id_obj IS NULL); --   19


Почему не дополнились, не обновились ???
----------------------------------------
SELECT * FROM gar_tmp.xxx_obj_fias WHERE (type_object = 2) AND (id_obj IS NULL); -- 6494
SELECT * FROM gar_tmp.xxx_obj_fias WHERE (type_object = 1) AND (id_obj IS NULL); --  298
SELECT * FROM gar_tmp.xxx_obj_fias WHERE (type_object = 0) AND (id_obj IS NULL); --   19

SELECT aa.* FROM gar_tmp.xxx_adr_area aa --  19
   INNER JOIN gar_tmp.xxx_obj_fias xx ON (aa.fias_guid = xx.obj_guid) 
WHERE ((xx.type_object = 0) AND (xx.id_obj IS NULL));   

SELECT aa.* FROM gar_tmp.xxx_adr_area aa -- 298
   INNER JOIN gar_tmp.xxx_obj_fias xx ON (aa.fias_guid = xx.obj_guid) 
WHERE ((xx.type_object = 1) AND (xx.id_obj IS NULL))-- and (nm_addr_obj = 'Юннатов');

SELECT hh.* FROM gar_tmp.xxx_adr_house hh -- 6494
   INNER JOIN gar_tmp.xxx_obj_fias xx ON (hh.fias_guid = xx.obj_guid) 
WHERE ((xx.type_object = 2) AND (xx.id_obj IS NULL)) ;

SELECT hh.* FROM gar_tmp.xxx_adr_house hh -- 111 !!!  и ДОЛЖНЫ ОБНОВЛЯТЬСЯ
   INNER JOIN gar_tmp.xxx_obj_fias xx ON (hh.fias_guid = xx.obj_guid) 
   INNER JOIN public.fias_not_found_06u n ON (hh.fias_guid = n.guid)    
WHERE ((xx.type_object = 2) AND (xx.id_obj IS NULL)) ;


-- 2023-10-04  Что, почему появились "бездомные" По новой.
-- 2023-10-06  По новой ещё раз
----------------------------------------------------------

DELETE FROM ONLY gar_tmp.xxx_adr_area;         --   26509/26515
DELETE FROM ONLY gar_tmp.xxx_adr_house;	       --  617502/617502
DELETE FROM ONLY gar_tmp.xxx_obj_fias;         --  643996/644002
DELETE FROM ONLY gar_tmp.xxx_type_param_value; -- 1065890/1065890

-- Идиот, обновлять aux !!!
SELECT * FROM gar_tmp.adr_area_aux;
DELETE FROM  gar_tmp.adr_area_aux; --7/24

SELECT * FROM gar_tmp.adr_street_aux;
DELETE FROM gar_tmp.adr_street_aux; -- 0/249 
--
SELECT * FROM gar_tmp.adr_house_aux;
DELETE FROM gar_tmp.adr_house_aux; -- 0/5880
---------------------------------------
---------------------------------------
SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_set_data(
       p_date          := current_date
      ,p_obj_level     := 16
      ,p_oper_type_ids := NULL::bigint[]
);   --  26515  с явным указанием параметров
DELETE FROM ONLY gar_tmp.xxx_adr_area;
SELECT * FROM ONLY gar_tmp.xxx_adr_area;
--
SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_set_data(); -- 26509
--
DELETE FROM ONLY gar_tmp.xxx_adr_area;

SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_house_set_data();  -- 617693
SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_set_data('gar_tmp','gar_tmp','gar_tmp');

   --   2076 /  2082  /  2082
   --  24433 / 24433  / 24433
   -- 617487  --  617491

SELECT * FROM gar_tmp_pcg_trans.f_set_params_value(); --  1065890
------------------------------------------------------------------
SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_set_data('gar_tmp','gar_tmp','gar_tmp');
SELECT * FROM gar_tmp.xxx_obj_fias;

   --   2076
   --  24433
   -- 617487  --  15 ??

SELECT * FROM gar_tmp_pcg_trans.f_set_params_value(); -- 1065890

SELECT * FROM gar_tmp.xxx_obj_fias;  -- 644006
SELECT * FROM gar_tmp.xxx_obj_fias WHERE (type_object = 2) AND (id_obj IS NULL); -- 6494 / 619
SELECT * FROM gar_tmp.xxx_obj_fias WHERE (type_object = 1) AND (id_obj IS NULL); --  298 / 296 / 47
SELECT * FROM gar_tmp.xxx_obj_fias WHERE (type_object = 0) AND (id_obj IS NULL); --   19 /  25 /  4

