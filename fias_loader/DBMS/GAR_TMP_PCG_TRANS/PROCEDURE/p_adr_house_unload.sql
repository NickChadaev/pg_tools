DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_unload (text, bigint, text);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_unload (
              p_schema_name   text  
             ,p_id_region     bigint
             ,p_conn          text       -- connection dblink             
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------------------
    --  2021-12-31/2022-01-28  Загрузка фрагмента из ОТДАЛЁННОГО справочника адресов домов.
    --  2022-11-28  Переход к использованию индексного хранилища.
    --  2023-06-14  Фильтрация дублей и прерывание в случае ошибки создания уникального 
    --              индекса
    -- -------------------------------------------------------------------------------------
    DECLARE
      TMP_SCH constant text = 'gar_tmp'; 
      __check  record;
      
    BEGIN
      CALL gar_link.p_adr_house_idx (TMP_SCH, NULL, true, false); 
      CALL gar_link.p_adr_house_idx (TMP_SCH, NULL, false, false); 
      --
      DELETE FROM ONLY gar_tmp.adr_house;   -- 2022-02-17
      
      -- ЗАМЕЧАНИЕ:  unnsi -- 47 -- c_unnsi_prd_s
      -- ПРЕДУПРЕЖДЕНИЕ:  P_ADR_HOUSE_LOAD: 23505 -- повторяющееся значение ключа нарушает ограничение уникальности "_xxx_adr_house_ie2"
      -- CALL

      INSERT INTO gar_tmp.adr_house (
      
                             id_house           
                            ,id_area            
                            ,id_street          
                            ,id_house_type_1    
                            ,nm_house_1         
                            ,id_house_type_2    
                            ,nm_house_2         
                            ,id_house_type_3    
                            ,nm_house_3         
                            ,nm_zipcode         
                            ,nm_house_full      
                            ,kd_oktmo           
                            ,nm_fias_guid       
                            ,dt_data_del        
                            ,id_data_etalon     
                            ,kd_okato           
                            ,vl_addr_latitude   
                            ,vl_addr_longitude 
       ) 
          SELECT * FROM gar_tmp_pcg_trans.f_adr_house_unload_data (
                                p_schema_name
                               ,p_id_region
                               ,p_conn
          );           
      
      -- Неуникальное процессинговое покрытие      
      CALL gar_link.p_adr_house_idx (TMP_SCH, NULL, false, true, false);    
      
      -- Фильрация
      FOR __check IN 
            SELECT * FROM gar_tmp_pcg_trans.fp_adr_house_check_twins_local (TMP_SCH)
         LOOP 
             RAISE NOTICE 'CHECK_HOUSE: %', __check;      
         END LOOP;
      
      -- Неуникальное процессинговое покрытие ДОЛОЙ     
      CALL gar_link.p_adr_house_idx (TMP_SCH, NULL, false, false);    
      CALL gar_link.p_adr_house_idx (TMP_SCH, NULL, false, true); 
    -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'P_ADR_HOUSE_LOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_unload (text, bigint, text) 
         IS 'Загрузка фрагмента ОТДАЛЁННОМ справочника адресов домов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
-- 
-- ЗАМЕЧАНИЕ:  Point 0
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i1" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i1; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i2" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i2; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i3" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i3; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i4" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i4; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i5" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i5; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i7" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i7; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_idx1" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_idx1; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_ak1" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_ak1; 
-- ЗАМЕЧАНИЕ:  Point 1
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ie2; 
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ak1; 
-- ЗАМЕЧАНИЕ:  Point 2
-- ЗАМЕЧАНИЕ:  unnsi -- 47 -- c_unnsi_prd_s
-- ЗАМЕЧАНИЕ:  Point 3
-- ЗАМЕЧАНИЕ:  Point 4
-- ПРЕДУПРЕЖДЕНИЕ:  P_ADR_HOUSE_LOAD: 23505 -- создать уникальный



-- ЗАМЕЧАНИЕ:  Point 0
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i1" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i1; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i2" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i2; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i3" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i3; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i4" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i4; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i5" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i5; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i7" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i7; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_idx1" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_idx1; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_ak1" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_ak1; 
-- ЗАМЕЧАНИЕ:  Point 1
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ie2; 
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ak1; 
-- ЗАМЕЧАНИЕ:  Point 2
-- ЗАМЕЧАНИЕ:  unnsi -- 47 -- c_unnsi_prd_s
-- ЗАМЕЧАНИЕ:  Point 3
-- ЗАМЕЧАНИЕ:  Point 4
-- ПРЕДУПРЕЖДЕНИЕ:  P_ADR_HOUSE_LOAD: 23505 -- создать уникальный индекс "_xxx_adr_house_ie2" не удалось
-- CALL
-- 
-- Query returned successfully in 2 secs 633 msec.


-- ЗАМЕЧАНИЕ:  Point 0
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i1" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i1; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i2" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i2; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i3" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i3; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i4" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i4; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i5" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i5; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_i7" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_i7; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_idx1" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_idx1; 
-- ЗАМЕЧАНИЕ:  индекс "adr_house_ak1" не существует, пропускается
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp.adr_house_ak1; 
-- ЗАМЕЧАНИЕ:  Point 1
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ie2; 
-- ЗАМЕЧАНИЕ:   DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ak1; 
-- ЗАМЕЧАНИЕ:  Point 2
-- ЗАМЕЧАНИЕ:  unnsi -- 47 -- c_unnsi_prd_s
-- ЗАМЕЧАНИЕ:  Point 3
-- ЗАМЕЧАНИЕ:  Point 4
-- ЗАМЕЧАНИЕ:   CREATE INDEX IF NOT EXISTS _xxx_adr_house_ie2 ON gar_tmp.adr_house USING btree (nm_fias_guid ASC NULLS LAST) WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL); 
-- ЗАМЕЧАНИЕ:   CREATE UNIQUE INDEX IF NOT EXISTS _xxx_adr_house_ak1 ON gar_tmp.adr_house USING btree (id_area ASC NULLS LAST, upper (nm_house_full::text) ASC NULLS LAST, id_street ASC NULLS LAST,id_house_type_1 ASC NULLS LAST)  WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL); 
-- ЗАМЕЧАНИЕ:  Point 5
-- CALL
-- 
-- Query returned successfully in 2 secs 892 msec.

