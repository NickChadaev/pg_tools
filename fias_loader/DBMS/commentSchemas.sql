/*==============================================================*/
/* DBMS name:      PostgreSQL 13.4                              */
/* Created on:     29.10.2021 19:46:57                          */
/*      Схемы "unsi", "unnsi" для FOREIGN серверов.             */
/*==============================================================*/
COMMENT ON SCHEMA gar_fias IS 'Данные, импортированных из адресного архива, и обработанные парсерами.';
COMMENT ON SCHEMA gar_fias_pcg_load IS 'Функциональная схема, обеспечивает запоминание результатов работы парсеров.';
COMMENT ON SCHEMA gar_tmp IS 'Промежуточные структуры, обработанные данные по одному адресному региону.';
COMMENT ON SCHEMA gar_tmp_pcg_trans IS 'Основная функциональная схема.';
COMMENT ON SCHEMA gar_version IS 'Версионирование импорта данных из адресного архива';
COMMENT ON SCHEMA gar_version_pcg_support IS 'Функциональная схема для поддержки версионирования импорта.';
COMMENT ON SCHEMA unsi IS 'DEPRICATED. Адресная схема на отдалённом сервере (Только Foreign Tables)';
COMMENT ON SCHEMA unnsi IS 'Адресная схема на отдалённом сервере (Только Foreign Tables).';
COMMENT ON SCHEMA gar_link IS 'Обеспечение коммуникаций, в частности с FOREIGN SERVERS. Расширение dblink здесь.';
COMMENT ON SCHEMA export_version IS 'Версионирование экспорта данных в адресную базу.';

