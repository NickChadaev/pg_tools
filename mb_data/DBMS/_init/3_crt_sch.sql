/*==============================================================*/
/* DBMS name:      PostgreSQL 13.12    2024-03-01               */
/*==============================================================*/

DROP SCHEMA IF EXISTS clientdb CASCADE;
CREATE SCHEMA IF NOT EXISTS clientdb; 
COMMENT ON SCHEMA clientdb IS 'Клиенты';
REVOKE ALL ON SCHEMA clientdb FROM PUBLIC;

DROP SCHEMA IF EXISTS contacts CASCADE;
CREATE SCHEMA IF NOT EXISTS contacts;
COMMENT ON SCHEMA contacts IS 'Контакты с клиентами';
REVOKE ALL ON SCHEMA contacts FROM PUBLIC;

DROP SCHEMA IF EXISTS metamodel CASCADE;
CREATE SCHEMA IF NOT EXISTS metamodel;
COMMENT ON SCHEMA metamodel IS 'Метамодель';
REVOKE ALL ON SCHEMA metamodel FROM PUBLIC;

DROP SCHEMA IF EXISTS dict CASCADE;
CREATE SCHEMA IF NOT EXISTS dict;
COMMENT ON SCHEMA dict IS 'Справочники';
REVOKE ALL ON SCHEMA dict FROM PUBLIC;

