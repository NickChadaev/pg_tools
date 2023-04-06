#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainCar.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Load data into database
# HIST: 2023--03-08 - created
# NOTS: 
# -------------------------------------------------------------------------------------------

import shlex
import psycopg2 
from lib_pg_perfect_ticker import simple_db_pool
import pgqueue
import time
import load_mainGar as LoadGar

bPN = "r2_"

#------------------------------
bLOG_NAME = "{0}process{1}.log"
bOUT_NAME = "{0}process{1}.out"
bERR_NAME = "{0}process{1}.err"
bSQL_NAME = "{0}process{1}.sql"
#------------------------------

PATH_DELIMITER = '/' 
bDL  = "|"
bLBR = "("
bRBR = ")"
bCM  = ","
EMP = ""
bU  = "_"

QUEUE_PROC = "QR"
QUEUE_LOG = "QL"
QUEUE_CONSUMER = "cons_p0"

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

### con = psycopg2.connect("dbname=db_exchange user=postgres port=5433")

cur1 = con.cursor()
cur1.execute (NEXT_EVENTS, (QUEUE_PROC, QUEUE_CONSUMER))
event = cur1.fetchone() 
con.commit()

if (event [0]):
        
    ev_id   = event[0]
    ev_time = event[1]
    #--
    ev_type = event[2]                 # ev_type
    ev_data = event[3]
    first_mess_proc = event[4]         #  ev_extra1
    log_pref_proc = event[5]           #  ev_extra2
    
    dp = ((ev_data.replace(bLBR, EMP)).replace(bRBR,EMP)).split(bCM)
  
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
    proc_mr = log_pref_proc + PATH_DELIMITER + bPN
    ml = LoadGar.make_load (host_ip, port, db_name, user_name, False, proc_mr) #### !!!!
    rc = ml.to_do (host_ip, port, db_name, user_name, batch_file_name,\
        bLOG_NAME, bOUT_NAME, bERR_NAME, bSQL_NAME, path, version_date,\
                p_fserver_nmb = fserver_nmb, p_schemas = schemas, p_id_region = id_region,\
                    p_first_message = first_mess_proc)   
    if (rc == 0):
        cur2 = con.cursor()
        cur2.execute (INSERT_EVENT,(QUEUE_LOG, ev_type, first_mess_proc, bPN.strip(bU), EMP, EMP, EMP))         
        con.commit()
