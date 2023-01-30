DROP FUNCTION IF EXISTS export_version.f_version_by_obj_put (date, text, text, integer, integer, text);
CREATE OR REPLACE FUNCTION export_version.f_version_by_obj_put (
                 p_dt_gar_version  date     -- Версия по GAR-FIAS
                ,p_sch_name        text     -- Схема
                ,p_nm_object       text     -- Имя таблицы
                ,p_qty_main        integer  -- Общее количество записей
                ,p_qty_aux         integer  -- Количество обновлённых записей.     
                ,p_file_path       text     -- Файл, с выгруженными обновлениями         
) 
  RETURNS bigint
  
  LANGUAGE plpgsql SECURITY DEFINER
  
  AS $$
  -- =====================================================================
  --    Author: Nick                                       
  --    Create date: 2022-12-09
  -- ---------------------------------------------------------------------  
  -- =====================================================================
  DECLARE
     _id_un_export_by_obj  bigint;
     _id_un_export         bigint;
  
  BEGIN
    SELECT id_un_export INTO _id_un_export FROM export_version.un_export 
                           WHERE (dt_gar_version = p_dt_gar_version);
    IF (NOT found)
      THEN
          _id_un_export_by_obj := NULL;
      ELSE
      
        INSERT INTO export_version.un_export_by_obj AS v
        (        id_un_export
                ,sch_name   
                ,nm_object
                ,qty_main
                ,qty_aux
                ,file_path
         )
             VALUES (_id_un_export
                    ,p_sch_name
                    ,p_nm_object
                    ,p_qty_main   
                    ,p_qty_aux    
                    ,p_file_path
             )                                
            ON CONFLICT (id_un_export, nm_object) 
            DO 
                 UPDATE SET  sch_name  = excluded.sch_name
                            ,qty_main  = excluded.qty_main 
                            ,qty_aux   = excluded.qty_aux  
                            ,file_path = excluded.file_path
                            
                   WHERE (v.id_un_export = excluded.id_un_export) AND
                         (v.nm_object = excluded.nm_object)
             
        RETURNING v.id_un_export_by_obj INTO _id_un_export_by_obj;   
    END IF;  
      
    RETURN _id_un_export_by_obj;
  END;
$$;

ALTER FUNCTION export_version.f_version_by_obj_put (date, text, text, integer, integer, text) OWNER TO postgres;

COMMENT ON FUNCTION export_version.f_version_by_obj_put (date, text, text, integer, integer, text) IS 'Сохранение Версии ГАР ФИАС';
--
--  USE CASE:
--
-- SELECT export_version.f_version_by_obj_put (

--         p_dt_gar_version := '2022-11-21'::date     -- Версия по GAR-FIAS
--        ,p_sch_name     := 'gar_tmp'::text     -- Схема
--        ,p_nm_object      := 'adr_area'::text     -- Имя таблицы
--        ,p_qty_main       := 389::integer  -- Общее количество записей
--        ,p_qty_aux        := 11::integer  -- Количество обновлённых записей.     
--        ,p_file_path      := NULL::text     -- Файл, с выгруженными обновлениями         

-- );
--
-- SELECT export_version.f_version_by_obj_put (

--         p_dt_gar_version := '2022-11-21'::date     -- Версия по GAR-FIAS
--        ,p_sch_name     := 'unnsi'::text     -- Схема
--        ,p_nm_object      := 'adr_street'::text     -- Имя таблицы
--        ,p_qty_main       := 910::integer  -- Общее количество записей
--        ,p_qty_aux        := 391::integer  -- Количество обновлённых записей.     
--        ,p_file_path      := NULL::text     -- Файл, с выгруженными обновлениями         

-- );
-- --
-- SELECT export_version.f_version_by_obj_put (

--         p_dt_gar_version := '2022-11-21'::date     -- Версия по GAR-FIAS
--        ,p_sch_name     := 'unnsi'::text     -- Схема
--        ,p_nm_object      := 'adr_house'::text     -- Имя таблицы
--        ,p_qty_main       := 2190::integer  -- Общее количество записей
--        ,p_qty_aux        := 470::integer  -- Количество обновлённых записей.     
--        ,p_file_path      := NULL::text     -- Файл, с выгруженными обновлениями         

-- );
