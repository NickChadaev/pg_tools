DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_ins (
                  text, text
                 ,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                 ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                 ,uuid,bigint,varchar(11),numeric,numeric
                 ,boolean
 );  
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_ins (
              p_schema_name        text  
             ,p_schema_h           text 
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
             ,p_sw  boolean              
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------
    --   2021-12-14/2022-01-28  
    --    Создание/Обновление записи в ОТДАЛЁННОМ справочнике  адресов домов.
    --   2022-02-07 Переход на базовые типы
    --   2022-02-11 История в отдельной схеме.
    --   2022-02-21 ONLY для UPDATE, DELETE, SELECT.
    --   2022-03-02 Возня с двойниками.
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
    -- ------------------------------------------------------------------------- 
    --  2022-05-31 COALESCE только для NOT NULL полей.    
    -- -------------------------------------------------------------------------
    --   2022-10-18 Вспомогательные таблицы..
    -- -------------------------------------------------------------------------     
    DECLARE
      _exec text;
      
      -- 2022-05-19/2022-05-31
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
      -- 2022-05-19/2022-05-31
      
      _ins text = $_$
               INSERT INTO %I.adr_house (
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
                 ) RETURNING id_house;      
              $_$;
      -- 2022-02-11
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
        -- 2022-02-11      
      --
      _rr  gar_tmp.adr_house_t;
      
       -- 2022-10-18
      _id_house bigint; 
      INS_OP CONSTANT char(1) := 'I';
      UPD_OP CONSTANT char(1) := 'U'; 
      
    BEGIN
     --
     --  2022-05-19 uuid нет в базе. Есть четвёрка, определяющая уникальность AK.
     --
      IF p_sw 
             THEN
                 CALL gar_tmp_pcg_trans.p_adr_house_del_twin (
                         p_schema_name   := p_schema_name
                        ,p_id_house      := p_id_house
                        ,p_id_area       := p_id_area
                        ,p_id_street     := p_id_street
                        ,p_nm_house_full := p_nm_house_full
                        ,p_nm_fias_guid  := p_nm_fias_guid
                        ,p_mode          := TRUE -- Обработка                        
                 );
      END IF;
      --
      _exec := format (_ins, p_schema_name
                            ,p_id_house          
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
                            ,NULL -- p_dt_data_del
                            ,NULL -- p_id_data_etalon    
                            ,p_kd_okato          
                            ,p_vl_addr_latitude  
                            ,p_vl_addr_longitude 
      );            
      EXECUTE _exec INTO _id_house;         
      
      INSERT INTO gar_tmp.adr_house_aux (id_house, op_sign)
       VALUES (_id_house, INS_OP)
          ON CONFLICT (id_house) DO UPDATE SET op_sign = INS_OP
              WHERE (gar_tmp.adr_house_aux.id_house = excluded.id_house);
      
    EXCEPTION  -- Возникает на отдалённом сервере            
       WHEN unique_violation THEN 
         BEGIN
          -- 2022-05-19, создание записи, рассматриваемого UUID нет в базе.
          --   Сработала основная уникальность "ak1".
          _rr := gar_tmp_pcg_trans.f_adr_house_get (p_schema_name
                                                   ,p_id_area
                                                   ,p_nm_house_full
                                                   ,p_id_street
                                                   ,p_id_house_type_1
          );
     
          IF (_rr.id_house IS NOT NULL) 
            THEN
             -- Запоминаю всегда старые с новым ID, переключатель "p_sw" - игнорирую
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
                   ,now()             -- dt_data_del
                   ,_rr.id_house      -- id_data_etalon  
                   ,_rr.kd_okato          
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
                              ,NULL -- p_dt_data_del      
                              ,NULL -- p_id_data_etalon   
                              ,p_kd_okato         
                              ,p_vl_addr_latitude 
                              ,p_vl_addr_longitude
                               --  
                              ,_rr.id_house               
              );
              EXECUTE _exec;  -- Результат - сменился UUID у записи.
              --
              INSERT INTO gar_tmp.adr_house_aux (id_house, op_sign)
               VALUES (_rr.id_house, UPD_OP)
                  ON CONFLICT (id_house) DO UPDATE SET op_sign = UPD_OP
                      WHERE (gar_tmp.adr_house_aux.id_house = excluded.id_house);
                      
               IF NOT (p_nm_fias_guid = _rr.nm_fias_guid)
                THEN
                    CALL gar_fias_pcg_load.p_twin_addr_obj_put (
                       p_fias_guid_new  := p_nm_fias_guid
                      ,p_fias_guid_old  := _rr.nm_fias_guid
                      ,p_obj_level      := 2::bigint
                      ,p_date_create    := current_date
                    );                       
              END IF;
              --
              IF p_sw
                THEN
                      CALL gar_tmp_pcg_trans.p_adr_house_del_twin (
                              p_schema_name   := p_schema_name
                             ,p_id_house      := p_id_house
                             ,p_id_area       := p_id_area
                             ,p_id_street     := p_id_street
                             ,p_nm_house_full := p_nm_house_full
                             ,p_nm_fias_guid  := p_nm_fias_guid
                             ,p_mode          := TRUE -- Обработка
                      );
              END IF; -- psw
          END IF; -- _rr.id_house IS NOT NULL
         END; -- unique_violation
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_ins (
                  text, text
                 ,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                 ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                 ,uuid,bigint,varchar(11),numeric,numeric
                 ,boolean                         
) 
         IS 'Создание записи в ОТДАЛЁННОМ справочнике адресов домов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_house_ins ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_house_ins ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);

