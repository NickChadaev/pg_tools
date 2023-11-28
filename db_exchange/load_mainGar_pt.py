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
import time

#
import yaml
from yaml.loader import SafeLoader

VERSION_STR = "  Version 0.1.0 Build 2023-11-27"

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

class make_load_pt ():
 """
    main class Nick 2023-02-07/2023-11-27
    <Host_IP> <Port> <DB_name> <User_name> <Yaml_file> <Version>
    
 """
 def __init__ ( self, p_host_ip, p_port, p_db_name, p_user_name, p_host_yaml, p_version_date ):

     yaml_file_name = string.strip (p_host_yaml)
     try:
         fy = open (yaml_file_name, "r" )
     
     except IOError, ex:
         print YAML_NOT_OPENED_0 + yaml_file_name + YAML_NOT_OPENED_1
         sys.exit( 1 )
     
     self.yaml_data = yaml.load(fy, Loader=SafeLoader) 
     self.version_date = p_version_date
     self.date_proc = datetime.datetime.now().isoformat()
     
     #---
     s_lp = "host=" + str(p_host_ip) + SPACE_0 + "port=" + str(p_port) + SPACE_0 +\
         "dbname=" + str(p_db_name) + SPACE_0 + "user=" + str(p_user_name) 
     
     self.conn = psycopg2.connect(s_lp)
     self.conn.autocommit = True
     self.curs = self.conn.cursor()
     
 def to_do_pt (self):
     
     fserver_nmb = None
     schemas = None
     hn = "{0:02d}"  
         
     if self.yaml_data.has_key ('global_params'):
         
         prefix    = self.yaml_data ['global_params'] ['prefix']
         path      = self.yaml_data ['global_params'] ['path']
         exec_proc = self.yaml_data ['global_params'] ['exec_proc']
         
         # + 2023-11-27
         
         yaml_stage_6 = self.yaml_data ['global_params'] ['yaml_stage_6']  # + /home/n.chadaev@abrr.local
         postproc_sh  = self.yaml_data ['global_params'] ['postproc_sh']   # + /home/n.chadaev@abrr.local + Y_BUILD
         upd_path     = self.yaml_data ['global_params'] ['upd_path']      # + /home/n.chadaev@abrr.local
         new_owner    = self.yaml_data ['global_params'] ['new_owner']
         new_grp      = self.yaml_data ['global_params'] ['new_grp']         
        
     else:
         
         prefix    = None
         path      = None
         exec_proc = None
         
         # + 2023-11-27
         
         yaml_stage_6 = None
         postproc_sh  = None
         upd_path     = None
         new_owner    = None
         new_grp      = None
         
     batch_proc_name = path + PATH_DELIMITER + prefix + PATH_DELIMITER + exec_proc 
         
     # + 2023-11-27
              
     yaml_stage_6 = path + PATH_DELIMITER + yaml_stage_6  
     postproc_sh  = path + PATH_DELIMITER + prefix + PATH_DELIMITER + postproc_sh 
     upd_path     = path + PATH_DELIMITER + upd_path
             
     rc = 0
     print self.date_proc
     last_type = "last_0"

     self.curs.execute (INSERT_EVENT,("QL0", last_type, (str(self.date_proc)+ "|" +\
         str(self.version_date) + "|" + yaml_stage_6 + "|" + postproc_sh + "|" + upd_path +\
             "|" + new_owner + "|" + new_grp), "", "", "", ""))
                                                                               
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
         proc_type  = "proc_" + h_name

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
         #       1          2       3         4           5          6   
        sa = " <Host_IP> <Port> <DB_name> <User_name> <Yaml_file> <Version>"
        
        if ((len( sys.argv ) - 1) < 2):
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )
        
        rc = 0
        ml = make_load_pt (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4],sys.argv[5], sys.argv[6])
        rc = ml.to_do_pt ()
        
        sys.exit (rc)

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        s1ys.exit (1)

# ===================================================================================================
