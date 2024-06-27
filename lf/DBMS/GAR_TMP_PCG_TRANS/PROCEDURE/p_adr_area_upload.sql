DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_area_upload (text, text); 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_area_upload (
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
         DELETE FROM ONLY %I.adr_area a USING ONLY %I.adr_area_aux z 
                            WHERE (a.id_area = z.id_area) AND (z.op_sign = 'U');    
      $_$;      
      
      _ins text = $_$
                 INSERT INTO %I.adr_area 
                     SELECT 
                              a.id_area          
                             ,a.id_country        
                             ,a.nm_area           
                             ,a.nm_area_full     
                             ,a.id_area_type      
                             ,a.id_area_parent   
                             ,a.kd_timezone       
                             ,a.pr_detailed      
                             ,a.kd_oktmo          
                             ,a.nm_fias_guid      
                             ,a.dt_data_del       
                             ,a.id_data_etalon    
                             ,a.kd_okato          
                             ,a.nm_zipcode        
                             ,a.kd_kladr          
                             ,a.vl_addr_latitude  
                             ,a.vl_addr_longitude 
                     FROM ONLY %I.adr_area a
                       INNER JOIN %I.adr_area_aux x ON (a.id_area = x.id_area);
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
          RAISE WARNING 'P_ADR_AREA_UPLOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_area_upload (text, text)
   IS 'Обратная загрузка обработанного фрагмента ОТДАЛЁННОГО справочника адресных регионов.';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_area_upload ('gar_tmp', 'unnsi');

