DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_unload (text); 
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_unload (text, bigint); 

DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_unload (text, bigint, text); 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_object_unload (
              p_schema_name   text    -- Имя схемы на отдалённом сервере  
             ,p_id_region     bigint  -- ID региона
             ,p_conn          text    -- Соединение с отдалённым сервером. 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- --------------------------------------------------------------------------
    --  2021-12-31 Загрузка фрагмента ОТДАЛЁННОГО справочника адресных объектов.
    --  2022-01-28 Перегружаю все региональные объекты типа "Дом"
    -- --------------------------------------------------------------------------

    BEGIN
      ALTER TABLE gar_tmp.adr_objects DROP CONSTRAINT IF EXISTS pk_tmp_adr_objects;
      ALTER TABLE gar_tmp.adr_objects DROP CONSTRAINT IF EXISTS pk_adr_objects;
      DROP INDEX IF EXISTS gar_tmp._xxx_adr_objects_ak1;
      DROP INDEX IF EXISTS gar_tmp._xxx_adr_objects_ie2;
      --
      DELETE FROM ONLY gar_tmp.adr_objects; -- 2022-02-17
      --
      INSERT INTO gar_tmp.adr_objects (
               id_object           
              ,id_area             
              ,id_house            
              ,id_object_type      
              ,id_street           
              ,nm_object           
              ,nm_object_full      
              ,nm_description      
              ,dt_data_del         
              ,id_data_etalon      
              ,id_metro_station    
              ,id_autoroad         
              ,nn_autoroad_km      
              ,nm_fias_guid        
              ,nm_zipcode          
              ,kd_oktmo            
              ,kd_okato            
              ,vl_addr_latitude    
              ,vl_addr_longitude  
          )
           SELECT * FROM gar_tmp_pcg_trans.f_adr_object_unload_data (
                     p_schema_name
          			,p_id_region
          			,p_conn 
           );
      --
      ALTER TABLE gar_tmp.adr_objects ADD CONSTRAINT pk_adr_objects PRIMARY KEY (id_object);
      --    
      CREATE UNIQUE INDEX _xxx_adr_objects_ak1
          ON gar_tmp.adr_objects USING btree
          (
             id_area         ASC NULLS LAST
            ,id_object_type ASC NULLS LAST
            ,upper (nm_object_full::text) ASC NULLS LAST
            ,id_street ASC NULLS LAST
            ,id_house   ASC NULLS LAST
          )
          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;
      --      
      CREATE INDEX _xxx_adr_objects_ie2
          ON gar_tmp.adr_objects USING btree
          (nm_fias_guid ASC NULLS LAST)
          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;    
    
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE WARNING 'P_ADR_OBJECT_LOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_object_unload (text, bigint, text) 
   IS ' Загрузка фрагмента ОТДАЛЁННОГО справочника адресных объектов.';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_object_unload ('unnsi', 52, (gar_link.f_conn_set ('c_unnsi_l', 'unnsi_nl')));
-- Query returned successfully in 11 secs 566 msec.
   
-- SELECT * FROM gar_tmp.adr_objects;     -- 813177 rows affected. 




