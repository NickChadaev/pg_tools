--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW export_version.version
 AS
 SELECT '$Revision:6d19d8d$ modified $RevDate:2023-04-05$'::text AS version; 

-- SELECT * FROM export_version.version;   
