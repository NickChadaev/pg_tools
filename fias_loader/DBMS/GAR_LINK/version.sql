--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_link.version
 AS
 SELECT '$Revision:b1d8909$ modified $RevDate:2023-01-25$'::text AS version; 

-- SELECT * FROM gar_link.version;
