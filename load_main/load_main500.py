#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_main.py
# AUTH: Nick (nick_ch58@list.ru)
# DESC: Load data into database, unload data from database
#       The simplest version, it uses PSQL/PG_DUMP
# HIST: 2009-04-21 - created
# NOTS: 2009-05-05 - The user's name parameters is added
#       2009-05-25 - The unload mode is created
#       2009-07-20 - Try .. exept IOError was added
#       2009-08-24 - The text log-file was added
#       2009-09-24 - The parameter's list was added into top of log
#       2010-01-25 - New feature DUMP SCHEMA ( mode 'F' ) was added
#       2010-02-03 - New procedure make_load was added
#       2010-04-05 - Rebuild classes
#       2014-06-16 - Используется библиотека pscopg2, используем её для получения
#                    текущих даты/времени и синхронизации времён клиента и сервера.     
#       2016-12-06 - The port parameter is added
#       2018-02-03 - ((string.strip (l_words [1])))  was added 

import sys
import os
import string
import datetime
import load_mainS

import psycopg2    # 2014-06-16 Nick    Исключено обращение к pscycopg

from load_mainS_tr import *

VERSION_STR = "  Version 2.1.2 Build 2019-01-16"

GET_DT = "SELECT now()::TIMESTAMP without time zone FROM current_timestamp;"

SCRIPT_NOT_OPENED_0 = "... Sript file not opened: '"
SCRIPT_NOT_OPENED_1 = "'."

LOG_NOT_OPENED_0 = "... Log file not opened: '"
LOG_NOT_OPENED_1 = "'."

POINTS = " ... "

#------------------------
bLOG_NAME = "process.log"
#------------------------

bCOMMENT_SIGN = "#"
bDELIMITER_SIGN = ";"

# -----------------------------------
DIRECT_SQL_COMMAND              = "0"
SEQUENCE_OF_SIMPLE_SQL_COMMANDS = "1"
DELETE_LOAD_COUNT               = "2"
CALL_STORED_PROC                = "3"
UNLOAD_FROM_DATABASE            = "A"
UNLOAD_FROM_DATABASE_T          = "B"
DATABASE_DUMP                   = "C"
COPY_FROM_LOCAL_TO_REMOTE       = "D"
COPY_FROM_REMOTE_TO_LOCAL       = "E"
SCHEMA_DUMP                     = "F"
# -----------------------------------
SPACE_0 = " "
# -----------------------------------

INPUT_CP = 'koi8_r'
BASE_CP = 'utf8'

class fd_log:
    """
      The text-log file class
    """
    def __init__ ( self, p_gui, p_host_ip, p_port, p_db_name, p_user_name ):  

        self.isGui = p_gui
        #---------------------------------------------------------
        #  Синхронизировали время сервера и время клиентской части
        #
        rc = -1  
        l_s = "host = " + str ( p_host_ip ) + " port = " + str ( p_port ) + " dbname = " + str ( p_db_name ) + " user = " + str ( p_user_name )

        # Nick 2017-05-30 
        # self.date_time = datetime.datetime.now()
        # self.delta_dt = self.date_time - self.date_time
        # Nick 2017-05-30 

        try:
             conn = psycopg2.connect(l_s)
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
        # Вычисляю текущее время сервера. 2014-06-16
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
            if self.isGui :  # Nick 2010-04-09
                 self.fd = codecs.open ( self.log_name, "a", INPUT_CP )
            else:
                 self.fd = open ( self.log_name, "a" )

        except IOError, ex:
            if self.isGui :
                self.ex_append ( LOG_NOT_OPENED_0 + p_log_name + LOG_NOT_OPENED_1 )
            else:
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
        self.fd.write ( self.list_params + '\n' );
        self.fd.write ( self.s_delimiter )

    def write_log ( self, p_str ):

        self.date_time = self.get_datetime() # 2014-06-16
        self.conv_dt ()
        #
        if self.isGui : # Nick 2010-02-05
		self.ex_append ( POINTS + p_str )
                self.show ()
        else:
		print POINTS + p_str

        self.fd.write ( "[" + self.s_t + "] ... " + p_str  + '\n' )

    def write_log_err ( self, p_rc, p_str ):

        self.date_time = self.get_datetime()  # 2014-06-16
        self.conv_dt ()
        #
        self.write_log ( "[" + self.s_t + "]: Error, rc = " + str ( p_rc ) )
        self.write_log ( "            " + p_str )

    def close_log ( self ):

        self.fd.write ( self.s_delimiter )
        self.fd.close()

# ------------------------------------------------------------------------------------

class fd_0:
    """
      The base class
    """

    def __init__ ( self, p_mode, p_host, p_port, p_db_name, p_user_name, p_out_name, p_err_name ):

      self.host      = p_host
      self.db_name   = " " + p_db_name + " "
      self.port      = p_port
      self.user_name = p_user_name
      self.cmd_name  = ""
      self.out_name  = p_out_name
      self.err_name  = p_err_name
      #---------------------------
      self.l_1 = "psql -h "
      self.l_2 = " -p "
      self.l_2_pref_cmd = ""

      if ( p_mode == 0 ):
            self.l_2_pref_cmd = " -c \""
      else:
            self.l_2_pref_cmd = " -f \""

      self.l_3     = "\" "
      self.l_4_out = " 1>> "
      self.l_5_err = " 2>> "
      #---------------------------
      self.l_arg = ""

    def f_create (self, p_cmd_name):

        self.cmd_name = p_cmd_name
        self.l_arg = self.l_1 + self.host + self.l_2 + self.port + self.l_2_pref_cmd + self.cmd_name
        self.l_arg = self.l_arg + self.l_3 + self.db_name + self.user_name + self.l_4_out
        self.l_arg = self.l_arg + self.out_name + self.l_5_err + self.err_name

    def f_run (self):

      rc = 0
      rc = ( os.system ( self.l_arg ) )

      # print self.l_arg
      # print "\n"

      return rc

class fd_1 (fd_0):

    def __init__ ( self, p_host, p_port, p_db_name, p_user_name, p_out_name, p_err_name ):

      self.host       = p_host
      self.port       = p_port
      self.db_name    = " " + p_db_name + " "
      self.user_name  = p_user_name
      self.table_name = ""
      self.file_name  = ""
      self.out_name   = p_out_name
      self.err_name   = p_err_name
      #---------------------------
      self.l_1 = "pg_dump -D -a -v -h "
      self.l_2 = " -U "
      self.l_3 = " -t "
      self.l_4 = " -f "
      self.l_9 = " -p " # Nick 2016-12-06 
      self.l_4_out = " 1>> "
      self.l_5_err = " 2>> "
      #---------------------------
      self.l_arg = ""

    def f_create ( self, p_table_name, p_file_name ):

        self.table_name = p_table_name
        self.file_name = p_file_name
        #
        self.l_arg = self.l_1 + self.host + self.l_9 + self.port + self.l_2 + self.user_name + self.l_3
        self.l_arg = self.l_arg + self.table_name + self.l_4 + self.file_name + self.db_name
        self.l_arg = self.l_arg + self.l_4_out + self.out_name + self.l_5_err + self.err_name

class fd_2 (fd_0):

    def __init__ ( self, p_host, p_port, p_db_name, p_user_name, p_out_name, p_err_name ):

        self.host       = p_host
        self.port       = p_port   # Nick 2016-12-06
        self.db_name    = " " + p_db_name + " "
        self.user_name  = p_user_name
        self.file_name  = ""
        self.out_name   = p_out_name
        self.err_name   = p_err_name
        #---------------------------
        self.l_1   = "pg_dump -v -D -h "
        self.l_2 = " -U "
        self.l_4 = " -f "
        self.l_9 = " -p "
        self.l_4_out = " 1>> "
        self.l_5_err = " 2>> "
        #---------------------------
        self.l_arg = ""

    def f_create ( self, p_file_name ):

        self.file_name = p_file_name
        #
        self.l_arg = self.l_1 + self.host + +self.l_9 + self.port + self.l_2 + self.user_name
        self.l_arg = self.l_arg + self.l_4 + self.file_name + self.db_name
        self.l_arg = self.l_arg + self.l_4_out + self.out_name + self.l_5_err + self.err_name

class fd_3 (fd_0):
    # From local to remote

    def __init__ ( self, p_host, p_target_name, p_user_name, p_out_name, p_err_name ):

        self.source_name = ""
        self.out_name    = p_out_name
        self.err_name    = p_err_name
        #---------------------------
        self.l_1 = "scp -r -v "
        self.l_2 = " " + p_user_name + "@" + p_host + ":" + p_target_name
        self.l_4_out = " 1>> "
        self.l_5_err = " 2>> "
        #---------------------------
        self.l_arg = ""

    def f_create ( self, p_source_name ):

        #
        self.l_arg = self.l_1 + p_source_name + self.l_2
        self.l_arg = self.l_arg + self.l_4_out + self.out_name + self.l_5_err + self.err_name

class fd_4 (fd_0):
    # From remote to local

    def __init__ ( self, p_host, p_source_name, p_user_name, p_out_name, p_err_name ): # p_target_name

        self.source_name = p_source_name
        self.out_name    = p_out_name
        self.err_name    = p_err_name
        #---------------------------
        self.l_1 = "scp -r -v "
        self.l_2 = p_user_name + "@" + p_host + ":" + self.source_name
        self.l_4_out = " 1>> "
        self.l_5_err = " 2>> "
        #---------------------------
        self.l_arg = ""

    def f_create ( self, p_target_name ): # p_source_name
        #
        self.l_arg = self.l_1 + self.l_2 + " " + p_target_name
        self.l_arg = self.l_arg + self.l_4_out + self.out_name + self.l_5_err + self.err_name

# Nick 2010/01/25  schema dump, 'create schema' command was presented.
class fd_5 (fd_0):

    def __init__ ( self, p_host, p_port, p_db_name, p_user_name, p_out_name, p_err_name ):

      self.host        = p_host
      self.port        = p_port
      self.db_name     = " " + p_db_name + " "
      self.user_name   = p_user_name
      self.schema_name = ""
      self.file_name   = ""
      self.out_name    = p_out_name
      self.err_name    = p_err_name
      #---------------------------
      self.l_1 = "pg_dump -D -v -h "
      self.l_2 = " -U "
      self.l_3 = " -n "
      self.l_4 = " -f "
      self.l_9 = " -p "   # Nick 2016-12-06
      self.l_4_out = " 1>> "
      self.l_5_err = " 2>> "
      #---------------------------
      self.l_arg = ""

    def f_create ( self, p_schema_name, p_file_name ):

        self.schema_name = p_schema_name
        self.file_name = p_file_name
        #
        self.l_arg = self.l_1 + self.host + self.l_9 + self.port + self.l_2 + self.user_name + self.l_3
        self.l_arg = self.l_arg + self.schema_name + self.l_4 + self.file_name + self.db_name
        self.l_arg = self.l_arg + self.l_4_out + self.out_name + self.l_5_err + self.err_name
#
# main class Nick 2010-03-31
#    2014-06-16 Добавляю три параметра:
#           - IP хоста
#           - имя базы
#           - имя пользователя

class make_load ( fd_log ):
 
 def __init__ ( self, p_gui, p_host_ip, p_port, p_db_name, p_user_name ):

    self.isGui = p_gui
    fd_log.__init__ ( self, p_gui, p_host_ip, p_port, p_db_name, p_user_name )

    self.tf = Trans_f ( INPUT_CP, BASE_CP ) # Nick 2010-04-09

 #
 # Nick 2010-04-05 -------------------------------------------------------------------------------------------
 #                    1          2         3          4            5          6            7          8          9
 def to_do ( self, p_host_ip, p_port, p_db_name, p_user_name, p_batch_name,  p_std_out, p_std_err, p_comments, p_tmp ):

    try:
        if not ( self.isGui ): # Nick 2010-04-13
                fd = open ( p_batch_name, "r" )

    except IOError, ex:
        if ( self.isGui ): # Nick 2010-02-05
            self.ex_append ( SCRIPT_NOT_OPENED_0 + p_batch_name + SCRIPT_NOT_OPENED_1 )
        else:
            print SCRIPT_NOT_OPENED_0 + p_batch_name + SCRIPT_NOT_OPENED_1

        return 1

    if self.isGui :
        self.ex_append ( SPACE_0 )
        self.c_list = self.tf.tr_in ( p_batch_name, p_tmp )
    else:
        self.c_list = fd.readlines ()
        fd.close ()
        # print SPACE_0  Nick 2014-06-16

    s_lp = str ( p_host_ip ) + SPACE_0 + str ( p_port ) + SPACE_0 + str ( p_db_name ) + SPACE_0 + str ( p_user_name )
    s_lp = s_lp + SPACE_0 + str ( p_batch_name ) + SPACE_0 + str ( p_std_out ) + SPACE_0 + str ( p_std_err )

    self.open_log ( bLOG_NAME, p_comments, s_lp )
    self.write_log_first ()

    rc = 0
    tr_f = load_mainS.tr_file ()

    for ce_list in self.c_list:
      if ce_list [0] <> bCOMMENT_SIGN:
        l_words = string.split ( ce_list, bDELIMITER_SIGN )

        if len (l_words) >= 4:
            l_db_name = string.strip (l_words [2])
            if len (l_db_name) == 0:
                l_db_name = p_db_name

            self.write_log ( l_words [3] )

            #----------------------------------------------------------------------------
            if l_words [0] == DIRECT_SQL_COMMAND:  # Direct SQL-command
                fr_0 = fd_0( 0, p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)

                fr_0.f_create ((string.strip (l_words [1])))  # Nick 2018-02-03
                rc = fr_0.f_run()

                if rc <> 0:     #  Fatal error, break process
                   self.write_log_err ( rc, fr_0.l_arg )
                   break

            #------------------------------------------------------------------------------
            if l_words [0] == SEQUENCE_OF_SIMPLE_SQL_COMMANDS:  # Sequence of simple SQL-commands
                fr_1 = fd_0( 1, p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)

                fr_1.f_create ((string.strip (l_words [1])))  # Nick 2018-02-03
                rc = fr_1.f_run()

                if rc <> 0:     #  Fatal error, break process
                   self.write_log_err ( rc, fr_1.l_arg )
                   break

            #----------------------------------------------------------------------------
            if l_words [0] == DELETE_LOAD_COUNT:  # The DELETE/LOAD/COUNT sequence of SQL-commands file
                ls_nm = tr_f.f_parse_name( l_words[1] )
                fr_20 = fd_0( 0, p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)
                fr_21 = fd_0( 1, p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)

                #delete                             command
                fr_20.f_create( "DELETE FROM " + ls_nm )
                rc = fr_20.f_run()

                if rc <> 0:     #  Fatal error, break process
                   self.write_log_err ( rc, fr_20.l_arg )
                   break

                #load
                fr_21.f_create ((string.strip (l_words [1])))  # Nick 2018-02-03 
                rc = fr_21.f_run()

                if rc <> 0:     #  Fatal error, break process
                   self.write_log_err ( rc, fr_21.l_arg )
                   break

                #count                               COMMAND
                fr_20.f_create( "SELECT count(*) AS LOADED_"+string.replace (ls_nm, ".","_")+" FROM "+ls_nm+" " )
                rc = fr_20.f_run()

                if rc <> 0:     #  Fatal error, break process
                   self.write_log_err ( rc, fr_20.l_arg )
                   break

            #----------------------------------------------------------------------------
            if l_words [0] == CALL_STORED_PROC:  # The Call Stored Prod
               ls_nm = tr_f.f_parse_name( l_words[1] )
               fr_30 = fd_0( 0, p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)
               fr_31 = fd_0( 1, p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)

               # delete x                             command
               fr_30.f_create( "DELETE FROM service.x_" + ls_nm )
               rc = fr_30.f_run()

               if rc <> 0:     #  Fatal error, break process
                  self.write_log_err ( rc, fr_30.l_arg )
                  break

               # load   x
               fr_31.f_create(l_words[1])
               rc = fr_31.f_run()

               if rc <> 0:     #  Fatal error, break process
                  self.write_log_err ( rc, fr_31.l_arg )
                  break

               # count  x                             COMMAND
               ls_cmd="SELECT count(*) AS LOADED_" + ls_nm + " FROM service.x_" + ls_nm + " "
               fr_30.f_create( ls_cmd )
               rc = fr_30.f_run()

               if rc <> 0:     #  Fatal error, break process
                  self.write_log_err ( rc, fr_30.l_arg )
                  break

               # call  x to pub                       COMMAND--
               fr_30.f_create( "SELECT service.f_load_" + ls_nm + " () " )
               rc = fr_30.f_run()

               if rc <> 0:     #  Fatal error, break process
                  self.write_log_err ( rc, fr_30.l_arg )
                  break

               # count  pub                          COMMAND
               ls_cmd = "SELECT count(*) AS TRANS_" + ls_nm + " FROM " + ls_nm + " "
               fr_30.f_create( ls_cmd )
               rc = fr_30.f_run()

               if rc <> 0:     #  Fatal error, break process
                  self.write_log_err ( rc, fr_30.l_arg )
                  break

               # delete x                             command
               fr_30.f_create( "DELETE FROM service.x_" + ls_nm )
               rc = fr_30.f_run()

               if rc <> 0:     #  Fatal error, break process
                  self.write_log_err ( rc, fr_30.l_arg )
                  break

            #----------------------------------------------------------------------------
            if l_words [0] == UNLOAD_FROM_DATABASE:  # Unload from database
               ls_nm = tr_f.f_parse_name ( l_words[1] )
               fu_A = fd_1 ( p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)
               fu_A.f_create ( ls_nm, l_words[1] )
               rc = fu_A.f_run ()

               if rc <> 0:     #  Fatal error, break process
                   self.write_log_err ( rc, fu_A.l_arg )
                   break

               tr_f.tr_one ( l_words [0], l_words[1] )

            #----------------------------------------------------------------------------
            if l_words [0] == UNLOAD_FROM_DATABASE_T:  # Unload from database
               ls_nm = tr_f.f_parse_name ( l_words[1] )
               fu_B = fd_1 ( p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)
               fu_B.f_create ( ls_nm, l_words[1] )
               rc = fu_B.f_run ()

               if rc <> 0:     #  Fatal error, break process
                   self.write_log_err ( rc, fu_B.l_arg )
                   break

               tr_f.tr_one ( l_words [0], l_words[1] )

            #----------------------------------------------------------------------------
            if l_words [0] == DATABASE_DUMP:  # Database dump
               fu_C = fd_2 ( p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)
               fu_C.f_create ( l_words [1] )
               rc = fu_C.f_run ()

               if rc <> 0:          # Fatal error, break process
                   self.write_log_err ( rc, fu_C.l_arg )
                   break

            #----------------------------------------------------------------------------
            if l_words [0] == COPY_FROM_LOCAL_TO_REMOTE:  # Copy files from local to remote
               fu_D = fd_3 ( p_host_ip, l_db_name, p_user_name, p_std_out, p_std_err )
               fu_D.f_create ( l_words [1] )
               rc = fu_D.f_run ()

               if rc <> 0:          # Fatal error, break process
                   self.write_log_err ( rc, fu_D.l_arg )
                   break

            #----------------------------------------------------------------------------
            if l_words [0] == COPY_FROM_REMOTE_TO_LOCAL:  # Copy files from remote to local
               fu_E = fd_4 ( p_host_ip, l_words [1], p_user_name, p_std_out, p_std_err ) # l_db_name
               fu_E.f_create ( l_db_name ) # l_words [1]
               rc = fu_E.f_run ()

               if rc <> 0:          # Fatal error, break process
                   self.write_log_err ( rc, fu_E.l_arg )
                   break

            # Nick 2010-01-25
            #----------------------------------------------------------------------------
            if l_words [0] == SCHEMA_DUMP:  # Schema dump
               ls_nm = tr_f.f_parse_name ( l_words[1] )
               fu_F = fd_5 ( p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)
               fu_F.f_create ( ls_nm, l_words[1] )
               rc = fu_F.f_run ()

               if rc <> 0:     #  Fatal error, break process
                   self.write_log_err ( rc, fu_F.l_arg )
                   break
               # tr_f.tr_one ( l_words [0], l_words[1] )


    self.close_log ()
    return rc

# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
             Load data into database.
             The simplest version, it uses PSQL
        """
#                  1       2           3             4            5                  6             7          8
        sa = " <Host_IP> <Port> <DB_name|Target> <User_name> <Batch_file_name> <Stdout_name> <Strerr_name> <Comment>"
        if ( len( sys.argv ) - 1 ) < 8:
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )
#
# Nick 2010-04-05 -----------------------------------------------------------------------------------------------------
#
        ml = make_load ( False, sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4] )
        rc = ml.to_do  ( sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6], sys.argv[7], sys.argv[8], None )
        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

