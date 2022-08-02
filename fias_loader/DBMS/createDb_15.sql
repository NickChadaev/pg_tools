/*==============================================================*/
/* DBMS name:      PostgreSQL 13.4                              */
/*==============================================================*/

CREATE DATABASE test_15
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru_RU.UTF-8'
    LC_CTYPE = 'ru_RU.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE test_15
    IS 'ТЕСТ Нормативно-справочная информация. v. 0.0. 2022-01-01';
