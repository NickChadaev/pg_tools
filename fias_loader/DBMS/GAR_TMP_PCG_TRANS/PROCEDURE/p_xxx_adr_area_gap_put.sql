DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_xxx_adr_area_gap_put (
              gar_tmp.xxx_adr_area_proc_t                   
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_xxx_adr_area_gap_put (
            p_data  gar_tmp.xxx_adr_area_proc_t  
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ------------------------------------------------------------------------------------------
    --  2022-12-03  Создание/Обновление записи в Адресные объекты не прошедшие входной контроль
    --  2023-10-24   ON CONFLICT (nm_fias_guid) DO NOTHING 
    -- ------------------------------------------------------------------------------------------
    BEGIN
      INSERT INTO gar_tmp.xxx_adr_area_gap (
                                             id_area
                                            ,nm_area
                                            ,nm_area_full
                                            ,id_area_type
                                            ,nm_area_type
                                            ,id_area_parent
                                            ,nm_fias_guid_parent
                                            ,kd_oktmo
                                            ,nm_fias_guid
                                            ,kd_okato
                                            ,nm_zipcode
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
                               p_data.id_area
                              ,p_data.nm_area
                              ,p_data.nm_area_full
                              ,p_data.id_area_type
                              ,p_data.nm_area_type
                              ,p_data.id_area_parent
                              ,p_data.nm_fias_guid_parent
                              ,p_data.kd_oktmo
                              ,p_data.nm_fias_guid
                              ,p_data.kd_okato
                              ,p_data.nm_zipcode
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

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_xxx_adr_area_gap_put (gar_tmp.xxx_adr_area_proc_t) 
         IS 'Создание/Обновление записи в Адресные объекты не прошедшие входной контроль';
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


