DROP FUNCTION IF EXISTS uio.f_event_no_term (timestamp(0) WITHOUT TIME ZONE);
CREATE OR REPLACE FUNCTION uio.f_event_no_term (      
     p_ev_time  timestamp(0) WITHOUT TIME ZONE  DEFAULT now()-- время события
  )
    RETURNS TABLE (
                     ev_id     bigint   -- 'ID задания';
                    ,ev_time   timestamp(0) WITHOUT TIME ZONE-- 'Время создания';
                    ,ev_type   text -- 'Тип задания';
                    ,ev_data   text -- 'Данные';
                    ,ev_extra1 text -- 'Дополнительные данные №1';
                    ,ev_extra2 text -- 'Дополнительные данные №2';
                    ,ev_extra3 text -- 'Дополнительные данные №3';
                    ,ev_extra4 text -- 'Дополнительные данные №4';
    )
    LANGUAGE sql
    SECURITY DEFINER  

AS 
 $$
 -- =============================================================================
 --     2023-07-20  Изменено условие выборки событий, ожидающих обработки. 
 -- =============================================================================
       WITH z AS (
                  SELECT ev_type FROM uio.event_first WHERE (ev_time >= p_ev_time)
                    EXCEPT 	
                  SELECT ev_type FROM uio.event_last WHERE (ev_time >= p_ev_time) 
      )
          SELECT 
                   f.ev_id
                  ,f.ev_time 
                  ,f.ev_type  
                  ,f.ev_data 
                  ,f.ev_extra1 
                  ,f.ev_extra2 
                  ,f.ev_extra3 
                  ,f.ev_extra4

          FROM uio.event_first f 
                 INNER JOIN z ON (z.ev_type = f.ev_type);
 $$;   
--
COMMENT ON FUNCTION uio.f_event_no_term (timestamp(0) WITHOUT TIME ZONE) IS  'Список событий, ожидающих обработки';
-- USE CASE                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
--     SELECT * FROM  uio.f_event_no_term ('2023-07-18 13:30:00');
--     SELECT * FROM  uio.event_parse;
--     SELECT * FROM  uio.event_proc;
--     SELECT * FROM  uio.event_last;
--     UPDATE uio.event_last SET ev_extra4 = '+'
