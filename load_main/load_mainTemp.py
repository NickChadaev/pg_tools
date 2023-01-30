#!/usr/bin/python
# coding=utf-8
# PROJ: DataBase, service function.
# FILE: load_mainTemp.py
# AUTH: Nick (nick-ch58@yandex.ru))
# DESC: Create script template.
# HIST: 2010-03-17 - created.

import sys, string

class ScriptTemplate:

    def __init__ (self):

        self.list_temp = []
        self.list_temp.append ( "#-------------------------------------------------------------------------------")
        self.list_temp.append ( "# 2009-04-21/2022-03-28 Nick (nick-ch58@yandex.ru).")
        self.list_temp.append ( "#-------------------------------------------------------------------------------")
        self.list_temp.append ( "# The structure of batch-file. It consists:")
        self.list_temp.append ( "#    0 - Action ")
        self.list_temp.append ( "#    1 - Command/File name/Path")
        self.list_temp.append ( "#    2 - DB name (optional)")
        self.list_temp.append ( "#    3 - The text of message")
        self.list_temp.append ( "#    The DB-name may be ommited. But if it is present, the it ")
        self.list_temp.append ( "#    cancels the name specified in the parameter list.")
        self.list_temp.append ( "#-------------------------------------------------------------------------------")
        self.list_temp.append ( "# Type action is: 0 - Direct performing SQL-command")
        self.list_temp.append ( "#                 1 - Perform SQL-commands from SQL-file")
        self.list_temp.append ( "#                 2 - Parsing XML, GAR-FIAS")
        self.list_temp.append ( "#                 3 - Perform PreProcess stage")
        self.list_temp.append ( "#                 4 - Perform Process stage")
        self.list_temp.append ( "#                 5 - Build package from SQL-file")
        self.list_temp.append ( "#                 6 - Perform PostProcess stage")
        self.list_temp.append ( "#                 X - Message for user (The fields ##1,2 - are empty )")
        self.list_temp.append ( "#-------------------------------------------------------------------------------")
        self.list_temp.append ( "# For example: ")
        self.list_temp.append ( "#       X;;;Start process; ")        
        self.list_temp.append ( "#       0;DROP DATABASE IF EXISTS db_k2;;Remove old DB; ")
        self.list_temp.append ( "#       1;1_crt_domain.sql;db_k2;Creating domains; ")
        self.list_temp.append ( "#       X;;;Parsing XML; ")
        self.list_temp.append ( "#       2;/media/rootadmin/Transcend/FIAS_GAR_2022_12_26;; -- Parsing XML-files;")
        self.list_temp.append ( "#       3;stage_31r.yaml;; -- stage_31r (PreProcessing);")
        self.list_temp.append ( "#       5;version.sql;;-- Версия 0b2d846/2022-12-29;")
        self.list_temp.append ( "#       5;FUNCTION/f_adr_area_show_data.sql;;-- f_adr_area_show_data.sql;")
        self.list_temp.append ( "#-------------------------------------------------------------------------------")
        self.list_temp.append ( "X;;;Start process;")
        self.list_temp.append ( "#")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "#")        
        self.list_temp.append ( "X;;;Stop process;")
        self.list_temp.append ( "#-------------------------------------------------------------------------------")

    def get_list ( self ):

        return self.list_temp

if __name__ == '__main__':
    
    for l in ScriptTemplate().get_list():
           print l
           
