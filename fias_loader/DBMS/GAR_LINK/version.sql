--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_link.version
 AS
 SELECT '$Revision:99df370$ modified $RevDate:2022-11-25$'::text AS version; 

-- SELECT * FROM gar_link.version;
