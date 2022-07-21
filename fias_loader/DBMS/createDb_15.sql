/*==============================================================*/
/* DBMS name:      PostgreSQL 13.4                              */
/*==============================================================*/

CREATE DATABASE unsi_test_15
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru_RU.UTF-8'
    LC_CTYPE = 'ru_RU.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE unsi_test_15
    IS 'Северная Осетия - Алания Респ Нормативно-справочная информация. v. 0.2. 2022-07-11';