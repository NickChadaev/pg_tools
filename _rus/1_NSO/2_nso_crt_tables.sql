/* ================================================================================================== */
/* DBMS name:      PostgreSQL 8                                                                       */
/* Created on:     10.02.2015 18:25:11                                                                */
/* -------------------------------------------------------------------------------------------------- */
/*  2015-03-19     Дополнения                                                                         */ 
/* -------------------------------------------------------------------------------------------------- */
/*  2015-05-29     Переношу в COM  nso_domain_column                                                  */
/*                 Добавляю краткий код в заголовок НСО                                               */
/*  2015_06_16 Модификация nso_blob                                                                   */
/*  2015_07_04 Index: ak1_nso_column_head   Убрал Nick.                                               */
/*  2015-07-27 Убрал всё, что относится к обмену данными.                                             */ 
/*  2015-09-24 Новое событие, создание данных                                                         */
/*  2015-10-06 nso_ref.ref_rec_id  null  Nick                                                         */
/* -------------------------------------------------------------------------------------------------- */
/* 2016-04-01 Gregory Добавляем атрибуты "date_from", "date_to"                                       */
/*              в nso_column_head, nso.nso_key_attr                                                   */
/* -------------------------------------------------------------------------------------------------- */
/* 2016-05-16 Nick добавлены события экспорта и импорта НСО.                                          */
/* 2016-05-28 Nick Общая sequence для всех исторических таблиц.                                       */
/* -------------------------------------------------------------------------------------------------- */
/* 2016-07-14 Gregory & Nick nso_object.                                                              */ 
/* unique_check boolean_t DEFAULT false. Признак контроля уникальности.                               */
/*  ------------------------------------------------------------------------------------------------  */
/*  2016-07-19 Nick добавлены события  включения контроля уникальности,                               */ 
/*                  выключения контроля уникальности.                                                 */
/* -------------------------------------------------------------------------------------------------- */
/* 2016-11-07 Nick  Общая последовательность для исторических таблиц и LOG.                           */
/*      Все LOG таблицы наследуют от "ALL_LOG".                                                       */
/* -------------------------------------------------------------------------------------------------- */
/* 2016-11-12 Nick, Абсолютное значение типа t_text (t_arr_values -> t_arr_text, t_str2048 -> t_text) */
/* -------------------------------------------------------------------------------------------------- */
/* 2017-01-25 Nick  Impact_descr типа t_text                                                          */
/* -------------------------------------------------------------------------------------------------- */
/* 2017-05-26 Nick  ak1_nso_column_head UNIQUE ( nso_id, col_code );                                  */
/* -------------------------------------------------------------------------------------------------- */
/* 2018-01-29 Nick nso_log нет собственных атрибутов.                                                 */
/* 2018-12-18 Nick Новый проект.                                                                      */ 
/* -------------------------------------------------------------------------------------------------- */
/* 2019-05-29 Nick Новое ядро, "nso_abs"  секционируется, "nso_blob" - под вопросом                   */ 
/* -------------------------------------------------------------------------------------------------- */
/* 2019-07-11 Nick Новое ядро,  Декларативное секционирование "nso_data.nso_abs".                     */
/*      Дополнительный атрибут "nso_strct.nso_object.section_number".                                 */
/*      Отдельная сущность "nso_data_section", "section_number"  <->  "section_sign".                 */
/*      Функционал на базе этой сущности обеспечивает создание секций, удаление,                      */
/*      создание PK, индексов, триггерных функций.                                                    */
/*            "nso_data.nso_record" получает дополнительный атрибут "section_sign".                   */
/*            "nso_data.nso_abs" получает дополнительный атрибут "section_sign".                      */
/*      Все функции отображения пересматриваются и в выражении участвует "section_sign".              */
/*      Секция №0 сушествуетт всегда, остальные по мере необходимости.                                */
/*      Секционируется и "nso_data.nso_blob", иначе будет сильно тормозить запросы.                   */
/* -------------------------------------------------------------------------------------------------- */
/*  2020-01-16 Начальные секции                                                                       */
/*  2020-01-21 Номер секции является единственным атрибутом, section_sign - исключается               */
/*             section_number имеет нативный тип "int2"                                               */
/* -------------------------------------------------------------------------------------------------- */
/*  2020-04-07 Nick Не забывать про установку имени схемы (по умолчанию) в LOG-таблицах.              */
/*=================================================================================================== */
SET search_path=nso,com,public,pg_catalog;

DROP SEQUENCE IF EXISTS nso.nso_object_nso_id_seq CASCADE;
CREATE SEQUENCE nso.nso_object_nso_id_seq INCREMENT 1 START 1;
/*==============================================================*/
/* Table: nso_object                                            */
/*==============================================================*/
DROP TABLE IF EXISTS nso_object CASCADE;
CREATE TABLE nso_object (
   nso_id             public.id_t   DEFAULT nextval('nso.nso_object_nso_id_seq'::regclass) NOT NULL,
   parent_nso_id      public.id_t             NULL,
   nso_type_id        public.id_t             NOT NULL,
   nso_uuid           public.t_guid           NOT NULL,
   date_create        public.t_timestamp      NOT NULL DEFAULT CURRENT_TIMESTAMP::public.t_timestamp,
   nso_release        public.small_t          NOT NULL DEFAULT 0,
   active_sign        public.t_boolean        NOT NULL DEFAULT FALSE,   
   is_group_nso       public.t_boolean        NOT NULL DEFAULT FALSE,
   is_intra_op        public.t_boolean        NOT NULL DEFAULT FALSE,
   is_m_view          public.t_boolean        NOT NULL DEFAULT FALSE, -- 2015-04-26
   unique_check       public.t_boolean        NOT NULL DEFAULT FALSE, -- 2016-07-14
   nso_code           public.t_str60          NOT NULL,
   nso_name           public.t_str250         NOT NULL,
   nso_select         public.t_text           NULL,                 -- 2015-05-13 Было 2048  Nick
   section_number     int2                    NOT NULL DEFAULT 0,   -- Nick 2019-05-29/2019-07-11/2020-01-21
   date_from          public.t_timestamp      NOT NULL DEFAULT CURRENT_TIMESTAMP::public.t_timestamp,
   date_to            public.t_timestamp      NOT NULL DEFAULT '9999-12-31 00:00:00'::public.t_timestamp,
   id_log             public.id_t             NOT NULL DEFAULT 0
);

COMMENT ON TABLE nso_object IS 'Нормативно-справочный объект';

COMMENT ON COLUMN nso_object.nso_id           IS 'Идентификатор НСО';
COMMENT ON COLUMN nso_object.parent_nso_id    IS 'Идентификатор родительского НСО';
COMMENT ON COLUMN nso_object.nso_type_id      IS 'Тип НСО';
COMMENT ON COLUMN nso_object.nso_uuid         IS 'UUID НСО';
COMMENT ON COLUMN nso_object.date_create      IS 'Дата создания-обновления';
COMMENT ON COLUMN nso_object.nso_release      IS 'Версия НСО';
COMMENT ON COLUMN nso_object.active_sign      IS 'Признак активного НСО';
COMMENT ON COLUMN nso_object.is_group_nso     IS 'Признак узлового НСО';
COMMENT ON COLUMN nso_object.is_intra_op      IS 'Признак интраоперабельности';
COMMENT ON COLUMN nso_object.is_m_view        IS 'Признак материализованного представления';
COMMENT ON COLUMN nso_object.unique_check     IS 'Признак контроля уникальности'; -- Nick 2016-07-14
COMMENT ON COLUMN nso_object.nso_code         IS 'Код НСО';
COMMENT ON COLUMN nso_object.nso_name         IS 'Наименование НСО';
COMMENT ON COLUMN nso_object.nso_select       IS 'Текст запроса SELECT';
COMMENT ON COLUMN nso_object.section_number   IS 'Номер секции';   -- Nick 2019-05-29
COMMENT ON COLUMN nso_object.date_from        IS 'Дата начала актуальности';
COMMENT ON COLUMN nso_object.date_to          IS 'Дата конца актуальности';
COMMENT ON COLUMN nso_object.id_log           IS 'Идентификатор журнала';

ALTER TABLE nso_object
   ADD CONSTRAINT pk_nso_object PRIMARY KEY (nso_id);

/*==============================================================*/
/* Index: ak1_nso_object                                        */
/*==============================================================*/
CREATE UNIQUE INDEX ak1_nso_object ON nso_object (nso_code);

/*==============================================================*/
/* Index: ak2_nso_object                                        */
/*==============================================================*/
CREATE UNIQUE INDEX ak2_nso_object ON nso_object (nso_name);

/*==============================================================*/
/* Index: ak3_nso_object                                        */
/*==============================================================*/
CREATE UNIQUE INDEX ak3_nso_object ON nso_object (nso_uuid);

/*==============================================================*/
/* Index: ie1_nso_object                                        */
/*==============================================================*/
CREATE  INDEX ie1_nso_object ON nso_object (date_from);

/*==============================================================*/
/* Table: nso_object_hist                                       */
/*==============================================================*/
DROP TABLE IF EXISTS nso_object_hist CASCADE;
CREATE TABLE nso_object_hist (
   obj_hist_id  public.id_t  NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'::regclass)
)
inherits (nso_object);

COMMENT ON TABLE nso_object_hist IS 'История объекта';

COMMENT ON COLUMN nso_object_hist.obj_hist_id IS 'Идентификатор историии НСO';

ALTER TABLE nso_object_hist
   ADD CONSTRAINT pk_nso_object_hist PRIMARY KEY (obj_hist_id);
-- ---------------------------------------------------------------

DROP SEQUENCE IF EXISTS nso.nso_column_head_col_id_seq CASCADE;
CREATE SEQUENCE nso.nso_column_head_col_id_seq INCREMENT 1 START 1;
/*==============================================================*/
/* Table: nso_column_head                                       */
/*==============================================================*/
DROP TABLE IF EXISTS nso_column_head CASCADE;
CREATE TABLE nso_column_head (
   col_id          public.id_t DEFAULT nextval('nso.nso_column_head_col_id_seq'::regclass) NOT NULL,
   parent_col_id   public.id_t                     NULL,
   attr_id         public.id_t                 NOT NULL,
   attr_scode      public.t_code1              NOT NULL,
   nso_id          public.id_t                 NOT NULL,
   col_code        public.t_str60              NOT NULL,
   col_name        public.t_str250             NOT NULL, -- Имя колонки
   number_col      public.small_t              NOT NULL DEFAULT 0,
   mandatory       public.t_boolean            NOT NULL DEFAULT FALSE,
   date_from       public.t_timestamp  NOT NULL DEFAULT (now())::public.t_timestamp, -- 2016-04-01 Gregory
   date_to         public.t_timestamp  NOT NULL DEFAULT '9999-12-31 00:00:00'::public.t_timestamp,
   log_id          public.id_t                 NOT NULL DEFAULT 0
);

COMMENT ON TABLE nso_column_head IS 'Колонка НСО';

COMMENT ON COLUMN nso_column_head.col_id        IS 'Идентификатор колонки';
COMMENT ON COLUMN nso_column_head.parent_col_id IS 'Идентификатор родительской колонки';
COMMENT ON COLUMN nso_column_head.attr_id       IS 'Идентификатор атрибута';
COMMENT ON COLUMN nso_column_head.attr_scode    IS 'Краткий код типа атрибута'; -- 2015-05-29
COMMENT ON COLUMN nso_column_head.nso_id        IS 'Идентификатор НСО';
COMMENT ON COLUMN nso_column_head.col_code      IS 'Код колонки';
COMMENT ON COLUMN nso_column_head.col_name      IS 'Имя колонки';
COMMENT ON COLUMN nso_column_head.number_col    IS 'Номер колонки';
COMMENT ON COLUMN nso_column_head.mandatory     IS 'Обязательность заполнения';
-- 2016-04-01 Gregory
COMMENT ON COLUMN nso.nso_column_head.date_from IS 'Дата начала актуальности';
COMMENT ON COLUMN nso.nso_column_head.date_to   IS 'Дата конца актуальности';
-- 2016-04-01 Gregory
COMMENT ON COLUMN nso_column_head.log_id        IS 'Идентификатор журнала';

ALTER TABLE nso_column_head
   ADD CONSTRAINT pk_nso_column_head PRIMARY KEY (col_id);

ALTER TABLE nso.nso_column_head ADD CONSTRAINT ak1_nso_column_head UNIQUE ( nso_id, col_code ); -- 2017-05-26 Nick
--
-- 2015-04-26
--
/*==============================================================*/
/* Index: ie2_nso_column_head                                   */
/*==============================================================*/
CREATE  INDEX ie2_nso_column_head ON nso_column_head (col_name);

/*==============================================================*/
/* Table: nso_column_head_hist                                  */
/*==============================================================*/
DROP TABLE IF EXISTS nso_column_head_hist CASCADE;
CREATE TABLE nso_column_head_hist (
   col_hist_id  public.id_t  NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'::regclass) -- 
)
inherits (nso_column_head);

COMMENT ON TABLE nso_column_head_hist IS 'История колонки';

COMMENT ON COLUMN nso_column_head_hist.col_hist_id IS 'Идентификатор истории колонки';

ALTER TABLE nso_column_head_hist
   ADD CONSTRAINT pk_nso_column_head_hist PRIMARY KEY (col_hist_id);

-- ----------------------------------------------------------------
DROP SEQUENCE IF EXISTS nso.nso_key_key_id_seq CASCADE;
CREATE SEQUENCE nso.nso_key_key_id_seq INCREMENT 1 START 1;
/*==============================================================*/
/* Table: nso_key                                               */
/*==============================================================*/
DROP TABLE IF EXISTS nso_key CASCADE;
CREATE TABLE nso_key (
   key_id          public.id_t DEFAULT nextval('nso.nso_key_key_id_seq'::regclass) NOT NULL,
   nso_id          public.id_t           NOT NULL,
   key_type_id     public.id_t           NOT NULL,
   key_small_code  public.t_code1        NOT NULL, -- 2015-03-19  Краткий код типа ключа
   key_code        public.t_str60        NOT NULL, -- 2015-03-19  
   on_off          public.t_boolean      NOT NULL DEFAULT TRUE,
   date_from       public.t_timestamp    NOT NULL DEFAULT now()::public.t_timestamp,                  -- 2015-03-19  
   date_to         public.t_timestamp    NOT NULL DEFAULT '9999-12-31 00:00:00'::public.t_timestamp,  -- 2015-03-19  
   log_id          public.id_t           NOT NULL DEFAULT 0
);

COMMENT ON TABLE nso_key IS 'Ключ';

COMMENT ON COLUMN nso_key.key_id         IS 'Идентификатор ключевого атрибута';
COMMENT ON COLUMN nso_key.nso_id         IS 'Идентификатор НСО';
COMMENT ON COLUMN nso_key.key_type_id    IS 'Идентификатор типа ключа';
COMMENT ON COLUMN nso_key.key_small_code IS 'Краткий код типа ключа';               -- 2015-03-19  
COMMENT ON COLUMN nso_key.key_code       IS 'Актуальный код ключа';                   
COMMENT ON COLUMN nso_key.date_from      IS 'Дата начала периода актуальности';      
COMMENT ON COLUMN nso_key.date_to        IS 'Дата завершения периода актуальности';  
COMMENT ON COLUMN nso_key.on_off         IS 'Состояние';
COMMENT ON COLUMN nso_key.log_id         IS 'Идентификатор журнала';

ALTER TABLE nso_key
   ADD CONSTRAINT pk_nso_key PRIMARY KEY (key_id);
/*==============================================================*/
/* Index: ak1_nso_key  2015-03-21 Nick                          */
/*==============================================================*/
CREATE UNIQUE INDEX ak1_nso_key ON nso_key (key_code);
------------------------------------------------------------------
/*==============================================================*/
/* Table: nso_key_attr                                          */
/*==============================================================*/
DROP TABLE IF EXISTS nso_key_attr CASCADE;
create table nso_key_attr (
     key_id        public.id_t         NOT NULL,
     col_id        public.id_t         NOT NULL,
     column_nm     public.small_t      NOT NULL DEFAULT 0,
     -- 2016-04-01 Gregory
     date_from     public.t_timestamp  NOT NULL DEFAULT (now())::public.t_timestamp,
     date_to       public.t_timestamp  NOT NULL DEFAULT '9999-12-31 00:00:00'::public.t_timestamp,
     -- 2016-04-01 Gregory 
     log_id        public.id_t         NOT NULL DEFAULT 0
);

COMMENT ON TABLE nso_key_attr IS 'Элемент ключа';

COMMENT ON COLUMN nso_key_attr.key_id    IS 'Идентификатор ключевого атрибута';
COMMENT ON COLUMN nso_key_attr.col_id    IS 'Идентификатор колонки';
COMMENT ON COLUMN nso_key_attr.column_nm IS 'Номер колонки';

-- 2016-04-01 Gregory
COMMENT ON COLUMN nso.nso_key_attr.date_from IS 'Дата начала актуальности';
COMMENT ON COLUMN nso.nso_key_attr.date_to   IS 'Дата конца актуальности';
-- 2016-04-01 Gregory

COMMENT ON COLUMN nso_key_attr.log_id is 'Идентификатор журнала';

ALTER TABLE nso_key_attr
   ADD CONSTRAINT pk_nso_key_attr PRIMARY KEY (key_id, col_id);

/*==============================================================*/
/* Table: nso_key_attr_hist                                     */
/*==============================================================*/
DROP TABLE IF EXISTS nso_key_attr_hist CASCADE;
CREATE TABLE nso_key_attr_hist (
   key_attr_hist_id  public.id_t  NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'::regclass)
   
) INHERITS (nso_key_attr);

COMMENT ON TABLE nso_key_attr_hist IS 'История элемента ключевой колонки';

COMMENT ON COLUMN nso_key_attr_hist.key_attr_hist_id IS  'Идентификатор истории';

ALTER TABLE nso_key_attr_hist
   ADD CONSTRAINT pk_nso_key_attr_hist PRIMARY KEY (key_attr_hist_id);

/*==============================================================*/
/* Table: nso_key_hist                                          */
/*==============================================================*/
DROP TABLE IF EXISTS nso_key_hist CASCADE;
CREATE TABLE nso_key_hist (
   key_hist_id  public.id_t  NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'::regclass)
)
inherits (nso_key);

COMMENT ON TABLE nso_key_hist IS 'История ключевой колонки';

COMMENT ON COLUMN nso_key_hist.key_hist_id IS 'Идентификатор истории ключевой колонки';

ALTER TABLE nso_key_hist
   ADD CONSTRAINT pk_nso_key_hist PRIMARY KEY (key_hist_id);
--
DROP SEQUENCE IF EXISTS nso.nso_record_rec_id_seq CASCADE;
CREATE SEQUENCE nso.nso_record_rec_id_seq INCREMENT 1 START 1; 
/*==============================================================*/
/* Table: nso_record                                            */
/*==============================================================*/
DROP TABLE IF EXISTS nso_record CASCADE;
CREATE TABLE nso_record (
   rec_id          public.id_t   DEFAULT nextval ('nso.nso_record_rec_id_seq'::regclass) NOT NULL,
   parent_rec_id   public.id_t          NULL,
   rec_uuid        public.t_guid        NOT NULL,
   nso_id          public.id_t          NOT NULL,
   actual          public.t_boolean     NOT NULL DEFAULT TRUE,
   section_number  int2                 NOT NULL DEFAULT 0,     -- Nick 2019-07-11
   date_from       public.t_timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP::public.t_timestamp,
   date_to         public.t_timestamp   NOT NULL DEFAULT '9999-12-31 00:00:00'::public.t_timestamp,
   log_id          public.id_t          NOT NULL DEFAULT 0 
);

COMMENT ON TABLE nso_record IS 'НСО Запись';

COMMENT ON COLUMN nso_record.rec_id          IS 'Идентификатор  записи';
COMMENT ON COLUMN nso_record.parent_rec_id   IS 'Идентификатор родительской  записи';
COMMENT ON COLUMN nso_record.rec_uuid        IS 'UUID записи';
COMMENT ON COLUMN nso_record.nso_id          IS 'Идентификатор НСО';
COMMENT ON COLUMN nso_record.actual          IS 'Актуальность записи';
COMMENT ON COLUMN nso_record.section_number  IS 'Номер секции';
COMMENT ON COLUMN nso_record.date_from       IS 'Дата начала актуальности';
COMMENT ON COLUMN nso_record.date_to         IS 'Дата конца актуальности';
COMMENT ON COLUMN nso_record.log_id          IS 'Идентификатор журнала';

ALTER TABLE nso_record
   ADD CONSTRAINT pk_nso_record PRIMARY KEY (rec_id);

/*==============================================================*/
/* Index: ak1_nso_record                                        */
/*==============================================================*/
CREATE UNIQUE INDEX ak1_nso_record on nso_record (rec_uuid);

/*==============================================================*/
/* Index: ie1_nso_record                                        */
/*==============================================================*/
CREATE  INDEX ie1_nso_record on nso_record (date_from);
-- ----------
-- 2015-05-05
-- ----------
/*==============================================================*/
/* Index: ie2_nso_record                                        */
/*==============================================================*/
CREATE  INDEX ie2_nso_record on nso_record (nso_id);

/*==============================================================*/
/* Table: nso_record_hist                                       */
/*==============================================================*/
DROP TABLE IF EXISTS nso_record_hist CASCADE;
CREATE TABLE nso_record_hist (
   rec_hist_id  public.id_t  NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'::regclass)
)
inherits (nso_record);

ALTER TABLE nso.nso_record_hist
   ADD CONSTRAINT pk_nso_record_hist PRIMARY KEY (rec_hist_id);

COMMENT ON TABLE nso_record_hist IS 'История изменений записей НСО';

COMMENT ON COLUMN nso_record_hist.rec_hist_id IS 'Идентификатор историии записи';
 
/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     11.07.2016 10:20:09                          */
/* -------------------------------------------------------------*/
/* Расскомментарить строки в конце скрипта !!!                  */
/*==============================================================*/

DROP TABLE IF EXISTS nso_record_unique;
/*==============================================================*/
/* Table: nso_record_unique                                     */
/*==============================================================*/
CREATE TABLE nso_record_unique (
   rec_id        public.id_t        NOT NULL,
   scode         public.t_code1     NOT NULL,
   unique_check  public.t_boolean   NOT NULL DEFAULT FALSE
);

COMMENT ON TABLE nso_record_unique IS 'НСО Запись Уникальность';

COMMENT ON COLUMN nso_record_unique.rec_id       IS 'Идентификатор  записи';
COMMENT ON COLUMN nso_record_unique.scode        IS 'Краткий код';
COMMENT ON COLUMN nso_record_unique.unique_check IS 'Признак контроля уникальности';

ALTER TABLE nso_record_unique
   ADD CONSTRAINT pk_nso_record_unique PRIMARY KEY (rec_id, scode);

/*==============================================================*/
/* Index: ak1_nso_record_unique                                 */
/*==============================================================*/
DROP INDEX IF EXISTS ak1_nso_record_unique;
CREATE UNIQUE INDEX ak1_nso_record_unique ON nso.nso_record_unique (
     scode,
     unique_check,
     nso_data.nso_f_nso_record_unique_sign_idx ( rec_id, scode )
)
WHERE unique_check IS TRUE;
--
/*==============================================================*/
/* Table: nso_abs                                               */
/*==============================================================*/
DROP TABLE IF EXISTS nso_abs CASCADE;
CREATE TABLE nso_abs (
   rec_id          public.id_t        NOT NULL,
   col_id          public.id_t        NOT NULL,
   s_type_code     public.t_code1     NOT NULL,
   s_key_code      public.t_code1     NOT NULL DEFAULT '0',
   section_number  int2               NOT NULL DEFAULT 0,   -- Nick 2019-07-11/2020-01-21
   is_actual       public.t_boolean   NOT NULL DEFAULT TRUE,
   log_id          public.id_t        NOT NULL DEFAULT 0,
   val_cell_abs    public.t_text      NULL  -- Nick 2016-11-12 t_str2048  
) PARTITION BY LIST (section_number);

COMMENT ON TABLE nso_abs IS 'Значение абсолютное';

COMMENT ON COLUMN nso_abs.rec_id         IS 'ID  записи';
COMMENT ON COLUMN nso_abs.col_id         IS 'ID колонки';
COMMENT ON COLUMN nso_abs.s_type_code    IS 'Код типа';
COMMENT ON COLUMN nso_abs.s_key_code     IS 'Код ключа';
COMMENT ON COLUMN nso_abs.section_number IS 'Номер секции';
COMMENT ON COLUMN nso_abs.is_actual      IS 'Признак актуальности';
COMMENT ON COLUMN nso_abs.log_id         IS 'Идентификатор журнала';
COMMENT ON COLUMN nso_abs.val_cell_abs   IS 'Значение';
-- 
-- 2020-01-21
-- В версии 10 родительская таблица не должна иметь ни первичных ключей, ни индексов
-- 2020-03-30 пЕРЕШЛИ НА 12
ALTER TABLE nso.nso_abs
   ADD CONSTRAINT pk_nso_abs PRIMARY KEY (section_number, rec_id, col_id);

--
CREATE TABLE nso.nso_abs_0 PARTITION OF nso.nso_abs FOR VALUES IN (0);  -- 2020-01-16 Начальная секция
COMMENT ON TABLE nso.nso_abs_0 IS 'Значение абсолютное, секция №0';
--

/*==============================================================*/
/* Table: nso_abs_hist                                          */
/*==============================================================*/
DROP TABLE IF EXISTS nso_abs_hist CASCADE;
CREATE TABLE nso_abs_hist (
   rec_id          public.id_t        NOT NULL,
   col_id          public.id_t        NOT NULL,
   s_type_code     public.t_code1     NOT NULL,
   s_key_code      public.t_code1     NOT NULL,
   section_number  int2               NOT NULL,  -- Nick 2019-07-11/2020-01-21
   is_actual       public.t_boolean   NOT NULL,
   log_id          public.id_t        NOT NULL,
   val_cell_abs    public.t_text      NULL,       -- Nick 2016-11-12 t_str2048  
   --
   abs_hist_id public.id_t            NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'::regclass)
);

COMMENT ON TABLE nso_abs_hist IS 'История абсолютного значения';

COMMENT ON COLUMN nso_abs_hist.rec_id         IS 'ID  записи';
COMMENT ON COLUMN nso_abs_hist.col_id         IS 'ID колонки';
COMMENT ON COLUMN nso_abs_hist.s_type_code    IS 'Код типа';
COMMENT ON COLUMN nso_abs_hist.s_key_code     IS 'Код ключа';
COMMENT ON COLUMN nso_abs_hist.section_number IS 'Номер секции';
COMMENT ON COLUMN nso_abs_hist.is_actual      IS 'Признак актуальности';
COMMENT ON COLUMN nso_abs_hist.log_id         IS 'Идентификатор журнала';
COMMENT ON COLUMN nso_abs_hist.val_cell_abs   IS  'Значение';
--
COMMENT ON COLUMN nso_abs_hist.abs_hist_id  IS 'Идентификатор истории ячейки';

ALTER TABLE nso_abs_hist
   ADD CONSTRAINT pk_nso_abs_hist PRIMARY KEY (abs_hist_id);

--
--  2015-06-16/2019-07-11 Nick модификация
--
/*==============================================================*/
/* Table: nso_blob                                              */
/*==============================================================*/
DROP TABLE IF EXISTS nso_blob CASCADE;
CREATE TABLE nso_blob (
  rec_id             public.id_t       NOT NULL,              -- ID записи
  col_id             public.id_t       NOT NULL,              -- ID колонки
  is_actual          public.t_boolean  NOT NULL DEFAULT true, -- Признак актуальности
  log_id             public.id_t       NOT NULL DEFAULT 0,    -- Идентификатор журнала
  s_type_code        public.t_code1    NOT NULL DEFAULT '0',  -- Тип электронной копии
  section_number     int2              NOT NULL DEFAULT 0,    -- Признак секции  2019-07-11/2020-01-21 Nick
  val_cel_hash       public.t_str100       NULL,              -- MD5 контрольная сумма (для проверки целостности данных)
  val_cel_data_name  public.t_fullname     NULL,              -- Имя файла
  val_cell_blob      public.t_blob         NULL               -- Значение
 ) PARTITION BY LIST (section_number);

COMMENT ON TABLE nso_blob IS 'Значение большое';

COMMENT ON COLUMN nso_blob.rec_id            IS 'ID записи';
COMMENT ON COLUMN nso_blob.col_id            IS 'ID колонки';
COMMENT ON COLUMN nso_blob.is_actual         IS 'Признак актуальности';
COMMENT ON COLUMN nso_blob.log_id            IS 'Идентификатор журнала';
COMMENT ON COLUMN nso_blob.s_type_code       IS 'Тип электронной копии';      
COMMENT ON COLUMN nso_blob.section_number    IS 'Номер секции';
COMMENT ON COLUMN nso_blob.val_cel_hash      IS 'MD5 контрольная сумма (для проверки целостности данных)';
COMMENT ON COLUMN nso_blob.val_cel_data_name IS 'Имя файла';
COMMENT ON COLUMN nso_blob.val_cell_blob     IS 'Значение';

ALTER TABLE nso_blob
   ADD CONSTRAINT pk_nso_blob PRIMARY KEY (section_number, rec_id, col_id);
-- 
-- 2020-01-21
-- В версии 10 родительская таблица не должна иметь ни первичных ключей, ни индексов
-- 2020-03-30  перешли на 12
--
CREATE TABLE nso.nso_blob_0 PARTITION OF nso.nso_blob FOR VALUES IN (0); -- 2020-01-16 Начальная секция
COMMENT ON TABLE nso.nso_blob_0 IS 'Значение большое, секция №0';

/*==============================================================*/
/* Table: nso_blob_hist                                         */
/*==============================================================*/
DROP TABLE IF EXISTS nso_blob_hist CASCADE;
CREATE TABLE nso_blob_hist (
  rec_id             public.id_t       NOT NULL,    -- ID записи
  col_id             public.id_t       NOT NULL,    -- ID колонки
  is_actual          public.t_boolean  NOT NULL,    -- Признак актуальности
  log_id             public.id_t       NOT NULL,    -- Идентификатор журнала
  s_type_code        public.t_code1    NOT NULL,    -- Тип электронной копии
  section_number     int2              NOT NULL,    -- Номер секции  Nick 2019-07-11/2020-01-21
  val_cel_hash       public.t_str100       NULL,    -- MD5 контрольная сумма (для проверки целостности данных)
  val_cel_data_name  public.t_fullname     NULL,    -- Имя файла
  val_cell_blob      public.t_blob         NULL,    -- Значение
  --
  blob_hist_id       public.id_t  NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'::regclass)
);

COMMENT ON TABLE nso_blob_hist IS 'История изменений большого значения';

ALTER TABLE nso_blob_hist
   ADD CONSTRAINT pk_nso_blob_hist PRIMARY KEY (blob_hist_id);
--
/*==============================================================*/
/* Table: nso_ref                                               */
/*==============================================================*/
DROP TABLE IF EXISTS nso_ref CASCADE;
CREATE TABLE nso_ref (
   rec_id       public.id_t        NOT NULL,
   col_id       public.id_t        NOT NULL,
   is_actual    public.t_boolean   NOT NULL DEFAULT TRUE,
   log_id       public.id_t        NOT NULL DEFAULT 0, -- Nick 2015-04-24
   ref_rec_id   public.id_t        -- not null   2015-10-06 Nick
);

COMMENT ON TABLE nso_ref IS 'Значение ссылочное';

COMMENT ON COLUMN nso_ref.rec_id     IS 'ID записи';
COMMENT ON COLUMN nso_ref.col_id     IS 'ID колонки';
COMMENT ON COLUMN nso_ref.is_actual  IS 'Признак актуальности';
COMMENT ON COLUMN nso_ref.log_id     IS 'Идентификатор журнала';
COMMENT ON COLUMN nso_ref.ref_rec_id IS 'Значение ссылка';

ALTER TABLE nso_ref
   ADD CONSTRAINT pk_nso_ref PRIMARY KEY (rec_id, col_id);

/*==============================================================*/
/* Table: nso_ref_hist                                          */
/*==============================================================*/
DROP TABLE IF EXISTS nso_ref_hist CASCADE;
CREATE TABLE nso_ref_hist (
   ref_hist_id  public.id_t  NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'::regclass)
)
inherits (nso_ref);

COMMENT ON TABLE nso_ref_hist IS 'История изменений значения-ссылки';

COMMENT ON COLUMN nso_ref_hist.ref_hist_id IS 'Идентификатор истории ячейки';

ALTER TABLE nso_ref_hist
   ADD CONSTRAINT pk_nso_ref_hist PRIMARY KEY (ref_hist_id);
--
/*==============================================================*/
/* Table: nso_log                                               */
/*==============================================================*/
DROP TABLE IF EXISTS nso_log CASCADE;

CREATE TABLE nso_log (  -- 2018-01-29 Nick нет собственных атрибутов.
) inherits (com.all_log);

COMMENT ON TABLE nso_log IS 'Журнал учёта изменений, схема НСО';

ALTER TABLE nso.nso_log
	ADD CONSTRAINT pk_nso_log PRIMARY KEY (id_log);
	
ALTER TABLE nso.nso_log ALTER COLUMN schema_name SET DEFAULT 'NSO'; -- Nick 2020-0407	
--
DROP SEQUENCE IF EXISTS nso.section_number_seq CASCADE;
CREATE SEQUENCE nso.section_number_seq AS int2 INCREMENT 1 START 1;
--
DROP TABLE IF EXISTS nso_section CASCADE;
/*==============================================================*/
/* Table: nso_section                                           */
/*==============================================================*/
CREATE TABLE nso_section (
   section_number   int2 NOT NULL DEFAULT nextval ('nso.section_number_seq'::regclass),
   crt_on_nso_abs   public.t_boolean    NOT NULL DEFAULT true,
   crt_on_nso_blob  public.t_boolean    NOT NULL DEFAULT false,
   date_from        public.t_timestamp  NOT NULL DEFAULT now()::public.t_timestamp,
   date_to          public.t_timestamp  NOT NULL DEFAULT '9999-12-31 00:00:00'::public.t_timestamp,
   section_descr    public.t_text,
   crt_table_1      public.t_text,
   crt_table_2      public.t_text,
   crt_trigger_1    public.t_text,
   crt_trigger_2    public.t_text,
   log_id           public.id_t       -- Идентификатор журнала
);

COMMENT ON TABLE nso_section  IS 'Описание секций, необходимо для созданий секций в NSO_ABS, NSO_BLOB';

COMMENT ON COLUMN nso_section.section_number  IS 'Номер секции';
COMMENT ON COLUMN nso_section.crt_on_nso_abs  IS 'Создать секцию для NSO_ABS';
COMMENT ON COLUMN nso_section.crt_on_nso_blob IS 'Создать секцию для NSO_BLOB';
COMMENT ON COLUMN nso_section.date_from       IS 'Дата начала актуальности';
COMMENT ON COLUMN nso_section.date_to         IS 'Дата конца актуальности';
COMMENT ON COLUMN nso_section.section_descr   IS 'Описание секции';
COMMENT ON COLUMN nso_section.crt_table_1     IS 'Текст CREATE TABLE PARTITION OF nso.nso_abs';
COMMENT ON COLUMN nso_section.crt_table_2     IS 'Текст CREATE TABLE PARTITION OF nso.nso_blob';
COMMENT ON COLUMN nso_section.crt_trigger_1   IS 'Текст триггера для PARTITION OF nso.nso_abs';
COMMENT ON COLUMN nso_section.crt_trigger_2   IS 'Текст триггера для PARTITION OF nso.nso_blob';
COMMENT ON COLUMN nso_section.log_id          IS 'Идентификатор журнала';

ALTER TABLE nso_section
   ADD CONSTRAINT pk_nso_section PRIMARY KEY (section_number);
--   
-- ALTER TABLE nso_section
--    ADD CONSTRAINT ak1_nso_section UNIQUE (section_sign);

