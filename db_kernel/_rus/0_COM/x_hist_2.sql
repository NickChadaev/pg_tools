--
--  2020-04-29 Nick  Тест на вложенное секционирование
--
DROP TABLE IF EXISTS com.all_log_1 CASCADE; 
CREATE TABLE com.all_log_1 (
   schema_name     public.t_sysname    NOT NULL,
   id_log          public.id_t	       NOT NULL  DEFAULT nextval('com.all_history_id_seq'::regclass), -- Общий счётчик
   impact_type     public.t_code1      NOT NULL,
   impact_date     public.t_timestamp  NOT NULL,
   impact_descr    public.t_text       NOT NULL,   -- Nick 2017-01-25
   user_name       public.t_str250     NOT NULL,
   host_name       public.t_str250       
 ) PARTITION BY LIST (schema_name);
--
ALTER TABLE com.all_log_1 ADD CONSTRAINT pk_all_log_1 
           PRIMARY KEY (schema_name, impact_date, impact_type, id_log);
 --
COMMENT ON TABLE com.all_log_1 IS 'Журнал регистрации операций и ошибок';

COMMENT ON COLUMN com.all_log_1.schema_name  IS 'Схема';
COMMENT ON COLUMN com.all_log_1.id_log       IS 'Идентификатор журнала';
COMMENT ON COLUMN com.all_log_1.impact_type  IS 'Тип воздействия';
COMMENT ON COLUMN com.all_log_1.impact_date  IS 'Дата воздействия';
COMMENT ON COLUMN com.all_log_1.impact_descr IS 'Описание воздействия';
COMMENT ON COLUMN com.all_log_1.user_name    IS 'Имя пользователя';
COMMENT ON COLUMN com.all_log_1.host_name    IS 'Имя хоста';
--
-- ALTER TABLE com.all_log_1 ADD CONSTRAINT ak1_all_log_1 UNIQUE (id_log);
CREATE INDEX ie2_all_log_1 ON com.all_log_1 ( user_name );
--   
CREATE TABLE com.com_log_1 PARTITION OF com.all_log_1 
    FOR VALUES IN ( 'com', 'com_codifier', 'com_domain', 'com_error', 'com_exchange'
                  , 'com_object', 'com_relation'
  )  PARTITION BY RANGE (impact_date);  
--
COMMENT ON TABLE com.com_log_1 IS 'Схема COM. Журнал регистрации операций и ошибок';
  --
CREATE TABLE com.com_log_1_19 PARTITION OF com.com_log_1
       FOR VALUES FROM ('2019-01-01 00:00:00') TO ('2019-12-31 23:58:50')
    PARTITION BY LIST (impact_type);   
COMMENT ON TABLE com.com_log_1_19 IS 'Схема COM. Журнал регистрации операций и ошибок. 2019 год';
--
CREATE TABLE com.com_log_1_20 PARTITION OF com.com_log_1
       FOR VALUES FROM ('2020-01-01 00:00:00') TO ('2020-12-31 23:58:50')
    PARTITION BY LIST (impact_type);
COMMENT ON TABLE com.com_log_1_20 IS 'Схема COM. Журнал регистрации операций и ошибок. 2020 год';
--      
CREATE TABLE com.com_log_1_19_op PARTITION OF com.com_log_1_19 
       FOR VALUES IN ('0','1','2','3','4','5','6','7','Q','8','9','A','B','C','D','E','F','G');
COMMENT ON TABLE com.com_log_1_19_op IS 'Схема COM. Журнал регистрации операций. 2019 год';
-- 
CREATE TABLE com.com_log_1_19_er PARTITION OF com.com_log_1_19 FOR VALUES IN ('!');
COMMENT ON TABLE com.com_log_1_19_er IS 'Схема COM. Журнал регистрации ошибок. 2019 год';
--      --
CREATE TABLE com.com_log_1_20_op PARTITION OF com.com_log_1_20 
       FOR VALUES IN ('0','1','2','3','4','5','6','7','Q','8','9','A','B','C','D','E','F','G');
COMMENT ON TABLE com.com_log_1_20_op IS 'Схема COM. Журнал регистрации операций. 2020 год';
       -- 
CREATE TABLE com.com_log_1_20_er PARTITION OF com.com_log_1_20 FOR VALUES IN ('!');
COMMENT ON TABLE com.com_log_1_20_er IS 'Схема COM. Журнал регистрации ошибок. 2020 год';
            
