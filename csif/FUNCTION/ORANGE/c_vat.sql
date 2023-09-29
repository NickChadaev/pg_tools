DROP FUNCTION IF EXISTS fsc_orange_pcg.c_vat () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_vat (
)
    RETURNS int4range
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- -------------------------------------------------------
      --   2023-08-17
      -- ------------
      --     Ставка НДС, 1199:
      --     1 – ставка НДС 20%
      --     2 – ставка НДС 10%
      --     3 – ставка НДС расч. 20/120
      --     4 – ставка НДС расч. 10/110
      --     5 – ставка НДС 0%
      --     6 – НДС не облагается

      SELECT int4range('[0,6]'); 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_vat ()
    IS 'КОНСТАНТЫ. Классификация ставок НДС';
-- -------------------------------------------------------------------------------
--   USE CASE:
--        SELECT fsc_orange_pcg.c_vat ();
--        SELECT lower(fsc_orange_pcg.c_vat ()), upper(fsc_orange_pcg.c_vat ())-1;
