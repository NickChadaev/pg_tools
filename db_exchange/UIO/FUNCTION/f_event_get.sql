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
 -- ===========================================================
 --  2023-03-06 Макет, живёт пока не выяснятся USE CASE  pgq.
 --  2023-04-28  Далее.
 --  2023-05-15  Topic 10+10
 -- =========================================================== 
  DECLARE
   
   _exec text;
   _select text = $_$

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
                      FROM %s p ORDER BY p.ev_id  LIMIT 1
                      FOR UPDATE
                  
          ), z20 AS (
                     DELETE FROM %s AS x USING z10
                         WHERE (x.ev_id = z10.ev_id)
                     RETURNING *                
                   )
                      SELECT * FROM z20; 
   $_$;
   
   cPARSE CONSTANT text = 'uio.event_parse';
   cPROC  CONSTANT text = 'uio.event_proc';
   
   cP0 CONSTANT text = 'uio.event_p0';
   cP1 CONSTANT text = 'uio.event_p1';
   cP2 CONSTANT text = 'uio.event_p2';
   cP3 CONSTANT text = 'uio.event_p3';
   cP4 CONSTANT text = 'uio.event_p4';
   cP5 CONSTANT text = 'uio.event_p5';
   cP6 CONSTANT text = 'uio.event_p6';
   cP7 CONSTANT text = 'uio.event_p7';
   cP8 CONSTANT text = 'uio.event_p8';
   cP9 CONSTANT text = 'uio.event_p9';
   
   cR0 CONSTANT text = 'uio.event_r0';
   cR1 CONSTANT text = 'uio.event_r1';
   cR2 CONSTANT text = 'uio.event_r2';
   cR3 CONSTANT text = 'uio.event_r3';
   cR4 CONSTANT text = 'uio.event_r4';
   cR5 CONSTANT text = 'uio.event_r5';
   cR6 CONSTANT text = 'uio.event_r6';
   cR7 CONSTANT text = 'uio.event_r7';
   cR8 CONSTANT text = 'uio.event_r8';
   cR9 CONSTANT text = 'uio.event_r9';
   
   
  BEGIN
    CASE p_nm_queue
    
       -- queue 
    
       WHEN 'QP' THEN  _exec = format (_select, cPARSE, cPARSE);            
       WHEN 'QR' THEN  _exec = format (_select, cPROC, cPROC);            

       -- contexts     
            
       WHEN 'QP0' THEN _exec = format (_select, cP0, cP0);            
       WHEN 'QP1' THEN _exec = format (_select, cP1, cP1);            
       WHEN 'QP2' THEN _exec = format (_select, cP2, cP2);            
       WHEN 'QP3' THEN _exec = format (_select, cP3, cP3);            
       WHEN 'QP4' THEN _exec = format (_select, cP4, cP4);            
       WHEN 'QP5' THEN _exec = format (_select, cP5, cP5);            
       WHEN 'QP6' THEN _exec = format (_select, cP6, cP6);            
       WHEN 'QP7' THEN _exec = format (_select, cP7, cP7);            
       WHEN 'QP8' THEN _exec = format (_select, cP8, cP8);            
       WHEN 'QP9' THEN _exec = format (_select, cP9, cP9);            
       
       WHEN 'QR0' THEN _exec = format (_select, cR0, cR0);            
       WHEN 'QR1' THEN _exec = format (_select, cR1, cR1);            
       WHEN 'QR2' THEN _exec = format (_select, cR2, cR2);            
       WHEN 'QR3' THEN _exec = format (_select, cR3, cR3);            
       WHEN 'QR4' THEN _exec = format (_select, cR4, cR4);            
       WHEN 'QR5' THEN _exec = format (_select, cR5, cR5);            
       WHEN 'QR6' THEN _exec = format (_select, cR6, cR6);            
       WHEN 'QR7' THEN _exec = format (_select, cR7, cR7);            
       WHEN 'QR8' THEN _exec = format (_select, cR8, cR8);            
       WHEN 'QR9' THEN _exec = format (_select, cR9, cR9);            

       
    END CASE;
   
    EXECUTE _exec INTO  ev_id     
                       ,ev_time   
                       ,ev_type   
                       ,ev_data   
                       ,ev_extra1 
                       ,ev_extra2 
                       ,ev_extra3 
                       ,ev_extra4;
                         
    RETURN NEXT;
    
  END;  
 $$;   
--
COMMENT ON FUNCTION uio.f_event_get (text, text) IS  'МАКЕТ. Взять одно событие из очереди';
-- USE CASE                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
--     SELECT * FROM  uio.f_event_get ('QP', 'TP');
--     SELECT * FROM  uio.f_event_get ('QR', 'xx');
--  SELECT * FROM uio.event_parse;
--  SELECT * FROM uio.event_proc;
