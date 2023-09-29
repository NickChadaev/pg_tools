DROP FUNCTION IF EXISTS fsc_orange_pcg.c_taxation_system () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_taxation_system (
)
    RETURNS int4range
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- -------------------------------------------------------
      --   2023-08-17
      -- ------------
                             
      --  Система налогообложения, 1055:
      --  0 – Общая, ОСН
      --  1 – Упрощенная доход, УСН доход
      --  2 – Упрощенная доход минус расход, УСН доход - расход
      --  3 – Единый налог на вмененный доход, ЕНВД
      --  4 – Единый сельскохозяйственный налог, ЕСН
      --  5 – Патентная система налогообложения, Патент  


      SELECT int4range('[0,5]'); 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_taxation_system ()
    IS 'КОНСТАНТЫ. Система налогообложения';
-- ------------------------------------------------------------------------
--   USE CASE:
--        SELECT fsc_orange_pcg.c_taxation_system ();
--        SELECT lower(fsc_orange_pcg.c_taxation_system ()), upper(fsc_orange_pcg.c_taxation_system ())-1;
