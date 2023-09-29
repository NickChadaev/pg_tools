--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW fsc_receipt_pcg.version
 AS
 SELECT '$Revision:f57c3f3$ modified $RevDate:2023-07-17$'::text AS version; 

-- SELECT * FROM fsc_receipt_pcg.version;
-- [atol c0aad62]  Реестр исходных данных и функции -- совместимость FIX-0
