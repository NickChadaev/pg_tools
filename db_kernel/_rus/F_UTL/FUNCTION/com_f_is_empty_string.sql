
/* ---------------------------------------------------------------
	Входные параметры:
	public.t_text		-- Строка которую необходимо проверить 
						-- пустая ли она

    Выходные параметры:
	public.t_boolean	-- Истина в случае если строка пустая 
	
	Особенности:
	
----------------------------------------------------------------*/

SET search_path=utl,public,pg_catalog;

DROP FUNCTION IF EXISTS utl.com_f_is_empty_string(public.t_text);

CREATE OR REPLACE FUNCTION utl.com_f_is_empty_string(public.t_text)
RETURNS public.t_boolean AS
        $$
          /*==============================================================*/
          /* DBMS name:      PostgreSQL 8                                 */
          /* Created on:     10.06.2015 11:30:00                          */
          /* Модификация:    15.06.2015 (перенос в схему com)             */
          /*                Функция проверки строки на пустоту.  Роман.   */
          /* 2019-04_29  Схема UTL.                                       */
          /*==============================================================*/        
            SELECT CASE WHEN $1 IS NULL THEN true WHEN (SELECT $1 ~ '^["|[:space:]]*$') THEN true ELSE false END::public.t_boolean; 
        $$
        LANGUAGE sql
        IMMUTABLE SECURITY INVOKER;
COMMENT ON FUNCTION utl.com_f_is_empty_string(public.t_text) 
IS '13: Проверка строки на пустоту. Если строка не нулевой длины но в ней присутствуют только пробельные символы и знаки табуляции то эту строку мы считаем пустой';

	-- Проверка на вход передаем NULL 
-- SELECT utl.com_f_is_empty_string(NULL::t_text); -- результат true
	
	-- Проверка на вход передаем символы табуляции и пробельные символы
-- SELECT utl.com_f_is_empty_string('        ""         	 '); -- результат true

	-- Проверка на вход передаем символы табуляции и пробельные символы и печатные символы
-- SELECT utl.com_f_is_empty_string('         	.        	 '); -- результат false
