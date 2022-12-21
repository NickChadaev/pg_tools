#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainStage6.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities.  
# -----------------------------------------------------------------------------------------

import sys
import psycopg2   

from GarProcess import stage_6_proc as Proc6
from GarProcess import stage_6_yaml as Yaml6

from MainProcess import fd_0 as Fd0
from MainProcess import fd_log as FdLog

VERSION_STR = "  Version 0.1.1 Build 2022-12-19" 

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
#          1       2        3          4            5             6         7
SA = " <Host_IP> <Port> <DB_name> <User_name> <YAML_file_name> <Path> <dt_gar_version>"
IA = 7
#
ADR_AREA = "adr_area"
ADR_AREA_AUX = "adr_area_aux"
ADR_AREA_FILE = "adr_area.sql"

ADR_STREET = "adr_street"
ADR_STREET_AUX = "adr_street_aux"
ADR_STREET_FILE = "adr_street.sql"

ADR_HOUSE = "adr_house"
ADR_HOUSE_AUX = "adr_house_aux"
ADR_HOUSE_FILE = "adr_house.sql"

PATH_DELIMITER = '/' 
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
     ,p_dt_gar_version, p_fserver_nmb = None, p_id_region = None):
     
     Proc6.proc_patterns.__init__(self)
     Yaml6.yaml_patterns.__init__(self, p_path, p_yaml_file, p_fserver_nmb, p_id_region)

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
     self.dt_gar_version = p_dt_gar_version
     #-------------------------------------- 
     #  Open connection.
     #
     rc = -1  
     l_s = "host = " + str (p_host_ip) + " port = " + str (p_port) + " dbname = " + str (p_db_name) + " user = " + str ( p_user_name )

     try:
          self.conn6 = psycopg2.connect(l_s)
          self.cur6 = self.conn6.cursor()
      
     except psycopg2.OperationalError, e:
          print "... Connection aborted: "
          print "... " + str (e)
          sys.exit ( rc )
     
     #------------------------------------------------------------
 
 def write_log_1 ( self, p_mess ):
     self.write_log (SPACE_7 + p_mess)
 
 def prt_stat (self):
     # print self.l_arg
     self.f_err.write ('\n' + self.l_arg + '\n')
     return 0
 
 def stage_6 ( self, p_cmd, p_log_mess = None, p_mode = 0):  
     """
      Main method
     """
     if not (p_log_mess == None):
         self.write_log_1 (p_log_mess)
         
     self.f_create_1 ( p_cmd, p_mode )   
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
      Сохранение записи в журнале выгрузок (master-запись).
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    if not self.save_ver_skip: 
        self.stage_6 (self.export_f_version_put.format\
            (self.dt_gar_version, self.kd_export_type, self.region_id,\
                self.seq_name, self.fserver_nmb), self.save_ver_descr)     
        
    return rc

 def stage_6_1 ( self, p_MOGRIFY): 
    """
     # Это постанализ и выгрузка адресных пространств
     0;SELECT count(1) AS qty_adr_area_main_0 FROM gar_tmp.adr_area;; -- Количество в gar_tmp.adr_area;
     0;SELECT count(1) AS qty_adr_area_aux_0 FROM gar_tmp.adr_area_aux;; -- Количество в gar_tmp.adr_area_aux;
     #
     1;../../A_FIAS_LOADER/GAR_TMP_PCG_TRANS/DO/adr_area_post_proc_1.sql;; -- Постанализ списка адресных регионов;
     0;CALL gar_tmp_pcg_trans.p_adr_area_upload ('gar_tmp', 'unnsi');; -- Выгрузка adr_area;
    """
    rc = 0
    self.MOGRIFY = p_MOGRIFY
    
    qty_total = 0   # Отдельное соединение
    qty_mod = 0
    
    if not self.aa_upload_skip:
    
        self.write_log_1 (self.aa_upload_descr)
        
        self.cur6.execute(self.check_data_adr.format(self.adr_area_sch_l, ADR_AREA))
        qty_total = self.cur6.fetchone()[0]
        self.conn6.commit()        
        
        self.cur6.execute(self.check_data_adr.format(self.adr_area_sch_l, ADR_AREA_AUX))
        qty_mod = self.cur6.fetchone()[0]
        self.conn6.commit()

        self.stage_6 (self.check_data_adr_1.format (qty_total,(ADR_AREA + "_0"))); 
        self.stage_6 (self.check_data_adr_1.format (qty_mod,(ADR_AREA_AUX + "_0"))); 

        if not (self.aa_upload_pa_script == None):
            self.stage_6 (self.post_adr_area.format(self.aa_upload_pa_script),p_mode = 1)
       
        self.stage_6 (self.gar_tmp_p_adr_area_upload.format\
            (self.adr_area_sch_l,self.adr_area_sch))

        if not self.save_ver_skip: 
            
            if not self.kd_export_type:
                file_path = (self.file_path + PATH_DELIMITER + ADR_AREA_FILE)
            else:
                file_path = ''
                
            self.stage_6 (self.export_f_version_by_obj_put.format\
                (self.dt_gar_version, self.adr_area_sch_l, ADR_AREA, qty_total, qty_mod,\
                    file_path))
            
    return rc

 def stage_6_2 ( self, p_MOGRIFY): 
    """
     Поиск дублей, постанализ и выгрузка улиц 
     0;SELECT count(1) AS qty_adr_street_main_0 FROM gar_tmp.adr_street;; -- Количество в gar_tmp.adr_street;
     0;SELECT count(1) AS qty_adr_street_aux_0 FROM gar_tmp.adr_street_aux;; -- Количество в gar_tmp.adr_street_aux;
     #
     0;CALL gar_link.p_adr_street_idx ('gar_tmp', NULL, false, false);; -- Улицы. Убираю Процессинговые ; 
     0;CALL gar_link.p_adr_street_idx ('gar_tmp', NULL, true, true, false);; -- Улицы. Эксплуатационное неуникальное индексное покрытие;
     #
     0;SELECT * FROM gar_tmp_pcg_trans.fp_adr_street_check_twins_local('gar_tmp');; -- Постобработка;
     #
     0;SELECT count(1) AS qty_adr_street_main_1 FROM gar_tmp.adr_street;; -- Количество в gar_tmp.adr_street;
     0;SELECT count(1) AS qty_adr_street_aux_1 FROM gar_tmp.adr_street_aux;; -- Количество в gar_tmp.adr_street_aux;
     #
     0;CALL gar_link.p_adr_street_idx_set_uniq ('gar_tmp', NULL, true, true);; -- Уникальность в эксплуатационных;
     0;CALL gar_link.p_adr_street_idx ('gar_tmp', NULL, true, false);; -- Убираю эксплуатационные;
     0;CALL gar_link.p_adr_street_idx ('gar_tmp', NULL, false, true);; -- Создаю процессинговые;
     #
     1;../../A_FIAS_LOADER/GAR_TMP_PCG_TRANS/DO/adr_street_post_proc_1.sql;; -- Постанализ списка улиц;
     0;CALL gar_tmp_pcg_trans.p_adr_street_upload ('gar_tmp', 'unnsi');; -- Выгрузка adr_street;
    """
    rc = 0
    self.MOGRIFY = p_MOGRIFY
    
    qty_total = 0   # Отдельное соединение
    qty_mod = 0   
    
    if not self.as_upload_skip:

        self.write_log_1 (self.as_upload_descr)
        
        self.cur6.execute(self.check_data_adr.format(self.adr_street_sch_l, ADR_STREET))
        qty_total = self.cur6.fetchone()[0]
        self.conn6.commit()
        
        self.cur6.execute(self.check_data_adr.format(self.adr_street_sch_l, ADR_STREET_AUX))
        qty_mod = self.cur6.fetchone()[0]
        self.conn6.commit()

        self.stage_6 (self.check_data_adr_1.format (qty_total,(ADR_STREET + "_0"))); 
        self.stage_6 (self.check_data_adr_1.format (qty_mod,(ADR_STREET_AUX + "_0")));     
    
        self.stage_6 (self.gar_link_p_adr_street_idx.format\
            (self.adr_street_sch_l,'NULL', False, False, False)) 
            
        self.stage_6 (self.gar_link_p_adr_street_idx.format\
            (self.adr_street_sch_l,'NULL', True, True, False)) 

        self.stage_6 (self.gar_tmp_fp_adr_street_check_twins_local.format\
            (self.adr_area_sch_l, self.as_bound_date, self.adr_hist_sch))
        
        self.cur6.execute(self.check_data_adr.format(self.adr_street_sch_l, ADR_STREET))
        qty_total = self.cur6.fetchone()[0]
        self.conn6.commit()

        self.cur6.execute(self.check_data_adr.format(self.adr_street_sch_l, ADR_STREET_AUX))
        qty_mod = self.cur6.fetchone()[0]
        self.conn6.commit()

        self.stage_6 (self.check_data_adr_1.format (qty_total,(ADR_STREET + "_1"))); 
        self.stage_6 (self.check_data_adr_1.format (qty_mod,(ADR_STREET_AUX + "_1")));     
        
        self.stage_6 (self.gar_link_p_adr_street_idx_set_uniq.format\
            (self.adr_area_sch_l, 'NULL', True, True)) 

        self.stage_6 (self.gar_link_p_adr_street_idx.format\
            (self.adr_street_sch_l,'NULL', True, False, False)) 

        self.stage_6 (self.gar_link_p_adr_street_idx.format\
            (self.adr_street_sch_l,'NULL', False, True, True)) 
        
        if not (self.as_upload_pa_script == None):
            self.stage_6 (self.post_adr_street.format(self.as_upload_pa_script),p_mode = 1)
       
        self.stage_6 (self.gar_tmp_p_adr_street_upload.format\
            (self.adr_street_sch_l,self.adr_street_sch))

        if not self.save_ver_skip:
            
            if not self.kd_export_type:
                file_path = (self.file_path + PATH_DELIMITER + ADR_STREET_FILE)
            else:
                file_path = ''
                
            self.stage_6 (self.export_f_version_by_obj_put.format\
                (self.dt_gar_version, self.adr_street_sch_l, ADR_STREET, qty_total, qty_mod,\
                    file_path))
               
    return rc

 def stage_6_3 ( self, p_MOGRIFY ): 
    """
     0;SELECT count(1) AS qty_adr_house_main_0 FROM gar_tmp.adr_house;; -- Количество в gar_tmp.adr_house;
     0;SELECT count(1) AS qty_adr_house_aux_0 FROM gar_tmp.adr_house_aux;; -- Количество в gar_tmp.adr_house_aux;
     #
     0;CALL gar_link.p_adr_house_idx ('gar_tmp', NULL, false, false);; -- Дома. Убираю Процессинговые ; 
     0;CALL gar_link.p_adr_house_idx ('gar_tmp', NULL, true, true, false);; -- Дома. Эксплуатационное неуникальное индексное покрытие;
     #
     0;SELECT * FROM gar_tmp_pcg_trans.fp_adr_house_check_twins_local('gar_tmp');; -- Постобработка;
     #
     0;SELECT count(1) AS qty_house_main_1 FROM gar_tmp.adr_house;; -- Количество в gar_tmp.adr_house;
     0;SELECT count(1) AS qty_house_aux_1 FROM gar_tmp.adr_house_aux;; -- Количество в gar_tmp.adr_house_aux;
     #
     0;CALL gar_link.p_adr_house_idx_set_uniq ('gar_tmp', NULL, true, true);; -- Уникальность в эксплуатационных;
     0;CALL gar_link.p_adr_house_idx ('gar_tmp', NULL, true, false);; -- Убираю эксплуатационные;
     0;CALL gar_link.p_adr_house_idx ('gar_tmp', NULL, false, true);; -- Создаю процессинговые;
     #
     1;../../A_FIAS_LOADER/GAR_TMP_PCG_TRANS/DO/adr_house_post_proc_1.sql;; -- Постанализ списка домов;
     0;CALL gar_tmp_pcg_trans.p_adr_house_upload ('gar_tmp', 'unnsi');; -- Обратная выгрузка adr_house;

    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    qty_total = 0   # Отдельное соединение
    qty_mod = 0   
    
    if not self.as_upload_skip:

        self.write_log_1 (self.ah_upload_descr)
        
        self.cur6.execute(self.check_data_adr.format(self.adr_house_sch_l, ADR_HOUSE))
        qty_total = self.cur6.fetchone()[0]
        self.conn6.commit()
             
        self.cur6.execute(self.check_data_adr.format(self.adr_house_sch_l, ADR_HOUSE_AUX))
        qty_mod = self.cur6.fetchone()[0]
        self.conn6.commit()

        self.stage_6 (self.check_data_adr_1.format (qty_total,(ADR_HOUSE + "_0"))); 
        self.stage_6 (self.check_data_adr_1.format (qty_mod,(ADR_HOUSE_AUX + "_0"))); 
        
        self.stage_6 (self.gar_link_p_adr_house_idx.format\
            (self.adr_house_sch_l,'NULL', False, False, False)) 
            
        self.stage_6 (self.gar_link_p_adr_house_idx.format\
            (self.adr_house_sch_l,'NULL', True, True, False)) 

        self.stage_6 (self.gar_tmp_fp_adr_house_check_twins_local.format\
            (self.adr_house_sch_l, self.as_bound_date, self.adr_hist_sch))
  
        self.cur6.execute(self.check_data_adr.format(self.adr_house_sch_l, ADR_HOUSE))
        qty_total = self.cur6.fetchone()[0]
        self.conn6.commit()
             
        self.cur6.execute(self.check_data_adr.format(self.adr_house_sch_l, ADR_HOUSE_AUX))
        qty_mod = self.cur6.fetchone()[0]
        self.conn6.commit()

        self.stage_6 (self.check_data_adr_1.format (qty_total,(ADR_HOUSE + "_1"))); 
        self.stage_6 (self.check_data_adr_1.format (qty_mod,(ADR_HOUSE_AUX + "_1")));
        
        self.stage_6 (self.gar_link_p_adr_house_idx_set_uniq.format\
            (self.adr_house_sch_l, 'NULL', True, True)) 

        self.stage_6 (self.gar_link_p_adr_house_idx.format\
            (self.adr_house_sch_l,'NULL', True, False, False)) 

        self.stage_6 (self.gar_link_p_adr_house_idx.format\
            (self.adr_house_sch_l,'NULL', False, True, True))
        
        if not (self.ah_upload_pa_script== None):
            self.stage_6 (self.post_adr_house.format\
                (self.ah_upload_pa_script),p_mode = 1)
       
        self.stage_6 (self.gar_tmp_p_adr_house_upload.format\
            (self.adr_house_sch_l,self.adr_house_sch))
 
        if not self.save_ver_skip: 

            if not self.kd_export_type:
                file_path = (self.file_path + PATH_DELIMITER + ADR_HOUSE_FILE)
            else:
                file_path = ''

            self.stage_6 (self.export_f_version_by_obj_put.format\
                (self.dt_gar_version, self.adr_house_sch_l, ADR_HOUSE, qty_total, qty_mod,\
                    file_path))
 
    return rc

# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
        """
        if ( len( sys.argv ) - 1 ) < IA:
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + SA
            sys.exit( 1 )
     
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
        
        mm.cur6.close()
        mm.conn6.close()
        
        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

#-----------------------------------------------------------------------------------------
#   $>./load_mainStage6.py 127.0.0.1 5433 unsi_test_12 postgres stage_6.yaml . 47 # 47 ??
#-----------------------------------------------------------------------------------------
