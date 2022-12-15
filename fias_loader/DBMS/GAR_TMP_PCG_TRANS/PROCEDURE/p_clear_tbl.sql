DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_clear_tbl (integer[]);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_clear_tbl (
          p_op_type  integer[] = ARRAY[-8,-9]::integer[] 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-13/2021-11-25/2022-03-15
    -- ----------------------------------------------------------------------------------------------------  
    -- Очистка временных (буфферных таблиц). FALSE - очищаются только таблицы-результаты TRUE - все таблицы.
    -- 2022-03-15 -- История сохраняется всегда.
    -- 2022-09-26 -- Многоступенчатое удаление.
    -- 2022-10-21 -- Вспомогательные таблицы.
    -- 2022-12-15 -- Пересмотр приоритетов процессов очистки данных: 
    -- ====================================================================================================
    DECLARE

      _OP_0 CONSTANT integer := 0;  
      _OP_1 CONSTANT integer := 1; -- Временные таблицы и вспомогательные таблицы.
      _OP_2 CONSTANT integer := 2; -- Таблицы-секции
      _OP_3 CONSTANT integer := 3;
      _OP_4 CONSTANT integer := 4;
      _OP_5 CONSTANT integer := 5;
      _OP_6 CONSTANT integer := 6; -- logging выгрузки.
      _OP_7 CONSTANT integer := 7; -- GAP-таблицы
      _OP_8 CONSTANT integer := 8; -- Исторические таблицы
      _OP_9 CONSTANT integer := 9; -- Прототипы справочников
         
    BEGIN
    
     IF (_OP_1 = ANY (p_op_type)) THEN -- Только временные таблицы.
     
        DELETE FROM ONLY gar_tmp.xxx_adr_area;         -- Временная таблица. заполняется данными из "AS_ADDR_OBJ", "AS_REESTR_OBJECTS", "AS_ADM_HIERARCHY", "AS_MUN_HIERARCHY", "AS_OBJECT_LEVEL", "AS_STEADS_PARAMS"
        DELETE FROM ONLY gar_tmp.xxx_adr_house;	       -- Адреса домов 
        DELETE FROM ONLY gar_tmp.xxx_obj_fias;         -- Дополнительная связь адресных объектов с ГАР-ФИАС
        DELETE FROM ONLY gar_tmp.xxx_type_param_value; -- Для каждого объекта хранятся агрегированные пары "Тип" - "Значение"
        --
        --  2022-10-21  Вспомогательные таблицы.
        --
        DELETE FROM ONLY gar_tmp.adr_area_aux;     
        DELETE FROM ONLY gar_tmp.adr_house_aux; 
        DELETE FROM ONLY gar_tmp.adr_street_aux;        
      
     END IF;
     --
     IF (_OP_2 = ANY (p_op_type)) THEN -- Только таблицы-секции
     
        DELETE FROM ONLY gar_tmp.adr_area;     
        DELETE FROM ONLY gar_tmp.adr_house; 
        DELETE FROM ONLY gar_tmp.adr_objects;
        DELETE FROM ONLY gar_tmp.adr_street;
      
     END IF;
     -- 
     IF (_OP_6 = ANY (p_op_type)) THEN -- LOGGING выгрузки
     
        DELETE FROM ONLY export_version.un_export_by_obj;
        DELETE FROM ONLY export_version.un_export;

     END IF;     
     -- 
     IF (_OP_7 = ANY (p_op_type)) THEN -- Только GAP-таблицы
     
        DELETE FROM ONLY gar_tmp.xxx_adr_street_gap;
        DELETE FROM ONLY gar_tmp.xxx_adr_area_gap;
        DELETE FROM ONLY gar_tmp.xxx_adr_house_gap;

     END IF;
     --
     IF (_OP_8 = ANY (p_op_type)) THEN -- Только исторические таблицы
     
        DELETE FROM ONLY gar_tmp.adr_area_hist;     
        DELETE FROM ONLY gar_tmp.adr_house_hist; 
        DELETE FROM ONLY gar_tmp.adr_objects_hist;
        DELETE FROM ONLY gar_tmp.adr_street_hist;
      
     END IF;
     --
     IF (_OP_9 = ANY (p_op_type)) THEN -- Только прототипы справочников
     
        DELETE FROM ONLY gar_tmp.xxx_adr_area_type;   -- Временная таблица для "С_Типы гео-региона (!)"
        DELETE FROM ONLY gar_tmp.xxx_adr_street_type; -- Временная таблица для "C_Типы улицы (!)"
        DELETE FROM ONLY gar_tmp.xxx_adr_house_type;  -- Временная таблица для "С_Типы номера (!)"
       
     END IF;
     --
    END;
  $$;

ALTER PROCEDURE gar_tmp_pcg_trans.p_clear_tbl(integer[]) OWNER TO postgres;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_clear_tbl(integer[]) IS 'Очистка временных таблиц';
--
--  USE CASE:
--             CALL gar_tmp_pcg_trans.p_clear_tbl ();
--       begin;
-- 			 CALL gar_tmp_pcg_trans.p_clear_tbl (ARRAY[0, 1, 2, 3]);
--       rollback;
-- -------------------------------------------------- unsi_test_89
-- SELECT count(1) AS xxx_adr_area_type   FROM gar_tmp.xxx_adr_area_type;    -- 166
-- SELECT count(1) AS xxx_adr_street_type FROM gar_tmp.xxx_adr_street_type;  -- 115
-- SELECT count(1) AS xxx_adr_house_type  FROM gar_tmp.xxx_adr_house_type;   --  10
-- --
-- SELECT count(1) AS qty_xxx_adr_area         FROM gar_tmp.xxx_adr_area;         -- 3007
-- SELECT count(1) AS qty_xxx_adr_house        FROM gar_tmp.xxx_adr_house;	       -- 46101
-- SELECT count(1) AS qty_xxx_obj_fias         FROM gar_tmp.xxx_obj_fias;         -- 49104   
-- SELECT count(1) AS qty_xxx_type_param_value FROM gar_tmp.xxx_type_param_value; -- 310443
-- --
-- SELECT count(1) AS qty_adr_area    FROM gar_tmp.adr_area;      -- 999
-- SELECT count(1) AS qty_adr_house   FROM gar_tmp.adr_house;     -- 51600
-- SELECT count(1) AS qty_adr_objects FROM gar_tmp.adr_objects; 
-- SELECT count(1) AS qty_adr_street  FROM gar_tmp.adr_street;    -- 2246
--     --
-- SELECT count(1) AS qty_adr_area_hist    FROM gar_tmp.adr_area_hist;   -- 973
-- SELECT count(1) AS qty_adr_house_hist   FROM gar_tmp.adr_house_hist;  -- 2019
-- SELECT count(1) AS qty_adr_objects_hist FROM gar_tmp.adr_objects_hist;
-- SELECT count(1) AS qty_adr_street_hist  FROM gar_tmp.adr_street_hist; -- 365
