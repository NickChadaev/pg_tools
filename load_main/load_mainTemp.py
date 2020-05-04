#!/usr/bin/python
# coding=utf-8
# PROJ: DataBase, service function.
# FILE: ScriptTemplate.py
# AUTH: Nick (nick_ch58@list.ru)
# DESC: Create script template.
# HIST: 2010-03-17 - created.

import sys, string

class ScriptTemplate:

    def __init__ (self):

        self.list_temp = []
        self.list_temp.append ( "#-------------------------------------------------------------------------------")
        self.list_temp.append ( "# 2009-04-21 Nick (nick_ch58@list.ru).")
        self.list_temp.append ( "#-------------------------------------")
        self.list_temp.append ( "# Сценарий. Поля:")
        self.list_temp.append ( "# 0 - вид действия, 1 - Имя файла/текст команды, 2 - база, 3 - комментарий")
        self.list_temp.append ( "#    Имя базы может быть опущено. Если оно есть, то отменяет имя базы указанное")
        self.list_temp.append ( "#    в списке параметров, передаваемом в программу при вызове.")
        self.list_temp.append ( "#-------------------------------------------------------------------------------")
        self.list_temp.append ( "# Вид действия: 0 - Прямое выполнение SQL-команды,")
        self.list_temp.append ( "#               1 - Выполнение последовательности SQL-команд из файла")
        self.list_temp.append ( "#               2 - Выполнение -- с очисткой таблицы и подсчётом кол-ва строк")
        self.list_temp.append ( "#               A - Выгрузка таблицы")
        self.list_temp.append ( "#               C - Дамп базы в тестовом формате, структура и данные,")
        self.list_temp.append ( "#                   текстовый формат, команды INSERT.")
        self.list_temp.append ( "#               F - Дамп схемы в тестовом формате, структура и данные,")
        self.list_temp.append ( "#                   текстовый формат, команды INSERT.")
        self.list_temp.append ( "#               X - Сообщение для пользователя ( 1, 2 поля - пустые )")
        self.list_temp.append ( "#-------------------------------------------------------------------------------")
        self.list_temp.append ( "X;;;Начат процесс;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "1;;; -- ;")
        self.list_temp.append ( "X;;;Процесс завершен;")
        self.list_temp.append ( "#-------------------------------------------------------------------------------")

    def get_list ( self ):

        return self.list_temp
