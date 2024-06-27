DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_upload (text, date, boolean); 

DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_upload (text, text); 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_upload (
              p_lschema_name  text -- локальная схема 
             ,p_fschema_name  text -- отдалённая схема
           )
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- --------------------------------------------------------------------------
    --  2021-12-31 Обратная загрузка обработанного фрагмента ОТДАЛЁННОГО 
    --              справочника адресов домов.
    --  2022-10-20 Вспомогальные таблицы, инкрементальное обновление.
    -- --------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _del text = $_$
         DELETE FROM ONLY %I.adr_house h USING ONLY %I.adr_house_aux z 
                            WHERE (h.id_house = z.id_house) AND (z.op_sign = 'U');    
      $_$;      
      
      _ins text = $_$
                 INSERT INTO %I.adr_house 
                     SELECT 
                              h.id_house           
                             ,h.id_area            
                             ,h.id_street          
                             ,h.id_house_type_1    
                             ,h.nm_house_1         
                             ,h.id_house_type_2    
                             ,h.nm_house_2         
                             ,h.id_house_type_3    
                             ,h.nm_house_3         
                             ,h.nm_zipcode         
                             ,h.nm_house_full      
                             ,h.kd_oktmo           
                             ,h.nm_fias_guid       
                             ,h.dt_data_del        
                             ,h.id_data_etalon     
                             ,h.kd_okato           
                             ,h.vl_addr_latitude   
                             ,h.vl_addr_longitude  
                     FROM ONLY %I.adr_house h
                       INNER JOIN %I.adr_house_aux x ON (h.id_house = x.id_house);
      $_$;			   

    BEGIN
      -- ALTER TABLE %I.adr_objects ADD CONSTRAINT adr_objects_pkey PRIMARY KEY (id_object);
      -- DROP INDEX IF EXISTS %I._xxx_adr_objects_ak1;
      -- DROP INDEX IF EXISTS %I._xxx_adr_objects_ie2;
      --
      _exec := format (_del, p_fschema_name, p_lschema_name); 
      -- RAISE NOTICE '%', _exec;
      EXECUTE _exec;  
      --
      _exec := format (_ins, p_fschema_name, p_lschema_name, p_lschema_name);   
	  -- RAISE NOTICE '%', _exec;      
      EXECUTE _exec;  
      --
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE WARNING 'P_ADR_HOUSE_UPLOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_upload (text, text)
   IS 'Обратная загрузка обработанного фрагмента ОТДАЛЁННОГО справочника адресов домов.';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_house_upload ('gar_tmp', 'unnsi');

