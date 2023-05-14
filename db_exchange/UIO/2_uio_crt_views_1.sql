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
	
	
COMMENT ON VIEW uio.v_event_waits IS 'Состояние неактивных событий';

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

