DROP FUNCTION IF EXISTS fsc_orange_pcg.c_payment_method_type () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_payment_method_type (
)
    RETURNS int4range
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- ----------------------------------
      --   2023-08-17
      -- ---------------------------------
      --   Признак способа расчета, 1214:
      --   1 – Предоплата 100%
      --   2 – Частичная предоплата
      --   3 – Аванс
      --   4 – Полный расчет
      --   5 – Частичный расчет и кредит
      --   6 – Передача в кредит
      --   7 – Оплата кредита

      SELECT int4range('[1,7]'); 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_payment_method_type ()
    IS 'КОНСТАНТЫ. Признак способа расчета';
-- -------------------------------------------------------------------------------
--   USE CASE:
--        SELECT fsc_orange_pcg.c_payment_method_type ();
--        SELECT lower(fsc_orange_pcg.c_payment_method_type ()), upper(fsc_orange_pcg.c_payment_method_type ())-1;
