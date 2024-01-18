--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_tmp_pcg_trans.version
 AS
 SELECT '$Revision:cc20c38$ modified $RevDate:2024-01-18$'::text AS version; 
                                                           
