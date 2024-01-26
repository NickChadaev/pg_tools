#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: p16.py + load_mainCar.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: pg-perfect-ticker's worker. 
# HIST: 2023-03-08 - created
# NOTS: 
# -------------------------------------------------------------------------------------------
#   ВНИМАНИЕ:  0 - Префикс-1
#              1 - Префикс-1 в верхнем регистре
#              2 - Номер    
#              3 - Префикс-2
#              4 - Префикс-2 в верхнем регистре
#              5 - Body

import shlex
import psycopg2 
from lib_pg_perfect_ticker import simple_db_pool
import time

bPN = "p16_"

PATH_DELIMITER = '/' 
bDL  = "|"
bLBR = "("
bRBR = ")"
bCM  = ","
EMP = ""

QUEUE_PARSE = "QP"
QUEUE_PROC  = "QR"
QUEUE_CONT  = "QP16"

QUEUE_CONSUMER = "cons_p16"

NEXT_EVENTS = """SELECT 
  ev_id    ::bigint                          -- ID события    
, ev_time  ::timestamp(0) WITHOUT TIME ZONE  -- Время события
, ev_type  ::text                            -- Тип 
, ev_data  ::text                            -- Данные
, ev_extra1::text                            -- Доп данные #1
, ev_extra2::text                            -- Доп данные #2
, ev_extra3::text                            -- Доп данные #3
, ev_extra4::text                            -- Доп данные #4
FROM uio.f_event_get (      
     p_nm_queue    := %s::text    -- Имя очереди
    ,p_nm_consumer := %s::text    -- Подписчик
);"""

INSERT_EVENT = """
CALL uio.p_event_ins (
    p_nm_queue  := (NULLIF (%s, ''))::text 
   ,p_ev_type   := (NULLIF (%s, ''))::text 
   ,p_ev_data   := (NULLIF (%s, ''))::text 
   ,p_ev_extra1 := (NULLIF (%s, ''))::text 
   ,p_ev_extra2 := (NULLIF (%s, ''))::text 
   ,p_ev_extra3 := (NULLIF (%s, ''))::text 
   ,p_ev_extra4 := (NULLIF (%s, ''))::text
);
"""

## con = psycopg2.connect("dbname=db_exchange user=postgres port=5433")

# Есть ли незаверщённый ранее процесс ( смотрю контекст).
cur1 = con.cursor()
cur1.execute (NEXT_EVENTS, (QUEUE_CONT, QUEUE_CONSUMER))
event_с = cur1.fetchone()  

if ( event_с [0] ):
    event = event_с
else:    
    cur2 = con.cursor()
    cur2.execute (NEXT_EVENTS, (QUEUE_PARSE, QUEUE_CONSUMER))
    event = cur2.fetchone() 
    
con.commit()

#------------------------------
bLOG_NAME = "{0}process{1}.log"
bOUT_NAME = "{0}process{1}.out"
bERR_NAME = "{0}process{1}.err"
bSQL_NAME = "{0}process{1}.sql"
#------------------------------

import load_mainGar as LoadGar

if ( event[0] ):
    
    # Формирую контекст.
    cur1.execute (INSERT_EVENT, (QUEUE_CONT, event[2], event[3], event[4], event[5], event[6], event[7]))      
    con.commit()
        
    ev_id   = event[0]
    ev_time = event[1]
    #--
    ev_type = event[2].split(bDL)       # ev_type
    ev_type_parse = ev_type[0]
    ev_type_proc = ev_type[1]
    
    ev_data = event[3].split(bDL)       # ev_data
    ev_data_parse = ev_data[0]
    log_pref_parse = ev_data[1]
    
    first_mess_parse = event[4]         #  ev_extra1
    
    ev_extra2 = event[5].split(bDL)     #  ev_extra2
    ev_data_proc = ev_extra2[0]
    log_pref_proc = ev_extra2[1]
    
    first_mess_proc = event[6]          #  ev_extra3
    
    dp = ((ev_data_parse.replace(bLBR, EMP)).replace(bRBR,EMP)).split(bCM)
  
    host_ip         = dp[0].strip()
    port            = dp[1].strip()                      
    db_name         = dp[2].strip()
    user_name       = dp[3].strip()
    batch_file_name = dp[4].strip()
    path            = dp[5].strip()   
    version_date    = dp[6].strip()
    fserver_nmb     = dp[7].strip()
    schemas         = dp[8].strip()
    id_region       = dp[9].strip()
    
    rc = 0
    proc_mp = log_pref_parse + PATH_DELIMITER + bPN
    ml = LoadGar.make_load (host_ip, port, db_name, user_name, False, proc_mp) #### !!!!
    rc = ml.to_do (host_ip, port, db_name, user_name, batch_file_name,\
        bLOG_NAME, bOUT_NAME, bERR_NAME, bSQL_NAME, path, version_date,\
                p_fserver_nmb = fserver_nmb, p_schemas = schemas, p_id_region = id_region,\
                    p_first_message = first_mess_parse)   
    if (rc == 0):
        #----------------------------------------    
        # Убираю контекст.
        cur1.execute (NEXT_EVENTS, (QUEUE_CONT, QUEUE_CONSUMER))
        event_с = cur1.fetchone()         
        
        # Готовлю задание для processing
        cur3 = con.cursor()
        cur3.execute (INSERT_EVENT, (QUEUE_PROC, ev_type_proc, ev_data_proc, first_mess_proc,\
            log_pref_proc, EMP, EMP))  
        ## psycopg2.errors.FeatureNotSupported:
        
        con.commit()

