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

VERSION_STR = "  Version 0.7.0 Build 2023-02-07"

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

class make_load_4 ():
 """
    main class Nick 2023-02-07
 """
 def __init__ ( self, p_host_yaml, p_version_date ):

     yaml_file_name = string.strip (p_host_yaml)
     try:
         fy = open (yaml_file_name, "r" )
     
     except IOError, ex:
         print YAML_NOT_OPENED_0 + yaml_file_name + YAML_NOT_OPENED_1
         sys.exit( 1 )
     
     self.yaml_data = yaml.load(fy, Loader=SafeLoader) 
     self.version_date = p_version_date
     
 def to_do_4 (self, p_sw = False):
     
     if self.yaml_data.has_key ('global_params'):
         
         self.fserver_nmb     = self.yaml_data ['global_params'] ['g_fserver_nmb']
         self.adr_area_sch    = self.yaml_data ['global_params'] ['g_adr_area_sch']
         self.adr_street_sch  = self.yaml_data ['global_params'] ['g_adr_street_sch']
         self.adr_house_sch   = self.yaml_data ['global_params'] ['g_adr_house_sch']
         self.adr_house_sch_l = self.yaml_data ['global_params'] ['g_adr_house_sch_l']
         self.schemas = (adr_area_sch, adr_street_sch, adr_house_sch, adr_house_sch_l)
         
     else:
         self.fserver_nmb = None
         self.schemas = None
         
     rc = 0
     
     for host in self.yaml_data ['hosts']:
         self.h_name     = host ['name']
         self.h_descr    = host ['descr']
         self.h_conninfo = host ['conninfo'] 
         h_params        = host ['params'] 
         #
         self.id_region       = h_params ['id_region']
         self.batch_file_name = h_params ['exec']
         self.path            = h_params ['path']
         # 
         self.batch_file_name = self.path + PATH_DELIMITER + self.batch_file_name
         
         cinfos = string.split (self.h_conninfo, SPACE_0)
         for cinfo in cinfos:
             
             z = string.split (cinfo, S_DELIM)
             if z[0] == 'host':
                 self.host_ip = z[1]
             elif z[0] == 'port':  
                 self.port = z[1]
             elif z[0] == 'dbname':
                 self.db_name = z[1]
             elif z[0] == 'user':
                 self.user_name = z[1]
             else:
                 self.password = z[1]

         first_str = POINTS + self.h_descr + ", id_region: " + str(self.id_region)\
             + ", Execute: " + self.batch_file_name + ', process_id:' + str (os.getpid ())
         if not p_sw:
             print first_str 
                
         ml = LoadGar.make_load (self.host_ip, self.port, self.db_name, self.user_name)
         rc = ml.to_do (self.host_ip, self.port, self.db_name, self.user_name, self.batch_file_name,\
             bOUT_NAME, bERR_NAME, self.path, self.version_date, self.fserver_nmb, self.schemas,\
                 self.id_region)     
         
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
#                  1          2           3           
        sa = " <Yaml_file> <Version>"
#                  1          2               
        
        if ((len( sys.argv ) - 1) < 2):
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )
        
        ml = make_load_4 (sys.argv[1], sys.argv[2])
        if ((len (sys.argv) - 1) == 2):
            rc = ml.to_do_4 ()
        else:    
            rc = ml.to_do_4 (bool(sys.argv[3]))
        
        sys.exit (rc)

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

