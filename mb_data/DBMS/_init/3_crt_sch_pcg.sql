/*==============================================================*/
/* DBMS name:      PostgreSQL 13.12    2024-03-06               */
/*==============================================================*/

DROP SCHEMA IF EXISTS pcg_clientdb CASCADE;
CREATE SCHEMA IF NOT EXISTS pcg_clientdb; 
COMMENT ON SCHEMA pcg_clientdb IS 'Клиенты, функционал загрузки данных';
REVOKE ALL ON SCHEMA pcg_clientdb FROM PUBLIC;

DROP SCHEMA IF EXISTS pcg_contacts CASCADE;
CREATE SCHEMA IF NOT EXISTS pcg_contacts;
COMMENT ON SCHEMA pcg_contacts IS 'Контакты с клиентами, функционал загрузки данных';
REVOKE ALL ON SCHEMA pcg_contacts FROM PUBLIC;

DROP SCHEMA IF EXISTS pcg_metamodel CASCADE;
CREATE SCHEMA IF NOT EXISTS pcg_metamodel;
COMMENT ON SCHEMA pcg_metamodel IS 'Метамодель, функционал загрузки данных';
REVOKE ALL ON SCHEMA pcg_metamodel FROM PUBLIC;

DROP SCHEMA IF EXISTS pcg_dict CASCADE;
CREATE SCHEMA IF NOT EXISTS pcg_dict;
COMMENT ON SCHEMA pcg_dict IS 'Справочники, функционал загрузки данных';
REVOKE ALL ON SCHEMA pcg_dict FROM PUBLIC;

