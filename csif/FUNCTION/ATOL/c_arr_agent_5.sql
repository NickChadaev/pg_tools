DROP FUNCTION IF EXISTS fsc_receipt_pcg.c_agent_5 () CASCADE;
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.c_agent_5 (
)
    RETURNS integer[]
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- -------------------------------------------------------
      --   2023-09-06
      -- ------------
      SELECT ARRAY [2001 -- В течение 5-и минутного интервала не появилось свободных касс для выполнения регистрации чека.
                  , 2002 -- Нет касс, которые могли бы выполнить регистрацию чека.
                  , 2004 -- Внутренняя ошибка сервиса. 
                  , 2005 -- Внутренняя ошибка сервиса.
                  ];
 
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.c_agent_5 ()
    IS 'КОНСТАНТЫ. Коды ошибок кассы (Произошел сбой кассы), тип ошибки = "agent". ATOL';
-- ------------------------------------------------------------------------
--   USE CASE:
--             SELECT fsc_receipt_pcg.c_agent_5 ();        -- {2001,2002,2004,2005}
--             SELECT (fsc_receipt_pcg.c_agent_5 ())[3];   -- 2004
--             SELECT (fsc_receipt_pcg.c_agent_5 ())[3:4]; -- {2004,2005}
--
