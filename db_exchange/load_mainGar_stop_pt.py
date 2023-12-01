#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainCar_stop_pt.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Load data into database
# HIST: 2021-12-01 - created
# NOTS: 
# -----------------------------------------------------------------------------------------------------------------------

import sys
import os
import string
import datetime
import psycopg2  
import time

#
import yaml
from yaml.loader import SafeLoader

VERSION_STR = "  Version 0.1.0 Build 2023-12-01"

S_DELIM = "="     # Nick 2022-03-09
bUL     = "_"
SPACE_0 = " "
EMP     = ""
# -----------------------------------

DROP_DATA = """DELETE FROM uio.event WHERE (ev_time >= %s) AND (ev_extra4 IS NULL);
"""

PATH_DELIMITER = '/'  # Nick 2020-05-11

class make_load_pt():
 """
    main class Nick 2023-02-07/2023-11-27
    <Host_IP> <Port> <DB_name> <User_name> <Yaml_file> <Version>
    
 """
 def __init__ ( self, p_host_ip, p_port, p_db_name, p_user_name, p_proc_date ):

     self.date_proc = p_proc_date + " 00:00:00"
     ### print self.date_proc
     
     #---
     s_lp = "host=" + str(p_host_ip) + SPACE_0 + "port=" + str(p_port) + SPACE_0 +\
         "dbname=" + str(p_db_name) + SPACE_0 + "user=" + str(p_user_name) 
     
     self.conn = psycopg2.connect(s_lp)
     self.conn.autocommit = True
     self.curs = self.conn.cursor()
     
 def to_do_pt(self):
     
     os.system ("sudo service pg-perfect-ticker@exchange stop")
     self.curs.execute (DROP_DATA,(self.date_proc,))         
     self.conn.commit;         
     os.system ("sudo service pg-perfect-ticker@exchange start")
         
     return rc
 
# ----------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
        """
         #         1        2       3         4           5         
        sa = " <Host_IP> <Port> <DB_name> <User_name> <Date_proc>"
        
        if ((len( sys.argv ) - 1) < 5):
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )
        
        rc = 0
        ml = make_load_pt (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4],sys.argv[5])
        rc = ml.to_do_pt()
        
        sys.exit (rc)

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        s1ys.exit (1)

# ===================================================================================================
