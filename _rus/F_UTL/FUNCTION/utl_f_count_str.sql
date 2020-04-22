-- ------------------------------------------------------------ --
--  2019-06-05 Nick    Подсчёт количества символов в строке.    --            
-- -- --------------------------------------------------------- --
SET search_path=utl,public;

DROP FUNCTION IF EXISTS utl.utl_f_count_str (public.t_text, public.t_text);
CREATE OR REPLACE FUNCTION utl.utl_f_count_str (p_str public.t_text, p_arg public.t_text)
  RETURNS public.t_int
AS 
   $$
     return p_str.count(p_arg)
   $$ 
      SECURITY INVOKER
      STABLE
      STRICT
      LANGUAGE plpython2u;  
      
COMMENT ON FUNCTION utl.utl_f_count_str (public.t_text, public.t_text) 
IS '58: Подсчёт количества символов в строке.
	  Аргументы:
	    1)  p_str   public.t_text  - Исходная строка
	    2) ,p_arg   public.t_text  - Строка образец

          Результат:
             public.t_int  - Количество вхождений "p_arg" в "p_str"

          Пример использования:   
             SELECT utl.utl_f_count_str (''aa%gg%''::public.t_text, ''%''); -- 2
             SELECT utl.utl_f_count_str (''aagg''::public.t_text, ''$'');   -- 0
';
-- -------------------------------------------------------------
-- SELECT utl.utl_f_count_str ('aa%gg%'::public.t_text, '%');
-- SELECT utl.utl_f_count_str (NULL, '$');
--

