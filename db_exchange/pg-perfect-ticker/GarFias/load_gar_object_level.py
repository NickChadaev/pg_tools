#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_gar_object_level.py
# AUTH: Nick Chadaev (nick-ch58@yandex.ru)
# DESC: Parse XML and Load data into database
# HIST: 2021-11-22 - created
#       2022-05-25 - remove AUTOCOMMIT, "count (1) FROM  xxxx"
#       2023-03-17 - version for python3

import sys
import os

import psycopg2  
from psycopg2 import Error

import xml.sax

VERSION_STR = "  Version 1.0.0 Build 2023-03-17"

XML_NOT_OPENED_0 = "... XML-file not opened: '"
XML_NOT_OPENED_1 = "'."

OPR_ABORTED = "... Operation aborted: "
CON_ABORTED = "... Connection aborted: "
POINTS = "... "

# ------------------------------------------------------------------------------
#  The specific constatnt

CALL_PROC = """CALL gar_fias_pcg_load.save_gar_object_level (
                    i_level_id    := (NULLIF (%s, ''))::bigint     
                   ,i_level_name  := (NULLIF (%s, ''))::varchar(100)  
                   ,i_short_name  := (NULLIF (%s, ''))::varchar(50)      
                   ,i_update_date := (NULLIF (%s, ''))::date       
                   ,i_start_date  := (NULLIF (%s, ''))::date       
                   ,i_end_date    := (NULLIF (%s, ''))::date       
                   ,i_is_active   := (NULLIF (%s, ''))::boolean    
);
"""
# 2022-05-25
BSIZE = 500
MESS_ABOUT = "gar_fias.as_object_level: "

# --------------------------------------------------------------------------

class ObjectLevelHandler (xml.sax.ContentHandler):
   """
     The specific part of SAX-parser 
   """
   
   def __init__(self, p_conn, p_cur, p_qty):
       
      self.conn_x = p_conn
      self.cur_x  = p_cur
      self.qty    = p_qty

      self.CurrentData = ""
      
      self.level_id      = ''
      self.level_name    = ''
      self.short_name    = ''
      self.update_date   = ''
      self.start_date    = ''     
      self.end_date      = ''
      self.is_active     = ''

   # -- 1
   def startElement(self, tag, attributes):
      self.CurrentData = tag
      
      if tag == "OBJECTLEVEL":
         #
         self.level_id    = attributes.get("LEVEL",'')
         self.level_name  = attributes.get("NAME",'')         
         self.short_name  = attributes.get("SHORTNAME",'')
         self.update_date = attributes.get("UPDATEDATE",'')
         self.start_date  = attributes.get("STARTDATE",'')
         self.end_date    = attributes.get("ENDDATE",'')
         self.is_active   = attributes.get("ISACTIVE",'')

         try:
              self.cur_x.execute (CALL_PROC, (self.level_id, self.level_name, self.short_name,\
                  self.update_date, self.start_date, self.end_date, self.is_active))
              
         except psycopg2.errors.SyntaxError as e1:
              print (OPR_ABORTED)
              print (POINTS + str (e1))
              
              self.conn_x.rollback();
              self.conn_x.close();
              
              sys.exit ( -1 )

         except psycopg2.errors.UndefinedFunction as e2:
              print (OPR_ABORTED)
              print (POINTS + str (e2))
              
              self.conn_x.rollback();
              self.conn_x.close();
              
              sys.exit ( -1 )

         except psycopg2.errors.ForeignKeyViolation as e3:
              print (OPR_ABORTED)
              print (POINTS + str (e3))
              
              self.conn_x.rollback();
              # self.conn_x.close(); 
              
              sys.exit ( -1 )               
         # 
         # 2022-05-25
         self.qty = self.qty + 1
         if (self.qty % BSIZE) == 0:
             self.conn_x.commit() 
         
   # -- 2
   def endElement(self, tag):
      self.CurrentData = ""

class MakeLoad ():
 """
    Try to connect DB
 """
 def ToDo ( self, p_host_ip, p_port, p_db_name, p_user_name, p_gar_file_path):

    #------------------------------
    rc = -1
    self.l_s = "host = " + str ( p_host_ip ) + " port = " + str ( p_port ) + \
        " dbname = " + str ( p_db_name ) + " user = " + str ( p_user_name )

    try:
         self.conn_x = psycopg2.connect (self.l_s)
         self.cur_x = self.conn_x.cursor()
     
    except psycopg2.OperationalError as e:
         print (CON_ABORTED)
         print (POINTS + str (e))
         
         sys.exit ( rc )
    #  
    parser = xml.sax.make_parser()
    parser.setFeature (xml.sax.handler.feature_namespaces, 0)

    # -- Handler
    Handler = ObjectLevelHandler (self.conn_x, self.cur_x, 0)
    parser.setContentHandler( Handler )
    
    try:
        parser.parse (p_gar_file_path)

    except ValueError as ex: # IOError
        print (XML_NOT_OPENED_0 + p_gar_file_path + XML_NOT_OPENED_1)
        print (POINTS + str (ex))
        
        sys.exit (-1)        
    
    self.conn_x.commit()
    ## print MESS_ABOUT + str(Handler.qty)
    
    self.conn_x.close()
    
    return (MESS_ABOUT + str(Handler.qty))

# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint of the class
             Parse XML and load it's data into database.
        """
#                  1       2        3          4            5        
        sa = " <Host_IP> <Port> <DB_name> <User_name> <GAR_file_name>"
        if not (( len( sys.argv ) - 1 ) == 5):
            print (VERSION_STR)
            print ("  Usage: " + str ( sys.argv [0] ) + sa)
            
            sys.exit( 1 )
#
        rc = 0
        ml = MakeLoad ()
        print (ml.ToDo (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]))
        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt as e:
        print ("... Terminated by user: ")
        sys.exit (1)
