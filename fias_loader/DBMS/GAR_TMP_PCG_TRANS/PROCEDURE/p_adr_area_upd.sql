DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_area_upd (
                text, text, bigint, integer, varchar(120), varchar(4000), integer, bigint, integer
               ,smallint, varchar(11), uuid, bigint, varchar(11), varchar(20), varchar(15)
               ,numeric, numeric 
               ,bigint, boolean
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_area_upd (
            p_schema_name        text  
           ,p_schema_h           text 
            --
           ,p_id_area            bigint         --  NOT NULL
           ,p_id_country         integer        --  NOT NULL
           ,p_nm_area            varchar(120)   --  NOT NULL
           ,p_nm_area_full       varchar(4000)  --  NOT NULL
           ,p_id_area_type       integer        --    NULL
           ,p_id_area_parent     bigint         --    NULL
           ,p_kd_timezone        integer        --    NULL
           ,p_pr_detailed        smallint       --  NOT NULL 
           ,p_kd_oktmo           varchar(11)    --    NULL
           ,p_nm_fias_guid       uuid           --    NULL
           ,p_id_data_etalon     bigint         --    NULL
           ,p_kd_okato           varchar(11)    --    NULL
           ,p_nm_zipcode         varchar(20)    --    NULL
           ,p_kd_kladr           varchar(15)    --    NULL
           ,p_vl_addr_latitude   numeric        --    NULL
           ,p_vl_addr_longitude  numeric        --    NULL 
           ,p_oper_type_id       bigint         -- Тип операции, с портала GAR-FIAS
           --
           ,p_sw                 boolean        -- Создаём историю, либо нет   
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------------
    --    2021-12-14  Создание/Обновление записи в ОТДАЛЁННОМ справочнике  
    --                   адресных пространств
    --    2021-12-21  p_oper_type_id = 20. Изменение. 
    --                  Проверяем на наличие нарушителей уникальности  
    --    2022-02-01  Расширенная обработка нарушения уникальности по второму индексу
    --    2022-02-10  Управление созданием истории.
    --    2022-02-21  Опция ONLY 
    -- -------------------------------------------------------------------------------
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
    -- -------------------------------------------------------------------------------
    --   2022-05-31 COALESCE только для NOT NULL полей.    
    -- -------------------------------------------------------------------------------
    --   2022-10-18 Вспомогательные таблицы..
    -- -------------------------------------------------------------------------------     
    DECLARE
      _exec text;
      
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
      --
        -- 2022-05-19/2022-05-31
      _upd_id text = $_$
            UPDATE ONLY %I.adr_area SET  
                 id_country     = COALESCE (%L, id_country    )::integer       -- NOT NULL  
                ,nm_area        = COALESCE (%L, nm_area       )::varchar(120)  -- NOT NULL
                ,nm_area_full   = COALESCE (%L, nm_area_full  )::varchar(4000) -- NOT NULL                         
                ,id_area_type   = %L::integer
                ,id_area_parent = %L::bigint
                 --
                ,kd_timezone  = %L::integer                               
                ,pr_detailed  = COALESCE (%L, pr_detailed )::smallint          -- NOT NULL                          
                ,kd_oktmo     = %L::varchar(11)  
                ,nm_fias_guid = %L::uuid
                
                ,dt_data_del    = %L::timestamp without time zone
                ,id_data_etalon = %L::bigint
                 --
                ,kd_okato          = %L::varchar(11)                           
                ,nm_zipcode        = %L::varchar(20)                           
                ,kd_kladr          = %L::varchar(15)                
                ,vl_addr_latitude  = %L::numeric                               
                ,vl_addr_longitude = %L::numeric                               
                    
            WHERE (id_area = %L::bigint);         
        $_$;          
        -- 2022-05-19/2022-05-31
        
      _rr   gar_tmp.adr_area_t; 
      _rr1  gar_tmp.adr_area_t;   

      -- _nm_fias_guid uuid;
      
      -- 2022-02-01 -- Общий родитель, одинаковые UUID но различные названия.
      --               Ту запись, которая уже была, ПЕРЕМЕЩАЕМ в историю со значением ID_REGION = 0
      --               (удаляем её из базы).
      _select_twin  text = $_$
          SELECT * FROM ONLY %I.adr_area 
                              WHERE ((nm_fias_guid = %L) AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL));
      $_$;     
      
      _del_twins  text = $_$
          DELETE FROM ONLY %I.adr_area WHERE (id_area = %L); 
      $_$;        
      -- 2022-02-01
      
      -- 2022-10-18
      UPD_OP CONSTANT char(1) := 'U';      
      
    BEGIN
    --
    -- 2022-05-19  Значение "p_nm_fias_guid" уже присутсвует в БД.
    --        Четвёрка "id_country", "id_area_parent", "id_area_type", "nm_area" 
    --        может вызвать исключение.    
    --
     _rr :=  gar_tmp_pcg_trans.f_adr_area_get (p_schema_name, p_nm_fias_guid);
                                              
     IF (_rr.id_area IS NOT NULL)
       THEN
        IF 
          ((_rr.id_country     IS DISTINCT FROM p_id_country)     AND (p_id_country IS NOT NULL)) OR                 
          ((_rr.id_area_parent IS DISTINCT FROM p_id_area_parent)) OR  --  AND (p_id_area_parent IS NOT NULL)                
          ((_rr.id_area_type   IS DISTINCT FROM p_id_area_type))   OR  --  AND (p_id_area_type   IS NOT NULL)  
          ((upper(_rr.nm_area) IS DISTINCT FROM upper(p_nm_area)) AND (p_nm_area IS NOT NULL)) OR      
          -- 2022-01-28 
          ((_rr.nm_fias_guid   IS DISTINCT FROM p_nm_fias_guid)   AND (p_nm_fias_guid  IS NOT NULL)) OR 
          ((upper(_rr.nm_area_full) IS DISTINCT FROM upper(p_nm_area_full)) AND (p_nm_area_full IS NOT NULL)) OR
          
          ((_rr.kd_oktmo     IS DISTINCT FROM p_kd_oktmo    )) OR --  AND (p_kd_oktmo     IS NOT NULL)
          ((_rr.kd_okato     IS DISTINCT FROM p_kd_okato    )) OR --  AND (p_kd_okato     IS NOT NULL)
          ((_rr.nm_zipcode   IS DISTINCT FROM p_nm_zipcode  )) OR --  AND (p_nm_zipcode   IS NOT NULL)  
          ((_rr.kd_kladr     IS DISTINCT FROM p_kd_kladr    ))    --  AND (p_kd_kladr     IS NOT NULL)
         
        THEN
           IF p_sw
             THEN
                -- Старые значения с новым ID и признаком удаления
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
                                      ,_rr.id_area -- id_data_etalon   
                                      ,_rr.kd_okato         
                                      ,_rr.nm_zipcode       
                                      ,_rr.kd_kladr         
                                      ,_rr.vl_addr_latitude 
                                      ,_rr.vl_addr_longitude 
                                      --
                                      , NULL  -- id_region
                );            
                EXECUTE _exec;               
           END IF; -- p_sw
            -- update,  
            --
           _exec := format (_upd_id, p_schema_name 
                                    ,p_id_country       
                                    ,p_nm_area          
                                    ,p_nm_area_full     
                                    ,p_id_area_type     
                                    ,p_id_area_parent  
                                    --
                                    ,p_kd_timezone      
                                    ,p_pr_detailed   
                                    ,p_kd_oktmo         
                                    ,p_nm_fias_guid   
                                    
                                    ,NULL -- dt_data_del
                                    ,NULL -- data_etalon
                                    
                                    ,p_kd_okato  
                                    ,p_nm_zipcode       
                                    ,p_kd_kladr         
                                    ,p_vl_addr_latitude 
                                    ,p_vl_addr_longitude
                                     --
                                    ,_rr.id_area 
           );                       
           EXECUTE _exec;
           --
           INSERT INTO gar_tmp.adr_area_aux (id_area, op_sign)
           VALUES (_rr.id_area, UPD_OP)
            ON CONFLICT (id_area) DO UPDATE SET op_sign = UPD_OP
                  WHERE (gar_tmp.adr_area_aux.id_area = excluded.id_area);           
           
        END IF; -- compare
        
     END IF; -- _rr.id_area IS NOT NULL
      
    -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    EXCEPTION  -- Возникает на отдалённом сервере    
      -- UNIQUE INDEX _xxx_adr_area_ie2 ON unnsi.adr_area USING btree (nm_fias_guid ASC NULLS LAST) 
    
      WHEN unique_violation THEN 
       BEGIN
        -- _exec := format (_select_twin, p_schema_name, p_nm_fias_guid);
        -- EXECUTE _exec INTO _rr1;  -- Дублёр
        -- Допустим, что это будет возможным. 
        
        _rr =  gar_tmp_pcg_trans.f_adr_area_get (p_schema_name, p_nm_fias_guid);  -- Основная запись
        _rr1 =  gar_tmp_pcg_trans.f_adr_area_get (p_schema_name, p_id_country
                                            ,p_id_area_parent, p_id_area_type, p_nm_area
        );
        
        IF (_rr1.id_area IS NOT NULL) -- Записываем в историю и сохраняем в базе вне основного контекста..
           THEN
             _exec := format (_ins_hist, p_schema_h
             
                         ,_rr1.id_area       
                         ,_rr1.id_country       
                         ,_rr1.nm_area          
                         ,_rr1.nm_area_full     
                         ,_rr1.id_area_type     
                         ,_rr1.id_area_parent   
                         ,_rr1.kd_timezone      
                         ,_rr1.pr_detailed  
                         , now()      --  dt_data_del
                         ,_rr1.kd_oktmo         
                         ,_rr1.nm_fias_guid   
                         ,_rr1.id_area -- id_data_etalon   
                         ,_rr1.kd_okato         
                         ,_rr1.nm_zipcode       
                         ,_rr1.kd_kladr         
                         ,_rr1.vl_addr_latitude 
                         ,_rr1.vl_addr_longitude 
                         ,0 -- Регион "0" - Исключение во время процесса дополнения.
             );            
             EXECUTE _exec;      
             --
             --  _exec := format (_del_twins, p_schema_name, _rr1.id_area);
             --  EXECUTE _exec;
             --
             _exec := format (_upd_id, p_schema_name 
                                       ,_rr1.id_country       
                                       ,_rr1.nm_area          
                                       ,_rr1.nm_area_full     
                                       ,_rr1.id_area_type     
                                       ,_rr1.id_area_parent  
                                       --
                                       ,_rr1.kd_timezone      
                                       ,_rr1.pr_detailed   
                                       ,_rr1.kd_oktmo         
                                       ,_rr1.nm_fias_guid   
                                       
                                       ,now()       -- dt_data_del
                                       ,_rr.id_area -- data_etalon
                                       
                                       ,_rr1.kd_okato  
                                       ,_rr1.nm_zipcode       
                                       ,_rr1.kd_kladr         
                                       ,_rr1.vl_addr_latitude 
                                       ,_rr1.vl_addr_longitude
                                        --
                                       ,_rr1.id_area 
             );                       
             EXECUTE _exec;
             --
             INSERT INTO gar_tmp.adr_area_aux (id_area, op_sign)
             VALUES (_rr1.id_area, UPD_OP)
              ON CONFLICT (id_area) DO UPDATE SET op_sign = UPD_OP
                    WHERE (gar_tmp.adr_area_aux.id_area = excluded.id_area);               
             
        END IF; -- _rr1.id_area IS NOT NULL
        
        -- Поскольку процесс обновления прервался, повторяю его.
        -- Старые значения в историю, но сечас это управляется переключателем.
        --
        IF (_rr.id_area IS NOT NULL) AND (_rr1.id_area IS NOT NULL)
           THEN
             IF p_sw
               THEN
                  -- Старые значения с новым ID и признаком удаления
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
                                        ,_rr.id_area -- id_data_etalon   
                                        ,_rr.kd_okato         
                                        ,_rr.nm_zipcode       
                                        ,_rr.kd_kladr         
                                        ,_rr.vl_addr_latitude 
                                        ,_rr.vl_addr_longitude 
                                        --
                                        , NULL  -- id_region
                  );            
                  EXECUTE _exec;      

             END IF;
               
              -- update,  
             _exec := format (_upd_id, p_schema_name 
                                     ,p_id_country       
                                     ,p_nm_area          
                                     ,p_nm_area_full     
                                     ,p_id_area_type     
                                     ,p_id_area_parent  
                                     --
                                     ,p_kd_timezone      
                                     ,p_pr_detailed   
                                     ,p_kd_oktmo         
                                     ,p_nm_fias_guid   
                                      --
                                     ,NULL -- dt_data_del
                                     ,NULL -- data_etalon
                                      --
                                     ,p_kd_okato  
                                     ,p_nm_zipcode       
                                     ,p_kd_kladr         
                                     ,p_vl_addr_latitude 
                                     ,p_vl_addr_longitude
                                      --
                                     ,_rr.id_area 
             );                       
             EXECUTE _exec;    
             --
             INSERT INTO gar_tmp.adr_area_aux (id_area, op_sign)
             VALUES (_rr.id_area, UPD_OP)
              ON CONFLICT (id_area) DO UPDATE SET op_sign = UPD_OP
                    WHERE (gar_tmp.adr_area_aux.id_area = excluded.id_area);               
        --
        END IF; -- _rr.id_area IS NOT NULL    
       END;  -- unique_violation
       -- +++++++++
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_area_upd 
               (text, text, bigint, integer, varchar(120), varchar(4000), integer, bigint, integer
               ,smallint, varchar(11), uuid, bigint, varchar(11), varchar(20), varchar(15)
               ,numeric, numeric,bigint, boolean
               ) 
         IS 'Обновление записи в ОТДАЛЁННОМ справочнике адресных пространств';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_area_upd ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_area_upd ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);



