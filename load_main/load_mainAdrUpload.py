#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainAdrUpload.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities.  
# -----------------------------------------------------------------------------------------

import os
import sys
import psycopg2  
import string

from os import stat
from stat import S_ISDIR
from os import listdir

from GarProcess import stage_6_proc as Proc6
from GarProcess import stage_6_yaml as Yaml6

from MainProcess import fd_0 as Fd0
from MainProcess import fd_log as FdLog

VERSION_STR = "  Version 0.3.0 Build 2023-01-28" 

CONN_ABORTED = "... Connection aborted: "
OP_ABORTED = "... Operation aborted: "

ERR_NOT_OPENED_0 = "... Err file not opened: '"
ERR_NOT_OPENED_1 = "'."

OUT_NOT_OPENED_0 = "... Out file not opened: '"
OUT_NOT_OPENED_1 = "'."

DATA_NOT_OPENED_0 = "... Data file not opened: '"
DATA_NOT_OPENED_1 = "'."

#------------------------
bLOG_NAME = "process.log"
bOUT_NAME = "process.out"
bERR_NAME = "process.err"
#------------------------
POINTS = "... "
SPACE_0 = " "
SPACE_7 = "    -- "
F_DELIM  = "\."  
  
bEMP = ""
bNL = '\n'
bLB = "["
bRB = "]"
bL  = "L"
bS  = "'"
bNCAT = "N"
bNone = "None" 
bNULL = "\N"
bDL = "|"
bMN = "-"

bCP = "utf8"

cMKDIR = "mkdir "
cIDX   = "IDX"
cDATA  = "DATA"

cOP0 = "cp "
cOP1 = "/GAR_TMP_PCG_TRANS/INDICES/[dc]*.sql "
cOP2 = "/GAR_TMP_PCG_TRANS/SH/load_upd[._][ws]* "

#-----------------------------------
#          1       2        3          4          5             6              7           8          
SA = " <Host_IP> <Port> <DB_name> <User_name> <YAML_path> <YAML_file_name> <Id_region> <Data-version>"
IA = 8
#
ADR_AREA = "adr_area"
ADR_AREA_AUX = "adr_area_aux"
ADR_AREA_FILE = "adr_area_{0:02d}.sql"

ADR_STREET = "adr_street"                     
ADR_STREET_AUX = "adr_street_aux"
ADR_STREET_FILE = "adr_street_{0:02d}.sql"

ADR_HOUSE = "adr_house"
ADR_HOUSE_AUX = "adr_house_aux"
ADR_HOUSE_FILE = "adr_house_{0:02d}.sql"          

PATH_DELIMITER = '/' 
SEPARATOR = '---------------------------'

FETCH_COUNT = 500
ZP = "z."

#-----------------------------------
class fd_log_z ( FdLog.fd_log ):
    
 def set_file_log ( self, p_fd = None ):
     """
      Открытый файл "process.log"
     """
     if not (p_fd == None):
         self.fd = p_fd
         self.s_delimiter = "--------------------------------------------------------" + '\n'
         
## def set_date_time ( self, p_date_time = None, p_delta_dt = None ):
##     """
##       Константы, синхронизация локального времени и времени сервера
##     """
##     if not (p_date_time == None):
##              self.date_time = p_date_time
## 
##     if not (p_delta_dt == None):
##              self.delta_dt = p_delta_dt

class AdrUpload (Proc6.proc_patterns, Yaml6.yaml_patterns, Fd0.fd_0, fd_log_z):     
 """
     It executes the functionality previously defined in stage_6_proc/yaml.py
#          1       2        3          4          5             6              7            8
SA = " <Host_IP> <Port> <DB_name> <User_name> <YAML_path> <YAML_file_name> <Id_region> <data_version>"
IA = 7     
     
 """

 def __init__(self, p_host_ip, p_port, p_db_name, p_user_name, p_yaml_path, p_yaml_file\
     ,p_id_region, p_data_version, p_fserver_nmb = None):
     
     Proc6.proc_patterns.__init__(self)
     Yaml6.yaml_patterns.__init__(self, p_yaml_path, p_yaml_file, p_fserver_nmb, p_id_region)

     fd_log_z.__init__(self, p_host_ip, p_port, p_db_name, p_user_name) 
     Fd0.fd_0.__init__(self, 0, p_host_ip, p_port, p_db_name, p_user_name, bOUT_NAME, bERR_NAME)

     self.host_ip = p_host_ip
     self.port = p_port
     self.db_name = p_db_name
     self.user_name = p_user_name

     # 2022-05-11
     try:
         self.f_err = open ( bERR_NAME, "a" )  
     except IOError, ex:
         print ERR_NOT_OPENED_0 + bERR_NAME + ERR_NOT_OPENED_1
         sys.exit (1)
         
     try:
         self.f_out = open ( bOUT_NAME, "a" )   
     except IOError, ex:
         print OUT_NOT_OPENED_0 + bOUT_NAME + OUT_NOT_OPENED_1
         sys.exit (1)
     # 2022-05-11
 
     # + 1) Версия добавляется к имени каталога данными    
     self.file_path = self.file_path + string.replace (p_data_version, bMN, bEMP)
     #------------------------------------------------------------
 
 def to_do (self, p_ADR_FILE_NAME):
     """
             aaup.to_do(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], aaup.adr_area_sch_l,\
                ADR_AREA, ADR_AREA_AUX, ADR_AREA_FILE.format(str(sys.argv[8]))
     """
     #
     # Try to make output dir
     #
     try:
         x = S_ISDIR (os.stat (self.file_path)[0] )
                     
     except  OSError, ex:
         os.system ( cMKDIR + self.file_path )
                    
     idx_dir = self.file_path + PATH_DELIMITER + cIDX
     try:
         x = S_ISDIR ( os.stat (idx_dir)[0] )
                     
     except  OSError, ex:
         os.system ( cMKDIR + idx_dir )

     dat_dir = self.file_path + PATH_DELIMITER + cDATA
     try:
         x = S_ISDIR ( os.stat (dat_dir)[0] )
                     
     except  OSError, ex:
         os.system ( cMKDIR + dat_dir )
     
     data_name = dat_dir + PATH_DELIMITER + p_ADR_FILE_NAME
     
     # проверить все dir на пустоту !!!!
     if (len (listdir(idx_dir)) == 0):
         try:
             l_cmd = cOP0 + self.git_path + cOP1 + idx_dir + "/."
             os.system (l_cmd)
         
         except  OSError, ex:
             print ex
             sys.exit(1)
         
     if (len (listdir(self.file_path)) == 2):    
         try:
             l_cmd = cOP0 + self.git_path + cOP2 + self.file_path + "/."
             os.system (l_cmd)
         
         except  OSError, ex:
             print ex
             sys.exit(1)

     try:
         self.f_data = open ( data_name, "w+" )   #  Truncate file
     except IOError, ex:
         print DATA_NOT_OPENED_0 + data_name + DATA_NOT_OPENED_1
         sys.exit (1)
 
     self.column_names = []
     self.column_categories = []
     self.ids_u = []
     #
     #-------------------------------------- 
     #  Open connection.
     #
     rc = -1  
     l_s = "host = " + str (self.host_ip) + " port = " + str (self.port) + " dbname = " +\
         str (self.db_name) + " user = " + str ( self.user_name )

     try:
          self.conn7 = psycopg2.connect(l_s)
          self.cur7= self.conn7.cursor()
      
     except psycopg2.OperationalError, e:
          print "... Connection aborted: "
          print "... " + str (e)
          sys.exit ( rc )
     
     self.cur7.arraysize = FETCH_COUNT 
     # -------------------------------
     return data_name
 
 def write_log_1 ( self, p_mess ):
     self.write_log (SPACE_7 + p_mess)
 
 def prt_stat (self, p_cmd):
     self.f_err.write ('\n' + p_cmd + '\n')
     return 0
 
 def aa_get_columns ( self, p_sch, p_ADR_MAIN, p_MOGRIFY ): 
     """
       Список столбцов, их типы/категории-
            self.sch_l = p_sch_l
            self.ADR_MAIN = p_ADR_MAIN
            self.ADR_AUX = p_ADR_AUX
     """
     rc = 0
     
     l_cmd = self.gar_link_f_show_col_descr.format (p_sch, p_ADR_MAIN)
     
     if p_MOGRIFY:
         self.prt_stat (l_cmd)
         
     self.cur7.execute(l_cmd)

     rows = self.cur7.fetchmany() 
     for row in rows:
         self.column_names.append(row[5])      
         self.column_categories.append(row[10])
     
     self.conn7.commit()  
   
     return rc

 def aa_get_data_0 ( self, p_sch, p_ADR_AUX, p_MOGRIFY ): 
     """
       IDs из таблицы  gar_tmp.adr_area_aux-
     """
     rc = 0
     l_cmd = self.get_op_sign_u.format(self.column_names[0], p_sch, p_ADR_AUX)

     if p_MOGRIFY:
         self.prt_stat (l_cmd)
         
     self.cur7.execute (l_cmd)
     rows = self.cur7.fetchmany () 
     
     while rows:
         for id in rows:
             self.ids_u.append (id[0])
             
         rows = self.cur7.fetchmany()    
         
     self.conn7.commit()  
         
     return rc

 def aa_put_data_0 ( self, p_sch, p_ADR_MAIN ): 
     """
       Формирую первую часть файла с данными:
       DELETE FROM unnsi.adr_area WHERE id_area = ANY (ARRAY[1,2,])-
     """
     rc = 0
    
     l_str = self.part_8 + bNL   # BEGIN;
     l_str = l_str + self.part_0.format (p_sch, p_ADR_MAIN, self.column_names[0],\
         (str(self.ids_u).replace (bL,bEMP)) )
     
     self.f_data.write (l_str + bNL + SEPARATOR + bNL) 
     
     return rc

 def aa_get_data_1 ( self, p_sch, p_ADR_MAIN, p_ADR_AUX ): 
     """
       Большой цикл и формирую по записям, стуктуру понятную COPY с разделителями "|".
     """
     l_column_names = []
     for l_cname in self.column_names:
         l_column_names.append((ZP + l_cname))
     
     l_cmd = (self.part_2.format(((str(l_column_names)).replace(bLB, bEMP)).replace(bRB,bEMP),\
         p_sch, p_ADR_MAIN, p_ADR_AUX, self.column_names[0])).replace (bS, bEMP)

     return l_cmd

 def aa_put_data_1 ( self, p_sch_l, p_sch_t, p_ADR_MAIN, p_ADR_AUX, p_MOGRIFY ): 
     """
       Формирую вторую часть файла с данными:
       Записи из таблиц gar_tmp.adr_area_aux JOIN gar_tmp.adr_area_aux 
       по записям, с буфферизацией.
     """
     rc = 0
     l_cmd = self.aa_get_data_1 ( p_sch_l, p_ADR_MAIN, p_ADR_AUX )
     
     if p_MOGRIFY:
         self.prt_stat (l_cmd)
         
     self.f_data.write(self.part_1.format (p_sch_t, p_ADR_MAIN,\
         ((str(self.column_names).replace(bLB, bEMP)).replace(bRB,bEMP)).\
             replace(bS, bEMP)) + bNL) 
     
     self.cur7.execute ( l_cmd )
     rows = self.cur7.fetchmany() 
     
     l_str = bEMP
     while rows:
         for row in rows:
             for li in range (len(self.column_names)):
                 l_str = l_str + str(row[li]) + bDL         
                
             l_str1 = string.strip(l_str, bDL)
             l_str1 = l_str1 + bNL                 
             
             self.f_data.write(l_str1.replace(bNone,bNULL))  
             l_str = bEMP
         
         rows = self.cur7.fetchmany()    
         
     self.conn7.commit()  
     
     self.f_data.write(F_DELIM + bNL)
     self.f_data.write(self.part_9 + bNL)  # COMMIT
     
     return rc

 def proc_rc (self, p_rc):
     
     self.write_log_err (p_rc, self.l_arg)
     self.close_log()
     self.f_err.close()
     self.f_out.close()
     #
     self.cur7.close()
     self.conn7.close()
     self.f_data.close()
     
     sys.exit (p_rc)     

 def stage_up (self, p_sch_l, p_sch_t, p_ADR_MAIN, p_ADR_AUX, p_MOGRIFY, p_log_mess = None):  
     """
      Main method.
     """
     rc = 0
     # -----------------------------------------------------
     if not (p_log_mess == None):
         self.write_log_1 (p_log_mess)
         
     rc = self.aa_get_columns ( p_sch_l, p_ADR_MAIN, p_MOGRIFY )
     if rc <> 0: #  Fatal error, break process
         self.proc_rc (rc) 

     rc = self.aa_get_data_0 ( p_sch_l, p_ADR_AUX, p_MOGRIFY )
     if rc <> 0: #  Fatal error, break process
         self.proc_rc (rc) 

     rc = self.aa_put_data_0 ( p_sch_t, p_ADR_MAIN )    
     if rc <> 0: #  Fatal error, break process
         self.proc_rc (rc) 
     
     rc = self.aa_put_data_1 (p_sch_l, p_sch_t, p_ADR_MAIN, p_ADR_AUX, p_MOGRIFY) 
     if rc <> 0: #  Fatal error, break process
         self.proc_rc (rc) 
      
     self.cur7.close()
     self.conn7.close()
     self.f_data.close()
     
     return rc           

# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
            Main entrypoint for the class
            #-----------------------------------
            #          1       2        3          4          5             6               7           8           
            SA = " <Host_IP> <Port> <DB_name> <User_name> <YAML_path> <YAML_file_name> <Id_region> <Data-version>"
            IA = 8
        """
        rc = 0
        
        if ( len( sys.argv ) - 1 ) < IA:
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + SA
            sys.exit( 1 )
     
        # Adr_areas
        aaup = AdrUpload ( sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4],\
            sys.argv[5], sys.argv[6], sys.argv[7], sys.argv[8] ) 

        if aaup.stage_6_1_on:   
            aaup.to_do (ADR_AREA_FILE.format(int(sys.argv[7]))) # str
            aaup.stage_up (aaup.adr_area_sch_l, aaup.adr_area_sch, ADR_AREA, ADR_AREA_AUX, aaup.mogrify_6_1) #  "Выгрузка в файл"
        
        # Adr_streets
        asup = AdrUpload ( sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4],\
            sys.argv[5], sys.argv[6], sys.argv[7], sys.argv[8] ) 
        
        if asup.stage_6_2_on:
            asup.to_do (ADR_STREET_FILE.format (int(sys.argv[7])))  # str
            asup.stage_up (asup.adr_street_sch_l, asup.adr_street_sch, ADR_STREET, ADR_STREET_AUX, asup.mogrify_6_2)
        
        # Adr_houses
        ahup = AdrUpload ( sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4],\
            sys.argv[5], sys.argv[6], sys.argv[7], sys.argv[8] ) 
        
        if ahup.stage_6_3_on:
            ahup.to_do (ADR_HOUSE_FILE.format (int(sys.argv[7]))) # str
            ahup.stage_up (ahup.adr_house_sch_l, ahup.adr_house_sch, ADR_HOUSE, ADR_HOUSE_AUX, ahup.mogrify_6_3)
        
        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

#-----------------------------------------------------------------------------------------
# $>./load_mainAdrUpload.py 127.0.0.1 5434 unsi_test_01 postgres . stage_6.yaml ~/tmp 01
