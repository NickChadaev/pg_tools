DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_upload (text, text); 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_street_upload (
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
         DELETE FROM ONLY %I.adr_street s USING ONLY %I.adr_street_aux z 
                            WHERE (s.id_street = z.id_street) AND (z.op_sign = 'U');    
      $_$;      
      
      _ins text = $_$
                 INSERT INTO %I.adr_street 
                     SELECT 
                              s.id_street            
                             ,s.id_area             
                             ,s.nm_street           
                             ,s.id_street_type       
                             ,s.nm_street_full      
                             ,s.nm_fias_guid         
                             ,s.dt_data_del         
                             ,s.id_data_etalon       
                             ,s.kd_kladr            
                             ,s.vl_addr_latitude    
                             ,s.vl_addr_longitude   
                     FROM ONLY %I.adr_street s
                       INNER JOIN %I.adr_street_aux x ON (s.id_street = x.id_street);
      $_$;			   

    BEGIN
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
          RAISE WARNING 'P_ADR_STREET_UPLOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_upload (text, text)
   IS 'Обратная загрузка обработанного фрагмента ОТДАЛЁННОГО справочника элементов дорожной сети.';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_street_upload ('gar_tmp', 'unnsi');

