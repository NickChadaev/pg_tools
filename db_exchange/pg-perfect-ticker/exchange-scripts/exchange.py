# -----------------------------------------------------------------------------------------------------------
# -*- mode: python; coding: utf-8 -*-
# -----------------------------------------------------------------------------------------------------------
#  2020-12-22 Nick. Python-скрипт для обменного сервиса.
# -----------------------------------------------------------------------------------------------------------

import shlex
import psycopg2 
from lib_pg_perfect_ticker import simple_db_pool

FETCH_COUNT = 50

# Список обслуживаемых сервисов.
FETCH_SERVICE_SQL = '''\
SELECT service_name\
      ,service_type\
      ,send_queue\
      ,send_queue_attr\
      ,recieve_queue\
      ,recieve_queue_attr\
      ,service_node_num\
	FROM uio.v_service_config s\
'''
# Обработчик
HANDLE_QUEUE_ITEMS_SQL = '''\
SELECT uio_pgq.handle_queue_items (%s, %s, %s, %s)\
'''

assert not con.autocommit
con.autocommit = True    

cur1 = con.cursor()  # Запрос для получения конфигурации сервисов 
cur2 = con.cursor()  # Только для выполнения HANDLE_QUEUE_ITEMS_SQL

cur1.arraysize = FETCH_COUNT
fetch_all_count = FETCH_COUNT

# Выполнение запроса
while fetch_all_count == FETCH_COUNT:
    
    cur1.execute (FETCH_SERVICE_SQL,)
    fetch_all_count = 0
    
    # Получение данных 
    rows = cur1.fetchmany()  
    
    for row in rows:
        fetch_all_count += 1
        if row[1] == 'PERM':
            cur2.execute (HANDLE_QUEUE_ITEMS_SQL, (row[0], row[2], row[3], row[6]))
            x=cur2.fetchone()
        else:
            x=()
        
