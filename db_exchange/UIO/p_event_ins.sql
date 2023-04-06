DROP PROCEDURE IF EXISTS uio.p_event_ins (text, text, text, text, text, text, text);
CREATE OR REPLACE PROCEDURE uio.p_event_ins (      
     p_nm_queue   text     -- Имя очереди
    ,p_ev_type    text     -- Тип 
    ,p_ev_data    text     -- Данные
    ,p_ev_extra1  text     -- Доп данные #1
    ,p_ev_extra2  text     -- Доп данные #2
    ,p_ev_extra3  text     -- Доп данные #3
    ,p_ev_extra4  text     -- Доп данные #4
  )
	    LANGUAGE plpgsql
        SECURITY DEFINER
AS 
 $$
 -- ===========================================================
 --  2023-03-06 Макет, живёт пока не выяснятся USE CASE  pgq.
 -- ===========================================================
  BEGIN
    IF (p_nm_queue = 'QP') 
       THEN
           INSERT INTO uio.event_parse
           (    ev_type  
               ,ev_data 
               ,ev_extra1 
               ,ev_extra2 
               ,ev_extra3 
               ,ev_extra4 
           )
             VALUES ( p_ev_type  
                    , p_ev_data  
                    , p_ev_extra1
                    , p_ev_extra2
                    , p_ev_extra3
                    , p_ev_extra4 
            );
       
       ELSIF (p_nm_queue = 'QR')
         THEN
             INSERT INTO uio.event_proc
             (    ev_type  
                 ,ev_data 
                 ,ev_extra1 
                 ,ev_extra2 
                 ,ev_extra3 
                 ,ev_extra4 
             )
               VALUES ( p_ev_type  
                      , p_ev_data  
                      , p_ev_extra1
                      , p_ev_extra2
                      , p_ev_extra3
                      , p_ev_extra4 
              );
       ELSIF (p_nm_queue = 'QL')
         THEN
             INSERT INTO uio.event_log
             (    ev_type  
                 ,ev_data 
                 ,ev_extra1 
                 ,ev_extra2 
                 ,ev_extra3 
                 ,ev_extra4 
             )
               VALUES ( p_ev_type  
                      , p_ev_data  
                      , p_ev_extra1
                      , p_ev_extra2
                      , p_ev_extra3
                      , p_ev_extra4 
              );
              
    END IF;
  END;  
 $$;   
--
COMMENT ON PROCEDURE uio.p_event_ins (text, text, text, text, text, text, text) 
   IS  'МАКЕТ. Создать события в очередях';
-- USE CASE                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
--     CALL uio.p_event_ins ('QP', 'TP', 'DP', 'DP1', 'DP2', 'DP3', 'DP4');
--     CALL uio.p_event_ins ('QR', 'TR', 'DR', 'DR1', 'DR2', 'DR3', 'DR4');
--  SELECT * FROM uio.event_parse;
--  SELECT * FROM uio.event_proc;
