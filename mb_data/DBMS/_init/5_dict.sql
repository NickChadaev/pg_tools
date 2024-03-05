--
--   2024-03-04
--
DROP TABLE IF EXISTS dict.dct_dict CASCADE;
CREATE TABLE dict.dct_dict (
  id_dict         BIGSERIAL,
  id_dict_parent  BIGINT,
  kd_dict_entity  INTEGER NOT NULL,
  pr_delete       BOOLEAN DEFAULT false NOT NULL,
  nm_dict         VARCHAR(400),
  nm_dict_full    VARCHAR,
  
  CONSTRAINT dct_dict_key PRIMARY KEY(id_dict, kd_dict_entity),
  CONSTRAINT dct_dict_fk2 FOREIGN KEY (id_dict_parent, kd_dict_entity)
    REFERENCES dict.dct_dict(id_dict, kd_dict_entity)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) ;

COMMENT ON TABLE dict.dct_dict
IS 'С_Значения справочников';

COMMENT ON COLUMN dict.dct_dict.id_dict
IS 'ИД записи справочника';

COMMENT ON COLUMN dict.dct_dict.id_dict_parent
IS 'Ид родительской записи справочника';

COMMENT ON COLUMN dict.dct_dict.kd_dict_entity
IS 'ИД сущности';

COMMENT ON COLUMN dict.dct_dict.pr_delete
IS 'Признак удаления';

COMMENT ON COLUMN dict.dct_dict.nm_dict
IS 'Наименование краткое';

COMMENT ON COLUMN dict.dct_dict.nm_dict_full
IS 'Наименование полное';

CREATE INDEX dct_dict_i1 ON dict.dct_dict
  USING btree (kd_dict_entity);
--
-- 
DROP TABLE IF EXISTS dict.dct_tp_client CASCADE;
CREATE TABLE dict.dct_tp_client (
  kd_tp_client    INTEGER NOT NULL,
  nm_tp_client    VARCHAR(100) NOT NULL,
  nm_abbreviation VARCHAR(30),
  CONSTRAINT dct_tp_client_key PRIMARY KEY(kd_tp_client)
) ;

COMMENT ON TABLE dict.dct_tp_client
IS 'С_Тип клиента';

COMMENT ON COLUMN dict.dct_tp_client.kd_tp_client
IS 'Ид типа клиента';

COMMENT ON COLUMN dict.dct_tp_client.nm_tp_client
IS 'Наименование типа клиента';

COMMENT ON COLUMN dict.dct_tp_client.nm_abbreviation
IS 'Аббревиатура';
--
--
DROP TABLE IF EXISTS dict.dct_tp_contact CASCADE;
CREATE TABLE dict.dct_tp_contact (
  kd_tp_contact  INTEGER NOT NULL,
  nm_tp_contact  VARCHAR(100) NOT NULL,
  nm_description TEXT,
  CONSTRAINT dct_tp_contact_key PRIMARY KEY(kd_tp_contact)
) ;

COMMENT ON TABLE dict.dct_tp_contact
IS 'С_Тип обращения';

COMMENT ON COLUMN dict.dct_tp_contact.kd_tp_contact
IS 'ИД типа обращения';

COMMENT ON COLUMN dict.dct_tp_contact.nm_tp_contact
IS 'Наименование типа обращения';

COMMENT ON COLUMN dict.dct_tp_contact.nm_description
IS 'Описание типа обращения';
--
--
DROP TABLE IF EXISTS dict.dct_system CASCADE;
CREATE TABLE dict.dct_system (
  kd_system      INTEGER NOT NULL,
  nm_system      VARCHAR(100) NOT NULL,
  nm_description TEXT,
  pr_billing     BOOLEAN NOT NULL,
  pr_lk          BOOLEAN NOT NULL,
  kd_tp_client   INTEGER,
  
  CONSTRAINT dct_system_key PRIMARY KEY(kd_system),
  CONSTRAINT dct_system_fk1 FOREIGN KEY (kd_tp_client)
    REFERENCES dict.dct_tp_client(kd_tp_client)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) ;

COMMENT ON TABLE dict.dct_system
IS 'С_Системы';

COMMENT ON COLUMN dict.dct_system.kd_system
IS 'ИД системы';

COMMENT ON COLUMN dict.dct_system.nm_system
IS 'Наименование';

COMMENT ON COLUMN dict.dct_system.nm_description
IS 'Описание';

COMMENT ON COLUMN dict.dct_system.pr_billing
IS 'Признак биллинговой системы.';

COMMENT ON COLUMN dict.dct_system.pr_lk
IS 'Признак "Личный кабинет".';

COMMENT ON COLUMN dict.dct_system.kd_tp_client
IS 'Ид типа клиента';

CREATE INDEX dct_system_i1 ON dict.dct_system
  USING btree (kd_system, nm_system COLLATE pg_catalog."default");
--
--
DROP TABLE IF EXISTS dict.dct_sys_entity CASCADE;
CREATE TABLE dict.dct_sys_entity (
  kd_sys_entity  INTEGER NOT NULL,
  nm_sys_entity  VARCHAR(100),
  nm_description TEXT,
  nm_table_name  VARCHAR(63),
  
  CONSTRAINT dct_sys_entity_key PRIMARY KEY(kd_sys_entity)
) ;

COMMENT ON TABLE dict.dct_sys_entity
IS 'Реестр системных сущностей представляет собой список таблиц, которые НЕ ведутся с '
' помощью метамодели данных Смородины-Диалог';

COMMENT ON COLUMN dict.dct_sys_entity.kd_sys_entity
IS 'ИД системной сущности';

COMMENT ON COLUMN dict.dct_sys_entity.nm_sys_entity
IS 'Наименование';

COMMENT ON COLUMN dict.dct_sys_entity.nm_description
IS 'Описание';

COMMENT ON COLUMN dict.dct_sys_entity.nm_table_name
IS 'Физическое название таблицы в БД';
--
--
DROP TABLE IF EXISTS dict.dct_crm_service CASCADE;
CREATE TABLE dict.dct_crm_service (
  id_crm_service    UUID NOT NULL,
  nm_crm_service    VARCHAR(400) NOT NULL,
  id_dict_facility  BIGINT NOT NULL,
  kd_tp_client      INTEGER NOT NULL,
  kd_entity         INTEGER NOT NULL,
  pr_gro            BOOLEAN DEFAULT false,
  
  CONSTRAINT dct_crm_service_fk1 FOREIGN KEY (kd_tp_client)
    REFERENCES dict.dct_tp_client(kd_tp_client)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) ;

COMMENT ON TABLE dict.dct_crm_service
IS 'Процесс CRM по деятельности организации';

COMMENT ON COLUMN dict.dct_crm_service.id_crm_service
IS 'ИД Процесса CRM по деятельности организации';

COMMENT ON COLUMN dict.dct_crm_service.nm_crm_service
IS 'Наименование Процесса CRM по деятельности организации';

COMMENT ON COLUMN dict.dct_crm_service.id_dict_facility
IS 'ИД организации';

COMMENT ON COLUMN dict.dct_crm_service.kd_tp_client
IS 'Ид типа клиента (ФЛ/ЮЛ), для которого доступен вид процессов поставщика';

COMMENT ON COLUMN dict.dct_crm_service.kd_entity
IS 'ИД сущности метамодели данных';

COMMENT ON COLUMN dict.dct_crm_service.pr_gro
IS 'Признак процесса ГРО. Признак не обновляется в случае изменения на тот случай, если его будет необходимо проставить руками. На данный моммент попадают значения у которых код сущности с 3200 по 3300.';


CREATE INDEX dct_crm_service_i1 ON dict.dct_crm_service
  USING btree (kd_entity);

CREATE INDEX dct_crm_service_i2 ON dict.dct_crm_service
  USING btree (id_dict_facility);

CREATE INDEX dct_crm_service_i3 ON dict.dct_crm_service
  USING btree (kd_tp_client);

CREATE UNIQUE INDEX dct_crm_service_idx ON dict.dct_crm_service
  USING btree (id_crm_service);
--
--
DROP TABLE IF EXISTS dict.dct_oper CASCADE;
CREATE TABLE dict.dct_oper (
  kd_oper SMALLINT NOT NULL,
  nm_oper VARCHAR(100) NOT NULL,
  
  CONSTRAINT d_oper_key PRIMARY KEY(kd_oper)
) ;

COMMENT ON TABLE dict.dct_oper
IS 'С_Виды операций';

COMMENT ON COLUMN dict.dct_oper.kd_oper
IS 'Ид вида операции';

COMMENT ON COLUMN dict.dct_oper.nm_oper
IS 'Наименование';
--
--
DROP TABLE IF EXISTS dict.dct_service_status CASCADE;
CREATE TABLE dict.dct_service_status (
  kd_status      INTEGER NOT NULL,
  kd_dict_entity INTEGER NOT NULL,
  nm_status      VARCHAR(100),
  nm_description TEXT,
  dt_change      TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  
  CONSTRAINT dct_service_status_key PRIMARY KEY(kd_status)
) ;

COMMENT ON TABLE dict.dct_service_status
IS 'С_Статус_процесса';

COMMENT ON COLUMN dict.dct_service_status.kd_status
IS 'ИД статуса';

COMMENT ON COLUMN dict.dct_service_status.kd_dict_entity
IS 'Код сущности статуса';

COMMENT ON COLUMN dict.dct_service_status.nm_status
IS 'Наименование';

COMMENT ON COLUMN dict.dct_service_status.nm_description
IS 'Описание';

COMMENT ON COLUMN dict.dct_service_status.dt_change
IS 'Дата изменения';

CREATE INDEX dct_service_status_i1 ON dict.dct_service_status
  USING btree (kd_status);
--
--
DROP TABLE IF EXISTS dict.dct_status CASCADE;
CREATE TABLE dict.dct_status (
  kd_status      INTEGER NOT NULL,
  nm_status      VARCHAR(100),
  nm_description TEXT,
  kd_sys_entity  INTEGER NOT NULL,
  dt_change      TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  
  CONSTRAINT dct_status_key PRIMARY KEY(kd_status),
  CONSTRAINT dct_status_fk1 FOREIGN KEY (kd_sys_entity)
    REFERENCES dict.dct_sys_entity(kd_sys_entity)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) ;

COMMENT ON TABLE dict.dct_status
IS 'С_Статус';

COMMENT ON COLUMN dict.dct_status.kd_status
IS 'ИД статуса';

COMMENT ON COLUMN dict.dct_status.nm_status
IS 'Наименование';

COMMENT ON COLUMN dict.dct_status.nm_description
IS 'Описание';

COMMENT ON COLUMN dict.dct_status.kd_sys_entity
IS 'ИД системной сущности, для которой используется статус';

COMMENT ON COLUMN dict.dct_status.dt_change
IS 'Дата изменения';

CREATE INDEX dct_status_i1 ON dict.dct_status
  USING btree (nm_status COLLATE pg_catalog."default");
--
--
DROP TABLE IF EXISTS dict.dct_spec_params CASCADE;
CREATE TABLE dict.dct_spec_params (
  kd_param         INTEGER NOT NULL,
  nm_param         VARCHAR(500) NOT NULL,
  id_dict_facility BIGINT,
  vl_param         INTEGER [],
  dt_change        TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  CONSTRAINT dct_spec_params_key PRIMARY KEY(kd_param)
) ;

COMMENT ON TABLE dict.dct_spec_params
IS 'Параметры для особых ситуаций. Таблица используется для дополненительных параметров выгрузки ' 
' (например исключение определенных id из выгрузок)';

COMMENT ON COLUMN dict.dct_spec_params.kd_param
IS 'Код параметра';

COMMENT ON COLUMN dict.dct_spec_params.nm_param
IS 'Наименование параметра';

COMMENT ON COLUMN dict.dct_spec_params.id_dict_facility
IS 'ИД поставщика услуг';

COMMENT ON COLUMN dict.dct_spec_params.vl_param
IS 'Значение параметра (массив)';

COMMENT ON COLUMN dict.dct_spec_params.dt_change
IS 'Дата изменения';

CREATE INDEX dct_spec_params_i1 ON dict.dct_spec_params
  USING btree (kd_param);

CREATE INDEX dct_spec_params_i2 ON dict.dct_spec_params
  USING btree (id_dict_facility);

CREATE UNIQUE INDEX dct_spec_params_pk_i1 ON dict.dct_spec_params
  USING btree (kd_param, (COALESCE(id_dict_facility, ('-1'::integer)::bigint)));

-- ALTER TABLE dict.dct_spec_params                2024-03-04 оБРАТИТЬ ВНИМАНИЕ.
--   ALTER COLUMN vl_param SET STORAGE EXTENDED;

DROP TABLE IF EXISTS dict.dct_step_service CASCADE;
CREATE TABLE dict.dct_step_service (
  id_step UUID NOT NULL,
  nm_step VARCHAR(100),
  CONSTRAINT dct_step_service_key PRIMARY KEY(id_step)
) ;

COMMENT ON TABLE dict.dct_step_service
IS 'Шаги задачи процесса';

COMMENT ON COLUMN dict.dct_step_service.id_step
IS 'ИД шага задачи процесса';

COMMENT ON COLUMN dict.dct_step_service.nm_step
IS 'Наименование шага задачи процесса';
--
--
-- CREATE TABLE dict.dct_step_service (
--   id_step UUID NOT NULL,
--   nm_step VARCHAR(100),
--   CONSTRAINT dct_step_service_key PRIMARY KEY(id_step)
-- ) ;
-- 
-- COMMENT ON TABLE dict.dct_step_service
-- IS 'Шаги задачи процесса';
-- 
-- COMMENT ON COLUMN dict.dct_step_service.id_step
-- IS 'ИД шага задачи процесса';
-- 
-- COMMENT ON COLUMN dict.dct_step_service.nm_step
-- IS 'Наименование шага задачи процесса';

DROP TABLE IF EXISTS dict.dct_otdels CASCADE;
CREATE TABLE dict.dct_otdels (
  kd_otd        INTEGER NOT NULL,
  kd_otd_parent INTEGER,
  nm_otd        VARCHAR(500),
  id_facility   INTEGER,
  CONSTRAINT dct_otdels_key PRIMARY KEY(kd_otd)
) ;

COMMENT ON TABLE dict.dct_otdels
IS 'Подразделения';

COMMENT ON COLUMN dict.dct_otdels.kd_otd
IS 'ИД подразделения';

COMMENT ON COLUMN dict.dct_otdels.kd_otd_parent
IS 'ИД родительского подразделения';

COMMENT ON COLUMN dict.dct_otdels.nm_otd
IS 'Наименование подразделения';

COMMENT ON COLUMN dict.dct_otdels.id_facility
IS 'ИД организации';

CREATE INDEX dct_otdels_idx1 ON dict.dct_otdels
  USING btree (id_facility);

CREATE INDEX dct_otdels_idx2 ON dict.dct_otdels
  USING btree (kd_otd_parent);
--
--
DROP TABLE IF EXISTS dict.dct_users CASCADE;
CREATE TABLE dict.dct_users (
  acc_id_usr   INTEGER NOT NULL,
  nm_usr       VARCHAR(150),
  fio          VARCHAR(500),
  id_facility  INTEGER,
  pr_access    BOOLEAN,
  kd_otd       INTEGER,
  kd_otd_list  INTEGER [],
  CONSTRAINT dct_users_key PRIMARY KEY(acc_id_usr)
) ;

COMMENT ON TABLE dict.dct_users
IS 'Пользователи';

COMMENT ON COLUMN dict.dct_users.acc_id_usr
IS 'ИД пользователя';

COMMENT ON COLUMN dict.dct_users.nm_usr
IS 'Логин пользователя';

COMMENT ON COLUMN dict.dct_users.fio
IS 'Фамилия Имя Отчество пользователя';

COMMENT ON COLUMN dict.dct_users.id_facility
IS 'ИД организации';

COMMENT ON COLUMN dict.dct_users.pr_access
IS 'Признак активного пользователя';

COMMENT ON COLUMN dict.dct_users.kd_otd
IS 'Основное подразделение пользователя';

-- ALTER TABLE dict.dct_users                оБРАТИТЬ ВНИМАНИЕ  2024-03-04
--   ALTER COLUMN kd_otd_list SET STORAGE EXTENDED;
