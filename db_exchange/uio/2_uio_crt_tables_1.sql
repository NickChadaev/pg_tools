DROP TABLE IF EXISTS uio.event_parse CASCADE;
CREATE TABLE uio.event_parse
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

COMMENT ON TABLE uio.event_parse IS 'Очередь заданий на parsing';

COMMENT ON COLUMN uio.event_parse.ev_id     IS 'ID задания';
COMMENT ON COLUMN uio.event_parse.ev_time   IS 'Время создания';
COMMENT ON COLUMN uio.event_parse.ev_type   IS 'Тип задания';
COMMENT ON COLUMN uio.event_parse.ev_data   IS 'Данные';
COMMENT ON COLUMN uio.event_parse.ev_extra1 IS 'Дополнительные данные №1';
COMMENT ON COLUMN uio.event_parse.ev_extra2 IS 'Дополнительные данные №2';
COMMENT ON COLUMN uio.event_parse.ev_extra3 IS 'Дополнительные данные №3';
COMMENT ON COLUMN uio.event_parse.ev_extra4 IS 'Дополнительные данные №4';
--
--SELECT * FROM uio.event_parse;
--
DROP TABLE IF EXISTS uio.event_proc CASCADE;
CREATE TABLE uio.event_proc
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

COMMENT ON TABLE uio.event_proc IS 'Очередь заданий на processing';

COMMENT ON COLUMN uio.event_proc.ev_id     IS 'ID задания';
COMMENT ON COLUMN uio.event_proc.ev_time   IS 'Время создания';
COMMENT ON COLUMN uio.event_proc.ev_type   IS 'Тип задания';
COMMENT ON COLUMN uio.event_proc.ev_data   IS 'Данные';
COMMENT ON COLUMN uio.event_proc.ev_extra1 IS 'Дополнительные данные №1';
COMMENT ON COLUMN uio.event_proc.ev_extra2 IS 'Дополнительные данные №2';
COMMENT ON COLUMN uio.event_proc.ev_extra3 IS 'Дополнительные данные №3';
COMMENT ON COLUMN uio.event_proc.ev_extra4 IS 'Дополнительные данные №4';

DROP TABLE IF EXISTS uio.event_log CASCADE;
CREATE TABLE uio.event_log
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

COMMENT ON TABLE uio.event_log IS 'Очередь результатов processing';

COMMENT ON COLUMN uio.event_log.ev_id     IS 'ID результата';
COMMENT ON COLUMN uio.event_log.ev_time   IS 'Время создания';
COMMENT ON COLUMN uio.event_log.ev_type   IS 'Тип результата';
COMMENT ON COLUMN uio.event_log.ev_data   IS 'Данные';
COMMENT ON COLUMN uio.event_log.ev_extra1 IS 'Дополнительные данные №1';
COMMENT ON COLUMN uio.event_log.ev_extra2 IS 'Дополнительные данные №2';
COMMENT ON COLUMN uio.event_log.ev_extra3 IS 'Дополнительные данные №3';
COMMENT ON COLUMN uio.event_log.ev_extra4 IS 'Дополнительные данные №4';
