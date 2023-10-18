------------------------------------------------------------
-- 2023-10-05  Башкирия  xxx_adr_area_type -- уже обновлена.
-------------------------------------------------------------
--
--  Установка последовательностей.
--
SELECT gar_tmp_pcg_trans.f_xxx_obj_seq_crt (
              p_seq_name      := 'gar_tmp.obj_seq' -- Имя последовательности
             ,p_id_region     := 4                 -- ID региона
             ,p_init_value    := 100000000         -- Начальное значение
);

DELETE FROM ONLY gar_tmp.xxx_adr_area;         --    47127
DELETE FROM ONLY gar_tmp.xxx_adr_house;	       --  1062791
DELETE FROM ONLY gar_tmp.xxx_obj_fias;         --  1109918
DELETE FROM ONLY gar_tmp.xxx_type_param_value; --  3952624

-- Идиот, обновлять aux !!!
SELECT * FROM gar_tmp.adr_area_aux;
DELETE FROM  gar_tmp.adr_area_aux; -- 12

SELECT * FROM gar_tmp.adr_street_aux;
DELETE FROM gar_tmp.adr_street_aux; -- 1
--
SELECT * FROM gar_tmp.adr_house_aux;
DELETE FROM gar_tmp.adr_house_aux; -- 728

SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_set_data(); -- 47144
DELETE FROM ONLY gar_tmp.xxx_adr_area;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_set_data(
       p_date          := current_date
      ,p_obj_level     := 16
      ,p_oper_type_ids := NULL::bigint[]
);   --  47144  с явным указанием параметров
-- +++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT * FROM ONLY gar_tmp.xxx_adr_area;

SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_house_set_data();  -- 1062791 
SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_set_data('gar_tmp','gar_tmp','gar_tmp');

   --    9791
   --   37353
   -- 1062791

SELECT * FROM gar_tmp_pcg_trans.f_set_params_value(); --  3952624


SELECT gar_tmp_pcg_trans.f_xxx_obj_seq_crt (
              p_seq_name      := 'gar_tmp.obj_seq' -- Имя последовательности
             ,p_id_region     := 6                 -- ID региона
             ,p_init_value    := 100000000         -- Начальное значение
);
