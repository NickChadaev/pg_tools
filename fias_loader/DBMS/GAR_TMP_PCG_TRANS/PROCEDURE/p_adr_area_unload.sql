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
    -- -------------------------------------------------------------------------------------
    BEGIN
      ALTER TABLE gar_tmp.adr_area DROP CONSTRAINT IF EXISTS pk_adr_area;
      ALTER TABLE gar_tmp.adr_area DROP CONSTRAINT IF EXISTS pk_tmp_adr_area;
      DROP INDEX IF EXISTS gar_tmp._xxx_adr_area_ak1;
      DROP INDEX IF EXISTS gar_tmp._xxx_adr_area_ie2;
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
      
      ALTER TABLE gar_tmp.adr_area ADD CONSTRAINT pk_adr_area PRIMARY KEY (id_area);
      
      CREATE UNIQUE INDEX IF NOT EXISTS _xxx_adr_area_ak1
          ON gar_tmp.adr_area USING btree
                (id_country, id_area_parent, id_area_type, upper(nm_area::text))
          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;
      
      CREATE UNIQUE INDEX IF NOT EXISTS _xxx_adr_area_ie2
          ON gar_tmp.adr_area USING btree
          (nm_fias_guid ASC NULLS LAST)
          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;      
      
    -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE WARNING 'P_ADR_AREA_LOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_area_unload (text, bigint, text) 
         IS 'Загрузка фрагмента ОТДАЛЁННОМ справочника адресных регионов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--    CALL gar_tmp_pcg_trans.p_adr_area_unload (
--                                 'unnsi'
--                                , 24
--                                ,(gar_link.f_conn_set (11))
-- );
--    SELECT count(1) AS qty_adr_area FROM gar_tmp.adr_area; -- 5076
--    SELECT * FROM gar_tmp.adr_area; -- 5076
 

