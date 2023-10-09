/*==============================================================*/
/* DBMS name:      PostgreSQL 13.9                              */
/*==============================================================*/

CREATE DATABASE unsi_test_02
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE unsi_test_02
    IS 'Башкортостан Респ. 223-09-25';