--
-- PostgreSQL database dump
--

-- Dumped from database version 13.11 (Ubuntu 13.11-1.pgdg18.04+1)
-- Dumped by pg_dump version 13.11 (Ubuntu 13.11-1.pgdg18.04+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adr_street_type; Type: TABLE; Schema: gar_tmp; Owner: postgres
--

CREATE TABLE gar_tmp.adr_street_type (
    id_street_type integer NOT NULL,
    nm_street_type character varying(50) NOT NULL,
    nm_street_type_short character varying(10) NOT NULL,
    dt_data_del timestamp without time zone
);


ALTER TABLE gar_tmp.adr_street_type OWNER TO postgres;

--
-- Name: TABLE adr_street_type; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON TABLE gar_tmp.adr_street_type IS 'С_Типы улицы (!)';


--
-- Name: COLUMN adr_street_type.id_street_type; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_street_type.id_street_type IS 'ИД типа улицы';


--
-- Name: COLUMN adr_street_type.nm_street_type; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_street_type.nm_street_type IS 'Наименование типа улицы';


--
-- Name: COLUMN adr_street_type.nm_street_type_short; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_street_type.nm_street_type_short IS 'Короткое наименование типа улицы';


--
-- Name: COLUMN adr_street_type.dt_data_del; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_street_type.dt_data_del IS 'Дата удаления';


--
-- Data for Name: adr_street_type; Type: TABLE DATA; Schema: gar_tmp; Owner: postgres
--

COPY gar_tmp.adr_street_type (id_street_type, nm_street_type, nm_street_type_short, dt_data_del) FROM stdin;
1	Аллея	аллея	\N
2	Бульвар	б-р	\N
3	Балка	балка	\N
4	Берег	берег	\N
5	Бугор	бугор	\N
6	Бухта	бухта	\N
7	Вал	вал	\N
8	Въезд	въезд	\N
9	Заезд	заезд	\N
10	Зона	зона	\N
11	Канал	канал	\N
12	Квартал	кв-л	\N
13	Кольцо	кольцо	\N
14	Коса	коса	\N
15	Линия	линия	\N
16	Микрорайон	мкр.	\N
17	Набережная	наб.	\N
18	Парк	парк	\N
19	Переулок	пер.	\N
20	Переезд	переезд	\N
21	Площадь	пл.	\N
22	Проспект	пр-кт	\N
23	Проезд	проезд	\N
24	Просек	просек	\N
25	Просека	просека	\N
26	Проток	проток	\N
27	Проулок	проулок	\N
28	Разъезд	рзд	\N
29	Ряды	ряды	\N
30	Сад	сад	\N
31	Сквер	сквер	\N
32	Спуск	спуск	\N
33	Станция	ст.	\N
34	Территория	тер.	\N
35	тоннель	тоннель	\N
36	Тракт	тракт	\N
37	Тупик	туп.	\N
38	Улица	ул.	\N
39	Участок	уч-к	\N
40	Шоссе	ш.	\N
41	Платформа	платф.	\N
42	Километр	км.	\N
43	Городок	г-к	\N
44	Гаражно-строительный кооп.	гск	\N
45	Казарма	казарма	\N
46	Местечко	м	\N
47	Остров	остров	\N
48	Ряд	ряд	\N
49	Дачное неком-е партнерство	днп	\N
50	Дорога	дор	\N
51	Маяк	маяк	\N
52	Магистраль	мгстр.	\N
53	Некоммерческое партнерство	н/п	\N
54	Планировочный район	пл.р-н	\N
55	Полустанок	полустанок	\N
56	Территория ДНТ	тер. ДНТ	\N
\.


--
-- Name: adr_street_type adr_street_type_nm_street_type_key; Type: CONSTRAINT; Schema: gar_tmp; Owner: postgres
--

ALTER TABLE ONLY gar_tmp.adr_street_type
    ADD CONSTRAINT adr_street_type_nm_street_type_key UNIQUE (nm_street_type);


--
-- Name: adr_street_type adr_street_type_pkey; Type: CONSTRAINT; Schema: gar_tmp; Owner: postgres
--

ALTER TABLE ONLY gar_tmp.adr_street_type
    ADD CONSTRAINT adr_street_type_pkey PRIMARY KEY (id_street_type);


--
-- PostgreSQL database dump complete
--

