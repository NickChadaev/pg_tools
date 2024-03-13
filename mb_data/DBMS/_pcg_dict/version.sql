--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW pcg_dict.version
 AS
 SELECT '$Revision:ece7ca2$ modified $RevDate:2024-03-13$'::text AS version; 
                                                           
