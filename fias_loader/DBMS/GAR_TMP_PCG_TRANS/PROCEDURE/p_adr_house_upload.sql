DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_upload (text, text); 
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_upload (text); 
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_upload (text, date); 

DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_upload (text, date, boolean); 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_upload (
              p_schema_name  text  
             ,p_date_proc    date = current_date
             ,p_del          boolean = FALSE -- В fp_adr_house убирались дубли при обработки EXCEPTION N 
                                             -- теперь убираю их в основной таблице 
           )
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- --------------------------------------------------------------------------
    --  2021-12-31 Обратная загрузка обработанного фрагмента ОТДАЛЁННОГО 
    --              справочника адресов домов.
    -- --------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _del_tw text = $_$
           WITH z (id_house) AS (
                 SELECT y.id_house FROM ONLY gar_tmp.adr_house y
                   UNION 
                 SELECT x.id_data_etalon FROM gar_tmp.adr_house_hist x 
                    WHERE ((date(x.dt_data_del) = %L) AND (x.id_region = 0)) 
           ) 
            DELETE FROM ONLY %I.adr_house h USING z WHERE (h.id_house = z.id_house);    
      $_$;
      
      _del text = $_$
         DELETE FROM ONLY %I.adr_house h USING ONLY gar_tmp.adr_house z 
                            WHERE (h.id_house = z.id_house);    
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
                     FROM ONLY gar_tmp.adr_house h;
      $_$;			   

    BEGIN
      -- ALTER TABLE %I.adr_objects ADD CONSTRAINT adr_objects_pkey PRIMARY KEY (id_object);
      -- DROP INDEX IF EXISTS %I._xxx_adr_objects_ak1;
      -- DROP INDEX IF EXISTS %I._xxx_adr_objects_ie2;
      --  + Остальные индексы, для таблицы объектов на отдалённом сервере.
      --  dblink-функционал.
      --
      IF p_del 
        THEN
              _exec := format (_del_tw, p_date_proc, p_schema_name);
        ELSE
              _exec := format (_del, p_schema_name); 
      END IF;
	  -- RAISE NOTICE '%', _exec;
      EXECUTE _exec;  
      --
      _exec := format (_ins, p_schema_name);   
	  -- RAISE NOTICE '%', _exec;      
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

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_upload (text, date, boolean) 
   IS 'Обратная загрузка обработанного фрагмента ОТДАЛЁННОГО справочника адресов домов.';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_house_upload ('unnsi');
--     CALL gar_tmp_pcg_trans.p_adr_house_upload ('unsi', current_date);
--     CALL gar_tmp_pcg_trans.p_adr_house_upload ('unsi', current_date, false);
--     CALL gar_tmp_pcg_trans.p_adr_house_upload ('unsi', current_date, true);

