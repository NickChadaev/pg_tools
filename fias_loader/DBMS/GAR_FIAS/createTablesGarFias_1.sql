/*================================================================================*/
/* DBMS name:      PostgreSQL 13.11                                               */
/* Created on:     31.10.2023 17:46:57                                            */
/*================================================================================*/

SET search_path=gar_fias,public;
/*==============================================================*/
/* Table: TWIN_ADDR_OBJECTS                                     */
/*==============================================================*/
DROP TABLE IF EXISTS gar_fias.twin_addr_objects;
CREATE TABLE  gar_fias.twin_addr_objects (

      fias_guid_new uuid   NOT NULL
     ,fias_guid_old uuid   NOT NULL
     ,obj_level     bigint NOT NULL
     ,date_create   date   NOT NULL DEFAULT current_date
);

ALTER TABLE gar_fias.twin_addr_objects ADD CONSTRAINT pk_twin_adr_objects
       PRIMARY KEY (fias_guid_new, fias_guid_old);

COMMENT ON TABLE gar_fias.twin_addr_objects IS 'Пары guids описывающие один адресный объект';

COMMENT ON COLUMN gar_fias.twin_addr_objects.fias_guid_new  IS 'Актуальный GUID';
COMMENT ON COLUMN gar_fias.twin_addr_objects.fias_guid_old  IS 'Предшествующий GUID';
COMMENT ON COLUMN gar_fias.twin_addr_objects.obj_level      IS 'Уровень адресного объекта (Классификация ГАР)';
COMMENT ON COLUMN gar_fias.twin_addr_objects.date_create    IS 'Дата создания записи.';

DROP INDEX IF EXISTS gar_fias.ie1_twin_addr_objects;
CREATE INDEX ie1_twin_addr_objects ON gar_fias.twin_addr_objects (fias_guid_old);
