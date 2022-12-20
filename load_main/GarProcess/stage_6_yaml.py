#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: stage_6_yaml.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities. Parsing YAML-files.
# -----------------------------------------------------------------------------------------

import sys
import string

# import pyyaml module
import yaml
from yaml.loader import SafeLoader

PATH_DELIMITER = '/'  
VERSION_STR = "  Version 0.1.1 Build 2022-12-19"

YAML_NOT_OPENED_0 = "... YAML file not opened: '"
YAML_NOT_OPENED_1 = "'."

class yaml_patterns ():
    """
     Установка параметров для post обработки 
 
    """
    
    def __init__ ( self, p_path, p_yaml_name ):

        target_dir = string.strip (p_path) + PATH_DELIMITER
        yaml_file_name = string.strip (p_yaml_name)
        
        try:
            f_yaml = open ((target_dir + yaml_file_name), "r")
        
        except IOError, ex:
            print YAML_NOT_OPENED_0 + yaml_file_name + YAML_NOT_OPENED_1
            return 1
        
        stage_6 = yaml.load(f_yaml, Loader=SafeLoader) 
        #
        # --------------------------------------------------------------
        #
        self.stage_6_0_on = stage_6 ['control_params'] ['stage_6_0']  
        self.stage_6_1_on = stage_6 ['control_params'] ['stage_6_1']  
        self.stage_6_2_on = stage_6 ['control_params'] ['stage_6_2']  
        self.stage_6_3_on = stage_6 ['control_params'] ['stage_6_3']         
        #
        self.mogrify_6_0 = stage_6 ['control_params'] ['mogrify_6_0']
        self.mogrify_6_1 = stage_6 ['control_params'] ['mogrify_6_1']
        self.mogrify_6_2 = stage_6 ['control_params'] ['mogrify_6_2']
        self.mogrify_6_3 = stage_6 ['control_params'] ['mogrify_6_3']        
        #
        self.region_id   = stage_6 ['global_params']['g_region_id'] 
        self.fserver_nmb = stage_6 ['global_params']['g_fserver_nmb']   
        self.kd_export_type = stage_6 ['global_params']['g_kd_export_type'] 
        self.seq_name       = stage_6 ['global_params']['g_seq_name']
        self.file_path      = stage_6 ['global_params']['g_file_path']
        #
        self.adr_area_sch     = stage_6 ['global_params']['g_adr_area_sch']
        self.adr_street_sch   = stage_6 ['global_params']['g_adr_street_sch']
        self.adr_house_sch    = stage_6 ['global_params']['g_adr_house_sch']
        self.adr_area_sch_l   = stage_6 ['global_params']['g_adr_area_sch_l']
        self.adr_street_sch_l = stage_6 ['global_params']['g_adr_street_sch_l']
        self.adr_house_sch_l  = stage_6 ['global_params']['g_adr_house_sch_l']
        
        
        self.adr_hist_sch = stage_6 ['global_params']['g_adr_hist_sch'] 
        #
        # Далее по этапам:
        # ---------------- 
        # stage_6_0  --  Сохранение данных в журнале.  
        #            Но будет выполняться на каждой их трёх итераций,  
        #            управление - либо выключена, либо пропускаем. 
        # 
        self.save_ver_descr = stage_6 ['unnsi_save_version'] ['descr']
        self.save_ver_skip  = stage_6 ['unnsi_save_version'] ['p_skip']       
        #  
        # stage_6_1 Постанализ и выгрузка адресных пространств.
        #
        self.aa_upload_descr     = stage_6 ['unnsi_adr_area_upload']['descr']
        self.aa_upload_skip      = stage_6 ['unnsi_adr_area_upload']['p_skip']
        self.aa_upload_pa_script = stage_6 ['unnsi_adr_area_upload']['params_proc']['p_post_script']
        #        
        # stage_6_2 Постанализ и выгрузка улиц
        #
        self.as_upload_descr     = stage_6 ['unnsi_adr_street_upload']['descr']
        self.as_upload_skip      = stage_6 ['unnsi_adr_street_upload']['p_skip']
        self.as_bound_date       = stage_6 ['unnsi_adr_street_upload']['params_proc']['p_bound_date']
        self.as_upload_pa_script = stage_6 ['unnsi_adr_street_upload']['params_proc']['p_post_script']
        #        
        # stage_6_3 Постанализ и выгрузка улиц
        #
        self.ah_upload_descr     = stage_6 ['unnsi_adr_house_upload']['descr']
        self.ah_upload_skip      = stage_6 ['unnsi_adr_house_upload']['p_skip']
        self.ah_bound_date       = stage_6 ['unnsi_adr_house_upload']['params_proc']['p_bound_date']
        self.ah_upload_pa_script = stage_6 ['unnsi_adr_house_upload']['params_proc']['p_post_script']
        #      
        f_yaml.close()     
        #
            
# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint to the class
        """
#                1           2                
        sa = " <Path> <YAML_file_name>"
        if ( len( sys.argv ) - 1 ) < 2:
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )
#
        yp = yaml_patterns (sys.argv[1], sys.argv[2])
        #
        print yp.stage_6_0_on   
        print yp.stage_6_1_on   
        print yp.stage_6_2_on   
        print yp.stage_6_3_on          
        #
        print yp.mogrify_6_0
        print yp.mogrify_6_1
        print yp.mogrify_6_2
        print yp.mogrify_6_3        
        #
        print yp.region_id  
        print yp.fserver_nmb
        print yp.kd_export_type 
        print yp.seq_name       
        print yp.file_path           
        #
        print yp.adr_area_sch     
        print yp.adr_street_sch   
        print yp.adr_house_sch    
        #
        print yp.adr_area_sch_l   
        print yp.adr_street_sch_l 
        print yp.adr_house_sch_l  
        
        print yp.adr_hist_sch 

        print yp.save_ver_descr
        print yp.save_ver_skip        
        #  
        # stage_6_1 Постанализ и выгрузка адресных пространств.
        #
        print yp.aa_upload_descr    
        print yp.aa_upload_skip     
        print yp.aa_upload_pa_script
        #        
        # stage_6_2 Постанализ и выгрузка улиц
        #
        print yp.as_upload_descr    
        print yp.as_upload_skip     
        print yp.as_bound_date     
        print yp.as_upload_pa_script
        #        
        # stage_6_3 Постанализ и выгрузка улиц
        #
        print yp.ah_upload_descr    
        print yp.ah_upload_skip  
        print yp.ah_bound_date     
        print yp.ah_upload_pa_script
        #--
        sys.exit (0)

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)
