--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_tmp_pcg_trans.version
 AS
 SELECT '$Revision:18c681c$ modified $RevDate:2023-11-13$'::text AS version; 
                                                           
