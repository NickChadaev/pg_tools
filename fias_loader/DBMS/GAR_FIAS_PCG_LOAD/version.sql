--
-- Версия пакета. Дата общей сборки, либо последняя дата обновления.
--
CREATE OR REPLACE VIEW gar_fias_pcg_load.version
 AS
 SELECT '$Revision:1562$ modified $RevDate:2022-07-12$'::text AS version; 
