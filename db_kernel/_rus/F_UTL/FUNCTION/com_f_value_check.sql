﻿-- =================================================================================
-- Author:	Nick
-- Create date: 2015-04-10
-- Description:	Проверка, соответствует ли значение типу атрибута
--   2015-05-30 Добавлен тип  T_TEXT 'Я' Первый тип, у которого значением краткого 
--      кода является русская буква.
-- 2017-10-09  Битовые строки
-- =================================================================================
/* ---------------------------------------------------------------------------------
	Входные параметры
				p_small_code   t_code1       -- краткий код типа
			       ,p_value        t_str2048     -- значение 

	Выходные параметры
				result_t.rc   0  - завершилось успешно, 
                         -1  - не удовлетворяет требованиям
                         -2  - усечение текстовой строки
                         -9  - величина NULL (в дальнейшем может возникнуть ошибка).
				result_t.errm  - текст сообщения (ошибки).
			
Проверяемые типы данных				

'1'|'SMALL_T'     |'Короткое целое'
'2'|'T_INT'       |'Целое'
'3'|'LONGINT_T'   |'Длинное целое'
'4'|'T_FLOAT'     |'Вещественое'
'5'|'T_BOOLEAN'   |'Логическое'
'6'|'T_CODE1'     |'Код размерностью 1 символ'
'7'|'T_CODE2'     |'Код размерностью 2 символа'
'8'|'T_CODE5'     |'Код размерностью 5 символов'
'9'|'T_STR20'     |'Код размерностью 20 символов'
'A'|'T_STR60'     |'Строка 60 символов'
'B'|'T_STR250'    |'Строка 250 символов'
'C'|'T_STR1024'   |'Строка размерностью 1024 символов'
'D'|'T_STR2048'   |'Строка размерностью 2048 символов'
'F'|'T_TIMESTAMP' |'Дата время без часового пояса'
'G'|'T_TIMESTAMPZ'|'Дата время с часовым поясом'
'H'|'T_DATE'      |'Дата'
'I'|'IP_T'        |'IP адрес'
'Q'|'XML_T'       |'XML'
'K'|'T_GUID'      |'UUID'
'L'|'T_SYSNAME'   |'Имя таблицы'
'M'|'T_FIELDNAME' |'Имя поля базы данных'
'N'|'T_MONEY'     |'Денежная единица'
'P'|'T_INN_UL'    |'ИНН юридического лица'
'R'|'T_KPP'       |'КПП'
'S'|'T_PHONE_NMB' |'Номер телефона'

-- 2015-05-30 Эти типы добавляем
-- Это типы, которые пока не используюся в системе хранения данных
-- 'Я'|'T_TEXT'         |'Текст не лимитированной длины. Может содержать гигабайты текстовой информации в одной ячейке (Ограничено есть только со стороны файловой системы OS)'
-- 'E'|'T_DESCRIPTION'  |'Расширенное полное наименование'
--
--  Добавляем.
-- 'Ю'|'T_INN_PP'       |'ИНН физического лица'
-- 'И'|'T_DECIMAL'      |'Десятичное число'
 ------------------------------------------------------------------------------------ */

SET search_path = com, nso, ind, com, public;
DROP FUNCTION IF EXISTS com.com_f_value_check ( t_code1, t_str2048 );
CREATE OR REPLACE FUNCTION com.com_f_value_check (
					 p_small_code   t_code1       -- краткий код типа
					,p_value        t_str2048     -- значение 
)
  RETURNS result_t 
    LANGUAGE plpgsql 
    STABLE
    SECURITY INVOKER -- 2015-04-05 Nick
   AS 
$$									
   DECLARE 
    	rsp_main    result_t;
      _value      t_str2048;
      _type_mess  t_str1024;
      _rc         longint_t := -1;
      -----------------------------------------------------------------------
      --  Тестовые переменные.
      _test_small_t       small_t  ;    -- 'Короткое целое'
      _test_t_int         t_int    ;    -- 'Целое'
      _test_longint_t     longint_t;    -- 'Длинное целое'
     ---  _test_t_float       t_float  ;    -- 'Вещественое'     ЕГО НЕТ !!
      _test_t_boolean     t_boolean;    -- 'Логическое'
      _test_t_code1       t_code1  ;    -- 'Код размерностью 1 символ'
      _test_t_code2       t_code2  ;    -- 'Код размерностью 2 символа'
      _test_t_code5       t_code5  ;    -- 'Код размерностью 5 символов'
      _test_t_str20       t_str20  ;    -- 'Код размерностью 20 символов'
      _test_t_str60       t_str60  ;    -- 'Строка 60 символов'
      _test_t_str250      t_str250 ;    -- 'Строка 250 символов'
      -- --------------------------------------------------------------------
      _test_t_str1024     t_str1024   ; -- 'Строка размерностью 1024 символов'
      _test_t_str2048     t_str2048   ; -- 'Строка размерностью 2048 символов'
      _test_t_timestamp   t_timestamp ; -- 'Дата время без часового пояса'
      _test_t_timestampz  t_timestampz; -- 'Дата время с часовым поясом'
      _test_t_date        t_date      ; -- 'Дата'
      _test_ip_t          ip_t        ; -- 'IP адрес'
      _test_xml_t         xml_t       ; -- 'XML'
      _test_t_guid        t_guid      ; -- 'UUID'
      _test_t_sysname     t_sysname   ; -- 'Имя таблицы'
      _test_t_fieldname   t_fieldname ; -- 'Имя поля базы данных'
      _test_t_money       t_money     ; -- 'Денежная единица'
      _test_t_inn_ul      t_inn_ul    ; -- 'ИНН юридического лица'
      _test_t_kpp         t_kpp       ; -- 'КПП'
      _test_t_phone_nmb   t_phone_nmb ; -- 'Номер телефона'
      --
      -- 2015-05-30
      _test_t_inn_pp   t_inn_pp ;  -- 'ИНН физического лица'
      _test_t_decimal  t_decimal;  -- 'Десятичное число'
      _test_id_t  id_t;  -- Внутренняя ссылка   
      -----------------------------------------------------------------------
      cMESS00     t_str1024 := ': проверка, выполнена успешно';
      cMESS01     t_str1024 := ': значение NULL, возможны ошибки';

      cEMP        t_code1   := '';
      cNULL       t_code5   := 'NULL';
      c_FUNC_NAME t_sysname := 'com_f_value_check';  --название функции
      ----------------------------------------------------------------------- 
   BEGIN
      IF ( p_small_code = 'U' ) -- Узловой атрибут не должен иметь значений
      THEN
         _rc := -1;
         RAISE SQLSTATE '90001';
      END IF;

      _value := btrim ( p_value );

      -- Если значение атрибута = NULL  и на колонке нет ограничений, то тогда проверку не выполняем
   	IF (( _value IS NULL ) OR ( _value = cEMP ) OR ( btrim ( _value ) = cEMP ))   
      THEN
         _rc := -9; 
         rsp_main := ( _rc, cMESS01 );
   	 RETURN rsp_main; -- Значение NULL, возможны ошибки
   	END IF;		
         
   -- ======================================== -- 
   --   Проверяем ячейку на соответствие типу  --
   -- ======================================== -- 
      CASE p_small_code 
       WHEN '1' THEN      
                     _type_mess := '"Короткое целое"';
                     _test_small_t := cast ( _value AS small_t );
       WHEN '2' THEN       
                     _type_mess := '"Целое"';
                     _test_t_int := cast ( _value AS t_int );
       WHEN '3' THEN     
                     _type_mess := '"Длинное целое"';
                     _test_longint_t := cast ( _value AS longint_t );
--     WHEN '4' THEN       
--                      _type_mess := '"Вещественое"';
--                      _test_t_float := cast ( _value AS t_float );
       WHEN '5' THEN      
                     _type_mess := '"Логическое"';
                     _test_t_boolean := cast ( _value AS t_boolean );

       WHEN '6' THEN   
                     _type_mess := '"Код размерностью 1 символ"';
                     _test_t_code1 := cast ( _value AS t_code1 );
                     IF length (_value) > 1 THEN
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;
       WHEN '7' THEN      
                     _type_mess := '"Код размерностью 2 символа"';
                     _test_t_code2 := cast ( _value AS t_code2 );
                     IF length (_value) > 2 THEN
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;
       WHEN '8' THEN      
                     _type_mess := '"Код размерностью 5 символов"';
                     _test_t_code5 := cast ( _value AS t_code5 );
                     IF length (_value) > 5 THEN
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;
       WHEN '9' THEN      
                     _type_mess := '"Код размерностью 20 символов"';
                     _test_t_str20 := cast ( _value AS t_str20 );
                     IF length (_value) > 20 THEN
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;
       WHEN 'A' THEN      
                     _type_mess := '"Строка 60 символов"';
                     _test_t_str60 := cast ( _value AS t_str60 );
                     IF length (_value) > 60 THEN
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;
       WHEN 'B' THEN       
                     _type_mess := '"Строка 250 символов"';
                     _test_t_str250 := cast ( _value AS t_str250 );
                     IF length (_value) > 250 THEN
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;

       WHEN 'C' THEN       
                     _type_mess := '"Строка размерностью 1024 символов"';
                     _test_t_str1024 := cast ( _value AS t_str1024 );
                     IF length (_value) > 1024 THEN
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;

       WHEN 'D' THEN      
                     _type_mess := '"Строка размерностью 2048 символов"';
                     _test_t_str2048 := cast ( _value AS t_str2048 );
                     IF length (_value) > 2048 THEN
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;

       WHEN 'F' THEN      
                     _type_mess := '"Дата время без часового пояса"';
                     _test_t_timestamp := cast ( _value AS t_timestamp );

       WHEN 'G' THEN  
                     _type_mess := '"Дата время с часовым поясом"';
                     _test_t_timestampz := cast ( _value AS t_timestampz );

       WHEN 'H' THEN     
                     _type_mess := '"Дата"';
                     _test_t_timestampz := cast ( _value AS t_timestampz );

       WHEN 'I' THEN      
                     _type_mess := '"IP адрес"';
                     _test_ip_t := cast ( _value AS ip_t );

       WHEN 'Q' THEN      --  Нет никаких методов контроля на уровне DB-engine
                     _type_mess := '"XML"';
                     _test_xml_t := cast ( _value AS xml_t );

       WHEN 'K' THEN      
                     _type_mess := '"UUID"';
                     _test_t_guid := cast ( _value AS t_guid );

       WHEN 'T' THEN      
                     _type_mess := '"Ссылка на запись"'; -- Внутренняя ссылка на запись всегда UUID
                     _test_t_guid := cast ( _value AS t_guid ); -- !!!!!!!!!!!!!!!!!!!!
       
       WHEN 'L' THEN  -- Это не имя таблицы, это системное имя, немного неудачно назван домен в ЕБД     
                     _type_mess := '"Имя таблицы"';
                     _test_t_sysname := cast ( _value AS t_sysname );
                     IF length (_value) > 120 THEN  -- Его длина составляет 120 байт
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;

       WHEN 'M' THEN   -- Типы "L" и "M" легко могут быть сведены в один.
                     _type_mess := '"Имя поля базы данных"';
                     _test_t_fieldname := cast ( _value AS t_fieldname );
                     IF length (_value) > 120 THEN
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;

       WHEN 'N' THEN    
                     _type_mess := '"Денежная единица"';
                     _test_t_money := cast ( _value AS t_money );

       WHEN 'P' THEN    
                     _type_mess := '"ИНН юридического лица"';
                     _test_t_inn_ul := cast ( _value AS t_inn_ul );
                     IF length (_value) > 10 THEN
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;

       WHEN 'R' THEN   
                     _type_mess := '"КПП"';
                     _test_t_kpp := cast ( _value AS t_kpp );
                     IF length (_value) > 9 THEN
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;

       WHEN 'S' THEN   
                     _type_mess := '"Номер телефона"';
                     _test_t_phone_nmb := cast ( _value AS t_phone_nmb );
                     IF length (_value) > 10 THEN
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;

       WHEN 'Ю' THEN   
                     _type_mess := '"ИНН физического лица"';
                     _test_t_inn_pp := cast ( _value AS t_inn_pp );
                     IF length (_value) > 12 THEN
                        _rc := -2;
                        RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
                     END IF;

       WHEN 'И' THEN   
                     _type_mess := '"Десятичное число"';
                     _test_t_decimal := cast ( _value AS t_decimal );

       -- Nick 2017-10-09
       WHEN 'j' THEN   
                     _type_mess := '"4-х битовая строка"';
                     _test_t_decimal := cast ( _value AS public.t_bit4 );

       WHEN '-' THEN   
                     _type_mess := '"8-ми битовая строка"';
                     _test_t_decimal := cast ( _value AS public.t_bit8 );
       -- Nick 2017-10-09

         ELSE -- Автоматическое приведение к типу строка 2048 байт
             _type_mess := 'Приведение к типу "Строка 2048 символов"';
             _test_t_str2048 := cast ( _value AS t_str2048 );
             IF length (_value) > 2048 THEN
                _rc := -2;
                RAISE SQLSTATE '90000'; -- Ошибки контроля типа начинаются с символа 9   rc = -2
             END IF;
      END CASE;

      _rc := 0 ;
      rsp_main := ( _rc, ( _type_mess || cMESS00 ) );

      RETURN rsp_main; 

   EXCEPTION
   	WHEN OTHERS THEN 
   		BEGIN
    			rsp_main := ( _rc, com.f_error_handling ( SQLSTATE, SQLERRM, _type_mess, c_FUNC_NAME ));
   			RETURN rsp_main;				
   		END;
   END;
$$;
COMMENT ON FUNCTION com.com_f_value_check ( t_code1, t_str2048 ) IS '7217: Проверка соответствия значения ячейки типу атрибута';

/* Примеры выполнения

select * FROM com.com_f_value_check  ( '1', '2737');
select * FROM com.com_f_value_check  ( '1', 'aaa946');
select * FROM com.com_f_value_check  ( '2', 'aaa946');
select * FROM com.com_f_value_check  ( '3', '34.46');
-----
select * FROM com.com_f_value_check  ( '1', '2378990'); -- 'Необработанная ошибка: код = 22003, текст = value "2378990" is out of range for type smallint. Ошибка произошла в функции: "com_f_value_check".'
select * FROM com.com_f_value_check  ( '2', '23789999999999999990'); -- 'Необработанная ошибка: код = 22003, текст = value "23789999999999999990" is out of range for type integer. Ошибка произошла в функции: "com_f_value_check".'
--
SELECT * FROM com.com_f_value_check  ( '5', 't');
--
SELECT * FROM com.com_f_value_check  ( '5', 'weee');
SELECT * FROM com.com_f_value_check  ( '5', '1');
SELECT * FROM com.com_f_value_check  ( '5', '0');
--
SELECT * FROM com.com_f_value_check  ( '6', '0'); -- _type_mess := '"Код размерностью 1 символ"';
SELECT * FROM com.com_f_value_check  ( '6', '999990'); -- _type_mess := '"Код размерностью 1 символ"';                    

SELECT * FROM com.com_f_value_check  ( 'F', '999990');     -- 'Необработанная ошибка: код = 22008, текст = date/time field value out of range: "999990". Ошибка произошла в функции: "com_f_value_check".'
SELECT * FROM com.com_f_value_check  ( 'F', '999AAA990');  -- 'Необработанная ошибка: код = 22007, текст = invalid input syntax for type timestamp: "999AAA990". Ошибка произошла в функции: "com_f_value_check".'                  
SELECT * FROM com.com_f_value_check  ( 'F', '1200-01-30 12:34:66');  -- 'Необработанная ошибка: код = 22008, текст = date/time field value out of range: "1200-01-30 12:34:66". Ошибка произошла в функции: "com_f_value_check".'
SELECT * FROM com.com_f_value_check  ( 'F', '1200-01-30 12:34:46'); -- ОК

SELECT * FROM com.com_f_value_check  ( 'И', '16.566'); -- '"XML": проверка, выполнена успешно'  реально не выполняется
--
SELECT * FROM com.com_f_value_check  ( 'Q', 'aaa94sss6'); -- '"XML": проверка, выполнена успешно'  реально не выполняется
--
SELECT * FROM com.com_f_value_check  ( 'I', 'aaa94sss6'); -- 'Символы недействительные для типа "IP адрес", величина: "aaa94sss6". Ошибка произошла в функции: "com_f_value_check".'
SELECT * FROM com.com_f_value_check  ( 'I', '192.168.1.120'); -- '"IP адрес": проверка, выполнена успешно'
--

SELECT * FROM com.com_f_value_check  ( 'K', 'aaa94sss6'); -- 'Символы недействительные для типа "UUID", величина: "aaa94sss6". Ошибка произошла в функции: "com_f_value_check".' OK
SELECT * FROM com.com_f_value_check  ( 'K', '12369211093'); -- 'Символы недействительные для типа "UUID", величина: "12369211093". Ошибка произошла в функции: "com_f_value_check".' OK
--
SELECT * FROM com.com_f_value_check  ( 'T', 'aaa94sss6'); -- 'Символы недействительные для типа "Ссылка на запись", величина: "aaa94sss6". Ошибка произошла в функции: "com_f_value_check".' OK
SELECT * FROM com.com_f_value_check  ( 'T', '957905a1-adc8-4e07-8615-3bcac7ba3788'); -- 'Символы недействительные для типа "UUID", величина: "12369211093". Ошибка произошла в функции: "com_f_value_check".' OK

select * FROM com.com_f_value_check  ( '1', '27375747575677567567')
-1|'Необработанная ошибка: код = 22003, текст = value "27375747575677567567" is out of range for type smallint. Ошибка произошла в функции: "com_f_value_check".'

select * FROM com.com_f_value_check  ( 'X', '27375747575677567567')
  */
