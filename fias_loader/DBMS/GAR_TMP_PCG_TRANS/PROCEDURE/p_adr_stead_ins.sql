DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_stead_ins (
                    text, text, bigint, bigint, bigint
                  , varchar(250), varchar(250)     
                  , varchar(11), varchar(11), varchar(20)
                  , uuid
 ); 
 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_stead_ins (
              p_schema_name        text  
             ,p_schema_h           text 
               --
             ,p_id_stead           bigint       --  NOT NULL
             ,p_id_area            bigint       --  NOT NULL
             ,p_id_street          bigint       --     NULL
             
             ,p_stead_num          varchar(250)
             ,p_stead_cadastr_num  varchar(250)
             
             ,p_kd_oktmo           varchar(11)  --  NULL
             ,p_kd_okato           varchar(11)  --  NULL
             ,p_nm_zipcode         varchar(20)  --  NULL
             
             ,p_nm_fias_guid       uuid         --  NOT NULL 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------
    --  2023-10-17 Создание/Обновление записи в справочнике ЗЕМЕЛЬНЫХ УЧАСТКОВ.
    -- -------------------------------------------------------------------------     
    DECLARE
      _exec text;
      
      _upd_id text = $_$
            UPDATE ONLY %I.adr_stead SET  
            
                 id_area           = COALESCE (%L, id_area)::bigint  -- NOT NULL
                ,id_street         = %L::bigint                      --     NULL
                ,stead_num         = COALESCE (%L, stead_num)::varchar(250)   -- NOT NULL
                ,stead_cadastr_num = %L::varchar(250)                         --     NULL
                                                                              
                ,kd_okato          = %L::varchar(11)  --   NULL
                ,kd_oktmo          = %L::varchar(11)  --   NULL
                ,nm_zipcode        = %L::varchar(20)  --   NULL
                
                ,nm_fias_guid      = COALESCE (%L, nm_fias_guid)::uuid  --  NOT NULL
                
                ,dt_data_del       = %L::timestamp without time zone    --  NULL
                ,id_data_etalon    = %L::bigint                         --  NULL
                    
            WHERE (id_stead = %L::bigint);
        $_$;

      _ins text = $_$
               INSERT INTO %I.adr_stead (
                                  id_stead              -- bigint                      NOT NULL
                                , id_area               -- bigint                      NOT NULL
                                , id_street             -- bigint                      NULL
                                , stead_num             -- archar(250)                 NOT NULL
                                , stead_cadastr_num     -- archar(250)                 NULL
                                , kd_oktmo              -- varchar(11)                 NULL
                                , kd_okato              -- varchar(11)                 NULL
                                , nm_zipcode            -- varchar(20)                 NULL
                                , nm_fias_guid          -- uuid                        NOT NULL
                                , dt_data_del           -- timestamp without time zone NULL
                                , id_data_etalon        -- bigint                      NULL
                                , vl_addr_latitude      -- numeric                     NULL
                                , vl_addr_longitude     -- numeric                     NULL
               )
                 VALUES (   %L::bigint                   
                           ,%L::bigint                   
                           ,%L::bigint                    
                           ,%L::varchar(250)               
                           ,%L::varchar(250)               
                           ,%L::varchar(11)               
                           ,%L::varchar(11)               
                           ,%L::varchar(20)  
                           ,%L::uuid
                           ,%L::timestamp without time zone
                           ,%L::bigint                   
                           ,%L::numeric                   
                           ,%L::numeric                   
                 ) RETURNING id_stead;      
              $_$;
 
      _ins_hist text = $_$
               INSERT INTO %I.adr_stead_hist (
                                id_stead              -- bigint                      NOT NULL
                              , id_area               -- bigint                      NOT NULL
                              , id_street             -- bigint                      NULL
                              , stead_num             -- archar(250)                 NOT NULL
                              , stead_cadastr_num     -- archar(250)                 NULL
                              , kd_oktmo              -- varchar(11)                 NULL
                              , kd_okato              -- varchar(11)                 NULL
                              , nm_zipcode            -- varchar(20)                 NULL
                              , nm_fias_guid          -- uuid                        NOT NULL
                              , dt_data_del           -- timestamp without time zone NULL
                              , id_data_etalon        -- bigint                      NULL
                              , vl_addr_latitude      -- numeric                     NULL
                              , vl_addr_longitude     -- numeric                     NULL
                              , id_region             -- bigint  
               )
                 VALUES (   %L::bigint                   
                           ,%L::bigint                   
                           ,%L::bigint                    
                           ,%L::varchar(250)               
                           ,%L::varchar(250)               
                           ,%L::varchar(11)               
                           ,%L::varchar(11)               
                           ,%L::varchar(20)  
                           ,%L::uuid
                           ,%L::timestamp without time zone
                           ,%L::bigint                   
                           ,%L::numeric                   
                           ,%L::numeric                                     
                           ,%L::bigint
                 );      
              $_$;
      --
      _rr  gar_tmp.adr_stead_t;
      
       -- 2022-10-18
      _id_stead bigint; 
      INS_OP CONSTANT char(1) := 'I';
      UPD_OP CONSTANT char(1) := 'U'; 
      
    BEGIN
     --
     --  2022-05-19 uuid нет в базе. Есть ТРОЙКА, определяющая уникальность AK.
     --
     --
      _exec := format (_ins, p_schema_name
                            ,p_id_stead          
                            ,p_id_area             
                            ,p_id_street           
                            ,p_stead_num           
                            ,p_stead_cadastr_num   
                            ,p_kd_oktmo            
                            ,p_kd_okato            
                            ,p_nm_zipcode          
                            ,p_nm_fias_guid        
                            ,NULL  -- p_dt_data_del
                            ,NULL  -- p_id_data_etalon    
                            ,NULL  -- p_vl_addr_latitude  
                            ,NULL  -- p_vl_addr_longitude 
      );            
      EXECUTE _exec INTO _id_stead;         
      
      INSERT INTO gar_tmp.adr_stead_aux (id_stead, op_sign)
       VALUES (_id_stead, INS_OP)
          ON CONFLICT (id_stead) DO UPDATE SET op_sign = INS_OP
              WHERE (gar_tmp.adr_stead_aux.id_stead = excluded.id_stead);
      
    EXCEPTION  -- Возникает на отдалённом сервере            
       WHEN unique_violation THEN 
         BEGIN
          -- 2022-05-19, создание записи, рассматриваемого UUID нет в базе.
          --   Сработала основная уникальность "ak1".
          _rr := gar_tmp_pcg_trans.f_adr_stead_get (p_schema_name
                                                   ,p_id_area
                                                   ,p_stead_num
                                                   ,p_id_street
          );
     
          IF (_rr.id_stead IS NOT NULL) 
            THEN
             -- Запоминаю всегда старые с новым ID 
             _exec := format (_ins_hist, p_schema_h
                                    --
                   ,_rr.id_stead           
                   ,_rr.id_area            
                   ,_rr.id_street          
                   ,_rr.stead_num          
                   ,_rr.stead_cadastr_num  
                   ,_rr.kd_oktmo           
                   ,_rr.kd_okato           
                   ,_rr.nm_zipcode         
                   ,_rr.nm_fias_guid       
                   ,now()             -- dt_data_del
                   ,_rr.id_stead      -- id_data_etalon  
                   ,_rr.vl_addr_latitude  
                   ,_rr.vl_addr_longitude 
                   --
                   ,0 -- Регион "0" - Исключение во время процесса дополнения.
             );            
             EXECUTE _exec; 
             -- ------------------------------------------------------------------------
             --  Продолжаю ранее прерванные операции. 
             --    update, используя атрибуты образующие уникальность отдельной записи.  
             --  2022-05-19 uuid однако. Используется существующий ID.
             -- ------------------------------------------------------------------------
             _exec = format (_upd_id, p_schema_name
                              ,p_id_area            
                              ,p_id_street          
                              ,p_stead_num          
                              ,p_stead_cadastr_num  
                              ,p_kd_okato    
                              ,p_kd_oktmo    
                              ,p_nm_zipcode  
                              ,p_nm_fias_guid  
                              ,NULL -- p_dt_data_del      
                              ,NULL -- p_id_data_etalon   
                               --  
                              ,_rr.id_stead               
              );
              EXECUTE _exec;  -- Результат - сменился UUID у записи.
              --
              INSERT INTO gar_tmp.adr_stead_aux (id_stead, op_sign)
               VALUES (_rr.id_stead, UPD_OP)
                  ON CONFLICT (id_stead) DO UPDATE SET op_sign = UPD_OP
                      WHERE (gar_tmp.adr_stead_aux.id_stead = excluded.id_stead);
              --
          END IF; -- _rr.id_stead IS NOT NULL
         END; -- unique_violation
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_stead_ins (
                    text, text, bigint, bigint, bigint
                  , varchar(250), varchar(250)     
                  , varchar(11), varchar(11), varchar(20)
                  , uuid
 ) IS 'Создание записи в справочнике ЗЕМЕЛЬНЫХ УЧАСТКОВ';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_stead_ins ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_stead_ins ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);

