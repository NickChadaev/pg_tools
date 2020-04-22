DROP FUNCTION IF EXISTS utl.f_debug_off ();
CREATE OR REPLACE FUNCTION utl.f_debug_off () RETURNS public.t_boolean 
AS
 $$
--  =======================================================================
--  Author     : Serge
--  Create date: 2017-01-30
--  Description: Отменить режим "debug".
--  2017-09-27 Timur проставим public 
--  2019-04-12 Nick IMMUTABLE.
--  2019-05-27 Nick Новоя ядро,  STABLE.
--  =======================================================================
   SELECT utl.com_p_global_set ('X_DEBUG', 'false' )::public.t_boolean
 $$
LANGUAGE 'sql' STABLE;

COMMENT ON FUNCTION utl.f_debug_off ()
IS '42: Отменить режим "debug"
      Входные параметры : Отсутствуют
      Выходные параметры:
         1) debug  t_boolean   -- FALSE режим "debug" отменен
                               -- TRUE  режим "debug" Установлен';
