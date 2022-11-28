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
    -- -------------------------------------------------------------------------------------
    BEGIN
      CALL gar_link.p_adr_house_idx ('gar_tmp', NULL, true, false); 
      CALL gar_link.p_adr_house_idx ('gar_tmp', NULL, false, false); 
      --
      DELETE FROM ONLY gar_tmp.adr_house;   -- 2022-02-17
      
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
      
      CALL gar_link.p_adr_house_idx ('gar_tmp', NULL, false, true);    
      
    -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE WARNING 'P_ADR_HOUSE_LOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_unload (text, bigint, text) 
         IS 'Загрузка фрагмента ОТДАЛЁННОМ справочника адресов домов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--    CALL gar_tmp_pcg_trans.p_adr_house_unload ('unnsi', 77, (gar_link.f_conn_set (12)));
--    SELECT count(1) AS qty_adr_house FROM gar_tmp.adr_house; --  265324
--    SELECT * FROM gar_tmp.adr_house; -- 
