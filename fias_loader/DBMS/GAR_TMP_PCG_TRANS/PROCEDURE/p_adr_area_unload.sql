DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_area_unload (text, bigint, text);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_area_unload (
              p_schema_name   text  
             ,p_id_region     bigint
             ,p_conn          text       -- connection dblink             
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------------------
    --  2022-09-08  Загрузка фрагмента из ОТДАЛЁННОГО справочника адресных регионов.
    --  2022-11-28  Переход к использованию индексного хранилища.
    --  2023-06-14  Фильтрация дублей и прерывание в случае ошибки создания уникального 
    --              индекса      
    -- -------------------------------------------------------------------------------------
    DECLARE
      TMP_SCH constant text = 'gar_tmp'; 
      -- __check  record;
          
    BEGIN
      CALL gar_link.p_adr_area_idx (TMP_SCH, NULL, true, false); -- Убираю эксплуатационные
      CALL gar_link.p_adr_area_idx (TMP_SCH, NULL, false, false); -- Убираю загрузочные
      --
      DELETE FROM ONLY gar_tmp.adr_area;   -- 2022-02-17
      
      INSERT INTO gar_tmp.adr_area (
                                       id_area          
                                      ,id_country       
                                      ,nm_area          
                                      ,nm_area_full     
                                      ,id_area_type     
                                      ,id_area_parent   
                                      ,kd_timezone      
                                      ,pr_detailed      
                                      ,kd_oktmo         
                                      ,nm_fias_guid     
                                      ,dt_data_del      
                                      ,id_data_etalon   
                                      ,kd_okato         
                                      ,nm_zipcode       
                                      ,kd_kladr         
                                      ,vl_addr_latitude 
                                      ,vl_addr_longitude
       ) 
          SELECT * FROM gar_tmp_pcg_trans.f_adr_area_unload_data (
                           p_schema_name
                          ,p_id_region
                          ,p_conn
       );     
       
      -- Процессинговое уникальное покрытие      
      CALL gar_link.p_adr_area_idx (TMP_SCH, NULL, false, true);    
      
     ---  -- Фильрация, бесполезное занятие.
     ---  SELECT * FROM gar_tmp_pcg_trans.fp_adr_area_check_twins_local (TMP_SCH)
     ---       INTO  __check;
     ---  RAISE NOTICE 'CHECK_AREA: %', __check;      
      
    -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'P_ADR_AREA_LOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_area_unload (text, bigint, text) 
         IS 'Загрузка фрагмента ОТДАЛЁННОМ справочника адресных регионов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--    CALL gar_tmp_pcg_trans.p_adr_area_unload ('unnsi',77,(gar_link.f_conn_set (12)));
--    SELECT count(1) AS qty_adr_area FROM gar_tmp.adr_area; -- 9146
--    SELECT * FROM gar_tmp.adr_area; -- 9146
 

