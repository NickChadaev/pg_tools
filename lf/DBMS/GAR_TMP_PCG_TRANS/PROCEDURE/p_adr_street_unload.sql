DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_unload (text, bigint, text);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_street_unload (
              p_schema_name   text  
             ,p_id_region     bigint
             ,p_conn          text       -- connection dblink             
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------------------
    --  2022-09-28  Загрузка фрагмента из ОТДАЛЁННОГО справочника адресов улиц.
    --  2022-11-28  Переход к использованию индексного хранилища.
    --  2023-06-14  Фильтрация дублей и прерывание в случае ошибки создания уникального 
    --              индекса    
    -- -------------------------------------------------------------------------------------
    DECLARE
      TMP_SCH constant text = 'gar_tmp'; 
      __check  record;
      
    BEGIN
      CALL gar_link.p_adr_street_idx (TMP_SCH, NULL, true, false); 
      CALL gar_link.p_adr_street_idx (TMP_SCH, NULL, false, false); 
      --
      DELETE FROM ONLY gar_tmp.adr_street;   -- 2022-02-17
      
      INSERT INTO gar_tmp.adr_street (
                   id_street          
                  ,id_area          
                  ,nm_street          
                  ,id_street_type     
                  ,nm_street_full     
                  ,nm_fias_guid       
                  ,dt_data_del        
                  ,id_data_etalon     
                  ,kd_kladr           
                  ,vl_addr_latitude   
                  ,vl_addr_longitude  
       ) 
          SELECT * FROM gar_tmp_pcg_trans.f_adr_street_unload_data (
                        p_schema_name
                       ,p_id_region
                       ,p_conn
          );           
      
      -- Неуникальное процессинговое покрытие      
      CALL gar_link.p_adr_street_idx (TMP_SCH, NULL, false, true, false);    
      
      -- Фильрация
      FOR __check IN 
            SELECT * FROM gar_tmp_pcg_trans.fp_adr_street_check_twins_local (TMP_SCH)
         LOOP 
             RAISE NOTICE 'CHECK_STREET: %', __check;      
         END LOOP;
      
      -- Неуникальное процессинговое покрытие ДОЛОЙ     
      CALL gar_link.p_adr_street_idx (TMP_SCH, NULL, false, false);    
      CALL gar_link.p_adr_street_idx (TMP_SCH, NULL, false, true);       
      
    -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'P_ADR_STREET_LOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_unload (text, bigint, text) 
         IS 'Загрузка фрагмента ОТДАЛЁННОМ справочника адресов улиц';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--    CALL gar_tmp_pcg_trans.p_adr_street_unload ('unnsi', 77, (gar_link.f_conn_set (12)));
--    SELECT count(1) AS qty_adr_street FROM gar_tmp.adr_street; -- 10707
--    SELECT * FROM gar_tmp.adr_street WHERE (nm_street ilike '%свободы%');
