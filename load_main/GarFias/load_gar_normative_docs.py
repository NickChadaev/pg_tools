#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_gar_normative_docs.py
# AUTH: Nick Chadaev (nick-ch58@yandex.ru)
# DESC: Parse XML and Load data into database
# HIST: 2021-11-19 - created
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

CALL_PROC = """CALL gar_fias_pcg_load.save_gar_normative_docs (
                    i_id          := (NULLIF (%s, ''))::bigint       
                   ,i_doc_name    := (NULLIF (%s, ''))::varchar(1500)
                   ,i_doc_date    := (NULLIF (%s, ''))::date         
                   ,i_doc_number  := (NULLIF (%s, ''))::varchar(150) 
                   ,i_doc_type    := (NULLIF (%s, ''))::bigint       
                   ,i_doc_kind    := (NULLIF (%s, ''))::bigint       
                   ,i_update_date := (NULLIF (%s, ''))::date         
                   ,i_org_name    := (NULLIF (%s, ''))::varchar(255) 
                   ,i_acc_date    := (NULLIF (%s, ''))::date 
                   ,i_reg_num     := (NULLIF (%s, ''))::varchar(100)
                   ,i_reg_date    := (NULLIF (%s, ''))::date
);
"""
# 2022-05-25
BSIZE = 500
MESS_ABOUT = "gar_fias.as_normative_docs: "

# ------------------------------------------------------------------------------

class NormativeDocsHandler (xml.sax.ContentHandler):
   """
     The specific part of SAX-parser 
   """
   def __init__(self, p_conn, p_cur, p_qty):
       
      self.conn_x = p_conn
      self.cur_x  = p_cur
      self.qty    = p_qty

      self.CurrentData = ""
      
      self.id          = ''
      self.doc_name    = ''
      self.doc_date    = ''
      self.doc_number  = ''
      self.doc_type    = ''
      self.doc_kind    = ''
      self.update_date = ''
      self.org_name    = ''
      self.acc_date    = ''    
      self.reg_num     = ''
      self.reg_date    = ''
      
   # -- 1
   def startElement(self, tag, attributes):
      self.CurrentData = tag

      if tag == "NORMDOC":
         #
         self.id          = attributes.get("ID",'')
         self.doc_name    = attributes.get("NAME",'')
         self.doc_date    = attributes.get("DATE",'')
         self.doc_number  = attributes.get("NUMBER",'')
         self.doc_type    = attributes.get("TYPE",'')
         self.doc_kind    = attributes.get("KIND",'')
         self.update_date = attributes.get("UPDATEDATE",'')
         self.org_name    = attributes.get("ORGNAME",'')
         self.acc_date    = attributes.get("ACCDATE",'')
         self.reg_num     = attributes.get("REGNUM",'')
         self.reg_date    = attributes.get("REGDATE",'')  
         #
         try:
              self.cur_x.execute (CALL_PROC, (self.id, self.doc_name, self.doc_date,\
                  self.doc_number, self.doc_type, self.doc_kind, self.update_date,\
                      self.org_name, self.acc_date, self.reg_num, self.reg_date))

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
    Handler = NormativeDocsHandler (self.conn_x, self.cur_x, 0)
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

