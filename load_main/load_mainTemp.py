#!/usr/bin/python
# coding=utf-8
# PROJ: DataBase, service function.
# FILE: ScriptTemplate.py
# AUTH: Nick (nick_ch58@list.ru)
# DESC: Create script template.
# HIST: 2010-03-17 - created.
#       2020-05-10 - Translated from Russian to English

import sys, string

class ScriptTemplate:

    def __init__ (self):

        self.list_temp = []
        self.list_temp.append ( "#-------------------------------------------------------------------------------")
        self.list_temp.append ( "# 2009-04-21/2020-05-10 Nick (nick-ch58@yandex.ru).")
        self.list_temp.append ( "#-------------------------------------------------------------------------------")
        self.list_temp.append ( "# The structure of bathc-file. It consists:")
        self.list_temp.append ( "#    0 - Type action ")
        self.list_temp.append ( "#    1 - SQL-command/The SQL-file name/The <1*.conf> file name")
        self.list_temp.append ( "#    2 - DB name ")
        self.list_temp.append ( "#    3 - The text of message")
        self.list_temp.append ( "#    The DB-name may be ommited. But if it is present, the it ")
        self.list_temp.append ( "#    cancels the name specified in the parameter list.")
        self.list_temp.append ( "#-------------------------------------------------------------------------------")
        self.list_temp.append ( "# Type action is: 0 - Direct performing SQL-command")
        self.list_temp.append ( "#                 1 - Perform SQL-command from SQL-file")
        self.list_temp.append ( "#                 2 - Direct loading into DB")
        self.list_temp.append ( "#                 3 - Deferred loading into DB")
        self.list_temp.append ( "#                 4 - Direct unloading from DB")
        self.list_temp.append ( "#                 5 - Defrred unloading from DB")
        self.list_temp.append ( "#                 X - Message for user (The fields ##1,2 - are empty )")
        self.list_temp.append ( "#-------------------------------------------------------------------------------")
        self.list_temp.append ( "# For example: ")
        self.list_temp.append ( "#       0;DROP DATABASE IF EXISTS db_k2;;Remove old DB; ")
        self.list_temp.append ( "#       1;1_crt_domain.sql;db_k2;Creating domains; ")
        self.list_temp.append ( "#       X;;;Schema COM; ")
        self.list_temp.append ( "#       1;0_COM/2_com_crt_tables.sql;;-- Creating the base tables; ")
        self.list_temp.append ( "#       1;0_COM/4_com_crt_errors.sql;;-- Creating the tables for errors;")
        self.list_temp.append ( "#-------------------------------------------------------------------------------")
        self.list_temp.append ( "X;;;Start process;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "X;;;Stop process;")
        self.list_temp.append ( "#-------------------------------------------------------------------------------")

    def get_list ( self ):

        return self.list_temp

if __name__ == '__main__':
    
    for l in ScriptTemplate().get_list():
           print l
           
