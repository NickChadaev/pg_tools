DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_upload (text); 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_object_upload (
              p_schema_name     text  
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- --------------------------------------------------------------------------
    --  2021-12-31 Обратная загрузка обработанного фрагмента ОТДАЛЁННОГО 
    --              справочника адресных объектов.
    -- --------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _del text = $_$
           DELETE FROM ONLY %I.adr_objects x USING ONLY gar_tmp.adr_objects t WHERE (x.id_object = t.id_object);    
      $_$;
      
      _ins text = $_$
           INSERT INTO %I.adr_objects 
               SELECT 
                       x.id_object           
                      ,x.id_area             
                      ,x.id_house            
                      ,x.id_object_type      
                      ,x.id_street           
                      ,x.nm_object           
                      ,x.nm_object_full      
                      ,x.nm_description      
                      ,x.dt_data_del         
                      ,x.id_data_etalon      
                      ,x.id_metro_station    
                      ,x.id_autoroad         
                      ,x.nn_autoroad_km      
                      ,x.nm_fias_guid        
                      ,x.nm_zipcode          
                      ,x.kd_oktmo            
                      ,x.kd_okato            
                      ,x.vl_addr_latitude    
                      ,x.vl_addr_longitude   
               FROM ONLY gar_tmp.adr_objects x;
      $_$;			   

    BEGIN
      -- ALTER TABLE %I.adr_objects ADD CONSTRAINT adr_objects_pkey PRIMARY KEY (id_object);
      -- DROP INDEX IF EXISTS %I._xxx_adr_objects_ak1;
      -- DROP INDEX IF EXISTS %I._xxx_adr_objects_ie2;
      --  + Остальные индексы, для таблицы объектов на отдалённом сервере.
      --  dblink-функционал.
      --
      _exec := format (_del, p_schema_name);            
      EXECUTE _exec;  
      --
      _exec := format (_ins, p_schema_name);            
      EXECUTE _exec;  
      --
      -- + Далее отдалённо, восстанавливается индексное покрытие.     
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE WARNING 'P_ADR_OBJECT_LOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_object_upload (text) 
   IS 'Обратная загрузка обработанного фрагмента ОТДАЛЁННОГО справочника адресных объектов.';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_object_upload ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_object_upload ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);

