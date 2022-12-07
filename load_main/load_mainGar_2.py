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

VERSION_STR = "  Version 0.5.3 Build 2022-12-06"

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


# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
        """
#                  1       2       3          4            5             6        7             
#       sa = " <Host_IP> <Port> <DB_name> <User_name> <Batch_file_name> <Path> <Version>"
        sa = " <Yaml_file> <Batch_file> <Path> <Version>"
#                  1          2           3       4                
        
        if ( len( sys.argv ) - 1 ) < 4:
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )
        #
        # Nick 2022-03-09 --------------------------------------------------
        #
        yaml_file_name = sys.argv[1]
        try:
            fy = open (yaml_file_name, "r" )
        
        except IOError, ex:
            print YAML_NOT_OPENED_0 + yaml_file_name + YAML_NOT_OPENED_1
            sys.exit( 1 )
        
        yaml_data = yaml.load (fy, Loader=SafeLoader) 
        rc = 0
        for host in yaml_data ['hosts']:
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
            
            # From command line options
            batch_file_name = sys.argv[2]
            path            = sys.argv[3]
            version_date    = sys.argv[4]
            # 
            print POINTS + h_descr + ", id_region: " + str(id_region)
            ml = LoadGar.make_load (host_ip, port, db_name, user_name)
            rc = ml.to_do  (host_ip, port, db_name, user_name, batch_file_name,\
                                  bOUT_NAME, bERR_NAME, path, version_date,\
                                      p_id_region = id_region)  
            if not (rc == 0):
                sys.exit (rc)
            
        sys.exit (rc)

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

