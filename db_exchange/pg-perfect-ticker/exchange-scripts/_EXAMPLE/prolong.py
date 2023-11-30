# -----------------------------------------------------------------------------------------------------------
# -*- mode: python; coding: utf-8 -*-
# -----------------------------------------------------------------------------------------------------------
#  2020-07-21/2020-07-25 Nick. Python-скрипт для pg-perfect-ticker. Выполнять только на хостах типа "tf_node"
#                              Пролонгирование сроков хранения фотоматериалов. 
# -----------------------------------------------------------------------------------------------------------
#  2020-07-28 Nick Поскольку работаем с одним хостом типа "tf_node", то соединения с "tf_checks" нет. 
#                   Аргументы не передаются,  т.е. "arg_list" не используется.    
#                   Два курсора на одно соединение к базе: cur1 и cur2
#                   Для соединения c БД УСТАНОВЛЕН признак "autocommit".    
# -----------------------------------------------------------------------------------------------------------

import shlex
import psycopg2, psycopg2.extras
from lib_pg_perfect_ticker import simple_db_pool

FETCH_COUNT = 500

# 2020-07-21 Вызов новой функции
FETCH_QUEUE_SQL = '''\
SELECT f.queue_item_id, f.event_type, f.payload::text
        FROM traffic_face_prolong.fetch_queue (
            %(fetch_count)s
        ) f\
'''

HANDLE_EVENT_SQL = '''\
SELECT traffic_face_transfer_back.handle_event (%s * -1, %s, %s)\
'''
# 2020-07-21 Вызов новой функции
DONE_QUEUE_SQL = '''\
SELECT traffic_face_prolong.done_queue (
            %(queue_item_ids)s
        )\
'''

assert not con.autocommit
con.autocommit = True   # Nick.

cur1 = stack.enter_context(con.cursor())  # Аналог "tf_checks_cur" в "transfer_back.py"
cur2 = stack.enter_context(con.cursor())  # Только для выполнения HANDLE_EVENT_SQL

cur1.arraysize = FETCH_COUNT

while True:
    cur1.execute(     
        FETCH_QUEUE_SQL,
        {
            'fetch_count': FETCH_COUNT,
        },
    )
    
    fetch_all_count = 0
    
    while True:
        queue_item_ids = []
        rows = cur1.fetchmany() 
        
        if not rows:
            break
        
        for row in rows:
            queue_item_ids.append(row[0])
        
        fetch_all_count += len(queue_item_ids)
        
        psycopg2.extras.execute_batch(cur2, HANDLE_EVENT_SQL, rows)   
        
        cur1.execute(     # Очищаем очередь.
            DONE_QUEUE_SQL,
            {
                'queue_item_ids': queue_item_ids,
            },
        )
    
    if fetch_all_count < FETCH_COUNT:
        break
