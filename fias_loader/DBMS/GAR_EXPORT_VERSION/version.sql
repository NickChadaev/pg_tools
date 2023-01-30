--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW export_version.version
 AS
 SELECT '$Revision:cd7dfd6$ modified $RevDate:2022-12-21$'::text AS version; 

-- SELECT * FROM export_version.version;  
