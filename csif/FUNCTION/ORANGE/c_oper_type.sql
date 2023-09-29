DROP FUNCTION IF EXISTS fsc_orange_pcg.c_oper_type () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_oper_type (
)
    RETURNS int4range
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- ------------------------
      --   2023-08-17
      -- ------------------------
      --  Признак расчета, 1054:
      --  1. Приход
      --  2. Возврат прихода
      --  3. Расход
      --  4. Возврат расхода

      SELECT int4range('[1,4]'); 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_oper_type ()
    IS 'КОНСТАНТЫ. Перечень типов операций фискализации';
-- -------------------------------------------------------------------------------
--   USE CASE:
--        SELECT fsc_orange_pcg.c_oper_type ();
--        SELECT lower(fsc_orange_pcg.c_oper_type ()), upper(fsc_orange_pcg.c_oper_type ())-1;
