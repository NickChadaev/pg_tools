--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_link.version
 AS
 SELECT '$Revision:1226$ modified $RevDate:2022-05-23$'::text AS version; 

-- SELECT * FROM gar_link.version;