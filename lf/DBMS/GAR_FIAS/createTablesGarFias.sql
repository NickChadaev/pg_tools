/*================================================================================*/
/* DBMS name:      PostgreSQL 13.4                                                */
/* Created on:     01.10.2021 17:46:57                                            */
/* 2022-03-16, после перехода на версию от 2022-03-10                             */
/*   ALTER TABLE gar_fias.as_normative_docs ALTER COLUMN doc_name DROP NOT NULL;  */
/*================================================================================*/

SET search_path=gar_fias,unsi,public;
/*==============================================================*/
/* Table: AS_ADDR_OBJ                                           */
/*==============================================================*/
drop table IF EXISTS AS_ADDR_OBJ CASCADE;
create table IF NOT EXISTS AS_ADDR_OBJ (
   id                   INT8                 not null,
   object_id            INT8                 not null,
   OBJECT_GUID          UUID                 not null,
   CHANGE_ID            INT8                 not null,
   object_name          VARCHAR(250)         not null,
   TYPE_ID              INT8,
   TYPE_NAME            varchar(50),          
   OBJ_LEVEL            INT8                 not null,
   oper_type_id         INT8                 not null,
   PREV_ID              INT8                 null,
   NEXT_ID              INT8                 null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTUAL            BOOL                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_ADDR_OBJ is
'Классификатор адресообразующих элементов';

comment on column AS_ADDR_OBJ.id is
'Идентификатор адресного объекта ';

comment on column AS_ADDR_OBJ.object_id is
'Глобальный уникальный идентификатор адресного объекта ';

comment on column AS_ADDR_OBJ.OBJECT_GUID is
'Глобальный уникальный идентификатор адресного объекта типа UUID';

comment on column AS_ADDR_OBJ.CHANGE_ID is
'ID изменившей транзакции';

comment on column AS_ADDR_OBJ.object_name is
'Наименование';

comment on column AS_ADDR_OBJ.TYPE_ID is
'ID типа объекта';

comment on column AS_ADDR_OBJ.TYPE_NAME is
'Краткое наименование типа объекта';

comment on column AS_ADDR_OBJ.OBJ_LEVEL is
'Уровень адресного объекта ';

comment on column AS_ADDR_OBJ.oper_type_id is
'Статус действия над записью – причина появления записи';

comment on column AS_ADDR_OBJ.PREV_ID is
'Идентификатор записи связывания с предыдущей исторической записью';

comment on column AS_ADDR_OBJ.NEXT_ID is
'Идентификатор записи связывания с последующей исторической записью';

comment on column AS_ADDR_OBJ.START_DATE is
'Дата внесения (обновления) записи';

comment on column AS_ADDR_OBJ.END_DATE is
'Окончание действия записи';

comment on column AS_ADDR_OBJ.IS_ACTUAL is
'Статус актуальности адресного объекта ФИАС';

comment on column AS_ADDR_OBJ.IS_ACTIVE is
'Признак действующего адресного объекта';

alter table AS_ADDR_OBJ
   add constraint PK_AS_ADDR_OBJ primary key (id);

-- 2021-10-07   
--  alter table AS_ADDR_OBJ
--    add constraint AK1_AS_ADDR_OBJ unique (object_id);
   
   
/*==============================================================*/
/* Table: AS_ADDR_OBJ_DIVISION                                  */
/*==============================================================*/
drop table IF EXISTS AS_ADDR_OBJ_DIVISION CASCADE;
create table IF NOT EXISTS AS_ADDR_OBJ_DIVISION (
   ID                   INT8                 not null,
   PARENT_ID            INT8                 not null,
   CHILD_ID             INT8                 not null,
   CHANGE_ID            INT8                 not null
);

comment on table AS_ADDR_OBJ_DIVISION is
'Переподчинение адресных элементов ';

comment on column AS_ADDR_OBJ_DIVISION.ID is
'Уникальный идентификатор записи.';

comment on column AS_ADDR_OBJ_DIVISION.PARENT_ID is
'Глобальный уникальный идентификатор родительского адресного объекта ';

comment on column AS_ADDR_OBJ_DIVISION.CHILD_ID is
'Глобальный уникальный идентификатор дочернего адресного объекта';

comment on column AS_ADDR_OBJ_DIVISION.CHANGE_ID is
'ID изменившей транзакции';

alter table AS_ADDR_OBJ_DIVISION
   add constraint PK_AS_ADDR_OBJ_DIVISION primary key (ID);

/*==============================================================*/
/* Table: AS_ADDR_OBJ_PARAMS                                    */
/*==============================================================*/
drop table IF EXISTS AS_ADDR_OBJ_PARAMS CASCADE;
create table IF NOT EXISTS AS_ADDR_OBJ_PARAMS (
   ID                   INT8                 not null,
   OBJECT_ID            INT8                 not null,
   CHANGE_ID            INT8                 not null,
   CHANGE_ID_END        INT8                 not null,
   TYPE_ID              int8                 not null,
   obj_value            text                 not null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null
);

comment on table AS_ADDR_OBJ_PARAMS is
'Параметры адресообразующего элемента';

comment on column AS_ADDR_OBJ_PARAMS.ID is
'Идентификатор записи';

comment on column AS_ADDR_OBJ_PARAMS.OBJECT_ID is
'Глобальный уникальный идентификатор адресного объекта ';

comment on column AS_ADDR_OBJ_PARAMS.CHANGE_ID is
'ИД изменившей транзакции';

comment on column AS_ADDR_OBJ_PARAMS.CHANGE_ID_END is
'ID завершившей транзакции';

comment on column AS_ADDR_OBJ_PARAMS.TYPE_ID is
'Тип параметра';

comment on column AS_ADDR_OBJ_PARAMS.obj_value is
'Величина';

comment on column AS_ADDR_OBJ_PARAMS.UPDATE_DATE is
'Дата проследнего обновления';

comment on column AS_ADDR_OBJ_PARAMS.START_DATE is
'Дата начала действия записи';

comment on column AS_ADDR_OBJ_PARAMS.END_DATE is
'Дата окончания действия записи';

alter table AS_ADDR_OBJ_PARAMS
   add constraint PK_as_addr_obj_params PRIMARY KEY (ID);
   
/*==============================================================*/
/* Table: AS_ADDR_OBJ_TYPE                                      */
/*==============================================================*/
drop table IF EXISTS AS_ADDR_OBJ_TYPE CASCADE;
create table IF NOT EXISTS AS_ADDR_OBJ_TYPE (
   ID                   INT8                 not null,
   TYPE_LEVEL           VARCHAR(10)          not null,
   TYPE_NAME            VARCHAR(250)         not null,
   TYPE_SHORTNAME       VARCHAR(50)          not null,
   TYPE_DESCR           VARCHAR(250)         null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTIVE            boolean              not null
);

comment on table AS_ADDR_OBJ_TYPE is
'Типы адресных объектов ';

comment on column AS_ADDR_OBJ_TYPE.ID is
'Идентификатор записи ';

comment on column AS_ADDR_OBJ_TYPE.TYPE_LEVEL is
'Уровень адресного объекта ';

comment on column AS_ADDR_OBJ_TYPE.TYPE_NAME is
'Полное наименование типа объекта';

comment on column AS_ADDR_OBJ_TYPE.TYPE_SHORTNAME is
'Краткое наименование типа объекта';

comment on column AS_ADDR_OBJ_TYPE.TYPE_DESCR is
'Описание';

comment on column AS_ADDR_OBJ_TYPE.UPDATE_DATE is
'Дата внесения (обновления) записи';

comment on column AS_ADDR_OBJ_TYPE.START_DATE is
'Начало действия записи';

comment on column AS_ADDR_OBJ_TYPE.END_DATE is
'Окончание действия записи';

comment on column AS_ADDR_OBJ_TYPE.IS_ACTIVE is
'Статус активности';

alter table AS_ADDR_OBJ_TYPE
   add constraint PK_as_addr_obj_type PRIMARY KEY (ID);   
   
/*==============================================================*/
/* Table: AS_ADD_HOUSE_TYPE                                     */
/*==============================================================*/
drop table IF EXISTS AS_ADD_HOUSE_TYPE CASCADE;
create table IF NOT EXISTS AS_ADD_HOUSE_TYPE (
   add_type_id          INT8                 not null,
   TYPE_NAME            VARCHAR(100)         not null,
   TYPE_SHORTNAME       VARCHAR(20)          not null,
   TYPE_DESCR           VARCHAR(100)         not null,
   IS_ACTIVE            boolean              not null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null
);

alter table AS_ADD_HOUSE_TYPE
   add constraint PK_AS_ADD_HOUSE_TYPE primary key (add_type_id);

/*==============================================================*/
/* Table: AS_ADM_HIERARCHY                                      */
/*==============================================================*/
drop table IF EXISTS AS_ADM_HIERARCHY CASCADE;
create table IF NOT EXISTS AS_ADM_HIERARCHY (
   ID                   INT8                 not null,
   OBJECT_ID            INT8                 not null,
   PARENT_OBJ_ID        INT8                 null,
   CHANGE_ID            INT8                 not null,
   REGION_CODE          VARCHAR(4)           null,
   AREA_CODE            VARCHAR(4)           null,
   CITY_CODE            VARCHAR(4)           null,
   PLACE_CODE           VARCHAR(4)           null,
   PLAN_CODE            VARCHAR(4)           null,
   STREET_CODE          VARCHAR(4)           null,
   PREV_ID              INT8                 null,
   NEXT_ID              INT8                 null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 null,
   END_DATE             DATE                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_ADM_HIERARCHY is
'Иерархия в административном делении ';

comment on column AS_ADM_HIERARCHY.ID is
'Уникальный идентификатор записи';

comment on column AS_ADM_HIERARCHY.OBJECT_ID is
'Глобальный уникальный идентификатор объекта ';

comment on column AS_ADM_HIERARCHY.PARENT_OBJ_ID is
'Уникальный идентификатор адресного объекта ';

comment on column AS_ADM_HIERARCHY.CHANGE_ID is
'ID изменившей транзакции';

comment on column AS_ADM_HIERARCHY.REGION_CODE is
'Код региона';

comment on column AS_ADM_HIERARCHY.AREA_CODE is
'Код района';

comment on column AS_ADM_HIERARCHY.CITY_CODE is
'Код города';

comment on column AS_ADM_HIERARCHY.PLACE_CODE is
'Код населенного пункта';

comment on column AS_ADM_HIERARCHY.PLAN_CODE is
'Код ЭПС';

comment on column AS_ADM_HIERARCHY.STREET_CODE is
'Код улицы';

comment on column AS_ADM_HIERARCHY.PREV_ID is
'Идентификатор записи связывания с предыдущей исторической записью';

comment on column AS_ADM_HIERARCHY.NEXT_ID is
'Идентификатор записи связывания с последующей исторической записью';

comment on column AS_ADM_HIERARCHY.UPDATE_DATE is
'Дата внесения (обновления) записи';

comment on column AS_ADM_HIERARCHY.START_DATE is
'Начало действия записи';

comment on column AS_ADM_HIERARCHY.END_DATE is
'Окончание действия записи';

comment on column AS_ADM_HIERARCHY.IS_ACTIVE is
'Признак действующего адресного объекта';

alter table AS_ADM_HIERARCHY
   add constraint PK_AS_ADM_HIERARCHY primary key (ID);

/*==============================================================*/
/* Table: AS_APARTMENTS                                         */
/*==============================================================*/
drop table IF EXISTS AS_APARTMENTS CASCADE;
create table IF NOT EXISTS AS_APARTMENTS (
   ID                   INT8                 not null,
   OBJECT_ID            INT8                 not null,
   OBJECT_GUID          uuid                 not null,
   CHANGE_ID            INT8                 not null,
   APART_NUMBER         VARCHAR(50)          not null,
   apart_type_id        INT8                 not null,
   oper_type_id         INT8                 not null,
   PREV_ID              INT8                 null,
   NEXT_ID              INT8                 null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTUAL            BOOL                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_APARTMENTS is
'Помещения';

comment on column AS_APARTMENTS.ID is
'Уникальный идентификатор записи';

comment on column AS_APARTMENTS.OBJECT_ID is
'Глобальный уникальный идентификатор объекта (INTEGER)';

comment on column AS_APARTMENTS.OBJECT_GUID is
'Глобальный уникальный идентификатор объекта (UUID)';

comment on column AS_APARTMENTS.CHANGE_ID is
'ID изменившей транзакции';

comment on column AS_APARTMENTS.APART_NUMBER is
'Номер комнаты';

comment on column AS_APARTMENTS.apart_type_id is
'Тип комнаты';

comment on column AS_APARTMENTS.oper_type_id is
'Статус действия над записью – причина появления записи';

comment on column AS_APARTMENTS.PREV_ID is
'Идентификатор записи связывания с предыдущей исторической записью';

comment on column AS_APARTMENTS.NEXT_ID is
'Идентификатор записи связывания с последующей исторической записью';

comment on column AS_APARTMENTS.UPDATE_DATE is
'Дата внесения (обновления) записи';

comment on column AS_APARTMENTS.START_DATE is
'Начало действия записи';

comment on column AS_APARTMENTS.END_DATE is
'Окончание действия записи';

comment on column AS_APARTMENTS.IS_ACTUAL is
'Статус актуальности адресного объекта ФИАС';

comment on column AS_APARTMENTS.IS_ACTIVE is
'Статус актуальности адресного объекта ФИАС
Признак действующего адресного объекта
';

alter table AS_APARTMENTS
   add constraint PK_AS_APARTMENTS primary key (ID);

/*==============================================================*/
/* Table: AS_APARTMENTS_PARAMS                                  */
/*==============================================================*/
drop table IF EXISTS AS_APARTMENTS_PARAMS CASCADE;
create table IF NOT EXISTS AS_APARTMENTS_PARAMS (
   ID                   INT8                 not null,
   OBJECT_ID            INT8                 not null,
   CHANGE_ID            INT8                 not null,
   CHANGE_ID_END        INT8                 not null,
   TYPE_ID              INT8                 not null,
   param_value          text                 not null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null
);

comment on table AS_APARTMENTS_PARAMS is
'Параметры помещения';

comment on column AS_APARTMENTS_PARAMS.ID is
'Идентификатор записи';

comment on column AS_APARTMENTS_PARAMS.OBJECT_ID is
'Глобальный уикальный идентификатор (INTEGER)';

comment on column AS_APARTMENTS_PARAMS.CHANGE_ID is
'Идентификатор транзакции';

comment on column AS_APARTMENTS_PARAMS.CHANGE_ID_END is
'Идентификатор последней транзакции';

comment on column AS_APARTMENTS_PARAMS.TYPE_ID is
'Идентификатор типа';

comment on column AS_APARTMENTS_PARAMS.UPDATE_DATE is
'Дата последнего обновления';

comment on column AS_APARTMENTS_PARAMS.START_DATE is
'Начало периода актуальности';

comment on column AS_APARTMENTS_PARAMS.END_DATE is
'Конец периода актуальности';

alter table AS_APARTMENTS_PARAMS
   add constraint PK_AS_APARTMENTS_PARAMS primary key (ID);

/*==============================================================*/
/* Table: AS_APARTMENT_TYPE                                     */
/*==============================================================*/
drop table IF EXISTS AS_APARTMENT_TYPE CASCADE;
create table IF NOT EXISTS AS_APARTMENT_TYPE (
   apart_type_id        INT8                 not null,
   TYPE_NAME            VARCHAR(100)         not null,
   TYPE_SHORTNAME       VARCHAR(50)          null,
   TYPE_DESC            VARCHAR(250)         null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_APARTMENT_TYPE is
'Типы помещений';

comment on column AS_APARTMENT_TYPE.apart_type_id is
'Идентификатор типа ';

comment on column AS_APARTMENT_TYPE.TYPE_NAME is
'Наименование';

comment on column AS_APARTMENT_TYPE.TYPE_SHORTNAME is
'Краткое наименование';

comment on column AS_APARTMENT_TYPE.TYPE_DESC is
'Описание';

comment on column AS_APARTMENT_TYPE.UPDATE_DATE is
'Дата внесения (обновления) записи';

comment on column AS_APARTMENT_TYPE.START_DATE is
'Начало действия записи';

comment on column AS_APARTMENT_TYPE.END_DATE is
'Окончание действия записи';

comment on column AS_APARTMENT_TYPE.IS_ACTIVE is
'Статус активности';

alter table AS_APARTMENT_TYPE
   add constraint PK_AS_APARTMENT_TYPE primary key (apart_type_id);

/*==============================================================*/
/* Table: AS_CARPLACES                                          */
/*==============================================================*/
drop table IF EXISTS AS_CARPLACES CASCADE;
create table IF NOT EXISTS AS_CARPLACES (
   ID                   INT8                 not null,
   OBJECT_ID            INT8                 not null,
   OBJECT_GUID          uuid                 not null,
   CHANGE_ID            INT8                 not null,
   CARPLACE_NUMBER      VARCHAR(50)          null,
   OPER_TYPE_ID         INT8                 not null,
   PREV_ID              INT8                 null,
   NEXT_ID              INT8                 null,
   UPDATE_DATE          DATE                 null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTUAL            BOOL                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_CARPLACES is
'Сведения по машино-местам';

comment on column AS_CARPLACES.ID is
'Уникальный идентификатор записи ';

comment on column AS_CARPLACES.OBJECT_ID is
'Глобальный уникальный идентификатор объекта (INTEGER)';

comment on column AS_CARPLACES.OBJECT_GUID is
'Глобальный уникальный идентификатор объекта (UUID)';

comment on column AS_CARPLACES.CHANGE_ID is
'ID изменившей транзакции';

comment on column AS_CARPLACES.CARPLACE_NUMBER is
'Номер машино-места';

comment on column AS_CARPLACES.OPER_TYPE_ID is
'Статус действия над записью – причина появления записи';

comment on column AS_CARPLACES.PREV_ID is
'Идентификатор записи связывания с предыдущей исторической записью';

comment on column AS_CARPLACES.NEXT_ID is
'Идентификатор записи связывания с последующей исторической записью';

comment on column AS_CARPLACES.UPDATE_DATE is
'Дата внесения (обновления) записи';

comment on column AS_CARPLACES.START_DATE is
'Начало действия записи';

comment on column AS_CARPLACES.END_DATE is
'Окончание действия записи';

comment on column AS_CARPLACES.IS_ACTUAL is
'Статус актуальности адресного объекта ФИАС';

comment on column AS_CARPLACES.IS_ACTIVE is
'Признак действующего адресного объекта';

alter table AS_CARPLACES
   add constraint PK_AS_CARPLACES primary key (ID);

/*==============================================================*/
/* Table: AS_CARPLACES_PARAMS                                   */
/*==============================================================*/
drop table IF EXISTS AS_CARPLACES_PARAMS CASCADE;
create table IF NOT EXISTS AS_CARPLACES_PARAMS (
   ID                   INT8                 not null,
   OBJECT_ID            INT8                 not null,
   CHANGE_ID            INT8                 not null,
   CHANGE_ID_END        INT8                 not null,
   TYPE_ID              INT8                 not null,
   param_value          VARCHAR(100)         not null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null
);

comment on table AS_CARPLACES_PARAMS is
'Параметры машиноместа';

comment on column AS_CARPLACES_PARAMS.ID is
'Уникальный идентификатор записи';

comment on column AS_CARPLACES_PARAMS.OBJECT_ID is
'Уникальный идентификатор объекта';

comment on column AS_CARPLACES_PARAMS.CHANGE_ID is
'Идентифкатор транзакции';

comment on column AS_CARPLACES_PARAMS.CHANGE_ID_END is
'Идентификатор последней примнённой транзакции';

comment on column AS_CARPLACES_PARAMS.TYPE_ID is
'Идентификатор типа
';

comment on column AS_CARPLACES_PARAMS.UPDATE_DATE is
'Дата последнего обновления';

comment on column AS_CARPLACES_PARAMS.START_DATE is
'Дата начала действия';

comment on column AS_CARPLACES_PARAMS.END_DATE is
'Дата окончания действия';

alter table AS_CARPLACES_PARAMS
   add constraint PK_AS_CARPLACES_PARAMS primary key (ID);

/*==============================================================*/
/* Table: AS_CHANGE_HISTORY                                     */
/*==============================================================*/
drop table IF EXISTS AS_CHANGE_HISTORY CASCADE;
create table IF NOT EXISTS AS_CHANGE_HISTORY (
   CHANGE_ID            INT8                 not null,
   OBJECT_ID            INT8                 not null,
   ADR_OBJECT_UUID      uuid                 not null,
   oper_type_id         INT8                 not null,
   ndoc_id              INT8                 null,
   CHANGE_DATE          DATE                 not null
);

comment on table AS_CHANGE_HISTORY is
'История изменений ';

comment on column AS_CHANGE_HISTORY.CHANGE_ID is
'ID изменившей транзакции
';

comment on column AS_CHANGE_HISTORY.OBJECT_ID is
'Глобальный уникальный идентификатор адресного объекта ';

comment on column AS_CHANGE_HISTORY.ADR_OBJECT_UUID is
'Глобальный уникальный идентификатор адресного объекта  UUID';

comment on column AS_CHANGE_HISTORY.oper_type_id is
'Идентификатор статуса ';

comment on column AS_CHANGE_HISTORY.ndoc_id is
'Идентификатор нормативного документа';

alter table AS_CHANGE_HISTORY
   add constraint PK_AS_CHANGE_HISTORY primary key (CHANGE_ID);

/*==============================================================*/
/* Table: AS_HOUSES                                             */
/*==============================================================*/
drop table IF EXISTS AS_HOUSES CASCADE;
create table IF NOT EXISTS AS_HOUSES (
   ID                   INT8                 not null,
   OBJECT_ID            INT8                 not null,
   OBJECT_GUID          uuid                 not null,
   CHANGE_ID            INT8                 not null,
   HOUSE_NUM            VARCHAR(50)          null,
   ADD_NUM1             VARCHAR(50)          null,
   ADD_NUM2             VARCHAR(50)          null,
   HOUSE_TYPE           INT8                 null,
   add_type1            INT8                 null,
   add_type2            INT8                 null,
   oper_type_id         INT8                 not null,
   PREV_ID              INT8                 null,
   NEXT_ID              INT8                 null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTUAL            BOOL                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_HOUSES is
'Номерам домов';

comment on column AS_HOUSES.ID is
'Уникальный идентификатор записи. ';

comment on column AS_HOUSES.OBJECT_ID is
'Глобальный уникальный идентификатор объекта (INTEGER)';

comment on column AS_HOUSES.OBJECT_GUID is
'Глобальный уникальный идентификатор объекта (UUID)';

comment on column AS_HOUSES.CHANGE_ID is
'ID изменившей транзакции';

comment on column AS_HOUSES.HOUSE_NUM is
'Основной номер дома';

comment on column AS_HOUSES.ADD_NUM1 is
'Дополнительный номер дома 1';

comment on column AS_HOUSES.ADD_NUM2 is
'Дополнительный номер дома 2';

comment on column AS_HOUSES.HOUSE_TYPE is
'Основной тип дома';

comment on column AS_HOUSES.add_type1 is
'Дополнительный тип дома 1';

comment on column AS_HOUSES.add_type2 is
'Дополнительный тип дома 2';

comment on column AS_HOUSES.oper_type_id is
'Статус действия над записью – причина появления записи';

comment on column AS_HOUSES.PREV_ID is
'Идентификатор записи связывания с предыдущей исторической записью';

comment on column AS_HOUSES.NEXT_ID is
'Идентификатор записи связывания с последующей исторической записью';

comment on column AS_HOUSES.UPDATE_DATE is
'Дата внесения (обновления) записи';

comment on column AS_HOUSES.START_DATE is
'Начало действия записи';

comment on column AS_HOUSES.END_DATE is
'Окончание действия записи';

comment on column AS_HOUSES.IS_ACTUAL is
'Статус актуальности адресного объекта ФИАС';

comment on column AS_HOUSES.IS_ACTIVE is
'Признак действующего адресного объекта';

alter table AS_HOUSES
   add constraint PK_AS_HOUSES primary key (ID);

/*==============================================================*/
/* Table: AS_HOUSES_PARAMS                                      */
/*==============================================================*/
drop table IF EXISTS AS_HOUSES_PARAMS CASCADE;
create table IF NOT EXISTS AS_HOUSES_PARAMS (
   ID                   INT8                 not null,
   OBJECT_ID            INT8                 not null,
   CHANGE_ID            INT8                 not null,
   CHANGE_ID_END        INT8                 not null,
   type_id              INT8                 not null,
   VALUE                text                 not null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null
);

comment on column AS_HOUSES_PARAMS.ID is
'Иникальный идентификатор';

comment on column AS_HOUSES_PARAMS.OBJECT_ID is
'Глобальный уникальный идентификатор';

comment on column AS_HOUSES_PARAMS.CHANGE_ID is
'ID транзакции, изменившей запись';

comment on column AS_HOUSES_PARAMS.CHANGE_ID_END is
'Завершившая транзакция';

comment on column AS_HOUSES_PARAMS.type_id is
'Тип параметра';

comment on column AS_HOUSES_PARAMS.VALUE is
'Величина';

comment on column AS_HOUSES_PARAMS.UPDATE_DATE is
'Дата обновления';

comment on column AS_HOUSES_PARAMS.START_DATE is
'Дата создания';

comment on column AS_HOUSES_PARAMS.END_DATE is
'Дата завершения';

alter table AS_HOUSES_PARAMS
   add constraint PK_AS_HOUSES_PARAMS primary key (ID);

/*==============================================================*/
/* Table: AS_HOUSE_TYPE                                         */
/*==============================================================*/
drop table IF EXISTS AS_HOUSE_TYPE CASCADE; 
create table IF NOT EXISTS AS_HOUSE_TYPE (
   house_type_id        INT8                 not null,
   TYPE_NAME            VARCHAR(50)          not null,
   TYPE_SHORTNAME       VARCHAR(20)          null,
   TYPE_DESCR           VARCHAR(250)         null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_HOUSE_TYPE is
'Признаки владения (Типы домов)';

comment on column AS_HOUSE_TYPE.house_type_id is
'ID Признака владения
';

comment on column AS_HOUSE_TYPE.TYPE_NAME is
'Наименование';

comment on column AS_HOUSE_TYPE.TYPE_SHORTNAME is
'Краткое наименование';

comment on column AS_HOUSE_TYPE.UPDATE_DATE is
'Дата внесения (обновления) записи';

comment on column AS_HOUSE_TYPE.START_DATE is
'Начало действия записи';

comment on column AS_HOUSE_TYPE.END_DATE is
'Окончание действия записи';

comment on column AS_HOUSE_TYPE.IS_ACTIVE is
'Статус активности';

alter table AS_HOUSE_TYPE
   add constraint PK_AS_HOUSE_TYPE primary key (house_type_id);

/*==============================================================*/
/* Table: AS_MUN_HIERARCHY                                      */
/*==============================================================*/
drop table IF EXISTS AS_MUN_HIERARCHY CASCADE;
create table IF NOT EXISTS AS_MUN_HIERARCHY (
   ID                   INT8                 not null,
   OBJECT_ID            INT8                 not null,
   parent_obj_id        INT8                 null,
   CHANGE_ID            INT8                 not null,
   OKTMO                VARCHAR(11)          not null,
   PREV_ID              INT8                 not null,
   NEXT_ID              INT8                 not null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_MUN_HIERARCHY is
'Иерархия в муниципальном делении';

comment on column AS_MUN_HIERARCHY.ID is
'Уникальный идентификатор записи';

comment on column AS_MUN_HIERARCHY.OBJECT_ID is
'Глобальный уникальный идентификатор адресного объекта';

comment on column AS_MUN_HIERARCHY.parent_obj_id is
'Идентификатор родительского объекта ';

comment on column AS_MUN_HIERARCHY.CHANGE_ID is
'ID изменившей транзакции';

comment on column AS_MUN_HIERARCHY.OKTMO is
'Код ОКТМО';

comment on column AS_MUN_HIERARCHY.START_DATE is
'Начало действия записи';

comment on column AS_MUN_HIERARCHY.END_DATE is
'Окончание действия записи';

comment on column AS_MUN_HIERARCHY.IS_ACTIVE is
'Признак действующего адресного объекта';

alter table AS_MUN_HIERARCHY
   add constraint PK_AS_MUN_HIERARCHY primary key (ID);

/*==============================================================*/
/* Table: AS_NORMATIVE_DOCS                                     */
/*==============================================================*/
drop table IF EXISTS AS_NORMATIVE_DOCS CASCADE;
create table IF NOT EXISTS AS_NORMATIVE_DOCS (
   ndoc_id              INT8                 not null,
   DOC_NAME             VARCHAR(1500)        null,  -- 2022-03-16, после перехода на 2022-03-10
   DOC_DATE             DATE                 not null,
   DOC_NUMBER           VARCHAR(150)         not null,
   doc_type_id          INT8                 not null,
   doc_kind_id          INT8                 not null,
   UPDATE_DATE          DATE                 not null,
   ORG_NAME             VARCHAR(255)         null,
   reg_num              VARCHAR(100)         null,
   reg_date             DATE                 null,
   ACC_DATE             DATE                 null,
   doc_comment          text                 null
);

comment on table AS_NORMATIVE_DOCS is
'Нормативные документы';

comment on column AS_NORMATIVE_DOCS.ndoc_id is
'Идентификатор нормативного документа';

comment on column AS_NORMATIVE_DOCS.DOC_NAME is
'Наименование документа';

comment on column AS_NORMATIVE_DOCS.DOC_DATE is
'Дата документа';

comment on column AS_NORMATIVE_DOCS.DOC_NUMBER is
'Номер документа';

comment on column AS_NORMATIVE_DOCS.doc_type_id is
'Тип документа';

comment on column AS_NORMATIVE_DOCS.doc_kind_id is
'Вид документа';

comment on column AS_NORMATIVE_DOCS.UPDATE_DATE is
'Дата обновления';

comment on column AS_NORMATIVE_DOCS.ORG_NAME is
'Наименование органа, создавшего нормативный документ';

comment on column AS_NORMATIVE_DOCS.reg_num is
'Номер государственной регистрации';

comment on column AS_NORMATIVE_DOCS.reg_date is
'Дата государственной регистрации';

comment on column AS_NORMATIVE_DOCS.ACC_DATE is
'Дата вступления в силу нормативного документа';

comment on column AS_NORMATIVE_DOCS.doc_comment is
'Комментарий к документу';

alter table AS_NORMATIVE_DOCS
   add constraint PK_AS_NORMATIVE_DOCS primary key (ndoc_id);

/*==============================================================*/
/* Table: AS_NORM_DOCS_KINDS                                    */
/*==============================================================*/
drop table IF EXISTS AS_NORM_DOCS_KINDS CASCADE;
create table IF NOT EXISTS AS_NORM_DOCS_KINDS (
   doc_kind_id          INT8                 not null,
   DOC_NAME             VARCHAR(500)         not null
);

comment on table AS_NORM_DOCS_KINDS is
'Вид документа';

alter table AS_NORM_DOCS_KINDS
   add constraint PK_AS_NORM_DOCS_KINDS primary key (doc_kind_id);

/*==============================================================*/
/* Table: AS_NORM_DOCS_TYPES                                    */
/*==============================================================*/
drop table IF EXISTS AS_NORM_DOCS_TYPES CASCADE;
create table IF NOT EXISTS AS_NORM_DOCS_TYPES (
   doc_type_id          INT8                 not null,
   DOC_NAME             VARCHAR(500)         not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null
);

comment on table AS_NORM_DOCS_TYPES is
'Тип нормативного документа';

comment on column AS_NORM_DOCS_TYPES.doc_type_id is
'Идентификатор типа';

comment on column AS_NORM_DOCS_TYPES.DOC_NAME is
'Наименование типа';

comment on column AS_NORM_DOCS_TYPES.START_DATE is
'Дата начала действия';

comment on column AS_NORM_DOCS_TYPES.END_DATE is
'Дата окончания действия';

alter table AS_NORM_DOCS_TYPES
   add constraint PK_AS_NORM_DOCS_TYPES primary key (doc_type_id);

/*==============================================================*/
/* Table: AS_OBJECT_LEVEL                                       */
/*==============================================================*/
drop table IF EXISTS AS_OBJECT_LEVEL CASCADE;
create table IF NOT EXISTS AS_OBJECT_LEVEL (
   level_id             INT8                 not null,
   level_name           VARCHAR(100)         not null,
   short_name           VARCHAR(50)          null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_OBJECT_LEVEL is
'Уровни адресных объектов';

comment on column AS_OBJECT_LEVEL.level_id is
'Уникальный идентификатор записи. ';

comment on column AS_OBJECT_LEVEL.level_name is
'Наименование';

comment on column AS_OBJECT_LEVEL.short_name is
'Краткое наименование';

comment on column AS_OBJECT_LEVEL.UPDATE_DATE is
'Дата внесения (обновления) записи';

comment on column AS_OBJECT_LEVEL.START_DATE is
'Начало действия записи';

comment on column AS_OBJECT_LEVEL.END_DATE is
'Окончание действия записи';

comment on column AS_OBJECT_LEVEL.IS_ACTIVE is
'Признак действующего адресного объекта';

alter table AS_OBJECT_LEVEL
   add constraint PK_AS_OBJECT_LEVEL primary key (level_id);

/*==============================================================*/
/* Table: AS_OPERATION_TYPE                                     */
/*==============================================================*/
drop table IF EXISTS AS_OPERATION_TYPE CASCADE; 
create table IF NOT EXISTS AS_OPERATION_TYPE (
   oper_type_id         INT8                 not null,
   oper_type_name       VARCHAR(100)         not null,
   short_name           VARCHAR(100)         null,
   descr                VARCHAR(250)         null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_OPERATION_TYPE is
'Статусы действия ';

comment on column AS_OPERATION_TYPE.oper_type_id is
'Идентификатор статуса ';

comment on column AS_OPERATION_TYPE.oper_type_name is
'Наименование';

comment on column AS_OPERATION_TYPE.short_name is
'Краткое наименование';

comment on column AS_OPERATION_TYPE.descr is
'Описание';

comment on column AS_OPERATION_TYPE.UPDATE_DATE is
'Дата внесения (обновления) записи';

comment on column AS_OPERATION_TYPE.START_DATE is
'Начало действия записи';

comment on column AS_OPERATION_TYPE.END_DATE is
'Окончание действия записи';

comment on column AS_OPERATION_TYPE.IS_ACTIVE is
'Статус активности';

alter table AS_OPERATION_TYPE
   add constraint PK_AS_OPERATION_TYPE primary key (oper_type_id);

/*==============================================================*/
/* Table: AS_PARAM_TYPE                                         */
/*==============================================================*/
drop table IF EXISTS AS_PARAM_TYPE CASCADE;
create table IF NOT EXISTS AS_PARAM_TYPE (
   type_id              INT8                 not null,
   TYPE_NAME            VARCHAR(50)          not null,
   TYPE_CODE            VARCHAR(250)          not null,
   TYPE_DESC            VARCHAR(250)         null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_PARAM_TYPE is
'Типы параметров';

comment on column AS_PARAM_TYPE.type_id is
'Идентификатор типа параметра ';

comment on column AS_PARAM_TYPE.TYPE_NAME is
'Наименование';

comment on column AS_PARAM_TYPE.TYPE_CODE is
'Кодовое обозначение';

comment on column AS_PARAM_TYPE.TYPE_DESC is
'Описание';

comment on column AS_PARAM_TYPE.UPDATE_DATE is
'Дата внесения (обновления) записи';

comment on column AS_PARAM_TYPE.START_DATE is
'Начало действия записи';

comment on column AS_PARAM_TYPE.END_DATE is
'Окончание действия записи';

comment on column AS_PARAM_TYPE.IS_ACTIVE is
'Статус активности';

alter table AS_PARAM_TYPE
   add constraint PK_AS_PARAM_TYPE primary key (type_id);

/*==============================================================*/
/* Table: AS_REESTR_OBJECTS                                     */
/*==============================================================*/
drop table IF EXISTS AS_REESTR_OBJECTS CASCADE;
create table IF NOT EXISTS AS_REESTR_OBJECTS (
   OBJECT_ID            INT8                 not null,
   OBJECT_GUID          uuid                 not null,
   CHANGE_ID            INT8                 not null,
   IS_ACTIVE            boolean              not null,
   level_id             INT8                 null,
   CREATE_DATE          DATE                 not null,
   UPDATE_DATE          DATE                 not null
);

comment on table AS_REESTR_OBJECTS is
'Сведения об элементе реестра';

comment on column AS_REESTR_OBJECTS.OBJECT_ID is
'Уникальный идентификатор адресного объекта ';

comment on column AS_REESTR_OBJECTS.OBJECT_GUID is
'Глобальный уникальный идентификатор адресного объекта ';

comment on column AS_REESTR_OBJECTS.CHANGE_ID is
'ID изменившей транзакции';

comment on column AS_REESTR_OBJECTS.IS_ACTIVE is
'Признак действующего объекта';

comment on column AS_REESTR_OBJECTS.level_id is
'Уникальный идентификатор записи. ';

comment on column AS_REESTR_OBJECTS.CREATE_DATE is
'Дата создания';

comment on column AS_REESTR_OBJECTS.UPDATE_DATE is
'Дата изменения';

alter table AS_REESTR_OBJECTS
   add constraint PK_AS_REESTR_OBJECTS primary key (OBJECT_ID);

/*==============================================================*/
/* Table: AS_ROOMS                                              */
/*==============================================================*/
drop table IF EXISTS AS_ROOMS CASCADE;
create table IF NOT EXISTS AS_ROOMS (
   ID                   INT8                 not null,
   OBJECT_ID            INT8                 not null,
   OBJECT_GUID          UUID                 not null,
   CHANGE_ID            INT8                 not null,
   ROOM_NUMBER          VARCHAR(50)          not null,
   room_type_id         INT8                 not null,
   OPER_TYPE_ID         INT8                 not null,
   PREV_ID              INT8                 null,
   NEXT_ID              INT8                 null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTUAL            BOOL                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_ROOMS is
'Комнаты';

comment on column AS_ROOMS.ID is
'Уникальный идентификатор записи';

comment on column AS_ROOMS.OBJECT_ID is
'Глобальный уникальный идентификатор  объекта (ID)';

comment on column AS_ROOMS.OBJECT_GUID is
'Глобальный уникальный идентификатор  объекта (UUID)';

comment on column AS_ROOMS.CHANGE_ID is
'Ид последнй изменившей транзакции';

comment on column AS_ROOMS.ROOM_NUMBER is
'Номер комнаты';

comment on column AS_ROOMS.room_type_id is
'Тип комнаты или офиса';

comment on column AS_ROOMS.OPER_TYPE_ID is
'Статус действия над записью – причина появления записи';

comment on column AS_ROOMS.PREV_ID is
'Идентификатор записи связывания с предыдущей исторической записью';

comment on column AS_ROOMS.NEXT_ID is
'Идентификатор записи связывания с последующей исторической записью';

comment on column AS_ROOMS.UPDATE_DATE is
'Дата внесения (обновления) записи';

comment on column AS_ROOMS.START_DATE is
'Дата начала действия';

comment on column AS_ROOMS.END_DATE is
'Дата завершения актуальности';

comment on column AS_ROOMS.IS_ACTUAL is
'Признак актуальности';

comment on column AS_ROOMS.IS_ACTIVE is
'Признак активного объекта';

alter table AS_ROOMS
   add constraint PK_AS_ROOMS primary key (ID);

/*==============================================================*/
/* Table: AS_ROOMS_PARAMS                                       */
/*==============================================================*/
drop table IF EXISTS AS_ROOMS_PARAMS CASCADE;
create table IF NOT EXISTS AS_ROOMS_PARAMS (
   ID                   INT8                 not null,
   OBJECT_ID            INT8                 not null,
   CHANGE_ID            INT8                 null,
   CHANGE_ID_END        INT8                 null,
   TYPE_ID              INT8                 null,
   VALUE                text                 not null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null
);

comment on table AS_ROOMS_PARAMS is
'Параметры комнаты';

comment on column AS_ROOMS_PARAMS.ID is
'Уникальный идентификатор записи';

comment on column AS_ROOMS_PARAMS.OBJECT_ID is
'Уникальный глобальный идентификатор объекта (INTEGER)';

comment on column AS_ROOMS_PARAMS.CHANGE_ID is
'Идентификатор транзакции';

comment on column AS_ROOMS_PARAMS.CHANGE_ID_END is
'Идентификатор последней применённой транзакции';

comment on column AS_ROOMS_PARAMS.TYPE_ID is
'Идентификатор типа';

comment on column AS_ROOMS_PARAMS.VALUE is
'Величина';

comment on column AS_ROOMS_PARAMS.UPDATE_DATE is
'Дата последнего обновления';

comment on column AS_ROOMS_PARAMS.START_DATE is
'Дата начала актуальности';

comment on column AS_ROOMS_PARAMS.END_DATE is
'Дата конца актуальности';

alter table AS_ROOMS_PARAMS
   add constraint PK_AS_ROOMS_PARAMS primary key (ID);

/*==============================================================*/
/* Table: AS_ROOM_TYPE                                          */
/*==============================================================*/
drop table IF EXISTS AS_ROOM_TYPE CASCADE;
create table IF NOT EXISTS AS_ROOM_TYPE (
   type_id              INT8                 not null,
   TYPE_NAME            VARCHAR(100)         not null,
   short_name           VARCHAR(50)          null,
   TYPE_DESC            VARCHAR(250)         null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_ROOM_TYPE is
'Типы комнат';

comment on column AS_ROOM_TYPE.type_id is
'Идентификатор типа ';

comment on column AS_ROOM_TYPE.short_name is
'Краткое наименование';

comment on column AS_ROOM_TYPE.TYPE_DESC is
'Описание типа';

comment on column AS_ROOM_TYPE.UPDATE_DATE is
'Дата внесения (обновления) записи';

comment on column AS_ROOM_TYPE.START_DATE is
'Начало действия записи';

comment on column AS_ROOM_TYPE.END_DATE is
'Окончание действия записи';

comment on column AS_ROOM_TYPE.IS_ACTIVE is
'Статус активности';

alter table AS_ROOM_TYPE
   add constraint PK_AS_ROOM_TYPE primary key (type_id);

/*==============================================================*/
/* Table: AS_STEADS                                             */
/*==============================================================*/
drop table IF EXISTS AS_STEADS CASCADE;
create table IF NOT EXISTS AS_STEADS (
   ID                   INT8                 not null,
   OBJECT_ID            INT8                 not null,
   OBJECT_GUID          uuid                 not null,
   CHANGE_ID            INT8                 not null,
   STEADS_NUMBER        VARCHAR(250)         null,       -- 2021-11-30 Nick
   OPER_TYPE_ID         INT8                 not null,
   prev_id              INT8                 null,
   NEXT_ID              INT8                 null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null,
   IS_ACTUAL            BOOL                 not null,
   IS_ACTIVE            BOOL                 not null
);

comment on table AS_STEADS is
'Земельные участки';

comment on column AS_STEADS.ID is
'Уникальный идентификатор записи';

comment on column AS_STEADS.OBJECT_ID is
'Глобальный уникальный идентификатор объекта (INTEGER)';

comment on column AS_STEADS.OBJECT_GUID is
'Глобальный уникальный идентификатор объекта (UUID)';

comment on column AS_STEADS.CHANGE_ID is
'ID изменившей транзакции';

comment on column AS_STEADS.STEADS_NUMBER is
'Номер земельного участка';

comment on column AS_STEADS.OPER_TYPE_ID is
'Статус действия над записью – причина появления записи';

comment on column AS_STEADS.prev_id is
'Идентификатор записи связывания с предыдущей исторической записью';

comment on column AS_STEADS.NEXT_ID is
'Идентификатор записи связывания с последующей исторической записью';

comment on column AS_STEADS.UPDATE_DATE is
'Дата внесения (обновления) записи';

comment on column AS_STEADS.START_DATE is
'Начало действия записи';

comment on column AS_STEADS.END_DATE is
'Окончание действия записи';

comment on column AS_STEADS.IS_ACTUAL is
'Статус актуальности адресного объекта ФИАС';

comment on column AS_STEADS.IS_ACTIVE is
'Признак действующего адресного объекта';

alter table AS_STEADS
   add constraint PK_AS_STEADS primary key (ID);

/*==============================================================*/
/* Table: AS_STEADS_PARAMS                                      */
/*==============================================================*/
drop table IF EXISTS AS_STEADS_PARAMS CASCADE;
create table IF NOT EXISTS AS_STEADS_PARAMS (
   ID                   INT8                 not null,
   OBJECT_ID            INT8                 not null,
   CHANGE_ID            INT8                 not null,
   CHANGE_ID_END        INT8                 not null,
   TYPE_ID              INT8                 not null,
   type_value           text                 not null,
   UPDATE_DATE          DATE                 not null,
   START_DATE           DATE                 not null,
   END_DATE             DATE                 not null
);

comment on table AS_STEADS_PARAMS is
'Параметры земельных участков';

comment on column AS_STEADS_PARAMS.ID is
'Уникальный идентификатор';

comment on column AS_STEADS_PARAMS.OBJECT_ID is
'Уникальный идентификатор';

comment on column AS_STEADS_PARAMS.CHANGE_ID is
'ID транзакции';

comment on column AS_STEADS_PARAMS.CHANGE_ID_END is
'ID завершающей транзакции';

comment on column AS_STEADS_PARAMS.UPDATE_DATE is
'Дата последнего обновления';

comment on column AS_STEADS_PARAMS.START_DATE is
'Дата начала действия';

comment on column AS_STEADS_PARAMS.END_DATE is
'Дата окончания действия';

alter table AS_STEADS_PARAMS
   add constraint PK_AS_STEADS_PARAMS primary key (ID);
