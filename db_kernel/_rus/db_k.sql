--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.10
-- Dumped by pg_dump version 9.6.10
-- Dumped from server: PostgresPro 9.6.10.1 on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 5.4.0-6ubuntu1~16.04.10) 5.4.0 20160609, 64-bit, edition: standard

-- Started on 2018-12-15 11:26:26 MSK

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2411 (class 0 OID 0)
-- Dependencies: 2410
-- Name: DATABASE db_k; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE db_k IS 'База-Ядро 2.0 от 2018-12-14. (Hg Ревизия 0)';


--
-- TOC entry 11 (class 2615 OID 44610)
-- Name: auth; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO postgres;

--
-- TOC entry 2412 (class 0 OID 0)
-- Dependencies: 11
-- Name: SCHEMA auth; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA auth IS 'Управление доступом к объектам';


--
-- TOC entry 29 (class 2615 OID 44612)
-- Name: auth_apr; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA auth_apr;


ALTER SCHEMA auth_apr OWNER TO postgres;

--
-- TOC entry 2413 (class 0 OID 0)
-- Dependencies: 29
-- Name: SCHEMA auth_apr; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA auth_apr IS 'Управление доступом к объектам. Функции для прикладных ролей';


--
-- TOC entry 20 (class 2615 OID 44611)
-- Name: auth_serv_obj; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA auth_serv_obj;


ALTER SCHEMA auth_serv_obj OWNER TO postgres;

--
-- TOC entry 2414 (class 0 OID 0)
-- Dependencies: 20
-- Name: SCHEMA auth_serv_obj; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA auth_serv_obj IS 'Управление доступом к объектам. Функции для серверных объектов';


--
-- TOC entry 13 (class 2615 OID 44599)
-- Name: com; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA com;


ALTER SCHEMA com OWNER TO postgres;

--
-- TOC entry 2415 (class 0 OID 0)
-- Dependencies: 13
-- Name: SCHEMA com; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA com IS 'Общие данные';


--
-- TOC entry 15 (class 2615 OID 44600)
-- Name: com_codifier; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA com_codifier;


ALTER SCHEMA com_codifier OWNER TO postgres;

--
-- TOC entry 2416 (class 0 OID 0)
-- Dependencies: 15
-- Name: SCHEMA com_codifier; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA com_codifier IS 'Общие данные. Функции для кодификатора';


--
-- TOC entry 14 (class 2615 OID 44601)
-- Name: com_domain; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA com_domain;


ALTER SCHEMA com_domain OWNER TO postgres;

--
-- TOC entry 2417 (class 0 OID 0)
-- Dependencies: 14
-- Name: SCHEMA com_domain; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA com_domain IS 'Общие данные. Функции для домена колонок';


--
-- TOC entry 18 (class 2615 OID 44602)
-- Name: com_object; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA com_object;


ALTER SCHEMA com_object OWNER TO postgres;

--
-- TOC entry 2418 (class 0 OID 0)
-- Dependencies: 18
-- Name: SCHEMA com_object; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA com_object IS 'Общие данные. Функции для объектов';


--
-- TOC entry 25 (class 2615 OID 44613)
-- Name: db_info; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA db_info;


ALTER SCHEMA db_info OWNER TO postgres;

--
-- TOC entry 2419 (class 0 OID 0)
-- Dependencies: 25
-- Name: SCHEMA db_info; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA db_info IS 'Информация о БД';


--
-- TOC entry 21 (class 2615 OID 44606)
-- Name: ind; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ind;


ALTER SCHEMA ind OWNER TO postgres;

--
-- TOC entry 2420 (class 0 OID 0)
-- Dependencies: 21
-- Name: SCHEMA ind; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA ind IS 'Показатели';


--
-- TOC entry 26 (class 2615 OID 44608)
-- Name: ind_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ind_data;


ALTER SCHEMA ind_data OWNER TO postgres;

--
-- TOC entry 2421 (class 0 OID 0)
-- Dependencies: 26
-- Name: SCHEMA ind_data; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA ind_data IS 'Показатели. Функции управляющие данными';


--
-- TOC entry 23 (class 2615 OID 44607)
-- Name: ind_structure; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ind_structure;


ALTER SCHEMA ind_structure OWNER TO postgres;

--
-- TOC entry 2422 (class 0 OID 0)
-- Dependencies: 23
-- Name: SCHEMA ind_structure; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA ind_structure IS 'Показатели. Функции управляющие структурой';


--
-- TOC entry 16 (class 2615 OID 44603)
-- Name: nso; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA nso;


ALTER SCHEMA nso OWNER TO postgres;

--
-- TOC entry 2423 (class 0 OID 0)
-- Dependencies: 16
-- Name: SCHEMA nso; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA nso IS 'Нормативно-справочная информация';


--
-- TOC entry 10 (class 2615 OID 44605)
-- Name: nso_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA nso_data;


ALTER SCHEMA nso_data OWNER TO postgres;

--
-- TOC entry 2424 (class 0 OID 0)
-- Dependencies: 10
-- Name: SCHEMA nso_data; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA nso_data IS 'Нормативно-справочная информация. Функции управляющие данными';


--
-- TOC entry 24 (class 2615 OID 44604)
-- Name: nso_structure; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA nso_structure;


ALTER SCHEMA nso_structure OWNER TO postgres;

--
-- TOC entry 2425 (class 0 OID 0)
-- Dependencies: 24
-- Name: SCHEMA nso_structure; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA nso_structure IS 'Нормативно-справочная информация. Функции управляющие структурой';


--
-- TOC entry 28 (class 2615 OID 44609)
-- Name: uio; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA uio;


ALTER SCHEMA uio OWNER TO postgres;

--
-- TOC entry 2427 (class 0 OID 0)
-- Dependencies: 28
-- Name: SCHEMA uio; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA uio IS 'Обмен данными';


--
-- TOC entry 22 (class 2615 OID 44614)
-- Name: utl; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA utl;


ALTER SCHEMA utl OWNER TO postgres;

--
-- TOC entry 2428 (class 0 OID 0)
-- Dependencies: 22
-- Name: SCHEMA utl; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA utl IS 'Вспомогательный функционал';


--
-- TOC entry 2 (class 3079 OID 12429)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2429 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 1 (class 3079 OID 44334)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 2430 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 7 (class 3079 OID 44343)
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- TOC entry 2431 (class 0 OID 0)
-- Dependencies: 7
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- TOC entry 6 (class 3079 OID 44466)
-- Name: pg_buffercache; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_buffercache WITH SCHEMA public;


--
-- TOC entry 2432 (class 0 OID 0)
-- Dependencies: 6
-- Name: EXTENSION pg_buffercache; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_buffercache IS 'examine the shared buffer cache';


--
-- TOC entry 5 (class 3079 OID 44472)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 2433 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 4 (class 3079 OID 44509)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 2434 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 3 (class 3079 OID 44520)
-- Name: xml2; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS xml2 WITH SCHEMA public;


--
-- TOC entry 2435 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION xml2; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION xml2 IS 'XPath querying and XSLT';


--
-- TOC entry 752 (class 1247 OID 44578)
-- Name: column_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.column_t AS (
	col_id bigint,
	col_stype character(1),
	key_stype character(1)
);


ALTER TYPE public.column_t OWNER TO postgres;

--
-- TOC entry 2436 (class 0 OID 0)
-- Dependencies: 752
-- Name: TYPE column_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.column_t IS 'Пользовательский тип для хранения краткой информации о столбце';


--
-- TOC entry 2437 (class 0 OID 0)
-- Dependencies: 752
-- Name: COLUMN column_t.col_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.column_t.col_id IS 'Идентификатор столбца';


--
-- TOC entry 2438 (class 0 OID 0)
-- Dependencies: 752
-- Name: COLUMN column_t.col_stype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.column_t.col_stype IS 'Код типа данных';


--
-- TOC entry 2439 (class 0 OID 0)
-- Dependencies: 752
-- Name: COLUMN column_t.key_stype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.column_t.key_stype IS 'Код типа ключа';


--
-- TOC entry 769 (class 1247 OID 44595)
-- Name: column_t2; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.column_t2 AS (
	col_id bigint,
	col_nmb smallint,
	col_code character varying(60),
	col_stype character(1),
	key_stype character(1)
);


ALTER TYPE public.column_t2 OWNER TO postgres;

--
-- TOC entry 2440 (class 0 OID 0)
-- Dependencies: 769
-- Name: TYPE column_t2; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.column_t2 IS 'Пользовательский тип для хранения краткой информации о столбце. Версия 2. K';


--
-- TOC entry 2441 (class 0 OID 0)
-- Dependencies: 769
-- Name: COLUMN column_t2.col_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.column_t2.col_id IS 'Идентификатор столбца';


--
-- TOC entry 2442 (class 0 OID 0)
-- Dependencies: 769
-- Name: COLUMN column_t2.col_nmb; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.column_t2.col_nmb IS 'Номер столбца';


--
-- TOC entry 2443 (class 0 OID 0)
-- Dependencies: 769
-- Name: COLUMN column_t2.col_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.column_t2.col_code IS 'Код столбца';


--
-- TOC entry 2444 (class 0 OID 0)
-- Dependencies: 769
-- Name: COLUMN column_t2.col_stype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.column_t2.col_stype IS 'Код типа данных';


--
-- TOC entry 2445 (class 0 OID 0)
-- Dependencies: 769
-- Name: COLUMN column_t2.key_stype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.column_t2.key_stype IS 'Код типа ключа';


--
-- TOC entry 710 (class 1247 OID 44534)
-- Name: id_t; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.id_t AS bigint;


ALTER DOMAIN public.id_t OWNER TO postgres;

--
-- TOC entry 2446 (class 0 OID 0)
-- Dependencies: 710
-- Name: DOMAIN id_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.id_t IS 'Идентификатор';


--
-- TOC entry 711 (class 1247 OID 44535)
-- Name: ip_t; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.ip_t AS inet;


ALTER DOMAIN public.ip_t OWNER TO postgres;

--
-- TOC entry 2447 (class 0 OID 0)
-- Dependencies: 711
-- Name: DOMAIN ip_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.ip_t IS 'IP адрес';


--
-- TOC entry 714 (class 1247 OID 44538)
-- Name: longint_t; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.longint_t AS bigint;


ALTER DOMAIN public.longint_t OWNER TO postgres;

--
-- TOC entry 2448 (class 0 OID 0)
-- Dependencies: 714
-- Name: DOMAIN longint_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.longint_t IS 'Длинное целое';


--
-- TOC entry 764 (class 1247 OID 44590)
-- Name: result_long_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.result_long_t AS (
	rc bigint,
	errm text
);


ALTER TYPE public.result_long_t OWNER TO postgres;

--
-- TOC entry 2449 (class 0 OID 0)
-- Dependencies: 764
-- Name: TYPE result_long_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.result_long_t IS 'Пользовательский тип для индикации успешности выполнения, переменные такого типа должны возвращатся каждой функцией, которая выполняет DDL-операции';


--
-- TOC entry 2450 (class 0 OID 0)
-- Dependencies: 764
-- Name: COLUMN result_long_t.rc; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_long_t.rc IS 'Код возврата';


--
-- TOC entry 2451 (class 0 OID 0)
-- Dependencies: 764
-- Name: COLUMN result_long_t.errm; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_long_t.errm IS 'Сообщение об ошибке';


--
-- TOC entry 749 (class 1247 OID 44575)
-- Name: result_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.result_t AS (
	rc bigint,
	errm character varying(2048)
);


ALTER TYPE public.result_t OWNER TO postgres;

--
-- TOC entry 2452 (class 0 OID 0)
-- Dependencies: 749
-- Name: TYPE result_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.result_t IS 'Пользовательский тип для индикации успешности выполнения, переменные такого типа должны возвращатся каждой функцией, которая выполняет DDL-операции';


--
-- TOC entry 2453 (class 0 OID 0)
-- Dependencies: 749
-- Name: COLUMN result_t.rc; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_t.rc IS 'Код возврата';


--
-- TOC entry 2454 (class 0 OID 0)
-- Dependencies: 749
-- Name: COLUMN result_t.errm; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_t.errm IS 'Сообщение об ошибке';


--
-- TOC entry 712 (class 1247 OID 44536)
-- Name: small_t; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.small_t AS smallint;


ALTER DOMAIN public.small_t OWNER TO postgres;

--
-- TOC entry 2455 (class 0 OID 0)
-- Dependencies: 712
-- Name: DOMAIN small_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.small_t IS 'Короткое целое';


--
-- TOC entry 762 (class 1247 OID 44586)
-- Name: t_arr_boolean; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_arr_boolean AS boolean[];


ALTER DOMAIN public.t_arr_boolean OWNER TO postgres;

--
-- TOC entry 2456 (class 0 OID 0)
-- Dependencies: 762
-- Name: DOMAIN t_arr_boolean; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_arr_boolean IS 'Массив логических значений';


--
-- TOC entry 732 (class 1247 OID 44556)
-- Name: t_arr_code; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_arr_code AS character varying(60)[];


ALTER DOMAIN public.t_arr_code OWNER TO postgres;

--
-- TOC entry 2457 (class 0 OID 0)
-- Dependencies: 732
-- Name: DOMAIN t_arr_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_arr_code IS 'Массив кодов';


--
-- TOC entry 768 (class 1247 OID 44592)
-- Name: t_arr_code1; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_arr_code1 AS character(1)[];


ALTER DOMAIN public.t_arr_code1 OWNER TO postgres;

--
-- TOC entry 2458 (class 0 OID 0)
-- Dependencies: 768
-- Name: DOMAIN t_arr_code1; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_arr_code1 IS 'Массив CHAR(1) K';


--
-- TOC entry 767 (class 1247 OID 44591)
-- Name: t_arr_guid; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_arr_guid AS uuid[];


ALTER DOMAIN public.t_arr_guid OWNER TO postgres;

--
-- TOC entry 2459 (class 0 OID 0)
-- Dependencies: 767
-- Name: DOMAIN t_arr_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_arr_guid IS 'Массив UUID';


--
-- TOC entry 731 (class 1247 OID 44555)
-- Name: t_arr_id; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_arr_id AS bigint[];


ALTER DOMAIN public.t_arr_id OWNER TO postgres;

--
-- TOC entry 2460 (class 0 OID 0)
-- Dependencies: 731
-- Name: DOMAIN t_arr_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_arr_id IS 'Массив идентификаторов';


--
-- TOC entry 760 (class 1247 OID 44584)
-- Name: t_arr_nmb; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_arr_nmb AS smallint[];


ALTER DOMAIN public.t_arr_nmb OWNER TO postgres;

--
-- TOC entry 2461 (class 0 OID 0)
-- Dependencies: 760
-- Name: DOMAIN t_arr_nmb; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_arr_nmb IS 'Массив коротких целых';


--
-- TOC entry 761 (class 1247 OID 44585)
-- Name: t_arr_text; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_arr_text AS text[];


ALTER DOMAIN public.t_arr_text OWNER TO postgres;

--
-- TOC entry 2462 (class 0 OID 0)
-- Dependencies: 761
-- Name: DOMAIN t_arr_text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_arr_text IS 'Массив текстов не лимитированной длины. Может содержать гигабайты текстовой информации в одной ячейке (Ограничено есть только со стороны файловой системы OS)';


--
-- TOC entry 746 (class 1247 OID 44570)
-- Name: t_arr_values; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_arr_values AS character varying(2048)[];


ALTER DOMAIN public.t_arr_values OWNER TO postgres;

--
-- TOC entry 2463 (class 0 OID 0)
-- Dependencies: 746
-- Name: DOMAIN t_arr_values; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_arr_values IS 'Массив значений';


--
-- TOC entry 774 (class 1247 OID 44598)
-- Name: t_bit16; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_bit16 AS bit varying(16);


ALTER DOMAIN public.t_bit16 OWNER TO postgres;

--
-- TOC entry 2464 (class 0 OID 0)
-- Dependencies: 774
-- Name: DOMAIN t_bit16; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_bit16 IS '16-ти битовая строка';


--
-- TOC entry 772 (class 1247 OID 44596)
-- Name: t_bit4; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_bit4 AS bit varying(4);


ALTER DOMAIN public.t_bit4 OWNER TO postgres;

--
-- TOC entry 2465 (class 0 OID 0)
-- Dependencies: 772
-- Name: DOMAIN t_bit4; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_bit4 IS '4-х битовая строка';


--
-- TOC entry 773 (class 1247 OID 44597)
-- Name: t_bit8; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_bit8 AS bit varying(8);


ALTER DOMAIN public.t_bit8 OWNER TO postgres;

--
-- TOC entry 2466 (class 0 OID 0)
-- Dependencies: 773
-- Name: DOMAIN t_bit8; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_bit8 IS '8-ми битовая строка';


--
-- TOC entry 715 (class 1247 OID 44539)
-- Name: t_blob; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_blob AS bytea;


ALTER DOMAIN public.t_blob OWNER TO postgres;

--
-- TOC entry 2467 (class 0 OID 0)
-- Dependencies: 715
-- Name: DOMAIN t_blob; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_blob IS 'Нестуктурированная бинарная информация';


--
-- TOC entry 716 (class 1247 OID 44540)
-- Name: t_boolean; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_boolean AS boolean;


ALTER DOMAIN public.t_boolean OWNER TO postgres;

--
-- TOC entry 2468 (class 0 OID 0)
-- Dependencies: 716
-- Name: DOMAIN t_boolean; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_boolean IS 'Логическое';


--
-- TOC entry 717 (class 1247 OID 44541)
-- Name: t_code1; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_code1 AS character(1);


ALTER DOMAIN public.t_code1 OWNER TO postgres;

--
-- TOC entry 2469 (class 0 OID 0)
-- Dependencies: 717
-- Name: DOMAIN t_code1; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_code1 IS 'Код размерностью 1 символ';


--
-- TOC entry 718 (class 1247 OID 44542)
-- Name: t_code2; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_code2 AS character(2);


ALTER DOMAIN public.t_code2 OWNER TO postgres;

--
-- TOC entry 2470 (class 0 OID 0)
-- Dependencies: 718
-- Name: DOMAIN t_code2; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_code2 IS 'Код размерностью 2 символа';


--
-- TOC entry 719 (class 1247 OID 44543)
-- Name: t_code5; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_code5 AS character(5);


ALTER DOMAIN public.t_code5 OWNER TO postgres;

--
-- TOC entry 2471 (class 0 OID 0)
-- Dependencies: 719
-- Name: DOMAIN t_code5; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_code5 IS 'Код размерностью 5 символов';


--
-- TOC entry 733 (class 1247 OID 44557)
-- Name: t_code6; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_code6 AS character varying(6);


ALTER DOMAIN public.t_code6 OWNER TO postgres;

--
-- TOC entry 2472 (class 0 OID 0)
-- Dependencies: 733
-- Name: DOMAIN t_code6; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_code6 IS 'Код размерностью 6 символов';


--
-- TOC entry 741 (class 1247 OID 44565)
-- Name: t_date; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_date AS date;


ALTER DOMAIN public.t_date OWNER TO postgres;

--
-- TOC entry 2473 (class 0 OID 0)
-- Dependencies: 741
-- Name: DOMAIN t_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_date IS 'Дата';


--
-- TOC entry 748 (class 1247 OID 44572)
-- Name: t_decimal; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_decimal AS numeric(17,6);


ALTER DOMAIN public.t_decimal OWNER TO postgres;

--
-- TOC entry 2474 (class 0 OID 0)
-- Dependencies: 748
-- Name: DOMAIN t_decimal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_decimal IS 'Десятичное число';


--
-- TOC entry 735 (class 1247 OID 44559)
-- Name: t_description; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_description AS character varying;


ALTER DOMAIN public.t_description OWNER TO postgres;

--
-- TOC entry 2475 (class 0 OID 0)
-- Dependencies: 735
-- Name: DOMAIN t_description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_description IS 'Расширенное полное наименование';


--
-- TOC entry 722 (class 1247 OID 44546)
-- Name: t_str2048; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_str2048 AS character varying(2048);


ALTER DOMAIN public.t_str2048 OWNER TO postgres;

--
-- TOC entry 2476 (class 0 OID 0)
-- Dependencies: 722
-- Name: DOMAIN t_str2048; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_str2048 IS 'Строка размерностью 2048 символов';


--
-- TOC entry 728 (class 1247 OID 44552)
-- Name: t_sysname; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_sysname AS character varying(120);


ALTER DOMAIN public.t_sysname OWNER TO postgres;

--
-- TOC entry 2477 (class 0 OID 0)
-- Dependencies: 728
-- Name: DOMAIN t_sysname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_sysname IS 'Имя таблицы';


--
-- TOC entry 755 (class 1247 OID 44581)
-- Name: t_error_head; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.t_error_head AS (
	err_code public.t_code5,
	message_out public.t_str2048,
	sch_name public.t_sysname,
	func_name public.t_sysname
);


ALTER TYPE public.t_error_head OWNER TO postgres;

--
-- TOC entry 2478 (class 0 OID 0)
-- Dependencies: 755
-- Name: TYPE t_error_head; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.t_error_head IS 'Тип описывает заголовок ошибки';


--
-- TOC entry 729 (class 1247 OID 44553)
-- Name: t_fieldname; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_fieldname AS character varying(120);


ALTER DOMAIN public.t_fieldname OWNER TO postgres;

--
-- TOC entry 2479 (class 0 OID 0)
-- Dependencies: 729
-- Name: DOMAIN t_fieldname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_fieldname IS 'Имя поля базы данных';


--
-- TOC entry 763 (class 1247 OID 44587)
-- Name: t_filename; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_filename AS character varying(1024);


ALTER DOMAIN public.t_filename OWNER TO postgres;

--
-- TOC entry 2480 (class 0 OID 0)
-- Dependencies: 763
-- Name: DOMAIN t_filename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_filename IS 'Имя внешнего файла';


--
-- TOC entry 730 (class 1247 OID 44554)
-- Name: t_fullname; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_fullname AS character varying(1024);


ALTER DOMAIN public.t_fullname OWNER TO postgres;

--
-- TOC entry 2481 (class 0 OID 0)
-- Dependencies: 730
-- Name: DOMAIN t_fullname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_fullname IS 'Полное наименование';


--
-- TOC entry 720 (class 1247 OID 44544)
-- Name: t_guid; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_guid AS uuid;


ALTER DOMAIN public.t_guid OWNER TO postgres;

--
-- TOC entry 2482 (class 0 OID 0)
-- Dependencies: 720
-- Name: DOMAIN t_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_guid IS 'UUID';


--
-- TOC entry 737 (class 1247 OID 44561)
-- Name: t_inn_pp; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_inn_pp AS character(12);


ALTER DOMAIN public.t_inn_pp OWNER TO postgres;

--
-- TOC entry 2483 (class 0 OID 0)
-- Dependencies: 737
-- Name: DOMAIN t_inn_pp; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_inn_pp IS 'ИНН физического лица';


--
-- TOC entry 736 (class 1247 OID 44560)
-- Name: t_inn_ul; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_inn_ul AS character(10);


ALTER DOMAIN public.t_inn_ul OWNER TO postgres;

--
-- TOC entry 2484 (class 0 OID 0)
-- Dependencies: 736
-- Name: DOMAIN t_inn_ul; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_inn_ul IS 'ИНН юридического лица';


--
-- TOC entry 713 (class 1247 OID 44537)
-- Name: t_int; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_int AS integer;


ALTER DOMAIN public.t_int OWNER TO postgres;

--
-- TOC entry 2485 (class 0 OID 0)
-- Dependencies: 713
-- Name: DOMAIN t_int; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_int IS 'Целое';


--
-- TOC entry 759 (class 1247 OID 44583)
-- Name: t_interval; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_interval AS interval;


ALTER DOMAIN public.t_interval OWNER TO postgres;

--
-- TOC entry 2486 (class 0 OID 0)
-- Dependencies: 759
-- Name: DOMAIN t_interval; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_interval IS 'Интервал';


--
-- TOC entry 758 (class 1247 OID 44582)
-- Name: t_json; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_json AS json;


ALTER DOMAIN public.t_json OWNER TO postgres;

--
-- TOC entry 2487 (class 0 OID 0)
-- Dependencies: 758
-- Name: DOMAIN t_json; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_json IS 'Тип JSON (Java Script Objects Notation)';


--
-- TOC entry 739 (class 1247 OID 44563)
-- Name: t_kpp; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_kpp AS character(9);


ALTER DOMAIN public.t_kpp OWNER TO postgres;

--
-- TOC entry 2488 (class 0 OID 0)
-- Dependencies: 739
-- Name: DOMAIN t_kpp; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_kpp IS 'КПП';


--
-- TOC entry 738 (class 1247 OID 44562)
-- Name: t_money; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_money AS numeric(15,2);


ALTER DOMAIN public.t_money OWNER TO postgres;

--
-- TOC entry 2489 (class 0 OID 0)
-- Dependencies: 738
-- Name: DOMAIN t_money; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_money IS 'Денежная единица';


--
-- TOC entry 727 (class 1247 OID 44551)
-- Name: t_oid; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_oid AS integer;


ALTER DOMAIN public.t_oid OWNER TO postgres;

--
-- TOC entry 2490 (class 0 OID 0)
-- Dependencies: 727
-- Name: DOMAIN t_oid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_oid IS 'Системный идентификатор';


--
-- TOC entry 740 (class 1247 OID 44564)
-- Name: t_phone_nmb; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_phone_nmb AS character(10);


ALTER DOMAIN public.t_phone_nmb OWNER TO postgres;

--
-- TOC entry 2491 (class 0 OID 0)
-- Dependencies: 740
-- Name: DOMAIN t_phone_nmb; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_phone_nmb IS 'Номер телефона';


--
-- TOC entry 742 (class 1247 OID 44566)
-- Name: t_shortname; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_shortname AS character varying(100);


ALTER DOMAIN public.t_shortname OWNER TO postgres;

--
-- TOC entry 2492 (class 0 OID 0)
-- Dependencies: 742
-- Name: DOMAIN t_shortname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_shortname IS 'Краткое наименование';


--
-- TOC entry 734 (class 1247 OID 44558)
-- Name: t_str100; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_str100 AS character varying(100);


ALTER DOMAIN public.t_str100 OWNER TO postgres;

--
-- TOC entry 2493 (class 0 OID 0)
-- Dependencies: 734
-- Name: DOMAIN t_str100; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_str100 IS 'Строка 100 символов';


--
-- TOC entry 721 (class 1247 OID 44545)
-- Name: t_str1024; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_str1024 AS character varying(1024);


ALTER DOMAIN public.t_str1024 OWNER TO postgres;

--
-- TOC entry 2494 (class 0 OID 0)
-- Dependencies: 721
-- Name: DOMAIN t_str1024; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_str1024 IS 'Строка 1024 символов';


--
-- TOC entry 743 (class 1247 OID 44567)
-- Name: t_str20; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_str20 AS character varying(20);


ALTER DOMAIN public.t_str20 OWNER TO postgres;

--
-- TOC entry 2495 (class 0 OID 0)
-- Dependencies: 743
-- Name: DOMAIN t_str20; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_str20 IS 'Строка 20 символов';


--
-- TOC entry 723 (class 1247 OID 44547)
-- Name: t_str250; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_str250 AS character varying(250);


ALTER DOMAIN public.t_str250 OWNER TO postgres;

--
-- TOC entry 2496 (class 0 OID 0)
-- Dependencies: 723
-- Name: DOMAIN t_str250; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_str250 IS 'Строка 250 символов';


--
-- TOC entry 744 (class 1247 OID 44568)
-- Name: t_str4096; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_str4096 AS character varying(4096);


ALTER DOMAIN public.t_str4096 OWNER TO postgres;

--
-- TOC entry 2497 (class 0 OID 0)
-- Dependencies: 744
-- Name: DOMAIN t_str4096; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_str4096 IS 'Строка 4096 символов';


--
-- TOC entry 724 (class 1247 OID 44548)
-- Name: t_str60; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_str60 AS character varying(60);


ALTER DOMAIN public.t_str60 OWNER TO postgres;

--
-- TOC entry 2498 (class 0 OID 0)
-- Dependencies: 724
-- Name: DOMAIN t_str60; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_str60 IS 'Строка 60 символов';


--
-- TOC entry 747 (class 1247 OID 44571)
-- Name: t_text; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_text AS text;


ALTER DOMAIN public.t_text OWNER TO postgres;

--
-- TOC entry 2499 (class 0 OID 0)
-- Dependencies: 747
-- Name: DOMAIN t_text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_text IS 'Текст не лимитированной длины. Может содержать гигабайты текстовой информации в одной ячейке (Ограничено есть только со стороны файловой системы OS)';


--
-- TOC entry 725 (class 1247 OID 44549)
-- Name: t_timestamp; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_timestamp AS timestamp(0) without time zone;


ALTER DOMAIN public.t_timestamp OWNER TO postgres;

--
-- TOC entry 2500 (class 0 OID 0)
-- Dependencies: 725
-- Name: DOMAIN t_timestamp; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_timestamp IS 'Дата время без часового пояса';


--
-- TOC entry 745 (class 1247 OID 44569)
-- Name: t_timestampz; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.t_timestampz AS timestamp(3) with time zone;


ALTER DOMAIN public.t_timestampz OWNER TO postgres;

--
-- TOC entry 2501 (class 0 OID 0)
-- Dependencies: 745
-- Name: DOMAIN t_timestampz; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.t_timestampz IS 'Дата время с часовым поясом';


--
-- TOC entry 726 (class 1247 OID 44550)
-- Name: xml_t; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.xml_t AS xml;


ALTER DOMAIN public.xml_t OWNER TO postgres;

--
-- TOC entry 2502 (class 0 OID 0)
-- Dependencies: 726
-- Name: DOMAIN xml_t; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON DOMAIN public.xml_t IS 'XML';


-- Completed on 2018-12-15 11:26:26 MSK

--
-- PostgreSQL database dump complete
--

