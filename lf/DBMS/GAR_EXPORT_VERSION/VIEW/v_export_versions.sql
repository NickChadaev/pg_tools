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
