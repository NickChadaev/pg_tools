--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 13.11 (Ubuntu 13.11-1.pgdg18.04+1)

-- Started on 2023-07-31 14:38:06 MSK

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
-- TOC entry 602 (class 1259 OID 2121262)
-- Name: _xxx; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._xxx (
    id_receipt bigint,
    id_pay bigint,
    rcp_type integer,
    dt_create timestamp(0) with time zone,
    rcp_status integer,
    rcp_nmb text
);


ALTER TABLE public._xxx OWNER TO postgres;

--
-- TOC entry 5046 (class 0 OID 2121262)
-- Dependencies: 602
-- Data for Name: _xxx; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733557, 382322, 0, '2023-05-13 00:00:00+03', 0, 'a8c63070-b8f7-429d-a494-710d7fee87e0');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733558, 663415, 0, '2023-05-13 00:00:00+03', 0, '056771fa-5daa-49f1-b0bb-384ba401b512');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733559, 11535, 0, '2023-05-13 00:00:00+03', 0, 'a6d75a34-8233-40c6-8fb5-39f6e4baf195');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733560, 123641, 0, '2023-05-13 00:00:00+03', 0, 'decdd967-790e-49da-85dc-49bb6ad5eddf');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733561, 876265, 0, '2023-05-12 00:00:00+03', 0, '3ad2e7c8-c75c-4190-be08-b083963455b3');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733562, 724025, 0, '2023-05-12 00:00:00+03', 0, 'e89d4d33-21ef-4128-ad9a-a45ee0316973');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733563, 376218, 0, '2023-05-13 00:00:00+03', 0, 'fb7a7b23-0c14-469f-8068-1b45b945ff94');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733564, 588784, 0, '2023-05-13 00:00:00+03', 0, '392d5635-808d-4994-8fe6-39763c809f4a');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733565, 714823, 0, '2023-05-12 00:00:00+03', 0, 'e691b59e-b82e-4642-b4bc-e3ba485fdcc1');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733566, 480802, 0, '2023-05-13 00:00:00+03', 0, '2f068bb4-2794-4963-ab0d-83a08dfb0f00');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733567, 140503, 0, '2023-05-12 00:00:00+03', 0, 'f510abd4-4704-45d2-8f80-fd2bfb1d5896');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733569, 158001, 0, '2023-05-13 00:00:00+03', 0, '476ccea5-c6ca-407d-8620-d7a000da4013');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733570, 805230, 0, '2023-05-13 00:00:00+03', 0, '09342e56-7a04-4e0b-9fd9-5309e8e357cb');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733571, 40364, 0, '2023-05-13 00:00:00+03', 0, '0294f4bc-8a21-4347-af4b-e0e445ac28ed');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733573, 302732, 0, '2023-05-12 00:00:00+03', 0, '1aa19c05-b59b-4d59-baa2-262adc5db678');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733574, 327453, 0, '2023-05-13 00:00:00+03', 0, '9cd3ffc2-f4c6-48d3-9fad-1f3d765a4772');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733576, 422713, 0, '2023-05-13 00:00:00+03', 0, '703db9d0-52b6-456e-8808-d99c66d29212');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733577, 537827, 0, '2023-05-13 00:00:00+03', 0, '987e29e7-f4ba-48aa-a596-3f5eb2bdaa20');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733578, 705473, 0, '2023-05-13 00:00:00+03', 0, '2e91c07e-f6e6-49b2-97e9-524e5955fe4f');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733579, 411185, 0, '2023-05-12 00:00:00+03', 0, '7b7d9867-c88f-46bb-ade3-e93d861103f3');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733580, 506321, 0, '2023-05-13 00:00:00+03', 0, 'b3884899-4221-4eac-ae29-837b34748e6e');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733581, 422570, 0, '2023-05-13 00:00:00+03', 0, '5f0ba8f2-f3f6-4c9e-a180-9b26d8c136bc');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733582, 357211, 0, '2023-05-13 00:00:00+03', 0, 'e45481ac-3697-446d-a1f1-69054aaa5ba8');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733583, 504336, 0, '2023-05-13 00:00:00+03', 0, 'b3be724c-67a4-4b5f-bfe7-528243c3d597');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733584, 861442, 0, '2023-05-12 00:00:00+03', 0, 'f0b7b630-4bc3-4b2e-a23a-13d6a93150d6');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733585, 356016, 0, '2023-05-13 00:00:00+03', 0, 'c207a288-98d1-4a7f-b42d-aaa042a3a3c3');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733586, 72277, 0, '2023-05-12 00:00:00+03', 0, 'f24aae9a-74c1-4a00-b127-503a1955d945');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733587, 640612, 0, '2023-05-13 00:00:00+03', 0, '24e31772-4930-40e6-887d-f1c942e1e4da');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733588, 426262, 0, '2023-05-13 00:00:00+03', 0, 'd712ae6d-30b0-4438-8715-8c2616fea6ab');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733589, 751501, 0, '2023-05-13 00:00:00+03', 0, '6af326b2-e6af-4664-be2a-339f281ac21d');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733590, 849559, 0, '2023-05-13 00:00:00+03', 0, '01e09198-599a-4c5c-987d-1031663b9384');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733591, 917969, 0, '2023-05-13 00:00:00+03', 0, '320aafd4-e484-43d8-8135-959f6d98b54f');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733592, 383885, 0, '2023-05-13 00:00:00+03', 0, '5ea319c4-5fdc-48d3-848b-e7f8487aefd3');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733593, 240427, 0, '2023-05-13 00:00:00+03', 0, '87b67b6b-283b-4615-93fb-1927ac89a541');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733594, 907910, 0, '2023-05-13 00:00:00+03', 0, '33e88f6e-ffb2-4585-a293-e16813382327');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733595, 587270, 0, '2023-05-13 00:00:00+03', 0, '2f942d9c-5937-43e8-ae2d-312bcc269766');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733596, 479458, 0, '2023-05-13 00:00:00+03', 0, 'd3f4ac3c-e266-4d64-9dae-2b62cc6e6013');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733597, 33595, 0, '2023-05-13 00:00:00+03', 0, '08af453c-f831-4c45-a03e-152bb34c0a25');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733598, 896299, 0, '2023-05-13 00:00:00+03', 0, '18c698d9-73a5-4b68-82db-3ea976645a49');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733599, 335728, 0, '2023-05-13 00:00:00+03', 0, '76854611-d0f2-47eb-b6df-9437f93fd9bf');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733601, 755454, 0, '2023-05-13 00:00:00+03', 0, '40dc6b92-5dd9-4908-a868-4d5a84c3ed03');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733603, 118144, 0, '2023-05-13 00:00:00+03', 0, 'dcd70b88-9944-4fc5-9179-bb62bb27178f');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733604, 832613, 0, '2023-05-13 00:00:00+03', 0, '854fdb40-2b7f-457b-be6d-989086210690');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733605, 474134, 0, '2023-05-13 00:00:00+03', 0, '04561624-2049-47d5-932b-a14156144e6d');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733606, 327442, 0, '2023-05-13 00:00:00+03', 0, 'abd80cf8-be12-4b6b-abf9-c3fda71ce3c7');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733607, 998253, 0, '2023-05-13 00:00:00+03', 0, '74dd9be7-d276-4b9b-bc54-1cb6822bd6c5');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733608, 32319, 0, '2023-05-13 00:00:00+03', 0, 'aa6d66a6-55a0-418c-b82c-01b0529bff17');
INSERT INTO public._xxx (id_receipt, id_pay, rcp_type, dt_create, rcp_status, rcp_nmb) VALUES (8557733609, 138889, 0, '2023-05-13 00:00:00+03', 0, '42a583eb-1744-4e7e-882e-d5721b86fddc');


-- Completed on 2023-07-31 14:38:14 MSK

--
-- PostgreSQL database dump complete
--

