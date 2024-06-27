DROP FUNCTION IF EXISTS gar_fias_pcg_load.del_gar_addr_obj (bigint);
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.del_gar_all ();
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.del_gar_all ()
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ==============================================================================
    -- Author: Nick
    -- Create date: 2021-11-23
    -- ------------------------------------------------------------------------------  
    -- 'Очистка таблиц в схеме "gar_fias"'
    -- ==============================================================================
   
    BEGIN
    
     TRUNCATE TABLE gar_fias.as_add_house_type;	
     TRUNCATE TABLE gar_fias.as_addr_obj;	        -- Классификатор адресообразующих элементов
     TRUNCATE TABLE gar_fias.as_addr_obj_division;	-- Переподчинение адресных элементов
     TRUNCATE TABLE gar_fias.as_addr_obj_params;	-- Параметры адресообразующего элемента
     TRUNCATE TABLE gar_fias.as_addr_obj_type;     	-- Типы адресных объектов
     TRUNCATE TABLE gar_fias.as_adm_hierarchy;      -- Иерархия в административном делении
     TRUNCATE TABLE gar_fias.as_apartment_type;	    -- Типы помещений
     TRUNCATE TABLE gar_fias.as_apartments;	        -- Помещения
     TRUNCATE TABLE gar_fias.as_apartments_params;  -- Параметры помещения
     TRUNCATE TABLE gar_fias.as_carplaces;	        -- Сведения по машино-местам
     TRUNCATE TABLE gar_fias.as_carplaces_params;	-- Параметры машиноместа
     TRUNCATE TABLE gar_fias.as_change_history;	    -- История изменений
     --
     TRUNCATE TABLE gar_fias.as_house_type;	     -- Признаки владения (Типы домов)
     TRUNCATE TABLE gar_fias.as_houses;	         -- Номерам домов
     TRUNCATE TABLE gar_fias.as_houses_params;   --
     TRUNCATE TABLE gar_fias.as_mun_hierarchy;   -- Иерархия в муниципальном делении
     TRUNCATE TABLE gar_fias.as_norm_docs_kinds; -- Вид документа
     TRUNCATE TABLE gar_fias.as_norm_docs_types; -- Тип нормативного документа
     TRUNCATE TABLE gar_fias.as_normative_docs;  -- Нормативные документы
     TRUNCATE TABLE gar_fias.as_object_level;	 -- Уровни адресных объектов
     TRUNCATE TABLE gar_fias.as_operation_type;  -- Статусы действия
     TRUNCATE TABLE gar_fias.as_param_type;	     -- Типы параметров
     TRUNCATE TABLE gar_fias.as_reestr_objects;  -- Сведения об элементе реестра
     TRUNCATE TABLE gar_fias.as_room_type;       -- Типы комнат
     TRUNCATE TABLE gar_fias.as_rooms;	         -- Комнаты
     TRUNCATE TABLE gar_fias.as_rooms_params;	 -- Параметры комнаты
     TRUNCATE TABLE gar_fias.as_steads;          -- Земельные участки
     TRUNCATE TABLE gar_fias.as_steads_params;	 -- Параметры земельных участков 
 
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.del_gar_all () OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.del_gar_all () IS 'Очистка таблиц в схеме "gar_fias"';
--
--  USE CASE:
--      SELECT * FROM gar_fias.as_addr_obj;
--      CALL gar_fias_pcg_load.del_gar_all ();
