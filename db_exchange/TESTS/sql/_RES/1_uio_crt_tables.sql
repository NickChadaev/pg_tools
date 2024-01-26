-- =====================================================================
--  2023-04-06  Очередь событий.
--  2023-04-29  Модификация, наследование
--  2023-05-13  Модификация, 10+10
--  2023-11-23  Модификация, 20+10 (продолжение в "2_uio_crt_tables_2")
--  2023-12-14  Под авто-генерацию кода.
-- ====================================================================

DROP TABLE IF EXISTS uio.event CASCADE;
CREATE TABLE IF NOT EXISTS uio.event () INHERITS (pgq.event_template);

CREATE SEQUENCE IF NOT EXISTS uio.event_ev_id_seq START 1 OWNED BY uio.event.ev_id;  
ALTER TABLE uio.event ALTER COLUMN ev_id SET DEFAULT nextval('uio.event_ev_id_seq'::regclass); 
ALTER TABLE uio.event ALTER COLUMN ev_time SET DEFAULT now(); 

COMMENT ON TABLE uio.event IS 'Очередь заданий, прототип';

COMMENT ON COLUMN uio.event.ev_id     IS 'ID задания';
COMMENT ON COLUMN uio.event.ev_time   IS 'Время создания';
COMMENT ON COLUMN uio.event.ev_type   IS 'Тип задания';
COMMENT ON COLUMN uio.event.ev_data   IS 'Данные';
COMMENT ON COLUMN uio.event.ev_extra1 IS 'Дополнительные данные №1';
COMMENT ON COLUMN uio.event.ev_extra2 IS 'Дополнительные данные №2';
COMMENT ON COLUMN uio.event.ev_extra3 IS 'Дополнительные данные №3';
COMMENT ON COLUMN uio.event.ev_extra4 IS 'Дополнительные данные №4';
--
--
DROP TABLE IF EXISTS uio.event_parse CASCADE;
CREATE TABLE uio.event_parse () INHERITS (uio.event);
COMMENT ON TABLE uio.event_parse IS 'Очередь заданий на parsing';
--
-- SELECT * FROM uio.event_parse;
--
DROP TABLE IF EXISTS uio.event_proc CASCADE;
CREATE TABLE uio.event_proc () INHERITS (uio.event);
COMMENT ON TABLE uio.event_proc IS 'Очередь заданий на processing';
--
--SELECT * FROM uio.event_proc;
--
DROP TABLE IF EXISTS uio.event_last CASCADE;

CREATE TABLE uio.event_last () INHERITS (uio.event);
COMMENT ON TABLE uio.event_last IS 'Очередь результатов processing';
--
-- SELECT * FROM uio.event_last;
--
DROP TABLE IF EXISTS uio.event_first CASCADE;
CREATE TABLE uio.event_first () INHERITS (uio.event);
COMMENT ON TABLE uio.event_first IS 'Очередь начальная/Реестр заданий';
--
-- SELECT * FROM uio.event_first;
--
--
DROP TABLE IF EXISTS uio.event_p0 CASCADE;
CREATE TABLE uio.event_p0 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p0 IS 'Контекст workers p0';

--
DROP TABLE IF EXISTS uio.event_p1 CASCADE;
CREATE TABLE uio.event_p1 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p1 IS 'Контекст workers p1';

--
DROP TABLE IF EXISTS uio.event_p2 CASCADE;
CREATE TABLE uio.event_p2 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p2 IS 'Контекст workers p2';

--
DROP TABLE IF EXISTS uio.event_p3 CASCADE;
CREATE TABLE uio.event_p3 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p3 IS 'Контекст workers p3';

--
DROP TABLE IF EXISTS uio.event_p4 CASCADE;
CREATE TABLE uio.event_p4 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p4 IS 'Контекст workers p4';

--
DROP TABLE IF EXISTS uio.event_p5 CASCADE;
CREATE TABLE uio.event_p5 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p5 IS 'Контекст workers p5';

--
DROP TABLE IF EXISTS uio.event_p6 CASCADE;
CREATE TABLE uio.event_p6 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p6 IS 'Контекст workers p6';

--
DROP TABLE IF EXISTS uio.event_p7 CASCADE;
CREATE TABLE uio.event_p7 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p7 IS 'Контекст workers p7';

--
DROP TABLE IF EXISTS uio.event_p8 CASCADE;
CREATE TABLE uio.event_p8 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p8 IS 'Контекст workers p8';

--
DROP TABLE IF EXISTS uio.event_p9 CASCADE;
CREATE TABLE uio.event_p9 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p9 IS 'Контекст workers p9';

--
DROP TABLE IF EXISTS uio.event_p10 CASCADE;
CREATE TABLE uio.event_p10 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p10 IS 'Контекст workers p10';

--
DROP TABLE IF EXISTS uio.event_p11 CASCADE;
CREATE TABLE uio.event_p11 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p11 IS 'Контекст workers p11';

--
DROP TABLE IF EXISTS uio.event_p12 CASCADE;
CREATE TABLE uio.event_p12 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p12 IS 'Контекст workers p12';

--
DROP TABLE IF EXISTS uio.event_p13 CASCADE;
CREATE TABLE uio.event_p13 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p13 IS 'Контекст workers p13';

--
DROP TABLE IF EXISTS uio.event_p14 CASCADE;
CREATE TABLE uio.event_p14 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p14 IS 'Контекст workers p14';

--
DROP TABLE IF EXISTS uio.event_p15 CASCADE;
CREATE TABLE uio.event_p15 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p15 IS 'Контекст workers p15';

--
DROP TABLE IF EXISTS uio.event_p16 CASCADE;
CREATE TABLE uio.event_p16 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p16 IS 'Контекст workers p16';

--
DROP TABLE IF EXISTS uio.event_p17 CASCADE;
CREATE TABLE uio.event_p17 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p17 IS 'Контекст workers p17';

--
DROP TABLE IF EXISTS uio.event_p18 CASCADE;
CREATE TABLE uio.event_p18 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p18 IS 'Контекст workers p18';

--
DROP TABLE IF EXISTS uio.event_p19 CASCADE;
CREATE TABLE uio.event_p19 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p19 IS 'Контекст workers p19';

--
DROP TABLE IF EXISTS uio.event_r0 CASCADE;
CREATE TABLE uio.event_r0 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r0 IS 'Контекст workers r0';

--
DROP TABLE IF EXISTS uio.event_r1 CASCADE;
CREATE TABLE uio.event_r1 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r1 IS 'Контекст workers r1';

--
DROP TABLE IF EXISTS uio.event_r2 CASCADE;
CREATE TABLE uio.event_r2 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r2 IS 'Контекст workers r2';

--
DROP TABLE IF EXISTS uio.event_r3 CASCADE;
CREATE TABLE uio.event_r3 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r3 IS 'Контекст workers r3';

--
DROP TABLE IF EXISTS uio.event_r4 CASCADE;
CREATE TABLE uio.event_r4 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r4 IS 'Контекст workers r4';

--
DROP TABLE IF EXISTS uio.event_r5 CASCADE;
CREATE TABLE uio.event_r5 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r5 IS 'Контекст workers r5';

--
DROP TABLE IF EXISTS uio.event_r6 CASCADE;
CREATE TABLE uio.event_r6 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r6 IS 'Контекст workers r6';

--
DROP TABLE IF EXISTS uio.event_r7 CASCADE;
CREATE TABLE uio.event_r7 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r7 IS 'Контекст workers r7';

--
DROP TABLE IF EXISTS uio.event_r8 CASCADE;
CREATE TABLE uio.event_r8 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r8 IS 'Контекст workers r8';

--
DROP TABLE IF EXISTS uio.event_r9 CASCADE;
CREATE TABLE uio.event_r9 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r9 IS 'Контекст workers r9';

