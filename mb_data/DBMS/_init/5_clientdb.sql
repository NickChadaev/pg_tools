--
--   2024-03-04
--
DROP TABLE IF EXISTS clientdb.cdb_client CASCADE;
CREATE TABLE clientdb.cdb_client (
  id_client             BIGSERIAL,
  id_client_united      BIGINT,
  id_client_jur_parent  BIGINT,
  kd_tp_client          INTEGER NOT NULL,
  kd_system             INTEGER NOT NULL,
  kd_process            INTEGER NOT NULL,
  dt_reg                TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  pr_jur_contact_only   BOOLEAN NOT NULL,
  pr_delete             BOOLEAN DEFAULT false NOT NULL,
  data                  JSONB DEFAULT '{}'::jsonb,
  
  CONSTRAINT cdb_client_key PRIMARY KEY(id_client),
  CONSTRAINT cdb_client_fk1 FOREIGN KEY (id_client_jur_parent)
    REFERENCES clientdb.cdb_client(id_client)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
    
  CONSTRAINT cdb_client_fk2 FOREIGN KEY (id_client_united)
    REFERENCES clientdb.cdb_client(id_client)
    ON DELETE SET NULL
    ON UPDATE NO ACTION
    NOT DEFERRABLE
);

COMMENT ON TABLE clientdb.cdb_client IS 'Клиент';

COMMENT ON COLUMN clientdb.cdb_client.id_client 
IS 'ИД клиента';

COMMENT ON COLUMN clientdb.cdb_client.id_client_united
IS 'ИД объединенного клиента. Заполнена только у записей, которые объединили в рамках операции ' 
'объединения дублей. Это ссылка на созданную при объединении запись.';

COMMENT ON COLUMN clientdb.cdb_client.id_client_jur_parent
IS 'ИД клиента Юл - родителя. Заполняется только по филиалам - это ссылка на родительскую организацию.';

COMMENT ON COLUMN clientdb.cdb_client.kd_tp_client 
IS 'Ид типа клиента';

COMMENT ON COLUMN clientdb.cdb_client.kd_system   
IS 'ИД системы,  в рамках которого был зарегистрирован клиент';

COMMENT ON COLUMN clientdb.cdb_client.kd_process
IS 'ИД процесса,  в рамках которого был зарегистрирован клиент';

COMMENT ON COLUMN clientdb.cdb_client.dt_reg
IS 'Дата регистрации';

COMMENT ON COLUMN clientdb.cdb_client.pr_jur_contact_only
IS 'Является только контактом ЮЛ';

COMMENT ON COLUMN clientdb.cdb_client.pr_delete
IS 'Признак удаления';

COMMENT ON COLUMN clientdb.cdb_client.data
IS 'Параметры - набор атрибутов, определенных в метамодели, в виде jsonb-объекта';

CREATE INDEX cdb_client_i1 ON clientdb.cdb_client
  USING btree (id_client, kd_tp_client, dt_reg, pr_delete);
--
  
DROP TABLE IF EXISTS clientdb.cdb_ls CASCADE;
CREATE TABLE clientdb.cdb_ls (
  id_ls            BIGSERIAL,
  id_dict_facility BIGINT NOT NULL,
  id_client        BIGINT NOT NULL,
  dt_en            DATE,
  nm_ls            VARCHAR(255),
  id_ls_role       BIGINT,
  dt_create        TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  CONSTRAINT cdb_ls_key PRIMARY KEY(id_ls),
  
  CONSTRAINT cdb_ls_fk1 FOREIGN KEY (id_client)
    REFERENCES clientdb.cdb_client(id_client)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) ;

COMMENT ON TABLE clientdb.cdb_ls
IS 'Подключенные ЛС';

COMMENT ON COLUMN clientdb.cdb_ls.id_ls
IS 'ИД связанного ЛС';

COMMENT ON COLUMN clientdb.cdb_ls.id_dict_facility
IS 'Ид поставщика услуг';

COMMENT ON COLUMN clientdb.cdb_ls.id_client
IS 'ИД клиента';

COMMENT ON COLUMN clientdb.cdb_ls.dt_en
IS 'Дата окончания действия связи';

COMMENT ON COLUMN clientdb.cdb_ls.nm_ls
IS 'Номер ЛС для отображения в Смородина-Диалог';

COMMENT ON COLUMN clientdb.cdb_ls.id_ls_role
IS 'Ид роли ЛС';

COMMENT ON COLUMN clientdb.cdb_ls.dt_create
IS 'Дата создания';

CREATE INDEX cdb_ls_i1 ON clientdb.cdb_ls
  USING btree (id_client, id_dict_facility, nm_ls COLLATE pg_catalog."default");
--
--
DROP TABLE IF EXISTS clientdb.cdb_client_additional CASCADE;  
CREATE TABLE clientdb.cdb_client_additional (
  id_client_additional BIGSERIAL,
  id_client BIGINT NOT NULL,
  kd_entity INTEGER NOT NULL,
  data     JSONB,
  id_ls    BIGINT,
  
  CONSTRAINT cdb_client_additional_key PRIMARY KEY(id_client_additional),
  
  CONSTRAINT cdb_client_additional_fk1 FOREIGN KEY (id_client)
    REFERENCES clientdb.cdb_client(id_client)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  
  CONSTRAINT cdb_client_additional_fk2 FOREIGN KEY (id_ls)
    REFERENCES clientdb.cdb_ls(id_ls)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) ;

COMMENT ON TABLE clientdb.cdb_client_additional
IS 'Адреса клиентов. Таблица соответсвует метамодельной сущности 2100 "Дополнительная сущность клиента"';

COMMENT ON COLUMN clientdb.cdb_client_additional.id_client_additional
IS 'ИД доп объекта по клиенту';

COMMENT ON COLUMN clientdb.cdb_client_additional.id_client
IS 'ИД клиента';

COMMENT ON COLUMN clientdb.cdb_client_additional.kd_entity
IS 'ИД доп сущности в метамодели данных';

COMMENT ON COLUMN clientdb.cdb_client_additional.data
IS 'Параметры доп сущности_json';

COMMENT ON COLUMN clientdb.cdb_client_additional.id_ls
IS 'ИД связанного ЛС';

CREATE INDEX cdb_client_additional_i1 ON clientdb.cdb_client_additional
  USING btree (id_client);

CREATE INDEX cdb_client_additional_i2 ON clientdb.cdb_client_additional
  USING btree (id_ls);
--
--
DROP TABLE IF EXISTS clientdb.cdb_client_journal CASCADE;  
CREATE TABLE clientdb.cdb_client_journal (
  id_client    BIGINT NOT NULL,
  dt_change    TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  id_usr       INTEGER  NOT NULL,
  kd_oper      SMALLINT NOT NULL,
  kd_attribute INTEGER NOT NULL,
  new_value    VARCHAR,
  old_value    VARCHAR
) ;

COMMENT ON TABLE clientdb.cdb_client_journal
IS 'Журнал операций модуля Клиенты (только таблица cdb_client)';

COMMENT ON COLUMN clientdb.cdb_client_journal.id_client
IS 'ИД клиента';

COMMENT ON COLUMN clientdb.cdb_client_journal.dt_change
IS 'Дата операции';

COMMENT ON COLUMN clientdb.cdb_client_journal.id_usr
IS 'Пользователь, внесший изменение';

COMMENT ON COLUMN clientdb.cdb_client_journal.kd_oper
IS 'Ид вида операции';

COMMENT ON COLUMN clientdb.cdb_client_journal.kd_attribute
IS 'Код измененного атрибута';

COMMENT ON COLUMN clientdb.cdb_client_journal.new_value
IS 'Новое значение атрибута';

COMMENT ON COLUMN clientdb.cdb_client_journal.old_value
IS 'старое значение атрибута';

CREATE INDEX cdb_client_journal_i1 ON clientdb.cdb_client_journal
  USING brin (dt_change);

CREATE INDEX cdb_client_journal_i2 ON clientdb.cdb_client_journal
  USING btree (id_client);

CREATE INDEX cdb_client_journal_i3 ON clientdb.cdb_client_journal
  USING btree (kd_attribute);

CREATE UNIQUE INDEX cdb_client_journal_i4 ON clientdb.cdb_client_journal
  USING btree (dt_change, id_client, kd_attribute);
