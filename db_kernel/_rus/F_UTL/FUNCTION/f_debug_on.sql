DROP FUNCTION IF EXISTS utl.f_debug_on ();
CREATE OR REPLACE FUNCTION utl.f_debug_on () RETURNS public.t_boolean 
AS
 $$
--  ===================================================================================================================
--  Author     : Serge
--  Create date: 2017-01-30
--  Description: Учтановить режим "debug".
--  2017-09-27 Timur проставим public 
--  2019-04-12 Nick IMMUTABLE.
--  2019-05-27 Nick Новое ядро, STABLR
--  ===================================================================================================================
    SELECT utl.com_p_global_set ('X_DEBUG'::public.t_text,'true')::public.t_boolean
 $$
LANGUAGE 'sql' STABLE;

COMMENT ON FUNCTION utl.f_debug_on()
IS '42: Установить режим "debug"
      Входные параметры : Отсутствуют
      Выходные параметры:
         1) debug  t_boolean   -- TRUE режим "debug" Установлен
                               -- FALSE режим "debug" не установлен'';';
