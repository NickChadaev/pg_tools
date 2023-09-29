--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW fsc_receipt_pcg.version
 AS
 SELECT '$Branch: all_prov$ $Revision:5a571ff$ $RevDate:2023-08-22$'::text AS version; 

-- SELECT * FROM fsc_receipt_pcg.version;
-- [atol c0aad62]  Реестр исходных данных и функции -- совместимость FIX-0
