DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_area_upd_single (
                text,     text,         uuid,          boolean 
               ,integer,  varchar(120), varchar(4000), integer,     bigint,      integer
               ,smallint, varchar(11),  varchar(11),   varchar(20), varchar(15)
               ,numeric,  numeric 
               ,boolean
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_area_upd_single (
            p_schema_name   text 
           ,p_schema_h      text 
           ,p_nm_fias_guid  uuid            --  пОИСКОВЫЙ аргумент
           ,p_direct_put    boolean = FALSE -- Способ заполнения NULL-столбцов.           
            --
           ,p_id_country         integer       = NULL -- NOT NULL
           ,p_nm_area            varchar(120)  = NULL -- NOT NULL
           ,p_nm_area_full       varchar(4000) = NULL -- NOT NULL                   
           ,p_id_area_type       integer       = NULL 
           ,p_id_area_parent     bigint        = NULL 
           ,p_kd_timezone        integer       = NULL 
           ,p_pr_detailed        smallint      = NULL -- NOT NULL  
           ,p_kd_oktmo           varchar(11)   = NULL 
           ,p_kd_okato           varchar(11)   = NULL 
           ,p_nm_zipcode         varchar(20)   = NULL 
           ,p_kd_kladr           varchar(15)   = NULL 
           ,p_vl_addr_latitude   numeric       = NULL -- Резерв
           ,p_vl_addr_longitude  numeric       = NULL -- Резерв
           --
           ,p_sw_hist  boolean = TRUE -- Создаётся историческая запись. 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------------
    --    2024-01-22  Обновление записи вне данных их ГАР-ФИАС  
    -- -------------------------------------------------------------------------------     
    DECLARE
      _exec text;
      
      _real_adr_area  gar_tmp.adr_area_t;
      
      
      _select text = $_$
                           SELECT id_area
                                , id_country
                                , nm_area
                                , nm_area_full
                                , id_area_type
                                , id_area_parent
                                , kd_timezone
                                , pr_detailed
                                , kd_oktmo
                                , nm_fias_guid
                                , dt_data_del
                                , id_data_etalon
                                , kd_okato
                                , nm_zipcode
                                , kd_kladr
                                , vl_addr_latitude
                                , vl_addr_longitude
                           FROM %I.adr_area  
                           
                           WHERE (nm_fias_guid = %L) AND
                            (id_data_etalon IS NULL) AND (dt_data_del IS NULL);               
              $_$;
      --
      
    BEGIN
      _exec = format (_select, p_schema_name, p_nm_fias_guid);   
      EXECUTE (_exec) INTO _real_adr_area; 

      IF (_real_adr_area.id_area IS NOT NULL)
        THEN
 --
          CALL gar_tmp_pcg_trans.p_adr_area_upd (
                  p_schema_name := p_schema_name  
                 ,p_schema_h    := p_schema_h  
                  --   ID сохраняется 
                 ,p_id_area     := _real_adr_area.id_area --  bigint    
                 --
                 ,p_id_country   := COALESCE (p_id_country,          _real_adr_area.id_country)::integer   
                 ,p_nm_area      := COALESCE (btrim(p_nm_area),      _real_adr_area.nm_area)::varchar(120)
                 ,p_nm_area_full := COALESCE (btrim(p_nm_area_full), _real_adr_area.nm_area_full)::varchar(4000)
                  --                   --
                 ,p_id_area_type := CASE 
                                      WHEN (NOT p_direct_put)
                                         THEN 
                                              COALESCE (p_id_area_type, _real_adr_area.id_area_type)::integer      
                                      ELSE
                                           p_id_area_type
                                    END 
                  --
                 ,p_id_area_parent := CASE 
                                          WHEN (NOT p_direct_put)
                                           THEN 
                                                COALESCE (p_id_area_parent, _real_adr_area.id_area_parent)::bigint      
                                          ELSE
                                                p_id_area_parent
                                      END
                  --
                 ,p_kd_timezone := CASE 
                                        WHEN (NOT p_direct_put)
                                         THEN 
                                              COALESCE (p_kd_timezone, _real_adr_area.kd_timezone)::integer
                                        ELSE
                                              p_kd_timezone
                                   END
                  --
                 ,p_pr_detailed := COALESCE (p_pr_detailed, _real_adr_area.pr_detailed)::smallint   
                  --
                 ,p_kd_oktmo := CASE 
                                     WHEN (NOT p_direct_put)
                                      THEN 
                                           COALESCE (p_kd_oktmo, _real_adr_area.kd_oktmo)::varchar(11)
                                     ELSE
                                           p_kd_oktmo
                                END
                  --
                 ,p_nm_fias_guid := _real_adr_area.nm_fias_guid::uuid  
                 --
                 ,p_id_data_etalon := NULL::bigint
                 --
                 ,p_kd_okato := CASE 
                                     WHEN (NOT p_direct_put)
                                      THEN 
                                           COALESCE (p_kd_okato, _real_adr_area.kd_okato)::varchar(11)
                                     ELSE
                                           p_kd_okato
                                END 
                 --
                 ,p_nm_zipcode := CASE 
                                     WHEN (NOT p_direct_put)
                                      THEN 
                                           COALESCE (p_nm_zipcode, _real_adr_area.nm_zipcode)::varchar(20)  
                                     ELSE
                                           p_nm_zipcode
                                  END
                 --
                 ,p_kd_kladr := CASE 
                                     WHEN (NOT p_direct_put)
                                      THEN 
                                           COALESCE (p_kd_kladr, _real_adr_area.kd_kladr)::varchar(15)   
                                     ELSE
                                           p_kd_kladr
                                END
                  --
                 ,p_vl_addr_latitude  := COALESCE (p_vl_addr_latitude , _real_adr_area.vl_addr_latitude )::numeric  
                 ,p_vl_addr_longitude := COALESCE (p_vl_addr_longitude, _real_adr_area.vl_addr_longitude)::numeric  
                  --
                 ,p_oper_type_id := NULL  -- ??
                  --
                 ,p_sw  := p_sw_hist                 
          );
      END IF;    
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_area_upd_single 
               (
                text,     text,         uuid,          boolean  
               ,integer,  varchar(120), varchar(4000), integer,     bigint,      integer
               ,smallint, varchar(11),  varchar(11),   varchar(20), varchar(15)
               ,numeric,  numeric 
               ,boolean
)
         IS 'Обновление записи в справочнике адресных пространств, вне данных из ГАР-ФИАС';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:

       -- CALL gar_tmp_pcg_trans.p_adr_area_upd_single ('gar_tmp', 'gar_tmp', '1a91684d-7af5-4f5e-acf3-d33fe8e3351a', p_nm_area := 'Чапаево'); 
       -- 
       -- SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = '1a91684d-7af5-4f5e-acf3-d33fe8e3351a');
       -- SELECT * FROM gar_tmp.adr_area_aux WHERE (id_area = 10461);
       -- SELECT * FROM gar_tmp.adr_area_hist WHERE (id_area = 10461) ORDER BY date_create DESC;
