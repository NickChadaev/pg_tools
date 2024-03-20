--
--   2024-03-20
--

DROP TABLE IF EXISTS contacts.cm_contact_service CASCADE;
CREATE TABLE contacts.cm_contact_service ( 
                       id_contact         bigint
                      ,id_service         bigint
                      ,dt_change          timestamp
                      ,id_usr             integer
                      ,pr_initial_contact boolean
  CONSTRAINT cm_contact_service_pkey PRIMARY KEY (id_contact, id_service)
);

COMMENT ON TABLE contacts.cm_contact_service
    IS 'Связанные с обращением процессы';
 
COMMENT ON COLUMN contacts.cm_contact_service.id_contact
    IS 'ID обращения';
 
COMMENT ON COLUMN contacts.cm_contact_service.id_service
    IS 'ID процесса';
 
COMMENT ON COLUMN contacts.cm_contact_service.dt_change
    IS 'Дата регистрации связи обращения и процесса';
 
COMMENT ON COLUMN contacts.cm_contact_service.id_usr
    IS 'Пользователь, внесший изменение';
 
COMMENT ON COLUMN contacts.cm_contact_service.pr_initial_contact
    IS 'Признак первого обращения: значением ИСТИНА отмечается связь с обращением,'
    '  в рамках которого был зарегистрирован процесс.';
-- Index: cm_contact_service_ak1
 
