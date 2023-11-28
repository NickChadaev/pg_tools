#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: l0.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: pg-perfect-ticker's worker.
# HIST: 2023-03-08 - created
# NOTS: 2023-11-28 - modification
# -------------------------------------------------------------------------------------------

import sys
import os

import logging
import shlex
import psycopg2 

from lib_pg_perfect_ticker import simple_db_pool
from lib_pg_perfect_ticker import log
import time

import yaml
from yaml.loader import SafeLoader

YAML_NOT_OPENED_0 = "... YAML file not opened: '"
YAML_NOT_OPENED_1 = "'."

bPN = "l0_"

PATH_DELIMITER = '/' 
bDL  = "|"
bLBR = "("
bRBR = ")"
bCM  = ","

bMN  = "-"
bEMP = ""
bU   = "_"

GET_TERM_EVENTS = """SELECT count(1) FROM uio.v_event_waits WHERE 
 (proc_descr = 'terminated') AND (ev_extra4 IS NULL);
 """

CLOSE_TERM_EVENTS = """WITH x AS (
    SELECT ev_id
	     , ev_time 
    FROM uio.v_event_waits
    WHERE (ev_time >= %s) AND (proc_descr = 'terminated')
)	
  UPDATE uio.event_last AS z SET ev_extra4 = '+'
     FROM x WHERE (x.ev_id = z.ev_id);
""";

QUEUE_CONT  = "QL0"
QUEUE_CONSUMER = "cons_l0"

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

## con = psycopg2.connect("dbname=db_exchange user=postgres port=5434")

arg_list = shlex.split(ticker_task_ctx.task_script_arg)

qty_reg = int(arg_list[0]) # - Количество регионов
log_ticker = arg_list[1]   # - log-file ticker'a. смотри настройки, должен совпадать

cur1 = con.cursor()
cur1.execute (GET_TERM_EVENTS)
qty_term_events = cur1.fetchone() 
con.commit()

log.log(logging.INFO, ("*** Qty of processed regions: " + str(qty_term_events[0]) + " ***")) # - Реальное количество обработанных 

if (qty_term_events[0] >= qty_reg):
    # Выполняется закрытие processing полного обновления 
    # --------------------------------------------------
    # Выбираю  все остальные параметры процесса из очереди l0
    
    cur2 = con.cursor()
    cur2.execute (NEXT_EVENTS, (QUEUE_CONT, QUEUE_CONSUMER))
    event = cur2.fetchone() 
    con.commit()
  
    ev_id   = event[0]
    ev_time = event[1]
    ev_type = event[2]             # ev_type
    
    ev_data = event[3].split(bDL)  # ev_data
    
    date_proc    = ev_data[0]   # - Дата обработки, необходима для фильтрации в "v_event_last", proc_descr = "terminated"
    date_version = ev_data[1]   # - Дата-версия
    yaml_stage_6 = ev_data[2]   # - Имя YAML-файла (постобработка).
    postproc_sh  = ev_data[3]   # - Имя SHELL-скрипта (завершающего постобработку)
    upd_path     = ev_data[4]   # - Путь к обновлениям
    new_owner    = ev_data[5]   # - Имя нового владельца файла
    new_grp      = ev_data[6]   # - Имя группы владельца файла.
    #
    try:
        f_yaml = open (yaml_stage_6, "r")
    
    except IOError as ex:
        not_open = YAML_NOT_OPENED_0 + yaml_stage_6 + YAML_NOT_OPENED_1
        log.log (logging.INFO, not_open)
        sys.exit (-1)
      
    stage_6 = yaml.load(f_yaml, Loader=SafeLoader) 
    upd_dir = stage_6 ['global_params']['g_file_path']
    upd_dir = upd_dir.split(PATH_DELIMITER)[4]
    upd_dir = upd_dir + date_version.replace(bMN, bEMP)
      
    post_proc_l = postproc_sh + " " + upd_path + " " + upd_dir + " '" +\
         new_owner + "' '" + new_grp + "'" + " 1>> " + log_ticker + " 2>> " +\
             log_ticker
    
    log.log (logging.INFO, post_proc_l)
    os.system (post_proc_l)
    #
    cur1.execute (CLOSE_TERM_EVENTS, (date_proc,))
    con.commit()
    
    log.log(logging.INFO,"*** Processing is terminated ***")

con.commit()

### --------------------------------------------------------------------------
### $>python3 l0.py 
### (4080,)
### (25948, datetime.datetime(2023, 11, 28, 16, 6, 56), 'last_0', '2023-11-28T16:06:56.202803|2023-11-20|/home/rootadmin/abr_upload/stage_6.yaml|/home/rootadmin/abr_upload/Y_BUILD/post_proc_l.sh|/home/rootadmin/abr_upload/tmp|n.chadaev|domain users', None, None, None, None)
### 2023-11-28T16:06:56.202803
### 2023-11-20
### /home/rootadmin/abr_upload/stage_6.yaml
### /home/rootadmin/abr_upload/Y_BUILD/post_proc_l.sh
### /home/rootadmin/abr_upload/tmp
### n.chadaev
### domain users
### /home/rootadmin/abr_upload/Y_BUILD/post_proc_l.sh /home/rootadmin/abr_upload/tmp up_prdl_20231120 'n.chadaev' 'domain users' 1>> /var/log/pg-perfect-ticker/exchange.log 2>> /var/log/pg-perfect-ticker/exchange.log
### $>
