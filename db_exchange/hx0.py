#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainCar.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Load data into database
# HIST: 2021-11-23 - created
# NOTS: 
#       2022-03-08  Yaml-conf file       
# -----------------------------------------------------------------------------------------------------------------------

import sys
import os
import string
### import datetime
import psycopg2  
import time

#
import yaml
from yaml.loader import SafeLoader

VERSION_STR = "  Version 0.0.0 Build 2023-12-13"

YAML_NOT_OPENED_0 = "... Yaml file not opened: '"
YAML_NOT_OPENED_1 = "'."

S_DELIM = "="     # Nick 2022-03-09
bUL     = "_"
SPACE_0 = " "
EMP     = ""
# -----------------------------------

PATH_DELIMITER = '/'  # Nick 2020-05-11

class make_load_xx ():
 """
    main class Nick 2023-02-07/2023-11-27
    <Host_IP> <Port> <DB_name> <User_name> <Yaml_file> <Version>
    
 """
 def __init__ ( self, p_param_yaml ):

     yaml_file_name = p_param_yaml.strip ()
     try:
         fy = open (yaml_file_name, "r" )
     
     except IOError as ex:
         print (YAML_NOT_OPENED_0 + yaml_file_name + YAML_NOT_OPENED_1)
         sys.exit( 1 )
     
     self.yaml_data = yaml.load(fy, Loader=SafeLoader) 
     
 def to_do_xx (self):
     
     ## fserver_nmb = None
     ## schemas = None
     ## hn = "{0:02d}"  
         
     rc = 0   
         
     ### print (self.yaml_data)
     ### print (dir(self.yaml_data))
         
     if not (self.yaml_data.get('paths_params') is None):
         
         #  Tempolates
         template_cfg_path = self.yaml_data ['paths_params'] ['template_cfg_path']
         template_py_path  = self.yaml_data ['paths_params'] ['template_py_path']
         template_sql_path = self.yaml_data ['paths_params'] ['template_sql_path']
         
         # Total parameters
         script_path  = self.yaml_data ['paths_params'] ['script_path']
         all_disabled = self.yaml_data ['paths_params'] ['all_disabled']    
         
         print (template_cfg_path)
         print (template_py_path)
         print (template_sql_path)
         print (script_path)
         print (all_disabled)
         
         
     else:
         
         template_cfg_path = None
         template_py_path  = None
         template_sql_path = None
         
         script_path  = None
         all_disabled = None
         
         rc = -1

     con_list = []  # По крайней мере одно соединение должно быть
     if not (self.yaml_data.get('db_con_list') is None):
         for con in self.yaml_data['db_con_list']:
             con_list.append(con['con_name'])

         print(con_list[0])

     # Далее нити и максимальное количество workers  Dic
     
     thread_pool_dic = {}
     if not (self.yaml_data.get('thread_pool_list') is None):
         for thread_pool in self.yaml_data ['thread_pool_list']:
             ##thread_name = thread_pool ['thread_name']
             ##max_workers = thread_pool ['max_workers']
             thread_pool_dic[thread_pool ['thread_name']] = thread_pool ['max_workers']
             
         print (thread_pool_dic)     
     
     # Как выбирать необходимую нить ???

     # Теперь самый главный цикл
     task_dic = {}
     if not (self.yaml_data.get('tasks') is None):
         for task in self.yaml_data['tasks']:
             is_sql      = task['is_sql']
             is_template = task['is_template']
             
             if is_sql:  #  Нет необходимости в проверке "is_template", sql-task - всегда оригинальна
                 task_name   = task['task_name']
                 thread_name = task['thread_name'] 
                 task_timer  = task['task_timer']
                 task_body   = task['task_body']
                 
                 # Допустим, так
                 task_dic[task_name] = (is_sql, is_template, thread_name, task_timer, task_body,)
                 print ("-- 1 --")
                 print (task_dic)
                                                      
             else:  # Не SQL сценарий.
                 print ("-- 1.1 --")                 
                 print (is_sql)
                 print (is_template)
                 
                 if (is_template):
                    task_prefix = task['task_prefix']
                    thread_name = task['thread_name']
                    task_mult   = task['task_mult']
                    task_worker = task['task_worker']
                    task_body   = task['task_body']
                    
                    task_dic [task_prefix] = (is_sql, is_template, thread_name, task_mult,\
                        task_worker, task_body,)
                    print ("-- 2 --")
                    print (task_dic)
                    
                 else:  # Не template, не sql, а простая py-задача

                    print ("-- 3.1 --") 
                    print (is_sql)
                    print (is_template)
                    
                    task_name   = task['task_name']
                    task_timer  = task['task_timer']
                    thread_name = task['thread_name']

                    task_dic [task_name] = (is_sql, is_template, thread_name, task_timer,)
                    print (task_dic)
                    #  Текст функции пишется вручную
                    
                    print (task_name)
                    print (task_timer)                    
                    print (thread_name)

                    args_dic = {}  # Вообще-то словарь
                    args_list = []
                   
                    if not (task.get('script_args') is None):  ##!!!!!!!!!
                        print (task['script_args'])
                        for arg in task['script_args']:
                            arg_value = arg ['arg_value']
                            args_list.append (arg_value)        
                    
                    args_dic[task_name] = args_list
                        
                    print ("-- 3 --")
                    print (args_dic)
     # Подведение итогов: списки не пусты и path params определены.
     
     if not ((len(task_dic) > 0) and (len(thread_pool_dic) > 0) and\
         (len(con_list) > 0) and (rc >= 0)):  
         
         rc = -1
         
     print (rc)    
     return rc
 
# ----------------------------------------------------------
if __name__ == '__main__':
    try:
        """
             Main entrypoint for the class
        """
         #       1          2       3         4           5          6   
        sa = " <Yaml_file>"
        
        if ((len( sys.argv ) - 1) < 1):
            print (VERSION_STR )
            print ("  Usage: " + str ( sys.argv [0] ) + sa)
            sys.exit( 1 )
        
        rc = 0
        ml = make_load_xx (sys.argv[1])
        rc = ml.to_do_xx ()
        
        sys.exit (rc)

#---------------------------------------
    except KeyboardInterrupt as e:
        print ("... Terminated by user: ")
        s1ys.exit (1)

# ===================================================================================================
