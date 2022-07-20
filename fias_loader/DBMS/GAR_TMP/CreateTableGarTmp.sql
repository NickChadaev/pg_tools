/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     15.10.2021 12:21:52                          */
/* ------------------------------------------------------------ */
/*       2021-11-24  Убираю из "xxx_" - таблиц:                 */
/*              ,kd_oktmo         varchar(11)                   */
/*              ,nm_zipcode       text                          */
/*==============================================================*/

SET search_path=gar_tmp;

DROP SEQUENCE IF EXISTS gar_tmp.obj_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS gar_tmp.obj_seq START 1;

DROP SEQUENCE IF EXISTS gar_tmp.obj_hist_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS gar_tmp.obj_hist_seq START 1;

-- DROP TABLE IF EXISTS gar_tmp.xxx_gar_tmp.adr_area_fias CASCADE;
DROP TABLE IF EXISTS gar_tmp.xxx_obj_fias CASCADE;
/*==============================================================*/
/* Table: gar_tmp.xxx_obj_fias                                  */
/*==============================================================*/

CREATE TABLE gar_tmp.xxx_obj_fias
(
     id_obj          bigint                     
    ,id_obj_fias     bigint
    ,obj_guid        uuid      NOT NULL
    ,type_object     integer   NOT NULL 
    ,tree_d          bigint[]  NOT NULL
    ,level_d         integer   NOT NULL
);

ALTER TABLE gar_tmp.xxx_obj_fias ADD CONSTRAINT pk_xxx_obj_fias PRIMARY KEY (obj_guid); 

COMMENT ON TABLE gar_tmp.xxx_obj_fias
    IS 'Дополнительная связь адресных объектов с ГАР-ФИАС';

COMMENT ON COLUMN gar_tmp.xxx_obj_fias.id_obj
    IS 'Глобальный уникальный идентификатор адресного объекта (ID ОБЪЕКТА)';  
    
COMMENT ON COLUMN gar_tmp.xxx_obj_fias.id_obj_fias
    IS 'Глобальный уникальный идентификатор адресного объекта ГАР-ФИАС (ID ОБЪЕКТА)';     
    
COMMENT ON COLUMN gar_tmp.xxx_obj_fias.obj_guid
    IS 'Глобальный уникальный идентификатор адресного объекта (UUID ОБЪЕКТА)';

COMMENT ON COLUMN gar_tmp.xxx_obj_fias.type_object
    IS 'Тип объекта: 0 - георегион, 2 - улица, 3 - строение';

COMMENT ON COLUMN gar_tmp.xxx_obj_fias.tree_d
    IS 'Положение в иерархии объектов';

COMMENT ON COLUMN gar_tmp.xxx_obj_fias.level_d
    IS 'Уровень в иерархии объектов'; 
    
DROP TABLE IF EXISTS gar_tmp.xxx_adr_street_type CASCADE;
/*==============================================================*/
/* Table: gar_tmp.xxx_adr_street_type                           */
/*==============================================================*/

CREATE TABLE gar_tmp.xxx_adr_street_type
(
     fias_ids             bigint[] 
    ,id_street_type       integer 
    ,fias_type_name       varchar(250)
    ,nm_street_type       varchar(50) 
    ,fias_type_shortname  varchar(50) 
    ,nm_street_type_short varchar(10) 
    ,fias_row_key         text        
    ,is_twin              boolean
);

ALTER TABLE  gar_tmp.xxx_adr_street_type ADD CONSTRAINT pk_xxx_adr_street_type PRIMARY KEY (fias_row_key);

COMMENT ON TABLE gar_tmp.xxx_adr_street_type IS 'Временная таблица для "C_Типы улицы (!)"';

COMMENT ON COLUMN gar_tmp.xxx_adr_street_type.fias_ids             IS 'IDs из схемы GAR_FIAS Отношенние N -> 1';
COMMENT ON COLUMN gar_tmp.xxx_adr_street_type.id_street_type       IS 'ID из схемы UNSI';
COMMENT ON COLUMN gar_tmp.xxx_adr_street_type.fias_type_name       IS 'Полное наименование из схемы GAR_FIAS';
COMMENT ON COLUMN gar_tmp.xxx_adr_street_type.nm_street_type       IS 'Полное наименование из схемы UNSI';
COMMENT ON COLUMN gar_tmp.xxx_adr_street_type.fias_type_shortname  IS 'Полное наименование из схемы GAR_FIAS';
COMMENT ON COLUMN gar_tmp.xxx_adr_street_type.nm_street_type_short IS 'Краткое наименование из схемы GAR_FIAS';
COMMENT ON COLUMN gar_tmp.xxx_adr_street_type.fias_row_key         IS 'Текстовый ключ строки';
COMMENT ON COLUMN gar_tmp.xxx_adr_street_type.is_twin              IS 'Признак дубля';


DROP TABLE IF EXISTS gar_tmp.xxx_adr_house_type CASCADE;
/*==============================================================*/
/* Table: gar_tmp.xxx_adr_house_type                            */
/*==============================================================*/
CREATE TABLE gar_tmp.xxx_adr_house_type
(
     fias_ids             bigint[] 
    ,id_house_type        integer 
    ,fias_type_name       varchar(50) 
    ,nm_house_type        varchar(50) 
    ,fias_type_shortname  varchar(20)  
    ,nm_house_type_short  varchar(10)  
    ,kd_house_type_lvl    integer DEFAULT 1
    ,fias_row_key         text 
    ,is_twin              boolean  DEFAULT false
);

ALTER TABLE  gar_tmp.xxx_adr_house_type ADD CONSTRAINT pk_xxx_adr_house_type PRIMARY KEY (fias_row_key);

COMMENT ON TABLE gar_tmp.xxx_adr_house_type IS 'Временная таблица для "С_Типы номера (!)"';

COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.fias_ids            IS 'IDs из схемы GAR_FIAS отношение n - 1';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.id_house_type       IS 'ID из схемы UNNSI';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.fias_type_name      IS 'Полное наименование из схемы GAR_FIAS';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.nm_house_type       IS 'Полное наименование из схемы UNNSI';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.fias_type_shortname IS 'Полное наименование из схемы GAR_FIAS';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.nm_house_type_short IS 'Краткое наименование из схемы UNNSI';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.kd_house_type_lvl   IS 'Уровень типа номера (1-основной)'; 
COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.fias_row_key        IS 'Текстовый ключ строки';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.is_twin             IS 'Признак дубля';

DROP TABLE IF EXISTS gar_tmp.xxx_adr_area_type CASCADE;
/*==============================================================*/
/* Table: gar_tmp.xxx_adr_area_type                             */
/*==============================================================*/
CREATE TABLE gar_tmp.xxx_adr_area_type
(
     fias_ids            bigint[]
    ,id_area_type        integer 
    ,fias_type_name      varchar(250)
    ,nm_area_type        varchar(50) 
    ,fias_type_shortname varchar(50) 
    ,nm_area_type_short  varchar(10) 
    ,pr_lead             smallint DEFAULT 0
    ,fias_row_key        text
    ,is_twin             boolean DEFAULT false
);

ALTER TABLE  gar_tmp.xxx_adr_area_type ADD CONSTRAINT pk_xxx_adr_area_type PRIMARY KEY (fias_row_key);

COMMENT ON TABLE gar_tmp.xxx_adr_area_type IS 'Временная таблица для "С_Типы гео-региона (!)"';

COMMENT ON COLUMN gar_tmp.xxx_adr_area_type.fias_ids            IS 'Множество IDs из схемы GAR_FIAS';
COMMENT ON COLUMN gar_tmp.xxx_adr_area_type.id_area_type        IS 'ID из схемы UNSI';
COMMENT ON COLUMN gar_tmp.xxx_adr_area_type.fias_type_name      IS 'Полное наименование из схемы GAR_FIAS';
COMMENT ON COLUMN gar_tmp.xxx_adr_area_type.nm_area_type        IS 'Полное наименование из схемы UNSI';
COMMENT ON COLUMN gar_tmp.xxx_adr_area_type.fias_type_shortname IS 'Полное наименование из схемы GAR_FIAS';
COMMENT ON COLUMN gar_tmp.xxx_adr_area_type.nm_area_type_short  IS 'Краткое наименование из схемы GAR_FIAS';
COMMENT ON COLUMN gar_tmp.xxx_adr_area_type.pr_lead             IS 'Признак очередности типа гео-региона';
COMMENT ON COLUMN gar_tmp.xxx_adr_area_type.fias_row_key        IS 'Текстовый ключ строки';
COMMENT ON COLUMN gar_tmp.xxx_adr_area_type.is_twin             IS 'Признак дубля';

/*==============================================================*/
/* Table:  gar_tmp.xxx_adr_area                                 */
/*==============================================================*/
DROP TABLE IF EXISTS  gar_tmp.xxx_adr_area CASCADE;
CREATE TABLE gar_tmp.xxx_adr_area
(
     id_addr_obj      bigint NOT NULL 
    ,id_addr_parent   bigint 
    ,fias_guid        uuid 
    ,parent_fias_guid uuid 
    ,nm_addr_obj      varchar(250) 
    ,addr_obj_type_id bigint
    ,addr_obj_type    varchar(50) 
    ,obj_level        bigint
    ,level_name       varchar(100) 
    --
    ,region_code   varchar(4)   NULL  -- 2021-12-01
    ,area_code     varchar(4)   NULL
    ,city_code     varchar(4)   NULL
    ,place_code    varchar(4)   NULL
    ,plan_code     varchar(4)   NULL
    ,street_code   varchar(4)   NULL    
    --
    ,oper_type_id     bigint
    ,oper_type_name   varchar(100)
     --                                     2021-12-06
    ,start_date       date      NOT NULL
    ,end_date         date      NOT NULL 
     --
    ,tree_d           bigint[] 
    ,level_d          integer

);

COMMENT ON TABLE gar_tmp.xxx_adr_area IS
'Временная таблица. заполняется данными из "AS_ADDR_OBJ", "AS_REESTR_OBJECTS", "AS_ADM_HIERARCHY", "AS_MUN_HIERARCHY", "AS_OBJECT_LEVEL", "AS_STEADS_PARAMS"';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.id_addr_obj IS
'Глобальный уникальный идентификатор адресного объекта (ID ОБЪЕКТА)';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.id_addr_parent IS
'ID Родительского объекта';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.fias_guid IS
'Глобальный уникальный идентификатор адресного объекта (UUID ОБЪЕКТА)';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.parent_fias_guid IS
'UUID Родительского объекта';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.nm_addr_obj IS
'Наименование объекта';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.addr_obj_type_id IS
'ID типа объекта';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.addr_obj_type IS
'Наименование типа объекта';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.obj_level IS
'Уровень адресного объекта';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.level_name IS
'Наименование уровня адресного объекта';

--------------   2021-12-01
COMMENT ON COLUMN gar_tmp.xxx_adr_area.region_code IS        
'Код региона';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.area_code IS
'Код района';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.city_code IS
'Код города';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.place_code IS
'Код населенного пункта';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.plan_code IS
'Код ЭПС';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.street_code IS
'Код улицы';
--------------   2021-12-01

COMMENT ON COLUMN gar_tmp.xxx_adr_area.oper_type_id IS  
'ID операции';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.oper_type_name IS 
'Наименование операции';
     --                                     2021-12-06
COMMENT ON COLUMN gar_tmp.xxx_adr_area.start_date IS 
'Дата начала периода актуальности';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.end_date   IS
'Дата окончания периода актуальности';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.tree_d IS
'Положение в адресной иерархии';

COMMENT ON COLUMN gar_tmp.xxx_adr_area.level_d IS
'Уровень в адресной иерархии';

ALTER TABLE gar_tmp.xxx_adr_area
    ADD CONSTRAINT pk_xxx_adr_area PRIMARY KEY (id_addr_obj);
--
-- 2022-03-18  Индекс должен быть всегда.
-- 
DROP INDEX IF EXISTS _xxx_adr_area_ie3;
CREATE INDEX IF NOT EXISTS _xxx_adr_area_ie3 
    ON gar_tmp.xxx_adr_area USING btree (obj_level);
    
-- ALTER TABLE gar_tmp.xxx_gar_tmp.adr_area ADD COLUMN addr_obj_type_id bigint;
-- COMMENT ON COLUMN gar_tmp.xxx_gar_tmp.adr_area.addr_obj_type_id IS
-- 'ID типа объекта';

/*==============================================================*/
/* Table: gar_tmp.xxx_adr_house                                 */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.xxx_adr_house CASCADE;
CREATE TABLE gar_tmp.xxx_adr_house
(
     id_house              bigint NOT NULL 
    ,id_addr_parent        bigint 
    ,fias_guid             uuid 
    ,parent_fias_guid      uuid 
    ,nm_parent_obj         varchar(250) 
    ,region_code           varchar(4)   
    ,parent_type_id        bigint       
    ,parent_type_name      varchar(250) 
    ,parent_type_shortname varchar(50)  
    ,parent_level_id       bigint       
    ,parent_level_name     varchar(100) 
    ,parent_short_name     varchar(50)  
    ,house_num             varchar(50)  
    ,add_num1              varchar(50)  
    ,add_num2              varchar(50)  
    ,house_type            bigint       
    ,house_type_name       varchar(50)  
    ,house_type_shortname  varchar(20)  
    ,add_type1             bigint       
    ,add_type1_name        varchar(100) 
    ,add_type1_shortname   varchar(20)  
    ,add_type2             bigint       
    ,add_type2_name        varchar(100) 
    ,add_type2_shortname   varchar(20)  
    ,oper_type_id          bigint       
    ,oper_type_name        varchar(100) 
    ,user_id               text
);

ALTER TABLE gar_tmp.xxx_adr_house ADD CONSTRAINT pk_xxx_adr_house PRIMARY KEY (id_house);

CREATE INDEX IF NOT EXISTS _xxx_adr_house_ie1 ON gar_tmp.xxx_adr_house USING btree (id_addr_parent);

/*==============================================================*/
/*       Table: gar_tmp.xxx_type_param_value                    */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.xxx_type_param_value CASCADE;
CREATE TABLE gar_tmp.xxx_type_param_value
    ( object_id         bigint
     ,type_param_value  public.hstore
    );
ALTER TABLE gar_tmp.xxx_type_param_value 
      ADD CONSTRAINT pk_xxx_type_param_value PRIMARY KEY (object_id);
    
COMMENT ON TABLE gar_tmp.xxx_type_param_value IS
'Для каждого объекта хранятся агрегированные пары "Тип" - "Значение"';

COMMENT ON COLUMN gar_tmp.xxx_type_param_value.object_id IS
'Глобальный уникальный идентификатор адресного объекта (ID ОБЪЕКТА)';

COMMENT ON COLUMN gar_tmp.xxx_type_param_value.type_param_value IS
'Пара "Тип" - "Значение"';
    
-- 
-- drop table if exists ssp_fias_house cascade;
-- create table if not exists ssp_fias_house (
--    id                   INT8                 not null,
--    nm_guid              uuid                 not null,
--    nm_guid_address      uuid                 not null,
--    nn_object_id         INT8                 not null,
--    is_actual            BOOL                 not null,
--    nm_house             VARCHAR(250)         not null,
--    postcode             text                 not null,
--    id_user              text                 not null default session_user,
--    abr_korp             text                 null,
--    abr_str              text                 null,
--    kd_oktmo             VARCHAR(11)          null,
--    kd_house_type        INT8                 null,
--    kd_structure_type    text                 null,
--    kd_update_postcode   BOOL                 not null,
--    rank_double          INT4                 null
-- );
-- 
-- COMMENT ON TABLE ssp_fias_house IS
-- 'Загрузка домов (kd_house_type = 4)  заполняется из таблиц "AS_STEADS", "AS_REESTR_OBJECTS", "AS_STEADS_PARAMS", "AS_MUN_HIERARCHY"';
-- 
-- COMMENT ON COLUMN ssp_fias_house.id IS
-- 'AS_STEADS  идентификатор записи';
-- 
-- COMMENT ON COLUMN ssp_fias_house.nm_guid IS
-- 'AS_STEADS - Глобальный уникальный идентификатор объекта (UUID)"';
-- 
-- COMMENT ON COLUMN ssp_fias_house.nm_guid_address IS
-- 'Значение AS_REESTR_OBJECTS.OBJECTGUID записи, у которой AS_REESTR_OBJECTS.OBJECTID == AS_ADM_HIERARCHY.PARENTOBJID записи, у которой OBJECTID == nn_object_id';
-- 
-- COMMENT ON COLUMN ssp_fias_house.nn_object_id IS
-- 'AS_STEADS - Уникальный идентификатор записи';
-- 
-- COMMENT ON COLUMN ssp_fias_house.is_actual IS
-- 'AS_STEADS - Статус актуальности адресного объекта ФИАС';
-- 
-- COMMENT ON COLUMN ssp_fias_house.nm_house IS
-- 'AS_STEADS - .steads_number Номер земельного участка';
-- 
-- COMMENT ON COLUMN ssp_fias_house.postcode IS
-- 'AS_STEADS_PARAMS - type_value, где TYPEID=="5" (Почтовый индекс)';
-- 
-- COMMENT ON COLUMN ssp_fias_house.id_user IS
-- 'ИД Пользователя, производящего операцию';
-- 
-- COMMENT ON COLUMN ssp_fias_house.abr_korp IS
-- 'Не заполнять';
-- 
-- COMMENT ON COLUMN ssp_fias_house.kd_oktmo IS
-- 'AS_MUN_HIERARCHY -- Код ОКТМО';
-- 
-- COMMENT ON COLUMN ssp_fias_house.kd_house_type IS
-- 'kd_house_type := 4 Внимание! В ГАР ФИАС под "Земельный участок" не выделено отдельного типа в HOUSETYPES.
-- А тип "4" в нём соответствует "Гаражу". Требуется завести специальный тип, например, "24", или использовать тип "4" (Гараж) не по назначению.';
-- 
-- COMMENT ON COLUMN ssp_fias_house.kd_update_postcode IS
-- 'Признак обновления индексов: 0 - не обновлять индексы 1 - обновлять индексы';
-- 
-- COMMENT ON COLUMN ssp_fias_house.rank_double IS
-- 'Группа дублей (с автоинкрементом) ???';
-- 
-- alter table ssp_fias_house
--    add constraint PK_SSP_FIAS_HOUSE primary key (id);
--
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
/*==============================================================*/
/* Table: gar_tmp.adr_area                                      */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.tmp_adr_area CASCADE;
DROP TABLE IF EXISTS gar_tmp.adr_area CASCADE;
create table if not exists gar_tmp.adr_area (
   id_area              bigint               not null,
   id_country           integer              not null,
   nm_area              varchar(120) not null,
   nm_area_full         varchar(4000) not null,
   id_area_type         integer              null,
   id_area_parent       bigint               null,
   kd_timezone          integer              null,
   pr_detailed          smallint             not null,
   kd_oktmo             varchar(11) null,
   nm_fias_guid         uuid                 null,
   dt_data_del          timestamp            null,
   id_data_etalon       bigint               null,
   kd_okato             varchar(11) null,
   nm_zipcode           varchar(20) null,
   kd_kladr             varchar(15) null,
   vl_addr_latitude     numeric              null,
   vl_addr_longitude    numeric              null
);

COMMENT ON TABLE gar_tmp.adr_area IS
'С_Гео-регионы (!)';

ALTER TABLE gar_tmp.adr_area
   ADD CONSTRAINT PK_TMP_ADR_AREA PRIMARY KEY (id_area);

/*==============================================================*/
/* Table: gar_tmp.adr_house                                     */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.tmp_adr_house CASCADE;
drop table if exists gar_tmp.adr_house CASCADE;
create table if not exists gar_tmp.adr_house (
   id_house             bigint               not null,
   id_area              bigint               not null,
   id_street            bigint               null,
   id_house_type_1      integer              null,
   nm_house_1           varchar(70) null,
   id_house_type_2      integer              null,
   nm_house_2           varchar(50) null,
   id_house_type_3      integer              null,
   nm_house_3           varchar(50) null,
   nm_zipcode           varchar(20) null,
   nm_house_full        varchar(250) not null,
   kd_oktmo             varchar(11) null,
   nm_fias_guid         uuid                 null,
   dt_data_del          timestamp            null,
   id_data_etalon       bigint               null,
   kd_okato             varchar(11) null,
   vl_addr_latitude     numeric              null,
   vl_addr_longitude    numeric              null
);

COMMENT ON TABLE gar_tmp.adr_house IS
'С_Адреса (!)';

ALTER TABLE gar_tmp.adr_house
   ADD CONSTRAINT pk_adr_house PRIMARY KEY (id_house);

/*==============================================================*/
/* Table: gar_tmp.adr_objects                                   */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.tmp_adr_objects CASCADE;
DROP TABLE IF EXISTS gar_tmp.adr_objects CASCADE;
create table if not exists gar_tmp.adr_objects (
   id_object            bigint               not null,
   id_area              bigint               not null,
   id_house             bigint               null,
   id_object_type       integer              not null,
   id_street            bigint               null,
   nm_object            varchar(250) null,
   nm_object_full       varchar(500) not null,
   nm_description       varchar(150) null,
   dt_data_del          timestamp            null,
   id_data_etalon       bigint               null,
   id_metro_station     integer              null,
   id_autoroad          integer              null,
   nn_autoroad_km       numeric              null,
   nm_fias_guid         uuid                 null,
   nm_zipcode           varchar(20) null,
   kd_oktmo             varchar(11) null,
   kd_okato             varchar(11) null,
   vl_addr_latitude     numeric              null,
   vl_addr_longitude    numeric              null
);

COMMENT ON TABLE gar_tmp.adr_objects IS
'С_Отдельные сооружения и территории (!)';

alter table gar_tmp.adr_objects
   add constraint PK_TMP_ADR_OBJECTS primary key (id_object);

/*==============================================================*/
/* Table: gar_tmp.adr_street                                    */
/*==============================================================*/
drop table IF EXISTS gar_tmp.tmp_adr_street CASCADE;
drop table IF EXISTS gar_tmp.adr_street CASCADE;
create table if not exists gar_tmp.adr_street (
   id_street            bigint               not null,
   id_area              bigint               not null,
   nm_street            varchar(120) not null,
   id_street_type       integer              null,
   nm_street_full       varchar(255) not null,
   nm_fias_guid         uuid                 null,
   dt_data_del          timestamp            null,
   id_data_etalon       bigint               null,
   kd_kladr             varchar(15) null,
   vl_addr_latitude     numeric              null,
   vl_addr_longitude    numeric              null
);

COMMENT ON TABLE gar_tmp.adr_street IS 'С_Улицы (!)';

alter table gar_tmp.adr_street
   add constraint PK_TMP_ADR_STREET primary key (id_street);
-- ---------------------------------------------------------
ALTER TABLE gar_tmp.adr_area    SET UNLOGGED;
ALTER TABLE gar_tmp.adr_house   SET UNLOGGED;
ALTER TABLE gar_tmp.adr_objects SET UNLOGGED;
ALTER TABLE gar_tmp.adr_street  SET UNLOGGED;
