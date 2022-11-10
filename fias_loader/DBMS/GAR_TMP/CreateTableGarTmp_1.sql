/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     10.11.2022 16:15:17                          */
/*==============================================================*/

/*==============================================================*/
/* Table: Table: gar_tmp.adr_area_type                          */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.adr_area_type CASCADE;
CREATE TABLE gar_tmp.adr_area_type
(
     id_area_type       integer     NOT NULL
    ,nm_area_type       varchar(50) NOT NULL
    ,nm_area_type_short varchar(10) NOT NULL
    ,pr_lead smallint               NOT NULL 
    ,dt_data_del timestamp without time zone 
);

COMMENT ON TABLE gar_tmp.adr_area_type
    IS 'С_Типы гео-региона (!)';

COMMENT ON COLUMN gar_tmp.adr_area_type.id_area_type
    IS 'ИД типа гео-региона';

COMMENT ON COLUMN gar_tmp.adr_area_type.nm_area_type
    IS 'Наименование типа гео-региона';

COMMENT ON COLUMN gar_tmp.adr_area_type.nm_area_type_short
    IS 'Короткое наименование типа гео-региона';

COMMENT ON COLUMN gar_tmp.adr_area_type.pr_lead
    IS 'Признак очередности типа гео-региона';

COMMENT ON COLUMN gar_tmp.adr_area_type.dt_data_del
    IS 'Дата удаления';

ALTER TABLE gar_tmp.adr_area_type 
      ADD CONSTRAINT adr_area_type_pkey PRIMARY KEY (id_area_type);
             
ALTER TABLE gar_tmp.adr_area_type 
      ADD CONSTRAINT adr_area_type_nm_area_type_key UNIQUE (nm_area_type);    
    
/*==============================================================*/
/* Table: gar_tmp.adr_street_type                               */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.adr_street_type CASCADE;
CREATE TABLE gar_tmp.adr_street_type
(
     id_street_type       integer      NOT NULL 
    ,nm_street_type       varchar(50)  NOT NULL 
    ,nm_street_type_short varchar(10)  NOT NULL 
    ,dt_data_del timestamp without time zone 
);

COMMENT ON TABLE gar_tmp.adr_street_type
    IS 'С_Типы улицы (!)';

COMMENT ON COLUMN gar_tmp.adr_street_type.id_street_type
    IS 'ИД типа улицы';

COMMENT ON COLUMN gar_tmp.adr_street_type.nm_street_type
    IS 'Наименование типа улицы';

COMMENT ON COLUMN gar_tmp.adr_street_type.nm_street_type_short
    IS 'Короткое наименование типа улицы';

COMMENT ON COLUMN gar_tmp.adr_street_type.dt_data_del
    IS 'Дата удаления';
    
ALTER TABLE gar_tmp.adr_street_type 
      ADD CONSTRAINT adr_street_type_pkey PRIMARY KEY (id_street_type);
      
ALTER TABLE gar_tmp.adr_street_type 
      ADD CONSTRAINT adr_street_type_nm_street_type_key UNIQUE (nm_street_type);
    
/*==============================================================*/
/* Table: gar_tmp.adr_house_type                                */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.adr_house_type CASCADE;
CREATE TABLE gar_tmp.adr_house_type
(
     id_house_type integer            NOT NULL 
    ,nm_house_type varchar(50)        NOT NULL 
    ,nm_house_type_short varchar(10)  NOT NULL 
    ,kd_house_type_lvl integer        NOT NULL  
    ,dt_data_del timestamp without time zone 
);

COMMENT ON TABLE gar_tmp.adr_house_type
    IS 'С_Типы номера (!)';

COMMENT ON COLUMN gar_tmp.adr_house_type.id_house_type
    IS 'ИД типа номера';

COMMENT ON COLUMN gar_tmp.adr_house_type.nm_house_type
    IS 'Наименование типа номера';

COMMENT ON COLUMN gar_tmp.adr_house_type.nm_house_type_short
    IS 'Короткое название типа номера';

COMMENT ON COLUMN gar_tmp.adr_house_type.kd_house_type_lvl
    IS 'Уровень типа номера';

COMMENT ON COLUMN gar_tmp.adr_house_type.dt_data_del
    IS 'Дата удаления';

ALTER TABLE gar_tmp.adr_house_type 
           ADD CONSTRAINT adr_house_type_pkey  PRIMARY KEY (id_house_type);
ALTER TABLE gar_tmp.adr_house_type 
           ADD CONSTRAINT adr_house_type_nm_house_type_key UNIQUE (nm_house_type);
           
