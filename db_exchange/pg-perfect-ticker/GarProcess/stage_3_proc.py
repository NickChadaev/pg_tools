#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: GarProcess package
# AUTH: NickChadaev (nick-ch58@yandex.ru)
# DESC: Utilities. Patterens for calling the PLpgSQL function/procedures.
#       2023-03-28 - version for python3
# -----------------------------------------------------------------------------------------

import sys

VERSION_STR = "  Version 1.0.0 Build 2023-03-28"

class proc_patterns ():
    """
      Patterns  
    """
    def __init__ (self):
        
        # Проверка региона
        self.get_region_info = """SELECT * FROM {0}.adr_area WHERE (id_area = {1}::bigint);   
        """
        # Заполнение таблицы с дефектными данными.
        self.gar_fias_set_adr_data = """SELECT gar_fias_pcg_load.f_adr_area_set_data (
              p_fias_guid := (gar_tmp_pcg_trans.f_adr_area_get('{0}',{1})).nm_fias_guid::uuid
             ,p_date      := '{2}'::date
             ,p_descr     := (gar_tmp_pcg_trans.f_adr_area_get('{0}',{1})).nm_area_full::text);"""     
             
        # Обработка таблицы с дефектными данными.
        self.gar_fias_addr_obj_update_children = """SELECT * FROM gar_fias_pcg_load.f_addr_obj_update_children (
         p_date_1    := '{0}'::date
        ,p_obj_level := ARRAY{1}::integer[]      
        ,p_date_2    := {2}::date           
        );"""
             
        # Установка признака LOGGED/UNLOGGED у таблиц в схеме gar_tmp
        self.gar_tmp_p_alt_tbl = "CALL gar_tmp_pcg_trans.p_alt_tbl (p_all := {0}::boolean);"
        #
        # Создание рабочих индексов в схеме gar_fias. False - удаление, True - создание
        self.gar_tmp_p_gar_fias_crt_idx = """CALL gar_tmp_pcg_trans.p_gar_fias_crt_idx (
                                                p_sw := {0}::boolean);"""
        #
        # Очистка данных во временной схеме.  
        self.gar_tmp_p_clear_tbl = """CALL gar_tmp_pcg_trans.p_clear_tbl (p_op_type := ARRAY{0}::integer[]);
        """
        #
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
        self.gar_link_p_adr_objects_idx = """CALL gar_link.p_adr_objects_idx (
                   p_conn        := (gar_link.f_conn_set({0}::numeric(3)))::text -- Именованное dblink-соединение   
                  ,p_schema_name := '{1}'::text  -- Имя отдалённой схемы 
                  ,p_mode_t      := {2}::boolean -- TRUE - Эксплутационные, FALSE - Загрузочные
                  ,p_mode_c      := {3}::boolean -- TRUE - Создание индексов FALSE - удаление 
                  ,p_uniq_x2     := {4}::boolean -- TRUE - Уникальность второго загрузочного индекса
            );
        """     
        #
        #  Загрузка данных из таблицы ADR_AREA_TYPE
        self.gar_tmp_p_adr_area_type_unload = """CALL gar_tmp_pcg_trans.p_adr_area_type_unload (
	                                                    p_sch_local  := '{0}'::text
	                                                   ,p_sch_remote := '{1}'::text
        );        
        """
        #  Загрузка данных из таблицы ADR_STREET_TYPE
        self.gar_tmp_p_adr_street_type_unload = """CALL gar_tmp_pcg_trans.p_adr_street_type_unload (
	                                                    p_sch_local  := '{0}'::text
	                                                   ,p_sch_remote := '{1}'::text
        );        
        """
        #  Загрузка данных из таблицы ADR_HOUSE_TYPE
        self.gar_tmp_p_adr_house_type_unload = """CALL gar_tmp_pcg_trans.p_adr_house_type_unload (
	                                                    p_sch_local  := '{0}'::text
	                                                   ,p_sch_remote := '{1}'::text
        );
	     """
        # Загрузка регионального фрагмента из таблицы ADR_AREA
        self.gar_tmp_p_adr_area_unload = """CALL gar_tmp_pcg_trans.p_adr_area_unload (
              p_schema_name := '{0}'::text  
             ,p_id_region   := {1}::bigint
             ,p_conn        := (gar_link.f_conn_set({2}::numeric(3)))::text -- Именованное dblink-соединение    
           );
        """
         #
        # Загрузка регионального фрагмента из таблицы ADR_STREET
        self.gar_tmp_p_adr_street_unload = """CALL gar_tmp_pcg_trans.p_adr_street_unload (
              p_schema_name := '{0}'::text  
             ,p_id_region   := {1}::bigint
             ,p_conn        := (gar_link.f_conn_set({2}::numeric(3)))::text -- Именованное dblink-соединение    
           );
        """       
        #
        # Загрузка регионального фрагмента из таблицы ADR_HOUSE
        self.gar_tmp_p_adr_house_unload = """CALL gar_tmp_pcg_trans.p_adr_house_unload (
              p_schema_name := '{0}'::text  
             ,p_id_region   := {1}::bigint
             ,p_conn        := (gar_link.f_conn_set({2}::numeric(3)))::text -- Именованное dblink-соединение    
           );
        """
        # Загрузка регионального фрагмента из таблицы ADR_OBJECTS
        self.gar_tmp_p_adr_object_unload = """CALL gar_tmp_pcg_trans.p_adr_object_unload (
              p_schema_name := '{0}'::text  
             ,p_id_region   := {1}::bigint
             ,p_conn        := (gar_link.f_conn_set({2}::numeric(3)))::text -- Именованное dblink-соединение    
           );
        """
        #
        # Установка последовательностей
        self.gar_tmp_f_xxx_obj_seq_crt = """SELECT gar_tmp_pcg_trans.f_xxx_obj_seq_crt (
              p_seq_name   := '{0}'::text -- Имя последовательности
             ,p_id_region  := {1}::bigint -- ID региона
             ,p_init_value := {2}::bigint -- Начальное значение    
              --                       Схемы
             ,p_adr_area_sch   := '{3}'::text -- Адресные пространства
             ,p_adr_street_sch := '{4}'::text -- Улицы
             ,p_adr_house_sch  := '{5}'::text -- Дома
              --
             ,p_seq_hist_name := '{6}'::text -- Имя исторической последовательности (УСТАРЕЛО)
        );
        """
        #
        # Актуализация справочников (адресные пространства).
        self.gar_tmp_f_xxx_adr_area_type_set = """SELECT gar_tmp_pcg_trans.f_xxx_adr_area_type_set (
              p_schema_etalon := '{0}'::text      -- Схема с эталонными справочниками.   
             ,p_schemas       := {1}::text[]  -- Список обновляемых схем (Здесь может быть эталон).
             ,p_op_type       := ARRAY{2}::integer[] -- Список выполняемых операций, пока только две.     
        );        
        """
        # Улицы, частный случай адресного пространства
        self.gar_tmp_f_xxx_street_type_set = """SELECT gar_tmp_pcg_trans.f_xxx_street_type_set (
              p_schema_etalon := '{0}'::text 
             ,p_schemas       := {1}::text[]
             ,p_op_type       := ARRAY{2}::integer[]
        );
        """
        # Дома
        self.gar_tmp_f_xxx_house_type_set = """SELECT gar_tmp_pcg_trans.f_xxx_house_type_set (
                p_schema_etalon := '{0}'::text 
               ,p_schemas       := {1}::text[]
               ,p_op_type       := ARRAY{2}::integer[]
        );        
        """
        # -----------------------------------------------------------------
        # Агрегация параметров. Для каждого объекта запомнить пары "Тип" -> "Значение"
        self.gar_tmp_f_set_params_value = """SELECT gar_tmp_pcg_trans.f_set_params_value (
              p_param_type_ids := ARRAY{0}::bigint[]
            ); 
        """
        # Агрегация адресных пространств.
        self.gar_tmp_f_xxx_adr_area_set_data = """SELECT gar_tmp_pcg_trans.f_xxx_adr_area_set_data (
              p_date          := {0}::date     -- Дата, на которую выбираются данные
             ,p_obj_level     := {1}::bigint   -- Уровень объекта
             ,p_oper_type_ids := {2}::bigint[] -- Типы операций.
        );
        """
        # Агрегация домовладений.
        self.gar_tmp_f_xxx_adr_house_set_data = """ SELECT gar_tmp_pcg_trans.f_xxx_adr_house_set_data (
              p_date          := {0}::date  
             ,p_parent_obj_id := {1}::bigint
        ); 
        """
        # Заполнение управляющей таблицы "gar_tmp.xxx_obj_fias"
        self.gar_tmp_f_xxx_obj_fias_set_data = """SELECT gar_tmp_pcg_trans.f_xxx_obj_fias_set_data (
              p_adr_area_sch   := '{0}'::text -- Отдалённая/Локальная схема для хранения адресных областей
             ,p_adr_street_sch := '{1}'::text -- Отдалённая/Локальная схема для хранения улиц
             ,p_adr_house_sch  := '{2}'::text -- Отдалённая/Локальная схема для хранения домов/строений
        );
        """      
        
# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        pp = proc_patterns()
        
        print (pp.gar_fias_set_adr_data)
        print ()
        print (pp.gar_fias_addr_obj_update_children)
        print ()
        print (pp.gar_tmp_p_adr_area_unload)
        print (pp.gar_tmp_p_adr_street_unload)
        print (pp.gar_tmp_p_adr_house_unload)
        
        sys.exit (0)

#---------------------------------------
    except KeyboardInterrupt as e:
        print ("... Terminated by user: ")
        sys.exit (1)
