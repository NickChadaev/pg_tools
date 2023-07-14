#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: l0.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: pg-perfect-ticker's worker.
# HIST: 2023-03-08 - created
# NOTS: 
# -------------------------------------------------------------------------------------------

import sys
import os

import logging
import shlex
import psycopg2 

from lib_pg_perfect_ticker import simple_db_pool
from lib_pg_perfect_ticker import log
#import pgqueue
import time
import load_mainGar as LoadGar

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

GET_TERM_EVENTS = """SELECT count(1) FROM uio.v_event_waits WHERE (ev_time >= %s)
 AND (proc_descr = 'terminated') AND ( ev_extra4 IS NULL);"""

CLOSE_TERM_EVENTS = """WITH x AS (
    SELECT ev_id
	     , ev_time 
    FROM uio.v_event_waits
    WHERE (ev_time >= %s) AND (proc_descr = 'terminated')
)	
  UPDATE uio.event_last AS z SET ev_extra4 = '+'
     FROM x WHERE (x.ev_id = z.ev_id);
""";
## con = psycopg2.connect("dbname=db_exchange user=postgres port=5433")

arg_list = shlex.split(ticker_task_ctx.task_script_arg)

qty_reg      = int(arg_list[0]) # - Количество регионов
date_proc    = arg_list[1]      # - Дата обработки, необходима для фильтрации в "v_event_last", proc_descr = "terminated"
date_version = arg_list[2]      # - Дата-версия
yaml_stage_6 = arg_list[3]      # - Имя YAML-файла (постобработка).
postproc_sh  = arg_list[4]      # - Имя SHELL-скрипта (завершающего постобработку)
upd_path     = arg_list[5]      # - Путь к обновлениям
new_owner    = arg_list[6]      # - Имя нового владельца файла
new_grp      = arg_list[7]      # - Имя группы владельца файла.
log_ticker   = arg_list[8]      # - log-file ticker'a. смотри настройки, должен совпадать

## log.log(logging.INFO, qty_reg)      # - Количество регионов
## log.log(logging.INFO, date_proc)    # - Дата обработки, необходима для фильтрации в "v_event_last", proc_descr = "terminated"
## log.log(logging.INFO, date_version) # - Дата-версия
## log.log(logging.INFO, yaml_stage_6) # - Имя YAML-файла (постобработка).
## log.log(logging.INFO, postproc_sh)  # - Имя SHELL-скрипта (завершающего постобработку)
## log.log(logging.INFO, upd_path)     # - Путь к обновлениям
## log.log(logging.INFO, new_owner)    # - Имя нового владельца файла
## log.log(logging.INFO, new_grp)      # - Имя группы владельца файла.
## log.log(logging.INFO, log_ticker)   # - log-file ticker'a. смотри настройки, должен совпадать
#
cur1 = con.cursor()
cur1.execute (GET_TERM_EVENTS, (date_proc,))
qty_term_events = cur1.fetchone() 
con.commit()

log.log(logging.INFO, ("*** Qty of processed regions: " + str(qty_term_events[0]) + " ***")) # - Реальное количество обработанных 

if (qty_term_events[0] >= qty_reg):
    # Выполняется закрытие processing полного обновления 
    
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
      
    # post_proc_l.sh \<Path\> \<Updates-dir\> \<Owner\> \<Group\>
    post_proc_l = postproc_sh + " " + upd_path + " " + upd_dir + " '" +\
         new_owner + "' '" + new_grp + "'" + " 1>> " + log_ticker + " 2>> " +\
             log_ticker
    
    ## log.log(logging.INFO, post_proc_l)
    os.system (post_proc_l)
    #
    cur1.execute (CLOSE_TERM_EVENTS, (date_proc,))
    con.commit()
    
    log.log(logging.INFO,"*** Processing is terminated ***")

con.commit()

