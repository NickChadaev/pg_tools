#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: GarProcess package
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities. Patterens for calling the PLpgSQL function/procedures.
# -----------------------------------------------------------------------------------------

import sys
## import string

VERSION_STR = "  Version 0.0.0 Build 2022-06-09"

class proc_patterns ():
    """
      Patterns  
    """
    def __init__ (self):

        # ----------------------------------------------------------------------------------
        # Дополнение адресных регионов
        self.gar_tmp_pcg_trans_f_adr_area_ins = """    
  SELECT gar_tmp_pcg_trans.f_adr_area_ins (
         p_schema_data   := '{0}'::text  -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
        ,p_schema_etl    := '{1}'::text  -- Схема эталон, обычно локальный сервер, копия p_schema_data 
        ,p_schema_hist   := '{2}'::text  -- Схема для хранения исторических данных 
        ,p_nm_guids_fias := NULL::uuid[] -- Список обрабатываемых GUID, NULL - все.
        ,p_sw_hist       := {3}::boolean -- True -> Создаётся историческая запись.
      );
"""
        # Обновление адресных регионов
        self.gar_tmp_pcg_trans_f_adr_area_upd = """
 SELECT gar_tmp_pcg_trans.f_adr_area_upd (
           p_schema_data   := '{0}'::text  -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl    := '{1}'::text  -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist   := '{2}'::text  -- Схема для хранения исторических данных 
          ,p_nm_guids_fias := NULL::uuid[] -- Список обрабатываемых GUID, NULL - все.
          ,p_sw_hist       := {3}::boolean -- TRUE -> Создаётся историческая запись.
 ); 
"""
        #  Контрольный запрос
        self.gar_tmp_pcg_trans_f_adr_area_check = """
  {0};  
"""
        # ----------------------------------------------------------------------------------
        # Дополнение улиц
        self.gar_tmp_pcg_trans_f_adr_street_ins = """
 SELECT gar_tmp_pcg_trans.f_adr_street_ins (
           p_schema_data   := '{0}'::text  -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl    := '{1}'::text  -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist   := '{2}'::text  -- Схема для хранения исторических данных 
          ,p_nm_guids_fias := NULL::uuid[] -- Список обрабатываемых GUID, NULL - все.
          ,p_sw_hist       := {3}::boolean -- TRUE -> Создаётся историческая запись.   
 );"""        

        # Обновление улиц  
        self.gar_tmp_pcg_trans_f_adr_street_upd = """
 SELECT gar_tmp_pcg_trans.f_adr_street_upd  (
           p_schema_data   := '{0}'::text  -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl    := '{1}'::text  -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist   := '{2}'::text  -- Схема для хранения исторических данных 
          ,p_nm_guids_fias := NULL::uuid[] -- Список обрабатываемых GUID, NULL - все.
          ,p_sw_hist       := {3}::boolean -- TRUE -> Создаётся историческая запись.      -- !!!!!
          ,p_sw_duble      := {4}::boolean -- TRUE -> Обязательное выявление дубликатов   -- !!!!!
 );"""

        #  Контрольный запрос
        self.gar_tmp_pcg_trans_f_adr_street_check = """
  {0};  
"""
        # ------------------------------------------------
        # Дополнение домов
        self.gar_tmp_pcg_trans_f_adr_house_ins = """
  SELECT gar_tmp_pcg_trans.f_adr_house_ins (
           p_schema_data   := '{0}'::text  -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl    := '{1}'::text  -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist   := '{2}'::text  -- Схема для хранения исторических данных 
          ,p_nm_guids_fias := NULL::uuid[] -- Список обрабатываемых GUID, NULL - все.
          ,p_sw            := {3}::boolean -- TRUE -> Включить дополнение/обновление adr_objects
          ,p_sw_twin       := {4}::boolean -- TRUE -> Включается поиск двойников        
      );"""

        # Обновление домов
        self.gar_tmp_pcg_trans_f_adr_house_upd = """
 SELECT gar_tmp_pcg_trans.f_adr_house_upd (
           p_schema_data   := '{0}'::text  -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl    := '{1}'::text  -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist   := '{2}'::text  -- Схема для хранения исторических данных 
          ,p_nm_guids_fias := NULL::uuid[] -- Список обрабатываемых GUID, NULL - все.
          ,p_sw_hist       := {3}::boolean -- TRUE -> Создаётся историческая запись.  
          ,p_sw_duble      := {4}::boolean -- TRUE -> Обязательное выявление дубликатов
          ,p_sw            := {5}::boolean -- TRUE -> Включить дополнение/обновление adr_objects
          ,p_del           := {6}::boolean -- TRUE -> Убираю дубли при обработки EXCEPTION 
 );"""
        #  Контрольный запрос
        self.gar_tmp_pcg_trans_f_adr_house_check = """
  {0};  
"""        
        
# --------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        pp = proc_patterns ()
        
        print pp.gar_tmp_pcg_trans_f_adr_area_ins
        print pp.gar_tmp_pcg_trans_f_adr_area_upd        
        print pp.gar_tmp_pcg_trans_f_adr_street_ins        
        print pp.gar_tmp_pcg_trans_f_adr_street_upd
        print pp.gar_tmp_pcg_trans_f_adr_house_ins        
        print pp.gar_tmp_pcg_trans_f_adr_house_upd        
        
        sys.exit (0)

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)
