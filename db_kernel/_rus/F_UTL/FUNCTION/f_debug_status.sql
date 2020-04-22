DROP FUNCTION IF EXISTS utl.f_debug_status();
CREATE OR REPLACE FUNCTION utl.f_debug_status () RETURNS public.t_boolean 
AS
$$
--  =======================================================================
--  Author     : Serge
--  Create date: 2017-01-30
--  Description: Получить состояния режима "debug".
--  2017-09-27 Timur проставим public 
--  2019-05-27 Nick Новое ядро.
--  =======================================================================
   SELECT (LOWER( COALESCE(utl.com_f_global_get('X_DEBUG'::public.t_text ), 'f') ) IN ('true', 't', '1'))::public.t_boolean -- 2017-09-27 Timur
$$
LANGUAGE 'sql' STABLE;

COMMENT ON FUNCTION utl.f_debug_status()
IS '42: Получить состояние режима "debug" из глобальной переменной
      Входные параметры : Отсутствуют
      Выходные параметры:
         1) debug  t_boolean   -- TRUE режим "debug" ON
                               -- FALSE режим "debug" OFF';
