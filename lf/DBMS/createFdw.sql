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
DROP SERVER IF EXISTS unnsi_m10l CASCADE;
CREATE SERVER IF NOT EXISTS unnsi_m10l FOREIGN DATA WRAPPER postgres_fdw OPTIONS (dbname 'unnsi_m10', host '127.0.0.1', port '5435');
CREATE USER MAPPING IF NOT EXISTS FOR postgres SERVER unnsi_m10l OPTIONS (user 'postgres', password '');
--
DROP SERVER IF EXISTS unnsi_m12l CASCADE;
CREATE SERVER IF NOT EXISTS unnsi_m12l FOREIGN DATA WRAPPER postgres_fdw OPTIONS (dbname 'unnsi_m12', host '127.0.0.1', port '5434');
CREATE USER MAPPING IF NOT EXISTS FOR postgres SERVER unnsi_m12l OPTIONS (user 'postgres', password '');
--
DROP SERVER IF EXISTS unnsi_dev CASCADE;
CREATE SERVER IF NOT EXISTS unnsi_dev FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '10.196.35.11', dbname 'ccrm_dev', port '5432');
CREATE USER MAPPING IF NOT EXISTS FOR postgres SERVER unnsi_dev OPTIONS (user 'postgres', password 'postgres1');
-- 
