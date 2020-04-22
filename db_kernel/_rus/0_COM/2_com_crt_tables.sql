/*==================================================================================*/
/* DBMS name:      PostgreSQL 8                                                      */
/* Created on:     10.02.2015 18:25:11                                               */
/*    2015-03-21 Появился частичный индекс на кратком коде                           */
/*    29.03.2015 18:19:37 Добавлен объект                                            */
/*    28.04.2015 Изменена иерархия объектов                                          */
/* --------------------------------------------------------------------------------- */                                                               
/* 2015-05-28:  Добавлены атрибуты в Кодификатор                                     */                                                                
/*    Дата создания              date_create                                         */        
/*    Дата начала актуальности   date_from                                           */
/*    Дата конца актуальности    date_to                                             */
/*    UUID                       codif_uuid                                          */
/*              Добавлена nso_domain_column                                          */ 
/* 2015-06-05:  Добавлен атрибут impact_type d таблицу nso_domain_column_hist        */
/* --------------------------------------------------------------------------------- */
/* 22.06.2015 15:15:34  obj_codifier, obj_object, nso_domain_column имеют            */
/*                      историю.                                                     */ 
/* ----------------------------------------------------------------------------------*/
/* Nick 2015-10-01 Кодификатор допускает одинаковые имена в различных ветках.        */
/*      add CONSTRAINT ak2_obj_codifier UNIQUE (codif_name, parent_codif_id)         */
/* ----------------------------------------------------------------------------------*/
/* Nick 2015-10-02 Добавлена таблица "Конфигурация ПТК"                              */
/* Nick 2015-11-16  Добавлен атрибуты: "Объект-домен", "Тип объекта-потомка".        */
/* --------------------------------------------------------------------------------- */
/* Nick 2015-12-30  Убрано                                                           */ 
/*     ALTER TABLE com_ptk_config ADD CONSTRAINT ak2_com_ptk_config UNIQUE (ptk_uuid)*/ 
/* 2016-02-03 Экспорт в XML, добавлены новые типы.                                   */ 
/* Добавлены воздействия D и E --                                                    */
/* Добавлены воздействия F и G -- 2016-01-26 Gregory                                 */
/* --------------------------------------------------------------------------------- */
/*  2016-06-19 Nick  Дополнительный атрибут в NSO_DOMAIN_COLUMN, nso_code            */
/* --------------------------------------------------------------------------------- */
/* 2016-11-07 Nick  Общая последовательность для исторических таблиц и LOG.          */
/*      Все LOG таблицы наследуют от "ALL_LOG". Удалена "Конфигурация ПТК.           */
/* --------------------------------------------------------------------------------- */
/* 2016-11-11 Nick  Ревизия структуры исторических таблиц.                           */
/* 2016-12-02 Nick  Добавлены события, связанные с конфигурацией ПТК                 */   
/* --------------------------------------------------------------------------------- */
/* 2017-01-25 Nick  Impact_descr типа t_text                                         */
/* --------------------------------------------------------------------------------- */
/* 2017-02-18 Nick  obj_owner_id - опциональный атрибут                              */
/* --------------------------------------------------------------------------------- */
/* 2017-02-23 Nick  Поисковый индекс по obj_owner_id.                                */
/* 2017-03-01 Nick  Все дочерние id_log не имеют ограничения NOT NULL                */
/* --------------------------------------------------------------------------------- */
/* 2017-12-01 Nick  Дополнительные индексы.  Тип объекта и времена                   */
/* 2017-12-10 Nick  Мелкие доделки. Удаление DEFAULT  в исторических таблицах.       */
/* --------------------------------------------------------------------------------- */
/* 2017-12-18 Nick  Предприятие-владелец UUID из НСО                                 */
/* --------------------------------------------------------------------------------- */
/* 2018-01-18 Nick  Нет собственных атрибутов у LOG-таблиц-наследников.              */
/* 2018-02-02 Nick  Последовательность com.com_log_id_log_seq                        */
/*                                                       только для utl_match_order  */
/* --------------------------------------------------------------------------------- */
/*  2018-12-15 Nick Новое ядро                                                       */
/* --------------------------------------------------------------------------------- */
/*  2019-05-20 Nick Имя схемы в LOG таблицах стало типа t_sysname                    */
/*  2020-04-07 Nick Не забывать про установку имени схемы (по умолчанию) в LOG-табл. */
/*===================================================================================*/
SET search_path=com, public, pg_catalog;

DROP SEQUENCE IF EXISTS com.com_log_id_log_seq CASCADE; -- Nick 2018-02-02
CREATE SEQUENCE com.com_log_id_log_seq INCREMENT 1 START 1;   

DROP SEQUENCE IF EXISTS com.all_history_id_seq CASCADE;     -- Nick 2016-11-01
CREATE SEQUENCE com.all_history_id_seq INCREMENT 1 START 1;   

DROP TABLE IF EXISTS com.all_log CASCADE;
/*==============================================================*/
/* Table: all_log                                               */
/*==============================================================*/
CREATE TABLE com.all_log (
   id_log          public.id_t	       NOT NULL  DEFAULT nextval('com.all_history_id_seq'::regclass), -- Общий счётчик
   user_name       public.t_str250     NOT NULL,
   host_name       public.t_str250     ,
   impact_type     public.t_code1      NOT NULL,
   impact_date     public.t_timestamp  NOT NULL,
   impact_descr    public.t_text       NOT NULL,  -- Nick 2017-01-25
   schema_name     public.t_sysname    NOT NULL   -- Nick 2019-05-20
   ); 
--
COMMENT ON TABLE all_log IS 'Журнал учёта изменений';

COMMENT ON COLUMN all_log.id_log       IS 'Идентификатор журнала';
COMMENT ON COLUMN all_log.user_name    IS 'Имя пользователя';
COMMENT ON COLUMN all_log.host_name    IS 'Имя хоста';
COMMENT ON COLUMN all_log.impact_type  IS 'Тип воздействия';
COMMENT ON COLUMN all_log.impact_date  IS 'Дата воздействия';
COMMENT ON COLUMN all_log.impact_descr IS 'Описание воздействия';
COMMENT ON COLUMN all_log.schema_name  IS 'Схема';

ALTER TABLE all_log ADD CONSTRAINT pk_all_log PRIMARY KEY (id_log);

CREATE INDEX ie1_all_log ON com.all_log ( schema_name, impact_date, impact_type );
CREATE INDEX ie2_all_log ON com.all_log ( user_name );

DROP TABLE IF EXISTS com_log CASCADE;
/*==============================================================*/
/* Table: com_log                                               */
/*==============================================================*/
CREATE TABLE com_log (
 --  schema_name public.t_code6 DEFAULT 'COM'::character varyingL -- ???  Не забыть
) INHERITS (com.all_log);

COMMENT ON TABLE com_log IS 'Журнал учёта изменений, общая схема';
--
ALTER TABLE com.com_log
	ADD CONSTRAINT pk_com_log PRIMARY KEY (id_log);
--
ALTER TABLE com.com_log ALTER COLUMN schema_name SET DEFAULT 'COM'; -- Nick 2020-04-07

CREATE INDEX ie2_com_log ON com.com_log USING btree (user_name, impact_date, impact_type);
--
DROP TABLE IF EXISTS com.com_obj_nso_relation CASCADE;
/*==============================================================*/
/* Table: com_obj_nso_relation                                  */
/*==============================================================*/
CREATE TABLE com.com_obj_nso_relation (
	obj_object_id     public.id_t NOT NULL,
	nso_record_id     public.id_t NOT NULL,
	perm_type_id      public.id_t NOT NULL,
	rel_date_create   public.t_timestamp DEFAULT (now())::public.t_timestamp NOT NULL,
	rel_status        public.t_boolean   DEFAULT true NOT NULL,
	id_log            public.id_t
);

COMMENT ON TABLE com.com_obj_nso_relation IS 'Связи между объектами: Предметная область и НСО';

COMMENT ON COLUMN com.com_obj_nso_relation.obj_object_id   IS 'Идентификатор экземпляра объекта предметной области';
COMMENT ON COLUMN com.com_obj_nso_relation.nso_record_id   IS 'Идентификатор экземпляра объекта НСО';
COMMENT ON COLUMN com.com_obj_nso_relation.perm_type_id    IS 'Тип связи';
COMMENT ON COLUMN com.com_obj_nso_relation.rel_date_create IS 'Дата создания';
COMMENT ON COLUMN com.com_obj_nso_relation.rel_status      IS 'Состояние связи';
COMMENT ON COLUMN com.com_obj_nso_relation.id_log          IS 'Идентификатор журнала';

DROP TABLE IF EXISTS com.exn_obj_relation CASCADE;
/*==============================================================*/
/* Table: com.exn_obj_relation                                  */
/*==============================================================*/
CREATE TABLE com.exn_obj_relation (
	exn_parent_object_id public.id_t NOT NULL,
	exn_obj_object_id    public.id_t NOT NULL,
	exn_perm_type_id     public.id_t NOT NULL,
	exn_date_create      public.t_timestamp DEFAULT (now())::public.t_timestamp NOT NULL,
	exn_status           public.t_boolean   DEFAULT false NOT NULL,
	id_log               public.id_t
);
COMMENT ON TABLE com.exn_obj_relation IS 'Связи между объектами';

COMMENT ON COLUMN com.exn_obj_relation.exn_parent_object_id IS 'Идентификатор родительского объекта';
COMMENT ON COLUMN com.exn_obj_relation.exn_obj_object_id    IS 'Идентификатор подчинённого объекта';
COMMENT ON COLUMN com.exn_obj_relation.exn_perm_type_id     IS 'Идентификатор типа разрешения';
COMMENT ON COLUMN com.exn_obj_relation.exn_date_create      IS 'Дата создания';
COMMENT ON COLUMN com.exn_obj_relation.exn_status           IS 'Состояние назначения';
COMMENT ON COLUMN com.exn_obj_relation.id_log               IS 'Идентификатор журнала';
--------------------------------------------------------------------------------
ALTER TABLE com.exn_obj_relation
	ADD CONSTRAINT pk_pmt_obj_relation PRIMARY KEY (exn_parent_object_id, exn_obj_object_id, exn_perm_type_id);
--
--
DROP SEQUENCE IF EXISTS com.nso_domain_column_attr_id_seq CASCADE; -- Nick 2018-02-02
CREATE SEQUENCE com.nso_domain_column_attr_id_seq INCREMENT 1 START 1;   
--
DROP TABLE IF EXISTS nso_domain_column CASCADE;
/*==============================================================*/
/* Table: nso_domain_column                                     */
/*==============================================================*/
CREATE TABLE nso_domain_column (
   attr_id           public.id_t   DEFAULT nextval('com.nso_domain_column_attr_id_seq'::regclass) NOT NULL,
   parent_attr_id    public.id_t           NULL,
   attr_type_id      public.id_t           NOT NULL,
   small_code        public.t_code1        NOT NULL,
   attr_uuid         public.t_guid         NOT NULL,
   attr_create_date  public.t_timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
   is_intra_op       public.t_boolean      NOT NULL DEFAULT false,
   attr_code         public.t_str60        NOT NULL,
   attr_name         public.t_str250       NOT NULL,
   domain_nso_id     public.id_t           NULL,
   domain_nso_code   public.t_str60        NULL,  -- 2015-11-16 Nick -- 2016-02-02 goback Nick  2016-06-19 Nick
   date_from         public.t_timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP::public.t_timestamp,
   date_to           public.t_timestamp    NOT NULL DEFAULT '9999-12-31 00:00:00'::public.t_timestamp,
   id_log            public.id_t           NULL
);

COMMENT ON TABLE nso_domain_column IS 'Домен колонки';

COMMENT ON COLUMN nso_domain_column.attr_id          IS 'Идентификатор атрибута';
COMMENT ON COLUMN nso_domain_column.parent_attr_id   IS 'Идентификатор родительского атрибута';
COMMENT ON COLUMN nso_domain_column.attr_type_id     IS 'Тип атрибута';
COMMENT ON COLUMN nso_domain_column.small_code       IS 'Краткий код типа атрибута';
COMMENT ON COLUMN nso_domain_column.attr_uuid        IS 'UUID атрибута';
COMMENT ON COLUMN nso_domain_column.attr_create_date IS 'Дата создания';
COMMENT ON COLUMN nso_domain_column.is_intra_op      IS 'Признак итраоперабельности';
COMMENT ON COLUMN nso_domain_column.attr_code        IS 'Код атрибута';
COMMENT ON COLUMN nso_domain_column.attr_name        IS 'Наименование атрибута';
COMMENT ON COLUMN nso_domain_column.domain_nso_id    IS 'Идентификатор НСО домена';
COMMENT ON COLUMN nso_domain_column.domain_nso_code  IS  'Код НСО домена';-- Nick 2015-11-16 -- 2016-02-02 goback Nick
COMMENT ON COLUMN nso_domain_column.date_from        IS 'Дата начала актуальности';
COMMENT ON COLUMN nso_domain_column.date_to          IS 'Дата конца актуальности';
COMMENT ON COLUMN nso_domain_column.id_log           IS 'Идентификатор журнала';

ALTER TABLE nso_domain_column
   ADD CONSTRAINT pk_nso_domain_column PRIMARY KEY (attr_id);

/*==============================================================*/
/* Index: ak1_nso_domain_column                                 */
/*==============================================================*/
CREATE UNIQUE INDEX ak1_nso_domain_column ON nso_domain_column (attr_code);

/*==============================================================*/
/* Index: ak2_nso_domain_column                                 */
/*==============================================================*/
CREATE UNIQUE INDEX ak2_nso_domain_column ON nso_domain_column (attr_name);

/*==============================================================*/
/* Index: ak3_nso_domain_column                                 */
/*==============================================================*/
CREATE UNIQUE INDEX ak3_nso_domain_column ON nso_domain_column (attr_uuid);

/*==============================================================*/
/* Index: ie1_nso_domain_column                                 */
/*==============================================================*/
CREATE  INDEX ie1_nso_domain_column ON nso_domain_column (date_from);

/*==============================================================*/
/* Table: nso_domain_column_hist                                */
/*==============================================================*/
DROP TABLE IF EXISTS nso_domain_column_hist CASCADE;
CREATE TABLE nso_domain_column_hist (
   domain_hist_id       public.id_t    NOT NULL DEFAULT nextval('com.all_history_id_seq'::regclass) -- Общий счётчик
)
inherits (nso_domain_column);

COMMENT ON TABLE nso_domain_column_hist IS 'История изменений домена колонок';

COMMENT ON COLUMN nso_domain_column_hist.domain_hist_id IS 'Идентификатор истории домена';

ALTER TABLE nso_domain_column_hist
   ADD CONSTRAINT pk_nso_domain_column_hist PRIMARY KEY (domain_hist_id);
--
DROP SEQUENCE IF EXISTS com.obj_codifier_codif_id_seq CASCADE; 
CREATE SEQUENCE com.obj_codifier_codif_id_seq INCREMENT 1 START 1;   
--
DROP TABLE IF EXISTS com.obj_codifier CASCADE;
/*==============================================================*/
/* Table: obj_codifier                                          */
/*==============================================================*/
CREATE TABLE com.obj_codifier (
   codif_id          public.id_t         NOT NULL  DEFAULT nextval('com.obj_codifier_codif_id_seq'::regclass) NOT NULL,
   parent_codif_id   public.id_t         NULL,
   small_code        public.t_code1      NOT NULL,
   codif_code        public.t_str60      NOT NULL,
   codif_name        public.t_str250     NOT NULL,
   create_date       public.t_timestamp  NOT NULL DEFAULT now()::public.t_timestamp,
   date_from         public.t_timestamp  NOT NULL DEFAULT now()::public.t_timestamp,
   date_to           public.t_timestamp  NOT NULL DEFAULT '9999-12-31 00:00:00'::public.t_timestamp,
   codif_uuid        public.t_guid       NOT NULL,
   id_log            public.id_t         NULL
);

COMMENT ON TABLE com.obj_codifier IS 'Определяет наиболее фундаментальные свойства сущностей БД, к таким свойствам относятся: тип объекта, тип данных, константы';

COMMENT ON COLUMN com.obj_codifier.codif_id        IS 'Идентификатор экземпляра';
COMMENT ON COLUMN com.obj_codifier.parent_codif_id IS 'Идентификатор родителя';
COMMENT ON COLUMN com.obj_codifier.small_code      IS 'Краткий код';
COMMENT ON COLUMN com.obj_codifier.codif_code      IS 'Код';
COMMENT ON COLUMN com.obj_codifier.codif_name      IS 'Наименование';
COMMENT ON COLUMN com.obj_codifier.create_date     IS 'Дата создания';
COMMENT ON COLUMN com.obj_codifier.date_from       IS 'Дата начала актуальности';
COMMENT ON COLUMN com.obj_codifier.date_to         IS 'Дата конца актуальности';
COMMENT ON COLUMN com.obj_codifier.codif_uuid      IS  'UUID';
COMMENT ON COLUMN com.obj_codifier.id_log          IS  'Идентификатор журнала';

ALTER TABLE obj_codifier ADD CONSTRAINT pk_obj_codifier  PRIMARY KEY (codif_id);
ALTER TABLE obj_codifier ADD CONSTRAINT ak1_obj_codifier UNIQUE (codif_code);
ALTER TABLE obj_codifier ADD CONSTRAINT ak2_obj_codifier UNIQUE (codif_name, parent_codif_id);

/*==============================================================*/
/* Index: ak2_obj_codifier  2015-03-21 Nick                     */
/*==============================================================*/
CREATE UNIQUE INDEX ak3_obj_codifier ON obj_codifier (small_code) WHERE ( small_code <> '0');
--
ALTER TABLE obj_codifier ADD CONSTRAINT ak4_obj_codifier UNIQUE (codif_uuid);

COMMENT ON CONSTRAINT pk_obj_codifier ON obj_codifier  IS 'Первичный ключ Кодификатора';

COMMENT ON CONSTRAINT ak1_obj_codifier ON obj_codifier IS 'Ограничение уникальности атрибута "Код"';
COMMENT ON CONSTRAINT ak2_obj_codifier ON obj_codifier IS 'Ограничение уникальности атрибута "Наименование"';
COMMENT ON INDEX      ak3_obj_codifier IS 'Ограничение уникальности атрибута "Краткий код"';
COMMENT ON CONSTRAINT ak4_obj_codifier ON obj_codifier IS 'Ограничение уникальности атрибута "UUID"';

DROP TABLE IF EXISTS obj_codifier_hist CASCADE;
/*==============================================================*/
/* Table: obj_codifier_hist                                     */
/*==============================================================*/
CREATE TABLE obj_codifier_hist (
   codif_hist_id  public.id_t NOT NULL DEFAULT nextval('com.all_history_id_seq'::regclass)  -- Общий счётчик
)
inherits (obj_codifier);

COMMENT ON TABLE obj_codifier_hist IS 'История изменений кодификатора';

COMMENT ON COLUMN obj_codifier_hist.codif_hist_id IS 'Идентификатор истории кодификатора';
--
DROP SEQUENCE IF EXISTS com.obj_object_object_id_seq CASCADE; 
CREATE SEQUENCE com.obj_object_object_id_seq INCREMENT 1 START 1;   
--
DROP TABLE IF EXISTS com.obj_object CASCADE;
/*==============================================================*/
/* Table: obj_object                                            */
/*==============================================================*/
CREATE TABLE com.obj_object (
   object_id            public.id_t  DEFAULT nextval('com.obj_object_object_id_seq'::regclass) NOT NULL,
   parent_object_id     public.id_t         NULL,
   object_type_id       public.id_t         NOT NULL,
   object_stype_id      public.id_t             NULL,  -- 2015-11-16 Nick
   object_short_name    public.t_str60          NULL,
   object_uuid          public.t_guid       NOT NULL,
   object_create_date   public.t_timestamp  NOT NULL DEFAULT now()::public.t_timestamp,
   object_mod_date      public.t_timestamp  NULL,
   object_read_date     public.t_timestamp  NULL,
   object_deact_date    public.t_timestamp  NULL,    -- Nick 2017-12-10
   object_secret_id     public.id_t         NOT NULL,
   object_owner_id      public.id_t         NULL,    -- Nick 2017-02-18
   object_owner1_id     public.t_guid       NULL,    -- Nick 2017-11-16/2017-12-18
   id_log               public.id_t         NULL
);

COMMENT ON TABLE com.obj_object IS
'Обобщённое описание объекта. Атрибутный состав сущности является общим для всех дочерних объектов';

COMMENT ON COLUMN com.obj_object.object_id          IS 'Идентификатор объекта';
COMMENT ON COLUMN com.obj_object.parent_object_id   IS 'Идентификатор родительского объекта';
COMMENT ON COLUMN com.obj_object.object_type_id     IS 'Идентификатор типа объекта';
COMMENT ON COLUMN com.obj_object.object_stype_id    IS 'Идентификатор типа объекта-потомка (подтип)';
COMMENT ON COLUMN com.obj_object.object_short_name  IS 'Краткое наименование объекта';
COMMENT ON COLUMN com.obj_object.object_uuid        IS 'UUID объекта';
COMMENT ON COLUMN com.obj_object.object_create_date IS 'Дата создания';
COMMENT ON COLUMN com.obj_object.object_mod_date    IS 'Дата последнего изменения';
COMMENT ON COLUMN com.obj_object.object_read_date   IS 'Дата последнего просмотра';
COMMENT ON COLUMN com.obj_object.object_deact_date  IS 'Дата деактивации объекта';
COMMENT ON COLUMN com.obj_object.object_owner_id    IS 'Создатель/Модификатор объекта';
COMMENT ON COLUMN com.obj_object.object_owner1_id   IS 'Организация-Владелец';
COMMENT ON COLUMN com.obj_object.object_secret_id   IS 'Гриф секретности';
COMMENT ON COLUMN com.obj_object.id_log             IS 'Идентификатор журнала';

ALTER TABLE com.obj_object ADD CONSTRAINT pk_obj_object PRIMARY KEY (object_id);

/*==============================================================*/
/* Index: ak1_obj_object                                         */
/*==============================================================*/
CREATE UNIQUE INDEX ak1_obj_object ON obj_object (object_uuid);
-- 2017-02-23 Nick
/*==============================================================*/
/* Index: ie1_obj_object                                        */
/*==============================================================*/
CREATE INDEX ie1_obj_object ON  com.obj_object ( object_owner_id );
CREATE INDEX ie2_obj_object ON  com.obj_object ( object_owner1_id );
--
--  2017-12-01 Nick Дополнительные индексы.
--  
CREATE INDEX ie3_obj_object ON com.obj_object ( object_type_id );
CREATE INDEX ie4_obj_object ON com.obj_object ( object_create_date, object_mod_date, object_read_date );
--
DROP TABLE IF EXISTS obj_object_hist CASCADE;
/*==============================================================*/
/* Table: obj_object_hist                                       */
/*==============================================================*/
CREATE TABLE obj_object_hist (
   object_hist_id    public.id_t  NOT NULL DEFAULT nextval ('com.all_history_id_seq'::regclass) 
)inherits (obj_object);

COMMENT ON TABLE obj_object_hist IS 'История изменений объекта';

COMMENT ON COLUMN obj_object_hist.object_hist_id IS 'Идентификатор истории объекта';
COMMENT ON COLUMN obj_object_hist.id_log         IS 'Идентификатор журнала';
--
-- ==========================================================================
-- Author:	SVETA
-- Create date: 2013-07-29
-- Description:	Создание и начальное заполнение таблицы ошибок.
-- Lля всех полей, участвующих в индексе поле по умолчанию = ''. 
-- Если оставить null, то индекс не отработает.
-- --------------------------------------------------------------------------
-- 2015-02-15 Таблица разделяется на две: 
--       com.sys_errors - данные для обработки ошибок DB-engine.
--       com.obj_errors - данные для обработки ошибок в API-DB.
--  Nick.         
-- 2015-03-18 t_code6 заменён на t_code5    
-- 2015-10-04 В ak1_sys_errors ON com.sys_errors
--            добавлена tbl_name, связано с появлением в IND_VALUE
--            и IND_VALU_HIST одноимённых ограничений. Ограничение созданное
--            в таблице-родителе, наследуется в таблице-потомке.
-- =========================================================================
--
DROP SEQUENCE IF EXISTS com.sys_errors_err_id_seq CASCADE; 
CREATE SEQUENCE com.sys_errors_err_id_seq INCREMENT 1 START 1;   
--
DROP TABLE IF EXISTS com.sys_errors CASCADE;
CREATE TABLE com.sys_errors (
      err_id       public.id_t DEFAULT nextval('com.sys_errors_err_id_seq'::regclass) NOT NULL 
     ,err_code     public.t_code5    NOT NULL -- код/номер ошибки 
     ,message_out  public.t_text           -- как выводить пользователю -- not null после заполнения текста ошибок
     ,sch_name     public.t_sysname  NOT NULL -- имя схемы
     ,constr_name  public.t_sysname  NOT NULL -- имя ограничения (Nick Увеличить длину sysnames ???!!!)
     ,opr_type     public.t_code1    NOT NULL 
     ,tbl_name     public.t_sysname  NOT NULL -- имя таблицы
);

COMMENT ON TABLE com.sys_errors IS 'Таблица, используемая для обработки ошибок DB-engine';

COMMENT ON COLUMN com.sys_errors.err_id       IS 'Идентификатор';
COMMENT ON COLUMN com.sys_errors.err_code     IS 'Код ошибки';
COMMENT ON COLUMN com.sys_errors.message_out  IS 'Текст выходного сообщения об обработанной ошибке';
COMMENT ON COLUMN com.sys_errors.sch_name     IS 'Имя схемы';
COMMENT ON COLUMN com.sys_errors.constr_name  IS 'Имя ограничения';
COMMENT ON COLUMN com.sys_errors.opr_type     IS 'Тип операции';
COMMENT ON COLUMN com.sys_errors.tbl_name     IS 'Имя таблицы';

ALTER TABLE com.sys_errors ADD CONSTRAINT pk_sys_errors PRIMARY KEY (err_id); -- PK таблицы   Nick 2013-08-19 добавил PRIMARY KEY
--
ALTER TABLE com.sys_errors 
  ADD  CONSTRAINT chk_sys_errors_operation_iud CHECK (opr_type = 'i' OR opr_type = 'd' or opr_type = 'u') ;

CREATE UNIQUE INDEX ak1_sys_errors ON com.sys_errors
  USING btree (err_code, constr_name, tbl_name, opr_type ) -- Nick 2015-10-04
  WITH (FILLFACTOR=80);
--

DROP TABLE IF EXISTS com.obj_errors CASCADE;
CREATE TABLE com.obj_errors (
      err_code     public.t_code5    NOT NULL  CONSTRAINT pk_obj_errors PRIMARY KEY    -- код/номер ошибки 
     ,message_out  public.t_text     NOT NULL 
     ,sch_name     public.t_sysname  NOT NULL             -- имя схемы
     ,func_name    public.t_sysname  NOT NULL DEFAULT ''  -- имя функции, где произошла ошибка. Значение '' - используется для всех функций.
);

COMMENT ON TABLE com.obj_errors IS 'Таблица используемая для обработки ошибок DB-API';

COMMENT ON COLUMN com.obj_errors.err_code    IS 'Код ошибки';
COMMENT ON COLUMN com.obj_errors.message_out IS 'Текст выходного сообщения об обработанной ошибке';
COMMENT ON COLUMN com.obj_errors.sch_name    IS 'Имя схемы';
COMMENT ON COLUMN com.obj_errors.func_name   IS 'Имя функции';
--
--
