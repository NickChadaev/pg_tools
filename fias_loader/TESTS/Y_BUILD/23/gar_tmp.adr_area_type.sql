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
-- Name: adr_area_type; Type: TABLE; Schema: gar_tmp; Owner: postgres
--

CREATE TABLE gar_tmp.adr_area_type (
    id_area_type integer NOT NULL,
    nm_area_type character varying(50) NOT NULL,
    nm_area_type_short character varying(10) NOT NULL,
    pr_lead smallint NOT NULL,
    dt_data_del timestamp without time zone
);


ALTER TABLE gar_tmp.adr_area_type OWNER TO postgres;

--
-- Name: TABLE adr_area_type; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON TABLE gar_tmp.adr_area_type IS 'С_Типы гео-региона (!)';


--
-- Name: COLUMN adr_area_type.id_area_type; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_area_type.id_area_type IS 'ИД типа гео-региона';


--
-- Name: COLUMN adr_area_type.nm_area_type; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_area_type.nm_area_type IS 'Наименование типа гео-региона';


--
-- Name: COLUMN adr_area_type.nm_area_type_short; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_area_type.nm_area_type_short IS 'Короткое наименование типа гео-региона';


--
-- Name: COLUMN adr_area_type.pr_lead; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_area_type.pr_lead IS 'Признак очередности типа гео-региона';


--
-- Name: COLUMN adr_area_type.dt_data_del; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_area_type.dt_data_del IS 'Дата удаления';


--
-- Data for Name: adr_area_type; Type: TABLE DATA; Schema: gar_tmp; Owner: postgres
--

COPY gar_tmp.adr_area_type (id_area_type, nm_area_type, nm_area_type_short, pr_lead, dt_data_del) FROM stdin;
1	Аал	аал	0	\N
2	Автономный округ	АО	0	\N
3	Автономная область	Аобл	0	\N
4	Арбан	арбан	0	\N
5	Аул	аул	0	\N
6	Выселки(ок)	высел.	0	\N
7	Город	г.	0	\N
8	Городок	городок	0	\N
9	городской поселок	гп	0	\N
10	Деревня	д.	0	\N
11	Дачный поселок	дп	0	\N
12	Железнодорожная будка	ж/д_будка	0	\N
13	Железнодорожная казарма	ж/д_казарм	0	\N
14	ж/д останов. (обгонный) пункт	ж/д_оп	0	\N
15	Железнодорожная платформа	ж/д_платф	0	\N
16	Железнодорожный пост	ж/д_пост	0	\N
17	Железнодорожный разъезд	ж/д_рзд	0	\N
18	Железнодорожная станция	ж/д_ст	0	\N
19	Жилая зона	жилзона	0	\N
20	Жилой район	жилрайон	0	\N
21	Заимка	заимка	0	\N
22	Казарма	казарма	0	\N
23	Квартал	кв-л	0	\N
24	Кордон	кордон	0	\N
25	Курортный поселок	кп	0	\N
26	Край	край	0	\N
27	Леспромхоз	лпх	0	\N
28	Местечко	м.	0	\N
29	Массив	массив	0	\N
30	Микрорайон	мкр.	0	\N
31	Населенный пункт	нп	0	\N
32	Область	обл.	0	\N
33	Остров	остров	0	\N
34	Поселок	п.	0	\N
35	Поселение	поселение	0	\N
36	Поселок и(при) станция(и)	п/ст	0	\N
37	Поселок городского типа	пгт	0	\N
38	Починок	починок	0	\N
39	Промышленная зона	промзона	0	\N
40	Район	р-н	0	\N
41	Республика	Респ	0	\N
42	Разъезд	рзд	0	\N
43	Рабочий поселок	рп	0	\N
44	Село	с	0	\N
45	Сельская администрация	с/а	0	\N
46	Сельское муницип.образование	с/мо	0	\N
47	Сельский округ	с/о	0	\N
48	Сельское поселение	с/п	0	\N
49	Сельсовет	с/с	0	\N
50	Слобода	сл	0	\N
51	Садовое неком-е товарищество	снт	0	\N
52	Станция	ст	0	\N
53	Станица	ст-ца	0	\N
54	Территория	тер	0	\N
55	Улус	у	0	\N
56	Хутор	х	0	\N
57	Дачное неком-е партнерство	днп	0	\N
58	Территория ДНП	тер. ДНП	0	\N
59	Территория ДНТ	тер. ДНТ	0	\N
60	Территория СНТ	тер. СНТ	0	\N
61	Территория ТСН	тер. ТСН	0	\N
62	Город федерального значения	г.ф.з.	0	\N
63	Округ	округ	0	\N
64	Чувашия	Чувашия	0	\N
65	Внутригородская территория	вн.тер. г.	0	\N
66	Городской округ	г.о.	0	\N
67	Муниципальный район	м.р-н	0	\N
68	Волость	волость	0	\N
69	Почтовое отделение	п/о	0	\N
70	Автодорога	автодорога	0	\N
71	Железнодорожный блокпост	ж/д бл-ст	0	\N
72	Железнодорожная ветка	ж/д в-ка	0	\N
73	Железнодорожный комбинат	ж/д к-т	0	\N
74	Железнодорожный остановочный пункт	ж/д о.п.	0	\N
75	Железнодорожный путевой пост	ж/д п.п.	0	\N
76	Железнодорожная площадка	ж/д пл-ка	0	\N
77	Зимовье	зим.	0	\N
78	Кишлак	киш.	0	\N
79	Поселок при железнодорожной станции	п. ж/д ст.	0	\N
80	Планировочный район	пл.р-н	0	\N
81	Погост	погост	0	\N
82	Поселок разъезда	пос.рзд	0	\N
83	Сельский поселок	сп	0	\N
84	Абонентский ящик	а/я	0	\N
85	Аллея	ал.	0	\N
86	Берег	б-г	0	\N
87	Бульвар	б-р	0	\N
88	Вал	вал	0	\N
89	Въезд	взд.	0	\N
90	Гаражно-строительный кооп.	гск	0	\N
91	Дорога	дор.	0	\N
92	Заезд	ззд.	0	\N
93	Зона (массив)	зона	0	\N
94	Километр	км	0	\N
95	Коса	коса	0	\N
96	Кольцо	к-цо	0	\N
97	Линия	лн.	0	\N
98	Местность	местность	0	\N
99	Месторождение	месторожд.	0	\N
100	Некоммерческое партнерство	н/п	0	\N
101	Набережная	наб.	0	\N
102	Промышленный район	п/р	0	\N
103	Парк	парк	0	\N
104	Переезд	пер-д	0	\N
105	Платформа	платф.	0	\N
106	Площадка	пл-ка	0	\N
107	Порт	порт	0	\N
108	Просек	пр-к	0	\N
109	Просека	пр-ка	0	\N
110	Проспект	пр-кт	0	\N
111	Проселок	пр-лок	0	\N
112	Проулок	проул.	0	\N
113	Сад	сад	0	\N
114	Спуск	с-к	0	\N
115	Сквер	сквер	0	\N
116	Территория ГСК	тер. ГСК	0	\N
117	Территория ДНО	тер. ДНО	0	\N
118	Территория ДПК	тер. ДПК	0	\N
119	Территория ОНО	тер. ОНО	0	\N
120	Территория ОНП	тер. ОНП	0	\N
121	Территория ОНТ	тер. ОНТ	0	\N
122	Территория ОПК	тер. ОПК	0	\N
123	Территория ПК	тер. ПК	0	\N
124	Территория СНО	тер. СНО	0	\N
125	Территория СНП	тер. СНП	0	\N
126	Территория СПК	тер. СПК	0	\N
127	Территория ТСЖ	тер. ТСЖ	0	\N
128	Территория СОСН	тер.СОСН	0	\N
129	Территория ФХ	тер.ф.х.	0	\N
130	Тракт	тракт	0	\N
131	Тупик	туп.	0	\N
132	Усадьба	ус.	0	\N
133	Фермерское хозяйство	ф/х	0	\N
134	Шоссе	ш.	0	\N
135	Юрты	ю.	0	\N
136	городское поселение	г.п.	0	\N
137	внутригородской район	вн.р-н	0	\N
138	межселенная территория	межсел.тер	0	\N
139	Муниципальный округ	м.о.	0	\N
140	Поселок при станции (поселок станции)	п. ст.	0	\N
141	Садовое товарищество	с/т	0	\N
142	Выселки	в-ки	0	\N
\.


--
-- Name: adr_area_type adr_area_type_nm_area_type_key; Type: CONSTRAINT; Schema: gar_tmp; Owner: postgres
--

ALTER TABLE ONLY gar_tmp.adr_area_type
    ADD CONSTRAINT adr_area_type_nm_area_type_key UNIQUE (nm_area_type);


--
-- Name: adr_area_type adr_area_type_pkey; Type: CONSTRAINT; Schema: gar_tmp; Owner: postgres
--

ALTER TABLE ONLY gar_tmp.adr_area_type
    ADD CONSTRAINT adr_area_type_pkey PRIMARY KEY (id_area_type);


--
-- PostgreSQL database dump complete
--

