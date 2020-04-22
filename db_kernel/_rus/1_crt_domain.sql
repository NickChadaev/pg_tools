/*===============================================================================================================*/
/* DBMS name:      PostgreSQL 8                                                                                  */
/* Created on:     10.02.2015 18:25:11                                                                           */
/* ------------------------------------------------------------------------------------------------------------- */
/* 2015-03-17   t_sysname, t_fieldname - увеличиваем длину до 120 байт                                           */
/*                                 добавлены t_kpp, t_arr_code.                                                  */
/* 2015-07-24   Добавлен тип t_json                                                                              */
/* 2015-07-26   Изменен тип result_t. result_t.errm VARCHAR (2048)                                               */
/* 2015-07-31   Добавлен тип t_interval                                                                          */ 
/* 2015-10-10   Domain: t_arr_nmb                                                                                */
/* 2016_02_13   Добавлен t_arr_boolean                                                                           */
/* 2016-04-05   Добавлен t_filename                                                                              */
/* 2016-05-18   Добавлен result_long_t                                                                           */ 
/* 2016-12-06   Добавлен t_arr_guid                                                                              */  
/* 2017-06-11   Добавлен t_arr_code1 (массив CHAR(1)). ЦОД. Nick                                                 */
/* 2017-09-12   Добавлен column_t2 "Пользовательский тип для хранения. Краткой информации о столбце. Версия 2. K */
/* 2017-10-09   Добавлены домены  t_bit4, t_bit8, t_bit16.                                                       */       
/* 2019-04-23   Тип для хранения результата GET STACKER DIAGNOSTIC.                                              */ 
/*===============================================================================================================*/

SET search_path=PUBLIC, pg_catalog;

/*==============================================================*/
/* Domain: id_t                                                 */
/*==============================================================*/
create domain id_t as INT8;

comment on domain id_t is
'Идентификатор';

/*==============================================================*/
/* Domain: ip_t                                                 */
/*==============================================================*/
create domain ip_t as INET;  -- VARCHAR(15);   2015-03-17

comment on domain ip_t is
'IP адрес';

/*==============================================================*/
/* Domain: small_t                                              */
/*==============================================================*/
create domain small_t as INT2;
comment on domain small_t IS 'Короткое целое';

-- Добавлено Nick 2015-03-17
/*==============================================================*/
/* Domain: t_int                                                */
/*==============================================================*/
create domain t_int as INT4;
comment on domain t_int IS 'Целое';
--
/*==============================================================*/
/* Domain: longint_t                                            */
/*==============================================================*/
create domain longint_t as INT8;
comment on domain longint_t IS 'Длинное целое';
-- Добавлено Nick 2015-03-17

/*==============================================================*/
/* Domain: t_blob                                               */
/*==============================================================*/
create domain t_blob as bytea;

comment on domain t_blob is
'Нестуктурированная бинарная информация';

/*==============================================================*/
/* Domain: t_boolean                                            */
/*==============================================================*/
create domain t_boolean as BOOL;

comment on domain t_boolean is
'Логическое';

/*==============================================================*/
/* Domain: t_code1                                              */
/*==============================================================*/
create domain t_code1 as CHAR(1);

comment on domain t_code1 is
'Код размерностью 1 символ';

/*==============================================================*/
/* Domain: t_code2                                              */
/*==============================================================*/
create domain t_code2 as CHAR(2);

comment on domain t_code2 is
'Код размерностью 2 символа';
   
--
-- Добавил Nick 2015-03-18
--
/*==============================================================*/
/* Domain: t_code5                                              */
/*==============================================================*/
create domain t_code5 as CHAR(5);

comment on domain t_code5 is
'Код размерностью 5 символов';

/*==============================================================*/
/* Domain: t_guid                                               */
/*==============================================================*/
create domain t_guid as uuid;

comment on domain t_guid is
'UUID';

/*==============================================================*/
/* Domain: t_str1024                                            */
/*==============================================================*/
create domain t_str1024 as VARCHAR(1024);

comment on domain t_str1024 is
'Строка 1024 символов';

/*==============================================================*/
/* Domain: t_str2048                                            */
/*==============================================================*/
create domain t_str2048 as VARCHAR(2048);

comment on domain t_str2048 is
'Строка размерностью 2048 символов';

/*==============================================================*/
/* Domain: t_str250                                             */
/*==============================================================*/
create domain t_str250 as VARCHAR(250);

comment on domain t_str250 is
'Строка 250 символов';

/*==============================================================*/
/* Domain: t_str60                                              */
/*==============================================================*/
create domain t_str60 as VARCHAR(60);

comment on domain t_str60 is
'Строка 60 символов';

/*==============================================================*/
/* Domain: t_timestamp                                          */
/*==============================================================*/
create domain t_timestamp as TIMESTAMP(0) WITHOUT TIME ZONE;

comment on domain t_timestamp is
'Дата время без часового пояса';

/*==============================================================*/
/* Domain: xml_t                                                */
/*==============================================================*/
create domain xml_t as XML;

comment on domain xml_t is
'XML';

-- ------------------------
-- 2015-02-15 Добавлено Nick
-- ------------------------
/*==============================================================*/
/* Domain:  t_oid                                               */
/*==============================================================*/
create domain t_oid as INT4;

comment on domain t_oid is
'Системный идентификатор';

/*==============================================================*/
/* Domain: t_sysname                                            */
/*==============================================================*/
create domain t_sysname as VARCHAR(120); -- 30 2015-03-17

comment on domain t_sysname is
'Имя таблицы';

/*==============================================================*/
/* Domain: t_fieldname                                          */
/*==============================================================*/
create domain t_fieldname as VARCHAR(120); -- 30 2015-03-17

comment on domain t_fieldname is
'Имя поля базы данных';

/*==============================================================*/
/* Domain: t_fullname                                           */
/*==============================================================*/
create domain t_fullname as VARCHAR(1024);

comment on domain t_fullname is
'Полное наименование';

/*==============================================================*/
/* Domain: t_arr_id                                             */
/*==============================================================*/
create domain t_arr_id as BIGINT [];

comment on domain t_arr_id is
'Массив идентификаторов';
--
/*==============================================================*/
/* Domain: t_arr_code                                           */
/*==============================================================*/
CREATE domain t_arr_code as VARCHAR(60) []; -- Nick 2015-03-17

COMMENT ON domain t_arr_code IS 
'Массив кодов';
--

/*==============================================================*/
/* Domain: t_code6                                              */
/*==============================================================*/
create domain t_code6 as VARCHAR(6);

comment on domain t_code6 is
'Код размерностью 6 символов';

/*==============================================================*/
/* Domain: t_str100                                             */
/*==============================================================*/
create domain t_str100 as VARCHAR(100);

comment on domain t_str100 is
'Строка 100 символов';
-- ---------------------------------------------------------------
-- 2015-03-17 Добавлено Nick
/*==============================================================*/
/* Domain: t_description                                        */
/*==============================================================*/
CREATE domain t_description AS VARCHAR;
COMMENT ON domain t_description IS 'Расширенное полное наименование';
--
/*==============================================================*/
/* Domain: t_inn_ul                                             */
/*==============================================================*/
create domain t_inn_ul as CHAR(10);
comment on domain t_inn_ul IS 'ИНН юридического лица';
--
/*==============================================================*/
/* Domain: t_inn_pp                                             */
/*==============================================================*/
create domain t_inn_pp as CHAR(12);
comment on domain t_inn_pp IS 'ИНН физического лица';
--
/*==============================================================*/
/* Domain:  t_money                                             */
/*==============================================================*/
create domain t_money as NUMERIC(15,2);
comment on domain t_money IS 'Денежная единица';
--
/*==============================================================*/
/* Domain: t_kpp                                                */
/*==============================================================*/
create domain t_kpp as CHAR(9);
comment on domain t_kpp IS 'КПП';
--
-- 2015-03-27		
--		
/*==============================================================*/
/* Domain: t_phone_nmb                                          */
/*==============================================================*/
CREATE domain t_phone_nmb AS CHAR(10);
COMMENT ON domain t_phone_nmb IS 'Номер телефона';

--- 2015-03-30 -----------------------------------------
/*==============================================================*/
/* Domain: t_date                                               */
/*==============================================================*/
CREATE DOMAIN t_date AS date;
COMMENT ON DOMAIN t_date IS 'Дата';
 
/*==============================================================*/
/* Domain: t_shortname                                          */
/*==============================================================*/
CREATE DOMAIN t_shortname AS VARCHAR(100);
COMMENT ON DOMAIN t_shortname IS 'Краткое наименование';

/*==============================================================*/
/* Domain: t_str20                                              */
/*==============================================================*/
CREATE DOMAIN t_str20 AS VARCHAR(20);
COMMENT ON DOMAIN t_str20 IS 'Строка 20 символов';

/*==============================================================*/
/* Domain: t_str4096                                            */
/*==============================================================*/
CREATE DOMAIN t_str4096 AS VARCHAR(4096);
COMMENT ON DOMAIN t_str4096 IS 'Строка 4096 символов';
--
-- 2015-04-05 
--
/*==============================================================*/
/* Domain: t_timestampz                                         */
/*==============================================================*/
create domain t_timestampz as TIMESTAMP(3) WITH TIME ZONE;

comment on domain t_timestampz is
'Дата время с часовым поясом';
--
-- 2015-04-21 
--
/*==============================================================*/
/* Domain: t_arr_values                                         */
/*==============================================================*/
CREATE domain t_arr_values as VARCHAR(2048) [];  
COMMENT ON domain t_arr_values IS 
'Массив значений';
--
-- 2015-05-27 Роман
--  
CREATE DOMAIN t_text AS text;
COMMENT ON DOMAIN t_text IS 'Текст не лимитированной длины.';
--
-- 2015-05-24 Дима Волокитин
--
CREATE DOMAIN t_decimal AS DECIMAL (17,6);
COMMENT ON DOMAIN t_decimal IS 'Десятичное число';

-- ================================================================ --
--            ТИПЫ ОПРЕДЕЛЁННЫЕ ПОЛЬЗОВАТЕЛЕМ.                      -- 
-- ================================================================ --

-- ================================================================ --
--  2013-09-10 Света.                                               --
--      Пользовательский тип для индикации успешности выполнения,   --
--      переменные такого типа должны возвращатся каждой функцией,  -- 
--      которая выполняет DDL-операции.                             -- 
-- ================================================================ --
--  2015-07-26 Nick. Длина errm увеличена до 2048 байт.             -- 
--  2018-12-14 Nick. errm типа text.                                --
-- ================================================================ --
CREATE TYPE result_t AS ( rc bigint, errm VARCHAR(2048) );
COMMENT ON TYPE result_t 
   IS 'Пользовательский тип для индикации успешности выполнения, переменные такого типа должны возвращатся каждой функцией, которая выполняет DDL-операции';

COMMENT ON COLUMN result_t.rc   IS 'Код возврата';
COMMENT ON COLUMN result_t.errm IS 'Сообщение об ошибке';

--
-- ALTER TYPE result_t ALTER ATTRIBUTE errm TYPE character varying(2048)  CASCADE;
--
-- ======================================================
-- 2015-04-22 Nick
--       Пользовательский тип для хранения краткой 
--             информации о столбце
-- ======================================================
CREATE TYPE column_t AS ( col_id bigint, col_stype CHAR(1), key_stype CHAR(1) );
COMMENT ON TYPE column_t 
   IS 'Пользовательский тип для хранения краткой информации о столбце';

COMMENT ON COLUMN column_t.col_id   IS 'Идентификатор столбца';
COMMENT ON COLUMN column_t.col_stype IS 'Код типа данных';
COMMENT ON COLUMN column_t.key_stype IS 'Код типа ключа';

-- ==============================================================
-- 2015-06-09 Роман
--      Пользовательский тип для хранения информации об ошибке.
-- ==============================================================
CREATE TYPE t_error_head AS (
			err_code    PUBLIC.t_code5,
			message_out PUBLIC.t_str2048, --  Увеличил длину 2015-08-05 Nick
			sch_name    PUBLIC.t_sysname,
			func_name   PUBLIC.t_sysname
);
COMMENT ON TYPE t_error_head IS 'Тип описывает заголовок ошибки';

-- =======================================
--   2015-07-24 Nick  Добавлен тип JSON
-- =======================================
CREATE DOMAIN t_json AS JSON;
COMMENT ON DOMAIN t_json IS 'Тип JSON (Java Script Objects Notation)';

-- =========================================
--   2015-07-31 Nick  Добавлен тип INTERVAL
-- =========================================
CREATE DOMAIN t_interval AS INTERVAL;
COMMENT ON DOMAIN t_interval IS 'Интервал';
--
/*==============================================================*/
/* 2015-10-10  Domain: t_arr_nmb                                */
/*==============================================================*/
CREATE domain t_arr_nmb as INT2 [];  
COMMENT ON domain t_arr_nmb IS 
'Массив коротких целых';

/*==============================================================*/
/* 2015-10-10  Domain: t_arr_text                                */
/*==============================================================*/
CREATE domain t_arr_text as TEXT [];  
COMMENT ON domain t_arr_text IS 
'Массив текстов не лимитированной длины.';

/*==============================================================*/
/* 2016-02-12  Domain: t_arr_boolean                            */
/*==============================================================*/
CREATE domain t_arr_boolean AS BOOLEAN [];  
COMMENT ON domain t_arr_boolean IS 'Массив логических значений';

/*==============================================================*/
/* 2016-04-05  Domain: t_filename                               */
/*==============================================================*/
CREATE DOMAIN t_filename AS VARCHAR ( 1024 );
COMMENT ON DOMAIN t_filename IS 'Имя внешнего файла';

/*==============================================================*/
/* 2016-05-18  Domain: result_long_t                            */
/*==============================================================*/
CREATE TYPE result_long_t AS ( rc bigint, errm text );
COMMENT ON TYPE result_long_t 
   IS 'Пользовательский тип для индикации успешности выполнения, переменные такого типа должны возвращатся каждой функцией, которая выполняет DDL-операции';

COMMENT ON COLUMN result_long_t.rc   IS 'Код возврата';
COMMENT ON COLUMN result_long_t.errm IS 'Сообщение об ошибке';

/*==============================================================*/
/* 2016-12-18  Domain: t_arr_guid                               */
/*==============================================================*/
CREATE DOMAIN public.t_arr_guid AS uuid[];

COMMENT ON DOMAIN public.t_arr_guid IS 'Массив UUID';

/*==============================================================*/
/* 2017-06-10  Domain: t_arr_code1   Nick                       */
/*==============================================================*/
CREATE DOMAIN public.t_arr_code1 AS CHAR (1)[];

COMMENT ON DOMAIN public.t_arr_code1 IS 'Массив CHAR(1) K';

-- ======================================================
-- 2017-05-21 Nick
--   Расширение пользовательского типа для хранения краткой 
--             информации о столбце
-- ======================================================
CREATE TYPE column_t2 AS ( col_id bigint
                         , col_nmb   smallint
                         , col_code  varchar(60)
                         , col_stype CHAR(1) 
                         , key_stype CHAR(1) 
);
COMMENT ON TYPE column_t2 
   IS 'Пользовательский тип для хранения краткой информации о столбце. Версия 2. K';

COMMENT ON COLUMN column_t2.col_id    IS 'Идентификатор столбца';
COMMENT ON COLUMN column_t2.col_nmb   IS 'Номер столбца';
COMMENT ON COLUMN column_t2.col_code  IS 'Код столбца';
COMMENT ON COLUMN column_t2.col_stype IS 'Код типа данных';
COMMENT ON COLUMN column_t2.key_stype IS 'Код типа ключа';

/*==============================================================*/
/* 2017-10-09  Domain: t_bit4, t_bit8, t_bit16.                 */
/*==============================================================*/
CREATE DOMAIN public.t_bit4 AS varbit(4);
COMMENT ON DOMAIN public.t_bit4 IS '4-х битовая строка';
--
CREATE DOMAIN public.t_bit8 AS varbit(8);
COMMENT ON DOMAIN public.t_bit8 IS '8-ми битовая строка';
--
CREATE DOMAIN public.t_bit16 AS varbit(16);
COMMENT ON DOMAIN public.t_bit16 IS '16-ти битовая строка';

-- ==========================================================
-- 2019-04-23 Nick
--       Тип для хранения результата GET STACKER DIAGNOSTIC.
-- ==========================================================

CREATE TYPE exception_type_t AS (
       state            text
      ,schema_name      text 
      ,func_name        text
      ,table_name       text 	      
      ,constraint_name  text     
      ,column_name      text	      
      ,datatype         text
      ,message          text 
      ,detail           text
      ,hint             text
      ,context          text
);


COMMENT ON TYPE exception_type_t IS 'Тип для хранения результата GET STACKER DIAGNOSTIC. K';

COMMENT ON COLUMN exception_type_t.state           IS 'Код исключения SQLSTATE';
COMMENT ON COLUMN exception_type_t.schema_name     IS 'Имя схемы';
COMMENT ON COLUMN exception_type_t.func_name       IS 'Имя функции';
COMMENT ON COLUMN exception_type_t.table_name      IS 'Имя таблицы';
COMMENT ON COLUMN exception_type_t.constraint_name IS 'Имя ограничения';
COMMENT ON COLUMN exception_type_t.column_name     IS 'Имя столбца';
COMMENT ON COLUMN exception_type_t.datatype        IS 'Имя типа данных';
COMMENT ON COLUMN exception_type_t.message         IS 'Сообщение';
COMMENT ON COLUMN exception_type_t.detail          IS 'Детали';
COMMENT ON COLUMN exception_type_t.hint            IS 'Подсказка';
COMMENT ON COLUMN exception_type_t.context         IS 'Контекст (стек вызовов)';
