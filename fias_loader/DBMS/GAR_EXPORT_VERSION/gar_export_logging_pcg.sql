
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW export_version.version
 AS
 SELECT '$Revision:6d19d8d$ modified $RevDate:2023-04-05$'::text AS version; 

-- SELECT * FROM export_version.version;   

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS export_version.f_version_put (date, boolean, bigint, text, numeric(3,0));
CREATE OR REPLACE FUNCTION export_version.f_version_put (
            p_dt_gar_version  date
          , p_kd_export_type  boolean
          , p_id_region       bigint
          , p_seq_name        text
          , p_node_id         numeric (3,0)

) 
  RETURNS bigint
  
    LANGUAGE plpgsql SECURITY DEFINER
    
    AS $$
    -- ========================================================================
    -- Author: Nick
    -- Create date: 2022-12-09
    -- ------------------------------------------------------------------------
    --  2023-04-05 Обновление, добавлены: "dt_export", "nm_user"
    -- ========================================================================
    DECLARE
       _id_un_export bigint;
       _seq_value    bigint;
       
       _get_seq_value text = $_$
              SELECT last_value FROM %s;
       $_$;
    
    BEGIN
        EXECUTE format(_get_seq_value, p_seq_name) INTO _seq_value;
    
        INSERT INTO export_version.un_export ( dt_gar_version
                                              ,kd_export_type
                                              ,id_region
                                              ,seq_value      
                                              ,node_id                                                     
         )
         VALUES ( p_dt_gar_version
                 ,p_kd_export_type
                 ,p_id_region  
                 ,_seq_value
                 ,p_node_id
         )    
          ON CONFLICT (dt_gar_version) DO UPDATE
                 SET 
                      kd_export_type = excluded.kd_export_type  
                     ,id_region      = excluded.id_region  
                     ,seq_value      = excluded.seq_value
                     ,node_id        = excluded.node_id 
                     ,dt_export      = now()
                     ,nm_user        = SESSION_USER
                 WHERE (export_version.un_export.dt_gar_version = excluded.dt_gar_version)
             
        RETURNING id_un_export INTO _id_un_export;   
        
      RETURN _id_un_export;
    END;
  $$;

ALTER FUNCTION export_version.f_version_put (date, boolean, bigint, text,numeric(3,0)) OWNER TO postgres;

COMMENT ON FUNCTION export_version.f_version_put (date, boolean, bigint, text,numeric(3,0))
IS 'Сохранение Версии Обработанных Адресных Данных';
-- ------------------------------------------------------------------------------------------------------
--  USE CASE:
--
--  SELECT export_version.f_version_put (
--                    p_dt_gar_version := '2022-11-21'::date
--                   ,p_kd_export_type := True 
--                   ,p_id_region      := 77
--                   ,p_seq_name       := 'gar_tmp.obj_seq'
--                   ,p_node_id        := 11
--  );                 
-- --
-- SELECT * FROM export_version.un_export;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP VIEW IF EXISTS export_version.v_export_versions;
CREATE OR REPLACE VIEW export_version.v_export_versions AS

     SELECT  
           e.id_un_export    
          ,e.dt_gar_version  
          ,e.kd_export_type  
          ,e.id_region   
          ,a.nm_area_full
          ,e.dt_export       
          ,e.nm_user         
          ,e.seq_value       
          ,e.node_id
           --
          ,d.id_un_export_by_obj  
          ,d.sch_name             
          ,d.nm_object            
          ,d.qty_main             
          ,d.qty_aux              
          ,d.file_path      
           --
          ,f.fserver_name 
          ,f.host         
          ,f.dbname       
          ,f.port         
          ,f.db_conn_name 
    
     FROM export_version.un_export e   
      
        INNER JOIN export_version.un_export_by_obj d ON (e.id_un_export = d.id_un_export)
        INNER JOIN gar_link.foreign_servers f  ON (f.node_id = e.node_id)
        INNER JOIN gar_tmp.adr_area a ON (a.id_area = e.id_region) 
    
     WHERE (f.active_sign );

COMMENT ON VIEW export_version.v_export_versions IS 'Список выполненных выгрузок';

COMMENT ON COLUMN export_version.v_export_versions.id_un_export    IS 'ID выгрузки';   
COMMENT ON COLUMN export_version.v_export_versions.dt_gar_version  IS 'Версия данных ГАР-ФИАС от';
COMMENT ON COLUMN export_version.v_export_versions.kd_export_type  IS 'Тип экспорта: FDW / Выгрузка в файл';
COMMENT ON COLUMN export_version.v_export_versions.id_region       IS 'ID региона ЕС НСИ';
COMMENT ON COLUMN export_version.v_export_versions.nm_area_full    IS 'Полное наименование региона ЕС НСИ';
COMMENT ON COLUMN export_version.v_export_versions.dt_export       IS 'Дата выгрузки';
COMMENT ON COLUMN export_version.v_export_versions.nm_user         IS 'Пользователь';
COMMENT ON COLUMN export_version.v_export_versions.seq_value       IS 'Последнее значение региональной последовательности';
COMMENT ON COLUMN export_version.v_export_versions.node_id         IS 'ID стороннего сервера';
           --
COMMENT ON COLUMN export_version.v_export_versions.id_un_export_by_obj IS 'ID делати выгрузки';  
COMMENT ON COLUMN export_version.v_export_versions.sch_name            IS 'Имя схемы-источника'; 
COMMENT ON COLUMN export_version.v_export_versions.nm_object           IS 'Имя таблицы'; 
COMMENT ON COLUMN export_version.v_export_versions.qty_main            IS 'Общее количество региональных данных'; 
COMMENT ON COLUMN export_version.v_export_versions.qty_aux             IS 'Количество изменённых региональных данных'; 
COMMENT ON COLUMN export_version.v_export_versions.file_path           IS 'Файл с данными';
           --
COMMENT ON COLUMN export_version.v_export_versions.fserver_name IS 'Имя стороннего сервера';
COMMENT ON COLUMN export_version.v_export_versions.host         IS 'IP хоста';
COMMENT ON COLUMN export_version.v_export_versions.dbname       IS 'Имя базы';
COMMENT ON COLUMN export_version.v_export_versions.port         IS 'Порт';
COMMENT ON COLUMN export_version.v_export_versions.db_conn_name IS 'Имя соединения';
--- USE CASE:

-- SELECT * FROM export_version.v_export_versions;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
