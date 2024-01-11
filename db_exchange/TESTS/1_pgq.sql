CREATE SCHEMA IF NOT EXISTS pgq;
COMMENT ON SCHEMA pgq IS 'The queue simplest functions'; 

CREATE TABLE pgq.queue
(
     queue_id serial
    ,queue_name text UNIQUE NOT NULL  
);

ALTER TABLE pgq.queue ADD CONSTRAINT pk_queue PRIMARY KEY (queue_id);
COMMENT ON TABLE pgq.queue IS 'Простейшая реализация очереди';

CREATE TABLE pgq.event 
(
     ev_id     bigserial
    ,ev_time   timestamp with time zone NOT NULL DEFAULT now()
    ,ev_txid   bigint NOT NULL DEFAULT txid_current()
    ,ev_owner  integer
    ,ev_retry  integer
    ,ev_type   text     -- Тип сообщения 1
    ,ev_data   text     -- Payload
    ,ev_extra1 text     -- Получатель (список)
    ,ev_extra2 text     -- Тип сообщения 2
    ,ev_extra3 text     -- Тип сообщения 3
    ,ev_extra4 text     -- ??? 
);
COMMENT ON TABLE pgq.event IS 'События  в очереди';

ALTER TABLE pgq.event ADD CONSTRAINT fk_queue_has_events 
   FOREIGN KEY (ev_owner) REFERENCES pgq.queue (queue_id ); 

--  Соглашение о типах -----
--   ,ev_type   text -- Тип сообщения 1      Данные/Уведомление о получении  (DATA/NOTIFICATION)
--   ,ev_data   text -- Payload              Нагрузка (только при пересылке данных)
--   ,ev_extra1 text -- Получатель (список)  Список, имена сервисов
--   ,ev_extra2 text -- Тип сообщения 2      Обращение к функции-обрабочику
--   ,ev_extra3 text -- Тип сообщения 3      XML/JSON/RECORD/ARRAY - любой структурированный тип
--

--    ,ev_extra4 text    -- ??? 


   
 
