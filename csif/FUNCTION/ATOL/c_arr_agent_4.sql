DROP FUNCTION IF EXISTS fsc_receipt_pcg.c_agent_4 () CASCADE;
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.c_agent_4 (
)
    RETURNS integer[]
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- -------------------------------------------------------
      --   2023-09-07
      -- ------------
      SELECT ARRAY [2003  -- ИНН, указанный в чеке не соответствует ИНН компании.
                  , 2006  -- Некорректный формат JSON
                  , 2007  -- Некорректное значение в JSON
                  , 2009  -- ИНН в запросе не совпадает с ИНН на кассе
                  ];
  ;
 
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.c_agent_4 ()
    IS 'КОНСТАНТЫ. Коды ошибок чека, тип ошибки = "agent". ATOL';
-- ------------------------------------------------------------------------
--   USE CASE:
--             SELECT fsc_receipt_pcg.c_agent_4 ();   -- {2003,2006,2007,2009}
--             SELECT (fsc_receipt_pcg.c_agent_4 ())[1]; -- 2003
--             SELECT (fsc_receipt_pcg.c_agent_4 ())[3]; -- 2007
