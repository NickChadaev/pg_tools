-- DROP SCHEMA IF EXISTS export_version CASCADE;
CREATE SCHEMA IF NOT EXISTS export_version;
COMMENT ON SCHEMA export_version IS 'Версионирование экспорта данных в адресную базу.';

COMMENT ON SCHEMA public IS 'Разная вспомогательная мелочь.'
