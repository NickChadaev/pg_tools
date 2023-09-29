--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW fsc_orange_pcg.version
 AS
 SELECT '$Revision:5eed275$ modified $RevDate:2023-08-17$'::text AS version; 
                   
-- SELECT * FROM fsc_orange_pcg.version;
-- $Revision:52461ee$ modified $RevDate:2023-08-07$
