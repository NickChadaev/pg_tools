DROP FUNCTION IF EXISTS fsc_orange_pcg.c_agent_type () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_agent_type (
)
    RETURNS integer[]
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- -------------------------------------------------------
      --   2023-08-17
      -- ------------
      SELECT ARRAY [
                            --   Признак агента по предмету расчета:
                          1 -- 0   – банковский платежный агент
                        , 2 -- 1   – банковский платежный субагент
                        , 4 -- 2   – платежный агент
                        , 8 -- 3   – платежный субагент
                        ,16 -- 4   – поверенный
                        ,32 -- 5   – комиссионер
                        ,64 -- 6   – иной агент     
                            -- 7 (128)-- Хрен его знает
 ];
 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_agent_type ()
    IS 'КОНСТАНТЫ. Признак агента по предмету расчета, 1222. Битовое поле';
-- ------------------------------------------------------------------------
--   USE CASE:
--             SELECT fsc_orange_pcg.c_agent_type ();   -- {1,2,4,8,16,32,64}
--             SELECT (fsc_orange_pcg.c_agent_type ())[5]; -- 16
--
