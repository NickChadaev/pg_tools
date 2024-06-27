--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_tmp_pcg_trans.version
 AS
 SELECT '$Revision:48c8c1c$ modified $RevDate:2024-01-24$'::text AS version; 
                                                           
