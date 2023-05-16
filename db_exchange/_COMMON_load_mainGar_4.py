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
import pgqueue
import time

#
import yaml
from yaml.loader import SafeLoader

import load_mainGar as LoadGar

VERSION_STR = "  Version 0.0.0 Build 2023-03-26"

YAML_NOT_OPENED_0 = "... Yaml file not opened: '"
YAML_NOT_OPENED_1 = "'."

S_DELIM = "="     # Nick 2022-03-09
bUL     = "_"
SPACE_0 = " "
EMP     = ""
# -----------------------------------

INSERT_EVENT = """
CALL uio.p_event_ins (
    p_nm_queue  := (NULLIF (%s, ''))::text 
   ,p_ev_type   := (NULLIF (%s, ''))::text 
   ,p_ev_data   := (NULLIF (%s, ''))::text 
   ,p_ev_extra1 := (NULLIF (%s, ''))::text 
   ,p_ev_extra2 := (NULLIF (%s, ''))::text 
   ,p_ev_extra3 := (NULLIF (%s, ''))::text 
   ,p_ev_extra4 := (NULLIF (%s, ''))::text
);
"""

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
     
     #---
     self.conn = psycopg2.connect("dbname=db_exchange user=postgres port=5433")
     self.conn.autocommit = True
     self.curs = self.conn.cursor()
     
 def to_do_4 (self):
     
     fserver_nmb = None
     schemas = None
     hn = "{0:02d}" 
         
     if self.yaml_data.has_key ('global_params'):
         
         prefix    = self.yaml_data ['global_params'] ['prefix']
         path      = self.yaml_data ['global_params'] ['path']
         exec_proc = self.yaml_data ['global_params'] ['exec_proc']
        
     else:
         
         prefix    = None
         path      = None
         exec_proc = None
     
     batch_proc_name = path + PATH_DELIMITER + prefix + PATH_DELIMITER + exec_proc 
     rc = 0
     
     for host in self.yaml_data ['hosts']:
         
         id_region    = host ['id_region']
         h_name =  hn.format (int(host ['name']))
         h_descr      = host ['descr']
         h_conninfo   = host ['conninfo'] 
         h_exec_parse = host ["exec_parse"]
         # 
         batch_parse_name = path + PATH_DELIMITER + prefix + PATH_DELIMITER + h_name\
             + PATH_DELIMITER + h_exec_parse    

         log_pref = path + PATH_DELIMITER + prefix + PATH_DELIMITER + h_name
        
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

         first_str_parse = h_descr + ", id_region: " + str(id_region)\
             + ", Execute: " + batch_parse_name + ", process_id:" + str (os.getpid ())
                
         first_str_proc = h_descr + ", id_region: " + str(id_region)\
             + ", Execute: " + batch_proc_name + ", process_id:" + str (os.getpid ())
                
         dev_parse = string.replace(str((host_ip, port, db_name, user_name, batch_parse_name,\
             path, self.version_date, fserver_nmb, schemas, id_region)), "'", "")         

         dev_proc = string.replace(str((host_ip, port, db_name, user_name, batch_proc_name,\
             path, self.version_date, fserver_nmb, schemas, id_region)), "'", "")         

         parse_type = "parse_" + h_name
         proc_type = "proc_" + h_name
          

         # ev_type  -- "parse_" + name  + "|" + "proc_" + name 
         # ev_data  --  dev_parse + "|" + log_pref 
         # ex1_data --  first_str_parse
         # ex2_data --  dev_proc +  "|" + log_pref 
         # ex3_data --  first_str_proc
         
         print parse_type
         print proc_type
         print batch_parse_name
         print batch_proc_name
         print first_str_parse
         print first_str_proc
         print dev_parse
         print dev_proc
         print log_pref
         
         self.curs.execute (INSERT_EVENT,("QF", proc_type, first_str_proc, \
             "", "", "", ""))         
         
         self.curs.execute (INSERT_EVENT,("QP", (parse_type + "|" + proc_type),\
             (dev_parse + "|" + log_pref), first_str_parse, (dev_proc + "|" + log_pref),\
                 first_str_proc, ""))
                                                                               
     return rc
 
# ----------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
        """
#                  1          2                   
        sa = " <Yaml_file> <Version>"
#                  1          2               
        
        if ((len( sys.argv ) - 1) < 2):
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )
        
        ml = make_load_4 (sys.argv[1], sys.argv[2])
        rc = ml.to_do_4 ()
        
        sys.exit (rc)

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

# ===================================================================================================
##  $>./_COMMON_load_mainGar_4.py hosts_common_xx_311.yaml 2022-12-26
##  parse_01
##  proc_01
##  /home/rootadmin/abr_upload/Y_BUILD/01/stage_gar_c_01.csv
##  /home/rootadmin/abr_upload/Y_BUILD/stage_346.csv
##  Адыгея Респ, id_region: 2, Execute: /home/rootadmin/abr_upload/Y_BUILD/01/stage_gar_c_01.csv, process_id:21422
##  Адыгея Респ, id_region: 2, Execute: /home/rootadmin/abr_upload/Y_BUILD/stage_346.csv, process_id:21422
##  (127.0.0.1, 5435, unsi_test_01, postgres, /home/rootadmin/abr_upload/Y_BUILD/01/stage_gar_c_01.csv, /home/rootadmin/abr_upload, 2022-12-26, None, None, 2)
##  (127.0.0.1, 5435, unsi_test_01, postgres, /home/rootadmin/abr_upload/Y_BUILD/stage_346.csv, /home/rootadmin/abr_upload, 2022-12-26, None, None, 2)
##  /home/rootadmin/abr_upload/Y_BUILD/01
##  parse_03
##  proc_03
##  /home/rootadmin/abr_upload/Y_BUILD/03/stage_gar_c_03.csv
##  /home/rootadmin/abr_upload/Y_BUILD/stage_346.csv
##  Бурятия Респ, id_region: 3, Execute: /home/rootadmin/abr_upload/Y_BUILD/03/stage_gar_c_03.csv, process_id:21422
##  Бурятия Респ, id_region: 3, Execute: /home/rootadmin/abr_upload/Y_BUILD/stage_346.csv, process_id:21422
##  (127.0.0.1, 5435, unsi_test_03, postgres, /home/rootadmin/abr_upload/Y_BUILD/03/stage_gar_c_03.csv, /home/rootadmin/abr_upload, 2022-12-26, None, None, 3)
##  (127.0.0.1, 5435, unsi_test_03, postgres, /home/rootadmin/abr_upload/Y_BUILD/stage_346.csv, /home/rootadmin/abr_upload, 2022-12-26, None, None, 3)
##  /home/rootadmin/abr_upload/Y_BUILD/03
##  parse_04
##  proc_04
##  /home/rootadmin/abr_upload/Y_BUILD/04/stage_gar_c_04.csv
##  /home/rootadmin/abr_upload/Y_BUILD/stage_346.csv
##  Алтай Респ, id_region: 5, Execute: /home/rootadmin/abr_upload/Y_BUILD/04/stage_gar_c_04.csv, process_id:21422
##  Алтай Респ, id_region: 5, Execute: /home/rootadmin/abr_upload/Y_BUILD/stage_346.csv, process_id:21422
##  (127.0.0.1, 5435, unsi_test_04, postgres, /home/rootadmin/abr_upload/Y_BUILD/04/stage_gar_c_04.csv, /home/rootadmin/abr_upload, 2022-12-26, None, None, 5)
##  (127.0.0.1, 5435, unsi_test_04, postgres, /home/rootadmin/abr_upload/Y_BUILD/stage_346.csv, /home/rootadmin/abr_upload, 2022-12-26, None, None, 5)
##  /home/rootadmin/abr_upload/Y_BUILD/04
##  parse_06
##  proc_06
##  /home/rootadmin/abr_upload/Y_BUILD/06/stage_gar_c_06.csv
##  /home/rootadmin/abr_upload/Y_BUILD/stage_346.csv
##  Ингушетия Респ, id_region: 7, Execute: /home/rootadmin/abr_upload/Y_BUILD/06/stage_gar_c_06.csv, process_id:21422
##  Ингушетия Респ, id_region: 7, Execute: /home/rootadmin/abr_upload/Y_BUILD/stage_346.csv, process_id:21422
##  (127.0.0.1, 5435, unsi_test_06, postgres, /home/rootadmin/abr_upload/Y_BUILD/06/stage_gar_c_06.csv, /home/rootadmin/abr_upload, 2022-12-26, None, None, 7)
##  (127.0.0.1, 5435, unsi_test_06, postgres, /home/rootadmin/abr_upload/Y_BUILD/stage_346.csv, /home/rootadmin/abr_upload, 2022-12-26, None, None, 7)
##  /home/rootadmin/abr_upload/Y_BUILD/06
##  
