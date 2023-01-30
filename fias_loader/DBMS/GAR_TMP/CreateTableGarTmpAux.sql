/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     18.10.2022 13:44:01                          */
/* ------------------------------------------------------------ */
/* Локальные вспомогательные таблицы.                           */
/*==============================================================*/

SET search_path=gar_tmp;

/*==============================================================*/
/* Table: gar_tmp.adr_area_aux                                  */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.adr_area_aux CASCADE;
CREATE TABLE IF NOT EXISTS gar_tmp.adr_area_aux (
    id_area   bigint   NOT NULL
   ,op_sign   char(1)  NOT NULL CHECK ( op_sign IN ('I','U'))   
);
COMMENT ON TABLE gar_tmp.adr_area_aux IS
'С_Гео-регионы (!), вспомогательная таблица';

ALTER TABLE gar_tmp.adr_area_aux
   ADD CONSTRAINT pk_adr_area_aux PRIMARY KEY (id_area);
/*==============================================================*/
/* Table: gar_tmp.adr_house_aux                                 */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.adr_house_aux CASCADE;
CREATE TABLE IF NOT EXISTS gar_tmp.adr_house_aux (
    id_house  bigint   NOT NULL
   ,op_sign   char(1)  NOT NULL CHECK ( op_sign IN ('I','U'))   
);

COMMENT ON TABLE gar_tmp.adr_house_aux IS
'С_Адреса (!), вспомогательная таблица';

ALTER TABLE gar_tmp.adr_house_aux
   ADD CONSTRAINT pk_adr_house_aux PRIMARY KEY (id_house);
   
/*==============================================================*/
/* Table: gar_tmp.adr_street_aux                                */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.adr_street_aux CASCADE;
create table if not exists gar_tmp.adr_street_aux (
    id_street  bigint   NOT NULL
   ,op_sign   char(1)  NOT NULL CHECK ( op_sign IN ('I','U'))   
);

COMMENT ON TABLE gar_tmp.adr_street_aux IS 'С_Улицы (!), вспомогательная таблица';

ALTER TABLE gar_tmp.adr_street_aux
   ADD CONSTRAINT pk_tmp_adr_street_aux PRIMARY KEY (id_street);
   
