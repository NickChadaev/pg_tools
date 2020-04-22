/* =================================================================================================== */
/*  DBMS name:      PostgreSQL 8                                                                       */
/*  Created on:     29.05.2015 19:41:23                                                                */
/*      Меняю ind_base_header на ind_type_header                                                       */
/*     Nick 2015-06-24  Ввёл единицу измерения колонки в заголовке типа.                               */   
/*     Nick 2105-08-19  Изменил названия первичного ключа в заголовке типа                             */ 
/*     Nick 2015-08-21  Поисковые индексы по краткому коду и                                           */
/*                      ID показателя и дате начала актуальности                                       */
/*       2015-08-24     Убрано раздельное хранение планового и фактического                            */
/*                      контекстов.                                                                    */
/*       2015-08-25  Исключен интервал актуальности из заголовка экземпляра                            */
/* --------------------------------------------------------------------------------------------------- */
/*  2015-10-03 Произвольное количество контекстов, убраны избыточные атрибуты                          */
/*  2015-10-10 Структура для управления контекстами                                                    */
/*  2015-10-11 Исключены из ind_indicator атрибуты ind_uuid, date_from, date_to                        */  
/*  2015-10-12 Исключена ind_value.date_system_write Nick                                              */
/*  2015-10-20 Исключена ind_base.column_structure Nick                                                */
/*  2015-10-24 Добавил ind_type в заголовок. Изменил  chk_context_sign.                                */
/*  2015-11-14 Добавил date_from, date_to в ind_indicator, ind_base.                                   */  
/*     ind.ind_type_header получила опциональный атрибут для сложного SELECT.                          */
/* --------------------------------------------------------------------------------------------------- */
/*  2016-01-18 Расширен список контекстов. Добавлены: 4, 5, 6, 7   Nick                                */   
/*    Modification: 2016-06-17 Отказ от сущности "ind.ind_context_descr"                               */  
/* --------------------------------------------------------------------------------------------------- */
/* 2016-11-10 Nick, Значение показателя типа t_text (t_arr_values ->  t_arr_text, t_str2048 -> t_text) */
/* --------------------------------------------------------------------------------------------------- */ 
/* 2016-11-12 Узелок на будущее, показатель - это взаимодействие двух объектов Subject + Object:       */
/*               Subject = Object (Либо Subject IS NULL ) - Характеристика - существует сейчас.        */
/*               Subject <> Object - Взаимодействие, необходимо реализовать.                           */
/* --------------------------------------------------------------------------------------------------- */ 
/* 2017-02-18 Узелок реализовывается  subject становится опциональным полем, в характеристике          */
/*    object = subject  во взаимодействии - нет.                                                       */ 
/* --------------------------------------------------------------------------------------------------- */ 
/* 2018-12-21 Nick Новое ядро.  Больше нет аттрибута data_system_write.                                */
/* =================================================================================================== */
SET search_path=ind,nso,com,public,pg_catalog;

/*==============================================================*/
/* Table: ind_type_header                                       */
/*==============================================================*/
DROP TABLE IF EXISTS ind_type_header CASCADE;
DROP SEQUENCE IF EXISTS ind_type_header_column_id_seq CASCADE;

CREATE SEQUENCE ind_type_header_column_id_seq INCREMENT 1 START 1 CACHE 1;
CREATE TABLE ind_type_header (
   column_id          public.id_t          NOT NULL DEFAULT NEXTVAL ('ind_type_header_column_id_seq'),
   parent_column_id   public.id_t              NULL,
   ind_type_id        public.id_t          NOT NULL,
   ind_type_code      public.t_str60       NOT NULL, -- Nick 2015-10-28
   attr_id            public.id_t          NOT NULL,
   column_code        public.t_str60       NOT NULL,
   col_nmb            public.small_t       NOT NULL,
   column_name        public.t_str250      NOT NULL,
   column_scode       public.t_code1       NOT NULL,
   unit_measure_id    public.id_t              NULL,         -- Nick 2015-06-24
   date_from          public.t_timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
   date_to            public.t_timestamp   NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
   column_structure   public.t_arr_id          NULL,
   ind_select         public.t_description     NULL  -- 2015-11-14
);

COMMENT ON TABLE ind.ind_type_header IS 'Каждый типа показателя имеет уникальный заголовок.';

COMMENT ON COLUMN ind_type_header.column_id         IS 'Идентификатор столбца';
COMMENT ON COLUMN ind_type_header.parent_column_id  IS 'Идентификатор родительского столбца';
COMMENT ON COLUMN ind_type_header.ind_type_id       IS 'Идентификатор типа показателя';
COMMENT ON COLUMN ind_type_header.ind_type_code     IS 'Код типа типа показателя'; -- Nick 2015-1-28
COMMENT ON COLUMN ind_type_header.attr_id           IS 'Идентификатор атрибута';
COMMENT ON COLUMN ind_type_header.column_code       IS 'Код колонки';
COMMENT ON COLUMN ind_type_header.col_nmb           IS 'Номер колонки П/П';
COMMENT ON COLUMN ind_type_header.column_name       IS 'Наименование колонки';
COMMENT ON COLUMN ind_type_header.column_scode      IS 'Краткий код типа колонки';
COMMENT ON COLUMN ind_type_header.unit_measure_id   IS 'Единица измерения колонки';
COMMENT ON COLUMN ind_type_header.date_from         IS 'Дата актуальности';
COMMENT ON COLUMN ind_type_header.date_to           IS 'Дата конца актуальности';
COMMENT ON COLUMN ind_type_header.column_structure  IS 'Стуктура колонки';
COMMENT ON COLUMN ind.ind_type_header.ind_type_code IS 'Код типа типа показателя';
COMMENT ON COLUMN ind_type_header.ind_select        IS 'Текст запроса SELECT';

ALTER TABLE ind_type_header  -- Nick 2105-08-19
   ADD CONSTRAINT pk_ind_type_header PRIMARY KEY (column_id);

ALTER TABLE ind_type_header  -- Nick 2105-08-19 
   ADD CONSTRAINT ak1_ind_type_header UNIQUE (attr_id, column_code, ind_type_id);

ALTER SEQUENCE ind_type_header_column_id_seq OWNED BY ind_type_header.column_id; 

CREATE INDEX ie1_ind_type_header ON ind. ind_type_header (ind_type_code); -- Nick 2015-10-28

/*==============================================================*/
/* Table: ind_indicator                                         */
/*==============================================================*/
DROP TABLE IF EXISTS ind_indicator CASCADE;
DROP SEQUENCE IF EXISTS ind_indicator_ind_id_seq CASCADE; 

CREATE SEQUENCE ind_indicator_ind_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
CREATE TABLE ind_indicator (
   ind_id               id_t                 NOT NULL DEFAULT NEXTVAL ('ind_indicator_ind_id_seq'),
   parent_ind_id        id_t                 NULL,
   ind_type_id          id_t                 NOT NULL,
   subject_id           id_t                 NULL,-- 2016-12-11, 2017-02-18, 2017-10-18 Nick
   object_id            id_t                 NOT NULL,
   date_system_write    t_timestamp          NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone
);
   
COMMENT ON TABLE ind_indicator IS 
'Постоянная часть показателя';

COMMENT ON COLUMN ind_indicator.ind_id IS 
'Идентификатор показателя';

COMMENT ON COLUMN ind_indicator.parent_ind_id IS 
'Идентификатор родительского показателя';

COMMENT ON COLUMN ind_indicator.ind_type_id IS 
'Тип показателя';

COMMENT ON COLUMN ind_indicator.subject_id IS 
'Идентификатор субъекта - Воздействующая сущность';

COMMENT ON COLUMN ind_indicator.object_id IS 
'Идентификатор объекта - Сущность Испытывает воздействие';

COMMENT ON COLUMN ind_indicator.date_system_write IS 
'Время записи в систему';

ALTER TABLE ind_indicator
   ADD CONSTRAINT pk_ind_indicator PRIMARY KEY (ind_id);

CREATE INDEX ie2_ind_indicator ON ind.ind_indicator (object_id, subject_id, ind_type_id);

-- 2015-08-21 Nick Добавлен ind_id
/*==============================================================*/
/* Index: ie2_ind_indicator                                     */
/*==============================================================*/
CREATE  INDEX ie1_ind_indicator ON ind_indicator (object_id, ind_id);
-- 2015-08-21 Nick

ALTER SEQUENCE ind_indicator_ind_id_seq OWNED BY ind_indicator.ind_id;


