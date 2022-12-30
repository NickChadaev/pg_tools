#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainCrtYaml.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities. Creating YAML-files.
# -----------------------------------------------------------------------------------------

import sys
import string

#           1          2         3              4             5        6      7        8
SA = " <CSV_pattern> <Nmb> <Target_Dir_1> <Target_Path_2> <Host_IP> <Port> <login> <passwd>"
LSA = 8
VERSION_STR_0 = "  Version 0.4.0 Build 2022-12-30"
VERSION_STR_1 = "  ------------------------------"

USE_CASE = "  USE CASE: "
US ="""    load_mainCrtYaml.py pattern_may_2.csv 02 ~/tmp Y_BUILD 127.0.0.1 5434 postgres postgres1
    Где:  
           pattern_may_2.csv - Шаблон
           02                - Номер шаблона в имени YAML-файла
           ~/tmp             - Целевой каталог
           Y_BUILD           - Путь (только для init, parse yamls)
           127.0.0.1         - IP
           5434              - порт
           postgres          - login
           postgres1         - passwd"""
#

SCRIPT_NOT_OPENED_0 = "... Pattern file not opened: '"
SCRIPT_NOT_OPENED_1 = "'."

YAML_NOT_OPENED_0 = "... YAML file not opened: '"
YAML_NOT_OPENED_1 = "'."

SPACES = "              "
POINTS = " ... "
DP = ": "

bCOMMENT_SIGN = "#"
bDELIMITER_SIGN = ";"

SPACE_0 = " "
# -----------------------------------

PATH_DELIMITER = '/'   

class m_yamls ():
    """
      Patterns для создания YAML-файлов
    """
    def __init__ (self):

        self.file_name_init  = "hosts_init_xx_{0}.yaml"
        self.file_name_parse = "hosts_parse_xx_{0}.yaml"     
        self.file_name_total = "hosts_total_xx_{0}.yaml"         

        self.hosts = "hosts:"
        self.last = """
        """
        self.init_yaml = """
       -                   
           name: init_{0:02d}
           descr: {2}
           conninfo: host={3} port={4} dbname=postgres user={7} password={8}
           params:
               id_region: {1}
               path: {5}
               exec: {6}/{0:02d}/stage_0_{0:02d}.csv"""             
            
        self.parse_yaml = """
       -                   
           name: parse_{0:02d}
           descr: {2}
           conninfo: host={3} port={4} dbname=unsi_test_{0:02d} user={7} password={8}
           params:
               id_region: {1}
               path: {5}
               exec: {6}/{0:02d}/stage_gar_c_{0:02d}.csv""" 
               
        self.total_yaml = """
       -                   
           name: unnsi_{0:02d}
           descr: {2}
           conninfo: host={3} port={4} dbname=unsi_test_{0:02d} user={5} password={6}
           params:
               id_region: {1}"""
     
class make_main (m_yamls):
 """
   Наследует patterns, определённые в m_yamls, создаёт YAML-файлы
 """
 #
 def __init__(self):
     
     m_yamls.__init__(self)

 #               1         2         3              4             5        6      7        8
 #  SA = " <CSV_pattern> <Nmb> <Target_Dir_1> <Target_Path_2> <Host_IP> <Port> <login> <passwd>"
 #  LSA = 8 
 #
 def to_do (self, p_csv_pattern,p_nmb,p_target_dir_1,p_target_path_2,p_host_ip, p_port,p_login,p_passwd):
    #
    file_name_init  = self.file_name_init.format(string.strip(p_nmb)) 
    file_name_parse = self.file_name_parse.format(string.strip(p_nmb))    
    file_name_total = self.file_name_total.format(string.strip(p_nmb))

    target_dir_1 = string.strip (p_target_dir_1)  
    target_path_2 = string.strip (p_target_path_2)
    #
    #  YAML-files
    #
    # INIT
    try:
        f_init = open ((target_dir_1 + PATH_DELIMITER + file_name_init), "w")

    except IOError, ex:
        print YAML_NOT_OPENED_0 + file_name_init + YAML_NOT_OPENED_1
        return 1

    # PARSE
    try:
        f_parse = open ((target_dir_1 + PATH_DELIMITER + file_name_parse), "w")

    except IOError, ex:
        print YAML_NOT_OPENED_0 + file_name_parse + YAML_NOT_OPENED_1
        return 1
    
    # TOTAL
    try:
        f_total = open ((target_dir_1 + PATH_DELIMITER + file_name_total), "w")

    # 
    except IOError, ex:
        print YAML_NOT_OPENED_0 + file_name_total + YAML_NOT_OPENED_1
        return 1    
    #  Pattern -- next step.
    #
    try:
        fd = open ( p_csv_pattern, "r" )

    except IOError, ex:
        print SCRIPT_NOT_OPENED_0 + p_csv_pattern + SCRIPT_NOT_OPENED_1
        return 1

    self.c_list = fd.readlines ()
    fd.close ()

    host_ip = string.strip (p_host_ip)
    port = str(p_port)
    
    rc = 0
    
    f_init.write (self.hosts)
    
    f_parse.write (self.hosts)
    f_total.write (self.hosts)

    for ce_list in self.c_list:
          
      if ce_list [0] <> bCOMMENT_SIGN:
        l_words = string.split ( ce_list, bDELIMITER_SIGN )

        if len (l_words) >= 5:
            fias_id      = string.strip (l_words [0])
            id_area      = string.strip (l_words [1])
            nm_area      = string.strip (l_words [3])
            nm_area_full = string.strip (l_words [4])
            #
            print POINTS + nm_area_full + DP 
            
            print SPACES + "Init"
            f_init.write (self.init_yaml.format (int (fias_id), int(id_area),\
                nm_area_full, host_ip, port, target_dir_1, (target_dir_1 + PATH_DELIMITER + target_path_2),\
                    string.strip(p_login), string.strip(p_passwd)))
            
            print SPACES + "Parse"
            f_parse.write (self.parse_yaml.format (int (fias_id), int (id_area),\
                nm_area_full, host_ip, port, target_dir_1,(target_dir_1 + PATH_DELIMITER + target_path_2),\
                    string.strip(p_login), string.strip(p_passwd)))
            
            print SPACES + "Total"
            f_total.write (self.total_yaml.format (int (fias_id), int (id_area), nm_area_full,\
                host_ip, port, string.strip(p_login), string.strip(p_passwd)))

    f_init.write  (self.last)
    f_parse.write (self.last)
    f_total.write (self.last)

    f_init.close()
    f_parse.close()
    f_total.close()
    
    return rc

# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
        """
        if ( len( sys.argv ) - 1 ) < LSA:
            print VERSION_STR_0 
            print VERSION_STR_1             
            print "  Usage: " + str ( sys.argv [0] ) + SA
            #
            print USE_CASE
            print US
            sys.exit( 1 )
#
        mm = make_main ()
        rc = mm.to_do (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6], \
            sys.argv[7], sys.argv[8])
        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

