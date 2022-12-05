DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_area_type_unload (text, text);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_area_type_unload (
              p_sch_local  text  
             ,p_sch_remote text
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ---------------------------------------------------------------------------
    --  2022-12-05  Загрузка ОТДАЛЁННОГО справочника типов адресных регионов.
    -- ---------------------------------------------------------------------------
    DECLARE
     _delete  text = $_$
            DELETE FROM %I.adr_area_type 
     $_$;
     --
     _ins_select  text = $_$
         INSERT INTO %I.adr_area_type 
             SELECT id_area_type, nm_area_type, nm_area_type_short, pr_lead, dt_data_del
                    FROM %I.adr_area_type
                ON CONFLICT (id_area_type) DO NOTHING;
     $_$;
     
    BEGIN
      EXECUTE format (_delete, p_sch_local);
      EXECUTE format (_ins_select, p_sch_local, p_sch_remote);
      
    -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE WARNING 'P_ADR_AREA_TYPE_UNLOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_area_type_unload (text, text) 
         IS 'Загрузка ОТДАЛЁННОГО справочника типов адресных регионов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
 
-- CALL gar_tmp_pcg_trans.p_adr_area_type_unload ('gar_tmp', 'unnsi'); 
-- SELECT * FROM gar_tmp.adr_area_type ORDER BY 1;; -- gar_tmp.adr_house_type;
