-- ------------
--  2023-08-04
-- ------------
DROP SCHEMA IF EXISTS fiscalization ;
CREATE SCHEMA IF NOT EXISTS fiscalization;

COMMENT ON SCHEMA fiscalization IS 'TRIAL-10 Версия  2023-08-04';


DROP SCHEMA IF EXISTS fsc_receipt_pcg;
CREATE SCHEMA IF NOT EXISTS fsc_receipt_pcg;

COMMENT ON SCHEMA fsc_receipt_pcg IS 'Функциональная схема (ATOL). Версия от 2023-05-18';


DROP SCHEMA IF EXISTS fsc_orange_pcg;
CREATE SCHEMA IF NOT EXISTS fsc_orange_pcg;

COMMENT ON SCHEMA fsc_orange_pcg IS 'Функциональная схема (Orange_Data). Версия от 2023-08-04';
