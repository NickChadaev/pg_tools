DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_upd_single (
                text, text, uuid, boolean
               ,bigint, varchar(120), integer, varchar(255)      
               ,varchar(15), numeric, numeric, boolean, boolean                             
 );  
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_street_upd_single (
             p_schema_name      text
            ,p_schema_h         text
            ,p_nm_fias_guid     uuid   --  Аргумент поиска.
            ,p_direct_put       boolean = FALSE -- Способ заполнения NULL-столбцов.
             --
            ,p_id_area           bigint       = NULL  -- NOT NULL 
            ,p_nm_street         varchar(120) = NULL  -- NOT NULL 
            ,p_id_street_type    integer      = NULL  --     NULL 
            ,p_nm_street_full    varchar(255) = NULL  -- NOT NULL 
            ,p_kd_kladr          varchar(15)  = NULL  --     NULL  
            ,p_vl_addr_latitude  numeric      = NULL  --  Резерв
            ,p_vl_addr_longitude numeric      = NULL  --  Резерв 
            
             --
            ,p_sw     boolean = TRUE  -- Создаём историю, либо нет 
            ,p_duble  boolean = FALSE -- Обязательное выявление дубликатов
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -----------------------------------------------------------------------------------
    --   2024-01-23 Обновление записи в справочнике элементов ДТС, вне данных из ГАР-ФИАС
    -- -----------------------------------------------------------------------------------
    
    DECLARE
      _exec   text;
      
      _real_adr_street  gar_tmp.adr_street_t;
      
      _select  text = $_$
                      SELECT id_street
                           , id_area
                           , nm_street
                           , id_street_type
                           , nm_street_full
                           , nm_fias_guid
                           , dt_data_del
                           , id_data_etalon
                           , kd_kladr
                           , vl_addr_latitude
                           , vl_addr_longitude
                           
                          FROM %I.adr_street 
                           
                      WHERE (nm_fias_guid = %L) AND
                            (id_data_etalon IS NULL) AND (dt_data_del IS NULL);                            
      $_$;
  
    BEGIN
      _exec = format (_select, p_schema_name, p_nm_fias_guid);   
      EXECUTE (_exec) INTO _real_adr_street; 

      RAISE NOTICE '%', _real_adr_street;      
      
      IF (_real_adr_street.id_street IS NOT NULL)
        THEN    
    
          CALL gar_tmp_pcg_trans.p_adr_street_upd (
          
              p_schema_name := p_schema_name                   
             ,p_schema_h    := p_schema_h     
              --               
             ,p_id_street   := _real_adr_street.id_street    
              --                
             ,p_id_area        := COALESCE (p_id_area,          _real_adr_street.id_area)::bigint              
             ,p_nm_street      := COALESCE (btrim(p_nm_street), _real_adr_street.nm_street)::varchar(120)      
             ,p_id_street_type := CASE 
                                      WHEN (NOT p_direct_put)
                                         THEN 
                                            COALESCE (p_id_street_type, _real_adr_street.id_street_type)::integer      
                                      ELSE
                                           p_id_street_type
                                  END   
                                   
             ,p_nm_street_full := COALESCE (btrim(p_nm_street_full), _real_adr_street.nm_street_full)::varchar(255)
              --                
             ,p_nm_fias_guid   := _real_adr_street.nm_fias_guid::uuid          
             ,p_id_data_etalon :=  NULL::bigint    
             --  
             ,p_kd_kladr := CASE 
                               WHEN (NOT p_direct_put)
                                  THEN 
                                     COALESCE (p_kd_kladr, _real_adr_street.kd_kladr)::varchar(15)      
                               ELSE
                                    p_kd_kladr
                            END               
             
             ,p_vl_addr_latitude  := COALESCE (p_vl_addr_latitude, _real_adr_street.vl_addr_latitude)::numeric       
             ,p_vl_addr_longitude := COALESCE (p_vl_addr_longitude, _real_adr_street.vl_addr_longitude)::numeric     
              -- 
             ,p_oper_type_id := NULL   
             ,p_sw    := p_sw   
             ,p_duble := p_duble
          );
          
      END IF;	
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_upd_single (
                text, text, uuid, boolean
               ,bigint, varchar(120), integer, varchar(255)      
               ,varchar(15), numeric, numeric, boolean, boolean                             
 ) 
         IS 'Обновление записи в справочнике элементов ДТС, вне данных из ГАР-ФИАС';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_street_upd_single ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_street_upd_single ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);


     
 
      
