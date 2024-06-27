/*==============================================================*/
/*   2022-12-09      Версионирование выгрузки.                  */
/*     DBMS name:      PostgreSQL 13                            */
/*==============================================================*/

SET search_path=export_version;

/*==============================================================*/
/* Table: un_export    ЦЕЛЕВОЙ СЕРВЕР !!!!!                     */
/*==============================================================*/
DROP TABLE IF EXISTS export_version.un_export CASCADE;
CREATE SEQUENCE IF NOT EXISTS export_version.un_export_id_seq INCREMENT 1 START 1;   

CREATE TABLE IF NOT EXISTS export_version.un_export (
    id_un_export    bigint       NOT NULL DEFAULT nextval('export_version.un_export_id_seq'::regclass)
   ,dt_gar_version  date         NOT NULL 
   ,kd_export_type  bool         NOT NULL DEFAULT TRUE 
   ,id_region       bigint       NOT NULL
   ,dt_export       timestamp    NOT NULL DEFAULT now() 
   ,nm_user         text         NOT NULL DEFAULT session_user 
   ,seq_value       bigint       NOT NULL 
   ,node_id         numeric(3,0) NOT NULL
);
ALTER TABLE export_version.un_export
   ADD CONSTRAINT pk_un_export PRIMARY KEY (id_un_export);

ALTER TABLE export_version.un_export
   ADD CONSTRAINT ak1_un_export UNIQUE (dt_gar_version);

COMMENT ON TABLE export_version.un_export IS 'Экспорт в адресную базу ЕС НСИ';

COMMENT ON COLUMN export_version.un_export.id_un_export   IS 'ID процесса экспорта в адресную базу ЕС НСИ';
COMMENT ON COLUMN export_version.un_export.dt_gar_version IS 'Дата версии ГАР ФИАС (Официальная дата версии ГАР ФИАС с сайта https://fias.nalog.ru.)';
COMMENT ON COLUMN export_version.un_export.kd_export_type IS 'Тип экспорта: TRUE: с использованием FDW, FALSE: текстовый файл.';
COMMENT ON COLUMN export_version.un_export.id_region      IS 'ID адресного региона (ЕС НСИ)';
COMMENT ON COLUMN export_version.un_export.dt_export      IS 'Дата экспорта.';
COMMENT ON COLUMN export_version.un_export.nm_user        IS 'Пользователь, запустившего процесс «Экспорта в адресную базу ЕС НСИ».';
COMMENT ON COLUMN export_version.un_export.seq_value      IS 'Последнее значение региональной последовательности';
COMMENT ON COLUMN export_version.un_export.node_id        IS 'Номер внешнего сервера';

/*==============================================================*/
/* Table: export_version.un_export_by_obj                       */
/*==============================================================*/
DROP TABLE IF EXISTS export_version.un_export_by_obj CASCADE;
CREATE SEQUENCE IF NOT EXISTS export_version.un_export_by_obj_id_seq INCREMENT 1 START 1;  

CREATE TABLE IF NOT EXISTS export_version.un_export_by_obj (
   id_un_export_by_obj  bigint  NOT NULL DEFAULT nextval('export_version.un_export_by_obj_id_seq'::regclass)
  ,id_un_export  bigint  NOT NULL 
  ,sch_name      text    NOT NULL 
  ,nm_object     text    NOT NULL 
  ,qty_main      integer NOT NULL DEFAULT 0
  ,qty_aux       integer NOT NULL DEFAULT 0
  ,file_path     text 
);

ALTER TABLE export_version.un_export_by_obj
   ADD CONSTRAINT pk_un_export_by_obj PRIMARY KEY (id_un_export_by_obj);

ALTER TABLE export_version.un_export_by_obj
   ADD CONSTRAINT ak1_un_export_by_obj UNIQUE (id_un_export, nm_object);   

ALTER TABLE export_version.un_export_by_obj 
   ADD CONSTRAINT chk_un_export_by_obj_nm_object 
                       CHECK ( nm_object = 'adr_area'   -- адресные пространства
                            OR nm_object = 'adr_street' -- улицы
                            OR nm_object = 'adr_house'  -- Дома
);    
      
COMMENT ON TABLE export_version.un_export_by_obj IS 'Детали экспорта в ЕС НСИ, по типам адресных объектов';

COMMENT ON COLUMN export_version.un_export_by_obj.id_un_export_by_obj IS 'ID процесса экспорта объекта в адресную базу ЕС НСИ';
COMMENT ON COLUMN export_version.un_export_by_obj.id_un_export        IS 'ID процесса экспорта в адресную базу ЕС НСИ';
COMMENT ON COLUMN export_version.un_export_by_obj.sch_name   IS 'Имя схемы-источника данных';
COMMENT ON COLUMN export_version.un_export_by_obj.nm_object  IS 'Наименование объекта: adr_area, adr_street, adr_house';
COMMENT ON COLUMN export_version.un_export_by_obj.qty_main   IS 'Общее количестов записей в таблице';
COMMENT ON COLUMN export_version.un_export_by_obj.qty_aux    IS 'Количество изменений/дополнений в таблице';
COMMENT ON COLUMN export_version.un_export_by_obj.file_path  IS 'Файл с данными (экспортв файловую систему)';
--
ALTER TABLE export_version.un_export_by_obj
   ADD CONSTRAINT fk_un_export_by_obj__id_un_export__un_export 
       FOREIGN KEY (id_un_export)
               REFERENCES export_version.un_export (id_un_export)
                            ON DELETE CASCADE ON UPDATE CASCADE;
--
ALTER TABLE export_version.un_export
   ADD CONSTRAINT fk_un_export__dt_gar_version__garfias_version 
       FOREIGN KEY (dt_gar_version)
               REFERENCES gar_version.garfias_version (nm_garfias_version)
                            ON DELETE CASCADE ON UPDATE CASCADE;
--
ALTER TABLE export_version.un_export
   ADD CONSTRAINT fk_un_export__node_id__foreign_servers 
       FOREIGN KEY (node_id)
               REFERENCES gar_link.foreign_servers (node_id)
                            ON DELETE CASCADE ON UPDATE CASCADE;
