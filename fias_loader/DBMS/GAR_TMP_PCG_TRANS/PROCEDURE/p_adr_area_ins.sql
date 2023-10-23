DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_area_ins (
                text, text, bigint, integer, varchar(120), varchar(4000), integer, bigint, integer
               ,smallint, varchar(11), uuid, bigint, varchar(11), varchar(20), varchar(15)
               ,numeric, numeric, boolean                        
);
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_area_ins (
                text, text, bigint, integer, varchar(120), varchar(4000), integer, bigint, integer
               ,smallint, varchar(11), uuid, varchar(11), varchar(20), varchar(15)
               ,numeric, numeric
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_area_ins (
            p_schema_name        text  
           ,p_schema_h           text 
            --
           ,p_id_area            bigint            --  NOT NULL
           ,p_id_country         integer           --  NOT NULL
           ,p_nm_area            varchar(120)      --  NOT NULL
           ,p_nm_area_full       varchar(4000)     --  NOT NULL
           ,p_id_area_type       integer           --    NULL
           ,p_id_area_parent     bigint            --    NULL
           ,p_kd_timezone        integer           --    NULL
           ,p_pr_detailed        smallint          --  NOT NULL 
           ,p_kd_oktmo           varchar(11)       --    NULL
           ,p_nm_fias_guid       uuid              --    NULL
           ,p_kd_okato           varchar(11)       --    NULL
           ,p_nm_zipcode         varchar(20)       --    NULL
           ,p_kd_kladr           varchar(15)       --    NULL
           ,p_vl_addr_latitude   numeric           --    NULL
           ,p_vl_addr_longitude  numeric           --    NULL 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------
    --    2021-12-14  Создание записи в ОТДАЛЁННОМ справочнике  
    --                   адресных пространств
    --    2021-12-21  Переход на другие правила уникальности. .. да в дышло. 
    --    2022-02-09  Управляемая история
    --    2022-02-21  Опция ONLY 
    -- -------------------------------------------------------------------------
    --   2022-05-19 "Cause belli" - квартет "id_area", upper("nm_house_full",
    --  "id_street", "id_house_type_1" не обеспечивает уникальность кортежа,
    --   т.к два последних атрибута являются опциональными. В то-же время 
    --   работа начиналась в тот момент, когда уникальность "nm_fias_guid"
    --   не обеспечивалась. Это причина "исчезновения" значений "nm_fias_guid"
    --   при выполнения обновлений. 
    --  Ввожу: 
    --        + upd_id, 
    --        + отказываюсь от суррогатного генератора "gar_tmp.obj_hist_seq"
    --  В дальнейшем распространяю это на остальные фунции типа "_ins", "_upd"
    --  "adr_area", "adr_street". 
    -- -------------------------------------------------------------------------
    --   2022-05-31 COALESCE только для NOT NULL полей.    
    -- -------------------------------------------------------------------------
    --  2022-10-18 Вспомогательные таблицы.
    --  2022-11-07 Увеличено количество защищённых (от обновления NULL) столбцов   
    --  2023-10-23 Сохраняется оригинальный UUID при обработке дубля.
    -- -------------------------------------------------------------------------    
    DECLARE
      _exec text;
      
      _ins text = $_$
               INSERT INTO %I.adr_area ( 
               
                            id_area           
                           ,id_country        
                           ,nm_area           
                           ,nm_area_full      
                           ,id_area_type      
                           ,id_area_parent    
                           ,kd_timezone       
                           ,pr_detailed   
                           ,dt_data_del 
                           ,kd_oktmo          
                           ,nm_fias_guid      
                           ,id_data_etalon    
                           ,kd_okato          
                           ,nm_zipcode        
                           ,kd_kladr          
                           ,vl_addr_latitude  
                           ,vl_addr_longitude 
               )
                 VALUES (   %L::bigint                     
                           ,%L::integer                    
                           ,%L::varchar(120)                
                           ,%L::varchar(4000)              
                           ,%L::integer                     
                           ,%L::bigint                     
                           ,%L::integer                     
                           ,%L::smallint  
                           ,%L::timestamp without time zone
                           ,%L::varchar(11)                 
                           ,%L::uuid                       
                           ,%L::bigint                     
                           ,%L::varchar(11)                 
                           ,%L::varchar(20)                
                           ,%L::varchar(15)                 
                           ,%L::numeric                    
                           ,%L::numeric                     
                 ) RETURNING id_area;      
              $_$;

      _ins_hist text = $_$
               INSERT INTO %I.adr_area_hist ( 
               
                            id_area           
                           ,id_country        
                           ,nm_area           
                           ,nm_area_full      
                           ,id_area_type      
                           ,id_area_parent    
                           ,kd_timezone       
                           ,pr_detailed   
                           ,dt_data_del 
                           ,kd_oktmo          
                           ,nm_fias_guid      
                           ,id_data_etalon    
                           ,kd_okato          
                           ,nm_zipcode        
                           ,kd_kladr          
                           ,vl_addr_latitude  
                           ,vl_addr_longitude
                           ,id_region
               )
                 VALUES (   %L::bigint                     
                           ,%L::integer                    
                           ,%L::varchar(120)                
                           ,%L::varchar(4000)              
                           ,%L::integer                     
                           ,%L::bigint                     
                           ,%L::integer                     
                           ,%L::smallint  
                           ,%L::timestamp without time zone
                           ,%L::varchar(11)                 
                           ,%L::uuid                       
                           ,%L::bigint                     
                           ,%L::varchar(11)                 
                           ,%L::varchar(20)                
                           ,%L::varchar(15)                 
                           ,%L::numeric                    
                           ,%L::numeric
                           ,%L::bigint
                 );      
              $_$;
              
        -- 2022-05-19/2022-05-31
      _upd_id text = $_$
            UPDATE ONLY %I.adr_area SET  
            
                 id_country     = COALESCE (%L, id_country    )::integer       -- NOT NULL  
                ,nm_area        = COALESCE (%L, nm_area       )::varchar(120)  -- NOT NULL
                ,nm_area_full   = COALESCE (%L, nm_area_full  )::varchar(4000) -- NOT NULL                         
                ,id_area_type   = %L::integer
                ,id_area_parent = %L::bigint
                 --
                ,kd_timezone  = COALESCE (%L, kd_timezone)::integer       -- 2022-11-07                   
                ,pr_detailed  = COALESCE (%L, pr_detailed)::smallint      -- NOT NULL                          
                ,kd_oktmo     = COALESCE (%L, kd_oktmo)::varchar(11)  
                ,nm_fias_guid = %L::uuid
                
                ,dt_data_del    = %L::timestamp without time zone
                ,id_data_etalon = %L::bigint
                 --
                ,kd_okato   = COALESCE (%L, kd_okato)::varchar(11)         -- 2022-11-07                      
                ,nm_zipcode = COALESCE (%L, nm_zipcode)::varchar(20)                           
                ,kd_kladr   = COALESCE (%L, kd_kladr)::varchar(15)                
                ,vl_addr_latitude  = %L::numeric                               
                ,vl_addr_longitude = %L::numeric  
                    
            WHERE (id_area = %L::bigint);         
        $_$;          
        -- 2022-05-19/2022-05-31
        
      _rr  gar_tmp.adr_area_t; 
       
       -- 2022-10-18
      _id_area bigint; 
      INS_OP CONSTANT char(1) := 'I';
      UPD_OP CONSTANT char(1) := 'U';
      
    BEGIN
    --
    --  2022-05-19 Значения "p_nm_fias_guid" нет в базе.
    --
       _exec := format (_ins, p_schema_name
                             ,p_id_area          
                             ,p_id_country       
                             ,p_nm_area          
                             ,p_nm_area_full     
                             ,p_id_area_type     
                             ,p_id_area_parent   
                             ,p_kd_timezone      
                             ,p_pr_detailed
                             ,NULL
                             ,p_kd_oktmo         
                             ,p_nm_fias_guid     
                             ,NULL -- p_id_data_etalon   
                             ,p_kd_okato         
                             ,p_nm_zipcode       
                             ,p_kd_kladr         
                             ,p_vl_addr_latitude 
                             ,p_vl_addr_longitude                           
       );            
       EXECUTE _exec INTO _id_area;
       --
       INSERT INTO gar_tmp.adr_area_aux (id_area, op_sign)
       VALUES (_id_area, INS_OP)
        ON CONFLICT (id_area) DO UPDATE SET op_sign = INS_OP
              WHERE (gar_tmp.adr_area_aux.id_area = excluded.id_area);
    
    EXCEPTION  -- Возникает на отдалённом сервере    Повторяю сделанное ???        
       WHEN unique_violation THEN 
          BEGIN
            -- Сработала основная уникальность "ak1".
            _rr =  gar_tmp_pcg_trans.f_adr_area_get (
                                        p_schema_name, p_id_country, p_id_area_parent
                                       ,p_id_area_type, p_nm_area
            );
            --
            -- Старые значения с новым ID и признаком удаления
            IF (_rr.id_area IS NOT NULL)  
              THEN
                   _exec := format (_ins_hist, p_schema_h
                   
                               ,_rr.id_area        
                               ,_rr.id_country       
                               ,_rr.nm_area          
                               ,_rr.nm_area_full     
                               ,_rr.id_area_type     
                               ,_rr.id_area_parent   
                               ,_rr.kd_timezone      
                               ,_rr.pr_detailed  
                               , now()      --  dt_data_del
                               ,_rr.kd_oktmo         
                               ,_rr.nm_fias_guid   
                               ,p_id_area -- id_data_etalon   
                               ,_rr.kd_okato         
                               ,_rr.nm_zipcode       
                               ,_rr.kd_kladr         
                               ,_rr.vl_addr_latitude 
                               ,_rr.vl_addr_longitude 
                               ,0 -- Регион "0" - Исключение во время процесса дополнения.
                   );            
                   EXECUTE _exec; 
                  --
                  -- update, 2022-05-19
                  --
                  _exec := format (_upd_id, p_schema_name 
                                      ,_rr.id_country       
                                      ,_rr.nm_area          
                                      ,_rr.nm_area_full     
                                      ,_rr.id_area_type     
                                      ,_rr.id_area_parent
                                       --
                                      ,_rr.kd_timezone      
                                      ,_rr.pr_detailed   
                                      ,_rr.kd_oktmo         
                                      ,_rr.nm_fias_guid 
                                      --
                                      , now()      -- dt_data_del
                                      , p_id_area  -- id_data_etalon
                                      
                                      ,_rr.kd_okato  
                                      ,_rr.nm_zipcode       
                                      ,_rr.kd_kladr         
                                      ,_rr.vl_addr_latitude 
                                      ,_rr.vl_addr_longitude
                                      --
                                      ,_rr.id_area
                  );            
                  EXECUTE _exec;   -- Возможна смена UUID.
                  
                  INSERT INTO gar_tmp.adr_area_aux (id_area, op_sign)
                  VALUES (_rr.id_area, UPD_OP)
                   ON CONFLICT (id_area) DO UPDATE SET op_sign = UPD_OP
                         WHERE (gar_tmp.adr_area_aux.id_area = excluded.id_area); 
                         
            END IF; -- _rr.id_area IS NOT NULL
            -- 
            -- Продолжаю прерванный ранее процесс.
            --
            _exec := format (_ins, p_schema_name
                                  ,p_id_area          
                                  ,p_id_country       
                                  ,p_nm_area          
                                  ,p_nm_area_full     
                                  ,p_id_area_type     
                                  ,p_id_area_parent   
                                  ,p_kd_timezone      
                                  ,p_pr_detailed
                                  ,NULL   -- p_dt_data_del
                                  ,p_kd_oktmo         
                                  ,p_nm_fias_guid     
                                  ,NULL   -- p_id_data_etalon   
                                  ,p_kd_okato         
                                  ,p_nm_zipcode       
                                  ,p_kd_kladr         
                                  ,p_vl_addr_latitude 
                                  ,p_vl_addr_longitude                           
            );            
            EXECUTE _exec INTO _id_area;
            --
            INSERT INTO gar_tmp.adr_area_aux (id_area, op_sign)
            VALUES (_id_area, INS_OP)
             ON CONFLICT (id_area) DO UPDATE SET op_sign = INS_OP
                   WHERE (gar_tmp.adr_area_aux.id_area = excluded.id_area);
                              
                  
          END; -- unique_violation
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_area_ins (
                text, text, bigint, integer, varchar(120), varchar(4000), integer, bigint, integer
               ,smallint, varchar(11), uuid, varchar(11), varchar(20), varchar(15)
               ,numeric, numeric
) 
         IS 'Создание/Обновление записи в ОТДАЛЁННОМ справочнике адресных пространств';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_area_ins ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_area_ins ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);

