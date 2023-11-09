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
-- Name: xxx_object_type_alias; Type: TABLE; Schema: gar_tmp; Owner: postgres
--

CREATE TABLE gar_tmp.xxx_object_type_alias (
    id_object_type integer NOT NULL,
    fias_row_key text NOT NULL,
    object_kind character(1) DEFAULT '0'::bpchar NOT NULL,
    CONSTRAINT chk_xxx_object_type_alias_object_kind CHECK (((object_kind = '0'::bpchar) OR (object_kind = '1'::bpchar) OR (object_kind = '2'::bpchar)))
);


ALTER TABLE gar_tmp.xxx_object_type_alias OWNER TO postgres;

--
-- Name: TABLE xxx_object_type_alias; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON TABLE gar_tmp.xxx_object_type_alias IS 'Таблица псевдонимов для адресных объектов';


--
-- Name: COLUMN xxx_object_type_alias.id_object_type; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.xxx_object_type_alias.id_object_type IS 'ID типа субъекта (псевдоним)';


--
-- Name: COLUMN xxx_object_type_alias.fias_row_key; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.xxx_object_type_alias.fias_row_key IS 'Текстовый ключ строки';


--
-- Name: COLUMN xxx_object_type_alias.object_kind; Type: COMMENT; Schema: gar_tmp; Owner: postgres
--

COMMENT ON COLUMN gar_tmp.xxx_object_type_alias.object_kind IS 'Вид объекта: 0-адресные пространства, 1-улицы, 2 - Дома.';


--
-- Data for Name: xxx_object_type_alias; Type: TABLE DATA; Schema: gar_tmp; Owner: postgres
--

COPY gar_tmp.xxx_object_type_alias (id_object_type, fias_row_key, object_kind) FROM stdin;
41	чувашия	0
\.


--
-- Name: xxx_object_type_alias pk_xxx_object_type_alias; Type: CONSTRAINT; Schema: gar_tmp; Owner: postgres
--

ALTER TABLE ONLY gar_tmp.xxx_object_type_alias
    ADD CONSTRAINT pk_xxx_object_type_alias PRIMARY KEY (fias_row_key);


--
-- PostgreSQL database dump complete
--

