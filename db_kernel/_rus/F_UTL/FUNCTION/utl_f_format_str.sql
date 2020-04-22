-- ------------------------------------------------------------ --
--  2019-06-05 Nick    Подсчёт количества символов в строке.    --            
-- -- --------------------------------------------------------- --
SET search_path=utl,public;

DROP FUNCTION IF EXISTS utl.utl_f_format_str (public.t_text, public.t_arr_text);
CREATE OR REPLACE FUNCTION utl.utl_f_format_str (p_pattern public.t_text, p_arg public.t_arr_text)
  RETURNS public.t_text
AS 
   $$
     return p_pattern.format(*p_arg)
   $$ 
      SECURITY INVOKER
      STABLE
      STRICT
      LANGUAGE plpython2u;  
      
COMMENT ON FUNCTION utl.utl_f_format_str (public.t_text, public.t_arr_text) 
IS '58: Преобразование строки, FORMAT.
	  Аргументы:
	    1)  p_pattern public.t_text     - Шаблон
	    2) ,p_arg     public.t_arr_text - Массив аргументов

          Результат:
             public.t_text  - Строка-результат

          Пример использования:   
             SELECT utl.utl_f_format_str (''AA {0} BB {1} '', ARRAY[''12'', ''89'']);
             --------------
             "AA 12 BB 89 "
';
-- -------------------------------------------------------------
-- SELECT utl.utl_f_format_str ('AA {0} BB {1} ', ARRAY['12', '89']);
