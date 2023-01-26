/*==============================================================*/
/* DBMS name:      PostgreSQL 13.4                              */
/* Created on:     29.10.2021 19:46:57                          */
/*      Схемы "unsi", "unnsi" для FOREIGN серверов.             */
/*==============================================================*/
CREATE SCHEMA IF NOT EXISTS gar_fias;
COMMENT ON SCHEMA gar_fias IS 'Данные, импортированных из адресного архива, и обработанные парсерами.';
--
CREATE SCHEMA IF NOT EXISTS gar_fias_pcg_load;
COMMENT ON SCHEMA gar_fias_pcg_load IS 'Функциональная схема, обеспечивает запоминание результатов работы парсеров.';
--
CREATE SCHEMA IF NOT EXISTS gar_tmp;
COMMENT ON SCHEMA gar_tmp IS 'Промежуточные структуры, обработанные данные по одному адресному региону.';
--
CREATE SCHEMA IF NOT EXISTS gar_tmp_pcg_trans;
COMMENT ON SCHEMA gar_tmp_pcg_trans IS 'Основная функциональная схема.';
--
CREATE SCHEMA IF NOT EXISTS gar_version;
COMMENT ON SCHEMA gar_version IS 'Версионирование импорта данных из адресного архива';
--
CREATE SCHEMA IF NOT EXISTS gar_version_pcg_support;
COMMENT ON SCHEMA gar_version_pcg_support IS 'Функциональная схема для поддержки версионирования импорта.';
--
CREATE SCHEMA IF NOT EXISTS unsi;
COMMENT ON SCHEMA unsi IS 'DEPRICATED. Адресная схема на отдалённом сервере (Только Foreign Tables)';
--
CREATE SCHEMA IF NOT EXISTS unnsi; 
COMMENT ON SCHEMA unnsi IS 'Адресная схема на отдалённом сервере (Только Foreign Tables).';
-- 2021-12-31
CREATE SCHEMA IF NOT EXISTS gar_link; 
COMMENT ON SCHEMA gar_link IS 'Обеспечение коммуникаций, в частности с FOREIGN SERVERS. Расширение dblink здесь.';
--
-- DROP SCHEMA IF EXISTS export_version CASCADE;
CREATE SCHEMA IF NOT EXISTS export_version;
COMMENT ON SCHEMA export_version IS 'Версионирование экспорта данных в адресную базу.';

COMMENT ON SCHEMA public IS 'Разная вспомогательная мелочь.'


