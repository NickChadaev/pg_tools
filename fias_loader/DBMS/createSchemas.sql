/*==============================================================*/
/* DBMS name:      PostgreSQL 13.4                              */
/* Created on:     29.10.2021 19:46:57                          */
/*      Схемы "unsi", "unnsi" для FOREIGN серверов.             */
/*==============================================================*/
CREATE SCHEMA IF NOT EXISTS gar_fias;
COMMENT ON SCHEMA gar_fias IS 'Схема для хранения импортированных данных из портала ГАР';
--
CREATE SCHEMA IF NOT EXISTS gar_fias_pcg_load;
COMMENT ON SCHEMA gar_fias_pcg_load IS 'Схема для загрузки данных из портала ГАР (взаимодействует с парсером)';
--
CREATE SCHEMA IF NOT EXISTS gar_tmp;
COMMENT ON SCHEMA gar_tmp IS 'Хранение промежуточных данных, предварительно загруженных из портала ГАР';
--
CREATE SCHEMA IF NOT EXISTS gar_tmp_pcg_trans;
COMMENT ON SCHEMA gar_tmp_pcg_trans IS 'Преобразование данных, предварительно, загруженных из портала ГАР';
--
CREATE SCHEMA IF NOT EXISTS gar_version;
COMMENT ON SCHEMA gar_version IS 'Версионирование импорта данных из портала ГАР';
--
CREATE SCHEMA IF NOT EXISTS gar_version_pcg_support;
COMMENT ON SCHEMA gar_version_pcg_support IS 'Поддержка версионирования импорта данных из портала ГАР';
--
CREATE SCHEMA IF NOT EXISTS unsi;
COMMENT ON SCHEMA unsi IS 'N Отдалённые Справочники';
--
CREATE SCHEMA IF NOT EXISTS unnsi; 
COMMENT ON SCHEMA unnsi IS 'NN Отдалённые Справочники';
-- 2021-12-31
CREATE SCHEMA IF NOT EXISTS gar_link; 
COMMENT ON SCHEMA gar_link IS 'Выполнить команды на ОТДАЛЁННОМ СЕРВЕРЕ';
--
-- 2022-12-20   ;
CREATE SCHEMA IF NOT EXISTS export_version;
COMMENT ON SCHEMA export_version IS 'Версионирование экспорта данных в адресную базу ЕС НСИ';

