--
-- 2021-12-02 Nick Создание необходимых расширений.
--
CREATE EXTENSION plpgsql_check SCHEMA public; 
CREATE EXTENSION hstore SCHEMA public;        
CREATE EXTENSION postgres_fdw SCHEMA public;  
CREATE EXTENSION dblink SCHEMA gar_link;
CREATE EXTENSION pg_trgm SCHEMA pg_catalog;
