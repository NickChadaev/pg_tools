DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_type_unload (text, text);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_street_type_unload (
              p_sch_local   text  
             ,p_sch_remote  text
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ---------------------------------------------------------------------------
    --  2022-12-05  Загрузка ОТДАЛЁННОГО справочника типов EKBW.
    -- ---------------------------------------------------------------------------
    DECLARE
     _delete  text = $_$
            DELETE FROM %I.adr_street_type 
     $_$;
     --
     _ins_select  text = $_$
         INSERT INTO %I.adr_street_type 
             SELECT id_street_type, nm_street_type, nm_street_type_short, dt_data_del
                    FROM %I.adr_street_type
                ON CONFLICT (id_street_type) DO NOTHING;
     $_$;
    
    BEGIN
      EXECUTE format (_delete, p_sch_local);
      EXECUTE format (_ins_select, p_sch_local, p_sch_remote);
      
    -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE WARNING 'P_ADR_STREET_TYPE_UNLOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_type_unload (text, text) 
         IS 'Загрузка ОТДАЛЁННОГО справочника типов адресных регионов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
 
-- CALL gar_tmp_pcg_trans.p_adr_street_type_unload ('gar_tmp', 'unnsi'); 
-- SELECT * FROM gar_tmp.adr_street_type ORDER BY 1;; -- gar_tmp.adr_house_type;
-- 
