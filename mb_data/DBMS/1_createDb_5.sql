DROP DATABASE IF EXISTS md_data_02;  /*==============================================================*/
/* DBMS name:      PostgreSQL 13.12                             */
/*==============================================================*/

DROP DATABASE IF EXISTS md_data_01;
CREATE DATABASE md_data_01
    WITH 
    OWNER = mb_owner
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru_RU.utf8'
    LC_CTYPE = 'ru_RU.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE md_data_01
    IS 'Данные для metabase. Регион 01. 2024-02-29';

DROP DATABASE IF EXISTS md_data_02;    
CREATE DATABASE md_data_02
    WITH 
    OWNER = mb_owner
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru_RU.utf8'
    LC_CTYPE = 'ru_RU.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE md_data_02
    IS 'Данные для metabase. Регион 02. 2024-02-29';

DROP DATABASE IF EXISTS md_data_03;      
CREATE DATABASE md_data_03
    WITH 
    OWNER = mb_owner
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru_RU.utf8'
    LC_CTYPE = 'ru_RU.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE md_data_03
    IS 'Данные для metabase. Регион 03. 2024-02-29';

DROP DATABASE IF EXISTS md_data_04;    
CREATE DATABASE md_data_04
    WITH 
    OWNER = mb_owner
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru_RU.utf8'
    LC_CTYPE = 'ru_RU.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE md_data_04
    IS 'Данные для metabase. Регион 04. 2024-02-29';

DROP DATABASE IF EXISTS md_data_05;
CREATE DATABASE md_data_05
    WITH 
    OWNER = mb_owner
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru_RU.utf8'
    LC_CTYPE = 'ru_RU.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE md_data_05
    IS 'Данные для metabase. Регион 05. 2024-02-29';
              
