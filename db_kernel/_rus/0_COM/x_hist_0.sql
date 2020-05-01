--
--  2020-04-29 Nick  Тест на вложенное секционирование
--
DROP TABLE IF EXISTS com.all_log_1 CASCADE; 
CREATE TABLE com.all_log_1 (
   schema_name     public.t_sysname    NOT NULL,
   table_name      public.t_sysname    NOT NULL,
   id_log          public.id_t	       NOT NULL  DEFAULT nextval('com.all_history_id_seq'::regclass), -- Общий счётчик
   user_name       public.t_str250     NOT NULL,
   host_name       public.t_str250     ,
   impact_type     public.t_code1      NOT NULL,
   impact_date     public.t_timestamp  NOT NULL,
   impact_descr    public.t_text       NOT NULL   -- Nick 2017-01-25
 ) PARTITION BY LIST (schema_name);
 --
 ALTER TABLE com.all_log_1 ADD CONSTRAINT pk_all_log_1 PRIMARY KEY (schema_name, table_name, id_log);
 --   
 CREATE TABLE com.com_log_1 PARTITION OF com.all_log_1 
    FOR VALUES IN ( 'com', 'com_codifier', 'com_domain', 'com_error', 'com_exchange'
                  , 'com_object', 'com_relation'
  )  PARTITION BY LIST (table_name) ;  
 --
 CREATE TABLE com.com_log_10 PARTITION OF com.com_log_1 
            FOR VALUES IN ('obj_codifier', 'nso_domain_column', 'sys_errors', 'obj_errors');
 --
 CREATE TABLE com.com_log_20 PARTITION OF com.com_log_1 FOR VALUES IN ('obj_object');
 CREATE TABLE com.com_log_21 PARTITION OF com.com_log_1 FOR VALUES IN ('');