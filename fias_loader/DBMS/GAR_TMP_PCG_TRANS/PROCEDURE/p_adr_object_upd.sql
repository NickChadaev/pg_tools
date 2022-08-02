DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_upd (
                text, bigint, bigint, bigint, integer, bigint, varchar(250), varchar(500), varchar(150) 
                     ,bigint, integer, integer, numeric, uuid, varchar(20), varchar(11), varchar(11)
                     ,numeric, numeric, bigint                           
 ); 

DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_upd (
                 text, text
                ,bigint, bigint, bigint, integer, bigint, varchar(250), varchar(500), varchar(150) 
                ,bigint, integer, integer, numeric, uuid, varchar(20), varchar(11), varchar(11)
                ,numeric, numeric, bigint, boolean                           
 ); 
 CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_object_upd (
              p_schema_name        text   -- Схема с данными
             ,p_schema_h           text   -- Историческая схема
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
             ,p_twin_id     bigint
             ,p_sw          boolean -- Создаётся историческая зап
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ------------------------------------------------------------------------------------
    --   2021-12-17/2021-12-26/2022-01-27 
    --               Обновление записи в ОТДАЛЁННОМ справочнике адресных объектов
    --   2022-02-07  Переход на базовые типы.
    --   2022-02-14  Поиск и удаление дублей.
    --   2022-02-21  ONLY для SELECT, UPDATE, DELETE
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
      _upd_u text = $_$
             UPDATE ONLY %I.adr_objects SET  
             
                   id_area           = COALESCE (%L, id_area)::bigint               --  NULL
                  ,id_house          = COALESCE (%L, id_house)::bigint              --  NULL
                  ,id_object_type    = COALESCE (%L, id_object_type)::integer       --  NULL
                  ,id_street         = COALESCE (%L, id_street)::bigint             --  NULL
                  ,nm_object         = COALESCE (%L, nm_object)::varchar(250)       --  NULL
                  ,nm_object_full    = COALESCE (%L, nm_object_full)::varchar(500)  --  NULL
                  ,nm_description    = COALESCE (%L, nm_description)::varchar(150)  --  NULL
                  ,dt_data_del       =  %L::timestamp without time zone             --  NULL
                  ,id_data_etalon    =  %L::bigint                                  --  NULL
                  ,id_metro_station  = COALESCE (%L, id_metro_station)::integer     -- NOT NULL
                  ,id_autoroad       = COALESCE (%L, id_autoroad)::integer          --  NULL
                  ,nn_autoroad_km    = COALESCE (%L, nn_autoroad_km)::numeric           
                  ,nm_zipcode        = COALESCE (%L, nm_zipcode)::varchar(20)       --  NULL
                  ,kd_oktmo          = COALESCE (%L, kd_oktmo)::varchar(11)         --  NULL
                  ,kd_okato          = COALESCE (%L, kd_okato)::varchar(11)         --  NULL          
                  ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude)::numeric     --  NULL
                  ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric    --  NULL
          
             WHERE (nm_fias_guid = %L::uuid) AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL);        
        $_$;   
       --
      _upd text = $_$
                  UPDATE ONLY %I.adr_objects SET
                  
                            nm_object         = COALESCE (%L, nm_object     )::varchar(250)    --  NULL
                           ,nm_description    = COALESCE (%L, nm_description)::varchar(150)    --  NULL
                           ,dt_data_del       =  %L::timestamp without time zone --  NULL
                           ,id_data_etalon    =  %L::bigint                      --  NULL
                           ,id_metro_station  = COALESCE (%L, id_metro_station )::integer         -- NOT NULL
                           ,id_autoroad       = COALESCE (%L, id_autoroad      )::integer         --  NULL
                           ,nn_autoroad_km    = COALESCE (%L, nn_autoroad_km   )::numeric         
                           ,nm_fias_guid      = COALESCE (%L, nm_fias_guid     )::uuid            --  NULL
                           ,nm_zipcode        = COALESCE (%L, nm_zipcode       )::varchar(20)     --  NULL
                           ,kd_oktmo          = COALESCE (%L, kd_oktmo         )::varchar(11)     --  NULL
                           ,kd_okato          = COALESCE (%L, kd_okato         )::varchar(11)     --  NULL          
                           ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric         --  NULL
                           ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric         --  NULL
                            --                           
                   WHERE  (id_area = %L::bigint) AND (id_object_type = %L::integer) AND
                          (upper(nm_object_full::text) = upper (%L)::text) AND 
                          (id_street IS NOT DISTINCT FROM %L::bigint) AND 
                          (id_house  IS NOT DISTINCT FROM %L::bigint) AND 
                          (id_data_etalon IS NULL) AND (dt_data_del IS NULL);      
        $_$;  
        
        _sel_twin text = $_$
           SELECT * FROM ONLY %I.adr_objects 
               WHERE (id_area = %L::bigint) AND (id_house = %L::bigint) AND 
                    (nm_fias_guid = %L::uuid) AND  
                    (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
        $_$;
        
       _del_twin  text = $_$             --  
           DELETE FROM ONLY %I.adr_objects WHERE (id_object = %L);                 
       $_$;         
        
      _rr  gar_tmp.adr_objects_t; -- RECORD;   
      _rr1 gar_tmp.adr_objects_t;
      
    BEGIN
      IF p_twin_id IS NOT NULL
        THEN
          _exec := format (_sel_twin, p_schema_name, p_id_area, p_twin_id, p_nm_fias_guid);  
          EXECUTE _exec INTO _rr1;
          --
          -- Двойники: различаются по первому альтернатиному ключу (степень различия в ID дома)
          --           но имеют одинаковые UUID
          IF (_rr1.id_object IS NOT NULL)
            THEN
               _exec := format (_ins_hist, p_schema_h
                    --
                   ,nextval('gar_tmp.obj_hist_seq')  --  bigint  --  NOT NULL
                   ,_rr1.id_area           --  bigint       --  NOT NULL
                   ,_rr1.id_house          --  bigint       --      NULL
                   ,_rr1.id_object_type    --  integer      --  NOT NULL
                   ,_rr1.id_street         --  bigint       --      NULL
                   ,_rr1.nm_object         --  varchar(250) --      NULL
                   ,_rr1.nm_object_full    --  varchar(500) --  NOT NULL
                   ,_rr1.nm_description    --  varchar(150) --      NULL
                   ,now()
                   ,_rr1.id_object        -- id_data_etalon    --  bigint       --      NULL
                   ,_rr1.id_metro_station  --  integer      --      NULL
                   ,_rr1.id_autoroad       --  integer      --      NULL
                   ,_rr1.nn_autoroad_km    --  numeric      --      NULL
                   ,_rr1.nm_fias_guid      --  uuid         --      NULL
                   ,_rr1.nm_zipcode        --  varchar(20)  --      NULL
                   ,_rr1.kd_oktmo          --  varchar(11)  --      NULL
                   ,_rr1.kd_okato          --  varchar(11)  --      NULL
                   ,_rr1.vl_addr_latitude  --  numeric      --      NULL
                   ,_rr1.vl_addr_longitude --  numeric      --      NULL
                   ,-1  --Признак принудительного поиска дублей
              );            
              EXECUTE _exec;            
              --
              _exec := format (_del_twin, p_schema_name, _rr1.id_object);
              EXECUTE _exec;
              
          END IF;-- _rr1.id_object IS NOT NULL
      END IF; -- TWINS
    
      _rr := gar_tmp_pcg_trans.f_adr_object_get (p_schema_name, 
                       p_id_area, p_id_object_type, p_nm_object_full, p_id_street, p_id_house 
      ); 
      --     
      IF (_rr.id_object IS NOT NULL)  
        THEN   -- ->  UPDATE
           IF
              ((_rr.id_area        IS DISTINCT FROM p_id_area       ) AND (p_id_area        IS NOT NULL)) OR
              ((_rr.id_street      IS DISTINCT FROM p_id_street     ) AND (p_id_street      IS NOT NULL)) OR
              ((_rr.id_house       IS DISTINCT FROM p_id_house      ) AND (p_id_house       IS NOT NULL)) OR
              ((_rr.nm_object_full IS DISTINCT FROM p_nm_object_full) AND (p_nm_object_full IS NOT NULL)) OR                
              ((_rr.nm_zipcode     IS DISTINCT FROM p_nm_zipcode    ) AND (p_nm_zipcode     IS NOT NULL)) OR 
                -- 
              ((_rr.nm_fias_guid   IS DISTINCT FROM p_nm_fias_guid  ) AND (p_nm_fias_guid   IS NOT NULL)) OR
              ((_rr.id_object_type IS DISTINCT FROM p_id_object_type) AND (p_id_object_type IS NOT NULL)) OR
                -- 
              ((_rr.kd_oktmo       IS DISTINCT FROM p_kd_oktmo      ) AND (p_kd_oktmo       IS NOT NULL)) OR  
              ((_rr.kd_okato       IS DISTINCT FROM p_kd_okato      ) AND (p_kd_okato       IS NOT NULL)) 
              
             THEN
               IF p_sw THEN -- Пишем в историю старые данные.
                 _exec := format (_ins_hist, p_schema_h
                          ,nextval('gar_tmp.obj_hist_seq')::bigint  --  NOT NULL
                          ,_rr.id_area          -- bigint       --  NOT NULL
                          ,_rr.id_house         -- bigint       --      NULL
                          ,_rr.id_object_type   -- integer      --  NOT NULL
                          ,_rr.id_street        -- bigint       --      NULL
                          ,_rr.nm_object        -- varchar(250) --      NULL
                          ,_rr.nm_object_full   -- varchar(500) --  NOT NULL
                          ,_rr.nm_description   -- varchar(150) --      NULL
                          ,now()
                          ,_rr.id_object         -- bigint       --      NULL  -- -- id_data_etalon
                          ,_rr.id_metro_station  -- integer      --      NULL
                          ,_rr.id_autoroad       -- integer      --      NULL
                          ,_rr.nn_autoroad_km    -- numeric      --      NULL
                          ,_rr.nm_fias_guid      -- uuid         --      NULL
                          ,_rr.nm_zipcode        -- varchar(20)  --      NULL
                          ,_rr.kd_oktmo          -- varchar(11)  --      NULL
                          ,_rr.kd_okato          -- varchar(11)  --      NULL
                          ,_rr.vl_addr_latitude  -- numeric      --      NULL
                          ,_rr.vl_addr_longitude -- numeric      --      NULL
                          , NULL
                 );            
                 EXECUTE _exec;
               END IF; -- p_sw -- пишем в историю 
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
           END IF; -- compare   
            
         ELSE  -- INSERT -- _rr.id_object IS NULL
           -- Дома и адресные объекто строго не сихронизированы. 
           -- Обновляемой записи из "adr_house" может и не быть в "adr_objects".
            -- 
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
                            ,NULL    -- p_id_data_etalon    --  bigint    NULL
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
      END IF; -- _rr.id_object IS NOT NULL
      
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
    
    EXCEPTION  -- Возникает на отдалённоми сервере               
      WHEN unique_violation THEN 
        BEGIN
          _rr1 := (p_schema_name, p_id_area, p_id_object_type, p_nm_object_full, p_id_street, p_id_house); 
          IF ( _rr1.id_object IS NOT NULL)
            THEN
              -- Запоминаю старые данные с новым ID
              _exec := format (_ins_hist, p_schema_h
                         ,nextval('gar_tmp.obj_hist_seq')  --  bigint  --  NOT NULL
                         ,_rr1.id_area           --  bigint       --  NOT NULL
                         ,_rr1.id_house          --  bigint       --      NULL
                         ,_rr1.id_object_type    --  integer      --  NOT NULL
                         ,_rr1.id_street         --  bigint       --      NULL
                         ,_rr1.nm_object         --  varchar(250) --      NULL
                         ,_rr1.nm_object_full    --  varchar(500) --  NOT NULL
                         ,_rr1.nm_description    --  varchar(150) --      NULL
                         ,now()
                         ,_rr1.id_object        -- id_data_etalon    --  bigint       --      NULL
                         ,_rr1.id_metro_station  --  integer      --      NULL
                         ,_rr1.id_autoroad       --  integer      --      NULL
                         ,_rr1.nn_autoroad_km    --  numeric      --      NULL
                         ,_rr1.nm_fias_guid      --  uuid         --      NULL
                         ,_rr1.nm_zipcode        --  varchar(20)  --      NULL
                         ,_rr1.kd_oktmo          --  varchar(11)  --      NULL
                         ,_rr1.kd_okato          --  varchar(11)  --      NULL
                         ,_rr1.vl_addr_latitude  --  numeric      --      NULL
                         ,_rr1.vl_addr_longitude --  numeric      --      NULL
                         , 0
              );            
              EXECUTE _exec;     
              -- 
              _exec := format (_del_twin, p_schema_name, _rr1.id_object);
              EXECUTE _exec;              
              --
              -- Продолжаю прерванную операцию  
              --
              _rr := (p_schema_name, p_id_area, p_id_object_type, p_nm_object_full, p_id_street, p_id_house); 
              IF (_rr.id_object IS NOT NULL) 
               THEN
                 IF p_sw THEN
                   -- Запоминаю старые данные с новым ID
                   _exec := format (_ins_hist, p_schema_h
                        ,nextval('gar_tmp.obj_hist_seq')  --  bigint  --  NOT NULL
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
                        , NULL
                   );            
                   EXECUTE _exec;     
                 END IF; -- Сохраняю исходные данные.
              
                 -- Обновляю запись.
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
              END IF; -- -- _rr.id_object IS NOT NULL
          END IF; -- _rr1.id_object IS NOT NULL
 	    END; -- unique_violation	
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_object_upd (
                 text, text
                ,bigint, bigint, bigint, integer, bigint, varchar(250), varchar(500), varchar(150) 
                ,bigint, integer, integer, numeric, uuid, varchar(20), varchar(11), varchar(11)
                ,numeric, numeric, bigint, boolean                            
) 
         IS 'Обновление записи в ОТДАЛЁННОМ справочнике адресных объектов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
-- -----------------------------------------------------------------------------------------------
-- 
-- ЗАМЕЧАНИЕ:  процедура gar_tmp_pcg_trans.p_adr_object_upd(text,pg_catalog.int8,pg_catalog.int8,pg_catalog.int8,pg_catalog.int4,pg_catalog.int8,pg_catalog.varchar,pg_catalog.varchar,pg_catalog.varchar,pg_catalog.int8,pg_catalog.int4,pg_catalog.int4,pg_catalog.numeric,uuid,pg_catalog.varchar,pg_catalog.varchar,pg_catalog.varchar,pg_catalog.numeric,pg_catalog.numeric,pg_catalog.int8) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:42804:256:присваивание:target type is different type than source type
-- ЗАМЕЧАНИЕ:  Detail: cast "text" value to "bigint" type
-- ЗАМЕЧАНИЕ:  Hint: The input expression type does not have an assignment cast to the target type.
-- ЗАМЕЧАНИЕ:  Context: at assignment to variable "_rr" declared on line 149
-- ЗАМЕЧАНИЕ:  warning:42804:256:присваивание:target type is different type than source type
-- ЗАМЕЧАНИЕ:  Detail: cast "character varying" value to "integer" type
-- ЗАМЕЧАНИЕ:  Hint: The input expression type does not have an assignment cast to the target type.
-- ЗАМЕЧАНИЕ:  Context: at assignment to variable "_rr" declared on line 149
-- ЗАМЕЧАНИЕ:  warning:00000:256:присваивание:too few attributes for composite variable
-- ЗАМЕЧАНИЕ:  Context: at assignment to variable "_rr" declared on line 149
-- ЗАМЕЧАНИЕ:  warning extra:00000:101:DECLARE:never read variable "_upd_u"
-- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_id_data_etalon"
-- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_oper_type_id"
-- ЗАМЕЧАНИЕ:  (FUNCTION,1652988,gar_tmp_pcg_trans,f_adr_object_get,"(text,bigint,integer,character varying,bigint,bigint)")
-- COMMENT
-- 
-- Query returned successfully in 219 msec.
-- 

