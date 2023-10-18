DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_xxx_adr_stead_gap_put (
              gar_tmp.xxx_adr_stead_proc_t                   
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_xxx_adr_stead_gap_put (
            p_data  gar_tmp.xxx_adr_stead_proc_t  
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ------------------------------------------------------------------------------
    --  2023-10-18  Создание/Обновление записи в ЗУ не прошедшие входной контроль
    -- ------------------------------------------------------------------------------
    BEGIN
   
      INSERT INTO gar_tmp.xxx_adr_stead_gap (
                                                 id_stead
                                               , id_addr_parent
                                               , nm_fias_guid
                                               , nm_fias_guid_parent
                                               , nm_parent_obj
                                               , region_code
                                               , parent_type_id
                                               , parent_type_name
                                               , parent_type_shortname
                                               , parent_level_id
                                               , parent_level_name
                                               , stead_num
                                               , stead_cadastr_num
                                               , kd_oktmo
                                               , kd_okato
                                               , nm_zipcode
                                               , oper_type_id
                                               , oper_type_name
                                               , curr_date
                                               , check_kind
       )
                      VALUES (
                                 p_data.id_stead
                                ,p_data.id_addr_parent
                                ,p_data.nm_fias_guid
                                ,p_data.nm_fias_guid_parent
                                ,p_data.nm_parent_obj
                                ,p_data.region_code
                                ,p_data.parent_type_id
                                ,p_data.parent_type_name
                                ,p_data.parent_type_shortname
                                ,p_data.parent_level_id
                                ,p_data.parent_level_name
                                ,p_data.stead_num
                                ,p_data.stead_cadastr_num
                                ,p_data.kd_oktmo
                                ,p_data.kd_okato
                                ,p_data.nm_zipcode
                                ,p_data.oper_type_id
                                ,p_data.oper_type_name
                                ,COALESCE (p_data.curr_date, current_date)
                                ,COALESCE (p_data.check_kind, '0')
                      )
             ON CONFLICT (nm_fias_guid) DO UPDATE
                SET
                       id_stead              = excluded.id_stead
                      ,id_addr_parent        = excluded.id_addr_parent
                      ,nm_fias_guid_parent   = excluded.nm_fias_guid_parent
                      ,nm_parent_obj         = excluded.nm_parent_obj
                      ,region_code           = excluded.region_code
                      ,parent_type_id        = excluded.parent_type_id
                      ,parent_type_name      = excluded.parent_type_name
                      ,parent_type_shortname = excluded.parent_type_shortname
                      ,parent_level_id       = excluded.parent_level_id
                      ,parent_level_name     = excluded.parent_level_name
                      ,stead_num             = excluded.stead_num
                      ,stead_cadastr_num     = excluded.stead_cadastr_num
                      ,kd_oktmo              = excluded.kd_oktmo
                      ,kd_okato              = excluded.kd_okato
                      ,nm_zipcode            = excluded.nm_zipcode
                      ,oper_type_id          = excluded.oper_type_id
                      ,oper_type_name        = excluded.oper_type_name
                      ,curr_date             = COALESCE (excluded.curr_date, current_date)
                      ,check_kind            = COALESCE (excluded.check_kind, '0')
                
                  WHERE (gar_tmp.xxx_adr_stead_gap.nm_fias_guid =  excluded.nm_fias_guid);
    
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_xxx_adr_stead_gap_put (gar_tmp.xxx_adr_stead_proc_t) 
         IS 'Создание/Обновление записи в ЗУ не прошедшие входной контроль';
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


