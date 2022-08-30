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
VERSION_STR = "  Version 0.0.2 Build 2022-08-30"

YAML_NOT_OPENED_0 = "... YAML file not opened: '"
YAML_NOT_OPENED_1 = "'."

class yaml_patterns ():
    """
      YAML Patterns 
        ================================================================================= 
        "global_params"           - Установка глобальных переменных 
        "gar_tmp_set_logged"      - Установка признака LOGGED у таблиц в схеме gar_tmp
        "gar_fias_crt_idx"        - Создание рабочих индесов в схеме gar_fias.
        "gar_tmp_clear_tbl"       - Очистка данных во временной схеме
        "gar_tmp_switch_indexies" - Смена индексного покрытия в GAR_FIAS-таблицах
        "unload_data"             - Загрузка регионального фрагмента из таблицы ADR_HOUSE
        "seq_settings"            - Установка последовательностей
        "dict_upgrading"          - Актуализация справочников
        "data_aggregation"        - Агрегация данных
        "obj_fias"                - Заполнение таблицы "gar_tmp.xxx_obj_fias"       
        =================================================================================
    """
    
    def __init__ ( self, p_path, p_yaml_name, p_fserver_nmb = None,\
        p_schemas = None, p_id_region = None ):

        target_dir = string.strip (p_path) + PATH_DELIMITER
        yaml_file_name = string.strip (p_yaml_name)
        
        try:
            f_yaml = open ((target_dir + yaml_file_name), "r")
        
        except IOError, ex:
            print YAML_NOT_OPENED_0 + yaml_file_name + YAML_NOT_OPENED_1
            return 1
        
        stage_3 = yaml.load(f_yaml, Loader=SafeLoader) 
        #
        # --------------------------------------------------------------
        #
        self.stage_3_9_on = stage_3 ['control_params'] ['stage_3_9']          
        self.stage_3_0_on = stage_3 ['control_params'] ['stage_3_0']  
        self.stage_3_1_on = stage_3 ['control_params'] ['stage_3_1']  
        self.stage_3_2_on = stage_3 ['control_params'] ['stage_3_2']  
        self.stage_3_3_on = stage_3 ['control_params'] ['stage_3_3']  
        #
        self.mogrify_3_9 = stage_3 ['control_params'] ['mogrify_3_9']
        self.mogrify_3_0 = stage_3 ['control_params'] ['mogrify_3_0']
        self.mogrify_3_1 = stage_3 ['control_params'] ['mogrify_3_1']
        self.mogrify_3_2 = stage_3 ['control_params'] ['mogrify_3_2']
        self.mogrify_3_3 = stage_3 ['control_params'] ['mogrify_3_3']         
        #
        self.region_id         = stage_3 ['global_params'] ['g_region_id']      
        self.g_fhost_id        = stage_3 ['global_params'] ['g_fserver_nmb']   
        #
        self.g_adr_area_sch    = stage_3 ['global_params'] ['g_adr_area_sch']      
        self.g_adr_street_sch  = stage_3 ['global_params'] ['g_adr_street_sch']      
        self.g_adr_house_sch   = stage_3 ['global_params'] ['g_adr_house_sch']      
        self.g_adr_house_sch_l = stage_3 ['global_params'] ['g_adr_house_sch_l']    
        #
        self.gar_fias_set_gap_descr = stage_3 ['gar_fias_set_gap']['descr']  
        self.gar_fias_set_gap_adr_area_skip = stage_3 ['gar_fias_set_gap']['params_adr_area']['p_skip']
        self.gar_fias_set_gap_adr_house_skip = stage_3 ['gar_fias_set_gap']['params_adr_house']['p_skip']
        #
        self.gt_stl_descr = stage_3 ['gar_tmp_set_logged'] ['descr']
        self.gt_stl_skip  = stage_3 ['gar_tmp_set_logged'] ['params'] ['p_skip']
        self.gt_stl_sw    = stage_3 ['gar_tmp_set_logged'] ['params'] ['p_sw']
        #
        self.gf_cidx_descr = stage_3 ['gar_fias_crt_idx'] ['descr']
        self.gf_cidx_skip  = stage_3 ['gar_fias_crt_idx'] ['params'] ['p_skip']
        self.gf_cidx_sw    = stage_3 ['gar_fias_crt_idx'] ['params'] ['p_sw']
        #
        self.gt_clr_descr = stage_3 ['gar_tmp_clear_tbl'] ['descr']
        self.gt_clr_skip  = stage_3 ['gar_tmp_clear_tbl'] ['params'] ['p_skip']
        self.gt_clr_sw    = stage_3 ['gar_tmp_clear_tbl'] ['params'] ['p_sw']
        #
        self.gt_sidx_descr           = stage_3 ['gar_tmp_switch_indexies'] ['descr']
        self.gt_sidx_skip            = stage_3 ['gar_tmp_switch_indexies'] ['params'] ['p_skip']
        self.gt_sidx_skip_adr_object = stage_3 ['gar_tmp_switch_indexies'] ['params'] ['p_skip_adr_object']
        # 
        self.gt_sidx_street_uniq_sw  = stage_3 ['gar_tmp_switch_indexies'] ['params'] ['params_street'] ['p_uniq_sw']
        self.gt_sidx_house_uniq_sw   = stage_3 ['gar_tmp_switch_indexies'] ['params'] ['params_house'] ['p_uniq_sw']
        self.gt_sidx_objects_uniq_x2 = stage_3 ['gar_tmp_switch_indexies'] ['params'] ['params_objects'] ['p_uniq_x2']        
        #
        self.gt_und_descr           = stage_3 ['unload_data'] ['descr']
        self.gt_und_skip            = stage_3 ['unload_data'] ['params'] ['p_skip']
        self.gt_und_skip_adr_object = stage_3 ['unload_data'] ['params'] ['p_skip_adr_object']
        #
        self.seq_set_descr          = stage_3 ['seq_settings'] ['descr']    
        self.seq_set_skip           = stage_3 ['seq_settings'] ['params'] ['p_skip']    
        self.seq_set_seq_name       = stage_3 ['seq_settings'] ['params'] ['p_seq_name']
        self.seq_set_seq_hist_name  = stage_3 ['seq_settings'] ['params'] ['p_seq_hist_name']
        self.seq_set_init_val       = stage_3 ['seq_settings'] ['params'] ['p_init_value']
        #
        self.dict_upgr_descr      = stage_3 ['dict_upgrading'] ['descr']    
        self.dict_upgr_sch_etalon = stage_3 ['dict_upgrading'] ['dict_params'] ['p_schema_etalon']    
        self.dict_upgr_schs       = stage_3 ['dict_upgrading'] ['dict_params'] ['p_schemas']     
        self.dict_upgr_op_type    = stage_3 ['dict_upgrading'] ['dict_params'] ['p_op_type']     
        self.dict_upgr_date       = stage_3 ['dict_upgrading'] ['dict_params'] ['p_date'] 
        #
        #   dict_1  -- adr_area    
        # 
        self.dict_upgr_aa_descr_1 = stage_3 ['dict_upgrading'] ['dict_params'] ['params'] ['descr_1']
        self.dict_upgr_aa_skip_1  = stage_3 ['dict_upgrading'] ['dict_params'] ['params'] ['p_skip_1']
        self.dict_upgr_aa_stop_1  = stage_3 ['dict_upgrading'] ['dict_params'] ['params'] ['p_stop_list_1']    
        #
        #   dict_2  -- adr_street    
        # 
        self.dict_upgr_as_descr_2 = stage_3 ['dict_upgrading'] ['dict_params'] ['params'] ['descr_2']
        self.dict_upgr_as_skip_2  = stage_3 ['dict_upgrading'] ['dict_params'] ['params'] ['p_skip_2']
        self.dict_upgr_as_stop_2  = stage_3 ['dict_upgrading'] ['dict_params'] ['params'] ['p_stop_list_2']    
        #
        #   dict_3  -- adr_house    
        #    
        self.dict_upgr_ah_descr_3 = stage_3 ['dict_upgrading'] ['dict_params'] ['params'] ['descr_3']
        self.dict_upgr_ah_skip_3  = stage_3 ['dict_upgrading'] ['dict_params'] ['params'] ['p_skip_3']
        self.dict_upgr_ah_stop_3  = stage_3 ['dict_upgrading'] ['dict_params'] ['params'] ['p_stop_list_3']    
        #
        #   Data aggregation
        #
        self.data_agg_descr      = stage_3 ['data_aggregation'] ['descr']
        self.data_agg_skip_agg   = stage_3 ['data_aggregation'] ['agg_params'] ['p_skip_agg']  
        self.data_agg_descr_agg  = stage_3 ['data_aggregation'] ['agg_params'] ['p_descr_agg']    
        self.data_agg_param_list = stage_3 ['data_aggregation'] ['agg_params'] ['p_param_list'] 
        #
        self.aa_agg_skip  = stage_3 ['data_aggregation'] ['agg_adr_area'] ['p_skip_adr_area']  
        self.aa_agg_descr = stage_3 ['data_aggregation'] ['agg_adr_area'] ['p_descr_adr_area']

        self.aa_agg_date          = stage_3 ['data_aggregation'] ['agg_adr_area'] ['params_aa'] ['p_date'] 
        self.aa_agg_obj_level     = stage_3 ['data_aggregation'] ['agg_adr_area'] ['params_aa'] ['p_obj_level'] 
        self.aa_agg_oper_type_ids = stage_3 ['data_aggregation'] ['agg_adr_area'] ['params_aa'] ['p_oper_type_ids'] 
        #
        self.ah_skip_adr_house = stage_3 ['data_aggregation'] ['agg_adr_house'] ['p_skip_adr_house']
        self.ah_agg_descr      = stage_3 ['data_aggregation'] ['agg_adr_house'] ['p_descr_adr_house'] 
        self.ah_agg_date       = stage_3 ['data_aggregation'] ['agg_adr_house'] ['params_ah'] ['p_date'] 
        self.ah_agg_parent_obj = stage_3 ['data_aggregation'] ['agg_adr_house'] ['params_ah'] ['p_parent_obj'] 
        #
        self.skip_obj_fias    = stage_3 ['data_aggregation'] ['obj_fias'] ['p_skip_obj_fias']  
        self.switch_house_sch = stage_3 ['data_aggregation'] ['obj_fias'] ['p_switch_house_sch']  
        self.obj_fias_descr   = stage_3 ['data_aggregation'] ['obj_fias'] ['p_descr_obj_fias']  
        
        f_yaml.close()     
        #
        #  Возможное переопределение. Данные из "hosts_xx.yaml"
        #  могут переопределить часть параметров в "stage_3.yaml". 
        #
        if not (p_fserver_nmb == None):
            self.g_fhost_id = p_fserver_nmb   

        if (not (p_schemas == None)) and (p_schemas.__len__() == 4):
            self.g_adr_area_sch    = p_schemas [0]
            self.g_adr_street_sch  = p_schemas [1]     
            self.g_adr_house_sch   = p_schemas [2]
            self.g_adr_house_sch_l = p_schemas [3]
            
        # Передавался как параметр командной строки !!!!
        if (not (p_id_region == 'None')) and (not (p_id_region == None)):  
            self.region_id = int(p_id_region)
            
# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint to the class
        """
#               1           2                
        sa = "<Path> <YAML_file_name>"
        if ( len( sys.argv ) - 1 ) < 2:
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )
#
        yp = yaml_patterns (sys.argv[1], sys.argv[2])
        print yp.region_id
        
        # stage_3_9
        print yp.stage_3_9_on
        print yp.mogrify_3_9
        
        print yp.gar_fias_set_gap_descr 
        print yp.gar_fias_set_gap_adr_area_skip 
        print yp.gar_fias_set_gap_adr_house_skip 
        
        sys.exit (0)

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)
