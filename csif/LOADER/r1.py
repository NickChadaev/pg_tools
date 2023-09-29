#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: r1.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: ---------------------------------
# HIST: 2023-06-20 - created
# NOTS: 
# -------------------------------------------------------------------------------------------

import psycopg2 
import load_mainS_tr as tr
import r1_yaml as rym
import string
import sys
import codecs

VERSION_STR = "  Version 0.0.0 Build 2023-06-20"

PATH_DELIMITER = '/' 
bDL  = "|"

bLBR = "("
bRBR = ")"
bCM  = ","
EMP = ""
bU  = "_"

bDONT_OPEN = "Don't open: "
META_DATA = """SELECT 
    
     descr_metadata -- text    NOT NULL 
    ,crt_table      -- text    NOT NULL 
    ,ins_table_0    -- text    NOT NULL 
    ,ins_table_1    -- text    
    ,ins_table_2    -- text    
    ,sel_table_0    -- text    NOT NULL 
    ,sel_table_1    -- text    
    ,sel_table_2    -- text        
    ,drop_table     -- text    NOT NULL
    ,delete_from    -- text    NOT NULL	
    ,where_bad      -- text
    
FROM dict.metadata WHERE (code_metadata = %s);      
"""

class InitSet:
    """
      НАЧАЛЬНЫЕ УСТАНОВКИ, СОЗДАНИЕ СТРУКТУР, ПЕРЕКОДИРОВКА ИСХОДНОГО ФАЙЛА.
    """
    def __init__ ( self, p_yp ): 
        
        rc = -1  
        self.l_s = p_yp.conninfo

        try:
             self.con = psycopg2.connect(self.l_s)

        except psycopg2.OperationalError, e:
             print "... Connection aborted: "
             print "... " + str (e)
             sys.exit ( rc )  
             
        self.META_CODE = p_yp.meta_code        

    def recode_crt (self, p_file_name, p_base_cd, p_trg_cd):
        """
          Перекодировка реестра и загрузка метаданных.   
        """
        tr_f = tr.Trans_f (p_base_cd, p_trg_cd)
        tr_f.tr_one (p_file_name, p_file_name) 
  
        cur1 = self.con.cursor()
        cur1.execute (META_DATA, (self.META_CODE,))
        self.mt_data = cur1.fetchone()  
    
        print self.mt_data[0]
        cur1.execute (self.mt_data[1])
        
        self.con.commit()
  
class LoadData:
    """
      ЗАГРУЗКА РЕЕСТРА, p_mt_data - сформированы ранее.
    """
    def __init__ ( self, p_mt_data, p_conn, p_file_name ):       
    
        self.mt_data   = p_mt_data
        self.conn      = p_conn
        self.file_name = p_file_name
        
    def load_dt(self, p_LEN_REC):
       """
           Загружаю реестр
       """
       f_temp = open (self.file_name)
       ls_l = f_temp.readlines()
       f_temp.close()
    
       # INSERT в промежуточную структуру
       cur2 = self.conn.cursor()
       for sl in ls_l:
       
           l_sl = string.split (sl, bDL)
           if (len(l_sl) >= p_LEN_REC):
               cur2.execute (self.mt_data[2], (l_sl))        
    
       self.conn.commit()
    
class CheckData:
    """
      ПРОВЕРКА ДАННЫХ В РЕЕСТРЕ (критерии проверки пока "зашиты" в коде загрузчика)
                       формирую файл с некорректными данными.
    """
    def __init__ ( self, p_mt_data, p_conn, p_file_name, p_dBAD ):       
    
        self.mt_data   = p_mt_data
        self.conn      = p_conn
        self.file_name = p_file_name + p_dBAD   
        
    def check_dt(self, p_base_cd, p_trg_cd):
       """
          Формирование реестра  ошибочных записей.   
       """
       # Поиск дефектов и INSERT в__pay_body_bad_1
       cur2 = self.conn.cursor()
       cur4 = self.conn.cursor()
       
       cur2.execute (self.mt_data[5].format (self.mt_data[10]))        
       lt = cur2.fetchone() 
       while (lt):
           cur4.execute (self.mt_data[4], (lt))
           lt = cur2.fetchone() 

       # Выгружаю дефекты
       xlst = []
       cur4.execute (self.mt_data[6])
       lt = cur4.fetchone() 
       while (lt):

           xxs = ""
           for xst in lt:
               xs = str(xst)
               xxs = xxs + xs + bDL 
              
           xxs = string.strip (xxs, bDL)    
           xlst.append(xxs)
           xxs = ""
           lt = cur4.fetchone() 
        
       try:
            nf = open (self.file_name, "w")
            
       except IOError, ex:
            print bDONT_OPEN + self.file_name
            return 

       nf.writelines ( xlst )
       nf.close ()           
 
       trf = tr.Trans_f (p_base_cd, p_trg_cd)
       trf.tr_one (self.file_name, self.file_name) 
       
       self.conn.commit()

class LoadTotal:
    """
      ЗАГРУЗКА ДАННЫХ В ОБЩИЙ РЕЕСТР    Уникальный ID 
    """
    def __init__ ( self, p_mt_data, p_conn, p_yp ):
          
        self.mt_data = p_mt_data
        self.conn    = p_conn
        
        ##
        ##  Company -- Компания
        ##         
        self.company_email = p_yp.company_email  ## 1
        self.company_sno   = p_yp.company_sno    ## 2
        ##
        ##  Payment -- Платёж
        ## 
        self.pmt_type = p_yp.pmt_type            ## 3
        ##
        ##  Item -- Услуга 
        ## 
        self.item_measure        = p_yp.item_measure        ## 4
        self.item_payment_method = p_yp.item_payment_method ## 5
        self.payment_object      = p_yp.payment_object      ## 6  
        self.item_vat            = p_yp.item_vat            ## 7
        ##
        ##  Misc  -- Опциональные
        ## 
        self.is_company_paying_agent = p_yp.is_company_paying_agent ##  8
        self.type_source_reestr      = p_yp.type_source_reestr      ##  9
        self.id_agent                = p_yp.id_agent                ## 10
        self.id_bank                 = p_yp.id_bank                 ## 11
        ##
        ## SQL
        ##
        self.where_value = p_yp.where_value  ## 12

    def load_tt (self):
       """
          Загрузка данных в оющий реестр   
       """
       cur2 = self.conn.cursor()
       cur4 = self.conn.cursor()
       
       k = 0
       s = self.mt_data[7].format(self.mt_data[10], self.company_email,self.company_sno,\
           self.pmt_type,self.item_measure,self.item_payment_method,self.payment_object,\
               self.item_vat,self.is_company_paying_agent,self.type_source_reestr,self.id_agent,\
                    self.id_bank,self.where_value)
       
       cur2.execute (s)        
       lt = cur2.fetchone() 
       ## print len(lt)
          
       while (lt):
           cur4.execute (self.mt_data[3], (lt))
           lt = cur2.fetchone() 
           k = k +1
           
       print k    
       ## self.conn.rollback()
       self.conn.commit()

def main ():
    """
       Main entrypoint for the class
       -----------------------------       
          ПЕРЕЧЕНЬ классов загрузчика.
          ==========================================================================================
          InitSet   -- НАЧАЛЬНЫЕ УСТАНОВКИ, СОЗДАНИЕ СТРУКТУР, ПЕРЕКОДИРОВКА ИСХОДНОГО ФАЙЛА.
          
          LoadData  -- ЗАГРУЗКА РЕЕСТРА.
          
          CheckData -- ПРОВЕРКА ДАННЫХ В РЕЕСТРЕ (критерии проверки пока "зашиты" в коде загрузчика)
                       формирую файл с некорректными данными.
                 
          LoadTotal -- ЗАГРУЗКА ДАННЫХ В ОБЩИЙ РЕЕСТР       
    """
    #               1                2       
    sa = " <Source_reestr_name> <YAML-file>"
    if ( len( sys.argv ) - 1 ) < 2:
        
            print VERSION_STR 
            print "  Usage: " + str (sys.argv [0]) + sa
            sys.exit(1)

    yp = rym.yaml_patterns ('.', sys.argv[2])

    ## Установка
    ist = InitSet (yp)
    ist.recode_crt (sys.argv[1], yp.base_codec, yp.target_codec)

    ## Загрузка
    ldt = LoadData (ist.mt_data, ist.con, sys.argv[1])
    ldt.load_dt(yp.len_rec)
 
    ## Проверка заруженных данных
    chk = CheckData (ist.mt_data, ist.con, sys.argv[1], yp.dBAD)
    chk.check_dt(yp.target_codec, yp.base_codec)  # Базовая и целевая кодировки поменялись местами.
     
    ## Загрузка в общий реестр
    ltt = LoadTotal (ist.mt_data, ist.con, yp)
    ltt.load_tt() 
     
    ist.con.close()
    
    sys.exit (0)

if __name__ == '__main__':
    main()
