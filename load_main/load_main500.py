#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_main500.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
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
#       2014-06-16 - The pscopg2 library is used to synchronization of client and server times.
#       2016-12-06 - The port parameter is added
#       2018-02-03 - ((string.strip (l_words [1])))  was added 
# ----------------------------------------------------------------------------------------------------------
#       2019-04-19 - Rebuild base classes:  first for psql, second for psycopg2.
#                    ---------------------------------------------------------------------------------------
#              Modes "2" и "3" are deactivated. Next step is: 
#                                           "2" - loading into DB the XML/JSON-files,
#                                           "3" - Deferred loading, the "pgq" will be used.
#              Mode "4" was added: - Unload from DB the XML/JSON-structure.                                         
#              Mode "5" was added too: - Deferred unloading the XML/JSON-structures.
#              Next, there was removed the rest classes for hell. Deprecated and useless.
#              
#              The batch-file "stage*.txt". Modes 2-5, field №1 "File Name" will be references to 
#              the file "1*.conf". In this file there is the key-value pairs, separated "=>". 
#              "hstore" structure. After the loading into "load_main500.py", it trasnformed into
#              dictionary.
#
#              Structure of "1*.conf" file:
#
#                  data_file  => "<absolute or relative file path>"
#                  function   => "<db-function name>"
#                  param_list => "<list of function parameters>"
#      ----------------------------------------------------------------
#      Next, there are the example of processing of the file "1*.conf":
#          
#   fr_x2 = fd_l (p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)  -- Constructor
#   fr_x2.load (l_f_name, l_param_list, l_data_inp)                                 -- Loading XML/JSON
#   #
#   fr_x3 = fd_l (p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)  -- Constructor
#   fr_x3.load (l_f_name, l_param_list, l_data_inp)                                 -- Deffered loading XML/JSON
#   #
#   fr_x4 = fd_u (p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)  -- Constructor
#   fr_x4.unload (l_f_name, l_param_list, l_data_out)                               -- Unloading XML/JSON
#   #
#   fr_x5 = fd_u (p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)  -- Constructor
#   fr_x5.unload (l_f_name, l_param_list, l_data_out)                               -- Deferred unloading JSON-структуры
# -----------------------------------------------------------------------------------------------------------------------
#   2020-05-10 - The eighth parameter became the path to the project repository (The point of build DB)
# -----------------------------------------------------------------------------------------------------------------------
#   2020-05-31 - The  "2" - loading into DB the XML/JSON-files. It uses psql. 
# -----------------------------------------------------------------------------------------------------------------------

import sys
import os
import string
import datetime
import psycopg2    

from xml.dom.minidom import parse  # 2020-05-31

VERSION_STR = "  Version 3.0.3 Build 2020-07-28"

GET_DT = "SELECT now()::TIMESTAMP without time zone FROM current_timestamp;"

SCRIPT_NOT_OPENED_0 = "... Sript file not opened: '"
SCRIPT_NOT_OPENED_1 = "'."

# 2020-05-31
CONF_NOT_OPENED_0 = "... XML-conf file not opened: '"  
CONF_NOT_OPENED_1 = "'."

TAG1 = "xml_file"
TAG2 = "steps"
XXX0 = "#text"

DATA_NOT_OPENED_0 = "... DATA file not opened: '"  
DATA_NOT_OPENED_1 = "'."
# 2020-05-31

LOG_NOT_OPENED_0 = "... Log file not opened: '"
LOG_NOT_OPENED_1 = "'."

POINTS = " ... "
S_DELIM = "$"     # Nick 2020-06-01

#------------------------
bLOG_NAME = "process.log"
#------------------------

bCOMMENT_SIGN = "#"
bDELIMITER_SIGN = ";"

# ---------------------------------------------------------------------
DIRECT_SQL_COMMAND              = "0"
SEQUENCE_OF_SIMPLE_SQL_COMMANDS = "1"
LOAD_XJ                         = "2"    # Nick 2018-07-17/2019-05-19/2020-05-31
DEF_LOAD_XJ                     = "3"
UNLOAD_XJ                       = "4"    # Nick 2018-07-17/2019-05-19
DEF_UNLOAD_XJ                   = "5"    # Nick 2018-07-17/2019-05-19
#
# ---------------------------------------------------------------------
SPACE_0 = " "
# -----------------------------------

INPUT_CP = 'koi8_r'
BASE_CP = 'utf8'

PATH_DELIMITER = '/'  # Nick 2020-05-11

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
      The base class, for the psql utility.
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

class fd_l (fd_0):
    """
        Loading JSON/XML-structures. The main logic is in the DB-functions.

    """
    def __init__ ( self, p_host, p_port, p_db_name, p_user_name, p_out_name, p_err_name ):
        """
           Constructor for loader.
        """
        
        fd_0.__init__ (self, 0, p_host, p_port, p_db_name, p_user_name, p_out_name, p_err_name )
        
        self.l_2_pref_cmd = ""
        # self.cmd_list = []
        self.cmd_list = ""    # 2020-06-01
        
    def load_conf ( self, p_conf_file_name ):
        """
           load Conf-file
        """
        try:
            self.doc_1 = parse(p_conf_file_name)  # DOM-model was built
    
        except IOError, ex:
            print CONF_NOT_OPENED_0 + p_conf_file_name + CONF_NOT_OPENED_1
            return 1
        
        self.doc_1.normalize()
        
        # First step - open the data file
        xfile = self.doc_1.getElementsByTagName(TAG1)[0]  # "xml_file"
        xfname = xfile.childNodes[0].nodeValue
        try:
            self.fd = open ( xfname, "r" )
    
        except IOError, ex:
            print DATA_NOT_OPENED_0 + xfname + DATA_NOT_OPENED_1
            return 1
    
        nodeArray=self.doc_1.getElementsByTagName(TAG2)[0] # "steps"
        childList=nodeArray.childNodes
        for child in childList:
            if child.nodeName <> XXX0:
                # self.cmd_list.append(child.childNodes[0].nodeValue) # Nick 2020-06-1
                self.cmd_list = self.cmd_list + child.childNodes[0].nodeValue + S_DELIM
         #
        
        return 0
     
    def f_create ( self, p_file_name ):
        """
            Preparation of the executables
            use case:  "copy.py <dta_file> <args_str> | psql -h <hn> -U <un> <db>
        """
        self.file_name = p_file_name
        #
        self.l_arg = self.l_1 + self.host + +self.l_9 + self.port + self.l_2 + self.user_name
        self.l_arg = self.l_arg + self.l_4 + self.file_name + self.db_name
        self.l_arg = self.l_arg + self.l_4_out + self.out_name + self.l_5_err + self.err_name

    def f_run (self):
        """
          Perform the loading
        """

class fd_u (fd_l):
    """
      The fd_l class is overridden, now it is forming and unloading XML / JSON structures.
        All the logic in the DB functions layer of the database.
    """
    def f_save_local (self):
        """ 
           Savinf the unloading data.
        """ 
        return 0

class make_load ( fd_log ):
 """
    main class Nick 2010-03-31
        2014-06-16 Three parameters was added:
            - IP nost
            - DB-name
            - user name
 """
 def __init__ ( self, p_host_ip, p_port, p_db_name, p_user_name ):

    fd_log.__init__ ( self, p_host_ip, p_port, p_db_name, p_user_name )

 #
 # Nick 2010-04-05 -------------------------------------------------------------------------------------------
 #                    1          2         3          4            5          6            7          8      
 def to_do ( self, p_host_ip, p_port, p_db_name, p_user_name, p_batch_name,  p_std_out, p_std_err, p_path):

    try:
        fd = open ( p_batch_name, "r" )

    except IOError, ex:
        print SCRIPT_NOT_OPENED_0 + p_batch_name + SCRIPT_NOT_OPENED_1
        return 1

    self.c_list = fd.readlines ()
    fd.close ()

    self.path = string.strip (p_path) + PATH_DELIMITER

    s_lp = str ( p_host_ip ) + SPACE_0 + str ( p_port ) + SPACE_0 + str ( p_db_name ) + SPACE_0 + str ( p_user_name )
    s_lp = s_lp + SPACE_0 + str ( p_batch_name ) + SPACE_0 + str ( p_std_out ) + SPACE_0 + str ( p_std_err )

    self.open_log ( bLOG_NAME, self.path, s_lp )
    self.write_log_first ()

    rc = 0

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
                fr_0 = fd_0 ( 0, p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)

                fr_0.f_create ((string.strip (l_words [1])))  # Nick 2018-02-03
                rc = fr_0.f_run()

                if rc <> 0:     #  Fatal error, break process
                   self.write_log_err ( rc, fr_0.l_arg )
                   break

            #------------------------------------------------------------------------------
            if l_words [0] == SEQUENCE_OF_SIMPLE_SQL_COMMANDS:  # Sequence of simple SQL-commands
                fr_1 = fd_0 ( 1, p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)

                fr_1.f_create (self.path + (string.strip (l_words [1])))  # Nick 2018-02-03
                rc = fr_1.f_run()

                if rc <> 0:     #  Fatal error, break process
                   self.write_log_err ( rc, fr_1.l_arg )
                   break

            #----------------------------------------------------------------------------
            # -- Nick 2018-07-17/2019-05-19/2020-05-31 
            #
            if l_words [0] == LOAD_XJ:  # Load from XML/JSON-structure
                 fr_l_xj = fd_l( p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)
                 
                 rc = fr_l_xj.load_conf (self.path + (string.strip (l_words [1])))        # Nick 2020-07-28
                 if rc <> 0:     #  Fatal error, break process. It isn't possible load conf file.
                    self.write_log_err ( rc, fr_l_xj.l_arg )
                    break
             
                 # Loading   Переопределить
                 # fr_l_xj.f_create ()  # Prepare execute string 
                 # rc = fr_l_xj.f_run() # Do it
                 # if rc <> 0:     #  Fatal error, break process
                 #    self.write_log_err ( rc, fr_l_xj.l_arg )
                 #    break

            ##----------------------------------------------------------------------------
            if l_words [0] == DEF_LOAD_XJ:  # Deferred loading
                 fr_l_def_xj = fd_l ( p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)

                 rc = fr_l_def_xj.load_conf (self.path + (string.strip (l_words [1])))    # Nick 2020-07-28
                 if rc <> 0:     #  Fatal error, break process. It isn't possible load conf file.
                    self.write_log_err ( rc, fr_l_def_xj.l_arg )
                    break
             
                 # Loading
                 fr_l_def_xj.f_create ()  # Prepare execute string 
                 rc = fr_l_def_xj.f_run() # Do it
                 if rc <> 0:     #  Fatal error, break process
                    self.write_log_err ( rc, fr_l_def_xj.l_arg )
                    break

            #----------------------------------------------------------------------------
            if l_words [0] == UNLOAD_XJ:  # Create XML, Unload it, save to local file system.
                 fr_un_xj = fd_u ( p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)

                 rc = fr_un_xj.load_conf ((string.strip (l_words [1])))
                 if rc <> 0:     #  Fatal error, break process. It isn't possible load conf file.
                    self.write_log_err ( rc, fr_un_xj.l_arg )
                    break
             
                 # UnLoad XML
                 fr_un_xj.f_create ()  # Prepare execute string 
                 rc = fr_un_xj.f_run() # Do it
             
                 if rc <> 0:     #  Fatal error, break process
                    self.write_log_err ( rc, fr_un_xj.l_arg )
                    break
                
                 rc = fr_un_xj.f_save_local() # Do it
                 if rc <> 0:     #  Fatal error, break process
                    self.write_log_err ( rc, fr_un_xj.l_arg )
                    break
                
            #----------------------------------------------------------------------------
            if l_words [0] == DEF_UNLOAD_XJ:  # Unload_from JSON

                 fr_def_u_js = fd_u ( p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err)

                 rc = fr_def_u_js.load_conf ((string.strip (l_words [1])))
                 if rc <> 0:     #  Fatal error, break process. It isn't possible load conf file.
                    self.write_log_err ( rc, fr_def_u_js.l_arg )
                    break
             
                 # UnLoad XML
                 fr_def_u_js.f_create ()  # Prepare execute string 
                 rc = fr_def_u_js.f_run() # Do it
                 if rc <> 0:     #  Fatal error, break process
                    self.write_log_err ( rc, fr_def_u_js.l_arg )
                    break
                
                 rc = fr_def_u_js.f_save_local() # Do it
                 if rc <> 0:     #  Fatal error, break process
                    self.write_log_err ( rc, fr_def_u_js.l_arg )
                    break

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
#                  1       2        3          4            5               6             7             8
        sa = " <Host_IP> <Port> <DB_name> <User_name> <Batch_file_name> <Stdout_name> <Strerr_name> <Path>"
        if ( len( sys.argv ) - 1 ) < 8:
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )
#
# Nick 2010-04-05 -----------------------------------------------------------------------------------------------------
#
        ml = make_load ( sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4] )
        rc = ml.to_do  ( sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6], sys.argv[7], sys.argv[8] )
        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

