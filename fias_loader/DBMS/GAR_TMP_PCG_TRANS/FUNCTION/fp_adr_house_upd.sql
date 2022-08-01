DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_upd (
                text,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                    ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                    ,uuid,bigint,varchar(11),numeric,numeric
                    ,bigint
 );
 
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_upd (
                    text, bigint, bigint, bigint, integer, varchar(70), integer, varchar(50)
                  , integer, varchar(50), varchar(20), varchar(250), varchar(11)
                  , uuid, bigint, varchar(11), numeric, numeric, bigint
);
--
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_upd (
                 text, text
                ,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                ,uuid,bigint,varchar(11),numeric,numeric,bigint, boolean, boolean
 );
-- 
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_upd (
                 text, text
                ,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                ,uuid,bigint,varchar(11),numeric,numeric, boolean, boolean, boolean
 ); 
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.fp_adr_house_upd (
              p_schema_name        text   -- Схема с данными
             ,p_schema_h           text   -- Историческая схема
               --
             ,p_id_house           bigint       --  NOT NULL
             ,p_id_area            bigint       --  NOT NULL
             ,p_id_street          bigint       --   NULL
             ,p_id_house_type_1    integer      --   NULL
             ,p_nm_house_1         varchar(70)  --   NULL
             ,p_id_house_type_2    integer      --   NULL
             ,p_nm_house_2         varchar(50)  --   NULL
             ,p_id_house_type_3    integer      --   NULL
             ,p_nm_house_3         varchar(50)  --   NULL
             ,p_nm_zipcode         varchar(20)  --   NULL
             ,p_nm_house_full      varchar(250) --  NOT NULL
             ,p_kd_oktmo           varchar(11)  --   NULL
             ,p_nm_fias_guid       uuid         --   NULL 
             ,p_id_data_etalon     bigint       --  NULL
             ,p_kd_okato           varchar(11)  --  NULL
             ,p_vl_addr_latitude   numeric      --  NULL
             ,p_vl_addr_longitude  numeric      --  NULL 
             --
             ,p_sw    boolean -- Создаётся историческая запись.  
             ,p_duble boolean -- Обязательное выявление дубликатов
             ,p_del   boolean -- Убираю дубли при обработки EXCEPTION              
             
)
    RETURNS bigint[] 
    LANGUAGE plpgsql SECURITY DEFINER
    
    AS $$
    -- -----------------------------------------------------------------------------
    --  2021-12-14/2021-12-25/2022-01-27  
    --         Обновление записи в ОТДАЛЁННОМ справочнике адресов домов.
    --  2022-02-01  Расширенная обработка нарушения уникальности по второму индексу  
    --  2022-02-11  История в отдельной схеме
    --  2022-02-21   ONLY - UPDATE, DELETE, SELECT
    --  2022-02-28  Расширенный поиск дублей.
    -- ----------------------------------------------------------------------------
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
    -- ----------------------------------------------------------------------------------- 
    --  2022-05-31 COALESCE только для NOT NULL полей.    
    -- -----------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _id_houses bigint[] := ARRAY[NULL, NULL]::bigint[]; 
         -- [1] - обработанный, [2] - двойник.
      
      _id_house_new  bigint;
      _id_house_hist bigint;
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
                 ) 
                    RETURNING id_house;      
              $_$;      
      --
      -- 2022-05-31
      _upd_id text = $_$
            UPDATE ONLY %I.adr_house SET  
            
                 id_area           = COALESCE (%L, id_area)::bigint  -- NOT NULL
                ,id_street         = %L::bigint                      --     NULL
                ,id_house_type_1   = %L::integer                     --     NULL
                ,nm_house_1        = %L::varchar(70)                 --     NULL
                ,id_house_type_2   = %L::integer                     --     NULL
                ,nm_house_2        = %L::varchar(50)                 --     NULL
                ,id_house_type_3   = %L::integer                     --     NULL
                ,nm_house_3        = %L::varchar(50)                 --     NULL
                ,nm_zipcode        = %L::varchar(20)                 --     NULL
                ,nm_house_full     = COALESCE (%L, nm_house_full)::varchar(250)   -- NOT NULL
                ,kd_oktmo          = %L::varchar(11)                 --  NULL
                ,nm_fias_guid      = %L::uuid                        --  NULL
                ,dt_data_del       = %L::timestamp without time zone --  NULL
                ,id_data_etalon    = %L::bigint                      --  NULL
                ,kd_okato          = %L::varchar(11)                 --  NULL
                ,vl_addr_latitude  = %L::numeric                     --  NULL
                ,vl_addr_longitude = %L::numeric                     --  NULL
                    
            WHERE (id_house = %L::bigint);
        $_$;
      -- 2022-05-31        
      --
      
       _del_twin  text = $_$             --  
           DELETE FROM ONLY %I.adr_house WHERE (id_house = %L);                 
       $_$;         
       
       _rr  gar_tmp.adr_house_t; 
       _rr1 gar_tmp.adr_house_t;
      
    BEGIN
     -- _rr := gar_tmp_pcg_trans.f_adr_house_get (p_schema_name
     --         , p_id_area, p_nm_house_full, p_id_street, p_id_house_type_1
     -- ); 
     -- 2022-05-19 Обновляюсь. Значимым явяляется UUID
     _rr := gar_tmp_pcg_trans.f_adr_house_get (p_schema_name, p_nm_fias_guid); 
     _id_house_new := _rr.id_house;
     
     IF p_duble -- Обязательный поиск дублей   
        THEN
                 CALL gar_tmp_pcg_trans.p_adr_house_del_twin (
                         p_schema_name   := p_schema_name
                        ,p_id_house      := _rr.id_house
                        ,p_id_area       := _rr.id_area
                        ,p_id_street     := _rr.id_street
                        ,p_nm_house_full := _rr.nm_house_full
                        ,p_nm_fias_guid  := _rr.nm_fias_guid
                        ,p_mode          := TRUE -- Обработка                           
                 );
        
     END IF; --- p_duble
     
     IF (_rr.id_house IS NOT NULL)  
       THEN  
          IF 
             -- 2022-05-31
             ((_rr.id_area         IS DISTINCT FROM p_id_area) AND (p_id_area IS NOT NULL)) OR
             ((_rr.id_street       IS DISTINCT FROM p_id_street)      ) OR -- AND (p_id_street       IS NOT NULL)
             ((_rr.id_house_type_1 IS DISTINCT FROM p_id_house_type_1)) OR -- AND (p_id_house_type_1 IS NOT NULL)
             ((_rr.id_house_type_2 IS DISTINCT FROM p_id_house_type_2)) OR -- AND (p_id_house_type_2 IS NOT NULL)
             ((_rr.id_house_type_3 IS DISTINCT FROM p_id_house_type_3)) OR -- AND (p_id_house_type_3 IS NOT NULL)
             --  2022-01-27
             ((_rr.nm_house_1 IS DISTINCT FROM p_nm_house_1)) OR           --  AND (p_nm_house_1 IS NOT NULL)
             ((_rr.nm_house_2 IS DISTINCT FROM p_nm_house_2)) OR           --  AND (p_nm_house_2 IS NOT NULL)
             ((_rr.nm_house_3 IS DISTINCT FROM p_nm_house_3)) OR           --  AND (p_nm_house_3 IS NOT NULL)
             --
             ((_rr.nm_fias_guid IS DISTINCT FROM p_nm_fias_guid) AND (p_nm_fias_guid IS NOT NULL)) OR
             --  2022-01-27                      
             ((upper(_rr.nm_house_full) IS DISTINCT FROM upper(p_nm_house_full)) AND (p_nm_house_full IS NOT NULL)) OR                  
             ((_rr.nm_zipcode      IS DISTINCT FROM p_nm_zipcode)) OR -- AND (p_nm_zipcode    IS NOT NULL)
             ((_rr.kd_oktmo        IS DISTINCT FROM p_kd_oktmo)  )    -- AND (p_kd_oktmo      IS NOT NULL)
             -- 2022-05-31
                
            THEN --> UPDATE
              -- Запоминаю старые с новым ID
              -- 2022-05-19 Без нового ID
              IF (p_sw) THEN 
                 _exec := format (_ins_hist, p_schema_h
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
                         ,now()            -- p_dt_data_del
                         ,_rr.id_house     -- id_data_etalon 
                         ,_rr.kd_okato          
                         ,_rr.vl_addr_latitude  
                         ,_rr.vl_addr_longitude
                         , NULL
                 );            
                 EXECUTE _exec INTO _id_house_hist;
              END IF; -- -- p_sw   
              --
              --  Выполняю UPDATE  2022-05-19 UPDATE ID
              --
              _exec = format (_upd_id, p_schema_name
                              ,p_id_area          
                              ,p_id_street        
                              ,p_id_house_type_1  
                              ,p_nm_house_1       
                              ,p_id_house_type_2  
                              ,p_nm_house_2       
                              ,p_id_house_type_3  
                              ,p_nm_house_3       
                              ,p_nm_zipcode       
                              ,p_nm_house_full    
                              ,p_kd_oktmo         
                              ,p_nm_fias_guid     
                              ,NULL      
                              ,NULL  
                              ,p_kd_okato         
                              ,p_vl_addr_latitude 
                              ,p_vl_addr_longitude
                               --   
                              ,_rr.id_house               
              );
              EXECUTE _exec;  
            END IF; -- compare
        ELSE
             _id_house_new := NULL;
     END IF; -- rr.id_house IS NOT NULL  
   
     _id_houses [1] := _id_house_new;
     RETURN _id_houses;
     
    -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     EXCEPTION  -- Возникает на отдалённоми сервере    
     --
     -- UNIQUE INDEX _xxx_adr_house_ie2 ON gar_tmp.adr_house USING btree (nm_fias_guid ASC NULLS LAST)    
     --       всегда существует в БД.
     --
       WHEN unique_violation THEN 
         BEGIN
           _rr  := gar_tmp_pcg_trans.f_adr_house_get (p_schema_name, p_nm_fias_guid);
           _rr1 := gar_tmp_pcg_trans.f_adr_house_get (p_schema_name
                        , p_id_area, p_nm_house_full, p_id_street, p_id_house_type_1
           ); 
           IF (_rr1.id_house IS NOT NULL)
              THEN
                  -- Зловредный дубль
                _exec := format (_ins_hist, p_schema_h
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
                                      ,_rr1.nm_fias_guid   
                                      ,now()            -- p_dt_data_del
                                      ,_rr1.id_house     -- id_data_etalon 
                                      ,_rr1.kd_okato          
                                      ,_rr1.vl_addr_latitude  
                                      ,_rr1.vl_addr_longitude
                                      , 0
                );            
                EXECUTE _exec INTO _id_house_hist;  
               ---------------------------------------------------------
               IF p_del -- иЗБАВЛЯЕМСЯ ОТ ДУБЛЕЙ.
                 THEN
                     _exec := format (_del_twin, p_schema_name, _rr1.id_house); -- ??
                     EXECUTE _exec;      -- Проверить функционал, удаляющий дубли.
                 ELSE    
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
                                      ,now()      
                                      ,_rr.id_house  
                                      ,_rr1.kd_okato         
                                      ,_rr1.vl_addr_latitude 
                                      ,_rr1.vl_addr_longitude
                                       --  
                                      ,_rr1.id_house               
                      );
                      EXECUTE _exec;
               END IF;  -- иЗБАВЛЯЕМСЯ ОТ ДУБЛЕЙ.
           END IF; -- _rr1.id_house IS NOT NULL
           --
           -- Повторяю прерванную операцию, от дублей избавился.
           IF (_rr.id_house IS NOT NULL) AND (_rr1.id_house IS NOT NULL)
             THEN
               IF p_sw THEN
                 --
                 -- Старые значения с новым ID и признаком удаления
                 -- 2022-05-19
                 -----------------------------------------------
                 _exec := format (_ins_hist, p_schema_h
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
                                   ,now()            -- p_dt_data_del
                                   ,_rr.id_house     -- id_data_etalon 
                                   ,_rr.kd_okato          
                                   ,_rr.vl_addr_latitude  
                                   ,_rr.vl_addr_longitude
                                   ,NULL
                 );            
                 EXECUTE _exec INTO _id_house_hist;      
               END IF;  -- p_sw  
               --
               -- update, используя атрибуты образующие уникальность-1 отдельной записи.  
               -- 
               _exec = format (_upd_id, p_schema_name
                                ,p_id_area          
                                ,p_id_street        
                                ,p_id_house_type_1  
                                ,p_nm_house_1       
                                ,p_id_house_type_2  
                                ,p_nm_house_2       
                                ,p_id_house_type_3  
                                ,p_nm_house_3       
                                ,p_nm_zipcode       
                                ,p_nm_house_full    
                                ,p_kd_oktmo         
                                ,p_nm_fias_guid     
                                ,NULL      
                                ,NULL  
                                ,p_kd_okato         
                                ,p_vl_addr_latitude 
                                ,p_vl_addr_longitude
                                 --  
                                ,_rr.id_house               
                );
               EXECUTE _exec;
               
             ELSE
                  _id_house_new := NULL;     
           END IF; -- compare _rr
          
           _id_houses [1] := _id_house_new; -- 2022-05-19 UUID цел, но остальные 
           RETURN _id_houses;               -- атрибуты образующие основную уникальность изменились. 
          
  	    END; -- unique_violation
    END;
  $$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.fp_adr_house_upd (
                 text, text
                ,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                ,uuid,bigint,varchar(11),numeric,numeric, boolean, boolean, boolean                          
) 
         IS 'Обновление записи в ОТДАЛЁННОМ справочнике адресов домов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.fp_adr_house_upd ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.fp_adr_house_upd ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);

