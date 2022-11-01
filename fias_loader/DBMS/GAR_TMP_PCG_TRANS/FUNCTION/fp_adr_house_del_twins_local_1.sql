DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_del_twin_local_1 (
                  text, bigint, bigint, bigint, varchar(250), uuid, date, text 
 ); 
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.fp_adr_house_del_twin_local_1 (
        p_schema_name      text  
       ,p_id_house         bigint       --  NOT NULL
       ,p_id_area          bigint       --  NOT NULL
       ,p_id_street        bigint       --      NULL
       ,p_nm_house_full    varchar(250) --  NOT NULL
       ,p_nm_fias_guid     uuid
       ,p_bound_date       date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name text = 'gar_tmp' 
        --
       ,OUT fcase          integer
       ,OUT id_house_subj  bigint
       ,OUT id_house_obj   bigint
       ,OUT nm_hose_full   varchar(250)
       ,OUT nm_fias_guid   uuid       
)

    RETURNS setof record
    LANGUAGE plpgsql SECURITY DEFINER
   
    AS $$
    -- ----------------------------------------------------------------------------------------
    --  2022-02-28  Убираем дубли. Проверка по UUID.
    -- ---------------------------------------------------------------------------------------
    --  2022-03-03  Двурежимная работа процедуры.
    --  Поиск в процессе постобработки, 
    --            используется индекс ""adr_house_ak1",  без уникальности 
    --  INDEX adr_house_ak1
    --    ON unnsi.adr_house USING btree (id_area ASC NULLS LAST, upper(nm_house_full::text) ASC NULLS LAST
    --   , id_street ASC NULLS LAST)
    --    WHERE id_data_etalon IS NULL;
    -- ---------------------------------------------------------------------------------------
    --  2022-04-04 Постобработка, историческая запись должна содержать ссылку на 
    --             воздействующий субъект (id_data_etalon := id_house)
    -- ---------------------------------------------------------------------------------------
    --  2022-06-06  Постобработка. Пока в 99 базе. Опытный вариант.
    --  2022-06-10  Постобработка. Пока в 99 базе. Ещё один опытный вариант.    
    --  2022-06-15  Постобработка. FIX. unsi_old2. Первый вариант, поддерживающий  целостность базы. 
    --  Соглашение о терминах:
    --     Проверяемая запись может иметь близнецов ("nm_fias_guid" СОВПАДАЮТ)
    --     Запись активна, если справедливо отношение:
    --          (dt_data_del IS NULL) AND (id_data_etalon IS NULL)
    --     Запись помечена на удаление: (dt_data_del IS NOT NULL) AND (id_data_etalon IS NULL)    
    --     Деактуализированная запись:  (dt_data_del IS NOT NULL) AND (id_data_etalon IS NOT NULL)
    -- ---------------------------------------------------------------------------------------
    --   Проверка записи:
    --     1) Найден дублёр, далее проверка его актуальности:
    --         1.1) Актуален, его "адресная область" так-же актуальна.
    --              сливаем записи, проверяемая запись удаляется 
    --
    --         1.2) Дублёр актуален, но его адресная облась НЕ АКТУАЛЬНА.
    --              Дублёр деактуализируется, его dt_data_del = dt_data_del адресной области.
    --
    --         1.3) Дублёр не актуален, в случае если dt_data_del < '2022-01-01' то 
    --               его id_data_etalon = id_house проверяемой записи.
    
    --         1.4) Дублёр не актуален, его dt_data_del >= '2022-01-01', то он удаляется.
    -- ---------------------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _upd_id text = $_$
            UPDATE ONLY %I.adr_house SET  
            
                 id_area           = COALESCE (%L, id_area)::bigint               -- NOT NULL
                ,id_street         = COALESCE (%L, id_street)::bigint             --  NULL
                ,id_house_type_1   = COALESCE (%L, id_house_type_1)::integer      --  NULL
                ,nm_house_1        = COALESCE (%L, nm_house_1)::varchar(70)       --  NULL
                ,id_house_type_2   = %L::integer      -- COALESCE ( NULL , id_house_type_2)
                ,nm_house_2        = %L::varchar(50)  -- COALESCE ( NULL , nm_house_2)
                ,id_house_type_3   = %L::integer      -- COALESCE ( NULL , id_house_type_3)
                ,nm_house_3        = %L::varchar(50)  -- COALESCE ( NULL, nm_house_3)
                ,nm_zipcode        = COALESCE (%L, nm_zipcode)::varchar(20)       --  NULL
                ,nm_house_full     = COALESCE (%L, nm_house_full)::varchar(250)   -- NOT NULL
                ,kd_oktmo          = COALESCE (%L, kd_oktmo)::varchar(11)         --  NULL
                ,nm_fias_guid      = COALESCE (%L, nm_fias_guid)::uuid
                ,dt_data_del       = %L::timestamp without time zone              --  NULL
                ,id_data_etalon    = %L::bigint                                   --  NULL
                ,kd_okato          = COALESCE (%L, kd_okato)::varchar(11)         --  NULL
                ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric    --  NULL
                ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric    --  NULL
                    
            WHERE (id_house = %L::bigint);
        $_$;        
           --
       _del_twin_id  text = $_$             --        
             DELETE FROM ONLY %I.adr_house WHERE (id_house = %L);                     
       $_$;
       --
      _ins_hist text = $_$
             INSERT INTO %I.adr_house_hist (
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
                            ,id_region         -- bigint
             )
               VALUES (   %L::bigint                   
                         ,%L::bigint                   
                         ,%L::bigint                    
                         ,%L::integer                  
                         ,%L::varchar(70)               
                         ,%L::integer                  
                         ,%L::varchar(50)               
                         ,%L::integer                  
                         ,%L::varchar(50)               
                         ,%L::varchar(20)  
                         ,%L::varchar(250)             
                         ,%L::varchar(11)               
                         ,%L::uuid
                         ,%L::timestamp without time zone
                         ,%L::bigint                   
                         ,%L::varchar(11)               
                         ,%L::numeric                  
                         ,%L::numeric  
                         ,%L::bigint
               ); 
        $_$;             
      -- -------------------------------------------------------------------------
      _sel_twin_post_u  text = $_$  -- UUID совпадают    
           SELECT * FROM ONLY %I.adr_house
               WHERE ((nm_fias_guid = %L::uuid) AND (NOT (id_house = %L::bigint))
                     ) AND (id_data_etalon IS NULL); 
       $_$;
       --
      _rr    gar_tmp.adr_house_t; 
      _rr1   gar_tmp.adr_house_t; 
      _rr2   gar_tmp.adr_area_t;
      
      -- 2022-10-18
      --
      UPD_OP CONSTANT char(1) := 'U';       
      
    BEGIN
     _exec := format (_sel_twin_post_u, p_schema_name, p_nm_fias_guid, p_id_house);         
     EXECUTE _exec INTO _rr1; -- Поиск дублёра по UUID
     -- --------------------------------
     --  Двойники: см. определение выше
     -- --------------------------------
     IF (_rr1.id_house IS NOT NULL) -- Найден. 
       THEN
        IF (_rr1.dt_data_del IS NULL)
          THEN
              _rr2 := gar_tmp_pcg_trans.f_adr_area_get (p_schema_name, _rr1.id_area);
              
              IF (_rr2.dt_data_del IS NULL) --- AND (_rr2.id_data_etalon IS NULL) 
                THEN
                    --  1.1) Актуален, его "адресная область" так-же актуальна.
                    --       сливаем записи, проверяемая запись удаляется 
                    -- --------------------------------------------------------

                    _rr := gar_tmp_pcg_trans.f_adr_house_get (p_schema_name, p_id_house);
                    _exec = format (_del_twin_id, p_schema_name, p_id_house);  
                    EXECUTE _exec;   -- Проверяемая запись
                    --
                    -- Создаю запись-фантом,
                    --      "_rr.id_house" потом удалится в отдалённой базе.
                    --   
                    INSERT INTO gar_tmp.adr_house_aux (id_house, op_sign)
                      VALUES (_rr.id_house, UPD_OP)
                        ON CONFLICT (id_house) DO UPDATE SET op_sign = UPD_OP
                            WHERE (gar_tmp.adr_house_aux.id_house = excluded.id_house);                    
                         
                    IF (_rr.id_data_etalon IS NULL) 
                     THEN
                        --
                        --    UPDATE _rr1 Обновление дублёра. 
                        --    Только в том случае, если проверяемая запись актуальна.
                        --    Старое значение уходит в историю
                        --
                        _exec := format (_ins_hist, p_schema_hist_name  
                                               --
                                ,_rr1.id_house  
                                ,_rr1.id_area           
                                ,_rr1.id_street         
                                ,_rr1.id_house_type_1   
                                ,_rr1.nm_house_1        
                                ,_rr1.id_house_type_2   
                                ,_rr1.nm_house_2        
                                ,_rr1.id_house_type_3   
                                ,_rr1.nm_house_3        
                                ,_rr1.nm_zipcode        
                                ,_rr1.nm_house_full     
                                ,_rr1.kd_oktmo          
                                ,_rr1.nm_fias_guid     -- 2022-04-04 
                                ,now()                 --    _rr1.dt_data_del     
                                ,p_id_house            --    _rr1.id_data_etalon     
                                ,_rr1.kd_okato          
                                ,_rr1.vl_addr_latitude  
                                ,_rr1.vl_addr_longitude
                                , -1 -- ID региона
                        ); 
                        EXECUTE _exec;

                        --  Обновляется старое значение  ??? Сколько их ??
                        _exec = format (_upd_id, p_schema_name
                                        ,_rr.id_area          
                                        ,_rr.id_street        
                                        ,_rr.id_house_type_1  
                                        ,_rr.nm_house_1       
                                        ,_rr.id_house_type_2  
                                        ,_rr.nm_house_2       
                                        ,_rr.id_house_type_3  
                                        ,_rr.nm_house_3       
                                        ,_rr.nm_zipcode       
                                        ,_rr.nm_house_full    
                                        ,_rr.kd_oktmo         
                                        ,_rr.nm_fias_guid     
                                        ,NULL      
                                        ,NULL  
                                        ,_rr.kd_okato         
                                        ,_rr.vl_addr_latitude 
                                        ,_rr.vl_addr_longitude
                                         --  
                                        ,_rr1.id_house               
                        );
                        EXECUTE _exec;
                        fcase := 1; -- Дублёр актуален, его adr_area - актуальна, 
                                   -- проверяемая - актуальна
                                   
                        INSERT INTO gar_tmp.adr_house_aux (id_house, op_sign)
                          VALUES (_rr1.id_house, UPD_OP)
                            ON CONFLICT (id_house) DO UPDATE SET op_sign = UPD_OP
                                 WHERE (gar_tmp.adr_house_aux.id_house = excluded.id_house);                                    
                        
                      ELSE -- Проверяемую запись в историю. (_rr.id_data_etalon IS NOT NULL)

                        _exec := format (_ins_hist, p_schema_hist_name  
                                               --
                                ,_rr.id_house  
                                ,_rr.id_area           
                                ,_rr.id_street         
                                ,_rr.id_house_type_1   
                                ,_rr.nm_house_1        
                                ,_rr.id_house_type_2   
                                ,_rr.nm_house_2        
                                ,_rr.id_house_type_3   
                                ,_rr.nm_house_3        
                                ,_rr.nm_zipcode        
                                ,_rr.nm_house_full     
                                ,_rr.kd_oktmo          
                                ,_rr.nm_fias_guid      
                                ,_rr.dt_data_del     
                                ,_rr.id_data_etalon     
                                ,_rr.kd_okato          
                                ,_rr.vl_addr_latitude  
                                ,_rr.vl_addr_longitude
                                , -1 -- ID региона
                        ); 
                        EXECUTE _exec;

                        fcase := 2; -- Дублёр актуален, его adr_area - актуальна, 
                                    -- проверяемая - НЕ актуальна
                    END IF; -- (_rr.id_data_etalon IS NULL)
                    
                 ELSE
                 
                 -- 1.2) Дублёр актуален, но его адресная облась НЕ АКТУАЛЬНА.
                 --      Дублёр деактуализируется, его dt_data_del = dt_data_del адресной области.
                 --      Активной остаётся проверяемая запись.  
                 
                 _exec = format (_upd_id, p_schema_name
                                 ,_rr1.id_area          
                                 ,_rr1.id_street        
                                 ,_rr1.id_house_type_1  
                                 ,_rr1.nm_house_1       
                                 ,_rr1.id_house_type_2  
                                 ,_rr1.nm_house_2       
                                 ,_rr1.id_house_type_3  
                                 ,_rr1.nm_house_3       
                                 ,_rr1.nm_zipcode       
                                 ,_rr1.nm_house_full    
                                 ,_rr1.kd_oktmo         
                                 ,_rr1.nm_fias_guid     
                                 ,_rr2.dt_data_del  --  dt_data_del    
                                 ,p_id_house     --  id_data_etalon 
                                 ,_rr1.kd_okato         
                                 ,_rr1.vl_addr_latitude 
                                 ,_rr1.vl_addr_longitude
                                  --  
                                 ,_rr1.id_house               
                 );
                 EXECUTE _exec;
                 --
                 INSERT INTO gar_tmp.adr_house_aux (id_house, op_sign)
                    VALUES (_rr1.id_house, UPD_OP)
                      ON CONFLICT (id_house) DO UPDATE SET op_sign = UPD_OP
                         WHERE (gar_tmp.adr_house_aux.id_house = excluded.id_house); 
                        
                 fcase := 3; -- Дублёр актуален, его adr_area - НЕ актуальна, 
                             -- проверяемая - актуальна                        
              END IF; -- (_rr2.dt_data_del IS NULL)
              
         ELSE --  (_rr1.dt_data_del IS NOT NULL)    
            IF (_rr1.dt_data_del < p_bound_date)
              THEN
               -- 
               -- 1.3) Дублёр не актуален, в случае если dt_data_del < '2022-01-01' то 
               --      его id_data_etalon = id_house проверяемой записи.

               _exec = format (_upd_id, p_schema_name
                                 ,_rr1.id_area          
                                 ,_rr1.id_street        
                                 ,_rr1.id_house_type_1  
                                 ,_rr1.nm_house_1       
                                 ,_rr1.id_house_type_2  
                                 ,_rr1.nm_house_2       
                                 ,_rr1.id_house_type_3  
                                 ,_rr1.nm_house_3       
                                 ,_rr1.nm_zipcode       
                                 ,_rr1.nm_house_full    
                                 ,_rr1.kd_oktmo         
                                 ,_rr1.nm_fias_guid     
                                 ,_rr1.dt_data_del      
                                 ,p_id_house  
                                 ,_rr1.kd_okato         
                                 ,_rr1.vl_addr_latitude 
                                 ,_rr1.vl_addr_longitude
                                  --   
                                 ,_rr1.id_house               
               );
               EXECUTE _exec; -- Связали.
               
               INSERT INTO gar_tmp.adr_house_aux (id_house, op_sign)  
                 VALUES (_rr1.id_house, UPD_OP)
                  ON CONFLICT (id_house) DO UPDATE SET op_sign = UPD_OP
                      WHERE (gar_tmp.adr_house_aux.id_house = excluded.id_house); 
              --     
              fcase := 4; -- Дублёр НЕ актуален,  проверяемая - актуальна                  
                 
             ELSE -- (_rr1.dt_data_del >= p_bound_date)
               --
               --  1.4) Дублёр не актуален, его dt_data_del >= '2022-01-01'.
                -- -----------------------------------------------------------------
                -- Дублёр существует, он обновляется данными из проверяемой записи,
                -- проверяемая запись удаляется. Это не мусор, что-то серьёзное.
                -- -----------------------------------------------------------------               
                --
                _rr := gar_tmp_pcg_trans.f_adr_house_get (p_schema_name, p_id_house);
                _exec = format (_del_twin_id, p_schema_name, p_id_house);  
                EXECUTE _exec;   -- Проверяемая запись
                --
                -- Создаю запись-фантом,
                --      "_rr.id_house" потом удалится в отдалённой базе.
                --   
                INSERT INTO gar_tmp.adr_house_aux (id_house, op_sign)
                  VALUES (_rr.id_house, UPD_OP)
                    ON CONFLICT (id_house) DO UPDATE SET op_sign = UPD_OP
                        WHERE (gar_tmp.adr_house_aux.id_house = excluded.id_house);                
                    
                _exec := format (_ins_hist, p_schema_hist_name  
                       ,_rr1.id_house  
                       ,_rr1.id_area           
                       ,_rr1.id_street         
                       ,_rr1.id_house_type_1   
                       ,_rr1.nm_house_1        
                       ,_rr1.id_house_type_2   
                       ,_rr1.nm_house_2        
                       ,_rr1.id_house_type_3   
                       ,_rr1.nm_house_3        
                       ,_rr1.nm_zipcode        
                       ,_rr1.nm_house_full     
                       ,_rr1.kd_oktmo          
                       ,_rr1.nm_fias_guid     -- 2022-04-04 
                       ,now()                 --    _rr1.dt_data_del     
                       ,p_id_house         --    _rr1.id_data_etalon     
                       ,_rr1.kd_okato          
                       ,_rr1.vl_addr_latitude  
                       ,_rr1.vl_addr_longitude
                       , -1 -- ID региона
               ); 
               EXECUTE _exec;
               
               _exec = format (_upd_id, p_schema_name
                               ,_rr.id_area          
                               ,_rr.id_street        
                               ,_rr.id_house_type_1  
                               ,_rr.nm_house_1       
                               ,_rr.id_house_type_2  
                               ,_rr.nm_house_2       
                               ,_rr.id_house_type_3  
                               ,_rr.nm_house_3       
                               ,_rr.nm_zipcode       
                               ,_rr.nm_house_full    
                               ,_rr.kd_oktmo         
                               ,_rr.nm_fias_guid   -- 2022-06-20 Сохраняется старый UUID /2022-11-01 НЕТ 
                               ,NULL      
                               ,NULL  
                               ,_rr.kd_okato         
                               ,_rr.vl_addr_latitude 
                               ,_rr.vl_addr_longitude
                                --  
                               ,_rr1.id_house               
               );
               EXECUTE _exec;
               
               INSERT INTO gar_tmp.adr_house_aux (id_house, op_sign)
                 VALUES (_rr1.id_house, UPD_OP)
                   ON CONFLICT (id_house) DO UPDATE SET op_sign = UPD_OP
                        WHERE (gar_tmp.adr_house_aux.id_house = excluded.id_house);
              
               fcase := 5; -- Дублёр , БЫЛ НЕ актуален,  проверяемая - актуальна
               --  Теперь ДУБЛЁР СТАЛ стал актуальным.
                              
            END IF; -- (_rr1.dt_data_del < p_bound_date)
        END IF; -- _rr1.dt_data_del IS NULL

      id_house_subj := p_id_house;
      id_house_obj  := _rr1.id_house;
      nm_hose_full  := _rr1.nm_house_full;
      nm_fias_guid  := _rr1.nm_fias_guid;  
       
     END IF; --  _rr1.id_house IS NOT NULL -- Найден.
     
     RETURN NEXT;
    END;
  $$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.fp_adr_house_del_twin_local_1 
    (text, bigint, bigint, bigint, varchar(250), uuid, date, text)
    IS 'Удаление/Слияние дублей';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- CALL gar_tmp_pcg_trans.fp_adr_house_del_twin_local_1 (
--               p_schema_name    := 'unnsi'  
--              ,p_id_house       := 2400298628   --  NOT NULL
--              ,p_id_area        := 32107        --  NOT NULL
--              ,p_id_street      := 353679       --      NULL
--              ,p_nm_house_full  := 'Д. 31Б/21'    --  NOT NULL
--              ,p_nm_fias_guid   := 'ba6461f5-8ea5-470d-a637-34cc42ea14ba'
-- );	
-- SELECT * FROM unnsi.adr_house WHERE ((id_area = 32107) AND 
--                                      (upper(nm_house_full::text) = 'Д. 31Б/21') AND (id_street=353679));
-- BEGIN;
-- UPDATE unnsi.adr_house SET dt_data_del = '2018-01-22 00:00:00' WHERE (id_house = 24026341);
-- COMMIT;
-- ROLLBACK;
