#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainStage3.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities.  
#       2023-03-28 - version for python3
# -----------------------------------------------------------------------------------------

import sys

from GarProcess import stage_3_proc as Proc3
from GarProcess import stage_3_yaml as Yaml3

from MainProcess import fd_0 as Fd0
from MainProcess import fd_log as FdLog

VERSION_STR = "  Version 1.0.0 Build 2023-03-28"

CONN_ABORTED = "... Connection aborted: "
OP_ABORTED = "... Operation aborted: "

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
         
class make_main (Proc3.proc_patterns, Yaml3.yaml_patterns, Fd0.fd_0, fd_log_z):     
 """
     It executes the functionality previously defined in stage_3.csv
 """

 def __init__(self, p_host_ip, p_port, p_db_name, p_user_name, p_yaml_file, p_path, p_std_out,\
     p_std_err, p_prt_sw = True, p_proc_mark = EMP, p_log_mark = EMP, p_id_region = None, p_fserver_nmb = None,\
         p_fschemas = None, p_date = None):
     
     Proc3.proc_patterns.__init__(self)
     Yaml3.yaml_patterns.__init__(self, p_path, p_yaml_file, p_fserver_nmb, p_fschemas,\
         p_id_region, p_date)
     
     fd_log_z.__init__(self, p_host_ip, p_port, p_db_name, p_user_name, p_prt_sw, p_proc_mark) 
     Fd0.fd_0.__init__(self, 0, p_host_ip, p_port, p_db_name, p_user_name, p_std_out, p_std_err,\
         p_proc_mark, p_log_mark)

     # 2022-05-11
     std_err = p_std_err.format(p_proc_mark,p_log_mark)    
     try:
         self.f_err = open (std_err, "a")
     except IOError as ex:
         print (ERR_NOT_OPENED_0 + std_err + ERR_NOT_OPENED_1)
         sys.exit (1)
     
     std_out = p_std_out.format(p_proc_mark,p_log_mark)    
     try:
         self.f_out = open (std_out, "a")   
     except IOError as ex:
         print (OUT_NOT_OPENED_0 + std_out + OUT_NOT_OPENED_1)
         sys.exit (1)         
     # 2022-05-11
     
     self.date = p_date
     #---------------------------------------------------------- 
 
 def write_log_1 ( self, p_mess ):
     self.write_log (SPACE_7 + p_mess)
 
 def prt_stat (self):
     # print self.l_arg
     self.f_err.write ('\n' + self.l_arg + '\n')
     return 0
 
 def stage_3 ( self, p_cmd, p_log_mess = None):  
     """
      Main method
     """
     if not (p_log_mess == None):
         self.write_log_1 (p_log_mess)
         
     self.f_create ( p_cmd )   
     rc = self.prt_stat() if self.MOGRIFY else self.f_run()
     
     if not (rc == 0):    #  Fatal error, break process
         
         self.write_log_err ( rc, self.l_arg )
         self.close_log()
         self.f_err.close()
         self.f_out.close()
         
         sys.exit (rc)     
         
     return rc           

 def stage_3_I ( self, p_MOGRIFY ): 
    """
     Начальные установки.
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    # Проверка региона 
    rc = self.stage_3 (self.get_region_info.format (self.g_adr_area_sch, self.region_id))

    # Установка индексного покрытия в схеме gar_fias;
    if not self.gf_cidx_skip:  
        rc = self.stage_3 (self.gar_tmp_p_gar_fias_crt_idx.format (self.gf_cidx_sw),\
            self.gf_cidx_descr)
                    
    return rc


 def stage_3_9 ( self, p_MOGRIFY ): 
    """
     Дефектные данные
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
     
    # Адресные регионы, заполнение таблицы дефектов.
    if not self.gar_fias_set_gap_adr_area_skip:     
        rc = self.stage_3 (self.gar_fias_set_adr_data.format (self.g_adr_area_sch,\
            self.region_id, self.date), self.gar_fias_set_gap_descr)
 
    # Корреция данных на основании таблицы дефектов.
    if not self.gar_fias_update_children_skip:                         # 2022-09-05
        rc = self.stage_3 (self.gar_fias_addr_obj_update_children.format (self.date,\
            self.gar_fias_update_children_obj_level, self.gar_fias_update_children_date_2),\
                self.gar_fias_update_children_descr)
        
    # Дома
    #if not self.gar_fias_set_gap_adr_house_skip:  
                    
    return rc

 def stage_3_0 ( self, p_MOGRIFY ): 
    """
     Подготовка таблиц, очистка данных и смена индексного покрытия 
     that has been defined in stage_3.csv
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    # Установка признака LOGGED у таблиц в схеме gar_tmp
    if not self.gt_stl_skip:     
        rc = self.stage_3 (self.gar_tmp_p_alt_tbl.format (self.gt_stl_sw),\
            self.gt_stl_descr)
            
    # Очистка данных во временной схеме
    if not self.gt_clr_skip:
        rc = self.stage_3 (self.gar_tmp_p_clear_tbl.format (self.gt_clr_sw),\
            self.gt_clr_descr)
        
    # Смена индексного покрытия в целевых таблицах
    if not self.gt_sidx_skip:

        rc = self.stage_3 (self.gar_link_p_adr_area_idx.format\
            (self.g_fhost_id, self.g_adr_area_sch, True, False), self.gt_sidx_descr)
        #    
        rc = self.stage_3 (self.gar_link_p_adr_area_idx.format\
            (self.g_fhost_id, self.g_adr_area_sch, False, True))

        rc = self.stage_3 (self.gar_link_p_adr_street_idx.format\
            (self.g_fhost_id, self.g_adr_street_sch, True, False,\
                self.gt_sidx_street_uniq_sw))
        #
        rc = self.stage_3 (self.gar_link_p_adr_street_idx.format\
            (self.g_fhost_id, self.g_adr_street_sch, False, True,\
                self.gt_sidx_street_uniq_sw))
        
        rc = self.stage_3 (self.gar_link_p_adr_house_idx.format\
            (self.g_fhost_id, self.g_adr_house_sch, True, False,\
                self.gt_sidx_house_uniq_sw))
        #
        rc = self.stage_3 (self.gar_link_p_adr_house_idx.format\
            (self.g_fhost_id, self.g_adr_house_sch, False, True,\
                self.gt_sidx_house_uniq_sw))
        
        if not self.gt_sidx_skip_adr_object:
            
            self.write_log_1 ('NOT Skip_adr_object')
            #
            rc = self.stage_3 (self.gar_link_p_adr_objects_idx.format\
                (self.g_fhost_id, self.g_adr_house_sch, True, False,\
                    self.gt_sidx_objects_uniq_x2))
            #
            rc = self.stage_3 (self.gar_link_p_adr_objects_idx.format\
                (self.g_fhost_id, self.g_adr_house_sch, False, True,\
                    self.gt_sidx_objects_uniq_x2))
                    
    return rc

 def stage_3_1 ( self, p_MOGRIFY): 
    """
      Выгрузка данных
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0

    # Загрузка данных из таблицы ADR_AREA_TYPE (unload_data) 
    if not self.unload_adr_area_type_skip: 

        rc = self.stage_3 (self.gar_tmp_p_adr_area_type_unload.format\
                (self.g_adr_area_sch_l, self.g_adr_area_sch), self.unload_adr_area_type_descr)

    # Загрузка данных из таблицы ADR_STREET_TYPE (unload_data) 
    if not self.unload_adr_street_type_skip: 

        rc = self.stage_3 (self.gar_tmp_p_adr_street_type_unload.format\
                (self.g_adr_street_sch_l, self.g_adr_street_sch), self.unload_adr_street_type_descr)

    # Загрузка данных из таблицы ADR_HOUSE_TYPE (unload_data) 
    if not self.unload_adr_house_type_skip: 

        rc = self.stage_3 (self.gar_tmp_p_adr_house_type_unload.format\
                (self.g_adr_house_sch_l, self.g_adr_house_sch), self.unload_adr_house_type_descr)

    # Загрузка регионального фрагмента из таблицы ADR_AREA (unload_data) 
    if not self.unload_adr_area_skip: 

        rc = self.stage_3 (self.gar_tmp_p_adr_area_unload.format\
                (self.g_adr_area_sch, self.region_id, self.g_fhost_id), self.unload_adr_area_descr)

    # Загрузка регионального фрагмента из таблицы ADR_STREET (unload_data) 
    if not self.unload_adr_street_skip: 

        rc = self.stage_3 (self.gar_tmp_p_adr_street_unload.format\
                (self.g_adr_street_sch, self.region_id, self.g_fhost_id), self.unload_adr_street_descr)
    
    # Загрузка регионального фрагмента из таблицы ADR_HOUSE (unload_data) 
    if not self.unload_adr_house_skip: 

        rc = self.stage_3 (self.gar_tmp_p_adr_house_unload.format\
                (self.g_adr_house_sch, self.region_id, self.g_fhost_id), self.unload_adr_house_descr)

        if not self.unload_adr_house_skip_adr_object:
            self.write_log_1 ('NOT Skip_adr_object')

            rc = self.stage_3 (self.gar_tmp_p_adr_object_unload.format\
                    (self.g_adr_house_sch, self.region_id, self.g_fhost_id))

    # Установка последовательностей 
    if not self.seq_set_skip: 

        rc = self.stage_3 (self.gar_tmp_f_xxx_obj_seq_crt.format\
                (self.seq_set_seq_name, self.region_id, self.seq_set_init_val,\
                    self.seq_set_adr_area_sch, self.seq_set_adr_street_sch,\
                        self.seq_set_adr_house_sch, self.seq_set_seq_hist_name),\
                            self.seq_set_descr)

    return rc

 def stage_3_2 ( self, p_MOGRIFY): 
    """
      Актуализация справочников
        ##
        #0;SELECT gar_tmp_pcg_trans.f_xxx_adr_area_type_set ('gar_tmp'::text,NULL, ARRAY [1]);; -- Установка xxx_adr_area_type;
        #0;; -- Update xxx_adr_area_type;
        ##
        #0;SELECT gar_tmp_pcg_trans.f_xxx_street_type_set ('gar_tmp',NULL, ARRAY [1]);; -- Установка xxx_adr_street_type;
        #0;SELECT gar_tmp_pcg_trans.f_xxx_house_type_set ('gar_tmp',NULL, ARRAY [1]);;  -- Установка xxx_adr_house_type;
        ##      
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0
    
    # Актуализация справочников
    self.write_log_1 (self.dict_upgr_descr)
    
    if self.dict_upgr_schs.__len__() == 0:
        dict_upgr_schs = 'NULL'
    else:
        dict_upgr_schs = "ARRAY " + str(self.dict_upgr_schs)
            
    # Актуализация справочников (адресные пространства).
    if not self.dict_upgr_aa_skip_1:
            
        rc = self.stage_3 (self.gar_tmp_f_xxx_adr_area_type_set.format\
            (self.g_adr_area_sch_l, dict_upgr_schs, self.dict_upgr_op_type),\
                self.dict_upgr_aa_descr_1)

        if not (self.dict_upgr_aa_add_query_1 == None):
            rc = self.stage_3 (self.dict_upgr_aa_add_query_1)    
            
        if not (self.dict_upgr_aa_control_query_1 == None):    
            rc = self.stage_3 (self.dict_upgr_aa_control_query_1)

    # Актуализация справочников (улицы, частный случай адресных пространств).
    if not self.dict_upgr_as_skip_2:
            
        rc = self.stage_3 (self.gar_tmp_f_xxx_street_type_set.format\
            (self.g_adr_area_sch_l, dict_upgr_schs, self.dict_upgr_op_type),\
                self.dict_upgr_as_descr_2)

        if not (self.dict_upgr_as_add_query_2 == None):
            rc = self.stage_3 (self.dict_upgr_as_add_query_2)    
            
        if not (self.dict_upgr_as_control_query_2 == None):    
            rc = self.stage_3 (self.dict_upgr_as_control_query_2)        
        
    # Дома
    if not self.dict_upgr_ah_skip_3:
        
        rc = self.stage_3 (self.gar_tmp_f_xxx_house_type_set.format\
            (self.g_adr_area_sch_l, dict_upgr_schs, self.dict_upgr_op_type),\
                self.dict_upgr_ah_descr_3)

        if not (self.dict_upgr_ah_add_query_3 == None):
            rc = self.stage_3 (self.dict_upgr_ah_add_query_3)    
            
        if not (self.dict_upgr_ah_control_query_3 == None):    
            rc = self.stage_3 (self.dict_upgr_ah_control_query_3)        

    return rc

 def stage_3_3 ( self, p_MOGRIFY): 
    """
     Агрегация данных
    """
    self.MOGRIFY = p_MOGRIFY
    rc = 0

    # Агрегация данных. 
    self.write_log_1 (self.data_agg_descr)
    
    # Для каждого объекта запомнить пары "Тип" - "Значение"
    if not self.data_agg_skip_agg:
        
        rc = self.stage_3 (self.gar_tmp_f_set_params_value.format\
            (self.data_agg_param_list), self.data_agg_descr_agg)
        
    # Запомнить промежуточные данные, адресные объекты.
    if not self.aa_agg_skip:
        
        rc = self.stage_3 ((self.gar_tmp_f_xxx_adr_area_set_data.format\
            (self.aa_agg_date, self.aa_agg_obj_level, self.aa_agg_oper_type_ids)).replace\
                ('None','NULL'), self.aa_agg_descr)

    # Загрузка прототипа таблицы домов "gar_tmp.xxx_adr_house".
    if not self.ah_skip_adr_house:
        
        rc = self.stage_3 ((self.gar_tmp_f_xxx_adr_house_set_data.format\
            (self.ah_agg_date,self.ah_agg_parent_obj)).replace ('None','NULL'),\
                self.ah_agg_descr)
            
    # Заполнение таблицы "gar_tmp.xxx_obj_fias"        
    if not self.skip_obj_fias:

        l_area_sch = self.g_adr_area_sch           # Установлена отдалённая схема.
        if self.switch_adr_area_sch:
            l_area_sch = self.g_adr_area_sch_l     # Установлена локальная схема.
        
        l_street_sch = self.g_adr_street_sch           # Установлена отдалённая схема.
        if self.switch_adr_street_sch:
            l_street_sch = self.g_adr_street_sch_l     # Установлена локальная схема.
        
        l_house_sch = self.g_adr_house_sch           # Установлена отдалённая схема.
        if self.switch_adr_house_sch:
            l_house_sch = self.g_adr_house_sch_l     # Установлена локальная схема.

        rc = self.stage_3 (self.gar_tmp_f_xxx_obj_fias_set_data.format\
            (l_area_sch, l_street_sch, l_house_sch), self.obj_fias_descr)
               
    return rc

# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
        """
#                  1       2        3          4            5             6        7        8    
        sa = " <Host_IP> <Port> <DB_name> <User_name> <YAML_file_name> <Path> <Id_region> <Date>"
        if ( len( sys.argv ) - 1 ) < 8:
            print (VERSION_STR )
            print ("  Usage: " + str ( sys.argv [0] ) + sa)
            sys.exit( 1 )
#
        mm = make_main (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]\
            ,sys.argv[5], sys.argv[6], bOUT_NAME, bERR_NAME, p_id_region = sys.argv[7], p_date = sys.argv[8])  
        
        s_lp = str (sys.argv[1]) + SPACE_0 + str (sys.argv[2]) + SPACE_0\
            + str (sys.argv[3]) + SPACE_0
        s_lp = s_lp + str (sys.argv[4]) + SPACE_0 + str (sys.argv[5]) 
     
        mm.open_log (bLOG_NAME, sys.argv[6], s_lp)
        mm.write_log_first()

        if mm.stage_3_I_on: 
            rc = mm.stage_3_I ( mm.mogrify_3_I )

        if mm.stage_3_9_on: 
            rc = mm.stage_3_9 ( mm.mogrify_3_9 )
 
        if mm.stage_3_0_on: 
            rc = mm.stage_3_0 ( mm.mogrify_3_0 )
         
        if mm.stage_3_1_on: 
            rc = mm.stage_3_1 ( mm.mogrify_3_1 )
        
        if mm.stage_3_2_on: 
            rc = mm.stage_3_2 ( mm.mogrify_3_2 )
        
        if mm.stage_3_3_on: 
            rc = mm.stage_3_3 ( mm.mogrify_3_3 )
        
        mm.close_log ()
        mm.f_err.close()
        mm.f_out.close()        
        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt as e:
        print ("... Terminated by user: ")
        sys.exit (1)

#--------------------------------------------------------------------------------
#   $>./load_mainStage3.py 127.0.0.1 5434 unsi_old2 postgres stage_3.yaml . 47
#   Установка признака LOGGED у таблиц в схеме gar_tmp
#   True
#   CALL gar_tmp_pcg_trans.p_alt_tbl (p_all := True::boolean);
#   Создание рабочих индесов в схеме gar_fias.
#   True
#   CALL gar_tmp_pcg_trans.p_gar_fias_crt_idx (
#                                                   p_sw := True::boolean);
#   Очистка данных во временной схеме
#   True
#   CALL gar_tmp_pcg_trans.p_clear_tbl (p_all := True::boolean);
#           
#   Смена индексного покрытия в целевых таблицах
#   Загрузка регионального фрагмента из таблицы ADR_HOUSE
#   $>
