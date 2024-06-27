DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.fp_adr_house_upd_single (
                 text, text, uuid, boolean
                ,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                ,bigint,varchar(11),numeric,numeric
                ,boolean, boolean, boolean
 ); 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.fp_adr_house_upd_single (
              p_schema_name   text   -- Схема с данными
             ,p_schema_h      text   -- Историческая схема
             ,p_nm_fias_guid  uuid   -- Поисковый аргумент 
             ,p_direct_put    boolean = FALSE -- Способ заполнения NULL-столбцов.             
               --
             ,p_id_house           bigint       = NULL  --  NOT NULL
             ,p_id_area            bigint       = NULL  --  NOT NULL
             ,p_id_street          bigint       = NULL  --    NULL
             ,p_id_house_type_1    integer      = NULL  --    NULL
             ,p_nm_house_1         varchar(70)  = NULL  --    NULL
             ,p_id_house_type_2    integer      = NULL  --    NULL
             ,p_nm_house_2         varchar(50)  = NULL  --    NULL
             ,p_id_house_type_3    integer      = NULL  --    NULL
             ,p_nm_house_3         varchar(50)  = NULL  --    NULL
             ,p_nm_zipcode         varchar(20)  = NULL  --    NULL
             ,p_nm_house_full      varchar(250) = NULL  --  NOT NULL
             ,p_kd_oktmo           varchar(11)  = NULL  --    NULL
             ,p_id_data_etalon     bigint       = NULL  --    NULL
             ,p_kd_okato           varchar(11)  = NULL  --    NULL
             ,p_vl_addr_latitude   numeric      = NULL  --  Резерв
             ,p_vl_addr_longitude  numeric      = NULL  --  Резерв 
             --
             ,p_sw    boolean = TRUE  -- Создаётся историческая запись.  
             ,p_duble boolean = FALSE -- Обязательное выявление дубликатов
             ,p_del   boolean = FALSE -- Убираю дубли при обработки EXCEPTION              
             
)
    LANGUAGE plpgsql SECURITY DEFINER
    
    AS $$
    -- -----------------------------------------------------------------------------
--     --    2024-01-22  Обновление записи вне данных их ГАР-ФИАС  
    -- -------------------------------------------------------------------------------     
    
    DECLARE
      _exec            text;
      _real_adr_house  gar_tmp.adr_house_t;
      _id_houses       bigint[];       
     --      
      _select text = $_$
                        SELECT  
                            id_house          -- bigint        NOT NULL
                           ,id_area           -- bigint        NOT NULL
                           ,id_street         -- bigint         NULL
                           ,id_house_type_1   -- integer        NULL
                           ,nm_house_1        -- varchar(70)    NULL
                           ,id_house_type_2   -- integer        NULL
                           ,nm_house_2        -- varchar(50)    NULL
                           ,id_house_type_3   -- integer        NULL
                           ,nm_house_3        -- varchar(50)    NULL
                           ,nm_zipcode        -- varchar(20)    NULL
                           ,nm_house_full     -- varchar(250)  NOT NULL
                           ,kd_oktmo          -- varchar(11)    NULL
                           ,nm_fias_guid      -- uuid           NULL 
                           ,dt_data_del       -- timestamp without time zone NULL
                           ,id_data_etalon    -- bigint        NULL
                           ,kd_okato          -- varchar(11)   NULL
                           ,vl_addr_latitude  -- numeric       NULL
                           ,vl_addr_longitude -- numeric       NULL

                        FROM %I.adr_house
                        
                        WHERE (nm_fias_guid = %L) AND
                         (id_data_etalon IS NULL) AND (dt_data_del IS NULL);               
              $_$;
      
    BEGIN
      _exec = format (_select, p_schema_name, p_nm_fias_guid);   
      EXECUTE (_exec) INTO _real_adr_house; 

      IF (_real_adr_house.id_house IS NOT NULL)
        THEN
            _id_houses := gar_tmp_pcg_trans.fp_adr_house_upd (
            
                p_schema_name := p_schema_name
               ,p_schema_h    := p_schema_h   -- Историческая схема
                 --
               ,p_id_house  := _real_adr_house.id_house::bigint  --  NOT NULL
               ,p_id_area   :=  COALESCE (p_id_area, _real_adr_house.id_area)::bigint         --  NOT NULL
               ,p_id_street :=  CASE 
                                    WHEN (NOT p_direct_put)
                                       THEN 
                                          COALESCE (p_id_street, _real_adr_house.id_street)::bigint     
                                    ELSE
                                         p_id_street
                                END 
                --
               ,p_id_house_type_1 := CASE 
                                       WHEN (NOT p_direct_put)
                                          THEN 
                                             COALESCE (p_id_house_type_1, _real_adr_house.id_house_type_1)::integer   
                                       ELSE
                                            p_id_house_type_1
                                     END
                --              
               ,p_nm_house_1 := CASE 
                                     WHEN (NOT p_direct_put)
                                        THEN 
                                           COALESCE (p_nm_house_1, _real_adr_house.nm_house_1)::varchar(70)   
                                     ELSE
                                          p_nm_house_1
                                END
                --
               ,p_id_house_type_2 := CASE 
                                       WHEN (NOT p_direct_put)
                                          THEN 
                                             COALESCE (p_id_house_type_2, _real_adr_house.id_house_type_2)::integer   
                                       ELSE
                                            p_id_house_type_2
                                     END
                --
               ,p_nm_house_2  := CASE 
                                     WHEN (NOT p_direct_put)
                                        THEN 
                                           COALESCE (p_nm_house_2, _real_adr_house.nm_house_2)::varchar(50)   
                                     ELSE
                                          p_nm_house_2
                                 END
                --
               ,p_id_house_type_3 := CASE 
                                       WHEN (NOT p_direct_put)
                                          THEN 
                                             COALESCE (p_id_house_type_3, _real_adr_house.id_house_type_3)::integer   
                                       ELSE
                                            p_id_house_type_3
                                     END
                --              
               ,p_nm_house_3 := CASE 
                                     WHEN (NOT p_direct_put)
                                        THEN 
                                           COALESCE (p_nm_house_3, _real_adr_house.nm_house_3)::varchar(50)   
                                     ELSE
                                          p_nm_house_3
                                END
                --
               ,p_nm_zipcode := CASE 
                                     WHEN (NOT p_direct_put)
                                        THEN 
                                           COALESCE (p_nm_zipcode, _real_adr_house.nm_zipcode)::varchar(20)  
                                     ELSE
                                          p_nm_zipcode
                                END
               --
               ,p_nm_house_full := COALESCE (p_nm_house_full, _real_adr_house.nm_house_full)::varchar(250) --  NOT NULL
               --                 
               ,p_kd_oktmo := CASE 
                                   WHEN (NOT p_direct_put)
                                      THEN 
                                         COALESCE (p_kd_oktmo, _real_adr_house.kd_oktmo)::varchar(11)  
                                   ELSE
                                        p_kd_oktmo
                              END
               --
               ,p_nm_fias_guid   := _real_adr_house.nm_fias_guid::uuid      
               ,p_id_data_etalon := NULL::bigint                            
               --
               ,p_kd_okato := CASE 
                                   WHEN (NOT p_direct_put)
                                      THEN 
                                         COALESCE (p_kd_okato, _real_adr_house.kd_okato)::varchar(11)  
                                   ELSE
                                        p_kd_okato
                              END
               -- 
               ,p_vl_addr_latitude  := COALESCE(p_vl_addr_latitude,  _real_adr_house.vl_addr_latitude)::numeric      --  NULL
               ,p_vl_addr_longitude := COALESCE(p_vl_addr_longitude, _real_adr_house.vl_addr_longitude)::numeric      --  NULL 
               --
               ,p_sw    := p_sw     -- Создаётся историческая запись.  
               ,p_duble := p_duble  -- Обязательное выявление дубликатов   
               ,p_del   := p_del    -- Убираю дубли при обработки EXCEPTION               
            );  
      END IF;             
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.fp_adr_house_upd_single(
                 text, text, uuid, boolean
                ,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                ,bigint,varchar(11),numeric,numeric
                ,boolean, boolean, boolean
 )
         IS 'Обновление записи вне данных их ГАР-ФИАС справочник адресов домов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.fp_adr_house_upd_single ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.fp_adr_house_upd_single ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);

