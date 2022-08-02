-- ----------------------------------------------------------------------------------------
--  Nick 2021-12-02--
--     Опции для серверов тестового контура (локального и удалённого) unnsi_p2 - Препрод2. 
--          В дальнейшем будет создан функционал для установки их параметров.
-- ----------------------------------------------------------------------------------------
-- 2022-01-23 Нижний Новгород
-- 2022-01-31 Нижний Новгород повторно.  unnsi_m - целевая база.

DROP SERVER IF EXISTS unsi_l CASCADE;
CREATE SERVER IF NOT EXISTS unsi_l FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', dbname 'unsi', port '5434');
CREATE USER MAPPING IF NOT EXISTS FOR postgres SERVER unsi_l OPTIONS (user 'postgres', password '');
--
DROP SERVER IF EXISTS unnsi_l CASCADE;
CREATE SERVER IF NOT EXISTS unnsi_l FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', dbname 'unnsi', port '5434');
CREATE USER MAPPING IF NOT EXISTS FOR postgres SERVER unnsi_l OPTIONS (user 'postgres', password '');
--
DROP SERVER IF EXISTS unnsi_nl CASCADE;
CREATE SERVER IF NOT EXISTS unnsi_nl FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', dbname 'unnsi_n', port '5434');
CREATE USER MAPPING IF NOT EXISTS FOR postgres SERVER unnsi_nl OPTIONS (user 'postgres', password '');
--
DROP SERVER IF EXISTS unnsi_m6l CASCADE;
CREATE SERVER IF NOT EXISTS unnsi_m6l FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', dbname 'unnsi_m6', port '5434');
CREATE USER MAPPING IF NOT EXISTS FOR postgres SERVER unnsi_m6l OPTIONS (user 'postgres', password '');
--
DROP SERVER IF EXISTS unnsi_m7l CASCADE;
CREATE SERVER IF NOT EXISTS unnsi_m7l FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', dbname 'unnsi_m7', port '5434');
CREATE USER MAPPING IF NOT EXISTS FOR postgres SERVER unnsi_m7l OPTIONS (user 'postgres', password '');
--
DROP SERVER IF EXISTS unnsi_m8l CASCADE;
CREATE SERVER IF NOT EXISTS unnsi_m8l FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', dbname 'unnsi_m8', port '5434');
CREATE USER MAPPING IF NOT EXISTS FOR postgres SERVER unnsi_m8l OPTIONS (user 'postgres', password '');
--
DROP SERVER IF EXISTS unnsi_m9l CASCADE;
CREATE SERVER IF NOT EXISTS unnsi_m9l FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', dbname 'unnsi_m9', port '5434');
CREATE USER MAPPING IF NOT EXISTS FOR postgres SERVER unnsi_m9l OPTIONS (user 'postgres', password '');
--
DROP SERVER IF EXISTS unnsi_dev CASCADE;
CREATE SERVER IF NOT EXISTS unnsi_dev FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '10.196.35.11', dbname 'ccrm_dev', port '5432');
CREATE USER MAPPING IF NOT EXISTS FOR postgres SERVER unnsi_dev OPTIONS (user 'postgres', password 'postgres1');
-- --
-- CREATE SERVER IF NOT EXISTS unnsi_p2 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '10.196.35.45', dbname 'unsi', port '5432');
-- CREATE USER MAPPING IF NOT EXISTS FOR postgres SERVER unnsi_p2 OPTIONS (user 'crm', password 'crm105005'); -- ???
--
-- CREATE SCHEMA IF NOT EXISTS unsi;
-- COMMENT ON SCHEMA unsi IS 'N Отдалённые Справочники';
--
-- DROP SCHEMA IF EXISTS unnsi CASCADE;
-- CREATE SCHEMA IF NOT EXISTS unnsi; 
-- COMMENT ON SCHEMA unnsi IS 'NN ОТдалённые Справочники НН';
--
-- IMPORT FOREIGN SCHEMA unsi FROM SERVER unsi_l INTO unsi;   -- unnsi_l
-- IMPORT FOREIGN SCHEMA unnsi FROM SERVER unnsi_m2l INTO unnsi;
-- IMPORT FOREIGN SCHEMA unnsi FROM SERVER unnsi_dev INTO unnsi;
-- IMPORT FOREIGN SCHEMA unnsi FROM SERVER unnsi_l INTO unnsi; 
--
