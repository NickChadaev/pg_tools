#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainStage4.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities.  
#       2023-03-28 - version for python3
# -----------------------------------------------------------------------------------------

import sys

from GarProcess import stage_4_proc as Proc4
from GarProcess import stage_4_yaml as Yaml4

from MainProcess import fd_0 as Fd0
from MainProcess import fd_log as FdLog

VERSION_STR = "  Version 1.0.0 Build 2023-03-28"

ERR_NOT_OPENED_0 = "... Err file not opened: '"
ERR_NOT_OPENED_1 = "'."

OUT_NOT_OPENED_0 = "... Out file not opened: '"
OUT_NOT_OPENED_1 = "'."

#-------------------------------
bLOG_NAME = "process.log"
bOUT_NAME = "{0}process{1}.out"
bERR_NAME = "{0}process{1}.err"
#-------------------------------
POINTS = "... "
SPACE_0 = " "
SPACE_7 = "    -- "
EMP = ""
#-----------------------------------

class fd_log_z ( FdLog.fd_log ):
    
 def set_file_log ( self, p_fd = None ):
     """
      Открытый файл "process.log"
     """
     if not (p_fd == None):
         self.fd = p_fd
         self.s_delimiter = "--------------------------------------------------------" + '\n'
         
class make_main (Proc4.proc_patterns, Yaml4.yaml_patterns, Fd0.fd_0, fd_log_z):     
 """
     It executes the functionality previously defined in stage_4.csv
 """

 def __init__(self, p_host_ip, p_port, p_db_name, p_user_name, p_yaml_file, p_path, p_std_out, p_std_err,\
     p_prt_sw = True, p_proc_mark = EMP, p_log_mark = EMP):
     
     Proc4.proc_patterns.__init__(self)
     Yaml4.yaml_patterns.__init__(self, p_path, p_yaml_file)
     
     fd_log_z.__init__(self, p_host_ip, p_port, p_db_name, p_user_name, p_prt_sw, p_proc_mark) 
     Fd0.fd_0.__init__(self, 0, p_host_ip, p_port, p_db_name, p_user_name, p_std_out, p_std_err,\
         p_proc_mark, p_log_mark)

     # 2022-05-11
     try:
         self.f_err = open ((p_std_err.format (p_proc_mark, p_log_mark)), "a" )   
     except IOError as ex:
         print (ERR_NOT_OPENED_0 + (p_std_err.format (p_proc_mark, p_log_mark)) + ERR_NOT_OPENED_1)
         sys.exit (1)
         
     std_out = p_std_out.format(p_proc_mark,p_log_mark)    
     try:
         self.f_out = open (std_out, "a")   
     except IOError as ex:
         print (OUT_NOT_OPENED_0 + std_out + OUT_NOT_OPENED_1)
         sys.exit (1)
     # 2022-05-11
     
     #------------------------------------------------------------
 
 def write_log_1 (self, p_mess):
     self.write_log (SPACE_7 + p_mess)
 
 def prt_stat (self):
     # print self.l_arg
     self.f_err.write ('\n' + self.l_arg + '\n')
     return 0
 
 def stage_4 (self, p_cmd, p_log_mess = None, p_mode = 0):  
     """
      Main method
     """
     if not (p_log_mess == None):
         self.write_log_1 (p_log_mess)
         
     self.f_create_1 (p_cmd, p_mode)   
     rc = self.prt_stat() if self.MOGRIFY else self.f_run()
     
     if not (rc == 0):    #  Fatal error, break process
         self.write_log_err ( rc, self.l_arg )
         self.close_log()
         self.f_err.close()
         self.f_out.close()
         
         sys.exit (rc)     
         
     return rc           
 
 def stage_4_1 ( self, p_MOGRIFY ): 
    """
      Адресные регионы, дополнение
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    if not self.adr_area_ins_skip:
    #
        rc = self.stage_4 (self.gar_tmp_pcg_trans_f_adr_area_ins.format\
            (self.adr_area_ins_schema_data, self.adr_area_ins_schema_etl,\
                self.g_history_sch, self.adr_area_ins_sw_hist), self.adr_area_ins_descr)
        
        if not (rc == 0):
            return rc

        rc = self.stage_4 (self.gar_tmp_pcg_trans_f_adr_area_check.format\
            (self.adr_area_ins_check_query), None)
    
    return rc

 def stage_4_2 ( self, p_MOGRIFY): 
    """
      Адресные регионы, обновление
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    if not self.adr_area_upd_skip:
    
        rc = self.stage_4 (self.gar_tmp_pcg_trans_f_adr_area_upd.format\
            (self.adr_area_upd_schema_data, self.adr_area_upd_schema_etl,\
                self.g_history_sch, self.adr_area_upd_sw_hist), self.adr_area_upd_descr)
        
        if not (rc == 0):
            return rc

        rc = self.stage_4 (self.gar_tmp_pcg_trans_f_adr_area_check.format\
            (self.adr_area_upd_check_query), None)
    
    return rc

 def stage_a_p ( self, p_MOGRIFY): 
    """
      Адресные регионы, постобработка.
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    return self.stage_4 (self.adr_area_pp_query1, self.adr_area_pp_descr, 1)

 def stage_4_3 ( self, p_MOGRIFY): 
    """
      Элемент улично-дорожной сети/Элемент планировочной структуры. Дополнение.
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    if not self.adr_street_ins_skip:
    
        rc = self.stage_4 (self.gar_tmp_pcg_trans_f_adr_street_ins.format\
            (self.adr_street_ins_schema_data, self.adr_area_upd_schema_etl,\
                self.g_history_sch, self.adr_street_ins_sw_hist), self.adr_street_ins_descr)

        if not (rc == 0):
            return rc

        rc = self.stage_4 (self.gar_tmp_pcg_trans_f_adr_street_check.format\
            (self.adr_street_ins_check_query), None)        

    return rc

 def stage_4_4 ( self, p_MOGRIFY ): 
    """
          Элемент улично-дорожной сети/Элемент планировочной структуры. Обновление.
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    if not self.adr_street_upd_skip:

        rc = self.stage_4 (self.gar_tmp_pcg_trans_f_adr_street_upd.format\
            (self.adr_street_upd_schema_data, self.adr_street_upd_schema_etl,\
                self.g_history_sch, self.adr_street_upd_sw_hist, self.adr_street_upd_sw_twin),\
                    self.adr_street_upd_descr)
                 
        if not (rc == 0):
            return rc

        rc = self.stage_4 (self.gar_tmp_pcg_trans_f_adr_street_check.format\
            (self.adr_street_upd_check_query), None)           
        #
    return rc

 def stage_s_p ( self, p_MOGRIFY): 
    """
      Улицы, постобработка.
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    return self.stage_4 (self.adr_street_pp_query1, self.adr_street_pp_descr, 1)

 def stage_4_5 ( self, p_MOGRIFY): 
    """
      Дома и строения. Дополнение.
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    if not self.adr_house_ins_skip:

        rc = self.stage_4 (self.gar_tmp_pcg_trans_f_adr_house_ins.format\
            (self.adr_house_ins_schema_data, self.adr_house_ins_schema_etl,\
                self.g_history_sch, self.adr_house_ins_sw, self.adr_house_ins_sw_twin)\
                    , self.adr_house_ins_descr)   
                 
        if not (rc == 0):
            return rc

        rc = self.stage_4 (self.gar_tmp_pcg_trans_f_adr_house_check.format\
            (self.adr_house_ins_check_query), None)    
        
    return rc

 def stage_4_6 ( self, p_MOGRIFY): 
    """
      Дома и строения. Обновление.
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    if not self.adr_house_upd_skip:
    
        rc = self.stage_4 (self.gar_tmp_pcg_trans_f_adr_house_upd.format\
            (self.adr_house_upd_schema_data, self.adr_house_upd_schema_etl,\
                self.g_history_sch, self.adr_house_upd_sw_hist, self.adr_house_upd_sw_twin, \
                self.adr_house_upd_sw, self.adr_house_upd_sw_del), self.adr_house_upd_descr) 
        
        if not (rc == 0):
            return rc

        if not ( self.adr_house_upd_check_query == None ): 
            rc = self.stage_4 (self.gar_tmp_pcg_trans_f_adr_house_check.format\
                (self.adr_house_upd_check_query), None)    
        
    return rc

 def stage_h_p ( self, p_MOGRIFY): 
    """
      Дома, постобработка.
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    return self.stage_4 (self.adr_house_pp_query1, self.adr_house_pp_descr, 1)

# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
        """
#                  1       2        3          4            5             6           
        sa = " <Host_IP> <Port> <DB_name> <User_name> <YAML_file_name> <Path>"
        if ( len( sys.argv ) - 1 ) < 6:
            print (VERSION_STR) 
            print ("  Usage: " + str ( sys.argv [0] ) + sa)
            sys.exit( 1 )
#
        mm = make_main (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]\
            ,sys.argv[5], sys.argv[6], bOUT_NAME, bERR_NAME)  

        s_lp = str (sys.argv[1]) + SPACE_0 + str (sys.argv[2]) + SPACE_0\
            + str (sys.argv[3]) + SPACE_0
        s_lp = s_lp + str (sys.argv[4]) + SPACE_0 + str (sys.argv[5]) 
     
        mm.open_log (bLOG_NAME, sys.argv[6], s_lp)
        mm.write_log_first ()
 
        if mm.stage_4_1_on: 
            rc = mm.stage_4_1 ( mm.mogrify_4_1 )
         
        if mm.stage_4_2_on: 
            rc = mm.stage_4_2 ( mm.mogrify_4_2 )

        if mm.stage_a_p_on: 
            rc = mm.stage_a_p ( mm.mogrify_a_p )
        
        if mm.stage_4_3_on: 
            rc = mm.stage_4_3 ( mm.mogrify_4_3 )
        
        if mm.stage_4_4_on: 
            rc = mm.stage_4_4 ( mm.mogrify_4_4 )

        if mm.stage_s_p_on: 
            rc = mm.stage_s_p ( mm.mogrify_s_p )
        
        if mm.stage_4_5_on: 
            rc = mm.stage_4_5 ( mm.mogrify_4_5 )
         
        if mm.stage_4_6_on: 
            rc = mm.stage_4_6 ( mm.mogrify_4_6 )

        if mm.stage_h_p_on: 
            rc = mm.stage_h_p ( mm.mogrify_h_p )
            
        mm.close_log ()
        mm.f_err.close()
        mm.f_out.close()        
        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt as e:
        print ("... Terminated by user: ")
        sys.exit (1)

#-----------------------------------------------------------------------------------------
#   $>./load_mainStage4.py 127.0.0.1 5433 unsi_test_12 postgres stage_4.yaml . 47 # 47 ??
#-----------------------------------------------------------------------------------------
