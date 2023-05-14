-- =========================================
--  2023-04-06  Очередь событий.
--  2023-04-29  Модификация, наследование
--  2023-05-13  Модификация, 10+10
-- =========================================

DROP TABLE IF EXISTS uio.event CASCADE;
CREATE TABLE uio.event
(
     ev_id     bigserial NOT NULL
    ,ev_time   timestamp(0) WITHOUT TIME ZONE NOT NULL DEFAULT now()
    ,ev_type   text 
    ,ev_data   text 
    ,ev_extra1 text 
    ,ev_extra2 text 
    ,ev_extra3 text 
    ,ev_extra4 text 
);

COMMENT ON TABLE uio.event IS 'Очередь заданий, прототип - МАКЕТ';

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
DROP TABLE IF EXISTS uio.event_log CASCADE;
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
DROP TABLE IF EXISTS uio.event_p0 CASCADE;
CREATE TABLE uio.event_p0 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p0 IS 'Контекст workers P0';
--
-- SELECT * FROM uio.event_p0;
--
DROP TABLE IF EXISTS uio.event_p1 CASCADE;
CREATE TABLE uio.event_p1 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p1 IS 'Контекст workers P1';
--
-- SELECT * FROM uio.event_p1;
--
DROP TABLE IF EXISTS uio.event_p2 CASCADE;
CREATE TABLE uio.event_p2 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p2 IS 'Контекст workers P2';
--
-- SELECT * FROM uio.event_p2;
--
DROP TABLE IF EXISTS uio.event_p3 CASCADE;
CREATE TABLE uio.event_p3 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p3 IS 'Контекст workers P3';
--
-- SELECT * FROM uio.event_p3;
--
DROP TABLE IF EXISTS uio.event_p4 CASCADE;
CREATE TABLE uio.event_p4 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p4 IS 'Контекст workers P4';
--
-- SELECT * FROM uio.event_p4;
--
DROP TABLE IF EXISTS uio.event_p5 CASCADE;
CREATE TABLE uio.event_p5 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p5 IS 'Контекст workers P5';
--
-- SELECT * FROM uio.event_p5;
--
DROP TABLE IF EXISTS uio.event_p6 CASCADE;
CREATE TABLE uio.event_p6 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p6 IS 'Контекст workers P6';
--
-- SELECT * FROM uio.event_p6;
--
DROP TABLE IF EXISTS uio.event_p7 CASCADE;
CREATE TABLE uio.event_p7 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p7 IS 'Контекст workers P7';
--
-- SELECT * FROM uio.event_p7;
--
DROP TABLE IF EXISTS uio.event_p8 CASCADE;
CREATE TABLE uio.event_p8 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p8 IS 'Контекст workers P8';
--
-- SELECT * FROM uio.event_p8;
--
DROP TABLE IF EXISTS uio.event_p9 CASCADE;
CREATE TABLE uio.event_p9 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p9 IS 'Контекст workers P9';
--
-- SELECT * FROM uio.event_p9;
--
DROP TABLE IF EXISTS uio.event_r0 CASCADE;
CREATE TABLE uio.event_r0 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r0 IS 'Контекст workers R0';
--
-- SELECT * FROM uio.event_r0;
--
DROP TABLE IF EXISTS uio.event_r1 CASCADE;
CREATE TABLE uio.event_r1 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r1 IS 'Контекст workers R1';
--
-- SELECT * FROM uio.event_r1;
--
DROP TABLE IF EXISTS uio.event_r2 CASCADE;
CREATE TABLE uio.event_r2 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r2 IS 'Контекст workers R2';
--
-- SELECT * FROM uio.event_r2;
--
DROP TABLE IF EXISTS uio.event_r3 CASCADE;
CREATE TABLE uio.event_r3 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r3 IS 'Контекст workers R3';
--
-- SELECT * FROM uio.event_r3;
--
DROP TABLE IF EXISTS uio.event_r4 CASCADE;
CREATE TABLE uio.event_r4 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r4 IS 'Контекст workers R4';
--
-- SELECT * FROM uio.event_r4;
--
DROP TABLE IF EXISTS uio.event_r5 CASCADE;
CREATE TABLE uio.event_r5 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r5 IS 'Контекст workers R5';
--
-- SELECT * FROM uio.event_r5;
--
DROP TABLE IF EXISTS uio.event_r6 CASCADE;
CREATE TABLE uio.event_r6 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r6 IS 'Контекст workers R6';
--
-- SELECT * FROM uio.event_r6;
--
DROP TABLE IF EXISTS uio.event_r7 CASCADE;
CREATE TABLE uio.event_r7 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r7 IS 'Контекст workers R7';
--
-- SELECT * FROM uio.event_r7;
--
DROP TABLE IF EXISTS uio.event_r8 CASCADE;
CREATE TABLE uio.event_r8 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r8 IS 'Контекст workers R8';
--
-- SELECT * FROM uio.event_r8;
--
DROP TABLE IF EXISTS uio.event_r9 CASCADE;
CREATE TABLE uio.event_r9 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_r9 IS 'Контекст workers R9';
--
-- SELECT * FROM uio.event_r9;
--

