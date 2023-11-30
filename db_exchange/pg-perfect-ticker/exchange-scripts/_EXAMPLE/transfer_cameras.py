# -*- mode: python; coding: utf-8 -*-

import shlex
import psycopg2, psycopg2.extras
from lib_pg_perfect_ticker import simple_db_pool

FETCH_COUNT = 500

FETCH_EVENTS_SQL = '''\
delete from face_control_transfer_var.camera_queue q
        where q.camera_queue_item_id = any (
            select qq.camera_queue_item_id
                    from face_control_transfer_var.camera_queue qq
                    order by qq.camera_queue_item_id
                    limit %(fetch_count)s
                    for update
        )
        returning q.camera\
'''

HANDLE_EVENT_SQL = '''\
select face_control.api_add_camera (%s)\
'''

arg_list = shlex.split(ticker_task_ctx.task_script_arg)

assert len(arg_list) == 1

fc_cbd_db_con_dsn = arg_list[0]

fc_cbd_con = stack.enter_context(
    simple_db_pool.get_db_con_ctxmgr(
        ticker_task_ctx.db_pool,
        fc_cbd_db_con_dsn,
    ),
)

assert not con.autocommit
assert not fc_cbd_con.autocommit

cur = stack.enter_context(con.cursor())
fc_cbd_cur = stack.enter_context(fc_cbd_con.cursor())

cur.arraysize = FETCH_COUNT

while True:
    cur.execute(
        FETCH_EVENTS_SQL,
        {
            'fetch_count': FETCH_COUNT,
        },
    )
    
    rowcount = 0
    
    while True:
        rows = cur.fetchmany()
        
        if not rows:
            break
        
        rowcount += len(rows)
        
        psycopg2.extras.execute_batch(fc_cbd_cur, HANDLE_EVENT_SQL, rows)
    
    if rowcount:
        fc_cbd_con.commit()
    
    con.commit()
    
    if rowcount < FETCH_COUNT:
        break
