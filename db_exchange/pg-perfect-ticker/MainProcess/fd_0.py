#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: fd_all.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Base classes
#       2023-03-17 - version for python3

import sys
import os

VERSION_STR = "  Version 1.0.0 Build 2023-03-16"

#------------------------
bOUT_NAME = "{0}process{1}.out"
bERR_NAME = "{0}process{1}.err"
#------------------------
SPACE_0 = " "
#------------------------

class fd_0:
    """
      The base class, for the psql utility.
    """

    def __init__ ( self, p_mode, p_host, p_port, p_db_name, p_user_name, p_out_name, p_err_name,\
        p_proc_mark = "", p_log_mark = ""):

      self.host      = p_host
      self.db_name   = " " + p_db_name + " "
      self.port      = p_port
      self.user_name = p_user_name
      self.cmd_name  = ""
      
      self.out_name = p_out_name.format (p_proc_mark, p_log_mark)
      self.err_name = p_err_name.format (p_proc_mark, p_log_mark)
          
      #---------------------------
      self.l_1 = "psql -h "
      self.l_2 = " -p "
      self.l_2_pref_cmd = ""

      if ( p_mode == 0 ):
            self.l_2_pref_cmd = " -c \""
      else:
            self.l_2_pref_cmd = " -f \""

      self.l_3     = "\" "
      self.l_3_0   = " -U "      
      self.l_4_out = " 1>> "
      self.l_5_err = " 2>> "
      #---------------------------
      self.l_arg = ""

    def f_create (self, p_cmd_name):

        self.cmd_name = p_cmd_name
        self.l_arg = self.l_1 + self.host + self.l_2 + self.port + self.l_2_pref_cmd\
            + self.cmd_name
        self.l_arg = self.l_arg + self.l_3 + self.db_name + self.l_3_0 + self.user_name\
            + self.l_4_out
        self.l_arg = self.l_arg + self.out_name + self.l_5_err + self.err_name
        
    def f_create_1 (self, p_cmd_name, p_mode = 0):
        """
         Костыль, повторяющий функциональность "f_create".
        """
        if ( p_mode == 0 ):
            self.l_2_pref_cmd = " -c \""
        else:
            self.l_2_pref_cmd = " -f \""

        self.cmd_name = p_cmd_name
        self.l_arg = self.l_1 + self.host + self.l_2 + self.port + self.l_2_pref_cmd\
            + self.cmd_name
        self.l_arg = self.l_arg + self.l_3 + self.db_name + self.l_3_0 + self.user_name\
            + self.l_4_out
        self.l_arg = self.l_arg + self.out_name + self.l_5_err + self.err_name        

    def f_run (self):

      # print self.l_arg
      rc = 0
      rc = ( os.system ( self.l_arg ) )

      return rc

# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
             The simplest version, it uses PSQL
        """
#                  1       2        3          4      
        sa = " <Host_IP> <Port> <DB_name> <User_name> "
        if ( len( sys.argv ) - 1 ) < 4:
            print (VERSION_STR) 
            print ("  Usage: " + str ( sys.argv [0] ) + sa)
            sys.exit(1)
#
        fd0 = fd_0 ( 0, sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], bOUT_NAME, bERR_NAME )
        fd0.f_create ("SELECT 1")
        print (fd0.l_arg)
        fd0.f_run()
        
        sys.exit (0)

#---------------------------------------
    except KeyboardInterrupt as e:
        print ("... Terminated by user: ")
        sys.exit (1)


