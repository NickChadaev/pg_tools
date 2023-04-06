import shlex
import psycopg2 
from lib_pg_perfect_ticker import simple_db_pool
import pgqueue
import string
import time

CALL_PROC = """INSERT INTO public.xxx_log (server_addr, db_name, message) VALUES (
        
            quote_literal ('P2: '), 
            quote_literal (current_database ()), 
            quote_literal ('{0}') 
            );
"""
## con = psycopg2.connect("dbname=db_exchange user=postgres port=5433")

cur1 = con.cursor()
cur2 = con.cursor()

first_q = pgqueue.Queue('QP')
consum_q = pgqueue.Consumer('QP', 'cons_p0')

i = 0
while i < 25000:
    for event in consum_q.next_events(cur1, commit = True):
        s = str(event)
        ls = s.replace("'", "")  # Python 3
        # print ls
        lls = CALL_PROC.format(ls)
        cur2.execute (lls)

    time.sleep (3)
    ##consum_q._load_next_batch(cur1)    
    i = i + 1
