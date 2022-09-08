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
    -- -------------------------------------------------------------------------------------
    BEGIN
      ALTER TABLE gar_tmp.adr_street DROP CONSTRAINT IF EXISTS pk_adr_street;
	  ALTER TABLE gar_tmp.adr_street DROP CONSTRAINT IF EXISTS pk_tmp_adr_street;
      DROP INDEX IF EXISTS gar_tmp._xxx_adr_street_ak1;
      DROP INDEX IF EXISTS gar_tmp._xxx_adr_street_ie2;
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
      
      ALTER TABLE gar_tmp.adr_street ADD CONSTRAINT pk_adr_street PRIMARY KEY (id_street);
      
      CREATE UNIQUE INDEX IF NOT EXISTS _xxx_adr_street_ak1
          ON gar_tmp.adr_street USING btree (id_area, upper(nm_street), id_street_type)
          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;
      
      CREATE UNIQUE INDEX IF NOT EXISTS _xxx_adr_street_ie2
          ON gar_tmp.adr_street USING btree (nm_fias_guid ASC NULLS LAST)
          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;      
      
    -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE WARNING 'P_ADR_STREET_LOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_unload (text, bigint, text) 
         IS 'Загрузка фрагмента ОТДАЛЁННОМ справочника адресов улиц';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--    CALL gar_tmp_pcg_trans.p_adr_street_unload (
--                                 'unnsi'
--                                , 24
--                                ,(gar_link.f_conn_set (11))
-- );
--    SELECT count(1) AS qty_adr_street FROM gar_tmp.adr_street; -- 41947
-- SELECT * FROM gar_tmp.adr_street;
