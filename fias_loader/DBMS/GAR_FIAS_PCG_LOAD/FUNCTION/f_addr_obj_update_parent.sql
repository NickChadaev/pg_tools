DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_update_parent (uuid, uuid, date);
CREATE OR REPLACE FUNCTION gar_fias_pcg_load.f_addr_obj_update_parent (
         p_parent_fias_guid_old  uuid
        ,p_parent_fias_guid_new  uuid
        ,p_date                  date = current_date        
  )
    RETURNS integer
    LANGUAGE plpgsql 
    SECURITY DEFINER
    AS $$
    -- =================================================================================
    -- Author: Nick
    -- Create date: 2022-07-08
    -- --------------------------------------------------------------------------------- 
    -- Модификация отношения подчинённости в схеме gar_fias.
    --                        p_parent_fias_guid_old  uuid -- старый родитель
    --                       ,p_parent_fias_guid_new  uuid -- новый родитель
    -- =================================================================================
    DECLARE 
      _id_parent_new   bigint;
      _id_parent_old   bigint;
      
      _r integer := 0;
      
    BEGIN
      _id_parent_new := (SELECT a.object_id FROM gar_fias.as_addr_obj a 
                            WHERE (a.object_guid = p_parent_fias_guid_new) AND (a.end_date > p_date)
                        );    
      --
      _id_parent_old := (SELECT b.object_id FROM gar_fias.as_addr_obj b 
                            WHERE (b.object_guid = p_parent_fias_guid_old) AND (b.end_date > p_date)
                        );    
     
      UPDATE gar_fias.as_adm_hierarchy n SET parent_obj_id = _id_parent_new 
               WHERE (_id_parent_old = n.parent_obj_id) AND (n.is_active);
                    
       GET DIAGNOSTICS _r = ROW_COUNT;

       -- Запомнить это отношение  ("старый" -- "новый") -- отношение   старый,  новый
       
       RETURN _r;
    END;
  $$;

ALTER FUNCTION gar_fias_pcg_load.f_addr_obj_update_parent (uuid, uuid, date) OWNER TO postgres;

COMMENT ON FUNCTION gar_fias_pcg_load.f_addr_obj_update_parent (uuid, uuid, date) 
IS 'Модификация отношения подчинённости в схеме gar_fias. ТОЛЬКО АКТИВНЫЕ И АКТУАЛЬНЫЕ ОБЪЕКТЫ.';
--
--  USE CASE:
--
-- BEGIN;
-- 
-- SELECT gar_fias_pcg_load.f_addr_obj_update_parent ('d2f48256-c10a-4806-b281-9b5b85d56616','21ab76d1-fab6-4b4f-a4dc-4871a93b7aab'); -- 2
-- SELECT a.* FROM gar_fias.as_addr_obj a WHERE (a.object_guid = '21ab76d1-fab6-4b4f-a4dc-4871a93b7aab') ; -- 81637
-- SELECT a.* FROM gar_fias.as_addr_obj a WHERE (a.object_guid = 'd2f48256-c10a-4806-b281-9b5b85d56616') ; -- 81317
-- 
-- SELECT * FROM gar_fias.as_adm_hierarchy where parent_obj_id = 81637 
--     UNION ALL
-- SELECT * FROM gar_fias.as_adm_hierarchy where parent_obj_id = 81317 ;
-- 
-- SELECT * FROM gar_fias_pcg_load."_NEW_f_adr_area_show_data" (p_fias_guid := NULL::uuid, p_qty := 1) ;
-- ROLLBACK;
