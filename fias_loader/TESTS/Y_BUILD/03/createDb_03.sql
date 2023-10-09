/*==============================================================*/
/* DBMS name:      PostgreSQL 13.9                              */
/*==============================================================*/

CREATE DATABASE unsi_test_03
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE unsi_test_03
    IS 'Бурятия Респ. 223-09-25';