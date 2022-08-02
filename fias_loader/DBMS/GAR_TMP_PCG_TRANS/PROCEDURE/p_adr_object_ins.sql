DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_ins (
                text, bigint, bigint, bigint, integer, bigint, varchar(250), varchar(500), varchar(150) 
                     ,bigint, integer, integer, numeric, uuid, varchar(20), varchar(11), varchar(11)
                     ,numeric, numeric                           
 ); 
--
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_ins (
                 text, text
                ,bigint, bigint, bigint, integer, bigint, varchar(250), varchar(500), varchar(150) 
                ,bigint, integer, integer, numeric, uuid, varchar(20), varchar(11), varchar(11)
                ,numeric, numeric, boolean                           
 ); 
 CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_object_ins (
              p_schema_name        text  
             ,p_schema_h           text 
               --
             ,p_id_object         bigint       --  NOT NULL
             ,p_id_area           bigint       --  NOT NULL
             ,p_id_house          bigint       --      NULL
             ,p_id_object_type    integer      --  NOT NULL
             ,p_id_street         bigint       --      NULL
             ,p_nm_object         varchar(250) --      NULL
             ,p_nm_object_full    varchar(500) --  NOT NULL
             ,p_nm_description    varchar(150) --      NULL
             ,p_id_data_etalon    bigint       --      NULL
             ,p_id_metro_station  integer      --      NULL
             ,p_id_autoroad       integer      --      NULL
             ,p_nn_autoroad_km    numeric      --      NULL
             ,p_nm_fias_guid      uuid         --      NULL
             ,p_nm_zipcode        varchar(20)  --      NULL
             ,p_kd_oktmo          varchar(11)  --      NULL
             ,p_kd_okato          varchar(11)  --      NULL
             ,p_vl_addr_latitude  numeric      --      NULL
             ,p_vl_addr_longitude numeric      --      NULL
             --
             ,p_sw  boolean                
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ------------------------------------------------------------------------------------
    --   2021-12-17 Создание/Обновление записи в ОТДАЛЁННОМ справочнике адресных объектов
    --   2022-02-07 Переход на базовые типы.
    --   2022-02-11 История в отдельной схеме.
    --   2022-02-21 ONLY для UPDATE, SELECT, DELETE.
    -- ------------------------------------------------------------------------------------
    DECLARE
      _exec text;
     
      _ins text = $_$
               INSERT INTO %I.adr_objects (
                              id_object        --  NOT NULL
                             ,id_area          --  NOT NULL
                             ,id_house         --      NULL
                             ,id_object_type   --  NOT NULL
                             ,id_street        --      NULL
                             ,nm_object        --      NULL
                             ,nm_object_full   --  NOT NULL
                             ,nm_description   --      NULL
                             ,dt_data_del      --      NULL    
                             ,id_data_etalon   --      NULL
                             ,id_metro_station --      NULL
                             ,id_autoroad      --      NULL
                             ,nn_autoroad_km   --      NULL
                             ,nm_fias_guid     --      NULL
                             ,nm_zipcode       --      NULL
                             ,kd_oktmo         --      NULL
                             ,kd_okato         --      NULL
                             ,vl_addr_latitude --      NULL
                             ,vl_addr_longitude --      NULL
               )
                 VALUES (   %L::bigint                  
                           ,%L::bigint                  
                           ,%L::bigint                   
                           ,%L::integer                 
                           ,%L::bigint                   
                           ,%L::varchar(250)            
                           ,%L::varchar(500)             
                           ,%L::varchar(150)   
                           ,%L::timestamp without time zone
                           ,%L::bigint                   
                           ,%L::integer     
                           ,%L::integer                 
                           ,%L::numeric                  
                           ,%L::uuid                    
                           ,%L::varchar(20)             
                           ,%L::varchar(11)              
                           ,%L::varchar(11)             
                           ,%L::numeric                  
                           ,%L::numeric                 
                 );      
              $_$;
              
      -- 2022-02-11
      _ins_hist text = $_$
               INSERT INTO %I.adr_objects_hist (
                              id_object        --  NOT NULL
                             ,id_area          --  NOT NULL
                             ,id_house         --      NULL
                             ,id_object_type   --  NOT NULL
                             ,id_street        --      NULL
                             ,nm_object        --      NULL
                             ,nm_object_full   --  NOT NULL
                             ,nm_description   --      NULL
                             ,dt_data_del      --      NULL    
                             ,id_data_etalon   --      NULL
                             ,id_metro_station --      NULL
                             ,id_autoroad      --      NULL
                             ,nn_autoroad_km   --      NULL
                             ,nm_fias_guid     --      NULL
                             ,nm_zipcode       --      NULL
                             ,kd_oktmo         --      NULL
                             ,kd_okato         --      NULL
                             ,vl_addr_latitude --      NULL
                             ,vl_addr_longitude --     NULL
                             ,id_region
               )
                 VALUES (   %L::bigint                  
                           ,%L::bigint                  
                           ,%L::bigint                   
                           ,%L::integer                 
                           ,%L::bigint                   
                           ,%L::varchar(250)            
                           ,%L::varchar(500)             
                           ,%L::varchar(150)   
                           ,%L::timestamp without time zone
                           ,%L::bigint                   
                           ,%L::integer     
                           ,%L::integer                 
                           ,%L::numeric                  
                           ,%L::uuid                    
                           ,%L::varchar(20)             
                           ,%L::varchar(11)              
                           ,%L::varchar(11)             
                           ,%L::numeric                  
                           ,%L::numeric
                           ,%L::bigint
                 );      
              $_$;
              -- 2022-02-11
              
      _upd text = $_$
                      UPDATE ONLY %I.adr_objects SET  
                      
                              ,nm_object         = COALESCE (%L, nm_object     )::varchar(250)    --  NULL
                              ,nm_description    = COALESCE (%L, nm_description)::varchar(150)    --  NULL
                              ,dt_data_del       = %L::timestamp without time zone  --  NULL
                              ,id_data_etalon    = %L::bigint                       --  NULL
                              ,id_metro_station  = COALESCE (%L, id_metro_station )::integer         -- NOT NULL
                              ,id_autoroad       = COALESCE (%L, id_autoroad      )::integer         --  NULL
                              ,nn_autoroad_km    = COALESCE (%L, nn_autoroad_km   )::numeric         
                              ,nm_fias_guid      = COALESCE (%L, nm_fias_guid     )::uuid            --  NULL
                              ,nm_zipcode        = COALESCE (%L, nm_zipcode       )::varchar(20)     --  NULL
                              ,kd_oktmo          = COALESCE (%L, kd_oktmo         )::varchar(11)     --  NULL
                              ,kd_okato          = COALESCE (%L, kd_okato         )::varchar(11)     --  NULL          
                              ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric         --  NULL
                              ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric         --  NULL
                                                        
                      WHERE ((id_area = %L) AND (id_object_type = %L) AND 
                             (upper(nm_object_full::text) = upper(%L)) AND
                             (id_street IS NOT DISTINCT FROM  %L) AND 
                             (id_house IS NOT DISTINCT FROM %L) AND 
                             (id_data_etalon IS NULL) AND (dt_data_del IS NULL)
                            );   
        $_$;  

      _rr  gar_tmp.adr_objects_t;   
      
    BEGIN
      _exec := format (_ins, p_schema_name
                       ,p_id_object         --  bigint       --  NOT NULL
                       ,p_id_area           --  bigint       --  NOT NULL
                       ,p_id_house          --  bigint       --      NULL
                       ,p_id_object_type    --  integer      --  NOT NULL
                       ,p_id_street         --  bigint       --      NULL
                       ,p_nm_object         --  varchar(250) --      NULL
                       ,p_nm_object_full    --  varchar(500) --  NOT NULL
                       ,p_nm_description    --  varchar(150) --      NULL
                       ,NULL                -- 
                       ,NULL                --  id_data_etalon    --  bigint       --      NULL
                       ,p_id_metro_station  --  integer      --      NULL
                       ,p_id_autoroad       --  integer      --      NULL
                       ,p_nn_autoroad_km    --  numeric      --      NULL
                       ,p_nm_fias_guid      --  uuid         --      NULL
                       ,p_nm_zipcode        --  varchar(20)  --      NULL
                       ,p_kd_oktmo          --  varchar(11)  --      NULL
                       ,p_kd_okato          --  varchar(11)  --      NULL
                       ,p_vl_addr_latitude  --  numeric      --      NULL
                       ,p_vl_addr_longitude --  numeric      --      NULL
      );            
      EXECUTE _exec;

    EXCEPTION  -- Возникает на отдалённом сервере            
       WHEN unique_violation THEN 
        BEGIN
          _rr := gar_tmp_pcg_trans.f_adr_object_get (p_schema_name, p_id_area, p_id_object_type
                                   ,p_nm_object_full , p_id_street, p_id_house
          ); 
           
          IF (_rr.id_object IS NOT NULL) 
            THEN 
                  -- Запоминаю старые с новым ID
                  _exec := format (_ins_hist, p_schema_h
                  
                         ,nextval ('gar_tmp.obj_hist_seq')       --  bigint    --  NOT NULL
                         ,_rr.id_area           --  bigint       --  NOT NULL
                         ,_rr.id_house          --  bigint       --      NULL
                         ,_rr.id_object_type    --  integer      --  NOT NULL
                         ,_rr.id_street         --  bigint       --      NULL
                         ,_rr.nm_object         --  varchar(250) --      NULL
                         ,_rr.nm_object_full    --  varchar(500) --  NOT NULL
                         ,_rr.nm_description    --  varchar(150) --      NULL
                         ,now()
                         ,_rr.id_object        -- id_data_etalon    --  bigint       --      NULL
                         ,_rr.id_metro_station  --  integer      --      NULL
                         ,_rr.id_autoroad       --  integer      --      NULL
                         ,_rr.nn_autoroad_km    --  numeric      --      NULL
                         ,_rr.nm_fias_guid      --  uuid         --      NULL
                         ,_rr.nm_zipcode        --  varchar(20)  --      NULL
                         ,_rr.kd_oktmo          --  varchar(11)  --      NULL
                         ,_rr.kd_okato          --  varchar(11)  --      NULL
                         ,_rr.vl_addr_latitude  --  numeric      --      NULL
                         ,_rr.vl_addr_longitude --  numeric      --      NULL
                          --
                         ,0 -- Регион "0" - Исключение во время процесса дополнения.                              
                  );            
                  EXECUTE _exec;  
          END IF;
          --
          -- update, используя атрибуты образующие уникальность отдельной записи.  
          --            
          _exec := format (_upd, p_schema_name
         
                     ,p_nm_object         
                     ,p_nm_description    
                     ,NULL   -- dt_data_del       
                     ,NULL   -- id_data_etalon    
                     ,p_id_metro_station  
                     ,p_id_autoroad       
                     ,p_nn_autoroad_km    
                     ,p_nm_fias_guid      
                     ,p_nm_zipcode        
                     ,p_kd_oktmo          
                     ,p_kd_okato                 
                     ,p_vl_addr_latitude  
                     ,p_vl_addr_longitude
                     --
                     ,p_id_area           
                     ,p_id_object_type    
                     ,p_nm_object_full    
                     ,p_id_street         
                     ,p_id_house          
           ); 
          EXECUTE _exec;          
        END;  
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_object_ins (
                 text, text
                ,bigint, bigint, bigint, integer, bigint, varchar(250), varchar(500), varchar(150) 
                ,bigint, integer, integer, numeric, uuid, varchar(20), varchar(11), varchar(11)
                ,numeric, numeric, boolean                               
) 
         IS 'Создание записи в ОТДАЛЁННОМ справочнике адресных объектов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_object_ins ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_object_ins ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);

