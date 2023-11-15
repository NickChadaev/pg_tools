--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_tmp_pcg_trans.version
 AS
 SELECT '$Revision:4a01ce1$ modified $RevDate:2023-11-15$'::text AS version; 
                                                           
