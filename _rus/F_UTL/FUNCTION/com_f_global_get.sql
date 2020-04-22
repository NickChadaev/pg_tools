DROP FUNCTION IF EXISTS utl.com_f_global_get ( public.t_text );
CREATE OR REPLACE FUNCTION utl.com_f_global_get ( p_name public.t_text )
RETURNS public.t_text AS
$$
-- -------------------------------------------------------------------------------
-- Author     : Бутрин С.
-- Create date: 2017-01-09
-- 2017-04-29  Nick Переписал на PLpg/SQL.
-- Description: Функция возвращает значение глобальной переменной
-- -------------------------------------------------------------------------------
 DECLARE
  _var public.t_text;

 BEGIN
    EXECUTE 'SHOW utl.' || btrim (p_name)  INTO _var;
    RETURN _var;
 END;
$$
LANGUAGE plpgsql
SECURITY INVOKER;

COMMENT ON FUNCTION utl.com_f_global_get (public.t_text)
IS '42: Получение значения глобальной переменной

      Аргументы:
                 p_name public.t_text -- Имя глобальной переменной
      Выходные величины:
	         Значение глобальной переменной
                 NULL             - если глобальная переменная не найдена';
-- ------------------------------------------------------------------------
-- SELECT utl.com_f_global_get ( 'C_DEBUG' );                 
