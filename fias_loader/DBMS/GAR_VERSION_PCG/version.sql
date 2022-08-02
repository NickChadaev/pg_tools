--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_version_pcg_support.version
 AS
 SELECT '$Revision:322$ modified $RevDate:2021-11-30$'::text AS version; 
