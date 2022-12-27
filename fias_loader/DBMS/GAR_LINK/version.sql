--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_link.version
 AS
 SELECT '$Revision:54d152c$ modified $RevDate:2022-12-23$'::text AS version; 

-- SELECT * FROM gar_link.version;
