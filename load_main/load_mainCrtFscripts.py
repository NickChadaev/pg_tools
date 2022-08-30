#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainCrtFscripts.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities: It makes four files 
#               (crt_f_servers.sql, crt_f_strees.sql,  crt_f_houses, crt_f_objects)
# -----------------------------------------------------------------------------------------

import sys
import os
import string
import datetime
import psycopg2    

VERSION_STR_0 = "  Version 0.1.1 Build 2022-08-30"
VERSION_STR_1 = "  ------------------------------"

        #  1              2        3          4         5           6             7            8
        # csv           target   p_host_ip,  p_port, p_fschema, p_user_name, p_user_name_f, p_passwd_f
SA = " <CSV_pattern> <Target_Dir> <Host_ip>, <Port>, <Fschema>, <User_name>, <User_name_f>, <Passwd_f>"

 

USE_CASE = "  USE CASE: "
US ="    load_mainCrtFscripts.py pattern.csv ~/tmp 127.0.0.1 5435 gar_tmp postgres postgres ''"
#

FILE_NOT_OPENED_0 = "... File not opened: '"
FILE_NOT_OPENED_1 = "'."

POINTS = " ... "

bCOMMENT_SIGN = "#"
bDELIMITER_SIGN = ";"

SPACE_0 = " "
POINT_0 = "."
# -----------------------------------

PATH_DELIMITER = '/'  

ADR_AREA    = "adr_area"
ADR_STREET  = "adr_street"
ADR_HOUSE   = "adr_house" 
ADR_OBJECTS = "adr_objects"

ADR_AREA_DESCR    = ", Георегионы"
ADR_STREET_DESCR  = ", Улицы"
ADR_HOUSE_DESCR   = ", Строения" 
ADR_OBJECTS_DESCR = ", Адресные объекты"

SCHEMA = 'unnsi'

class m_fserver ():
    """
      Создаётся Внешний сервер.
    """
    def __init__ (self, p_path):
        
        self.fserver_file_name = p_path + "crt_fservers.sql"
        self.fserver_name = "f_unsi_test_{0:02d}" 
        self.fserver_body = """DROP SERVER IF EXISTS {0} CASCADE;
CREATE SERVER {0}
    FOREIGN DATA WRAPPER postgres_fdw  -- {1:02d} {2};
    OPTIONS (host '{3}', dbname 'unsi_test_{1:02d}', port '{4}');
CREATE USER MAPPING IF NOT EXISTS FOR {5} SERVER {0} OPTIONS (user '{6}', password '{7}');
--
"""
    def b_fserver_0 (self, p_fias_id):
        # Создаю имя внешнего сервера
        self.f_server_name = self.fserver_name.format(int (p_fias_id)) 

    def b_fserver_1 (self, p_fias_id, p_nm_area_full, p_host_ip, p_port,\
        p_user_name, p_user_name_f, p_passwd_f):
        # Создаю тело скрипта
        self.f_server = self.fserver_body.format (self.f_server_name, int (p_fias_id), p_nm_area_full,\
            p_host_ip, p_port, p_user_name, p_user_name_f, p_passwd_f)
          
class m_ftable ():
    """
     Создание внешней таблицы
    """
    def __init__ (self, p_path): 
       
        self.ftable_file_name = p_path + "crt_ftables.sql"
        
        self.ftable_name = "unnsi.adr_{0}_{1:02d}"
        
        self.ftable_body = """CREATE FOREIGN TABLE IF NOT EXISTS {0} (
) INHERITS ({1}) SERVER {2} OPTIONS (schema_name '{3}', table_name '{4}');
COMMENT ON FOREIGN TABLE {0} IS '{5:02d} -- {6}';
--
"""

    def b_ftable_0 (self, p_name_pattern, p_fias_id):
        # Создаю имя внешней таблицы 
        return self.ftable_name.format (p_name_pattern, int(p_fias_id)) 

    def b_ftable_1 (self, p_ftable_name, p_parent_name, p_fserver_name, p_lschema_name,\
        p_ltable_name, p_fias_id, p_comment):
        # Создаю тело скрипта для внешней таблицы.
        return self.ftable_body.format (p_ftable_name, p_parent_name, p_fserver_name,\
            p_lschema_name, p_ltable_name,  int(p_fias_id), p_comment)
           
class make_main ():   
 """
  Это самый главный 
 """
 #                                      
 def to_do ( self, p_csv_pattern, p_target_dir, p_host_ip, p_port, p_fschema, p_user_name,\
                p_user_name_f, p_passwd_f):
     
    path = string.strip (p_target_dir) + PATH_DELIMITER
    
    mfs = m_fserver (path)   # Внешние сервера 
    mft = m_ftable (path)   # Внешние таблицы.

    try:
        fd = open ( p_csv_pattern, "r" )

    except IOError, ex:
        print FILE_NOT_OPENED_0 + p_csv_pattern + FILE_NOT_OPENED_1
        return 1

    c_list = fd.readlines ()
    fd.close ()

    try:
        fsrv = open ( mfs.fserver_file_name, "a" )
    
    except IOError, ex:
        print FILE_NOT_OPENED_0 + mfs.fserver_file_name + FILE_NOT_OPENED_1
        return 1
    
    try:
        ftbl = open ( mft.ftable_file_name, "a" )
    
    except IOError, ex:
        print FILE_NOT_OPENED_0 + mft.ftable_file_name + FILE_NOT_OPENED_1
        return 1

    rc = 0
    
    for ce_list in c_list:
      if ce_list [0] <> bCOMMENT_SIGN:
        l_words = string.split ( ce_list, bDELIMITER_SIGN )

        if len (l_words) >= 5:
            fias_id      = string.strip (l_words [0])
            id_area      = string.strip (l_words [1])
            nm_area_full = string.strip (l_words [4])
            
            print fias_id + SPACE_0 + nm_area_full
            
            #
            #   1) Создать fservers
            #   
            mfs.b_fserver_0 (fias_id)
            mfs.b_fserver_1 (fias_id, nm_area_full, p_host_ip, p_port, p_user_name,\
                p_user_name_f, p_passwd_f)
            fsrv.write (mfs.f_server)
            #
            #   2) Создать ftables
            #
            adr_area_name    = mft.b_ftable_0 (ADR_AREA,    fias_id)
            adr_street_name  = mft.b_ftable_0 (ADR_STREET,  fias_id)
            adr_house_name   = mft.b_ftable_0 (ADR_HOUSE,   fias_id)
            adr_objects_name = mft.b_ftable_0 (ADR_OBJECTS, fias_id)

            adr_area_body    = mft.b_ftable_1 (adr_area_name, (SCHEMA + POINT_0 + ADR_AREA),\
                mfs.f_server_name, p_fschema, ADR_AREA, fias_id, (nm_area_full + ADR_AREA_DESCR))

            adr_street_body  = mft.b_ftable_1 (adr_street_name, (SCHEMA + POINT_0 + ADR_STREET),\
                mfs.f_server_name, p_fschema, ADR_STREET, fias_id, (nm_area_full + ADR_STREET_DESCR))
            
            adr_house_body   = mft.b_ftable_1 (adr_house_name, (SCHEMA + POINT_0 + ADR_HOUSE),\
                mfs.f_server_name, p_fschema, ADR_HOUSE, fias_id, (nm_area_full + ADR_HOUSE_DESCR))
            
            adr_objects_body = mft.b_ftable_1 (adr_objects_name, (SCHEMA + POINT_0 + ADR_OBJECTS),\
                mfs.f_server_name, p_fschema, ADR_OBJECTS, fias_id, (nm_area_full + ADR_OBJECTS_DESCR))

            ftbl.write (adr_area_body)
            ftbl.write (adr_street_body)
            ftbl.write (adr_house_body)
            ftbl.write (adr_objects_body)
            
    ftbl.close ()
    fsrv.close ()
            
    return rc

# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
        """
        if ( len( sys.argv ) - 1 ) < 7:
            print VERSION_STR_0
            print VERSION_STR_1 
            print "  Usage: " + str ( sys.argv [0] ) + SA            
            #
            print USE_CASE
            print US
            sys.exit( 1 )
#
        mm = make_main ()
        #  1      2       3         4         5           6             7           8
        # csv  target  p_host_ip, p_port, p_fschema, p_user_name, p_user_name_f, p_passwd_f
 
        rc = mm.to_do ( sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5],\
            sys.argv[6], sys.argv[7], sys.argv[8])
        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

## -------------------------------------------------------------------------------------------------------------------------
##  USE CASE:
##./load_mainCrtScripts.py pattern.csv ~/tmp '/media/rootadmin/Transcend' 'gar_xml.zip' 'FIAS_GAR_2022_03_10' '2022-03-10' 3
