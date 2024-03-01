/*==============================================================*/
/* DBMS name:      PostgreSQL 13.12    2024-03-01               */
/*==============================================================*/

CREATE SCHEMA IF NOT EXISTS clientdb; 
COMMENT ON SCHEMA clientdb IS 'Клиенты';

CREATE SCHEMA IF NOT EXISTS contacts;
COMMENT ON SCHEMA contacts IS 'Контакты с клиентами';

CREATE SCHEMA IF NOT EXISTS metamodel;
COMMENT ON SCHEMA metamodel IS 'Метамодель';
    
CREATE SCHEMA IF NOT EXISTS dict
COMMENT ON SCHEMA dict IS 'Справочники';
 


ALTER SCHEMA clientdb OWNER TO mb_owner_01;
  
GRANT ALL ON SCHEMA clientdb TO mb_owner_01;
GRANT USAGE ON SCHEMA clientdb TO mb_reader_01;

ALTER DEFAULT PRIVILEGES IN SCHEMA clientdb
GRANT ALL ON TABLES TO mb_owner_01;

ALTER DEFAULT PRIVILEGES IN SCHEMA clientdb
GRANT SELECT ON TABLES TO mb_reader_01;

ALTER DEFAULT PRIVILEGES IN SCHEMA clientdb
GRANT ALL ON SEQUENCES TO mb_owner_01;
  
REVOKE ALL ON SCHEMA clientdb FROM PUBLIC;   
  
  

ALTER SCHEMA contacts
  OWNER TO mb_owner;
  
CREATE SCHEMA dict AUTHORIZATION mb_owner;

ALTER SCHEMA dict
  OWNER TO mb_owner;  
  
CREATE SCHEMA metamodel AUTHORIZATION mb_owner;

ALTER SCHEMA metamodel
  OWNER TO mb_owner;
  
--


GRANT ALL ON SCHEMA metamodel TO mb_owner;

GRANT USAGE ON SCHEMA metamodel TO mb_reader;

ALTER DEFAULT PRIVILEGES IN SCHEMA metamodel
GRANT ALL ON TABLES TO mb_owner;

ALTER DEFAULT PRIVILEGES IN SCHEMA metamodel
GRANT SELECT ON TABLES TO mb_reader;

ALTER DEFAULT PRIVILEGES IN SCHEMA metamodel
GRANT ALL ON SEQUENCES TO mb_owner;


CREATE SCHEMA IF NOT EXISTS dict
    AUTHORIZATION mb_owner;

GRANT ALL ON SCHEMA dict TO mb_owner;

GRANT USAGE ON SCHEMA dict TO mb_reader;

ALTER DEFAULT PRIVILEGES IN SCHEMA dict
GRANT ALL ON TABLES TO mb_owner;

ALTER DEFAULT PRIVILEGES IN SCHEMA dict
GRANT SELECT ON TABLES TO mb_reader;

ALTER DEFAULT PRIVILEGES IN SCHEMA dict
GRANT ALL ON SEQUENCES TO mb_owner;





CREATE SCHEMA IF NOT EXISTS contacts
    AUTHORIZATION mb_owner;

GRANT ALL ON SCHEMA contacts TO mb_owner;

GRANT USAGE ON SCHEMA contacts TO mb_reader;

ALTER DEFAULT PRIVILEGES IN SCHEMA contacts
GRANT ALL ON TABLES TO mb_owner;

ALTER DEFAULT PRIVILEGES IN SCHEMA contacts
GRANT SELECT ON TABLES TO mb_reader;

ALTER DEFAULT PRIVILEGES IN SCHEMA contacts
GRANT ALL ON SEQUENCES TO mb_owner;
