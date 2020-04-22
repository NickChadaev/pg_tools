/* ---------------------------------------------------------------
	Входные параметры:
	public.t_text		-- Строка которую необходимо преобразовать
						-- в null если она пустая 

    Выходные параметры:
	public.t_text		-- Входная строка или Null если она пустая
	
	Особенности:
	
----------------------------------------------------------------*/

SET search_path=utl,public,pg_catalog;

-- so.v_nso_employer <-> com_f_empty_string_to_null(t_text)
DROP FUNCTION IF EXISTS utl.com_f_empty_string_to_null(public.t_text);
CREATE OR REPLACE FUNCTION utl.com_f_empty_string_to_null(public.t_text)
RETURNS public.t_text AS
        $$
        /*==============================================================*/
        /* DBMS name:      PostgreSQL 8                                 */
        /* Created on:     10.06.2015 11:30:00                          */
        /* Модификация:    15.06.2015 (перенос в схему com)             */
        /*     Функция преобразования пустой строки в null.  Роман.     */
        /* 2017-10-31 Nick.  "" - Это пустая строка                     */
        /* 2019-04_29 Новое ядро. Схема UTL.                            */
        /*==============================================================*/
            SELECT CASE WHEN ($1 ~ '^["|[:space:]]*$') = true THEN NULL::public.t_text ELSE $1 END; 
        $$
        LANGUAGE sql
		IMMUTABLE SECURITY INVOKER;
COMMENT ON FUNCTION utl.com_f_empty_string_to_null(public.t_text)
        IS '13: Преобразования пустой строки в NULL. Если строка не нулевой длины но в ней присутствуют только пробельные символы то эту строку мы считаем пустой';

	-- Проверка на вход передаем NULL 
-- SELECT (utl.com_f_empty_string_to_null(NULL::t_text) IS NULL) ;  
-- SELECT (utl.com_f_empty_string_to_null('""'::t_text) IS NULL) ;  
-- SELECT (utl.com_f_empty_string_to_null(''::t_text) IS NULL) ;  
-- SELECT (utl.com_f_empty_string_to_null('Андрианов Саша'::t_text) IS NULL) ;  
-- SELECT (utl.com_f_empty_string_to_null('    Андрианов Саша   '::t_text) IS NULL) ;  

-- Проверка на вход передаем символы табуляции и пробельные символы
-- SELECT (utl.com_f_empty_string_to_null('          '::t_text) IS NULL) ;  
-- SELECT (utl.com_f_empty_string_to_null('    ""      '::t_text) IS NULL) ;  

	-- Проверка на вход передаем символы табуляции и пробельные символы и печатные символы
-- SELECT COALESCE( utl.com_f_empty_string_to_null('         	.        	 '), '(null)'); --результат '         	.        	 '
