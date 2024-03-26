--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW pcg_dict.version
 AS
 SELECT '$Revision:ad4ccc8$ modified $RevDate:2024-03-25$'::text AS version; 
                                                           
