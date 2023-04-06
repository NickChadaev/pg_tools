DROP FUNCTION IF EXISTS uio.f_event_get (text, text);
CREATE OR REPLACE FUNCTION uio.f_event_get (      
     p_nm_queue    text    -- Имя очереди
    ,p_nm_consumer text    -- Подписчик
    ,OUT ev_id         bigint  -- ID события
    ,OUT ev_time      timestamp(0) WITHOUT TIME ZONE  -- время события
    ,OUT ev_type    text     -- Тип 
    ,OUT ev_data    text     -- Данные
    ,OUT ev_extra1  text     -- Доп данные #1
    ,OUT ev_extra2  text     -- Доп данные #2
    ,OUT ev_extra3  text     -- Доп данные #3
    ,OUT ev_extra4  text     -- Доп данные #4
  )
    RETURNS setof record  
    LANGUAGE plpgsql
    SECURITY DEFINER  

AS 
 $$
  BEGIN
    IF (p_nm_queue = 'QP') 
       THEN
        WITH z10 AS (
                      SELECT
                           p.ev_id
                          ,p.ev_time 
                          ,p.ev_type  
                          ,p.ev_data 
                          ,p.ev_extra1 
                          ,p.ev_extra2 
                          ,p.ev_extra3 
                          ,p.ev_extra4
                      FROM uio.event_parse p ORDER BY p.ev_id  LIMIT 1
                      FOR UPDATE
                  
          ), z20 AS (
                     DELETE FROM uio.event_parse AS x USING z10
                         WHERE (x.ev_id = z10.ev_id)
                     RETURNING *                
                   )
                      SELECT * FROM z20 
                          INTO  ev_id     
                               ,ev_time   
                               ,ev_type   
                               ,ev_data   
                               ,ev_extra1 
                               ,ev_extra2 
                               ,ev_extra3 
                               ,ev_extra4;
             RETURN NEXT;                  
       
       ELSIF (p_nm_queue = 'QR')
         THEN
             WITH z11 AS (
                           SELECT
                                r.ev_id
                               ,r.ev_time 
                               ,r.ev_type  
                               ,r.ev_data 
                               ,r.ev_extra1 
                               ,r.ev_extra2 
                               ,r.ev_extra3 
                               ,r.ev_extra4
                           FROM uio.event_proc r ORDER BY r.ev_id  LIMIT 1
                           FOR UPDATE
                       
               ), z21 AS (
                          DELETE FROM uio.event_proc AS x USING z11
                              WHERE (x.ev_id = z11.ev_id)
                          RETURNING *                
                        )
                           SELECT * FROM z21 
                               INTO  ev_id     
                                    ,ev_time   
                                    ,ev_type   
                                    ,ev_data   
                                    ,ev_extra1 
                                    ,ev_extra2 
                                    ,ev_extra3 
                                    ,ev_extra4;
                  RETURN NEXT;                  
    END IF;
  END;  
 $$;   
--
COMMENT ON FUNCTION uio.f_event_get (text, text) IS  'МАКЕТ. Взять одно событие из очереди';
-- USE CASE                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
--     SELECT * FROM  uio.f_event_get ('QP', 'TP');
--     SELECT * FROM  uio.f_event_get ('QR', 'xx');
--  SELECT * FROM uio.event_parse;
--  SELECT * FROM uio.event_proc;
