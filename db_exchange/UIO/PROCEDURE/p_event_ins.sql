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
 --  2023-04-28  Далее.
 --  2023-05-15  Topic 10+10
 --  2023-11-23  Topic 20+10 
 -- ===========================================================
  DECLARE
  
    cFIRST CONSTANT text = 'uio.event_first';
    cLAST  CONSTANT text = 'uio.event_last';
  
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
    --
    -- Next 2023-11-23
    --
    cP10 CONSTANT text = 'uio.event_p10';
    cP11 CONSTANT text = 'uio.event_p11';
    cP12 CONSTANT text = 'uio.event_p12';
    cP13 CONSTANT text = 'uio.event_p13';
    cP14 CONSTANT text = 'uio.event_p14';
    cP15 CONSTANT text = 'uio.event_p15';
    cP16 CONSTANT text = 'uio.event_p16';
    cP17 CONSTANT text = 'uio.event_p17';
    cP18 CONSTANT text = 'uio.event_p18';
    cP19 CONSTANT text = 'uio.event_p19';
    --
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
  
    _exec  text;
 
    _insert text = $_$
    
           INSERT INTO %s
           (                ev_type  
                           ,ev_data 
                           ,ev_extra1 
                           ,ev_extra2 
                           ,ev_extra3 
                           ,ev_extra4 
           )
             VALUES ( %L
                    , %L
                    , %L
                    , %L
                    , %L
                    , %L 
            );
    $_$;
    
  BEGIN
  
   CASE p_nm_queue
      -- queue 
      WHEN 'QF' THEN  _exec = format(_insert, cFIRST, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QL' THEN  _exec = format(_insert, cLAST, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
   
      WHEN 'QP' THEN  _exec = format(_insert, cPARSE, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QR' THEN  _exec = format(_insert, cPROC, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            

      -- contexts     
           
      WHEN 'QP0' THEN _exec = format(_insert, cP0, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP1' THEN _exec = format(_insert, cP1, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP2' THEN _exec = format(_insert, cP2, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP3' THEN _exec = format(_insert, cP3, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP4' THEN _exec = format(_insert, cP4, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP5' THEN _exec = format(_insert, cP5, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP6' THEN _exec = format(_insert, cP6, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP7' THEN _exec = format(_insert, cP7, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP8' THEN _exec = format(_insert, cP8, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP9' THEN _exec = format(_insert, cP9, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      --
      -- 2023-11-23
      --
      WHEN 'QP10' THEN _exec = format(_insert, cP10, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP11' THEN _exec = format(_insert, cP11, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP12' THEN _exec = format(_insert, cP12, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP13' THEN _exec = format(_insert, cP13, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP14' THEN _exec = format(_insert, cP14, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP15' THEN _exec = format(_insert, cP15, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP16' THEN _exec = format(_insert, cP16, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP17' THEN _exec = format(_insert, cP17, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP18' THEN _exec = format(_insert, cP18, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QP19' THEN _exec = format(_insert, cP19, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      --
      WHEN 'QR0' THEN _exec = format(_insert, cR0, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QR1' THEN _exec = format(_insert, cR1, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QR2' THEN _exec = format(_insert, cR2, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QR3' THEN _exec = format(_insert, cR3, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QR4' THEN _exec = format(_insert, cR4, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QR5' THEN _exec = format(_insert, cR5, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QR6' THEN _exec = format(_insert, cR6, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QR7' THEN _exec = format(_insert, cR7, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QR8' THEN _exec = format(_insert, cR8, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
      WHEN 'QR9' THEN _exec = format(_insert, cR9, p_ev_type, p_ev_data, p_ev_extra1, p_ev_extra2, p_ev_extra3, p_ev_extra4);            
           
   END CASE;
    
   EXECUTE (_exec); 
   
  END;  
 $$;   
--
COMMENT ON PROCEDURE uio.p_event_ins (text, text, text, text, text, text, text) 
   IS  'Создать события в очередях';
-- USE CASE                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
--     CALL uio.p_event_ins ('QP', 'TP', 'DP', 'DP1', 'DP2', 'DP3', 'DP4');
--     CALL uio.p_event_ins ('QR', 'TR', 'DR', 'DR1', 'DR2', 'DR3', 'DR4');
--  SELECT * FROM uio.event_parse;
--  SELECT * FROM uio.event_proc;
