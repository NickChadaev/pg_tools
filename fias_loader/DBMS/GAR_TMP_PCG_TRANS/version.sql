--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_tmp_pcg_trans.version
 AS
 SELECT '$Revision:d640503$ modified $RevDate:2023-11-24$'::text AS version; 
                                                           
