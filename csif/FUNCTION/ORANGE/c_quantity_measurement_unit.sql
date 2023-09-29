DROP FUNCTION IF EXISTS fsc_orange_pcg.c_quantity_measurement_unit () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_quantity_measurement_unit (
)
    RETURNS int4range
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- --------------------------------------------------------
      --   2023-08-17
      -- --------------------------------------------------------
      --    Мера количества предмета расчета

      SELECT int4range('[0,255]'); 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_quantity_measurement_unit ()
    IS 'КОНСТАНТЫ. Мера количества предмета расчета';
-- -------------------------------------------------------------------------------
--  USE CASE:
--    SELECT fsc_orange_pcg.c_quantity_measurement_unit ();
--    SELECT lower(fsc_orange_pcg.c_quantity_measurement_unit ()), upper(fsc_orange_pcg.c_quantity_measurement_unit ())-1;
