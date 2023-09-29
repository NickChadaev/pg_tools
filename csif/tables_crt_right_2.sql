/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     04.05.2023 12:21:08/2023-05-12               */
/*==============================================================*/

SET search_path=fiscalization;


DROP table IF EXISTS fiscalization.fsc_app CASCADE;
/*==============================================================*/
/* Table: fsc_app                                               */
/*==============================================================*/
create table fiscalization.fsc_app (
   id_app               INT4  NOT NULL DEFAULT nextval('fiscalization.fsc_app_id_app_seq'::regclass),
   dt_create            TIMESTAMP(0) without time zone NOT NULL DEFAULT now(),
   dt_update            TIMESTAMP(0) without time zone,
   dt_remove            TIMESTAMP(0) without time zone,
   app_guid             uuid,
   secret_key           text NOT NULL,
   nm_app               text NOT NULL,
   notification_url     text,
   provaider_key        text,
   app_status           BOOL  not null default TRUE
);

alter table fiscalization.fsc_app
   add constraint pk_app primary key (id_app);

COMMENT ON TABLE fiscalization.fsc_app
    IS 'Приложение';

COMMENT ON COLUMN fiscalization.fsc_app.id_app
    IS 'ID приложения';

COMMENT ON COLUMN fiscalization.fsc_app.dt_create
    IS 'Дата создания записи';

COMMENT ON COLUMN fiscalization.fsc_app.dt_update
    IS 'Дата обновления';

COMMENT ON COLUMN fiscalization.fsc_app.dt_remove
    IS 'Дата логического удаления';

COMMENT ON COLUMN fiscalization.fsc_app.app_guid
    IS 'UUID приложения';

COMMENT ON COLUMN fiscalization.fsc_app.secret_key
    IS 'Секретный ключ';

COMMENT ON COLUMN fiscalization.fsc_app.nm_app
    IS 'Название приложеия';

COMMENT ON COLUMN fiscalization.fsc_app.notification_url
    IS 'URL для уведомлений';

COMMENT ON COLUMN fiscalization.fsc_app.provaider_key
    IS 'Ключ провайдера';   

COMMENT ON COLUMN fiscalization.fsc_app.app_status
    IS 'Статус приложения';   
    
-- NOTICE:  drop cascades to 2 other objects
-- DETAIL:  drop cascades to constraint fk_app_uses_app_fsc_provider on table fsc_app_fsc_provider
-- drop cascades to constraint fk_app_provides_fsc_order on table fsc_order

DROP TABLE IF EXISTS fiscalization.fsc_org_app CASCADE;   -- ++    
/*==============================================================*/
/* Table: fsc_org_app                                           */
/*==============================================================*/
create table fiscalization.fsc_org_app (
   id_org_app           INT4                 not null DEFAULT nextval('fiscalization.fsc_org_app_id_org_app_seq'::regclass),
   id_org               INT4                 not null,
   id_app               INT4                 not null,
   id_fsc_data_operator INT4                 null,
   dt_create            TIMESTAMP(0) without time zone not null default now(),
   org_app_status       BOOL                 not null default TRUE
);

alter table fiscalization.fsc_org_app
   add constraint pk_org_app primary key (id_org_app);

alter table fiscalization.fsc_org_app
   add constraint ak1_org_app unique (id_org, id_app);

COMMENT ON TABLE fiscalization.fsc_org_app
    IS 'Организации и Приложения';

COMMENT ON COLUMN fiscalization.fsc_org_app.id_org_app
    IS 'ID приложения организации';

COMMENT ON COLUMN fiscalization.fsc_org_app.id_org
    IS 'ID Организации';

COMMENT ON COLUMN fiscalization.fsc_org_app.id_app
    IS 'ID приложение';
   
COMMENT ON COLUMN fiscalization.fsc_org_app.id_fsc_data_operator     
    IS 'ID ОФД';
   
COMMENT ON COLUMN fiscalization.fsc_org_app.dt_create
    IS 'Дата создания';

COMMENT ON COLUMN fiscalization.fsc_org_app.org_app_status
    IS 'Статус';  

-- ALTER TABLE fiscalization.fsc_org_app ADD COLUMN id_fsc_data_operator INT4;
    
DROP table IF EXISTS fiscalization.fsc_app_param CASCADE;
/*==============================================================*/
/* Table: fsc_app_param                                         */
/*==============================================================*/
create table fiscalization.fsc_app_param (
    id_app_param          INT4 not null DEFAULT nextval('fiscalization.fsc_app_param_id_seq'::regclass),
    id_app	              INT4 NOT NULL,
    id_fsc_provider       INT4 NOT NULL,
    dt_create             TIMESTAMP (0) without time zone not null DEFAULT now(),
    dt_update             TIMESTAMP (0) without time zone,
    app_params	          jsonb, 
    app_status	          BOOL  not null default TRUE    
);

alter table fiscalization.fsc_app_param
   add constraint pk_app_param primary key (id_app_param);

alter table fiscalization.fsc_app_param
   add constraint ak1_app_param unique (id_app, id_fsc_provider);

COMMENT ON TABLE fiscalization.fsc_app_param
    IS 'Настройки приложения для организации';

COMMENT ON COLUMN fiscalization.fsc_app_param.id_app_param
    IS 'ID Настройки приложения для организации';

COMMENT ON COLUMN fiscalization.fsc_app_param.id_app
    IS 'ID Приложения для Организации';

COMMENT ON COLUMN fiscalization.fsc_app_param.id_fsc_provider
    IS 'ID фискального провайдера';

COMMENT ON COLUMN fiscalization.fsc_app_param.dt_create
    IS 'Дата создания';

COMMENT ON COLUMN fiscalization.fsc_app_param.dt_update
    IS 'Дата обновления';

COMMENT ON COLUMN fiscalization.fsc_app_param.app_params
    IS 'Параметры настройки';
   
COMMENT ON COLUMN fiscalization.fsc_app_param.app_status
    IS 'Статус настройки';   
    
DROP table IF EXISTS fiscalization.fsc_org CASCADE;
/*==============================================================*/
/* Table: fsc_org                                               */
/*==============================================================*/
create table fiscalization.fsc_org (
   id_org               INT4                 not null DEFAULT nextval ('fiscalization.fsc_org_id_org_seq'::regclass),   
   dt_create            TIMESTAMP(0) without time zone NOT NULL default now(),
   dt_update            TIMESTAMP(0) without time zone,
   dt_remove            TIMESTAMP(0) without time zone,
   inn                  VARCHAR(12)          not null,
   bik                  VARCHAR(9),     -- 2023-06-05 Только для банков
   nm_org_name          VARCHAR(150)         not null,
   nm_org_address       TEXT,           -- 2023-06-05
   nm_org_phones        TEXT[],         -- 2023-06-05
   org_type             INT4                 null,
   org_status           BOOL                 not null default TRUE
);

ALTER TABLE fiscalization.fsc_org  ADD CONSTRAINT pk_org PRIMARY KEY (id_org);

-- DROP INDEX IF EXISTS ak1_org ;
CREATE UNIQUE INDEX IF NOT EXISTS ak1_org ON fiscalization.fsc_org 
  USING btree (fsc_receipt_pcg.f_xxx_replace_char(nm_org_name), inn);
   
COMMENT ON TABLE fiscalization.fsc_org
    IS 'Организация';

COMMENT ON COLUMN fiscalization.fsc_org.id_org
    IS 'ID организации';

COMMENT ON COLUMN fiscalization.fsc_org.dt_create
    IS 'Дата создания записи';

COMMENT ON COLUMN fiscalization.fsc_org.dt_update
    IS 'Дата обновления';

COMMENT ON COLUMN fiscalization.fsc_org.dt_remove
    IS 'Дата логического удаления';

COMMENT ON COLUMN fiscalization.fsc_org.inn
    IS 'ИНН организации';

COMMENT ON COLUMN fiscalization.fsc_org.bik
    IS 'БИК организации (Для организации типа 5,расчётный банк)';

COMMENT ON COLUMN fiscalization.fsc_org.nm_org_address
    IS 'Адрес организации (фактический, юридический ??)';

COMMENT ON COLUMN fiscalization.fsc_org.nm_org_phones
    IS 'Контактные телефоны организации';

COMMENT ON COLUMN fiscalization.fsc_org.nm_org_name
    IS 'Наименование организации';

COMMENT ON COLUMN fiscalization.fsc_org.org_type
    IS 'Тип организации';

COMMENT ON COLUMN fiscalization.fsc_org.org_status
    IS 'Статус организации';   
   
-- ALTER TABLE fiscalization.fsc_org ADD COLUMN bik VARCHAR(9);  
-- ALTER TABLE fiscalization.fsc_org ADD COLUMN nm_org_address TEXT;   
-- ALTER TABLE fiscalization.fsc_org ADD COLUMN nm_org_phones TEXT[];  
   
DROP table IF EXISTS fiscalization.fsc_provider CASCADE;   
/*==============================================================*/
/* Table: fsc_provider                                          */
/*==============================================================*/
create table fiscalization.fsc_provider (
   id_fsc_provider      INT4              not null DEFAULT nextval ('fiscalization.fsc_provider_id_seq'::regclass),
   nm_fsc_provider      VARCHAR(150)      not null,
   kd_fsc_provider      VARCHAR(20)       not null,
   fsc_url              TEXT              null,
   fsc_port             VARCHAR(5)        null,
   fsc_status           BOOL              not null default TRUE 
);

alter table fiscalization.fsc_provider
   add constraint pk_fiscal_provider primary key (id_fsc_provider);

COMMENT ON TABLE fiscalization.fsc_provider
    IS 'Фискальный провайдер';

COMMENT ON COLUMN fiscalization.fsc_provider.id_fsc_provider
    IS 'ID фискального провайдера';

COMMENT ON COLUMN fiscalization.fsc_provider.nm_fsc_provider
    IS 'Наименование';

COMMENT ON COLUMN fiscalization.fsc_provider.kd_fsc_provider
    IS 'Системный код';
    
COMMENT ON COLUMN fiscalization.fsc_provider.fsc_url
    IS 'URL фискального провайдера';

COMMENT ON COLUMN fiscalization.fsc_provider.fsc_port
    IS 'Порт';

COMMENT ON COLUMN fiscalization.fsc_provider.fsc_status
    IS 'Статус';   

DROP table IF EXISTS fiscalization.fsc_org_cash CASCADE;   
/*==============================================================*/
/* Table: fsc_org_cash                                          */
/*==============================================================*/
create table fiscalization.fsc_org_cash (
   id_org_cash      INT4      not null DEFAULT nextval ('fiscalization.fsc_org_cash_id_seq'::regclass),
   id_org           INT4      not null,
   id_fsc_provider  INT4      not null,
   dt_create        TIMESTAMP (0) without time zone not null DEFAULT now(),
   dt_update        TIMESTAMP (0) without time zone,
   qty_cash         INT4 not null DEFAULT 0,
   grp_cash         VARCHAR(50),
   nm_grp_cash      VARCHAR(150),
   org_cash_status  BOOL  not null default TRUE  
);

alter table fiscalization.fsc_org_cash
   add constraint pk_fsc_org_cash primary key (id_org_cash);
   
alter table fiscalization.fsc_org_cash
   add constraint ak1_fsc_org_cash unique (id_org, id_fsc_provider);   

COMMENT ON TABLE fiscalization.fsc_org_cash
    IS 'Настройки касс для организаций';

COMMENT ON COLUMN fiscalization.fsc_org_cash.id_org_cash
    IS 'ID настройки';
   
COMMENT ON COLUMN fiscalization.fsc_org_cash.id_fsc_provider
    IS 'ID фискального провайдера';
    
COMMENT ON COLUMN fiscalization.fsc_org_cash.id_org
    IS 'ID организации';
    
COMMENT ON COLUMN fiscalization.fsc_org_cash.dt_create
    IS 'Дата создания';
    
COMMENT ON COLUMN fiscalization.fsc_org_cash.dt_update
    IS 'Дата обновления';
    
COMMENT ON COLUMN fiscalization.fsc_org_cash.qty_cash
    IS 'Количество касс';
    
COMMENT ON COLUMN fiscalization.fsc_org_cash.grp_cash
    IS 'Группа касс';
    
COMMENT ON COLUMN fiscalization.fsc_org_cash.nm_grp_cash
    IS 'Наименование группы касс';

COMMENT ON COLUMN fiscalization.fsc_org_cash.org_cash_status
    IS 'Статус настройки касс';
   
--  ALTER TABLE fiscalization.fsc_org_cash DROP constraint ak1_fsc_org_cash;   
--  ALTER TABLE fiscalization.fsc_org_cash DROP COLUMN id_fsc_data_operator;   
--  
--  ALTER TABLE fiscalization.fsc_org_cash ADD COLUMN id_fsc_provider INT4 not null;
--  COMMENT ON COLUMN fiscalization.fsc_org_cash.id_fsc_provider
--      IS 'ID фискального провайдера';
--  
--  alter table fiscalization.fsc_org_cash
--     add constraint ak1_fsc_org_cash unique (id_org, id_fsc_provider);   

DROP table IF EXISTS fiscalization.fsc_data_operator CASCADE;
/*==============================================================*/
/* Table: fsc_data_operator  2023-05-12/2023-05-15              */
/*==============================================================*/
create table fiscalization.fsc_data_operator (
   id_fsc_data_operator   INT4 not null DEFAULT nextval ('fsc_data_operator_id_seq'::regclass),   
   -- id_fsc_provider	      INT4 NOT NULL,
   dt_create	          TIMESTAMP(0) without time zone NOT NULL DEFAULT now(),
   dt_update	          TIMESTAMP(0) without time zone,
   -- dt_remove	          TIMESTAMP(0) without time zone,
   ofd_inn	              VARCHAR(12)  not null,
   nm_ofd	              TEXT         not null,
   nm_ofd_full            TEXT             null,
   ofd_site               TEXT             null,
   fns_info               TEXT             NULL;
   ofd_status             BOOL         not null default TRUE
);

-- ALTER TABLE fiscalization.fsc_data_operator DROP COLUMN dt_remove;
-- ALTER TABLE fiscalization.fsc_data_operator ADD COLUMN nm_ofd_full TEXT null;
-- ALTER TABLE fiscalization.fsc_data_operator ADD COLUMN fns_info TEXT null;

alter table fiscalization.fsc_data_operator
   add constraint pk_fsc_data_operator primary key (id_fsc_data_operator);

alter table fiscalization.fsc_data_operator
   add constraint ak1_data_operator unique (ofd_inn);
   
COMMENT ON TABLE fiscalization.fsc_data_operator
    IS 'ОФД';

COMMENT ON COLUMN fiscalization.fsc_data_operator.id_fsc_data_operator
    IS 'ID ОФД';      
    
-- COMMENT ON COLUMN fiscalization.fsc_data_operator.id_fsc_provider
--     IS 'ID фискального провайдера';    

COMMENT ON COLUMN fiscalization.fsc_data_operator.dt_create
    IS 'Дата создания записи';

COMMENT ON COLUMN fiscalization.fsc_data_operator.dt_update
    IS 'Дата обновления';

-- COMMENT ON COLUMN fiscalization.fsc_data_operator.dt_remove
--  IS 'Дата логического удаления';

COMMENT ON COLUMN fiscalization.fsc_data_operator.ofd_inn
    IS 'ИНН ОФД';

COMMENT ON COLUMN fiscalization.fsc_data_operator.nm_ofd
    IS 'Наименование ОФД';

COMMENT ON COLUMN fiscalization.fsc_data_operator.nm_ofd_full
    IS 'Полное наименование ОФД';
    
COMMENT ON COLUMN fiscalization.fsc_data_operator.ofd_site
    IS 'Сайт ОФД';

COMMENT ON COLUMN fiscalization.fsc_data_operator.fns_info
    IS 'Информация от ФНС';
    
COMMENT ON COLUMN fiscalization.fsc_data_operator.ofd_status
    IS 'Статус ОФД';  

--ALTER TABLE fiscalization.fsc_data_operator DROP COLUMN id_fsc_provider;
