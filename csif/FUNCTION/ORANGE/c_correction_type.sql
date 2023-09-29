DROP FUNCTION IF EXISTS fsc_orange_pcg.c_correction_type () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_correction_type (
)
    RETURNS int4range
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- ------------------------
      --   2023-08-23
      -- ------------------------
      --   Тип коррекции 1173:
      --   0. Самостоятельно
      --   1. По предписанию

      SELECT int4range('[0,1]'); 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_correction_type ()
    IS 'КОНСТАНТЫ. Тип коррекции';
-- -------------------------------------------------------------------------------
--   USE CASE:
--        SELECT fsc_orange_pcg.c_correction_type ();
--        SELECT lower(fsc_orange_pcg.c_correction_type ()), upper(fsc_orange_pcg.c_correction_type ())-1;
