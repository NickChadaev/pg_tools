DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_del_twin (
                  text, bigint, bigint, varchar(120), integer, uuid, boolean, date, text 
 );   
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_street_del_twin (
        p_schema_name      text  
        --
       ,p_id_street        bigint
       ,p_id_area          bigint      
       ,p_nm_street        varchar(120)
       ,p_id_street_type   integer
       ,p_nm_fias_guid     uuid 
        --            
       ,p_mode             boolean = TRUE  -- используется в процессе обработки
                                 --  FALSE -- в постобработке.
       ,p_bound_date       date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name text = 'gar_tmp'                     
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ---------------------------------------------------------------------------
    --  2022-04-22  оиск близнецов. Два режима: 
    --    Поиск в процессе обработки, загрузочное индексное покрытие. 
    --    Поиск в после обработки, эксплуатационное индексное покрытие:
    --    В процессе постобработки, 
    --            используется индекс ""adr_street_ak1",  без уникальности 
    --
    --         CREATE INDEX adr_street_ak1
    --             ON unnsi.adr_street USING btree
    --               (id_area                ASC NULLS LAST
    --               ,upper(nm_street::text) ASC NULLS LAST
    --               ,id_street_type         ASC NULLS LAST
    --             )
    --             WHERE id_data_etalon IS NULL
    --
    --    Историческая запись должна содержать ссылку на 
    --                     воздействующий субъект (id_data_etalon := id_street)
    -- ---------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _upd_id text = $_$
            UPDATE ONLY %I.adr_street SET  
                  id_area           = COALESCE (%L, id_area       )::bigint                                 
                , nm_street         = COALESCE (%L, nm_street     )::varchar(120)                       
                , id_street_type    = COALESCE (%L, id_street_type)::integer                                
                , nm_street_full    = COALESCE (%L, nm_street_full)::varchar(255)                           
                , nm_fias_guid      = COALESCE (%L, nm_fias_guid  )::uuid
                , dt_data_del       = COALESCE (dt_data_del, %L)::timestamp without time zone              --  NULL
                , id_data_etalon    = %L::bigint                                   --  NULL
                , kd_kladr          = COALESCE (%L, kd_kladr      )::varchar(15)
                , vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric                
                , vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric                
            WHERE (id_street = %L::bigint);        
       $_$;   
      --
      _upd_id_1 text = $_$
            UPDATE ONLY %I.adr_street SET  
                  id_area           = COALESCE (%L, id_area       )::bigint                                 
                , nm_street         = COALESCE (%L, nm_street     )::varchar(120)                       
                , id_street_type    = COALESCE (%L, id_street_type)::integer                                
                , nm_street_full    = COALESCE (%L, nm_street_full)::varchar(255)                           
                , nm_fias_guid      = COALESCE (%L, nm_fias_guid  )::uuid
                , dt_data_del       = %L::timestamp without time zone              --  NULL
                , id_data_etalon    = %L::bigint                                   --  NULL
                , kd_kladr          = COALESCE (%L, kd_kladr      )::varchar(15)
                , vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric                
                , vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric                
            WHERE (id_street = %L::bigint);   
       $_$;      
      -- 
       _select_u text = $_$
             SELECT s.* FROM ONLY %I.adr_street s WHERE (s.id_street = %L);
       $_$;
           --
       _del_twin  text = $_$             --        
              DELETE FROM ONLY %I.adr_street WHERE (id_street = %L);                     
       $_$;
       --
      _ins_hist text = $_$
            INSERT INTO %I.adr_street_hist (
                               id_street
                             , id_area
                             , nm_street
                             , id_street_type
                             , nm_street_full
                             , nm_fias_guid
                             , dt_data_del
                             , id_data_etalon
                             , kd_kladr
                             , vl_addr_latitude
                             , vl_addr_longitude
                             , id_region
            )
              VALUES (   %L::bigint                    
                        ,%L::bigint                    
                        ,%L::varchar(120)               
                        ,%L::integer                   
                        ,%L::varchar(255)               
                        ,%L::uuid 
                        ,%L::timestamp without time zone
                        ,%L::bigint                     
                        ,%L::varchar(15)               
                        ,%L::numeric                    
                        ,%L::numeric    
                        ,%L::bigint
              );      
        $_$;             
       -- -------------------------------------------------------------------------
       --
      _sel_twin_post  text = $_$     
           SELECT * FROM ONLY %I.adr_street
                   -- В пределах одного региона, одинаковые названия и типы, 
                   --   разница в UUIDs не важна
                   --
               WHERE ( (id_area = %L::bigint) AND    
                       (NOT (id_street = %L::bigint)) AND 
                       (
                           (upper(nm_street::text) = upper (%L)::text) AND
                           (id_street_type IS NOT DISTINCT FROM %L::bigint) 
                       ) AND (id_data_etalon IS NULL) 
                );
       $_$;
       --
      _rr    gar_tmp.adr_street_t; 
      _rr1   gar_tmp.adr_street_t; 
      
    BEGIN
     IF p_mode
       THEN -- Обработка
             NULL;             
       ELSE -- Постобработка
         _exec := format (_sel_twin_post, p_schema_name
                                ,p_id_area
                                ,p_id_street
                                 --
                                ,p_nm_street
                                ,p_id_street_type
                                 --
         );         
         EXECUTE _exec INTO _rr1; -- Поиск дублёра
         ----------------
         -- Двойники:  
         --
         IF (_rr1.id_street IS NOT NULL) -- Найден. 
           THEN
            IF (_rr1.dt_data_del <=  p_bound_date) AND (_rr1.dt_data_del IS NOT NULL)
              THEN
                   _exec = format (_upd_id, p_schema_name
                                       --
                                     ,_rr1.id_area           
                                     ,_rr1.nm_street         
                                     ,_rr1.id_street_type    
                                     ,_rr1.nm_street_full    
                                      --       
                                     ,_rr1.nm_fias_guid  
                                      --
                                     ,_rr1.dt_data_del      
                                     ,p_id_street 
                                      --
                                     ,_rr1.kd_kladr         
                                     ,_rr1.vl_addr_latitude 
                                     ,_rr1.vl_addr_longitude
                                      --   
                                     ,_rr1.id_street               
                     );
                     EXECUTE _exec; -- Связали.
            ELSE
               -- -----------------------------------------------------------------
               --  (dt_data_del >  p_bound_date) AND (dt_data_del IS NOT NULL) 
               --                   OR (dt_data_del IS NULL)
               -- -----------------------------------------------------------------
               -- Дублёр существует, он обновляется данными из проверяемой записи,
               -- проверяемая запись удаляется.
               -- -----------------------------------------------------------------
               _exec = format (_select_u, p_schema_name, p_id_street);
               EXECUTE _exec INTO _rr; -- проверяемая запись, полная структура.
               IF _rr.id_street IS NOT NULL 
                 THEN
                     _exec = format (_del_twin, p_schema_name, _rr.id_street);  
                     EXECUTE _exec;   -- Проверяемая запись
                     --
                     --    UPDATE _rr1 Обновление дублёра.
                     --    Старое значение уходит в историю
                     --
                     _exec := format (_ins_hist, p_schema_hist_name  
                                       --
                                     ,_rr1.id_street               
                                     ,_rr1.id_area           
                                     ,_rr1.nm_street         
                                     ,_rr1.id_street_type    
                                     ,_rr1.nm_street_full    
                                      --       
                                     ,_rr1.nm_fias_guid  
                                      --
                                     ,now()              --    _rr1.dt_data_del     
                                     ,_rr.id_street         --    _rr1.id_data_etalon     
                                      --
                                     ,_rr1.kd_kladr         
                                     ,_rr1.vl_addr_latitude 
                                     ,_rr1.vl_addr_longitude
                                      --   
                                     ,-1 -- ID региона
                     ); 
                     EXECUTE _exec;
                     --      
                     --  Обновляется старое значение  ??? Сколько их ??
                     --
                     _exec = format (_upd_id_1, p_schema_name
                                         --
                                       ,_rr1.id_area           
                                       ,_rr1.nm_street         
                                       ,_rr1.id_street_type    
                                       ,_rr1.nm_street_full    
                                        --       
                                       ,_rr1.nm_fias_guid  
                                        --
                                       ,NULL      
                                       ,NULL 
                                        --
                                       ,_rr1.kd_kladr         
                                       ,_rr1.vl_addr_latitude 
                                       ,_rr1.vl_addr_longitude
                                        --   
                                       ,_rr1.id_street               
                       );
                     
                     
                     EXECUTE _exec;
               END IF; -- _rr.id_street IS NOT NULL
            END IF; -- (_rr1.dt_data_del <=  p_bound_date) AND (_rr1.dt_data_del IS NOT NULL)
         END IF; --  _rr1.id_street IS NOT NULL
         
     END IF; -- p_mode
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_del_twin 
    (text, bigint, bigint, varchar(120), integer, uuid, boolean, date, text)
    IS 'Удаление/Слияние дублей. УЛИЦЫ';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- CALL gar_tmp_pcg_trans.p_adr_street_del_twin (
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
