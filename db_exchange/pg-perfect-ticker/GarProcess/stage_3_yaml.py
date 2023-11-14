#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: GarProcess package
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities. Parsing YAML-files.
#       2023-03-28 - version for python3
# -----------------------------------------------------------------------------------------

import sys
import string

# import pyyaml module
import yaml
from yaml.loader import SafeLoader

PATH_DELIMITER = '/'  
VERSION_STR = "  Version 1.0.1 Build 2023-11-14"

YAML_NOT_OPENED_0 = "... YAML file not opened: '"
YAML_NOT_OPENED_1 = "'."

class yaml_patterns ():
    """
      YAML Patterns 
        =============================================================================================== 
        "global_params"           - Установка глобальных переменных 
        "gar_tmp_set_logged"      - Установка признака LOGGED у таблиц в схеме gar_tmp
        "gar_fias_crt_idx"        - Создание рабочих индесов в схеме gar_fias.
        "gar_tmp_clear_tbl"       - Очистка данных во временной схеме
        "gar_tmp_switch_indexies" - Смена индексного покрытия в GAR_FIAS-таблицах
        "unload_data"             - Загрузка региональных фрагментов из ADR_AREA, ADR_STREET, ADR_HOUSE
        "seq_settings"            - Установка последовательностей
        "dict_upgrading"          - Актуализация справочников
        "data_aggregation"        - Агрегация данных
        "obj_fias"                - Заполнение таблицы "gar_tmp.xxx_obj_fias"       
        ===============================================================================================
    """
    
    def __init__ ( self, p_path, p_yaml_name, p_fserver_nmb = None,\
        p_schemas = None, p_id_region = None, p_date_2 = None ):

        target_dir = p_path.strip() + PATH_DELIMITER
        yaml_file_name = p_yaml_name.strip()

        try:
            f_yaml = open ((target_dir + yaml_file_name), "r")
        
        except IOError as ex:
            print (YAML_NOT_OPENED_0 + yaml_file_name + YAML_NOT_OPENED_1)
            return 1
        
        stage_3 = yaml.load(f_yaml, Loader=SafeLoader) 
        #
        #  Control
        #
        self.stage_3_I_on = stage_3 ['control_params']['stage_3_I']          
        self.stage_3_9_on = stage_3 ['control_params']['stage_3_9']          
        self.stage_3_0_on = stage_3 ['control_params']['stage_3_0']  
        self.stage_3_1_on = stage_3 ['control_params']['stage_3_1']  
        self.stage_3_2_on = stage_3 ['control_params']['stage_3_2']  
        self.stage_3_3_on = stage_3 ['control_params']['stage_3_3']  
        #
        self.mogrify_3_I = stage_3 ['control_params']['mogrify_3_I']        
        self.mogrify_3_9 = stage_3 ['control_params']['mogrify_3_9']
        self.mogrify_3_0 = stage_3 ['control_params']['mogrify_3_0']
        self.mogrify_3_1 = stage_3 ['control_params']['mogrify_3_1']
        self.mogrify_3_2 = stage_3 ['control_params']['mogrify_3_2']
        self.mogrify_3_3 = stage_3 ['control_params']['mogrify_3_3']         
        #
        #  Global
        #
        self.region_id        = stage_3 ['global_params']['g_region_id']      
        self.g_fhost_id       = stage_3 ['global_params']['g_fserver_nmb']   
        #        
        self.g_adr_area_sch   = stage_3 ['global_params']['g_adr_area_sch']      
        self.g_adr_street_sch = stage_3 ['global_params']['g_adr_street_sch']      
        self.g_adr_house_sch  = stage_3 ['global_params']['g_adr_house_sch']   
        #
        self.g_adr_house_sch_l = stage_3 ['global_params']['g_adr_house_sch_l']    
        #
        self.g_adr_area_sch_l = stage_3 ['global_params']['g_adr_area_sch_l']    
        self.g_adr_street_sch_l = stage_3 ['global_params']['g_adr_street_sch_l']    
        self.g_adr_hist_sch = stage_3 ['global_params']['g_adr_hist_sch']    
        #
        # stage_3_I
        #        
        self.gf_cidx_descr = stage_3 ['gar_fias_crt_idx']['descr']
        self.gf_cidx_skip  = stage_3 ['gar_fias_crt_idx']['params']['p_skip']
        self.gf_cidx_sw    = stage_3 ['gar_fias_crt_idx']['params']['p_sw']
        #
        # stage_3_9 + 2023-11-10
        #        
        self.gar_fias_set_gap_descr = stage_3 ['gar_fias_set_gap']['descr']  
        #
        self.gar_fias_set_gap_adr_area_skip      = stage_3 ['gar_fias_set_gap']['params_adr_area']['p_skip']
        self.gar_fias_set_gap_adr_area_date      = stage_3 ['gar_fias_set_gap']['params_adr_area']['p_date']
        self.gar_fias_set_gap_adr_area_obj_level = stage_3 ['gar_fias_set_gap']['params_adr_area']['p_obj_level']
        self.gar_fias_set_gap_adr_area_qty       = stage_3 ['gar_fias_set_gap']['params_adr_area']['p_qty']
        
        self.gar_fias_set_gap_adr_house_skip = stage_3 ['gar_fias_set_gap']['params_adr_house']['p_skip']
        #
        # 2022-09-02/2023-11-10
        #
        self.gar_fias_update_children_descr  = stage_3 ['gar_fias_update_children']['descr']
        self.gar_fias_update_children_skip   = stage_3 ['gar_fias_update_children']['param_adr_area_update']['p_skip']
        #
        self.gar_fias_addr_obj_select_twins_descr = stage_3 ['gar_fias_addr_obj_select_twins']['descr']
        self.gar_fias_addr_obj_select_twins_skip  = stage_3 ['gar_fias_addr_obj_select_twins']['param_select_twin']['p_skip']
        self.gar_fias_addr_obj_select_twins_qty   = stage_3 ['gar_fias_addr_obj_select_twins']['param_select_twin']['p_qty']
        #  
        # stage_3_0
        #        
        self.gt_stl_descr = stage_3 ['gar_tmp_set_logged']['descr']
        self.gt_stl_skip  = stage_3 ['gar_tmp_set_logged']['params']['p_skip']
        self.gt_stl_sw    = stage_3 ['gar_tmp_set_logged']['params']['p_sw']
        #
        self.gt_clr_descr = stage_3 ['gar_tmp_clear_tbl']['descr']
        self.gt_clr_skip  = stage_3 ['gar_tmp_clear_tbl']['params']['p_skip']
        self.gt_clr_sw    = stage_3 ['gar_tmp_clear_tbl']['params']['p_sw']
        #
        self.gt_sidx_descr           = stage_3 ['gar_tmp_switch_indexies']['descr']
        self.gt_sidx_skip            = stage_3 ['gar_tmp_switch_indexies']['params']['p_skip']
        self.gt_sidx_skip_adr_object = stage_3 ['gar_tmp_switch_indexies']['params']['p_skip_adr_object']
        # 
        self.gt_sidx_street_uniq_sw  = stage_3 ['gar_tmp_switch_indexies']['params']['params_street']['p_uniq_sw']
        self.gt_sidx_house_uniq_sw   = stage_3 ['gar_tmp_switch_indexies']['params']['params_house']['p_uniq_sw']
        self.gt_sidx_objects_uniq_x2 = stage_3 ['gar_tmp_switch_indexies']['params']['params_objects']['p_uniq_x2']        
        #
        # stage_3_1   - Unloading and settings
        #
        self.unload_adr_area_type_descr = stage_3 ['unload_data_adr_area_type']['descr']
        self.unload_adr_area_type_skip  = stage_3 ['unload_data_adr_area_type']['params']['p_skip']
        #
        self.unload_adr_street_type_descr = stage_3 ['unload_data_adr_street_type']['descr']
        self.unload_adr_street_type_skip  = stage_3 ['unload_data_adr_street_type']['params']['p_skip']
        #
        self.unload_adr_house_type_descr = stage_3 ['unload_data_adr_house_type']['descr']
        self.unload_adr_house_type_skip  = stage_3 ['unload_data_adr_house_type']['params']['p_skip']
        #        
        self.unload_adr_area_descr = stage_3 ['unload_data_adr_area']['descr']
        self.unload_adr_area_skip  = stage_3 ['unload_data_adr_area']['params']['p_skip']
        #
        self.unload_adr_street_descr = stage_3 ['unload_data_adr_street']['descr']
        self.unload_adr_street_skip  = stage_3 ['unload_data_adr_street']['params']['p_skip']
        #
        self.unload_adr_house_descr           = stage_3 ['unload_data_adr_house']['descr']
        self.unload_adr_house_skip            = stage_3 ['unload_data_adr_house']['params']['p_skip']
        self.unload_adr_house_skip_adr_object = stage_3 ['unload_data_adr_house']['params']['p_skip_adr_object']
        #
        self.seq_set_descr          = stage_3 ['seq_settings']['descr']    
        self.seq_set_skip           = stage_3 ['seq_settings']['params']['p_skip']    
        self.seq_set_seq_name       = stage_3 ['seq_settings']['params']['p_seq_name']
        self.seq_set_seq_hist_name  = stage_3 ['seq_settings']['params']['p_seq_hist_name']
        self.seq_set_init_val       = stage_3 ['seq_settings']['params']['p_init_value']
        #
        self.seq_set_adr_area_sch   = stage_3 ['seq_settings']['params']['sq_adr_area_sch']  
        self.seq_set_adr_street_sch = stage_3 ['seq_settings']['params']['sq_adr_street_sch']
        self.seq_set_adr_house_sch  = stage_3 ['seq_settings']['params']['sq_adr_house_sch'] 
        #
        # stage_3_2 - Обновление справочников типов
        #        
        self.dict_upgr_descr      = stage_3 ['dict_upgrading']['descr']    
        self.dict_upgr_schs       = stage_3 ['dict_upgrading']['dict_params']['p_schemas']     
        self.dict_upgr_op_type    = stage_3 ['dict_upgrading']['dict_params']['p_op_type']     
        #
        #   dict_1  -- adr_area    
        # 
        self.dict_upgr_aa_descr_1 = stage_3 ['dict_upgrading']['dict_params']['params']['descr_1']
        self.dict_upgr_aa_skip_1  = stage_3 ['dict_upgrading']['dict_params']['params']['p_skip_1']
        self.dict_upgr_aa_stop_1  = stage_3 ['dict_upgrading']['dict_params']['params']['p_stop_list_1']    
        self.dict_upgr_aa_add_query_1     = stage_3 ['dict_upgrading']['dict_params']['params']['p_add_query_1']    
        self.dict_upgr_aa_control_query_1 = stage_3 ['dict_upgrading']['dict_params']['params']['p_control_query_1']    
        #
        #   dict_2  -- adr_street    
        # 
        self.dict_upgr_as_descr_2 = stage_3 ['dict_upgrading']['dict_params']['params']['descr_2']
        self.dict_upgr_as_skip_2  = stage_3 ['dict_upgrading']['dict_params']['params']['p_skip_2']
        self.dict_upgr_as_stop_2  = stage_3 ['dict_upgrading']['dict_params']['params']['p_stop_list_2']    
        self.dict_upgr_as_add_query_2     = stage_3 ['dict_upgrading']['dict_params']['params']['p_add_query_2']    
        self.dict_upgr_as_control_query_2 = stage_3 ['dict_upgrading']['dict_params']['params']['p_control_query_2']    
        #
        #   dict_3  -- adr_house    
        #    
        self.dict_upgr_ah_descr_3 = stage_3 ['dict_upgrading']['dict_params']['params']['descr_3']
        self.dict_upgr_ah_skip_3  = stage_3 ['dict_upgrading']['dict_params']['params']['p_skip_3']
        self.dict_upgr_ah_stop_3  = stage_3 ['dict_upgrading']['dict_params']['params']['p_stop_list_3']    
        self.dict_upgr_ah_add_query_3     = stage_3 ['dict_upgrading']['dict_params']['params']['p_add_query_3']    
        self.dict_upgr_ah_control_query_3 = stage_3 ['dict_upgrading']['dict_params']['params']['p_control_query_3']    
        #
        # stage_3_3 - Data aggregation
        #         
        self.data_agg_descr      = stage_3 ['data_aggregation']['descr']
        self.data_agg_skip_agg   = stage_3 ['data_aggregation']['agg_params']['p_skip_agg']  
        self.data_agg_descr_agg  = stage_3 ['data_aggregation']['agg_params']['p_descr_agg']    
        self.data_agg_param_list = stage_3 ['data_aggregation']['agg_params']['p_param_list'] 
        #
        self.aa_agg_skip  = stage_3 ['data_aggregation']['agg_adr_area']['p_skip_adr_area']  
        self.aa_agg_descr = stage_3 ['data_aggregation']['agg_adr_area']['p_descr_adr_area']

        self.aa_agg_date          = stage_3 ['data_aggregation']['agg_adr_area']['params_aa']['p_date'] 
        self.aa_agg_obj_level     = stage_3 ['data_aggregation']['agg_adr_area']['params_aa']['p_obj_level'] 
        self.aa_agg_oper_type_ids = stage_3 ['data_aggregation']['agg_adr_area']['params_aa']['p_oper_type_ids'] 
        #
        self.ah_skip_adr_house = stage_3 ['data_aggregation']['agg_adr_house']['p_skip_adr_house']
        self.ah_agg_descr      = stage_3 ['data_aggregation']['agg_adr_house']['p_descr_adr_house'] 
        self.ah_agg_date       = stage_3 ['data_aggregation']['agg_adr_house']['params_ah']['p_date'] 
        self.ah_agg_parent_obj = stage_3 ['data_aggregation']['agg_adr_house']['params_ah']['p_parent_obj'] 
        #
        self.skip_obj_fias = stage_3 ['data_aggregation']['obj_fias']['p_skip_obj_fias']  
        #
        self.switch_adr_area_sch   = stage_3 ['data_aggregation']['obj_fias']['p_switch_adr_area_sch']  
        self.switch_adr_street_sch = stage_3 ['data_aggregation']['obj_fias']['p_switch_adr_street_sch']  
        self.switch_adr_house_sch  = stage_3 ['data_aggregation']['obj_fias']['p_switch_adr_house_sch']  
        #
        self.obj_fias_descr = stage_3 ['data_aggregation']['obj_fias']['p_descr_obj_fias']  
        
        f_yaml.close()     
        #
        #  Возможное переопределение. Данные из "hosts_xx.yaml"
        #  могут переопределить часть параметров в "stage_3.yaml". 
        #
        ## if not (p_fserver_nmb == None):
        ##     self.g_fhost_id = p_fserver_nmb   

        ## if (not (p_schemas == None)) and (p_schemas.__len__() == 4):
        ##     self.g_adr_area_sch    = p_schemas [0]
        ##     self.g_adr_street_sch  = p_schemas [1]     
        ##     self.g_adr_house_sch   = p_schemas [2]
        ##     self.g_adr_house_sch_l = p_schemas [3]
            
        # Передавался как параметр командной строки !!!!
        if (not (p_id_region == 'None')) and (not (p_id_region == None)):  
            self.region_id = int(p_id_region)
        # ???
        if (not(p_date_2 == 'None')) and (not(p_date_2 == None)):
            self.date_2 = p_date_2 
        elif (not(self.gar_fias_set_gap_adr_area_date == 'None')) and\
            (not(self.gar_fias_set_gap_adr_area_date == None)):
                self.date_2 = self.gar_fias_set_gap_adr_area_date
            
# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint to the class
        """
#               1           2                
        sa = " <Path> <YAML_file_name>"
        if ( len( sys.argv) - 1) < 2:
            print (VERSION_STR)
            print ("  Usage: " + str ( sys.argv [0]) + sa)
            sys.exit( 1)
#
        yp = yaml_patterns (sys.argv[1], sys.argv[2])
        print (yp.region_id)
        
        #-------------------------------------------------
        print ('\n' + '** Control **' + '\n')
        #
        print (yp.stage_3_I_on)  
        print (yp.stage_3_9_on)          
        print (yp.stage_3_0_on)  
        print (yp.stage_3_1_on)  
        print (yp.stage_3_2_on)  
        print (yp.stage_3_3_on)  
        #
        print (yp.mogrify_3_I)        
        print (yp.mogrify_3_9)
        print (yp.mogrify_3_0)
        print (yp.mogrify_3_1)
        print (yp.mogrify_3_2)
        print (yp.mogrify_3_3)         
        #
        print ('\n' + '**  Global **' + '\n')
        #
        print (yp.region_id)      
        print (yp.g_fhost_id)    
        #        
        print (yp.g_adr_area_sch)      
        print (yp.g_adr_street_sch)      
        print (yp.g_adr_house_sch)      
        #
        print (yp.g_adr_house_sch_l)     
        print (yp.g_adr_area_sch_l)     
        print (yp.g_adr_street_sch_l)     
        print (yp.g_adr_hist_sch)     
        #        
        print ('\n' + '** stage_3_I **' + '\n')
        #        
        print (yp.gf_cidx_descr)
        print (yp.gf_cidx_skip) 
        print (yp.gf_cidx_sw)   
        #        
        print ('\n' + '** stage_3_9 **' + '\n')
        #        
        print (yp.gar_fias_set_gap_descr)         
        print (yp.gar_fias_set_gap_adr_area_skip) 
        print (yp.gar_fias_set_gap_adr_area_date)
        print (yp.gar_fias_set_gap_adr_area_obj_level)
        print (yp.gar_fias_set_gap_adr_area_qty)
        
        print (yp.gar_fias_set_gap_adr_house_skip)
        #
        # 2022-09-02/2023-11-10
        #
        print (yp.gar_fias_update_children_descr)
        print (yp.gar_fias_update_children_skip)
        #
        print (yp.gar_fias_addr_obj_select_twins_descr) 
        print (yp.gar_fias_addr_obj_select_twins_skip)
        print (yp.gar_fias_addr_obj_select_twins_qty)

        print ('\n' + '** stage_3_0 **' + '\n')
        #        
        print (yp.gt_stl_descr)
        print (yp.gt_stl_skip)
        print (yp.gt_stl_sw)
        #
        print (yp.gt_clr_descr)
        print (yp.gt_clr_skip)
        print (yp.gt_clr_sw)
        #
        print (yp.gt_sidx_descr)
        print (yp.gt_sidx_skip)
        print (yp.gt_sidx_skip_adr_object)
        # 
        print (yp.gt_sidx_street_uniq_sw) 
        print (yp.gt_sidx_house_uniq_sw) 
        print (yp.gt_sidx_objects_uniq_x2) 
        #
        print ('\n' + '** stage_3_1 **' + '\n')
        #
        print (yp.unload_adr_area_type_descr)
        print (yp.unload_adr_area_type_skip)
        #
        print (yp.unload_adr_street_type_descr)
        print (yp.unload_adr_street_type_skip)
        #
        print (yp.unload_adr_house_type_descr)          
        print (yp.unload_adr_house_type_skip)          
        #
        print (yp.unload_adr_area_descr)
        print (yp.unload_adr_area_skip)
        #
        print (yp.unload_adr_street_descr)
        print (yp.unload_adr_street_skip)
        #
        print (yp.unload_adr_house_descr)         
        print (yp.unload_adr_house_skip)
        print (yp.unload_adr_house_skip_adr_object)
        #
        print (yp.seq_set_descr)
        print (yp.seq_set_skip)
        print (yp.seq_set_seq_name)
        print (yp.seq_set_seq_hist_name)
        print (yp.seq_set_init_val)
        print (yp.seq_set_adr_area_sch)
        print (yp.seq_set_adr_street_sch)
        print (yp.seq_set_adr_house_sch)
        #
        print ('\n' + '** stage_3_2 **' +  '\n')
        #        
        print (yp.dict_upgr_descr)   
        print (yp.dict_upgr_schs)   
        print (yp.dict_upgr_op_type)   
        #
        #   dict_1  -- adr_area    
        # 
        print (yp.dict_upgr_aa_descr_1)
        print (yp.dict_upgr_aa_skip_1)
        print (yp.dict_upgr_aa_stop_1)
        print (yp.dict_upgr_aa_add_query_1)
        print (yp.dict_upgr_aa_control_query_1)
        #
        #   dict_2  -- adr_street    
        # 
        print (yp.dict_upgr_as_descr_2)
        print (yp.dict_upgr_as_skip_2)
        print (yp.dict_upgr_as_stop_2)
        print (yp.dict_upgr_as_add_query_2)
        print (yp.dict_upgr_as_control_query_2)
        #
        #   dict_3  -- adr_house    
        #    
        print (yp.dict_upgr_ah_descr_3)
        print (yp.dict_upgr_ah_skip_3)
        print (yp.dict_upgr_ah_stop_3)
        print (yp.dict_upgr_ah_add_query_3)
        print (yp.dict_upgr_ah_control_query_3)
        #
        print ('\n' + '** stage_3_3 **')
        #         
        print (yp.data_agg_descr)  
        print (yp.data_agg_skip_agg)
        print (yp.data_agg_descr_agg)  
        print (yp.data_agg_param_list)
        #
        print (yp.aa_agg_skip) 
        print (yp.aa_agg_descr)

        print (yp.aa_agg_date)  
        print (yp.aa_agg_obj_level)
        print (yp.aa_agg_oper_type_ids)
        #
        print (yp.ah_skip_adr_house)
        print (yp.ah_agg_descr)
        print (yp.ah_agg_date)
        print (yp.ah_agg_parent_obj)
        #
        print (yp.skip_obj_fias) 
        #
        print (yp.switch_adr_area_sch)
        print (yp.switch_adr_street_sch) 
        print (yp.switch_adr_house_sch)
        #
        print (yp.obj_fias_descr)   

        #-------------------------------------------------
        
        sys.exit (0)

#---------------------------------------
    except KeyboardInterrupt as e:
        print ("... Terminated by user: ")
        sys.exit (1)
