-- ===================================================================
--  2023-04-06  Очередь событий.
--  2023-04-29  Модификация, наследование
--  2023-05-13  Модификация, 10+10
--  2023-11-23  Модификация, 20+10 (продолжение "2_uio_crt_tables_1")
-- ===================================================================
--
DROP TABLE IF EXISTS uio.event_p10 CASCADE;
CREATE TABLE uio.event_p10 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p10 IS 'Контекст workers P10';
--
-- SELECT * FROM uio.event_p10;
--
DROP TABLE IF EXISTS uio.event_p11 CASCADE;
CREATE TABLE uio.event_p11 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p11 IS 'Контекст workers P11';
--
-- SELECT * FROM uio.event_p11;
--
DROP TABLE IF EXISTS uio.event_p12 CASCADE;
CREATE TABLE uio.event_p12 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p12 IS 'Контекст workers P12';
--
-- SELECT * FROM uio.event_p12;
--
DROP TABLE IF EXISTS uio.event_p13 CASCADE;
CREATE TABLE uio.event_p13 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p13 IS 'Контекст workers P13';
--
-- SELECT * FROM uio.event_p13;
--
DROP TABLE IF EXISTS uio.event_p14 CASCADE;
CREATE TABLE uio.event_p14 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p14 IS 'Контекст workers P14';
--
-- SELECT * FROM uio.event_p14;
--
DROP TABLE IF EXISTS uio.event_p15 CASCADE;
CREATE TABLE uio.event_p15 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p15 IS 'Контекст workers P15';
--
-- SELECT * FROM uio.event_p15;
--
DROP TABLE IF EXISTS uio.event_p16 CASCADE;
CREATE TABLE uio.event_p16 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p16 IS 'Контекст workers P16';
--
-- SELECT * FROM uio.event_p16;
--
DROP TABLE IF EXISTS uio.event_p17 CASCADE;
CREATE TABLE uio.event_p17 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p17 IS 'Контекст workers P17';
--
-- SELECT * FROM uio.event_p17;
--
DROP TABLE IF EXISTS uio.event_p18 CASCADE;
CREATE TABLE uio.event_p18 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p18 IS 'Контекст workers P18';
--
-- SELECT * FROM uio.event_p18;
-- 
DROP TABLE IF EXISTS uio.event_p19 CASCADE;
CREATE TABLE uio.event_p19 () INHERITS (uio.event);
COMMENT ON TABLE uio.event_p19 IS 'Контекст workers P19';
--
-- SELECT * FROM uio.event_p19;
-- 
