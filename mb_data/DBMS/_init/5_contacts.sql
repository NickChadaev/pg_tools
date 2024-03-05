--
--   2024-03-04
--

DROP TABLE IF EXISTS contacts.cm_contact CASCADE;
CREATE TABLE contacts.cm_contact (
  id_contact        BIGSERIAL,
  dt_beg            TIMESTAMP WITHOUT TIME ZONE,
  dt_end            TIMESTAMP WITHOUT TIME ZONE,
  id_contact_method BIGINT NOT NULL,
  kd_tp_contact     INTEGER NOT NULL,
  id_usr_create     INTEGER NOT NULL,
  id_reg            INTEGER,
  kd_system         INTEGER NOT NULL,
  id_entity         BIGINT,
  id_jur_contact    BIGINT,
  kd_entity         INTEGER,
  data              JSONB DEFAULT '{}'::jsonb,
  kd_status         INTEGER NOT NULL,
  CONSTRAINT cm_contact_key PRIMARY KEY(id_contact)
) ;

COMMENT ON TABLE contacts.cm_contact
IS 'Таблица для регистрации обращений (входящих и исходящих)';

COMMENT ON COLUMN contacts.cm_contact.id_contact
IS 'ИД обращения';

COMMENT ON COLUMN contacts.cm_contact.dt_beg
IS 'Дата и время начала регистрации обращения';

COMMENT ON COLUMN contacts.cm_contact.dt_end
IS 'Дата и время окончания регистрации обращения';

COMMENT ON COLUMN contacts.cm_contact.id_contact_method
IS 'ИД способа связи с клиентом';

COMMENT ON COLUMN contacts.cm_contact.kd_tp_contact
IS 'ИД типа обращения';

COMMENT ON COLUMN contacts.cm_contact.id_usr_create
IS 'ИД пользователя-регистратора обращения';

COMMENT ON COLUMN contacts.cm_contact.id_reg
IS 'ИД подразделения-регистратора обращения';

COMMENT ON COLUMN contacts.cm_contact.kd_system
IS 'ИД системы-источника обращения';

COMMENT ON COLUMN contacts.cm_contact.id_entity
IS 'ИД лида/клиента (ссылка на лида или клиента, по которому зарегистрировано обращение)';

COMMENT ON COLUMN contacts.cm_contact.id_jur_contact
IS 'ИД контактного лица клиента ЮЛ по обращению клиента-ЮЛ';

COMMENT ON COLUMN contacts.cm_contact.kd_entity
IS 'ИД сущности Клиентов (лид или клиент), по которой зарегистрировано обращение';

COMMENT ON COLUMN contacts.cm_contact.data
IS 'Реквизиты клиента и его контактного лица на момент регистрации  обращения: массив json';

COMMENT ON COLUMN contacts.cm_contact.kd_status
IS 'ИД текущего статуса обращения';

CREATE INDEX cm_contact_i1 ON contacts.cm_contact
  USING btree (kd_system)
  WHERE (kd_system <> ALL (ARRAY[19, 48]));

CREATE INDEX cm_contact_i2 ON contacts.cm_contact
  USING btree (kd_status)
  WITH (fillfactor = 80)
  WHERE (kd_status <> ALL (ARRAY[15, 16]));

CREATE INDEX cm_contact_i3 ON contacts.cm_contact
  USING brin (kd_entity);

CREATE INDEX cm_contact_i4 ON contacts.cm_contact
  USING btree (dt_beg);

CREATE INDEX cm_contact_i5 ON contacts.cm_contact
  USING btree (dt_beg, id_usr_create, id_contact)
  WITH (fillfactor = 80);
--
--
DROP TABLE IF EXISTS contacts.cm_contact_status_hist CASCADE;
CREATE TABLE contacts.cm_contact_status_hist (
  id_contact  BIGINT NOT NULL,
  dt_change   TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  kd_status   BIGINT NOT NULL,
  id_usr      INTEGER NOT NULL,
  CONSTRAINT cm_contact_status_hist_pkey PRIMARY KEY(id_contact, dt_change)
) ;

COMMENT ON TABLE contacts.cm_contact_status_hist
IS 'История изменения статуса обращения';

COMMENT ON COLUMN contacts.cm_contact_status_hist.dt_change
IS 'Дата и время изменения';

COMMENT ON COLUMN contacts.cm_contact_status_hist.kd_status
IS 'ИД статуса обращения';

COMMENT ON COLUMN contacts.cm_contact_status_hist.id_usr
IS 'Пользователь, внесший изменения';

CREATE INDEX cm_contact_status_hist_dt_change_idx ON contacts.cm_contact_status_hist
  USING brin (dt_change);

CREATE INDEX cm_contact_status_hist_i1 ON contacts.cm_contact_status_hist
  USING btree (id_contact);

CREATE INDEX cm_contact_status_hist_i2 ON contacts.cm_contact_status_hist
  USING btree (kd_status);
--
--
DROP TABLE IF EXISTS contacts.cm_service CASCADE;
CREATE TABLE contacts.cm_service (
  id_service           BIGSERIAL,
  id_contact           BIGINT,
  id_service_parent    BIGINT,
  id_jur_contact       BIGINT,
  dt_create            TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  id_crm_service       UUID NOT NULL,
  kd_system            INTEGER,
  data                 JSONB,
  nn_ls                VARCHAR(255),
  id_reg_ls            INTEGER,
  id_reg               INTEGER,
  id_usr_create        INTEGER NOT NULL,
  pr_reject            BOOLEAN DEFAULT false NOT NULL,
  id_scenario_instance BIGINT,
  kd_scenario_status   INTEGER,
  pr_ended             BOOLEAN DEFAULT false NOT NULL,
  dt_complete          TIMESTAMP WITHOUT TIME ZONE,
  CONSTRAINT cm_service_key PRIMARY KEY(id_service)
) ;

COMMENT ON TABLE contacts.cm_service
IS 'Процесс';

COMMENT ON COLUMN contacts.cm_service.id_contact
IS 'Ид первого обращения';

COMMENT ON COLUMN contacts.cm_service.id_service_parent
IS 'ИД родительского процесса. Заполняется у созданных автоматически процессов ссылкой на связанную процесс-родитель.';

COMMENT ON COLUMN contacts.cm_service.id_jur_contact
IS 'ИД контактного лица (альтернативный ключ) клиента ЮЛ,  с которым необходимо взаимодействовать по данному процессу';

COMMENT ON COLUMN contacts.cm_service.dt_create
IS 'Дата и время регистрации процесса';

COMMENT ON COLUMN contacts.cm_service.id_crm_service
IS 'ИД Процесса CRM по деятельности организации';

COMMENT ON COLUMN contacts.cm_service.kd_system
IS 'ИД биллинговой системы, к которой относится ЛС по данному процессу';

COMMENT ON COLUMN contacts.cm_service.data
IS 'Параметры процесса_json согласно метамодели данных';

COMMENT ON COLUMN contacts.cm_service.nn_ls
IS 'Номер ЛС: сохраняется номер лицевого счета, по которому оказан процесс, в случае, если однозначно идентифицировать клиента не удалось';

COMMENT ON COLUMN contacts.cm_service.id_reg_ls
IS 'Код отделения лицевого счета из биллинга';

COMMENT ON COLUMN contacts.cm_service.id_reg
IS 'ИД подразделения-регистратора процесса';

COMMENT ON COLUMN contacts.cm_service.id_usr_create
IS 'ИД пользователя-регистратора процесса';

COMMENT ON COLUMN contacts.cm_service.pr_reject
IS 'Факт отказа клиента от процесса';

COMMENT ON COLUMN contacts.cm_service.dt_complete
IS 'Дата и время завершения или остановки экземпляра сценария';

CREATE INDEX cm_service_i1 ON contacts.cm_service
  USING btree (id_contact)
  WITH (fillfactor = 80)
  WHERE (id_contact IS NOT NULL);

CREATE INDEX cm_service_i2 ON contacts.cm_service
  USING btree (id_crm_service);

CREATE INDEX cm_service_i3 ON contacts.cm_service
  USING btree (id_service_parent)
  WITH (fillfactor = 80);

CREATE INDEX cm_service_idx4 ON contacts.cm_service
  USING btree (dt_create)
  WITH (fillfactor = 80);

-- ?????
--   CREATE TABLE contacts.cm_service (
--     id_service BIGSERIAL,
--     id_contact BIGINT,
--     id_service_parent BIGINT,
--     id_jur_contact BIGINT,
--     dt_create TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
--     id_crm_service UUID NOT NULL,
--     kd_system INTEGER,
--     data JSONB,
--     nn_ls VARCHAR(255),
--     id_reg_ls INTEGER,
--     id_reg INTEGER,
--     id_usr_create INTEGER NOT NULL,
--     pr_reject BOOLEAN DEFAULT false NOT NULL,
--     id_scenario_instance BIGINT,
--     kd_scenario_status INTEGER,
--     pr_ended BOOLEAN DEFAULT false NOT NULL,
--     dt_complete TIMESTAMP WITHOUT TIME ZONE,
--     CONSTRAINT cm_service_key PRIMARY KEY(id_service)
--   ) ;
--   
--   COMMENT ON TABLE contacts.cm_service
--   IS 'Процесс';
--   
--   COMMENT ON COLUMN contacts.cm_service.id_contact
--   IS 'Ид первого обращения';
--   
--   COMMENT ON COLUMN contacts.cm_service.id_service_parent
--   IS 'ИД родительского процесса. Заполняется у созданных автоматически процессов ссылкой на связанную процесс-родитель.';
--   
--   COMMENT ON COLUMN contacts.cm_service.id_jur_contact
--   IS 'ИД контактного лица (альтернативный ключ) клиента ЮЛ,  с которым необходимо взаимодействовать по данному процессу';
--   
--   COMMENT ON COLUMN contacts.cm_service.dt_create
--   IS 'Дата и время регистрации процесса';
--   
--   COMMENT ON COLUMN contacts.cm_service.id_crm_service
--   IS 'ИД Процесса CRM по деятельности организации';
--   
--   COMMENT ON COLUMN contacts.cm_service.kd_system
--   IS 'ИД биллинговой системы, к которой относится ЛС по данному процессу';
--   
--   COMMENT ON COLUMN contacts.cm_service.data
--   IS 'Параметры процесса_json согласно метамодели данных';
--   
--   COMMENT ON COLUMN contacts.cm_service.nn_ls
--   IS 'Номер ЛС: сохраняется номер лицевого счета, по которому оказан процесс, в случае, если однозначно идентифицировать клиента не удалось';
--   
--   COMMENT ON COLUMN contacts.cm_service.id_reg_ls
--   IS 'Код отделения лицевого счета из биллинга';
--   
--   COMMENT ON COLUMN contacts.cm_service.id_reg
--   IS 'ИД подразделения-регистратора процесса';
--   
--   COMMENT ON COLUMN contacts.cm_service.id_usr_create
--   IS 'ИД пользователя-регистратора процесса';
--   
--   COMMENT ON COLUMN contacts.cm_service.pr_reject
--   IS 'Факт отказа клиента от процесса';
--   
--   COMMENT ON COLUMN contacts.cm_service.dt_complete
--   IS 'Дата и время завершения или остановки экземпляра сценария';
--   
--   CREATE INDEX cm_service_i1 ON contacts.cm_service
--     USING btree (id_contact)
--     WITH (fillfactor = 80)
--     WHERE (id_contact IS NOT NULL);
--   
--   CREATE INDEX cm_service_i2 ON contacts.cm_service
--     USING btree (id_crm_service);
--   
--   CREATE INDEX cm_service_i3 ON contacts.cm_service
--     USING btree (id_service_parent)
--     WITH (fillfactor = 80);
--   
--   CREATE INDEX cm_service_idx4 ON contacts.cm_service
--     USING btree (dt_create)
--     WITH (fillfactor = 80);
--   
--   ALTER TABLE contacts.cm_service
--     OWNER TO mb_owner;
--
--
DROP TABLE IF EXISTS contacts.cm_service_additional CASCADE;
CREATE TABLE contacts.cm_service_additional (
  kd_entity  INTEGER NOT NULL,
  nn_rownum  INTEGER NOT NULL,
  id_service BIGINT NOT NULL,
  dt_change  TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  id_usr     INTEGER NOT NULL,
  data       JSONB,
  CONSTRAINT cm_service_additional_key PRIMARY KEY(id_service, kd_entity, nn_rownum)
) ;

COMMENT ON TABLE contacts.cm_service_additional IS 'Доп. сущности метамодели';

COMMENT ON COLUMN contacts.cm_service_additional.kd_entity
IS 'ИД доп. сущности метамодели';

COMMENT ON COLUMN contacts.cm_service_additional.nn_rownum
IS 'Номер строки';

COMMENT ON COLUMN contacts.cm_service_additional.id_service
IS 'ид процесса';

COMMENT ON COLUMN contacts.cm_service_additional.dt_change
IS 'Дата изменения';

COMMENT ON COLUMN contacts.cm_service_additional.id_usr
IS 'Пользователь, внесший изменения';

COMMENT ON COLUMN contacts.cm_service_additional.data
IS 'Параметры доп сущности_json';

CREATE INDEX cm_service_additional_i1 ON contacts.cm_service_additional
  USING btree (id_service, kd_entity);
--
--
DROP TABLE IF EXISTS contacts.cm_service_journal CASCADE;
CREATE TABLE contacts.cm_service_journal (
  id_service   BIGINT NOT NULL,
  kd_entity    INTEGER,
  dt_change    TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  id_usr       INTEGER  NOT NULL,
  kd_oper      SMALLINT NOT NULL,
  kd_attribute INTEGER  NOT NULL,
  new_value    VARCHAR,
  old_value    VARCHAR
) ;

COMMENT ON TABLE contacts.cm_service_journal
IS 'Журнал операций модуля Управление контактами';

COMMENT ON COLUMN contacts.cm_service_journal.id_service
IS 'ИД процесса';

COMMENT ON COLUMN contacts.cm_service_journal.kd_entity
IS 'ИД сущности';

COMMENT ON COLUMN contacts.cm_service_journal.dt_change
IS 'Дата операции';

COMMENT ON COLUMN contacts.cm_service_journal.id_usr
IS 'Пользователь, внесший изменение';

COMMENT ON COLUMN contacts.cm_service_journal.kd_oper
IS 'Ид вида операции';

COMMENT ON COLUMN contacts.cm_service_journal.kd_attribute
IS 'Код измененного атрибута';

COMMENT ON COLUMN contacts.cm_service_journal.new_value
IS 'Новое значение атрибута';

COMMENT ON COLUMN contacts.cm_service_journal.old_value
IS 'старое значение атрибута';

CREATE INDEX cm_service_journal_i1 ON contacts.cm_service_journal
  USING brin (dt_change);

CREATE INDEX cm_service_journal_i2 ON contacts.cm_service_journal
  USING btree (id_service);

CREATE INDEX cm_service_journal_i3 ON contacts.cm_service_journal
  USING btree (kd_attribute);

CREATE UNIQUE INDEX cm_service_journal_i4 ON contacts.cm_service_journal
  USING btree (dt_change, id_service, kd_attribute);
--
--
DROP TABLE IF EXISTS contacts.cm_service_status_hist CASCADE;
CREATE TABLE contacts.cm_service_status_hist (
  id_service BIGINT NOT NULL,
  dt_change TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  kd_status BIGINT NOT NULL,
  id_usr    INTEGER NOT NULL,
  CONSTRAINT cm_service_status_hist_pkey PRIMARY KEY(id_service, dt_change)
) ;

COMMENT ON TABLE contacts.cm_service_status_hist
IS 'История изменения статуса процесса';

COMMENT ON COLUMN contacts.cm_service_status_hist.dt_change
IS 'Дата и время изменения';

COMMENT ON COLUMN contacts.cm_service_status_hist.kd_status
IS 'ИД статуса процесса';

COMMENT ON COLUMN contacts.cm_service_status_hist.id_usr
IS 'Пользователь, внесший изменения';

CREATE INDEX cm_service_status_hist_dt_change_idx ON contacts.cm_service_status_hist
  USING brin (dt_change);

CREATE INDEX cm_service_status_hist_i1 ON contacts.cm_service_status_hist
  USING btree (id_service);

CREATE INDEX cm_service_status_hist_i2 ON contacts.cm_service_status_hist
  USING btree (kd_status);

CREATE INDEX cm_service_status_hist_idx4 ON contacts.cm_service_status_hist
  USING btree (dt_change, id_service);
--
--
DROP TABLE IF EXISTS contacts.cm_task CASCADE;
CREATE TABLE contacts.cm_task (
  id_task          BIGSERIAL,
  id_service       BIGINT NOT NULL,
  id_usr_create    INTEGER NOT NULL,
  id_log           BIGINT,
  id_task_parent   BIGINT,
  id_usr_executor  INTEGER,
  id_reg_executor  INTEGER,
  dt_create        TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  dt_plan_beg      TIMESTAMP WITHOUT TIME ZONE,
  dt_plan_end      TIMESTAMP WITHOUT TIME ZONE,
  dt_fact_end      TIMESTAMP WITHOUT TIME ZONE,
  id_task_solution BIGINT,
  kd_status        INTEGER NOT NULL,
  id_task_type     BIGINT,
  dt_status        TIMESTAMP WITHOUT TIME ZONE,
  id_step          UUID,
  CONSTRAINT cm_task_key PRIMARY KEY(id_task)
) ;

COMMENT ON TABLE contacts.cm_task
IS 'Задачи';

COMMENT ON COLUMN contacts.cm_task.id_task
IS 'ИД задачи';

COMMENT ON COLUMN contacts.cm_task.id_service
IS 'ИД процесса';

COMMENT ON COLUMN contacts.cm_task.id_usr_create
IS 'ИД пользователя-создателя задачи';

COMMENT ON COLUMN contacts.cm_task.id_log
IS 'ИД экземпляра шага сценария';

COMMENT ON COLUMN contacts.cm_task.id_task_parent
IS 'ИД задачи';

COMMENT ON COLUMN contacts.cm_task.id_usr_executor
IS 'ИД пользователя-исполнителя задачи';

COMMENT ON COLUMN contacts.cm_task.id_reg_executor
IS 'ИД подразделения-исполнителя задачи';

COMMENT ON COLUMN contacts.cm_task.dt_create
IS 'Дата создания задачи';

COMMENT ON COLUMN contacts.cm_task.dt_plan_beg
IS 'Плановая дата выполнения задачи(начало выполнения задачи)';

COMMENT ON COLUMN contacts.cm_task.dt_plan_end
IS 'Плановая дата выполнения задачи';

COMMENT ON COLUMN contacts.cm_task.dt_fact_end
IS 'Фактическая дата выполнения задачи';

COMMENT ON COLUMN contacts.cm_task.id_task_solution
IS 'ИД решения по задаче';

COMMENT ON COLUMN contacts.cm_task.kd_status
IS 'ИД текущего статуса задачи';

CREATE INDEX cm_task_i2 ON contacts.cm_task
  USING btree (id_service);

CREATE INDEX cm_task_i3 ON contacts.cm_task
  USING btree (dt_create, id_task);

CREATE INDEX cm_task_i4 ON contacts.cm_task
  USING btree (dt_fact_end, id_task)
  WHERE (kd_status <> ALL (ARRAY[17, 18, 59, 60]));

CREATE INDEX cm_task_i5 ON contacts.cm_task
  USING btree (id_task_parent)
  WHERE (id_task_parent IS NOT NULL);

CREATE INDEX cm_task_i6 ON contacts.cm_task
  USING btree (dt_fact_end, id_usr_executor)
  WHERE (kd_status = ANY (ARRAY[17, 18, 59]));

CREATE INDEX cm_task_i7 ON contacts.cm_task
  USING btree (kd_status, id_reg_executor);

CREATE INDEX cn_task_i8 ON contacts.cm_task
  USING btree (id_step);

CREATE INDEX cn_task_i9 ON contacts.cm_task
  USING btree (id_task_solution)
  WHERE (id_task_solution IS NOT NULL);
--
--
DROP TABLE IF EXISTS contacts.cm_task_status_hist CASCADE;
CREATE TABLE contacts.cm_task_status_hist (
  id_task   BIGINT NOT NULL,
  dt_change TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  kd_status BIGINT NOT NULL,
  id_usr    INTEGER NOT NULL,
  CONSTRAINT cm_task_status_hist_pkey PRIMARY KEY(id_task, dt_change)
) ;

COMMENT ON TABLE contacts.cm_task_status_hist
IS 'История изменения статуса задачи';

COMMENT ON COLUMN contacts.cm_task_status_hist.dt_change
IS 'Дата и время изменения';

COMMENT ON COLUMN contacts.cm_task_status_hist.kd_status
IS 'ИД статуса задачи';

COMMENT ON COLUMN contacts.cm_task_status_hist.id_usr
IS 'Пользователь, внесший изменения';

CREATE INDEX cm_task_status_hist_dt_change_idx ON contacts.cm_task_status_hist
  USING brin (dt_change);

CREATE INDEX cm_task_status_hist_i1 ON contacts.cm_task_status_hist
  USING btree (id_task);

CREATE INDEX cm_task_status_hist_i2 ON contacts.cm_task_status_hist
  USING btree (kd_status);

CREATE INDEX cm_task_status_hist_i3 ON contacts.cm_task_status_hist
  USING btree (id_usr);

CREATE INDEX cm_task_status_hist_idx4 ON contacts.cm_task_status_hist
  USING btree (dt_change, id_task);
--
--
DROP TABLE IF EXISTS contacts.cm_comment CASCADE;
CREATE TABLE contacts.cm_comment (
  id_comment        BIGSERIAL,
  id_comment_parent BIGINT,
  id_entity         BIGINT NOT NULL,
  kd_sys_entity     INTEGER NOT NULL,
  id_usr_create     INTEGER NOT NULL,
  nm_comment        TEXT NOT NULL,
  dt_comment        TIMESTAMP WITHOUT TIME ZONE DEFAULT LOCALTIMESTAMP NOT NULL,
  pr_del            BOOLEAN,
  
  CONSTRAINT cm_comment_key PRIMARY KEY(id_comment),
  CONSTRAINT cm_comment_fk1 FOREIGN KEY (id_comment_parent)
    REFERENCES contacts.cm_comment(id_comment)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) ;

COMMENT ON TABLE contacts.cm_comment
IS 'Комментарии к экземпляру сущности';

COMMENT ON COLUMN contacts.cm_comment.id_comment
IS 'ИД комментария';

COMMENT ON COLUMN contacts.cm_comment.id_comment_parent
IS 'ИД комментария';

COMMENT ON COLUMN contacts.cm_comment.id_entity
IS 'ИД экземпляра сущности, к которой прикреплен комментарий';

COMMENT ON COLUMN contacts.cm_comment.kd_sys_entity
IS 'ИД  системной сущности, по которой добавлен комментарий';

COMMENT ON COLUMN contacts.cm_comment.id_usr_create
IS 'ИД Пользователя, добавившего коммент';

COMMENT ON COLUMN contacts.cm_comment.nm_comment
IS 'Текст комментария';

COMMENT ON COLUMN contacts.cm_comment.dt_comment
IS 'Дата добавления комментария';

COMMENT ON COLUMN contacts.cm_comment.pr_del
IS 'Дата удаления';

CREATE INDEX cm_comment_i0 ON contacts.cm_comment
  USING btree (id_entity, kd_sys_entity, dt_comment);

CREATE INDEX cm_comment_i1 ON contacts.cm_comment
  USING btree (kd_sys_entity);

CREATE INDEX cm_comment_i2 ON contacts.cm_comment
  USING btree (id_comment_parent)
  WHERE (id_comment_parent IS NOT NULL);

