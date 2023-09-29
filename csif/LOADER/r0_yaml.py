#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: r0_yaml.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities. Parsing YAML-files.
# -----------------------------------------------------------------------------------------

import sys
import string

# import pyyaml module
import yaml
from yaml.loader import SafeLoader

PATH_DELIMITER = '/'  
VERSION_STR = "  Version 0.1.1 Build 2023-07-28"

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
        
        r0 = yaml.load(f_yaml, Loader=SafeLoader) 
        #
        # --------------------------------------------------------------
        #
        self.conninfo     = r0 ['total_params'] ['conninfo']  
        self.base_codec   = r0 ['total_params'] ['base_codec']  
        self.target_codec = r0 ['total_params'] ['target_codec']
        #
        self.len_rec           = r0 ['total_params'] ['len_rec']  
        self.meta_code         = r0 ['total_params'] ['meta_code']         
        self.dBAD              = r0 ['total_params'] ['dBAD']
        self.cash_receipt_type = r0 ['total_params'] ['cash_receipt_type']
        #
        #
        self.company_email = r0 ['atol_param'] ['company'] ['company_email']  
        self.company_sno   = r0 ['atol_param'] ['company'] ['company_sno']         
        #
        self.pmt_type = r0 ['atol_param'] ['payment'] ['pmt_type']
        #
        self.item_measure        = r0 ['atol_param'] ['item'] ['item_measure']
        self.item_payment_method = r0 ['atol_param'] ['item'] ['item_payment_method']
        self.payment_object      = r0 ['atol_param'] ['item'] ['payment_object']
        self.item_vat            = r0 ['atol_param'] ['item'] ['item_vat']        
        #
        self.type_source_reestr = r0 ['atol_param'] ['optional'] ['type_source_reestr']       
        #
        self.where_value = r0 ['sql_params'] ['where_value']    
        #

if __name__ == '__main__':
    try:
        """
             Main entrypoint to the class
        """
#                1                           
        sa = " <YAML_file_name>"
        if ( len( sys.argv ) - 1 ) < 1:
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )
#
        yp = yaml_patterns ('.', sys.argv[1])
        
        print yp.conninfo   
        print yp.base_codec 
        print yp.target_codec
        #
        print yp.len_rec   
        print yp.meta_code 
        print yp.dBAD      
        print yp.cash_receipt_type
        #
        print yp.company_email 
        print yp.company_sno   
        #
        print yp.pmt_type 
        #
        print yp.item_measure        
        print yp.item_payment_method 
        print yp.payment_object      
        print yp.item_vat            
        #
        print yp.type_source_reestr     
        #
        print yp.where_value
        
        sys.exit (0)

    #---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)
