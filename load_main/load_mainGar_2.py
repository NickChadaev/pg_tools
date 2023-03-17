#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainCar.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Load data into database
# HIST: 2021-11-23 - created
# NOTS: 
#       2022-03-08  Yaml-conf file       
# -----------------------------------------------------------------------------------------------------------------------

import sys
import os
import string
import datetime
import psycopg2    
#
import yaml
from yaml.loader import SafeLoader

import load_mainGar as LoadGar

VERSION_STR = "  Version 0.7.1 Build 2023-02-15"

YAML_NOT_OPENED_0 = "... Yaml file not opened: '"
YAML_NOT_OPENED_1 = "'."

POINTS = " ... "

#------------------------
bLOG_NAME = "process.log"
bOUT_NAME = "process.out"
bERR_NAME = "process.err"
bSQL_NAME = "process.sql"
#------------------------

S_DELIM = "="     # Nick 2022-03-09
bUL     = "_"
SPACE_0 = " "
EMP     = ""
# -----------------------------------

PATH_DELIMITER = '/'  # Nick 2020-05-11

class make_load_2 ():
 """
    main class Nick 2023-02-07
 """
 def __init__ (self, p_host_yaml, p_batch_file_name, p_path, p_version_date):

     yaml_file_name = string.strip (p_host_yaml)
     try:
         fy = open (yaml_file_name, "r" )
     
     except IOError, ex:
         print YAML_NOT_OPENED_0 + yaml_file_name + YAML_NOT_OPENED_1
         sys.exit( 1 )
     
     self.yaml_data = yaml.load(fy, Loader=SafeLoader) 
     self.batch_file_name = p_batch_file_name
     self.path            = p_path
     self.version_date    = p_version_date
     
 def to_do_2 (self, p_sw = False):
     
     rc = 0
     for host in self.yaml_data ['hosts']:
         h_name     = host     ['name']
         h_descr    = host     ['descr']
         h_conninfo = host     ['conninfo'] 
         h_params   = host     ['params'] 
         id_region  = h_params ['id_region']
         # 
         cinfos = string.split (h_conninfo, SPACE_0)
         for cinfo in cinfos:
             
             z = string.split (cinfo, S_DELIM)
             if z[0] == 'host':
                 host_ip = z[1]
             elif z[0] == 'port':  
                 port = z[1]
             elif z[0] == 'dbname':
                 db_name = z[1]
             elif z[0] == 'user':
                 user_name = z[1]
             else:
                 password = z[1]
         # 
         first_str = POINTS + h_descr + ", id_region: " + str(id_region)\
             + ", Process_id:" + str (os.getpid ())
         if not p_sw:
             print first_str 

         ml = LoadGar.make_load (host_ip, port, db_name, user_name)
         rc = ml.to_do  (host_ip, port, db_name, user_name, self.batch_file_name,\
                               bLOG_NAME, bOUT_NAME, bERR_NAME, bSQL_NAME, self.path, self.version_date,\
                                   p_id_region = id_region)  
         
         if not (rc == 0):
             sys.exit (rc)
     
         ## if p_sw:
         ##     import pgqueue
         ##     put_queue

     return rc
         
# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
        """
        sa = " <Yaml_file> <Batch_file> <Path> <Version>"
#                  1          2           3       4                
        
        if ( len( sys.argv ) - 1 ) < 4:
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )
        #
        ml = make_load_2 (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
        if ((len (sys.argv) - 1) == 4):
            rc = ml.to_do_2 ()
        else:    
            rc = ml.to_do_2 (bool(sys.argv[5]))
        
        sys.exit (rc)            
        
#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

