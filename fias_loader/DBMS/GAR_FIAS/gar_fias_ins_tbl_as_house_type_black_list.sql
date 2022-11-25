--
-- PostgreSQL database dump
--

-- Dumped from database version 13.9 (Ubuntu 13.9-1.pgdg18.04+1)
-- Dumped by pg_dump version 13.9 (Ubuntu 13.9-1.pgdg18.04+1)

-- Started on 2022-11-21 12:02:45 MSK

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
-- TOC entry 3652 (class 0 OID 116159)
-- Dependencies: 350
-- Data for Name: as_house_type_black_list; Type: TABLE DATA; Schema: gar_fias; Owner: postgres
--

INSERT INTO gar_fias.as_house_type_black_list (house_type_id, type_name, type_shortname, type_descr, update_date, start_date, end_date, is_active, fias_row_key) VALUES (6, 'Шахта', 'шахта', 'Шахта', '1900-01-01', '1900-01-01', '2079-06-06', true, 'шахта');
INSERT INTO gar_fias.as_house_type_black_list (house_type_id, type_name, type_shortname, type_descr, update_date, start_date, end_date, is_active, fias_row_key) VALUES (11, 'Подвал', 'подв.', 'Подвал', '1900-01-01', '1900-01-01', '2015-11-05', false, 'подвал');
INSERT INTO gar_fias.as_house_type_black_list (house_type_id, type_name, type_shortname, type_descr, update_date, start_date, end_date, is_active, fias_row_key) VALUES (12, 'Котельная', 'кот.', 'Котельная', '1900-01-01', '1900-01-01', '2015-11-05', false, 'котельная');
INSERT INTO gar_fias.as_house_type_black_list (house_type_id, type_name, type_shortname, type_descr, update_date, start_date, end_date, is_active, fias_row_key) VALUES (13, 'Погреб', 'п-б', 'Погреб', '1900-01-01', '1900-01-01', '2015-11-05', false, 'погреб');
INSERT INTO gar_fias.as_house_type_black_list (house_type_id, type_name, type_shortname, type_descr, update_date, start_date, end_date, is_active, fias_row_key) VALUES (14, 'Объект незавершенного строительства', 'ОНС', 'Объект незавершенного строительства', '1900-01-01', '1900-01-01', '2015-11-05', false, 'объектнезавершенногостроительства');


-- Completed on 2022-11-21 12:02:47 MSK

--
-- PostgreSQL database dump complete
--

