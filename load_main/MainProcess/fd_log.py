#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: fd_all.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Base classes

import sys
import datetime
import psycopg2    

VERSION_STR = "  Version 0.0.0 Build 2022-04-08"

GET_DT = "SELECT now()::TIMESTAMP without time zone FROM current_timestamp;"

LOG_NOT_OPENED_0 = "... Log file not opened: '"
LOG_NOT_OPENED_1 = "'."

POINTS = " ... "
bCP = "utf8"
#------------------------
bLOG_NAME = "process.log"
#------------------------
SPACE_0 = " "
#------------------------

class fd_log:
    """
      The text-log file class
    """
    def __init__ ( self, p_host_ip, p_port, p_db_name, p_user_name ):  

        #---------------------------------------------------------
        #  Synchronized server and client time
        #
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

        except psycopg2.OperationalError, e:
             print "... Connection aborted: "
             print "... " + str (e)
             sys.exit ( rc )

        #----------------------------------------------------------
    def get_datetime ( self ):
        #
        # Compute real server time. 2014-06-16
        #
        return ( datetime.datetime.now () + self.delta_dt )  

    def open_log ( self, p_log_name, p_log_comment, p_list_params ):
        #
        self.log_name    = p_log_name
        self.log_comment = p_log_comment
        self.list_params = p_list_params
        #
        self.s_d = ""
        self.s_t = ""
        #
        self.s_delimiter = "--------------------------------------------------------" + '\n'

        try:
            self.fd = open ( self.log_name, "a" )   

        except IOError, ex:
            print LOG_NOT_OPENED_0 + p_log_name + LOG_NOT_OPENED_1

            sys.exit (1)

    def conv_dt ( self ):
        s_dt = self.date_time.isoformat (".")
        ss_dt = s_dt.split (".")
        self.s_d = ss_dt [0]
        self.s_t = ss_dt [1]

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
        print POINTS + p_str
        self.fd.write ( "[" + self.s_t + "] ... " + p_str.encode (bCP)  + '\n' )

    def write_log_err ( self, p_rc, p_str ):

        self.date_time = self.get_datetime()  # 2014-06-16
        self.conv_dt ()
        #
        self.write_log ( "[" + self.s_t + "]: Error, rc = " + str ( p_rc ) )
        self.write_log ( "            " + p_str.decode (bCP))

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
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit(1)
#
        fdl = fd_log (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
        fdl.open_log (bLOG_NAME, "+++++++++", "*********")
        fdl.write_log_first()     
        fdl.write_log ("Hren")
        fdl.write_log ("Кириллица".decode(bCP))        
        fdl.close_log() 
        
        sys.exit (0)

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

## Python 3000 will prohibit decoding of Unicode strings, according to PEP 3137
##  : "encoding always takes a Unicode string and returns a bytes sequence, 
##     and decoding always takes a bytes sequence and returns a Unicode string". 
