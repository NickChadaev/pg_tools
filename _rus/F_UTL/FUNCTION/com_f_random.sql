-- ------------------------
--  2017-02-17 by Leopard
-- ------------------------

DROP FUNCTION IF EXISTS utl.random ( numeric, numeric );
CREATE OR REPLACE FUNCTION utl.random ( numeric, numeric )
   RETURNS numeric AS
   $$
      SELECT ($1 + ($2 -$1) * random ()::numeric);
   $$ LANGUAGE SQL VOLATILE;

COMMENT ON FUNCTION utl.random ( numeric, numeric ) IS '237: Получение случайного числа из диапазона.';
--------------------------------------------------------------------------------------
-- SELECT * FROM  utl.random ( 10, 40 );
