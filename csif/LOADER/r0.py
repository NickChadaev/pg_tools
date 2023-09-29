#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: r0.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: ---------------------------------
# HIST: 2023-06-17 - created
# NOTS: 
# -------------------------------------------------------------------------------------------

import psycopg2 
import load_mainS_tr as tr
import r0_yaml as rym
import string
import sys
import f0

VERSION_STR = "  Version 0.1.2 Build 2023-08-15"

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
    ,call_proc_fin  -- text
    
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
        self.UTF8      = p_yp.dUTF8

    def recode_crt (self, p_file_name, p_base_cd, p_trg_cd):
        """
          Перекодировка реестра и загрузка метаданных.   
        """
        tr_f = tr.Trans_f (p_base_cd, p_trg_cd)
        
        self.s_file_name = string.replace(p_file_name, " за ", bU)
        self.s_file_name = string.replace(self.s_file_name, " ", bU) 
        self.s_file_name = self.s_file_name + self.UTF8
        
        tr_f.tr_one (p_file_name, self.s_file_name) 
  
        cur1 = self.con.cursor()
        cur1.execute (META_DATA, (self.META_CODE,))
        self.mt_data = cur1.fetchone()  
    
        print self.mt_data[0]
        cur1.execute (self.mt_data[1])
        
        self.con.commit()
  
class LoadData(f0.ListSet):
    """
      ЗАГРУЗКА РЕЕСТРА, p_mt_data - сформированы ранее.
    """
    def __init__ ( self, p_mt_data, p_conn, p_file_name ):       

        f0.ListSet.__init__(self)  
    
        self.mt_data   = p_mt_data
        self.conn      = p_conn
        self.file_name = p_file_name
        
        self.setL = f0.ListSet()
        
    def load_dt(self, p_LEN_REC):
       """
           Загружаю реестр
       """
       rc = -1
       f_temp = open (self.file_name)
       ls_l = f_temp.readlines()
       f_temp.close()
       
       # INSERT в промежуточную структуру, выполняется фильтр фискализации.
       cur2 = self.conn.cursor()
       ss = self.setL.apply_filter(ls_l, p_LEN_REC)

       if (len (ss) == 0):
           print "Данные не прошли сквозь фильтр фискализации"
           sys.exit (rc)  

       for sl in ss:   
           l_sl = string.split (sl, bDL)
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
       
       self.conn.commit()

class LoadTotal:
    """
      ЗАГРУЗКА ДАННЫХ В ОБЩИЙ РЕЕСТР     
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
        self.type_source_reestr = p_yp.type_source_reestr      ##  9
        self.cash_receipt_type  = p_yp.cash_receipt_type       ## 10
        ##

    def load_tt (self):
       """
          Загрузка данных в общий реестр   
       """
       cur2 = self.conn.cursor()
       
       s = self.mt_data[7].format(self.mt_data[10], self.company_email, self.company_sno,\
           self.pmt_type, self.item_measure, self.item_payment_method, self.payment_object,\
               self.type_source_reestr, self.cash_receipt_type)
       
       ss = self.mt_data[11].format (s, self.mt_data[3])
       cur2.execute (ss)  
       
       self.conn.commit()

def main ():
    """
       Main entrypoint for the class
       ------------------------------       
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
    ldt = LoadData (ist.mt_data, ist.con, ist.s_file_name)
    ldt.load_dt(yp.len_rec)
 
    ## Проверка заруженных данных
    chk = CheckData (ist.mt_data, ist.con, ist.s_file_name, yp.dBAD)
    chk.check_dt(yp.target_codec, yp.base_codec)  # Базовая и целевая кодировки поменялись местами.
     
    ## Загрузка в общий реестр
    ltt = LoadTotal (ist.mt_data, ist.con, yp)
    ltt.load_tt() 
     
    ist.con.close()
    
    sys.exit (0)

if __name__ == '__main__':
    main()
