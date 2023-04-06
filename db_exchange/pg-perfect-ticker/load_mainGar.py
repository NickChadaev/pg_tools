#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainCar.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Load data into database
# HIST: 2021-11-23 - created
# NOTS: 2022-05-05 - "fserver_nmb", "fschema_name" was added. 
#                    "fd_log", "fd0" - are external classes. 
#       2023-03-17 - version for python3
# ----------------------------------------------------------------------------------------
import sys
import os
import string
import datetime
import psycopg2    

# 2022-05-06
from MainProcess import fd_0 as Fd0
from MainProcess import fd_log as FdLog
# 2022-05-06

# 2022-08-11
import load_mainStage3 as Stage3
import load_mainStage4 as Stage4
import load_mainStage6 as Stage6
# 2022-08-11

import GarFias.r_scan_dir as ScanDir
# ------------------------------------------------------
#   Common Part
#
import GarFias.load_gar_add_house_type as AddHouseType
import GarFias.load_gar_addr_obj_type as AddrObjType
import GarFias.load_gar_apartment_type as ApartmentType
import GarFias.load_gar_house_type as HouseType
import GarFias.load_gar_norm_docs_kinds as NormDocsKinds
import GarFias.load_gar_norm_docs_types as NormDocsTypes
import GarFias.load_gar_object_level as ObjectLevel
import GarFias.load_gar_operation_type as OperationType 
import GarFias.load_gar_param_type as ParamType 
import GarFias.load_gar_room_type as RoomsType

bAS_ADDHOUSE_TYPES       = "ASADDHOUSETYPES"
bAS_ADDR_OBJ_TYPES       = "ASADDROBJTYPES"
bAS_APARTMENT_TYPES      = "ASAPARTMENTTYPES"
bAS_HOUSE_TYPES          = "ASHOUSETYPES"
bAS_NORMATIVE_DOCS_KINDS = "ASNORMATIVEDOCSKINDS"
bAS_NORMATIVE_DOCS_TYPES = "ASNORMATIVEDOCSTYPES"
bAS_OBJECT_LEVELS        = "ASOBJECTLEVELS"
bAS_OPERATION_TYPES      = "ASOPERATIONTYPES"
bAS_PARAM_TYPES          = "ASPARAMTYPES"
bAS_ROOM_TYPES           = "ASROOMTYPES"

# ---------------------------------------------
#    Region part
#
import GarFias.load_gar_addr_obj as AddrObj
import GarFias.load_gar_addr_obj_division as AddrObjDivision
import GarFias.load_gar_addr_obj_params as AddrObjParams  
import GarFias.load_gar_adm_hierarchy as AdmHierarchy
import GarFias.load_gar_apartments as Apartments
import GarFias.load_gar_apartments_params as ApartmentsParams
import GarFias.load_gar_carplaces as Carplaces
import GarFias.load_gar_carplaces_params as CarplacesParams  
import GarFias.load_gar_change_history as ChangeHistory
import GarFias.load_gar_houses as Houses
import GarFias.load_gar_houses_params as HousesParams 
import GarFias.load_gar_mun_hierarchy as MunHierarchy
import GarFias.load_gar_normative_docs as NormativeDocs
import GarFias.load_gar_reestr_objects as ReestrObjects
import GarFias.load_gar_rooms as Rooms
import GarFias.load_gar_rooms_params as RoomsParams
import GarFias.load_gar_steads as Steads
import GarFias.load_gar_steads_params as SteadsParams 

bAS_ADDR_OBJ          = "ASADDROBJ"
bAS_ADDR_OBJ_DIVISION = "ASADDROBJDIVISION"
bAS_ADDR_OBJ_PARAMS   = "ASADDROBJPARAMS"
bAS_ADM_HIERARCHY     = "ASADMHIERARCHY"
bAS_APARTMENTS        = "ASAPARTMENTS"
bAS_APARTMENTS_PARAMS = "ASAPARTMENTSPARAMS"
bAS_CARPLACES         = "ASCARPLACES"
bAS_CARPLACES_PARAMS  = "ASCARPLACESPARAMS"
bAS_CHANGE_HISTORY    = "ASCHANGEHISTORY"
bAS_HOUSES            = "ASHOUSES"
bAS_HOUSES_PARAMS     = "ASHOUSESPARAMS"
bAS_MUN_HIERARCHY     = "ASMUNHIERARCHY"
bAS_NORMATIVE_DOCS    = "ASNORMATIVEDOCS"
bAS_REESTR_OBJECTS    = "ASREESTROBJECTS"
bAS_ROOMS             = "ASROOMS"
bAS_ROOMS_PARAMS      = "ASROOMSPARAMS"
bAS_STEADS            = "ASSTEADS"
bAS_STEADS_PARAMS     = "ASSTEADSPARAMS"

VERSION_STR = "  Version 1.0.0 Build 2023-03-17"

GET_DT = "SELECT now()::TIMESTAMP without time zone FROM current_timestamp;"

SCRIPT_NOT_OPENED_0 = "... Sript file not opened: '"
SCRIPT_NOT_OPENED_1 = "'."

OUT_NOT_OPENED_0 = "... Out file not opened: '"
OUT_NOT_OPENED_1 = "'."

POINTS = " ... "

#------------------------
bLOG_NAME = "{0}process{1}.log"
bOUT_NAME = "{0}process{1}.out"
bERR_NAME = "{0}process{1}.err"
bSQL_NAME = "{0}process{1}.sql"
#------------------------

bCOMMENT_SIGN = "#"
bDELIMITER_SIGN = ";"
bUL = "_"

# ----------------------------------
DIRECT_SQL_COMMAND             = "0"
SEQUENCE_SQL_COMMANDS          = "1"
LOAD_XML                       = "2"    
STAGE_3_YAML                   = "3"        #  2022-05-06
STAGE_4_YAML                   = "4"        #  2022-05-06
SEQUENCE_SQL_COMMANDS_WITH_LOG = "5"   
STAGE_6_YAML                   = "6"        #  2022-08-11 
_RESERVED4_                    = "7" 
MESSAGE                        = "X"

# Version support move to batch-file
CALL_PROC_F = """SELECT gar_version_pcg_support.save_gar_files_by_region (

       i_nm_garfias_version := (NULLIF (%s, ''))::date   
      ,i_id_region          := (NULLIF (%s, ''))::integer  
      ,i_file_path          := (NULLIF (%s, ''))::text          
);
"""
#
# ---------------------------------------------------------------------
SPACE_0 = " "
EMP = ""
bNL = '\n'
# -----------------------------------

PATH_DELIMITER = '/'  # Nick 2020-05-11
SQL_DELIMITER = '\n' + "-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" + '\n'


class fd_log_s ( FdLog.fd_log ):
    
    # 2022-02-27
    def open_sql_log ( self, p_sql_log_name, p_proc_mark = EMP, p_log_mark = EMP):
        #
        self.sql_log_name  = p_sql_log_name.format (p_proc_mark, p_log_mark)
        self.sql_delimiter = SQL_DELIMITER

        try:
            self.fd_sql = open ( self.sql_log_name, "a" )

        except IOError as ex:
            print (LOG_NOT_OPENED_0 + self.sql_log_name + LOG_NOT_OPENED_1)

            sys.exit (1)
            
    def write_sql_log ( self, p_list ):

        self.fd_sql.write (self.sql_delimiter)
        self.fd_sql.writelines (p_list)           

    def close_sql_log ( self ):

        self.fd_sql.write ( self.sql_delimiter )
        self.fd_sql.close()
    # 2022-02-27
        
class make_load ( fd_log_s ):
 """
    main class Nick 2010-03-31
        2014-06-16 Three parameters was added:
            - IP nost
            - DB-name
            - user name
 """
 def __init__ ( self, p_host_ip, p_port, p_db_name, p_user_name, p_prt_sw = True, p_proc_mark = EMP): 

    fd_log_s.__init__ ( self, p_host_ip, p_port, p_db_name, p_user_name, p_prt_sw, p_proc_mark)
    
    # ----------------------------------------------------------------------------
    # Common part
    #
    self.mlc01 = AddHouseType.MakeLoad() 
    self.mlc02 = AddrObjType.MakeLoad() 
    self.mlc03 = ApartmentType.MakeLoad() 
    self.mlc04 = HouseType.MakeLoad() 
    self.mlc05 = NormDocsKinds.MakeLoad() 
    self.mlc06 = NormDocsTypes.MakeLoad() 
    self.mlc07 = ObjectLevel.MakeLoad() 
    self.mlc08 = OperationType.MakeLoad()  
    self.mlc09 = ParamType.MakeLoad() 
    self.mlc10 = RoomsType.MakeLoad()    
    # -----------------------------------------------------------------
    #  Region part
    #
    self.mlr01 = AddrObj.MakeLoad()   
    self.mlr02 = AddrObjDivision.MakeLoad()   
    self.mlr03 = AddrObjParams.MakeLoad()   
    self.mlr04 = AdmHierarchy.MakeLoad()   
    self.mlr05 = Apartments.MakeLoad()   
    self.mlr06 = ApartmentsParams.MakeLoad()   
    self.mlr07 = Carplaces.MakeLoad()   
    self.mlr08 = CarplacesParams.MakeLoad()     
    self.mlr09 = ChangeHistory.MakeLoad()   
    self.mlr10 = Houses.MakeLoad()   
    self.mlr11 = HousesParams.MakeLoad()   
    self.mlr12 = MunHierarchy.MakeLoad()   
    self.mlr13 = NormativeDocs.MakeLoad()   
    self.mlr14 = ReestrObjects.MakeLoad()   
    self.mlr15 = Rooms.MakeLoad()   
    self.mlr16 = RoomsParams.MakeLoad()   
    self.mlr17 = Steads.MakeLoad()   
    self.mlr18 = SteadsParams.MakeLoad()

 def load_list_names (self, p_catalog_name):
    """
      Create list of XML-file names
    """
    sd = ScanDir.RbScanDir() 
    sd.scan (p_catalog_name.strip())
    #sd.dump()
        
    return sd.files # sorted (sd.files,reverse=True)

 def get_file_sign (self, p_file_name):
    """
      Get File Unique-sign
    """
    names_parts = p_file_name.split(PATH_DELIMITER)
    name_part = names_parts [len (names_parts) -1]
    xxx = name_part.split(bUL)
    s = ""
    for i in range (len(xxx) -2):
        s = s + xxx[i]
    return s

 def save_file_info (self, p_host_ip, p_port, p_db_name, p_user_name, p_file_name):
    """
      Save info about XML-file. Separated connection
    """
    # Try to define number of region
    NUMS = "0123456789"
    name_parts = p_file_name.split(PATH_DELIMITER)
    r_nmb = name_parts [len(name_parts)-2]
    
    if not ((r_nmb[0] in NUMS) & (r_nmb[1] in NUMS)):
         r_nmb = ''    
    
    rc = -1  
    self.l_s = "host = " + str ( p_host_ip ) + " port = " + str ( p_port ) +\
        " dbname = " + str ( p_db_name ) + " user = " + str ( p_user_name )

    try:
         conn = psycopg2.connect(self.l_s)
         cur = conn.cursor()
         cur.execute (CALL_PROC_F, (self.version, r_nmb, p_file_name))
    
         rc = cur.fetchone()[0]  
         
         conn.commit()
         cur.close()
         conn.close()

         return rc

    except psycopg2.OperationalError as e1:
         print ("... Connection aborted: ")
         print ("... " + str (e1))
         sys.exit ( rc )
         
    except psycopg2.NotNullViolation as e2:
         print ("... Connection aborted: ")
         print ("... " + str (e2))
         sys.exit ( rc )
         
 #
 # Nick 2010-04-05 --------------------------------------------------------------------------------------------------
 #                    1          2         3          4            5          6            7          8        9
 def to_do ( self, p_host_ip, p_port, p_db_name, p_user_name, p_batch_name, p_std_log, p_std_out,\
     p_std_err, p_std_sql, p_path, p_version, p_fserver_nmb = None, p_schemas = None,\
         p_id_region = None, p_first_message = None):

    self.version = p_version.strip()

    try:
        fd = open ( p_batch_name, "r" )
    except IOError as ex:
        print (SCRIPT_NOT_OPENED_0 + p_batch_name + SCRIPT_NOT_OPENED_1)
        return 1

    self.c_list = fd.readlines ()
    fd.close ()

    self.path = p_path.strip (PATH_DELIMITER)

    s_lp = str ( p_host_ip ) + SPACE_0 + str ( p_port ) + SPACE_0 + str ( p_db_name ) + SPACE_0 +\
        str ( p_user_name )
    s_lp = s_lp + SPACE_0 + str ( p_batch_name ) + SPACE_0 + str ( self.version )

    self.open_log ( p_std_log, self.path, s_lp )
    self.write_log_first ()
    if not (p_first_message == None):
        self.write_log (p_first_message)
        
    ## 2023-03-31  Появляются свойства self.proc_mark, self.log_mark     
    std_out = p_std_out.format (self.proc_mark, self.log_mark)    
    try:
        self.f_out = open (std_out, "a")   
    except IOError as ex:
        print (OUT_NOT_OPENED_0 + std_out + OUT_NOT_OPENED_1)
        sys.exit (1)         
    
    # 2022-02-27
    self.open_sql_log (p_std_sql, self.proc_mark, self.log_mark)

    rc = 0

    for ce_list in self.c_list:
      if not (ce_list [0] == bCOMMENT_SIGN):
        l_words = ce_list.split (bDELIMITER_SIGN)

        if len (l_words) >= 4:
            l_db_name = (l_words[2]).strip()
            if len (l_db_name) == 0:
                l_db_name = p_db_name
            
            #----------------------------------------------------------------------------
            if l_words [0] == MESSAGE:  # Message
                self.write_log (l_words [3])             

            #----------------------------------------------------------------------------
            if l_words [0] == DIRECT_SQL_COMMAND:  # Direct SQL-command
                
                self.write_log (l_words [3])  
                fr_0 = Fd0.fd_0 (0, p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err\
                    ,self.proc_mark, self.log_mark)

                fr_0.f_create ((l_words [1]).strip())  # Nick 2018-02-03
                rc = fr_0.f_run()

                if not (rc == 0):     #  Fatal error, break process
                   self.write_log_err ( rc, fr_0.l_arg )
                   break

            #------------------------------------------------------------------------------
            if l_words [0] == SEQUENCE_SQL_COMMANDS:  # Sequence of simple SQL-commands
                
                self.write_log (l_words [3])                     
                fr_1 = Fd0.fd_0 ( 1, p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err\
                    ,self.proc_mark, self.log_mark)
                
                fr_1.f_create (self.path + (l_words [1]).strip())
                rc = fr_1.f_run()

                if not (rc == 0):     #  Fatal error, break process
                   self.write_log_err ( rc, fr_1.l_arg )
                   break

            #------------------------------------------------------------------------------
            if l_words [0] == SEQUENCE_SQL_COMMANDS_WITH_LOG:  # Sequence of simple SQL-commands with LOG
                
                self.write_log (l_words [3])                     
                fr_5 = Fd0.fd_0 (1, p_host_ip, p_port, l_db_name, p_user_name, p_std_out, p_std_err\
                    ,self.proc_mark, self.log_mark)

                f_name = self.path + (l_words [1]).strip()
                fr_5.f_create (f_name)  # Nick 2018-02-03
                rc = fr_5.f_run()

                if not (rc == 0):     #  Fatal error, break process
                   self.write_log_err (rc, fr_5.l_arg)
                   break
               
                # Without any fatal errors
                try:
                    fs = open (f_name, "r" )
                
                except IOError as ex:
                    print (SCRIPT_NOT_OPENED_0 + f_name + SCRIPT_NOT_OPENED_1)
                    return 1
                
                s_data = fs.readlines()
                fs.close()
                
                self.write_sql_log (s_data)

            #----------------------------------------------------------------------------
            if l_words [0] == STAGE_3_YAML:  # Processing stage_3.yaml
                
                self.write_log (l_words [3])                     
 
                mm3 = Stage3.make_main (p_host_ip, p_port, l_db_name, p_user_name, \
                    (l_words [1]).strip(), p_path, p_std_out, p_std_err, self.prt_sw, self.proc_mark,\
                        self.log_mark, p_id_region, p_fserver_nmb, p_schemas, self.version) 
      
                mm3.set_file_log (self.fd)  # Уже открыт

                if mm3.stage_3_I_on: 
                    rc = mm3.stage_3_I ( mm3.mogrify_3_I )
                    if not (rc == 0):     #  Fatal error, break process
                        break
                    
                if mm3.stage_3_9_on: 
                    rc = mm3.stage_3_9 ( mm3.mogrify_3_9 )
                    if not (rc == 0):     #  Fatal error, break process
                        break
                    
                if mm3.stage_3_0_on: 
                    rc = mm3.stage_3_0 ( mm3.mogrify_3_0 )
                    if not (rc == 0):     #  Fatal error, break process
                        break
                 
                if mm3.stage_3_1_on: 
                    rc = mm3.stage_3_1 ( mm3.mogrify_3_1 )
                    if not (rc == 0):     #  Fatal error, break process
                        break
                
                if mm3.stage_3_2_on: 
                    rc = mm3.stage_3_2 ( mm3.mogrify_3_2 )
                    if not (rc == 0):     #  Fatal error, break process
                        break
                
                if mm3.stage_3_3_on: 
                    rc = mm3.stage_3_3 ( mm3.mogrify_3_3 )           
                    if not (rc == 0):     #  Fatal error, break process
                        break
           
            #----------------------------------------------------------------------------
            if l_words [0] == STAGE_4_YAML:  # Processing stage_4.yaml
                
                self.write_log (l_words [3])
 
                mm4 = Stage4.make_main (p_host_ip, p_port, l_db_name, p_user_name, \
                    (l_words [1]).strip(), p_path, p_std_out, p_std_err, self.prt_sw, self.proc_mark,\
                        self.log_mark) 
 
                mm4.set_file_log (self.fd)  # Уже открыт

                #------------------------------------------------------------
                if mm4.stage_4_1_on: 
                    rc = mm4.stage_4_1 ( mm4.mogrify_4_1 )
                    if not (rc == 0):     #  Fatal error, break process
                        break
                 
                if mm4.stage_4_2_on: 
                    rc = mm4.stage_4_2 ( mm4.mogrify_4_2 )
                    if not (rc == 0):     #  Fatal error, break process
                        break

                if mm4.stage_a_p_on: 
                    rc = mm4.stage_a_p ( mm4.mogrify_a_p )
                    if not (rc == 0):     #  Fatal error, break process
                        break
                
                if mm4.stage_4_3_on: 
                    rc = mm4.stage_4_3 ( mm4.mogrify_4_3 )
                    if not (rc == 0):     #  Fatal error, break process
                        break
                
                if mm4.stage_4_4_on: 
                    rc = mm4.stage_4_4 ( mm4.mogrify_4_4 )
                    if not (rc == 0):     #  Fatal error, break process
                        break

                if mm4.stage_s_p_on: 
                    rc = mm4.stage_s_p ( mm4.mogrify_s_p )
                    if not (rc == 0):     #  Fatal error, break process
                        break
                
                if mm4.stage_4_5_on: 
                    rc = mm4.stage_4_5 ( mm4.mogrify_4_5 )
                    if not (rc == 0):     #  Fatal error, break process
                        break
                 
                if mm4.stage_4_6_on: 
                    rc = mm4.stage_4_6 ( mm4.mogrify_4_6 )
                    if not (rc == 0):     #  Fatal error, break process
                        break

                if mm4.stage_h_p_on: 
                    rc = mm4.stage_h_p ( mm4.mogrify_h_p )
                    if not (rc == 0):     #  Fatal error, break process
                        break
 
            #----------------------------------------------------------------------------
            if l_words [0] == STAGE_6_YAML:  # Processing stage_6.yaml
                
                self.write_log (l_words [3])                        
 
                mm6 = Stage6.make_main (p_host_ip, p_port, l_db_name, p_user_name, \
                    p_path, (l_words [1]).strip(), self.version, p_std_out, p_std_err, \
                        self.prt_sw, self.proc_mark, self.log_mark, p_fserver_nmb, p_id_region) 
                
                mm6.set_file_log (self.fd)  # Уже открыт

                #------------------------------------------------------------
                if mm6.stage_6_0_on: 
                    rc = mm6.stage_6_0 ( mm6.mogrify_6_0 )
                    if not (rc == 0):     #  Fatal error, break process
                        break
                 
                if mm6.stage_6_1_on: 
                    rc = mm6.stage_6_1 ( mm6.mogrify_6_1 )
                    if not (rc == 0):     #  Fatal error, break process
                        break
                
                if mm6.stage_6_2_on: 
                    rc = mm6.stage_6_2 ( mm6.mogrify_6_2 )
                    if not (rc == 0):     #  Fatal error, break process
                        break
                
                if mm6.stage_6_3_on: 
                    rc = mm6.stage_6_3 ( mm6.mogrify_6_3 ) 
                    if not (rc == 0):     #  Fatal error, break process
                        break
         
                mm6.cur6.close()
                mm6.conn6.close()
            #----------------------------------------------------------------------------
            if l_words [0] == LOAD_XML:  # Parse and Load XML
                 list_names = self.load_list_names (l_words [1]) # 2021-11-28  

                 for file_name in list_names:
                     self.write_log (file_name)  
                     file_sign = self.get_file_sign (file_name)
                     #
                     #  Common Part 
                     #
                     if (file_sign == bAS_ADDHOUSE_TYPES):
                         self.f_out.write (self.mlc01.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)

                     elif (file_sign == bAS_ADDR_OBJ_TYPES):
                         self.f_out.write (self.mlc02.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                   
                     elif (file_sign == bAS_APARTMENT_TYPES):
                         self.f_out.write (self.mlc03.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     elif (file_sign == bAS_HOUSE_TYPES):
                         self.f_out.write (self.mlc04.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     elif (file_sign == bAS_NORMATIVE_DOCS_KINDS):
                         self.f_out.write (self.mlc05.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     elif (file_sign == bAS_NORMATIVE_DOCS_TYPES):
                         self.f_out.write (self.mlc06.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     elif (file_sign == bAS_OBJECT_LEVELS):
                         self.f_out.write (self.mlc07.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     elif (file_sign == bAS_OPERATION_TYPES):
                         self.f_out.write (self.mlc08.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     elif (file_sign == bAS_PARAM_TYPES):
                         self.f_out.write (self.mlc09.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     elif (file_sign == bAS_ROOM_TYPES):
                         self.f_out.write (self.mlc10.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                     #
                     # Region part
                     #
                     elif (file_sign == bAS_ADDR_OBJ):
                         self.f_out.write (self.mlr01.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL) 
                         
                     elif (file_sign == bAS_ADDR_OBJ_DIVISION):
                         self.f_out.write (self.mlr02.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)                           
                         
                     elif (file_sign == bAS_ADDR_OBJ_PARAMS):
                         self.f_out.write (self.mlr03.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)  
                         
                     elif (file_sign == bAS_ADM_HIERARCHY):
                         self.f_out.write (self.mlr04.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     elif (file_sign == bAS_APARTMENTS):
                         self.f_out.write (self.mlr05.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     elif (file_sign == bAS_APARTMENTS_PARAMS):
                         self.f_out.write (self.mlr06.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     elif (file_sign == bAS_CARPLACES):
                         self.f_out.write (self.mlr07.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL) 
                         
                     elif (file_sign == bAS_CARPLACES_PARAMS):
                         self.f_out.write (self.mlr08.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL) 
                         
                     elif (file_sign == bAS_CHANGE_HISTORY):
                         self.f_out.write (self.mlr09.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)    
                         
                     elif (file_sign == bAS_HOUSES):
                         self.f_out.write (self.mlr10.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     elif (file_sign == bAS_HOUSES_PARAMS):
                         self.f_out.write (self.mlr11.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     elif (file_sign == bAS_MUN_HIERARCHY):
                         self.f_out.write (self.mlr12.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     elif (file_sign == bAS_NORMATIVE_DOCS):
                         self.f_out.write (self.mlr13.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)  
                        
                     elif (file_sign == bAS_REESTR_OBJECTS):
                         self.f_out.write (self.mlr14.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)   
                        
                     elif (file_sign == bAS_ROOMS):
                         self.f_out.write (self.mlr15.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)  
                         
                     elif (file_sign == bAS_ROOMS_PARAMS):
                         self.f_out.write (self.mlr16.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)  
                         
                     elif (file_sign == bAS_STEADS):
                         self.f_out.write (self.mlr17.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL) 
                         
                     else:  #  bAS_STEADS_PARAMS  
                         self.f_out.write (self.mlr18.ToDo (p_host_ip, p_port, l_db_name, p_user_name, file_name) + bNL)
                         
                     rc1 = self.save_file_info (p_host_ip, p_port, l_db_name, p_user_name, file_name)

    self.close_log()
    self.close_sql_log()  # 2022-02-27
    self.f_out.close()
    
    return rc

# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
             Load data into database.
             The simplest version, it uses PSQL
        """
#                  1       2        3          4            5             6        7             
        sa = " <Host_IP> <Port> <DB_name> <User_name> <Batch_file_name> <Path> <Version>"
        if ( len( sys.argv ) - 1 ) < 7:
            print (VERSION_STR) 
            print ("  Usage: " + str ( sys.argv [0] ) + sa)
            sys.exit( 1 )
#
# Nick 2010-04-05 -----------------------------------------------------------------------------------------------------
#
        ml = make_load ( sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4] )
        rc = ml.to_do  ( sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4],\
                                   sys.argv[5], bLOG_NAME, bOUT_NAME, bERR_NAME, bSQL_NAME,\
                                       sys.argv[6], sys.argv[7] )
        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt as e:
        print ("... Terminated by user: ")
        sys.exit (1)
