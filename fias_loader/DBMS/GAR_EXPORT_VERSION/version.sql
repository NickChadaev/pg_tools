--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW export_version.version
 AS
 SELECT '$Revision:0cb98a3$ modified $RevDate:2022-12-15$'::text AS version; 

-- SELECT * FROM export_version.version;  
