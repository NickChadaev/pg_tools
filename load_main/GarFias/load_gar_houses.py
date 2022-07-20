#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_gar_houses.py
# AUTH: Nick Chadaev (nick-ch58@yandex.ru)
# DESC: Parse XML and Load data into database
# HIST: 2021-11-22 - created
#       2022-05-25 - remove AUTOCOMMIT, "count (1) FROM  xxxx"

import sys
import os

import psycopg2  
from psycopg2 import Error

import xml.sax

VERSION_STR = "  Version 0.1.2 Build 2022-05-25"

XML_NOT_OPENED_0 = "... XML-file not opened: '"
XML_NOT_OPENED_1 = "'."

# ------------------------------------------------------------------------------
#  The specific constatnt

CALL_PROC = """CALL gar_fias_pcg_load.save_gar_houses (
                            i_id           := (NULLIF (%s, ''))::bigint       
                           ,i_object_id    := (NULLIF (%s, ''))::bigint      
                           ,i_object_guid  := (NULLIF (%s, ''))::uuid        
                           ,i_change_id    := (NULLIF (%s, ''))::bigint 
                           ,i_house_num    := (NULLIF (%s, ''))::varchar(50)
                           ,i_add_num1     := (NULLIF (%s, ''))::varchar(50) 
                           ,i_add_num2     := (NULLIF (%s, ''))::varchar(50) 
                           ,i_house_type   := (NULLIF (%s, ''))::bigint    
                           ,i_add_type1    := (NULLIF (%s, ''))::bigint     
                           ,i_add_type2    := (NULLIF (%s, ''))::bigint     
                           ,i_oper_type_id := (NULLIF (%s, ''))::bigint   
                           ,i_prev_id      := (NULLIF (%s, ''))::bigint      
                           ,i_next_id      := (NULLIF (%s, ''))::bigint    
                           ,i_update_date  := (NULLIF (%s, ''))::date        
                           ,i_start_date   := (NULLIF (%s, ''))::date        
                           ,i_end_date     := (NULLIF (%s, ''))::date        
                           ,i_is_actual    := (NULLIF (%s, ''))::boolean     
                           ,i_is_active    := (NULLIF (%s, ''))::boolean     
);
"""
# 2022-05-25
BSIZE = 500
MESS_ABOUT = "gar_fias.as_houses: "
# ------------------------------------------------------------------------------

class HousesHandler (xml.sax.ContentHandler):
   """
     The specific part of SAX-parser 
   """
   def __init__(self, p_conn, p_cur, p_qty):
       
      self.conn_x = p_conn
      self.cur_x  = p_cur
      self.qty    = p_qty

      self.CurrentData = ""

      self.id           = ''
      self.object_id    = ''
      self.object_guid  = ''
      self.change_id    = ''
      #
      self.house_num    = ''
      self.add_num1     = ''
      self.add_num2     = ''
      self.house_type   = ''
      self.add_type1    = ''
      self.add_type2    = ''
      self.oper_type_id = ''
      #
      self.prev_id      = ''
      self.next_id      = ''
      self.update_date  = ''
      self.start_date   = ''
      self.end_date     = ''
      self.is_actual    = ''
      self.is_active    = ''

   # -- 1
   def startElement(self, tag, attributes):
      self.CurrentData = tag

      if tag == "HOUSE":
         #
         self.id           = attributes.get("ID",'')  
         self.object_id    = attributes.get("OBJECTID",'')   
         self.object_guid  = attributes.get("OBJECTGUID",'')   
         self.change_id    = attributes.get("CHANGEID",'')  
         #
         self.house_num    = attributes.get("HOUSENUM",'')     
         self.add_num1     = attributes.get("ADDNUM1",'')   
         self.add_num2     = attributes.get("ADDNUM2",'')   
         self.house_type   = attributes.get("HOUSETYPE",'')
         self.add_type1    = attributes.get("ADDTYPE1",'')                                                          
         self.add_type2    = attributes.get("ADDTYPE2",'')                          
         self.oper_type_id = attributes.get("OPERTYPEID",'')
         #
         self.prev_id      = attributes.get("PREVID",'')  
         self.next_id      = attributes.get("NEXTID",'')  
         self.update_date  = attributes.get("UPDATEDATE",'')   
         self.start_date   = attributes.get("STARTDATE",'')    
         self.end_date     = attributes.get("ENDDATE",'')  
         self.is_actual    = attributes.get("ISACTUAL",'')  
         self.is_active    = attributes.get("ISACTIVE",'')  
         #
         try:
              self.cur_x.execute (CALL_PROC, (self.id, self.object_id, self.object_guid,\
                  self.change_id, self.house_num, self.add_num1, self.add_num2, self.house_type,\
                      self.add_type1, self.add_type2, self.oper_type_id, self.prev_id, \
                          self.next_id, self.update_date, self.start_date, self.end_date,\
                              self.is_actual, self.is_active))

         except psycopg2.errors.SyntaxError, e1:
              print "... Operation aborted: "
              print "... " + str (e1)
              self.conn_x.rollback();
              self.conn_x.close();
              
              sys.exit ( -1 )

         except psycopg2.errors.UndefinedFunction, e2:
              print "... Operation aborted: "
              print "... " + str (e2)
              self.conn_x.rollback();
              self.conn_x.close();
              
              sys.exit ( -1 )

         except psycopg2.errors.ForeignKeyViolation, e3:
              print "... Operation aborted: "
              print "... " + str (e3)
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
     
    except psycopg2.OperationalError, e:
         print "... Connection aborted: "
         print "... " + str (e)
         sys.exit ( rc )
    # 
    parser = xml.sax.make_parser()
    parser.setFeature (xml.sax.handler.feature_namespaces, 0)

    # -- Handler
    Handler = HousesHandler (self.conn_x, self.cur_x, 0)
    parser.setContentHandler ( Handler )
    
    try:
        parser.parse (p_gar_file_path)

    except IOError, ex:
        print XML_NOT_OPENED_0 + p_gar_file_path + XML_NOT_OPENED_1
        print "... " + str (ex)
        sys.exit (-1)        
    
    self.conn_x.commit()
    print MESS_ABOUT + str(Handler.qty)
    
    self.conn_x.close()
        
    return Handler.qty

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
            print VERSION_STR 
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )

        ml = MakeLoad ()
        rc = ml.ToDo (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])

        sys.exit ( rc )

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)

