DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_unload (text);
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_unload (text, bigint);

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
    -- -------------------------------------------------------------------------------------
    BEGIN
      ALTER TABLE gar_tmp.adr_house DROP CONSTRAINT IF EXISTS pk_adr_house;
      ALTER TABLE gar_tmp.adr_house DROP CONSTRAINT IF EXISTS pk_tmp_adr_house;
      DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ak1;
      DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ie2;
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
      
      ALTER TABLE gar_tmp.adr_house ADD CONSTRAINT pk_adr_house PRIMARY KEY (id_house);
      
      CREATE UNIQUE INDEX IF NOT EXISTS _xxx_adr_house_ak1
          ON gar_tmp.adr_house USING btree
          ( id_area ASC NULLS LAST
           ,upper(nm_house_full::text) ASC NULLS LAST
           ,id_street ASC NULLS LAST
           ,id_house_type_1 ASC NULLS LAST           
          )
          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;
      
      CREATE UNIQUE INDEX IF NOT EXISTS _xxx_adr_house_ie2
          ON gar_tmp.adr_house USING btree
          (nm_fias_guid ASC NULLS LAST)
          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;      
      
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
--    CALL gar_tmp_pcg_trans.p_adr_house_unload (
--                                 'unnsi'
--                                , 52
--                                ,(gar_link.f_conn_set ('c_unnsi_l', 'unnsi_nl'))
-- );
--    SELECT count(1) AS qty_adr_house FROM gar_tmp.adr_house; -- 891734
-- 265508,950 мс (04:25,509)

