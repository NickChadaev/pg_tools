--
-- Версия пакета. Дата общей сборки, либо последняя дата обновления.
--
CREATE OR REPLACE VIEW uio.version
 AS
 SELECT '$Revision:00de437$ modified $RevDate:2023-05-15$'::text AS version; 
                   
