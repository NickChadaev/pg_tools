#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainCrtScripts.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities
# -----------------------------------------------------------------------------------------

import sys
import os
import string
import datetime
import psycopg2    

VERSION_STR_0 = "  Version 0.4.4 Build 2023-11-13"
VERSION_STR_1 = "  ------------------------------"

#            1            2           3           4          5         6          7 
SA = " <CSV_pattern> <Target_Dir> <Host_Path> <Git_Path> <XML-dir> <XML-path> <ZIP-name> \
 <Version> <Del-Sw(optional)>"
#    8          9               

USE_CASE = "  USE CASE: "
US ="""  load_mainCrtScripts.py pattern_may_0.csv ~/Y_BUILD ../Y_BUILD ../A_FIAS_LOADER ../7_DATA
            FIAS_GAR_2022_12_26 gar_xml_2022_09_30.zip 2022-03-10 <True>
  Где:
          pattern_may_0.csv    -- Шаблон
          ~/Y_BUILD            -- Каталог цель   
          ../Y_BUILD           -- Путь в целевом каталоге       
          ../A_FIAS_LOADER     -- GIT каталог                   
          ../7_DATA            -- каталог с XML-данными. 
          FIAS_GAR_2022_12_26  -- Путь в каталоге с XML-данными  
          gar_xml_12_26.zip    -- Имя архива
          2022-12-26           -- Версия
          True                 -- Опция"""   

FILE_NOT_OPENED_0 = "... File not opened: '"
FILE_NOT_OPENED_1 = "'."

POINTS = " ... "

bCOMMENT_SIGN = "#"
bDELIMITER_SIGN = ";"

SPACE_0 = " "
# -----------------------------------

PATH_DELIMITER = '/'  # Nick 2020-05-11

class m_catalog ():
    """
    Имя рабочего каталога
    """
    def __init__ (self, p_path):
        
        self.catalog_name_p = p_path + "{0:02d}"    
        
    def b_catalog (self, p_fias_id):
        
        self.catalog_name = self.catalog_name_p.format (int (p_fias_id))
        
class m_stage_0 ():
    """
      Начальный stage, создаётся БД.
    """

    def __init__ (self, p_path):
        
        self.file_name_p = p_path + "{0:02d}/stage_0_{0:02d}.csv"
        
        self.db_name_p    = "unsi_test_{0:02d}"
        self.stage_body_p = """#------------------------------------------------------------------------
X;;;Start process;
0;DROP DATABASE IF EXISTS unsi_test_{0:02d};; -- Remove old DB;
1;{1}/{0:02d}/createDb_{0:02d}.sql;; -- DB creating;
1;{2}/createSchemas.sql;unsi_test_{0:02d}; -- Schemas creating;
1;{2}/CreateExtensions.sql;unsi_test_{0:02d}; -- Extension creating;
X;;;Stop process;
"""
    def b_stage_0 (self, p_fias_id, p_path, p_git_path):
        
        self.file_name_st0 = self.file_name_p.format (int (p_fias_id))
        self.db_name_0 = self.db_name_p.format (int (p_fias_id))
        self.stage_body_0 = self.stage_body_p.format (int (p_fias_id), p_path, p_git_path)
          
class m_db_script_0 ():
    """
     Скрипт, создающий БД
    """
    def __init__ (self, p_path): 
     
        self.file_name_p = p_path + "{0:02d}/createDb_{0:02d}.sql"
        self.file_name_c = p_path + "{0:02d}/commentDb_{0:02d}.sql"
        
        self.scipt_body_p = """/*==============================================================*/
/* DBMS name:      PostgreSQL 13.9                              */
/*==============================================================*/

CREATE DATABASE {0}
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE {0}
    IS '{1}. {2}';"""

        self.scipt_body_c = """COMMENT ON DATABASE {0}
    IS '{1}. {2}';"""

           
    def b_db_script_0 (self, p_fias_id, p_db_name, p_nm_area_full, p_version_date):
        
        self.file_name_sc = self.file_name_p.format (int (p_fias_id))
        self.script_body_0 = self.scipt_body_p.format (p_db_name, p_nm_area_full, p_version_date)
           
    def b_db_script_1 (self, p_fias_id, p_db_name, p_nm_area_full, p_version_date):
        
        self.file_name_cc = self.file_name_c.format (int (p_fias_id))
        self.script_body_1 = self.scipt_body_c.format (p_db_name, p_nm_area_full, p_version_date)

class m_stage_parse ():
    """
     Сценарий, управляющий parsing XML-файлов 2023-11-13  Удаление Индексов.
    """
    def __init__ (self, p_path):

        self.file_name_p  = p_path + "{0:02d}/stage_gar_c_{0:02d}.csv"  
        
        self.stage_body_p = """X;;;Start process;
0;SELECT gar_version_pcg_support.save_gar_version (i_nm_garfias_version := '{1}'::date,i_kd_download_type := FALSE ::boolean,i_dt_download := now()::timestamp without time zone,i_arc_path := '{2}{3}'::text);; -- Version;
0;CALL gar_fias_pcg_load.del_gar_all();; -- Очистка от данных;
0;CALL gar_tmp_pcg_trans.p_gar_fias_crt_idx(FALSE);; -- Убираем индексы;
0;CALL gar_fias_pcg_load.p_alt_tbl (FALSE);; -- Set UNLOGGED;
#
2;{4}{5};; -- Common XML-file;
2;{4}{5}/{0:02d};; -- Region XML-file;  # {6}
#
0;SELECT gar_version_pcg_support.set_gar_dt_create ('{1}'::date, now()::timestamp without time zone);; -- Data finish;
0;CALL gar_fias_pcg_load.p_alt_tbl (TRUE);; -- Set LOGGED;  # in 4 min 30 secs.
#
X;;;Stop process;"""
           
    def b_stage_parse (self, p_fias_id, p_version_date, p_path_1, p_zip_name, p_path_2, p_path_3, p_nm_area_full):
        
        self.file_name_parse = self.file_name_p.format (int (p_fias_id))
        self.stage_body_parse = self.stage_body_p.format (int (p_fias_id), p_version_date,\
            p_path_1, p_zip_name, p_path_2, p_path_3, p_nm_area_full)
        
 #     rc = ( os.system ( self.l_arg ) )

class make_main ():    # m_db_script_0, m_db_script_0, m_stage_parse
 """
   This is main. DONT forget please
           rc = mm.to_do ( sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5],\
            sys.argv[6], sys.argv[7], sys.argv[8], del_sign)
    ----------------------------------------------------------------------------------------
                1            2           3           4          5         6          7 
    SA = " <CSV_pattern> <Target_Dir> <Host_Path> <Git_Path> <XML-dir> <XML-path> <ZIP-name> \
     <Version> <Del-Sw(optional)
        8            9               
    -----------------------------------------------------------------------------------------    
 """
 #
 def to_do ( self, p_csv_pattern, p_target_dir, p_host_path, p_git_path, p_xml_dir, p_xml_path,\
     p_zip_name, p_version, p_del_sign = False):

    target_dir = string.strip (p_target_dir) + PATH_DELIMITER
    xml_dir = string.strip (p_xml_dir)       + PATH_DELIMITER
    
    host_path = string.strip (p_host_path)
    git_path  = string.strip (p_git_path)
    xml_path  = string.strip (p_xml_path)
    
    mc  = m_catalog (target_dir)      # Рабочий каталог 
    ms0 = m_stage_0 (target_dir)      # Начальный stage, создание БД 
    mdb = m_db_script_0 (target_dir)  # Собственно скрипт создающий БД.
    msp = m_stage_parse (target_dir)  # Stage parsing

    try:
        fd = open ( p_csv_pattern, "r" )

    except IOError, ex:
        print FILE_NOT_OPENED_0 + p_csv_pattern + FILE_NOT_OPENED_1
        return 1

    c_list = fd.readlines ()
    fd.close ()

    rc = 0
    
    for ce_list in c_list:
      if ce_list [0] <> bCOMMENT_SIGN:
        l_words = string.split ( ce_list, bDELIMITER_SIGN )

        if len (l_words) >= 5:
            fias_id      = string.strip (l_words [0])
            id_area      = string.strip (l_words [1])
            nm_area_full = string.strip (l_words [4])
            #
            #   1) Создать каталог <fias_id>
            #
            mc.b_catalog (fias_id)
            
            if p_del_sign:
                rc = ( os.system ("rm -d -R -f " + mc.catalog_name ))
                
            rc = ( os.system ("mkdir " + mc.catalog_name ))
            print ( mc.catalog_name + " " + nm_area_full )  
            #
            #   2) Создать stage_0
            #            
            ms0.b_stage_0 (fias_id, host_path, git_path)
            try:
                fs0 = open ( ms0.file_name_st0, "w" )
            
            except IOError, ex:
                print FILE_NOT_OPENED_0 + ms0.file_name_st0 + FILE_NOT_OPENED_1
                return 1
            
            fs0.write (ms0.stage_body_0)
            fs0.close ()             
            #
            #   3) Создать db_scipt_0
            #
            mdb.b_db_script_0 (fias_id, ms0.db_name_0, nm_area_full, p_version)
            try:
                fdb = open ( mdb.file_name_sc, "w" )
            
            except IOError, ex:
                print FILE_NOT_OPENED_0 + mdb.file_name_sc + FILE_NOT_OPENED_1
                return 1
            
            fdb.write (mdb.script_body_0)
            fdb.close ()
            #
            #   3.0) Создать db_comment_0
            #
            mdb.b_db_script_1 (fias_id, ms0.db_name_0, nm_area_full, p_version)
            try:
                fdb = open ( mdb.file_name_cc, "w" )
            
            except IOError, ex:
                print FILE_NOT_OPENED_0 + mdb.file_name_cc + FILE_NOT_OPENED_1
                return 1
            
            fdb.write (mdb.script_body_1)
            fdb.close ()            
            #
            #   4) Создать parse script
            #
            msp.b_stage_parse (fias_id, p_version, xml_dir, p_zip_name, xml_dir, xml_path, nm_area_full)
            try:
                fsp = open ( msp.file_name_parse, "w" )
            
            except IOError, ex:
                print FILE_NOT_OPENED_0 + msp.file_name_parse + FILE_NOT_OPENED_1
                return 1
            
            fsp.write (msp.stage_body_parse)
            fsp.close ()              
            
    return rc

# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
        """
        if ( len( sys.argv ) - 1 ) < 8:
            print VERSION_STR_0
            print VERSION_STR_1 
            print "  Usage: " + str ( sys.argv [0] ) + SA            
            #
            print USE_CASE
            print US
            sys.exit( 1 )
#
        del_sign = False

        if ( len( sys.argv ) - 1 ) == 9:
            if sys.argv[9] == 'True':
                del_sign = True
            else:
                del_sign = False

        mm = make_main ()
        rc = mm.to_do ( sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5],\
            sys.argv[6], sys.argv[7], sys.argv[8], del_sign)
        
        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)
  
