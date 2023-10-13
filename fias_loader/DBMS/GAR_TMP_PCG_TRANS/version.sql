--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_tmp_pcg_trans.version
 AS
 SELECT '$Revision:1555bdb$ modified $RevDate:2023-10-13$'::text AS version; 
                                                           
