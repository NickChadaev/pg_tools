#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainCrtYaml.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities. Creating YAML-files.
# -----------------------------------------------------------------------------------------

import sys
import string

#           1              2              3             4        5        6                7               8              9                10
SA = " <CSV_pattern> <Target_Path_1> <Target_Path_2> <Host_IP> <Port> <Fserver_nmb> <Adr_area_sch> <Adr_street_sch> <Adr_house_sch>  <Adr_house_sch_l>"
LSA = 10
VERSION_STR_0 = "  Version 0.2.1 Build 2022-05-23"
VERSION_STR_1 = "  ------------------------------"

USE_CASE = "  USE CASE: "
US ="    load_mainCrtYaml.py pattern_may_2.csv . /home/rootadmin/abr_u/Y_BUILD 127.0.0.1 5434 10 unnsi unnsi unnsi gar_tmp"
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

        self.file_name_init  = "hosts_init_xx.yaml"
        self.file_name_build = "hosts_build_xx.yaml" 
        self.file_name_parse = "hosts_parse_xx.yaml"     
        self.file_name_total = "hosts_total_xx.yaml"         

        self.globals_build = """global_params:
    g_fserver_nmb: {0}    
    g_adr_area_sch: {1}
    g_adr_street_sch: {2}
    g_adr_house_sch: {3}
    g_adr_house_sch_l: {4}
"""
    
        self.hosts = "hosts:"
        self.last = """
        """
        self.init_yaml = """
       -                   
           name: init_{0:02d}
           descr: {2}
           conninfo: host={3} port={4} dbname=postgres user=postgres password=postgres
           params:
               id_region: {1}
               path: {5}
               exec: {5}/{0:02d}/stage_0_{0:02d}.csv"""             
            
        self.build_yaml = """
       -                   
           name: build_{0:02d}
           descr: {2}
           conninfo: host={3} port={4} dbname=unsi_test_{0:02d} user=postgres password=postgres  
           params:
               id_region: {1}           
               path: {5}
               exec: {5}/{0:02d}/stage_3_{0:02d}.csv"""   
               
        self.parse_yaml = """
       -                   
           name: parse_{0:02d}
           descr: {2}
           conninfo: host={3} port={4} dbname=unsi_test_{0:02d} user=postgres password=postgres
           params:
               id_region: {1}
               path: {5}
               exec: {5}/{0:02d}/stage_gar_c_{0:02d}.csv""" 
               
        self.total_yaml = """
       -                   
           name: unnsi_{0:02d}
           descr: {2}
           conninfo: host={3} port={4} dbname=unsi_test_{0:02d} user=postgres password=postgres
           params:
               id_region: {1}"""
     
class make_main (m_yamls):
 """
   Наследует patterns, определённые в m_yamls, создаёт YAML-файлы
 """
 #
 def __init__(self):
     
     m_yamls.__init__(self)
     
 #              1              2              3             4        5        6                7       
 #  sa = " <CSV_pattern> <Target_Path_1> <Target_Path_2> <Host_IP> <Port> <F-server-nmb> <F-schema-name>
 #       
 def to_do (self, p_csv_pattern, p_target_path_1, p_target_path_2, p_host_ip,\
     p_port, p_fserver_nmb, p_adr_area_sch, p_adr_street_sch, p_adr_house_sch,\
         p_adr_house_sch_l):
    #
    target_path_1 = string.strip (p_target_path_1)  
    target_path_2 = string.strip (p_target_path_2)
    #
    #  YAML-files
    #
    # INIT
    try:
        f_init = open ((target_path_1 + PATH_DELIMITER + self.file_name_init), "w")

    except IOError, ex:
        print YAML_NOT_OPENED_0 + self.file_name_init + YAML_NOT_OPENED_1
        return 1

    # BUILD
    try:
        f_build = open ((target_path_1 + PATH_DELIMITER + self.file_name_build), "w")

    except IOError, ex:
        print YAML_NOT_OPENED_0 + self.file_name_build + YAML_NOT_OPENED_1
        return 1
    
    # PARSE
    try:
        f_parse = open ((target_path_1 + PATH_DELIMITER + self.file_name_parse), "w")

    except IOError, ex:
        print YAML_NOT_OPENED_0 + self.file_name_parse + YAML_NOT_OPENED_1
        return 1
    
    # TOTAL
    try:
        f_total = open ((target_path_1 + PATH_DELIMITER + self.file_name_total), "w")

    # 
    except IOError, ex:
        print YAML_NOT_OPENED_0 + self.file_name_total + YAML_NOT_OPENED_1
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
    #
    # 2022-05-04
    fserver_nmb     = str ( p_fserver_nmb )  
    adr_area_sch    = string.strip ( p_adr_area_sch   )
    adr_street_sch  = string.strip ( p_adr_street_sch )
    adr_house_sch   = string.strip ( p_adr_house_sch  )
    adr_house_sch_l = string.strip ( p_adr_house_sch_l)   
    # 2022-05-04
    
    rc = 0
    
    f_init.write (self.hosts)
    
    # 2022-05-06
    f_build.write (self.globals_build.format (fserver_nmb, adr_area_sch, adr_street_sch,\
            adr_house_sch, adr_house_sch_l))
    f_build.write ("\n" + self.hosts)  
    # 2022-05-06
    
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
                nm_area_full, host_ip, port, target_path_2))
                
            print SPACES + "Build"
            f_build.write (self.build_yaml.format (int (fias_id), int (id_area),\
                nm_area_full, host_ip, port, target_path_2))
            
            print SPACES + "Parse"
            f_parse.write (self.parse_yaml.format (int (fias_id), int (id_area),\
                nm_area_full, host_ip, port, target_path_2))
            
            print SPACES + "Total"
            f_total.write (self.total_yaml.format (int (fias_id), int (id_area),\
                nm_area_full, host_ip, port))

    f_init.write  (self.last)
    f_build.write (self.last)
    f_parse.write (self.last)
    f_total.write (self.last)

    f_init.close()
    f_build.close()
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
        rc = mm.to_do (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5],\
            sys.argv[6], sys.argv[7], sys.argv[8], sys.argv[9], sys.argv[10])
        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

# -------------------------------
# USE CASE:
#  load_mainCrtYaml.py pattern_may_2.csv . /home/rootadmin/abr_u/Y_BUILD 127.0.0.1 5434 10 unnsi unnsi unnsi gar_tmp
#
#
