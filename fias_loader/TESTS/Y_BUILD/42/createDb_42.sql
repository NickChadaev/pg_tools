/*==============================================================*/
/* DBMS name:      PostgreSQL 13.9                              */
/*==============================================================*/

CREATE DATABASE unsi_test_42
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE unsi_test_42
    IS 'Кемеровская обл.. 2023-11-13';