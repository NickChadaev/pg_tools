#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: GarProcess package
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities. Patterens for calling the PLpgSQL function/procedures.
# -----------------------------------------------------------------------------------------

import sys
## import string

VERSION_STR = "  Version 0.0.0 Build 2022-05-20"

class proc_patterns ():
    """
      Patterns  
    """
    def __init__ (self):
        
        # Смена индексного покрытия в целевых таблицах
        self.gar_link_p_adr_area_idx = """CALL gar_link.p_adr_area_idx (
                   p_conn        := (gar_link.f_conn_set({0}::numeric(3)))::text -- Именованное dblink-соединение   
                  ,p_schema_name := '{1}'::text  -- Имя отдалённой схемы 
                  ,p_mode_t      := {2}::boolean -- TRUE - Эксплутационные, FALSE - Загрузочные
                  ,p_mode_c      := {3}::boolean -- TRUE - Создание индексов, FALSE - удаление             
            );
        """                
        self.gar_link_p_adr_street_idx = """CALL gar_link.p_adr_street_idx (
                   p_conn        := (gar_link.f_conn_set({0}::numeric(3)))::text -- Именованное dblink-соединение   
                  ,p_schema_name := '{1}'::text  -- Имя отдалённой схемы 
                  ,p_mode_t      := {2}::boolean -- TRUE - Эксплутационные, FALSE - Загрузочные
                  ,p_mode_c      := {3}::boolean -- TRUE - Создание индексов, FALSE - удаление  
                  ,p_uniq_sw     := {4}::boolean -- Уникальность "ak1", "ie2".                  
            );
        """      
        self.gar_link_p_adr_house_idx = """CALL gar_link.p_adr_house_idx (
                   p_conn        := (gar_link.f_conn_set({0}::numeric(3)))::text -- Именованное dblink-соединение   
                  ,p_schema_name := '{1}'::text  -- Имя отдалённой схемы 
                  ,p_mode_t      := {2}::boolean -- TRUE - Эксплутационные, FALSE - Загрузочные
                  ,p_mode_c      := {3}::boolean -- TRUE - Создание индексов FALSE - удаление  
                  ,p_uniq_sw     := {4}::boolean -- TRUE - Уникальность "ak1", "ie2" - 
            ); 
        """
        #--------------------------------------------------------------------------------------------        
        #  
        # stage_6_1
        #
        #   adr_street_check_twins:
        #       descr: Поиск дублей, таблица ADR_STREET
        #       params:
        #           p_skip: False
        #           p_bound_date: DATE('2022-01-01') 
        #           p_init_value: 100000000   
        #           
        self.gar_tmp_p_adr_street_check_twins = """CALL gar_tmp_pcg_trans.p_adr_street_check_twins (
                p_schema_name      := '{0}'::text      -- Схема 
               ,p_conn_name        := (gar_link.f_conn_set({1}::numeric(3)))::text   -- Именованое dblink-соединение
               ,p_street_ids       := {2}::bigint [][] -- Массив граничных значений  
               ,p_mode             := {3}::boolean     -- Постобработка FALSE.
               ,p_bound_date       := {4}::date        -- Только для режима Post обработки. '2022-01-01' 
               ,p_schema_hist_name := '{5}'::text      -- Схема с историческими данными 'gar_tmp'             
        );
        """
        # -- Улицы. Контрольный запрос.
        self.check_data_adr_street = """SELECT * FROM {0}.adr_street_hist WHERE (id_region = {1});   
        """
        # Уникальный эксплуатационный индекс.
        self.gar_link_p_adr_street_idx_set_uniq = """CALL gar_link.p_adr_street_idx_set_uniq (
                   p_conn        := (gar_link.f_conn_set({0}::numeric(3)))::text  -- Именованное dblink-соединение   
                  ,p_schema_name := '{1}'::text      -- Имя отдалённой схемы 
                  ,p_mode_t      := {2}::boolean -- Выбор типа индексов TRUE - Эксплутационные, FALSE - Загрузочные
                  ,p_uniq_sw     := {3}::boolean -- Уникальность "ak1", "ie2" - TRUE  
        );
        """
        #      
        # stage_6_2
        #
        #   adr_house_check_twins:
        #       descr: Поиск дублей, таблица ADR_HOUSE
        #       params:
        #           p_skip: False
        #           p_bound_date: DATE('2022-01-01') 
        #           p_init_value: 100000000   
        #        
        self.gar_tmp_p_adr_house_check_twins = """CALL gar_tmp_pcg_trans.p_adr_house_check_twins (
                p_schema_name      := '{0}'::text      -- Схема 
               ,p_conn_name        := (gar_link.f_conn_set({1}::numeric(3)))::text   -- Именованое dblink-соединение
               ,p_house_ids        := {2}::bigint [][] -- Массив граничных значений  
               ,p_mode             := {3}::boolean     -- Постобработка FALSE.
               ,p_bound_date       := {4}::date        -- Только для режима Post обработки. '2022-01-01' 
               ,p_schema_hist_name := '{5}'::text      -- Схема с историческими данными 'gar_tmp'             
        );
        """        
        # -- Дома. Контрольный запрос.
        self.check_data_adr_house = """SELECT * FROM {0}.adr_house_hist WHERE (id_region = {1});   
        """
        self.gar_link_p_adr_house_idx_set_uniq = """CALL gar_link.p_adr_house_idx (
                   p_conn        := (gar_link.f_conn_set({0}::numeric(3)))::text -- Именованное dblink-соединение   
                  ,p_schema_name := '{1}'::text  -- Имя отдалённой схемы 
                  ,p_mode_t      := {2}::boolean -- TRUE - Эксплутационные, FALSE - Загрузочные
                  ,p_mode_c      := {3}::boolean -- TRUE - Создание индексов FALSE - удаление  
                  ,p_uniq_sw     := {4}::boolean -- TRUE - Уникальность "ak1", "ie2" - 
            ); 
        """
        
# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        pp = proc_patterns ()
        
        print pp.gar_tmp_p_adr_street_check_twins
        print pp.check_data_adr_street
        print pp.gar_tmp_p_adr_house_check_twins
        print pp.check_data_adr_house
        print pp.gar_link_p_adr_street_idx_set_uniq
        print pp.gar_link_p_adr_house_idx_set_uniq
        
        sys.exit (0)

#---------------------------------------
    except KeyboardInterrupt, e:
        print "... Terminated by user: "
        sys.exit (1)
