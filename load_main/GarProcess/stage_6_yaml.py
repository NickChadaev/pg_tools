#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: GarProcess package
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities. Parsing YAML-files.
# -----------------------------------------------------------------------------------------

import sys
import string

# import pyyaml module
import yaml
from yaml.loader import SafeLoader

PATH_DELIMITER = '/'  
VERSION_STR = "  Version 0.0.0 Build 2022-05-19"

YAML_NOT_OPENED_0 = "... YAML file not opened: '"
YAML_NOT_OPENED_1 = "'."

class yaml_patterns ():
    """
     Установка параметров для post обработки 
 
    """
    
    def __init__ ( self, p_path, p_yaml_name, p_fserver_nmb = None, p_schemas = None):

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
        #
        self.mogrify_6_0 = stage_6 ['control_params'] ['mogrify_6_0']
        self.mogrify_6_1 = stage_6 ['control_params'] ['mogrify_6_1']
        self.mogrify_6_2 = stage_6 ['control_params'] ['mogrify_6_2']
        #
        self.g_fhost_id = stage_6 ['global_params'] ['g_fserver_nmb'] 
        self.g_regions  = stage_6 ['global_params'] ['g_regions']
        #
        self.g_adr_area_sch   = stage_6 ['global_params'] ['g_adr_area_sch']      
        self.g_adr_street_sch = stage_6 ['global_params'] ['g_adr_street_sch']      
        self.g_adr_house_sch  = stage_6 ['global_params'] ['g_adr_house_sch']      
        self.g_history_sch    = stage_6 ['global_params'] ['g_history_sch']    
        #
        self.gt_sidx_descr           = stage_6 ['gar_tmp_switch_indexies'] ['descr']
        self.gt_sidx_skip            = stage_6 ['gar_tmp_switch_indexies'] ['params'] ['p_skip']
        # 
        self.gt_sidx_street_uniq_sw  = stage_6 ['gar_tmp_switch_indexies'] ['params'] ['params_street'] ['p_uniq_sw']
        self.gt_sidx_house_uniq_sw   = stage_6 ['gar_tmp_switch_indexies'] ['params'] ['params_house'] ['p_uniq_sw']
        #
        self.adr_street_check_twins_descr      = stage_6 ['adr_street_check_twins'] ['descr']
        self.adr_street_check_twins_skip       = stage_6 ['adr_street_check_twins'] ['params'] ['p_skip']
        self.adr_street_check_twins_bound_date = stage_6 ['adr_street_check_twins'] ['params'] ['p_bound_date']
        self.adr_street_check_twins_init_value = stage_6 ['adr_street_check_twins'] ['params'] ['p_init_value']
        #
        self.adr_house_check_twins_descr      = stage_6 ['adr_house_check_twins'] ['descr']
        self.adr_house_check_twins_skip       = stage_6 ['adr_house_check_twins'] ['params'] ['p_skip']
        self.adr_house_check_twins_bound_date = stage_6 ['adr_house_check_twins'] ['params'] ['p_bound_date']
        self.adr_house_check_twins_init_value = stage_6 ['adr_house_check_twins'] ['params'] ['p_init_value']

        
        f_yaml.close()     
        #
        #  Возможное переопределение. Данные из "hosts_xx.yaml"
        #  могут переопределить часть параметров в "stage_6.yaml". 
        #
        if not (p_fserver_nmb == None):
            self.g_fhost_id = p_fserver_nmb   

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
        
        sys.exit (0)

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)
