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
-- Name: adr_house_type; Type: TABLE; Schema: gar_tmp; Owner: postgres
--

CREATE TABLE gar_tmp.adr_house_type (
    id_house_type integer NOT NULL,
    nm_house_type character varying(50) NOT NULL,
    nm_house_type_short character varying(10) NOT NULL,
    kd_house_type_lvl integer NOT NULL,
    dt_data_del timestamp without time zone
);


ALTER TABLE gar_tmp.adr_house_type OWNER TO postgres;

--
-- Name: TABLE adr_house_type; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON TABLE gar_tmp.adr_house_type IS 'С_Типы номера (!)';


--
-- Name: COLUMN adr_house_type.id_house_type; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_house_type.id_house_type IS 'ИД типа номера';


--
-- Name: COLUMN adr_house_type.nm_house_type; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_house_type.nm_house_type IS 'Наименование типа номера';


--
-- Name: COLUMN adr_house_type.nm_house_type_short; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_house_type.nm_house_type_short IS 'Короткое название типа номера';


--
-- Name: COLUMN adr_house_type.kd_house_type_lvl; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_house_type.kd_house_type_lvl IS 'Уровень типа номера';


--
-- Name: COLUMN adr_house_type.dt_data_del; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.adr_house_type.dt_data_del IS 'Дата удаления';


--
-- Data for Name: adr_house_type; Type: TABLE DATA; Schema: gar_tmp; Owner: postgres
--

COPY gar_tmp.adr_house_type (id_house_type, nm_house_type, nm_house_type_short, kd_house_type_lvl, dt_data_del) FROM stdin;
1	Владение	вл.	1	\N
2	Дом	д.	1	\N
3	Домовладение	дв.	1	\N
4	Корпус	корп.	2	\N
5	Строение	стр.	3	\N
6	Сооружение	соор.	3	\N
7	Литер	литер	3	\N
8	Гараж	г-ж	1	\N
9	Здание	зд.	1	\N
10	Литера	литера	1	\N
\.


--
-- Name: adr_house_type adr_house_type_nm_house_type_key; Type: CONSTRAINT; Schema: gar_tmp; Owner: postgres
--

ALTER TABLE ONLY gar_tmp.adr_house_type
    ADD CONSTRAINT adr_house_type_nm_house_type_key UNIQUE (nm_house_type);


--
-- Name: adr_house_type adr_house_type_pkey; Type: CONSTRAINT; Schema: gar_tmp; Owner: postgres
--

ALTER TABLE ONLY gar_tmp.adr_house_type
    ADD CONSTRAINT adr_house_type_pkey PRIMARY KEY (id_house_type);


--
-- PostgreSQL database dump complete
--

