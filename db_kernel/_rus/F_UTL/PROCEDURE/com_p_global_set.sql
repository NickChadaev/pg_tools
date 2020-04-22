DROP FUNCTION IF EXISTS utl.com_p_global_set ( public.t_text, public.t_text );
CREATE OR REPLACE FUNCTION utl.com_p_global_set (
                     p_name public.t_text
                   , p_val  public.t_text
)
RETURNS public.t_text AS
$$
   -- -------------------------------------------------------------------------------------------------
   -- Author     : Бутрин С.
   -- Create date: 2017-01-09
   -- 2017-04-29  Nick Переписал на PLpg/SQL.
   -- Description: Устанавливает (инициализирует) глобальную переменную новым значением
   -- 2017-12-29  Nick  quote_ident 
   -- -------------------------------------------------------------------------------------------------
  BEGIN
     EXECUTE 'SET utl.' || btrim ( p_name ) || ' = ' || quote_ident ( btrim ( p_val ));
     RETURN btrim ( p_val );
  END;  
$$
LANGUAGE plpgsql
SECURITY DEFINER;

COMMENT ON FUNCTION utl.com_p_global_set ( public.t_text, public.t_text )
IS '42: Установка глобальной переменной новым значением

      Аргументы:
                     p_name public.t_text  -- Имя переменной
                   , p_val  public.t_text  -- Значение
';
-------------------------
-- SELECT utl.com_p_global_set ( 'X_DEBUG', 'true' );
-----------------------------------------------------
-- SELECT utl.com_f_global_get ( 'X_DEBUG' );