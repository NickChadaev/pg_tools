#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: fd_all.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Base classes
#       2023-03-17 - version for python3

import sys
import datetime
import psycopg2    

VERSION_STR = "  Version 1.0.0 Build 2023-03-16"

GET_DT = "SELECT now()::TIMESTAMP without time zone FROM current_timestamp;"

LOG_NOT_OPENED_0 = "... Log file not opened: '"
LOG_NOT_OPENED_1 = "'."

POINTS = " ... "
#------------------------
bLOG_NAME = "{0}process{1}.log"
#------------------------
SPACE_0 = " "
#------------------------

class fd_log:
    """
      The text-log file class
    """
    def __init__ ( self, p_host_ip, p_port, p_db_name, p_user_name,\
        p_prt_sw = True, p_proc_mark = "" ):  

        #---------------------------------------------------------
        #  Synchronized server and client time
        #
        self.prt_sw = p_prt_sw
        self.proc_mark = p_proc_mark
        
        rc = -1  
        self.l_s = "host = " + str ( p_host_ip ) + " port = " + str ( p_port ) + " dbname = " + str ( p_db_name ) + " user = " + str ( p_user_name )

        try:
             conn = psycopg2.connect(self.l_s)
             cur = conn.cursor()
             cur.execute(GET_DT)
         
             self.date_time = datetime.datetime.now()
             self.delta_dt = cur.fetchone()[0] - self.date_time
         
             cur.close()
             conn.close()

        except psycopg2.OperationalError as e:
             print ("... Connection aborted: ")
             print ("... " + str (e))
             sys.exit ( rc )

        #----------------------------------------------------------
    def get_datetime ( self ):
        #
        # Compute real server time. 2014-06-16
        #
        return ( datetime.datetime.now () + self.delta_dt )  

    def conv_dt ( self ):
        s_dt = self.date_time.isoformat (".")
        ss_dt = s_dt.split (".")
        self.s_d = ss_dt [0]
        self.s_t = ss_dt [1]

    def open_log ( self, p_log_name, p_log_comment, p_list_params ):
        #
        self.log_comment = p_log_comment
        self.list_params = p_list_params
        #
        self.conv_dt ()
        self.log_mark = "_" + self.s_d.replace("-", "") + "_" + self.s_t.replace(":", "")
        self.log_name = p_log_name.format (self.proc_mark, self.log_mark) 
        #
        self.s_delimiter = "--------------------------------------------------------" + '\n'

        try:
            self.fd = open ( self.log_name, "a" )   

        except IOError as ex:
            print (LOG_NOT_OPENED_0 + p_log_name + LOG_NOT_OPENED_1)

            sys.exit (1)

    def write_log_first ( self ):

        self.date_time = self.get_datetime() # 2014-06-16
        self.conv_dt ()
        #
        self.fd.write ( self.s_d + SPACE_0 + self.s_t + SPACE_0 + self.log_comment + '\n' )
        self.fd.write ( self.list_params + '\n' )
        self.fd.write ( self.s_delimiter )

    def write_log ( self, p_str ):

        self.date_time = self.get_datetime() # 2014-06-16
        self.conv_dt ()
        #
        if self.prt_sw:
            print (POINTS + p_str)
        
        self.fd.write ( "[" + self.s_t + "] ... " + p_str  + '\n' )

    def write_log_err ( self, p_rc, p_str ):

        self.date_time = self.get_datetime()  # 2014-06-16
        self.conv_dt ()
        #
        self.write_log ( "[" + self.s_t + "]: Error, rc = " + str ( p_rc ) )
        self.write_log ( "            " + p_str)

    def close_log ( self ):

        self.fd.write ( self.s_delimiter )
        self.fd.close()

# -----------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
        """
#                  1       2        3          4      
        sa = " <Host_IP> <Port> <DB_name> <User_name> "
        if ( len( sys.argv ) - 1 ) < 4:
            print (VERSION_STR) 
            print ("  Usage: " + str ( sys.argv [0] ) + sa)
            sys.exit(1)
#
        fdl0 = fd_log (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
        fdl0.open_log (bLOG_NAME, "+++++++++", "*********")
        print (fdl0.get_marks())
        fdl0.write_log_first()     
        fdl0.write_log ("Hren")
        fdl0.write_log ("Кириллица")        
        fdl0.close_log() 
        #
        fdl1 = fd_log (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4],\
            p_proc_mark = "p0_", p_prt_sw = False)
        fdl1.open_log (bLOG_NAME, "+++++++++", "*********")
        print (fdl1.get_marks())
        fdl1.write_log_first()     
        fdl1.write_log ("Hren")
        fdl1.write_log ("Кириллица")        
        fdl1.close_log() 

        
        sys.exit (0)

#---------------------------------------
    except KeyboardInterrupt as e:
        print ("... Terminated by user: ")
        sys.exit (1)

## Python 3000 will prohibit decoding of Unicode strings, according to PEP 3137
##  : "encoding always takes a Unicode string and returns a bytes sequence, 
##     and decoding always takes a bytes sequence and returns a Unicode string". 
