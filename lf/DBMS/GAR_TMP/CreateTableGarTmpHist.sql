/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     09.02.2022 12:27:53                          */
/* ------------------------------------------------------------ */
/* Локальные исторические таблицы.                              */
/*==============================================================*/

SET search_path=gar_tmp;

/*==============================================================*/
/* Table: gar_tmp.adr_area_hist                                 */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.adr_area_hist CASCADE;
create table if not exists gar_tmp.adr_area_hist (
   id_area_hist    bigserial   not null,
   date_create     timestamp  not null DEFAULT now(),
   f_server_name   text,
   id_region       bigint
) INHERITS (gar_tmp.adr_area);

COMMENT ON TABLE gar_tmp.adr_area_hist IS
'С_Гео-регионы (!), история';

ALTER TABLE gar_tmp.adr_area_hist
   ADD CONSTRAINT pk_adr_area_hist PRIMARY KEY (id_area_hist);
--
-- ALTER TABLE gar_tmp.adr_area_hist ADD COLUMN  id_region  bigint;
/*==============================================================*/
/* Table: gar_tmp.adr_house_hist                                */
/*==============================================================*/
drop table if exists gar_tmp.adr_house_hist CASCADE;
create table if not exists gar_tmp.adr_house_hist (
   id_house_hist   bigserial   not null,
   date_create     timestamp  not null DEFAULT now(),
   f_server_name   text,
   id_region       bigint
) INHERITS (gar_tmp.adr_house);

COMMENT ON TABLE gar_tmp.adr_house_hist IS
'С_Адреса (!), история';

ALTER TABLE gar_tmp.adr_house_hist
   ADD CONSTRAINT pk_adr_house_hist PRIMARY KEY (id_house_hist);
   
-- ALTER TABLE gar_tmp.adr_house_hist ADD COLUMN  id_region  bigint;
/*==============================================================*/
/* Table: gar_tmp.adr_objects_hist                              */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.adr_objects_hist CASCADE;
create table if not exists gar_tmp.adr_objects_hist (
   id_object_hist   bigserial   not null,
   date_create      timestamp  not null DEFAULT now(),
   f_server_name    text,
   id_region        bigint
) INHERITS (gar_tmp.adr_objects);

COMMENT ON TABLE gar_tmp.adr_objects_hist IS
'С_Отдельные сооружения и территории (!), история';

alter table gar_tmp.adr_objects_hist
   add constraint pk_tmp_adr_objects_hist primary key (id_object_hist);
   
-- ALTER TABLE gar_tmp.adr_objects_hist ADD COLUMN  id_region  bigint;
/*==============================================================*/
/* Table: gar_tmp.adr_street_hist                                    */
/*==============================================================*/
drop table IF EXISTS gar_tmp.adr_street_hist CASCADE;
create table if not exists gar_tmp.adr_street_hist (
   id_street_hist   bigserial   not null,
   date_create      timestamp  not null DEFAULT now(),
   f_server_name    text,
   id_region        bigint
) INHERITS (gar_tmp.adr_street);

COMMENT ON TABLE gar_tmp.adr_street_hist IS 'С_Улицы (!), история';

alter table gar_tmp.adr_street_hist
   add constraint pk_tmp_adr_street_hist primary key (id_street_hist);
   
-- ALTER TABLE gar_tmp.adr_street_hist ADD COLUMN  id_region  bigint;   
-- ---------------------------------------------------------
/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     09.02.2022 12:27:53                          */
/* ------------------------------------------------------------ */
/*     Индексы для локальных исторических таблиц.               */
/*==============================================================*/

SET search_path=gar_tmp;

/*==============================================================*/
/* Table: gar_tmp.adr_area_hist                                 */
/*==============================================================*/
CREATE INDEX IF NOT EXISTS ie1_adr_area_hist ON gar_tmp.adr_area_hist USING btree (date_create);
CREATE INDEX IF NOT EXISTS ie2_adr_area_hist ON gar_tmp.adr_area_hist USING btree (f_server_name);
CREATE INDEX IF NOT EXISTS ie3_adr_area_hist ON gar_tmp.adr_area_hist USING btree (id_region);

/*==============================================================*/
/* Table: gar_tmp.adr_house_hist                                */
/*==============================================================*/
CREATE INDEX IF NOT EXISTS ie1_adr_house_hist ON gar_tmp.adr_house_hist USING btree (date_create);
CREATE INDEX IF NOT EXISTS ie2_adr_house_hist ON gar_tmp.adr_house_hist USING btree (f_server_name);
CREATE INDEX IF NOT EXISTS ie3_adr_house_hist ON gar_tmp.adr_house_hist USING btree (id_region);

/*==============================================================*/
/* Table: gar_tmp.adr_objects_hist                              */
/*==============================================================*/
CREATE INDEX IF NOT EXISTS ie1_adr_objects_hist ON gar_tmp.adr_objects_hist USING btree (date_create);
CREATE INDEX IF NOT EXISTS ie2_adr_objects_hist ON gar_tmp.adr_objects_hist USING btree (f_server_name);
CREATE INDEX IF NOT EXISTS ie3_adr_objects_hist ON gar_tmp.adr_objects_hist USING btree (id_region);

/*==============================================================*/
/* Table: gar_tmp.adr_street_hist                               */
/*==============================================================*/
CREATE INDEX IF NOT EXISTS ie1_adr_street_hist ON gar_tmp.adr_street_hist USING btree (date_create);
CREATE INDEX IF NOT EXISTS ie2_adr_street_hist ON gar_tmp.adr_street_hist USING btree (f_server_name);
CREATE INDEX IF NOT EXISTS ie3_adr_street_hist ON gar_tmp.adr_street_hist USING btree (id_region);
-- ---------------------------------------------------------
-- SELECT * FROM  gar_tmp.adr_street_hist WHERE (id_region = 27);

--
-- 2022-08-12  Отмена наследования.
--
ALTER TABLE gar_tmp.adr_area_hist NO INHERIT gar_tmp.adr_area;
ALTER TABLE gar_tmp.adr_house_hist NO INHERIT gar_tmp.adr_house;
ALTER TABLE gar_tmp.adr_objects_hist NO INHERIT gar_tmp.adr_objects;
ALTER TABLE gar_tmp.adr_street_hist NO INHERIT gar_tmp.adr_street;
