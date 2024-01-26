#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: load_mainCen_pt.py
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Load data into database
# HIST: 2023-12-13 - created
# NOTS: 
# -----------------------------------------------------------------------------------------------------------------------

import sys
import os
import string
#
import yaml
from yaml.loader import SafeLoader

import random

VERSION_STR = "  Version 0.0.0 Build 2023-12-13"

YAML_NOT_OPENED_0 = "... Yaml file not opened: '"
YAML_NOT_OPENED_1 = "'."

PATTERN_NOT_OPENED_0 = "... Pattern file not opened: '"
PATTERN_NOT_OPENED_1 = "'."

PY_NOT_OPENED_0 = "... Py-file not opened: '"
PY_NOT_OPENED_1 = "'."

S_DELIM = "="     # Nick 2022-03-09
bUL     = "_"
SPACE_0 = " "
EMP     = ""
bP      = "p"
bR      = "r"
RES     = "_RES"  
bSP8    = "        "
#          12345678

bPY = ".py"
# -----------------------------------

PATH_DELIMITER = '/'  # Nick 2020-05-11

class make_load_xx ():
 
 def __init__ ( self, p_param_yaml ):

     yaml_file_name = p_param_yaml.strip ()
     try:
         fy = open (yaml_file_name, "r" )
     
     except IOError as ex:
         print (YAML_NOT_OPENED_0 + yaml_file_name + YAML_NOT_OPENED_1)
         sys.exit( 1 )
     
     self.yaml_data = yaml.load(fy, Loader=SafeLoader) 

     self.template_cfg_path = None
     self.template_py_path  = None
     self.template_sql_path = None
         
     self.cfg_file_name = None
     self.script_path  = None
     self.all_disabled = None
     
     self.sql_script_body  = None
     self.sql_table_parent = None
     
     self.con_list = []  # По крайней мере одно соединение должно быть
     self.thread_pool_dic = {}
     self.task_dic = {}
     self.args_dic = {}  
     
     self.sql_file_name = None
     self.fs_sql_body   = None  #  Контент файла формируется в двух методах.  
     self.x_template    = None
     
     #
     # Внимание, для сервисного конфигурационного файла, pattern's определены здесь,
     #    в теле конструктора.
     #
     self.header = """[exchange-common]             

[pg-perfect-ticker]
"""
     self.part1 = """
thread_pool_list =  
"""
     self.part2 = """
db_con_list =        
"""
     self.part3 = """
task_list =        
"""
     self.part4 = """
{0}.max_workers = {1}"""

     self.sql_body = """
{0}.disabled = {1}                
{0}.sql = {2}
{0}.timer = {3}
{0}.thread_pool = {4}
{0}.db_con = {5}
"""     
     
     self.no_sql_body = """
{0}.disabled = {1}                
{0}.script = {2}/{3}
{0}.timer = {4}
{0}.thread_pool = {5}
{0}.db_con = {6}"""    

     self.add_part = """
{0}.script_arg = 
"""
     
 def do_yaml_xx (self):
     """
     Parsing YAML-ФАЙЛА.
     """
     
     rc = 0   
         
     if not (self.yaml_data.get('total_params') is None):
         
         #  Templates
         self.template_cfg_path = self.yaml_data ['total_params'] ['template_cfg_path']
         self.template_py_path  = self.yaml_data ['total_params'] ['template_py_path']
         self.template_sql_path = self.yaml_data ['total_params'] ['template_sql_path']
         
         # Total parameters
         self.cfg_file_name = self.yaml_data ['total_params'] ['cfg_file_name']
         self.script_path   = self.yaml_data ['total_params'] ['script_path']
         self.all_disabled  = self.yaml_data ['total_params'] ['all_disabled']  

         self.sql_script_worker = self.yaml_data ['total_params'] ['sql_script_worker']          
         self.sql_script_body   = self.yaml_data ['total_params'] ['sql_script_body'] 
         self.sql_table_parent  = self.yaml_data ['total_params'] ['sql_table_parent']
      
     else:
         
         rc = -1

     if not (self.yaml_data.get('db_con_list') is None):
         for con in self.yaml_data['db_con_list']:
             self.con_list.append(con['con_name'])

     # Далее нити и максимальное количество workers  
     if not (self.yaml_data.get('thread_pool_list') is None):
         for thread_pool in self.yaml_data ['thread_pool_list']:
             self.thread_pool_dic[thread_pool ['thread_name']] = thread_pool ['max_workers']
             
         ### print(self.thread_pool_dic)     

     # Теперь самый главный цикл
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
                 self.task_dic[task_name] = (is_sql, is_template, thread_name, task_timer, task_body,)
                                                      
             else:  # Не SQL сценарий.
                
                 if (is_template):
                    task_prefix = task['task_prefix']
                    thread_name = task['thread_name']
                    task_mult   = task['task_mult']
                    task_worker = task['task_worker']
                    task_body   = task['task_body']
                    if not (task.get('depend_prefix') is None):
                        depend_prefix = task['depend_prefix']
                    
                    self.task_dic [task_prefix] = (is_sql, is_template, thread_name, task_mult,\
                        task_worker, task_body, depend_prefix,)
                    
                 else:  # Не template, не sql, а простая py-задача
                    
                    task_name   = task['task_name']
                    task_timer  = task['task_timer']
                    thread_name = task['thread_name']

                    self.task_dic [task_name] = (is_sql, is_template, thread_name, task_timer,)
                    #  Текст функции пишется вручную
                    
                    args_list = []
                    if not (task.get('script_args') is None):   
                        for arg in task['script_args']:
                            arg_value = arg ['arg_value']
                            args_list.append (arg_value)
                    
                    self.args_dic[task_name] = args_list
     
     # Подведение итогов: списки не пусты и path params определены.
     
     if not ((len(self.task_dic) > 0) and (len(self.thread_pool_dic) > 0) and\
         (len(self.con_list) > 0) and (rc >= 0)):  
         
         rc = -1
         
     return rc
 
 def do_py_xx (self):
     """
      Создаю текст PY-worker's по шаблону.
     """
 
     # Это переменная часть sql-скрипта.
     try:
         self.fs_sql_body = open(self.sql_file_name, "at", encoding='utf-8')
     
     except IOError as ex:
         print (PY_NOT_OPENED_0 + self.sql_file_name + PY_NOT_OPENED_1)
         sys.exit(1) 
 
     for task in self.task_dic:
     
         task_tuple = self.task_dic[task]
         if (task_tuple[1] is True):  # Да это шаблон и трахаемся только с ним. 
             
             thread_name = task_tuple[2] 
             qty_task = self.thread_pool_dic[thread_name]
             
             x_file_name = self.template_py_path + PATH_DELIMITER + task_tuple[4].strip()
             z_file_name = self.template_py_path + PATH_DELIMITER + task_tuple[5].strip()
             
             try:
                 fx = open (x_file_name, "rt", encoding='utf-8')
                 x_template = fx.read()
                 fx.close()
             
             except IOError as ex:
                 print (PATTERN_NOT_OPENED_0 + x_file_name + PATTERN_NOT_OPENED_1)
                 sys.exit( 1 ) 
             
             try:
                 fz = open (z_file_name, "rt", encoding='utf-8')
                 z_template = fz.read()
                 fz.close
             
             except IOError as ex:
                 print (PATTERN_NOT_OPENED_0 + z_file_name + PATTERN_NOT_OPENED_1)
                 sys.exit( 1 )  
                 
             for t_nmb in range (qty_task):
                 if (task == bP):
                     # ----------------------------------------------------------
                     #  ВНИМАНИЕ:  0 - Префикс-1
                     #             1 - Префикс-1 в верхнем регистре
                     #             2 - Номер    
                     #             3 - Префикс-2
                     #             4 - Префикс-2 в верхнем регистре (ЗАВИСИМЫЙ)
                     #             5 - Body 
                     # ----------------------------------------------------------
                     depend_prefix = task_tuple[6].strip()
                     x_body = x_template.format(task, task.upper(), t_nmb, depend_prefix,\
                         depend_prefix.upper(), z_template)
                     xb_file_name = self.template_py_path + PATH_DELIMITER + \
                         RES + PATH_DELIMITER + task + str(t_nmb) + bPY 
                 
                 if (task == bR): 
                     # -------------------------------------------------------------------------------------------
                     #   ВНИМАНИЕ:  0 - Префикс-1
                     #              1 - Префикс-1 в верхнем регистре
                     #              2 - Номер    
                     #              3 - Body
                     x_body = x_template.format(task, task.upper(), t_nmb, z_template)
                     xb_file_name = self.template_py_path + PATH_DELIMITER + \
                         RES + PATH_DELIMITER + task + str(t_nmb) + bPY         
         
                 try:
                     fb = open (xb_file_name, "wt", encoding='utf-8')
                     fb.write(x_body)
                     fb.close
                 
                 except IOError as ex:
                     print (PY_NOT_OPENED_0 + xb_file_name + PY_NOT_OPENED_1)
                     sys.exit( 1 )  
                 #
                 # Таблицы для хранения "in-flight content", для
                 # workers создаваемых "руками" эти таблицы -- то-же ручками.
                 #
                 sql_body = self.x_template.format (task, t_nmb)  
                 self.fs_sql_body.write(sql_body)
         else:
             pass   # Это не шаблон
          

     self.fs_sql_body.close() 

 def do_cfg_xx (self):
     """
      Создаю конфигурационный файл. Немногоcopy-past из do_py_xx()
     """
     cfg_full_name = self.template_cfg_path + PATH_DELIMITER + RES +\
         PATH_DELIMITER + self.cfg_file_name

     try:
         self.fs_cfg = open (cfg_full_name, "wt", encoding = 'utf-8')
         
         self.fs_cfg.write(self.header)
         self.fs_cfg.write(self.part1)

         for thread in self.thread_pool_dic:
             self.fs_cfg.write(bSP8 + thread + '\n')

         self.fs_cfg.write(self.part2)
         for x_con in self.con_list:
             self.fs_cfg.write(bSP8 + x_con + '\n')

         self.fs_cfg.write(self.part3)     
         for task in self.task_dic: # Задачи трах №1. 
         
             task_tuple = self.task_dic[task]
             if (task_tuple[1] is True):  
        
                 thread_name = task_tuple[2] 
                 qty_task = self.thread_pool_dic[thread_name]
                 
                 for t_nmb in range (qty_task):
                     x_task_name = task + str(t_nmb) 
                     self.fs_cfg.write(bSP8 + x_task_name + '\n')
             else:
                 self.fs_cfg.write(bSP8 + task + '\n')
         
         for thread_name in self.thread_pool_dic:
             self.fs_cfg.write(self.part4.format (thread_name, self.thread_pool_dic[thread_name]))
    
         for task in self.task_dic: # Задачи трах №2. 

             task_tuple = self.task_dic[task]
             if (task_tuple[0] is True):  # sql - не может быть template.
                 
                 self.fs_cfg.write("\n")
                 self.fs_cfg.write(self.sql_body.format (task, self.all_disabled, task_tuple[4],\
                     task_tuple[3], task_tuple[2], self.con_list[0]))
             
             else:  # No-sql body у нх могут быть дополнительные параметры.
                 if (task_tuple[1] is True):  # template
                     
                     thread_name = task_tuple[2] 
                     qty_task = self.thread_pool_dic[thread_name]
                     
                     for t_nmb in range (qty_task):
                         x_task_name = task + str(t_nmb) 
                         
                         self.fs_cfg.write("\n")
                         self.fs_cfg.write(self.no_sql_body.format(x_task_name, self.all_disabled,\
                             self.script_path, (x_task_name + bPY),\
                                 round(((random.random())*task_tuple[3]),2),\
                                     thread_name, self.con_list[0]))
                         
                         if not (self.args_dic.get(x_task_name) is None):
                            self.fs_cfg.write(self.add_part.format(x_task_name))
                            for arg_l in self.args_dic[x_task_name]:
                                self.fs_cfg.write (bSP8 + str(arg_l) + "\n")
                        
                 else:  # Ни фига подобного.
                     self.fs_cfg.write("\n")
                     self.fs_cfg.write(self.no_sql_body.format(task, self.all_disabled, self.script_path,\
                         (task + bPY), task_tuple[3], task_tuple[2], self.con_list[0]))
                         
                     if not (self.args_dic.get(task) is None):
                        self.fs_cfg.write(self.add_part.format(task))
                        for arg_l in self.args_dic[task]:
                            self.fs_cfg.write (bSP8 + str(arg_l) + "\n")
                     
     except IOError as ex:
         print (PY_NOT_OPENED_0 + cfg_full_name + PY_NOT_OPENED_1)
         sys.exit( 1 )      

     # Закрыть его в самом конце. ???
     self.fs_cfg.close()

 def do_sql_xx (self):
     """
     Создаю таблицы для хранения данных для микросервисов
     Две очереди, хранящие задания на parsing и на обработку (processing)
     Далее для каждого микросервиса создаётся таблица для хранения "in_fight" контента.
     """
     z_file_name = self.template_sql_path + PATH_DELIMITER + self.sql_script_body.strip()
             
     try:
         fz_sql = open (z_file_name, "rt", encoding='utf-8')
         z_template = fz_sql.read()
         fz_sql.close()
     
     except IOError as ex:
         print (PATTERN_NOT_OPENED_0 + z_file_name + PATTERN_NOT_OPENED_1)
         sys.exit( 1 )      
     
     # Особенность sql-скрипта: "Body" - это основной блок, началол скрипта,
     # далее, к нему "пристыковываются" части ответственные за "in-flight-content"
     # поэтому имя одно, но далее файл будет открываться в "append_mode" в методе "do_py_xx".
     
     sql_body = z_template.format(self.sql_table_parent)
     self.sql_file_name = self.template_sql_path + PATH_DELIMITER + RES +\
         PATH_DELIMITER + "1_" + ((self.sql_script_body.replace("z_", "")).\
             replace("__sql", "sql"))

     try:
         
         self.fs_sql_body = open (self.sql_file_name, "wt", encoding = 'utf-8')
         self.fs_sql_body.write(sql_body)
         self.fs_sql_body.close()               # Далее append  mode.
     
     except IOError as ex:
         print (PY_NOT_OPENED_0 + self.sql_file_name + PY_NOT_OPENED_1)
         sys.exit( 1 ) 

     # А теперь вытаскиваю заготовку для переменной части.
     
     x_file_name = self.template_sql_path + PATH_DELIMITER + self.sql_script_worker.strip()
             
     try:
         fx_sql = open (x_file_name, "rt", encoding = 'utf-8')
         self.x_template = fx_sql.read()
         fx_sql.close()
     
     except IOError as ex:
         print (PATTERN_NOT_OPENED_0 + x_file_name + PATTERN_NOT_OPENED_1)
         sys.exit( 1 )      
     
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
        rc = ml.do_yaml_xx ()

        if (rc == 0):
            
            ml.do_sql_xx()
            ml.do_cfg_xx()
            ml.do_py_xx()
            
            print (ml.template_cfg_path)
            print (ml.template_py_path)
            print (ml.template_sql_path)
                
            print (ml.cfg_file_name)
            print (ml.script_path) 
            print (ml.all_disabled)
            
            print (ml.sql_script_body) 
            print (ml.sql_table_parent)
          
            print (ml.con_list)        
            print (ml.thread_pool_dic) 
            print (ml.task_dic)
            print (ml.args_dic)   
            
            print (ml.sql_file_name)
        
        sys.exit (rc)

#---------------------------------------
    except KeyboardInterrupt as e:
        print ("... Terminated by user: ")
        s1ys.exit (1)

# ===================================================================================================
