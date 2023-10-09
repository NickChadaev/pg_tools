--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_tmp_pcg_trans.version
 AS
 SELECT '$Revision:7aea8ff$ modified $RevDate:2023-10-06$'::text AS version; 
                                        
