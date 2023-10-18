DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_stead_upd (
                 text, text, bigint, bigint, bigint,varchar(250),varchar(250)     
                ,varchar(11),varchar(11),varchar(20),uuid
 ); 
 
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.fp_adr_stead_upd (
              p_schema_name        text   -- Схема с данными
             ,p_schema_h           text   -- Историческая схема
               --
             ,p_id_stead           bigint       --  NOT NULL
              --
             ,p_id_area            bigint      -- NOT NULL
             ,p_id_street          bigint      --  NULL
              --
             ,p_stead_num         varchar(250) -- NOT NULL                               
             ,p_stead_cadastr_num varchar(250) --  NULL
              --              
             ,p_kd_oktmo          varchar(11)  --  NULL
             ,p_kd_okato          varchar(11)  --  NULL
             ,p_nm_zipcode        varchar(20)  --  NULL
             
             ,p_nm_fias_guid      uuid         --  NOT NULL              
)
    RETURNS bigint[] 
    LANGUAGE plpgsql SECURITY DEFINER
    
    AS $$
    -- -----------------------------------------------------------------------------
    --  2023-120-18 Обновление записи в ОТДАЛЁННОМ справочнике адресов ЗУ  
    --              COALESCE только для NOT NULL полей.    
    -- -----------------------------------------------------------------------------
    
    DECLARE
      _exec text;
      
      _id_steads bigint[] := ARRAY[NULL, NULL]::bigint[]; 
         -- [1] - обработанный, [2] - двойник.
      
      _id_stead_new  bigint;
      _id_stead_hist bigint;
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
                ,vl_addr_latitude  = %L::numeric                        --  NULL
                ,vl_addr_longitude = %L::numeric                        --  NULL
                    
            WHERE (id_stead = %L::bigint);
        $_$;
        
       _rr  gar_tmp.adr_stead_t; 
       _rr1 gar_tmp.adr_stead_t;
       
      -- 2022-10-18
      --
      UPD_OP CONSTANT char(1) := 'U';  
      
    BEGIN
     -- _rr := gar_tmp_pcg_trans.f_adr_stead_get (p_schema_name
     --         , p_id_area, p_nm_stead_full, p_id_street, p_id_stead_type_1
     -- ); 
     -- 2022-05-19 Обновляюсь. Значимым явяляется UUID
     _rr := gar_tmp_pcg_trans.f_adr_stead_get (p_schema_name, p_nm_fias_guid); 
     _id_stead_new := _rr.id_stead;
     
     
     IF (_rr.id_stead IS NOT NULL)  
       THEN  
          IF 
             -- 2022-05-31
             ((_rr.id_area         IS DISTINCT FROM p_id_area) AND (p_id_area IS NOT NULL)) OR
             ((_rr.id_street       IS DISTINCT FROM p_id_street)      ) OR -- AND (p_id_street       IS NOT NULL)
             ((_rr.id_stead_type_1 IS DISTINCT FROM p_id_stead_type_1)) OR -- AND (p_id_stead_type_1 IS NOT NULL)
             ((_rr.id_stead_type_2 IS DISTINCT FROM p_id_stead_type_2)) OR -- AND (p_id_stead_type_2 IS NOT NULL)
             ((_rr.id_stead_type_3 IS DISTINCT FROM p_id_stead_type_3)) OR -- AND (p_id_stead_type_3 IS NOT NULL)
             --  2022-01-27
             ((_rr.nm_stead_1 IS DISTINCT FROM p_nm_stead_1)) OR           --  AND (p_nm_stead_1 IS NOT NULL)
             ((_rr.nm_stead_2 IS DISTINCT FROM p_nm_stead_2)) OR           --  AND (p_nm_stead_2 IS NOT NULL)
             ((_rr.nm_stead_3 IS DISTINCT FROM p_nm_stead_3)) OR           --  AND (p_nm_stead_3 IS NOT NULL)
             --
             ((_rr.nm_fias_guid IS DISTINCT FROM p_nm_fias_guid) AND (p_nm_fias_guid IS NOT NULL)) OR
             --  2022-01-27                      
             ((upper(_rr.nm_stead_full) IS DISTINCT FROM upper(p_nm_stead_full)) AND (p_nm_stead_full IS NOT NULL)) OR                  
             ((_rr.nm_zipcode      IS DISTINCT FROM p_nm_zipcode)) OR -- AND (p_nm_zipcode    IS NOT NULL)
             ((_rr.kd_oktmo        IS DISTINCT FROM p_kd_oktmo)  )    -- AND (p_kd_oktmo      IS NOT NULL)
             -- 2022-05-31
                
            THEN --> UPDATE
              -- Запоминаю старые с новым ID
              -- 2022-05-19 Без нового ID
              IF (p_sw) THEN 
                 _exec := format (_ins_hist, p_schema_h
                                        --
                         ,_rr.id_stead    
                         ,_rr.id_area           
                         ,_rr.id_street         
                         ,_rr.id_stead_type_1   
                         ,_rr.nm_stead_1        
                         ,_rr.id_stead_type_2   
                         ,_rr.nm_stead_2        
                         ,_rr.id_stead_type_3   
                         ,_rr.nm_stead_3        
                         ,_rr.nm_zipcode        
                         ,_rr.nm_stead_full     
                         ,_rr.kd_oktmo          
                         ,_rr.nm_fias_guid   
                         ,now()            -- p_dt_data_del
                         ,_rr.id_stead     -- id_data_etalon 
                         ,_rr.kd_okato          
                         ,_rr.vl_addr_latitude  
                         ,_rr.vl_addr_longitude
                         , NULL
                 );            
                 EXECUTE _exec INTO _id_stead_hist;
              END IF; -- -- p_sw   
              --
              --  Выполняю UPDATE  2022-05-19 UPDATE ID
              --
              _exec = format (_upd_id, p_schema_name
                              ,p_id_area          
                              ,p_id_street        
                              ,p_id_stead_type_1  
                              ,p_nm_stead_1       
                              ,p_id_stead_type_2  
                              ,p_nm_stead_2       
                              ,p_id_stead_type_3  
                              ,p_nm_stead_3       
                              ,p_nm_zipcode       
                              ,p_nm_stead_full    
                              ,p_kd_oktmo         
                              ,p_nm_fias_guid     
                              ,NULL      
                              ,NULL  
                              ,p_kd_okato         
                              ,p_vl_addr_latitude 
                              ,p_vl_addr_longitude
                               --   
                              ,_rr.id_stead               
              );
              EXECUTE _exec;
              --  
              INSERT INTO gar_tmp.adr_stead_aux (id_stead, op_sign)
              VALUES (_rr.id_stead, UPD_OP)
                 ON CONFLICT (id_stead) DO UPDATE SET op_sign = UPD_OP
                     WHERE (gar_tmp.adr_stead_aux.id_stead = excluded.id_stead);             
              
            END IF; -- compare
        ELSE
             _id_stead_new := NULL;
     END IF; -- rr.id_stead IS NOT NULL  
   
     _id_steads [1] := _id_stead_new;
     RETURN _id_steads;
     
    -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     EXCEPTION  -- Возникает на отдалённоми сервере    
     --
     -- UNIQUE INDEX _xxx_adr_stead_ie2 ON gar_tmp.adr_stead USING btree (nm_fias_guid ASC NULLS LAST)    
     --       всегда существует в БД.
     --
       WHEN unique_violation THEN 
         BEGIN
           _rr  := gar_tmp_pcg_trans.f_adr_stead_get (p_schema_name, p_nm_fias_guid);
           _rr1 := gar_tmp_pcg_trans.f_adr_stead_get (p_schema_name
                        , p_id_area, p_nm_stead_full, p_id_street, p_id_stead_type_1
           ); 
           IF (_rr1.id_stead IS NOT NULL)
              THEN
                  -- Зловредный дубль
                _exec := format (_ins_hist, p_schema_h
                                       --
                                      ,_rr1.id_stead    
                                      ,_rr1.id_area           
                                      ,_rr1.id_street         
                                      ,_rr1.id_stead_type_1   
                                      ,_rr1.nm_stead_1        
                                      ,_rr1.id_stead_type_2   
                                      ,_rr1.nm_stead_2        
                                      ,_rr1.id_stead_type_3   
                                      ,_rr1.nm_stead_3        
                                      ,_rr1.nm_zipcode        
                                      ,_rr1.nm_stead_full     
                                      ,_rr1.kd_oktmo          
                                      ,_rr1.nm_fias_guid   
                                      ,now()            -- p_dt_data_del
                                      ,_rr1.id_stead     -- id_data_etalon 
                                      ,_rr1.kd_okato          
                                      ,_rr1.vl_addr_latitude  
                                      ,_rr1.vl_addr_longitude
                                      , 0
                );            
                EXECUTE _exec INTO _id_stead_hist;  
               ---------------------------------------------------------
               IF p_del -- иЗБАВЛЯЕМСЯ ОТ ДУБЛЕЙ.
                 THEN
                     _exec := format (_del_twin, p_schema_name, _rr1.id_stead); -- ??
                     EXECUTE _exec;      -- Проверить функционал, удаляющий дубли.
                 ELSE    
                     _exec = format (_upd_id, p_schema_name
                                      ,_rr1.id_area          
                                      ,_rr1.id_street        
                                      ,_rr1.id_stead_type_1  
                                      ,_rr1.nm_stead_1       
                                      ,_rr1.id_stead_type_2  
                                      ,_rr1.nm_stead_2       
                                      ,_rr1.id_stead_type_3  
                                      ,_rr1.nm_stead_3       
                                      ,_rr1.nm_zipcode       
                                      ,_rr1.nm_stead_full    
                                      ,_rr1.kd_oktmo         
                                      ,_rr1.nm_fias_guid     
                                      ,now()      
                                      ,_rr.id_stead  
                                      ,_rr1.kd_okato         
                                      ,_rr1.vl_addr_latitude 
                                      ,_rr1.vl_addr_longitude
                                       --  
                                      ,_rr1.id_stead               
                      );
                      EXECUTE _exec;
                      --  
                      INSERT INTO gar_tmp.adr_stead_aux (id_stead, op_sign)
                       VALUES (_rr1.id_stead, UPD_OP)
                         ON CONFLICT (id_stead) DO UPDATE SET op_sign = UPD_OP
                             WHERE (gar_tmp.adr_stead_aux.id_stead = excluded.id_stead); 
                             
               END IF;  -- иЗБАВЛЯЕМСЯ ОТ ДУБЛЕЙ.
           END IF; -- _rr1.id_stead IS NOT NULL
           --
           -- Повторяю прерванную операцию, от дублей избавился.
           IF (_rr.id_stead IS NOT NULL) AND (_rr1.id_stead IS NOT NULL)
             THEN
               IF p_sw THEN
                 --
                 -- Старые значения с новым ID и признаком удаления
                 -- 2022-05-19
                 -----------------------------------------------
                 _exec := format (_ins_hist, p_schema_h
                                        --
                                   ,_rr.id_stead    
                                   ,_rr.id_area           
                                   ,_rr.id_street         
                                   ,_rr.id_stead_type_1   
                                   ,_rr.nm_stead_1        
                                   ,_rr.id_stead_type_2   
                                   ,_rr.nm_stead_2        
                                   ,_rr.id_stead_type_3   
                                   ,_rr.nm_stead_3        
                                   ,_rr.nm_zipcode        
                                   ,_rr.nm_stead_full     
                                   ,_rr.kd_oktmo          
                                   ,_rr.nm_fias_guid   
                                   ,now()            -- p_dt_data_del
                                   ,_rr.id_stead     -- id_data_etalon 
                                   ,_rr.kd_okato          
                                   ,_rr.vl_addr_latitude  
                                   ,_rr.vl_addr_longitude
                                   ,NULL
                 );            
                 EXECUTE _exec INTO _id_stead_hist;      
               END IF;  -- p_sw  
               --
               -- update, используя атрибуты образующие уникальность-1 отдельной записи.  
               -- 
               _exec = format (_upd_id, p_schema_name
                                ,p_id_area          
                                ,p_id_street        
                                ,p_id_stead_type_1  
                                ,p_nm_stead_1       
                                ,p_id_stead_type_2  
                                ,p_nm_stead_2       
                                ,p_id_stead_type_3  
                                ,p_nm_stead_3       
                                ,p_nm_zipcode       
                                ,p_nm_stead_full    
                                ,p_kd_oktmo         
                                ,p_nm_fias_guid     
                                ,NULL      
                                ,NULL  
                                ,p_kd_okato         
                                ,p_vl_addr_latitude 
                                ,p_vl_addr_longitude
                                 --  
                                ,_rr.id_stead               
                );
               EXECUTE _exec;
               --  
               INSERT INTO gar_tmp.adr_stead_aux (id_stead, op_sign)
                VALUES (_rr.id_stead, UPD_OP)
                  ON CONFLICT (id_stead) DO UPDATE SET op_sign = UPD_OP
                      WHERE (gar_tmp.adr_stead_aux.id_stead = excluded.id_stead);                
               
             ELSE
                  _id_stead_new := NULL;     
           END IF; -- compare _rr
          
           _id_steads [1] := _id_stead_new; -- 2022-05-19 UUID цел, но остальные 
           RETURN _id_steads;               -- атрибуты образующие основную уникальность изменились. 
          
  	    END; -- unique_violation
    END;
  $$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.fp_adr_stead_upd (
                 text, text, bigint, bigint, bigint,varchar(250),varchar(250)     
                ,varchar(11),varchar(11),varchar(20),uuid
 )
         IS 'Обновление записи в ОТДАЛЁННОМ справочнике адресов ЗУ';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.fp_adr_stead_upd ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.fp_adr_stead_upd ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);

