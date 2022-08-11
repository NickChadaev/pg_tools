#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainStage6.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities.  
# -----------------------------------------------------------------------------------------

import sys

from GarProcess import stage_6_proc as Proc6
from GarProcess import stage_6_yaml as Yaml6

from MainProcess import fd_0 as Fd0
from MainProcess import fd_log as FdLog

VERSION_STR = "  Version 0.0.2 Build 2022-08-05" 

CONN_ABORTED = "... Connection aborted: "
OP_ABORTED = "... Operation aborted: "

ERR_NOT_OPENED_0 = "... Err file not opened: '"
ERR_NOT_OPENED_1 = "'."

OUT_NOT_OPENED_0 = "... Out file not opened: '"
OUT_NOT_OPENED_1 = "'."

#------------------------
bLOG_NAME = "process.log"
bOUT_NAME = "process.out"
bERR_NAME = "process.err"
#------------------------
POINTS = "... "
SPACE_0 = " "
SPACE_7 = "    -- "
bCP = "utf8"
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

class make_main (Proc6.proc_patterns, Yaml6.yaml_patterns, Fd0.fd_0, fd_log_z):     
 """
     It executes the functionality previously defined in stage_6.csv
 """

 def __init__(self, p_host_ip, p_port, p_db_name, p_user_name, p_yaml_file, p_path\
     ,p_fserver_nmb = None, p_fschemas = None):
     
     Proc6.proc_patterns.__init__(self)
     Yaml6.yaml_patterns.__init__(self, p_path, p_yaml_file, p_fserver_nmb, p_fschemas)
     
     fd_log_z.__init__(self, p_host_ip, p_port, p_db_name, p_user_name) 
     Fd0.fd_0.__init__(self, 0, p_host_ip, p_port, p_db_name, p_user_name, bOUT_NAME, bERR_NAME)

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
     
     self.s_arr_ids = "'{0}'"
     
     #------------------------------------------------------------
 
 def write_log_1 ( self, p_mess ):
     self.write_log (SPACE_7 + p_mess)
 
 def prt_stat (self):
     # print self.l_arg
     self.f_err.write ('\n' + self.l_arg + '\n')
     return 0
 
 def make_arr_bounds (self, p_init_value):

     lr = []
     for le in self.g_regions:
         le_min = le * p_init_value
         le_max = (le * p_init_value) + (p_init_value/100)*99
         lr.append([le_min,le_max])
         
     return lr    
 
 def stage_6 ( self, p_cmd, p_log_mess = None):  
     """
      Main method
     """
     if not (p_log_mess == None):
         self.write_log_1 (p_log_mess)
         
     self.f_create ( p_cmd )   
     rc = self.prt_stat() if self.MOGRIFY else self.f_run()
     
     if rc<> 0:    #  Fatal error, break process
         self.write_log_err ( rc, self.l_arg )
         self.close_log()
         self.f_err.close()
         self.f_out.close()
         
         sys.exit (rc)     
         
     return rc           
 
 def stage_6_0 ( self, p_MOGRIFY ): 
    """
     Смена индексного покрытия 
     that has been defined in stage_6.csv
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    # Смена индексного покрытия в целевых таблицах
       
    self.write_log_1(self.drp_lidx_descr)   
    
    if not self.drp_lidx_skip_area: 
        rc = self.stage_6 (self.gar_link_p_adr_area_idx.format\
            (self.g_fhost_id, self.g_adr_area_sch, False, False))        

    if not self.drp_lidx_skip_street:
        rc = self.stage_6 (self.gar_link_p_adr_street_idx.format\
            (self.g_fhost_id, self.g_adr_street_sch, False, False, False))
        
    if not self.drp_lidx_skip_house:
        rc = self.stage_6 (self.gar_link_p_adr_house_idx.format\
            (self.g_fhost_id, self.g_adr_house_sch, False, False, False))
        
    if not self.drp_lidx_skip_object:
        rc = self.stage_6 (self.gar_link_p_adr_objects_idx.format\
            (self.g_fhost_id, self.g_adr_house_sch, False, False, False))               
                           
    self.write_log_1 (self.crt_widx_descr)

    if not self.crt_widx_skip_area:
       rc = self.stage_6 (self.gar_link_p_adr_area_idx.format\
           (self.g_fhost_id, self.g_adr_area_sch, True, True))          
    #
    if not self.crt_widx_skip_street:    
       rc = self.stage_6 (self.gar_link_p_adr_street_idx.format\
           (self.g_fhost_id, self.g_adr_street_sch, True, True,\
               self.crt_widx_unique_street))

    if not self.crt_widx_skip_house:
        rc = self.stage_6 (self.gar_link_p_adr_house_idx.format\
            (self.g_fhost_id, self.g_adr_house_sch, True, True,\
                self.crt_widx_unique_house))
        
    if not self.crt_widx_skip_object:
        rc = self.stage_6 (self.gar_link_p_adr_objects_idx.format\
            (self.g_fhost_id, self.g_adr_house_sch, True, True, False))            
        
    return rc

 def stage_6_1 ( self, p_MOGRIFY): 
    """
       Поиск и коррекция дублей, таблица ADR_STREET
    """
    rc = 0
    self.MOGRIFY = p_MOGRIFY
    if not self.adr_street_check_twins_skip:
    
        # Улицы. Поиск и коррекция дублей

        ### self.gar_tmp_p_adr_street_check_twins = """CALL gar_tmp_pcg_trans.p_adr_street_check_twins (
        ###         p_schema_name      := '{0}'::text      -- Схема 
        ###        ,p_conn_name        := (gar_link.f_conn_set({1}::numeric(3)))::text   -- Именованое dblink-соединение
        ###        ,p_street_ids       := {2}::bigint [][] -- Массив граничных значений  
        ###        ,p_mode             := {3}::boolean     -- Постобработка FALSE.
        ###        ,p_bound_date       := {4}::date        -- Только для режима Post обработки. '2022-01-01' 
        ###        ,p_schema_hist_name := '{5}'::text      -- Схема с историческими данными 'gar_tmp'             
        ### );
        ### """
        sa = ((self.s_arr_ids.format(self.make_arr_bounds(self.adr_street_check_twins_init_value)))\
            .replace('[', '{')).replace (']', '}') 
        
        rc = self.stage_6 (self.gar_tmp_p_adr_street_check_twins.format (self.g_adr_street_sch,\
            self.g_fhost_id, sa, False, self.adr_street_check_twins_bound_date,\
                    self.g_history_sch), self.adr_street_check_twins_descr)        

        # -- Улицы. Контрольный запрос.
        rc = self.stage_6 (self.check_data_adr_street.format(self.adr_street_cquery))
            
    return rc

 def stage_6_2 ( self, p_MOGRIFY): 
    """
      Поиск и коррекция дублей, таблица ADR_HOUSE
    """
    rc = 0
    self.MOGRIFY = p_MOGRIFY
    
    self.write_log_1(self.adr_house_check_twins_descr)
    
    if not self.adr_house_check_twins_skip_1:
    
        # Поиск и коррекция дублей, часть 1
        ### self.gar_tmp_p_adr_house_check_twins = """CALL gar_tmp_pcg_trans.p_adr_house_check_twins (
        ###         p_schema_name      := '{0}'::text      -- Схема 
        ###        ,p_conn_name        := (gar_link.f_conn_set({1}::numeric(3)))::text   -- Именованое dblink-соединение
        ###        ,p_house_ids        := {2}::bigint [][] -- Массив граничных значений  
        ###        ,p_mode             := {3}::boolean     -- Постобработка FALSE.
        ###        ,p_bound_date       := {4}::date        -- Только для режима Post обработки. '2022-01-01' 
        ###        ,p_schema_hist_name := '{5}'::text      -- Схема с историческими данными 'gar_tmp'             
        ### );
        self.s_arr_ids = "'{0}'"
        sa = ((self.s_arr_ids.format(self.make_arr_bounds(self.adr_house_check_twins_init_value)))\
            .replace('[', '{')).replace (']', '}') 
        
        rc = self.stage_6 (self.gar_tmp_p_adr_house_check_twins_1.format(self.g_adr_house_sch,\
            self.g_fhost_id, sa, False, self.adr_house_check_twins_bound_date,self.g_history_sch))

    if not self.adr_house_check_twins_skip_2:

        # Поиск и коррекция дублей, часть 2
        ### gar_tmp_pcg_trans.p_adr_house_check_twins_1 (
        ###                p_schema_name      := '{0}'::text      -- Схема   
        ###               ,p_conn_name        := (gar_link.f_conn_set({1}::numeric(3)))::text   -- Именованое dblink-соединение 
        ###               ,p_mode             := {2}::boolean     -- Постобработка FALSE.              
        ###               ,p_bound_date       := {3}::date        -- Только для режима Post обработки. '2022-01-01'
        ###               ,p_schema_hist_name := '{4}'::text      -- Схема с историческими данными 'gar_tmp'             
        ###        );
        rc = self.stage_6 (self.gar_tmp_p_adr_house_check_twins_2.format(self.g_adr_house_sch,\
            self.g_fhost_id, False, self.adr_house_check_twins_bound_date,self.g_history_sch))

        # -- Дома. Контрольный запрос.
        rc = self.stage_6 (self.check_data_adr_house.format(self.adr_house_cquery))
            
    return rc

    #   self.crt_unique_indexies_descr = stage_6 ['gar_crt_unique_indexies'] ['descr']
    
 def stage_6_3 ( self, p_MOGRIFY ): 
    """
     Смена индексного покрытия 
     that has been defined in stage_6.csv
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
       
    self.write_log_1(self.crt_unique_indexies_descr)
    
    # Смена индексного покрытия в целевых таблицах
    if not self.crt_unique_indexies_street_skip:
        # -- Улицы. Установка уникального индекса
        rc = self.stage_6 (self.gar_link_p_adr_street_idx_set_uniq.format\
                (self.g_fhost_id, self.g_adr_street_sch, True, True,\
                    self.crt_unique_indexies_street_uniq_sw))

    if not self.crt_unique_indexies_house_skip:        
        # -- Дома. Установка уникального индекса.
        rc = self.stage_6 (self.gar_link_p_adr_house_idx_set_uniq.format\
                (self.g_fhost_id, self.g_adr_street_sch, True, True,\
                    self.crt_unique_indexies_house_uniq_sw))

    return rc

# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
        """
#                  1       2        3          4            5             6        7  
        sa = " <Host_IP> <Port> <DB_name> <User_name> <YAML_file_name> <Path> <fserver_nmb>"
        if ( len( sys.argv ) - 1 ) < 7:
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )
#
        mm = make_main (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]\
            ,sys.argv[5], sys.argv[6], sys.argv[7])  

        s_lp = str (sys.argv[1]) + SPACE_0 + str (sys.argv[2]) + SPACE_0\
            + str (sys.argv[3]) + SPACE_0
        s_lp = s_lp + str (sys.argv[4]) + SPACE_0 + str (sys.argv[5]) 
     
        mm.open_log (bLOG_NAME, sys.argv[6], s_lp)
        mm.write_log_first ()
 
        if mm.stage_6_0_on: 
            rc = mm.stage_6_0 ( mm.mogrify_6_0 )
         
        if mm.stage_6_1_on: 
            rc = mm.stage_6_1 ( mm.mogrify_6_1 )
        
        if mm.stage_6_2_on: 
            rc = mm.stage_6_2 ( mm.mogrify_6_2 )
        
        if mm.stage_6_3_on: 
            rc = mm.stage_6_3 ( mm.mogrify_6_3 )
        
        mm.close_log ()
        mm.f_err.close()
        mm.f_out.close()        
        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

#-----------------------------------------------------------------------------------------
#   $>./load_mainStage6.py 127.0.0.1 5433 unsi_test_12 postgres stage_6.yaml . 47 # 47 ??
#-----------------------------------------------------------------------------------------
