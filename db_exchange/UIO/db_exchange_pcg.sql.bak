
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Версия пакета. Дата общей сборки, либо последняя дата обновления.
--
CREATE OR REPLACE VIEW uio.version
 AS
 SELECT '$Revision:00de437$ modified $RevDate:2023-05-15$'::text AS version; 
                   

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/*================================================================================== */
/* DBMS name:  PostgreSQL 13                                                         */
/* Created on: 27.10.2020 15:55:11 Всё по новой, от прежней UIO не остаётся ничего.  */
/* 2023-05-13  10+10                                                                 */
/*===================================================================================*/

DROP VIEW IF EXISTS uio.v_workers_context CASCADE; 
CREATE VIEW uio.v_workers_context 
  AS 
     SELECT 
            'p0' AS proc_name
          , 'parsing 0' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_p0
	
	UNION 
	
     SELECT 
            'p1' AS proc_name
          , 'parsing 1' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_p1
	
	UNION 
	
     SELECT 
            'p2' AS proc_name
          , 'parsing 2' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_p2
	
	UNION 

     SELECT 
            'p3' AS proc_name
          , 'parsing 3' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_p3
	
	UNION 
	
     SELECT 
            'p4' AS proc_name
          , 'parsing 4' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_p4
	
	UNION 

     SELECT 
            'p5' AS proc_name
          , 'parsing 5' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_p5

    UNION 

     SELECT 
            'p6' AS proc_name
          , 'parsing 6' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_p6

    UNION 

     SELECT 
            'p7' AS proc_name
          , 'parsing 7' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_p7

    UNION 

     SELECT 
            'p8' AS proc_name
          , 'parsing 8' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_p8	
	
    UNION 

     SELECT 
            'p9' AS proc_name
          , 'parsing 9' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_p9	
	
	UNION 
	
     SELECT 
            'r0' AS proc_name
          , 'processing 0' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_r0
	
	UNION 
	
     SELECT 
            'r1' AS proc_name
          , 'processing 1' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_r1
	
	UNION 
	
     SELECT 
            'r2' AS proc_name
          , 'processing 2' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_r2

    UNION

     SELECT 
            'r3' AS proc_name
          , 'processing 3' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_r3

    UNION

     SELECT 
            'r4' AS proc_name
          , 'processing 4' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_r4

    UNION

     SELECT 
            'r5' AS proc_name
          , 'processing 5' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_r5

    UNION

     SELECT 
            'r6' AS proc_name
          , 'processing 6' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_r6	

    UNION

     SELECT 
            'r7' AS proc_name
          , 'processing 7' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_r7	
	
    UNION

     SELECT 
            'r8' AS proc_name
          , 'processing 8' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_r8
	
    UNION

     SELECT 
            'r9' AS proc_name
          , 'processing 9' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_r9
	
	ORDER BY 1;
	
	
COMMENT ON VIEW uio.v_workers_context IS 'Активные процессы';

COMMENT ON COLUMN uio.v_workers_context.proc_name   IS 'Имя процесса';
COMMENT ON COLUMN uio.v_workers_context.proc_descr  IS 'Описание';
COMMENT ON COLUMN uio.v_workers_context.ev_id       IS 'ID задания';
COMMENT ON COLUMN uio.v_workers_context.ev_time     IS 'Время создания';
COMMENT ON COLUMN uio.v_workers_context.ev_type     IS 'Тип задания';
COMMENT ON COLUMN uio.v_workers_context.ev_data     IS 'Данные';
COMMENT ON COLUMN uio.v_workers_context.ev_extra1   IS 'Дополнительные данные №1';
COMMENT ON COLUMN uio.v_workers_context.ev_extra2   IS 'Дополнительные данные №2';
COMMENT ON COLUMN uio.v_workers_context.ev_extra3   IS 'Дополнительные данные №3';
COMMENT ON COLUMN uio.v_workers_context.ev_extra4   IS 'Дополнительные данные №4';

-- SELECT * FROM uio.v_workers_context;

DROP VIEW IF EXISTS uio.v_event_waits CASCADE; 
CREATE VIEW uio.v_event_waits 
  AS 
     SELECT 
            'event_parse' AS proc_name
          , 'waiting to parse' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_parse
	
	UNION 
	
     SELECT 
            'event_proc' AS proc_name
          , 'waiting to processed' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_proc
	
	UNION 
	
     SELECT 
            'event_last' AS proc_name
          , 'terminated' AS proc_descr  
          , ev_id
          , ev_time
          , ev_type
          , ev_data
          , ev_extra1
          , ev_extra2
          , ev_extra3
          , ev_extra4
          
	FROM uio.event_last 
	
	 ORDER BY 2, 4;
	
	
COMMENT ON VIEW uio.v_event_waits IS 'Состояние неактивных событий (либо свершившееся, либо не наступившее';

COMMENT ON COLUMN uio.v_event_waits.proc_name   IS 'Имя события';
COMMENT ON COLUMN uio.v_event_waits.proc_descr  IS 'Описание';
COMMENT ON COLUMN uio.v_event_waits.ev_id       IS 'ID задания';
COMMENT ON COLUMN uio.v_event_waits.ev_time     IS 'Время создания';
COMMENT ON COLUMN uio.v_event_waits.ev_type     IS 'Тип задания';
COMMENT ON COLUMN uio.v_event_waits.ev_data     IS 'Данные';
COMMENT ON COLUMN uio.v_event_waits.ev_extra1   IS 'Дополнительные данные №1';
COMMENT ON COLUMN uio.v_event_waits.ev_extra2   IS 'Дополнительные данные №2';
COMMENT ON COLUMN uio.v_event_waits.ev_extra3   IS 'Дополнительные данные №3';
COMMENT ON COLUMN uio.v_event_waits.ev_extra4   IS 'Дополнительные данные №4';

-- SELECT * FROM uio.v_event_waits;


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
COMMENT ON FUNCTION uio.f_event_get (text, text) IS  'Взять одно событие из очереди (предполагалась мигшрация на PGQ)';
-- USE CASE                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
--     SELECT * FROM  uio.f_event_get ('QP', 'TP');
--     SELECT * FROM  uio.f_event_get ('QR', 'xx');
--  SELECT * FROM uio.event_parse;
--  SELECT * FROM uio.event_proc;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
                 INNER JOIN z ON (z.ev_type = f.ev_type)
		  WHERE (ev_time >= p_ev_time) ORDER BY f.ev_time, f.ev_type;
 $$;   
--
COMMENT ON FUNCTION uio.f_event_no_term (timestamp(0) WITHOUT TIME ZONE) IS  'Список событий, ожидающих обработки';
-- USE CASE                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
--     SELECT * FROM  uio.f_event_no_term ('2023-07-21 14:15:00');
--     SELECT * FROM  uio.f_event_no_term ();
--     SELECT * FROM  uio.event_parse;
--     SELECT * FROM  uio.event_proc;
--     SELECT * FROM  uio.event_last;
--     UPDATE uio.event_last SET ev_extra4 = '+'

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
   IS  'МАКЕТ. Создать события в очередях';
-- USE CASE                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
--     CALL uio.p_event_ins ('QP', 'TP', 'DP', 'DP1', 'DP2', 'DP3', 'DP4');
--     CALL uio.p_event_ins ('QR', 'TR', 'DR', 'DR1', 'DR2', 'DR3', 'DR4');
--  SELECT * FROM uio.event_parse;
--  SELECT * FROM uio.event_proc;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
