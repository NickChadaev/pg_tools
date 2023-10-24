DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_xxx_adr_street_gap_put (
              gar_tmp.xxx_adr_street_proc_t                   
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_xxx_adr_street_gap_put (
            p_data  gar_tmp.xxx_adr_street_proc_t  
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------------
    --  2022-12-03  Создание/Обновление записи в Улицы не прошедшие входной контроль 
    --  2023-10-24               ON CONFLICT (nm_fias_guid) DO NOTHING ;
    -- -------------------------------------------------------------------------------
    BEGIN
   
      INSERT INTO gar_tmp.xxx_adr_street_gap (
                                                id_street
                                               ,nm_street
                                               ,nm_street_full
                                               ,id_street_type
                                               ,nm_street_type
                                               ,id_area
                                               ,nm_fias_guid_area
                                               ,nm_fias_guid
                                               ,kd_kladr
                                               ,tree_d
                                               ,level_d
                                               ,obj_level
                                               ,level_name
                                               ,oper_type_id
                                               ,oper_type_name
                                               ,curr_date
                                               ,check_kind
                     )
                      VALUES (
                               p_data.id_street
                              ,p_data.nm_street
                              ,p_data.nm_street_full
                              ,p_data.id_street_type
                              ,p_data.nm_street_type
                              ,p_data.id_area
                              ,p_data.nm_fias_guid_area
                              ,p_data.nm_fias_guid
                              ,p_data.kd_kladr
                              ,p_data.tree_d
                              ,p_data.level_d
                              ,p_data.obj_level
                              ,p_data.level_name
                              ,p_data.oper_type_id
                              ,p_data.oper_type_name
                              ,COALESCE (p_data.curr_date, current_date)
                              ,COALESCE (p_data.check_kind, '0')
                      )
                         ON CONFLICT (nm_fias_guid) DO NOTHING ;
    
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_xxx_adr_street_gap_put (gar_tmp.xxx_adr_street_proc_t) 
         IS 'Создание/Обновление записи в Улицы не прошедшие входной контроль';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:

-- Класс 23 — Нарушение ограничения целостности
-- 23000	integrity_constraint_violation
-- 23001	restrict_violation
-- 23502	not_null_violation
-- 23503	foreign_key_violation
-- 23505	unique_violation
-- 23514	check_violation
-- 23P01	exclusion_violation


