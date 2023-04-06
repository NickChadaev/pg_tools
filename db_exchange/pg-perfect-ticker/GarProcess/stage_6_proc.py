#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: stage_6_proc.py
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
        
        # Сохранение записи в журнале выгрузок
        self.export_f_version_put = """SELECT export_version.f_version_put (
                                      p_dt_gar_version := '{0}'::date 
                                     ,p_kd_export_type := {1}::boolean 
                                     ,p_id_region      := {2}::bigint 
                                     ,p_seq_name       := '{3}'::text 
                                     ,p_node_id        := {4}::numeric         
        );
        """
        self.export_f_version_by_obj_put = """SELECT export_version.f_version_by_obj_put (
                           p_dt_gar_version := '{0}'::date 
                          ,p_sch_name       := '{1}'::text
                          ,p_nm_object      := '{2}'::text 
                          ,p_qty_main       := {3}::integer 
                          ,p_qty_aux        := {4}::integer 
                          ,p_file_path      := '{5}'::text
        );
        """
        # Загрузка
        self.gar_tmp_p_adr_area_upload = """CALL gar_tmp_pcg_trans.p_adr_area_upload (
                      p_lschema_name := '{0}'::text -- локальная схема 
                     ,p_fschema_name := '{1}'::text -- отдалённая схема
                   );
        """

        self.gar_tmp_p_adr_street_upload = """CALL gar_tmp_pcg_trans.p_adr_street_upload (
                      p_lschema_name := '{0}'::text -- локальная схема 
                     ,p_fschema_name := '{1}'::text -- отдалённая схема
                   );
        """   

        self.gar_tmp_p_adr_house_upload = """ CALL gar_tmp_pcg_trans.p_adr_house_upload (
                      p_lschema_name := '{0}'::text -- локальная схема 
                     ,p_fschema_name := '{1}'::text -- отдалённая схема
                   );
        """      

        self.conn = """(gar_link.f_conn_set({0}::numeric(3)))"""
        
        # Далее управление индексами
        self.gar_link_p_adr_area_idx = """CALL gar_link.p_adr_area_idx (
              p_schema_name := '{0}'::text  -- Имя отдалённой/локальной схемы схемы 
             ,p_conn        := {1}::text    -- Именованное dblink-соединение   
             ,p_mode_t      := {2}::boolean -- TRUE - Эксплутационные, FALSE - Загрузочные
             ,p_mode_c      := {3}::boolean -- TRUE - Создание индексов, FALSE - удаление             
        );
        """        

        #       -- (gar_link.f_conn_set({1}::numeric(3)))
        self.gar_link_p_adr_street_idx = """CALL gar_link.p_adr_street_idx (
                   p_schema_name := '{0}'::text  -- Имя локальной/отдалённой схемы 
                  ,p_conn        := {1}::text    -- Именованное dblink-соединение   
                  ,p_mode_t      := {2}::boolean -- TRUE - Эксплутационные, FALSE - Загрузочные
                  ,p_mode_c      := {3}::boolean -- TRUE - Создание индексов, FALSE - удаление  
                  ,p_uniq_sw     := {4}::boolean -- TRUE - Уникальность "ak1", "ie2" - 
            ); 
        """
        #  Уникальный индекс. -- (gar_link.f_conn_set({1}::numeric(3)))
        self.gar_link_p_adr_street_idx_set_uniq = """CALL gar_link.p_adr_street_idx_set_uniq (
                   p_schema_name := '{0}'::text  -- Имя локальной/отдалённой схемы 
                  ,p_conn        := {1}::text    -- Именованное dblink-соединение   
                  ,p_mode_t      := {2}::boolean -- TRUE - Эксплутационные, FALSE - Загрузочные
                  ,p_uniq_sw     := {3}::boolean -- Уникальность "ak1", "ie2" - TRUE  
        );
        """
        #       -- (gar_link.f_conn_set({1}::numeric(3)))::text
        self.gar_link_p_adr_house_idx = """CALL gar_link.p_adr_house_idx (
                   p_schema_name := '{0}'::text  -- Имя локальной/отдалённой схемы
                  ,p_conn        := {1}::text    -- Именованное dblink-соединение   
                  ,p_mode_t      := {2}::boolean -- TRUE - Эксплутационные, FALSE - Загрузочные
                  ,p_mode_c      := {3}::boolean -- TRUE - Создание индексов, FALSE - удаление  
                  ,p_uniq_sw     := {4}::boolean -- TRUE - Уникальность "ak1", "ie2" - 
            ); 
        """        
        # Уникальный индекс. -- (gar_link.f_conn_set({1}::numeric(3)))        
        self.gar_link_p_adr_house_idx_set_uniq = """CALL gar_link.p_adr_house_idx_set_uniq (
                   p_schema_name := '{0}'::text  -- Имя локальной/отдалённой схемы 
                  ,p_conn        := {1}::text -- Именованное dblink-соединение   
                  ,p_mode_t      := {2}::boolean -- TRUE - Эксплутационные, FALSE - Загрузочные
                  ,p_uniq_sw     := {3}::boolean -- TRUE - Уникальность "ak1", "ie2" - 
            ); 
        """
        
        # Поиск дубликатов
        self.gar_tmp_fp_adr_area_check_twins_local = """SELECT * FROM gar_tmp_pcg_trans.fp_adr_area_check_twins_local (
              p_schema_name      := '{0}':: text 
             ,p_bound_date       := '{1}':: date 
             ,p_schema_hist_name := '{2}':: text 
        );
        """
        self.gar_tmp_fp_adr_street_check_twins_local = """SELECT * FROM gar_tmp_pcg_trans.fp_adr_street_check_twins_local(
              p_schema_name      := '{0}'::text 
             ,p_bound_date       := '{1}'::date 
             ,p_schema_hist_name := '{2}'::text      
        );
        """
        self.gar_tmp_fp_adr_house_check_twins_local = """SELECT * FROM gar_tmp_pcg_trans.fp_adr_house_check_twins_local(
              p_schema_name      := '{0}'::text 
             ,p_bound_date       := '{1}'::date 
             ,p_schema_hist_name := '{2}'::text      
        );
        """
        # Контрольный запрос
        self.check_data_adr = """SELECT count(1) FROM {0}.{1}; 
        """
        # Дополнительный контрольный запрос.
        self.check_data_adr_1 = """SELECT {0} AS qty_{1}; 
        """

        # Простейший Post анализ.
        self.post_adr_area = "{0}"
        self.post_adr_street = "{0}"
        self.post_adr_house = "{0}"

        # Сервис
        self.gar_link_f_show_col_descr = """SELECT * FROM gar_link.f_show_col_descr (
              p_schema_name := '{0}'::varchar(20) -- Наименование схемы
             ,p_obj_name    := '{1}'::varchar(64) -- Наименование объекта
        ) ORDER BY attr_number;        
        """  
        self.get_op_sign_u = """SELECT {0} FROM ONLY {1}.{2} WHERE (op_sign = 'U');"""
        #
        self.part_0 = """DELETE FROM {0}.{1} WHERE {2} = ANY (ARRAY{3}::bigint[]);"""
        self.part_1 = """COPY {0}.{1} ({2}) FROM stdin WITH DELIMITER '|';"""
        self.part_2 = """SELECT {0} FROM ONLY {1}.{2} z INNER JOIN ONLY {1}.{3} x ON (z.{4} = x.{4});
                      """
        self.part_8 = """BEGIN;"""
        self.part_9 = """COMMIT;"""
# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        pp = proc_patterns ()
        #
        print (pp.export_f_version_put)               
        print (pp.export_f_version_by_obj_put)                  

        print (pp.conn)

        print (pp.gar_tmp_p_adr_area_upload)        
        print (pp.gar_tmp_p_adr_street_upload)        
        print (pp.gar_tmp_p_adr_house_upload )        

        print (pp.gar_link_p_adr_area_idx)
        print (pp.gar_link_p_adr_street_idx) 
        print (pp.gar_link_p_adr_street_idx_set_uniq) 
        print (pp.gar_link_p_adr_house_idx ) 
        print (pp.gar_link_p_adr_house_idx_set_uniq ) 
          
        print (pp.gar_tmp_fp_adr_area_check_twins_local)
        print (pp.gar_tmp_fp_adr_street_check_twins_local)
        print (pp.gar_tmp_fp_adr_house_check_twins_local )
        
        print (pp.check_data_adr) 
        print (pp.check_data_adr_1) 
         
        print (pp.post_adr_area) 
        print (pp.post_adr_street) 
        print (pp.post_adr_house) 
        
        sys.exit (0)

#---------------------------------------
    except KeyboardInterrupt as e:
        print ("... Terminated by user: ")
        sys.exit (1)
