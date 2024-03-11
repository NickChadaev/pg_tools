--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW pcg_metamodel.version
 AS
 SELECT '$Revision:4b501d3$ modified $RevDate:2024-03-07$'::text AS version; 
                                                           
