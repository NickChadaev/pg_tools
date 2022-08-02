--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_link.version
 AS
 SELECT '$Revision:322$ modified $RevDate:2021-11-30$'::text AS version; 

-- SELECT * FROM gar_link.version;
