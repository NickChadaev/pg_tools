--
-- Версия пакета. Дата общей сборки, либо последняя дата обновления.
--
CREATE OR REPLACE VIEW gar_fias_pcg_load.version
 AS
 SELECT '$Revision:5ac285e$ modified $RevDate:2023-11-01$'::text AS version; 
