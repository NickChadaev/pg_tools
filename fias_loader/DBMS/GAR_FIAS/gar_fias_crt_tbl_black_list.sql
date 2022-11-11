/*================================================================================*/
/* DBMS name:      PostgreSQL 13.4                                                */
/* Created on:     11.11.2022 12:34:51                                            */
/*================================================================================*/

SET search_path=gar_fias,unsi,public;
/*==============================================================*/
/* Table:     AS_ADDR_OBJ_TYPE_BLACK_LIST                       */
/*==============================================================*/

DROP TABLE IF EXISTS gar_fias.as_addr_obj_type_black_list CASCADE;
CREATE TABLE gar_fias.as_addr_obj_type_black_list
(
    id             bigint       NOT NULL 
   ,type_name      varchar(250) NOT NULL 
   ,type_shortname varchar(50)  NOT NULL 
   ,type_descr     varchar(250) 
   ,update_date    date NOT NULL 
   ,start_date     date NOT NULL 
   ,end_date       date NOT NULL 
   ,is_active      boolean NOT NULL 
   ,fias_row_key   text    NOT NULL 
   ,object_kind    char(1) NOT NULL DEFAULT '0' -- адресные пространства
);

ALTER TABLE gar_fias.as_addr_obj_type_black_list
           ADD CONSTRAINT pk_as_addr_obj_type_black_list PRIMARY KEY (fias_row_key, object_kind);

COMMENT ON TABLE gar_fias.as_addr_obj_type_black_list
    IS 'Типы адресных объектов, запрещённые для импорта';

COMMENT ON COLUMN gar_fias.as_addr_obj_type_black_list.id
    IS 'Идентификатор записи ';

COMMENT ON COLUMN gar_fias.as_addr_obj_type_black_list.type_name
    IS 'Полное наименование типа объекта';

COMMENT ON COLUMN gar_fias.as_addr_obj_type_black_list.type_shortname
    IS 'Краткое наименование типа объекта';

COMMENT ON COLUMN gar_fias.as_addr_obj_type_black_list.type_descr
    IS 'Описание';

COMMENT ON COLUMN gar_fias.as_addr_obj_type_black_list.update_date
    IS 'Дата внесения (обновления) записи';

COMMENT ON COLUMN gar_fias.as_addr_obj_type_black_list.start_date
    IS 'Начало действия записи';

COMMENT ON COLUMN gar_fias.as_addr_obj_type_black_list.end_date
    IS 'Окончание действия записи';

COMMENT ON COLUMN gar_fias.as_addr_obj_type_black_list.is_active
    IS 'Статус активности';
    
COMMENT ON COLUMN gar_fias.as_addr_obj_type_black_list.fias_row_key
    IS 'Текстовый ключ строки';

COMMENT ON COLUMN gar_fias.as_addr_obj_type_black_list.object_kind
    IS 'Вид объекта: 0-адресные пространства, 1-улицы';
    
/*==============================================================*/
/* Table: AS_HOUSE_TYPE_BLACK_LIST                              */
/*==============================================================*/
DROP TABLE IF EXISTS gar_fias.as_house_type_black_list;
CREATE TABLE gar_fias.as_house_type_black_list
(
     house_type_id  bigint      NOT NULL 
    ,type_name      varchar(50) NOT NULL 
    ,type_shortname varchar(20) 
    ,type_descr     varchar(250) 
    ,update_date    date    NOT NULL 
    ,start_date     date    NOT NULL 
    ,end_date       date    NOT NULL 
    ,is_active      boolean NOT NULL 
    ,fias_row_key   text    NOT NULL 
);

ALTER TABLE gar_fias.as_house_type_black_list
  ADD CONSTRAINT pk_as_house_type_back_list PRIMARY KEY (fias_row_key);    

COMMENT ON TABLE gar_fias.as_house_type_black_list
    IS 'Признаки владения (Типы домов), список типов, запретных для импорта';

COMMENT ON COLUMN gar_fias.as_house_type_black_list.house_type_id
    IS 'ID Признака владения';

COMMENT ON COLUMN gar_fias.as_house_type_black_list.type_name
    IS 'Наименование';

COMMENT ON COLUMN gar_fias.as_house_type_black_list.type_shortname
    IS 'Краткое наименование';

COMMENT ON COLUMN gar_fias.as_house_type_black_list.update_date
    IS 'Дата внесения (обновления) записи';

COMMENT ON COLUMN gar_fias.as_house_type_black_list.start_date
    IS 'Начало действия записи';

COMMENT ON COLUMN gar_fias.as_house_type_black_list.end_date
    IS 'Окончание действия записи';

COMMENT ON COLUMN gar_fias.as_house_type_black_list.is_active
    IS 'Статус активности';
  
COMMENT ON COLUMN gar_fias.as_house_type_black_list.fias_row_key
    IS 'Текстовый ключ строки';
  
