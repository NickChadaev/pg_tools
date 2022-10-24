--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW public.version
 AS
 SELECT '$Revision:213568b$ modified $RevDate:2022-10-24$'::text AS version; 

-- SELECT * FROM public.version;
