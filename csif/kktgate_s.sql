--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 13.9 (Ubuntu 13.9-1.pgdg18.04+1)

-- Started on 2023-07-25 10:35:06 MSK

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 25 (class 2615 OID 1509701)
-- Name: _OLD_1_fiscalization; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "_OLD_1_fiscalization";


ALTER SCHEMA "_OLD_1_fiscalization" OWNER TO postgres;

--
-- TOC entry 7864 (class 0 OID 0)
-- Dependencies: 25
-- Name: SCHEMA "_OLD_1_fiscalization"; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA "_OLD_1_fiscalization" IS 'TRIAL-1 Версия  2023-02-17';


--
-- TOC entry 23 (class 2615 OID 1607937)
-- Name: _OLD_4_fiscalization; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "_OLD_4_fiscalization";


ALTER SCHEMA "_OLD_4_fiscalization" OWNER TO postgres;

--
-- TOC entry 7865 (class 0 OID 0)
-- Dependencies: 23
-- Name: SCHEMA "_OLD_4_fiscalization"; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA "_OLD_4_fiscalization" IS 'TRIAL-4 Версия  2023-03-02';


--
-- TOC entry 24 (class 2615 OID 1614925)
-- Name: _OLD_5_fiscalization; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "_OLD_5_fiscalization";


ALTER SCHEMA "_OLD_5_fiscalization" OWNER TO postgres;

--
-- TOC entry 7866 (class 0 OID 0)
-- Dependencies: 24
-- Name: SCHEMA "_OLD_5_fiscalization"; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA "_OLD_5_fiscalization" IS 'TRIAL-5 Версия  2023-03-09';


--
-- TOC entry 26 (class 2615 OID 1618427)
-- Name: _OLD_6_fiscalization; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "_OLD_6_fiscalization";


ALTER SCHEMA "_OLD_6_fiscalization" OWNER TO postgres;

--
-- TOC entry 7867 (class 0 OID 0)
-- Dependencies: 26
-- Name: SCHEMA "_OLD_6_fiscalization"; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA "_OLD_6_fiscalization" IS 'TRIAL-6  Версия 2023-03-10  Схема хранения с основными операциями:  INSERT, DELETE.';


--
-- TOC entry 29 (class 2615 OID 1867310)
-- Name: _OLD_7_fiscalization; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "_OLD_7_fiscalization";


ALTER SCHEMA "_OLD_7_fiscalization" OWNER TO postgres;

--
-- TOC entry 7868 (class 0 OID 0)
-- Dependencies: 29
-- Name: SCHEMA "_OLD_7_fiscalization"; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA "_OLD_7_fiscalization" IS 'TRIAL-7 Версия  2023-03-21';


--
-- TOC entry 22 (class 2615 OID 1510644)
-- Name: dict; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA dict;


ALTER SCHEMA dict OWNER TO postgres;

--
-- TOC entry 7869 (class 0 OID 0)
-- Dependencies: 22
-- Name: SCHEMA dict; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA dict IS 'Справочники';


--
-- TOC entry 30 (class 2615 OID 2111812)
-- Name: fiscalization; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA fiscalization;


ALTER SCHEMA fiscalization OWNER TO postgres;

--
-- TOC entry 7870 (class 0 OID 0)
-- Dependencies: 30
-- Name: SCHEMA fiscalization; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA fiscalization IS 'TRIAL-9 Версия  2023-05-04';


--
-- TOC entry 28 (class 2615 OID 2111776)
-- Name: fiscalization_part; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA fiscalization_part;


ALTER SCHEMA fiscalization_part OWNER TO postgres;

--
-- TOC entry 7871 (class 0 OID 0)
-- Dependencies: 28
-- Name: SCHEMA fiscalization_part; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA fiscalization_part IS 'Секции, по диапазону дат';


--
-- TOC entry 31 (class 2615 OID 2111772)
-- Name: fsc_receipt_pcg; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA fsc_receipt_pcg;


ALTER SCHEMA fsc_receipt_pcg OWNER TO postgres;

--
-- TOC entry 7872 (class 0 OID 0)
-- Dependencies: 31
-- Name: SCHEMA fsc_receipt_pcg; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA fsc_receipt_pcg IS 'Функциональная схема. Версия от 2023-05-18';


--
-- TOC entry 10 (class 2615 OID 491531)
-- Name: pgagent; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgagent;


ALTER SCHEMA pgagent OWNER TO postgres;

--
-- TOC entry 7873 (class 0 OID 0)
-- Dependencies: 10
-- Name: SCHEMA pgagent; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';


--
-- TOC entry 12 (class 2615 OID 46843)
-- Name: stb_pre_aggregations; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA stb_pre_aggregations;


ALTER SCHEMA stb_pre_aggregations OWNER TO postgres;

--
-- TOC entry 27 (class 2615 OID 2111624)
-- Name: task; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA task;


ALTER SCHEMA task OWNER TO postgres;

--
-- TOC entry 7875 (class 0 OID 0)
-- Dependencies: 27
-- Name: SCHEMA task; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA task IS 'ЗАДАЧИ. TRIAL-7 Версия  2022-04-04';


--
-- TOC entry 4 (class 3079 OID 46844)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- TOC entry 7876 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- TOC entry 2 (class 3079 OID 491532)
-- Name: pgagent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;


--
-- TOC entry 7877 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgagent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';


--
-- TOC entry 5 (class 3079 OID 1475881)
-- Name: postgres_fdw; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgres_fdw WITH SCHEMA public;


--
-- TOC entry 7878 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION postgres_fdw; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgres_fdw IS 'foreign-data wrapper for remote PostgreSQL servers';


--
-- TOC entry 3 (class 3079 OID 1614904)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 7879 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 2238 (class 1247 OID 2115213)
-- Name: agent_info_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.agent_info_t AS ENUM (
    'bank_paying_agent',
    'bank_paying_subagent',
    'paying_agent',
    'paying_subagent',
    'attorney',
    'commission_agent',
    'another'
);


ALTER TYPE public.agent_info_t OWNER TO postgres;

--
-- TOC entry 2250 (class 1247 OID 2115533)
-- Name: correction_type_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.correction_type_t AS ENUM (
    'self',
    'instruction'
);


ALTER TYPE public.correction_type_t OWNER TO postgres;

--
-- TOC entry 7880 (class 0 OID 0)
-- Dependencies: 2250
-- Name: TYPE correction_type_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.correction_type_t IS 'Типы коррекций';


--
-- TOC entry 2226 (class 1247 OID 2115010)
-- Name: payment_method_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_method_t AS ENUM (
    'full_prepayment',
    'prepayment',
    'advance',
    'full_payment',
    'partial_payment',
    'credit',
    'credit_payment'
);


ALTER TYPE public.payment_method_t OWNER TO postgres;

--
-- TOC entry 7881 (class 0 OID 0)
-- Dependencies: 2226
-- Name: TYPE payment_method_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.payment_method_t IS 'Признак способа расчёта';


--
-- TOC entry 2247 (class 1247 OID 2115531)
-- Name: item_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.item_t AS (
	name text,
	price numeric(10,2),
	quantity numeric(8,3),
	measure integer,
	sum numeric(10,2),
	payment_method public.payment_method_t,
	payment_object integer,
	vat json,
	user_data text,
	excise numeric(10,2),
	country_code text,
	declaration_number text,
	mark_quantity json,
	mark_processing_mode text,
	sectoral_item_props json,
	mark_code json,
	agent_info json,
	supplier_info json
);


ALTER TYPE public.item_t OWNER TO postgres;

--
-- TOC entry 7882 (class 0 OID 0)
-- Dependencies: 2247
-- Name: TYPE item_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.item_t IS 'Описание товара/услуги';


--
-- TOC entry 2253 (class 1247 OID 2115578)
-- Name: operation_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.operation_t AS ENUM (
    'sell',
    'buy',
    'sell_refund',
    'buy_refund',
    'sell_correction',
    'buy_correction',
    'sell_refund_correction',
    'buy_refund_correction'
);


ALTER TYPE public.operation_t OWNER TO postgres;

--
-- TOC entry 7883 (class 0 OID 0)
-- Dependencies: 2253
-- Name: TYPE operation_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.operation_t IS 'Типы операций';


--
-- TOC entry 2244 (class 1247 OID 2115528)
-- Name: pmt_type_sum_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.pmt_type_sum_t AS (
	pmt_type integer,
	pmt_sum numeric(10,2)
);


ALTER TYPE public.pmt_type_sum_t OWNER TO postgres;

--
-- TOC entry 7884 (class 0 OID 0)
-- Dependencies: 2244
-- Name: TYPE pmt_type_sum_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.pmt_type_sum_t IS 'Вид и сумма к оплаты';


--
-- TOC entry 2235 (class 1247 OID 2115186)
-- Name: sectoral_item_props_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sectoral_item_props_t AS (
	federal_id text,
	date text,
	number text,
	value text
);


ALTER TYPE public.sectoral_item_props_t OWNER TO postgres;

--
-- TOC entry 7885 (class 0 OID 0)
-- Dependencies: 2235
-- Name: TYPE sectoral_item_props_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.sectoral_item_props_t IS 'Отраслевой реквизит товара';


--
-- TOC entry 2223 (class 1247 OID 2114939)
-- Name: sno_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sno_t AS ENUM (
    'osn',
    'usn_income',
    'usn_income_outcome',
    'envd',
    'esn',
    'patent'
);


ALTER TYPE public.sno_t OWNER TO postgres;

--
-- TOC entry 7886 (class 0 OID 0)
-- Dependencies: 2223
-- Name: TYPE sno_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.sno_t IS 'Система налогообложения';


--
-- TOC entry 2229 (class 1247 OID 2115097)
-- Name: vat_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.vat_t AS ENUM (
    'none',
    'vat0',
    'vat10',
    'vat110',
    'vat20',
    'vat120'
);


ALTER TYPE public.vat_t OWNER TO postgres;

--
-- TOC entry 7887 (class 0 OID 0)
-- Dependencies: 2229
-- Name: TYPE vat_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.vat_t IS 'Типы агентов';


--
-- TOC entry 2232 (class 1247 OID 2115173)
-- Name: vats_type_sum_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.vats_type_sum_t AS (
	vats_type public.vat_t,
	vats_sum numeric(10,2)
);


ALTER TYPE public.vats_type_sum_t OWNER TO postgres;

--
-- TOC entry 7888 (class 0 OID 0)
-- Dependencies: 2232
-- Name: TYPE vats_type_sum_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.vats_type_sum_t IS 'Налог на чек коррекции';


--
-- TOC entry 635 (class 1255 OID 2120394)
-- Name: f_xxx_replace_char(text); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.f_xxx_replace_char(p_str text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
    DECLARE
      PCHAR  CONSTANT text[]  = ARRAY[ 'Г. ЕКАТЕРИНБУРГ','Г. КРАСНОЯРСК','Г. ВОРОНЕЖ',
                              'Г. ХАБАРОВСК','Г. МОСКВА','*','&','$','@',':','.','(',')',
                              '/', '-', '_', '\','ЛС','N','"', '№'];
      --                        
      cEMP   CONSTANT text = ''; 
      _char  text;
      _r     text;
     
    BEGIN
        _r := upper(btrim(p_str));
        FOREACH _char IN ARRAY PCHAR 
           LOOP
           _r := REPLACE (_r, _char, cEMP);
           END LOOP;
           
        RETURN REPLACE (_r, ' ', ''); -- Только явно указанные константы
    END;
$_$;


ALTER FUNCTION fsc_receipt_pcg.f_xxx_replace_char(p_str text) OWNER TO postgres;

--
-- TOC entry 7889 (class 0 OID 0)
-- Dependencies: 635
-- Name: FUNCTION f_xxx_replace_char(p_str text); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.f_xxx_replace_char(p_str text) IS 'Функция удаляет мусорные символы из строки';


--
-- TOC entry 651 (class 1255 OID 2120413)
-- Name: fsc_additional_user_props_crt_1(text, text); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_additional_user_props_crt_1(p_name text, p_value text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
   -- ============================================================================ --
   --    2023-05-23  "additional_user_props" - Дополнительные реквизиты клиента
   -- ============================================================================ --

   DECLARE
     JKEY  CONSTANT text = 'additional_user_props';
     JKEYS CONSTANT text[] = array['name', 'value']::text[];  

     QTY_NAME CONSTANT integer := 64;
     QTY_VALUE CONSTANT integer := 256;

     __mess      text := '"%s": Все данные являются обязательными: "%s" = %L, "%s" = %L';
     __eqs_mess  text := '"%s": Длина "%s" должна быть равна %s символам';      
     
     __result json;
      
   BEGIN
      IF (p_name IS NULL) OR (p_value IS NULL) 
        THEN
              RAISE '%', format(__mess, JKEY, JKEYS[1], p_name, JKEYS[2], p_value);
              
        ELSIF NOT (char_length(p_name) <= QTY_NAME)
             THEN
                    RAISE '%', format(__eqs_mess, JKEY, JKEYS[1], QTY_NAME);
                    
        ELSIF NOT (char_length(p_value) <= QTY_VALUE)
             THEN
                    RAISE '%', format(__eqs_mess, JKEY, JKEYS[2], QTY_VALUE);
                    
      END IF;
   
      __result := json_strip_nulls (json_build_object(JKEYS[1], p_name, JKEYS[2], p_value));
       
       RETURN __result;
   END;
  
$$;


ALTER FUNCTION fsc_receipt_pcg.fsc_additional_user_props_crt_1(p_name text, p_value text) OWNER TO postgres;

--
-- TOC entry 7890 (class 0 OID 0)
-- Dependencies: 651
-- Name: FUNCTION fsc_additional_user_props_crt_1(p_name text, p_value text); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_additional_user_props_crt_1(p_name text, p_value text) IS 'Создание объекта "additional_user_props" - Дополнительные реквизиты клиента';


--
-- TOC entry 643 (class 1255 OID 2120401)
-- Name: fsc_agent_info_crt_2(public.agent_info_t, json, json, json); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_agent_info_crt_2(p_type public.agent_info_t, p_paying_agent json DEFAULT NULL::json, p_receive_payments_operator json DEFAULT NULL::json, p_money_transfer_operator json DEFAULT NULL::json) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
   -- ============================================================================ --
   --  2023-05-19  Все матрёшки (первого, второго и третьего уровней должны 
   --               возвращать значение, ключ -- в вызывающей функциии   ????
   --  2023-05-23  Создание объекта  "agent_info" - платёжный агент.
   -- ============================================================================ --

   DECLARE
     JKEY2 CONSTANT text = 'agent_info';
     JKEYS3 CONSTANT text[] = array['type', 'paying_agent', 'receive_payments_operator', 'money_transfer_operator']::text[];  

     __result json;
      
   BEGIN
       __result := json_build_object ( JKEYS3[1], p_type
                                      ,JKEYS3[2], p_paying_agent
                                      ,JKEYS3[3], p_receive_payments_operator
                                      ,JKEYS3[4], p_money_transfer_operator                                                                
       );
       
       RETURN json_strip_nulls (__result);
       
   END;
  
$$;


ALTER FUNCTION fsc_receipt_pcg.fsc_agent_info_crt_2(p_type public.agent_info_t, p_paying_agent json, p_receive_payments_operator json, p_money_transfer_operator json) OWNER TO postgres;

--
-- TOC entry 7891 (class 0 OID 0)
-- Dependencies: 643
-- Name: FUNCTION fsc_agent_info_crt_2(p_type public.agent_info_t, p_paying_agent json, p_receive_payments_operator json, p_money_transfer_operator json); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_agent_info_crt_2(p_type public.agent_info_t, p_paying_agent json, p_receive_payments_operator json, p_money_transfer_operator json) IS 'Создание объекта "Платёжный агент"';


--
-- TOC entry 650 (class 1255 OID 2120412)
-- Name: fsc_client_crt_1(text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_client_crt_1(p_name text DEFAULT NULL::text, p_inn text DEFAULT NULL::text, p_email text DEFAULT NULL::text, p_phone text DEFAULT NULL::text, p_birthdate text DEFAULT NULL::text, p_citizenship text DEFAULT NULL::text, p_document_code text DEFAULT NULL::text, p_document_data text DEFAULT NULL::text, p_address text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
   -- ============================================================================ --
   --    2023-05-18  Создание объекта  "client"  Уровень 1.
   -- ============================================================================ --

   DECLARE
     JKEY  CONSTANT text      := 'client';
     JKEYS CONSTANT text[]    := array['email', 'phone','name','inn','birthdate','citizenship','document_code','document_data','address']::text[];  
     JQ    CONSTANT integer[] := array[  64,     19,     256,   NULL,    10,          3,            2,               64,          256]::integer[];
     --                                   1       2       3      4      5           6             7                  8           9
     
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __eqs_mess  text := '"%s": Длина "%s" должна быть ровно %s символов';
     __eqn_mess  text := '"%s": Длина "%s" должна быть ровно %s цифр';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s" = %L, "%s" = %L';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';

     __jdata  text[];
     __result json;
      
   BEGIN
     __jdata := array [p_email, p_phone, p_name, p_inn, p_birthdate, p_citizenship, p_document_code, p_document_data, p_address];
     
     IF NOT (char_length(__jdata[1]) <= JQ[1]) 
       THEN
           RAISE '%', format (__lts_mess, JKEY, JKEYS[1], JQ[1]);              
            
       ELSIF NOT (char_length(__jdata[2]) <= JQ[2])
            THEN  
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[2], JQ[2]);      

       ELSIF NOT (char_length(__jdata[3]) <= JQ[3])
            THEN  
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[3], JQ[3]);   
                 
       ELSIF NOT (__jdata[4] ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[4], __jdata[4]);   
                 
       ELSIF NOT (char_length(__jdata[5]) = JQ[5])
             THEN
                 RAISE '%', format (__eqs_mess, JKEY, JKEYS[5], JQ[5]);                 
                 
       ELSIF NOT (char_length(__jdata[6]) = JQ[6])
             THEN
                 RAISE '%', format (__eqs_mess, JKEY, JKEYS[6], JQ[6]);                 

       ELSIF NOT (char_length(__jdata[7]) = JQ[7])
             THEN
                 RAISE '%', format (__eqs_mess, JKEY, JKEYS[7], JQ[7]);                 
                 
       ELSIF NOT (char_length(__jdata[8]) <= JQ[8])
            THEN  
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[8], JQ[8]);   

       ELSIF NOT (char_length(__jdata[9]) <= JQ[9])
            THEN  
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[9], JQ[9]);   
                 
       END IF;
      
       __result := json_strip_nulls (json_object (JKEYS, __jdata));
       
       RETURN __result;
   END;
  
$_$;


ALTER FUNCTION fsc_receipt_pcg.fsc_client_crt_1(p_name text, p_inn text, p_email text, p_phone text, p_birthdate text, p_citizenship text, p_document_code text, p_document_data text, p_address text) OWNER TO postgres;

--
-- TOC entry 7892 (class 0 OID 0)
-- Dependencies: 650
-- Name: FUNCTION fsc_client_crt_1(p_name text, p_inn text, p_email text, p_phone text, p_birthdate text, p_citizenship text, p_document_code text, p_document_data text, p_address text); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_client_crt_1(p_name text, p_inn text, p_email text, p_phone text, p_birthdate text, p_citizenship text, p_document_code text, p_document_data text, p_address text) IS 'Создание объекта "client"';


--
-- TOC entry 649 (class 1255 OID 2120411)
-- Name: fsc_company_crt_1(text, public.sno_t, text, text); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_company_crt_1(p_email text, p_sno public.sno_t, p_inn text, p_payment_address text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
   -- ============================================================================ --
   --    2023-05-18  Создание объекта  "company"
   -- ============================================================================ --

   DECLARE
     JKEY  CONSTANT text      := 'company';
     JKEYS CONSTANT text[]    := array['email',  'sno',   'inn', 'payment_address']::text[];  
     JQ    CONSTANT integer[] := array[  64,     NULL,    NULL,       256]::integer[];
     --                                   1        2        3          4      
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __eqs_mess  text := '"%s": Длина "%s" должна быть ровно %s символов';
     __eqn_mess  text := '"%s": Длина "%s" должна быть ровно %s цифр';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s" = %L, "%s" = %L, "%s" = %L, "%s" = %L';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';

     __jdata  text[];
     __result json;
      
   BEGIN
       __jdata := array [p_email, p_sno::text, p_inn, p_payment_address];

     IF (__jdata[1] IS NULL) OR (__jdata[2] IS NULL) OR 
        (__jdata[3] IS NULL) OR (__jdata[4] IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY 
                                  ,JKEYS[1], __jdata[1], JKEYS[2], __jdata[2]
                                  ,JKEYS[3], __jdata[3], JKEYS[4], __jdata[4]
            );      
            
       ELSIF NOT (__jdata[3] ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[3], __jdata[3]);   
                 
       ELSIF NOT (char_length(__jdata[4]) <= JQ[4])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[4], JQ[4]);                 
       END IF;       
       
       __result := json_strip_nulls (json_object (JKEYS, __jdata));
       
       RETURN __result;
   END;
  
$_$;


ALTER FUNCTION fsc_receipt_pcg.fsc_company_crt_1(p_email text, p_sno public.sno_t, p_inn text, p_payment_address text) OWNER TO postgres;

--
-- TOC entry 7893 (class 0 OID 0)
-- Dependencies: 649
-- Name: FUNCTION fsc_company_crt_1(p_email text, p_sno public.sno_t, p_inn text, p_payment_address text); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_company_crt_1(p_email text, p_sno public.sno_t, p_inn text, p_payment_address text) IS 'Создание объекта "company"';


--
-- TOC entry 654 (class 1255 OID 2120416)
-- Name: fsc_correction_crt_0(json, json, json, json, json, numeric, json, text, text, text, json, json, json); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_correction_crt_0(p_client json, p_company json, p_correction_info json, p_items json, p_payments json, p_total numeric, p_vats json DEFAULT NULL::json, p_cashier text DEFAULT NULL::text, p_cashier_inn text DEFAULT NULL::text, p_additional_check_props text DEFAULT NULL::text, p_additional_user_props json DEFAULT NULL::json, p_operating_check_props json DEFAULT NULL::json, p_sectoral_check_props json DEFAULT NULL::json) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
   -- ============================================================================ --
   --    2023-05-30  Создание объекта "correction"
   -- ============================================================================ --
   
   DECLARE
     JKEY  CONSTANT text      := 'correction';
     JKEYS CONSTANT text[]    := array [ 'client',                 'company',            'correction_info',             'items'
     --                                     1                         2                         3                         4      
                                       , 'payments',               'total',                  'vats',                   'cashier'
     --                                     5                         6                         7                         8      
                                       , 'cashier_inn', 'additional_check_props', 'additional_user_proips', 'operating_check_props'
     --                                     9                         10                       11                        12      
                                       , 'sectoral_check_props'     
     --                                     13                                       
                                       ]::text[];  
                                       
     JQ    CONSTANT integer[] := array[    NULL,                     NULL,                      NULL,                    NULL
                                          ,NULL,                     NULL,                      NULL,                     64                     
                                          ,NULL,                       16,                      NULL,                     NULL
                                          ,NULL
     ]::integer[];
     
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s", "%s", "%s", "%s", "%s", "%s"';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';

     __result json;
      
   BEGIN
   
     IF (p_client IS NULL) OR (p_company IS NULL) OR (p_correction_info IS NULL) OR
        (p_items IS NULL) OR (p_payments IS NULL) OR (p_total IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY, JKEYS[1], JKEYS[2], JKEYS[3], JKEYS[4], JKEYS[5], JKEYS[6]);      
            
       ELSIF NOT (p_cashier_inn ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[9], p_cashier_inn);   
                 
       ELSIF NOT (char_length(p_cashier) <= JQ[8])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[8], JQ[8]);                 
                 
       ELSIF NOT (char_length(p_additional_check_props) <= JQ[10])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[10], JQ[10]);                 
                 
       END IF;       
       
       __result := json_strip_nulls (json_build_object (
                 JKEYS  [1], p_client,      JKEYS  [2], p_company, JKEYS [3], p_correction_info, JKEYS[4], p_items
                ,JKEYS  [5], p_payments,    JKEYS  [6], p_total,   JKEYS [7], p_vats,            JKEYS[8], p_cashier
                ,JKEYS  [9], p_cashier_inn, JKEYS [10], p_additional_check_props, JKEYS[11], p_additional_user_props 
                ,JKEYS [12], p_operating_check_props
                ,JKEYS [13], p_sectoral_check_props  
                                    )
       );
       
       RETURN __result;
   END;
  
$_$;


ALTER FUNCTION fsc_receipt_pcg.fsc_correction_crt_0(p_client json, p_company json, p_correction_info json, p_items json, p_payments json, p_total numeric, p_vats json, p_cashier text, p_cashier_inn text, p_additional_check_props text, p_additional_user_props json, p_operating_check_props json, p_sectoral_check_props json) OWNER TO postgres;

--
-- TOC entry 7894 (class 0 OID 0)
-- Dependencies: 654
-- Name: FUNCTION fsc_correction_crt_0(p_client json, p_company json, p_correction_info json, p_items json, p_payments json, p_total numeric, p_vats json, p_cashier text, p_cashier_inn text, p_additional_check_props text, p_additional_user_props json, p_operating_check_props json, p_sectoral_check_props json); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_correction_crt_0(p_client json, p_company json, p_correction_info json, p_items json, p_payments json, p_total numeric, p_vats json, p_cashier text, p_cashier_inn text, p_additional_check_props text, p_additional_user_props json, p_operating_check_props json, p_sectoral_check_props json) IS 'Создание объекта "correction"';


--
-- TOC entry 652 (class 1255 OID 2120414)
-- Name: fsc_correction_info_crt_1(public.correction_type_t, date, text); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_correction_info_crt_1(p_type public.correction_type_t, p_base_date date, p_base_number text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
   -- ===================================================================================== --
   --  2023-05-30  Создание объекта  "correction_info" СВЕДЕНИЯ О КОРРЕКТИРУЮЩЕЙ ОПЕРАЦИИ
   -- ===================================================================================== --

   DECLARE
     JKEY  CONSTANT text      := 'correction_info';
     JKEYS CONSTANT text[]    := array['type', 'base_date', 'base_number']::text[];  
     JQ    CONSTANT integer[] := array[  NULL,    NULL,        32 ]::integer[];
     --                                   1        2            3     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s" = %L, "%s" = %L';

     __jdata  text[];
     __result json;
      
   BEGIN
       __jdata := array [p_type::text, to_char(p_base_date,'dd.mm.yyyy'), p_base_number];

     IF (__jdata[1] IS NULL) OR (__jdata[2] IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY, JKEYS[1], __jdata[1], JKEYS[2], __jdata[2]);      
            
       ELSIF NOT (char_length(__jdata[3]) <= JQ[3])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[3], JQ[3]);                 
       END IF;       
       
       __result := json_strip_nulls (json_object (JKEYS, __jdata));
       
       RETURN __result;
   END;
  
$$;


ALTER FUNCTION fsc_receipt_pcg.fsc_correction_info_crt_1(p_type public.correction_type_t, p_base_date date, p_base_number text) OWNER TO postgres;

--
-- TOC entry 7895 (class 0 OID 0)
-- Dependencies: 652
-- Name: FUNCTION fsc_correction_info_crt_1(p_type public.correction_type_t, p_base_date date, p_base_number text); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_correction_info_crt_1(p_type public.correction_type_t, p_base_date date, p_base_number text) IS 'Создание объекта  "correction_info" СВЕДЕНИЯ О КОРРЕКТИРУЮЩЕЙ ОПЕРАЦИИ';


--
-- TOC entry 633 (class 1255 OID 2120409)
-- Name: fsc_items_crt_1(public.item_t[]); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_items_crt_1(p_item public.item_t[]) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
   -- ============================================================================ --
   --    2023-05-18  Создание объекта  "item"
   -- ---------------------------------------------------------------------------- --
   --   Обязательные и опциональные аторибуты типа:
   --  
   --   CREATE TYPE item_t AS (    
   --      name                 text             -- Наименование товара/услуги      
   --     ,price                numeric (10,2)   -- Цена в рублях
   --     ,quantity             numeric (8,3)    -- Количество
   --     ,measure              integer          -- measure_t   -- Единица измерения  --!!! Значения контролирую в функции
   --     ,sum                  numeric (10,2)   -- Сумма в рублях
   --     ,payment_method       payment_method_t -- Способ расчёта
   --     ,payment_object       integer          -- Признак предмета расчёта  !!! Значения контролирую в функции
   --     ,vat                  json             -- Атрибуты налога на позицию
   -- -------------------------------------------------------------------------
   --     ,user_data            text          DEFAULT NULL -- Дополнительный реквизит предмета расчёта
   --     ,excise               numeric(10,2) DEFAULT NULL -- Сумма акциза в рублях 
   --     ,country_code         text          DEFAULT NULL -- Цифровой код страны происхождения товара 
   --     ,declaration_number   text          DEFAULT NULL -- Номер таможенной декларации
   --     ,mark_quantity        json          DEFAULT NULL -- Дробное количество маркированного товара
   --     ,mark_processing_mode text          DEFAULT NULL -- 
   --     ,sectoral_item_props  json          DEFAULT NULL --
   --     ,mark_code            json          DEFAULT NULL -- МАркировка средствами идентификации 
   --     ,agent_info           json          DEFAULT NULL -- Атрибуты агента
   --     ,supplier_info        json          DEFAULT NULL -- Поставщик 
   --                                         Поле обязательно, если передан «agent_info». 
   -- );
   --   COMMENT ON TYPE item_t IS 'Описание товара/услуги';
   -- ============================================================================ --

   DECLARE
     QTY_ITMS CONSTANT integer := 100; 
     
     JKEY     CONSTANT text := 'item'; --  1/7/13          2/8/14                   3/9/15                4/10/16       5/11/17             6/12/18                                
     JKEYS    CONSTANT text[]:= ARRAY [ 'name',           'price',                'quantity',            'measure',   'sum',          'payment_method'      
                                       ,'payment_object', 'vat',                  'user_data',           'excise',    'country_code', 'declaration_number'  
                                       ,'mark_quantity',  'mark_processing_mode', 'sectoral_item_props', 'mark_code', 'agent_info',   'supplier_info'
                                ]::text[];

     JMAX CONSTANT numeric (10,2)[]:= ARRAY [ 
                                        128.0,            42949672.95,              99999.99,               NULL,     42949672.95,     NULL      
                                       , NULL,              NULL,                     64.0,              42949672.95,    3.0,           32.0  
                                       , NULL,              NULL,                     NULL,                 NULL,        NULL,         NULL          
                                ]::text[];

     MEASURE_0 CONSTANT int4range  := int4range('[0,0]');                            
     MEASURE_1 CONSTANT int4range  := int4range('[10,12]');                            
     MEASURE_2 CONSTANT int4range  := int4range('[20,22]');                            
     MEASURE_3 CONSTANT int4range  := int4range('[30,32]');                            
     MEASURE_4 CONSTANT int4range  := int4range('[40,42]');                            
     MEASURE_5 CONSTANT int4range  := int4range('[50,51]');                            
     MEASURE_6 CONSTANT int4range  := int4range('[70,73]');                            
     MEASURE_7 CONSTANT int4range  := int4range('[80,83]');                            
     MEASURE_8 CONSTANT int4range  := int4range('[255,255]');   
     
     PAYMENT_OBJECT_0 CONSTANT int4range  := int4range('[1,27]');  
     PAYMENT_OBJECT_1 CONSTANT int4range  := int4range('[30,33]');                               
                                
     __lts_items_mess text := '"%s": Количество различных товаров/услуг не должно превышать: %s';
     __lts_mess       text := '"%s": Длина "%s" должна быть не больше %s символов';
     __eqs_mess       text := '"%s": Длина "%s" должна быть равна %s символам';     
     __ltn_mess       text := '"%s": Величина "%s" не должна превышать %s';
     __ptn_mess       text := '"%s": Величина "%s" не должна превышать %s и должна быть положительной';    
     __msr_mess       text := '"%s": Неправильный тип единицы измерения товара: "%s" = %s';           
     __mpo_mess       text := '"%s": Неправильный признак предмета расчёта: "%s" = %s';
     
     __null_mess text := '"%s[%s]": Все данные являются обязательными: "%s" = %L, "%s" = %L, "%s" = %L, "%s" = %L'
                         ', "%s" = %L, "%s" = %L, "%s" = %L, "%s" = %L';     
     __items item_t[];
     __item  item_t;
     __i  integer;
     
     __result json;
      
   BEGIN
      IF (array_length (p_item, 1) > QTY_ITMS) 
        THEN
          RAISE '%', format (__lts_items_mess, JKEY, QTY_ITMS);
      END IF;  
      
      -- Теперь цикл по входному массиву, на каждой итерации, выполняются проверки.
      
      __i := 1;
      FOREACH __item IN ARRAY p_item
      
          LOOP
             IF  (__item.name IS NULL) OR (__item.price IS NULL) OR (__item.quantity IS NULL) OR 
                 (__item.measure IS NULL) OR (__item.sum IS NULL) OR (__item.payment_method IS NULL) OR 
                 (__item.payment_object IS NULL) OR (__item.vat IS NULL)
               THEN
                    RAISE '%', format (__null_mess, JKEY, __i
                                              , JKEYS[1], __item.name  
                                              , JKEYS[2], __item.price
                                              , JKEYS[3], __item.quantity
                                              , JKEYS[4], __item.measure
                                              , JKEYS[5], __item.sum
                                              , JKEYS[6], __item.payment_method 
                                              , JKEYS[7], __item.payment_object  
                                              , JKEYS[8], __item.vat
                                      );

                ELSIF NOT (char_length(__item.name) <= JMAX[1]::integer)   
                    THEN
                         RAISE '%', format (__lts_mess, JKEY, JKEYS[1], JMAX[1]::integer);
                    
                ELSIF (__item.price > JMAX[2]) 
                    THEN
                         RAISE '%', format (__ltn_mess, JKEY, JKEYS[2], JMAX[2]::integer);
                         
                ELSIF (__item.quantity > JMAX[3]) 
                    THEN
                         RAISE '%', format (__ltn_mess, JKEY, JKEYS[3], JMAX[3]::integer);
                         
                ELSIF NOT (( MEASURE_0 @> __item.measure) OR ( MEASURE_1 @> __item.measure) OR ( MEASURE_2 @> __item.measure) OR 
                           ( MEASURE_3 @> __item.measure) OR ( MEASURE_4 @> __item.measure) OR ( MEASURE_5 @> __item.measure) OR 
                           ( MEASURE_6 @> __item.measure) OR ( MEASURE_7 @> __item.measure) OR ( MEASURE_8 @> __item.measure)
                          )                                                                                   
                    THEN
                        RAISE '%', format (__msr_mess, JKEY, JKEYS[4], __item.measure);
     
                ELSIF (__item.sum > JMAX[5]) 
                    THEN
                         RAISE '%', format (__ltn_mess, JKEY, JKEYS[5], JMAX[5]::integer);           
             
                ELSIF NOT ((PAYMENT_OBJECT_0 @> __item.payment_object) OR (PAYMENT_OBJECT_1 @> __item.payment_object)) 
                    THEN                
                        RAISE '%', format (__mpo_mess, JKEY, JKEYS[7], __item.payment_object);
                
                ELSIF NOT (char_length(__item.user_data) <= JMAX[9]::integer)
                    THEN
                        RAISE '%', format (__lts_mess, JKEY, JKEYS[9], JMAX[9]::integer);               
             
                ELSIF NOT ((__item.excise <= JMAX[10]) AND (__item.excise > 0)) 
                    THEN
                         RAISE '%', format (__ptn_mess, JKEY, JKEYS[10], JMAX[10]::integer);

                ELSIF NOT (char_length(__item.country_code) = JMAX[11]::integer)
                    THEN                
                         RAISE '%', format (__eqs_mess, JKEY, JKEYS[11], JMAX[11]::integer); 
                    
                ELSIF NOT (char_length(__item.declaration_number) <= JMAX[12]::integer)
                    THEN
                         RAISE '%', format (__lts_mess, JKEY, JKEYS[12], JMAX[12]::integer);
             END IF;

             __items [__i] := __item ;
             __i := __i + 1;
          END LOOP;
      
       __result := json_strip_nulls (to_json(__items));
       
       RETURN __result;
   END;
  
$$;


ALTER FUNCTION fsc_receipt_pcg.fsc_items_crt_1(p_item public.item_t[]) OWNER TO postgres;

--
-- TOC entry 7896 (class 0 OID 0)
-- Dependencies: 633
-- Name: FUNCTION fsc_items_crt_1(p_item public.item_t[]); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_items_crt_1(p_item public.item_t[]) IS 'Создание объекта "item" -- описание товаров/услуг';


--
-- TOC entry 642 (class 1255 OID 2120400)
-- Name: fsc_mark_code_crt_2(text, text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_mark_code_crt_2(p_unknown text DEFAULT NULL::text, p_ean8 text DEFAULT NULL::text, p_ean13 text DEFAULT NULL::text, p_itf14 text DEFAULT NULL::text, p_gs10 text DEFAULT NULL::text, p_gs1m text DEFAULT NULL::text, p_short text DEFAULT NULL::text, p_fur text DEFAULT NULL::text, p_egais20 text DEFAULT NULL::text, p_egais30 text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
   -- ========================================================================================= --
   --    2023-05-22  Создание объекта "mark_code" - Маркировка товара средствами идентификации
   -- ========================================================================================= --

   DECLARE
     JKEY  CONSTANT text      := 'makr_code';
     JKEYS CONSTANT text[]    := array ['unknown', 'ean8', 'ean13', 'itf14', 'gs10', 'gs1m', 'short', 'fur', 'egais20', 'egais30']::text[];  
     JQ    CONSTANT integer[] := array [   32,       8,      13,      14,      38,    200,      38,     20,    33,        14     ]::integer[];
     -- --------------------------------------------------------------------------------------------------------------------------------------
     --                                     1        2        3        4        5      6         7       8      9         10
     
     __lts_mess text := '"%s": Длина "%s" должна быть не больше %s символов';
     __eqs_mess text := '"%s": Длина "%s" должна быть ровно %s символов';
     __eqn_mess text := '"%s": Длина "%s" должна быть ровно %s цифр';
     
     __jdata text [] := array[NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL]::text[];
     
     __result json;
      
   BEGIN
      IF (p_unknown IS NOT NULL) 
         THEN
             IF NOT (char_length(p_unknown) <= JQ[1])
               THEN
                  RAISE '%', format (__lts_mess, JKEY, JKEYS[1], JQ[1]);
             END IF;           
             __jdata [1] := p_unknown;
             
      ELSIF (p_ean8 IS NOT NULL)
         THEN
              IF NOT (char_length(p_ean8) =  JQ[2])
               THEN
                  RAISE '%', format (__eqn_mess, JKEY, JKEYS[2], JQ[2]);         
             END IF;          
             __jdata [2] := p_ean8;
             
      ELSIF (p_ean13 IS NOT NULL)
         THEN
              IF NOT (char_length(p_ean13) = JQ[3])
               THEN
                  RAISE '%', format (__eqn_mess, JKEY, JKEYS[3], JQ[3]);        
             END IF;          
             __jdata [3] := p_ean13;
             
      ELSIF (p_itf14 IS NOT NULL)
         THEN
             IF NOT (char_length(p_itf14) = JQ[4])
               THEN
                  RAISE  '%', format (__eqn_mess, JKEY, JKEYS[4], JQ[4]);           
             END IF;     
             __jdata [4] := p_itf14;
         
      ELSIF (p_gs10 IS NOT NULL)
         THEN
             IF NOT (char_length(p_gs10) <= JQ[5])
               THEN
                  RAISE '%', format (__lts_mess, JKEY, JKEYS[5], JQ[5]);
             END IF;           
             __jdata [5] := p_gs10;             
             
      ELSIF (p_gs1m IS NOT NULL)
         THEN
             IF NOT (char_length(p_gs10) <= JQ[6])
               THEN
                  RAISE '%', format (__lts_mess, JKEY, JKEYS[6], JQ[6]);
             END IF;            
             __jdata [6] := p_gs1m;                                

      ELSIF (p_short IS NOT NULL)
         THEN
             IF NOT (char_length(p_short) <= JQ[7])
               THEN
                  RAISE '%', format (__lts_mess, JKEY, JKEYS[7], JQ[7]);
             END IF;            
             __jdata [7] := p_short;                                

      ELSIF (p_fur IS NOT NULL)
         THEN
             IF NOT (char_length(p_fur) = JQ[8])
               THEN
                  RAISE  '%', format (__eqs_mess, JKEY, JKEYS[8], JQ[8]);        
             END IF;           
             __jdata [8] := p_fur;     

      ELSIF ( p_egais20 IS NOT NULL)
         THEN
             IF NOT (char_length(p_egais20) = JQ[9])
               THEN
                  RAISE  '%', format (__eqs_mess, JKEY, JKEYS[9], JQ[9]);  
             END IF;  
             __jdata [9] := p_egais20;   

      ELSIF ( p_egais30 IS NOT NULL)
         THEN
             IF NOT (char_length(p_egais30) = JQ[10])
               THEN
                  RAISE '%', format (__eqs_mess, JKEY, JKEYS[10], JQ[10]);
             END IF;  
             __jdata [10] := p_egais30;               
      END IF;

      __result := json_strip_nulls (json_object (JKEYS, __jdata));
       
       RETURN __result;
   END;
  
$$;


ALTER FUNCTION fsc_receipt_pcg.fsc_mark_code_crt_2(p_unknown text, p_ean8 text, p_ean13 text, p_itf14 text, p_gs10 text, p_gs1m text, p_short text, p_fur text, p_egais20 text, p_egais30 text) OWNER TO postgres;

--
-- TOC entry 7897 (class 0 OID 0)
-- Dependencies: 642
-- Name: FUNCTION fsc_mark_code_crt_2(p_unknown text, p_ean8 text, p_ean13 text, p_itf14 text, p_gs10 text, p_gs1m text, p_short text, p_fur text, p_egais20 text, p_egais30 text); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_mark_code_crt_2(p_unknown text, p_ean8 text, p_ean13 text, p_itf14 text, p_gs10 text, p_gs1m text, p_short text, p_fur text, p_egais20 text, p_egais30 text) IS 'Создание объекта "mark_code" - Маркировка товара средствами идентификации';


--
-- TOC entry 641 (class 1255 OID 2120399)
-- Name: fsc_mark_quantity_crt_2(integer, integer); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_mark_quantity_crt_2(p_numerator integer, p_denominator integer) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
   -- =========================================================================================== --
   --    2023-05-19'Создание объекта "mark_quantity" - дробное количество маркированного товара'
   -- =========================================================================================== --

   DECLARE
     JKEY  CONSTANT text = 'mark_quantity';
     JKEYS CONSTANT text[] = array['numerator', 'denominator']::text[];  

     __result json;
      
   BEGIN
     IF NOT ((p_numerator IS NOT NULL) AND (p_denominator IS NOT NULL)) 
        THEN
             RAISE 'mark_quantity: NULL значения запрещены';
     END IF;   
   
     IF (p_numerator <= 0) 
        THEN
             RAISE 'mark_quantity: %: "numerator" должен быть > 0', p_numerator;
     END IF;
   
     IF (p_denominator <= 0) 
        THEN
             RAISE 'mark_quantity: %: "denominator" должен быть > 0', p_denominator;
     END IF;

     IF NOT (p_numerator < p_denominator) 
        THEN
             RAISE 'mark_quantity: %, %: "numerator" должен быть меньше, чем "denominator"', p_numerator, p_denominator;
     END IF;
     
       __result := json_strip_nulls (json_build_object(JKEYS[1], p_numerator, JKEYS[2], p_denominator));
       
       RETURN __result;
   END;
  
$$;


ALTER FUNCTION fsc_receipt_pcg.fsc_mark_quantity_crt_2(p_numerator integer, p_denominator integer) OWNER TO postgres;

--
-- TOC entry 7898 (class 0 OID 0)
-- Dependencies: 641
-- Name: FUNCTION fsc_mark_quantity_crt_2(p_numerator integer, p_denominator integer); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_mark_quantity_crt_2(p_numerator integer, p_denominator integer) IS 'Создание объекта "mark_quantity" - дробное количество маркированного товара';


--
-- TOC entry 640 (class 1255 OID 2120398)
-- Name: fsc_money_transfer_operator_crt_3(text[], text, text, text); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_money_transfer_operator_crt_3(p_phones text[] DEFAULT NULL::text[], p_name text DEFAULT NULL::text, p_address text DEFAULT NULL::text, p_inn text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
   -- =============================================================================================== --
   --   2023-05-23  Создание объекта  "money_transfer_operator" - Оператор перевода денежных средств.
   -- =============================================================================================== --

   DECLARE
     JKEY  CONSTANT text := 'money_transfer_operator';
     JKEYS CONSTANT text[]    := array['phones', 'name', 'address', 'inn']::text[];  
     JQ    CONSTANT integer[] := array[ 19,        64,      256,     NULL]::integer[];
     --                                  1          2         3        4
  
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
    
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';     
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';
     
     __result json;
      
   BEGIN
      IF NOT (p_inn ~ INN_PATTERN)
        THEN
           RAISE '%', format (__inn_mess, JKEY, JKEYS[4], p_inn);         
           
      ELSIF NOT (char_length (p_name) <= JQ[2])
            THEN
                RAISE '%', format (__lts_mess, JKEY, JKEYS[2], JQ[2]);                 
                
      ELSIF NOT (char_length (p_address) <= JQ[3])
            THEN
                RAISE '%', format (__lts_mess, JKEY, JKEYS[3], JQ[3]);                 
      END IF;      
   
      __result := json_strip_nulls (json_build_object ( JKEYS[1], p_phones::text[]
                                                      , JKEYS[2], p_name::text
                                                      , JKEYS[3], p_address::text
                                                      , JKEYS[4], p_inn::text)
      );
       
      RETURN __result;
   END;
  
$_$;


ALTER FUNCTION fsc_receipt_pcg.fsc_money_transfer_operator_crt_3(p_phones text[], p_name text, p_address text, p_inn text) OWNER TO postgres;

--
-- TOC entry 7899 (class 0 OID 0)
-- Dependencies: 640
-- Name: FUNCTION fsc_money_transfer_operator_crt_3(p_phones text[], p_name text, p_address text, p_inn text); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_money_transfer_operator_crt_3(p_phones text[], p_name text, p_address text, p_inn text) IS 'Создание объекта  "money_transfer_operator" - Оператор перевода денежных средств.';


--
-- TOC entry 648 (class 1255 OID 2120408)
-- Name: fsc_operating_check_props_crt_1(text, text, text); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_operating_check_props_crt_1(p_name text, p_value text, p_timestamp text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
   -- ======================================================================================== --
   --    2023-05-24  Создание объекта  "operating_check_props" - Операционный реквизит чека.
   -- ======================================================================================== --

   DECLARE
     JKEY    CONSTANT text   := 'operating_check_props';
     JKEYS   CONSTANT text[] := array['name', 'value', 'timestamp']::text[];  
     QTY_VAL CONSTANT integer := 64;

     __result json;
     __mess      text := '"%s": Все данные являются обязательными: "%s" = %L, "%s" = %L, "%s" = %L';
     __eqs_mess  text := '"%s": Длина "%s" должна быть равна %s символам';      
     
   BEGIN
      IF (p_name IS NULL) OR (p_value IS NULL) OR (p_timestamp IS NULL)
         THEN
              RAISE '%', format(__mess, JKEY, JKEYS[1], p_name, JKEYS[2], p_value, JKEYS[3], p_timestamp);
              
        ELSIF NOT (char_length(p_value) <= QTY_VAL)
             THEN
                    RAISE '%', format(__eqs_mess, JKEY, JKEYS[2], QTY_VAL);
      END IF;
      
       __result := json_strip_nulls (json_build_object (JKEYS[1], p_name, JKEYS[2], p_value, JKEYS[3], p_timestamp));
       
       RETURN __result;
   END;
  
$$;


ALTER FUNCTION fsc_receipt_pcg.fsc_operating_check_props_crt_1(p_name text, p_value text, p_timestamp text) OWNER TO postgres;

--
-- TOC entry 7900 (class 0 OID 0)
-- Dependencies: 648
-- Name: FUNCTION fsc_operating_check_props_crt_1(p_name text, p_value text, p_timestamp text); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_operating_check_props_crt_1(p_name text, p_value text, p_timestamp text) IS 'Создание объекта "operating_check_props" - Операционный реквизит чека.';


--
-- TOC entry 655 (class 1255 OID 2120417)
-- Name: fsc_order_crt(timestamp without time zone, text, public.operation_t, json, json, json, json, json, numeric, json, text, text, text, json, json, json, boolean, text); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_order_crt(p_timestamp timestamp without time zone, p_external_id text, p_operation public.operation_t, p_correction_info json, p_client json, p_company json, p_items json, p_payments json, p_total numeric, p_vats json DEFAULT NULL::json, p_cashier text DEFAULT NULL::text, p_cashier_inn text DEFAULT NULL::text, p_additional_check_props text DEFAULT NULL::text, p_additional_user_props json DEFAULT NULL::json, p_operating_check_props json DEFAULT NULL::json, p_sectoral_check_props json DEFAULT NULL::json, p_ism_optional boolean DEFAULT NULL::boolean, p_callback_url text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
   -- ========================================================================================== --
   --  2023-05-29  Создание объекта "order", данные для POST-запроса на сервер фискализации.     --
   --  2023-06-01  Типизация запросов:  "Просто запрос"/"Корреция".  
   --      + Новый вариант функции, объединяющий в себе как "fsc_receipt_crt_0" 
   --        так и "fsc_correction_crt_0".  Сразу новый запрос на выполнение фискализации.                   
   -- ========================================================================================== --
   
   DECLARE
     JKEY   CONSTANT text := 'order';
     JKEY_0 CONSTANT text := 'service';
     
     RECEIPT    CONSTANT text := 'receipt';
     CORRECTION CONSTANT text := 'correction';
     
     JKEYS       text[] := array [ 'timestamp', 'external_id',  'XXXXX', 'ism_optional', 'callback_url', 'operation' ]::text[];  
     --                                 1            2             3           4               5               6 
     -- Перестал быть константой, JKEYS[3] принимает значения "receipt", "correction"
     
     JQ    CONSTANT integer[] := array [NULL,      128,          NULL,        NULL,           256,           NULL]::integer[];
    
     __lts_mess       text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess      text := '"%s": Эти данные являются обязательными: "%s", "%s", "%s"';
     __null_mess_corr text := '"%s": Данные о коррекции чека являются обязательными';

     __data    json;
     __result  json;
     
   BEGIN
   
     IF (p_timestamp IS NULL) OR (p_external_id IS NULL) OR (p_operation IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY, JKEYS[1], JKEYS[2],  JKEYS[6]);        
            
       ELSIF NOT (char_length(p_external_id) <= JQ[2])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[2], JQ[2]);                 
                 
       ELSIF NOT (char_length(p_callback_url) <= JQ[5])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[5], JQ[5]);                 
     END IF;       
       
     IF ( p_operation::text = ANY (enum_range('sell'::operation_t, 'buy_refund'::operation_t)::text[])) 
        THEN 
               JKEYS[3] := RECEIPT; 
               __data := fsc_receipt_pcg.fsc_receipt_crt_0 (
              
                      p_client                 := p_client                 -- Покупатель / клиент 
                    , p_company                := p_company                -- Компания
                    , p_items                  := p_items                  -- Товары, услуги
                    , p_payments               := p_payments               -- Оплаты
                    , p_total                  := p_total                  -- Итоговая сумма чека в рублях
                    , p_vats                   := p_vats                   -- Атрибуты налогов на чек
                    , p_cashier                := p_cashier                -- ФИО кассира
                    , p_cashier_inn            := p_cashier_inn            -- ИНН кассира
                    , p_additional_check_props := p_additional_check_props -- Дополнительный реквизит чека
                    , p_additional_user_props  := p_additional_user_props  -- Дополнительный реквизит пользователя
                    , p_operating_check_props  := p_operating_check_props  -- Операционныц реквизит чека
                    , p_sectoral_check_props   := p_sectoral_check_props   -- Отраслевой реквизит кассового чека
               );
 
        ELSE
               IF (p_correction_info IS NULL)  
                 THEN
                       RAISE '%', format (__null_mess_corr, JKEY);
               END IF;
               
               JKEYS[3] := CORRECTION;
               
               __data := fsc_receipt_pcg.fsc_correction_crt_0 (
               
                             p_client                 :=  p_client                 -- Покупатель / клиент 
                           , p_company                :=  p_company                -- Компания
                           , p_correction_info        :=  p_correction_info        -- Информация о типе коррекции 
                           , p_items                  :=  p_items                  -- Товары, услуги
                           , p_payments               :=  p_payments               -- Оплаты
                           , p_total                  :=  p_total                  -- Итоговая сумма чека в рублях
                           , p_vats                   :=  p_vats                   -- Атрибуты налогов на чек
                           , p_cashier                :=  p_cashier                -- ФИО кассира
                           , p_cashier_inn            :=  p_cashier_inn            -- ИНН кассира
                           , p_additional_check_props :=  p_additional_check_props -- Дополнительный реквизит чека
                           , p_additional_user_props  :=  p_additional_user_props  -- Дополнительный реквизит пользователя
                           , p_operating_check_props  :=  p_operating_check_props  -- Операционныц реквизит чека
                           , p_sectoral_check_props   :=  p_sectoral_check_props   -- Отраслевой реквизит кассового чека
               ); 
     END IF;
       
     __result := json_strip_nulls (json_build_object (
                 JKEYS[1], to_char (p_timestamp, 'dd.mm.yyyy HH:MM::SS')
               , JKEYS[2], p_external_id
               , JKEYS[3], __data
               , JKEYS[4], p_ism_optional
               , JKEY_0, json_build_object (JKEYS[5], p_callback_url)
     ));

     RETURN __result;
   END;
  
$$;


ALTER FUNCTION fsc_receipt_pcg.fsc_order_crt(p_timestamp timestamp without time zone, p_external_id text, p_operation public.operation_t, p_correction_info json, p_client json, p_company json, p_items json, p_payments json, p_total numeric, p_vats json, p_cashier text, p_cashier_inn text, p_additional_check_props text, p_additional_user_props json, p_operating_check_props json, p_sectoral_check_props json, p_ism_optional boolean, p_callback_url text) OWNER TO postgres;

--
-- TOC entry 7901 (class 0 OID 0)
-- Dependencies: 655
-- Name: FUNCTION fsc_order_crt(p_timestamp timestamp without time zone, p_external_id text, p_operation public.operation_t, p_correction_info json, p_client json, p_company json, p_items json, p_payments json, p_total numeric, p_vats json, p_cashier text, p_cashier_inn text, p_additional_check_props text, p_additional_user_props json, p_operating_check_props json, p_sectoral_check_props json, p_ism_optional boolean, p_callback_url text); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_order_crt(p_timestamp timestamp without time zone, p_external_id text, p_operation public.operation_t, p_correction_info json, p_client json, p_company json, p_items json, p_payments json, p_total numeric, p_vats json, p_cashier text, p_cashier_inn text, p_additional_check_props text, p_additional_user_props json, p_operating_check_props json, p_sectoral_check_props json, p_ism_optional boolean, p_callback_url text) IS 'Создание объекта "order" (Данные для POST-запроса)';


--
-- TOC entry 639 (class 1255 OID 2121036)
-- Name: fsc_orders_load(integer, date, date, public.agent_info_t, text, integer, text, public.operation_t); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_orders_load(p_reestr_type integer DEFAULT 0, p_min_date date DEFAULT CURRENT_DATE, p_max_date date DEFAULT CURRENT_DATE, p_agent_type public.agent_info_t DEFAULT 'bank_paying_agent'::public.agent_info_t, p_order_callback_url text DEFAULT 'www.xxx.ru'::text, p_rcp_type integer DEFAULT 0, p_paying_agent_operation text DEFAULT 'Платёж'::text, p_order_operation public.operation_t DEFAULT 'sell'::public.operation_t) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
-- ------------------------------------------------------------------------------------
--     Загрузка из репестра исходных данных в секцию "0" -- запросы на фискализацию.
--      2023-05-31 -- 2023-06-13  -- Прототип оформленный в виде DO-блока.
--      2023-06-16 -- Первая версия. 
--      2023-07-17 -- Без ссылки на пару "Организация --Приложение".
-- ------------------------------------------------------------------------------------
     DECLARE
       
       __item    item_t;
       __result  json;
       __x       record;
       __i       integer;
       __j       integer;
       --
       __company_phone  text;
       __external_id    uuid;
       
       RCP_STATUS constant integer := 0;  -- Начальное состояние чека.
       RESEND_PR  constant integer := 0;  -- В начальном состоянии количество повторных попыток = 0
     
      -- Далее набор констант, ограничивающий исходные данные,
      -- Хотя плохие исходные данные оставлены, всё равно фильтруем
      --
      MAX_ITEM_NAME_LEN constant integer := 128;
      MAX_ITEM_PRICE    constant numeric(10,2) := 42949673.00;
     
     BEGIN
       __j := 0;
       FOR  __x IN  SELECT    
   	                    x.id_source_reestr
                      , x.dt_create
                      --
                      , x.company_email
                      , x.company_sno
                      , x.company_inn
                      , x.company_payment_address
                      --
                      , x.client_name
                      , x.client_inn
                      , x.pmt_type
                      , x.pmt_sum
                      , substr (x.item_name, 1, MAX_ITEM_NAME_LEN) AS item_name  -- ???
                      , x.item_price
                      , x.item_measure
                      , x.item_quantity
                      , x.item_sum
                      , x.item_payment_method
                      , x.payment_object
                      , x.item_vat
                      , x.client_account
                      --
                      , x.company_account
                      , x.company_phones
                      , x.company_name
                      , z.id_org
                      , (SELECT k.id_org_app FROM fiscalization.fsc_org_app k WHERE (z.id_org = k.id_org) LIMIT 1
                        ) AS id_org_app                     
                      --
                      , x.company_bik
                      , x.company_paying_agent
                      --
                      , x.bank_name
                      , x.bank_addr
                      , x.bank_inn
                      , x.bank_bik
                      , x.bank_phones 
                      , x.external_id
                          
                FROM fiscalization.fsc_source_reestr x 

                     INNER JOIN fiscalization.fsc_org z 
                             ON ( fsc_receipt_pcg.f_xxx_replace_char(x.company_name) =
                                                   fsc_receipt_pcg.f_xxx_replace_char(z.nm_org_name)
                                )
                        WHERE (x.type_source_reestr = p_reestr_type) AND
                              (x.dt_create BETWEEN p_min_date AND p_max_date) AND
                              (x.item_price <= MAX_ITEM_PRICE) 
                           
    			-- 8 ERROR:  "item": Длина "name" должна быть не больше 128 символов
    			--  ERROR:  "item": Величина "price" не должна превышать 42949673
     LOOP           
     
            __external_id  := __x.external_id;
     
           -- Товары, услуги:  элемент структуры
           __item.name     := __x.item_name::text;             
           __item.price    := __x.item_price::numeric(10,2);   
           __item.quantity := __x.item_quantity::numeric(8,3);     
           __item.measure  := __x.item_measure::integer;          
           __item.sum      := __x.item_sum::numeric(10,2);   
           
           __item.payment_method := __x.item_payment_method::payment_method_t; 
           __item.payment_object := __x.payment_object ::integer;         
           
           __item.vat := fsc_receipt_pcg.fsc_vat_crt_2 (
                                    p_type := __x.item_vat -- Номер налога в ККТ
           )::json; 
           ---------------------------------------
           __item.user_data            := NULL::text;         
           __item.excise               := NULL::numeric(10,2);
           __item.country_code         := NULL::text;         
           __item.declaration_number   := NULL::text;         
           __item.mark_quantity        := NULL::json;         
           __item.mark_processing_mode := NULL::text;         
           __item.sectoral_item_props  := NULL::json;         
           __item.mark_code            := NULL::json;  
           
           IF (__x.company_paying_agent)
             THEN
                __i := 1;
                --Уборка мусора из номеров телефонов
                FOREACH __company_phone IN ARRAY __x.company_phones
                 LOOP
                   __company_phone := fsc_receipt_pcg.f_xxx_replace_char(__x.company_phones[__i]);
                   __x.company_phones[__i] := __company_phone;
                   __i := __i + 1;
                END LOOP;
             
                 __item.agent_info := fsc_receipt_pcg.fsc_agent_info_crt_2 (
                       p_type := p_agent_type  -- Тип агента по предмету расчёта 
                      ,p_paying_agent := fsc_receipt_pcg.fsc_paying_agent_crt_3 (
                                   p_paying_agent_operation, __x.company_phones
                       )
                      ,p_receive_payments_operator := 
                           fsc_receipt_pcg.fsc_receive_payments_operators_crt_3 (__x.company_phones)
                      ,p_money_transfer_operator := fsc_receipt_pcg.fsc_money_transfer_operator_crt_3 
                                              ( __x.company_phones
                                               ,__x.company_name
                                               ,__x.company_payment_address
                                               ,__x.company_inn 
                                              )
                  );
                  
                  __item.supplier_info := fsc_receipt_pcg.fsc_supplier_info_crt_2(        
                        p_phones := __x.company_phones -- Номера телефонов        
                       ,p_name   := __x.company_name          
                       ,p_inn    := __x.company_inn      
                  ) ;
             ELSE
                  __item.agent_info    := NULL;
                  __item.supplier_info := NULL;
             END IF;
           
          __result := fsc_receipt_pcg.fsc_order_crt (
          
                 p_timestamp        := __x.dt_create::timestamp -- Дата и время документа
               , p_external_id      := __external_id::text      -- Внешний идентификатолр документа 
               , p_operation        := p_order_operation        -- Тип выполняемой операции
               , p_correction_info  := NULL    -- Информация о типе коррекции ОПЦИОНАЛЬНО МОЖЕТ БЫТЬ "NULL"
                 --     
                -- Покупатель / клиент
               , p_client := fsc_receipt_pcg.fsc_client_crt_1 (
                                                                 p_name := __x.client_name
                                                                ,p_inn  := __x.client_inn
               )::json
              
               -- Компания
               , p_company := fsc_receipt_pcg.fsc_company_crt_1 (
                                p_email           := __x.company_email -- mail отправителя чека (адрес ОФД) 
                              , p_sno             := __x.company_sno   -- Система налогообложения
                              , p_inn             := __x.company_inn   -- ИНН организации
                              , p_payment_address := __x.company_payment_address  -- место расчётов                    
                )::json 
               
               -- Товары, услуги
               , p_items := fsc_receipt_pcg.fsc_items_crt_1 (ARRAY[__item]::item_t[])::json
                
                 --  Оплаты   
               , p_payments := fsc_receipt_pcg.fsc_payments_crt_1 (
                                 p_pmt_type_sum := ARRAY[(__x.pmt_type, __x.pmt_sum)]::pmt_type_sum_t[]
                )::json
                
               , p_total := __x.pmt_sum
               --
               , p_ism_optional := TRUE                 -- Регистрация в случае недоступности проверки кода маркировки  
               , p_callback_url := p_order_callback_url -- Адрес ответа, (используем после обработки чека)   
        
          );
        
         -- RAISE NOTICE '%', __result;   
         
         INSERT INTO fiscalization.fsc_receipt(
                  dt_create       -- d
                , rcp_status      -- 0
                , dt_update
                , inn             -- d
                , rcp_nmb         -- d
                , rcp_fp
                , dt_fp
                , id_org_app      -- 189
                , rcp_status_descr
                , rcp_order       -- d
                , rcp_receipt
                , rcp_type        -- 0
                , rcp_received    -- false
                , rcp_notify_send -- false
                , id_pmt_reestr   -- d
                , resend_pr       -- 0    
           )
         VALUES (      	                      
                    __x.dt_create
                  , RCP_STATUS
                  , NULL
                  , __x.client_inn
                  , __external_id::text
                  , NULL
                  , NULL
                  , __x.id_org_app
                  , NULL
                  , __result::jsonb
                  , NULL
                  , p_rcp_type  -- Тип чека                 -- ??
                  , FALSE
                  , FALSE
                  , __x.id_source_reestr
                  , RESEND_PR
        );
        
        __j := __j + 1;
       END LOOP;
       
       RETURN __j;
    END;
    
   $$;


ALTER FUNCTION fsc_receipt_pcg.fsc_orders_load(p_reestr_type integer, p_min_date date, p_max_date date, p_agent_type public.agent_info_t, p_order_callback_url text, p_rcp_type integer, p_paying_agent_operation text, p_order_operation public.operation_t) OWNER TO postgres;

--
-- TOC entry 7902 (class 0 OID 0)
-- Dependencies: 639
-- Name: FUNCTION fsc_orders_load(p_reestr_type integer, p_min_date date, p_max_date date, p_agent_type public.agent_info_t, p_order_callback_url text, p_rcp_type integer, p_paying_agent_operation text, p_order_operation public.operation_t); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_orders_load(p_reestr_type integer, p_min_date date, p_max_date date, p_agent_type public.agent_info_t, p_order_callback_url text, p_rcp_type integer, p_paying_agent_operation text, p_order_operation public.operation_t) IS ' Загрузка из репестра исходных данных в секцию "0" -- запросы на фискализацию.';


--
-- TOC entry 637 (class 1255 OID 2120397)
-- Name: fsc_paying_agent_crt_3(text, text[]); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_paying_agent_crt_3(p_operation text DEFAULT NULL::text, p_phones text[] DEFAULT NULL::text[]) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
   -- ============================================================================= --
   --    2023-05-22  Создание объекта  "paying_agent" - атрибуты Платёжного агента
   -- ============================================================================= --

   DECLARE
     JKEY  CONSTANT text := 'paying_agent';
     JKEYS CONSTANT text[]    := array['operation', 'phones']::text[];  
     JQ    CONSTANT integer[] := array[   24,         NULL]::integer[];
     --                                    1           2  
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';       
     
     __result json;
      
   BEGIN
      IF NOT (char_length (p_operation) <= JQ[1])
            THEN
                RAISE '%', format (__lts_mess, JKEY, JKEYS[1], JQ[1]);                 
      END IF;    
   
      __result := json_strip_nulls (json_build_object (JKEYS[1], p_operation::text, JKEYS[2], p_phones::text[]));
       
      RETURN __result;
   END;
  
$$;


ALTER FUNCTION fsc_receipt_pcg.fsc_paying_agent_crt_3(p_operation text, p_phones text[]) OWNER TO postgres;

--
-- TOC entry 7903 (class 0 OID 0)
-- Dependencies: 637
-- Name: FUNCTION fsc_paying_agent_crt_3(p_operation text, p_phones text[]); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_paying_agent_crt_3(p_operation text, p_phones text[]) IS 'Создание объекта  "paying_agent" - атрибуты Платёжного агента';


--
-- TOC entry 647 (class 1255 OID 2120407)
-- Name: fsc_payments_crt_1(public.pmt_type_sum_t[]); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_payments_crt_1(p_pmt_type_sum public.pmt_type_sum_t[]) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
   -- ============================================================================ --
   --    2023-05-19 Создание объекта "payments" - Вид и сумма оплаты
   -- ============================================================================ --

   DECLARE
     JKEY     CONSTANT text       := 'payments';
     QTY_PMT  CONSTANT integer    := 10; 
     PMT_TYPE CONSTANT int4range  := int4range('[0,9]');
     
     __pmt_type_sum  pmt_type_sum_t;
     __result        json;
      
   BEGIN
      IF (array_length (p_pmt_type_sum, 1) > QTY_PMT) 
        THEN
          RAISE '"payments": Количество различных видов оплаты не должно превышать: %', QTY_PMT;
      END IF;  

      FOREACH __pmt_type_sum IN ARRAY p_pmt_type_sum
         LOOP
           IF NOT (PMT_TYPE @> __pmt_type_sum.pmt_type)
             THEN
                RAISE '"payments": Вид оплаты должен находится в диапазоне от % до %', lower(PMT_TYPE), upper(PMT_TYPE)-1;
		   END IF;	  
         END LOOP;
      
      __result := json_strip_nulls (to_json(p_pmt_type_sum));
      
      RETURN __result;
   END;
  
$$;


ALTER FUNCTION fsc_receipt_pcg.fsc_payments_crt_1(p_pmt_type_sum public.pmt_type_sum_t[]) OWNER TO postgres;

--
-- TOC entry 7904 (class 0 OID 0)
-- Dependencies: 647
-- Name: FUNCTION fsc_payments_crt_1(p_pmt_type_sum public.pmt_type_sum_t[]); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_payments_crt_1(p_pmt_type_sum public.pmt_type_sum_t[]) IS 'Создание объекта "payments" - Вид и сумма оплаты';


--
-- TOC entry 656 (class 1255 OID 2120421)
-- Name: fsc_range_part_crt(text, text, text, date, date, text, text, text); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_range_part_crt(p_parent_sch_name text, p_parent_tbl_name text, p_constr_name text, p_min_bound date, p_max_bound date, p_part_sch_name text DEFAULT NULL::text, p_pref_1 text DEFAULT 'fsc'::text, p_pref_2 text DEFAULT 'chk'::text, OUT l_result boolean, OUT l_part_name text) RETURNS SETOF record
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_X$
   -- ============================================================================ --
   --    2023-04-13  прототип функции, создающей секции с временными диапазонами
   -- ============================================================================ --

   DECLARE
      _crt_part  text = $_$
   
            CREATE TABLE %s.%s_%s PARTITION OF %s.%s
            ( 
                CONSTRAINT %s_%s CHECK (dt_create >= %L AND dt_create < %L)
            )
                FOR VALUES FROM (%L) TO (%L);
               
       $_$;

      _exec text;      
      _part_sch_name text := COALESCE (p_part_sch_name, p_parent_sch_name);
      
   BEGIN
      _exec := format (_crt_part 
                       ,_part_sch_name
                       , p_pref_1 
                       , p_constr_name
                       , p_parent_sch_name 
                       , p_parent_tbl_name 
                       , p_pref_2
                       , p_constr_name
                       , p_min_bound
                       , p_max_bound
                       , p_min_bound
                       , p_max_bound
       );
	     
	  EXECUTE (_exec);
	     
       l_result    := TRUE;
       l_part_name := btrim (_exec);
      
       RETURN NEXT;
   END;
  
$_X$;


ALTER FUNCTION fsc_receipt_pcg.fsc_range_part_crt(p_parent_sch_name text, p_parent_tbl_name text, p_constr_name text, p_min_bound date, p_max_bound date, p_part_sch_name text, p_pref_1 text, p_pref_2 text, OUT l_result boolean, OUT l_part_name text) OWNER TO postgres;

--
-- TOC entry 7905 (class 0 OID 0)
-- Dependencies: 656
-- Name: FUNCTION fsc_range_part_crt(p_parent_sch_name text, p_parent_tbl_name text, p_constr_name text, p_min_bound date, p_max_bound date, p_part_sch_name text, p_pref_1 text, p_pref_2 text, OUT l_result boolean, OUT l_part_name text); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_range_part_crt(p_parent_sch_name text, p_parent_tbl_name text, p_constr_name text, p_min_bound date, p_max_bound date, p_part_sch_name text, p_pref_1 text, p_pref_2 text, OUT l_result boolean, OUT l_part_name text) IS 'Прототип функции, создающей секции с временными диапазонами';


--
-- TOC entry 653 (class 1255 OID 2120415)
-- Name: fsc_receipt_crt_0(json, json, json, json, numeric, json, text, text, text, json, json, json); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_receipt_crt_0(p_client json, p_company json, p_items json, p_payments json, p_total numeric, p_vats json DEFAULT NULL::json, p_cashier text DEFAULT NULL::text, p_cashier_inn text DEFAULT NULL::text, p_additional_check_props text DEFAULT NULL::text, p_additional_user_props json DEFAULT NULL::json, p_operating_check_props json DEFAULT NULL::json, p_sectoral_check_props json DEFAULT NULL::json) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
   -- ============================================================================ --
   --    2023-05-26  Создание объекта "receipt"
   -- ============================================================================ --
   
   DECLARE
     JKEY  CONSTANT text      := 'receipt';
     JKEYS CONSTANT text[]    := array [ 'client',                 'company',                'items',                 'payments'
     --                                     1                         2                         3                         4      
                                       , 'total',                  'vats',                   'cashier',               'cashier_inn'
     --                                     5                         6                         7                         8      
                                       , 'additional_check_props', 'additional_user_proips', 'operating_check_props', 'sectoral_check_props'
     --                                     9                         10                         11                       12      
                                       ]::text[];  
                                       
     JQ    CONSTANT integer[] := array[    NULL,                     NULL,                      NULL,                    NULL
                                          ,NULL,                     NULL,                      64,                      NULL
                                          , 16,                      NULL,                      NULL,                    NULL
     ]::integer[];
     
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s", "%s", "%s", "%s", "%s"';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';

     __result json;
      
   BEGIN
   
     IF (p_client IS NULL) OR (p_company IS NULL) OR 
        (p_items IS NULL) OR (p_payments IS NULL) OR (p_total IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY, JKEYS[1], JKEYS[2], JKEYS[3], JKEYS[4], JKEYS[5]
            );      
            
       ELSIF NOT (p_cashier_inn ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[8], p_cashier_inn);   
                 
       ELSIF NOT (char_length(p_cashier) <= JQ[7])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[7], JQ[7]);                 
                 
       ELSIF NOT (char_length(p_additional_check_props) <= JQ[9])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[9], JQ[9]);                 
                 
       END IF;       
       
       __result := json_strip_nulls (json_build_object (
                 JKEYS [1], p_client, JKEYS[2], p_company, JKEYS[3], p_items,   JKEYS[ 4], p_payments 
                ,JKEYS [5], p_total,  JKEYS[6], p_vats,    JKEYS[7], p_cashier, JKEYS[ 8], p_cashier_inn
                ,JKEYS [9], p_additional_check_props, JKEYS[10], p_additional_user_props 
                ,JKEYS[11], p_operating_check_props,  JKEYS[12], p_sectoral_check_props  
       ));
       
       RETURN __result;
   END;
  
$_$;


ALTER FUNCTION fsc_receipt_pcg.fsc_receipt_crt_0(p_client json, p_company json, p_items json, p_payments json, p_total numeric, p_vats json, p_cashier text, p_cashier_inn text, p_additional_check_props text, p_additional_user_props json, p_operating_check_props json, p_sectoral_check_props json) OWNER TO postgres;

--
-- TOC entry 7906 (class 0 OID 0)
-- Dependencies: 653
-- Name: FUNCTION fsc_receipt_crt_0(p_client json, p_company json, p_items json, p_payments json, p_total numeric, p_vats json, p_cashier text, p_cashier_inn text, p_additional_check_props text, p_additional_user_props json, p_operating_check_props json, p_sectoral_check_props json); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_receipt_crt_0(p_client json, p_company json, p_items json, p_payments json, p_total numeric, p_vats json, p_cashier text, p_cashier_inn text, p_additional_check_props text, p_additional_user_props json, p_operating_check_props json, p_sectoral_check_props json) IS 'Создание объекта "receipt"';


--
-- TOC entry 636 (class 1255 OID 2120396)
-- Name: fsc_receive_payments_operators_crt_3(text[]); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_receive_payments_operators_crt_3(p_phones text[] DEFAULT NULL::text[]) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
   -- =============================================================================================== --
   --   2023-05-23  "receive_payments_operators" - Контактные номера опраторов по приёму платежей.
   -- =============================================================================================== --

   DECLARE
     JKEY  CONSTANT text = 'receive_payments_operators';
     JKEYS CONSTANT text[] = array['phones']::text[];  

     __result json;
      
   BEGIN
       __result := json_strip_nulls (json_build_object (JKEYS[1], p_phones::text[]));
       RETURN __result;
   END;
  
$$;


ALTER FUNCTION fsc_receipt_pcg.fsc_receive_payments_operators_crt_3(p_phones text[]) OWNER TO postgres;

--
-- TOC entry 7907 (class 0 OID 0)
-- Dependencies: 636
-- Name: FUNCTION fsc_receive_payments_operators_crt_3(p_phones text[]); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_receive_payments_operators_crt_3(p_phones text[]) IS ' Контактные номера опраторов по приёму платежей.';


--
-- TOC entry 646 (class 1255 OID 2120406)
-- Name: fsc_sectoral_check_props_crt_1(public.sectoral_item_props_t[]); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_sectoral_check_props_crt_1(p_sectoral_check_props public.sectoral_item_props_t[]) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
   -- ============================================================================================ --
   --    2023-05-25 Создание объекта "sectoral_check_prop" - Отраслевые реквизиты кассового чека.
   -- ============================================================================================ --

   DECLARE
     JKEY    CONSTANT text    := 'sectoral_check_prop';
     JKEYS   CONSTANT text[] := ARRAY['federal_id', 'date', 'number', 'value'];
     
     DD_MM_YYYY_PATTERN  CONSTANT text := '^(0[1-9]|[12]\\d|3[01])\\.(0[1-9]|1[0-2])\\.(19|20)\\d\\d$'; -- ??!!
     
     QTY_SIP CONSTANT integer := 6; 
     QTY_NMB CONSTANT integer := 32; 
     QTY_VAL CONSTANT integer := 256; 
     
     __len_mess  text := '"%s": Количество различных отраслевых реквизитов не должно превышать: s%';
     __null_mess text := '"%s": Все данные являются обязательными: "%s" = %L, "%s" = %L, "%s" = %L, "%s" = %L';
     __eqs_mess  text := '"%s": Длина "%s" должна быть равна %s символам';     
     
     
     __sectoral_check_prop  sectoral_item_props_t;
     __result json;
      
   BEGIN
      IF (array_length (p_sectoral_check_props, 1) > QTY_SIP) 
        THEN
          RAISE'%', format (__len_mess, QTY_SIP);
      END IF;  
   
      FOREACH __sectoral_check_prop IN ARRAY p_sectoral_check_props
      
          LOOP
             IF (__sectoral_check_prop.federal_id IS NULL) OR (__sectoral_check_prop.date IS NULL) OR 
                (__sectoral_check_prop.number IS NULL) OR (__sectoral_check_prop.value IS NULL)
               THEN
                    RAISE '%', format (__null_mess, JKEY 
                                                  , JKEYS[1], __sectoral_check_prop.federal_id
                                                  , JKEYS[2], __sectoral_check_prop.date
                                                  , JKEYS[3], __sectoral_check_prop.number
                                                  , JKEYS[4], __sectoral_check_prop.value                                                 
                    );
                    
               ELSIF NOT (char_length(__sectoral_check_prop.number) <= QTY_NMB)
                    THEN
                           RAISE '%', format(__eqs_mess, JKEY, JKEYS[3], QTY_NMB);
                           
               ELSIF NOT (char_length(__sectoral_check_prop.value) <= QTY_VAL)
                    THEN
                           RAISE '%', format(__eqs_mess, JKEY, JKEYS[4], QTY_VAL);                           
             END IF;   
          
          END LOOP;
      
      __result := json_strip_nulls (to_json(p_sectoral_check_props));
      
      RETURN __result;
   END;
  
$_$;


ALTER FUNCTION fsc_receipt_pcg.fsc_sectoral_check_props_crt_1(p_sectoral_check_props public.sectoral_item_props_t[]) OWNER TO postgres;

--
-- TOC entry 7908 (class 0 OID 0)
-- Dependencies: 646
-- Name: FUNCTION fsc_sectoral_check_props_crt_1(p_sectoral_check_props public.sectoral_item_props_t[]); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_sectoral_check_props_crt_1(p_sectoral_check_props public.sectoral_item_props_t[]) IS ' Создание объекта "sectoral_check_prop" - Отраслевые реквизиты кассового чека.';


--
-- TOC entry 632 (class 1255 OID 2120404)
-- Name: fsc_sectoral_item_props_crt_2(public.sectoral_item_props_t[]); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_sectoral_item_props_crt_2(p_sectoral_item_props public.sectoral_item_props_t[]) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
   -- ====================================================================================    --    2023-05-22 Создание объекта "sectoral_item_props" - Отраслевые реквизиты товара.
   -- ==================================================================================== --

   DECLARE
    
     JKEY    CONSTANT text    := 'sectoral_item_props';
     JKEYS   CONSTANT text[] := ARRAY['federal_id', 'date', 'number', 'value'];
     
     DD_MM_YYYY_PATTERN  CONSTANT text := '^(0[1-9]|[12]\\d|3[01])\\.(0[1-9]|1[0-2])\\.(19|20)\\d\\d$'; -- ??!!
     
     QTY_SIP CONSTANT integer := 6; 
     QTY_NMB CONSTANT integer := 32; 
     QTY_VAL CONSTANT integer := 256; 
     
     __len_mess  text := '"%s": Количество различных отраслевых реквизитов не должно превышать: s%';
     __null_mess text := '"%s": Все данные являются обязательными: "%s" = %L, "%s" = %L, "%s" = %L, "%s" = %L';
     __eqs_mess  text := '"%s": Длина "%s" должна быть равна %s символам';     
     
     __sectoral_item_prop  sectoral_item_props_t;

     __result json;
      
   BEGIN
      IF (array_length (p_sectoral_item_props, 1) > QTY_SIP) 
        THEN
          RAISE'%', format (__len_mess, QTY_SIP);
      END IF;  
   
      FOREACH __sectoral_item_prop IN ARRAY p_sectoral_item_props
      
          LOOP
             IF (__sectoral_item_prop.federal_id IS NULL) OR (__sectoral_item_prop.date IS NULL) OR 
                (__sectoral_item_prop.number IS NULL) OR (__sectoral_item_prop.value IS NULL)
               THEN
                    RAISE '%', format (__null_mess, JKEY
                                                  , JKEYS[1], __sectoral_item_prop.federal_id
                                                  , JKEYS[2], __sectoral_item_prop.date
                                                  , JKEYS[3], __sectoral_item_prop.number
                                                  , JKEYS[4], __sectoral_item_prop.value                                                 
                    );
                    
               ELSIF NOT (char_length(__sectoral_item_prop.number) <= QTY_NMB)
                    THEN
                           RAISE '%', format(__eqs_mess, JKEY, JKEYS[3], QTY_NMB);
                           
               ELSIF NOT (char_length(__sectoral_item_prop.value) <= QTY_VAL)
                    THEN
                           RAISE '%', format(__eqs_mess, JKEY, JKEYS[4], QTY_VAL);                           
             END IF;   
          
          END LOOP;
      
      __result := json_strip_nulls (to_json(p_sectoral_item_props));
      
      RETURN __result;      
   END;
  
$_$;


ALTER FUNCTION fsc_receipt_pcg.fsc_sectoral_item_props_crt_2(p_sectoral_item_props public.sectoral_item_props_t[]) OWNER TO postgres;

--
-- TOC entry 7909 (class 0 OID 0)
-- Dependencies: 632
-- Name: FUNCTION fsc_sectoral_item_props_crt_2(p_sectoral_item_props public.sectoral_item_props_t[]); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_sectoral_item_props_crt_2(p_sectoral_item_props public.sectoral_item_props_t[]) IS ' Создание объекта "sectoral_item_props" - Отраслевые реквизиты товара.';


--
-- TOC entry 638 (class 1255 OID 2120402)
-- Name: fsc_supplier_info_crt_2(text[], text, text); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_supplier_info_crt_2(p_phones text[], p_name text DEFAULT NULL::text, p_inn text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
   -- ============================================================================= --
   --    2023-05-22  Создание объекта  "supplier_info" - атрибуты Поставщика услуг
   -- ============================================================================= --

   DECLARE
     JKEY  CONSTANT text      := 'supplier_info';
     JKEYS CONSTANT text[]    := array['phones', 'name', 'inn']::text[];  
     JQ    CONSTANT integer[] := array[  NULL,    256,    NULL]::integer[];
     --                                   1        2        3       
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s" = %L';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';

     __result json;
      
   BEGIN

     IF (p_phones IS NULL)
       THEN
            RAISE '%', format ( __null_mess, JKEY, JKEYS[1], p_phones );      
            
       ELSIF NOT (p_inn ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[3], p_inn);   
                 
       ELSIF NOT (char_length (p_name) <= JQ[2])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[2], JQ[2]);                 
       END IF;      
      
       __result := json_strip_nulls (json_build_object (JKEYS[1], p_phones::text[], JKEYS[2], p_name::text, JKEYS[3], p_inn::text));
       
       RETURN __result;
   END;
  
$_$;


ALTER FUNCTION fsc_receipt_pcg.fsc_supplier_info_crt_2(p_phones text[], p_name text, p_inn text) OWNER TO postgres;

--
-- TOC entry 7910 (class 0 OID 0)
-- Dependencies: 638
-- Name: FUNCTION fsc_supplier_info_crt_2(p_phones text[], p_name text, p_inn text); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_supplier_info_crt_2(p_phones text[], p_name text, p_inn text) IS 'Создание объекта  "supplier_info" - атрибуты Поставщика услуг';


--
-- TOC entry 644 (class 1255 OID 2120403)
-- Name: fsc_vat_crt_2(public.vat_t, numeric); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_vat_crt_2(p_type public.vat_t, p_sum numeric DEFAULT NULL::numeric) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
   -- ============================================================================ --
   --    2023-05-18  Создание объекта  "vat" - атрибуты налога на позицию
   -- ============================================================================ --

   DECLARE
     JKEY  CONSTANT text   := 'vat';
     JKEYS CONSTANT text[] := array['type', 'sum']::text[];  

     __null_mess text := '"%s": Эти данные являются обязательными: "%s" = %L';
     __result json;
      
   BEGIN
   
    IF (p_type IS NULL)
       THEN
            RAISE '%', format ( __null_mess, JKEY, JKEYS[1], p_type);     
    END IF;
    __result := json_strip_nulls (json_build_object(JKEYS[1], p_type::text, JKEYS[2], p_sum));
       
    RETURN __result;
    
   END;
  
$$;


ALTER FUNCTION fsc_receipt_pcg.fsc_vat_crt_2(p_type public.vat_t, p_sum numeric) OWNER TO postgres;

--
-- TOC entry 7911 (class 0 OID 0)
-- Dependencies: 644
-- Name: FUNCTION fsc_vat_crt_2(p_type public.vat_t, p_sum numeric); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_vat_crt_2(p_type public.vat_t, p_sum numeric) IS 'Создание объекта "vat" - атрибуты налога на позицию';


--
-- TOC entry 645 (class 1255 OID 2120405)
-- Name: fsc_vats_crt_1(public.vats_type_sum_t[]); Type: FUNCTION; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE FUNCTION fsc_receipt_pcg.fsc_vats_crt_1(p_vats_type_sum public.vats_type_sum_t[]) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
   -- ============================================================================ --
   --    2023-05-19 Создание объекта `vats" - Ставка и сумма налогов в кассе.
   -- ============================================================================ --

   DECLARE
    JKEY    CONSTANT text    := 'vats';
    QTY_VTS CONSTANT integer := 6; 
     
    __lts_vats_mess text := '"%s": Количество различных видов оплаты не должно превышать: %s';
    __null_mess     text := '"%s": Эти данные являются обязательными: "%s[%s]" = %L';
    __result json;
    
    __vats_type_sum  vats_type_sum_t; 
    __i integer;
      
   BEGIN
      IF (array_length (p_vats_type_sum, 1) > QTY_VTS) 
        THEN
           RAISE '%', format (__lts_vats_mess, JKEY, QTY_VTS);
      END IF;

      __i := 1;
      FOREACH __vats_type_sum IN ARRAY p_vats_type_sum
        LOOP
           IF (__vats_type_sum.vats_type IS NULL)
             THEN
                  RAISE '%', format (__null_mess, JKEY, 'vats_type', __i, __vats_type_sum.vats_type);     
           END IF; 
		   
           __i := __i + 1;
        END LOOP;
   
      __result := json_strip_nulls (to_json(p_vats_type_sum));
      
      RETURN __result;
   END;
  
$$;


ALTER FUNCTION fsc_receipt_pcg.fsc_vats_crt_1(p_vats_type_sum public.vats_type_sum_t[]) OWNER TO postgres;

--
-- TOC entry 7912 (class 0 OID 0)
-- Dependencies: 645
-- Name: FUNCTION fsc_vats_crt_1(p_vats_type_sum public.vats_type_sum_t[]); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_vats_crt_1(p_vats_type_sum public.vats_type_sum_t[]) IS 'Создание объекта `vats" - Ставка и сумма налогов в кассе.';


--
-- TOC entry 634 (class 1255 OID 2120768)
-- Name: p_source_reestr_ins_0(text, text); Type: PROCEDURE; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE PROCEDURE fsc_receipt_pcg.p_source_reestr_ins_0(p_select text, p_insert text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------
    --  2023-06-28 Создание записей в реестре исходных данных. Финальная часть.
    -- -------------------------------------------------------------------------    
    DECLARE
     __data  record;
     __exec  text;
     --
     __select text := btrim (p_select);
     __insert text := btrim (p_insert);     
     
    BEGIN
            
        FOR __data IN EXECUTE __select 
           LOOP
             __exec := format (__insert
                                ,__data.dt_create   
                                ,__data.company_email  
                                ,__data.company_sno  
                                ,__data.company_inn   
                                ,__data.company_payment_addr  
                                ,__data.company_phones          
                                ,__data.company_name  
                                ,__data.company_bik
                                ,__data.client_name              
                                ,__data.client_inn               
                                ,__data.pmt_type                 
                                ,__data.pmt_sum                  
                                ,__data.item_name                
                                ,__data.item_price               
                                ,__data.item_measure            
                                ,__data.item_sum                
                                ,__data.item_payment_method      
                                ,__data.payment_object           
                                ,__data.item_vat                 
                                ,__data.client_account     
                                ,__data.company_account    
                                ,__data.company_paying_agent 
                                ,__data.bank_name            
                                ,__data.bank_inn             
                                ,__data.bank_bik             
                                ,__data.bank_phones          
                                ,__data.bank_addr     
                                ,__data.type_source_reestr  
                                ,__data.external_id        
             );
             EXECUTE __exec;
             
        END LOOP;    
    
   END;
  $$;


ALTER PROCEDURE fsc_receipt_pcg.p_source_reestr_ins_0(p_select text, p_insert text) OWNER TO postgres;

--
-- TOC entry 7913 (class 0 OID 0)
-- Dependencies: 634
-- Name: PROCEDURE p_source_reestr_ins_0(p_select text, p_insert text); Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON PROCEDURE fsc_receipt_pcg.p_source_reestr_ins_0(p_select text, p_insert text) IS 'Создание записей в реестре исходных данных. Финальная часть.';


--
-- TOC entry 657 (class 1255 OID 2120742)
-- Name: f_show_col_descr(character varying, character varying, character[], text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_show_col_descr(p_schema_name character varying DEFAULT NULL::character varying, p_obj_name character varying DEFAULT NULL::character varying, p_object_type character[] DEFAULT ARRAY['r'::text, 'v'::text, 'm'::text, 'c'::text, 't'::text, 'f'::text, 'p'::text], p_provider text DEFAULT 'selinux'::text) RETURNS TABLE(schema_name character varying, objoid integer, obj_type character varying, obj_name character varying, attr_number smallint, column_name character varying, type_name character varying, type_len integer, type_prec integer, base_name character varying, type_category character, column_description character varying, not_null boolean, has_default boolean, default_value text, seclabel text)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$

/*------------------------------------------------------------------------------------
   Описание  f_show_col_descr
   Получение описание столбцов таблицы/представления.
   Необходимо доработать блок, выводящий информацию о типе столбца.

   Раздел или область применения: Сервис

    История:
     Дата: 22.08.2013  NIck
     -- ------------------------
    2015-04-05  Добавлены:
                  STABLE  SECURITY DEFINER
    2016-01-22  Типы сущностей согласованы с проектом ASK_U,
                 добавлены новые типы: 't' - pg_toast, 'c' - user defined type
    2016-02-12 Roman - Длина отображается корректно.
    2017-05-19 Nick  - длина отображается ещё корректнее
    2019-02-26 Новый тип сущности: внешняя таблица.
    2020-01-23 Новый тип сущности: секционированная таблица 
	2020-03-27 Nick Добавлен столбец "seclabel"
    ---------------------------------------------------------------------------------------------

     За основу взят текст из статьи: Лихачёв В. Н. "ОБРАБОТКА ОШИБОК ОГРАНИЧЕНИЙ ДЛЯ БАЗ ДАННЫХ
                 POSTGRESQL".   Калужский университет.
    ----------------------------------------------------------------------------------------------*/
     DECLARE  
        C_NUM_TYPES text [] := ARRAY ['t_money', 't_decimal', 'money', 'numeric', 'decimal'];

     BEGIN
      RETURN QUERY
          SELECT
               n.nspname::VARCHAR(20) AS schema_name
             , c.oid::INTEGER AS objoid
             , CASE c.relkind
                    WHEN 'r' THEN 'C_TABLE'
                    WHEN 'v' THEN 'C_VIEW'
                    WHEN 'm' THEN 'C_MAT_VIEW'
                    WHEN 'c' THEN 'C_TYPE' 
                    WHEN 't' THEN 'C_PG_TOAST'
                    WHEN 'f' THEN 'C_FTABLE' -- 2019-02-26
                    WHEN 'p' THEN 'C_STABLE' -- 2020-01-23
                   ELSE 'C_UNDEF'
               END::varchar(20)         AS obj_type
             , c.relname::VARCHAR(64)   AS obj_name
             , a.attnum::SMALLINT       AS attr_number
             , a.attname::VARCHAR  (64) AS column_name
             , t1.typname::VARCHAR (64) AS type_name
               -- Nick 2017-05-19
             , 
               CASE
                WHEN NOT (t1.typname = ANY (C_NUM_TYPES))
                    THEN -- Nick 2019-02-27
                       COALESCE (t2.character_maximum_length, (
                          CASE  
                             WHEN ((t1.typlen = -1) AND ( NOT t1.typbyval ) and (t1.typcategory = 'S' ) AND 
                                   (t1.typtypmod > 0)
                                  ) 
                             THEN
                                (t1.typtypmod - 4)::INTEGER 
                             ELSE
                                  t1.typlen::INTEGER 
                          END
                         )
                       ) -- Nick 2019-02-27            
                         ELSE
                              t2.numeric_precision::INTEGER             
                END AS type_len
                --
              , CASE  
                     WHEN ( t1.typname = ANY (C_NUM_TYPES))
                       THEN
                           t2.numeric_scale::INTEGER 
                       ELSE
                           0::INTEGER             
                END AS numerci_scale
               -- 
             , t2.data_type::VARCHAR (64) AS base_name
             , t1.typcategory::CHAR(1)  
               -- Nick 2017-05-19
             , d.description::VARCHAR (250) AS column_description
             , a.attnotnull::BOOLEAN   AS not_null
             , a.atthasdef::BOOLEAN    AS has_default
             , t2.column_default::TEXT AS default_value
             , sl.label  AS seclabel

          FROM pg_namespace n
                INNER JOIN pg_class c     ON ( n.oid = c.relnamespace )
                INNER JOIN pg_attribute a ON (( a.attrelid = c.oid ) AND ( a.attnum > 0 ))
                INNER JOIN pg_type t1     ON ( a.atttypid = t1.oid )
                LEFT OUTER join information_schema.columns t2 ON 
                            (t2.table_schema = n.nspname) AND (t2.table_name = c.relname) AND
                            (t2.ordinal_position = a.attnum)
                LEFT OUTER JOIN pg_description d ON ((d.objoid = a.attrelid) AND (a.attnum = d.objsubid))
                LEFT OUTER JOIN                              
                 LATERAL ( SELECT s.label, s.objoid, s.objsubid FROM pg_seclabels s
                           WHERE (s.objoid = c.oid) AND (s.objsubid = a.attnum) AND
                                 (s.objtype = 'column') AND (s.provider = btrim(lower(p_provider)))            
            ) sl ON (sl.objoid = c.oid) AND (sl.objsubid = a.attnum)                            
          WHERE
               ( c.relkind = ANY (p_object_type ))
           AND ( n.nspname = COALESCE ( lower ( p_schema_name ), n.nspname ) )
           AND ( c.relname = COALESCE ( lower (btrim ( p_obj_name )), c.relname ))
        ORDER BY c.relname, a.attnum;
    END;
    $$;


ALTER FUNCTION public.f_show_col_descr(p_schema_name character varying, p_obj_name character varying, p_object_type character[], p_provider text) OWNER TO postgres;

--
-- TOC entry 7914 (class 0 OID 0)
-- Dependencies: 657
-- Name: FUNCTION f_show_col_descr(p_schema_name character varying, p_obj_name character varying, p_object_type character[], p_provider text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.f_show_col_descr(p_schema_name character varying, p_obj_name character varying, p_object_type character[], p_provider text) IS '10: Получение описание столбцов таблицы/представления

   Раздел или область применения: Сервис
   Входные параметры:
       p_schema_name    VARCHAR (20)    -- Наименование схемы
      ,p_obj_name       VARCHAR (64)    -- Наименование объекта
      ,p_object_type    CHAR(1) []      -- Тип объекта ''r'' - таблица, ''v'' - представление, ''t'' - pg_toast, ''c'' - user defined type.
      ,p_provider       TEXT   = ''selinux''  -- Имя провайдера безопасности

   Выходные параметры:
    (
                  schema_name         VARCHAR  (20)  -- Наименование схемы
                , objoid              INTEGER        -- OID объекта
                , obj_type            VARCHAR  (20)  -- Тип объекта
                , obj_name            VARCHAR  (64)  -- Наименование объекта
                , attr_number         SMALLINT       -- Номер атрибута
                , column_name         VARCHAR  (64)  -- Наименование атрибута
                , type_name           VARCHAR  (64)  -- Наименование типа
                , type_len            INTEGER        -- Длина типа
                , type_prec           INTEGER        -- Точность поля
                , base_name           VARCHAR  (64)  -- Имя базового типа
                , type_category       CHAR(1)        -- Категория типа
                , column_description  VARCHAR (250)  -- Описание столбца
                , not_null            BOOLEAN        -- Признак NOT NULL
                , has_default         BOOLEAN        -- Признак DEFAULT VALUE
                , default_value       TEXT           -- Значение по умолчанию 
		        ,seclabel            TEXT           -- Метка безопаснос                
    )

    Пример использования:
             SELECT * FROM f_show_col_descr (); -- Все таблицы во всех схемах.
             SELECT * FROM f_show_col_descr ( NULL, NULL, ARRAY[''v''] ) ORDER BY schema_name, obj_name;  -- Все представления.
             SELECT * FROM f_show_col_descr ( ''obj'', NULL, ARRAY [''v'', ''r''] ) ORDER BY schema_name, obj_name, attr_number; -- Все представления в схеме "Объекты".

    Категории типа:
          A - Массив
          B - Логический
          C - Составной
          D - Дата/время
          E - Перечисление
          G - Геометрический
          I - Сетевой адрес
          N - Число
          P - Псевдотип
          R - Диапазон 
          S - Строка
          T - Интервал
          U - Пользовательский
          V - Битовая строка
          X - Неизвестный тип (unknown)
';


--
-- TOC entry 629 (class 1255 OID 46852)
-- Name: get_secure_info(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_secure_info(_uuid character varying, _secret character varying, _inn character varying) RETURNS TABLE(org_id integer, inn character varying, active smallint, "group" character varying, kkt_count smallint, default_parameters character varying, name character varying, uuid character varying, app_id integer, notification_url character varying, orange_key character varying)
    LANGUAGE sql
    AS $$

select
	org.org_id,
	org.inn,
	org.active,
	org.group,
	org.kkt_count,
	org.default_parameters::varchar,
	app.name,
	app.uuid,
	app.app_id,
	app.notification_url,
	app.orange_key
from
	org_link link
join org org on
	org.org_id = link.org_id
join app app on
	app.app_id = link.app_id
where	app.uuid = _uuid
and     app.secret = _secret
and case _inn
	WHEN ''
		THEN 1=1
    ELSE org.inn = _inn
    end 

$$;


ALTER FUNCTION public.get_secure_info(_uuid character varying, _secret character varying, _inn character varying) OWNER TO postgres;

--
-- TOC entry 616 (class 1255 OID 46853)
-- Name: inc(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.inc(val integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN val + 1;
END; $$;


ALTER FUNCTION public.inc(val integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 311 (class 1259 OID 1510509)
-- Name: fsc_app; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_app (
    id_app integer NOT NULL,
    dt_create timestamp(0) without time zone NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    app_guid uuid,
    secret_key text NOT NULL,
    nm_app text NOT NULL,
    notification_url text,
    provaider_key text
);


ALTER TABLE "_OLD_1_fiscalization".fsc_app OWNER TO postgres;

--
-- TOC entry 7919 (class 0 OID 0)
-- Dependencies: 311
-- Name: TABLE fsc_app; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_app IS 'Приложение';


--
-- TOC entry 7920 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN fsc_app.id_app; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app.id_app IS 'ID приложения';


--
-- TOC entry 7921 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN fsc_app.dt_create; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app.dt_create IS 'Дата создания записи';


--
-- TOC entry 7922 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN fsc_app.dt_update; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app.dt_update IS 'Дата обновления';


--
-- TOC entry 7923 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN fsc_app.dt_remove; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 7924 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN fsc_app.app_guid; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app.app_guid IS 'UUID приложения';


--
-- TOC entry 7925 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN fsc_app.secret_key; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app.secret_key IS 'Секретный ключ';


--
-- TOC entry 7926 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN fsc_app.nm_app; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app.nm_app IS 'Название приложеия';


--
-- TOC entry 7927 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN fsc_app.notification_url; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app.notification_url IS 'URL для уведомлений';


--
-- TOC entry 7928 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN fsc_app.provaider_key; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app.provaider_key IS 'Ключ провайдера';


--
-- TOC entry 300 (class 1259 OID 1510236)
-- Name: fsc_app_kkt_group; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_app_kkt_group (
    id_app_kkt_group integer NOT NULL,
    id_app integer NOT NULL,
    id_kkt_group integer NOT NULL,
    dt_create timestamp(0) without time zone,
    app_kkt_status boolean
);


ALTER TABLE "_OLD_1_fiscalization".fsc_app_kkt_group OWNER TO postgres;

--
-- TOC entry 7929 (class 0 OID 0)
-- Dependencies: 300
-- Name: TABLE fsc_app_kkt_group; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_app_kkt_group IS 'Приложения для группы ККТ';


--
-- TOC entry 7930 (class 0 OID 0)
-- Dependencies: 300
-- Name: COLUMN fsc_app_kkt_group.id_app_kkt_group; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app_kkt_group.id_app_kkt_group IS 'ID приложения для группы ККТ';


--
-- TOC entry 7931 (class 0 OID 0)
-- Dependencies: 300
-- Name: COLUMN fsc_app_kkt_group.id_app; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app_kkt_group.id_app IS 'ID приложение';


--
-- TOC entry 7932 (class 0 OID 0)
-- Dependencies: 300
-- Name: COLUMN fsc_app_kkt_group.id_kkt_group; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app_kkt_group.id_kkt_group IS 'ID группы ККТ';


--
-- TOC entry 7933 (class 0 OID 0)
-- Dependencies: 300
-- Name: COLUMN fsc_app_kkt_group.dt_create; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app_kkt_group.dt_create IS 'Дата создания';


--
-- TOC entry 7934 (class 0 OID 0)
-- Dependencies: 300
-- Name: COLUMN fsc_app_kkt_group.app_kkt_status; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_app_kkt_group.app_kkt_status IS 'Статус';


--
-- TOC entry 301 (class 1259 OID 1510239)
-- Name: fsc_appeal; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_appeal (
    id_appeal integer NOT NULL,
    id_user integer NOT NULL,
    dt_appeal timestamp(0) without time zone,
    nmb_appeal text,
    descr_appeal text,
    apl_status boolean,
    apl_type integer,
    apl_file text
);


ALTER TABLE "_OLD_1_fiscalization".fsc_appeal OWNER TO postgres;

--
-- TOC entry 7935 (class 0 OID 0)
-- Dependencies: 301
-- Name: TABLE fsc_appeal; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_appeal IS 'Обращение';


--
-- TOC entry 7936 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN fsc_appeal.id_appeal; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_appeal.id_appeal IS 'ID обращения';


--
-- TOC entry 7937 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN fsc_appeal.dt_appeal; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_appeal.dt_appeal IS 'Дата обращения';


--
-- TOC entry 7938 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN fsc_appeal.nmb_appeal; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_appeal.nmb_appeal IS 'Номер обрашения';


--
-- TOC entry 7939 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN fsc_appeal.descr_appeal; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_appeal.descr_appeal IS 'Описание обращения';


--
-- TOC entry 7940 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN fsc_appeal.apl_status; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_appeal.apl_status IS 'Статус обращения';


--
-- TOC entry 7941 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN fsc_appeal.apl_type; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_appeal.apl_type IS 'Тип обращения';


--
-- TOC entry 7942 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN fsc_appeal.apl_file; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_appeal.apl_file IS 'Файл';


--
-- TOC entry 302 (class 1259 OID 1510245)
-- Name: fsc_data_operator; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_data_operator (
    id_fsc_data_operator integer NOT NULL,
    nm_data_operator text,
    site_data_operator text
);


ALTER TABLE "_OLD_1_fiscalization".fsc_data_operator OWNER TO postgres;

--
-- TOC entry 7943 (class 0 OID 0)
-- Dependencies: 302
-- Name: TABLE fsc_data_operator; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_data_operator IS 'ОФД';


--
-- TOC entry 7944 (class 0 OID 0)
-- Dependencies: 302
-- Name: COLUMN fsc_data_operator.id_fsc_data_operator; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_data_operator.id_fsc_data_operator IS 'ID оператора фискальных данных';


--
-- TOC entry 7945 (class 0 OID 0)
-- Dependencies: 302
-- Name: COLUMN fsc_data_operator.nm_data_operator; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_data_operator.nm_data_operator IS 'Наименование оператора фискальных данных';


--
-- TOC entry 7946 (class 0 OID 0)
-- Dependencies: 302
-- Name: COLUMN fsc_data_operator.site_data_operator; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_data_operator.site_data_operator IS 'Сайт оператора фискальных данных';


--
-- TOC entry 303 (class 1259 OID 1510251)
-- Name: fsc_filter; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_filter (
    id_filter integer NOT NULL,
    id_task integer,
    fsc_query json,
    nm_filter_name character varying(255),
    filter_type integer
);


ALTER TABLE "_OLD_1_fiscalization".fsc_filter OWNER TO postgres;

--
-- TOC entry 7947 (class 0 OID 0)
-- Dependencies: 303
-- Name: TABLE fsc_filter; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_filter IS 'Фильтр';


--
-- TOC entry 7948 (class 0 OID 0)
-- Dependencies: 303
-- Name: COLUMN fsc_filter.id_filter; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_filter.id_filter IS 'ID Фильтра';


--
-- TOC entry 7949 (class 0 OID 0)
-- Dependencies: 303
-- Name: COLUMN fsc_filter.id_task; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_filter.id_task IS 'ID задачи';


--
-- TOC entry 7950 (class 0 OID 0)
-- Dependencies: 303
-- Name: COLUMN fsc_filter.fsc_query; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_filter.fsc_query IS 'Запрос';


--
-- TOC entry 7951 (class 0 OID 0)
-- Dependencies: 303
-- Name: COLUMN fsc_filter.filter_type; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_filter.filter_type IS 'Тип фильтра';


--
-- TOC entry 304 (class 1259 OID 1510257)
-- Name: fsc_kkt; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_kkt (
    id_kkt integer NOT NULL,
    id_fsc_provider integer,
    id_kkt_group integer,
    kkt_dt_create timestamp(0) without time zone,
    rcp_qty integer,
    kkt_nmb text,
    kkt_status integer
);


ALTER TABLE "_OLD_1_fiscalization".fsc_kkt OWNER TO postgres;

--
-- TOC entry 7952 (class 0 OID 0)
-- Dependencies: 304
-- Name: TABLE fsc_kkt; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_kkt IS 'ККТ';


--
-- TOC entry 7953 (class 0 OID 0)
-- Dependencies: 304
-- Name: COLUMN fsc_kkt.id_kkt; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_kkt.id_kkt IS 'ID ККТ';


--
-- TOC entry 7954 (class 0 OID 0)
-- Dependencies: 304
-- Name: COLUMN fsc_kkt.id_fsc_provider; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_kkt.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 7955 (class 0 OID 0)
-- Dependencies: 304
-- Name: COLUMN fsc_kkt.id_kkt_group; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_kkt.id_kkt_group IS 'ID группы ККТ';


--
-- TOC entry 7956 (class 0 OID 0)
-- Dependencies: 304
-- Name: COLUMN fsc_kkt.kkt_dt_create; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_kkt.kkt_dt_create IS 'Дата выдачи';


--
-- TOC entry 7957 (class 0 OID 0)
-- Dependencies: 304
-- Name: COLUMN fsc_kkt.rcp_qty; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_kkt.rcp_qty IS 'Количество чеков';


--
-- TOC entry 7958 (class 0 OID 0)
-- Dependencies: 304
-- Name: COLUMN fsc_kkt.kkt_nmb; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_kkt.kkt_nmb IS 'Номер ККТ';


--
-- TOC entry 7959 (class 0 OID 0)
-- Dependencies: 304
-- Name: COLUMN fsc_kkt.kkt_status; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_kkt.kkt_status IS 'Статус';


--
-- TOC entry 305 (class 1259 OID 1510263)
-- Name: fsc_kkt_groupe; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_kkt_groupe (
    id_kkt_group integer NOT NULL,
    kkt_qty integer,
    nm_kkt_group text,
    id_org integer,
    id_fsc_provider integer,
    kkt_grp_status boolean
);


ALTER TABLE "_OLD_1_fiscalization".fsc_kkt_groupe OWNER TO postgres;

--
-- TOC entry 7960 (class 0 OID 0)
-- Dependencies: 305
-- Name: TABLE fsc_kkt_groupe; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_kkt_groupe IS 'Группа ККТ';


--
-- TOC entry 7961 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN fsc_kkt_groupe.id_kkt_group; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_kkt_groupe.id_kkt_group IS 'ID группы ККТ';


--
-- TOC entry 7962 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN fsc_kkt_groupe.kkt_qty; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_kkt_groupe.kkt_qty IS 'Количество касс';


--
-- TOC entry 7963 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN fsc_kkt_groupe.nm_kkt_group; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_kkt_groupe.nm_kkt_group IS 'Название группы ККТ';


--
-- TOC entry 7964 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN fsc_kkt_groupe.id_org; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_kkt_groupe.id_org IS 'Организация';


--
-- TOC entry 7965 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN fsc_kkt_groupe.id_fsc_provider; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_kkt_groupe.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 7966 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN fsc_kkt_groupe.kkt_grp_status; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_kkt_groupe.kkt_grp_status IS 'Статус';


--
-- TOC entry 312 (class 1259 OID 1510527)
-- Name: fsc_org; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_org (
    id_org integer NOT NULL,
    dt_create timestamp(0) without time zone NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    nm_group character varying(32),
    inn character varying(20) NOT NULL,
    kkt_qty integer NOT NULL,
    nm_org_name character varying(255) NOT NULL,
    default_parameters json,
    org_type integer,
    org_status boolean NOT NULL
);


ALTER TABLE "_OLD_1_fiscalization".fsc_org OWNER TO postgres;

--
-- TOC entry 7967 (class 0 OID 0)
-- Dependencies: 312
-- Name: TABLE fsc_org; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_org IS 'Организация';


--
-- TOC entry 7968 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN fsc_org.id_org; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org.id_org IS 'ID организации';


--
-- TOC entry 7969 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN fsc_org.dt_create; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org.dt_create IS 'Дата создания записи';


--
-- TOC entry 7970 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN fsc_org.dt_update; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org.dt_update IS 'Дата обновления';


--
-- TOC entry 7971 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN fsc_org.dt_remove; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 7972 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN fsc_org.nm_group; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org.nm_group IS 'Группа касс';


--
-- TOC entry 7973 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN fsc_org.inn; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org.inn IS 'ИНН';


--
-- TOC entry 7974 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN fsc_org.kkt_qty; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org.kkt_qty IS 'Количество касс';


--
-- TOC entry 7975 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN fsc_org.nm_org_name; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org.nm_org_name IS 'Наименование организации';


--
-- TOC entry 7976 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN fsc_org.default_parameters; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org.default_parameters IS 'Параметры по умолчанию';


--
-- TOC entry 7977 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN fsc_org.org_type; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org.org_type IS 'Тип организации';


--
-- TOC entry 7978 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN fsc_org.org_status; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org.org_status IS 'Статус организации';


--
-- TOC entry 306 (class 1259 OID 1510275)
-- Name: fsc_org_app; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_org_app (
    id_org_app integer NOT NULL,
    id_app integer NOT NULL,
    id_org integer NOT NULL,
    dt_create timestamp(0) without time zone,
    org_app_status boolean
);


ALTER TABLE "_OLD_1_fiscalization".fsc_org_app OWNER TO postgres;

--
-- TOC entry 7979 (class 0 OID 0)
-- Dependencies: 306
-- Name: TABLE fsc_org_app; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_org_app IS 'Приложения организации';


--
-- TOC entry 7980 (class 0 OID 0)
-- Dependencies: 306
-- Name: COLUMN fsc_org_app.id_org_app; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org_app.id_org_app IS 'ID приложения организации';


--
-- TOC entry 7981 (class 0 OID 0)
-- Dependencies: 306
-- Name: COLUMN fsc_org_app.id_app; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org_app.id_app IS 'ID приложение';


--
-- TOC entry 7982 (class 0 OID 0)
-- Dependencies: 306
-- Name: COLUMN fsc_org_app.id_org; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org_app.id_org IS 'ID Организации';


--
-- TOC entry 7983 (class 0 OID 0)
-- Dependencies: 306
-- Name: COLUMN fsc_org_app.dt_create; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org_app.dt_create IS 'Дата создания';


--
-- TOC entry 7984 (class 0 OID 0)
-- Dependencies: 306
-- Name: COLUMN fsc_org_app.org_app_status; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_org_app.org_app_status IS 'Статус';


--
-- TOC entry 328 (class 1259 OID 1512062)
-- Name: fsc_payment_id_pmt_seq; Type: SEQUENCE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_1_fiscalization".fsc_payment_id_pmt_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_id_pmt_seq OWNER TO postgres;

--
-- TOC entry 314 (class 1259 OID 1510831)
-- Name: fsc_payment; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL
)
PARTITION BY RANGE (dt_payment);


ALTER TABLE "_OLD_1_fiscalization".fsc_payment OWNER TO postgres;

--
-- TOC entry 7985 (class 0 OID 0)
-- Dependencies: 314
-- Name: TABLE fsc_payment; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_payment IS 'Платёж';


--
-- TOC entry 7986 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN fsc_payment.id_payment; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_payment.id_payment IS 'ID платежа';


--
-- TOC entry 7987 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN fsc_payment.dt_payment; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_payment.dt_payment IS 'Дата платежа';


--
-- TOC entry 7988 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN fsc_payment.pmt_status; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_payment.pmt_status IS 'Статус платежа';


--
-- TOC entry 7989 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN fsc_payment.id_currency; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_payment.id_currency IS 'Валюта';


--
-- TOC entry 7990 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN fsc_payment.qty_pos; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_payment.qty_pos IS 'Количество позиций';


--
-- TOC entry 7991 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN fsc_payment.vat_rate; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_payment.vat_rate IS 'Ставка НДС';


--
-- TOC entry 7992 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN fsc_payment.pmt_amount; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_payment.pmt_amount IS 'Сумма';


--
-- TOC entry 7993 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN fsc_payment.pmt_type; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_payment.pmt_type IS 'Тип платежа';


--
-- TOC entry 327 (class 1259 OID 1512012)
-- Name: fsc_payment_default; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment_default (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_default DEFAULT;


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_default OWNER TO postgres;

--
-- TOC entry 315 (class 1259 OID 1511832)
-- Name: fsc_payment_part_2021_01; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_01 (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL,
    CONSTRAINT chk_receipt_dt_payment_2021_01 CHECK (((dt_payment >= '2021-01-01 00:00:00+03'::timestamp with time zone) AND (dt_payment < '2021-02-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_01 FOR VALUES FROM ('2021-01-01 00:00:00+03') TO ('2021-02-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_01 OWNER TO postgres;

--
-- TOC entry 316 (class 1259 OID 1511847)
-- Name: fsc_payment_part_2021_02; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_02 (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL,
    CONSTRAINT chk_receipt_dt_payment_2021_02 CHECK (((dt_payment >= '2021-02-01 00:00:00+03'::timestamp with time zone) AND (dt_payment < '2021-03-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_02 FOR VALUES FROM ('2021-02-01 00:00:00+03') TO ('2021-03-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_02 OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 1511862)
-- Name: fsc_payment_part_2021_03; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_03 (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL,
    CONSTRAINT chk_receipt_dt_payment_2021_03 CHECK (((dt_payment >= '2021-03-01 00:00:00+03'::timestamp with time zone) AND (dt_payment < '2021-04-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_03 FOR VALUES FROM ('2021-03-01 00:00:00+03') TO ('2021-04-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_03 OWNER TO postgres;

--
-- TOC entry 318 (class 1259 OID 1511877)
-- Name: fsc_payment_part_2021_04; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_04 (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL,
    CONSTRAINT chk_receipt_dt_payment_2021_04 CHECK (((dt_payment >= '2021-04-01 00:00:00+03'::timestamp with time zone) AND (dt_payment < '2021-05-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_04 FOR VALUES FROM ('2021-04-01 00:00:00+03') TO ('2021-05-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_04 OWNER TO postgres;

--
-- TOC entry 319 (class 1259 OID 1511892)
-- Name: fsc_payment_part_2021_05; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_05 (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL,
    CONSTRAINT chk_receipt_dt_payment_2021_05 CHECK (((dt_payment >= '2021-05-01 00:00:00+03'::timestamp with time zone) AND (dt_payment < '2021-06-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_05 FOR VALUES FROM ('2021-05-01 00:00:00+03') TO ('2021-06-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_05 OWNER TO postgres;

--
-- TOC entry 320 (class 1259 OID 1511907)
-- Name: fsc_payment_part_2021_06; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_06 (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL,
    CONSTRAINT chk_receipt_dt_payment_2021_06 CHECK (((dt_payment >= '2021-06-01 00:00:00+03'::timestamp with time zone) AND (dt_payment < '2021-07-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_06 FOR VALUES FROM ('2021-06-01 00:00:00+03') TO ('2021-07-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_06 OWNER TO postgres;

--
-- TOC entry 321 (class 1259 OID 1511922)
-- Name: fsc_payment_part_2021_07; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_07 (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL,
    CONSTRAINT chk_receipt_dt_payment_2021_07 CHECK (((dt_payment >= '2021-07-01 00:00:00+03'::timestamp with time zone) AND (dt_payment < '2021-08-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_07 FOR VALUES FROM ('2021-07-01 00:00:00+03') TO ('2021-08-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_07 OWNER TO postgres;

--
-- TOC entry 322 (class 1259 OID 1511937)
-- Name: fsc_payment_part_2021_08; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_08 (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL,
    CONSTRAINT chk_receipt_dt_payment_2021_08 CHECK (((dt_payment >= '2021-08-01 00:00:00+03'::timestamp with time zone) AND (dt_payment < '2021-09-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_08 FOR VALUES FROM ('2021-08-01 00:00:00+03') TO ('2021-09-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_08 OWNER TO postgres;

--
-- TOC entry 323 (class 1259 OID 1511952)
-- Name: fsc_payment_part_2021_09; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_09 (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL,
    CONSTRAINT chk_receipt_dt_payment_2021_09 CHECK (((dt_payment >= '2021-09-01 00:00:00+03'::timestamp with time zone) AND (dt_payment < '2021-10-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_09 FOR VALUES FROM ('2021-09-01 00:00:00+03') TO ('2021-10-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_09 OWNER TO postgres;

--
-- TOC entry 324 (class 1259 OID 1511967)
-- Name: fsc_payment_part_2021_10; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_10 (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL,
    CONSTRAINT chk_receipt_dt_payment_2021_10 CHECK (((dt_payment >= '2021-10-01 00:00:00+03'::timestamp with time zone) AND (dt_payment < '2021-11-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_10 FOR VALUES FROM ('2021-10-01 00:00:00+03') TO ('2021-11-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_10 OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 1511982)
-- Name: fsc_payment_part_2021_11; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_11 (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL,
    CONSTRAINT chk_receipt_dt_payment_2021_11 CHECK (((dt_payment >= '2021-11-01 00:00:00+03'::timestamp with time zone) AND (dt_payment < '2021-12-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_11 FOR VALUES FROM ('2021-11-01 00:00:00+03') TO ('2021-12-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_11 OWNER TO postgres;

--
-- TOC entry 326 (class 1259 OID 1511997)
-- Name: fsc_payment_part_2021_12; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_12 (
    id_payment bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_payment_id_pmt_seq'::regclass) NOT NULL,
    dt_payment timestamp(0) with time zone NOT NULL,
    pmt_status integer,
    id_currency integer,
    qty_pos integer,
    vat_rate numeric(4,2),
    pmt_amount numeric(12,2),
    pmt_type integer,
    id_service bigint NOT NULL,
    id_user integer NOT NULL,
    CONSTRAINT chk_receipt_dt_payment_2021_12 CHECK (((dt_payment >= '2021-12-01 00:00:00+03'::timestamp with time zone) AND (dt_payment < '2022-01-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_12 FOR VALUES FROM ('2021-12-01 00:00:00+03') TO ('2022-01-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_payment_part_2021_12 OWNER TO postgres;

--
-- TOC entry 307 (class 1259 OID 1510281)
-- Name: fsc_provider; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_provider (
    id_fsc_provider integer NOT NULL,
    nm_fsk_providere character varying(255),
    fsc_url text,
    fsc_port character varying(5),
    fsc_status boolean
);


ALTER TABLE "_OLD_1_fiscalization".fsc_provider OWNER TO postgres;

--
-- TOC entry 7994 (class 0 OID 0)
-- Dependencies: 307
-- Name: TABLE fsc_provider; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_provider IS 'Фискальный провайдер';


--
-- TOC entry 7995 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN fsc_provider.id_fsc_provider; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_provider.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 7996 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN fsc_provider.nm_fsk_providere; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_provider.nm_fsk_providere IS 'Наименование';


--
-- TOC entry 7997 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN fsc_provider.fsc_url; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_provider.fsc_url IS 'URL фискального провайдера';


--
-- TOC entry 7998 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN fsc_provider.fsc_port; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_provider.fsc_port IS 'Порт';


--
-- TOC entry 7999 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN fsc_provider.fsc_status; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_provider.fsc_status IS 'Статус';


--
-- TOC entry 335 (class 1259 OID 1512293)
-- Name: fsc_receipt_id_receipt_seq; Type: SEQUENCE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_1_fiscalization".fsc_receipt_id_receipt_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_id_receipt_seq OWNER TO postgres;

--
-- TOC entry 336 (class 1259 OID 1512295)
-- Name: fsc_receipt; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL
)
PARTITION BY RANGE (dt_create);


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt OWNER TO postgres;

--
-- TOC entry 8000 (class 0 OID 0)
-- Dependencies: 336
-- Name: TABLE fsc_receipt; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_receipt IS 'Чек';


--
-- TOC entry 8001 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.id_receipt; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.id_receipt IS 'ID Чека';


--
-- TOC entry 8002 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.dt_create; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.dt_create IS 'Дата создания';


--
-- TOC entry 8003 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.id_payment; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.id_payment IS 'ID платежа';


--
-- TOC entry 8004 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.dt_payment; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.dt_payment IS 'Дата платежа';


--
-- TOC entry 8005 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.dt_update; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.dt_update IS 'Дата обновления';


--
-- TOC entry 8006 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.inn; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.inn IS 'ИНН';


--
-- TOC entry 8007 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.rcp_nmb; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.rcp_nmb IS 'Номер чека';


--
-- TOC entry 8008 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.rcp_contact; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.rcp_contact IS 'Контактная информация';


--
-- TOC entry 8009 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.rcp_fp; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.rcp_fp IS 'Номер ФН';


--
-- TOC entry 8010 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.dt_fp; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.dt_fp IS 'Дата фискализапции';


--
-- TOC entry 8011 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.id_org; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.id_org IS 'Организация';


--
-- TOC entry 8012 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.id_kkt; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.id_kkt IS 'ID ККТ';


--
-- TOC entry 8013 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.rcp_status_descr; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.rcp_status_descr IS 'Описание статуса';


--
-- TOC entry 8014 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.rcp_amount; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.rcp_amount IS 'Сумма';


--
-- TOC entry 8015 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.rcp_correction; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.rcp_correction IS 'Тип (чек корреции/кассовый чек)';


--
-- TOC entry 8016 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.rcp_status; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.rcp_status IS 'Статус чека';


--
-- TOC entry 8017 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.rcp_received; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.rcp_received IS 'Чек принят';


--
-- TOC entry 8018 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN fsc_receipt.rcp_notify_send; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt.rcp_notify_send IS 'Извещение отослано';


--
-- TOC entry 349 (class 1259 OID 1512500)
-- Name: fsc_receipt_default; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_default (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_default DEFAULT;


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_default OWNER TO postgres;

--
-- TOC entry 350 (class 1259 OID 1512561)
-- Name: fsc_receipt_js; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb
)
PARTITION BY RANGE (dt_create);


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js OWNER TO postgres;

--
-- TOC entry 8019 (class 0 OID 0)
-- Dependencies: 350
-- Name: TABLE fsc_receipt_js; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_receipt_js IS 'Чек, json структуры';


--
-- TOC entry 8020 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN fsc_receipt_js.id_receipt; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt_js.id_receipt IS 'ID Чека';


--
-- TOC entry 8021 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN fsc_receipt_js.dt_create; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt_js.dt_create IS 'Дата создания';


--
-- TOC entry 8022 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN fsc_receipt_js.rcp_order; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt_js.rcp_order IS 'Запрос на фискализацию';


--
-- TOC entry 8023 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN fsc_receipt_js.rcp_receipt; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_receipt_js.rcp_receipt IS 'Фискализированный чек';


--
-- TOC entry 363 (class 1259 OID 1512751)
-- Name: fsc_receipt_js_default; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js_default (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_default DEFAULT;


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js_default OWNER TO postgres;

--
-- TOC entry 351 (class 1259 OID 1512607)
-- Name: fsc_receipt_js_part_2021_01; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_01 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_receipt_js_dt_create_2021_01 CHECK (((dt_create >= '2021-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-02-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_01 FOR VALUES FROM ('2021-01-01 00:00:00+03') TO ('2021-02-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_01 OWNER TO postgres;

--
-- TOC entry 352 (class 1259 OID 1512619)
-- Name: fsc_receipt_js_part_2021_02; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_02 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_receipt_js_dt_create_2021_02 CHECK (((dt_create >= '2021-02-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-03-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_02 FOR VALUES FROM ('2021-02-01 00:00:00+03') TO ('2021-03-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_02 OWNER TO postgres;

--
-- TOC entry 353 (class 1259 OID 1512631)
-- Name: fsc_receipt_js_part_2021_03; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_03 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_receipt_js_dt_create_2021_03 CHECK (((dt_create >= '2021-03-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-04-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_03 FOR VALUES FROM ('2021-03-01 00:00:00+03') TO ('2021-04-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_03 OWNER TO postgres;

--
-- TOC entry 354 (class 1259 OID 1512643)
-- Name: fsc_receipt_js_part_2021_04; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_04 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_receipt_js_dt_create_2021_04 CHECK (((dt_create >= '2021-04-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-05-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_04 FOR VALUES FROM ('2021-04-01 00:00:00+03') TO ('2021-05-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_04 OWNER TO postgres;

--
-- TOC entry 355 (class 1259 OID 1512655)
-- Name: fsc_receipt_js_part_2021_05; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_05 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_receipt_js_dt_create_2021_05 CHECK (((dt_create >= '2021-05-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-06-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_05 FOR VALUES FROM ('2021-05-01 00:00:00+03') TO ('2021-06-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_05 OWNER TO postgres;

--
-- TOC entry 356 (class 1259 OID 1512667)
-- Name: fsc_receipt_js_part_2021_06; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_06 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_receipt_js_dt_create_2021_06 CHECK (((dt_create >= '2021-06-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-07-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_06 FOR VALUES FROM ('2021-06-01 00:00:00+03') TO ('2021-07-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_06 OWNER TO postgres;

--
-- TOC entry 357 (class 1259 OID 1512679)
-- Name: fsc_receipt_js_part_2021_07; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_07 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_receipt_js_dt_create_2021_07 CHECK (((dt_create >= '2021-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-08-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_07 FOR VALUES FROM ('2021-07-01 00:00:00+03') TO ('2021-08-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_07 OWNER TO postgres;

--
-- TOC entry 358 (class 1259 OID 1512691)
-- Name: fsc_receipt_js_part_2021_08; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_08 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_receipt_js_dt_create_2021_08 CHECK (((dt_create >= '2021-08-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-09-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_08 FOR VALUES FROM ('2021-08-01 00:00:00+03') TO ('2021-09-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_08 OWNER TO postgres;

--
-- TOC entry 359 (class 1259 OID 1512703)
-- Name: fsc_receipt_js_part_2021_09; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_09 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_receipt_js_dt_create_2021_09 CHECK (((dt_create >= '2021-09-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-10-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_09 FOR VALUES FROM ('2021-09-01 00:00:00+03') TO ('2021-10-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_09 OWNER TO postgres;

--
-- TOC entry 360 (class 1259 OID 1512715)
-- Name: fsc_receipt_js_part_2021_10; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_10 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_receipt_js_dt_create_2021_10 CHECK (((dt_create >= '2021-10-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-11-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_10 FOR VALUES FROM ('2021-10-01 00:00:00+03') TO ('2021-11-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_10 OWNER TO postgres;

--
-- TOC entry 361 (class 1259 OID 1512727)
-- Name: fsc_receipt_js_part_2021_11; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_11 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_receipt_js_dt_create_2021_11 CHECK (((dt_create >= '2021-11-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-12-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_11 FOR VALUES FROM ('2021-11-01 00:00:00+03') TO ('2021-12-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_11 OWNER TO postgres;

--
-- TOC entry 362 (class 1259 OID 1512739)
-- Name: fsc_receipt_js_part_2021_12; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_12 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_receipt_js_dt_create_2021_12 CHECK (((dt_create >= '2021-12-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2022-01-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_12 FOR VALUES FROM ('2021-12-01 00:00:00+03') TO ('2022-01-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js_part_2021_12 OWNER TO postgres;

--
-- TOC entry 337 (class 1259 OID 1512308)
-- Name: fsc_receipt_part_2021_01; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_01 (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_01 CHECK (((dt_create >= '2021-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-02-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_01 FOR VALUES FROM ('2021-01-01 00:00:00+03') TO ('2021-02-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_01 OWNER TO postgres;

--
-- TOC entry 338 (class 1259 OID 1512324)
-- Name: fsc_receipt_part_2021_02; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_02 (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_02 CHECK (((dt_create >= '2021-02-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-03-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_02 FOR VALUES FROM ('2021-02-01 00:00:00+03') TO ('2021-03-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_02 OWNER TO postgres;

--
-- TOC entry 339 (class 1259 OID 1512340)
-- Name: fsc_receipt_part_2021_03; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_03 (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_03 CHECK (((dt_create >= '2021-03-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-04-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_03 FOR VALUES FROM ('2021-03-01 00:00:00+03') TO ('2021-04-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_03 OWNER TO postgres;

--
-- TOC entry 340 (class 1259 OID 1512356)
-- Name: fsc_receipt_part_2021_04; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_04 (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_04 CHECK (((dt_create >= '2021-04-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-05-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_04 FOR VALUES FROM ('2021-04-01 00:00:00+03') TO ('2021-05-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_04 OWNER TO postgres;

--
-- TOC entry 341 (class 1259 OID 1512372)
-- Name: fsc_receipt_part_2021_05; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_05 (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_05 CHECK (((dt_create >= '2021-05-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-06-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_05 FOR VALUES FROM ('2021-05-01 00:00:00+03') TO ('2021-06-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_05 OWNER TO postgres;

--
-- TOC entry 342 (class 1259 OID 1512388)
-- Name: fsc_receipt_part_2021_06; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_06 (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_06 CHECK (((dt_create >= '2021-06-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-07-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_06 FOR VALUES FROM ('2021-06-01 00:00:00+03') TO ('2021-07-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_06 OWNER TO postgres;

--
-- TOC entry 343 (class 1259 OID 1512404)
-- Name: fsc_receipt_part_2021_07; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_07 (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_07 CHECK (((dt_create >= '2021-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-08-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_07 FOR VALUES FROM ('2021-07-01 00:00:00+03') TO ('2021-08-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_07 OWNER TO postgres;

--
-- TOC entry 344 (class 1259 OID 1512420)
-- Name: fsc_receipt_part_2021_08; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_08 (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_08 CHECK (((dt_create >= '2021-08-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-09-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_08 FOR VALUES FROM ('2021-08-01 00:00:00+03') TO ('2021-09-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_08 OWNER TO postgres;

--
-- TOC entry 345 (class 1259 OID 1512436)
-- Name: fsc_receipt_part_2021_09; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_09 (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_09 CHECK (((dt_create >= '2021-09-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-10-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_09 FOR VALUES FROM ('2021-09-01 00:00:00+03') TO ('2021-10-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_09 OWNER TO postgres;

--
-- TOC entry 346 (class 1259 OID 1512452)
-- Name: fsc_receipt_part_2021_10; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_10 (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_10 CHECK (((dt_create >= '2021-10-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-11-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_10 FOR VALUES FROM ('2021-10-01 00:00:00+03') TO ('2021-11-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_10 OWNER TO postgres;

--
-- TOC entry 347 (class 1259 OID 1512468)
-- Name: fsc_receipt_part_2021_11; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_11 (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_11 CHECK (((dt_create >= '2021-11-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-12-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_11 FOR VALUES FROM ('2021-11-01 00:00:00+03') TO ('2021-12-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_11 OWNER TO postgres;

--
-- TOC entry 348 (class 1259 OID 1512484)
-- Name: fsc_receipt_part_2021_12; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_12 (
    id_receipt bigint DEFAULT nextval('"_OLD_1_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_payment bigint,
    dt_payment timestamp with time zone,
    dt_update timestamp with time zone,
    inn character varying(20) NOT NULL,
    rcp_nmb text NOT NULL,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp with time zone,
    id_org integer NOT NULL,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_correction boolean NOT NULL,
    rcp_status integer NOT NULL,
    rcp_received boolean NOT NULL,
    rcp_notify_send boolean NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_12 CHECK (((dt_create >= '2021-12-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2022-01-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_12 FOR VALUES FROM ('2021-12-01 00:00:00+03') TO ('2022-01-01 00:00:00+03');


ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_part_2021_12 OWNER TO postgres;

--
-- TOC entry 365 (class 1259 OID 1607915)
-- Name: fsc_report_id_report_seq; Type: SEQUENCE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_1_fiscalization".fsc_report_id_report_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_1_fiscalization".fsc_report_id_report_seq OWNER TO postgres;

--
-- TOC entry 366 (class 1259 OID 1607917)
-- Name: fsc_report; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_report (
    id_report integer DEFAULT nextval('"_OLD_1_fiscalization".fsc_report_id_report_seq'::regclass) NOT NULL,
    id_user integer NOT NULL,
    rpt_mail text,
    dt_begin timestamp(0) without time zone,
    dt_end timestamp(0) without time zone,
    rcp_pmt_type integer NOT NULL,
    id_org integer NOT NULL,
    qty_rcp integer DEFAULT 0 NOT NULL,
    qty_rcp_c integer DEFAULT 0 NOT NULL,
    total_sum_rcp numeric(14,2) DEFAULT 0.0 NOT NULL,
    fscs_fullness numeric(5,2) DEFAULT 0.0 NOT NULL
);


ALTER TABLE "_OLD_1_fiscalization".fsc_report OWNER TO postgres;

--
-- TOC entry 8024 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN fsc_report.id_report; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_report.id_report IS 'ID Отчёта';


--
-- TOC entry 8025 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN fsc_report.id_user; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_report.id_user IS 'ID Пользователя';


--
-- TOC entry 8026 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN fsc_report.rpt_mail; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_report.rpt_mail IS 'e-mail';


--
-- TOC entry 8027 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN fsc_report.dt_begin; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_report.dt_begin IS 'Дата начала отчётного периода';


--
-- TOC entry 8028 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN fsc_report.dt_end; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_report.dt_end IS 'Дата окончания отчётного периода';


--
-- TOC entry 8029 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN fsc_report.rcp_pmt_type; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_report.rcp_pmt_type IS 'Тип способа расчёта';


--
-- TOC entry 8030 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN fsc_report.id_org; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_report.id_org IS 'ID организации';


--
-- TOC entry 8031 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN fsc_report.qty_rcp; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_report.qty_rcp IS 'Количество чеков за отчётный период';


--
-- TOC entry 8032 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN fsc_report.qty_rcp_c; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_report.qty_rcp_c IS 'Количество чеков коррекции за отчётный период';


--
-- TOC entry 8033 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN fsc_report.total_sum_rcp; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_report.total_sum_rcp IS 'Общая сумма чеков  за отчётный период';


--
-- TOC entry 8034 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN fsc_report.fscs_fullness; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_report.fscs_fullness IS 'Заполненность ФН %';


--
-- TOC entry 330 (class 1259 OID 1512118)
-- Name: fsc_service; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_service (
    id_service bigint NOT NULL,
    dt_create timestamp(0) without time zone NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    id_user integer,
    id_org integer,
    nm_service character varying(255),
    descr_service text,
    srv_type integer NOT NULL
);


ALTER TABLE "_OLD_1_fiscalization".fsc_service OWNER TO postgres;

--
-- TOC entry 8035 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE fsc_service; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_service IS 'Услуга';


--
-- TOC entry 8036 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN fsc_service.id_service; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_service.id_service IS 'ID Услуги';


--
-- TOC entry 8037 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN fsc_service.dt_create; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_service.dt_create IS 'Дата создания записи';


--
-- TOC entry 8038 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN fsc_service.dt_update; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_service.dt_update IS 'Дата обновления';


--
-- TOC entry 8039 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN fsc_service.dt_remove; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_service.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 8040 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN fsc_service.id_user; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_service.id_user IS 'ID Пользователя';


--
-- TOC entry 8041 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN fsc_service.id_org; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_service.id_org IS 'ID Организации';


--
-- TOC entry 8042 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN fsc_service.nm_service; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_service.nm_service IS 'Наименование услуги';


--
-- TOC entry 8043 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN fsc_service.descr_service; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_service.descr_service IS 'Описание услуги';


--
-- TOC entry 8044 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN fsc_service.srv_type; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_service.srv_type IS 'Тип услуги';


--
-- TOC entry 329 (class 1259 OID 1512116)
-- Name: fsc_service_id_srv_seq; Type: SEQUENCE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_1_fiscalization".fsc_service_id_srv_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_1_fiscalization".fsc_service_id_srv_seq OWNER TO postgres;

--
-- TOC entry 8045 (class 0 OID 0)
-- Dependencies: 329
-- Name: fsc_service_id_srv_seq; Type: SEQUENCE OWNED BY; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER SEQUENCE "_OLD_1_fiscalization".fsc_service_id_srv_seq OWNED BY "_OLD_1_fiscalization".fsc_service.id_service;


--
-- TOC entry 308 (class 1259 OID 1510305)
-- Name: fsc_storage; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_storage (
    id_fsc_storage integer NOT NULL,
    id_kkt integer,
    fscs_dt_create timestamp without time zone,
    rcp_qty integer,
    fscs_qty_max integer,
    fscs_nmb text,
    fscs_status boolean
);


ALTER TABLE "_OLD_1_fiscalization".fsc_storage OWNER TO postgres;

--
-- TOC entry 8046 (class 0 OID 0)
-- Dependencies: 308
-- Name: TABLE fsc_storage; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_storage IS 'Фискальный накопитель';


--
-- TOC entry 8047 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN fsc_storage.id_fsc_storage; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_storage.id_fsc_storage IS 'ID Фискального накопителя';


--
-- TOC entry 8048 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN fsc_storage.id_kkt; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_storage.id_kkt IS 'ID ККТ';


--
-- TOC entry 8049 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN fsc_storage.fscs_dt_create; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_storage.fscs_dt_create IS 'Дата выдачи';


--
-- TOC entry 8050 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN fsc_storage.rcp_qty; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_storage.rcp_qty IS 'Количество чеков';


--
-- TOC entry 8051 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN fsc_storage.fscs_qty_max; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_storage.fscs_qty_max IS 'Максимально чеков';


--
-- TOC entry 8052 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN fsc_storage.fscs_nmb; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_storage.fscs_nmb IS 'Номер';


--
-- TOC entry 8053 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN fsc_storage.fscs_status; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_storage.fscs_status IS 'Статус';


--
-- TOC entry 309 (class 1259 OID 1510311)
-- Name: fsc_task; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_task (
    id_task integer NOT NULL,
    id_user integer,
    dt_begin timestamp(0) without time zone,
    id_kkt integer,
    dt_end timestamp(0) without time zone,
    task_nmb text,
    task_status integer,
    task_type integer
);


ALTER TABLE "_OLD_1_fiscalization".fsc_task OWNER TO postgres;

--
-- TOC entry 8054 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE fsc_task; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_task IS 'Задача';


--
-- TOC entry 8055 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN fsc_task.id_task; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_task.id_task IS 'ID задачи';


--
-- TOC entry 8056 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN fsc_task.id_user; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_task.id_user IS 'ID пользователя';


--
-- TOC entry 8057 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN fsc_task.dt_begin; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_task.dt_begin IS 'Дата начала';


--
-- TOC entry 8058 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN fsc_task.id_kkt; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_task.id_kkt IS 'ID ККТ';


--
-- TOC entry 8059 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN fsc_task.dt_end; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_task.dt_end IS 'Дата окончания';


--
-- TOC entry 8060 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN fsc_task.task_nmb; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_task.task_nmb IS 'Номер задачи';


--
-- TOC entry 8061 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN fsc_task.task_status; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_task.task_status IS 'Статус задачи';


--
-- TOC entry 8062 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN fsc_task.task_type; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_task.task_type IS 'Тип задачи';


--
-- TOC entry 313 (class 1259 OID 1510565)
-- Name: fsc_user; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsc_user (
    id_user integer NOT NULL,
    dt_create timestamp(0) without time zone NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    id_org integer,
    is_adm boolean NOT NULL,
    sso_login text NOT NULL,
    usr_status boolean NOT NULL
);


ALTER TABLE "_OLD_1_fiscalization".fsc_user OWNER TO postgres;

--
-- TOC entry 8063 (class 0 OID 0)
-- Dependencies: 313
-- Name: TABLE fsc_user; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsc_user IS 'Пользователь/Абонент';


--
-- TOC entry 8064 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN fsc_user.id_user; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_user.id_user IS 'ID Пользователя';


--
-- TOC entry 8065 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN fsc_user.dt_create; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_user.dt_create IS 'Дата создания записи';


--
-- TOC entry 8066 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN fsc_user.dt_update; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_user.dt_update IS 'Дата обновления';


--
-- TOC entry 8067 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN fsc_user.dt_remove; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_user.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 8068 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN fsc_user.id_org; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_user.id_org IS 'ID Организации';


--
-- TOC entry 8069 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN fsc_user.is_adm; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_user.is_adm IS 'Администратор';


--
-- TOC entry 8070 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN fsc_user.sso_login; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_user.sso_login IS 'Логин';


--
-- TOC entry 8071 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN fsc_user.usr_status; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsc_user.usr_status IS 'Статус пользователя';


--
-- TOC entry 310 (class 1259 OID 1510323)
-- Name: fsk_route; Type: TABLE; Schema: _OLD_1_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_1_fiscalization".fsk_route (
    id_fsc_route integer NOT NULL,
    id_fsc_provider integer,
    id_org integer,
    dt_create timestamp(0) without time zone,
    route_status boolean
);


ALTER TABLE "_OLD_1_fiscalization".fsk_route OWNER TO postgres;

--
-- TOC entry 8072 (class 0 OID 0)
-- Dependencies: 310
-- Name: TABLE fsk_route; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_1_fiscalization".fsk_route IS 'Маршрут';


--
-- TOC entry 8073 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN fsk_route.id_fsc_route; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsk_route.id_fsc_route IS 'ID Маршрута';


--
-- TOC entry 8074 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN fsk_route.id_fsc_provider; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsk_route.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 8075 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN fsk_route.id_org; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsk_route.id_org IS 'ID Организации';


--
-- TOC entry 8076 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN fsk_route.dt_create; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsk_route.dt_create IS 'Дата создания';


--
-- TOC entry 8077 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN fsk_route.route_status; Type: COMMENT; Schema: _OLD_1_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_1_fiscalization".fsk_route.route_status IS 'Статус';


--
-- TOC entry 369 (class 1259 OID 1611431)
-- Name: fsc_app; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_app (
    id_app integer NOT NULL,
    dt_create timestamp(0) without time zone NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    app_guid uuid,
    secret_key text NOT NULL,
    nm_app text NOT NULL,
    notification_url text,
    provaider_key text
);


ALTER TABLE "_OLD_4_fiscalization".fsc_app OWNER TO postgres;

--
-- TOC entry 8078 (class 0 OID 0)
-- Dependencies: 369
-- Name: TABLE fsc_app; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_app IS 'Приложение';


--
-- TOC entry 8079 (class 0 OID 0)
-- Dependencies: 369
-- Name: COLUMN fsc_app.id_app; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app.id_app IS 'ID приложения';


--
-- TOC entry 8080 (class 0 OID 0)
-- Dependencies: 369
-- Name: COLUMN fsc_app.dt_create; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app.dt_create IS 'Дата создания записи';


--
-- TOC entry 8081 (class 0 OID 0)
-- Dependencies: 369
-- Name: COLUMN fsc_app.dt_update; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app.dt_update IS 'Дата обновления';


--
-- TOC entry 8082 (class 0 OID 0)
-- Dependencies: 369
-- Name: COLUMN fsc_app.dt_remove; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 8083 (class 0 OID 0)
-- Dependencies: 369
-- Name: COLUMN fsc_app.app_guid; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app.app_guid IS 'UUID приложения';


--
-- TOC entry 8084 (class 0 OID 0)
-- Dependencies: 369
-- Name: COLUMN fsc_app.secret_key; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app.secret_key IS 'Секретный ключ';


--
-- TOC entry 8085 (class 0 OID 0)
-- Dependencies: 369
-- Name: COLUMN fsc_app.nm_app; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app.nm_app IS 'Название приложеия';


--
-- TOC entry 8086 (class 0 OID 0)
-- Dependencies: 369
-- Name: COLUMN fsc_app.notification_url; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app.notification_url IS 'URL для уведомлений';


--
-- TOC entry 8087 (class 0 OID 0)
-- Dependencies: 369
-- Name: COLUMN fsc_app.provaider_key; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app.provaider_key IS 'Ключ провайдера';


--
-- TOC entry 423 (class 1259 OID 1614892)
-- Name: fsc_app_fsc_provider_id_seq; Type: SEQUENCE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_4_fiscalization".fsc_app_fsc_provider_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_4_fiscalization".fsc_app_fsc_provider_id_seq OWNER TO postgres;

--
-- TOC entry 370 (class 1259 OID 1611439)
-- Name: fsc_app_fsc_provider; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_app_fsc_provider (
    id_app_fsk_provider integer DEFAULT nextval('"_OLD_4_fiscalization".fsc_app_fsc_provider_id_seq'::regclass) NOT NULL,
    id_app integer NOT NULL,
    id_fsc_provider integer NOT NULL,
    dt_create timestamp(0) without time zone,
    app_fsc_provider_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_4_fiscalization".fsc_app_fsc_provider OWNER TO postgres;

--
-- TOC entry 8088 (class 0 OID 0)
-- Dependencies: 370
-- Name: TABLE fsc_app_fsc_provider; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_app_fsc_provider IS 'Приложения для фискального провайдера';


--
-- TOC entry 8089 (class 0 OID 0)
-- Dependencies: 370
-- Name: COLUMN fsc_app_fsc_provider.id_app_fsk_provider; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app_fsc_provider.id_app_fsk_provider IS 'ID Приложения для фискального провайдера';


--
-- TOC entry 8090 (class 0 OID 0)
-- Dependencies: 370
-- Name: COLUMN fsc_app_fsc_provider.id_app; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app_fsc_provider.id_app IS 'ID приложение';


--
-- TOC entry 8091 (class 0 OID 0)
-- Dependencies: 370
-- Name: COLUMN fsc_app_fsc_provider.id_fsc_provider; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app_fsc_provider.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 8092 (class 0 OID 0)
-- Dependencies: 370
-- Name: COLUMN fsc_app_fsc_provider.dt_create; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app_fsc_provider.dt_create IS 'Дата создания';


--
-- TOC entry 8093 (class 0 OID 0)
-- Dependencies: 370
-- Name: COLUMN fsc_app_fsc_provider.app_fsc_provider_status; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_app_fsc_provider.app_fsc_provider_status IS 'Статус';


--
-- TOC entry 371 (class 1259 OID 1611447)
-- Name: fsc_filter; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_filter (
    id_filter integer NOT NULL,
    id_task integer NOT NULL,
    fsc_query json,
    nm_filter_name character varying(255),
    filter_type integer
);


ALTER TABLE "_OLD_4_fiscalization".fsc_filter OWNER TO postgres;

--
-- TOC entry 8094 (class 0 OID 0)
-- Dependencies: 371
-- Name: TABLE fsc_filter; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_filter IS 'Фильтр';


--
-- TOC entry 8095 (class 0 OID 0)
-- Dependencies: 371
-- Name: COLUMN fsc_filter.id_filter; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_filter.id_filter IS 'ID Фильтра';


--
-- TOC entry 8096 (class 0 OID 0)
-- Dependencies: 371
-- Name: COLUMN fsc_filter.id_task; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_filter.id_task IS 'ID задачи';


--
-- TOC entry 8097 (class 0 OID 0)
-- Dependencies: 371
-- Name: COLUMN fsc_filter.fsc_query; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_filter.fsc_query IS 'Запрос';


--
-- TOC entry 8098 (class 0 OID 0)
-- Dependencies: 371
-- Name: COLUMN fsc_filter.nm_filter_name; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_filter.nm_filter_name IS 'Наименование фильтра';


--
-- TOC entry 8099 (class 0 OID 0)
-- Dependencies: 371
-- Name: COLUMN fsc_filter.filter_type; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_filter.filter_type IS 'Тип фильтра';


--
-- TOC entry 425 (class 1259 OID 1614898)
-- Name: fsc_kkt_id_seq; Type: SEQUENCE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_4_fiscalization".fsc_kkt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_4_fiscalization".fsc_kkt_id_seq OWNER TO postgres;

--
-- TOC entry 372 (class 1259 OID 1611455)
-- Name: fsc_kkt; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_kkt (
    id_kkt integer DEFAULT nextval('"_OLD_4_fiscalization".fsc_kkt_id_seq'::regclass) NOT NULL,
    id_kkt_group integer NOT NULL,
    kkt_dt_create timestamp(0) without time zone,
    rcp_qty integer,
    kkt_nmb text,
    kkt_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_4_fiscalization".fsc_kkt OWNER TO postgres;

--
-- TOC entry 8100 (class 0 OID 0)
-- Dependencies: 372
-- Name: TABLE fsc_kkt; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_kkt IS 'ККТ';


--
-- TOC entry 8101 (class 0 OID 0)
-- Dependencies: 372
-- Name: COLUMN fsc_kkt.id_kkt; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_kkt.id_kkt IS 'ID ККТ';


--
-- TOC entry 8102 (class 0 OID 0)
-- Dependencies: 372
-- Name: COLUMN fsc_kkt.id_kkt_group; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_kkt.id_kkt_group IS 'ID группы ККТ';


--
-- TOC entry 8103 (class 0 OID 0)
-- Dependencies: 372
-- Name: COLUMN fsc_kkt.kkt_dt_create; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_kkt.kkt_dt_create IS 'Дата выдачи';


--
-- TOC entry 8104 (class 0 OID 0)
-- Dependencies: 372
-- Name: COLUMN fsc_kkt.rcp_qty; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_kkt.rcp_qty IS 'Количество чеков';


--
-- TOC entry 8105 (class 0 OID 0)
-- Dependencies: 372
-- Name: COLUMN fsc_kkt.kkt_nmb; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_kkt.kkt_nmb IS 'Номер ККТ';


--
-- TOC entry 8106 (class 0 OID 0)
-- Dependencies: 372
-- Name: COLUMN fsc_kkt.kkt_status; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_kkt.kkt_status IS 'Статус';


--
-- TOC entry 424 (class 1259 OID 1614895)
-- Name: fsc_kkt_group_id_seq; Type: SEQUENCE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_4_fiscalization".fsc_kkt_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_4_fiscalization".fsc_kkt_group_id_seq OWNER TO postgres;

--
-- TOC entry 373 (class 1259 OID 1611464)
-- Name: fsc_kkt_group; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_kkt_group (
    id_kkt_group integer DEFAULT nextval('"_OLD_4_fiscalization".fsc_kkt_group_id_seq'::regclass) NOT NULL,
    kkt_qty integer,
    nm_kkt_group text,
    id_fsc_provider integer,
    kkt_grp_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_4_fiscalization".fsc_kkt_group OWNER TO postgres;

--
-- TOC entry 8107 (class 0 OID 0)
-- Dependencies: 373
-- Name: TABLE fsc_kkt_group; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_kkt_group IS 'Группа ККТ';


--
-- TOC entry 8108 (class 0 OID 0)
-- Dependencies: 373
-- Name: COLUMN fsc_kkt_group.id_kkt_group; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_kkt_group.id_kkt_group IS 'ID группы ККТ';


--
-- TOC entry 8109 (class 0 OID 0)
-- Dependencies: 373
-- Name: COLUMN fsc_kkt_group.kkt_qty; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_kkt_group.kkt_qty IS 'Количество касс';


--
-- TOC entry 8110 (class 0 OID 0)
-- Dependencies: 373
-- Name: COLUMN fsc_kkt_group.nm_kkt_group; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_kkt_group.nm_kkt_group IS 'Название группы ККТ';


--
-- TOC entry 8111 (class 0 OID 0)
-- Dependencies: 373
-- Name: COLUMN fsc_kkt_group.id_fsc_provider; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_kkt_group.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 8112 (class 0 OID 0)
-- Dependencies: 373
-- Name: COLUMN fsc_kkt_group.kkt_grp_status; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_kkt_group.kkt_grp_status IS 'Статус';


--
-- TOC entry 374 (class 1259 OID 1611473)
-- Name: fsc_order; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL
)
PARTITION BY RANGE (dt_create);


ALTER TABLE "_OLD_4_fiscalization".fsc_order OWNER TO postgres;

--
-- TOC entry 8113 (class 0 OID 0)
-- Dependencies: 374
-- Name: TABLE fsc_order; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_order IS 'Чек, json структуры';


--
-- TOC entry 8114 (class 0 OID 0)
-- Dependencies: 374
-- Name: COLUMN fsc_order.id_receipt; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_order.id_receipt IS 'ID Чека';


--
-- TOC entry 8115 (class 0 OID 0)
-- Dependencies: 374
-- Name: COLUMN fsc_order.dt_create; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_order.dt_create IS 'Дата создания';


--
-- TOC entry 8116 (class 0 OID 0)
-- Dependencies: 374
-- Name: COLUMN fsc_order.rcp_order; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_order.rcp_order IS 'Запрос на фискализацию';


--
-- TOC entry 387 (class 1259 OID 1611586)
-- Name: fsc_order_default; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order_default (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_default DEFAULT;


ALTER TABLE "_OLD_4_fiscalization".fsc_order_default OWNER TO postgres;

--
-- TOC entry 375 (class 1259 OID 1611478)
-- Name: fsc_order_part_2021_01; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order_part_2021_01 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_01 CHECK (((dt_create >= '2021-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-02-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_01 FOR VALUES FROM ('2021-01-01 00:00:00+03') TO ('2021-02-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_order_part_2021_01 OWNER TO postgres;

--
-- TOC entry 376 (class 1259 OID 1611487)
-- Name: fsc_order_part_2021_02; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order_part_2021_02 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_02 CHECK (((dt_create >= '2021-02-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-03-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_02 FOR VALUES FROM ('2021-02-01 00:00:00+03') TO ('2021-03-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_order_part_2021_02 OWNER TO postgres;

--
-- TOC entry 377 (class 1259 OID 1611496)
-- Name: fsc_order_part_2021_03; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order_part_2021_03 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_03 CHECK (((dt_create >= '2021-03-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-04-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_03 FOR VALUES FROM ('2021-03-01 00:00:00+03') TO ('2021-04-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_order_part_2021_03 OWNER TO postgres;

--
-- TOC entry 378 (class 1259 OID 1611505)
-- Name: fsc_order_part_2021_04; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order_part_2021_04 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_04 CHECK (((dt_create >= '2021-04-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-05-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_04 FOR VALUES FROM ('2021-04-01 00:00:00+03') TO ('2021-05-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_order_part_2021_04 OWNER TO postgres;

--
-- TOC entry 379 (class 1259 OID 1611514)
-- Name: fsc_order_part_2021_05; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order_part_2021_05 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_05 CHECK (((dt_create >= '2021-05-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-06-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_05 FOR VALUES FROM ('2021-05-01 00:00:00+03') TO ('2021-06-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_order_part_2021_05 OWNER TO postgres;

--
-- TOC entry 380 (class 1259 OID 1611523)
-- Name: fsc_order_part_2021_06; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order_part_2021_06 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_06 CHECK (((dt_create >= '2021-06-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-07-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_06 FOR VALUES FROM ('2021-06-01 00:00:00+03') TO ('2021-07-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_order_part_2021_06 OWNER TO postgres;

--
-- TOC entry 381 (class 1259 OID 1611532)
-- Name: fsc_order_part_2021_07; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order_part_2021_07 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_07 CHECK (((dt_create >= '2021-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-08-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_07 FOR VALUES FROM ('2021-07-01 00:00:00+03') TO ('2021-08-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_order_part_2021_07 OWNER TO postgres;

--
-- TOC entry 382 (class 1259 OID 1611541)
-- Name: fsc_order_part_2021_08; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order_part_2021_08 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_08 CHECK (((dt_create >= '2021-08-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-09-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_08 FOR VALUES FROM ('2021-08-01 00:00:00+03') TO ('2021-09-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_order_part_2021_08 OWNER TO postgres;

--
-- TOC entry 383 (class 1259 OID 1611550)
-- Name: fsc_order_part_2021_09; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order_part_2021_09 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_09 CHECK (((dt_create >= '2021-09-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-10-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_09 FOR VALUES FROM ('2021-09-01 00:00:00+03') TO ('2021-10-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_order_part_2021_09 OWNER TO postgres;

--
-- TOC entry 384 (class 1259 OID 1611559)
-- Name: fsc_order_part_2021_10; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order_part_2021_10 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_10 CHECK (((dt_create >= '2021-10-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-11-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_10 FOR VALUES FROM ('2021-10-01 00:00:00+03') TO ('2021-11-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_order_part_2021_10 OWNER TO postgres;

--
-- TOC entry 385 (class 1259 OID 1611568)
-- Name: fsc_order_part_2021_11; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order_part_2021_11 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_11 CHECK (((dt_create >= '2021-11-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-12-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_11 FOR VALUES FROM ('2021-11-01 00:00:00+03') TO ('2021-12-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_order_part_2021_11 OWNER TO postgres;

--
-- TOC entry 386 (class 1259 OID 1611577)
-- Name: fsc_order_part_2021_12; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_order_part_2021_12 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_order jsonb NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_12 CHECK (((dt_create >= '2021-12-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2022-01-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_12 FOR VALUES FROM ('2021-12-01 00:00:00+03') TO ('2022-01-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_order_part_2021_12 OWNER TO postgres;

--
-- TOC entry 388 (class 1259 OID 1611594)
-- Name: fsc_org; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_org (
    id_org integer NOT NULL,
    dt_create timestamp(0) without time zone NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    nm_group_kkt character varying(32),
    inn character varying(20) NOT NULL,
    kkt_qty integer NOT NULL,
    nm_org_name character varying(255) NOT NULL,
    default_parameters json,
    org_type integer,
    org_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_4_fiscalization".fsc_org OWNER TO postgres;

--
-- TOC entry 8117 (class 0 OID 0)
-- Dependencies: 388
-- Name: TABLE fsc_org; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_org IS 'Организация';


--
-- TOC entry 8118 (class 0 OID 0)
-- Dependencies: 388
-- Name: COLUMN fsc_org.id_org; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org.id_org IS 'ID организации';


--
-- TOC entry 8119 (class 0 OID 0)
-- Dependencies: 388
-- Name: COLUMN fsc_org.dt_create; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org.dt_create IS 'Дата создания записи';


--
-- TOC entry 8120 (class 0 OID 0)
-- Dependencies: 388
-- Name: COLUMN fsc_org.dt_update; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org.dt_update IS 'Дата обновления';


--
-- TOC entry 8121 (class 0 OID 0)
-- Dependencies: 388
-- Name: COLUMN fsc_org.dt_remove; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 8122 (class 0 OID 0)
-- Dependencies: 388
-- Name: COLUMN fsc_org.nm_group_kkt; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org.nm_group_kkt IS 'Группа касс';


--
-- TOC entry 8123 (class 0 OID 0)
-- Dependencies: 388
-- Name: COLUMN fsc_org.inn; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org.inn IS 'ИНН';


--
-- TOC entry 8124 (class 0 OID 0)
-- Dependencies: 388
-- Name: COLUMN fsc_org.kkt_qty; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org.kkt_qty IS 'Количество касс';


--
-- TOC entry 8125 (class 0 OID 0)
-- Dependencies: 388
-- Name: COLUMN fsc_org.nm_org_name; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org.nm_org_name IS 'Наименование организации';


--
-- TOC entry 8126 (class 0 OID 0)
-- Dependencies: 388
-- Name: COLUMN fsc_org.default_parameters; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org.default_parameters IS 'Параметры по умолчанию';


--
-- TOC entry 8127 (class 0 OID 0)
-- Dependencies: 388
-- Name: COLUMN fsc_org.org_type; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org.org_type IS 'Тип организации';


--
-- TOC entry 8128 (class 0 OID 0)
-- Dependencies: 388
-- Name: COLUMN fsc_org.org_status; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org.org_status IS 'Статус организации';


--
-- TOC entry 389 (class 1259 OID 1611603)
-- Name: fsc_org_app; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_org_app (
    id_org_app integer NOT NULL,
    id_app integer NOT NULL,
    id_org integer NOT NULL,
    dt_create timestamp(0) without time zone,
    org_app_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_4_fiscalization".fsc_org_app OWNER TO postgres;

--
-- TOC entry 8129 (class 0 OID 0)
-- Dependencies: 389
-- Name: TABLE fsc_org_app; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_org_app IS 'Приложения организации';


--
-- TOC entry 8130 (class 0 OID 0)
-- Dependencies: 389
-- Name: COLUMN fsc_org_app.id_org_app; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org_app.id_org_app IS 'ID приложения организации';


--
-- TOC entry 8131 (class 0 OID 0)
-- Dependencies: 389
-- Name: COLUMN fsc_org_app.id_app; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org_app.id_app IS 'ID приложение';


--
-- TOC entry 8132 (class 0 OID 0)
-- Dependencies: 389
-- Name: COLUMN fsc_org_app.id_org; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org_app.id_org IS 'ID Организации';


--
-- TOC entry 8133 (class 0 OID 0)
-- Dependencies: 389
-- Name: COLUMN fsc_org_app.dt_create; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org_app.dt_create IS 'Дата создания';


--
-- TOC entry 8134 (class 0 OID 0)
-- Dependencies: 389
-- Name: COLUMN fsc_org_app.org_app_status; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_org_app.org_app_status IS 'Статус';


--
-- TOC entry 390 (class 1259 OID 1611611)
-- Name: fsc_provider; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_provider (
    id_fsc_provider integer NOT NULL,
    nm_fsc_provider character varying(255),
    fsc_url text,
    fsc_port character varying(5),
    fsc_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_4_fiscalization".fsc_provider OWNER TO postgres;

--
-- TOC entry 8135 (class 0 OID 0)
-- Dependencies: 390
-- Name: TABLE fsc_provider; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_provider IS 'Фискальный провайдер';


--
-- TOC entry 8136 (class 0 OID 0)
-- Dependencies: 390
-- Name: COLUMN fsc_provider.id_fsc_provider; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_provider.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 8137 (class 0 OID 0)
-- Dependencies: 390
-- Name: COLUMN fsc_provider.nm_fsc_provider; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_provider.nm_fsc_provider IS 'Наименование';


--
-- TOC entry 8138 (class 0 OID 0)
-- Dependencies: 390
-- Name: COLUMN fsc_provider.fsc_url; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_provider.fsc_url IS 'URL фискального провайдера';


--
-- TOC entry 8139 (class 0 OID 0)
-- Dependencies: 390
-- Name: COLUMN fsc_provider.fsc_port; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_provider.fsc_port IS 'Порт';


--
-- TOC entry 8140 (class 0 OID 0)
-- Dependencies: 390
-- Name: COLUMN fsc_provider.fsc_status; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_provider.fsc_status IS 'Статус';


--
-- TOC entry 367 (class 1259 OID 1607938)
-- Name: fsc_receipt_id_receipt_seq; Type: SEQUENCE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_4_fiscalization".fsc_receipt_id_receipt_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_id_receipt_seq OWNER TO postgres;

--
-- TOC entry 391 (class 1259 OID 1611620)
-- Name: fsc_receipt; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL
)
PARTITION BY RANGE (dt_create);


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt OWNER TO postgres;

--
-- TOC entry 8141 (class 0 OID 0)
-- Dependencies: 391
-- Name: TABLE fsc_receipt; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_receipt IS 'Чек';


--
-- TOC entry 8142 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.id_receipt; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.id_receipt IS 'ID Чека';


--
-- TOC entry 8143 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.dt_create; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.dt_create IS 'Дата создания';


--
-- TOC entry 8144 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.dt_update; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.dt_update IS 'Дата обновления';


--
-- TOC entry 8145 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.inn; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.inn IS 'ИНН';


--
-- TOC entry 8146 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.rcp_nmb; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.rcp_nmb IS 'Номер чека';


--
-- TOC entry 8147 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.rcp_contact; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.rcp_contact IS 'Контактная информация';


--
-- TOC entry 8148 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.rcp_fp; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.rcp_fp IS 'Номер ФН';


--
-- TOC entry 8149 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.dt_fp; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.dt_fp IS 'Дата фискализапции';


--
-- TOC entry 8150 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.id_org; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.id_org IS 'Организация';


--
-- TOC entry 8151 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.id_kkt; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.id_kkt IS 'ID ККТ';


--
-- TOC entry 8152 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.rcp_status_descr; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.rcp_status_descr IS 'Описание статуса';


--
-- TOC entry 8153 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.rcp_amount; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.rcp_amount IS 'Сумма';


--
-- TOC entry 8154 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.rcp_correction; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.rcp_correction IS 'Тип (чек корреции/кассовый чек)';


--
-- TOC entry 8155 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.rcp_status; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.rcp_status IS 'Статус чека';


--
-- TOC entry 8156 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.rcp_received; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.rcp_received IS 'Чек принят';


--
-- TOC entry 8157 (class 0 OID 0)
-- Dependencies: 391
-- Name: COLUMN fsc_receipt.rcp_notify_send; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt.rcp_notify_send IS 'Извещение отослано';


--
-- TOC entry 404 (class 1259 OID 1611798)
-- Name: fsc_receipt_default; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_default (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_default DEFAULT;


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_default OWNER TO postgres;

--
-- TOC entry 392 (class 1259 OID 1611630)
-- Name: fsc_receipt_part_2021_01; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_01 (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_01 CHECK (((dt_create >= '2021-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-02-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_01 FOR VALUES FROM ('2021-01-01 00:00:00+03') TO ('2021-02-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_01 OWNER TO postgres;

--
-- TOC entry 393 (class 1259 OID 1611644)
-- Name: fsc_receipt_part_2021_02; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_02 (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_02 CHECK (((dt_create >= '2021-02-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-03-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_02 FOR VALUES FROM ('2021-02-01 00:00:00+03') TO ('2021-03-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_02 OWNER TO postgres;

--
-- TOC entry 394 (class 1259 OID 1611658)
-- Name: fsc_receipt_part_2021_03; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_03 (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_03 CHECK (((dt_create >= '2021-03-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-04-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_03 FOR VALUES FROM ('2021-03-01 00:00:00+03') TO ('2021-04-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_03 OWNER TO postgres;

--
-- TOC entry 395 (class 1259 OID 1611672)
-- Name: fsc_receipt_part_2021_04; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_04 (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_04 CHECK (((dt_create >= '2021-04-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-05-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_04 FOR VALUES FROM ('2021-04-01 00:00:00+03') TO ('2021-05-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_04 OWNER TO postgres;

--
-- TOC entry 396 (class 1259 OID 1611686)
-- Name: fsc_receipt_part_2021_05; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_05 (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_05 CHECK (((dt_create >= '2021-05-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-06-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_05 FOR VALUES FROM ('2021-05-01 00:00:00+03') TO ('2021-06-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_05 OWNER TO postgres;

--
-- TOC entry 397 (class 1259 OID 1611700)
-- Name: fsc_receipt_part_2021_06; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_06 (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_06 CHECK (((dt_create >= '2021-06-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-07-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_06 FOR VALUES FROM ('2021-06-01 00:00:00+03') TO ('2021-07-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_06 OWNER TO postgres;

--
-- TOC entry 398 (class 1259 OID 1611714)
-- Name: fsc_receipt_part_2021_07; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_07 (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_07 CHECK (((dt_create >= '2021-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-08-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_07 FOR VALUES FROM ('2021-07-01 00:00:00+03') TO ('2021-08-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_07 OWNER TO postgres;

--
-- TOC entry 399 (class 1259 OID 1611728)
-- Name: fsc_receipt_part_2021_08; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_08 (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_08 CHECK (((dt_create >= '2021-08-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-09-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_08 FOR VALUES FROM ('2021-08-01 00:00:00+03') TO ('2021-09-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_08 OWNER TO postgres;

--
-- TOC entry 400 (class 1259 OID 1611742)
-- Name: fsc_receipt_part_2021_09; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_09 (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_09 CHECK (((dt_create >= '2021-09-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-10-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_09 FOR VALUES FROM ('2021-09-01 00:00:00+03') TO ('2021-10-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_09 OWNER TO postgres;

--
-- TOC entry 401 (class 1259 OID 1611756)
-- Name: fsc_receipt_part_2021_10; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_10 (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_10 CHECK (((dt_create >= '2021-10-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-11-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_10 FOR VALUES FROM ('2021-10-01 00:00:00+03') TO ('2021-11-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_10 OWNER TO postgres;

--
-- TOC entry 402 (class 1259 OID 1611770)
-- Name: fsc_receipt_part_2021_11; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_11 (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_11 CHECK (((dt_create >= '2021-11-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-12-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_11 FOR VALUES FROM ('2021-11-01 00:00:00+03') TO ('2021-12-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_11 OWNER TO postgres;

--
-- TOC entry 403 (class 1259 OID 1611784)
-- Name: fsc_receipt_part_2021_12; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_12 (
    id_receipt bigint DEFAULT nextval('"_OLD_4_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_kkt integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_12 CHECK (((dt_create >= '2021-12-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2022-01-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_12 FOR VALUES FROM ('2021-12-01 00:00:00+03') TO ('2022-01-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_part_2021_12 OWNER TO postgres;

--
-- TOC entry 405 (class 1259 OID 1611811)
-- Name: fsc_receipt_result; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb
)
PARTITION BY RANGE (dt_create);


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result OWNER TO postgres;

--
-- TOC entry 8158 (class 0 OID 0)
-- Dependencies: 405
-- Name: TABLE fsc_receipt_result; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_receipt_result IS 'Чек, результат фискализации';


--
-- TOC entry 8159 (class 0 OID 0)
-- Dependencies: 405
-- Name: COLUMN fsc_receipt_result.id_receipt; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt_result.id_receipt IS 'ID Чека';


--
-- TOC entry 8160 (class 0 OID 0)
-- Dependencies: 405
-- Name: COLUMN fsc_receipt_result.dt_create; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt_result.dt_create IS 'Дата создания';


--
-- TOC entry 8161 (class 0 OID 0)
-- Dependencies: 405
-- Name: COLUMN fsc_receipt_result.rcp_receipt; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_receipt_result.rcp_receipt IS 'Фискализированный чек';


--
-- TOC entry 418 (class 1259 OID 1611924)
-- Name: fsc_receipt_result_default; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result_default (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_default DEFAULT;


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result_default OWNER TO postgres;

--
-- TOC entry 406 (class 1259 OID 1611816)
-- Name: fsc_receipt_result_part_2021_01; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_01 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_result_dt_create_2021_01 CHECK (((dt_create >= '2021-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-02-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_01 FOR VALUES FROM ('2021-01-01 00:00:00+03') TO ('2021-02-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_01 OWNER TO postgres;

--
-- TOC entry 407 (class 1259 OID 1611825)
-- Name: fsc_receipt_result_part_2021_02; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_02 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_result_dt_create_2021_02 CHECK (((dt_create >= '2021-02-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-03-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_02 FOR VALUES FROM ('2021-02-01 00:00:00+03') TO ('2021-03-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_02 OWNER TO postgres;

--
-- TOC entry 408 (class 1259 OID 1611834)
-- Name: fsc_receipt_result_part_2021_03; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_03 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_result_dt_create_2021_03 CHECK (((dt_create >= '2021-03-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-04-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_03 FOR VALUES FROM ('2021-03-01 00:00:00+03') TO ('2021-04-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_03 OWNER TO postgres;

--
-- TOC entry 409 (class 1259 OID 1611843)
-- Name: fsc_receipt_result_part_2021_04; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_04 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_result_dt_create_2021_04 CHECK (((dt_create >= '2021-04-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-05-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_04 FOR VALUES FROM ('2021-04-01 00:00:00+03') TO ('2021-05-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_04 OWNER TO postgres;

--
-- TOC entry 410 (class 1259 OID 1611852)
-- Name: fsc_receipt_result_part_2021_05; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_05 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_result_dt_create_2021_05 CHECK (((dt_create >= '2021-05-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-06-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_05 FOR VALUES FROM ('2021-05-01 00:00:00+03') TO ('2021-06-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_05 OWNER TO postgres;

--
-- TOC entry 411 (class 1259 OID 1611861)
-- Name: fsc_receipt_result_part_2021_06; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_06 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_result_dt_create_2021_06 CHECK (((dt_create >= '2021-06-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-07-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_06 FOR VALUES FROM ('2021-06-01 00:00:00+03') TO ('2021-07-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_06 OWNER TO postgres;

--
-- TOC entry 412 (class 1259 OID 1611870)
-- Name: fsc_receipt_result_part_2021_07; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_07 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_result_dt_create_2021_07 CHECK (((dt_create >= '2021-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-08-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_07 FOR VALUES FROM ('2021-07-01 00:00:00+03') TO ('2021-08-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_07 OWNER TO postgres;

--
-- TOC entry 413 (class 1259 OID 1611879)
-- Name: fsc_receipt_result_part_2021_08; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_08 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_result_dt_create_2021_08 CHECK (((dt_create >= '2021-08-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-09-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_08 FOR VALUES FROM ('2021-08-01 00:00:00+03') TO ('2021-09-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_08 OWNER TO postgres;

--
-- TOC entry 414 (class 1259 OID 1611888)
-- Name: fsc_receipt_result_part_2021_09; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_09 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_result_dt_create_2021_09 CHECK (((dt_create >= '2021-09-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-10-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_09 FOR VALUES FROM ('2021-09-01 00:00:00+03') TO ('2021-10-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_09 OWNER TO postgres;

--
-- TOC entry 415 (class 1259 OID 1611897)
-- Name: fsc_receipt_result_part_2021_10; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_10 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_result_dt_create_2021_10 CHECK (((dt_create >= '2021-10-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-11-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_10 FOR VALUES FROM ('2021-10-01 00:00:00+03') TO ('2021-11-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_10 OWNER TO postgres;

--
-- TOC entry 416 (class 1259 OID 1611906)
-- Name: fsc_receipt_result_part_2021_11; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_11 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_result_dt_create_2021_11 CHECK (((dt_create >= '2021-11-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-12-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_11 FOR VALUES FROM ('2021-11-01 00:00:00+03') TO ('2021-12-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_11 OWNER TO postgres;

--
-- TOC entry 417 (class 1259 OID 1611915)
-- Name: fsc_receipt_result_part_2021_12; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_12 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    CONSTRAINT chk_result_dt_create_2021_12 CHECK (((dt_create >= '2021-12-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2022-01-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_12 FOR VALUES FROM ('2021-12-01 00:00:00+03') TO ('2022-01-01 00:00:00+03');


ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result_part_2021_12 OWNER TO postgres;

--
-- TOC entry 368 (class 1259 OID 1607940)
-- Name: fsc_report_id_report_seq; Type: SEQUENCE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_4_fiscalization".fsc_report_id_report_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_4_fiscalization".fsc_report_id_report_seq OWNER TO postgres;

--
-- TOC entry 422 (class 1259 OID 1614880)
-- Name: fsc_report; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_report (
    id_report integer DEFAULT nextval('"_OLD_4_fiscalization".fsc_report_id_report_seq'::regclass) NOT NULL,
    id_user integer NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    dt_begin timestamp(0) without time zone,
    dt_end timestamp(0) without time zone,
    dt_fp timestamp(0) without time zone,
    rpt_mail text,
    rcp_pmt_type integer,
    qty_rcp integer,
    qty_rcp_c integer,
    total_sum_rcp numeric(14,2),
    fscs_fullness numeric(5,2),
    rpt_guid uuid,
    rpt_parameters jsonb NOT NULL,
    id_org integer,
    id_app integer,
    id_fsc_provider integer,
    id_kkt_group integer,
    id_kkt integer,
    id_fsc_storage integer,
    id_receipt bigint
);


ALTER TABLE "_OLD_4_fiscalization".fsc_report OWNER TO postgres;

--
-- TOC entry 8162 (class 0 OID 0)
-- Dependencies: 422
-- Name: TABLE fsc_report; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_report IS 'Отчёт';


--
-- TOC entry 8163 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.id_report; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.id_report IS 'ID Отчёта';


--
-- TOC entry 8164 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.id_user; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.id_user IS 'ID Пользователя';


--
-- TOC entry 8165 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.dt_create; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.dt_create IS 'Дата создания отчёта';


--
-- TOC entry 8166 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.dt_update; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.dt_update IS 'Дата обновления отчёта';


--
-- TOC entry 8167 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.dt_remove; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.dt_remove IS 'Дата логического удаления отчёта';


--
-- TOC entry 8168 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.dt_begin; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.dt_begin IS 'Дата начала выполнения';


--
-- TOC entry 8169 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.dt_end; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.dt_end IS 'Дата завершения выполнения';


--
-- TOC entry 8170 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.dt_fp; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.dt_fp IS 'Дата фискализации';


--
-- TOC entry 8171 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.rpt_mail; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.rpt_mail IS 'e-mail';


--
-- TOC entry 8172 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.rcp_pmt_type; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.rcp_pmt_type IS 'Тип способа расчёта';


--
-- TOC entry 8173 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.qty_rcp; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.qty_rcp IS 'Количество чеков за отчётный период';


--
-- TOC entry 8174 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.qty_rcp_c; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.qty_rcp_c IS 'Количество чеков коррекции за отчётный период';


--
-- TOC entry 8175 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.total_sum_rcp; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.total_sum_rcp IS 'Общая сумма чеков  за отчётный период';


--
-- TOC entry 8176 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.fscs_fullness; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.fscs_fullness IS 'Заполненность ФН %';


--
-- TOC entry 8177 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.rpt_guid; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.rpt_guid IS 'Уникальный идентификатор отчёта';


--
-- TOC entry 8178 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.rpt_parameters; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.rpt_parameters IS 'Параметры отчёта';


--
-- TOC entry 8179 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.id_org; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.id_org IS 'ID организации';


--
-- TOC entry 8180 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.id_app; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.id_app IS 'ID приложения';


--
-- TOC entry 8181 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.id_fsc_provider; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 8182 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.id_kkt_group; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.id_kkt_group IS 'ID группы касс';


--
-- TOC entry 8183 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.id_kkt; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.id_kkt IS 'ID ККТ';


--
-- TOC entry 8184 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.id_fsc_storage; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.id_fsc_storage IS 'ID фискального накопителя';


--
-- TOC entry 8185 (class 0 OID 0)
-- Dependencies: 422
-- Name: COLUMN fsc_report.id_receipt; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_report.id_receipt IS 'ID чека';


--
-- TOC entry 426 (class 1259 OID 1614901)
-- Name: fsc_storage_id_seq; Type: SEQUENCE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_4_fiscalization".fsc_storage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_4_fiscalization".fsc_storage_id_seq OWNER TO postgres;

--
-- TOC entry 419 (class 1259 OID 1611932)
-- Name: fsc_storage; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_storage (
    id_fsc_storage integer DEFAULT nextval('"_OLD_4_fiscalization".fsc_storage_id_seq'::regclass) NOT NULL,
    id_kkt integer NOT NULL,
    fscs_dt_create timestamp(0) without time zone,
    rcp_qty integer,
    fscs_qty_max integer,
    fscs_nmb text,
    fscs_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_4_fiscalization".fsc_storage OWNER TO postgres;

--
-- TOC entry 8186 (class 0 OID 0)
-- Dependencies: 419
-- Name: TABLE fsc_storage; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_storage IS 'Фискальный накопитель';


--
-- TOC entry 8187 (class 0 OID 0)
-- Dependencies: 419
-- Name: COLUMN fsc_storage.id_fsc_storage; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_storage.id_fsc_storage IS 'ID Фискального накопителя';


--
-- TOC entry 8188 (class 0 OID 0)
-- Dependencies: 419
-- Name: COLUMN fsc_storage.id_kkt; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_storage.id_kkt IS 'ID ККТ';


--
-- TOC entry 8189 (class 0 OID 0)
-- Dependencies: 419
-- Name: COLUMN fsc_storage.fscs_dt_create; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_storage.fscs_dt_create IS 'Дата выдачи';


--
-- TOC entry 8190 (class 0 OID 0)
-- Dependencies: 419
-- Name: COLUMN fsc_storage.rcp_qty; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_storage.rcp_qty IS 'Количество чеков';


--
-- TOC entry 8191 (class 0 OID 0)
-- Dependencies: 419
-- Name: COLUMN fsc_storage.fscs_qty_max; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_storage.fscs_qty_max IS 'Максимально чеков';


--
-- TOC entry 8192 (class 0 OID 0)
-- Dependencies: 419
-- Name: COLUMN fsc_storage.fscs_nmb; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_storage.fscs_nmb IS 'Номер';


--
-- TOC entry 8193 (class 0 OID 0)
-- Dependencies: 419
-- Name: COLUMN fsc_storage.fscs_status; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_storage.fscs_status IS 'Статус';


--
-- TOC entry 420 (class 1259 OID 1611940)
-- Name: fsc_task; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_task (
    id_task integer NOT NULL,
    id_user integer NOT NULL,
    id_kkt integer NOT NULL,
    dt_begin timestamp(0) without time zone,
    dt_end timestamp(0) without time zone,
    task_nmb text,
    task_status integer,
    task_type integer
);


ALTER TABLE "_OLD_4_fiscalization".fsc_task OWNER TO postgres;

--
-- TOC entry 8194 (class 0 OID 0)
-- Dependencies: 420
-- Name: TABLE fsc_task; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_task IS 'Задача';


--
-- TOC entry 8195 (class 0 OID 0)
-- Dependencies: 420
-- Name: COLUMN fsc_task.id_task; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_task.id_task IS 'ID задачи';


--
-- TOC entry 8196 (class 0 OID 0)
-- Dependencies: 420
-- Name: COLUMN fsc_task.id_user; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_task.id_user IS 'ID пользователя';


--
-- TOC entry 8197 (class 0 OID 0)
-- Dependencies: 420
-- Name: COLUMN fsc_task.id_kkt; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_task.id_kkt IS 'ID ККТ';


--
-- TOC entry 8198 (class 0 OID 0)
-- Dependencies: 420
-- Name: COLUMN fsc_task.dt_begin; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_task.dt_begin IS 'Дата начала';


--
-- TOC entry 8199 (class 0 OID 0)
-- Dependencies: 420
-- Name: COLUMN fsc_task.dt_end; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_task.dt_end IS 'Дата окончания';


--
-- TOC entry 8200 (class 0 OID 0)
-- Dependencies: 420
-- Name: COLUMN fsc_task.task_nmb; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_task.task_nmb IS 'Номер задачи';


--
-- TOC entry 8201 (class 0 OID 0)
-- Dependencies: 420
-- Name: COLUMN fsc_task.task_status; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_task.task_status IS 'Статус задачи';


--
-- TOC entry 8202 (class 0 OID 0)
-- Dependencies: 420
-- Name: COLUMN fsc_task.task_type; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_task.task_type IS 'Тип задачи';


--
-- TOC entry 421 (class 1259 OID 1611948)
-- Name: fsc_user; Type: TABLE; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_4_fiscalization".fsc_user (
    id_user integer NOT NULL,
    dt_create timestamp(0) without time zone NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    id_org integer,
    is_adm boolean DEFAULT false NOT NULL,
    sso_login text NOT NULL,
    usr_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_4_fiscalization".fsc_user OWNER TO postgres;

--
-- TOC entry 8203 (class 0 OID 0)
-- Dependencies: 421
-- Name: TABLE fsc_user; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_4_fiscalization".fsc_user IS 'Пользователь/Абонент';


--
-- TOC entry 8204 (class 0 OID 0)
-- Dependencies: 421
-- Name: COLUMN fsc_user.id_user; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_user.id_user IS 'ID Пользователя';


--
-- TOC entry 8205 (class 0 OID 0)
-- Dependencies: 421
-- Name: COLUMN fsc_user.dt_create; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_user.dt_create IS 'Дата создания записи';


--
-- TOC entry 8206 (class 0 OID 0)
-- Dependencies: 421
-- Name: COLUMN fsc_user.dt_update; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_user.dt_update IS 'Дата обновления';


--
-- TOC entry 8207 (class 0 OID 0)
-- Dependencies: 421
-- Name: COLUMN fsc_user.dt_remove; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_user.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 8208 (class 0 OID 0)
-- Dependencies: 421
-- Name: COLUMN fsc_user.id_org; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_user.id_org IS 'ID Организации';


--
-- TOC entry 8209 (class 0 OID 0)
-- Dependencies: 421
-- Name: COLUMN fsc_user.is_adm; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_user.is_adm IS 'Администратор';


--
-- TOC entry 8210 (class 0 OID 0)
-- Dependencies: 421
-- Name: COLUMN fsc_user.sso_login; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_user.sso_login IS 'Логин';


--
-- TOC entry 8211 (class 0 OID 0)
-- Dependencies: 421
-- Name: COLUMN fsc_user.usr_status; Type: COMMENT; Schema: _OLD_4_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_4_fiscalization".fsc_user.usr_status IS 'Статус пользователя';


--
-- TOC entry 428 (class 1259 OID 1615585)
-- Name: fsc_app_id_app_seq; Type: SEQUENCE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_5_fiscalization".fsc_app_id_app_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_5_fiscalization".fsc_app_id_app_seq OWNER TO postgres;

--
-- TOC entry 480 (class 1259 OID 1616278)
-- Name: fsc_app; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_app (
    id_app integer DEFAULT nextval('"_OLD_5_fiscalization".fsc_app_id_app_seq'::regclass) NOT NULL,
    dt_create timestamp(0) without time zone NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    app_guid uuid,
    secret_key text NOT NULL,
    nm_app text NOT NULL,
    notification_url text,
    provaider_key text
);


ALTER TABLE "_OLD_5_fiscalization".fsc_app OWNER TO postgres;

--
-- TOC entry 8212 (class 0 OID 0)
-- Dependencies: 480
-- Name: TABLE fsc_app; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_5_fiscalization".fsc_app IS 'Приложение';


--
-- TOC entry 8213 (class 0 OID 0)
-- Dependencies: 480
-- Name: COLUMN fsc_app.id_app; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app.id_app IS 'ID приложения';


--
-- TOC entry 8214 (class 0 OID 0)
-- Dependencies: 480
-- Name: COLUMN fsc_app.dt_create; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app.dt_create IS 'Дата создания записи';


--
-- TOC entry 8215 (class 0 OID 0)
-- Dependencies: 480
-- Name: COLUMN fsc_app.dt_update; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app.dt_update IS 'Дата обновления';


--
-- TOC entry 8216 (class 0 OID 0)
-- Dependencies: 480
-- Name: COLUMN fsc_app.dt_remove; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 8217 (class 0 OID 0)
-- Dependencies: 480
-- Name: COLUMN fsc_app.app_guid; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app.app_guid IS 'UUID приложения';


--
-- TOC entry 8218 (class 0 OID 0)
-- Dependencies: 480
-- Name: COLUMN fsc_app.secret_key; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app.secret_key IS 'Секретный ключ';


--
-- TOC entry 8219 (class 0 OID 0)
-- Dependencies: 480
-- Name: COLUMN fsc_app.nm_app; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app.nm_app IS 'Название приложеия';


--
-- TOC entry 8220 (class 0 OID 0)
-- Dependencies: 480
-- Name: COLUMN fsc_app.notification_url; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app.notification_url IS 'URL для уведомлений';


--
-- TOC entry 8221 (class 0 OID 0)
-- Dependencies: 480
-- Name: COLUMN fsc_app.provaider_key; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app.provaider_key IS 'Ключ приложения';


--
-- TOC entry 431 (class 1259 OID 1615591)
-- Name: fsc_app_fsc_provider_id_seq; Type: SEQUENCE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_5_fiscalization".fsc_app_fsc_provider_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_5_fiscalization".fsc_app_fsc_provider_id_seq OWNER TO postgres;

--
-- TOC entry 433 (class 1259 OID 1615605)
-- Name: fsc_app_fsc_provider; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_app_fsc_provider (
    id_app_fsk_provider integer DEFAULT nextval('"_OLD_5_fiscalization".fsc_app_fsc_provider_id_seq'::regclass) NOT NULL,
    id_app integer NOT NULL,
    id_fsc_provider integer NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) without time zone,
    qty_cash integer DEFAULT 0 NOT NULL,
    grp_cash character varying(50),
    nm_grp_cash character varying(150),
    app_fsc_provider_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_5_fiscalization".fsc_app_fsc_provider OWNER TO postgres;

--
-- TOC entry 8222 (class 0 OID 0)
-- Dependencies: 433
-- Name: TABLE fsc_app_fsc_provider; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_5_fiscalization".fsc_app_fsc_provider IS 'Настройки приложения';


--
-- TOC entry 8223 (class 0 OID 0)
-- Dependencies: 433
-- Name: COLUMN fsc_app_fsc_provider.id_app_fsk_provider; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app_fsc_provider.id_app_fsk_provider IS 'ID Настройки приложения';


--
-- TOC entry 8224 (class 0 OID 0)
-- Dependencies: 433
-- Name: COLUMN fsc_app_fsc_provider.id_app; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app_fsc_provider.id_app IS 'ID приложение';


--
-- TOC entry 8225 (class 0 OID 0)
-- Dependencies: 433
-- Name: COLUMN fsc_app_fsc_provider.id_fsc_provider; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app_fsc_provider.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 8226 (class 0 OID 0)
-- Dependencies: 433
-- Name: COLUMN fsc_app_fsc_provider.dt_create; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app_fsc_provider.dt_create IS 'Дата создания';


--
-- TOC entry 8227 (class 0 OID 0)
-- Dependencies: 433
-- Name: COLUMN fsc_app_fsc_provider.dt_update; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app_fsc_provider.dt_update IS 'Дата обновления';


--
-- TOC entry 8228 (class 0 OID 0)
-- Dependencies: 433
-- Name: COLUMN fsc_app_fsc_provider.qty_cash; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app_fsc_provider.qty_cash IS 'Количество касс';


--
-- TOC entry 8229 (class 0 OID 0)
-- Dependencies: 433
-- Name: COLUMN fsc_app_fsc_provider.grp_cash; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app_fsc_provider.grp_cash IS 'Группа касс';


--
-- TOC entry 8230 (class 0 OID 0)
-- Dependencies: 433
-- Name: COLUMN fsc_app_fsc_provider.nm_grp_cash; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app_fsc_provider.nm_grp_cash IS 'Наименование группы';


--
-- TOC entry 8231 (class 0 OID 0)
-- Dependencies: 433
-- Name: COLUMN fsc_app_fsc_provider.app_fsc_provider_status; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_app_fsc_provider.app_fsc_provider_status IS 'Статус';


--
-- TOC entry 430 (class 1259 OID 1615589)
-- Name: fsc_receipt_id_receipt_seq; Type: SEQUENCE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_5_fiscalization".fsc_receipt_id_receipt_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_5_fiscalization".fsc_receipt_id_receipt_seq OWNER TO postgres;

--
-- TOC entry 434 (class 1259 OID 1615616)
-- Name: fsc_order; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL
)
PARTITION BY RANGE (dt_create);


ALTER TABLE "_OLD_5_fiscalization".fsc_order OWNER TO postgres;

--
-- TOC entry 8232 (class 0 OID 0)
-- Dependencies: 434
-- Name: TABLE fsc_order; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_5_fiscalization".fsc_order IS 'Запрос на фискализацию';


--
-- TOC entry 8233 (class 0 OID 0)
-- Dependencies: 434
-- Name: COLUMN fsc_order.id_receipt; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_order.id_receipt IS 'ID Чека';


--
-- TOC entry 8234 (class 0 OID 0)
-- Dependencies: 434
-- Name: COLUMN fsc_order.dt_create; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_order.dt_create IS 'Дата создания';


--
-- TOC entry 8235 (class 0 OID 0)
-- Dependencies: 434
-- Name: COLUMN fsc_order.id_app; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_order.id_app IS 'ID приложения';


--
-- TOC entry 8236 (class 0 OID 0)
-- Dependencies: 434
-- Name: COLUMN fsc_order.rcp_correction; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_order.rcp_correction IS 'Тип (чек корреции/кассовый чек)';


--
-- TOC entry 8237 (class 0 OID 0)
-- Dependencies: 434
-- Name: COLUMN fsc_order.rcp_order; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_order.rcp_order IS 'Запрос на фискализацию';


--
-- TOC entry 8238 (class 0 OID 0)
-- Dependencies: 434
-- Name: COLUMN fsc_order.id_org; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_order.id_org IS 'ID организации';


--
-- TOC entry 447 (class 1259 OID 1615755)
-- Name: fsc_order_default; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order_default (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_default DEFAULT;


ALTER TABLE "_OLD_5_fiscalization".fsc_order_default OWNER TO postgres;

--
-- TOC entry 435 (class 1259 OID 1615623)
-- Name: fsc_order_part_2021_01; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order_part_2021_01 (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_01 CHECK (((dt_create >= '2021-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-02-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_01 FOR VALUES FROM ('2021-01-01 00:00:00+03') TO ('2021-02-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_order_part_2021_01 OWNER TO postgres;

--
-- TOC entry 436 (class 1259 OID 1615634)
-- Name: fsc_order_part_2021_02; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order_part_2021_02 (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_02 CHECK (((dt_create >= '2021-02-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-03-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_02 FOR VALUES FROM ('2021-02-01 00:00:00+03') TO ('2021-03-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_order_part_2021_02 OWNER TO postgres;

--
-- TOC entry 437 (class 1259 OID 1615645)
-- Name: fsc_order_part_2021_03; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order_part_2021_03 (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_03 CHECK (((dt_create >= '2021-03-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-04-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_03 FOR VALUES FROM ('2021-03-01 00:00:00+03') TO ('2021-04-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_order_part_2021_03 OWNER TO postgres;

--
-- TOC entry 438 (class 1259 OID 1615656)
-- Name: fsc_order_part_2021_04; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order_part_2021_04 (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_04 CHECK (((dt_create >= '2021-04-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-05-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_04 FOR VALUES FROM ('2021-04-01 00:00:00+03') TO ('2021-05-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_order_part_2021_04 OWNER TO postgres;

--
-- TOC entry 439 (class 1259 OID 1615667)
-- Name: fsc_order_part_2021_05; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order_part_2021_05 (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_05 CHECK (((dt_create >= '2021-05-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-06-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_05 FOR VALUES FROM ('2021-05-01 00:00:00+03') TO ('2021-06-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_order_part_2021_05 OWNER TO postgres;

--
-- TOC entry 440 (class 1259 OID 1615678)
-- Name: fsc_order_part_2021_06; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order_part_2021_06 (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_06 CHECK (((dt_create >= '2021-06-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-07-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_06 FOR VALUES FROM ('2021-06-01 00:00:00+03') TO ('2021-07-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_order_part_2021_06 OWNER TO postgres;

--
-- TOC entry 441 (class 1259 OID 1615689)
-- Name: fsc_order_part_2021_07; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order_part_2021_07 (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_07 CHECK (((dt_create >= '2021-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-08-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_07 FOR VALUES FROM ('2021-07-01 00:00:00+03') TO ('2021-08-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_order_part_2021_07 OWNER TO postgres;

--
-- TOC entry 442 (class 1259 OID 1615700)
-- Name: fsc_order_part_2021_08; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order_part_2021_08 (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_08 CHECK (((dt_create >= '2021-08-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-09-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_08 FOR VALUES FROM ('2021-08-01 00:00:00+03') TO ('2021-09-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_order_part_2021_08 OWNER TO postgres;

--
-- TOC entry 443 (class 1259 OID 1615711)
-- Name: fsc_order_part_2021_09; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order_part_2021_09 (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_09 CHECK (((dt_create >= '2021-09-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-10-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_09 FOR VALUES FROM ('2021-09-01 00:00:00+03') TO ('2021-10-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_order_part_2021_09 OWNER TO postgres;

--
-- TOC entry 444 (class 1259 OID 1615722)
-- Name: fsc_order_part_2021_10; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order_part_2021_10 (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_10 CHECK (((dt_create >= '2021-10-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-11-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_10 FOR VALUES FROM ('2021-10-01 00:00:00+03') TO ('2021-11-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_order_part_2021_10 OWNER TO postgres;

--
-- TOC entry 445 (class 1259 OID 1615733)
-- Name: fsc_order_part_2021_11; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order_part_2021_11 (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_11 CHECK (((dt_create >= '2021-11-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-12-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_11 FOR VALUES FROM ('2021-11-01 00:00:00+03') TO ('2021-12-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_order_part_2021_11 OWNER TO postgres;

--
-- TOC entry 446 (class 1259 OID 1615744)
-- Name: fsc_order_part_2021_12; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_order_part_2021_12 (
    id_receipt bigint DEFAULT nextval('"_OLD_5_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    id_app integer NOT NULL,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_order jsonb NOT NULL,
    id_org integer NOT NULL,
    CONSTRAINT chk_order_dt_create_2021_12 CHECK (((dt_create >= '2021-12-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2022-01-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_12 FOR VALUES FROM ('2021-12-01 00:00:00+03') TO ('2022-01-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_order_part_2021_12 OWNER TO postgres;

--
-- TOC entry 429 (class 1259 OID 1615587)
-- Name: fsc_org_id_org_seq; Type: SEQUENCE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_5_fiscalization".fsc_org_id_org_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_5_fiscalization".fsc_org_id_org_seq OWNER TO postgres;

--
-- TOC entry 448 (class 1259 OID 1615765)
-- Name: fsc_org; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_org (
    id_org integer DEFAULT nextval('"_OLD_5_fiscalization".fsc_org_id_org_seq'::regclass) NOT NULL,
    dt_create timestamp(0) without time zone NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    inn character varying(12) NOT NULL,
    nm_org_name character varying(150) NOT NULL,
    default_parameters jsonb,
    org_type integer,
    org_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_5_fiscalization".fsc_org OWNER TO postgres;

--
-- TOC entry 8239 (class 0 OID 0)
-- Dependencies: 448
-- Name: TABLE fsc_org; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_5_fiscalization".fsc_org IS 'Организация';


--
-- TOC entry 8240 (class 0 OID 0)
-- Dependencies: 448
-- Name: COLUMN fsc_org.id_org; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org.id_org IS 'ID организации';


--
-- TOC entry 8241 (class 0 OID 0)
-- Dependencies: 448
-- Name: COLUMN fsc_org.dt_create; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org.dt_create IS 'Дата создания записи';


--
-- TOC entry 8242 (class 0 OID 0)
-- Dependencies: 448
-- Name: COLUMN fsc_org.dt_update; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org.dt_update IS 'Дата обновления';


--
-- TOC entry 8243 (class 0 OID 0)
-- Dependencies: 448
-- Name: COLUMN fsc_org.dt_remove; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 8244 (class 0 OID 0)
-- Dependencies: 448
-- Name: COLUMN fsc_org.inn; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org.inn IS 'ИНН';


--
-- TOC entry 8245 (class 0 OID 0)
-- Dependencies: 448
-- Name: COLUMN fsc_org.nm_org_name; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org.nm_org_name IS 'Наименование организации';


--
-- TOC entry 8246 (class 0 OID 0)
-- Dependencies: 448
-- Name: COLUMN fsc_org.default_parameters; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org.default_parameters IS 'Параметры по умолчанию';


--
-- TOC entry 8247 (class 0 OID 0)
-- Dependencies: 448
-- Name: COLUMN fsc_org.org_type; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org.org_type IS 'Тип организации';


--
-- TOC entry 8248 (class 0 OID 0)
-- Dependencies: 448
-- Name: COLUMN fsc_org.org_status; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org.org_status IS 'Статус организации';


--
-- TOC entry 478 (class 1259 OID 1616266)
-- Name: fsc_org_app_id_org_app_seq; Type: SEQUENCE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_5_fiscalization".fsc_org_app_id_org_app_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_5_fiscalization".fsc_org_app_id_org_app_seq OWNER TO postgres;

--
-- TOC entry 479 (class 1259 OID 1616268)
-- Name: fsc_org_app; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_org_app (
    id_org_app integer DEFAULT nextval('"_OLD_5_fiscalization".fsc_org_app_id_org_app_seq'::regclass) NOT NULL,
    id_app integer NOT NULL,
    id_org integer NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    org_app_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_5_fiscalization".fsc_org_app OWNER TO postgres;

--
-- TOC entry 8249 (class 0 OID 0)
-- Dependencies: 479
-- Name: TABLE fsc_org_app; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_5_fiscalization".fsc_org_app IS 'Приложения организации';


--
-- TOC entry 8250 (class 0 OID 0)
-- Dependencies: 479
-- Name: COLUMN fsc_org_app.id_org_app; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org_app.id_org_app IS 'ID приложения организации';


--
-- TOC entry 8251 (class 0 OID 0)
-- Dependencies: 479
-- Name: COLUMN fsc_org_app.id_app; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org_app.id_app IS 'ID приложение';


--
-- TOC entry 8252 (class 0 OID 0)
-- Dependencies: 479
-- Name: COLUMN fsc_org_app.id_org; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org_app.id_org IS 'ID Организации';


--
-- TOC entry 8253 (class 0 OID 0)
-- Dependencies: 479
-- Name: COLUMN fsc_org_app.dt_create; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org_app.dt_create IS 'Дата создания';


--
-- TOC entry 8254 (class 0 OID 0)
-- Dependencies: 479
-- Name: COLUMN fsc_org_app.org_app_status; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_org_app.org_app_status IS 'Статус';


--
-- TOC entry 432 (class 1259 OID 1615593)
-- Name: fsc_provider_id_seq; Type: SEQUENCE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_5_fiscalization".fsc_provider_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_5_fiscalization".fsc_provider_id_seq OWNER TO postgres;

--
-- TOC entry 449 (class 1259 OID 1615775)
-- Name: fsc_provider; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_provider (
    id_fsc_provider integer DEFAULT nextval('"_OLD_5_fiscalization".fsc_provider_id_seq'::regclass) NOT NULL,
    nm_fsc_provider character varying(150) NOT NULL,
    kd_fsc_provider character varying(20) NOT NULL,
    fsc_url text,
    fsc_port character varying(5),
    fsc_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_5_fiscalization".fsc_provider OWNER TO postgres;

--
-- TOC entry 8255 (class 0 OID 0)
-- Dependencies: 449
-- Name: TABLE fsc_provider; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_5_fiscalization".fsc_provider IS 'Фискальный провайдер';


--
-- TOC entry 8256 (class 0 OID 0)
-- Dependencies: 449
-- Name: COLUMN fsc_provider.id_fsc_provider; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_provider.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 8257 (class 0 OID 0)
-- Dependencies: 449
-- Name: COLUMN fsc_provider.nm_fsc_provider; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_provider.nm_fsc_provider IS 'Наименование';


--
-- TOC entry 8258 (class 0 OID 0)
-- Dependencies: 449
-- Name: COLUMN fsc_provider.kd_fsc_provider; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_provider.kd_fsc_provider IS 'Системный код';


--
-- TOC entry 8259 (class 0 OID 0)
-- Dependencies: 449
-- Name: COLUMN fsc_provider.fsc_url; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_provider.fsc_url IS 'URL фискального провайдера';


--
-- TOC entry 8260 (class 0 OID 0)
-- Dependencies: 449
-- Name: COLUMN fsc_provider.fsc_port; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_provider.fsc_port IS 'Порт';


--
-- TOC entry 8261 (class 0 OID 0)
-- Dependencies: 449
-- Name: COLUMN fsc_provider.fsc_status; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_provider.fsc_status IS 'Статус';


--
-- TOC entry 450 (class 1259 OID 1615785)
-- Name: fsc_rcp_params; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL
)
PARTITION BY RANGE (dt_create);


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params OWNER TO postgres;

--
-- TOC entry 8262 (class 0 OID 0)
-- Dependencies: 450
-- Name: TABLE fsc_rcp_params; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_5_fiscalization".fsc_rcp_params IS 'Параметры чека';


--
-- TOC entry 8263 (class 0 OID 0)
-- Dependencies: 450
-- Name: COLUMN fsc_rcp_params.id_receipt; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_rcp_params.id_receipt IS 'ID Чека';


--
-- TOC entry 8264 (class 0 OID 0)
-- Dependencies: 450
-- Name: COLUMN fsc_rcp_params.dt_create; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_rcp_params.dt_create IS 'Дата создания';


--
-- TOC entry 8265 (class 0 OID 0)
-- Dependencies: 450
-- Name: COLUMN fsc_rcp_params.dt_update; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_rcp_params.dt_update IS 'Дата обновления';


--
-- TOC entry 8266 (class 0 OID 0)
-- Dependencies: 450
-- Name: COLUMN fsc_rcp_params.rcp_amount; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_rcp_params.rcp_amount IS 'Сумма';


--
-- TOC entry 8267 (class 0 OID 0)
-- Dependencies: 450
-- Name: COLUMN fsc_rcp_params.rcp_status; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_rcp_params.rcp_status IS 'Статус чека';


--
-- TOC entry 8268 (class 0 OID 0)
-- Dependencies: 450
-- Name: COLUMN fsc_rcp_params.rcp_received; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_rcp_params.rcp_received IS 'Чек принят';


--
-- TOC entry 8269 (class 0 OID 0)
-- Dependencies: 450
-- Name: COLUMN fsc_rcp_params.rcp_notify_send; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_rcp_params.rcp_notify_send IS 'Извещение отослано';


--
-- TOC entry 463 (class 1259 OID 1615914)
-- Name: fsc_rcp_params_default; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params_default (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_default DEFAULT;


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_default OWNER TO postgres;

--
-- TOC entry 427 (class 1259 OID 1615111)
-- Name: fsc_rcp_params_id_receipt_seq; Type: SEQUENCE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_5_fiscalization".fsc_rcp_params_id_receipt_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_id_receipt_seq OWNER TO postgres;

--
-- TOC entry 451 (class 1259 OID 1615794)
-- Name: fsc_rcp_params_part_2021_01; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_01 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_01 CHECK (((dt_create >= '2021-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-02-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_01 FOR VALUES FROM ('2021-01-01 00:00:00+03') TO ('2021-02-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_01 OWNER TO postgres;

--
-- TOC entry 452 (class 1259 OID 1615804)
-- Name: fsc_rcp_params_part_2021_02; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_02 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_02 CHECK (((dt_create >= '2021-02-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-03-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_02 FOR VALUES FROM ('2021-02-01 00:00:00+03') TO ('2021-03-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_02 OWNER TO postgres;

--
-- TOC entry 453 (class 1259 OID 1615814)
-- Name: fsc_rcp_params_part_2021_03; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_03 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_03 CHECK (((dt_create >= '2021-03-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-04-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_03 FOR VALUES FROM ('2021-03-01 00:00:00+03') TO ('2021-04-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_03 OWNER TO postgres;

--
-- TOC entry 454 (class 1259 OID 1615824)
-- Name: fsc_rcp_params_part_2021_04; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_04 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_04 CHECK (((dt_create >= '2021-04-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-05-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_04 FOR VALUES FROM ('2021-04-01 00:00:00+03') TO ('2021-05-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_04 OWNER TO postgres;

--
-- TOC entry 455 (class 1259 OID 1615834)
-- Name: fsc_rcp_params_part_2021_05; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_05 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_05 CHECK (((dt_create >= '2021-05-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-06-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_05 FOR VALUES FROM ('2021-05-01 00:00:00+03') TO ('2021-06-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_05 OWNER TO postgres;

--
-- TOC entry 456 (class 1259 OID 1615844)
-- Name: fsc_rcp_params_part_2021_06; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_06 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_06 CHECK (((dt_create >= '2021-06-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-07-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_06 FOR VALUES FROM ('2021-06-01 00:00:00+03') TO ('2021-07-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_06 OWNER TO postgres;

--
-- TOC entry 457 (class 1259 OID 1615854)
-- Name: fsc_rcp_params_part_2021_07; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_07 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_07 CHECK (((dt_create >= '2021-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-08-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_07 FOR VALUES FROM ('2021-07-01 00:00:00+03') TO ('2021-08-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_07 OWNER TO postgres;

--
-- TOC entry 458 (class 1259 OID 1615864)
-- Name: fsc_rcp_params_part_2021_08; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_08 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_08 CHECK (((dt_create >= '2021-08-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-09-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_08 FOR VALUES FROM ('2021-08-01 00:00:00+03') TO ('2021-09-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_08 OWNER TO postgres;

--
-- TOC entry 459 (class 1259 OID 1615874)
-- Name: fsc_rcp_params_part_2021_09; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_09 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_09 CHECK (((dt_create >= '2021-09-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-10-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_09 FOR VALUES FROM ('2021-09-01 00:00:00+03') TO ('2021-10-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_09 OWNER TO postgres;

--
-- TOC entry 460 (class 1259 OID 1615884)
-- Name: fsc_rcp_params_part_2021_10; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_10 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_10 CHECK (((dt_create >= '2021-10-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-11-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_10 FOR VALUES FROM ('2021-10-01 00:00:00+03') TO ('2021-11-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_10 OWNER TO postgres;

--
-- TOC entry 461 (class 1259 OID 1615894)
-- Name: fsc_rcp_params_part_2021_11; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_11 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_11 CHECK (((dt_create >= '2021-11-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-12-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_11 FOR VALUES FROM ('2021-11-01 00:00:00+03') TO ('2021-12-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_11 OWNER TO postgres;

--
-- TOC entry 462 (class 1259 OID 1615904)
-- Name: fsc_rcp_params_part_2021_12; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_12 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) with time zone,
    rcp_amount numeric(12,2) NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_dt_create_2021_12 CHECK (((dt_create >= '2021-12-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2022-01-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_12 FOR VALUES FROM ('2021-12-01 00:00:00+03') TO ('2022-01-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params_part_2021_12 OWNER TO postgres;

--
-- TOC entry 464 (class 1259 OID 1615923)
-- Name: fsc_result; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone
)
PARTITION BY RANGE (dt_create);


ALTER TABLE "_OLD_5_fiscalization".fsc_result OWNER TO postgres;

--
-- TOC entry 8270 (class 0 OID 0)
-- Dependencies: 464
-- Name: TABLE fsc_result; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_5_fiscalization".fsc_result IS 'Чек, результат фискализации';


--
-- TOC entry 8271 (class 0 OID 0)
-- Dependencies: 464
-- Name: COLUMN fsc_result.id_receipt; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_result.id_receipt IS 'ID Чека';


--
-- TOC entry 8272 (class 0 OID 0)
-- Dependencies: 464
-- Name: COLUMN fsc_result.dt_create; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_result.dt_create IS 'Дата создания';


--
-- TOC entry 8273 (class 0 OID 0)
-- Dependencies: 464
-- Name: COLUMN fsc_result.rcp_receipt; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_result.rcp_receipt IS 'Фискализированный чек';


--
-- TOC entry 8274 (class 0 OID 0)
-- Dependencies: 464
-- Name: COLUMN fsc_result.rcp_nmb; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_result.rcp_nmb IS 'Номер чека';


--
-- TOC entry 8275 (class 0 OID 0)
-- Dependencies: 464
-- Name: COLUMN fsc_result.rcp_fp; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_result.rcp_fp IS 'ФН';


--
-- TOC entry 8276 (class 0 OID 0)
-- Dependencies: 464
-- Name: COLUMN fsc_result.dt_fp; Type: COMMENT; Schema: _OLD_5_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_5_fiscalization".fsc_result.dt_fp IS 'Дата фискализации';


--
-- TOC entry 477 (class 1259 OID 1616036)
-- Name: fsc_result_default; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result_default (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_default DEFAULT;


ALTER TABLE "_OLD_5_fiscalization".fsc_result_default OWNER TO postgres;

--
-- TOC entry 465 (class 1259 OID 1615928)
-- Name: fsc_result_part_2021_01; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result_part_2021_01 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    CONSTRAINT chk_result_dt_create_2021_01 CHECK (((dt_create >= '2021-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-02-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_01 FOR VALUES FROM ('2021-01-01 00:00:00+03') TO ('2021-02-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_result_part_2021_01 OWNER TO postgres;

--
-- TOC entry 466 (class 1259 OID 1615937)
-- Name: fsc_result_part_2021_02; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result_part_2021_02 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    CONSTRAINT chk_result_dt_create_2021_02 CHECK (((dt_create >= '2021-02-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-03-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_02 FOR VALUES FROM ('2021-02-01 00:00:00+03') TO ('2021-03-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_result_part_2021_02 OWNER TO postgres;

--
-- TOC entry 467 (class 1259 OID 1615946)
-- Name: fsc_result_part_2021_03; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result_part_2021_03 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    CONSTRAINT chk_result_dt_create_2021_03 CHECK (((dt_create >= '2021-03-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-04-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_03 FOR VALUES FROM ('2021-03-01 00:00:00+03') TO ('2021-04-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_result_part_2021_03 OWNER TO postgres;

--
-- TOC entry 468 (class 1259 OID 1615955)
-- Name: fsc_result_part_2021_04; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result_part_2021_04 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    CONSTRAINT chk_result_dt_create_2021_04 CHECK (((dt_create >= '2021-04-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-05-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_04 FOR VALUES FROM ('2021-04-01 00:00:00+03') TO ('2021-05-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_result_part_2021_04 OWNER TO postgres;

--
-- TOC entry 469 (class 1259 OID 1615964)
-- Name: fsc_result_part_2021_05; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result_part_2021_05 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    CONSTRAINT chk_result_dt_create_2021_05 CHECK (((dt_create >= '2021-05-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-06-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_05 FOR VALUES FROM ('2021-05-01 00:00:00+03') TO ('2021-06-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_result_part_2021_05 OWNER TO postgres;

--
-- TOC entry 470 (class 1259 OID 1615973)
-- Name: fsc_result_part_2021_06; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result_part_2021_06 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    CONSTRAINT chk_result_dt_create_2021_06 CHECK (((dt_create >= '2021-06-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-07-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_06 FOR VALUES FROM ('2021-06-01 00:00:00+03') TO ('2021-07-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_result_part_2021_06 OWNER TO postgres;

--
-- TOC entry 471 (class 1259 OID 1615982)
-- Name: fsc_result_part_2021_07; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result_part_2021_07 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    CONSTRAINT chk_result_dt_create_2021_07 CHECK (((dt_create >= '2021-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-08-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_07 FOR VALUES FROM ('2021-07-01 00:00:00+03') TO ('2021-08-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_result_part_2021_07 OWNER TO postgres;

--
-- TOC entry 472 (class 1259 OID 1615991)
-- Name: fsc_result_part_2021_08; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result_part_2021_08 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    CONSTRAINT chk_result_dt_create_2021_08 CHECK (((dt_create >= '2021-08-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-09-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_08 FOR VALUES FROM ('2021-08-01 00:00:00+03') TO ('2021-09-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_result_part_2021_08 OWNER TO postgres;

--
-- TOC entry 473 (class 1259 OID 1616000)
-- Name: fsc_result_part_2021_09; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result_part_2021_09 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    CONSTRAINT chk_result_dt_create_2021_09 CHECK (((dt_create >= '2021-09-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-10-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_09 FOR VALUES FROM ('2021-09-01 00:00:00+03') TO ('2021-10-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_result_part_2021_09 OWNER TO postgres;

--
-- TOC entry 474 (class 1259 OID 1616009)
-- Name: fsc_result_part_2021_10; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result_part_2021_10 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    CONSTRAINT chk_result_dt_create_2021_10 CHECK (((dt_create >= '2021-10-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-11-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_10 FOR VALUES FROM ('2021-10-01 00:00:00+03') TO ('2021-11-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_result_part_2021_10 OWNER TO postgres;

--
-- TOC entry 475 (class 1259 OID 1616018)
-- Name: fsc_result_part_2021_11; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result_part_2021_11 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    CONSTRAINT chk_result_dt_create_2021_11 CHECK (((dt_create >= '2021-11-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-12-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_11 FOR VALUES FROM ('2021-11-01 00:00:00+03') TO ('2021-12-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_result_part_2021_11 OWNER TO postgres;

--
-- TOC entry 476 (class 1259 OID 1616027)
-- Name: fsc_result_part_2021_12; Type: TABLE; Schema: _OLD_5_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_5_fiscalization".fsc_result_part_2021_12 (
    id_receipt bigint NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_receipt jsonb,
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    CONSTRAINT chk_result_dt_create_2021_12 CHECK (((dt_create >= '2021-12-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2022-01-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_12 FOR VALUES FROM ('2021-12-01 00:00:00+03') TO ('2022-01-01 00:00:00+03');


ALTER TABLE "_OLD_5_fiscalization".fsc_result_part_2021_12 OWNER TO postgres;

--
-- TOC entry 481 (class 1259 OID 1618428)
-- Name: fsc_app_id_app_seq; Type: SEQUENCE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_6_fiscalization".fsc_app_id_app_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_6_fiscalization".fsc_app_id_app_seq OWNER TO postgres;

--
-- TOC entry 505 (class 1259 OID 1867259)
-- Name: fsc_app; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_app (
    id_app integer DEFAULT nextval('"_OLD_6_fiscalization".fsc_app_id_app_seq'::regclass) NOT NULL,
    dt_create timestamp(0) without time zone NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    app_guid uuid,
    secret_key text NOT NULL,
    nm_app text NOT NULL,
    notification_url text,
    provaider_key text
);


ALTER TABLE "_OLD_6_fiscalization".fsc_app OWNER TO postgres;

--
-- TOC entry 8277 (class 0 OID 0)
-- Dependencies: 505
-- Name: TABLE fsc_app; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_6_fiscalization".fsc_app IS 'Приложение';


--
-- TOC entry 8278 (class 0 OID 0)
-- Dependencies: 505
-- Name: COLUMN fsc_app.id_app; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app.id_app IS 'ID приложения';


--
-- TOC entry 8279 (class 0 OID 0)
-- Dependencies: 505
-- Name: COLUMN fsc_app.dt_create; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app.dt_create IS 'Дата создания записи';


--
-- TOC entry 8280 (class 0 OID 0)
-- Dependencies: 505
-- Name: COLUMN fsc_app.dt_update; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app.dt_update IS 'Дата обновления';


--
-- TOC entry 8281 (class 0 OID 0)
-- Dependencies: 505
-- Name: COLUMN fsc_app.dt_remove; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 8282 (class 0 OID 0)
-- Dependencies: 505
-- Name: COLUMN fsc_app.app_guid; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app.app_guid IS 'UUID приложения';


--
-- TOC entry 8283 (class 0 OID 0)
-- Dependencies: 505
-- Name: COLUMN fsc_app.secret_key; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app.secret_key IS 'Секретный ключ';


--
-- TOC entry 8284 (class 0 OID 0)
-- Dependencies: 505
-- Name: COLUMN fsc_app.nm_app; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app.nm_app IS 'Название приложеия';


--
-- TOC entry 8285 (class 0 OID 0)
-- Dependencies: 505
-- Name: COLUMN fsc_app.notification_url; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app.notification_url IS 'URL для уведомлений';


--
-- TOC entry 8286 (class 0 OID 0)
-- Dependencies: 505
-- Name: COLUMN fsc_app.provaider_key; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app.provaider_key IS 'Ключ приложения';


--
-- TOC entry 484 (class 1259 OID 1618434)
-- Name: fsc_app_fsc_provider_id_seq; Type: SEQUENCE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_6_fiscalization".fsc_app_fsc_provider_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_6_fiscalization".fsc_app_fsc_provider_id_seq OWNER TO postgres;

--
-- TOC entry 507 (class 1259 OID 1867278)
-- Name: fsc_app_fsc_provider; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_app_fsc_provider (
    id_app_fsk_provider integer DEFAULT nextval('"_OLD_6_fiscalization".fsc_app_fsc_provider_id_seq'::regclass) NOT NULL,
    id_app integer NOT NULL,
    id_fsc_provider integer NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) without time zone,
    qty_cash integer DEFAULT 0 NOT NULL,
    grp_cash character varying(50),
    nm_grp_cash character varying(150),
    app_fsc_provider_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_6_fiscalization".fsc_app_fsc_provider OWNER TO postgres;

--
-- TOC entry 8287 (class 0 OID 0)
-- Dependencies: 507
-- Name: TABLE fsc_app_fsc_provider; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_6_fiscalization".fsc_app_fsc_provider IS 'Настройки приложения';


--
-- TOC entry 8288 (class 0 OID 0)
-- Dependencies: 507
-- Name: COLUMN fsc_app_fsc_provider.id_app_fsk_provider; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app_fsc_provider.id_app_fsk_provider IS 'ID Настройки приложения';


--
-- TOC entry 8289 (class 0 OID 0)
-- Dependencies: 507
-- Name: COLUMN fsc_app_fsc_provider.id_app; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app_fsc_provider.id_app IS 'ID приложение';


--
-- TOC entry 8290 (class 0 OID 0)
-- Dependencies: 507
-- Name: COLUMN fsc_app_fsc_provider.id_fsc_provider; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app_fsc_provider.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 8291 (class 0 OID 0)
-- Dependencies: 507
-- Name: COLUMN fsc_app_fsc_provider.dt_create; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app_fsc_provider.dt_create IS 'Дата создания';


--
-- TOC entry 8292 (class 0 OID 0)
-- Dependencies: 507
-- Name: COLUMN fsc_app_fsc_provider.dt_update; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app_fsc_provider.dt_update IS 'Дата обновления';


--
-- TOC entry 8293 (class 0 OID 0)
-- Dependencies: 507
-- Name: COLUMN fsc_app_fsc_provider.qty_cash; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app_fsc_provider.qty_cash IS 'Количество касс';


--
-- TOC entry 8294 (class 0 OID 0)
-- Dependencies: 507
-- Name: COLUMN fsc_app_fsc_provider.grp_cash; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app_fsc_provider.grp_cash IS 'Группа касс';


--
-- TOC entry 8295 (class 0 OID 0)
-- Dependencies: 507
-- Name: COLUMN fsc_app_fsc_provider.nm_grp_cash; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app_fsc_provider.nm_grp_cash IS 'Наименование группы';


--
-- TOC entry 8296 (class 0 OID 0)
-- Dependencies: 507
-- Name: COLUMN fsc_app_fsc_provider.app_fsc_provider_status; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_app_fsc_provider.app_fsc_provider_status IS 'Статус';


--
-- TOC entry 482 (class 1259 OID 1618430)
-- Name: fsc_org_id_org_seq; Type: SEQUENCE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_6_fiscalization".fsc_org_id_org_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_6_fiscalization".fsc_org_id_org_seq OWNER TO postgres;

--
-- TOC entry 508 (class 1259 OID 1867289)
-- Name: fsc_org; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_org (
    id_org integer DEFAULT nextval('"_OLD_6_fiscalization".fsc_org_id_org_seq'::regclass) NOT NULL,
    dt_create timestamp(0) without time zone NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    inn character varying(12) NOT NULL,
    nm_org_name character varying(150) NOT NULL,
    default_parameters jsonb,
    org_type integer,
    org_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_6_fiscalization".fsc_org OWNER TO postgres;

--
-- TOC entry 8297 (class 0 OID 0)
-- Dependencies: 508
-- Name: TABLE fsc_org; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_6_fiscalization".fsc_org IS 'Организация';


--
-- TOC entry 8298 (class 0 OID 0)
-- Dependencies: 508
-- Name: COLUMN fsc_org.id_org; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org.id_org IS 'ID организации';


--
-- TOC entry 8299 (class 0 OID 0)
-- Dependencies: 508
-- Name: COLUMN fsc_org.dt_create; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org.dt_create IS 'Дата создания записи';


--
-- TOC entry 8300 (class 0 OID 0)
-- Dependencies: 508
-- Name: COLUMN fsc_org.dt_update; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org.dt_update IS 'Дата обновления';


--
-- TOC entry 8301 (class 0 OID 0)
-- Dependencies: 508
-- Name: COLUMN fsc_org.dt_remove; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 8302 (class 0 OID 0)
-- Dependencies: 508
-- Name: COLUMN fsc_org.inn; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org.inn IS 'ИНН';


--
-- TOC entry 8303 (class 0 OID 0)
-- Dependencies: 508
-- Name: COLUMN fsc_org.nm_org_name; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org.nm_org_name IS 'Наименование организации';


--
-- TOC entry 8304 (class 0 OID 0)
-- Dependencies: 508
-- Name: COLUMN fsc_org.default_parameters; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org.default_parameters IS 'Параметры по умолчанию';


--
-- TOC entry 8305 (class 0 OID 0)
-- Dependencies: 508
-- Name: COLUMN fsc_org.org_type; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org.org_type IS 'Тип организации';


--
-- TOC entry 8306 (class 0 OID 0)
-- Dependencies: 508
-- Name: COLUMN fsc_org.org_status; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org.org_status IS 'Статус организации';


--
-- TOC entry 486 (class 1259 OID 1618438)
-- Name: fsc_org_app_id_org_app_seq; Type: SEQUENCE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_6_fiscalization".fsc_org_app_id_org_app_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_6_fiscalization".fsc_org_app_id_org_app_seq OWNER TO postgres;

--
-- TOC entry 506 (class 1259 OID 1867268)
-- Name: fsc_org_app; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_org_app (
    id_org_app integer DEFAULT nextval('"_OLD_6_fiscalization".fsc_org_app_id_org_app_seq'::regclass) NOT NULL,
    id_app integer NOT NULL,
    id_org integer NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    org_app_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_6_fiscalization".fsc_org_app OWNER TO postgres;

--
-- TOC entry 8307 (class 0 OID 0)
-- Dependencies: 506
-- Name: TABLE fsc_org_app; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_6_fiscalization".fsc_org_app IS 'Приложения организации';


--
-- TOC entry 8308 (class 0 OID 0)
-- Dependencies: 506
-- Name: COLUMN fsc_org_app.id_org_app; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org_app.id_org_app IS 'ID приложения организации';


--
-- TOC entry 8309 (class 0 OID 0)
-- Dependencies: 506
-- Name: COLUMN fsc_org_app.id_app; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org_app.id_app IS 'ID приложение';


--
-- TOC entry 8310 (class 0 OID 0)
-- Dependencies: 506
-- Name: COLUMN fsc_org_app.id_org; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org_app.id_org IS 'ID Организации';


--
-- TOC entry 8311 (class 0 OID 0)
-- Dependencies: 506
-- Name: COLUMN fsc_org_app.dt_create; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org_app.dt_create IS 'Дата создания';


--
-- TOC entry 8312 (class 0 OID 0)
-- Dependencies: 506
-- Name: COLUMN fsc_org_app.org_app_status; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_org_app.org_app_status IS 'Статус';


--
-- TOC entry 485 (class 1259 OID 1618436)
-- Name: fsc_provider_id_seq; Type: SEQUENCE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_6_fiscalization".fsc_provider_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_6_fiscalization".fsc_provider_id_seq OWNER TO postgres;

--
-- TOC entry 509 (class 1259 OID 1867299)
-- Name: fsc_provider; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_provider (
    id_fsc_provider integer DEFAULT nextval('"_OLD_6_fiscalization".fsc_provider_id_seq'::regclass) NOT NULL,
    nm_fsc_provider character varying(150) NOT NULL,
    kd_fsc_provider character varying(20) NOT NULL,
    fsc_url text,
    fsc_port character varying(5),
    fsc_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_6_fiscalization".fsc_provider OWNER TO postgres;

--
-- TOC entry 8313 (class 0 OID 0)
-- Dependencies: 509
-- Name: TABLE fsc_provider; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_6_fiscalization".fsc_provider IS 'Фискальный провайдер';


--
-- TOC entry 8314 (class 0 OID 0)
-- Dependencies: 509
-- Name: COLUMN fsc_provider.id_fsc_provider; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_provider.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 8315 (class 0 OID 0)
-- Dependencies: 509
-- Name: COLUMN fsc_provider.nm_fsc_provider; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_provider.nm_fsc_provider IS 'Наименование';


--
-- TOC entry 8316 (class 0 OID 0)
-- Dependencies: 509
-- Name: COLUMN fsc_provider.kd_fsc_provider; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_provider.kd_fsc_provider IS 'Системный код';


--
-- TOC entry 8317 (class 0 OID 0)
-- Dependencies: 509
-- Name: COLUMN fsc_provider.fsc_url; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_provider.fsc_url IS 'URL фискального провайдера';


--
-- TOC entry 8318 (class 0 OID 0)
-- Dependencies: 509
-- Name: COLUMN fsc_provider.fsc_port; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_provider.fsc_port IS 'Порт';


--
-- TOC entry 8319 (class 0 OID 0)
-- Dependencies: 509
-- Name: COLUMN fsc_provider.fsc_status; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_provider.fsc_status IS 'Статус';


--
-- TOC entry 483 (class 1259 OID 1618432)
-- Name: fsc_receipt_id_receipt_seq; Type: SEQUENCE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_6_fiscalization".fsc_receipt_id_receipt_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_id_receipt_seq OWNER TO postgres;

--
-- TOC entry 487 (class 1259 OID 1618813)
-- Name: fsc_receipt; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL
)
PARTITION BY LIST (rcp_status);


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt OWNER TO postgres;

--
-- TOC entry 8320 (class 0 OID 0)
-- Dependencies: 487
-- Name: TABLE fsc_receipt; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_6_fiscalization".fsc_receipt IS 'Чек';


--
-- TOC entry 8321 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.id_receipt; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.id_receipt IS 'ID Чека';


--
-- TOC entry 8322 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.dt_create; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.dt_create IS 'Дата создания';


--
-- TOC entry 8323 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.rcp_status; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.rcp_status IS 'Статус чека';


--
-- TOC entry 8324 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.dt_update; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.dt_update IS 'Дата обновления';


--
-- TOC entry 8325 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.inn; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.inn IS 'ИНН';


--
-- TOC entry 8326 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.rcp_nmb; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.rcp_nmb IS 'Номер чека';


--
-- TOC entry 8327 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.rcp_contact; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.rcp_contact IS 'Контактная информация';


--
-- TOC entry 8328 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.rcp_fp; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.rcp_fp IS 'Номер ФН';


--
-- TOC entry 8329 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.dt_fp; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.dt_fp IS 'Дата фискализапции';


--
-- TOC entry 8330 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.id_org; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.id_org IS 'ID Организации';


--
-- TOC entry 8331 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.id_app; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.id_app IS 'ID Приложения';


--
-- TOC entry 8332 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.rcp_status_descr; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.rcp_status_descr IS 'Описание статуса';


--
-- TOC entry 8333 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.rcp_amount; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.rcp_amount IS 'Сумма';


--
-- TOC entry 8334 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.rcp_order; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.rcp_order IS 'Запрос на фискализацию';


--
-- TOC entry 8335 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.rcp_receipt; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.rcp_receipt IS 'Результат фискализации';


--
-- TOC entry 8336 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.rcp_correction; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.rcp_correction IS 'Тип (чек корреции/кассовый чек)';


--
-- TOC entry 8337 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.rcp_received; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.rcp_received IS 'Чек принят';


--
-- TOC entry 8338 (class 0 OID 0)
-- Dependencies: 487
-- Name: COLUMN fsc_receipt.rcp_notify_send; Type: COMMENT; Schema: _OLD_6_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_6_fiscalization".fsc_receipt.rcp_notify_send IS 'Извещение отослано';


--
-- TOC entry 488 (class 1259 OID 1618823)
-- Name: fsc_receipt_0; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_0 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_0 CHECK ((rcp_status = 0))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_0 FOR VALUES IN (0);


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_0 OWNER TO postgres;

--
-- TOC entry 489 (class 1259 OID 1618837)
-- Name: fsc_receipt_1; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_1 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_1 CHECK ((rcp_status = 1))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_1 FOR VALUES IN (1);


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_1 OWNER TO postgres;

--
-- TOC entry 492 (class 1259 OID 1618878)
-- Name: fsc_receipt_2; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_2 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2))
)
PARTITION BY RANGE (dt_create);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2 FOR VALUES IN (2);


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_2 OWNER TO postgres;

--
-- TOC entry 493 (class 1259 OID 1618889)
-- Name: fsc_receipt_2_2021_01; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_01 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_01 CHECK (((dt_create >= '2021-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-02-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_01 FOR VALUES FROM ('2021-01-01 00:00:00+03') TO ('2021-02-01 00:00:00+03');


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_01 OWNER TO postgres;

--
-- TOC entry 494 (class 1259 OID 1618904)
-- Name: fsc_receipt_2_2021_02; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_02 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_02 CHECK (((dt_create >= '2021-02-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-03-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_02 FOR VALUES FROM ('2021-02-01 00:00:00+03') TO ('2021-03-01 00:00:00+03');


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_02 OWNER TO postgres;

--
-- TOC entry 495 (class 1259 OID 1618919)
-- Name: fsc_receipt_2_2021_03; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_03 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_03 CHECK (((dt_create >= '2021-03-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-04-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_03 FOR VALUES FROM ('2021-03-01 00:00:00+03') TO ('2021-04-01 00:00:00+03');


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_03 OWNER TO postgres;

--
-- TOC entry 496 (class 1259 OID 1618934)
-- Name: fsc_receipt_2_2021_04; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_04 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_04 CHECK (((dt_create >= '2021-04-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-05-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_04 FOR VALUES FROM ('2021-04-01 00:00:00+03') TO ('2021-05-01 00:00:00+03');


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_04 OWNER TO postgres;

--
-- TOC entry 497 (class 1259 OID 1618949)
-- Name: fsc_receipt_2_2021_05; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_05 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_05 CHECK (((dt_create >= '2021-05-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-06-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_05 FOR VALUES FROM ('2021-05-01 00:00:00+03') TO ('2021-06-01 00:00:00+03');


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_05 OWNER TO postgres;

--
-- TOC entry 498 (class 1259 OID 1618964)
-- Name: fsc_receipt_2_2021_06; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_06 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_06 CHECK (((dt_create >= '2021-06-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-07-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_06 FOR VALUES FROM ('2021-06-01 00:00:00+03') TO ('2021-07-01 00:00:00+03');


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_06 OWNER TO postgres;

--
-- TOC entry 499 (class 1259 OID 1618979)
-- Name: fsc_receipt_2_2021_07; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_07 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_07 CHECK (((dt_create >= '2021-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-08-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_07 FOR VALUES FROM ('2021-07-01 00:00:00+03') TO ('2021-08-01 00:00:00+03');


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_07 OWNER TO postgres;

--
-- TOC entry 500 (class 1259 OID 1618994)
-- Name: fsc_receipt_2_2021_08; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_08 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_08 CHECK (((dt_create >= '2021-08-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-09-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_08 FOR VALUES FROM ('2021-08-01 00:00:00+03') TO ('2021-09-01 00:00:00+03');


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_08 OWNER TO postgres;

--
-- TOC entry 501 (class 1259 OID 1619009)
-- Name: fsc_receipt_2_2021_09; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_09 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_09 CHECK (((dt_create >= '2021-09-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-10-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_09 FOR VALUES FROM ('2021-09-01 00:00:00+03') TO ('2021-10-01 00:00:00+03');


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_09 OWNER TO postgres;

--
-- TOC entry 502 (class 1259 OID 1619024)
-- Name: fsc_receipt_2_2021_10; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_10 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_10 CHECK (((dt_create >= '2021-10-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-11-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_10 FOR VALUES FROM ('2021-10-01 00:00:00+03') TO ('2021-11-01 00:00:00+03');


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_10 OWNER TO postgres;

--
-- TOC entry 503 (class 1259 OID 1619039)
-- Name: fsc_receipt_2_2021_11; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_11 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_11 CHECK (((dt_create >= '2021-11-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-12-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_11 FOR VALUES FROM ('2021-11-01 00:00:00+03') TO ('2021-12-01 00:00:00+03');


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_11 OWNER TO postgres;

--
-- TOC entry 504 (class 1259 OID 1619054)
-- Name: fsc_receipt_2_2021_12; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_12 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_12 CHECK (((dt_create >= '2021-12-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2022-01-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_12 FOR VALUES FROM ('2021-12-01 00:00:00+03') TO ('2022-01-01 00:00:00+03');


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_2_2021_12 OWNER TO postgres;

--
-- TOC entry 490 (class 1259 OID 1618851)
-- Name: fsc_receipt_345; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_345 (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_345 CHECK ((rcp_status = ANY (ARRAY[3, 4, 5])))
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_345 FOR VALUES IN (3, 4, 5);


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_345 OWNER TO postgres;

--
-- TOC entry 491 (class 1259 OID 1618865)
-- Name: fsc_receipt_default; Type: TABLE; Schema: _OLD_6_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_6_fiscalization".fsc_receipt_default (
    id_receipt bigint DEFAULT nextval('"_OLD_6_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org integer,
    id_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL
);
ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_default DEFAULT;


ALTER TABLE "_OLD_6_fiscalization".fsc_receipt_default OWNER TO postgres;

--
-- TOC entry 510 (class 1259 OID 1867311)
-- Name: fsc_app_id_app_seq; Type: SEQUENCE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_7_fiscalization".fsc_app_id_app_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_7_fiscalization".fsc_app_id_app_seq OWNER TO postgres;

--
-- TOC entry 535 (class 1259 OID 1867707)
-- Name: fsc_app; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_app (
    id_app integer DEFAULT nextval('"_OLD_7_fiscalization".fsc_app_id_app_seq'::regclass) NOT NULL,
    dt_create timestamp(0) without time zone NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    app_guid uuid,
    secret_key text NOT NULL,
    nm_app text NOT NULL,
    notification_url text,
    provaider_key text
);


ALTER TABLE "_OLD_7_fiscalization".fsc_app OWNER TO postgres;

--
-- TOC entry 8339 (class 0 OID 0)
-- Dependencies: 535
-- Name: TABLE fsc_app; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_app IS 'Приложение';


--
-- TOC entry 8340 (class 0 OID 0)
-- Dependencies: 535
-- Name: COLUMN fsc_app.id_app; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_app.id_app IS 'ID приложения';


--
-- TOC entry 8341 (class 0 OID 0)
-- Dependencies: 535
-- Name: COLUMN fsc_app.dt_create; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_app.dt_create IS 'Дата создания записи';


--
-- TOC entry 8342 (class 0 OID 0)
-- Dependencies: 535
-- Name: COLUMN fsc_app.dt_update; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_app.dt_update IS 'Дата обновления';


--
-- TOC entry 8343 (class 0 OID 0)
-- Dependencies: 535
-- Name: COLUMN fsc_app.dt_remove; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_app.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 8344 (class 0 OID 0)
-- Dependencies: 535
-- Name: COLUMN fsc_app.app_guid; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_app.app_guid IS 'UUID приложения';


--
-- TOC entry 8345 (class 0 OID 0)
-- Dependencies: 535
-- Name: COLUMN fsc_app.secret_key; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_app.secret_key IS 'Секретный ключ';


--
-- TOC entry 8346 (class 0 OID 0)
-- Dependencies: 535
-- Name: COLUMN fsc_app.nm_app; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_app.nm_app IS 'Название приложеия';


--
-- TOC entry 8347 (class 0 OID 0)
-- Dependencies: 535
-- Name: COLUMN fsc_app.notification_url; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_app.notification_url IS 'URL для уведомлений';


--
-- TOC entry 8348 (class 0 OID 0)
-- Dependencies: 535
-- Name: COLUMN fsc_app.provaider_key; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_app.provaider_key IS 'Ключ провайдера';


--
-- TOC entry 511 (class 1259 OID 1867313)
-- Name: fsc_org_id_org_seq; Type: SEQUENCE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_7_fiscalization".fsc_org_id_org_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_7_fiscalization".fsc_org_id_org_seq OWNER TO postgres;

--
-- TOC entry 538 (class 1259 OID 1867739)
-- Name: fsc_org; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_org (
    id_org integer DEFAULT nextval('"_OLD_7_fiscalization".fsc_org_id_org_seq'::regclass) NOT NULL,
    dt_create timestamp(0) without time zone NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    inn character varying(12) NOT NULL,
    nm_org_name character varying(150) NOT NULL,
    org_type integer,
    org_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_7_fiscalization".fsc_org OWNER TO postgres;

--
-- TOC entry 8349 (class 0 OID 0)
-- Dependencies: 538
-- Name: TABLE fsc_org; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_org IS 'Организация';


--
-- TOC entry 8350 (class 0 OID 0)
-- Dependencies: 538
-- Name: COLUMN fsc_org.id_org; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org.id_org IS 'ID организации';


--
-- TOC entry 8351 (class 0 OID 0)
-- Dependencies: 538
-- Name: COLUMN fsc_org.dt_create; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org.dt_create IS 'Дата создания записи';


--
-- TOC entry 8352 (class 0 OID 0)
-- Dependencies: 538
-- Name: COLUMN fsc_org.dt_update; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org.dt_update IS 'Дата обновления';


--
-- TOC entry 8353 (class 0 OID 0)
-- Dependencies: 538
-- Name: COLUMN fsc_org.dt_remove; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 8354 (class 0 OID 0)
-- Dependencies: 538
-- Name: COLUMN fsc_org.inn; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org.inn IS 'ИНН';


--
-- TOC entry 8355 (class 0 OID 0)
-- Dependencies: 538
-- Name: COLUMN fsc_org.nm_org_name; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org.nm_org_name IS 'Наименование организации';


--
-- TOC entry 8356 (class 0 OID 0)
-- Dependencies: 538
-- Name: COLUMN fsc_org.org_type; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org.org_type IS 'Тип организации';


--
-- TOC entry 8357 (class 0 OID 0)
-- Dependencies: 538
-- Name: COLUMN fsc_org.org_status; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org.org_status IS 'Статус организации';


--
-- TOC entry 532 (class 1259 OID 1867584)
-- Name: fsc_org_app_id_org_app_seq; Type: SEQUENCE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_7_fiscalization".fsc_org_app_id_org_app_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_7_fiscalization".fsc_org_app_id_org_app_seq OWNER TO postgres;

--
-- TOC entry 536 (class 1259 OID 1867716)
-- Name: fsc_org_app; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_org_app (
    id_org_app integer DEFAULT nextval('"_OLD_7_fiscalization".fsc_org_app_id_org_app_seq'::regclass) NOT NULL,
    id_app integer NOT NULL,
    id_org integer NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    org_app_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_7_fiscalization".fsc_org_app OWNER TO postgres;

--
-- TOC entry 8358 (class 0 OID 0)
-- Dependencies: 536
-- Name: TABLE fsc_org_app; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_org_app IS 'Приложения организации';


--
-- TOC entry 8359 (class 0 OID 0)
-- Dependencies: 536
-- Name: COLUMN fsc_org_app.id_org_app; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_app.id_org_app IS 'ID приложения организации';


--
-- TOC entry 8360 (class 0 OID 0)
-- Dependencies: 536
-- Name: COLUMN fsc_org_app.id_app; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_app.id_app IS 'ID приложение';


--
-- TOC entry 8361 (class 0 OID 0)
-- Dependencies: 536
-- Name: COLUMN fsc_org_app.id_org; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_app.id_org IS 'ID Организации';


--
-- TOC entry 8362 (class 0 OID 0)
-- Dependencies: 536
-- Name: COLUMN fsc_org_app.dt_create; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_app.dt_create IS 'Дата создания';


--
-- TOC entry 8363 (class 0 OID 0)
-- Dependencies: 536
-- Name: COLUMN fsc_org_app.org_app_status; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_app.org_app_status IS 'Статус';


--
-- TOC entry 534 (class 1259 OID 1867614)
-- Name: fsc_org_app_param_id_seq; Type: SEQUENCE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_7_fiscalization".fsc_org_app_param_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_7_fiscalization".fsc_org_app_param_id_seq OWNER TO postgres;

--
-- TOC entry 537 (class 1259 OID 1867726)
-- Name: fsc_org_app_param; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_org_app_param (
    id_org_app_param integer DEFAULT nextval('"_OLD_7_fiscalization".fsc_org_app_param_id_seq'::regclass) NOT NULL,
    id_org_app integer NOT NULL,
    id_fsc_provider integer NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) without time zone,
    org_app_params jsonb,
    org_app_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_7_fiscalization".fsc_org_app_param OWNER TO postgres;

--
-- TOC entry 8364 (class 0 OID 0)
-- Dependencies: 537
-- Name: TABLE fsc_org_app_param; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_org_app_param IS 'Настройки приложения для организации';


--
-- TOC entry 8365 (class 0 OID 0)
-- Dependencies: 537
-- Name: COLUMN fsc_org_app_param.id_org_app_param; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_app_param.id_org_app_param IS 'ID Настройки приложения для организации';


--
-- TOC entry 8366 (class 0 OID 0)
-- Dependencies: 537
-- Name: COLUMN fsc_org_app_param.id_org_app; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_app_param.id_org_app IS 'ID Приложения Организации';


--
-- TOC entry 8367 (class 0 OID 0)
-- Dependencies: 537
-- Name: COLUMN fsc_org_app_param.id_fsc_provider; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_app_param.id_fsc_provider IS 'ID провайдера фискализации';


--
-- TOC entry 8368 (class 0 OID 0)
-- Dependencies: 537
-- Name: COLUMN fsc_org_app_param.dt_create; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_app_param.dt_create IS 'Дата создания';


--
-- TOC entry 8369 (class 0 OID 0)
-- Dependencies: 537
-- Name: COLUMN fsc_org_app_param.dt_update; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_app_param.dt_update IS 'Дата обновления';


--
-- TOC entry 8370 (class 0 OID 0)
-- Dependencies: 537
-- Name: COLUMN fsc_org_app_param.org_app_params; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_app_param.org_app_params IS 'Параметры настройки';


--
-- TOC entry 8371 (class 0 OID 0)
-- Dependencies: 537
-- Name: COLUMN fsc_org_app_param.org_app_status; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_app_param.org_app_status IS 'Статус настройки';


--
-- TOC entry 533 (class 1259 OID 1867588)
-- Name: fsc_org_cash_id_seq; Type: SEQUENCE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_7_fiscalization".fsc_org_cash_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_7_fiscalization".fsc_org_cash_id_seq OWNER TO postgres;

--
-- TOC entry 540 (class 1259 OID 1867759)
-- Name: fsc_org_cash; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_org_cash (
    id_org_cash integer DEFAULT nextval('"_OLD_7_fiscalization".fsc_org_cash_id_seq'::regclass) NOT NULL,
    id_fsc_provider integer NOT NULL,
    id_org integer NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) without time zone,
    qty_cash integer DEFAULT 0 NOT NULL,
    grp_cash character varying(50),
    nm_grp_cash character varying(150),
    org_cash_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_7_fiscalization".fsc_org_cash OWNER TO postgres;

--
-- TOC entry 8372 (class 0 OID 0)
-- Dependencies: 540
-- Name: TABLE fsc_org_cash; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_org_cash IS 'Настройки касс для организаций';


--
-- TOC entry 8373 (class 0 OID 0)
-- Dependencies: 540
-- Name: COLUMN fsc_org_cash.id_org_cash; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_cash.id_org_cash IS 'ID настройки';


--
-- TOC entry 8374 (class 0 OID 0)
-- Dependencies: 540
-- Name: COLUMN fsc_org_cash.id_fsc_provider; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_cash.id_fsc_provider IS 'ID провайдера фискализации';


--
-- TOC entry 8375 (class 0 OID 0)
-- Dependencies: 540
-- Name: COLUMN fsc_org_cash.id_org; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_cash.id_org IS 'ID Организации';


--
-- TOC entry 8376 (class 0 OID 0)
-- Dependencies: 540
-- Name: COLUMN fsc_org_cash.dt_create; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_cash.dt_create IS 'Дата создания';


--
-- TOC entry 8377 (class 0 OID 0)
-- Dependencies: 540
-- Name: COLUMN fsc_org_cash.dt_update; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_cash.dt_update IS 'Дата обновления';


--
-- TOC entry 8378 (class 0 OID 0)
-- Dependencies: 540
-- Name: COLUMN fsc_org_cash.qty_cash; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_cash.qty_cash IS 'Количество касс';


--
-- TOC entry 8379 (class 0 OID 0)
-- Dependencies: 540
-- Name: COLUMN fsc_org_cash.grp_cash; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_cash.grp_cash IS 'Группа касс';


--
-- TOC entry 8380 (class 0 OID 0)
-- Dependencies: 540
-- Name: COLUMN fsc_org_cash.nm_grp_cash; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_cash.nm_grp_cash IS 'Наименование группы касс';


--
-- TOC entry 8381 (class 0 OID 0)
-- Dependencies: 540
-- Name: COLUMN fsc_org_cash.org_cash_status; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_org_cash.org_cash_status IS 'Статус настройки касс';


--
-- TOC entry 513 (class 1259 OID 1867319)
-- Name: fsc_provider_id_seq; Type: SEQUENCE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_7_fiscalization".fsc_provider_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_7_fiscalization".fsc_provider_id_seq OWNER TO postgres;

--
-- TOC entry 539 (class 1259 OID 1867749)
-- Name: fsc_provider; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_provider (
    id_fsc_provider integer DEFAULT nextval('"_OLD_7_fiscalization".fsc_provider_id_seq'::regclass) NOT NULL,
    nm_fsc_provider character varying(150) NOT NULL,
    kd_fsc_provider character varying(20) NOT NULL,
    fsc_url text,
    fsc_port character varying(5),
    fsc_status boolean DEFAULT true NOT NULL
);


ALTER TABLE "_OLD_7_fiscalization".fsc_provider OWNER TO postgres;

--
-- TOC entry 8382 (class 0 OID 0)
-- Dependencies: 539
-- Name: TABLE fsc_provider; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_provider IS 'Фискальный провайдер';


--
-- TOC entry 8383 (class 0 OID 0)
-- Dependencies: 539
-- Name: COLUMN fsc_provider.id_fsc_provider; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_provider.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 8384 (class 0 OID 0)
-- Dependencies: 539
-- Name: COLUMN fsc_provider.nm_fsc_provider; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_provider.nm_fsc_provider IS 'Наименование';


--
-- TOC entry 8385 (class 0 OID 0)
-- Dependencies: 539
-- Name: COLUMN fsc_provider.kd_fsc_provider; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_provider.kd_fsc_provider IS 'Системный код';


--
-- TOC entry 8386 (class 0 OID 0)
-- Dependencies: 539
-- Name: COLUMN fsc_provider.fsc_url; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_provider.fsc_url IS 'URL фискального провайдера';


--
-- TOC entry 8387 (class 0 OID 0)
-- Dependencies: 539
-- Name: COLUMN fsc_provider.fsc_port; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_provider.fsc_port IS 'Порт';


--
-- TOC entry 8388 (class 0 OID 0)
-- Dependencies: 539
-- Name: COLUMN fsc_provider.fsc_status; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_provider.fsc_status IS 'Статус';


--
-- TOC entry 512 (class 1259 OID 1867315)
-- Name: fsc_receipt_id_receipt_seq; Type: SEQUENCE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE SEQUENCE "_OLD_7_fiscalization".fsc_receipt_id_receipt_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_id_receipt_seq OWNER TO postgres;

--
-- TOC entry 514 (class 1259 OID 1867323)
-- Name: fsc_receipt; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL
)
PARTITION BY LIST (rcp_status);


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt OWNER TO postgres;

--
-- TOC entry 8389 (class 0 OID 0)
-- Dependencies: 514
-- Name: TABLE fsc_receipt; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt IS 'Чек';


--
-- TOC entry 8390 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.id_receipt; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.id_receipt IS 'ID Чека';


--
-- TOC entry 8391 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.dt_create; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.dt_create IS 'Дата создания';


--
-- TOC entry 8392 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.rcp_status; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.rcp_status IS 'Статус чека';


--
-- TOC entry 8393 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.dt_update; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.dt_update IS 'Дата обновления';


--
-- TOC entry 8394 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.inn; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.inn IS 'ИНН';


--
-- TOC entry 8395 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.rcp_nmb; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.rcp_nmb IS 'Номер чека';


--
-- TOC entry 8396 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.rcp_contact; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.rcp_contact IS 'Контактная информация';


--
-- TOC entry 8397 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.rcp_fp; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.rcp_fp IS 'Номер ФН';


--
-- TOC entry 8398 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.dt_fp; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.dt_fp IS 'Дата фискализапции';


--
-- TOC entry 8399 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.id_org_app; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.id_org_app IS 'ID пары Организация-Приложение';


--
-- TOC entry 8400 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.rcp_status_descr; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.rcp_status_descr IS 'Описание статуса';


--
-- TOC entry 8401 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.rcp_amount; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.rcp_amount IS 'Сумма';


--
-- TOC entry 8402 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.rcp_order; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.rcp_order IS 'Запрос на фискализацию';


--
-- TOC entry 8403 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.rcp_receipt; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.rcp_receipt IS 'Результат фискализации';


--
-- TOC entry 8404 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.rcp_correction; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.rcp_correction IS 'Тип (чек корреции/кассовый чек)';


--
-- TOC entry 8405 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.rcp_received; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.rcp_received IS 'Чек принят';


--
-- TOC entry 8406 (class 0 OID 0)
-- Dependencies: 514
-- Name: COLUMN fsc_receipt.rcp_notify_send; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON COLUMN "_OLD_7_fiscalization".fsc_receipt.rcp_notify_send IS 'Извещение отослано';


--
-- TOC entry 515 (class 1259 OID 1867333)
-- Name: fsc_receipt_0; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_0 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_0 CHECK ((rcp_status = 0))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_0 FOR VALUES IN (0);


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_0 OWNER TO postgres;

--
-- TOC entry 8407 (class 0 OID 0)
-- Dependencies: 515
-- Name: TABLE fsc_receipt_0; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_0 IS 'Запрос на фискализацию';


--
-- TOC entry 516 (class 1259 OID 1867347)
-- Name: fsc_receipt_1; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_1 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_1 CHECK ((rcp_status = 1))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_1 FOR VALUES IN (1);


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_1 OWNER TO postgres;

--
-- TOC entry 8408 (class 0 OID 0)
-- Dependencies: 516
-- Name: TABLE fsc_receipt_1; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_1 IS 'Отправлено на фискализацию';


--
-- TOC entry 519 (class 1259 OID 1867388)
-- Name: fsc_receipt_2; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_2 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2))
)
PARTITION BY RANGE (dt_create);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2 FOR VALUES IN (2);


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_2 OWNER TO postgres;

--
-- TOC entry 8409 (class 0 OID 0)
-- Dependencies: 519
-- Name: TABLE fsc_receipt_2; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_2 IS 'Результаты фискализации';


--
-- TOC entry 520 (class 1259 OID 1867399)
-- Name: fsc_receipt_2_2021_01; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_01 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_01 CHECK (((dt_create >= '2021-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-02-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_01 FOR VALUES FROM ('2021-01-01 00:00:00+03') TO ('2021-02-01 00:00:00+03');


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_01 OWNER TO postgres;

--
-- TOC entry 8410 (class 0 OID 0)
-- Dependencies: 520
-- Name: TABLE fsc_receipt_2_2021_01; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_01 IS 'Результаты фискализации. 2021_01';


--
-- TOC entry 521 (class 1259 OID 1867414)
-- Name: fsc_receipt_2_2021_02; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_02 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_02 CHECK (((dt_create >= '2021-02-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-03-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_02 FOR VALUES FROM ('2021-02-01 00:00:00+03') TO ('2021-03-01 00:00:00+03');


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_02 OWNER TO postgres;

--
-- TOC entry 8411 (class 0 OID 0)
-- Dependencies: 521
-- Name: TABLE fsc_receipt_2_2021_02; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_02 IS 'Результаты фискализации. 2021_02';


--
-- TOC entry 522 (class 1259 OID 1867429)
-- Name: fsc_receipt_2_2021_03; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_03 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_03 CHECK (((dt_create >= '2021-03-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-04-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_03 FOR VALUES FROM ('2021-03-01 00:00:00+03') TO ('2021-04-01 00:00:00+03');


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_03 OWNER TO postgres;

--
-- TOC entry 8412 (class 0 OID 0)
-- Dependencies: 522
-- Name: TABLE fsc_receipt_2_2021_03; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_03 IS 'Результаты фискализации. 2021_03';


--
-- TOC entry 523 (class 1259 OID 1867444)
-- Name: fsc_receipt_2_2021_04; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_04 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_04 CHECK (((dt_create >= '2021-04-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-05-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_04 FOR VALUES FROM ('2021-04-01 00:00:00+03') TO ('2021-05-01 00:00:00+03');


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_04 OWNER TO postgres;

--
-- TOC entry 8413 (class 0 OID 0)
-- Dependencies: 523
-- Name: TABLE fsc_receipt_2_2021_04; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_04 IS 'Результаты фискализации. 2021_04';


--
-- TOC entry 524 (class 1259 OID 1867459)
-- Name: fsc_receipt_2_2021_05; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_05 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_05 CHECK (((dt_create >= '2021-05-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-06-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_05 FOR VALUES FROM ('2021-05-01 00:00:00+03') TO ('2021-06-01 00:00:00+03');


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_05 OWNER TO postgres;

--
-- TOC entry 8414 (class 0 OID 0)
-- Dependencies: 524
-- Name: TABLE fsc_receipt_2_2021_05; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_05 IS 'Результаты фискализации. 2021_05';


--
-- TOC entry 525 (class 1259 OID 1867474)
-- Name: fsc_receipt_2_2021_06; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_06 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_06 CHECK (((dt_create >= '2021-06-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-07-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_06 FOR VALUES FROM ('2021-06-01 00:00:00+03') TO ('2021-07-01 00:00:00+03');


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_06 OWNER TO postgres;

--
-- TOC entry 8415 (class 0 OID 0)
-- Dependencies: 525
-- Name: TABLE fsc_receipt_2_2021_06; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_06 IS 'Результаты фискализации. 2021_06';


--
-- TOC entry 526 (class 1259 OID 1867489)
-- Name: fsc_receipt_2_2021_07; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_07 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_07 CHECK (((dt_create >= '2021-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-08-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_07 FOR VALUES FROM ('2021-07-01 00:00:00+03') TO ('2021-08-01 00:00:00+03');


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_07 OWNER TO postgres;

--
-- TOC entry 8416 (class 0 OID 0)
-- Dependencies: 526
-- Name: TABLE fsc_receipt_2_2021_07; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_07 IS 'Результаты фискализации. 2021_07';


--
-- TOC entry 527 (class 1259 OID 1867504)
-- Name: fsc_receipt_2_2021_08; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_08 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_08 CHECK (((dt_create >= '2021-08-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-09-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_08 FOR VALUES FROM ('2021-08-01 00:00:00+03') TO ('2021-09-01 00:00:00+03');


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_08 OWNER TO postgres;

--
-- TOC entry 8417 (class 0 OID 0)
-- Dependencies: 527
-- Name: TABLE fsc_receipt_2_2021_08; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_08 IS 'Результаты фискализации. 2021_08';


--
-- TOC entry 528 (class 1259 OID 1867519)
-- Name: fsc_receipt_2_2021_09; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_09 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_09 CHECK (((dt_create >= '2021-09-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-10-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_09 FOR VALUES FROM ('2021-09-01 00:00:00+03') TO ('2021-10-01 00:00:00+03');


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_09 OWNER TO postgres;

--
-- TOC entry 8418 (class 0 OID 0)
-- Dependencies: 528
-- Name: TABLE fsc_receipt_2_2021_09; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_09 IS 'Результаты фискализации. 2021_09';


--
-- TOC entry 529 (class 1259 OID 1867534)
-- Name: fsc_receipt_2_2021_10; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_10 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_10 CHECK (((dt_create >= '2021-10-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-11-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_10 FOR VALUES FROM ('2021-10-01 00:00:00+03') TO ('2021-11-01 00:00:00+03');


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_10 OWNER TO postgres;

--
-- TOC entry 8419 (class 0 OID 0)
-- Dependencies: 529
-- Name: TABLE fsc_receipt_2_2021_10; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_10 IS 'Результаты фискализации. 2021_10';


--
-- TOC entry 530 (class 1259 OID 1867549)
-- Name: fsc_receipt_2_2021_11; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_11 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_11 CHECK (((dt_create >= '2021-11-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-12-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_11 FOR VALUES FROM ('2021-11-01 00:00:00+03') TO ('2021-12-01 00:00:00+03');


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_11 OWNER TO postgres;

--
-- TOC entry 8420 (class 0 OID 0)
-- Dependencies: 530
-- Name: TABLE fsc_receipt_2_2021_11; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_11 IS 'Результаты фискализации. 2021_11';


--
-- TOC entry 531 (class 1259 OID 1867564)
-- Name: fsc_receipt_2_2021_12; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_12 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_12 CHECK (((dt_create >= '2021-12-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2022-01-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2 ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_12 FOR VALUES FROM ('2021-12-01 00:00:00+03') TO ('2022-01-01 00:00:00+03');


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_12 OWNER TO postgres;

--
-- TOC entry 8421 (class 0 OID 0)
-- Dependencies: 531
-- Name: TABLE fsc_receipt_2_2021_12; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_2_2021_12 IS 'Результаты фискализации. 2021_12';


--
-- TOC entry 517 (class 1259 OID 1867361)
-- Name: fsc_receipt_345; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_345 (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_345 CHECK ((rcp_status = ANY (ARRAY[3, 4, 5])))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_345 FOR VALUES IN (3, 4, 5);


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_345 OWNER TO postgres;

--
-- TOC entry 8422 (class 0 OID 0)
-- Dependencies: 517
-- Name: TABLE fsc_receipt_345; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_345 IS 'Ошибки фискализации';


--
-- TOC entry 518 (class 1259 OID 1867375)
-- Name: fsc_receipt_default; Type: TABLE; Schema: _OLD_7_fiscalization; Owner: postgres
--

CREATE TABLE "_OLD_7_fiscalization".fsc_receipt_default (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_default DEFAULT;


ALTER TABLE "_OLD_7_fiscalization".fsc_receipt_default OWNER TO postgres;

--
-- TOC entry 8423 (class 0 OID 0)
-- Dependencies: 518
-- Name: TABLE fsc_receipt_default; Type: COMMENT; Schema: _OLD_7_fiscalization; Owner: postgres
--

COMMENT ON TABLE "_OLD_7_fiscalization".fsc_receipt_default IS 'Неклассифицированные данные фискализации';


--
-- TOC entry 333 (class 1259 OID 1512253)
-- Name: d_base; Type: TABLE; Schema: dict; Owner: postgres
--

CREATE TABLE dict.d_base (
    id_dict integer NOT NULL,
    id_dict_entity integer NOT NULL,
    is_remove boolean DEFAULT false NOT NULL,
    dt_update timestamp(0) without time zone,
    kd_dict text,
    nm_dict text
);


ALTER TABLE dict.d_base OWNER TO postgres;

--
-- TOC entry 8424 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE d_base; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON TABLE dict.d_base IS 'Справочники, базовая структура';


--
-- TOC entry 8425 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN d_base.id_dict; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.d_base.id_dict IS 'ID записи справочника';


--
-- TOC entry 8426 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN d_base.id_dict_entity; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.d_base.id_dict_entity IS 'ID записи из перечня справочников';


--
-- TOC entry 8427 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN d_base.is_remove; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.d_base.is_remove IS 'Признак логического удаления';


--
-- TOC entry 8428 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN d_base.dt_update; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.d_base.dt_update IS 'Дата обовления';


--
-- TOC entry 8429 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN d_base.kd_dict; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.d_base.kd_dict IS 'Код записи';


--
-- TOC entry 8430 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN d_base.nm_dict; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.d_base.nm_dict IS 'Наименование записи';


--
-- TOC entry 332 (class 1259 OID 1512251)
-- Name: d_base_id_dict_seq; Type: SEQUENCE; Schema: dict; Owner: postgres
--

CREATE SEQUENCE dict.d_base_id_dict_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dict.d_base_id_dict_seq OWNER TO postgres;

--
-- TOC entry 8431 (class 0 OID 0)
-- Dependencies: 332
-- Name: d_base_id_dict_seq; Type: SEQUENCE OWNED BY; Schema: dict; Owner: postgres
--

ALTER SEQUENCE dict.d_base_id_dict_seq OWNED BY dict.d_base.id_dict;


--
-- TOC entry 331 (class 1259 OID 1512242)
-- Name: d_entity; Type: TABLE; Schema: dict; Owner: postgres
--

CREATE TABLE dict.d_entity (
    id_dict_entity integer NOT NULL,
    nm_dict_entity text NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE dict.d_entity OWNER TO postgres;

--
-- TOC entry 8432 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE d_entity; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON TABLE dict.d_entity IS 'Перечень справочников';


--
-- TOC entry 597 (class 1259 OID 2120780)
-- Name: metadata; Type: TABLE; Schema: dict; Owner: postgres
--

CREATE TABLE dict.metadata (
    id_metadata integer NOT NULL,
    code_metadata character(4) NOT NULL,
    descr_metadata text NOT NULL,
    crt_table text NOT NULL,
    ins_table_0 text NOT NULL,
    ins_table_1 text,
    ins_table_2 text,
    sel_table_0 text NOT NULL,
    sel_table_1 text NOT NULL,
    sel_table_2 text,
    drop_table text NOT NULL,
    delete_from text NOT NULL,
    where_bad text,
    call_proc_fin text
);


ALTER TABLE dict.metadata OWNER TO postgres;

--
-- TOC entry 8433 (class 0 OID 0)
-- Dependencies: 597
-- Name: TABLE metadata; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON TABLE dict.metadata IS 'Временые хранилища (структуры и методы доступа), для различных типов платёжных реестров';


--
-- TOC entry 8434 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.id_metadata; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.id_metadata IS 'ID записи';


--
-- TOC entry 8435 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.code_metadata; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.code_metadata IS 'Код записи (уникален)';


--
-- TOC entry 8436 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.descr_metadata; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.descr_metadata IS 'Описание экземпляра метаданных';


--
-- TOC entry 8437 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.crt_table; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.crt_table IS 'Создание временных таблиц';


--
-- TOC entry 8438 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.ins_table_0; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.ins_table_0 IS 'Оператор INSERT для зарузки данных из файла-реестра во временную таблицу';


--
-- TOC entry 8439 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.ins_table_1; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.ins_table_1 IS 'Оператор INSERT для загрузки ОБЩЕГО РЕЕСТРА исходных данных';


--
-- TOC entry 8440 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.ins_table_2; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.ins_table_2 IS 'Оператор INSERT для загрузки таблицы с дефетными  данными';


--
-- TOC entry 8441 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.sel_table_0; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.sel_table_0 IS 'Оператор SELECT для выборки данных из временной таблицы';


--
-- TOC entry 8442 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.sel_table_1; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.sel_table_1 IS 'Оператор SELECT для выборки данных из временной таблицы ДЕФЕКТОВ';


--
-- TOC entry 8443 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.sel_table_2; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.sel_table_2 IS 'Оператор SELECT формирующий данные для загрузки в ОБЩИЙ РЕЕСТР';


--
-- TOC entry 8444 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.drop_table; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.drop_table IS 'Оператор DROP TABLE';


--
-- TOC entry 8445 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.delete_from; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.delete_from IS 'Оператор DELETE FROM';


--
-- TOC entry 8446 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.where_bad; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.where_bad IS 'Условие для фильтрации дефектных записей';


--
-- TOC entry 8447 (class 0 OID 0)
-- Dependencies: 597
-- Name: COLUMN metadata.call_proc_fin; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.metadata.call_proc_fin IS 'Шаблон вызова процедуры "fsc_receipt_pcg.p_source_reestr_ins_0"';


--
-- TOC entry 596 (class 1259 OID 2120778)
-- Name: metadata_id_metadata_seq; Type: SEQUENCE; Schema: dict; Owner: postgres
--

CREATE SEQUENCE dict.metadata_id_metadata_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dict.metadata_id_metadata_seq OWNER TO postgres;

--
-- TOC entry 8448 (class 0 OID 0)
-- Dependencies: 596
-- Name: metadata_id_metadata_seq; Type: SEQUENCE OWNED BY; Schema: dict; Owner: postgres
--

ALTER SEQUENCE dict.metadata_id_metadata_seq OWNED BY dict.metadata.id_metadata;


--
-- TOC entry 590 (class 1259 OID 2115873)
-- Name: pay_body; Type: TABLE; Schema: dict; Owner: postgres
--

CREATE TABLE dict.pay_body (
    personal_account text,
    period text,
    doc_number text,
    f1 text,
    f2 text,
    f3 text,
    s_code text,
    pmt_date text,
    pmt_sum integer,
    inform text,
    sign_pmt character(1)
);


ALTER TABLE dict.pay_body OWNER TO postgres;

--
-- TOC entry 581 (class 1259 OID 2114915)
-- Name: pmt_body; Type: TABLE; Schema: dict; Owner: postgres
--

CREATE TABLE dict.pmt_body (
    file_type text,
    id_pmt integer,
    p_date_1 text,
    sum_1 numeric(16,2),
    account_1 text,
    name_1 text,
    inn_1 text,
    name_2 text,
    bik_2 text,
    account_2 text,
    name_3 text,
    f1 text,
    f2 text,
    descr text,
    f3 text
);


ALTER TABLE dict.pmt_body OWNER TO postgres;

--
-- TOC entry 580 (class 1259 OID 2114903)
-- Name: pmt_header; Type: TABLE; Schema: dict; Owner: postgres
--

CREATE TABLE dict.pmt_header (
    file_type text,
    h_date_1 text,
    h_time_1 time without time zone,
    h_date_2 text,
    h_date_3 text,
    account_h text,
    sum_1 numeric(16,2),
    sum_2 numeric(16,2),
    sum_3 numeric(16,2),
    sum_4 numeric(16,2)
);


ALTER TABLE dict.pmt_header OWNER TO postgres;

--
-- TOC entry 334 (class 1259 OID 1512285)
-- Name: ssp_org_type; Type: TABLE; Schema: dict; Owner: postgres
--

CREATE TABLE dict.ssp_org_type (
    kd_priority integer NOT NULL
)
INHERITS (dict.d_base);


ALTER TABLE dict.ssp_org_type OWNER TO postgres;

--
-- TOC entry 8449 (class 0 OID 0)
-- Dependencies: 334
-- Name: TABLE ssp_org_type; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON TABLE dict.ssp_org_type IS 'Перечень типов организаций';


--
-- TOC entry 8450 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN ssp_org_type.id_dict; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.ssp_org_type.id_dict IS 'ID записи справочника';


--
-- TOC entry 8451 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN ssp_org_type.id_dict_entity; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.ssp_org_type.id_dict_entity IS 'ID записи из перечня справочников';


--
-- TOC entry 8452 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN ssp_org_type.is_remove; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.ssp_org_type.is_remove IS 'Признак логического удаления';


--
-- TOC entry 8453 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN ssp_org_type.dt_update; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.ssp_org_type.dt_update IS 'Дата обновления';


--
-- TOC entry 8454 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN ssp_org_type.kd_dict; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.ssp_org_type.kd_dict IS 'Код записи';


--
-- TOC entry 8455 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN ssp_org_type.nm_dict; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.ssp_org_type.nm_dict IS 'Наименование записи';


--
-- TOC entry 8456 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN ssp_org_type.kd_priority; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.ssp_org_type.kd_priority IS 'Код приоритета';


--
-- TOC entry 364 (class 1259 OID 1607901)
-- Name: ssp_pmt_type; Type: TABLE; Schema: dict; Owner: postgres
--

CREATE TABLE dict.ssp_pmt_type (
)
INHERITS (dict.d_base);


ALTER TABLE dict.ssp_pmt_type OWNER TO postgres;

--
-- TOC entry 8457 (class 0 OID 0)
-- Dependencies: 364
-- Name: TABLE ssp_pmt_type; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON TABLE dict.ssp_pmt_type IS 'Перечень типов платежей';


--
-- TOC entry 8458 (class 0 OID 0)
-- Dependencies: 364
-- Name: COLUMN ssp_pmt_type.id_dict; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.ssp_pmt_type.id_dict IS 'ID записи справочника';


--
-- TOC entry 8459 (class 0 OID 0)
-- Dependencies: 364
-- Name: COLUMN ssp_pmt_type.id_dict_entity; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.ssp_pmt_type.id_dict_entity IS 'ID записи из перечня справочников';


--
-- TOC entry 8460 (class 0 OID 0)
-- Dependencies: 364
-- Name: COLUMN ssp_pmt_type.is_remove; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.ssp_pmt_type.is_remove IS 'Признак логического удаления';


--
-- TOC entry 8461 (class 0 OID 0)
-- Dependencies: 364
-- Name: COLUMN ssp_pmt_type.dt_update; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.ssp_pmt_type.dt_update IS 'Дата обновления';


--
-- TOC entry 8462 (class 0 OID 0)
-- Dependencies: 364
-- Name: COLUMN ssp_pmt_type.kd_dict; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.ssp_pmt_type.kd_dict IS 'Код типа платежа';


--
-- TOC entry 8463 (class 0 OID 0)
-- Dependencies: 364
-- Name: COLUMN ssp_pmt_type.nm_dict; Type: COMMENT; Schema: dict; Owner: postgres
--

COMMENT ON COLUMN dict.ssp_pmt_type.nm_dict IS 'Наименование типа платежа';


--
-- TOC entry 554 (class 1259 OID 2111813)
-- Name: fsc_app_id_app_seq; Type: SEQUENCE; Schema: fiscalization; Owner: postgres
--

CREATE SEQUENCE fiscalization.fsc_app_id_app_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fiscalization.fsc_app_id_app_seq OWNER TO postgres;

--
-- TOC entry 578 (class 1259 OID 2112371)
-- Name: fsc_app; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_app (
    id_app integer DEFAULT nextval('fiscalization.fsc_app_id_app_seq'::regclass) NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    app_guid uuid,
    secret_key text NOT NULL,
    nm_app text NOT NULL,
    notification_url text,
    provaider_key text,
    app_status boolean DEFAULT true NOT NULL
);


ALTER TABLE fiscalization.fsc_app OWNER TO postgres;

--
-- TOC entry 8464 (class 0 OID 0)
-- Dependencies: 578
-- Name: TABLE fsc_app; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_app IS 'Приложение';


--
-- TOC entry 8465 (class 0 OID 0)
-- Dependencies: 578
-- Name: COLUMN fsc_app.id_app; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app.id_app IS 'ID приложения';


--
-- TOC entry 8466 (class 0 OID 0)
-- Dependencies: 578
-- Name: COLUMN fsc_app.dt_create; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app.dt_create IS 'Дата создания записи';


--
-- TOC entry 8467 (class 0 OID 0)
-- Dependencies: 578
-- Name: COLUMN fsc_app.dt_update; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app.dt_update IS 'Дата обновления';


--
-- TOC entry 8468 (class 0 OID 0)
-- Dependencies: 578
-- Name: COLUMN fsc_app.dt_remove; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 8469 (class 0 OID 0)
-- Dependencies: 578
-- Name: COLUMN fsc_app.app_guid; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app.app_guid IS 'UUID приложения';


--
-- TOC entry 8470 (class 0 OID 0)
-- Dependencies: 578
-- Name: COLUMN fsc_app.secret_key; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app.secret_key IS 'Секретный ключ';


--
-- TOC entry 8471 (class 0 OID 0)
-- Dependencies: 578
-- Name: COLUMN fsc_app.nm_app; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app.nm_app IS 'Название приложеия';


--
-- TOC entry 8472 (class 0 OID 0)
-- Dependencies: 578
-- Name: COLUMN fsc_app.notification_url; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app.notification_url IS 'URL для уведомлений';


--
-- TOC entry 8473 (class 0 OID 0)
-- Dependencies: 578
-- Name: COLUMN fsc_app.provaider_key; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app.provaider_key IS 'Ключ провайдера';


--
-- TOC entry 8474 (class 0 OID 0)
-- Dependencies: 578
-- Name: COLUMN fsc_app.app_status; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app.app_status IS 'Статус приложения';


--
-- TOC entry 560 (class 1259 OID 2111825)
-- Name: fsc_app_param_id_seq; Type: SEQUENCE; Schema: fiscalization; Owner: postgres
--

CREATE SEQUENCE fiscalization.fsc_app_param_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fiscalization.fsc_app_param_id_seq OWNER TO postgres;

--
-- TOC entry 579 (class 1259 OID 2114694)
-- Name: fsc_app_param; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_app_param (
    id_app_param integer DEFAULT nextval('fiscalization.fsc_app_param_id_seq'::regclass) NOT NULL,
    id_app integer NOT NULL,
    id_fsc_provider integer NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) without time zone,
    app_params jsonb,
    app_status boolean DEFAULT true NOT NULL
);


ALTER TABLE fiscalization.fsc_app_param OWNER TO postgres;

--
-- TOC entry 8475 (class 0 OID 0)
-- Dependencies: 579
-- Name: TABLE fsc_app_param; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_app_param IS 'Настройки приложения для организации';


--
-- TOC entry 8476 (class 0 OID 0)
-- Dependencies: 579
-- Name: COLUMN fsc_app_param.id_app_param; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app_param.id_app_param IS 'ID Настройки приложения для организации';


--
-- TOC entry 8477 (class 0 OID 0)
-- Dependencies: 579
-- Name: COLUMN fsc_app_param.id_app; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app_param.id_app IS 'ID Приложения для Организации';


--
-- TOC entry 8478 (class 0 OID 0)
-- Dependencies: 579
-- Name: COLUMN fsc_app_param.id_fsc_provider; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app_param.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 8479 (class 0 OID 0)
-- Dependencies: 579
-- Name: COLUMN fsc_app_param.dt_create; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app_param.dt_create IS 'Дата создания';


--
-- TOC entry 8480 (class 0 OID 0)
-- Dependencies: 579
-- Name: COLUMN fsc_app_param.dt_update; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app_param.dt_update IS 'Дата обновления';


--
-- TOC entry 8481 (class 0 OID 0)
-- Dependencies: 579
-- Name: COLUMN fsc_app_param.app_params; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app_param.app_params IS 'Параметры настройки';


--
-- TOC entry 8482 (class 0 OID 0)
-- Dependencies: 579
-- Name: COLUMN fsc_app_param.app_status; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_app_param.app_status IS 'Статус настройки';


--
-- TOC entry 561 (class 1259 OID 2111827)
-- Name: fsc_data_operator_id_seq; Type: SEQUENCE; Schema: fiscalization; Owner: postgres
--

CREATE SEQUENCE fiscalization.fsc_data_operator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fiscalization.fsc_data_operator_id_seq OWNER TO postgres;

--
-- TOC entry 577 (class 1259 OID 2112358)
-- Name: fsc_data_operator; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_data_operator (
    id_fsc_data_operator integer DEFAULT nextval('fiscalization.fsc_data_operator_id_seq'::regclass) NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) without time zone,
    ofd_inn character varying(12) NOT NULL,
    nm_ofd text NOT NULL,
    ofd_site text,
    ofd_status boolean DEFAULT true NOT NULL,
    nm_ofd_full text,
    fns_info text
);


ALTER TABLE fiscalization.fsc_data_operator OWNER TO postgres;

--
-- TOC entry 8483 (class 0 OID 0)
-- Dependencies: 577
-- Name: TABLE fsc_data_operator; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_data_operator IS 'ОФД';


--
-- TOC entry 8484 (class 0 OID 0)
-- Dependencies: 577
-- Name: COLUMN fsc_data_operator.id_fsc_data_operator; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_data_operator.id_fsc_data_operator IS 'ID ОФД';


--
-- TOC entry 8485 (class 0 OID 0)
-- Dependencies: 577
-- Name: COLUMN fsc_data_operator.dt_create; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_data_operator.dt_create IS 'Дата создания записи';


--
-- TOC entry 8486 (class 0 OID 0)
-- Dependencies: 577
-- Name: COLUMN fsc_data_operator.dt_update; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_data_operator.dt_update IS 'Дата обновления';


--
-- TOC entry 8487 (class 0 OID 0)
-- Dependencies: 577
-- Name: COLUMN fsc_data_operator.ofd_inn; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_data_operator.ofd_inn IS 'ИНН ОФД';


--
-- TOC entry 8488 (class 0 OID 0)
-- Dependencies: 577
-- Name: COLUMN fsc_data_operator.nm_ofd; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_data_operator.nm_ofd IS 'Наименование ОФД';


--
-- TOC entry 8489 (class 0 OID 0)
-- Dependencies: 577
-- Name: COLUMN fsc_data_operator.ofd_site; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_data_operator.ofd_site IS 'Сайт ОФД';


--
-- TOC entry 8490 (class 0 OID 0)
-- Dependencies: 577
-- Name: COLUMN fsc_data_operator.ofd_status; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_data_operator.ofd_status IS 'Статус ОФД';


--
-- TOC entry 8491 (class 0 OID 0)
-- Dependencies: 577
-- Name: COLUMN fsc_data_operator.nm_ofd_full; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_data_operator.nm_ofd_full IS 'Полное наименование ОФД';


--
-- TOC entry 8492 (class 0 OID 0)
-- Dependencies: 577
-- Name: COLUMN fsc_data_operator.fns_info; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_data_operator.fns_info IS 'Информация от ФНС';


--
-- TOC entry 555 (class 1259 OID 2111815)
-- Name: fsc_org_id_org_seq; Type: SEQUENCE; Schema: fiscalization; Owner: postgres
--

CREATE SEQUENCE fiscalization.fsc_org_id_org_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fiscalization.fsc_org_id_org_seq OWNER TO postgres;

--
-- TOC entry 574 (class 1259 OID 2112330)
-- Name: fsc_org; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_org (
    id_org integer DEFAULT nextval('fiscalization.fsc_org_id_org_seq'::regclass) NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) without time zone,
    dt_remove timestamp(0) without time zone,
    inn character varying(12) NOT NULL,
    nm_org_name character varying(150) NOT NULL,
    org_type integer,
    org_status boolean DEFAULT true NOT NULL,
    bik character varying(9),
    nm_org_address text,
    nm_org_phones text[]
);


ALTER TABLE fiscalization.fsc_org OWNER TO postgres;

--
-- TOC entry 8493 (class 0 OID 0)
-- Dependencies: 574
-- Name: TABLE fsc_org; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_org IS 'Организация';


--
-- TOC entry 8494 (class 0 OID 0)
-- Dependencies: 574
-- Name: COLUMN fsc_org.id_org; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org.id_org IS 'ID организации';


--
-- TOC entry 8495 (class 0 OID 0)
-- Dependencies: 574
-- Name: COLUMN fsc_org.dt_create; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org.dt_create IS 'Дата создания записи';


--
-- TOC entry 8496 (class 0 OID 0)
-- Dependencies: 574
-- Name: COLUMN fsc_org.dt_update; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org.dt_update IS 'Дата обновления';


--
-- TOC entry 8497 (class 0 OID 0)
-- Dependencies: 574
-- Name: COLUMN fsc_org.dt_remove; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org.dt_remove IS 'Дата логического удаления';


--
-- TOC entry 8498 (class 0 OID 0)
-- Dependencies: 574
-- Name: COLUMN fsc_org.inn; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org.inn IS 'ИНН';


--
-- TOC entry 8499 (class 0 OID 0)
-- Dependencies: 574
-- Name: COLUMN fsc_org.nm_org_name; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org.nm_org_name IS 'Наименование организации';


--
-- TOC entry 8500 (class 0 OID 0)
-- Dependencies: 574
-- Name: COLUMN fsc_org.org_type; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org.org_type IS 'Тип организации';


--
-- TOC entry 8501 (class 0 OID 0)
-- Dependencies: 574
-- Name: COLUMN fsc_org.org_status; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org.org_status IS 'Статус организации';


--
-- TOC entry 8502 (class 0 OID 0)
-- Dependencies: 574
-- Name: COLUMN fsc_org.bik; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org.bik IS 'БИК организации (Для организации типа 5,расчётный банк)';


--
-- TOC entry 8503 (class 0 OID 0)
-- Dependencies: 574
-- Name: COLUMN fsc_org.nm_org_address; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org.nm_org_address IS 'Адрес организации (фактический, юридический ??)';


--
-- TOC entry 8504 (class 0 OID 0)
-- Dependencies: 574
-- Name: COLUMN fsc_org.nm_org_phones; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org.nm_org_phones IS 'Контактные телефоны организации';


--
-- TOC entry 557 (class 1259 OID 2111819)
-- Name: fsc_org_app_id_org_app_seq; Type: SEQUENCE; Schema: fiscalization; Owner: postgres
--

CREATE SEQUENCE fiscalization.fsc_org_app_id_org_app_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fiscalization.fsc_org_app_id_org_app_seq OWNER TO postgres;

--
-- TOC entry 573 (class 1259 OID 2112307)
-- Name: fsc_org_app; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_org_app (
    id_org_app integer DEFAULT nextval('fiscalization.fsc_org_app_id_org_app_seq'::regclass) NOT NULL,
    id_org integer NOT NULL,
    id_app integer NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    org_app_status boolean DEFAULT true NOT NULL,
    id_fsc_data_operator integer
);


ALTER TABLE fiscalization.fsc_org_app OWNER TO postgres;

--
-- TOC entry 8505 (class 0 OID 0)
-- Dependencies: 573
-- Name: TABLE fsc_org_app; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_org_app IS 'Организации и Приложения';


--
-- TOC entry 8506 (class 0 OID 0)
-- Dependencies: 573
-- Name: COLUMN fsc_org_app.id_org_app; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_app.id_org_app IS 'ID приложения организации';


--
-- TOC entry 8507 (class 0 OID 0)
-- Dependencies: 573
-- Name: COLUMN fsc_org_app.id_org; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_app.id_org IS 'ID Организации';


--
-- TOC entry 8508 (class 0 OID 0)
-- Dependencies: 573
-- Name: COLUMN fsc_org_app.id_app; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_app.id_app IS 'ID приложение';


--
-- TOC entry 8509 (class 0 OID 0)
-- Dependencies: 573
-- Name: COLUMN fsc_org_app.dt_create; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_app.dt_create IS 'Дата создания';


--
-- TOC entry 8510 (class 0 OID 0)
-- Dependencies: 573
-- Name: COLUMN fsc_org_app.org_app_status; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_app.org_app_status IS 'Статус';


--
-- TOC entry 559 (class 1259 OID 2111823)
-- Name: fsc_org_cash_id_seq; Type: SEQUENCE; Schema: fiscalization; Owner: postgres
--

CREATE SEQUENCE fiscalization.fsc_org_cash_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fiscalization.fsc_org_cash_id_seq OWNER TO postgres;

--
-- TOC entry 576 (class 1259 OID 2112347)
-- Name: fsc_org_cash; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_org_cash (
    id_org_cash integer DEFAULT nextval('fiscalization.fsc_org_cash_id_seq'::regclass) NOT NULL,
    id_org integer NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    dt_update timestamp(0) without time zone,
    qty_cash integer DEFAULT 0 NOT NULL,
    grp_cash character varying(50),
    nm_grp_cash character varying(150),
    org_cash_status boolean DEFAULT true NOT NULL,
    id_fsc_provider integer NOT NULL
);


ALTER TABLE fiscalization.fsc_org_cash OWNER TO postgres;

--
-- TOC entry 8511 (class 0 OID 0)
-- Dependencies: 576
-- Name: TABLE fsc_org_cash; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_org_cash IS 'Настройки касс для организаций';


--
-- TOC entry 8512 (class 0 OID 0)
-- Dependencies: 576
-- Name: COLUMN fsc_org_cash.id_org_cash; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_cash.id_org_cash IS 'ID настройки';


--
-- TOC entry 8513 (class 0 OID 0)
-- Dependencies: 576
-- Name: COLUMN fsc_org_cash.id_org; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_cash.id_org IS 'ID организации';


--
-- TOC entry 8514 (class 0 OID 0)
-- Dependencies: 576
-- Name: COLUMN fsc_org_cash.dt_create; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_cash.dt_create IS 'Дата создания';


--
-- TOC entry 8515 (class 0 OID 0)
-- Dependencies: 576
-- Name: COLUMN fsc_org_cash.dt_update; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_cash.dt_update IS 'Дата обновления';


--
-- TOC entry 8516 (class 0 OID 0)
-- Dependencies: 576
-- Name: COLUMN fsc_org_cash.qty_cash; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_cash.qty_cash IS 'Количество касс';


--
-- TOC entry 8517 (class 0 OID 0)
-- Dependencies: 576
-- Name: COLUMN fsc_org_cash.grp_cash; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_cash.grp_cash IS 'Группа касс';


--
-- TOC entry 8518 (class 0 OID 0)
-- Dependencies: 576
-- Name: COLUMN fsc_org_cash.nm_grp_cash; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_cash.nm_grp_cash IS 'Наименование группы касс';


--
-- TOC entry 8519 (class 0 OID 0)
-- Dependencies: 576
-- Name: COLUMN fsc_org_cash.org_cash_status; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_cash.org_cash_status IS 'Статус настройки касс';


--
-- TOC entry 8520 (class 0 OID 0)
-- Dependencies: 576
-- Name: COLUMN fsc_org_cash.id_fsc_provider; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_org_cash.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 558 (class 1259 OID 2111821)
-- Name: fsc_provider_id_seq; Type: SEQUENCE; Schema: fiscalization; Owner: postgres
--

CREATE SEQUENCE fiscalization.fsc_provider_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fiscalization.fsc_provider_id_seq OWNER TO postgres;

--
-- TOC entry 575 (class 1259 OID 2112337)
-- Name: fsc_provider; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_provider (
    id_fsc_provider integer DEFAULT nextval('fiscalization.fsc_provider_id_seq'::regclass) NOT NULL,
    nm_fsc_provider character varying(150) NOT NULL,
    kd_fsc_provider character varying(20) NOT NULL,
    fsc_url text,
    fsc_port character varying(5),
    fsc_status boolean DEFAULT true NOT NULL
);


ALTER TABLE fiscalization.fsc_provider OWNER TO postgres;

--
-- TOC entry 8521 (class 0 OID 0)
-- Dependencies: 575
-- Name: TABLE fsc_provider; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_provider IS 'Фискальный провайдер';


--
-- TOC entry 8522 (class 0 OID 0)
-- Dependencies: 575
-- Name: COLUMN fsc_provider.id_fsc_provider; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_provider.id_fsc_provider IS 'ID фискального провайдера';


--
-- TOC entry 8523 (class 0 OID 0)
-- Dependencies: 575
-- Name: COLUMN fsc_provider.nm_fsc_provider; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_provider.nm_fsc_provider IS 'Наименование';


--
-- TOC entry 8524 (class 0 OID 0)
-- Dependencies: 575
-- Name: COLUMN fsc_provider.kd_fsc_provider; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_provider.kd_fsc_provider IS 'Системный код';


--
-- TOC entry 8525 (class 0 OID 0)
-- Dependencies: 575
-- Name: COLUMN fsc_provider.fsc_url; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_provider.fsc_url IS 'URL фискального провайдера';


--
-- TOC entry 8526 (class 0 OID 0)
-- Dependencies: 575
-- Name: COLUMN fsc_provider.fsc_port; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_provider.fsc_port IS 'Порт';


--
-- TOC entry 8527 (class 0 OID 0)
-- Dependencies: 575
-- Name: COLUMN fsc_provider.fsc_status; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_provider.fsc_status IS 'Статус';


--
-- TOC entry 556 (class 1259 OID 2111817)
-- Name: fsc_receipt_id_receipt_seq; Type: SEQUENCE; Schema: fiscalization; Owner: postgres
--

CREATE SEQUENCE fiscalization.fsc_receipt_id_receipt_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fiscalization.fsc_receipt_id_receipt_seq OWNER TO postgres;

--
-- TOC entry 562 (class 1259 OID 2111992)
-- Name: fsc_receipt; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_receipt (
    id_receipt bigint DEFAULT nextval('fiscalization.fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(12),
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_type integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    id_pmt_reestr bigint,
    resend_pr integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_receipt_status CHECK ((rcp_status = ANY (ARRAY[0, 1, 2, 3, 4, 5]))),
    CONSTRAINT chk_receipt_type CHECK ((rcp_type = ANY (ARRAY[0, 1, 2]))),
    CONSTRAINT chk_resend_pr CHECK ((resend_pr = ANY (ARRAY[0, 1, 2, 3, 4, 5])))
)
PARTITION BY LIST (rcp_status);


ALTER TABLE fiscalization.fsc_receipt OWNER TO postgres;

--
-- TOC entry 8528 (class 0 OID 0)
-- Dependencies: 562
-- Name: TABLE fsc_receipt; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_receipt IS 'Чек';


--
-- TOC entry 8529 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.id_receipt; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.id_receipt IS 'ID Чека';


--
-- TOC entry 8530 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.dt_create; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.dt_create IS 'Дата создания';


--
-- TOC entry 8531 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.rcp_status; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_status IS 'Статус чека';


--
-- TOC entry 8532 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.dt_update; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.dt_update IS 'Дата обновления';


--
-- TOC entry 8533 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.inn; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.inn IS 'ИНН';


--
-- TOC entry 8534 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.rcp_nmb; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_nmb IS 'Номер чека';


--
-- TOC entry 8535 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.rcp_fp; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_fp IS 'Фискальный признак';


--
-- TOC entry 8536 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.dt_fp; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.dt_fp IS 'Дата фискализапции';


--
-- TOC entry 8537 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.id_org_app; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.id_org_app IS 'ID пары Организация-Приложение';


--
-- TOC entry 8538 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.rcp_status_descr; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_status_descr IS 'Описание статуса';


--
-- TOC entry 8539 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.rcp_order; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_order IS 'Запрос на фискализацию';


--
-- TOC entry 8540 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.rcp_receipt; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_receipt IS 'Результат фискализации';


--
-- TOC entry 8541 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.rcp_type; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_type IS 'Тип (0-кассовый чек/1-чек корреции/2-возврат платежа)';


--
-- TOC entry 8542 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.rcp_received; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_received IS 'Чек принят';


--
-- TOC entry 8543 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.rcp_notify_send; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_notify_send IS 'Извещение отослано';


--
-- TOC entry 8544 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.id_pmt_reestr; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.id_pmt_reestr IS 'ID реестра платежей';


--
-- TOC entry 8545 (class 0 OID 0)
-- Dependencies: 562
-- Name: COLUMN fsc_receipt.resend_pr; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_receipt.resend_pr IS 'Признак повторной фискализации: 0 - первичная, 1,2,3,4,5 - повторная';


--
-- TOC entry 563 (class 1259 OID 2112004)
-- Name: fsc_receipt_0; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_receipt_0 (
    id_receipt bigint DEFAULT nextval('fiscalization.fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(12),
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_type integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    id_pmt_reestr bigint,
    resend_pr integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_receipt_0 CHECK ((rcp_status = 0)),
    CONSTRAINT chk_receipt_status CHECK ((rcp_status = ANY (ARRAY[0, 1, 2, 3, 4, 5]))),
    CONSTRAINT chk_receipt_type CHECK ((rcp_type = ANY (ARRAY[0, 1, 2]))),
    CONSTRAINT chk_resend_pr CHECK ((resend_pr = ANY (ARRAY[0, 1, 2, 3, 4, 5])))
);
ALTER TABLE ONLY fiscalization.fsc_receipt ATTACH PARTITION fiscalization.fsc_receipt_0 FOR VALUES IN (0);


ALTER TABLE fiscalization.fsc_receipt_0 OWNER TO postgres;

--
-- TOC entry 8546 (class 0 OID 0)
-- Dependencies: 563
-- Name: TABLE fsc_receipt_0; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_receipt_0 IS 'Запрос на фискализацию';


--
-- TOC entry 564 (class 1259 OID 2112020)
-- Name: fsc_receipt_1; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_receipt_1 (
    id_receipt bigint DEFAULT nextval('fiscalization.fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(12),
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_type integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    id_pmt_reestr bigint,
    resend_pr integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_receipt_1 CHECK ((rcp_status = 1)),
    CONSTRAINT chk_receipt_status CHECK ((rcp_status = ANY (ARRAY[0, 1, 2, 3, 4, 5]))),
    CONSTRAINT chk_receipt_type CHECK ((rcp_type = ANY (ARRAY[0, 1, 2]))),
    CONSTRAINT chk_resend_pr CHECK ((resend_pr = ANY (ARRAY[0, 1, 2, 3, 4, 5])))
);
ALTER TABLE ONLY fiscalization.fsc_receipt ATTACH PARTITION fiscalization.fsc_receipt_1 FOR VALUES IN (1);


ALTER TABLE fiscalization.fsc_receipt_1 OWNER TO postgres;

--
-- TOC entry 8547 (class 0 OID 0)
-- Dependencies: 564
-- Name: TABLE fsc_receipt_1; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_receipt_1 IS 'Отправлено на фискализацию';


--
-- TOC entry 568 (class 1259 OID 2112083)
-- Name: fsc_receipt_2; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_receipt_2 (
    id_receipt bigint DEFAULT nextval('fiscalization.fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(12),
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_type integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    id_pmt_reestr bigint,
    resend_pr integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_status CHECK ((rcp_status = ANY (ARRAY[0, 1, 2, 3, 4, 5]))),
    CONSTRAINT chk_receipt_type CHECK ((rcp_type = ANY (ARRAY[0, 1, 2]))),
    CONSTRAINT chk_resend_pr CHECK ((resend_pr = ANY (ARRAY[0, 1, 2, 3, 4, 5])))
)
PARTITION BY RANGE (dt_create);
ALTER TABLE ONLY fiscalization.fsc_receipt ATTACH PARTITION fiscalization.fsc_receipt_2 FOR VALUES IN (2);


ALTER TABLE fiscalization.fsc_receipt_2 OWNER TO postgres;

--
-- TOC entry 8548 (class 0 OID 0)
-- Dependencies: 568
-- Name: TABLE fsc_receipt_2; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_receipt_2 IS 'Результаты фискализации';


--
-- TOC entry 569 (class 1259 OID 2112096)
-- Name: fsc_receipt_2_2021_1; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_receipt_2_2021_1 (
    id_receipt bigint DEFAULT nextval('fiscalization.fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(12),
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_type integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    id_pmt_reestr bigint,
    resend_pr integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_1 CHECK (((dt_create >= '2021-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-04-01 00:00:00+03'::timestamp with time zone))),
    CONSTRAINT chk_receipt_status CHECK ((rcp_status = ANY (ARRAY[0, 1, 2, 3, 4, 5]))),
    CONSTRAINT chk_receipt_type CHECK ((rcp_type = ANY (ARRAY[0, 1, 2]))),
    CONSTRAINT chk_resend_pr CHECK ((resend_pr = ANY (ARRAY[0, 1, 2, 3, 4, 5])))
);
ALTER TABLE ONLY fiscalization.fsc_receipt_2 ATTACH PARTITION fiscalization.fsc_receipt_2_2021_1 FOR VALUES FROM ('2021-01-01 00:00:00+03') TO ('2021-04-01 00:00:00+03');


ALTER TABLE fiscalization.fsc_receipt_2_2021_1 OWNER TO postgres;

--
-- TOC entry 8549 (class 0 OID 0)
-- Dependencies: 569
-- Name: TABLE fsc_receipt_2_2021_1; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_receipt_2_2021_1 IS 'Результаты фискализации. 2021 год, первый квартал';


--
-- TOC entry 570 (class 1259 OID 2112113)
-- Name: fsc_receipt_2_2021_2; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_receipt_2_2021_2 (
    id_receipt bigint DEFAULT nextval('fiscalization.fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(12),
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_type integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    id_pmt_reestr bigint,
    resend_pr integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_2 CHECK (((dt_create >= '2021-04-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-07-01 00:00:00+03'::timestamp with time zone))),
    CONSTRAINT chk_receipt_status CHECK ((rcp_status = ANY (ARRAY[0, 1, 2, 3, 4, 5]))),
    CONSTRAINT chk_receipt_type CHECK ((rcp_type = ANY (ARRAY[0, 1, 2]))),
    CONSTRAINT chk_resend_pr CHECK ((resend_pr = ANY (ARRAY[0, 1, 2, 3, 4, 5])))
);
ALTER TABLE ONLY fiscalization.fsc_receipt_2 ATTACH PARTITION fiscalization.fsc_receipt_2_2021_2 FOR VALUES FROM ('2021-04-01 00:00:00+03') TO ('2021-07-01 00:00:00+03');


ALTER TABLE fiscalization.fsc_receipt_2_2021_2 OWNER TO postgres;

--
-- TOC entry 8550 (class 0 OID 0)
-- Dependencies: 570
-- Name: TABLE fsc_receipt_2_2021_2; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_receipt_2_2021_2 IS 'Результаты фискализации. 2021 год, второй квартал';


--
-- TOC entry 571 (class 1259 OID 2112130)
-- Name: fsc_receipt_2_2021_3; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_receipt_2_2021_3 (
    id_receipt bigint DEFAULT nextval('fiscalization.fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(12),
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_type integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    id_pmt_reestr bigint,
    resend_pr integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_3 CHECK (((dt_create >= '2021-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-10-01 00:00:00+03'::timestamp with time zone))),
    CONSTRAINT chk_receipt_status CHECK ((rcp_status = ANY (ARRAY[0, 1, 2, 3, 4, 5]))),
    CONSTRAINT chk_receipt_type CHECK ((rcp_type = ANY (ARRAY[0, 1, 2]))),
    CONSTRAINT chk_resend_pr CHECK ((resend_pr = ANY (ARRAY[0, 1, 2, 3, 4, 5])))
);
ALTER TABLE ONLY fiscalization.fsc_receipt_2 ATTACH PARTITION fiscalization.fsc_receipt_2_2021_3 FOR VALUES FROM ('2021-07-01 00:00:00+03') TO ('2021-10-01 00:00:00+03');


ALTER TABLE fiscalization.fsc_receipt_2_2021_3 OWNER TO postgres;

--
-- TOC entry 8551 (class 0 OID 0)
-- Dependencies: 571
-- Name: TABLE fsc_receipt_2_2021_3; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_receipt_2_2021_3 IS 'Результаты фискализации. 2021 год, третий квартал';


--
-- TOC entry 572 (class 1259 OID 2112147)
-- Name: fsc_receipt_2_2021_4; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_receipt_2_2021_4 (
    id_receipt bigint DEFAULT nextval('fiscalization.fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(12),
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_type integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    id_pmt_reestr bigint,
    resend_pr integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_dt_create_2021_4 CHECK (((dt_create >= '2021-10-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2022-01-01 00:00:00+03'::timestamp with time zone))),
    CONSTRAINT chk_receipt_status CHECK ((rcp_status = ANY (ARRAY[0, 1, 2, 3, 4, 5]))),
    CONSTRAINT chk_receipt_type CHECK ((rcp_type = ANY (ARRAY[0, 1, 2]))),
    CONSTRAINT chk_resend_pr CHECK ((resend_pr = ANY (ARRAY[0, 1, 2, 3, 4, 5])))
);
ALTER TABLE ONLY fiscalization.fsc_receipt_2 ATTACH PARTITION fiscalization.fsc_receipt_2_2021_4 FOR VALUES FROM ('2021-10-01 00:00:00+03') TO ('2022-01-01 00:00:00+03');


ALTER TABLE fiscalization.fsc_receipt_2_2021_4 OWNER TO postgres;

--
-- TOC entry 8552 (class 0 OID 0)
-- Dependencies: 572
-- Name: TABLE fsc_receipt_2_2021_4; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_receipt_2_2021_4 IS 'Результаты фискализации. 2021 год, четвёртый квартал';


--
-- TOC entry 565 (class 1259 OID 2112036)
-- Name: fsc_receipt_3; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_receipt_3 (
    id_receipt bigint DEFAULT nextval('fiscalization.fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(12),
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_type integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    id_pmt_reestr bigint,
    resend_pr integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_receipt_3 CHECK ((rcp_status = 3)),
    CONSTRAINT chk_receipt_status CHECK ((rcp_status = ANY (ARRAY[0, 1, 2, 3, 4, 5]))),
    CONSTRAINT chk_receipt_type CHECK ((rcp_type = ANY (ARRAY[0, 1, 2]))),
    CONSTRAINT chk_resend_pr CHECK ((resend_pr = ANY (ARRAY[0, 1, 2, 3, 4, 5])))
);
ALTER TABLE ONLY fiscalization.fsc_receipt ATTACH PARTITION fiscalization.fsc_receipt_3 FOR VALUES IN (3);


ALTER TABLE fiscalization.fsc_receipt_3 OWNER TO postgres;

--
-- TOC entry 8553 (class 0 OID 0)
-- Dependencies: 565
-- Name: TABLE fsc_receipt_3; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_receipt_3 IS 'Ожидание освобождения очереди';


--
-- TOC entry 566 (class 1259 OID 2112052)
-- Name: fsc_receipt_45; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_receipt_45 (
    id_receipt bigint DEFAULT nextval('fiscalization.fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(12),
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_type integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    id_pmt_reestr bigint,
    resend_pr integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_receipt_45 CHECK ((rcp_status = ANY (ARRAY[4, 5]))),
    CONSTRAINT chk_receipt_status CHECK ((rcp_status = ANY (ARRAY[0, 1, 2, 3, 4, 5]))),
    CONSTRAINT chk_receipt_type CHECK ((rcp_type = ANY (ARRAY[0, 1, 2]))),
    CONSTRAINT chk_resend_pr CHECK ((resend_pr = ANY (ARRAY[0, 1, 2, 3, 4, 5])))
);
ALTER TABLE ONLY fiscalization.fsc_receipt ATTACH PARTITION fiscalization.fsc_receipt_45 FOR VALUES IN (4, 5);


ALTER TABLE fiscalization.fsc_receipt_45 OWNER TO postgres;

--
-- TOC entry 8554 (class 0 OID 0)
-- Dependencies: 566
-- Name: TABLE fsc_receipt_45; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_receipt_45 IS 'Ошибки фискализации';


--
-- TOC entry 567 (class 1259 OID 2112068)
-- Name: fsc_receipt_default; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_receipt_default (
    id_receipt bigint DEFAULT nextval('fiscalization.fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(12),
    rcp_nmb text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_type integer DEFAULT 0 NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    id_pmt_reestr bigint,
    resend_pr integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_receipt_status CHECK ((rcp_status = ANY (ARRAY[0, 1, 2, 3, 4, 5]))),
    CONSTRAINT chk_receipt_type CHECK ((rcp_type = ANY (ARRAY[0, 1, 2]))),
    CONSTRAINT chk_resend_pr CHECK ((resend_pr = ANY (ARRAY[0, 1, 2, 3, 4, 5])))
);
ALTER TABLE ONLY fiscalization.fsc_receipt ATTACH PARTITION fiscalization.fsc_receipt_default DEFAULT;


ALTER TABLE fiscalization.fsc_receipt_default OWNER TO postgres;

--
-- TOC entry 8555 (class 0 OID 0)
-- Dependencies: 567
-- Name: TABLE fsc_receipt_default; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_receipt_default IS 'Неклассифицированные данные фискализации';


--
-- TOC entry 588 (class 1259 OID 2115845)
-- Name: fsc_source_reestr_id_reestr_seq; Type: SEQUENCE; Schema: fiscalization; Owner: postgres
--

CREATE SEQUENCE fiscalization.fsc_source_reestr_id_reestr_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fiscalization.fsc_source_reestr_id_reestr_seq OWNER TO postgres;

--
-- TOC entry 589 (class 1259 OID 2115847)
-- Name: fsc_source_reestr; Type: TABLE; Schema: fiscalization; Owner: postgres
--

CREATE TABLE fiscalization.fsc_source_reestr (
    id_source_reestr bigint DEFAULT nextval('fiscalization.fsc_source_reestr_id_reestr_seq'::regclass) NOT NULL,
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL,
    company_email text NOT NULL,
    company_sno public.sno_t NOT NULL,
    company_inn text NOT NULL,
    company_payment_address text NOT NULL,
    client_name text NOT NULL,
    client_inn text NOT NULL,
    pmt_type integer NOT NULL,
    pmt_sum numeric(10,2) NOT NULL,
    item_name text NOT NULL,
    item_price numeric(10,2) NOT NULL,
    item_measure integer NOT NULL,
    item_quantity numeric(8,3) DEFAULT 1.000 NOT NULL,
    item_sum numeric(10,2) NOT NULL,
    item_payment_method public.payment_method_t NOT NULL,
    payment_object integer NOT NULL,
    item_vat public.vat_t NOT NULL,
    client_account text,
    company_account text,
    company_phones text[],
    company_name text,
    company_bik text,
    company_paying_agent boolean DEFAULT false NOT NULL,
    bank_name text,
    bank_addr text,
    bank_inn text,
    bank_bik text,
    bank_phones text[],
    type_source_reestr integer DEFAULT 0 NOT NULL,
    external_id text NOT NULL
);


ALTER TABLE fiscalization.fsc_source_reestr OWNER TO postgres;

--
-- TOC entry 8556 (class 0 OID 0)
-- Dependencies: 589
-- Name: TABLE fsc_source_reestr; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON TABLE fiscalization.fsc_source_reestr IS 'Реестр исходных данных';


--
-- TOC entry 8557 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.id_source_reestr; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.id_source_reestr IS 'ID рееестра исходных данных';


--
-- TOC entry 8558 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.dt_create; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.dt_create IS 'Дата создания записи';


--
-- TOC entry 8559 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.company_email; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_email IS 'mail отправителя чека (адрес ОФД)';


--
-- TOC entry 8560 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.company_sno; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_sno IS 'Система налогообложения';


--
-- TOC entry 8561 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.company_inn; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_inn IS 'ИНН организации';


--
-- TOC entry 8562 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.company_payment_address; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_payment_address IS 'Место расчётов';


--
-- TOC entry 8563 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.client_name; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.client_name IS 'Наименование клиента';


--
-- TOC entry 8564 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.client_inn; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.client_inn IS 'ИНН клиента';


--
-- TOC entry 8565 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.pmt_type; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.pmt_type IS 'Вид  оплаты';


--
-- TOC entry 8566 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.pmt_sum; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.pmt_sum IS 'Сумма оплаты';


--
-- TOC entry 8567 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.item_name; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_name IS 'Наименование товара/услуги';


--
-- TOC entry 8568 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.item_price; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_price IS 'Цена в рублях';


--
-- TOC entry 8569 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.item_measure; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_measure IS 'Единица измерения товара';


--
-- TOC entry 8570 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.item_quantity; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_quantity IS 'Количество товара/Оказанных услуг';


--
-- TOC entry 8571 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.item_sum; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_sum IS 'Сумма товара в рублях';


--
-- TOC entry 8572 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.item_payment_method; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_payment_method IS 'Способ расчёта за товар';


--
-- TOC entry 8573 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.payment_object; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.payment_object IS 'Признак предмета расчёта';


--
-- TOC entry 8574 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.item_vat; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_vat IS 'Тип налога';


--
-- TOC entry 8575 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.client_account; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.client_account IS 'Счёт клиента';


--
-- TOC entry 8576 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.company_account; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_account IS 'Счёт компании, предоставляющей услуги';


--
-- TOC entry 8577 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.company_phones; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_phones IS 'Контактные телефоны компании';


--
-- TOC entry 8578 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.company_name; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_name IS 'Наименование компании, предоставляющей услуги';


--
-- TOC entry 8579 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.company_bik; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_bik IS 'БИК компании, предоставляющей услуги';


--
-- TOC entry 8580 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.company_paying_agent; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_paying_agent IS 'Компания -- банковский агент, переход на двухзвенную схему';


--
-- TOC entry 8581 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.bank_name; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.bank_name IS 'Наименование банка (двухзвенная схема)';


--
-- TOC entry 8582 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.bank_addr; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.bank_addr IS 'Адрес банка';


--
-- TOC entry 8583 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.bank_inn; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.bank_inn IS 'ИНН банка (двухзвенная схема)';


--
-- TOC entry 8584 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.bank_bik; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.bank_bik IS 'БИК банка (двухзвенная схема)';


--
-- TOC entry 8585 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.bank_phones; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.bank_phones IS 'Контактные телефоны банка (двухзвенная схема)';


--
-- TOC entry 8586 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.type_source_reestr; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.type_source_reestr IS 'Тип реестра исходных данных';


--
-- TOC entry 8587 (class 0 OID 0)
-- Dependencies: 589
-- Name: COLUMN fsc_source_reestr.external_id; Type: COMMENT; Schema: fiscalization; Owner: postgres
--

COMMENT ON COLUMN fiscalization.fsc_source_reestr.external_id IS 'Внешний идентификатор строки реестра (Внешний ID чека)';


--
-- TOC entry 553 (class 1259 OID 2111777)
-- Name: fsc_receipt_2_2020_01_half; Type: TABLE; Schema: fiscalization_part; Owner: postgres
--

CREATE TABLE fiscalization_part.fsc_receipt_2_2020_01_half (
    id_receipt bigint DEFAULT nextval('"_OLD_7_fiscalization".fsc_receipt_id_receipt_seq'::regclass) NOT NULL,
    dt_create timestamp(0) with time zone NOT NULL,
    rcp_status integer DEFAULT 0 NOT NULL,
    dt_update timestamp(0) with time zone,
    inn character varying(20),
    rcp_nmb text,
    rcp_contact text,
    rcp_fp character(10),
    dt_fp timestamp(0) with time zone,
    id_org_app integer,
    rcp_status_descr text,
    rcp_amount numeric(12,2),
    rcp_order jsonb,
    rcp_receipt jsonb,
    rcp_correction boolean DEFAULT false NOT NULL,
    rcp_received boolean DEFAULT false NOT NULL,
    rcp_notify_send boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_receipt_2 CHECK ((rcp_status = 2)),
    CONSTRAINT chk_receipt_2_2020_01_half CHECK (((dt_create >= '2020-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2020-07-01 00:00:00+03'::timestamp with time zone)))
);
ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2 ATTACH PARTITION fiscalization_part.fsc_receipt_2_2020_01_half FOR VALUES FROM ('2020-01-01 00:00:00+03') TO ('2020-07-01 00:00:00+03');


ALTER TABLE fiscalization_part.fsc_receipt_2_2020_01_half OWNER TO postgres;

--
-- TOC entry 587 (class 1259 OID 2115683)
-- Name: item_t; Type: TABLE; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE TABLE fsc_receipt_pcg.item_t OF public.item_t;


ALTER TABLE fsc_receipt_pcg.item_t OWNER TO postgres;

--
-- TOC entry 8588 (class 0 OID 0)
-- Dependencies: 587
-- Name: TABLE item_t; Type: COMMENT; Schema: fsc_receipt_pcg; Owner: postgres
--

COMMENT ON TABLE fsc_receipt_pcg.item_t IS 'Описание товара/услуги';


--
-- TOC entry 584 (class 1259 OID 2115501)
-- Name: version; Type: VIEW; Schema: fsc_receipt_pcg; Owner: postgres
--

CREATE VIEW fsc_receipt_pcg.version AS
 SELECT '$Revision:f57c3f3$ modified $RevDate:2023-07-17$'::text AS version;


ALTER TABLE fsc_receipt_pcg.version OWNER TO postgres;

--
-- TOC entry 591 (class 1259 OID 2120440)
-- Name: __abr_body; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.__abr_body (
    file_type text,
    id_pmt integer,
    p_date_1 text,
    sum_1 numeric(16,2),
    account_1 text,
    name_1 text,
    inn_1 text,
    name_2 text,
    bik_2 text,
    account_2 text,
    name_3 text,
    f1 text,
    f2 text,
    descr text,
    f3 text
);


ALTER TABLE public.__abr_body OWNER TO postgres;

--
-- TOC entry 592 (class 1259 OID 2120455)
-- Name: __pay_body; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.__pay_body (
    personal_account text,
    period text,
    doc_number text,
    f1 text,
    f2 text,
    f3 text,
    s_code text,
    pmt_date text,
    pmt_sum integer,
    inform text,
    sign_pmt text
);


ALTER TABLE public.__pay_body OWNER TO postgres;

--
-- TOC entry 594 (class 1259 OID 2120558)
-- Name: __pay_body_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.__pay_body_1 (
    id_pay integer NOT NULL,
    personal_account text,
    period text,
    doc_number text,
    f1 text,
    f2 text,
    f3 text,
    s_code text,
    pmt_date text,
    pmt_sum integer,
    inform text,
    sign_pmt text
);


ALTER TABLE public.__pay_body_1 OWNER TO postgres;

--
-- TOC entry 593 (class 1259 OID 2120556)
-- Name: __pay_body_1_id_pay_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.__pay_body_1_id_pay_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.__pay_body_1_id_pay_seq OWNER TO postgres;

--
-- TOC entry 8589 (class 0 OID 0)
-- Dependencies: 593
-- Name: __pay_body_1_id_pay_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.__pay_body_1_id_pay_seq OWNED BY public.__pay_body_1.id_pay;


--
-- TOC entry 595 (class 1259 OID 2120565)
-- Name: __pay_body_bad_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.__pay_body_bad_1 (
    dt_create timestamp(0) without time zone DEFAULT now() NOT NULL
)
INHERITS (public.__pay_body_1);


ALTER TABLE public.__pay_body_bad_1 OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 183095)
-- Name: app_app_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_app_id_seq
    START WITH 48
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.app_app_id_seq OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 46854)
-- Name: app; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app (
    app_id integer DEFAULT nextval('public.app_app_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    uuid character varying(255) NOT NULL,
    secret character varying(255) NOT NULL,
    name character varying(255),
    notification_url character varying(255),
    orange_key character varying(255)
);


ALTER TABLE public.app OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 46864)
-- Name: app_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_link (
    app_link_id integer NOT NULL,
    app_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.app_link OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 46867)
-- Name: app_link_app_link_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_link_app_link_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_link_app_link_id_seq OWNER TO postgres;

--
-- TOC entry 8593 (class 0 OID 0)
-- Dependencies: 237
-- Name: app_link_app_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_link_app_link_id_seq OWNED BY public.app_link.app_link_id;


--
-- TOC entry 238 (class 1259 OID 46869)
-- Name: org; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.org (
    org_id integer NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    name character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    active smallint NOT NULL,
    "group" character varying(32) NOT NULL,
    default_parameters json NOT NULL,
    kkt_count smallint NOT NULL
);


ALTER TABLE public.org OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 46877)
-- Name: org_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.org_link (
    org_link_id integer NOT NULL,
    app_id integer NOT NULL,
    org_id integer NOT NULL
);


ALTER TABLE public.org_link OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 46880)
-- Name: org_link_org_link_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.org_link_org_link_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.org_link_org_link_id_seq OWNER TO postgres;

--
-- TOC entry 8597 (class 0 OID 0)
-- Dependencies: 240
-- Name: org_link_org_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.org_link_org_link_id_seq OWNED BY public.org_link.org_link_id;


--
-- TOC entry 241 (class 1259 OID 46882)
-- Name: org_org_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.org_org_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.org_org_id_seq OWNER TO postgres;

--
-- TOC entry 8599 (class 0 OID 0)
-- Dependencies: 241
-- Name: org_org_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.org_org_id_seq OWNED BY public.org.org_id;


--
-- TOC entry 254 (class 1259 OID 167137)
-- Name: receipt_receipt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.receipt_receipt_id_seq
    START WITH 2147483647
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1000;


ALTER TABLE public.receipt_receipt_id_seq OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 907975)
-- Name: receipt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
)
PARTITION BY RANGE (dt_create);


ALTER TABLE public.receipt OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 110851)
-- Name: receipt_2018; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_2018 (
    receipt_id bigint DEFAULT NULL NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_2018 FOR VALUES FROM ('2018-01-01 00:00:00+03') TO ('2019-01-01 00:00:00+03');


ALTER TABLE public.receipt_2018 OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 110864)
-- Name: receipt_2019; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_2019 (
    receipt_id bigint DEFAULT NULL NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_2019 FOR VALUES FROM ('2019-01-01 00:00:00+03') TO ('2019-07-01 00:00:00+03');


ALTER TABLE public.receipt_2019 OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 908398)
-- Name: receipt_default; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_default (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_default DEFAULT;


ALTER TABLE public.receipt_default OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 46884)
-- Name: receipt_old; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_old (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_old OWNER TO postgres;

--
-- TOC entry 299 (class 1259 OID 1167968)
-- Name: receipt_part_2020_01; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2020_01 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_part_2020_01 OWNER TO postgres;

--
-- TOC entry 298 (class 1259 OID 1167955)
-- Name: receipt_part_2020_02; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2020_02 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_part_2020_02 OWNER TO postgres;

--
-- TOC entry 297 (class 1259 OID 1167942)
-- Name: receipt_part_2020_03; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2020_03 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_part_2020_03 OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 1167929)
-- Name: receipt_part_2020_04; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2020_04 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_part_2020_04 OWNER TO postgres;

--
-- TOC entry 295 (class 1259 OID 1167916)
-- Name: receipt_part_2020_05; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2020_05 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_part_2020_05 OWNER TO postgres;

--
-- TOC entry 294 (class 1259 OID 1167903)
-- Name: receipt_part_2020_06; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2020_06 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_part_2020_06 OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 1167890)
-- Name: receipt_part_2020_07; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2020_07 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_part_2020_07 OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 1167877)
-- Name: receipt_part_2020_08; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2020_08 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_part_2020_08 OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 1167864)
-- Name: receipt_part_2020_09; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2020_09 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_part_2020_09 OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 1167851)
-- Name: receipt_part_2020_10; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2020_10 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_part_2020_10 OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 1167838)
-- Name: receipt_part_2020_11; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2020_11 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_part_2020_11 OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 1167825)
-- Name: receipt_part_2020_12; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2020_12 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_part_2020_12 OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 1146791)
-- Name: receipt_part_2021_01; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2021_01 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_part_2021_01 FOR VALUES FROM ('2021-01-01 00:00:00+03') TO ('2021-02-01 00:00:00+03');


ALTER TABLE public.receipt_part_2021_01 OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 1146778)
-- Name: receipt_part_2021_02; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2021_02 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_part_2021_02 FOR VALUES FROM ('2021-02-01 00:00:00+03') TO ('2021-03-01 00:00:00+03');


ALTER TABLE public.receipt_part_2021_02 OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 1146765)
-- Name: receipt_part_2021_03; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2021_03 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_part_2021_03 FOR VALUES FROM ('2021-03-01 00:00:00+03') TO ('2021-04-01 00:00:00+03');


ALTER TABLE public.receipt_part_2021_03 OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 1146752)
-- Name: receipt_part_2021_04; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2021_04 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_part_2021_04 FOR VALUES FROM ('2021-04-01 00:00:00+03') TO ('2021-05-01 00:00:00+03');


ALTER TABLE public.receipt_part_2021_04 OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 1146739)
-- Name: receipt_part_2021_05; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2021_05 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_part_2021_05 FOR VALUES FROM ('2021-05-01 00:00:00+03') TO ('2021-06-01 00:00:00+03');


ALTER TABLE public.receipt_part_2021_05 OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 1146726)
-- Name: receipt_part_2021_06; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2021_06 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_part_2021_06 FOR VALUES FROM ('2021-06-01 00:00:00+03') TO ('2021-07-01 00:00:00+03');


ALTER TABLE public.receipt_part_2021_06 OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 1070950)
-- Name: receipt_part_2021_07; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2021_07 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_part_2021_07 FOR VALUES FROM ('2021-07-01 00:00:00+03') TO ('2021-08-01 00:00:00+03');


ALTER TABLE public.receipt_part_2021_07 OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 908597)
-- Name: receipt_part_2021_08; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2021_08 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_part_2021_08 FOR VALUES FROM ('2021-08-01 00:00:00+03') TO ('2021-09-01 00:00:00+03');


ALTER TABLE public.receipt_part_2021_08 OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 908584)
-- Name: receipt_part_2021_09; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2021_09 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_part_2021_09 FOR VALUES FROM ('2021-09-01 00:00:00+03') TO ('2021-10-01 00:00:00+03');


ALTER TABLE public.receipt_part_2021_09 OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 908571)
-- Name: receipt_part_2021_10; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2021_10 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_part_2021_10 FOR VALUES FROM ('2021-10-01 00:00:00+03') TO ('2021-11-01 00:00:00+03');


ALTER TABLE public.receipt_part_2021_10 OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 908359)
-- Name: receipt_part_2021_11; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2021_11 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_part_2021_11 FOR VALUES FROM ('2021-11-01 00:00:00+03') TO ('2021-12-01 00:00:00+03');


ALTER TABLE public.receipt_part_2021_11 OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 908372)
-- Name: receipt_part_2021_12; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2021_12 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_part_2021_12 FOR VALUES FROM ('2021-12-01 00:00:00+03') TO ('2022-01-01 00:00:00+03');


ALTER TABLE public.receipt_part_2021_12 OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 908385)
-- Name: receipt_part_2022_01; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_part_2022_01 (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);
ALTER TABLE ONLY public.receipt ATTACH PARTITION public.receipt_part_2022_01 FOR VALUES FROM ('2022-01-01 00:00:00+03') TO ('2022-02-01 00:00:00+03');


ALTER TABLE public.receipt_part_2022_01 OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 492554)
-- Name: receipt_status5; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_status5 (
    uid character varying,
    inn character varying,
    dt_create character varying
);


ALTER TABLE public.receipt_status5 OWNER TO postgres;

--
-- TOC entry 8606 (class 0 OID 0)
-- Dependencies: 271
-- Name: TABLE receipt_status5; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.receipt_status5 IS 'Таблица для статистика чеков со статусом 5';


--
-- TOC entry 277 (class 1259 OID 908559)
-- Name: receipt_work; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_work (
    receipt_id bigint DEFAULT nextval('public.receipt_receipt_id_seq'::regclass) NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    org_id integer NOT NULL,
    app_id integer NOT NULL,
    dt_fp timestamp(6) with time zone,
    fp character varying(255),
    "order" json NOT NULL,
    receipt json,
    uid character varying(255) NOT NULL,
    inn character varying(255) NOT NULL,
    amount real NOT NULL,
    contact character varying(255),
    correction smallint NOT NULL,
    notify_send smallint NOT NULL,
    receipt_received smallint NOT NULL,
    receipt_status integer DEFAULT 0,
    receipt_status_description character varying,
    attributes json
);


ALTER TABLE public.receipt_work OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 46895)
-- Name: report; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report (
    report_id integer NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    dt_work_start timestamp(6) with time zone,
    dt_work_complete timestamp(6) with time zone,
    uuid character varying(128),
    user_id integer NOT NULL,
    parameters json NOT NULL,
    receipt_id bigint,
    org_id bigint,
    app_id bigint,
    dt_fp timestamp without time zone
);


ALTER TABLE public.report OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 46903)
-- Name: report_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_report_id_seq OWNER TO postgres;

--
-- TOC entry 8609 (class 0 OID 0)
-- Dependencies: 244
-- Name: report_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.report_report_id_seq OWNED BY public.report.report_id;


--
-- TOC entry 245 (class 1259 OID 46905)
-- Name: test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test (
    test character varying(255),
    fp character varying(255),
    status smallint
);


ALTER TABLE public.test OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 46911)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    user_id integer NOT NULL,
    dt_create timestamp(6) with time zone DEFAULT now() NOT NULL,
    dt_update timestamp with time zone DEFAULT now() NOT NULL,
    dt_remove timestamp(6) with time zone,
    sso_login character varying(255),
    is_admin smallint,
    org_id integer
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 46916)
-- Name: usrr_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usrr_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usrr_user_id_seq OWNER TO postgres;

--
-- TOC entry 8613 (class 0 OID 0)
-- Dependencies: 247
-- Name: usrr_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usrr_user_id_seq OWNED BY public."user".user_id;


--
-- TOC entry 248 (class 1259 OID 46918)
-- Name: receipt_receipts_per_day_glougeq3_y1plbshy_1569943977443; Type: TABLE; Schema: stb_pre_aggregations; Owner: postgres
--

CREATE TABLE stb_pre_aggregations.receipt_receipts_per_day_glougeq3_y1plbshy_1569943977443 (
    org__name character varying(255),
    receipt__dt_create_date timestamp without time zone,
    receipt__count bigint
);


ALTER TABLE stb_pre_aggregations.receipt_receipts_per_day_glougeq3_y1plbshy_1569943977443 OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 46921)
-- Name: receipt_receipts_per_hour_4dpwxcnd_nkv4d0ns_1569944401838; Type: TABLE; Schema: stb_pre_aggregations; Owner: postgres
--

CREATE TABLE stb_pre_aggregations.receipt_receipts_per_hour_4dpwxcnd_nkv4d0ns_1569944401838 (
    org__name character varying(255),
    receipt__dt_create_hour timestamp without time zone,
    receipt__count bigint
);


ALTER TABLE stb_pre_aggregations.receipt_receipts_per_hour_4dpwxcnd_nkv4d0ns_1569944401838 OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 46924)
-- Name: receipt_receipts_per_month_2fykycdn_g4i2vokg_1569943983410; Type: TABLE; Schema: stb_pre_aggregations; Owner: postgres
--

CREATE TABLE stb_pre_aggregations.receipt_receipts_per_month_2fykycdn_g4i2vokg_1569943983410 (
    org__name character varying(255),
    receipt__dt_create_month timestamp without time zone,
    receipt__count bigint
);


ALTER TABLE stb_pre_aggregations.receipt_receipts_per_month_2fykycdn_g4i2vokg_1569943983410 OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 46927)
-- Name: receipt_receipts_per_week_ro0yvtck_sgf4bjzi_1569575036222; Type: TABLE; Schema: stb_pre_aggregations; Owner: postgres
--

CREATE TABLE stb_pre_aggregations.receipt_receipts_per_week_ro0yvtck_sgf4bjzi_1569575036222 (
    org__name character varying(255),
    receipt__dt_create_week timestamp without time zone,
    receipt__count bigint
);


ALTER TABLE stb_pre_aggregations.receipt_receipts_per_week_ro0yvtck_sgf4bjzi_1569575036222 OWNER TO postgres;

--
-- TOC entry 541 (class 1259 OID 2111625)
-- Name: ssp_cash_group; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.ssp_cash_group (
    id_cash_group integer NOT NULL,
    id_atol_group character varying(100),
    nm_group character varying(100),
    cash_qnt integer NOT NULL,
    org_inn character varying(100) NOT NULL
);


ALTER TABLE task.ssp_cash_group OWNER TO postgres;

--
-- TOC entry 8619 (class 0 OID 0)
-- Dependencies: 541
-- Name: TABLE ssp_cash_group; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON TABLE task.ssp_cash_group IS 'Ãðóïïà êàññ';


--
-- TOC entry 8620 (class 0 OID 0)
-- Dependencies: 541
-- Name: COLUMN ssp_cash_group.nm_group; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_cash_group.nm_group IS 'Íàèìåíîâàíèå ãðóïïû';


--
-- TOC entry 8621 (class 0 OID 0)
-- Dependencies: 541
-- Name: COLUMN ssp_cash_group.cash_qnt; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_cash_group.cash_qnt IS 'Êîëè÷åñòâî êàññ';


--
-- TOC entry 8622 (class 0 OID 0)
-- Dependencies: 541
-- Name: COLUMN ssp_cash_group.org_inn; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_cash_group.org_inn IS 'ÈÍÍ îðãàíèçàöèè';


--
-- TOC entry 542 (class 1259 OID 2111630)
-- Name: ssp_cash_register; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.ssp_cash_register (
    id_cash_register integer NOT NULL,
    id_cash_group integer,
    nm_cash_register text,
    url_cash_register text,
    ln_cash_register character varying(100),
    pw_cash_register character varying(100)
);


ALTER TABLE task.ssp_cash_register OWNER TO postgres;

--
-- TOC entry 8623 (class 0 OID 0)
-- Dependencies: 542
-- Name: TABLE ssp_cash_register; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON TABLE task.ssp_cash_register IS ' Êàññîâûé àïïàðàò';


--
-- TOC entry 8624 (class 0 OID 0)
-- Dependencies: 542
-- Name: COLUMN ssp_cash_register.id_cash_register; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_cash_register.id_cash_register IS 'ID êàññîâîãî àïïàðàòà';


--
-- TOC entry 8625 (class 0 OID 0)
-- Dependencies: 542
-- Name: COLUMN ssp_cash_register.nm_cash_register; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_cash_register.nm_cash_register IS 'Íàèìåíîâàíèå êàññîâîãî àïïàðàòà';


--
-- TOC entry 8626 (class 0 OID 0)
-- Dependencies: 542
-- Name: COLUMN ssp_cash_register.url_cash_register; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_cash_register.url_cash_register IS 'URL êàññîâîãî àïïàðàòà';


--
-- TOC entry 543 (class 1259 OID 2111638)
-- Name: ssp_fisc_ad_filters; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.ssp_fisc_ad_filters (
    id_row integer NOT NULL,
    id_filter integer NOT NULL,
    kd_filter_type integer NOT NULL,
    vl_filter text NOT NULL,
    vl_filter_name text
);


ALTER TABLE task.ssp_fisc_ad_filters OWNER TO postgres;

--
-- TOC entry 8627 (class 0 OID 0)
-- Dependencies: 543
-- Name: TABLE ssp_fisc_ad_filters; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON TABLE task.ssp_fisc_ad_filters IS 'Äîïîëíèòåëüíûé ôèëüòð';


--
-- TOC entry 8628 (class 0 OID 0)
-- Dependencies: 543
-- Name: COLUMN ssp_fisc_ad_filters.id_row; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_ad_filters.id_row IS 'ID ñòðîêè';


--
-- TOC entry 8629 (class 0 OID 0)
-- Dependencies: 543
-- Name: COLUMN ssp_fisc_ad_filters.id_filter; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_ad_filters.id_filter IS 'ID  ôèëüòðà';


--
-- TOC entry 8630 (class 0 OID 0)
-- Dependencies: 543
-- Name: COLUMN ssp_fisc_ad_filters.kd_filter_type; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_ad_filters.kd_filter_type IS 'ID òèïà ôèëüòðà';


--
-- TOC entry 8631 (class 0 OID 0)
-- Dependencies: 543
-- Name: COLUMN ssp_fisc_ad_filters.vl_filter; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_ad_filters.vl_filter IS 'Òåêñò ôèëüòðà';


--
-- TOC entry 8632 (class 0 OID 0)
-- Dependencies: 543
-- Name: COLUMN ssp_fisc_ad_filters.vl_filter_name; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_ad_filters.vl_filter_name IS 'Íàèìåíîâàíèå ôèëüòðà';


--
-- TOC entry 544 (class 1259 OID 2111646)
-- Name: ssp_fisc_filter; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.ssp_fisc_filter (
    id_filter integer NOT NULL,
    nm_filter character varying(100)
);


ALTER TABLE task.ssp_fisc_filter OWNER TO postgres;

--
-- TOC entry 8633 (class 0 OID 0)
-- Dependencies: 544
-- Name: TABLE ssp_fisc_filter; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON TABLE task.ssp_fisc_filter IS 'Ôèëüòð';


--
-- TOC entry 8634 (class 0 OID 0)
-- Dependencies: 544
-- Name: COLUMN ssp_fisc_filter.id_filter; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_filter.id_filter IS 'ID  ôèëüòðà';


--
-- TOC entry 8635 (class 0 OID 0)
-- Dependencies: 544
-- Name: COLUMN ssp_fisc_filter.nm_filter; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_filter.nm_filter IS 'Íàèìåíîâàíèå ôèëüòðà';


--
-- TOC entry 545 (class 1259 OID 2111651)
-- Name: ssp_fisc_filter_type; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.ssp_fisc_filter_type (
    kd_filter_type integer NOT NULL,
    nm_filter_type character varying(100)
);


ALTER TABLE task.ssp_fisc_filter_type OWNER TO postgres;

--
-- TOC entry 8636 (class 0 OID 0)
-- Dependencies: 545
-- Name: TABLE ssp_fisc_filter_type; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON TABLE task.ssp_fisc_filter_type IS 'Òèï ôèëüòðà';


--
-- TOC entry 8637 (class 0 OID 0)
-- Dependencies: 545
-- Name: COLUMN ssp_fisc_filter_type.kd_filter_type; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_filter_type.kd_filter_type IS 'ID òèïà ôèëüòðà';


--
-- TOC entry 8638 (class 0 OID 0)
-- Dependencies: 545
-- Name: COLUMN ssp_fisc_filter_type.nm_filter_type; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_filter_type.nm_filter_type IS 'Íàèìåíîâàíèå òèïà ôèëüòðà';


--
-- TOC entry 546 (class 1259 OID 2111656)
-- Name: ssp_fisc_link_task_filters; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.ssp_fisc_link_task_filters (
    id_row integer NOT NULL,
    id_filter integer NOT NULL,
    id_fisc_task integer NOT NULL,
    dt_create timestamp(0) without time zone,
    task_filter_status boolean NOT NULL
);


ALTER TABLE task.ssp_fisc_link_task_filters OWNER TO postgres;

--
-- TOC entry 8639 (class 0 OID 0)
-- Dependencies: 546
-- Name: TABLE ssp_fisc_link_task_filters; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON TABLE task.ssp_fisc_link_task_filters IS 'Ñâÿçü ôèëüòðà è çàäà÷è';


--
-- TOC entry 8640 (class 0 OID 0)
-- Dependencies: 546
-- Name: COLUMN ssp_fisc_link_task_filters.id_row; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_link_task_filters.id_row IS 'ID_ñòðîêè';


--
-- TOC entry 8641 (class 0 OID 0)
-- Dependencies: 546
-- Name: COLUMN ssp_fisc_link_task_filters.id_filter; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_link_task_filters.id_filter IS 'ID  ôèëüòðà';


--
-- TOC entry 8642 (class 0 OID 0)
-- Dependencies: 546
-- Name: COLUMN ssp_fisc_link_task_filters.id_fisc_task; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_link_task_filters.id_fisc_task IS 'ID Çàäà÷è';


--
-- TOC entry 8643 (class 0 OID 0)
-- Dependencies: 546
-- Name: COLUMN ssp_fisc_link_task_filters.dt_create; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_link_task_filters.dt_create IS 'Äàòà ñîçäàíèÿ ñâÿçè';


--
-- TOC entry 8644 (class 0 OID 0)
-- Dependencies: 546
-- Name: COLUMN ssp_fisc_link_task_filters.task_filter_status; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_link_task_filters.task_filter_status IS 'Ñòàòóñ ñâÿçè';


--
-- TOC entry 547 (class 1259 OID 2111663)
-- Name: ssp_fisc_task; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.ssp_fisc_task (
    id_fisc_task integer NOT NULL,
    dt_from timestamp(0) without time zone NOT NULL,
    dt_to timestamp(0) without time zone NOT NULL,
    id_cash_group integer NOT NULL,
    dt_start timestamp(0) without time zone,
    dt_end timestamp(0) without time zone,
    kd_fisc_task_type integer NOT NULL,
    kd_fisc_task_state integer NOT NULL,
    qnt_send integer,
    qnt_success integer,
    qnt_errors integer,
    nm_task character varying(100) NOT NULL,
    task_stage character varying(100),
    dt_create timestamp(0) without time zone NOT NULL,
    sm_success integer,
    sm_errors integer
);


ALTER TABLE task.ssp_fisc_task OWNER TO postgres;

--
-- TOC entry 8645 (class 0 OID 0)
-- Dependencies: 547
-- Name: TABLE ssp_fisc_task; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON TABLE task.ssp_fisc_task IS 'Çàäà÷à ôèñêàëèçàöèè';


--
-- TOC entry 8646 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.id_fisc_task; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.id_fisc_task IS 'ID Çàäà÷è';


--
-- TOC entry 8647 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.dt_from; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.dt_from IS 'Äàòà íà÷àëà àêòóàëüíîñòè';


--
-- TOC entry 8648 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.dt_to; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.dt_to IS 'Äàòà çàâåðøåíèÿ àêòóàëüíîñòè';


--
-- TOC entry 8649 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.id_cash_group; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.id_cash_group IS 'ID ãðóïïû êàññ';


--
-- TOC entry 8650 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.dt_start; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.dt_start IS 'Äàòà íà÷àëà âûïîëíåíèÿ';


--
-- TOC entry 8651 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.dt_end; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.dt_end IS 'Äàòà çàâåðøåíèÿ';


--
-- TOC entry 8652 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.kd_fisc_task_type; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.kd_fisc_task_type IS 'ID Òèïà çàäà÷è';


--
-- TOC entry 8653 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.kd_fisc_task_state; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.kd_fisc_task_state IS 'ID Ñòàòóñà çàäà÷è';


--
-- TOC entry 8654 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.qnt_send; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.qnt_send IS 'Êîëè÷åñòâî îòîñëàííûõ ÷åêîâ';


--
-- TOC entry 8655 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.qnt_success; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.qnt_success IS 'Êîëè÷åñòâî óñïåøíûõ ÷åêîâ';


--
-- TOC entry 8656 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.qnt_errors; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.qnt_errors IS 'Êîëè÷åñòâî îøèáî÷íûõ ÷åêîâ';


--
-- TOC entry 8657 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.nm_task; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.nm_task IS 'Íàèìåíîâàíèå çàäà÷è';


--
-- TOC entry 8658 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.task_stage; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.task_stage IS 'Ýòàï çàäà÷è';


--
-- TOC entry 8659 (class 0 OID 0)
-- Dependencies: 547
-- Name: COLUMN ssp_fisc_task.dt_create; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task.dt_create IS 'Äàòà ñîçäàíèÿ çàäà÷è';


--
-- TOC entry 548 (class 1259 OID 2111668)
-- Name: ssp_fisc_task_state; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.ssp_fisc_task_state (
    kd_fisc_task_state integer NOT NULL,
    nm_fisc_task_state character varying(100)
);


ALTER TABLE task.ssp_fisc_task_state OWNER TO postgres;

--
-- TOC entry 8660 (class 0 OID 0)
-- Dependencies: 548
-- Name: TABLE ssp_fisc_task_state; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON TABLE task.ssp_fisc_task_state IS 'Ñòàòóñ çàäà÷è ôèñêàëèçàöèè';


--
-- TOC entry 8661 (class 0 OID 0)
-- Dependencies: 548
-- Name: COLUMN ssp_fisc_task_state.kd_fisc_task_state; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task_state.kd_fisc_task_state IS 'ID Ñòàòóñà çàäà÷è';


--
-- TOC entry 8662 (class 0 OID 0)
-- Dependencies: 548
-- Name: COLUMN ssp_fisc_task_state.nm_fisc_task_state; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task_state.nm_fisc_task_state IS 'Íàèìåíîâàíèå ñòàòóñà çàäà÷è';


--
-- TOC entry 549 (class 1259 OID 2111673)
-- Name: ssp_fisc_task_type; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.ssp_fisc_task_type (
    kd_fisc_task_type integer NOT NULL,
    nm_fisc_task_type character varying(100)
);


ALTER TABLE task.ssp_fisc_task_type OWNER TO postgres;

--
-- TOC entry 8663 (class 0 OID 0)
-- Dependencies: 549
-- Name: TABLE ssp_fisc_task_type; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON TABLE task.ssp_fisc_task_type IS 'Òèï çàäà÷è ôèñêàëèçàöèè';


--
-- TOC entry 8664 (class 0 OID 0)
-- Dependencies: 549
-- Name: COLUMN ssp_fisc_task_type.kd_fisc_task_type; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task_type.kd_fisc_task_type IS 'ID Òèïà çàäà÷è';


--
-- TOC entry 8665 (class 0 OID 0)
-- Dependencies: 549
-- Name: COLUMN ssp_fisc_task_type.nm_fisc_task_type; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_fisc_task_type.nm_fisc_task_type IS 'Íàèìåíîâàíèå òèïà';


--
-- TOC entry 550 (class 1259 OID 2111678)
-- Name: ssp_pay_corrparams_fisc; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.ssp_pay_corrparams_fisc (
    id_pay_corrparams integer NOT NULL,
    id_fisc_task integer NOT NULL,
    type_corr character varying(500) NOT NULL,
    dt_doc timestamp(0) without time zone NOT NULL,
    nn_doc character varying(100) NOT NULL,
    nm_corr text
);


ALTER TABLE task.ssp_pay_corrparams_fisc OWNER TO postgres;

--
-- TOC entry 8666 (class 0 OID 0)
-- Dependencies: 550
-- Name: TABLE ssp_pay_corrparams_fisc; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON TABLE task.ssp_pay_corrparams_fisc IS 'Îñíîâàíèå êîððåêöèè';


--
-- TOC entry 8667 (class 0 OID 0)
-- Dependencies: 550
-- Name: COLUMN ssp_pay_corrparams_fisc.id_pay_corrparams; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_corrparams_fisc.id_pay_corrparams IS 'ID îñíîâàíèÿ êîððåêöèè';


--
-- TOC entry 8668 (class 0 OID 0)
-- Dependencies: 550
-- Name: COLUMN ssp_pay_corrparams_fisc.id_fisc_task; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_corrparams_fisc.id_fisc_task IS 'ID Çàäà÷è';


--
-- TOC entry 8669 (class 0 OID 0)
-- Dependencies: 550
-- Name: COLUMN ssp_pay_corrparams_fisc.type_corr; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_corrparams_fisc.type_corr IS 'Òèï êîððåêöèè';


--
-- TOC entry 8670 (class 0 OID 0)
-- Dependencies: 550
-- Name: COLUMN ssp_pay_corrparams_fisc.dt_doc; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_corrparams_fisc.dt_doc IS 'Äàòà äîêóìåíòà îñíîâàíèÿ';


--
-- TOC entry 8671 (class 0 OID 0)
-- Dependencies: 550
-- Name: COLUMN ssp_pay_corrparams_fisc.nn_doc; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_corrparams_fisc.nn_doc IS 'Íîìåð äîêóìåíòà îñíîâàíèÿ';


--
-- TOC entry 8672 (class 0 OID 0)
-- Dependencies: 550
-- Name: COLUMN ssp_pay_corrparams_fisc.nm_corr; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_corrparams_fisc.nm_corr IS 'Îïèñàíèå êîððåêöèè';


--
-- TOC entry 551 (class 1259 OID 2111686)
-- Name: ssp_pay_hist_fisc; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.ssp_pay_hist_fisc (
    id_pay_fisc integer NOT NULL,
    id_pay integer NOT NULL,
    type_object integer NOT NULL,
    nn_pay_kkt character varying(50),
    dt_pay_fisc timestamp(0) without time zone NOT NULL,
    kd_oper_type integer NOT NULL,
    kd_error integer,
    kd_error_type integer,
    kd_state_pay_hist integer NOT NULL,
    fisc_uid uuid NOT NULL,
    fisc_info text
);


ALTER TABLE task.ssp_pay_hist_fisc OWNER TO postgres;

--
-- TOC entry 8673 (class 0 OID 0)
-- Dependencies: 551
-- Name: TABLE ssp_pay_hist_fisc; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON TABLE task.ssp_pay_hist_fisc IS 'Èñòîðèÿ ïëàòåæà â îíëàéí-êàññå';


--
-- TOC entry 8674 (class 0 OID 0)
-- Dependencies: 551
-- Name: COLUMN ssp_pay_hist_fisc.id_pay_fisc; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_hist_fisc.id_pay_fisc IS 'ID çàïèñè';


--
-- TOC entry 8675 (class 0 OID 0)
-- Dependencies: 551
-- Name: COLUMN ssp_pay_hist_fisc.id_pay; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_hist_fisc.id_pay IS 'ID ïëàòåæà';


--
-- TOC entry 8676 (class 0 OID 0)
-- Dependencies: 551
-- Name: COLUMN ssp_pay_hist_fisc.type_object; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_hist_fisc.type_object IS 'Òèï îáúåêòà';


--
-- TOC entry 8677 (class 0 OID 0)
-- Dependencies: 551
-- Name: COLUMN ssp_pay_hist_fisc.nn_pay_kkt; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_hist_fisc.nn_pay_kkt IS 'Íîìåð ïëàòåæà â îíëàéí-êàññå';


--
-- TOC entry 8678 (class 0 OID 0)
-- Dependencies: 551
-- Name: COLUMN ssp_pay_hist_fisc.dt_pay_fisc; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_hist_fisc.dt_pay_fisc IS 'Äàòà ôèñêàëèçàöèè';


--
-- TOC entry 8679 (class 0 OID 0)
-- Dependencies: 551
-- Name: COLUMN ssp_pay_hist_fisc.kd_oper_type; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_hist_fisc.kd_oper_type IS 'Êîä îïåðàöèè';


--
-- TOC entry 8680 (class 0 OID 0)
-- Dependencies: 551
-- Name: COLUMN ssp_pay_hist_fisc.kd_error; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_hist_fisc.kd_error IS 'Êîä îøèáêè';


--
-- TOC entry 8681 (class 0 OID 0)
-- Dependencies: 551
-- Name: COLUMN ssp_pay_hist_fisc.kd_error_type; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_hist_fisc.kd_error_type IS 'Òèï îøèáêè';


--
-- TOC entry 8682 (class 0 OID 0)
-- Dependencies: 551
-- Name: COLUMN ssp_pay_hist_fisc.kd_state_pay_hist; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_hist_fisc.kd_state_pay_hist IS 'Ñòàòóñ ïëàòåæà â îíëàéí-êàññå';


--
-- TOC entry 8683 (class 0 OID 0)
-- Dependencies: 551
-- Name: COLUMN ssp_pay_hist_fisc.fisc_uid; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_hist_fisc.fisc_uid IS 'Óíèêàëüíûé èäåíòèôèêàòîð';


--
-- TOC entry 8684 (class 0 OID 0)
-- Dependencies: 551
-- Name: COLUMN ssp_pay_hist_fisc.fisc_info; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_hist_fisc.fisc_info IS 'Ôèñêàëüíàÿ èíôîðìàöèÿ';


--
-- TOC entry 552 (class 1259 OID 2111696)
-- Name: ssp_pay_link_fisc; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.ssp_pay_link_fisc (
    id_link integer NOT NULL,
    id_pay integer,
    id_pay_kkt character varying(100) NOT NULL,
    id_pay_fisc integer NOT NULL,
    kd_state_pay_hist integer NOT NULL,
    id_fisc_task integer NOT NULL
);


ALTER TABLE task.ssp_pay_link_fisc OWNER TO postgres;

--
-- TOC entry 8685 (class 0 OID 0)
-- Dependencies: 552
-- Name: TABLE ssp_pay_link_fisc; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON TABLE task.ssp_pay_link_fisc IS 'Ðåêâèçèòû ôèñêàëèçàöèè äîêóìåíòà';


--
-- TOC entry 8686 (class 0 OID 0)
-- Dependencies: 552
-- Name: COLUMN ssp_pay_link_fisc.id_link; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_link_fisc.id_link IS 'ID çàïèñè';


--
-- TOC entry 8687 (class 0 OID 0)
-- Dependencies: 552
-- Name: COLUMN ssp_pay_link_fisc.id_pay; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_link_fisc.id_pay IS 'ID ïëàòåæà';


--
-- TOC entry 8688 (class 0 OID 0)
-- Dependencies: 552
-- Name: COLUMN ssp_pay_link_fisc.id_pay_kkt; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_link_fisc.id_pay_kkt IS 'ID ïëàòåæà â îíëàéí êàññå';


--
-- TOC entry 8689 (class 0 OID 0)
-- Dependencies: 552
-- Name: COLUMN ssp_pay_link_fisc.id_pay_fisc; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_link_fisc.id_pay_fisc IS 'ID èñòîðèè ïëàòåæà â îíëàéí-êàññå';


--
-- TOC entry 8690 (class 0 OID 0)
-- Dependencies: 552
-- Name: COLUMN ssp_pay_link_fisc.kd_state_pay_hist; Type: COMMENT; Schema: task; Owner: postgres
--

COMMENT ON COLUMN task.ssp_pay_link_fisc.kd_state_pay_hist IS 'Êîä ñòàòóñà ïëàòåæà â îíëàéí-êàññå';


--
-- TOC entry 5462 (class 2604 OID 1512121)
-- Name: fsc_service id_service; Type: DEFAULT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_service ALTER COLUMN id_service SET DEFAULT nextval('"_OLD_1_fiscalization".fsc_service_id_srv_seq'::regclass);


--
-- TOC entry 5464 (class 2604 OID 1512256)
-- Name: d_base id_dict; Type: DEFAULT; Schema: dict; Owner: postgres
--

ALTER TABLE ONLY dict.d_base ALTER COLUMN id_dict SET DEFAULT nextval('dict.d_base_id_dict_seq'::regclass);


--
-- TOC entry 6188 (class 2604 OID 2120783)
-- Name: metadata id_metadata; Type: DEFAULT; Schema: dict; Owner: postgres
--

ALTER TABLE ONLY dict.metadata ALTER COLUMN id_metadata SET DEFAULT nextval('dict.metadata_id_metadata_seq'::regclass);


--
-- TOC entry 5466 (class 2604 OID 1512288)
-- Name: ssp_org_type id_dict; Type: DEFAULT; Schema: dict; Owner: postgres
--

ALTER TABLE ONLY dict.ssp_org_type ALTER COLUMN id_dict SET DEFAULT nextval('dict.d_base_id_dict_seq'::regclass);


--
-- TOC entry 5467 (class 2604 OID 1512289)
-- Name: ssp_org_type is_remove; Type: DEFAULT; Schema: dict; Owner: postgres
--

ALTER TABLE ONLY dict.ssp_org_type ALTER COLUMN is_remove SET DEFAULT false;


--
-- TOC entry 5506 (class 2604 OID 1607904)
-- Name: ssp_pmt_type id_dict; Type: DEFAULT; Schema: dict; Owner: postgres
--

ALTER TABLE ONLY dict.ssp_pmt_type ALTER COLUMN id_dict SET DEFAULT nextval('dict.d_base_id_dict_seq'::regclass);


--
-- TOC entry 5507 (class 2604 OID 1607905)
-- Name: ssp_pmt_type is_remove; Type: DEFAULT; Schema: dict; Owner: postgres
--

ALTER TABLE ONLY dict.ssp_pmt_type ALTER COLUMN is_remove SET DEFAULT false;


--
-- TOC entry 6185 (class 2604 OID 2120561)
-- Name: __pay_body_1 id_pay; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.__pay_body_1 ALTER COLUMN id_pay SET DEFAULT nextval('public.__pay_body_1_id_pay_seq'::regclass);


--
-- TOC entry 6186 (class 2604 OID 2120568)
-- Name: __pay_body_bad_1 id_pay; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.__pay_body_bad_1 ALTER COLUMN id_pay SET DEFAULT nextval('public.__pay_body_1_id_pay_seq'::regclass);


--
-- TOC entry 5234 (class 2604 OID 46931)
-- Name: app_link app_link_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_link ALTER COLUMN app_link_id SET DEFAULT nextval('public.app_link_app_link_id_seq'::regclass);


--
-- TOC entry 5235 (class 2604 OID 46932)
-- Name: org org_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org ALTER COLUMN org_id SET DEFAULT nextval('public.org_org_id_seq'::regclass);


--
-- TOC entry 5238 (class 2604 OID 46933)
-- Name: org_link org_link_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_link ALTER COLUMN org_link_id SET DEFAULT nextval('public.org_link_org_link_id_seq'::regclass);


--
-- TOC entry 5244 (class 2604 OID 46935)
-- Name: report report_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report ALTER COLUMN report_id SET DEFAULT nextval('public.report_report_id_seq'::regclass);


--
-- TOC entry 5247 (class 2604 OID 46936)
-- Name: user user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN user_id SET DEFAULT nextval('public.usrr_user_id_seq'::regclass);


--
-- TOC entry 6495 (class 2606 OID 1510331)
-- Name: fsc_app_kkt_group ak1_app_kkt_group; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_app_kkt_group
    ADD CONSTRAINT ak1_app_kkt_group UNIQUE (id_kkt_group, id_app);


--
-- TOC entry 6509 (class 2606 OID 1510347)
-- Name: fsc_org_app ak1_org_app; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_org_app
    ADD CONSTRAINT ak1_org_app UNIQUE (id_app, id_org);


--
-- TOC entry 6519 (class 2606 OID 1510367)
-- Name: fsk_route ak1_route; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsk_route
    ADD CONSTRAINT ak1_route UNIQUE (id_fsc_provider, id_org);


--
-- TOC entry 6529 (class 2606 OID 1510835)
-- Name: fsc_payment pk_fsc_payment; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment
    ADD CONSTRAINT pk_fsc_payment PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6555 (class 2606 OID 1512016)
-- Name: fsc_payment_default fsc_payment_default_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment_default
    ADD CONSTRAINT fsc_payment_default_pkey PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6531 (class 2606 OID 1511836)
-- Name: fsc_payment_part_2021_01 fsc_payment_part_2021_01_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment_part_2021_01
    ADD CONSTRAINT fsc_payment_part_2021_01_pkey PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6533 (class 2606 OID 1511851)
-- Name: fsc_payment_part_2021_02 fsc_payment_part_2021_02_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment_part_2021_02
    ADD CONSTRAINT fsc_payment_part_2021_02_pkey PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6535 (class 2606 OID 1511866)
-- Name: fsc_payment_part_2021_03 fsc_payment_part_2021_03_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment_part_2021_03
    ADD CONSTRAINT fsc_payment_part_2021_03_pkey PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6537 (class 2606 OID 1511881)
-- Name: fsc_payment_part_2021_04 fsc_payment_part_2021_04_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment_part_2021_04
    ADD CONSTRAINT fsc_payment_part_2021_04_pkey PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6539 (class 2606 OID 1511896)
-- Name: fsc_payment_part_2021_05 fsc_payment_part_2021_05_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment_part_2021_05
    ADD CONSTRAINT fsc_payment_part_2021_05_pkey PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6541 (class 2606 OID 1511911)
-- Name: fsc_payment_part_2021_06 fsc_payment_part_2021_06_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment_part_2021_06
    ADD CONSTRAINT fsc_payment_part_2021_06_pkey PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6543 (class 2606 OID 1511926)
-- Name: fsc_payment_part_2021_07 fsc_payment_part_2021_07_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment_part_2021_07
    ADD CONSTRAINT fsc_payment_part_2021_07_pkey PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6545 (class 2606 OID 1511941)
-- Name: fsc_payment_part_2021_08 fsc_payment_part_2021_08_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment_part_2021_08
    ADD CONSTRAINT fsc_payment_part_2021_08_pkey PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6547 (class 2606 OID 1511956)
-- Name: fsc_payment_part_2021_09 fsc_payment_part_2021_09_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment_part_2021_09
    ADD CONSTRAINT fsc_payment_part_2021_09_pkey PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6549 (class 2606 OID 1511971)
-- Name: fsc_payment_part_2021_10 fsc_payment_part_2021_10_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment_part_2021_10
    ADD CONSTRAINT fsc_payment_part_2021_10_pkey PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6551 (class 2606 OID 1511986)
-- Name: fsc_payment_part_2021_11 fsc_payment_part_2021_11_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment_part_2021_11
    ADD CONSTRAINT fsc_payment_part_2021_11_pkey PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6553 (class 2606 OID 1512001)
-- Name: fsc_payment_part_2021_12 fsc_payment_part_2021_12_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_payment_part_2021_12
    ADD CONSTRAINT fsc_payment_part_2021_12_pkey PRIMARY KEY (id_payment, dt_payment);


--
-- TOC entry 6565 (class 2606 OID 1512300)
-- Name: fsc_receipt pk_fsc_receipt; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt
    ADD CONSTRAINT pk_fsc_receipt PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6591 (class 2606 OID 1512505)
-- Name: fsc_receipt_default fsc_receipt_default_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_default
    ADD CONSTRAINT fsc_receipt_default_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6593 (class 2606 OID 1512565)
-- Name: fsc_receipt_js pk_fsc_receipt_js; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js
    ADD CONSTRAINT pk_fsc_receipt_js PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6619 (class 2606 OID 1512755)
-- Name: fsc_receipt_js_default fsc_receipt_js_default_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js_default
    ADD CONSTRAINT fsc_receipt_js_default_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6595 (class 2606 OID 1512611)
-- Name: fsc_receipt_js_part_2021_01 fsc_receipt_js_part_2021_01_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js_part_2021_01
    ADD CONSTRAINT fsc_receipt_js_part_2021_01_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6597 (class 2606 OID 1512623)
-- Name: fsc_receipt_js_part_2021_02 fsc_receipt_js_part_2021_02_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js_part_2021_02
    ADD CONSTRAINT fsc_receipt_js_part_2021_02_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6599 (class 2606 OID 1512635)
-- Name: fsc_receipt_js_part_2021_03 fsc_receipt_js_part_2021_03_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js_part_2021_03
    ADD CONSTRAINT fsc_receipt_js_part_2021_03_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6601 (class 2606 OID 1512647)
-- Name: fsc_receipt_js_part_2021_04 fsc_receipt_js_part_2021_04_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js_part_2021_04
    ADD CONSTRAINT fsc_receipt_js_part_2021_04_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6603 (class 2606 OID 1512659)
-- Name: fsc_receipt_js_part_2021_05 fsc_receipt_js_part_2021_05_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js_part_2021_05
    ADD CONSTRAINT fsc_receipt_js_part_2021_05_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6605 (class 2606 OID 1512671)
-- Name: fsc_receipt_js_part_2021_06 fsc_receipt_js_part_2021_06_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js_part_2021_06
    ADD CONSTRAINT fsc_receipt_js_part_2021_06_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6607 (class 2606 OID 1512683)
-- Name: fsc_receipt_js_part_2021_07 fsc_receipt_js_part_2021_07_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js_part_2021_07
    ADD CONSTRAINT fsc_receipt_js_part_2021_07_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6609 (class 2606 OID 1512695)
-- Name: fsc_receipt_js_part_2021_08 fsc_receipt_js_part_2021_08_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js_part_2021_08
    ADD CONSTRAINT fsc_receipt_js_part_2021_08_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6611 (class 2606 OID 1512707)
-- Name: fsc_receipt_js_part_2021_09 fsc_receipt_js_part_2021_09_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js_part_2021_09
    ADD CONSTRAINT fsc_receipt_js_part_2021_09_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6613 (class 2606 OID 1512719)
-- Name: fsc_receipt_js_part_2021_10 fsc_receipt_js_part_2021_10_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js_part_2021_10
    ADD CONSTRAINT fsc_receipt_js_part_2021_10_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6615 (class 2606 OID 1512731)
-- Name: fsc_receipt_js_part_2021_11 fsc_receipt_js_part_2021_11_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js_part_2021_11
    ADD CONSTRAINT fsc_receipt_js_part_2021_11_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6617 (class 2606 OID 1512743)
-- Name: fsc_receipt_js_part_2021_12 fsc_receipt_js_part_2021_12_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_js_part_2021_12
    ADD CONSTRAINT fsc_receipt_js_part_2021_12_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6567 (class 2606 OID 1512313)
-- Name: fsc_receipt_part_2021_01 fsc_receipt_part_2021_01_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_part_2021_01
    ADD CONSTRAINT fsc_receipt_part_2021_01_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6569 (class 2606 OID 1512329)
-- Name: fsc_receipt_part_2021_02 fsc_receipt_part_2021_02_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_part_2021_02
    ADD CONSTRAINT fsc_receipt_part_2021_02_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6571 (class 2606 OID 1512345)
-- Name: fsc_receipt_part_2021_03 fsc_receipt_part_2021_03_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_part_2021_03
    ADD CONSTRAINT fsc_receipt_part_2021_03_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6573 (class 2606 OID 1512361)
-- Name: fsc_receipt_part_2021_04 fsc_receipt_part_2021_04_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_part_2021_04
    ADD CONSTRAINT fsc_receipt_part_2021_04_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6575 (class 2606 OID 1512377)
-- Name: fsc_receipt_part_2021_05 fsc_receipt_part_2021_05_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_part_2021_05
    ADD CONSTRAINT fsc_receipt_part_2021_05_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6577 (class 2606 OID 1512393)
-- Name: fsc_receipt_part_2021_06 fsc_receipt_part_2021_06_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_part_2021_06
    ADD CONSTRAINT fsc_receipt_part_2021_06_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6579 (class 2606 OID 1512409)
-- Name: fsc_receipt_part_2021_07 fsc_receipt_part_2021_07_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_part_2021_07
    ADD CONSTRAINT fsc_receipt_part_2021_07_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6581 (class 2606 OID 1512425)
-- Name: fsc_receipt_part_2021_08 fsc_receipt_part_2021_08_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_part_2021_08
    ADD CONSTRAINT fsc_receipt_part_2021_08_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6583 (class 2606 OID 1512441)
-- Name: fsc_receipt_part_2021_09 fsc_receipt_part_2021_09_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_part_2021_09
    ADD CONSTRAINT fsc_receipt_part_2021_09_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6585 (class 2606 OID 1512457)
-- Name: fsc_receipt_part_2021_10 fsc_receipt_part_2021_10_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_part_2021_10
    ADD CONSTRAINT fsc_receipt_part_2021_10_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6587 (class 2606 OID 1512473)
-- Name: fsc_receipt_part_2021_11 fsc_receipt_part_2021_11_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_part_2021_11
    ADD CONSTRAINT fsc_receipt_part_2021_11_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6589 (class 2606 OID 1512489)
-- Name: fsc_receipt_part_2021_12 fsc_receipt_part_2021_12_pkey; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_receipt_part_2021_12
    ADD CONSTRAINT fsc_receipt_part_2021_12_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6523 (class 2606 OID 1510516)
-- Name: fsc_app pk_fsc_app; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_app
    ADD CONSTRAINT pk_fsc_app PRIMARY KEY (id_app);


--
-- TOC entry 6497 (class 2606 OID 1510329)
-- Name: fsc_app_kkt_group pk_fsc_app_kkt_group; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_app_kkt_group
    ADD CONSTRAINT pk_fsc_app_kkt_group PRIMARY KEY (id_app_kkt_group);


--
-- TOC entry 6499 (class 2606 OID 1510333)
-- Name: fsc_appeal pk_fsc_appeal; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_appeal
    ADD CONSTRAINT pk_fsc_appeal PRIMARY KEY (id_appeal);


--
-- TOC entry 6501 (class 2606 OID 1510335)
-- Name: fsc_data_operator pk_fsc_data_operator; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_data_operator
    ADD CONSTRAINT pk_fsc_data_operator PRIMARY KEY (id_fsc_data_operator);


--
-- TOC entry 6503 (class 2606 OID 1510337)
-- Name: fsc_filter pk_fsc_filter; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_filter
    ADD CONSTRAINT pk_fsc_filter PRIMARY KEY (id_filter);


--
-- TOC entry 6505 (class 2606 OID 1510339)
-- Name: fsc_kkt pk_fsc_kkt; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_kkt
    ADD CONSTRAINT pk_fsc_kkt PRIMARY KEY (id_kkt);


--
-- TOC entry 6507 (class 2606 OID 1510341)
-- Name: fsc_kkt_groupe pk_fsc_kkt_groupe; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_kkt_groupe
    ADD CONSTRAINT pk_fsc_kkt_groupe PRIMARY KEY (id_kkt_group);


--
-- TOC entry 6525 (class 2606 OID 1510534)
-- Name: fsc_org pk_fsc_org; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_org
    ADD CONSTRAINT pk_fsc_org PRIMARY KEY (id_org);


--
-- TOC entry 6511 (class 2606 OID 1510345)
-- Name: fsc_org_app pk_fsc_org_app; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_org_app
    ADD CONSTRAINT pk_fsc_org_app PRIMARY KEY (id_org_app);


--
-- TOC entry 6513 (class 2606 OID 1510351)
-- Name: fsc_provider pk_fsc_provider; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_provider
    ADD CONSTRAINT pk_fsc_provider PRIMARY KEY (id_fsc_provider);


--
-- TOC entry 6623 (class 2606 OID 1607929)
-- Name: fsc_report pk_fsc_report; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_report
    ADD CONSTRAINT pk_fsc_report PRIMARY KEY (id_report);


--
-- TOC entry 6557 (class 2606 OID 1512126)
-- Name: fsc_service pk_fsc_service; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_service
    ADD CONSTRAINT pk_fsc_service PRIMARY KEY (id_service);


--
-- TOC entry 6515 (class 2606 OID 1510359)
-- Name: fsc_storage pk_fsc_storage; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_storage
    ADD CONSTRAINT pk_fsc_storage PRIMARY KEY (id_fsc_storage);


--
-- TOC entry 6517 (class 2606 OID 1510361)
-- Name: fsc_task pk_fsc_task; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_task
    ADD CONSTRAINT pk_fsc_task PRIMARY KEY (id_task);


--
-- TOC entry 6527 (class 2606 OID 1510572)
-- Name: fsc_user pk_fsc_user; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_user
    ADD CONSTRAINT pk_fsc_user PRIMARY KEY (id_user);


--
-- TOC entry 6521 (class 2606 OID 1510365)
-- Name: fsk_route pk_fsk_route; Type: CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsk_route
    ADD CONSTRAINT pk_fsk_route PRIMARY KEY (id_fsc_route);


--
-- TOC entry 6625 (class 2606 OID 1614877)
-- Name: fsc_app ak1_app; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_app
    ADD CONSTRAINT ak1_app UNIQUE (app_guid);


--
-- TOC entry 6629 (class 2606 OID 1611446)
-- Name: fsc_app_fsc_provider ak1_app_kkt_group; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_app_fsc_provider
    ADD CONSTRAINT ak1_app_kkt_group UNIQUE (id_app);


--
-- TOC entry 6667 (class 2606 OID 1614879)
-- Name: fsc_org ak1_org; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_org
    ADD CONSTRAINT ak1_org UNIQUE (inn);


--
-- TOC entry 6671 (class 2606 OID 1611610)
-- Name: fsc_org_app ak1_org_app; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_org_app
    ADD CONSTRAINT ak1_org_app UNIQUE (id_app, id_org);


--
-- TOC entry 6677 (class 2606 OID 1614848)
-- Name: fsc_receipt ak1_receipt; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt
    ADD CONSTRAINT ak1_receipt UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6879 (class 2606 OID 1614891)
-- Name: fsc_report ak1_report; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_report
    ADD CONSTRAINT ak1_report UNIQUE (rpt_guid);


--
-- TOC entry 6639 (class 2606 OID 1611477)
-- Name: fsc_order pk_order; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order
    ADD CONSTRAINT pk_order PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6665 (class 2606 OID 1611590)
-- Name: fsc_order_default fsc_order_default_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order_default
    ADD CONSTRAINT fsc_order_default_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6641 (class 2606 OID 1611482)
-- Name: fsc_order_part_2021_01 fsc_order_part_2021_01_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order_part_2021_01
    ADD CONSTRAINT fsc_order_part_2021_01_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6643 (class 2606 OID 1611491)
-- Name: fsc_order_part_2021_02 fsc_order_part_2021_02_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order_part_2021_02
    ADD CONSTRAINT fsc_order_part_2021_02_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6645 (class 2606 OID 1611500)
-- Name: fsc_order_part_2021_03 fsc_order_part_2021_03_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order_part_2021_03
    ADD CONSTRAINT fsc_order_part_2021_03_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6647 (class 2606 OID 1611509)
-- Name: fsc_order_part_2021_04 fsc_order_part_2021_04_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order_part_2021_04
    ADD CONSTRAINT fsc_order_part_2021_04_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6649 (class 2606 OID 1611518)
-- Name: fsc_order_part_2021_05 fsc_order_part_2021_05_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order_part_2021_05
    ADD CONSTRAINT fsc_order_part_2021_05_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6651 (class 2606 OID 1611527)
-- Name: fsc_order_part_2021_06 fsc_order_part_2021_06_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order_part_2021_06
    ADD CONSTRAINT fsc_order_part_2021_06_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6653 (class 2606 OID 1611536)
-- Name: fsc_order_part_2021_07 fsc_order_part_2021_07_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order_part_2021_07
    ADD CONSTRAINT fsc_order_part_2021_07_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6655 (class 2606 OID 1611545)
-- Name: fsc_order_part_2021_08 fsc_order_part_2021_08_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order_part_2021_08
    ADD CONSTRAINT fsc_order_part_2021_08_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6657 (class 2606 OID 1611554)
-- Name: fsc_order_part_2021_09 fsc_order_part_2021_09_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order_part_2021_09
    ADD CONSTRAINT fsc_order_part_2021_09_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6659 (class 2606 OID 1611563)
-- Name: fsc_order_part_2021_10 fsc_order_part_2021_10_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order_part_2021_10
    ADD CONSTRAINT fsc_order_part_2021_10_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6661 (class 2606 OID 1611572)
-- Name: fsc_order_part_2021_11 fsc_order_part_2021_11_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order_part_2021_11
    ADD CONSTRAINT fsc_order_part_2021_11_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6663 (class 2606 OID 1611581)
-- Name: fsc_order_part_2021_12 fsc_order_part_2021_12_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_order_part_2021_12
    ADD CONSTRAINT fsc_order_part_2021_12_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6833 (class 2606 OID 1614874)
-- Name: fsc_receipt_default fsc_receipt_default_dt_create_inn_rcp_nmb_key; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_default
    ADD CONSTRAINT fsc_receipt_default_dt_create_inn_rcp_nmb_key UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6679 (class 2606 OID 1611629)
-- Name: fsc_receipt pk_receipt; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt
    ADD CONSTRAINT pk_receipt PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6837 (class 2606 OID 1611807)
-- Name: fsc_receipt_default fsc_receipt_default_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_default
    ADD CONSTRAINT fsc_receipt_default_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6689 (class 2606 OID 1614850)
-- Name: fsc_receipt_part_2021_01 fsc_receipt_part_2021_01_dt_create_inn_rcp_nmb_key; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_01
    ADD CONSTRAINT fsc_receipt_part_2021_01_dt_create_inn_rcp_nmb_key UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6693 (class 2606 OID 1611639)
-- Name: fsc_receipt_part_2021_01 fsc_receipt_part_2021_01_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_01
    ADD CONSTRAINT fsc_receipt_part_2021_01_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6701 (class 2606 OID 1614852)
-- Name: fsc_receipt_part_2021_02 fsc_receipt_part_2021_02_dt_create_inn_rcp_nmb_key; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_02
    ADD CONSTRAINT fsc_receipt_part_2021_02_dt_create_inn_rcp_nmb_key UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6705 (class 2606 OID 1611653)
-- Name: fsc_receipt_part_2021_02 fsc_receipt_part_2021_02_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_02
    ADD CONSTRAINT fsc_receipt_part_2021_02_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6713 (class 2606 OID 1614854)
-- Name: fsc_receipt_part_2021_03 fsc_receipt_part_2021_03_dt_create_inn_rcp_nmb_key; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_03
    ADD CONSTRAINT fsc_receipt_part_2021_03_dt_create_inn_rcp_nmb_key UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6717 (class 2606 OID 1611667)
-- Name: fsc_receipt_part_2021_03 fsc_receipt_part_2021_03_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_03
    ADD CONSTRAINT fsc_receipt_part_2021_03_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6725 (class 2606 OID 1614856)
-- Name: fsc_receipt_part_2021_04 fsc_receipt_part_2021_04_dt_create_inn_rcp_nmb_key; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_04
    ADD CONSTRAINT fsc_receipt_part_2021_04_dt_create_inn_rcp_nmb_key UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6729 (class 2606 OID 1611681)
-- Name: fsc_receipt_part_2021_04 fsc_receipt_part_2021_04_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_04
    ADD CONSTRAINT fsc_receipt_part_2021_04_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6737 (class 2606 OID 1614858)
-- Name: fsc_receipt_part_2021_05 fsc_receipt_part_2021_05_dt_create_inn_rcp_nmb_key; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_05
    ADD CONSTRAINT fsc_receipt_part_2021_05_dt_create_inn_rcp_nmb_key UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6741 (class 2606 OID 1611695)
-- Name: fsc_receipt_part_2021_05 fsc_receipt_part_2021_05_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_05
    ADD CONSTRAINT fsc_receipt_part_2021_05_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6749 (class 2606 OID 1614860)
-- Name: fsc_receipt_part_2021_06 fsc_receipt_part_2021_06_dt_create_inn_rcp_nmb_key; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_06
    ADD CONSTRAINT fsc_receipt_part_2021_06_dt_create_inn_rcp_nmb_key UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6753 (class 2606 OID 1611709)
-- Name: fsc_receipt_part_2021_06 fsc_receipt_part_2021_06_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_06
    ADD CONSTRAINT fsc_receipt_part_2021_06_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6761 (class 2606 OID 1614862)
-- Name: fsc_receipt_part_2021_07 fsc_receipt_part_2021_07_dt_create_inn_rcp_nmb_key; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_07
    ADD CONSTRAINT fsc_receipt_part_2021_07_dt_create_inn_rcp_nmb_key UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6765 (class 2606 OID 1611723)
-- Name: fsc_receipt_part_2021_07 fsc_receipt_part_2021_07_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_07
    ADD CONSTRAINT fsc_receipt_part_2021_07_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6773 (class 2606 OID 1614864)
-- Name: fsc_receipt_part_2021_08 fsc_receipt_part_2021_08_dt_create_inn_rcp_nmb_key; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_08
    ADD CONSTRAINT fsc_receipt_part_2021_08_dt_create_inn_rcp_nmb_key UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6777 (class 2606 OID 1611737)
-- Name: fsc_receipt_part_2021_08 fsc_receipt_part_2021_08_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_08
    ADD CONSTRAINT fsc_receipt_part_2021_08_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6785 (class 2606 OID 1614866)
-- Name: fsc_receipt_part_2021_09 fsc_receipt_part_2021_09_dt_create_inn_rcp_nmb_key; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_09
    ADD CONSTRAINT fsc_receipt_part_2021_09_dt_create_inn_rcp_nmb_key UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6789 (class 2606 OID 1611751)
-- Name: fsc_receipt_part_2021_09 fsc_receipt_part_2021_09_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_09
    ADD CONSTRAINT fsc_receipt_part_2021_09_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6797 (class 2606 OID 1614868)
-- Name: fsc_receipt_part_2021_10 fsc_receipt_part_2021_10_dt_create_inn_rcp_nmb_key; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_10
    ADD CONSTRAINT fsc_receipt_part_2021_10_dt_create_inn_rcp_nmb_key UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6801 (class 2606 OID 1611765)
-- Name: fsc_receipt_part_2021_10 fsc_receipt_part_2021_10_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_10
    ADD CONSTRAINT fsc_receipt_part_2021_10_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6809 (class 2606 OID 1614870)
-- Name: fsc_receipt_part_2021_11 fsc_receipt_part_2021_11_dt_create_inn_rcp_nmb_key; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_11
    ADD CONSTRAINT fsc_receipt_part_2021_11_dt_create_inn_rcp_nmb_key UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6813 (class 2606 OID 1611779)
-- Name: fsc_receipt_part_2021_11 fsc_receipt_part_2021_11_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_11
    ADD CONSTRAINT fsc_receipt_part_2021_11_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6821 (class 2606 OID 1614872)
-- Name: fsc_receipt_part_2021_12 fsc_receipt_part_2021_12_dt_create_inn_rcp_nmb_key; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_12
    ADD CONSTRAINT fsc_receipt_part_2021_12_dt_create_inn_rcp_nmb_key UNIQUE (dt_create, inn, rcp_nmb);


--
-- TOC entry 6825 (class 2606 OID 1611793)
-- Name: fsc_receipt_part_2021_12 fsc_receipt_part_2021_12_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_part_2021_12
    ADD CONSTRAINT fsc_receipt_part_2021_12_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6845 (class 2606 OID 1611815)
-- Name: fsc_receipt_result pk_receipt_resul; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result
    ADD CONSTRAINT pk_receipt_resul PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6871 (class 2606 OID 1611928)
-- Name: fsc_receipt_result_default fsc_receipt_result_default_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result_default
    ADD CONSTRAINT fsc_receipt_result_default_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6847 (class 2606 OID 1611820)
-- Name: fsc_receipt_result_part_2021_01 fsc_receipt_result_part_2021_01_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result_part_2021_01
    ADD CONSTRAINT fsc_receipt_result_part_2021_01_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6849 (class 2606 OID 1611829)
-- Name: fsc_receipt_result_part_2021_02 fsc_receipt_result_part_2021_02_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result_part_2021_02
    ADD CONSTRAINT fsc_receipt_result_part_2021_02_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6851 (class 2606 OID 1611838)
-- Name: fsc_receipt_result_part_2021_03 fsc_receipt_result_part_2021_03_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result_part_2021_03
    ADD CONSTRAINT fsc_receipt_result_part_2021_03_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6853 (class 2606 OID 1611847)
-- Name: fsc_receipt_result_part_2021_04 fsc_receipt_result_part_2021_04_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result_part_2021_04
    ADD CONSTRAINT fsc_receipt_result_part_2021_04_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6855 (class 2606 OID 1611856)
-- Name: fsc_receipt_result_part_2021_05 fsc_receipt_result_part_2021_05_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result_part_2021_05
    ADD CONSTRAINT fsc_receipt_result_part_2021_05_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6857 (class 2606 OID 1611865)
-- Name: fsc_receipt_result_part_2021_06 fsc_receipt_result_part_2021_06_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result_part_2021_06
    ADD CONSTRAINT fsc_receipt_result_part_2021_06_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6859 (class 2606 OID 1611874)
-- Name: fsc_receipt_result_part_2021_07 fsc_receipt_result_part_2021_07_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result_part_2021_07
    ADD CONSTRAINT fsc_receipt_result_part_2021_07_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6861 (class 2606 OID 1611883)
-- Name: fsc_receipt_result_part_2021_08 fsc_receipt_result_part_2021_08_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result_part_2021_08
    ADD CONSTRAINT fsc_receipt_result_part_2021_08_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6863 (class 2606 OID 1611892)
-- Name: fsc_receipt_result_part_2021_09 fsc_receipt_result_part_2021_09_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result_part_2021_09
    ADD CONSTRAINT fsc_receipt_result_part_2021_09_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6865 (class 2606 OID 1611901)
-- Name: fsc_receipt_result_part_2021_10 fsc_receipt_result_part_2021_10_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result_part_2021_10
    ADD CONSTRAINT fsc_receipt_result_part_2021_10_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6867 (class 2606 OID 1611910)
-- Name: fsc_receipt_result_part_2021_11 fsc_receipt_result_part_2021_11_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result_part_2021_11
    ADD CONSTRAINT fsc_receipt_result_part_2021_11_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6869 (class 2606 OID 1611919)
-- Name: fsc_receipt_result_part_2021_12 fsc_receipt_result_part_2021_12_pkey; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_receipt_result_part_2021_12
    ADD CONSTRAINT fsc_receipt_result_part_2021_12_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6627 (class 2606 OID 1611438)
-- Name: fsc_app pk_app; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_app
    ADD CONSTRAINT pk_app PRIMARY KEY (id_app);


--
-- TOC entry 6631 (class 2606 OID 1611444)
-- Name: fsc_app_fsc_provider pk_app_kkt_group; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_app_fsc_provider
    ADD CONSTRAINT pk_app_kkt_group PRIMARY KEY (id_app_fsk_provider);


--
-- TOC entry 6633 (class 2606 OID 1611454)
-- Name: fsc_filter pk_filter; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_filter
    ADD CONSTRAINT pk_filter PRIMARY KEY (id_filter);


--
-- TOC entry 6675 (class 2606 OID 1611619)
-- Name: fsc_provider pk_fiscal_provider; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_provider
    ADD CONSTRAINT pk_fiscal_provider PRIMARY KEY (id_fsc_provider);


--
-- TOC entry 6873 (class 2606 OID 1611939)
-- Name: fsc_storage pk_fiscal_storage; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_storage
    ADD CONSTRAINT pk_fiscal_storage PRIMARY KEY (id_fsc_storage);


--
-- TOC entry 6635 (class 2606 OID 1611463)
-- Name: fsc_kkt pk_kkt; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_kkt
    ADD CONSTRAINT pk_kkt PRIMARY KEY (id_kkt);


--
-- TOC entry 6637 (class 2606 OID 1611472)
-- Name: fsc_kkt_group pk_kkt_group; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_kkt_group
    ADD CONSTRAINT pk_kkt_group PRIMARY KEY (id_kkt_group);


--
-- TOC entry 6669 (class 2606 OID 1611602)
-- Name: fsc_org pk_org; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_org
    ADD CONSTRAINT pk_org PRIMARY KEY (id_org);


--
-- TOC entry 6673 (class 2606 OID 1611608)
-- Name: fsc_org_app pk_org_app; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_org_app
    ADD CONSTRAINT pk_org_app PRIMARY KEY (id_org_app);


--
-- TOC entry 6881 (class 2606 OID 1614889)
-- Name: fsc_report pk_report; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_report
    ADD CONSTRAINT pk_report PRIMARY KEY (id_report);


--
-- TOC entry 6875 (class 2606 OID 1611947)
-- Name: fsc_task pk_task; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_task
    ADD CONSTRAINT pk_task PRIMARY KEY (id_task);


--
-- TOC entry 6877 (class 2606 OID 1611957)
-- Name: fsc_user pk_user; Type: CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_user
    ADD CONSTRAINT pk_user PRIMARY KEY (id_user);


--
-- TOC entry 6883 (class 2606 OID 1615615)
-- Name: fsc_app_fsc_provider ak1_app_kkt_group; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_app_fsc_provider
    ADD CONSTRAINT ak1_app_kkt_group UNIQUE (id_app, id_fsc_provider);


--
-- TOC entry 6975 (class 2606 OID 1616277)
-- Name: fsc_org_app ak1_org_app; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_org_app
    ADD CONSTRAINT ak1_org_app UNIQUE (id_app, id_org);


--
-- TOC entry 6887 (class 2606 OID 1615622)
-- Name: fsc_order pk_order; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order
    ADD CONSTRAINT pk_order PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6913 (class 2606 OID 1615761)
-- Name: fsc_order_default fsc_order_default_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order_default
    ADD CONSTRAINT fsc_order_default_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6889 (class 2606 OID 1615629)
-- Name: fsc_order_part_2021_01 fsc_order_part_2021_01_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order_part_2021_01
    ADD CONSTRAINT fsc_order_part_2021_01_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6891 (class 2606 OID 1615640)
-- Name: fsc_order_part_2021_02 fsc_order_part_2021_02_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order_part_2021_02
    ADD CONSTRAINT fsc_order_part_2021_02_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6893 (class 2606 OID 1615651)
-- Name: fsc_order_part_2021_03 fsc_order_part_2021_03_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order_part_2021_03
    ADD CONSTRAINT fsc_order_part_2021_03_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6895 (class 2606 OID 1615662)
-- Name: fsc_order_part_2021_04 fsc_order_part_2021_04_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order_part_2021_04
    ADD CONSTRAINT fsc_order_part_2021_04_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6897 (class 2606 OID 1615673)
-- Name: fsc_order_part_2021_05 fsc_order_part_2021_05_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order_part_2021_05
    ADD CONSTRAINT fsc_order_part_2021_05_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6899 (class 2606 OID 1615684)
-- Name: fsc_order_part_2021_06 fsc_order_part_2021_06_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order_part_2021_06
    ADD CONSTRAINT fsc_order_part_2021_06_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6901 (class 2606 OID 1615695)
-- Name: fsc_order_part_2021_07 fsc_order_part_2021_07_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order_part_2021_07
    ADD CONSTRAINT fsc_order_part_2021_07_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6903 (class 2606 OID 1615706)
-- Name: fsc_order_part_2021_08 fsc_order_part_2021_08_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order_part_2021_08
    ADD CONSTRAINT fsc_order_part_2021_08_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6905 (class 2606 OID 1615717)
-- Name: fsc_order_part_2021_09 fsc_order_part_2021_09_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order_part_2021_09
    ADD CONSTRAINT fsc_order_part_2021_09_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6907 (class 2606 OID 1615728)
-- Name: fsc_order_part_2021_10 fsc_order_part_2021_10_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order_part_2021_10
    ADD CONSTRAINT fsc_order_part_2021_10_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6909 (class 2606 OID 1615739)
-- Name: fsc_order_part_2021_11 fsc_order_part_2021_11_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order_part_2021_11
    ADD CONSTRAINT fsc_order_part_2021_11_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6911 (class 2606 OID 1615750)
-- Name: fsc_order_part_2021_12 fsc_order_part_2021_12_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_order_part_2021_12
    ADD CONSTRAINT fsc_order_part_2021_12_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6919 (class 2606 OID 1615793)
-- Name: fsc_rcp_params pk_receipt; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params
    ADD CONSTRAINT pk_receipt PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6945 (class 2606 OID 1615922)
-- Name: fsc_rcp_params_default fsc_rcp_params_default_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params_default
    ADD CONSTRAINT fsc_rcp_params_default_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6921 (class 2606 OID 1615802)
-- Name: fsc_rcp_params_part_2021_01 fsc_rcp_params_part_2021_01_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params_part_2021_01
    ADD CONSTRAINT fsc_rcp_params_part_2021_01_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6923 (class 2606 OID 1615812)
-- Name: fsc_rcp_params_part_2021_02 fsc_rcp_params_part_2021_02_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params_part_2021_02
    ADD CONSTRAINT fsc_rcp_params_part_2021_02_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6925 (class 2606 OID 1615822)
-- Name: fsc_rcp_params_part_2021_03 fsc_rcp_params_part_2021_03_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params_part_2021_03
    ADD CONSTRAINT fsc_rcp_params_part_2021_03_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6927 (class 2606 OID 1615832)
-- Name: fsc_rcp_params_part_2021_04 fsc_rcp_params_part_2021_04_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params_part_2021_04
    ADD CONSTRAINT fsc_rcp_params_part_2021_04_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6929 (class 2606 OID 1615842)
-- Name: fsc_rcp_params_part_2021_05 fsc_rcp_params_part_2021_05_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params_part_2021_05
    ADD CONSTRAINT fsc_rcp_params_part_2021_05_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6931 (class 2606 OID 1615852)
-- Name: fsc_rcp_params_part_2021_06 fsc_rcp_params_part_2021_06_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params_part_2021_06
    ADD CONSTRAINT fsc_rcp_params_part_2021_06_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6933 (class 2606 OID 1615862)
-- Name: fsc_rcp_params_part_2021_07 fsc_rcp_params_part_2021_07_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params_part_2021_07
    ADD CONSTRAINT fsc_rcp_params_part_2021_07_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6935 (class 2606 OID 1615872)
-- Name: fsc_rcp_params_part_2021_08 fsc_rcp_params_part_2021_08_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params_part_2021_08
    ADD CONSTRAINT fsc_rcp_params_part_2021_08_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6937 (class 2606 OID 1615882)
-- Name: fsc_rcp_params_part_2021_09 fsc_rcp_params_part_2021_09_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params_part_2021_09
    ADD CONSTRAINT fsc_rcp_params_part_2021_09_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6939 (class 2606 OID 1615892)
-- Name: fsc_rcp_params_part_2021_10 fsc_rcp_params_part_2021_10_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params_part_2021_10
    ADD CONSTRAINT fsc_rcp_params_part_2021_10_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6941 (class 2606 OID 1615902)
-- Name: fsc_rcp_params_part_2021_11 fsc_rcp_params_part_2021_11_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params_part_2021_11
    ADD CONSTRAINT fsc_rcp_params_part_2021_11_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6943 (class 2606 OID 1615912)
-- Name: fsc_rcp_params_part_2021_12 fsc_rcp_params_part_2021_12_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_rcp_params_part_2021_12
    ADD CONSTRAINT fsc_rcp_params_part_2021_12_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6947 (class 2606 OID 1615927)
-- Name: fsc_result pk_receipt_resul; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result
    ADD CONSTRAINT pk_receipt_resul PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6973 (class 2606 OID 1616040)
-- Name: fsc_result_default fsc_result_default_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result_default
    ADD CONSTRAINT fsc_result_default_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6949 (class 2606 OID 1615932)
-- Name: fsc_result_part_2021_01 fsc_result_part_2021_01_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result_part_2021_01
    ADD CONSTRAINT fsc_result_part_2021_01_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6951 (class 2606 OID 1615941)
-- Name: fsc_result_part_2021_02 fsc_result_part_2021_02_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result_part_2021_02
    ADD CONSTRAINT fsc_result_part_2021_02_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6953 (class 2606 OID 1615950)
-- Name: fsc_result_part_2021_03 fsc_result_part_2021_03_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result_part_2021_03
    ADD CONSTRAINT fsc_result_part_2021_03_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6955 (class 2606 OID 1615959)
-- Name: fsc_result_part_2021_04 fsc_result_part_2021_04_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result_part_2021_04
    ADD CONSTRAINT fsc_result_part_2021_04_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6957 (class 2606 OID 1615968)
-- Name: fsc_result_part_2021_05 fsc_result_part_2021_05_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result_part_2021_05
    ADD CONSTRAINT fsc_result_part_2021_05_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6959 (class 2606 OID 1615977)
-- Name: fsc_result_part_2021_06 fsc_result_part_2021_06_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result_part_2021_06
    ADD CONSTRAINT fsc_result_part_2021_06_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6961 (class 2606 OID 1615986)
-- Name: fsc_result_part_2021_07 fsc_result_part_2021_07_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result_part_2021_07
    ADD CONSTRAINT fsc_result_part_2021_07_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6963 (class 2606 OID 1615995)
-- Name: fsc_result_part_2021_08 fsc_result_part_2021_08_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result_part_2021_08
    ADD CONSTRAINT fsc_result_part_2021_08_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6965 (class 2606 OID 1616004)
-- Name: fsc_result_part_2021_09 fsc_result_part_2021_09_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result_part_2021_09
    ADD CONSTRAINT fsc_result_part_2021_09_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6967 (class 2606 OID 1616013)
-- Name: fsc_result_part_2021_10 fsc_result_part_2021_10_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result_part_2021_10
    ADD CONSTRAINT fsc_result_part_2021_10_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6969 (class 2606 OID 1616022)
-- Name: fsc_result_part_2021_11 fsc_result_part_2021_11_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result_part_2021_11
    ADD CONSTRAINT fsc_result_part_2021_11_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6971 (class 2606 OID 1616031)
-- Name: fsc_result_part_2021_12 fsc_result_part_2021_12_pkey; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_result_part_2021_12
    ADD CONSTRAINT fsc_result_part_2021_12_pkey PRIMARY KEY (id_receipt, dt_create);


--
-- TOC entry 6979 (class 2606 OID 1616286)
-- Name: fsc_app pk_app; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_app
    ADD CONSTRAINT pk_app PRIMARY KEY (id_app);


--
-- TOC entry 6885 (class 2606 OID 1615613)
-- Name: fsc_app_fsc_provider pk_app_kkt_group; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_app_fsc_provider
    ADD CONSTRAINT pk_app_kkt_group PRIMARY KEY (id_app_fsk_provider);


--
-- TOC entry 6917 (class 2606 OID 1615784)
-- Name: fsc_provider pk_fiscal_provider; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_provider
    ADD CONSTRAINT pk_fiscal_provider PRIMARY KEY (id_fsc_provider);


--
-- TOC entry 6915 (class 2606 OID 1615774)
-- Name: fsc_org pk_org; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_org
    ADD CONSTRAINT pk_org PRIMARY KEY (id_org);


--
-- TOC entry 6977 (class 2606 OID 1616275)
-- Name: fsc_org_app pk_org_app; Type: CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_org_app
    ADD CONSTRAINT pk_org_app PRIMARY KEY (id_org_app);


--
-- TOC entry 7023 (class 2606 OID 1867288)
-- Name: fsc_app_fsc_provider ak1_app_kkt_group; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_app_fsc_provider
    ADD CONSTRAINT ak1_app_kkt_group UNIQUE (id_app, id_fsc_provider);


--
-- TOC entry 7019 (class 2606 OID 1867277)
-- Name: fsc_org_app ak1_org_app; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_org_app
    ADD CONSTRAINT ak1_org_app UNIQUE (id_app, id_org);


--
-- TOC entry 6981 (class 2606 OID 1618822)
-- Name: fsc_receipt pk_receipt; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt
    ADD CONSTRAINT pk_receipt PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 6983 (class 2606 OID 1618832)
-- Name: fsc_receipt_0 fsc_receipt_0_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_0
    ADD CONSTRAINT fsc_receipt_0_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 6985 (class 2606 OID 1618846)
-- Name: fsc_receipt_1 fsc_receipt_1_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_1
    ADD CONSTRAINT fsc_receipt_1_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 6991 (class 2606 OID 1618887)
-- Name: fsc_receipt_2 fsc_receipt_2_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2
    ADD CONSTRAINT fsc_receipt_2_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 6993 (class 2606 OID 1618899)
-- Name: fsc_receipt_2_2021_01 fsc_receipt_2_2021_01_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2_2021_01
    ADD CONSTRAINT fsc_receipt_2_2021_01_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 6995 (class 2606 OID 1618914)
-- Name: fsc_receipt_2_2021_02 fsc_receipt_2_2021_02_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2_2021_02
    ADD CONSTRAINT fsc_receipt_2_2021_02_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 6997 (class 2606 OID 1618929)
-- Name: fsc_receipt_2_2021_03 fsc_receipt_2_2021_03_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2_2021_03
    ADD CONSTRAINT fsc_receipt_2_2021_03_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 6999 (class 2606 OID 1618944)
-- Name: fsc_receipt_2_2021_04 fsc_receipt_2_2021_04_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2_2021_04
    ADD CONSTRAINT fsc_receipt_2_2021_04_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7001 (class 2606 OID 1618959)
-- Name: fsc_receipt_2_2021_05 fsc_receipt_2_2021_05_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2_2021_05
    ADD CONSTRAINT fsc_receipt_2_2021_05_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7003 (class 2606 OID 1618974)
-- Name: fsc_receipt_2_2021_06 fsc_receipt_2_2021_06_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2_2021_06
    ADD CONSTRAINT fsc_receipt_2_2021_06_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7005 (class 2606 OID 1618989)
-- Name: fsc_receipt_2_2021_07 fsc_receipt_2_2021_07_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2_2021_07
    ADD CONSTRAINT fsc_receipt_2_2021_07_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7007 (class 2606 OID 1619004)
-- Name: fsc_receipt_2_2021_08 fsc_receipt_2_2021_08_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2_2021_08
    ADD CONSTRAINT fsc_receipt_2_2021_08_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7009 (class 2606 OID 1619019)
-- Name: fsc_receipt_2_2021_09 fsc_receipt_2_2021_09_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2_2021_09
    ADD CONSTRAINT fsc_receipt_2_2021_09_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7011 (class 2606 OID 1619034)
-- Name: fsc_receipt_2_2021_10 fsc_receipt_2_2021_10_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2_2021_10
    ADD CONSTRAINT fsc_receipt_2_2021_10_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7013 (class 2606 OID 1619049)
-- Name: fsc_receipt_2_2021_11 fsc_receipt_2_2021_11_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2_2021_11
    ADD CONSTRAINT fsc_receipt_2_2021_11_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7015 (class 2606 OID 1619064)
-- Name: fsc_receipt_2_2021_12 fsc_receipt_2_2021_12_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_2_2021_12
    ADD CONSTRAINT fsc_receipt_2_2021_12_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 6987 (class 2606 OID 1618860)
-- Name: fsc_receipt_345 fsc_receipt_345_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_345
    ADD CONSTRAINT fsc_receipt_345_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 6989 (class 2606 OID 1618874)
-- Name: fsc_receipt_default fsc_receipt_default_pkey; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_receipt_default
    ADD CONSTRAINT fsc_receipt_default_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7017 (class 2606 OID 1867267)
-- Name: fsc_app pk_app; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_app
    ADD CONSTRAINT pk_app PRIMARY KEY (id_app);


--
-- TOC entry 7025 (class 2606 OID 1867286)
-- Name: fsc_app_fsc_provider pk_app_kkt_group; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_app_fsc_provider
    ADD CONSTRAINT pk_app_kkt_group PRIMARY KEY (id_app_fsk_provider);


--
-- TOC entry 7029 (class 2606 OID 1867308)
-- Name: fsc_provider pk_fiscal_provider; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_provider
    ADD CONSTRAINT pk_fiscal_provider PRIMARY KEY (id_fsc_provider);


--
-- TOC entry 7027 (class 2606 OID 1867298)
-- Name: fsc_org pk_org; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_org
    ADD CONSTRAINT pk_org PRIMARY KEY (id_org);


--
-- TOC entry 7021 (class 2606 OID 1867275)
-- Name: fsc_org_app pk_org_app; Type: CONSTRAINT; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_6_fiscalization".fsc_org_app
    ADD CONSTRAINT pk_org_app PRIMARY KEY (id_org_app);


--
-- TOC entry 7081 (class 2606 OID 1867769)
-- Name: fsc_org_cash ak1_fsc_org_cash; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_org_cash
    ADD CONSTRAINT ak1_fsc_org_cash UNIQUE (id_org, id_fsc_provider);


--
-- TOC entry 7069 (class 2606 OID 1867725)
-- Name: fsc_org_app ak1_org_app; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_org_app
    ADD CONSTRAINT ak1_org_app UNIQUE (id_app, id_org);


--
-- TOC entry 7073 (class 2606 OID 1867738)
-- Name: fsc_org_app_param ak1_org_app_param; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_org_app_param
    ADD CONSTRAINT ak1_org_app_param UNIQUE (id_org_app, id_fsc_provider);


--
-- TOC entry 7031 (class 2606 OID 1867332)
-- Name: fsc_receipt pk_receipt; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt
    ADD CONSTRAINT pk_receipt PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7033 (class 2606 OID 1867342)
-- Name: fsc_receipt_0 fsc_receipt_0_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_0
    ADD CONSTRAINT fsc_receipt_0_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7035 (class 2606 OID 1867356)
-- Name: fsc_receipt_1 fsc_receipt_1_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_1
    ADD CONSTRAINT fsc_receipt_1_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7041 (class 2606 OID 1867397)
-- Name: fsc_receipt_2 fsc_receipt_2_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2
    ADD CONSTRAINT fsc_receipt_2_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7043 (class 2606 OID 1867409)
-- Name: fsc_receipt_2_2021_01 fsc_receipt_2_2021_01_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2_2021_01
    ADD CONSTRAINT fsc_receipt_2_2021_01_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7045 (class 2606 OID 1867424)
-- Name: fsc_receipt_2_2021_02 fsc_receipt_2_2021_02_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2_2021_02
    ADD CONSTRAINT fsc_receipt_2_2021_02_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7047 (class 2606 OID 1867439)
-- Name: fsc_receipt_2_2021_03 fsc_receipt_2_2021_03_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2_2021_03
    ADD CONSTRAINT fsc_receipt_2_2021_03_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7049 (class 2606 OID 1867454)
-- Name: fsc_receipt_2_2021_04 fsc_receipt_2_2021_04_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2_2021_04
    ADD CONSTRAINT fsc_receipt_2_2021_04_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7051 (class 2606 OID 1867469)
-- Name: fsc_receipt_2_2021_05 fsc_receipt_2_2021_05_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2_2021_05
    ADD CONSTRAINT fsc_receipt_2_2021_05_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7053 (class 2606 OID 1867484)
-- Name: fsc_receipt_2_2021_06 fsc_receipt_2_2021_06_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2_2021_06
    ADD CONSTRAINT fsc_receipt_2_2021_06_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7055 (class 2606 OID 1867499)
-- Name: fsc_receipt_2_2021_07 fsc_receipt_2_2021_07_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2_2021_07
    ADD CONSTRAINT fsc_receipt_2_2021_07_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7057 (class 2606 OID 1867514)
-- Name: fsc_receipt_2_2021_08 fsc_receipt_2_2021_08_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2_2021_08
    ADD CONSTRAINT fsc_receipt_2_2021_08_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7059 (class 2606 OID 1867529)
-- Name: fsc_receipt_2_2021_09 fsc_receipt_2_2021_09_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2_2021_09
    ADD CONSTRAINT fsc_receipt_2_2021_09_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7061 (class 2606 OID 1867544)
-- Name: fsc_receipt_2_2021_10 fsc_receipt_2_2021_10_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2_2021_10
    ADD CONSTRAINT fsc_receipt_2_2021_10_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7063 (class 2606 OID 1867559)
-- Name: fsc_receipt_2_2021_11 fsc_receipt_2_2021_11_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2_2021_11
    ADD CONSTRAINT fsc_receipt_2_2021_11_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7065 (class 2606 OID 1867574)
-- Name: fsc_receipt_2_2021_12 fsc_receipt_2_2021_12_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_2_2021_12
    ADD CONSTRAINT fsc_receipt_2_2021_12_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7037 (class 2606 OID 1867370)
-- Name: fsc_receipt_345 fsc_receipt_345_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_345
    ADD CONSTRAINT fsc_receipt_345_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7039 (class 2606 OID 1867384)
-- Name: fsc_receipt_default fsc_receipt_default_pkey; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_receipt_default
    ADD CONSTRAINT fsc_receipt_default_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7067 (class 2606 OID 1867715)
-- Name: fsc_app pk_app; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_app
    ADD CONSTRAINT pk_app PRIMARY KEY (id_app);


--
-- TOC entry 7079 (class 2606 OID 1867758)
-- Name: fsc_provider pk_fiscal_provider; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_provider
    ADD CONSTRAINT pk_fiscal_provider PRIMARY KEY (id_fsc_provider);


--
-- TOC entry 7083 (class 2606 OID 1867767)
-- Name: fsc_org_cash pk_fsc_org_cash; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_org_cash
    ADD CONSTRAINT pk_fsc_org_cash PRIMARY KEY (id_org_cash);


--
-- TOC entry 7077 (class 2606 OID 1867748)
-- Name: fsc_org pk_org; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_org
    ADD CONSTRAINT pk_org PRIMARY KEY (id_org);


--
-- TOC entry 7071 (class 2606 OID 1867723)
-- Name: fsc_org_app pk_org_app; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_org_app
    ADD CONSTRAINT pk_org_app PRIMARY KEY (id_org_app);


--
-- TOC entry 7075 (class 2606 OID 1867736)
-- Name: fsc_org_app_param pk_org_app_param; Type: CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_org_app_param
    ADD CONSTRAINT pk_org_app_param PRIMARY KEY (id_org_app_param);


--
-- TOC entry 6561 (class 2606 OID 1607910)
-- Name: d_base pk_d_base; Type: CONSTRAINT; Schema: dict; Owner: postgres
--

ALTER TABLE ONLY dict.d_base
    ADD CONSTRAINT pk_d_base PRIMARY KEY (id_dict);


--
-- TOC entry 6559 (class 2606 OID 1512250)
-- Name: d_entity pk_d_entity; Type: CONSTRAINT; Schema: dict; Owner: postgres
--

ALTER TABLE ONLY dict.d_entity
    ADD CONSTRAINT pk_d_entity PRIMARY KEY (id_dict_entity);


--
-- TOC entry 6563 (class 2606 OID 1607912)
-- Name: ssp_org_type pk_ssp_org_type; Type: CONSTRAINT; Schema: dict; Owner: postgres
--

ALTER TABLE ONLY dict.ssp_org_type
    ADD CONSTRAINT pk_ssp_org_type PRIMARY KEY (id_dict);


--
-- TOC entry 6621 (class 2606 OID 1607914)
-- Name: ssp_pmt_type pk_ssp_pmt_type; Type: CONSTRAINT; Schema: dict; Owner: postgres
--

ALTER TABLE ONLY dict.ssp_pmt_type
    ADD CONSTRAINT pk_ssp_pmt_type PRIMARY KEY (id_dict);


--
-- TOC entry 7167 (class 2606 OID 2114706)
-- Name: fsc_app_param ak1_app_param; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_app_param
    ADD CONSTRAINT ak1_app_param UNIQUE (id_app, id_fsc_provider);


--
-- TOC entry 7161 (class 2606 OID 2112461)
-- Name: fsc_data_operator ak1_data_operator; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_data_operator
    ADD CONSTRAINT ak1_data_operator UNIQUE (ofd_inn);


--
-- TOC entry 7157 (class 2606 OID 2114693)
-- Name: fsc_org_cash ak1_fsc_org_cash; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_org_cash
    ADD CONSTRAINT ak1_fsc_org_cash UNIQUE (id_org, id_fsc_provider);


--
-- TOC entry 7148 (class 2606 OID 2112316)
-- Name: fsc_org_app ak1_org_app; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_org_app
    ADD CONSTRAINT ak1_org_app UNIQUE (id_org, id_app);


--
-- TOC entry 7171 (class 2606 OID 2120379)
-- Name: fsc_source_reestr ak1_source_reestr; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_source_reestr
    ADD CONSTRAINT ak1_source_reestr UNIQUE (external_id);


--
-- TOC entry 7116 (class 2606 OID 2112001)
-- Name: fsc_receipt pk_receipt; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_receipt
    ADD CONSTRAINT pk_receipt PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7119 (class 2606 OID 2112015)
-- Name: fsc_receipt_0 fsc_receipt_0_pkey; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_receipt_0
    ADD CONSTRAINT fsc_receipt_0_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7122 (class 2606 OID 2112031)
-- Name: fsc_receipt_1 fsc_receipt_1_pkey; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_receipt_1
    ADD CONSTRAINT fsc_receipt_1_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7134 (class 2606 OID 2112094)
-- Name: fsc_receipt_2 fsc_receipt_2_pkey; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_receipt_2
    ADD CONSTRAINT fsc_receipt_2_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7137 (class 2606 OID 2112108)
-- Name: fsc_receipt_2_2021_1 fsc_receipt_2_2021_1_pkey; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_receipt_2_2021_1
    ADD CONSTRAINT fsc_receipt_2_2021_1_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7140 (class 2606 OID 2112125)
-- Name: fsc_receipt_2_2021_2 fsc_receipt_2_2021_2_pkey; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_receipt_2_2021_2
    ADD CONSTRAINT fsc_receipt_2_2021_2_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7143 (class 2606 OID 2112142)
-- Name: fsc_receipt_2_2021_3 fsc_receipt_2_2021_3_pkey; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_receipt_2_2021_3
    ADD CONSTRAINT fsc_receipt_2_2021_3_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7146 (class 2606 OID 2112159)
-- Name: fsc_receipt_2_2021_4 fsc_receipt_2_2021_4_pkey; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_receipt_2_2021_4
    ADD CONSTRAINT fsc_receipt_2_2021_4_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7125 (class 2606 OID 2112047)
-- Name: fsc_receipt_3 fsc_receipt_3_pkey; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_receipt_3
    ADD CONSTRAINT fsc_receipt_3_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7128 (class 2606 OID 2112063)
-- Name: fsc_receipt_45 fsc_receipt_45_pkey; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_receipt_45
    ADD CONSTRAINT fsc_receipt_45_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7131 (class 2606 OID 2112079)
-- Name: fsc_receipt_default fsc_receipt_default_pkey; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_receipt_default
    ADD CONSTRAINT fsc_receipt_default_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 7165 (class 2606 OID 2112380)
-- Name: fsc_app pk_app; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_app
    ADD CONSTRAINT pk_app PRIMARY KEY (id_app);


--
-- TOC entry 7169 (class 2606 OID 2114704)
-- Name: fsc_app_param pk_app_param; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_app_param
    ADD CONSTRAINT pk_app_param PRIMARY KEY (id_app_param);


--
-- TOC entry 7155 (class 2606 OID 2112346)
-- Name: fsc_provider pk_fiscal_provider; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_provider
    ADD CONSTRAINT pk_fiscal_provider PRIMARY KEY (id_fsc_provider);


--
-- TOC entry 7163 (class 2606 OID 2112367)
-- Name: fsc_data_operator pk_fsc_data_operator; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_data_operator
    ADD CONSTRAINT pk_fsc_data_operator PRIMARY KEY (id_fsc_data_operator);


--
-- TOC entry 7159 (class 2606 OID 2112355)
-- Name: fsc_org_cash pk_fsc_org_cash; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_org_cash
    ADD CONSTRAINT pk_fsc_org_cash PRIMARY KEY (id_org_cash);


--
-- TOC entry 7153 (class 2606 OID 2112336)
-- Name: fsc_org pk_org; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_org
    ADD CONSTRAINT pk_org PRIMARY KEY (id_org);


--
-- TOC entry 7150 (class 2606 OID 2112314)
-- Name: fsc_org_app pk_org_app; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_org_app
    ADD CONSTRAINT pk_org_app PRIMARY KEY (id_org_app);


--
-- TOC entry 7174 (class 2606 OID 2115858)
-- Name: fsc_source_reestr pk_source_reestr; Type: CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_source_reestr
    ADD CONSTRAINT pk_source_reestr PRIMARY KEY (id_source_reestr);


--
-- TOC entry 7113 (class 2606 OID 2111787)
-- Name: fsc_receipt_2_2020_01_half fsc_receipt_2_2020_01_half_pkey; Type: CONSTRAINT; Schema: fiscalization_part; Owner: postgres
--

ALTER TABLE ONLY fiscalization_part.fsc_receipt_2_2020_01_half
    ADD CONSTRAINT fsc_receipt_2_2020_01_half_pkey PRIMARY KEY (id_receipt, rcp_status, dt_create);


--
-- TOC entry 6196 (class 2606 OID 46962)
-- Name: app_link app_link_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_link
    ADD CONSTRAINT app_link_unique UNIQUE (app_id, user_id);


--
-- TOC entry 6192 (class 2606 OID 46973)
-- Name: app app_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT app_pkey PRIMARY KEY (app_id);


--
-- TOC entry 5243 (class 2606 OID 1509689)
-- Name: receipt_old chk_receipt_dt_create; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_old
    ADD CONSTRAINT chk_receipt_dt_create CHECK (((dt_create >= '2019-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-01-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5253 (class 2606 OID 907974)
-- Name: receipt_2018 chk_receipt_dt_create_2018; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_2018
    ADD CONSTRAINT chk_receipt_dt_create_2018 CHECK (((dt_create >= '2018-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2019-01-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5257 (class 2606 OID 907971)
-- Name: receipt_2019 chk_receipt_dt_create_2019; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_2019
    ADD CONSTRAINT chk_receipt_dt_create_2019 CHECK (((dt_create >= '2019-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2019-07-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5435 (class 2606 OID 1167980)
-- Name: receipt_part_2020_01 chk_receipt_dt_create_2020_01; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2020_01
    ADD CONSTRAINT chk_receipt_dt_create_2020_01 CHECK (((dt_create >= '2020-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2020-02-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5430 (class 2606 OID 1167967)
-- Name: receipt_part_2020_02 chk_receipt_dt_create_2020_02; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2020_02
    ADD CONSTRAINT chk_receipt_dt_create_2020_02 CHECK (((dt_create >= '2020-02-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2020-03-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5425 (class 2606 OID 1167954)
-- Name: receipt_part_2020_03 chk_receipt_dt_create_2020_03; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2020_03
    ADD CONSTRAINT chk_receipt_dt_create_2020_03 CHECK (((dt_create >= '2020-03-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2020-04-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5420 (class 2606 OID 1167941)
-- Name: receipt_part_2020_04 chk_receipt_dt_create_2020_04; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2020_04
    ADD CONSTRAINT chk_receipt_dt_create_2020_04 CHECK (((dt_create >= '2020-04-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2020-05-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5415 (class 2606 OID 1167928)
-- Name: receipt_part_2020_05 chk_receipt_dt_create_2020_05; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2020_05
    ADD CONSTRAINT chk_receipt_dt_create_2020_05 CHECK (((dt_create >= '2020-05-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2020-06-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5410 (class 2606 OID 1167915)
-- Name: receipt_part_2020_06 chk_receipt_dt_create_2020_06; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2020_06
    ADD CONSTRAINT chk_receipt_dt_create_2020_06 CHECK (((dt_create >= '2020-06-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2020-07-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5405 (class 2606 OID 1167902)
-- Name: receipt_part_2020_07 chk_receipt_dt_create_2020_07; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2020_07
    ADD CONSTRAINT chk_receipt_dt_create_2020_07 CHECK (((dt_create >= '2020-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2020-08-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5400 (class 2606 OID 1167889)
-- Name: receipt_part_2020_08 chk_receipt_dt_create_2020_08; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2020_08
    ADD CONSTRAINT chk_receipt_dt_create_2020_08 CHECK (((dt_create >= '2020-08-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2020-09-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5395 (class 2606 OID 1167876)
-- Name: receipt_part_2020_09 chk_receipt_dt_create_2020_09; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2020_09
    ADD CONSTRAINT chk_receipt_dt_create_2020_09 CHECK (((dt_create >= '2020-09-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2020-10-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5390 (class 2606 OID 1167863)
-- Name: receipt_part_2020_10 chk_receipt_dt_create_2020_10; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2020_10
    ADD CONSTRAINT chk_receipt_dt_create_2020_10 CHECK (((dt_create >= '2020-10-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2020-11-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5385 (class 2606 OID 1167850)
-- Name: receipt_part_2020_11 chk_receipt_dt_create_2020_11; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2020_11
    ADD CONSTRAINT chk_receipt_dt_create_2020_11 CHECK (((dt_create >= '2020-11-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2020-12-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5380 (class 2606 OID 1167837)
-- Name: receipt_part_2020_12 chk_receipt_dt_create_2020_12; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2020_12
    ADD CONSTRAINT chk_receipt_dt_create_2020_12 CHECK (((dt_create >= '2020-12-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-01-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5375 (class 2606 OID 1146803)
-- Name: receipt_part_2021_01 chk_receipt_dt_create_2021_01; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2021_01
    ADD CONSTRAINT chk_receipt_dt_create_2021_01 CHECK (((dt_create >= '2021-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-02-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5370 (class 2606 OID 1146790)
-- Name: receipt_part_2021_02 chk_receipt_dt_create_2021_02; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2021_02
    ADD CONSTRAINT chk_receipt_dt_create_2021_02 CHECK (((dt_create >= '2021-02-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-03-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5365 (class 2606 OID 1146777)
-- Name: receipt_part_2021_03 chk_receipt_dt_create_2021_03; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2021_03
    ADD CONSTRAINT chk_receipt_dt_create_2021_03 CHECK (((dt_create >= '2021-03-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-04-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5360 (class 2606 OID 1146764)
-- Name: receipt_part_2021_04 chk_receipt_dt_create_2021_04; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2021_04
    ADD CONSTRAINT chk_receipt_dt_create_2021_04 CHECK (((dt_create >= '2021-04-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-05-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5355 (class 2606 OID 1146751)
-- Name: receipt_part_2021_05 chk_receipt_dt_create_2021_05; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2021_05
    ADD CONSTRAINT chk_receipt_dt_create_2021_05 CHECK (((dt_create >= '2021-05-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-06-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5350 (class 2606 OID 1146738)
-- Name: receipt_part_2021_06 chk_receipt_dt_create_2021_06; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2021_06
    ADD CONSTRAINT chk_receipt_dt_create_2021_06 CHECK (((dt_create >= '2021-06-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-07-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5345 (class 2606 OID 1070962)
-- Name: receipt_part_2021_07 chk_receipt_dt_create_2021_07; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2021_07
    ADD CONSTRAINT chk_receipt_dt_create_2021_07 CHECK (((dt_create >= '2021-07-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-08-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5340 (class 2606 OID 908609)
-- Name: receipt_part_2021_08 chk_receipt_dt_create_2021_08; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2021_08
    ADD CONSTRAINT chk_receipt_dt_create_2021_08 CHECK (((dt_create >= '2021-08-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-09-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5335 (class 2606 OID 908596)
-- Name: receipt_part_2021_09 chk_receipt_dt_create_2021_09; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2021_09
    ADD CONSTRAINT chk_receipt_dt_create_2021_09 CHECK (((dt_create >= '2021-09-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-10-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5330 (class 2606 OID 908583)
-- Name: receipt_part_2021_10 chk_receipt_dt_create_2021_10; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2021_10
    ADD CONSTRAINT chk_receipt_dt_create_2021_10 CHECK (((dt_create >= '2021-10-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-11-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5307 (class 2606 OID 908371)
-- Name: receipt_part_2021_11 chk_receipt_dt_create_2021_11; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2021_11
    ADD CONSTRAINT chk_receipt_dt_create_2021_11 CHECK (((dt_create >= '2021-11-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2021-12-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5312 (class 2606 OID 908384)
-- Name: receipt_part_2021_12 chk_receipt_dt_create_2021_12; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2021_12
    ADD CONSTRAINT chk_receipt_dt_create_2021_12 CHECK (((dt_create >= '2021-12-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2022-01-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 5317 (class 2606 OID 908397)
-- Name: receipt_part_2022_01 chk_receipt_dt_create_2022_01; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_part_2022_01
    ADD CONSTRAINT chk_receipt_dt_create_2022_01 CHECK (((dt_create >= '2022-01-01 00:00:00+03'::timestamp with time zone) AND (dt_create < '2022-02-01 00:00:00+03'::timestamp with time zone))) NOT VALID;


--
-- TOC entry 6198 (class 2606 OID 46977)
-- Name: org inn; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT inn UNIQUE (inn);


--
-- TOC entry 6202 (class 2606 OID 46979)
-- Name: org_link org_link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_link
    ADD CONSTRAINT org_link_pkey PRIMARY KEY (org_link_id);


--
-- TOC entry 6204 (class 2606 OID 46986)
-- Name: org_link org_link_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_link
    ADD CONSTRAINT org_link_unique UNIQUE (app_id, org_id);


--
-- TOC entry 6200 (class 2606 OID 46993)
-- Name: org org_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT org_pkey PRIMARY KEY (org_id);


--
-- TOC entry 6493 (class 2606 OID 1167979)
-- Name: receipt_part_2020_01 pk_receipt_part_2020_01; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2020_01
    ADD CONSTRAINT pk_receipt_part_2020_01 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6491 (class 2606 OID 1167966)
-- Name: receipt_part_2020_02 pk_receipt_part_2020_02; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2020_02
    ADD CONSTRAINT pk_receipt_part_2020_02 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6489 (class 2606 OID 1167953)
-- Name: receipt_part_2020_03 pk_receipt_part_2020_03; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2020_03
    ADD CONSTRAINT pk_receipt_part_2020_03 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6487 (class 2606 OID 1167940)
-- Name: receipt_part_2020_04 pk_receipt_part_2020_04; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2020_04
    ADD CONSTRAINT pk_receipt_part_2020_04 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6485 (class 2606 OID 1167927)
-- Name: receipt_part_2020_05 pk_receipt_part_2020_05; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2020_05
    ADD CONSTRAINT pk_receipt_part_2020_05 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6483 (class 2606 OID 1167914)
-- Name: receipt_part_2020_06 pk_receipt_part_2020_06; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2020_06
    ADD CONSTRAINT pk_receipt_part_2020_06 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6481 (class 2606 OID 1167901)
-- Name: receipt_part_2020_07 pk_receipt_part_2020_07; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2020_07
    ADD CONSTRAINT pk_receipt_part_2020_07 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6479 (class 2606 OID 1167888)
-- Name: receipt_part_2020_08 pk_receipt_part_2020_08; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2020_08
    ADD CONSTRAINT pk_receipt_part_2020_08 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6477 (class 2606 OID 1167875)
-- Name: receipt_part_2020_09 pk_receipt_part_2020_09; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2020_09
    ADD CONSTRAINT pk_receipt_part_2020_09 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6475 (class 2606 OID 1167862)
-- Name: receipt_part_2020_10 pk_receipt_part_2020_10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2020_10
    ADD CONSTRAINT pk_receipt_part_2020_10 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6473 (class 2606 OID 1167849)
-- Name: receipt_part_2020_11 pk_receipt_part_2020_11; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2020_11
    ADD CONSTRAINT pk_receipt_part_2020_11 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6471 (class 2606 OID 1167836)
-- Name: receipt_part_2020_12 pk_receipt_part_2020_12; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2020_12
    ADD CONSTRAINT pk_receipt_part_2020_12 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6282 (class 2606 OID 907983)
-- Name: receipt receipt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt
    ADD CONSTRAINT receipt_pkey PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6458 (class 2606 OID 1146802)
-- Name: receipt_part_2021_01 pk_receipt_part_2021_01; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2021_01
    ADD CONSTRAINT pk_receipt_part_2021_01 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6445 (class 2606 OID 1146789)
-- Name: receipt_part_2021_02 pk_receipt_part_2021_02; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2021_02
    ADD CONSTRAINT pk_receipt_part_2021_02 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6432 (class 2606 OID 1146776)
-- Name: receipt_part_2021_03 pk_receipt_part_2021_03; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2021_03
    ADD CONSTRAINT pk_receipt_part_2021_03 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6419 (class 2606 OID 1146763)
-- Name: receipt_part_2021_04 pk_receipt_part_2021_04; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2021_04
    ADD CONSTRAINT pk_receipt_part_2021_04 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6406 (class 2606 OID 1146750)
-- Name: receipt_part_2021_05 pk_receipt_part_2021_05; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2021_05
    ADD CONSTRAINT pk_receipt_part_2021_05 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6393 (class 2606 OID 1146737)
-- Name: receipt_part_2021_06 pk_receipt_part_2021_06; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2021_06
    ADD CONSTRAINT pk_receipt_part_2021_06 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6380 (class 2606 OID 1070961)
-- Name: receipt_part_2021_07 pk_receipt_part_2021_07; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2021_07
    ADD CONSTRAINT pk_receipt_part_2021_07 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6367 (class 2606 OID 908608)
-- Name: receipt_part_2021_08 pk_receipt_part_2021_08; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2021_08
    ADD CONSTRAINT pk_receipt_part_2021_08 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6354 (class 2606 OID 908595)
-- Name: receipt_part_2021_09 pk_receipt_part_2021_09; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2021_09
    ADD CONSTRAINT pk_receipt_part_2021_09 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6341 (class 2606 OID 908582)
-- Name: receipt_part_2021_10 pk_receipt_part_2021_10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2021_10
    ADD CONSTRAINT pk_receipt_part_2021_10 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6287 (class 2606 OID 908370)
-- Name: receipt_part_2021_11 pk_receipt_part_2021_11; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2021_11
    ADD CONSTRAINT pk_receipt_part_2021_11 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6300 (class 2606 OID 908383)
-- Name: receipt_part_2021_12 pk_receipt_part_2021_12; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2021_12
    ADD CONSTRAINT pk_receipt_part_2021_12 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6313 (class 2606 OID 908396)
-- Name: receipt_part_2022_01 pk_receipt_part_2022_01; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_part_2022_01
    ADD CONSTRAINT pk_receipt_part_2022_01 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6339 (class 2606 OID 908570)
-- Name: receipt_work pk_receipt_work; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_work
    ADD CONSTRAINT pk_receipt_work PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6336 (class 2606 OID 908406)
-- Name: receipt_default receipt_default_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_default
    ADD CONSTRAINT receipt_default_pkey PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6236 (class 2606 OID 907985)
-- Name: receipt_2018 receipt_pkey_2018; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_2018
    ADD CONSTRAINT receipt_pkey_2018 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6249 (class 2606 OID 907994)
-- Name: receipt_2019 receipt_pkey_2019; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_2019
    ADD CONSTRAINT receipt_pkey_2019 PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6217 (class 2606 OID 907969)
-- Name: receipt_old receipt_pkey_old; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_old
    ADD CONSTRAINT receipt_pkey_old PRIMARY KEY (receipt_id, dt_create);


--
-- TOC entry 6219 (class 2606 OID 46994)
-- Name: report report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_pkey PRIMARY KEY (report_id);


--
-- TOC entry 6221 (class 2606 OID 47011)
-- Name: report report_uuid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_uuid UNIQUE (uuid);


--
-- TOC entry 6223 (class 2606 OID 46974)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);


--
-- TOC entry 6194 (class 2606 OID 46988)
-- Name: app uuid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT uuid UNIQUE (uuid);


--
-- TOC entry 7095 (class 2606 OID 2111662)
-- Name: ssp_fisc_link_task_filters ak_ssp_fisc_link_task_ssp_fisc; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_link_task_filters
    ADD CONSTRAINT ak_ssp_fisc_link_task_ssp_fisc UNIQUE (id_filter, id_fisc_task);


--
-- TOC entry 7107 (class 2606 OID 2111695)
-- Name: ssp_pay_hist_fisc ak_ssp_pay_hist_fisc__ssp_pay_; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_pay_hist_fisc
    ADD CONSTRAINT ak_ssp_pay_hist_fisc__ssp_pay_ UNIQUE (fisc_uid);


--
-- TOC entry 7085 (class 2606 OID 2111629)
-- Name: ssp_cash_group pk_ssp_cash_group; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_cash_group
    ADD CONSTRAINT pk_ssp_cash_group PRIMARY KEY (id_cash_group);


--
-- TOC entry 7087 (class 2606 OID 2111637)
-- Name: ssp_cash_register pk_ssp_cash_register; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_cash_register
    ADD CONSTRAINT pk_ssp_cash_register PRIMARY KEY (id_cash_register);


--
-- TOC entry 7089 (class 2606 OID 2111645)
-- Name: ssp_fisc_ad_filters pk_ssp_fisc_ad_filters; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_ad_filters
    ADD CONSTRAINT pk_ssp_fisc_ad_filters PRIMARY KEY (id_row);


--
-- TOC entry 7091 (class 2606 OID 2111650)
-- Name: ssp_fisc_filter pk_ssp_fisc_filter; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_filter
    ADD CONSTRAINT pk_ssp_fisc_filter PRIMARY KEY (id_filter);


--
-- TOC entry 7093 (class 2606 OID 2111655)
-- Name: ssp_fisc_filter_type pk_ssp_fisc_filter_type; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_filter_type
    ADD CONSTRAINT pk_ssp_fisc_filter_type PRIMARY KEY (kd_filter_type);


--
-- TOC entry 7097 (class 2606 OID 2111660)
-- Name: ssp_fisc_link_task_filters pk_ssp_fisc_link_task_filters1; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_link_task_filters
    ADD CONSTRAINT pk_ssp_fisc_link_task_filters1 PRIMARY KEY (id_row);


--
-- TOC entry 7099 (class 2606 OID 2111667)
-- Name: ssp_fisc_task pk_ssp_fisc_task; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_task
    ADD CONSTRAINT pk_ssp_fisc_task PRIMARY KEY (id_fisc_task);


--
-- TOC entry 7101 (class 2606 OID 2111672)
-- Name: ssp_fisc_task_state pk_ssp_fisc_task_state; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_task_state
    ADD CONSTRAINT pk_ssp_fisc_task_state PRIMARY KEY (kd_fisc_task_state);


--
-- TOC entry 7103 (class 2606 OID 2111677)
-- Name: ssp_fisc_task_type pk_ssp_fisc_task_type; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_task_type
    ADD CONSTRAINT pk_ssp_fisc_task_type PRIMARY KEY (kd_fisc_task_type);


--
-- TOC entry 7105 (class 2606 OID 2111685)
-- Name: ssp_pay_corrparams_fisc pk_ssp_pay_corrparams_fisc; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_pay_corrparams_fisc
    ADD CONSTRAINT pk_ssp_pay_corrparams_fisc PRIMARY KEY (id_pay_corrparams);


--
-- TOC entry 7109 (class 2606 OID 2111693)
-- Name: ssp_pay_hist_fisc pk_ssp_pay_hist_fisc; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_pay_hist_fisc
    ADD CONSTRAINT pk_ssp_pay_hist_fisc PRIMARY KEY (id_pay_fisc);


--
-- TOC entry 7111 (class 2606 OID 2111700)
-- Name: ssp_pay_link_fisc pk_ssp_pay_link_fisc; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_pay_link_fisc
    ADD CONSTRAINT pk_ssp_pay_link_fisc PRIMARY KEY (id_link);


--
-- TOC entry 6686 (class 1259 OID 1614819)
-- Name: receipt_i8; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX receipt_i8 ON ONLY "_OLD_4_fiscalization".fsc_receipt USING btree (id_org);


--
-- TOC entry 6834 (class 1259 OID 1614832)
-- Name: fsc_receipt_default_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_default_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_default USING btree (id_org);


--
-- TOC entry 6680 (class 1259 OID 1614735)
-- Name: receipt_i10_rep; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX receipt_i10_rep ON ONLY "_OLD_4_fiscalization".fsc_receipt USING btree (id_org, rcp_correction);


--
-- TOC entry 6835 (class 1259 OID 1614748)
-- Name: fsc_receipt_default_id_org_rcp_correction_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_default_id_org_rcp_correction_idx ON "_OLD_4_fiscalization".fsc_receipt_default USING btree (id_org, rcp_correction);


--
-- TOC entry 6682 (class 1259 OID 1614763)
-- Name: receipt_i4; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX receipt_i4 ON ONLY "_OLD_4_fiscalization".fsc_receipt USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6838 (class 1259 OID 1614776)
-- Name: fsc_receipt_default_rcp_fp_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_default_rcp_fp_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_default USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6681 (class 1259 OID 1614749)
-- Name: receipt_i3; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX receipt_i3 ON ONLY "_OLD_4_fiscalization".fsc_receipt USING btree (rcp_fp, inn);


--
-- TOC entry 6839 (class 1259 OID 1614762)
-- Name: fsc_receipt_default_rcp_fp_inn_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_default_rcp_fp_inn_idx ON "_OLD_4_fiscalization".fsc_receipt_default USING btree (rcp_fp, inn);


--
-- TOC entry 6683 (class 1259 OID 1614777)
-- Name: receipt_i5; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX receipt_i5 ON ONLY "_OLD_4_fiscalization".fsc_receipt USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6840 (class 1259 OID 1614790)
-- Name: fsc_receipt_default_rcp_fp_rcp_status_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_default_rcp_fp_rcp_status_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_default USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6684 (class 1259 OID 1614791)
-- Name: receipt_i6; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX receipt_i6 ON ONLY "_OLD_4_fiscalization".fsc_receipt USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6841 (class 1259 OID 1614804)
-- Name: fsc_receipt_default_rcp_fp_rcp_status_id_org_idx1; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_default_rcp_fp_rcp_status_id_org_idx1 ON "_OLD_4_fiscalization".fsc_receipt_default USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6685 (class 1259 OID 1614805)
-- Name: receipt_i7; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX receipt_i7 ON ONLY "_OLD_4_fiscalization".fsc_receipt USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6842 (class 1259 OID 1614818)
-- Name: fsc_receipt_default_rcp_notify_send_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_default_rcp_notify_send_idx ON "_OLD_4_fiscalization".fsc_receipt_default USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6687 (class 1259 OID 1614833)
-- Name: receipt_i9; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX receipt_i9 ON ONLY "_OLD_4_fiscalization".fsc_receipt USING btree (rcp_status);


--
-- TOC entry 6843 (class 1259 OID 1614846)
-- Name: fsc_receipt_default_rcp_status_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_default_rcp_status_idx ON "_OLD_4_fiscalization".fsc_receipt_default USING btree (rcp_status);


--
-- TOC entry 6690 (class 1259 OID 1614820)
-- Name: fsc_receipt_part_2021_01_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_01_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_01 USING btree (id_org);


--
-- TOC entry 6691 (class 1259 OID 1614736)
-- Name: fsc_receipt_part_2021_01_id_org_rcp_correction_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_01_id_org_rcp_correction_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_01 USING btree (id_org, rcp_correction);


--
-- TOC entry 6694 (class 1259 OID 1614764)
-- Name: fsc_receipt_part_2021_01_rcp_fp_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_01_rcp_fp_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_01 USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6695 (class 1259 OID 1614750)
-- Name: fsc_receipt_part_2021_01_rcp_fp_inn_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_01_rcp_fp_inn_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_01 USING btree (rcp_fp, inn);


--
-- TOC entry 6696 (class 1259 OID 1614778)
-- Name: fsc_receipt_part_2021_01_rcp_fp_rcp_status_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_01_rcp_fp_rcp_status_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_01 USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6697 (class 1259 OID 1614792)
-- Name: fsc_receipt_part_2021_01_rcp_fp_rcp_status_id_org_idx1; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_01_rcp_fp_rcp_status_id_org_idx1 ON "_OLD_4_fiscalization".fsc_receipt_part_2021_01 USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6698 (class 1259 OID 1614806)
-- Name: fsc_receipt_part_2021_01_rcp_notify_send_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_01_rcp_notify_send_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_01 USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6699 (class 1259 OID 1614834)
-- Name: fsc_receipt_part_2021_01_rcp_status_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_01_rcp_status_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_01 USING btree (rcp_status);


--
-- TOC entry 6702 (class 1259 OID 1614821)
-- Name: fsc_receipt_part_2021_02_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_02_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_02 USING btree (id_org);


--
-- TOC entry 6703 (class 1259 OID 1614737)
-- Name: fsc_receipt_part_2021_02_id_org_rcp_correction_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_02_id_org_rcp_correction_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_02 USING btree (id_org, rcp_correction);


--
-- TOC entry 6706 (class 1259 OID 1614765)
-- Name: fsc_receipt_part_2021_02_rcp_fp_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_02_rcp_fp_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_02 USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6707 (class 1259 OID 1614751)
-- Name: fsc_receipt_part_2021_02_rcp_fp_inn_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_02_rcp_fp_inn_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_02 USING btree (rcp_fp, inn);


--
-- TOC entry 6708 (class 1259 OID 1614779)
-- Name: fsc_receipt_part_2021_02_rcp_fp_rcp_status_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_02_rcp_fp_rcp_status_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_02 USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6709 (class 1259 OID 1614793)
-- Name: fsc_receipt_part_2021_02_rcp_fp_rcp_status_id_org_idx1; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_02_rcp_fp_rcp_status_id_org_idx1 ON "_OLD_4_fiscalization".fsc_receipt_part_2021_02 USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6710 (class 1259 OID 1614807)
-- Name: fsc_receipt_part_2021_02_rcp_notify_send_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_02_rcp_notify_send_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_02 USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6711 (class 1259 OID 1614835)
-- Name: fsc_receipt_part_2021_02_rcp_status_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_02_rcp_status_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_02 USING btree (rcp_status);


--
-- TOC entry 6714 (class 1259 OID 1614822)
-- Name: fsc_receipt_part_2021_03_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_03_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_03 USING btree (id_org);


--
-- TOC entry 6715 (class 1259 OID 1614738)
-- Name: fsc_receipt_part_2021_03_id_org_rcp_correction_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_03_id_org_rcp_correction_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_03 USING btree (id_org, rcp_correction);


--
-- TOC entry 6718 (class 1259 OID 1614766)
-- Name: fsc_receipt_part_2021_03_rcp_fp_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_03_rcp_fp_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_03 USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6719 (class 1259 OID 1614752)
-- Name: fsc_receipt_part_2021_03_rcp_fp_inn_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_03_rcp_fp_inn_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_03 USING btree (rcp_fp, inn);


--
-- TOC entry 6720 (class 1259 OID 1614780)
-- Name: fsc_receipt_part_2021_03_rcp_fp_rcp_status_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_03_rcp_fp_rcp_status_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_03 USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6721 (class 1259 OID 1614794)
-- Name: fsc_receipt_part_2021_03_rcp_fp_rcp_status_id_org_idx1; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_03_rcp_fp_rcp_status_id_org_idx1 ON "_OLD_4_fiscalization".fsc_receipt_part_2021_03 USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6722 (class 1259 OID 1614808)
-- Name: fsc_receipt_part_2021_03_rcp_notify_send_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_03_rcp_notify_send_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_03 USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6723 (class 1259 OID 1614836)
-- Name: fsc_receipt_part_2021_03_rcp_status_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_03_rcp_status_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_03 USING btree (rcp_status);


--
-- TOC entry 6726 (class 1259 OID 1614823)
-- Name: fsc_receipt_part_2021_04_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_04_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_04 USING btree (id_org);


--
-- TOC entry 6727 (class 1259 OID 1614739)
-- Name: fsc_receipt_part_2021_04_id_org_rcp_correction_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_04_id_org_rcp_correction_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_04 USING btree (id_org, rcp_correction);


--
-- TOC entry 6730 (class 1259 OID 1614767)
-- Name: fsc_receipt_part_2021_04_rcp_fp_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_04_rcp_fp_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_04 USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6731 (class 1259 OID 1614753)
-- Name: fsc_receipt_part_2021_04_rcp_fp_inn_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_04_rcp_fp_inn_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_04 USING btree (rcp_fp, inn);


--
-- TOC entry 6732 (class 1259 OID 1614781)
-- Name: fsc_receipt_part_2021_04_rcp_fp_rcp_status_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_04_rcp_fp_rcp_status_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_04 USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6733 (class 1259 OID 1614795)
-- Name: fsc_receipt_part_2021_04_rcp_fp_rcp_status_id_org_idx1; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_04_rcp_fp_rcp_status_id_org_idx1 ON "_OLD_4_fiscalization".fsc_receipt_part_2021_04 USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6734 (class 1259 OID 1614809)
-- Name: fsc_receipt_part_2021_04_rcp_notify_send_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_04_rcp_notify_send_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_04 USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6735 (class 1259 OID 1614837)
-- Name: fsc_receipt_part_2021_04_rcp_status_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_04_rcp_status_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_04 USING btree (rcp_status);


--
-- TOC entry 6738 (class 1259 OID 1614824)
-- Name: fsc_receipt_part_2021_05_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_05_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_05 USING btree (id_org);


--
-- TOC entry 6739 (class 1259 OID 1614740)
-- Name: fsc_receipt_part_2021_05_id_org_rcp_correction_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_05_id_org_rcp_correction_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_05 USING btree (id_org, rcp_correction);


--
-- TOC entry 6742 (class 1259 OID 1614768)
-- Name: fsc_receipt_part_2021_05_rcp_fp_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_05_rcp_fp_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_05 USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6743 (class 1259 OID 1614754)
-- Name: fsc_receipt_part_2021_05_rcp_fp_inn_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_05_rcp_fp_inn_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_05 USING btree (rcp_fp, inn);


--
-- TOC entry 6744 (class 1259 OID 1614782)
-- Name: fsc_receipt_part_2021_05_rcp_fp_rcp_status_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_05_rcp_fp_rcp_status_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_05 USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6745 (class 1259 OID 1614796)
-- Name: fsc_receipt_part_2021_05_rcp_fp_rcp_status_id_org_idx1; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_05_rcp_fp_rcp_status_id_org_idx1 ON "_OLD_4_fiscalization".fsc_receipt_part_2021_05 USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6746 (class 1259 OID 1614810)
-- Name: fsc_receipt_part_2021_05_rcp_notify_send_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_05_rcp_notify_send_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_05 USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6747 (class 1259 OID 1614838)
-- Name: fsc_receipt_part_2021_05_rcp_status_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_05_rcp_status_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_05 USING btree (rcp_status);


--
-- TOC entry 6750 (class 1259 OID 1614825)
-- Name: fsc_receipt_part_2021_06_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_06_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_06 USING btree (id_org);


--
-- TOC entry 6751 (class 1259 OID 1614741)
-- Name: fsc_receipt_part_2021_06_id_org_rcp_correction_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_06_id_org_rcp_correction_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_06 USING btree (id_org, rcp_correction);


--
-- TOC entry 6754 (class 1259 OID 1614769)
-- Name: fsc_receipt_part_2021_06_rcp_fp_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_06_rcp_fp_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_06 USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6755 (class 1259 OID 1614755)
-- Name: fsc_receipt_part_2021_06_rcp_fp_inn_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_06_rcp_fp_inn_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_06 USING btree (rcp_fp, inn);


--
-- TOC entry 6756 (class 1259 OID 1614783)
-- Name: fsc_receipt_part_2021_06_rcp_fp_rcp_status_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_06_rcp_fp_rcp_status_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_06 USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6757 (class 1259 OID 1614797)
-- Name: fsc_receipt_part_2021_06_rcp_fp_rcp_status_id_org_idx1; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_06_rcp_fp_rcp_status_id_org_idx1 ON "_OLD_4_fiscalization".fsc_receipt_part_2021_06 USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6758 (class 1259 OID 1614811)
-- Name: fsc_receipt_part_2021_06_rcp_notify_send_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_06_rcp_notify_send_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_06 USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6759 (class 1259 OID 1614839)
-- Name: fsc_receipt_part_2021_06_rcp_status_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_06_rcp_status_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_06 USING btree (rcp_status);


--
-- TOC entry 6762 (class 1259 OID 1614826)
-- Name: fsc_receipt_part_2021_07_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_07_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_07 USING btree (id_org);


--
-- TOC entry 6763 (class 1259 OID 1614742)
-- Name: fsc_receipt_part_2021_07_id_org_rcp_correction_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_07_id_org_rcp_correction_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_07 USING btree (id_org, rcp_correction);


--
-- TOC entry 6766 (class 1259 OID 1614770)
-- Name: fsc_receipt_part_2021_07_rcp_fp_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_07_rcp_fp_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_07 USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6767 (class 1259 OID 1614756)
-- Name: fsc_receipt_part_2021_07_rcp_fp_inn_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_07_rcp_fp_inn_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_07 USING btree (rcp_fp, inn);


--
-- TOC entry 6768 (class 1259 OID 1614784)
-- Name: fsc_receipt_part_2021_07_rcp_fp_rcp_status_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_07_rcp_fp_rcp_status_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_07 USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6769 (class 1259 OID 1614798)
-- Name: fsc_receipt_part_2021_07_rcp_fp_rcp_status_id_org_idx1; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_07_rcp_fp_rcp_status_id_org_idx1 ON "_OLD_4_fiscalization".fsc_receipt_part_2021_07 USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6770 (class 1259 OID 1614812)
-- Name: fsc_receipt_part_2021_07_rcp_notify_send_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_07_rcp_notify_send_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_07 USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6771 (class 1259 OID 1614840)
-- Name: fsc_receipt_part_2021_07_rcp_status_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_07_rcp_status_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_07 USING btree (rcp_status);


--
-- TOC entry 6774 (class 1259 OID 1614827)
-- Name: fsc_receipt_part_2021_08_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_08_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_08 USING btree (id_org);


--
-- TOC entry 6775 (class 1259 OID 1614743)
-- Name: fsc_receipt_part_2021_08_id_org_rcp_correction_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_08_id_org_rcp_correction_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_08 USING btree (id_org, rcp_correction);


--
-- TOC entry 6778 (class 1259 OID 1614771)
-- Name: fsc_receipt_part_2021_08_rcp_fp_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_08_rcp_fp_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_08 USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6779 (class 1259 OID 1614757)
-- Name: fsc_receipt_part_2021_08_rcp_fp_inn_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_08_rcp_fp_inn_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_08 USING btree (rcp_fp, inn);


--
-- TOC entry 6780 (class 1259 OID 1614785)
-- Name: fsc_receipt_part_2021_08_rcp_fp_rcp_status_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_08_rcp_fp_rcp_status_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_08 USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6781 (class 1259 OID 1614799)
-- Name: fsc_receipt_part_2021_08_rcp_fp_rcp_status_id_org_idx1; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_08_rcp_fp_rcp_status_id_org_idx1 ON "_OLD_4_fiscalization".fsc_receipt_part_2021_08 USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6782 (class 1259 OID 1614813)
-- Name: fsc_receipt_part_2021_08_rcp_notify_send_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_08_rcp_notify_send_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_08 USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6783 (class 1259 OID 1614841)
-- Name: fsc_receipt_part_2021_08_rcp_status_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_08_rcp_status_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_08 USING btree (rcp_status);


--
-- TOC entry 6786 (class 1259 OID 1614828)
-- Name: fsc_receipt_part_2021_09_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_09_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_09 USING btree (id_org);


--
-- TOC entry 6787 (class 1259 OID 1614744)
-- Name: fsc_receipt_part_2021_09_id_org_rcp_correction_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_09_id_org_rcp_correction_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_09 USING btree (id_org, rcp_correction);


--
-- TOC entry 6790 (class 1259 OID 1614772)
-- Name: fsc_receipt_part_2021_09_rcp_fp_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_09_rcp_fp_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_09 USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6791 (class 1259 OID 1614758)
-- Name: fsc_receipt_part_2021_09_rcp_fp_inn_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_09_rcp_fp_inn_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_09 USING btree (rcp_fp, inn);


--
-- TOC entry 6792 (class 1259 OID 1614786)
-- Name: fsc_receipt_part_2021_09_rcp_fp_rcp_status_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_09_rcp_fp_rcp_status_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_09 USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6793 (class 1259 OID 1614800)
-- Name: fsc_receipt_part_2021_09_rcp_fp_rcp_status_id_org_idx1; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_09_rcp_fp_rcp_status_id_org_idx1 ON "_OLD_4_fiscalization".fsc_receipt_part_2021_09 USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6794 (class 1259 OID 1614814)
-- Name: fsc_receipt_part_2021_09_rcp_notify_send_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_09_rcp_notify_send_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_09 USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6795 (class 1259 OID 1614842)
-- Name: fsc_receipt_part_2021_09_rcp_status_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_09_rcp_status_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_09 USING btree (rcp_status);


--
-- TOC entry 6798 (class 1259 OID 1614829)
-- Name: fsc_receipt_part_2021_10_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_10_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_10 USING btree (id_org);


--
-- TOC entry 6799 (class 1259 OID 1614745)
-- Name: fsc_receipt_part_2021_10_id_org_rcp_correction_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_10_id_org_rcp_correction_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_10 USING btree (id_org, rcp_correction);


--
-- TOC entry 6802 (class 1259 OID 1614773)
-- Name: fsc_receipt_part_2021_10_rcp_fp_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_10_rcp_fp_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_10 USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6803 (class 1259 OID 1614759)
-- Name: fsc_receipt_part_2021_10_rcp_fp_inn_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_10_rcp_fp_inn_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_10 USING btree (rcp_fp, inn);


--
-- TOC entry 6804 (class 1259 OID 1614787)
-- Name: fsc_receipt_part_2021_10_rcp_fp_rcp_status_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_10_rcp_fp_rcp_status_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_10 USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6805 (class 1259 OID 1614801)
-- Name: fsc_receipt_part_2021_10_rcp_fp_rcp_status_id_org_idx1; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_10_rcp_fp_rcp_status_id_org_idx1 ON "_OLD_4_fiscalization".fsc_receipt_part_2021_10 USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6806 (class 1259 OID 1614815)
-- Name: fsc_receipt_part_2021_10_rcp_notify_send_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_10_rcp_notify_send_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_10 USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6807 (class 1259 OID 1614843)
-- Name: fsc_receipt_part_2021_10_rcp_status_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_10_rcp_status_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_10 USING btree (rcp_status);


--
-- TOC entry 6810 (class 1259 OID 1614830)
-- Name: fsc_receipt_part_2021_11_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_11_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_11 USING btree (id_org);


--
-- TOC entry 6811 (class 1259 OID 1614746)
-- Name: fsc_receipt_part_2021_11_id_org_rcp_correction_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_11_id_org_rcp_correction_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_11 USING btree (id_org, rcp_correction);


--
-- TOC entry 6814 (class 1259 OID 1614774)
-- Name: fsc_receipt_part_2021_11_rcp_fp_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_11_rcp_fp_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_11 USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6815 (class 1259 OID 1614760)
-- Name: fsc_receipt_part_2021_11_rcp_fp_inn_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_11_rcp_fp_inn_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_11 USING btree (rcp_fp, inn);


--
-- TOC entry 6816 (class 1259 OID 1614788)
-- Name: fsc_receipt_part_2021_11_rcp_fp_rcp_status_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_11_rcp_fp_rcp_status_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_11 USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6817 (class 1259 OID 1614802)
-- Name: fsc_receipt_part_2021_11_rcp_fp_rcp_status_id_org_idx1; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_11_rcp_fp_rcp_status_id_org_idx1 ON "_OLD_4_fiscalization".fsc_receipt_part_2021_11 USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6818 (class 1259 OID 1614816)
-- Name: fsc_receipt_part_2021_11_rcp_notify_send_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_11_rcp_notify_send_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_11 USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6819 (class 1259 OID 1614844)
-- Name: fsc_receipt_part_2021_11_rcp_status_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_11_rcp_status_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_11 USING btree (rcp_status);


--
-- TOC entry 6822 (class 1259 OID 1614831)
-- Name: fsc_receipt_part_2021_12_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_12_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_12 USING btree (id_org);


--
-- TOC entry 6823 (class 1259 OID 1614747)
-- Name: fsc_receipt_part_2021_12_id_org_rcp_correction_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_12_id_org_rcp_correction_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_12 USING btree (id_org, rcp_correction);


--
-- TOC entry 6826 (class 1259 OID 1614775)
-- Name: fsc_receipt_part_2021_12_rcp_fp_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_12_rcp_fp_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_12 USING btree (rcp_fp NULLS FIRST, id_org) WHERE (rcp_fp IS NULL);


--
-- TOC entry 6827 (class 1259 OID 1614761)
-- Name: fsc_receipt_part_2021_12_rcp_fp_inn_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_12_rcp_fp_inn_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_12 USING btree (rcp_fp, inn);


--
-- TOC entry 6828 (class 1259 OID 1614789)
-- Name: fsc_receipt_part_2021_12_rcp_fp_rcp_status_id_org_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_12_rcp_fp_rcp_status_id_org_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_12 USING btree (rcp_fp, rcp_status, id_org) WHERE ((rcp_fp IS NULL) AND (rcp_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6829 (class 1259 OID 1614803)
-- Name: fsc_receipt_part_2021_12_rcp_fp_rcp_status_id_org_idx1; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_12_rcp_fp_rcp_status_id_org_idx1 ON "_OLD_4_fiscalization".fsc_receipt_part_2021_12 USING btree (rcp_fp NULLS FIRST, rcp_status NULLS FIRST, id_org NULLS FIRST) WHERE ((rcp_fp IS NULL) AND (rcp_status = 1));


--
-- TOC entry 6830 (class 1259 OID 1614817)
-- Name: fsc_receipt_part_2021_12_rcp_notify_send_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_12_rcp_notify_send_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_12 USING hash (rcp_notify_send) WHERE ((NOT rcp_notify_send) AND rcp_received);


--
-- TOC entry 6831 (class 1259 OID 1614845)
-- Name: fsc_receipt_part_2021_12_rcp_status_idx; Type: INDEX; Schema: _OLD_4_fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_part_2021_12_rcp_status_idx ON "_OLD_4_fiscalization".fsc_receipt_part_2021_12 USING btree (rcp_status);


--
-- TOC entry 7151 (class 1259 OID 2120395)
-- Name: ak1_org; Type: INDEX; Schema: fiscalization; Owner: postgres
--

CREATE UNIQUE INDEX ak1_org ON fiscalization.fsc_org USING btree (fsc_receipt_pcg.f_xxx_replace_char((nm_org_name)::text), inn);


--
-- TOC entry 7114 (class 1259 OID 2114657)
-- Name: ie1_receipt; Type: INDEX; Schema: fiscalization; Owner: postgres
--

CREATE INDEX ie1_receipt ON ONLY fiscalization.fsc_receipt USING btree (inn, rcp_nmb);


--
-- TOC entry 7117 (class 1259 OID 2114658)
-- Name: fsc_receipt_0_inn_rcp_nmb_idx; Type: INDEX; Schema: fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_0_inn_rcp_nmb_idx ON fiscalization.fsc_receipt_0 USING btree (inn, rcp_nmb);


--
-- TOC entry 7120 (class 1259 OID 2114659)
-- Name: fsc_receipt_1_inn_rcp_nmb_idx; Type: INDEX; Schema: fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_1_inn_rcp_nmb_idx ON fiscalization.fsc_receipt_1 USING btree (inn, rcp_nmb);


--
-- TOC entry 7132 (class 1259 OID 2114660)
-- Name: fsc_receipt_2_inn_rcp_nmb_idx; Type: INDEX; Schema: fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_2_inn_rcp_nmb_idx ON ONLY fiscalization.fsc_receipt_2 USING btree (inn, rcp_nmb);


--
-- TOC entry 7135 (class 1259 OID 2114661)
-- Name: fsc_receipt_2_2021_1_inn_rcp_nmb_idx; Type: INDEX; Schema: fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_2_2021_1_inn_rcp_nmb_idx ON fiscalization.fsc_receipt_2_2021_1 USING btree (inn, rcp_nmb);


--
-- TOC entry 7138 (class 1259 OID 2114662)
-- Name: fsc_receipt_2_2021_2_inn_rcp_nmb_idx; Type: INDEX; Schema: fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_2_2021_2_inn_rcp_nmb_idx ON fiscalization.fsc_receipt_2_2021_2 USING btree (inn, rcp_nmb);


--
-- TOC entry 7141 (class 1259 OID 2114663)
-- Name: fsc_receipt_2_2021_3_inn_rcp_nmb_idx; Type: INDEX; Schema: fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_2_2021_3_inn_rcp_nmb_idx ON fiscalization.fsc_receipt_2_2021_3 USING btree (inn, rcp_nmb);


--
-- TOC entry 7144 (class 1259 OID 2114664)
-- Name: fsc_receipt_2_2021_4_inn_rcp_nmb_idx; Type: INDEX; Schema: fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_2_2021_4_inn_rcp_nmb_idx ON fiscalization.fsc_receipt_2_2021_4 USING btree (inn, rcp_nmb);


--
-- TOC entry 7123 (class 1259 OID 2114665)
-- Name: fsc_receipt_3_inn_rcp_nmb_idx; Type: INDEX; Schema: fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_3_inn_rcp_nmb_idx ON fiscalization.fsc_receipt_3 USING btree (inn, rcp_nmb);


--
-- TOC entry 7126 (class 1259 OID 2114666)
-- Name: fsc_receipt_45_inn_rcp_nmb_idx; Type: INDEX; Schema: fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_45_inn_rcp_nmb_idx ON fiscalization.fsc_receipt_45 USING btree (inn, rcp_nmb);


--
-- TOC entry 7129 (class 1259 OID 2114667)
-- Name: fsc_receipt_default_inn_rcp_nmb_idx; Type: INDEX; Schema: fiscalization; Owner: postgres
--

CREATE INDEX fsc_receipt_default_inn_rcp_nmb_idx ON fiscalization.fsc_receipt_default USING btree (inn, rcp_nmb);


--
-- TOC entry 7172 (class 1259 OID 2115885)
-- Name: ie1_source_reestr; Type: INDEX; Schema: fiscalization; Owner: postgres
--

CREATE INDEX ie1_source_reestr ON fiscalization.fsc_source_reestr USING btree (type_source_reestr, dt_create);


--
-- TOC entry 6273 (class 1259 OID 908458)
-- Name: receipt_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_app_id_idx ON ONLY public.receipt USING btree (app_id);


--
-- TOC entry 6224 (class 1259 OID 908459)
-- Name: receipt_2018_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2018_app_id_idx ON public.receipt_2018 USING btree (app_id);


--
-- TOC entry 6274 (class 1259 OID 908466)
-- Name: receipt_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_dt_create_idx ON ONLY public.receipt USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6225 (class 1259 OID 908467)
-- Name: receipt_2018_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2018_dt_create_idx ON public.receipt_2018 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6284 (class 1259 OID 908530)
-- Name: report_full_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX report_full_idx ON ONLY public.receipt USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6226 (class 1259 OID 908531)
-- Name: receipt_2018_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2018_dt_create_org_id_app_id_correction_idx ON public.receipt_2018 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6275 (class 1259 OID 908474)
-- Name: receipt_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_fp_inn_idx ON ONLY public.receipt USING btree (fp, inn);


--
-- TOC entry 6227 (class 1259 OID 908475)
-- Name: receipt_2018_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2018_fp_inn_idx ON public.receipt_2018 USING btree (fp, inn);


--
-- TOC entry 6276 (class 1259 OID 908482)
-- Name: receipt_fp_isnull_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_fp_isnull_idx ON ONLY public.receipt USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6228 (class 1259 OID 908483)
-- Name: receipt_2018_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2018_fp_org_id_idx ON public.receipt_2018 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6277 (class 1259 OID 908490)
-- Name: receipt_fp_null_0_3_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_fp_null_0_3_idx ON ONLY public.receipt USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6229 (class 1259 OID 908491)
-- Name: receipt_2018_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2018_fp_receipt_status_org_id_idx ON public.receipt_2018 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6278 (class 1259 OID 908498)
-- Name: receipt_fp_null_1_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_fp_null_1_idx ON ONLY public.receipt USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6230 (class 1259 OID 908499)
-- Name: receipt_2018_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2018_fp_receipt_status_org_id_idx1 ON public.receipt_2018 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6285 (class 1259 OID 908538)
-- Name: uniq_receipt; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_receipt ON ONLY public.receipt USING btree (inn, uid, dt_create);


--
-- TOC entry 6231 (class 1259 OID 908539)
-- Name: receipt_2018_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_2018_inn_uid_dt_create_idx ON public.receipt_2018 USING btree (inn, uid, dt_create);


--
-- TOC entry 6279 (class 1259 OID 908506)
-- Name: receipt_notify_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_notify_idx ON ONLY public.receipt USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6232 (class 1259 OID 908507)
-- Name: receipt_2018_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2018_notify_send_app_id_idx ON public.receipt_2018 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6280 (class 1259 OID 908514)
-- Name: receipt_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_org_id_idx ON ONLY public.receipt USING btree (org_id);


--
-- TOC entry 6233 (class 1259 OID 908515)
-- Name: receipt_2018_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2018_org_id_idx ON public.receipt_2018 USING btree (org_id);


--
-- TOC entry 6283 (class 1259 OID 908522)
-- Name: receipt_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_receipt_status_idx ON ONLY public.receipt USING btree (receipt_status);


--
-- TOC entry 6234 (class 1259 OID 908523)
-- Name: receipt_2018_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2018_receipt_status_idx ON public.receipt_2018 USING btree (receipt_status);


--
-- TOC entry 6237 (class 1259 OID 908460)
-- Name: receipt_2019_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2019_app_id_idx ON public.receipt_2019 USING btree (app_id);


--
-- TOC entry 6238 (class 1259 OID 908468)
-- Name: receipt_2019_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2019_dt_create_idx ON public.receipt_2019 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6239 (class 1259 OID 908532)
-- Name: receipt_2019_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2019_dt_create_org_id_app_id_correction_idx ON public.receipt_2019 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6240 (class 1259 OID 908476)
-- Name: receipt_2019_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2019_fp_inn_idx ON public.receipt_2019 USING btree (fp, inn);


--
-- TOC entry 6241 (class 1259 OID 908484)
-- Name: receipt_2019_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2019_fp_org_id_idx ON public.receipt_2019 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6242 (class 1259 OID 908492)
-- Name: receipt_2019_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2019_fp_receipt_status_org_id_idx ON public.receipt_2019 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6243 (class 1259 OID 908500)
-- Name: receipt_2019_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2019_fp_receipt_status_org_id_idx1 ON public.receipt_2019 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6244 (class 1259 OID 908540)
-- Name: receipt_2019_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_2019_inn_uid_dt_create_idx ON public.receipt_2019 USING btree (inn, uid, dt_create);


--
-- TOC entry 6245 (class 1259 OID 908508)
-- Name: receipt_2019_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2019_notify_send_app_id_idx ON public.receipt_2019 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6246 (class 1259 OID 908516)
-- Name: receipt_2019_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2019_org_id_idx ON public.receipt_2019 USING btree (org_id);


--
-- TOC entry 6247 (class 1259 OID 908524)
-- Name: receipt_2019_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_2019_receipt_status_idx ON public.receipt_2019 USING btree (receipt_status);


--
-- TOC entry 6325 (class 1259 OID 908465)
-- Name: receipt_default_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_default_app_id_idx ON public.receipt_default USING btree (app_id);


--
-- TOC entry 6326 (class 1259 OID 908473)
-- Name: receipt_default_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_default_dt_create_idx ON public.receipt_default USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6327 (class 1259 OID 908537)
-- Name: receipt_default_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_default_dt_create_org_id_app_id_correction_idx ON public.receipt_default USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6328 (class 1259 OID 908481)
-- Name: receipt_default_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_default_fp_inn_idx ON public.receipt_default USING btree (fp, inn);


--
-- TOC entry 6329 (class 1259 OID 908489)
-- Name: receipt_default_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_default_fp_org_id_idx ON public.receipt_default USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6330 (class 1259 OID 908497)
-- Name: receipt_default_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_default_fp_receipt_status_org_id_idx ON public.receipt_default USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6331 (class 1259 OID 908505)
-- Name: receipt_default_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_default_fp_receipt_status_org_id_idx1 ON public.receipt_default USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6332 (class 1259 OID 908545)
-- Name: receipt_default_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_default_inn_uid_dt_create_idx ON public.receipt_default USING btree (inn, uid, dt_create);


--
-- TOC entry 6333 (class 1259 OID 908513)
-- Name: receipt_default_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_default_notify_send_app_id_idx ON public.receipt_default USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6334 (class 1259 OID 908521)
-- Name: receipt_default_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_default_org_id_idx ON public.receipt_default USING btree (org_id);


--
-- TOC entry 6337 (class 1259 OID 908529)
-- Name: receipt_default_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_default_receipt_status_idx ON public.receipt_default USING btree (receipt_status);


--
-- TOC entry 6205 (class 1259 OID 908461)
-- Name: receipt_old_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_old_app_id_idx ON public.receipt_old USING btree (app_id);


--
-- TOC entry 6206 (class 1259 OID 908469)
-- Name: receipt_old_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_old_dt_create_idx ON public.receipt_old USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6207 (class 1259 OID 908533)
-- Name: receipt_old_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_old_dt_create_org_id_app_id_correction_idx ON public.receipt_old USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6208 (class 1259 OID 908477)
-- Name: receipt_old_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_old_fp_inn_idx ON public.receipt_old USING btree (fp, inn);


--
-- TOC entry 6209 (class 1259 OID 908485)
-- Name: receipt_old_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_old_fp_org_id_idx ON public.receipt_old USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6210 (class 1259 OID 908493)
-- Name: receipt_old_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_old_fp_receipt_status_org_id_idx ON public.receipt_old USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6211 (class 1259 OID 908501)
-- Name: receipt_old_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_old_fp_receipt_status_org_id_idx1 ON public.receipt_old USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6212 (class 1259 OID 908541)
-- Name: receipt_old_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_old_inn_uid_dt_create_idx ON public.receipt_old USING btree (inn, uid, dt_create);


--
-- TOC entry 6213 (class 1259 OID 908509)
-- Name: receipt_old_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_old_notify_send_app_id_idx ON public.receipt_old USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6214 (class 1259 OID 908517)
-- Name: receipt_old_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_old_org_id_idx ON public.receipt_old USING btree (org_id);


--
-- TOC entry 6215 (class 1259 OID 908525)
-- Name: receipt_old_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_old_receipt_status_idx ON public.receipt_old USING btree (receipt_status);


--
-- TOC entry 6459 (class 1259 OID 1509672)
-- Name: receipt_part_2021_01_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_01_app_id_idx ON public.receipt_part_2021_01 USING btree (app_id);


--
-- TOC entry 6460 (class 1259 OID 1509673)
-- Name: receipt_part_2021_01_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_01_dt_create_idx ON public.receipt_part_2021_01 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6461 (class 1259 OID 1509681)
-- Name: receipt_part_2021_01_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_01_dt_create_org_id_app_id_correction_idx ON public.receipt_part_2021_01 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6462 (class 1259 OID 1509674)
-- Name: receipt_part_2021_01_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_01_fp_inn_idx ON public.receipt_part_2021_01 USING btree (fp, inn);


--
-- TOC entry 6463 (class 1259 OID 1509675)
-- Name: receipt_part_2021_01_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_01_fp_org_id_idx ON public.receipt_part_2021_01 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6464 (class 1259 OID 1509676)
-- Name: receipt_part_2021_01_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_01_fp_receipt_status_org_id_idx ON public.receipt_part_2021_01 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6465 (class 1259 OID 1509677)
-- Name: receipt_part_2021_01_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_01_fp_receipt_status_org_id_idx1 ON public.receipt_part_2021_01 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6466 (class 1259 OID 1509682)
-- Name: receipt_part_2021_01_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_part_2021_01_inn_uid_dt_create_idx ON public.receipt_part_2021_01 USING btree (inn, uid, dt_create);


--
-- TOC entry 6467 (class 1259 OID 1509678)
-- Name: receipt_part_2021_01_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_01_notify_send_app_id_idx ON public.receipt_part_2021_01 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6468 (class 1259 OID 1509679)
-- Name: receipt_part_2021_01_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_01_org_id_idx ON public.receipt_part_2021_01 USING btree (org_id);


--
-- TOC entry 6469 (class 1259 OID 1509680)
-- Name: receipt_part_2021_01_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_01_receipt_status_idx ON public.receipt_part_2021_01 USING btree (receipt_status);


--
-- TOC entry 6446 (class 1259 OID 1474280)
-- Name: receipt_part_2021_02_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_02_app_id_idx ON public.receipt_part_2021_02 USING btree (app_id);


--
-- TOC entry 6447 (class 1259 OID 1474281)
-- Name: receipt_part_2021_02_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_02_dt_create_idx ON public.receipt_part_2021_02 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6448 (class 1259 OID 1474289)
-- Name: receipt_part_2021_02_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_02_dt_create_org_id_app_id_correction_idx ON public.receipt_part_2021_02 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6449 (class 1259 OID 1474282)
-- Name: receipt_part_2021_02_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_02_fp_inn_idx ON public.receipt_part_2021_02 USING btree (fp, inn);


--
-- TOC entry 6450 (class 1259 OID 1474283)
-- Name: receipt_part_2021_02_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_02_fp_org_id_idx ON public.receipt_part_2021_02 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6451 (class 1259 OID 1474284)
-- Name: receipt_part_2021_02_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_02_fp_receipt_status_org_id_idx ON public.receipt_part_2021_02 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6452 (class 1259 OID 1474285)
-- Name: receipt_part_2021_02_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_02_fp_receipt_status_org_id_idx1 ON public.receipt_part_2021_02 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6453 (class 1259 OID 1474290)
-- Name: receipt_part_2021_02_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_part_2021_02_inn_uid_dt_create_idx ON public.receipt_part_2021_02 USING btree (inn, uid, dt_create);


--
-- TOC entry 6454 (class 1259 OID 1474286)
-- Name: receipt_part_2021_02_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_02_notify_send_app_id_idx ON public.receipt_part_2021_02 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6455 (class 1259 OID 1474287)
-- Name: receipt_part_2021_02_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_02_org_id_idx ON public.receipt_part_2021_02 USING btree (org_id);


--
-- TOC entry 6456 (class 1259 OID 1474288)
-- Name: receipt_part_2021_02_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_02_receipt_status_idx ON public.receipt_part_2021_02 USING btree (receipt_status);


--
-- TOC entry 6433 (class 1259 OID 1474263)
-- Name: receipt_part_2021_03_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_03_app_id_idx ON public.receipt_part_2021_03 USING btree (app_id);


--
-- TOC entry 6434 (class 1259 OID 1474264)
-- Name: receipt_part_2021_03_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_03_dt_create_idx ON public.receipt_part_2021_03 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6435 (class 1259 OID 1474272)
-- Name: receipt_part_2021_03_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_03_dt_create_org_id_app_id_correction_idx ON public.receipt_part_2021_03 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6436 (class 1259 OID 1474265)
-- Name: receipt_part_2021_03_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_03_fp_inn_idx ON public.receipt_part_2021_03 USING btree (fp, inn);


--
-- TOC entry 6437 (class 1259 OID 1474266)
-- Name: receipt_part_2021_03_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_03_fp_org_id_idx ON public.receipt_part_2021_03 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6438 (class 1259 OID 1474267)
-- Name: receipt_part_2021_03_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_03_fp_receipt_status_org_id_idx ON public.receipt_part_2021_03 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6439 (class 1259 OID 1474268)
-- Name: receipt_part_2021_03_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_03_fp_receipt_status_org_id_idx1 ON public.receipt_part_2021_03 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6440 (class 1259 OID 1474273)
-- Name: receipt_part_2021_03_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_part_2021_03_inn_uid_dt_create_idx ON public.receipt_part_2021_03 USING btree (inn, uid, dt_create);


--
-- TOC entry 6441 (class 1259 OID 1474269)
-- Name: receipt_part_2021_03_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_03_notify_send_app_id_idx ON public.receipt_part_2021_03 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6442 (class 1259 OID 1474270)
-- Name: receipt_part_2021_03_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_03_org_id_idx ON public.receipt_part_2021_03 USING btree (org_id);


--
-- TOC entry 6443 (class 1259 OID 1474271)
-- Name: receipt_part_2021_03_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_03_receipt_status_idx ON public.receipt_part_2021_03 USING btree (receipt_status);


--
-- TOC entry 6420 (class 1259 OID 1474246)
-- Name: receipt_part_2021_04_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_04_app_id_idx ON public.receipt_part_2021_04 USING btree (app_id);


--
-- TOC entry 6421 (class 1259 OID 1474247)
-- Name: receipt_part_2021_04_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_04_dt_create_idx ON public.receipt_part_2021_04 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6422 (class 1259 OID 1474255)
-- Name: receipt_part_2021_04_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_04_dt_create_org_id_app_id_correction_idx ON public.receipt_part_2021_04 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6423 (class 1259 OID 1474248)
-- Name: receipt_part_2021_04_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_04_fp_inn_idx ON public.receipt_part_2021_04 USING btree (fp, inn);


--
-- TOC entry 6424 (class 1259 OID 1474249)
-- Name: receipt_part_2021_04_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_04_fp_org_id_idx ON public.receipt_part_2021_04 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6425 (class 1259 OID 1474250)
-- Name: receipt_part_2021_04_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_04_fp_receipt_status_org_id_idx ON public.receipt_part_2021_04 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6426 (class 1259 OID 1474251)
-- Name: receipt_part_2021_04_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_04_fp_receipt_status_org_id_idx1 ON public.receipt_part_2021_04 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6427 (class 1259 OID 1474256)
-- Name: receipt_part_2021_04_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_part_2021_04_inn_uid_dt_create_idx ON public.receipt_part_2021_04 USING btree (inn, uid, dt_create);


--
-- TOC entry 6428 (class 1259 OID 1474252)
-- Name: receipt_part_2021_04_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_04_notify_send_app_id_idx ON public.receipt_part_2021_04 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6429 (class 1259 OID 1474253)
-- Name: receipt_part_2021_04_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_04_org_id_idx ON public.receipt_part_2021_04 USING btree (org_id);


--
-- TOC entry 6430 (class 1259 OID 1474254)
-- Name: receipt_part_2021_04_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_04_receipt_status_idx ON public.receipt_part_2021_04 USING btree (receipt_status);


--
-- TOC entry 6407 (class 1259 OID 1474229)
-- Name: receipt_part_2021_05_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_05_app_id_idx ON public.receipt_part_2021_05 USING btree (app_id);


--
-- TOC entry 6408 (class 1259 OID 1474230)
-- Name: receipt_part_2021_05_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_05_dt_create_idx ON public.receipt_part_2021_05 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6409 (class 1259 OID 1474238)
-- Name: receipt_part_2021_05_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_05_dt_create_org_id_app_id_correction_idx ON public.receipt_part_2021_05 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6410 (class 1259 OID 1474231)
-- Name: receipt_part_2021_05_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_05_fp_inn_idx ON public.receipt_part_2021_05 USING btree (fp, inn);


--
-- TOC entry 6411 (class 1259 OID 1474232)
-- Name: receipt_part_2021_05_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_05_fp_org_id_idx ON public.receipt_part_2021_05 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6412 (class 1259 OID 1474233)
-- Name: receipt_part_2021_05_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_05_fp_receipt_status_org_id_idx ON public.receipt_part_2021_05 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6413 (class 1259 OID 1474234)
-- Name: receipt_part_2021_05_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_05_fp_receipt_status_org_id_idx1 ON public.receipt_part_2021_05 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6414 (class 1259 OID 1474239)
-- Name: receipt_part_2021_05_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_part_2021_05_inn_uid_dt_create_idx ON public.receipt_part_2021_05 USING btree (inn, uid, dt_create);


--
-- TOC entry 6415 (class 1259 OID 1474235)
-- Name: receipt_part_2021_05_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_05_notify_send_app_id_idx ON public.receipt_part_2021_05 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6416 (class 1259 OID 1474236)
-- Name: receipt_part_2021_05_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_05_org_id_idx ON public.receipt_part_2021_05 USING btree (org_id);


--
-- TOC entry 6417 (class 1259 OID 1474237)
-- Name: receipt_part_2021_05_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_05_receipt_status_idx ON public.receipt_part_2021_05 USING btree (receipt_status);


--
-- TOC entry 6394 (class 1259 OID 1474212)
-- Name: receipt_part_2021_06_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_06_app_id_idx ON public.receipt_part_2021_06 USING btree (app_id);


--
-- TOC entry 6395 (class 1259 OID 1474213)
-- Name: receipt_part_2021_06_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_06_dt_create_idx ON public.receipt_part_2021_06 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6396 (class 1259 OID 1474221)
-- Name: receipt_part_2021_06_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_06_dt_create_org_id_app_id_correction_idx ON public.receipt_part_2021_06 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6397 (class 1259 OID 1474214)
-- Name: receipt_part_2021_06_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_06_fp_inn_idx ON public.receipt_part_2021_06 USING btree (fp, inn);


--
-- TOC entry 6398 (class 1259 OID 1474215)
-- Name: receipt_part_2021_06_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_06_fp_org_id_idx ON public.receipt_part_2021_06 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6399 (class 1259 OID 1474216)
-- Name: receipt_part_2021_06_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_06_fp_receipt_status_org_id_idx ON public.receipt_part_2021_06 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6400 (class 1259 OID 1474217)
-- Name: receipt_part_2021_06_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_06_fp_receipt_status_org_id_idx1 ON public.receipt_part_2021_06 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6401 (class 1259 OID 1474222)
-- Name: receipt_part_2021_06_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_part_2021_06_inn_uid_dt_create_idx ON public.receipt_part_2021_06 USING btree (inn, uid, dt_create);


--
-- TOC entry 6402 (class 1259 OID 1474218)
-- Name: receipt_part_2021_06_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_06_notify_send_app_id_idx ON public.receipt_part_2021_06 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6403 (class 1259 OID 1474219)
-- Name: receipt_part_2021_06_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_06_org_id_idx ON public.receipt_part_2021_06 USING btree (org_id);


--
-- TOC entry 6404 (class 1259 OID 1474220)
-- Name: receipt_part_2021_06_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_06_receipt_status_idx ON public.receipt_part_2021_06 USING btree (receipt_status);


--
-- TOC entry 6381 (class 1259 OID 1146707)
-- Name: receipt_part_2021_07_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_07_app_id_idx ON public.receipt_part_2021_07 USING btree (app_id);


--
-- TOC entry 6382 (class 1259 OID 1146708)
-- Name: receipt_part_2021_07_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_07_dt_create_idx ON public.receipt_part_2021_07 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6383 (class 1259 OID 1146716)
-- Name: receipt_part_2021_07_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_07_dt_create_org_id_app_id_correction_idx ON public.receipt_part_2021_07 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6384 (class 1259 OID 1146709)
-- Name: receipt_part_2021_07_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_07_fp_inn_idx ON public.receipt_part_2021_07 USING btree (fp, inn);


--
-- TOC entry 6385 (class 1259 OID 1146710)
-- Name: receipt_part_2021_07_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_07_fp_org_id_idx ON public.receipt_part_2021_07 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6386 (class 1259 OID 1146711)
-- Name: receipt_part_2021_07_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_07_fp_receipt_status_org_id_idx ON public.receipt_part_2021_07 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6387 (class 1259 OID 1146712)
-- Name: receipt_part_2021_07_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_07_fp_receipt_status_org_id_idx1 ON public.receipt_part_2021_07 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6388 (class 1259 OID 1146717)
-- Name: receipt_part_2021_07_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_part_2021_07_inn_uid_dt_create_idx ON public.receipt_part_2021_07 USING btree (inn, uid, dt_create);


--
-- TOC entry 6389 (class 1259 OID 1146713)
-- Name: receipt_part_2021_07_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_07_notify_send_app_id_idx ON public.receipt_part_2021_07 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6390 (class 1259 OID 1146714)
-- Name: receipt_part_2021_07_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_07_org_id_idx ON public.receipt_part_2021_07 USING btree (org_id);


--
-- TOC entry 6391 (class 1259 OID 1146715)
-- Name: receipt_part_2021_07_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_07_receipt_status_idx ON public.receipt_part_2021_07 USING btree (receipt_status);


--
-- TOC entry 6368 (class 1259 OID 1146690)
-- Name: receipt_part_2021_08_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_08_app_id_idx ON public.receipt_part_2021_08 USING btree (app_id);


--
-- TOC entry 6369 (class 1259 OID 1146691)
-- Name: receipt_part_2021_08_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_08_dt_create_idx ON public.receipt_part_2021_08 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6370 (class 1259 OID 1146699)
-- Name: receipt_part_2021_08_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_08_dt_create_org_id_app_id_correction_idx ON public.receipt_part_2021_08 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6371 (class 1259 OID 1146692)
-- Name: receipt_part_2021_08_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_08_fp_inn_idx ON public.receipt_part_2021_08 USING btree (fp, inn);


--
-- TOC entry 6372 (class 1259 OID 1146693)
-- Name: receipt_part_2021_08_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_08_fp_org_id_idx ON public.receipt_part_2021_08 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6373 (class 1259 OID 1146694)
-- Name: receipt_part_2021_08_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_08_fp_receipt_status_org_id_idx ON public.receipt_part_2021_08 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6374 (class 1259 OID 1146695)
-- Name: receipt_part_2021_08_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_08_fp_receipt_status_org_id_idx1 ON public.receipt_part_2021_08 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6375 (class 1259 OID 1146700)
-- Name: receipt_part_2021_08_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_part_2021_08_inn_uid_dt_create_idx ON public.receipt_part_2021_08 USING btree (inn, uid, dt_create);


--
-- TOC entry 6376 (class 1259 OID 1146696)
-- Name: receipt_part_2021_08_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_08_notify_send_app_id_idx ON public.receipt_part_2021_08 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6377 (class 1259 OID 1146697)
-- Name: receipt_part_2021_08_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_08_org_id_idx ON public.receipt_part_2021_08 USING btree (org_id);


--
-- TOC entry 6378 (class 1259 OID 1146698)
-- Name: receipt_part_2021_08_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_08_receipt_status_idx ON public.receipt_part_2021_08 USING btree (receipt_status);


--
-- TOC entry 6355 (class 1259 OID 1146672)
-- Name: receipt_part_2021_09_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_09_app_id_idx ON public.receipt_part_2021_09 USING btree (app_id);


--
-- TOC entry 6356 (class 1259 OID 1146673)
-- Name: receipt_part_2021_09_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_09_dt_create_idx ON public.receipt_part_2021_09 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6357 (class 1259 OID 1146681)
-- Name: receipt_part_2021_09_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_09_dt_create_org_id_app_id_correction_idx ON public.receipt_part_2021_09 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6358 (class 1259 OID 1146674)
-- Name: receipt_part_2021_09_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_09_fp_inn_idx ON public.receipt_part_2021_09 USING btree (fp, inn);


--
-- TOC entry 6359 (class 1259 OID 1146675)
-- Name: receipt_part_2021_09_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_09_fp_org_id_idx ON public.receipt_part_2021_09 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6360 (class 1259 OID 1146676)
-- Name: receipt_part_2021_09_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_09_fp_receipt_status_org_id_idx ON public.receipt_part_2021_09 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6361 (class 1259 OID 1146677)
-- Name: receipt_part_2021_09_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_09_fp_receipt_status_org_id_idx1 ON public.receipt_part_2021_09 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6362 (class 1259 OID 1146682)
-- Name: receipt_part_2021_09_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_part_2021_09_inn_uid_dt_create_idx ON public.receipt_part_2021_09 USING btree (inn, uid, dt_create);


--
-- TOC entry 6363 (class 1259 OID 1146678)
-- Name: receipt_part_2021_09_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_09_notify_send_app_id_idx ON public.receipt_part_2021_09 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6364 (class 1259 OID 1146679)
-- Name: receipt_part_2021_09_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_09_org_id_idx ON public.receipt_part_2021_09 USING btree (org_id);


--
-- TOC entry 6365 (class 1259 OID 1146680)
-- Name: receipt_part_2021_09_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_09_receipt_status_idx ON public.receipt_part_2021_09 USING btree (receipt_status);


--
-- TOC entry 6342 (class 1259 OID 1146655)
-- Name: receipt_part_2021_10_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_10_app_id_idx ON public.receipt_part_2021_10 USING btree (app_id);


--
-- TOC entry 6343 (class 1259 OID 1146656)
-- Name: receipt_part_2021_10_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_10_dt_create_idx ON public.receipt_part_2021_10 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6344 (class 1259 OID 1146664)
-- Name: receipt_part_2021_10_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_10_dt_create_org_id_app_id_correction_idx ON public.receipt_part_2021_10 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6345 (class 1259 OID 1146657)
-- Name: receipt_part_2021_10_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_10_fp_inn_idx ON public.receipt_part_2021_10 USING btree (fp, inn);


--
-- TOC entry 6346 (class 1259 OID 1146658)
-- Name: receipt_part_2021_10_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_10_fp_org_id_idx ON public.receipt_part_2021_10 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6347 (class 1259 OID 1146659)
-- Name: receipt_part_2021_10_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_10_fp_receipt_status_org_id_idx ON public.receipt_part_2021_10 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6348 (class 1259 OID 1146660)
-- Name: receipt_part_2021_10_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_10_fp_receipt_status_org_id_idx1 ON public.receipt_part_2021_10 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6349 (class 1259 OID 1146665)
-- Name: receipt_part_2021_10_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_part_2021_10_inn_uid_dt_create_idx ON public.receipt_part_2021_10 USING btree (inn, uid, dt_create);


--
-- TOC entry 6350 (class 1259 OID 1146661)
-- Name: receipt_part_2021_10_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_10_notify_send_app_id_idx ON public.receipt_part_2021_10 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6351 (class 1259 OID 1146662)
-- Name: receipt_part_2021_10_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_10_org_id_idx ON public.receipt_part_2021_10 USING btree (org_id);


--
-- TOC entry 6352 (class 1259 OID 1146663)
-- Name: receipt_part_2021_10_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_10_receipt_status_idx ON public.receipt_part_2021_10 USING btree (receipt_status);


--
-- TOC entry 6288 (class 1259 OID 908462)
-- Name: receipt_part_2021_11_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_11_app_id_idx ON public.receipt_part_2021_11 USING btree (app_id);


--
-- TOC entry 6289 (class 1259 OID 908470)
-- Name: receipt_part_2021_11_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_11_dt_create_idx ON public.receipt_part_2021_11 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6290 (class 1259 OID 908534)
-- Name: receipt_part_2021_11_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_11_dt_create_org_id_app_id_correction_idx ON public.receipt_part_2021_11 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6291 (class 1259 OID 908478)
-- Name: receipt_part_2021_11_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_11_fp_inn_idx ON public.receipt_part_2021_11 USING btree (fp, inn);


--
-- TOC entry 6292 (class 1259 OID 908486)
-- Name: receipt_part_2021_11_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_11_fp_org_id_idx ON public.receipt_part_2021_11 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6293 (class 1259 OID 908494)
-- Name: receipt_part_2021_11_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_11_fp_receipt_status_org_id_idx ON public.receipt_part_2021_11 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6294 (class 1259 OID 908502)
-- Name: receipt_part_2021_11_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_11_fp_receipt_status_org_id_idx1 ON public.receipt_part_2021_11 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6295 (class 1259 OID 908542)
-- Name: receipt_part_2021_11_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_part_2021_11_inn_uid_dt_create_idx ON public.receipt_part_2021_11 USING btree (inn, uid, dt_create);


--
-- TOC entry 6296 (class 1259 OID 908510)
-- Name: receipt_part_2021_11_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_11_notify_send_app_id_idx ON public.receipt_part_2021_11 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6297 (class 1259 OID 908518)
-- Name: receipt_part_2021_11_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_11_org_id_idx ON public.receipt_part_2021_11 USING btree (org_id);


--
-- TOC entry 6298 (class 1259 OID 908526)
-- Name: receipt_part_2021_11_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_11_receipt_status_idx ON public.receipt_part_2021_11 USING btree (receipt_status);


--
-- TOC entry 6301 (class 1259 OID 908463)
-- Name: receipt_part_2021_12_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_12_app_id_idx ON public.receipt_part_2021_12 USING btree (app_id);


--
-- TOC entry 6302 (class 1259 OID 908471)
-- Name: receipt_part_2021_12_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_12_dt_create_idx ON public.receipt_part_2021_12 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6303 (class 1259 OID 908535)
-- Name: receipt_part_2021_12_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_12_dt_create_org_id_app_id_correction_idx ON public.receipt_part_2021_12 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6304 (class 1259 OID 908479)
-- Name: receipt_part_2021_12_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_12_fp_inn_idx ON public.receipt_part_2021_12 USING btree (fp, inn);


--
-- TOC entry 6305 (class 1259 OID 908487)
-- Name: receipt_part_2021_12_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_12_fp_org_id_idx ON public.receipt_part_2021_12 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6306 (class 1259 OID 908495)
-- Name: receipt_part_2021_12_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_12_fp_receipt_status_org_id_idx ON public.receipt_part_2021_12 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6307 (class 1259 OID 908503)
-- Name: receipt_part_2021_12_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_12_fp_receipt_status_org_id_idx1 ON public.receipt_part_2021_12 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6308 (class 1259 OID 908543)
-- Name: receipt_part_2021_12_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_part_2021_12_inn_uid_dt_create_idx ON public.receipt_part_2021_12 USING btree (inn, uid, dt_create);


--
-- TOC entry 6309 (class 1259 OID 908511)
-- Name: receipt_part_2021_12_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_12_notify_send_app_id_idx ON public.receipt_part_2021_12 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6310 (class 1259 OID 908519)
-- Name: receipt_part_2021_12_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_12_org_id_idx ON public.receipt_part_2021_12 USING btree (org_id);


--
-- TOC entry 6311 (class 1259 OID 908527)
-- Name: receipt_part_2021_12_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2021_12_receipt_status_idx ON public.receipt_part_2021_12 USING btree (receipt_status);


--
-- TOC entry 6314 (class 1259 OID 908464)
-- Name: receipt_part_2022_01_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2022_01_app_id_idx ON public.receipt_part_2022_01 USING btree (app_id);


--
-- TOC entry 6315 (class 1259 OID 908472)
-- Name: receipt_part_2022_01_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2022_01_dt_create_idx ON public.receipt_part_2022_01 USING btree (dt_create DESC NULLS LAST);


--
-- TOC entry 6316 (class 1259 OID 908536)
-- Name: receipt_part_2022_01_dt_create_org_id_app_id_correction_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2022_01_dt_create_org_id_app_id_correction_idx ON public.receipt_part_2022_01 USING btree (dt_create, org_id, app_id, correction);


--
-- TOC entry 6317 (class 1259 OID 908480)
-- Name: receipt_part_2022_01_fp_inn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2022_01_fp_inn_idx ON public.receipt_part_2022_01 USING btree (fp, inn);


--
-- TOC entry 6318 (class 1259 OID 908488)
-- Name: receipt_part_2022_01_fp_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2022_01_fp_org_id_idx ON public.receipt_part_2022_01 USING btree (fp NULLS FIRST, org_id) WHERE (fp IS NULL);


--
-- TOC entry 6319 (class 1259 OID 908496)
-- Name: receipt_part_2022_01_fp_receipt_status_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2022_01_fp_receipt_status_org_id_idx ON public.receipt_part_2022_01 USING btree (fp, receipt_status, org_id) WHERE ((fp IS NULL) AND (receipt_status = ANY (ARRAY[0, 3])));


--
-- TOC entry 6320 (class 1259 OID 908504)
-- Name: receipt_part_2022_01_fp_receipt_status_org_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2022_01_fp_receipt_status_org_id_idx1 ON public.receipt_part_2022_01 USING btree (fp NULLS FIRST, receipt_status NULLS FIRST, org_id NULLS FIRST) WHERE ((fp IS NULL) AND (receipt_status = 1));


--
-- TOC entry 6321 (class 1259 OID 908544)
-- Name: receipt_part_2022_01_inn_uid_dt_create_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX receipt_part_2022_01_inn_uid_dt_create_idx ON public.receipt_part_2022_01 USING btree (inn, uid, dt_create);


--
-- TOC entry 6322 (class 1259 OID 908512)
-- Name: receipt_part_2022_01_notify_send_app_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2022_01_notify_send_app_id_idx ON public.receipt_part_2022_01 USING btree (notify_send, app_id) WHERE ((notify_send = 0) AND (receipt_received = 1));


--
-- TOC entry 6323 (class 1259 OID 908520)
-- Name: receipt_part_2022_01_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2022_01_org_id_idx ON public.receipt_part_2022_01 USING btree (org_id);


--
-- TOC entry 6324 (class 1259 OID 908528)
-- Name: receipt_part_2022_01_receipt_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX receipt_part_2022_01_receipt_status_idx ON public.receipt_part_2022_01 USING btree (receipt_status);


--
-- TOC entry 7379 (class 0 OID 0)
-- Name: fsc_payment_default_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_default_pkey;


--
-- TOC entry 7367 (class 0 OID 0)
-- Name: fsc_payment_part_2021_01_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_01_pkey;


--
-- TOC entry 7368 (class 0 OID 0)
-- Name: fsc_payment_part_2021_02_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_02_pkey;


--
-- TOC entry 7369 (class 0 OID 0)
-- Name: fsc_payment_part_2021_03_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_03_pkey;


--
-- TOC entry 7370 (class 0 OID 0)
-- Name: fsc_payment_part_2021_04_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_04_pkey;


--
-- TOC entry 7371 (class 0 OID 0)
-- Name: fsc_payment_part_2021_05_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_05_pkey;


--
-- TOC entry 7372 (class 0 OID 0)
-- Name: fsc_payment_part_2021_06_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_06_pkey;


--
-- TOC entry 7373 (class 0 OID 0)
-- Name: fsc_payment_part_2021_07_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_07_pkey;


--
-- TOC entry 7374 (class 0 OID 0)
-- Name: fsc_payment_part_2021_08_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_08_pkey;


--
-- TOC entry 7375 (class 0 OID 0)
-- Name: fsc_payment_part_2021_09_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_09_pkey;


--
-- TOC entry 7376 (class 0 OID 0)
-- Name: fsc_payment_part_2021_10_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_10_pkey;


--
-- TOC entry 7377 (class 0 OID 0)
-- Name: fsc_payment_part_2021_11_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_11_pkey;


--
-- TOC entry 7378 (class 0 OID 0)
-- Name: fsc_payment_part_2021_12_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_payment ATTACH PARTITION "_OLD_1_fiscalization".fsc_payment_part_2021_12_pkey;


--
-- TOC entry 7392 (class 0 OID 0)
-- Name: fsc_receipt_default_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_default_pkey;


--
-- TOC entry 7405 (class 0 OID 0)
-- Name: fsc_receipt_js_default_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_default_pkey;


--
-- TOC entry 7393 (class 0 OID 0)
-- Name: fsc_receipt_js_part_2021_01_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_01_pkey;


--
-- TOC entry 7394 (class 0 OID 0)
-- Name: fsc_receipt_js_part_2021_02_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_02_pkey;


--
-- TOC entry 7395 (class 0 OID 0)
-- Name: fsc_receipt_js_part_2021_03_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_03_pkey;


--
-- TOC entry 7396 (class 0 OID 0)
-- Name: fsc_receipt_js_part_2021_04_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_04_pkey;


--
-- TOC entry 7397 (class 0 OID 0)
-- Name: fsc_receipt_js_part_2021_05_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_05_pkey;


--
-- TOC entry 7398 (class 0 OID 0)
-- Name: fsc_receipt_js_part_2021_06_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_06_pkey;


--
-- TOC entry 7399 (class 0 OID 0)
-- Name: fsc_receipt_js_part_2021_07_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_07_pkey;


--
-- TOC entry 7400 (class 0 OID 0)
-- Name: fsc_receipt_js_part_2021_08_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_08_pkey;


--
-- TOC entry 7401 (class 0 OID 0)
-- Name: fsc_receipt_js_part_2021_09_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_09_pkey;


--
-- TOC entry 7402 (class 0 OID 0)
-- Name: fsc_receipt_js_part_2021_10_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_10_pkey;


--
-- TOC entry 7403 (class 0 OID 0)
-- Name: fsc_receipt_js_part_2021_11_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_11_pkey;


--
-- TOC entry 7404 (class 0 OID 0)
-- Name: fsc_receipt_js_part_2021_12_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt_js ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_js_part_2021_12_pkey;


--
-- TOC entry 7380 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_01_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_01_pkey;


--
-- TOC entry 7381 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_02_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_02_pkey;


--
-- TOC entry 7382 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_03_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_03_pkey;


--
-- TOC entry 7383 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_04_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_04_pkey;


--
-- TOC entry 7384 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_05_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_05_pkey;


--
-- TOC entry 7385 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_06_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_06_pkey;


--
-- TOC entry 7386 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_07_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_07_pkey;


--
-- TOC entry 7387 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_08_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_08_pkey;


--
-- TOC entry 7388 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_09_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_09_pkey;


--
-- TOC entry 7389 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_10_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_10_pkey;


--
-- TOC entry 7390 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_11_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_11_pkey;


--
-- TOC entry 7391 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_12_pkey; Type: INDEX ATTACH; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_1_fiscalization".pk_fsc_receipt ATTACH PARTITION "_OLD_1_fiscalization".fsc_receipt_part_2021_12_pkey;


--
-- TOC entry 7418 (class 0 OID 0)
-- Name: fsc_order_default_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_default_pkey;


--
-- TOC entry 7406 (class 0 OID 0)
-- Name: fsc_order_part_2021_01_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_01_pkey;


--
-- TOC entry 7407 (class 0 OID 0)
-- Name: fsc_order_part_2021_02_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_02_pkey;


--
-- TOC entry 7408 (class 0 OID 0)
-- Name: fsc_order_part_2021_03_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_03_pkey;


--
-- TOC entry 7409 (class 0 OID 0)
-- Name: fsc_order_part_2021_04_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_04_pkey;


--
-- TOC entry 7410 (class 0 OID 0)
-- Name: fsc_order_part_2021_05_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_05_pkey;


--
-- TOC entry 7411 (class 0 OID 0)
-- Name: fsc_order_part_2021_06_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_06_pkey;


--
-- TOC entry 7412 (class 0 OID 0)
-- Name: fsc_order_part_2021_07_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_07_pkey;


--
-- TOC entry 7413 (class 0 OID 0)
-- Name: fsc_order_part_2021_08_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_08_pkey;


--
-- TOC entry 7414 (class 0 OID 0)
-- Name: fsc_order_part_2021_09_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_09_pkey;


--
-- TOC entry 7415 (class 0 OID 0)
-- Name: fsc_order_part_2021_10_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_10_pkey;


--
-- TOC entry 7416 (class 0 OID 0)
-- Name: fsc_order_part_2021_11_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_11_pkey;


--
-- TOC entry 7417 (class 0 OID 0)
-- Name: fsc_order_part_2021_12_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_order ATTACH PARTITION "_OLD_4_fiscalization".fsc_order_part_2021_12_pkey;


--
-- TOC entry 7539 (class 0 OID 0)
-- Name: fsc_receipt_default_dt_create_inn_rcp_nmb_key; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".ak1_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_default_dt_create_inn_rcp_nmb_key;


--
-- TOC entry 7540 (class 0 OID 0)
-- Name: fsc_receipt_default_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i8 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_default_id_org_idx;


--
-- TOC entry 7541 (class 0 OID 0)
-- Name: fsc_receipt_default_id_org_rcp_correction_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i10_rep ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_default_id_org_rcp_correction_idx;


--
-- TOC entry 7542 (class 0 OID 0)
-- Name: fsc_receipt_default_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_default_pkey;


--
-- TOC entry 7543 (class 0 OID 0)
-- Name: fsc_receipt_default_rcp_fp_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i4 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_default_rcp_fp_id_org_idx;


--
-- TOC entry 7544 (class 0 OID 0)
-- Name: fsc_receipt_default_rcp_fp_inn_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i3 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_default_rcp_fp_inn_idx;


--
-- TOC entry 7545 (class 0 OID 0)
-- Name: fsc_receipt_default_rcp_fp_rcp_status_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i5 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_default_rcp_fp_rcp_status_id_org_idx;


--
-- TOC entry 7546 (class 0 OID 0)
-- Name: fsc_receipt_default_rcp_fp_rcp_status_id_org_idx1; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i6 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_default_rcp_fp_rcp_status_id_org_idx1;


--
-- TOC entry 7547 (class 0 OID 0)
-- Name: fsc_receipt_default_rcp_notify_send_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i7 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_default_rcp_notify_send_idx;


--
-- TOC entry 7548 (class 0 OID 0)
-- Name: fsc_receipt_default_rcp_status_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i9 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_default_rcp_status_idx;


--
-- TOC entry 7419 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_01_dt_create_inn_rcp_nmb_key; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".ak1_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_01_dt_create_inn_rcp_nmb_key;


--
-- TOC entry 7420 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_01_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i8 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_01_id_org_idx;


--
-- TOC entry 7421 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_01_id_org_rcp_correction_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i10_rep ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_01_id_org_rcp_correction_idx;


--
-- TOC entry 7422 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_01_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_01_pkey;


--
-- TOC entry 7423 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_01_rcp_fp_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i4 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_01_rcp_fp_id_org_idx;


--
-- TOC entry 7424 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_01_rcp_fp_inn_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i3 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_01_rcp_fp_inn_idx;


--
-- TOC entry 7425 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_01_rcp_fp_rcp_status_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i5 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_01_rcp_fp_rcp_status_id_org_idx;


--
-- TOC entry 7426 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_01_rcp_fp_rcp_status_id_org_idx1; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i6 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_01_rcp_fp_rcp_status_id_org_idx1;


--
-- TOC entry 7427 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_01_rcp_notify_send_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i7 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_01_rcp_notify_send_idx;


--
-- TOC entry 7428 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_01_rcp_status_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i9 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_01_rcp_status_idx;


--
-- TOC entry 7429 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_02_dt_create_inn_rcp_nmb_key; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".ak1_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_02_dt_create_inn_rcp_nmb_key;


--
-- TOC entry 7430 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_02_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i8 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_02_id_org_idx;


--
-- TOC entry 7431 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_02_id_org_rcp_correction_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i10_rep ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_02_id_org_rcp_correction_idx;


--
-- TOC entry 7432 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_02_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_02_pkey;


--
-- TOC entry 7433 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_02_rcp_fp_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i4 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_02_rcp_fp_id_org_idx;


--
-- TOC entry 7434 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_02_rcp_fp_inn_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i3 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_02_rcp_fp_inn_idx;


--
-- TOC entry 7435 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_02_rcp_fp_rcp_status_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i5 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_02_rcp_fp_rcp_status_id_org_idx;


--
-- TOC entry 7436 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_02_rcp_fp_rcp_status_id_org_idx1; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i6 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_02_rcp_fp_rcp_status_id_org_idx1;


--
-- TOC entry 7437 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_02_rcp_notify_send_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i7 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_02_rcp_notify_send_idx;


--
-- TOC entry 7438 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_02_rcp_status_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i9 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_02_rcp_status_idx;


--
-- TOC entry 7439 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_03_dt_create_inn_rcp_nmb_key; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".ak1_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_03_dt_create_inn_rcp_nmb_key;


--
-- TOC entry 7440 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_03_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i8 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_03_id_org_idx;


--
-- TOC entry 7441 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_03_id_org_rcp_correction_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i10_rep ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_03_id_org_rcp_correction_idx;


--
-- TOC entry 7442 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_03_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_03_pkey;


--
-- TOC entry 7443 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_03_rcp_fp_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i4 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_03_rcp_fp_id_org_idx;


--
-- TOC entry 7444 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_03_rcp_fp_inn_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i3 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_03_rcp_fp_inn_idx;


--
-- TOC entry 7445 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_03_rcp_fp_rcp_status_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i5 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_03_rcp_fp_rcp_status_id_org_idx;


--
-- TOC entry 7446 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_03_rcp_fp_rcp_status_id_org_idx1; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i6 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_03_rcp_fp_rcp_status_id_org_idx1;


--
-- TOC entry 7447 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_03_rcp_notify_send_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i7 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_03_rcp_notify_send_idx;


--
-- TOC entry 7448 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_03_rcp_status_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i9 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_03_rcp_status_idx;


--
-- TOC entry 7449 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_04_dt_create_inn_rcp_nmb_key; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".ak1_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_04_dt_create_inn_rcp_nmb_key;


--
-- TOC entry 7450 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_04_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i8 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_04_id_org_idx;


--
-- TOC entry 7451 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_04_id_org_rcp_correction_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i10_rep ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_04_id_org_rcp_correction_idx;


--
-- TOC entry 7452 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_04_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_04_pkey;


--
-- TOC entry 7453 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_04_rcp_fp_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i4 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_04_rcp_fp_id_org_idx;


--
-- TOC entry 7454 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_04_rcp_fp_inn_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i3 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_04_rcp_fp_inn_idx;


--
-- TOC entry 7455 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_04_rcp_fp_rcp_status_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i5 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_04_rcp_fp_rcp_status_id_org_idx;


--
-- TOC entry 7456 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_04_rcp_fp_rcp_status_id_org_idx1; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i6 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_04_rcp_fp_rcp_status_id_org_idx1;


--
-- TOC entry 7457 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_04_rcp_notify_send_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i7 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_04_rcp_notify_send_idx;


--
-- TOC entry 7458 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_04_rcp_status_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i9 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_04_rcp_status_idx;


--
-- TOC entry 7459 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_05_dt_create_inn_rcp_nmb_key; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".ak1_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_05_dt_create_inn_rcp_nmb_key;


--
-- TOC entry 7460 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_05_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i8 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_05_id_org_idx;


--
-- TOC entry 7461 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_05_id_org_rcp_correction_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i10_rep ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_05_id_org_rcp_correction_idx;


--
-- TOC entry 7462 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_05_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_05_pkey;


--
-- TOC entry 7463 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_05_rcp_fp_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i4 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_05_rcp_fp_id_org_idx;


--
-- TOC entry 7464 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_05_rcp_fp_inn_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i3 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_05_rcp_fp_inn_idx;


--
-- TOC entry 7465 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_05_rcp_fp_rcp_status_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i5 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_05_rcp_fp_rcp_status_id_org_idx;


--
-- TOC entry 7466 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_05_rcp_fp_rcp_status_id_org_idx1; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i6 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_05_rcp_fp_rcp_status_id_org_idx1;


--
-- TOC entry 7467 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_05_rcp_notify_send_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i7 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_05_rcp_notify_send_idx;


--
-- TOC entry 7468 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_05_rcp_status_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i9 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_05_rcp_status_idx;


--
-- TOC entry 7469 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_06_dt_create_inn_rcp_nmb_key; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".ak1_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_06_dt_create_inn_rcp_nmb_key;


--
-- TOC entry 7470 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_06_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i8 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_06_id_org_idx;


--
-- TOC entry 7471 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_06_id_org_rcp_correction_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i10_rep ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_06_id_org_rcp_correction_idx;


--
-- TOC entry 7472 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_06_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_06_pkey;


--
-- TOC entry 7473 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_06_rcp_fp_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i4 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_06_rcp_fp_id_org_idx;


--
-- TOC entry 7474 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_06_rcp_fp_inn_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i3 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_06_rcp_fp_inn_idx;


--
-- TOC entry 7475 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_06_rcp_fp_rcp_status_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i5 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_06_rcp_fp_rcp_status_id_org_idx;


--
-- TOC entry 7476 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_06_rcp_fp_rcp_status_id_org_idx1; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i6 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_06_rcp_fp_rcp_status_id_org_idx1;


--
-- TOC entry 7477 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_06_rcp_notify_send_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i7 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_06_rcp_notify_send_idx;


--
-- TOC entry 7478 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_06_rcp_status_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i9 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_06_rcp_status_idx;


--
-- TOC entry 7479 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_07_dt_create_inn_rcp_nmb_key; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".ak1_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_07_dt_create_inn_rcp_nmb_key;


--
-- TOC entry 7480 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_07_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i8 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_07_id_org_idx;


--
-- TOC entry 7481 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_07_id_org_rcp_correction_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i10_rep ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_07_id_org_rcp_correction_idx;


--
-- TOC entry 7482 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_07_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_07_pkey;


--
-- TOC entry 7483 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_07_rcp_fp_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i4 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_07_rcp_fp_id_org_idx;


--
-- TOC entry 7484 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_07_rcp_fp_inn_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i3 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_07_rcp_fp_inn_idx;


--
-- TOC entry 7485 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_07_rcp_fp_rcp_status_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i5 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_07_rcp_fp_rcp_status_id_org_idx;


--
-- TOC entry 7486 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_07_rcp_fp_rcp_status_id_org_idx1; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i6 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_07_rcp_fp_rcp_status_id_org_idx1;


--
-- TOC entry 7487 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_07_rcp_notify_send_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i7 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_07_rcp_notify_send_idx;


--
-- TOC entry 7488 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_07_rcp_status_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i9 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_07_rcp_status_idx;


--
-- TOC entry 7489 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_08_dt_create_inn_rcp_nmb_key; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".ak1_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_08_dt_create_inn_rcp_nmb_key;


--
-- TOC entry 7490 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_08_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i8 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_08_id_org_idx;


--
-- TOC entry 7491 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_08_id_org_rcp_correction_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i10_rep ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_08_id_org_rcp_correction_idx;


--
-- TOC entry 7492 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_08_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_08_pkey;


--
-- TOC entry 7493 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_08_rcp_fp_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i4 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_08_rcp_fp_id_org_idx;


--
-- TOC entry 7494 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_08_rcp_fp_inn_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i3 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_08_rcp_fp_inn_idx;


--
-- TOC entry 7495 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_08_rcp_fp_rcp_status_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i5 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_08_rcp_fp_rcp_status_id_org_idx;


--
-- TOC entry 7496 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_08_rcp_fp_rcp_status_id_org_idx1; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i6 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_08_rcp_fp_rcp_status_id_org_idx1;


--
-- TOC entry 7497 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_08_rcp_notify_send_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i7 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_08_rcp_notify_send_idx;


--
-- TOC entry 7498 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_08_rcp_status_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i9 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_08_rcp_status_idx;


--
-- TOC entry 7499 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_09_dt_create_inn_rcp_nmb_key; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".ak1_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_09_dt_create_inn_rcp_nmb_key;


--
-- TOC entry 7500 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_09_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i8 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_09_id_org_idx;


--
-- TOC entry 7501 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_09_id_org_rcp_correction_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i10_rep ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_09_id_org_rcp_correction_idx;


--
-- TOC entry 7502 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_09_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_09_pkey;


--
-- TOC entry 7503 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_09_rcp_fp_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i4 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_09_rcp_fp_id_org_idx;


--
-- TOC entry 7504 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_09_rcp_fp_inn_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i3 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_09_rcp_fp_inn_idx;


--
-- TOC entry 7505 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_09_rcp_fp_rcp_status_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i5 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_09_rcp_fp_rcp_status_id_org_idx;


--
-- TOC entry 7506 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_09_rcp_fp_rcp_status_id_org_idx1; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i6 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_09_rcp_fp_rcp_status_id_org_idx1;


--
-- TOC entry 7507 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_09_rcp_notify_send_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i7 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_09_rcp_notify_send_idx;


--
-- TOC entry 7508 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_09_rcp_status_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i9 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_09_rcp_status_idx;


--
-- TOC entry 7509 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_10_dt_create_inn_rcp_nmb_key; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".ak1_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_10_dt_create_inn_rcp_nmb_key;


--
-- TOC entry 7510 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_10_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i8 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_10_id_org_idx;


--
-- TOC entry 7511 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_10_id_org_rcp_correction_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i10_rep ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_10_id_org_rcp_correction_idx;


--
-- TOC entry 7512 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_10_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_10_pkey;


--
-- TOC entry 7513 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_10_rcp_fp_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i4 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_10_rcp_fp_id_org_idx;


--
-- TOC entry 7514 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_10_rcp_fp_inn_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i3 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_10_rcp_fp_inn_idx;


--
-- TOC entry 7515 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_10_rcp_fp_rcp_status_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i5 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_10_rcp_fp_rcp_status_id_org_idx;


--
-- TOC entry 7516 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_10_rcp_fp_rcp_status_id_org_idx1; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i6 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_10_rcp_fp_rcp_status_id_org_idx1;


--
-- TOC entry 7517 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_10_rcp_notify_send_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i7 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_10_rcp_notify_send_idx;


--
-- TOC entry 7518 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_10_rcp_status_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i9 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_10_rcp_status_idx;


--
-- TOC entry 7519 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_11_dt_create_inn_rcp_nmb_key; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".ak1_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_11_dt_create_inn_rcp_nmb_key;


--
-- TOC entry 7520 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_11_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i8 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_11_id_org_idx;


--
-- TOC entry 7521 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_11_id_org_rcp_correction_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i10_rep ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_11_id_org_rcp_correction_idx;


--
-- TOC entry 7522 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_11_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_11_pkey;


--
-- TOC entry 7523 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_11_rcp_fp_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i4 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_11_rcp_fp_id_org_idx;


--
-- TOC entry 7524 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_11_rcp_fp_inn_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i3 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_11_rcp_fp_inn_idx;


--
-- TOC entry 7525 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_11_rcp_fp_rcp_status_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i5 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_11_rcp_fp_rcp_status_id_org_idx;


--
-- TOC entry 7526 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_11_rcp_fp_rcp_status_id_org_idx1; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i6 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_11_rcp_fp_rcp_status_id_org_idx1;


--
-- TOC entry 7527 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_11_rcp_notify_send_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i7 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_11_rcp_notify_send_idx;


--
-- TOC entry 7528 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_11_rcp_status_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i9 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_11_rcp_status_idx;


--
-- TOC entry 7529 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_12_dt_create_inn_rcp_nmb_key; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".ak1_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_12_dt_create_inn_rcp_nmb_key;


--
-- TOC entry 7530 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_12_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i8 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_12_id_org_idx;


--
-- TOC entry 7531 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_12_id_org_rcp_correction_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i10_rep ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_12_id_org_rcp_correction_idx;


--
-- TOC entry 7532 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_12_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_12_pkey;


--
-- TOC entry 7533 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_12_rcp_fp_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i4 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_12_rcp_fp_id_org_idx;


--
-- TOC entry 7534 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_12_rcp_fp_inn_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i3 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_12_rcp_fp_inn_idx;


--
-- TOC entry 7535 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_12_rcp_fp_rcp_status_id_org_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i5 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_12_rcp_fp_rcp_status_id_org_idx;


--
-- TOC entry 7536 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_12_rcp_fp_rcp_status_id_org_idx1; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i6 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_12_rcp_fp_rcp_status_id_org_idx1;


--
-- TOC entry 7537 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_12_rcp_notify_send_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i7 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_12_rcp_notify_send_idx;


--
-- TOC entry 7538 (class 0 OID 0)
-- Name: fsc_receipt_part_2021_12_rcp_status_idx; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".receipt_i9 ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_part_2021_12_rcp_status_idx;


--
-- TOC entry 7561 (class 0 OID 0)
-- Name: fsc_receipt_result_default_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_default_pkey;


--
-- TOC entry 7549 (class 0 OID 0)
-- Name: fsc_receipt_result_part_2021_01_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_01_pkey;


--
-- TOC entry 7550 (class 0 OID 0)
-- Name: fsc_receipt_result_part_2021_02_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_02_pkey;


--
-- TOC entry 7551 (class 0 OID 0)
-- Name: fsc_receipt_result_part_2021_03_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_03_pkey;


--
-- TOC entry 7552 (class 0 OID 0)
-- Name: fsc_receipt_result_part_2021_04_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_04_pkey;


--
-- TOC entry 7553 (class 0 OID 0)
-- Name: fsc_receipt_result_part_2021_05_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_05_pkey;


--
-- TOC entry 7554 (class 0 OID 0)
-- Name: fsc_receipt_result_part_2021_06_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_06_pkey;


--
-- TOC entry 7555 (class 0 OID 0)
-- Name: fsc_receipt_result_part_2021_07_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_07_pkey;


--
-- TOC entry 7556 (class 0 OID 0)
-- Name: fsc_receipt_result_part_2021_08_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_08_pkey;


--
-- TOC entry 7557 (class 0 OID 0)
-- Name: fsc_receipt_result_part_2021_09_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_09_pkey;


--
-- TOC entry 7558 (class 0 OID 0)
-- Name: fsc_receipt_result_part_2021_10_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_10_pkey;


--
-- TOC entry 7559 (class 0 OID 0)
-- Name: fsc_receipt_result_part_2021_11_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_11_pkey;


--
-- TOC entry 7560 (class 0 OID 0)
-- Name: fsc_receipt_result_part_2021_12_pkey; Type: INDEX ATTACH; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_4_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_4_fiscalization".fsc_receipt_result_part_2021_12_pkey;


--
-- TOC entry 7574 (class 0 OID 0)
-- Name: fsc_order_default_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_default_pkey;


--
-- TOC entry 7562 (class 0 OID 0)
-- Name: fsc_order_part_2021_01_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_01_pkey;


--
-- TOC entry 7563 (class 0 OID 0)
-- Name: fsc_order_part_2021_02_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_02_pkey;


--
-- TOC entry 7564 (class 0 OID 0)
-- Name: fsc_order_part_2021_03_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_03_pkey;


--
-- TOC entry 7565 (class 0 OID 0)
-- Name: fsc_order_part_2021_04_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_04_pkey;


--
-- TOC entry 7566 (class 0 OID 0)
-- Name: fsc_order_part_2021_05_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_05_pkey;


--
-- TOC entry 7567 (class 0 OID 0)
-- Name: fsc_order_part_2021_06_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_06_pkey;


--
-- TOC entry 7568 (class 0 OID 0)
-- Name: fsc_order_part_2021_07_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_07_pkey;


--
-- TOC entry 7569 (class 0 OID 0)
-- Name: fsc_order_part_2021_08_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_08_pkey;


--
-- TOC entry 7570 (class 0 OID 0)
-- Name: fsc_order_part_2021_09_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_09_pkey;


--
-- TOC entry 7571 (class 0 OID 0)
-- Name: fsc_order_part_2021_10_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_10_pkey;


--
-- TOC entry 7572 (class 0 OID 0)
-- Name: fsc_order_part_2021_11_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_11_pkey;


--
-- TOC entry 7573 (class 0 OID 0)
-- Name: fsc_order_part_2021_12_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_order ATTACH PARTITION "_OLD_5_fiscalization".fsc_order_part_2021_12_pkey;


--
-- TOC entry 7587 (class 0 OID 0)
-- Name: fsc_rcp_params_default_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_default_pkey;


--
-- TOC entry 7575 (class 0 OID 0)
-- Name: fsc_rcp_params_part_2021_01_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_01_pkey;


--
-- TOC entry 7576 (class 0 OID 0)
-- Name: fsc_rcp_params_part_2021_02_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_02_pkey;


--
-- TOC entry 7577 (class 0 OID 0)
-- Name: fsc_rcp_params_part_2021_03_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_03_pkey;


--
-- TOC entry 7578 (class 0 OID 0)
-- Name: fsc_rcp_params_part_2021_04_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_04_pkey;


--
-- TOC entry 7579 (class 0 OID 0)
-- Name: fsc_rcp_params_part_2021_05_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_05_pkey;


--
-- TOC entry 7580 (class 0 OID 0)
-- Name: fsc_rcp_params_part_2021_06_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_06_pkey;


--
-- TOC entry 7581 (class 0 OID 0)
-- Name: fsc_rcp_params_part_2021_07_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_07_pkey;


--
-- TOC entry 7582 (class 0 OID 0)
-- Name: fsc_rcp_params_part_2021_08_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_08_pkey;


--
-- TOC entry 7583 (class 0 OID 0)
-- Name: fsc_rcp_params_part_2021_09_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_09_pkey;


--
-- TOC entry 7584 (class 0 OID 0)
-- Name: fsc_rcp_params_part_2021_10_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_10_pkey;


--
-- TOC entry 7585 (class 0 OID 0)
-- Name: fsc_rcp_params_part_2021_11_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_11_pkey;


--
-- TOC entry 7586 (class 0 OID 0)
-- Name: fsc_rcp_params_part_2021_12_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt ATTACH PARTITION "_OLD_5_fiscalization".fsc_rcp_params_part_2021_12_pkey;


--
-- TOC entry 7600 (class 0 OID 0)
-- Name: fsc_result_default_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_default_pkey;


--
-- TOC entry 7588 (class 0 OID 0)
-- Name: fsc_result_part_2021_01_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_01_pkey;


--
-- TOC entry 7589 (class 0 OID 0)
-- Name: fsc_result_part_2021_02_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_02_pkey;


--
-- TOC entry 7590 (class 0 OID 0)
-- Name: fsc_result_part_2021_03_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_03_pkey;


--
-- TOC entry 7591 (class 0 OID 0)
-- Name: fsc_result_part_2021_04_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_04_pkey;


--
-- TOC entry 7592 (class 0 OID 0)
-- Name: fsc_result_part_2021_05_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_05_pkey;


--
-- TOC entry 7593 (class 0 OID 0)
-- Name: fsc_result_part_2021_06_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_06_pkey;


--
-- TOC entry 7594 (class 0 OID 0)
-- Name: fsc_result_part_2021_07_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_07_pkey;


--
-- TOC entry 7595 (class 0 OID 0)
-- Name: fsc_result_part_2021_08_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_08_pkey;


--
-- TOC entry 7596 (class 0 OID 0)
-- Name: fsc_result_part_2021_09_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_09_pkey;


--
-- TOC entry 7597 (class 0 OID 0)
-- Name: fsc_result_part_2021_10_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_10_pkey;


--
-- TOC entry 7598 (class 0 OID 0)
-- Name: fsc_result_part_2021_11_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_11_pkey;


--
-- TOC entry 7599 (class 0 OID 0)
-- Name: fsc_result_part_2021_12_pkey; Type: INDEX ATTACH; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_5_fiscalization".pk_receipt_resul ATTACH PARTITION "_OLD_5_fiscalization".fsc_result_part_2021_12_pkey;


--
-- TOC entry 7601 (class 0 OID 0)
-- Name: fsc_receipt_0_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".pk_receipt ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_0_pkey;


--
-- TOC entry 7602 (class 0 OID 0)
-- Name: fsc_receipt_1_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".pk_receipt ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_1_pkey;


--
-- TOC entry 7606 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_01_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_01_pkey;


--
-- TOC entry 7607 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_02_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_02_pkey;


--
-- TOC entry 7608 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_03_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_03_pkey;


--
-- TOC entry 7609 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_04_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_04_pkey;


--
-- TOC entry 7610 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_05_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_05_pkey;


--
-- TOC entry 7611 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_06_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_06_pkey;


--
-- TOC entry 7612 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_07_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_07_pkey;


--
-- TOC entry 7613 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_08_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_08_pkey;


--
-- TOC entry 7614 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_09_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_09_pkey;


--
-- TOC entry 7615 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_10_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_10_pkey;


--
-- TOC entry 7616 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_11_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_11_pkey;


--
-- TOC entry 7617 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_12_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_2021_12_pkey;


--
-- TOC entry 7605 (class 0 OID 0)
-- Name: fsc_receipt_2_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".pk_receipt ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_2_pkey;


--
-- TOC entry 7603 (class 0 OID 0)
-- Name: fsc_receipt_345_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".pk_receipt ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_345_pkey;


--
-- TOC entry 7604 (class 0 OID 0)
-- Name: fsc_receipt_default_pkey; Type: INDEX ATTACH; Schema: _OLD_6_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_6_fiscalization".pk_receipt ATTACH PARTITION "_OLD_6_fiscalization".fsc_receipt_default_pkey;


--
-- TOC entry 7618 (class 0 OID 0)
-- Name: fsc_receipt_0_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".pk_receipt ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_0_pkey;


--
-- TOC entry 7619 (class 0 OID 0)
-- Name: fsc_receipt_1_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".pk_receipt ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_1_pkey;


--
-- TOC entry 7623 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_01_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_01_pkey;


--
-- TOC entry 7624 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_02_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_02_pkey;


--
-- TOC entry 7625 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_03_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_03_pkey;


--
-- TOC entry 7626 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_04_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_04_pkey;


--
-- TOC entry 7627 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_05_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_05_pkey;


--
-- TOC entry 7628 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_06_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_06_pkey;


--
-- TOC entry 7629 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_07_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_07_pkey;


--
-- TOC entry 7630 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_08_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_08_pkey;


--
-- TOC entry 7631 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_09_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_09_pkey;


--
-- TOC entry 7632 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_10_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_10_pkey;


--
-- TOC entry 7633 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_11_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_11_pkey;


--
-- TOC entry 7634 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_12_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_2021_12_pkey;


--
-- TOC entry 7622 (class 0 OID 0)
-- Name: fsc_receipt_2_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".pk_receipt ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_2_pkey;


--
-- TOC entry 7620 (class 0 OID 0)
-- Name: fsc_receipt_345_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".pk_receipt ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_345_pkey;


--
-- TOC entry 7621 (class 0 OID 0)
-- Name: fsc_receipt_default_pkey; Type: INDEX ATTACH; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".pk_receipt ATTACH PARTITION "_OLD_7_fiscalization".fsc_receipt_default_pkey;


--
-- TOC entry 7636 (class 0 OID 0)
-- Name: fsc_receipt_0_inn_rcp_nmb_idx; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.ie1_receipt ATTACH PARTITION fiscalization.fsc_receipt_0_inn_rcp_nmb_idx;


--
-- TOC entry 7637 (class 0 OID 0)
-- Name: fsc_receipt_0_pkey; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.pk_receipt ATTACH PARTITION fiscalization.fsc_receipt_0_pkey;


--
-- TOC entry 7638 (class 0 OID 0)
-- Name: fsc_receipt_1_inn_rcp_nmb_idx; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.ie1_receipt ATTACH PARTITION fiscalization.fsc_receipt_1_inn_rcp_nmb_idx;


--
-- TOC entry 7639 (class 0 OID 0)
-- Name: fsc_receipt_1_pkey; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.pk_receipt ATTACH PARTITION fiscalization.fsc_receipt_1_pkey;


--
-- TOC entry 7648 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_1_inn_rcp_nmb_idx; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.fsc_receipt_2_inn_rcp_nmb_idx ATTACH PARTITION fiscalization.fsc_receipt_2_2021_1_inn_rcp_nmb_idx;


--
-- TOC entry 7649 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_1_pkey; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.fsc_receipt_2_pkey ATTACH PARTITION fiscalization.fsc_receipt_2_2021_1_pkey;


--
-- TOC entry 7650 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_2_inn_rcp_nmb_idx; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.fsc_receipt_2_inn_rcp_nmb_idx ATTACH PARTITION fiscalization.fsc_receipt_2_2021_2_inn_rcp_nmb_idx;


--
-- TOC entry 7651 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_2_pkey; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.fsc_receipt_2_pkey ATTACH PARTITION fiscalization.fsc_receipt_2_2021_2_pkey;


--
-- TOC entry 7652 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_3_inn_rcp_nmb_idx; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.fsc_receipt_2_inn_rcp_nmb_idx ATTACH PARTITION fiscalization.fsc_receipt_2_2021_3_inn_rcp_nmb_idx;


--
-- TOC entry 7653 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_3_pkey; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.fsc_receipt_2_pkey ATTACH PARTITION fiscalization.fsc_receipt_2_2021_3_pkey;


--
-- TOC entry 7654 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_4_inn_rcp_nmb_idx; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.fsc_receipt_2_inn_rcp_nmb_idx ATTACH PARTITION fiscalization.fsc_receipt_2_2021_4_inn_rcp_nmb_idx;


--
-- TOC entry 7655 (class 0 OID 0)
-- Name: fsc_receipt_2_2021_4_pkey; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.fsc_receipt_2_pkey ATTACH PARTITION fiscalization.fsc_receipt_2_2021_4_pkey;


--
-- TOC entry 7646 (class 0 OID 0)
-- Name: fsc_receipt_2_inn_rcp_nmb_idx; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.ie1_receipt ATTACH PARTITION fiscalization.fsc_receipt_2_inn_rcp_nmb_idx;


--
-- TOC entry 7647 (class 0 OID 0)
-- Name: fsc_receipt_2_pkey; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.pk_receipt ATTACH PARTITION fiscalization.fsc_receipt_2_pkey;


--
-- TOC entry 7640 (class 0 OID 0)
-- Name: fsc_receipt_3_inn_rcp_nmb_idx; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.ie1_receipt ATTACH PARTITION fiscalization.fsc_receipt_3_inn_rcp_nmb_idx;


--
-- TOC entry 7641 (class 0 OID 0)
-- Name: fsc_receipt_3_pkey; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.pk_receipt ATTACH PARTITION fiscalization.fsc_receipt_3_pkey;


--
-- TOC entry 7642 (class 0 OID 0)
-- Name: fsc_receipt_45_inn_rcp_nmb_idx; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.ie1_receipt ATTACH PARTITION fiscalization.fsc_receipt_45_inn_rcp_nmb_idx;


--
-- TOC entry 7643 (class 0 OID 0)
-- Name: fsc_receipt_45_pkey; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.pk_receipt ATTACH PARTITION fiscalization.fsc_receipt_45_pkey;


--
-- TOC entry 7644 (class 0 OID 0)
-- Name: fsc_receipt_default_inn_rcp_nmb_idx; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.ie1_receipt ATTACH PARTITION fiscalization.fsc_receipt_default_inn_rcp_nmb_idx;


--
-- TOC entry 7645 (class 0 OID 0)
-- Name: fsc_receipt_default_pkey; Type: INDEX ATTACH; Schema: fiscalization; Owner: postgres
--

ALTER INDEX fiscalization.pk_receipt ATTACH PARTITION fiscalization.fsc_receipt_default_pkey;


--
-- TOC entry 7635 (class 0 OID 0)
-- Name: fsc_receipt_2_2020_01_half_pkey; Type: INDEX ATTACH; Schema: fiscalization_part; Owner: postgres
--

ALTER INDEX "_OLD_7_fiscalization".fsc_receipt_2_pkey ATTACH PARTITION fiscalization_part.fsc_receipt_2_2020_01_half_pkey;


--
-- TOC entry 7355 (class 0 OID 0)
-- Name: pk_receipt_part_2021_01; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.pk_receipt_part_2021_01;


--
-- TOC entry 7343 (class 0 OID 0)
-- Name: pk_receipt_part_2021_02; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.pk_receipt_part_2021_02;


--
-- TOC entry 7331 (class 0 OID 0)
-- Name: pk_receipt_part_2021_03; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.pk_receipt_part_2021_03;


--
-- TOC entry 7319 (class 0 OID 0)
-- Name: pk_receipt_part_2021_04; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.pk_receipt_part_2021_04;


--
-- TOC entry 7307 (class 0 OID 0)
-- Name: pk_receipt_part_2021_05; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.pk_receipt_part_2021_05;


--
-- TOC entry 7295 (class 0 OID 0)
-- Name: pk_receipt_part_2021_06; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.pk_receipt_part_2021_06;


--
-- TOC entry 7283 (class 0 OID 0)
-- Name: pk_receipt_part_2021_07; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.pk_receipt_part_2021_07;


--
-- TOC entry 7271 (class 0 OID 0)
-- Name: pk_receipt_part_2021_08; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.pk_receipt_part_2021_08;


--
-- TOC entry 7259 (class 0 OID 0)
-- Name: pk_receipt_part_2021_09; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.pk_receipt_part_2021_09;


--
-- TOC entry 7247 (class 0 OID 0)
-- Name: pk_receipt_part_2021_10; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.pk_receipt_part_2021_10;


--
-- TOC entry 7199 (class 0 OID 0)
-- Name: pk_receipt_part_2021_11; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.pk_receipt_part_2021_11;


--
-- TOC entry 7211 (class 0 OID 0)
-- Name: pk_receipt_part_2021_12; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.pk_receipt_part_2021_12;


--
-- TOC entry 7223 (class 0 OID 0)
-- Name: pk_receipt_part_2022_01; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.pk_receipt_part_2022_01;


--
-- TOC entry 7175 (class 0 OID 0)
-- Name: receipt_2018_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_2018_app_id_idx;


--
-- TOC entry 7176 (class 0 OID 0)
-- Name: receipt_2018_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_2018_dt_create_idx;


--
-- TOC entry 7177 (class 0 OID 0)
-- Name: receipt_2018_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_2018_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7178 (class 0 OID 0)
-- Name: receipt_2018_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_2018_fp_inn_idx;


--
-- TOC entry 7179 (class 0 OID 0)
-- Name: receipt_2018_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_2018_fp_org_id_idx;


--
-- TOC entry 7180 (class 0 OID 0)
-- Name: receipt_2018_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_2018_fp_receipt_status_org_id_idx;


--
-- TOC entry 7181 (class 0 OID 0)
-- Name: receipt_2018_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_2018_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7182 (class 0 OID 0)
-- Name: receipt_2018_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_2018_inn_uid_dt_create_idx;


--
-- TOC entry 7183 (class 0 OID 0)
-- Name: receipt_2018_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_2018_notify_send_app_id_idx;


--
-- TOC entry 7184 (class 0 OID 0)
-- Name: receipt_2018_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_2018_org_id_idx;


--
-- TOC entry 7185 (class 0 OID 0)
-- Name: receipt_2018_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_2018_receipt_status_idx;


--
-- TOC entry 7187 (class 0 OID 0)
-- Name: receipt_2019_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_2019_app_id_idx;


--
-- TOC entry 7188 (class 0 OID 0)
-- Name: receipt_2019_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_2019_dt_create_idx;


--
-- TOC entry 7189 (class 0 OID 0)
-- Name: receipt_2019_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_2019_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7190 (class 0 OID 0)
-- Name: receipt_2019_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_2019_fp_inn_idx;


--
-- TOC entry 7191 (class 0 OID 0)
-- Name: receipt_2019_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_2019_fp_org_id_idx;


--
-- TOC entry 7192 (class 0 OID 0)
-- Name: receipt_2019_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_2019_fp_receipt_status_org_id_idx;


--
-- TOC entry 7193 (class 0 OID 0)
-- Name: receipt_2019_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_2019_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7194 (class 0 OID 0)
-- Name: receipt_2019_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_2019_inn_uid_dt_create_idx;


--
-- TOC entry 7195 (class 0 OID 0)
-- Name: receipt_2019_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_2019_notify_send_app_id_idx;


--
-- TOC entry 7196 (class 0 OID 0)
-- Name: receipt_2019_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_2019_org_id_idx;


--
-- TOC entry 7197 (class 0 OID 0)
-- Name: receipt_2019_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_2019_receipt_status_idx;


--
-- TOC entry 7235 (class 0 OID 0)
-- Name: receipt_default_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_default_app_id_idx;


--
-- TOC entry 7236 (class 0 OID 0)
-- Name: receipt_default_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_default_dt_create_idx;


--
-- TOC entry 7237 (class 0 OID 0)
-- Name: receipt_default_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_default_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7238 (class 0 OID 0)
-- Name: receipt_default_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_default_fp_inn_idx;


--
-- TOC entry 7239 (class 0 OID 0)
-- Name: receipt_default_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_default_fp_org_id_idx;


--
-- TOC entry 7240 (class 0 OID 0)
-- Name: receipt_default_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_default_fp_receipt_status_org_id_idx;


--
-- TOC entry 7241 (class 0 OID 0)
-- Name: receipt_default_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_default_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7242 (class 0 OID 0)
-- Name: receipt_default_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_default_inn_uid_dt_create_idx;


--
-- TOC entry 7243 (class 0 OID 0)
-- Name: receipt_default_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_default_notify_send_app_id_idx;


--
-- TOC entry 7244 (class 0 OID 0)
-- Name: receipt_default_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_default_org_id_idx;


--
-- TOC entry 7245 (class 0 OID 0)
-- Name: receipt_default_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.receipt_default_pkey;


--
-- TOC entry 7246 (class 0 OID 0)
-- Name: receipt_default_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_default_receipt_status_idx;


--
-- TOC entry 7356 (class 0 OID 0)
-- Name: receipt_part_2021_01_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_part_2021_01_app_id_idx;


--
-- TOC entry 7357 (class 0 OID 0)
-- Name: receipt_part_2021_01_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_part_2021_01_dt_create_idx;


--
-- TOC entry 7358 (class 0 OID 0)
-- Name: receipt_part_2021_01_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_part_2021_01_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7359 (class 0 OID 0)
-- Name: receipt_part_2021_01_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_part_2021_01_fp_inn_idx;


--
-- TOC entry 7360 (class 0 OID 0)
-- Name: receipt_part_2021_01_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_part_2021_01_fp_org_id_idx;


--
-- TOC entry 7361 (class 0 OID 0)
-- Name: receipt_part_2021_01_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_part_2021_01_fp_receipt_status_org_id_idx;


--
-- TOC entry 7362 (class 0 OID 0)
-- Name: receipt_part_2021_01_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_part_2021_01_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7363 (class 0 OID 0)
-- Name: receipt_part_2021_01_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_part_2021_01_inn_uid_dt_create_idx;


--
-- TOC entry 7364 (class 0 OID 0)
-- Name: receipt_part_2021_01_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_part_2021_01_notify_send_app_id_idx;


--
-- TOC entry 7365 (class 0 OID 0)
-- Name: receipt_part_2021_01_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_part_2021_01_org_id_idx;


--
-- TOC entry 7366 (class 0 OID 0)
-- Name: receipt_part_2021_01_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_part_2021_01_receipt_status_idx;


--
-- TOC entry 7344 (class 0 OID 0)
-- Name: receipt_part_2021_02_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_part_2021_02_app_id_idx;


--
-- TOC entry 7345 (class 0 OID 0)
-- Name: receipt_part_2021_02_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_part_2021_02_dt_create_idx;


--
-- TOC entry 7346 (class 0 OID 0)
-- Name: receipt_part_2021_02_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_part_2021_02_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7347 (class 0 OID 0)
-- Name: receipt_part_2021_02_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_part_2021_02_fp_inn_idx;


--
-- TOC entry 7348 (class 0 OID 0)
-- Name: receipt_part_2021_02_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_part_2021_02_fp_org_id_idx;


--
-- TOC entry 7349 (class 0 OID 0)
-- Name: receipt_part_2021_02_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_part_2021_02_fp_receipt_status_org_id_idx;


--
-- TOC entry 7350 (class 0 OID 0)
-- Name: receipt_part_2021_02_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_part_2021_02_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7351 (class 0 OID 0)
-- Name: receipt_part_2021_02_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_part_2021_02_inn_uid_dt_create_idx;


--
-- TOC entry 7352 (class 0 OID 0)
-- Name: receipt_part_2021_02_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_part_2021_02_notify_send_app_id_idx;


--
-- TOC entry 7353 (class 0 OID 0)
-- Name: receipt_part_2021_02_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_part_2021_02_org_id_idx;


--
-- TOC entry 7354 (class 0 OID 0)
-- Name: receipt_part_2021_02_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_part_2021_02_receipt_status_idx;


--
-- TOC entry 7332 (class 0 OID 0)
-- Name: receipt_part_2021_03_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_part_2021_03_app_id_idx;


--
-- TOC entry 7333 (class 0 OID 0)
-- Name: receipt_part_2021_03_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_part_2021_03_dt_create_idx;


--
-- TOC entry 7334 (class 0 OID 0)
-- Name: receipt_part_2021_03_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_part_2021_03_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7335 (class 0 OID 0)
-- Name: receipt_part_2021_03_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_part_2021_03_fp_inn_idx;


--
-- TOC entry 7336 (class 0 OID 0)
-- Name: receipt_part_2021_03_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_part_2021_03_fp_org_id_idx;


--
-- TOC entry 7337 (class 0 OID 0)
-- Name: receipt_part_2021_03_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_part_2021_03_fp_receipt_status_org_id_idx;


--
-- TOC entry 7338 (class 0 OID 0)
-- Name: receipt_part_2021_03_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_part_2021_03_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7339 (class 0 OID 0)
-- Name: receipt_part_2021_03_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_part_2021_03_inn_uid_dt_create_idx;


--
-- TOC entry 7340 (class 0 OID 0)
-- Name: receipt_part_2021_03_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_part_2021_03_notify_send_app_id_idx;


--
-- TOC entry 7341 (class 0 OID 0)
-- Name: receipt_part_2021_03_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_part_2021_03_org_id_idx;


--
-- TOC entry 7342 (class 0 OID 0)
-- Name: receipt_part_2021_03_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_part_2021_03_receipt_status_idx;


--
-- TOC entry 7320 (class 0 OID 0)
-- Name: receipt_part_2021_04_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_part_2021_04_app_id_idx;


--
-- TOC entry 7321 (class 0 OID 0)
-- Name: receipt_part_2021_04_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_part_2021_04_dt_create_idx;


--
-- TOC entry 7322 (class 0 OID 0)
-- Name: receipt_part_2021_04_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_part_2021_04_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7323 (class 0 OID 0)
-- Name: receipt_part_2021_04_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_part_2021_04_fp_inn_idx;


--
-- TOC entry 7324 (class 0 OID 0)
-- Name: receipt_part_2021_04_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_part_2021_04_fp_org_id_idx;


--
-- TOC entry 7325 (class 0 OID 0)
-- Name: receipt_part_2021_04_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_part_2021_04_fp_receipt_status_org_id_idx;


--
-- TOC entry 7326 (class 0 OID 0)
-- Name: receipt_part_2021_04_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_part_2021_04_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7327 (class 0 OID 0)
-- Name: receipt_part_2021_04_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_part_2021_04_inn_uid_dt_create_idx;


--
-- TOC entry 7328 (class 0 OID 0)
-- Name: receipt_part_2021_04_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_part_2021_04_notify_send_app_id_idx;


--
-- TOC entry 7329 (class 0 OID 0)
-- Name: receipt_part_2021_04_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_part_2021_04_org_id_idx;


--
-- TOC entry 7330 (class 0 OID 0)
-- Name: receipt_part_2021_04_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_part_2021_04_receipt_status_idx;


--
-- TOC entry 7308 (class 0 OID 0)
-- Name: receipt_part_2021_05_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_part_2021_05_app_id_idx;


--
-- TOC entry 7309 (class 0 OID 0)
-- Name: receipt_part_2021_05_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_part_2021_05_dt_create_idx;


--
-- TOC entry 7310 (class 0 OID 0)
-- Name: receipt_part_2021_05_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_part_2021_05_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7311 (class 0 OID 0)
-- Name: receipt_part_2021_05_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_part_2021_05_fp_inn_idx;


--
-- TOC entry 7312 (class 0 OID 0)
-- Name: receipt_part_2021_05_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_part_2021_05_fp_org_id_idx;


--
-- TOC entry 7313 (class 0 OID 0)
-- Name: receipt_part_2021_05_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_part_2021_05_fp_receipt_status_org_id_idx;


--
-- TOC entry 7314 (class 0 OID 0)
-- Name: receipt_part_2021_05_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_part_2021_05_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7315 (class 0 OID 0)
-- Name: receipt_part_2021_05_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_part_2021_05_inn_uid_dt_create_idx;


--
-- TOC entry 7316 (class 0 OID 0)
-- Name: receipt_part_2021_05_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_part_2021_05_notify_send_app_id_idx;


--
-- TOC entry 7317 (class 0 OID 0)
-- Name: receipt_part_2021_05_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_part_2021_05_org_id_idx;


--
-- TOC entry 7318 (class 0 OID 0)
-- Name: receipt_part_2021_05_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_part_2021_05_receipt_status_idx;


--
-- TOC entry 7296 (class 0 OID 0)
-- Name: receipt_part_2021_06_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_part_2021_06_app_id_idx;


--
-- TOC entry 7297 (class 0 OID 0)
-- Name: receipt_part_2021_06_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_part_2021_06_dt_create_idx;


--
-- TOC entry 7298 (class 0 OID 0)
-- Name: receipt_part_2021_06_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_part_2021_06_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7299 (class 0 OID 0)
-- Name: receipt_part_2021_06_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_part_2021_06_fp_inn_idx;


--
-- TOC entry 7300 (class 0 OID 0)
-- Name: receipt_part_2021_06_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_part_2021_06_fp_org_id_idx;


--
-- TOC entry 7301 (class 0 OID 0)
-- Name: receipt_part_2021_06_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_part_2021_06_fp_receipt_status_org_id_idx;


--
-- TOC entry 7302 (class 0 OID 0)
-- Name: receipt_part_2021_06_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_part_2021_06_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7303 (class 0 OID 0)
-- Name: receipt_part_2021_06_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_part_2021_06_inn_uid_dt_create_idx;


--
-- TOC entry 7304 (class 0 OID 0)
-- Name: receipt_part_2021_06_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_part_2021_06_notify_send_app_id_idx;


--
-- TOC entry 7305 (class 0 OID 0)
-- Name: receipt_part_2021_06_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_part_2021_06_org_id_idx;


--
-- TOC entry 7306 (class 0 OID 0)
-- Name: receipt_part_2021_06_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_part_2021_06_receipt_status_idx;


--
-- TOC entry 7284 (class 0 OID 0)
-- Name: receipt_part_2021_07_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_part_2021_07_app_id_idx;


--
-- TOC entry 7285 (class 0 OID 0)
-- Name: receipt_part_2021_07_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_part_2021_07_dt_create_idx;


--
-- TOC entry 7286 (class 0 OID 0)
-- Name: receipt_part_2021_07_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_part_2021_07_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7287 (class 0 OID 0)
-- Name: receipt_part_2021_07_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_part_2021_07_fp_inn_idx;


--
-- TOC entry 7288 (class 0 OID 0)
-- Name: receipt_part_2021_07_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_part_2021_07_fp_org_id_idx;


--
-- TOC entry 7289 (class 0 OID 0)
-- Name: receipt_part_2021_07_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_part_2021_07_fp_receipt_status_org_id_idx;


--
-- TOC entry 7290 (class 0 OID 0)
-- Name: receipt_part_2021_07_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_part_2021_07_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7291 (class 0 OID 0)
-- Name: receipt_part_2021_07_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_part_2021_07_inn_uid_dt_create_idx;


--
-- TOC entry 7292 (class 0 OID 0)
-- Name: receipt_part_2021_07_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_part_2021_07_notify_send_app_id_idx;


--
-- TOC entry 7293 (class 0 OID 0)
-- Name: receipt_part_2021_07_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_part_2021_07_org_id_idx;


--
-- TOC entry 7294 (class 0 OID 0)
-- Name: receipt_part_2021_07_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_part_2021_07_receipt_status_idx;


--
-- TOC entry 7272 (class 0 OID 0)
-- Name: receipt_part_2021_08_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_part_2021_08_app_id_idx;


--
-- TOC entry 7273 (class 0 OID 0)
-- Name: receipt_part_2021_08_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_part_2021_08_dt_create_idx;


--
-- TOC entry 7274 (class 0 OID 0)
-- Name: receipt_part_2021_08_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_part_2021_08_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7275 (class 0 OID 0)
-- Name: receipt_part_2021_08_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_part_2021_08_fp_inn_idx;


--
-- TOC entry 7276 (class 0 OID 0)
-- Name: receipt_part_2021_08_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_part_2021_08_fp_org_id_idx;


--
-- TOC entry 7277 (class 0 OID 0)
-- Name: receipt_part_2021_08_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_part_2021_08_fp_receipt_status_org_id_idx;


--
-- TOC entry 7278 (class 0 OID 0)
-- Name: receipt_part_2021_08_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_part_2021_08_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7279 (class 0 OID 0)
-- Name: receipt_part_2021_08_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_part_2021_08_inn_uid_dt_create_idx;


--
-- TOC entry 7280 (class 0 OID 0)
-- Name: receipt_part_2021_08_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_part_2021_08_notify_send_app_id_idx;


--
-- TOC entry 7281 (class 0 OID 0)
-- Name: receipt_part_2021_08_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_part_2021_08_org_id_idx;


--
-- TOC entry 7282 (class 0 OID 0)
-- Name: receipt_part_2021_08_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_part_2021_08_receipt_status_idx;


--
-- TOC entry 7260 (class 0 OID 0)
-- Name: receipt_part_2021_09_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_part_2021_09_app_id_idx;


--
-- TOC entry 7261 (class 0 OID 0)
-- Name: receipt_part_2021_09_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_part_2021_09_dt_create_idx;


--
-- TOC entry 7262 (class 0 OID 0)
-- Name: receipt_part_2021_09_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_part_2021_09_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7263 (class 0 OID 0)
-- Name: receipt_part_2021_09_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_part_2021_09_fp_inn_idx;


--
-- TOC entry 7264 (class 0 OID 0)
-- Name: receipt_part_2021_09_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_part_2021_09_fp_org_id_idx;


--
-- TOC entry 7265 (class 0 OID 0)
-- Name: receipt_part_2021_09_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_part_2021_09_fp_receipt_status_org_id_idx;


--
-- TOC entry 7266 (class 0 OID 0)
-- Name: receipt_part_2021_09_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_part_2021_09_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7267 (class 0 OID 0)
-- Name: receipt_part_2021_09_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_part_2021_09_inn_uid_dt_create_idx;


--
-- TOC entry 7268 (class 0 OID 0)
-- Name: receipt_part_2021_09_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_part_2021_09_notify_send_app_id_idx;


--
-- TOC entry 7269 (class 0 OID 0)
-- Name: receipt_part_2021_09_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_part_2021_09_org_id_idx;


--
-- TOC entry 7270 (class 0 OID 0)
-- Name: receipt_part_2021_09_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_part_2021_09_receipt_status_idx;


--
-- TOC entry 7248 (class 0 OID 0)
-- Name: receipt_part_2021_10_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_part_2021_10_app_id_idx;


--
-- TOC entry 7249 (class 0 OID 0)
-- Name: receipt_part_2021_10_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_part_2021_10_dt_create_idx;


--
-- TOC entry 7250 (class 0 OID 0)
-- Name: receipt_part_2021_10_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_part_2021_10_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7251 (class 0 OID 0)
-- Name: receipt_part_2021_10_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_part_2021_10_fp_inn_idx;


--
-- TOC entry 7252 (class 0 OID 0)
-- Name: receipt_part_2021_10_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_part_2021_10_fp_org_id_idx;


--
-- TOC entry 7253 (class 0 OID 0)
-- Name: receipt_part_2021_10_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_part_2021_10_fp_receipt_status_org_id_idx;


--
-- TOC entry 7254 (class 0 OID 0)
-- Name: receipt_part_2021_10_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_part_2021_10_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7255 (class 0 OID 0)
-- Name: receipt_part_2021_10_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_part_2021_10_inn_uid_dt_create_idx;


--
-- TOC entry 7256 (class 0 OID 0)
-- Name: receipt_part_2021_10_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_part_2021_10_notify_send_app_id_idx;


--
-- TOC entry 7257 (class 0 OID 0)
-- Name: receipt_part_2021_10_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_part_2021_10_org_id_idx;


--
-- TOC entry 7258 (class 0 OID 0)
-- Name: receipt_part_2021_10_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_part_2021_10_receipt_status_idx;


--
-- TOC entry 7200 (class 0 OID 0)
-- Name: receipt_part_2021_11_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_part_2021_11_app_id_idx;


--
-- TOC entry 7201 (class 0 OID 0)
-- Name: receipt_part_2021_11_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_part_2021_11_dt_create_idx;


--
-- TOC entry 7202 (class 0 OID 0)
-- Name: receipt_part_2021_11_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_part_2021_11_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7203 (class 0 OID 0)
-- Name: receipt_part_2021_11_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_part_2021_11_fp_inn_idx;


--
-- TOC entry 7204 (class 0 OID 0)
-- Name: receipt_part_2021_11_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_part_2021_11_fp_org_id_idx;


--
-- TOC entry 7205 (class 0 OID 0)
-- Name: receipt_part_2021_11_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_part_2021_11_fp_receipt_status_org_id_idx;


--
-- TOC entry 7206 (class 0 OID 0)
-- Name: receipt_part_2021_11_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_part_2021_11_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7207 (class 0 OID 0)
-- Name: receipt_part_2021_11_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_part_2021_11_inn_uid_dt_create_idx;


--
-- TOC entry 7208 (class 0 OID 0)
-- Name: receipt_part_2021_11_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_part_2021_11_notify_send_app_id_idx;


--
-- TOC entry 7209 (class 0 OID 0)
-- Name: receipt_part_2021_11_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_part_2021_11_org_id_idx;


--
-- TOC entry 7210 (class 0 OID 0)
-- Name: receipt_part_2021_11_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_part_2021_11_receipt_status_idx;


--
-- TOC entry 7212 (class 0 OID 0)
-- Name: receipt_part_2021_12_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_part_2021_12_app_id_idx;


--
-- TOC entry 7213 (class 0 OID 0)
-- Name: receipt_part_2021_12_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_part_2021_12_dt_create_idx;


--
-- TOC entry 7214 (class 0 OID 0)
-- Name: receipt_part_2021_12_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_part_2021_12_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7215 (class 0 OID 0)
-- Name: receipt_part_2021_12_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_part_2021_12_fp_inn_idx;


--
-- TOC entry 7216 (class 0 OID 0)
-- Name: receipt_part_2021_12_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_part_2021_12_fp_org_id_idx;


--
-- TOC entry 7217 (class 0 OID 0)
-- Name: receipt_part_2021_12_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_part_2021_12_fp_receipt_status_org_id_idx;


--
-- TOC entry 7218 (class 0 OID 0)
-- Name: receipt_part_2021_12_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_part_2021_12_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7219 (class 0 OID 0)
-- Name: receipt_part_2021_12_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_part_2021_12_inn_uid_dt_create_idx;


--
-- TOC entry 7220 (class 0 OID 0)
-- Name: receipt_part_2021_12_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_part_2021_12_notify_send_app_id_idx;


--
-- TOC entry 7221 (class 0 OID 0)
-- Name: receipt_part_2021_12_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_part_2021_12_org_id_idx;


--
-- TOC entry 7222 (class 0 OID 0)
-- Name: receipt_part_2021_12_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_part_2021_12_receipt_status_idx;


--
-- TOC entry 7224 (class 0 OID 0)
-- Name: receipt_part_2022_01_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_app_id_idx ATTACH PARTITION public.receipt_part_2022_01_app_id_idx;


--
-- TOC entry 7225 (class 0 OID 0)
-- Name: receipt_part_2022_01_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_dt_create_idx ATTACH PARTITION public.receipt_part_2022_01_dt_create_idx;


--
-- TOC entry 7226 (class 0 OID 0)
-- Name: receipt_part_2022_01_dt_create_org_id_app_id_correction_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.report_full_idx ATTACH PARTITION public.receipt_part_2022_01_dt_create_org_id_app_id_correction_idx;


--
-- TOC entry 7227 (class 0 OID 0)
-- Name: receipt_part_2022_01_fp_inn_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_inn_idx ATTACH PARTITION public.receipt_part_2022_01_fp_inn_idx;


--
-- TOC entry 7228 (class 0 OID 0)
-- Name: receipt_part_2022_01_fp_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_isnull_idx ATTACH PARTITION public.receipt_part_2022_01_fp_org_id_idx;


--
-- TOC entry 7229 (class 0 OID 0)
-- Name: receipt_part_2022_01_fp_receipt_status_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_0_3_idx ATTACH PARTITION public.receipt_part_2022_01_fp_receipt_status_org_id_idx;


--
-- TOC entry 7230 (class 0 OID 0)
-- Name: receipt_part_2022_01_fp_receipt_status_org_id_idx1; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_fp_null_1_idx ATTACH PARTITION public.receipt_part_2022_01_fp_receipt_status_org_id_idx1;


--
-- TOC entry 7231 (class 0 OID 0)
-- Name: receipt_part_2022_01_inn_uid_dt_create_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.uniq_receipt ATTACH PARTITION public.receipt_part_2022_01_inn_uid_dt_create_idx;


--
-- TOC entry 7232 (class 0 OID 0)
-- Name: receipt_part_2022_01_notify_send_app_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_notify_idx ATTACH PARTITION public.receipt_part_2022_01_notify_send_app_id_idx;


--
-- TOC entry 7233 (class 0 OID 0)
-- Name: receipt_part_2022_01_org_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_org_id_idx ATTACH PARTITION public.receipt_part_2022_01_org_id_idx;


--
-- TOC entry 7234 (class 0 OID 0)
-- Name: receipt_part_2022_01_receipt_status_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_receipt_status_idx ATTACH PARTITION public.receipt_part_2022_01_receipt_status_idx;


--
-- TOC entry 7186 (class 0 OID 0)
-- Name: receipt_pkey_2018; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.receipt_pkey_2018;


--
-- TOC entry 7198 (class 0 OID 0)
-- Name: receipt_pkey_2019; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.receipt_pkey ATTACH PARTITION public.receipt_pkey_2019;


--
-- TOC entry 7674 (class 2606 OID 1510522)
-- Name: fsc_org_app fk_app_provedes_org_app; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_org_app
    ADD CONSTRAINT fk_app_provedes_org_app FOREIGN KEY (id_app) REFERENCES "_OLD_1_fiscalization".fsc_app(id_app);


--
-- TOC entry 7666 (class 2606 OID 1510517)
-- Name: fsc_app_kkt_group fk_app_uses_app_kkt_group; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_app_kkt_group
    ADD CONSTRAINT fk_app_uses_app_kkt_group FOREIGN KEY (id_app) REFERENCES "_OLD_1_fiscalization".fsc_app(id_app);


--
-- TOC entry 7670 (class 2606 OID 1510388)
-- Name: fsc_kkt fk_fiscal_provider_provides_kkt; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_kkt
    ADD CONSTRAINT fk_fiscal_provider_provides_kkt FOREIGN KEY (id_fsc_provider) REFERENCES "_OLD_1_fiscalization".fsc_provider(id_fsc_provider);


--
-- TOC entry 7672 (class 2606 OID 1510398)
-- Name: fsc_kkt_groupe fk_fsc_provider_creates_group_kkt; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_kkt_groupe
    ADD CONSTRAINT fk_fsc_provider_creates_group_kkt FOREIGN KEY (id_fsc_provider) REFERENCES "_OLD_1_fiscalization".fsc_provider(id_fsc_provider);


--
-- TOC entry 7679 (class 2606 OID 1510483)
-- Name: fsk_route fk_fsc_provider_provides_router; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsk_route
    ADD CONSTRAINT fk_fsc_provider_provides_router FOREIGN KEY (id_fsc_provider) REFERENCES "_OLD_1_fiscalization".fsc_provider(id_fsc_provider);


--
-- TOC entry 7677 (class 2606 OID 1510468)
-- Name: fsc_task fk_kkt_belongs_task; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_task
    ADD CONSTRAINT fk_kkt_belongs_task FOREIGN KEY (id_kkt) REFERENCES "_OLD_1_fiscalization".fsc_kkt(id_kkt);


--
-- TOC entry 7671 (class 2606 OID 1510393)
-- Name: fsc_kkt fk_kkt_group_icludes_one_kkt; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_kkt
    ADD CONSTRAINT fk_kkt_group_icludes_one_kkt FOREIGN KEY (id_kkt_group) REFERENCES "_OLD_1_fiscalization".fsc_kkt_groupe(id_kkt_group);


--
-- TOC entry 7667 (class 2606 OID 1510373)
-- Name: fsc_app_kkt_group fk_kkt_group_uses_app_group; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_app_kkt_group
    ADD CONSTRAINT fk_kkt_group_uses_app_group FOREIGN KEY (id_kkt_group) REFERENCES "_OLD_1_fiscalization".fsc_kkt_groupe(id_kkt_group);


--
-- TOC entry 7676 (class 2606 OID 1510463)
-- Name: fsc_storage fk_kkt_has_one_fiscal_storage; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_storage
    ADD CONSTRAINT fk_kkt_has_one_fiscal_storage FOREIGN KEY (id_kkt) REFERENCES "_OLD_1_fiscalization".fsc_kkt(id_kkt);


--
-- TOC entry 7685 (class 2606 OID 1512301)
-- Name: fsc_receipt fk_kkt_sends_receipt; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE "_OLD_1_fiscalization".fsc_receipt
    ADD CONSTRAINT fk_kkt_sends_receipt FOREIGN KEY (id_kkt) REFERENCES "_OLD_1_fiscalization".fsc_kkt(id_kkt);


--
-- TOC entry 7680 (class 2606 OID 1510560)
-- Name: fsk_route fk_org_connets_route; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsk_route
    ADD CONSTRAINT fk_org_connets_route FOREIGN KEY (id_org) REFERENCES "_OLD_1_fiscalization".fsc_org(id_org);


--
-- TOC entry 7673 (class 2606 OID 1510535)
-- Name: fsc_kkt_groupe fk_org_has_kkt_group; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_kkt_groupe
    ADD CONSTRAINT fk_org_has_kkt_group FOREIGN KEY (id_org) REFERENCES "_OLD_1_fiscalization".fsc_org(id_org);


--
-- TOC entry 7686 (class 2606 OID 1512304)
-- Name: fsc_receipt fk_org_owns_receipt; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE "_OLD_1_fiscalization".fsc_receipt
    ADD CONSTRAINT fk_org_owns_receipt FOREIGN KEY (id_org) REFERENCES "_OLD_1_fiscalization".fsc_org(id_org);


--
-- TOC entry 7675 (class 2606 OID 1510540)
-- Name: fsc_org_app fk_org_uses_app_org; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_org_app
    ADD CONSTRAINT fk_org_uses_app_org FOREIGN KEY (id_org) REFERENCES "_OLD_1_fiscalization".fsc_org(id_org);


--
-- TOC entry 7682 (class 2606 OID 1512127)
-- Name: fsc_service fk_organisation_submits_service; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_service
    ADD CONSTRAINT fk_organisation_submits_service FOREIGN KEY (id_org) REFERENCES "_OLD_1_fiscalization".fsc_org(id_org);


--
-- TOC entry 7687 (class 2606 OID 1513944)
-- Name: fsc_receipt_js fk_receipt_js_belongs_receipt; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE "_OLD_1_fiscalization".fsc_receipt_js
    ADD CONSTRAINT fk_receipt_js_belongs_receipt FOREIGN KEY (id_receipt, dt_create) REFERENCES "_OLD_1_fiscalization".fsc_receipt(id_receipt, dt_create) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7669 (class 2606 OID 1510383)
-- Name: fsc_filter fk_tasks_has_filter; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_filter
    ADD CONSTRAINT fk_tasks_has_filter FOREIGN KEY (id_task) REFERENCES "_OLD_1_fiscalization".fsc_task(id_task);


--
-- TOC entry 7678 (class 2606 OID 1510593)
-- Name: fsc_task fk_user_creates_task; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_task
    ADD CONSTRAINT fk_user_creates_task FOREIGN KEY (id_user) REFERENCES "_OLD_1_fiscalization".fsc_user(id_user);


--
-- TOC entry 7688 (class 2606 OID 1607930)
-- Name: fsc_report fk_user_forms_report; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_report
    ADD CONSTRAINT fk_user_forms_report FOREIGN KEY (id_user) REFERENCES "_OLD_1_fiscalization".fsc_user(id_user);


--
-- TOC entry 7668 (class 2606 OID 1510573)
-- Name: fsc_appeal fk_user_makes_appeal; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_appeal
    ADD CONSTRAINT fk_user_makes_appeal FOREIGN KEY (id_user) REFERENCES "_OLD_1_fiscalization".fsc_user(id_user);


--
-- TOC entry 7681 (class 2606 OID 1510839)
-- Name: fsc_payment fk_user_makes_payment; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE "_OLD_1_fiscalization".fsc_payment
    ADD CONSTRAINT fk_user_makes_payment FOREIGN KEY (id_user) REFERENCES "_OLD_1_fiscalization".fsc_user(id_user);


--
-- TOC entry 7683 (class 2606 OID 1512132)
-- Name: fsc_service fk_user_receivs_services; Type: FK CONSTRAINT; Schema: _OLD_1_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_1_fiscalization".fsc_service
    ADD CONSTRAINT fk_user_receivs_services FOREIGN KEY (id_user) REFERENCES "_OLD_1_fiscalization".fsc_user(id_user);


--
-- TOC entry 7695 (class 2606 OID 1612386)
-- Name: fsc_org_app fk_app_rovedes_org_app; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_org_app
    ADD CONSTRAINT fk_app_rovedes_org_app FOREIGN KEY (id_app) REFERENCES "_OLD_4_fiscalization".fsc_app(id_app) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7689 (class 2606 OID 1612282)
-- Name: fsc_app_fsc_provider fk_app_uses_app_kkt_group; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_app_fsc_provider
    ADD CONSTRAINT fk_app_uses_app_kkt_group FOREIGN KEY (id_app) REFERENCES "_OLD_4_fiscalization".fsc_app(id_app) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7693 (class 2606 OID 1612302)
-- Name: fsc_kkt_group fk_fsc_provider_creates_group_kkt; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_kkt_group
    ADD CONSTRAINT fk_fsc_provider_creates_group_kkt FOREIGN KEY (id_fsc_provider) REFERENCES "_OLD_4_fiscalization".fsc_provider(id_fsc_provider) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7690 (class 2606 OID 1612287)
-- Name: fsc_app_fsc_provider fk_fsc_provider_uses_app_group; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_app_fsc_provider
    ADD CONSTRAINT fk_fsc_provider_uses_app_group FOREIGN KEY (id_fsc_provider) REFERENCES "_OLD_4_fiscalization".fsc_provider(id_fsc_provider) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7699 (class 2606 OID 1612480)
-- Name: fsc_receipt_result fk_fsc_receipt_gets_result; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE "_OLD_4_fiscalization".fsc_receipt_result
    ADD CONSTRAINT fk_fsc_receipt_gets_result FOREIGN KEY (id_receipt, dt_create) REFERENCES "_OLD_4_fiscalization".fsc_receipt(id_receipt, dt_create) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7694 (class 2606 OID 1612307)
-- Name: fsc_order fk_fsc_receipt_sends_fsc_order; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE "_OLD_4_fiscalization".fsc_order
    ADD CONSTRAINT fk_fsc_receipt_sends_fsc_order FOREIGN KEY (id_receipt, dt_create) REFERENCES "_OLD_4_fiscalization".fsc_receipt(id_receipt, dt_create) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7701 (class 2606 OID 1612564)
-- Name: fsc_task fk_kkt_belongs_task; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_task
    ADD CONSTRAINT fk_kkt_belongs_task FOREIGN KEY (id_kkt) REFERENCES "_OLD_4_fiscalization".fsc_kkt(id_kkt) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7692 (class 2606 OID 1612297)
-- Name: fsc_kkt fk_kkt_group_icludes_one_kkt; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_kkt
    ADD CONSTRAINT fk_kkt_group_icludes_one_kkt FOREIGN KEY (id_kkt_group) REFERENCES "_OLD_4_fiscalization".fsc_kkt_group(id_kkt_group) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7700 (class 2606 OID 1612559)
-- Name: fsc_storage fk_kkt_has_one_fiscal_storage; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_storage
    ADD CONSTRAINT fk_kkt_has_one_fiscal_storage FOREIGN KEY (id_kkt) REFERENCES "_OLD_4_fiscalization".fsc_kkt(id_kkt) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7697 (class 2606 OID 1612396)
-- Name: fsc_receipt fk_kkt_sends_receipt; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE "_OLD_4_fiscalization".fsc_receipt
    ADD CONSTRAINT fk_kkt_sends_receipt FOREIGN KEY (id_kkt) REFERENCES "_OLD_4_fiscalization".fsc_kkt(id_kkt) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7703 (class 2606 OID 1612574)
-- Name: fsc_user fk_org_has_contract; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_user
    ADD CONSTRAINT fk_org_has_contract FOREIGN KEY (id_org) REFERENCES "_OLD_4_fiscalization".fsc_org(id_org) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7698 (class 2606 OID 1612438)
-- Name: fsc_receipt fk_org_owns_receipt; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE "_OLD_4_fiscalization".fsc_receipt
    ADD CONSTRAINT fk_org_owns_receipt FOREIGN KEY (id_org) REFERENCES "_OLD_4_fiscalization".fsc_org(id_org) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7696 (class 2606 OID 1612391)
-- Name: fsc_org_app fk_org_uses_app_org; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_org_app
    ADD CONSTRAINT fk_org_uses_app_org FOREIGN KEY (id_org) REFERENCES "_OLD_4_fiscalization".fsc_org(id_org) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7691 (class 2606 OID 1612292)
-- Name: fsc_filter fk_tasks_has_filter; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_filter
    ADD CONSTRAINT fk_tasks_has_filter FOREIGN KEY (id_task) REFERENCES "_OLD_4_fiscalization".fsc_task(id_task) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7702 (class 2606 OID 1612569)
-- Name: fsc_task fk_user_creates_task; Type: FK CONSTRAINT; Schema: _OLD_4_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_4_fiscalization".fsc_task
    ADD CONSTRAINT fk_user_creates_task FOREIGN KEY (id_user) REFERENCES "_OLD_4_fiscalization".fsc_user(id_user) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7706 (class 2606 OID 1616187)
-- Name: fsc_result fk_fsc_order_gets_result; Type: FK CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE "_OLD_5_fiscalization".fsc_result
    ADD CONSTRAINT fk_fsc_order_gets_result FOREIGN KEY (id_receipt, dt_create) REFERENCES "_OLD_5_fiscalization".fsc_order(id_receipt, dt_create) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7704 (class 2606 OID 1616056)
-- Name: fsc_app_fsc_provider fk_fsc_provider_providers_app_provider; Type: FK CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_5_fiscalization".fsc_app_fsc_provider
    ADD CONSTRAINT fk_fsc_provider_providers_app_provider FOREIGN KEY (id_fsc_provider) REFERENCES "_OLD_5_fiscalization".fsc_provider(id_fsc_provider) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7705 (class 2606 OID 1616108)
-- Name: fsc_rcp_params fk_order_has_parameters; Type: FK CONSTRAINT; Schema: _OLD_5_fiscalization; Owner: postgres
--

ALTER TABLE "_OLD_5_fiscalization".fsc_rcp_params
    ADD CONSTRAINT fk_order_has_parameters FOREIGN KEY (id_receipt, dt_create) REFERENCES "_OLD_5_fiscalization".fsc_order(id_receipt, dt_create) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 7708 (class 2606 OID 2111562)
-- Name: fsc_org_app fk_app_provedes_org_app; Type: FK CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_org_app
    ADD CONSTRAINT fk_app_provedes_org_app FOREIGN KEY (id_app) REFERENCES "_OLD_7_fiscalization".fsc_app(id_app) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7710 (class 2606 OID 2111567)
-- Name: fsc_org_app_param fk_app_uses_app_parametrs; Type: FK CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_org_app_param
    ADD CONSTRAINT fk_app_uses_app_parametrs FOREIGN KEY (id_org_app) REFERENCES "_OLD_7_fiscalization".fsc_org_app(id_org_app) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7711 (class 2606 OID 2111547)
-- Name: fsc_org_app_param fk_fsc_provider_supports_org_app_parameters; Type: FK CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_org_app_param
    ADD CONSTRAINT fk_fsc_provider_supports_org_app_parameters FOREIGN KEY (id_fsc_provider) REFERENCES "_OLD_7_fiscalization".fsc_provider(id_fsc_provider) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7707 (class 2606 OID 2111572)
-- Name: fsc_receipt fk_org_app_provedes_fsc_receipt; Type: FK CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE "_OLD_7_fiscalization".fsc_receipt
    ADD CONSTRAINT fk_org_app_provedes_fsc_receipt FOREIGN KEY (id_org_app) REFERENCES "_OLD_7_fiscalization".fsc_org_app(id_org_app) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7709 (class 2606 OID 2111557)
-- Name: fsc_org_app fk_org_uses_app_org; Type: FK CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_org_app
    ADD CONSTRAINT fk_org_uses_app_org FOREIGN KEY (id_org) REFERENCES "_OLD_7_fiscalization".fsc_org(id_org) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7712 (class 2606 OID 2111552)
-- Name: fsc_org_cash fk_org_uses_org_cash; Type: FK CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_org_cash
    ADD CONSTRAINT fk_org_uses_org_cash FOREIGN KEY (id_org) REFERENCES "_OLD_7_fiscalization".fsc_org(id_org) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7713 (class 2606 OID 2111542)
-- Name: fsc_org_cash fk_provider_providers_org_cash; Type: FK CONSTRAINT; Schema: _OLD_7_fiscalization; Owner: postgres
--

ALTER TABLE ONLY "_OLD_7_fiscalization".fsc_org_cash
    ADD CONSTRAINT fk_provider_providers_org_cash FOREIGN KEY (id_fsc_provider) REFERENCES "_OLD_7_fiscalization".fsc_provider(id_fsc_provider) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7684 (class 2606 OID 1512263)
-- Name: d_base fk1_d_base_belong_d_entity; Type: FK CONSTRAINT; Schema: dict; Owner: postgres
--

ALTER TABLE ONLY dict.d_base
    ADD CONSTRAINT fk1_d_base_belong_d_entity FOREIGN KEY (id_dict_entity) REFERENCES dict.d_entity(id_dict_entity);


--
-- TOC entry 7724 (class 2606 OID 2114798)
-- Name: fsc_org_app fk_app_provedes_org_app; Type: FK CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_org_app
    ADD CONSTRAINT fk_app_provedes_org_app FOREIGN KEY (id_app) REFERENCES fiscalization.fsc_app(id_app) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7729 (class 2606 OID 2114803)
-- Name: fsc_app_param fk_app_uses_app_parametrs; Type: FK CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_app_param
    ADD CONSTRAINT fk_app_uses_app_parametrs FOREIGN KEY (id_app) REFERENCES fiscalization.fsc_app(id_app) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7728 (class 2606 OID 2114783)
-- Name: fsc_data_operator fk_ofd_provides_org_app; Type: FK CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_data_operator
    ADD CONSTRAINT fk_ofd_provides_org_app FOREIGN KEY (id_fsc_data_operator) REFERENCES fiscalization.fsc_data_operator(id_fsc_data_operator) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7730 (class 2606 OID 2114778)
-- Name: fsc_app_param fk_ofdr_supports_app_parameters; Type: FK CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_app_param
    ADD CONSTRAINT fk_ofdr_supports_app_parameters FOREIGN KEY (id_fsc_provider) REFERENCES fiscalization.fsc_provider(id_fsc_provider) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7723 (class 2606 OID 2114808)
-- Name: fsc_receipt fk_org_app_supports_fsc_receipt; Type: FK CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE fiscalization.fsc_receipt
    ADD CONSTRAINT fk_org_app_supports_fsc_receipt FOREIGN KEY (id_org_app) REFERENCES fiscalization.fsc_org_app(id_org_app) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7725 (class 2606 OID 2114793)
-- Name: fsc_org_app fk_org_uses_app_org; Type: FK CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_org_app
    ADD CONSTRAINT fk_org_uses_app_org FOREIGN KEY (id_org) REFERENCES fiscalization.fsc_org(id_org) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7726 (class 2606 OID 2114788)
-- Name: fsc_org_cash fk_org_uses_org_cash; Type: FK CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_org_cash
    ADD CONSTRAINT fk_org_uses_org_cash FOREIGN KEY (id_org) REFERENCES fiscalization.fsc_org(id_org) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7727 (class 2606 OID 2114773)
-- Name: fsc_org_cash fk_provider_supports_org_cash; Type: FK CONSTRAINT; Schema: fiscalization; Owner: postgres
--

ALTER TABLE ONLY fiscalization.fsc_org_cash
    ADD CONSTRAINT fk_provider_supports_org_cash FOREIGN KEY (id_fsc_provider) REFERENCES fiscalization.fsc_provider(id_fsc_provider) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7658 (class 2606 OID 47018)
-- Name: org_link app link; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_link
    ADD CONSTRAINT "app link" FOREIGN KEY (app_id) REFERENCES public.app(app_id);


--
-- TOC entry 7664 (class 2606 OID 908410)
-- Name: receipt app_link; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt
    ADD CONSTRAINT app_link FOREIGN KEY (app_id) REFERENCES public.app(app_id);


--
-- TOC entry 7660 (class 2606 OID 908419)
-- Name: receipt_old app_link; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_old
    ADD CONSTRAINT app_link FOREIGN KEY (app_id) REFERENCES public.app(app_id);


--
-- TOC entry 7656 (class 2606 OID 47004)
-- Name: app_link app_link_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_link
    ADD CONSTRAINT app_link_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.app(app_id);


--
-- TOC entry 7657 (class 2606 OID 46984)
-- Name: app_link app_link_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_link
    ADD CONSTRAINT app_link_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- TOC entry 7663 (class 2606 OID 90612)
-- Name: user fk_org_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT fk_org_id FOREIGN KEY (org_id) REFERENCES public.org(org_id) NOT VALID;


--
-- TOC entry 7659 (class 2606 OID 47005)
-- Name: org_link org link; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_link
    ADD CONSTRAINT "org link" FOREIGN KEY (org_id) REFERENCES public.org(org_id);


--
-- TOC entry 7665 (class 2606 OID 908434)
-- Name: receipt org_link; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt
    ADD CONSTRAINT org_link FOREIGN KEY (org_id) REFERENCES public.org(org_id);


--
-- TOC entry 7661 (class 2606 OID 908443)
-- Name: receipt_old org_link; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_old
    ADD CONSTRAINT org_link FOREIGN KEY (org_id) REFERENCES public.org(org_id);


--
-- TOC entry 7662 (class 2606 OID 47025)
-- Name: report report_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- TOC entry 7715 (class 2606 OID 2111726)
-- Name: ssp_fisc_ad_filters fk_ssp_fisc_ssp_fisc__ssp_fisc; Type: FK CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_ad_filters
    ADD CONSTRAINT fk_ssp_fisc_ssp_fisc__ssp_fisc FOREIGN KEY (kd_filter_type) REFERENCES task.ssp_fisc_filter_type(kd_filter_type) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7716 (class 2606 OID 2111731)
-- Name: ssp_fisc_link_task_filters fk_ssp_fisc_ssp_fisc__ssp_fisc; Type: FK CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_link_task_filters
    ADD CONSTRAINT fk_ssp_fisc_ssp_fisc__ssp_fisc FOREIGN KEY (id_filter) REFERENCES task.ssp_fisc_filter(id_filter) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7714 (class 2606 OID 2111721)
-- Name: ssp_cash_register ssp_cash_group_fk1; Type: FK CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_cash_register
    ADD CONSTRAINT ssp_cash_group_fk1 FOREIGN KEY (id_cash_group) REFERENCES task.ssp_cash_group(id_cash_group) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7718 (class 2606 OID 2111741)
-- Name: ssp_fisc_task ssp_fisc_reference_ssp_cash_fk1; Type: FK CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_task
    ADD CONSTRAINT ssp_fisc_reference_ssp_cash_fk1 FOREIGN KEY (id_cash_group) REFERENCES task.ssp_cash_group(id_cash_group) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7717 (class 2606 OID 2111736)
-- Name: ssp_fisc_link_task_filters ssp_fisc_reference_ssp_fisc_fk1; Type: FK CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_link_task_filters
    ADD CONSTRAINT ssp_fisc_reference_ssp_fisc_fk1 FOREIGN KEY (id_fisc_task) REFERENCES task.ssp_fisc_task(id_fisc_task) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7719 (class 2606 OID 2111746)
-- Name: ssp_fisc_task ssp_fisc_reference_ssp_fisc_fk1; Type: FK CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_task
    ADD CONSTRAINT ssp_fisc_reference_ssp_fisc_fk1 FOREIGN KEY (kd_fisc_task_state) REFERENCES task.ssp_fisc_task_state(kd_fisc_task_state) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7720 (class 2606 OID 2111751)
-- Name: ssp_fisc_task ssp_fisc_reference_ssp_fisc_fk2; Type: FK CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_fisc_task
    ADD CONSTRAINT ssp_fisc_reference_ssp_fisc_fk2 FOREIGN KEY (kd_fisc_task_type) REFERENCES task.ssp_fisc_task_type(kd_fisc_task_type) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7721 (class 2606 OID 2111756)
-- Name: ssp_pay_corrparams_fisc ssp_pay_corrparams_fisc_fk1; Type: FK CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_pay_corrparams_fisc
    ADD CONSTRAINT ssp_pay_corrparams_fisc_fk1 FOREIGN KEY (id_fisc_task) REFERENCES task.ssp_fisc_task(id_fisc_task) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7722 (class 2606 OID 2111761)
-- Name: ssp_pay_link_fisc ssp_pay_link_fisc_fk1; Type: FK CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.ssp_pay_link_fisc
    ADD CONSTRAINT ssp_pay_link_fisc_fk1 FOREIGN KEY (id_fisc_task) REFERENCES task.ssp_fisc_task(id_fisc_task) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7874 (class 0 OID 0)
-- Dependencies: 14
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO support_role;


--
-- TOC entry 7915 (class 0 OID 0)
-- Dependencies: 629
-- Name: FUNCTION get_secure_info(_uuid character varying, _secret character varying, _inn character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_secure_info(_uuid character varying, _secret character varying, _inn character varying) TO support_role;


--
-- TOC entry 7916 (class 0 OID 0)
-- Dependencies: 616
-- Name: FUNCTION inc(val integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.inc(val integer) TO support_role;


--
-- TOC entry 7917 (class 0 OID 0)
-- Dependencies: 630
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT queryid bigint, OUT query text, OUT calls bigint, OUT total_time double precision, OUT min_time double precision, OUT max_time double precision, OUT mean_time double precision, OUT stddev_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT queryid bigint, OUT query text, OUT calls bigint, OUT total_time double precision, OUT min_time double precision, OUT max_time double precision, OUT mean_time double precision, OUT stddev_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision) TO support_role;


--
-- TOC entry 7918 (class 0 OID 0)
-- Dependencies: 631
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO support_role;


--
-- TOC entry 8590 (class 0 OID 0)
-- Dependencies: 255
-- Name: SEQUENCE app_app_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.app_app_id_seq TO support_role;


--
-- TOC entry 8591 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE app; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE public.app TO support_role;


--
-- TOC entry 8592 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE app_link; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE public.app_link TO support_role;


--
-- TOC entry 8594 (class 0 OID 0)
-- Dependencies: 237
-- Name: SEQUENCE app_link_app_link_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.app_link_app_link_id_seq TO support_role;


--
-- TOC entry 8595 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE org; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE public.org TO support_role;


--
-- TOC entry 8596 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE org_link; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE public.org_link TO support_role;


--
-- TOC entry 8598 (class 0 OID 0)
-- Dependencies: 240
-- Name: SEQUENCE org_link_org_link_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.org_link_org_link_id_seq TO support_role;


--
-- TOC entry 8600 (class 0 OID 0)
-- Dependencies: 241
-- Name: SEQUENCE org_org_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.org_org_id_seq TO support_role;


--
-- TOC entry 8601 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE public.pg_stat_statements TO support_role;


--
-- TOC entry 8602 (class 0 OID 0)
-- Dependencies: 254
-- Name: SEQUENCE receipt_receipt_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.receipt_receipt_id_seq TO support_role;


--
-- TOC entry 8603 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE receipt_2018; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE public.receipt_2018 TO support_role;


--
-- TOC entry 8604 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE receipt_2019; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE public.receipt_2019 TO support_role;


--
-- TOC entry 8605 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE receipt_old; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE public.receipt_old TO support_role;


--
-- TOC entry 8607 (class 0 OID 0)
-- Dependencies: 271
-- Name: TABLE receipt_status5; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.receipt_status5 TO support;


--
-- TOC entry 8608 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE report; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE public.report TO support_role;


--
-- TOC entry 8610 (class 0 OID 0)
-- Dependencies: 244
-- Name: SEQUENCE report_report_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.report_report_id_seq TO support_role;


--
-- TOC entry 8611 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE test; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE public.test TO support_role;


--
-- TOC entry 8612 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE "user"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE public."user" TO support_role;


--
-- TOC entry 8614 (class 0 OID 0)
-- Dependencies: 247
-- Name: SEQUENCE usrr_user_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.usrr_user_id_seq TO support_role;


--
-- TOC entry 8615 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE receipt_receipts_per_day_glougeq3_y1plbshy_1569943977443; Type: ACL; Schema: stb_pre_aggregations; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE stb_pre_aggregations.receipt_receipts_per_day_glougeq3_y1plbshy_1569943977443 TO support_role;


--
-- TOC entry 8616 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE receipt_receipts_per_hour_4dpwxcnd_nkv4d0ns_1569944401838; Type: ACL; Schema: stb_pre_aggregations; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE stb_pre_aggregations.receipt_receipts_per_hour_4dpwxcnd_nkv4d0ns_1569944401838 TO support_role;


--
-- TOC entry 8617 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE receipt_receipts_per_month_2fykycdn_g4i2vokg_1569943983410; Type: ACL; Schema: stb_pre_aggregations; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE stb_pre_aggregations.receipt_receipts_per_month_2fykycdn_g4i2vokg_1569943983410 TO support_role;


--
-- TOC entry 8618 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE receipt_receipts_per_week_ro0yvtck_sgf4bjzi_1569575036222; Type: ACL; Schema: stb_pre_aggregations; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,UPDATE ON TABLE stb_pre_aggregations.receipt_receipts_per_week_ro0yvtck_sgf4bjzi_1569575036222 TO support_role;


-- Completed on 2023-07-25 10:37:50 MSK

--
-- PostgreSQL database dump complete
--

