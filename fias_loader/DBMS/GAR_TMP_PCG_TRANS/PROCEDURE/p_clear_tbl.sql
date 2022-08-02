DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_clear_tbl (boolean);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_clear_tbl (
        p_all  boolean = FALSE
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-13/2021-11-25/2022-03-15
    -- ----------------------------------------------------------------------------------------------------  
    -- Очистка временных (буфферных таблиц). false - очищаются только таблицы-результаты
    --        true - все таблицы.
    -- 2022-03-15 -- История сохраняется всегда.
    -- ====================================================================================================
   
    BEGIN
    
      IF p_all THEN
      
	    TRUNCATE TABLE gar_tmp.xxx_adr_area_type;   -- Временная таблица для "С_Типы гео-региона (!)"
        TRUNCATE TABLE gar_tmp.xxx_adr_street_type; -- Временная таблица для "C_Типы улицы (!)"
        TRUNCATE TABLE gar_tmp.xxx_adr_house_type;  -- Временная таблица для "С_Типы номера (!)"
    
      END IF;
      -- 
	  TRUNCATE TABLE gar_tmp.xxx_adr_area;         -- Временная таблица. заполняется данными из "AS_ADDR_OBJ", "AS_REESTR_OBJECTS", "AS_ADM_HIERARCHY", "AS_MUN_HIERARCHY", "AS_OBJECT_LEVEL", "AS_STEADS_PARAMS"
	  TRUNCATE TABLE gar_tmp.xxx_adr_house;	       -- Адреса домов 
	  TRUNCATE TABLE gar_tmp.xxx_obj_fias;         -- Дополнительная связь адресных объектов с ГАР-ФИАС
      TRUNCATE TABLE gar_tmp.xxx_type_param_value; -- Для каждого объекта хранятся агрегированные пары "Тип" - "Значение"
      --
      DELETE FROM ONLY gar_tmp.adr_area;     -- 2022-03-10 Сохраняются данные в таблицах-наследниках.
      DELETE FROM ONLY gar_tmp.adr_house; 
	  DELETE FROM ONLY gar_tmp.adr_objects;
	  DELETE FROM ONLY gar_tmp.adr_street;    
	  
    END;
  $$;

ALTER PROCEDURE gar_tmp_pcg_trans.p_clear_tbl (boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_clear_tbl (boolean) IS 'Очистка временных (буфферных) таблиц';
--
--  USE CASE:
--             CALL gar_tmp_pcg_trans.p_clear_tbl (FALSE); --  
--             CALL gar_tmp_pcg_trans.p_clear_tbl ();
