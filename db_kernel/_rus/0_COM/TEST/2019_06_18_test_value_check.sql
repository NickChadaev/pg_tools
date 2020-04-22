--
-- 2019-06-18  Тестирование "com_error.com_f_value_check()".
--

select * FROM com_error.com_f_value_check  ( '1'::public.t_code1, '2737'::public.t_text);
-- 0|'"Короткое целое": проверка, выполнена успешно'

select * FROM com_error.com_f_value_check  ( '1', 'aaa946');

SELECT * FROM com.com_f_com_log_s();
select * from com.all_log;
select * FROM com_error.com_f_value_check  ( '2', 'aaa946');
-- -1|'Ошибку: "invalid input syntax for integer: "aaa946"" с кодом: "22P02" необходимо добавить в таблицу по обработки ошибок для функции:  com_f_value_check. Ошибка произошла в функции: "com_f_value_check".'

select * FROM com_error.com_f_value_check  ( '3', '34.46');
-- -1|'Ошибку: "invalid input syntax for integer: "34.46"" с кодом: "22P02" необходимо добавить в таблицу по обработки ошибок для функции:  com_f_value_check. Ошибка произошла в функции: "com_f_value_check".'
--
select * FROM com_error.com_f_value_check  ( '2', '23789999999999999990'); -- 'Необработанная ошибка: код = 22003, текст = value "23789999999999999990" is out of range for type integer. Ошибка произошла в функции: "com_f_value_check".'
-- -1|'Величина: "23789999999999999990", слишком велика для типа: "Целое". Ошибка произошла в функции: "com_f_value_check".'
--    Значит сообщение уже добавлено в таблицу системных ошибок. 

select * FROM com_error.com_f_value_check  ( '1', '2378990'); -- 'Необработанная ошибка: код = 22003, текст = value "2378990" is out of range for type smallint. Ошибка произошла в функции: "com_f_value_check".'
-- -1|'Величина: "2378990", слишком велика для типа: "Короткое целое". Ошибка произошла в функции: "com_f_value_check".'

SELECT * FROM com_error.com_f_value_check  ( '5', 't');
-- 0|'"Логическое": проверка, выполнена успешно'

SELECT * FROM com_error.com_f_value_check  ( '5', 'weee');
-- -1|'Ошибку: "invalid input syntax for type boolean: "weee"" с кодом: "22P02" необходимо добавить в таблицу по обработки ошибок для функции:  com_f_value_check. Ошибка произошла в функции: "com_f_value_check".'

SELECT * FROM com_error.com_f_value_check  ( '5', '1');
-- 0|'"Логическое": проверка, выполнена успешно'

SELECT * FROM com_error.com_f_value_check  ( '5', '0');
-- 0|'"Логическое": проверка, выполнена успешно'

--
SELECT * FROM com_error.com_f_value_check  ( '6', '0'); -- _type_mess := '"Код размерностью 1 символ"';
-- 0|'"Код размерностью 1 символ": проверка, выполнена успешно'

SELECT * FROM com_error.com_f_value_check  ( '6', '999990'); -- _type_mess := '"Код размерностью 1 символ"';                    !!!!!
-- -2|'Тип: "Код размерностью 1 символ"Слишком длинная строка, произойдёт усечение. Ошибка произошла в функции: "com_f_value_check".'

SELECT * FROM com_error.com_f_value_check  ( 'F', '999990');     -- 'Необработанная ошибка: код = 22008, текст = date/time field value out of range: "999990". Ошибка произошла в функции: "com_f_value_check".'
SELECT * FROM com_error.com_f_value_check  ( 'F', '999AAA990');  -- 'Необработанная ошибка: код = 22007, текст = invalid input syntax for type timestamp: "999AAA990". Ошибка произошла в функции: "com_f_value_check".'                  
SELECT * FROM com_error.com_f_value_check  ( 'F', 'AA00-01-30 12:34:66');  -- 'Необработанная ошибка: код = 22008, текст = date/time field value out of range: "1200-01-30 12:34:66". Ошибка произошла в функции: "com_f_value_check".'

--"Ошибку: "неверный синтаксис для типа timestamp: "AA00-01-30 12:34:66"" с кодом: "22007" необходимо добавить в таблицу по обработки ошибок для функции:  com_f_value_check

-- "Величина: "1200-01-30 12:34:66", слишком велика для типа: "Дата время без часового пояса"
-- SELECT * FROM com_error.com_f_value_check  ( 'F', '1200-01-30 12:34:46'); -- ОК

SELECT * FROM com_error.com_f_value_check  ( 'И', '16.566'); -- '"Десятичное число": проверка, выполнена успешно"
--
SELECT * FROM com_error.com_f_value_check  ( 'Q', 'aaa94sss6'); -- '"XML": проверка, выполнена успешно'  реально не выполняется
--
SELECT * FROM com_error.com_f_value_check  ( 'I', 'aaa94sss6'); -- 'Символы недействительные для типа "IP адрес", величина: "aaa94sss6". Ошибка произошла в функции: "com_f_value_check".'
SELECT * FROM com_error.com_f_value_check  ( 'I', '192.168.1.120'); -- '"IP адрес": проверка, выполнена успешно'
--

SELECT * FROM com_error.com_f_value_check  ( 'K', 'aaa94sss6'); -- 'Символы недействительные для типа "UUID", величина: "aaa94sss6". Ошибка произошла в функции: "com_f_value_check".' OK
SELECT * FROM com_error.com_f_value_check  ( 'K', '12369211093'); -- 'Символы недействительные для типа "UUID", величина: "12369211093". Ошибка произошла в функции: "com_f_value_check".' OK
--
SELECT * FROM com_error.com_f_value_check  ( 'T', 'aaa94sss6'); -- 'Символы недействительные для типа "Ссылка на запись", величина: "aaa94sss6". Ошибка произошла в функции: "com_f_value_check".' OK
SELECT * FROM com_error.com_f_value_check  ( 'T', '957905a1-adc8-4e07-8615-3bcac7ba3788'); -- 'Символы недействительные для типа "UUID", величина: "12369211093". Ошибка произошла в функции: "com_f_value_check".' OK

select * FROM com_error.com_f_value_check  ( '1', '27375747575677567567')
-- -1|'Величина: "27375747575677567567", слишком велика для типа: "Короткое целое". Ошибка произошла в функции: "com_f_value_check".'

select * FROM com_error.com_f_value_check  ( 'X', '27375747575677567567')
-- -1|'Необработанная ошибка: код = XX000, текст = Unexpected end of string. Ошибка произошла в функции: "com_f_value_check".'

 SELECT * FROM com.obj_errors;
 SELECT * FROM com.sys_errors;

 --  1) Повтроения
 --  2) 60090
 --  3) -2 ??