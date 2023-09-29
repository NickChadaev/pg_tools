DROP FUNCTION IF EXISTS fsc_orange_pcg.c_pmt_type () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_pmt_type (
)
    RETURNS integer[]
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- -------------------------------------------------------
      --   2023-08-17
      -- ------------
      SELECT ARRAY [
                     --     Тип оплаты:
                       1 -- сумма по чеку наличными,                                                1031
                     , 2 -- сумма по чеку безналичными,                                             1081
                     ,14 -- сумма по чеку предоплатой (зачетом аванса и (или) предыдущих платежей), 1215
                     ,15 -- сумма по чеку постоплатой (в кредит),                                   1216
                     ,16 -- сумма по чеку (БСО) встречным предоставлением,                          1217
     ];
 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_pmt_type ()
    IS 'КОНСТАНТЫ. Тип оплаты';
-- ------------------------------------------------------------------------
--   USE CASE:
--             SELECT fsc_orange_pcg.c_pmt_type ();   -- {1,2,14,15,16}
--             SELECT (fsc_orange_pcg.c_pmt_type ())[1]; -- 1
--
