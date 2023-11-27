--
-- Версия пакета. Дата общей сборки, либо последняя дата обновления.
--
CREATE OR REPLACE VIEW uio.version
 AS
 SELECT '$Revision:d6e39f0$ modified $RevDate:2023-11-27$'::text AS version; 
                   
