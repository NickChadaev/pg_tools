DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_del_twin (
                  text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text 
 );   
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_del_twin_0 (
                  text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text 
 );    
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.fp_adr_house_del_twin_0 (
        p_schema_name      text  
       ,p_id_house         bigint       --  NOT NULL
       ,p_id_area          bigint       --  NOT NULL
       ,p_id_street        bigint       --      NULL
       ,p_nm_house_full    varchar(250) --  NOT NULL
       ,p_nm_fias_guid     uuid
       ,p_mode             boolean = TRUE  -- используется в процессе обработки
                                 --  FALSE -- в постобработке.
       ,p_bound_date       date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name text = 'gar_tmp'                     
)
    RETURNS integer
    LANGUAGE plpgsql 
    SECURITY DEFINER
    AS $$
    -- ---------------------------------------------------------------------------
    --  2022-02-28  Убираем дубли. 
    --  2022-02-28 Поиск близнецов. Два режима: 
    --    Поиск в процессе обработки, загрузочное индексное покрытие. 
    --    Поиск в после обработки, эксплуатационное индексное покрытие:
    --
    -- Используется технологический индекс (поиск в процессе обработки):
    --    UNIQUE INDEX _xxx_adr_house_ak1 ON unnsi.adr_house USING btree
    --                        (id_area ASC NULLS LAST
    --                        ,upper (nm_house_full::text) ASC NULLS LAST
    --                        ,id_street ASC NULLS LAST
    --                        ,id_house_type_1 ASC NULLS LAST
    --                        )
    --                    WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL)  
    -- ---------------------------------------------------------------------------
    --  2022-03-03  Двурежимная работа процедуры.
    --  Поиск в процессе постобработки, 
    --            используется индекс ""adr_house_ak1",  без уникальности 
    --
    --  INDEX adr_house_ak1
    --    ON unnsi.adr_house USING btree (id_area ASC NULLS LAST, upper(nm_house_full::text) ASC NULLS LAST
    --   , id_street ASC NULLS LAST)
    --    WHERE id_data_etalon IS NULL;
    -- ---------------------------------------------------------------------------
    --  2022-04-04 Постобработка, историческая запись должна содержать ссылку на 
    --             воздействующий субъект (id_data_etalon := id_house)
    --  --------------------------------------------------------------------------
    --  2022-06-20 Постобработка, только.
    -- ---------------------------------------------------------------------------
    -- 	ЗАМЕЧАНИЕ:  warning extra:00000:134:DECLARE:never read variable "_sel_twin_proc"
    --  ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_nm_fias_guid"
	
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
                ,dt_data_del       = COALESCE (dt_data_del, %L)::timestamp without time zone              --  NULL
                ,id_data_etalon    = %L::bigint                                   --  NULL
                ,kd_okato          = COALESCE (%L, kd_okato)::varchar(11)         --  NULL
                ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric    --  NULL
                ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric    --  NULL
                    
            WHERE (id_house = %L::bigint);
        $_$;        
      --
      _upd_id_1 text = $_$
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
       _select_u text = $_$
             SELECT h.* FROM ONLY %I.adr_house h WHERE (h.id_house = %L);
       $_$;
           --
       _del_twin  text = $_$             --        
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
      _sel_twin_proc  text = $_$
           SELECT * FROM ONLY %I.adr_house
               WHERE
                ((id_area = %L::bigint) AND 
                    (
                      (  -- На ОДНОЙ улице разные названия, UUIDs тождественны
                        (NOT (upper(nm_house_full::text) = upper (%L)::text)) AND
                        (id_street IS NOT DISTINCT FROM %L::bigint)  AND
                        (nm_fias_guid = %L::uuid)
                      )
                         OR
                      (     -- На РАЗНЫХ улицах одинаковые названия, UUIDs тождественны
                        (upper(nm_house_full::text) = upper (%L)::text) AND
                        (id_street IS DISTINCT FROM %L::bigint) AND 
                        (nm_fias_guid = %L::uuid)
                      )
                         OR
                      (   -- На ОДНОЙ улице одинаковые названия, UUIDs различаются
                        (upper(nm_house_full::text) = upper (%L)::text) AND
                        (id_street IS NOT DISTINCT FROM %L::bigint)  AND
                        (NOT (nm_fias_guid = %L::uuid))                   
                      )
                    ) 
                      AND 
                          ((id_data_etalon IS NULL) AND (dt_data_del IS NULL))    
                )
                
                OR -- Разные регионы (адресные пространства), одинаковые названия и UUID
                
                (((NOT (id_area = %L::bigint)) AND
                        (upper(nm_house_full::text) = upper (%L)::text) AND
                        (id_street IS NOT DISTINCT FROM %L::bigint) AND 
                        (nm_fias_guid = %L::uuid)
                 )
                     AND 
                 ((id_data_etalon IS NULL) AND (dt_data_del IS NULL))    
                );
       $_$;
       -- Различаются ID.      
      _sel_twin_post  text = $_$     
           SELECT * FROM ONLY %I.adr_house
                   -- В пределах одного региона, 
                   -- на ОДНОЙ улице одинаковые названия, разница в UUIDs не важна
                   --
               WHERE ((id_area = %L::bigint) AND    
                   (
                            (upper(nm_house_full::text) = upper (%L)::text) AND
                            (id_street IS NOT DISTINCT FROM %L::bigint)  AND
                            (NOT (id_house = %L::bigint))
                     
                   ) AND (id_data_etalon IS NULL) 
                );
                --
                -- Либо различные регионы, одинаковые UUIDs, разница в улицах не важна
                --
       $_$;
       --
      _rr    gar_tmp.adr_house_t; 
      _rr1   gar_tmp.adr_house_t; 
      _qty integer;
      
    BEGIN
     _qty := 0;
    
     IF p_mode
       THEN -- Обработка
         NULL;
             
       ELSE -- Постобработка
         _exec := format (_sel_twin_post, p_schema_name
                                ,p_id_area
                                 --
                                ,p_nm_house_full
                                ,p_id_street
                                 --
                                ,p_id_house
         );         
         EXECUTE _exec INTO _rr1; -- Поиск дублёра
         ----------------
         -- Двойники: см. определение выше
         --
         IF (_rr1.id_house IS NOT NULL) -- Найден. 
           THEN
            IF (_rr1.dt_data_del <=  p_bound_date) AND (_rr1.dt_data_del IS NOT NULL)
              THEN
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
                     _qty := 1;
            ELSE
               -- -----------------------------------------------------------------
               --  (dt_data_del >  p_bound_date) AND (dt_data_del IS NOT NULL) 
               --                   OR (dt_data_del IS NULL)
               -- -----------------------------------------------------------------
               -- Дублёр существует, он обновляется данными из проверяемой записи,
               -- проверяемая запись удаляется.
               -- -----------------------------------------------------------------
               _exec = format (_select_u, p_schema_name, p_id_house);
               EXECUTE _exec INTO _rr; -- проверяемая запись, полная структура.
               IF _rr.id_house IS NOT NULL 
                 THEN
                     _exec = format (_del_twin, p_schema_name, _rr.id_house);  
                     EXECUTE _exec;   -- Проверяемая запись
                     --
                     --    UPDATE _rr1 Обновление дублёра.
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
                             ,_rr.id_house          --    _rr1.id_data_etalon     
                             ,_rr1.kd_okato          
                             ,_rr1.vl_addr_latitude  
                             ,_rr1.vl_addr_longitude
                             , -1 -- ID региона
                     ); 
                     EXECUTE _exec;
                     --      
                     --  Обновляется старое значение  ??? Сколько их ??
                     --
                     _exec = format (_upd_id_1, p_schema_name
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
                                     ,_rr1.nm_fias_guid   -- 2022-06-20 Сохраняется старый UUID  
                                     ,NULL      
                                     ,NULL  
                                     ,_rr.kd_okato         
                                     ,_rr.vl_addr_latitude 
                                     ,_rr.vl_addr_longitude
                                      --  
                                     ,_rr1.id_house               
                     );
                     EXECUTE _exec;
                     _qty := 1;
                     
               END IF; -- _rr.id_house IS NOT NULL
            END IF; -- (_rr1.dt_data_del <=  p_bound_date) AND (_rr1.dt_data_del IS NOT NULL)
         END IF; --  _rr1.id_house IS NOT NULL
     END IF; -- p_mode
     
     RETURN _qty;
    END;
  $$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.fp_adr_house_del_twin_0 
    (text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text)
    IS 'Удаление/Слияние дублей';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- CALL gar_tmp_pcg_trans.fp_adr_house_del_twin (
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
