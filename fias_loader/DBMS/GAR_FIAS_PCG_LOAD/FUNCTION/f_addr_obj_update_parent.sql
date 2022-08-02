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
    --                       ,p_parent_fias_guid_new  uuid -- новый родтель
    -- =================================================================================
    DECLARE 
      _id_parent_new   bigint;
      _r integer := 0;
      
    BEGIN
      _id_parent_new := (SELECT a.object_id FROM gar_fias.as_addr_obj a 
                            WHERE (a.object_guid = p_parent_fias_guid_new) AND
                                  (a.is_actual) AND (a.is_active) AND 
                                  (a.end_date > p_date) AND (a.start_date <= p_date)
                          );
      WITH z (
                 id_addr_obj
      )
       AS (
            SELECT id_addr_obj
                 FROM gar_fias_pcg_load.f_adr_area_show_data (p_parent_fias_guid_old::uuid)
                            WHERE (level_d > 1) 
          )
          UPDATE gar_fias.as_adm_hierarchy n SET parent_obj_id = _id_parent_new 
                FROM z
                    WHERE (z.id_addr_obj = n.object_id) AND (n.is_active)
                      AND (n.end_date > p_date) AND (n.start_date <= p_date);
    
       GET DIAGNOSTICS _r = ROW_COUNT;
       RETURN _r;
    END;
  $$;

ALTER FUNCTION gar_fias_pcg_load.f_addr_obj_update_parent (uuid, uuid, date) OWNER TO postgres;

COMMENT ON FUNCTION gar_fias_pcg_load.f_addr_obj_update_parent (uuid, uuid, date) 
IS 'Модификация отношения подчинённости в схеме gar_fias. ТОЛЬКО АКТИВНЫЕ И АКТУАЛЬНЫЕ ОБЪЕКТЫ.';
--
--  USE CASE:
--
-- SELECT gar_fias_pcg_load.f_addr_obj_update_parent ('80a6adb4-a120-4f45-9a50-646ee565d37a', 'b0aa0895-e596-4a25-a0aa-0c69c83f0f9e')

-- SELECT * FROM gar_fias_pcg_load.f_adr_area_show_data ('b0aa0895-e596-4a25-a0aa-0c69c83f0f9e'::uuid);
-- SELECT * FROM gar_fias_pcg_load.f_adr_area_show_data ('80a6adb4-a120-4f45-9a50-646ee565d37a'::uuid);
