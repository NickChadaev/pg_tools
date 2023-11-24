--
-- Версия пакета. Дата общей сборки, либо последняя дата обновления.
--
CREATE OR REPLACE VIEW uio.version
 AS
 SELECT '$Revision:1caa085$ modified $RevDate:2023-05-24$'::text AS version; 
                   
