--
--    2023-07-27
--
-- sudo apt-cache search oracle_fdw 
-- sudo apt-get install postgresql-13-oracle-fdw
-- sudo apt-get install postgresql-13-orafce  

CREATE SERVER moe_test FOREIGN DATA WRAPPER oracle_fdw OPTIONS (dbserver'//10.196.35.88:1521/MOE_TEST');
GRANT USAGE ON FOREIGN SERVER moe_test TO postgres;
CREATE USER MAPPING FOR postgres SERVER moe_test OPTIONS (user 'curr', password 'curr');

