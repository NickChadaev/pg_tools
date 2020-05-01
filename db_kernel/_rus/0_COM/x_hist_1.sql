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
           PRIMARY KEY (schema_name, id_log, impact_type, impact_date);
 --   
 CREATE TABLE com.com_log_1 PARTITION OF com.all_log_1 
    FOR VALUES IN ( 'com', 'com_codifier', 'com_domain', 'com_error', 'com_exchange'
                  , 'com_object', 'com_relation'
  )  PARTITION BY LIST (impact_type) ;  
 --
 CREATE TABLE com.com_log_1_op PARTITION OF com.com_log_1
            FOR VALUES IN ('0','1','2','3','4','5','6','7','Q','8','9','A','B','C','D','E','F','G')
       PARTITION BY RANGE (impact_date);
  
 CREATE TABLE com.com_log_1_er PARTITION OF com.com_log_1 FOR VALUES IN ('!')
       PARTITION BY RANGE (impact_date);
 -- 
 CREATE TABLE com.com_log_19_op PARTITION OF com.com_log_1_op 
            FOR VALUES FROM ('2019-01-01 00:00:00') TO ('2019-12-31 23:58:50');
 --
 CREATE TABLE com.com_log_19_er PARTITION OF com.com_log_1_er 
            FOR VALUES FROM ('2019-01-01 00:00:00') TO ('2019-12-31 23:58:50');

 CREATE TABLE com.com_log_20_op PARTITION OF com.com_log_1_op 
            FOR VALUES FROM ('2020-01-01 00:00:00') TO ('2020-12-31 23:58:50');
 --
 CREATE TABLE com.com_log_20_er PARTITION OF com.com_log_1_er
             FOR VALUES FROM ('2020-01-01 00:00:00') TO ('2020-12-31 23:58:50');
