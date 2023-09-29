DROP FUNCTION IF EXISTS fsc_receipt_pcg.c_system_4 () CASCADE;
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.c_system_4 (
)
    RETURNS integer[]
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- -------------------------------------------------------
      --   2023-09-06
      -- ------------
      SELECT ARRAY [ 30 -- Передан некорректный UUID
                  ,  32 -- Ошибка валидации JSON.
                  ,  40 -- Некорректный  запрос
                  ,  41 -- Передан некорректный Content-type.
                  ];
 
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.c_system_4 ()
  IS 'КОНСТАНТЫ. Коды ошибок сервиса (причина - ошибки в данных), тип ошибки = "system, без анализа статуса ответа". ATOL';
-- ------------------------------------------------------------------------
--   USE CASE:
--             SELECT fsc_receipt_pcg.c_system_4 ();        -- {1,10,11,12,13,14,20,21,31,50}
--             SELECT (fsc_receipt_pcg.c_system_4 ())[3];   -- 11
--             SELECT (fsc_receipt_pcg.c_system_4 ())[3:4]; -- {11,12}
--
