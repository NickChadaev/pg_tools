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
VERSION_STR = "  Version 0.0.2 Build 2022-08-05"

YAML_NOT_OPENED_0 = "... YAML file not opened: '"
YAML_NOT_OPENED_1 = "'."

class yaml_patterns ():
    """
     Установка параметров для post обработки 
 
    """
    
    def __init__ ( self, p_path, p_yaml_name, p_fserver_nmb = None, p_schemas = None):

        # Предопределённый список регионов.

        self.g_regions = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,\
            22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,\
                44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,\
                    66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,86,87]

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
        g_regions_tmp  = stage_6 ['global_params'] ['g_regions']
        #
        # Переопределяю.
        #
        if not (g_regions_tmp == 'None'):
            self.g_regions = g_regions_tmp
        
        self.g_fhost_id = stage_6 ['global_params'] ['g_fserver_nmb'] 
        #
        self.g_adr_area_sch   = stage_6 ['global_params'] ['g_adr_area_sch']      
        self.g_adr_street_sch = stage_6 ['global_params'] ['g_adr_street_sch']      
        self.g_adr_house_sch  = stage_6 ['global_params'] ['g_adr_house_sch']      
        self.g_history_sch    = stage_6 ['global_params'] ['g_history_sch']    
        #
        # Далее по этапам:
        # ---------------- 
        # stage_6_0
        #        
        self.drp_lidx_descr = stage_6  ['gar_drop_load_indexies'] ['descr']
        self.drp_lidx_skip_area   = stage_6 ['gar_drop_load_indexies'] ['params_area'] ['p_skip']
        self.drp_lidx_skip_street = stage_6 ['gar_drop_load_indexies'] ['params_street'] ['p_skip']
        self.drp_lidx_skip_house  = stage_6 ['gar_drop_load_indexies'] ['params_house'] ['p_skip']
        self.drp_lidx_skip_object = stage_6 ['gar_drop_load_indexies'] ['param_objects'] ['p_skip']
 
        self.crt_widx_descr = stage_6  ['gar_create_work_indexies'] ['descr']
        self.crt_widx_skip_area     = stage_6 ['gar_create_work_indexies'] ['params_area'] ['p_skip']
        self.crt_widx_skip_street   = stage_6 ['gar_create_work_indexies'] ['params_street'] ['p_skip']
        self.crt_widx_unique_street = stage_6 ['gar_create_work_indexies'] ['params_street'] ['p_uniq_sw']
        
        self.crt_widx_skip_house   = stage_6 ['gar_create_work_indexies'] ['params_house'] ['p_skip']
        self.crt_widx_unique_house = stage_6 ['gar_create_work_indexies'] ['params_house'] ['p_uniq_sw']
                    
        self.crt_widx_skip_object = stage_6 ['gar_create_work_indexies'] ['param_objects'] ['p_skip']
        #  
        # stage_6_1
        #        
        self.adr_street_check_twins_descr = stage_6 ['adr_street_check_twins'] ['descr']
        self.adr_street_check_twins_skip  = False
        self.adr_street_check_twins_bound_date = stage_6 ['adr_street_check_twins'] ['params'] ['p_bound_date']
        self.adr_street_check_twins_init_value = stage_6 ['adr_street_check_twins'] ['params'] ['p_init_value']
        self.adr_street_cquery = stage_6 ['adr_street_check_twins']['cquery']
        #      
        # stage_6_2
        #
        self.adr_house_check_twins_descr = stage_6 ['adr_house_check_twins'] ['descr']
        self.adr_house_check_twins_skip_1 = stage_6 ['adr_house_check_twins'] ['params'] ['p_skip_1']
        self.adr_house_check_twins_skip_2 = stage_6 ['adr_house_check_twins'] ['params'] ['p_skip_2']        
        self.adr_house_check_twins_bound_date = stage_6 ['adr_house_check_twins'] ['params'] ['p_bound_date']
        self.adr_house_check_twins_init_value = stage_6 ['adr_house_check_twins'] ['params'] ['p_init_value']
        self.adr_house_cquery = stage_6 ['adr_house_check_twins']['cquery']
        #      
        # stage_6_3
        #
        self.crt_unique_indexies_descr = stage_6 ['gar_crt_unique_indexies'] ['descr']
        
        self.crt_unique_indexies_street_skip = stage_6 ['gar_crt_unique_indexies'] ['params'] ['params_street'] ['p_skip']
        self.crt_unique_indexies_street_uniq_sw = stage_6 ['gar_crt_unique_indexies'] ['params'] ['params_street'] ['p_uniq_sw']
        
        self.crt_unique_indexies_house_skip  = stage_6 ['gar_crt_unique_indexies'] ['params'] ['params_house'] ['p_skip']
        self.crt_unique_indexies_house_uniq_sw  = stage_6 ['gar_crt_unique_indexies'] ['params'] ['params_house'] ['p_uniq_sw']
        #
        f_yaml.close()     
        #
        #  Возможное переопределение. Данные из "hosts_xx.yaml"
        #  могут переопределить часть параметров в "stage_6.yaml". 
        #
        # Передавался как параметр командной строки !!!!
        if (not (p_fserver_nmb == 'None')) and (not (p_fserver_nmb == None)):  
            self.g_fhost_id = int(p_fserver_nmb)

        if (not (p_schemas == None)) and (p_schemas.__len__() == 4):
            self.g_adr_area_sch    = p_schemas [0]
            self.g_adr_street_sch  = p_schemas [1]     
            self.g_adr_house_sch   = p_schemas [2]
            self.g_history_sch     = p_schemas [3]
            
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
        
        print yp.g_fhost_id
        print yp.g_adr_area_sch   
        print yp.g_adr_street_sch     
        print yp.g_adr_house_sch  
        print yp.g_history_sch    
        print yp.g_regions
        #--
        # stage_6_0
        #        
        print yp.drp_lidx_descr      
        print yp.drp_lidx_skip_area  
        print yp.drp_lidx_skip_street
        print yp.drp_lidx_skip_house 
        print yp.drp_lidx_skip_object
 
        print yp.crt_widx_descr         
        print yp.crt_widx_skip_area     
        print yp.crt_widx_skip_street   
        print yp.crt_widx_unique_street 
        
        print yp.crt_widx_skip_house   
        print yp.crt_widx_unique_house 
                    
        print yp.crt_widx_skip_object 
        #  
        # stage_6_1
        #        
        print yp.adr_street_check_twins_descr     
        print yp.adr_street_check_twins_skip      
        print yp.adr_street_check_twins_bound_date
        print yp.adr_street_check_twins_init_value
        print yp.adr_street_cquery
        #      
        # stage_6_2
        #
        print yp.adr_house_check_twins_descr     
        print yp.adr_house_check_twins_skip_1    
        print yp.adr_house_check_twins_skip_2    
        print yp.adr_house_check_twins_bound_date
        print yp.adr_house_check_twins_init_value
        print yp.adr_house_cquery
        #      
        # stage_6_3
        #
        print yp.crt_unique_indexies_descr         
        print yp.crt_unique_indexies_street_skip   
        print yp.crt_unique_indexies_street_uniq_sw
        print yp.crt_unique_indexies_house_skip    
        print yp.crt_unique_indexies_house_uniq_sw 
        #--
        sys.exit (0)

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)
