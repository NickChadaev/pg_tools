#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: stage_4_yaml.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities. Parsing YAML-files.
# -----------------------------------------------------------------------------------------

import sys
import string

# import pyyaml module
import yaml
from yaml.loader import SafeLoader

PATH_DELIMITER = '/'  
VERSION_STR = "  Version 0.0.1 Build 2022-07-15"

YAML_NOT_OPENED_0 = "... YAML file not opened: '"
YAML_NOT_OPENED_1 = "'."

class yaml_patterns ():
    """
     Paring YAML-файла
 
    """
    def __init__ ( self, p_path, p_yaml_name ):

        target_dir = string.strip (p_path) + PATH_DELIMITER
        yaml_file_name = string.strip (p_yaml_name)
        
        try:
            f_yaml = open ((target_dir + yaml_file_name), "r")
        
        except IOError, ex:
            print YAML_NOT_OPENED_0 + yaml_file_name + YAML_NOT_OPENED_1
            return 1
        
        stage_4 = yaml.load(f_yaml, Loader=SafeLoader) 
        #
        # --------------------------------------------------------------
        #
        self.stage_4_1_on = stage_4 ['control_params'] ['stage_4_1']  
        self.stage_4_2_on = stage_4 ['control_params'] ['stage_4_2']  
        self.stage_4_3_on = stage_4 ['control_params'] ['stage_4_3']  
        self.stage_4_4_on = stage_4 ['control_params'] ['stage_4_4']         
        self.stage_4_5_on = stage_4 ['control_params'] ['stage_4_5']  
        self.stage_4_6_on = stage_4 ['control_params'] ['stage_4_6']         
        #
        self.mogrify_4_1 = stage_4 ['control_params'] ['mogrify_4_1']
        self.mogrify_4_2 = stage_4 ['control_params'] ['mogrify_4_2']
        self.mogrify_4_3 = stage_4 ['control_params'] ['mogrify_4_3']
        self.mogrify_4_4 = stage_4 ['control_params'] ['mogrify_4_4']        
        self.mogrify_4_5 = stage_4 ['control_params'] ['mogrify_4_5']
        self.mogrify_4_6 = stage_4 ['control_params'] ['mogrify_4_6']        
        #
        self.g_history_sch = stage_4 ['global_params'] ['g_history_sch']    
        #
        # Далее по этапам:
        # ---------------- 
        # stage_4_1
        #
        self.adr_area_ins_descr = stage_4 ['adr_area']['op_ins']['p_descr']
        self.adr_area_ins_skip  = False
        self.adr_area_ins_schema_data = stage_4 ['adr_area']['op_ins']['params']['p_schema_data']
        self.adr_area_ins_schema_etl  = stage_4 ['adr_area']['op_ins']['params']['p_schema_etl']
        self.adr_area_ins_sw_hist     = stage_4 ['adr_area']['op_ins']['params']['p_sw_hist']
        self.adr_area_ins_check_query = stage_4 ['adr_area']['op_ins']['params']['p_check_query']        
        #
        if (self.adr_area_ins_check_query == 'None'):  
            self.adr_area_ins_check_query = None
        #  
        # stage_4_2
        #
        self.adr_area_upd_descr = stage_4 ['adr_area']['op_upd']['p_descr']
        self.adr_area_upd_skip  = False
        self.adr_area_upd_schema_data = stage_4 ['adr_area']['op_upd']['params']['p_schema_data']
        self.adr_area_upd_schema_etl  = stage_4 ['adr_area']['op_upd']['params']['p_schema_etl']
        self.adr_area_upd_sw_hist     = stage_4 ['adr_area']['op_upd']['params']['p_sw_hist']
        self.adr_area_upd_check_query = stage_4 ['adr_area']['op_upd']['params']['p_check_query']        
        #
        if (self.adr_area_upd_check_query == 'None'):  
            self.adr_area_upd_check_query = None
        #  
        # stage_4_3
        #                                                                                            
        self.adr_street_ins_descr = stage_4 ['adr_street']['op_ins']['p_descr']
        self.adr_street_ins_skip  = False
        self.adr_street_ins_schema_data = stage_4 ['adr_street']['op_ins']['params']['p_schema_data']
        self.adr_street_ins_schema_etl  = stage_4 ['adr_street']['op_ins']['params']['p_schema_etl']
        self.adr_street_ins_sw_hist     = stage_4 ['adr_street']['op_ins']['params']['p_sw_hist']
        self.adr_street_ins_check_query = stage_4 ['adr_street']['op_ins']['params']['p_check_query']
        #
        if (self.adr_street_ins_check_query == 'None'):  
            self.adr_street_ins_check_query = None
        #      
        # stage_4_4
        #
        self.adr_street_upd_descr = stage_4 ['adr_street']['op_upd']['p_descr']        
        self.adr_street_upd_skip  = False
        self.adr_street_upd_schema_data = stage_4 ['adr_street']['op_upd']['params']['p_schema_data']
        self.adr_street_upd_schema_etl  = stage_4 ['adr_street']['op_upd']['params']['p_schema_etl']
        self.adr_street_upd_sw_hist     = stage_4 ['adr_street']['op_upd']['params']['p_sw_hist']
        self.adr_street_upd_sw_twin     = stage_4 ['adr_street']['op_upd']['params']['p_sw_twin']
        self.adr_street_upd_check_query = stage_4 ['adr_street']['op_upd']['params']['p_check_query']        
        #
        if (self.adr_street_upd_check_query == 'None'):  
            self.adr_street_upd_check_query = None
        #      
        # stage_4_5
        #
        self.adr_house_ins_descr = stage_4 ['adr_house']['op_ins']['p_descr']
        self.adr_house_ins_skip  = False
        self.adr_house_ins_schema_data = stage_4 ['adr_house']['op_ins']['params']['p_schema_data']
        self.adr_house_ins_schema_etl  = stage_4 ['adr_house']['op_ins']['params']['p_schema_etl']
        self.adr_house_ins_sw          = stage_4 ['adr_house']['op_ins']['params']['p_sw']
        self.adr_house_ins_sw_twin     = stage_4 ['adr_house']['op_ins']['params']['p_sw_twin']
        self.adr_house_ins_check_query = stage_4 ['adr_house']['op_ins']['params']['p_check_query']
        #
        if (self.adr_house_ins_check_query == 'None'):  
            self.adr_house_ins_check_query = None
        #
        # stage_4_6
        #   
        self.adr_house_upd_descr = stage_4 ['adr_house']['op_upd']['p_descr']        
        self.adr_house_upd_skip  = False
        self.adr_house_upd_schema_data = stage_4 ['adr_house']['op_upd']['params']['p_schema_data']
        self.adr_house_upd_schema_etl  = stage_4 ['adr_house']['op_upd']['params']['p_schema_etl']
        self.adr_house_upd_sw_hist     = stage_4 ['adr_house']['op_upd']['params']['p_sw_hist']
        self.adr_house_upd_sw_twin     = stage_4 ['adr_house']['op_upd']['params']['p_sw_twin']
        self.adr_house_upd_sw_del      = stage_4 ['adr_house']['op_upd']['params']['p_del']
        self.adr_house_upd_sw          = stage_4 ['adr_house']['op_upd']['params']['p_sw']
        self.adr_house_upd_check_query = stage_4 ['adr_house']['op_upd']['params']['p_check_query']
        #
        if (self.adr_house_upd_check_query == 'None'):  
            self.adr_house_upd_check_query = None

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
        
        print yp.stage_4_1_on
        print yp.stage_4_2_on
        print yp.stage_4_3_on    
        print yp.stage_4_4_on
        print yp.stage_4_5_on
        print yp.stage_4_6_on
        #
        print yp.mogrify_4_1
        print yp.mogrify_4_2
        print yp.mogrify_4_3    
        print yp.mogrify_4_4
        print yp.mogrify_4_5
        print yp.mogrify_4_6
        #
        print yp.g_history_sch
        
        # stage_4_1
        print yp.adr_area_ins_descr
        print yp.adr_area_ins_skip    
        print yp.adr_area_ins_schema_data
        print yp.adr_area_ins_schema_etl 
        print yp.adr_area_ins_sw_hist    
        print yp.adr_area_ins_check_query
        #
        # stage_4_2
        print yp.adr_area_upd_descr        
        print yp.adr_area_upd_skip
        print yp.adr_area_upd_schema_data    
        print yp.adr_area_upd_schema_etl 
        print yp.adr_area_upd_sw_hist    
        print yp.adr_area_upd_check_query
        #  
        # stage_4_3
        print yp.adr_street_ins_descr
        print yp.adr_street_ins_skip    
        print yp.adr_street_ins_schema_data
        print yp.adr_street_ins_schema_etl 
        print yp.adr_street_ins_sw_hist    
        print yp.adr_street_ins_check_query
        #      
        # stage_4_4
        print yp.adr_street_upd_descr        
        print yp.adr_street_upd_skip    
        print yp.adr_street_upd_schema_data
        print yp.adr_street_upd_schema_etl 
        print yp.adr_street_upd_sw_twin    
        print yp.adr_street_upd_check_query
        #      
        # stage_4_5
        #
        print yp.adr_house_ins_descr    
        print yp.adr_house_ins_skip
        print yp.adr_house_ins_schema_data
        print yp.adr_house_ins_schema_etl 
        print yp.adr_house_ins_sw             
        print yp.adr_house_ins_sw_twin    
        print yp.adr_house_ins_check_query
        #
        # stage_4_6
        # 
        print yp.adr_house_upd_descr        
        print yp.adr_house_upd_skip
        print yp.adr_house_upd_schema_data    
        print yp.adr_house_upd_schema_etl 
        print yp.adr_house_upd_sw_hist 
        print yp.adr_house_upd_sw_twin    
        print yp.adr_house_upd_sw_del     
        print yp.adr_house_upd_sw             
        print yp.adr_house_upd_check_query
        
        sys.exit (0)

    #---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)
