--
-- Версия пакета. Дата общей сборки, либо последняя дата обновления.
--
CREATE OR REPLACE VIEW gar_fias_pcg_load.version
 AS
 SELECT '$Revision:1765$ modified $RevDate:2022-09-23$'::text AS version; 
