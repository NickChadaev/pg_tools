DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_stead_upd (
                 text, text, bigint, bigint, varchar(250), varchar(250)     
                ,varchar(11), varchar(11), varchar(20), uuid
 ); 
 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_stead_upd (
              p_schema_name        text   -- Схема с данными
             ,p_schema_h           text   -- Историческая схема
              --
             ,p_id_area            bigint      -- NOT NULL
             ,p_id_street          bigint      --     NULL
              --
             ,p_stead_num         varchar(250) -- NOT NULL                               
             ,p_stead_cadastr_num varchar(250) --     NULL
              --              
             ,p_kd_oktmo          varchar(11)  --  NULL
             ,p_kd_okato          varchar(11)  --  NULL
             ,p_nm_zipcode        varchar(20)  --  NULL
             
             ,p_nm_fias_guid      uuid         -- NOT NULL              
)
    LANGUAGE plpgsql SECURITY DEFINER
    
    AS $$
    -- -----------------------------------------------------------------------------
    --  2023-120-18 Обновление записи в ОТДАЛЁННОМ справочнике адресов ЗУ  
    --              COALESCE только для NOT NULL полей.    
    -- -----------------------------------------------------------------------------
    
    DECLARE
      _exec text;
      --
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
        
       _rr  gar_tmp.adr_stead_t; 
       _rr1 gar_tmp.adr_stead_t;
       
      -- 2022-10-18
      --
      UPD_OP CONSTANT char(1) := 'U';  
      
    BEGIN
     -- 2022-05-19 Обновляюсь. Значимым является UUID
     _rr := gar_tmp_pcg_trans.f_adr_stead_get (p_schema_name, p_nm_fias_guid); 
     
     IF (_rr.id_stead IS NOT NULL)  
       THEN  
          IF 
             ((_rr.id_area          IS DISTINCT FROM p_id_area) AND (p_id_area IS NOT NULL)) OR
             ((_rr.id_street        IS DISTINCT FROM p_id_street)) OR  
             ((upper(_rr.stead_num) IS DISTINCT FROM upper(p_stead_num)) AND (p_stead_num IS NOT NULL)) OR                  
             ((upper(_rr.stead_cadastr_num) IS DISTINCT FROM upper(p_stead_cadastr_num))) OR                  
             --                      
             ((_rr.kd_oktmo   IS DISTINCT FROM p_kd_oktmo))   OR  
             ((_rr.kd_okato   IS DISTINCT FROM p_kd_okato))   OR
             ((_rr.nm_zipcode IS DISTINCT FROM p_nm_zipcode)) OR
             --
             ((_rr.nm_fias_guid IS DISTINCT FROM p_nm_fias_guid) AND (p_nm_fias_guid IS NOT NULL)) 
                
            THEN --> UPDATE
            
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
                                      ,NULL
              );            
              EXECUTE _exec;  
              --
              --  Выполняю UPDATE   
              --
             _exec = format (_upd_id, p_schema_name
                              ,p_id_area            
                              ,p_id_street          
                              ,p_stead_num          
                              ,p_stead_cadastr_num  
                              ,p_kd_okato    
                              ,p_kd_oktmo    
                              ,p_nm_zipcode  
                              ,p_nm_fias_guid
                               --
                              ,NULL -- p_dt_data_del      
                              ,NULL -- p_id_data_etalon   
                               --  
                              ,_rr.id_stead               
              );
              --
              EXECUTE _exec;
              --  
              INSERT INTO gar_tmp.adr_stead_aux (id_stead, op_sign)
              VALUES (_rr.id_stead, UPD_OP)
                 ON CONFLICT (id_stead) DO UPDATE SET op_sign = UPD_OP
                     WHERE (gar_tmp.adr_stead_aux.id_stead = excluded.id_stead); 
                     
          END IF; -- compare for update
     END IF; -- rr.id_stead IS NOT NULL  
   
    -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     EXCEPTION  -- Возникает на отдалённоми сервере    
     --
     -- UNIQUE INDEX _xxx_adr_stead_ie2 ON gar_tmp.adr_stead USING btree (nm_fias_guid ASC NULLS LAST)    
     --       всегда существует в БД.
     --
       WHEN unique_violation THEN 
         BEGIN
           _rr  := gar_tmp_pcg_trans.f_adr_stead_get (p_schema_name, p_nm_fias_guid);
           _rr1 := gar_tmp_pcg_trans.f_adr_stead_get (p_schema_name, p_id_area, p_stead_num, p_id_street); 
           
           IF (_rr1.id_stead IS NOT NULL)
              THEN
                  -- Зловредный дубль
                _exec := format (_ins_hist, p_schema_h
                                        --
                                   ,_rr1.id_stead           
                                   ,_rr1.id_area            
                                   ,_rr1.id_street          
                                   ,_rr1.stead_num          
                                   ,_rr1.stead_cadastr_num  
                                   ,_rr1.kd_oktmo           
                                   ,_rr1.kd_okato           
                                   ,_rr1.nm_zipcode         
                                   ,_rr1.nm_fias_guid       
                                   ,now()             -- dt_data_del
                                   ,_rr.id_stead      -- id_data_etalon   ID той записи, которой дубль мешал
                                   ,_rr1.vl_addr_latitude  
                                   ,_rr1.vl_addr_longitude 
                                   --
                                   ,0
                                );            
               EXECUTE _exec;   
               ---------------------------------------------------------------------------------
               -- Дубль стал неактивным, но зачем в этом случае создаётся историческая запись ??
               --
               _exec = format (_upd_id, p_schema_name
               
                                ,_rr1.id_area            
                                ,_rr1.id_street          
                                ,_rr1.stead_num          
                                ,_rr1.stead_cadastr_num  
                                ,_rr1.kd_okato    
                                ,_rr1.kd_oktmo    
                                ,_rr1.nm_zipcode  
                                ,_rr1.nm_fias_guid 
                                --
                                ,now()      
                                ,_rr.id_stead  
                                 --  
                                ,_rr1.id_stead               
                );               
               
                EXECUTE _exec;
                --  
               INSERT INTO gar_tmp.adr_stead_aux (id_stead, op_sign)
                 VALUES (_rr1.id_stead, UPD_OP)
                   ON CONFLICT (id_stead) DO UPDATE SET op_sign = UPD_OP
                       WHERE (gar_tmp.adr_stead_aux.id_stead = excluded.id_stead); 
                             
           END IF; -- _rr1.id_stead IS NOT NULL
           --
           -- Повторяю прерванную операцию, от дублей избавился.
           IF (_rr.id_stead IS NOT NULL) AND (_rr1.id_stead IS NOT NULL)
             THEN
                 --
                 -- Старые значения с новым ID и признаком удаления 2022-05-19
                 -------------------------------------------------------------
                 
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
                                      ,NULL
              );            
              EXECUTE _exec ;       
               --
               -- update, используя атрибуты образующие уникальность-1 отдельной записи.  
               -- 
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
              --
              EXECUTE _exec;               
               --  
               INSERT INTO gar_tmp.adr_stead_aux (id_stead, op_sign)
                VALUES (_rr.id_stead, UPD_OP)
                  ON CONFLICT (id_stead) DO UPDATE SET op_sign = UPD_OP
                      WHERE (gar_tmp.adr_stead_aux.id_stead = excluded.id_stead);                
               
           END IF; -- compare _rr, _rr1
          
  	     END; -- unique_violation
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_stead_upd (
                 text, text, bigint, bigint,varchar(250),varchar(250)     
                ,varchar(11),varchar(11),varchar(20),uuid
 )
         IS 'Обновление записи в ОТДАЛЁННОМ справочнике адресов ЗУ';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_stead_upd ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_stead_upd ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);

