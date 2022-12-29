--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_link.version
 AS
 SELECT '$Revision:c6ec2fd$ modified $RevDate:2022-12-29$'::text AS version; 

-- SELECT * FROM gar_link.version;
