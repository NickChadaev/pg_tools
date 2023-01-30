DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_area_del_twin (
                  text, bigint, integer, bigint, integer, varchar(120), uuid, date, text 
 );   
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.fp_adr_area_del_twin (
        p_schema_name      text  
       ,p_id_area          bigint      
        --
       ,p_id_country       integer      
       ,p_id_area_parent   bigint       
       ,p_id_area_type     integer      
       ,p_nm_area          varchar(120)      
       ,p_nm_fias_guid     uuid 
        --
       ,p_bound_date       date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name text = 'gar_tmp'                     
        --
       ,OUT fcase         integer
       ,OUT id_area_subj  bigint
       ,OUT id_area_obj   bigint
       ,OUT nm_area       varchar(120)
       ,OUT nm_fias_guid  uuid       
)
    RETURNS setof record
    LANGUAGE plpgsql 
    SECURITY DEFINER
    AS $$
    -- ------------------------------------------------------------------------------
    --  2022-04-22  Поиск близнецов. Два режима: 
    --    Поиск в процессе обработки, загрузочное индексное покрытие. 
    --    Поиск в после обработки, эксплуатационное индексное покрытие:
    --    В процессе постобработки индексы не используются ???
    --    Историческая запись должна содержать ссылку на 
    --                     воздействующий субъект (id_data_etalon := id_area)
    -- ------------------------------------------------------------------------------
    --  2022-12-12 Проверяемая запись обновляется  данными дублёра, дублёр удаляется.
    -- ------------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _upd_id text = $_$
            UPDATE ONLY %I.adr_area SET  
                 id_country     = COALESCE (%L, id_country    )::integer       -- NOT NULL  
                ,nm_area        = COALESCE (%L, nm_area       )::varchar(120)  -- NOT NULL
                ,nm_area_full   = COALESCE (%L, nm_area_full  )::varchar(4000) -- NOT NULL                         
                ,id_area_type   = %L::integer
                ,id_area_parent = %L::bigint
                 --
                ,kd_timezone  = COALESCE (%L, kd_timezone)::integer       -- 2022-11-07                   
                ,pr_detailed  = COALESCE (%L, pr_detailed)::smallint      -- NOT NULL                          
                ,kd_oktmo     = COALESCE (%L, kd_oktmo)::varchar(11)  
                ,nm_fias_guid = %L::uuid
                
                ,dt_data_del    = %L::timestamp without time zone
                ,id_data_etalon = %L::bigint
                 --
                ,kd_okato   = COALESCE (%L, kd_okato)::varchar(11)         -- 2022-11-07                      
                ,nm_zipcode = COALESCE (%L, nm_zipcode)::varchar(20)                           
                ,kd_kladr   = COALESCE (%L, kd_kladr)::varchar(15)                
                ,vl_addr_latitude  = %L::numeric                               
                ,vl_addr_longitude = %L::numeric                               
                    
            WHERE (id_area = %L::bigint);
       $_$;			
        -- 
       _del_twin  text = $_$                     
              DELETE FROM ONLY %I.adr_area WHERE (id_area = %L);                     
       $_$;
       --
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
       -- -------------------------------------------------------------------------
       --
       _sel_twin_post  text = $_$     
           SELECT * FROM ONLY %I.adr_area
                   -- В пределах одной страны, одного родительского региона, 
                   -- должны быть одинаковые названия и типы, разница в UUIDs не важна
                   --
               WHERE ( (id_country = %L::integer) AND    
                       (NOT (id_area = %L::bigint)) AND 
                       (
                           (upper(nm_area::text) = upper (%L)::text) AND
                           (id_area_type IS NOT DISTINCT FROM %L::integer) AND
                           (id_area_parent IS NOT DISTINCT FROM %L::bigint)
                           
                       ) AND (id_data_etalon IS NULL) 
               );
       $_$;
       --
      _rr   gar_tmp.adr_area_t; 
      _rr1  gar_tmp.adr_area_t;  
      --
      UPD_OP CONSTANT char(1) := 'U';       
      BOUND_VALUE CONSTANT bigint := 100000000;
      
    BEGIN
     _exec := format (_sel_twin_post, p_schema_name
                            ,p_id_country
                            ,p_id_area
                             --
                            ,p_nm_area
                            ,p_id_area_type
                            ,p_id_area_parent
     );         
     EXECUTE _exec INTO _rr1; -- Поиск дублёра
     -----------------------------------------
     -- Двойники:  
     --
     IF (_rr1.id_area IS NOT NULL) -- Найден. 
       THEN
        -- Проверяемая запись, полная структур       
        _rr := gar_tmp_pcg_trans.f_adr_area_get (p_schema_name, p_id_area);
        
        IF (_rr1.dt_data_del <=  p_bound_date) AND (_rr1.dt_data_del IS NOT NULL)
          THEN -- Мусор, кто-то, раньше, его ручками удалил.
             _exec = format (_upd_id, p_schema_name
                                 --
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
                                --
                               ,_rr1.dt_data_del      
                               ,p_id_area 
                                --
                               ,_rr1.kd_okato           
                               ,_rr1.nm_zipcode         
                               ,_rr1.kd_kladr           
                               ,_rr1.vl_addr_latitude 
                               ,_rr1.vl_addr_longitude
                                --   
                               ,_rr1.id_area               
             );
             EXECUTE _exec; -- Связали. 
             --  
             INSERT INTO gar_tmp.adr_area_aux (id_area, op_sign)  
                VALUES (_rr1.id_area, UPD_OP)
                  ON CONFLICT (id_area) DO UPDATE SET op_sign = UPD_OP
                      WHERE (gar_tmp.adr_area_aux.id_area = excluded.id_area); 
             -- -----------------------------------------------------------------    
             fcase := 4; -- Дублёр НЕ актуален, проверяемая - актуальна 
             --             ДУБЛЁР был удалён логически.                  
             -- -----------------------------------------------------------------
             --  (dt_data_del >  p_bound_date) AND (dt_data_del IS NOT NULL) 
             --                   OR (dt_data_del IS NULL)
             -- -----------------------------------------------------------------
        
        ELSIF (_rr.id_area > BOUND_VALUE) AND (_rr1.id_area < BOUND_VALUE)
          THEN -- Дублёр обновляется данными проверяемой записи,
               --     проверяемая запись удаляется (сохранение старых id_area).
           -- -------------------------------------------------------------------
           IF _rr1.id_area IS NOT NULL 
             THEN
               _exec = format (_del_twin, p_schema_name, _rr.id_area);  
               EXECUTE _exec;   -- Проверяемая запись убита
               --
               -- Создаю запись-фантом, "_rr.id_area" потом удалится в отдалённой базе.
               --   
               INSERT INTO gar_tmp.adr_area_aux (id_area, op_sign)
                 VALUES (_rr.id_area, UPD_OP)
                   ON CONFLICT (id_area) DO UPDATE SET op_sign = UPD_OP
                       WHERE (gar_tmp.adr_area_aux.id_area = excluded.id_area);                 
               --
               --    Проверяемая запись уходит в историю
               --
               _exec := format (_ins_hist, p_schema_hist_name  
                                 --
                               ,_rr.id_area           
                               ,_rr.id_country        
                               ,_rr.nm_area           
                               ,_rr.nm_area_full      
                               ,_rr.id_area_type      
                               ,_rr.id_area_parent    
                               ,_rr.kd_timezone       
                               ,_rr.pr_detailed   
                               
                               ,now()          -- _rr.dt_data_del 
                               
                               ,_rr.kd_oktmo          
                               ,_rr.nm_fias_guid      
                               
                               ,_rr.id_area        -- _rr.id_data_etalon    
                               
                               ,_rr.kd_okato          
                               ,_rr.nm_zipcode        
                               ,_rr.kd_kladr          
                               ,_rr.vl_addr_latitude  
                               ,_rr.vl_addr_longitude
                               ,-1 -- ID региона
               ); 
               EXECUTE _exec;
               --
               --    Старое значение дублёра уходит в историю
               --
               _exec := format (_ins_hist, p_schema_hist_name  
                                 --
                               ,_rr1.id_area           
                               ,_rr1.id_country        
                               ,_rr1.nm_area           
                               ,_rr1.nm_area_full      
                               ,_rr1.id_area_type      
                               ,_rr1.id_area_parent    
                               ,_rr1.kd_timezone       
                               ,_rr1.pr_detailed   
                               
                               ,now()          -- _rr.dt_data_del 
                               
                               ,_rr1.kd_oktmo          
                               ,_rr1.nm_fias_guid      
                               
                               ,_rr.id_area        -- _rr.id_data_etalon    
                               
                               ,_rr1.kd_okato          
                               ,_rr1.nm_zipcode        
                               ,_rr1.kd_kladr          
                               ,_rr1.vl_addr_latitude  
                               ,_rr1.vl_addr_longitude
                               ,-1 -- ID региона
               ); 
               EXECUTE _exec;
               --      
               -- Обновляется дублёр данными проверяемой записи
               --
               _exec = format (_upd_id, p_schema_name
                                   --
                                ,_rr.id_country       
                                ,_rr.nm_area        
                                ,_rr.nm_area_full                            
                                ,_rr.id_area_type   
                                ,_rr.id_area_parent 
                                  --
                                ,_rr.kd_timezone                     
                                ,_rr.pr_detailed                          
                                ,_rr.kd_oktmo     
                                ,_rr.nm_fias_guid 
                                  --
                                ,NULL   
                                ,NULL
                                  --
                                ,_rr.kd_okato                        
                                ,_rr.nm_zipcode       
                                ,_rr.kd_kladr  
                                ,_rr.vl_addr_latitude                              
                                ,_rr.vl_addr_longitude              
                                  --   
                                ,_rr1.id_area              
               );
               EXECUTE _exec;
               fcase := 5;  -- ДУБЛЁР ОБНОВИЛСЯ, проверяемая запись УДАЛИЛАСЬ
               
               INSERT INTO gar_tmp.adr_area_aux (id_area, op_sign)
                 VALUES (_rr1.id_area, UPD_OP)
                   ON CONFLICT (id_area) DO UPDATE SET op_sign = UPD_OP
                        WHERE (gar_tmp.adr_area_aux.id_area = excluded.id_area);                
               
           END IF; -- _rr.id_area IS NOT NULL
           
        ELSIF (_rr.id_area < BOUND_VALUE) AND (_rr1.id_area > BOUND_VALUE)
          THEN -- Проверяемая запись обновляется данными дублёра,
           -- ---------------------------------------------------
           IF _rr.id_area IS NOT NULL 
             THEN
               _exec = format (_del_twin, p_schema_name, _rr1.id_area);  
               EXECUTE _exec;   -- Дублёр убит
               --
               -- Создаю запись-фантом, "_rr1.id_area" потом удалится в отдалённой базе.
               --   
               INSERT INTO gar_tmp.adr_area_aux (id_area, op_sign)
                 VALUES (_rr1.id_area, UPD_OP)
                   ON CONFLICT (id_area) DO UPDATE SET op_sign = UPD_OP
                       WHERE (gar_tmp.adr_area_aux.id_area = excluded.id_area);                 
               --
               --  Дублёр уходит в историю
               --
               _exec := format (_ins_hist, p_schema_hist_name  
                                 --
                               ,_rr1.id_area           
                               ,_rr1.id_country        
                               ,_rr1.nm_area           
                               ,_rr1.nm_area_full      
                               ,_rr1.id_area_type      
                               ,_rr1.id_area_parent    
                               ,_rr1.kd_timezone       
                               ,_rr1.pr_detailed   
                               
                               ,now()          -- _rr.dt_data_del 
                               
                               ,_rr1.kd_oktmo          
                               ,_rr1.nm_fias_guid      
                               
                               ,_rr1.id_area        -- _rr.id_data_etalon    
                               
                               ,_rr1.kd_okato          
                               ,_rr1.nm_zipcode        
                               ,_rr1.kd_kladr          
                               ,_rr1.vl_addr_latitude  
                               ,_rr1.vl_addr_longitude
                               ,-1 -- ID региона
               ); 
               EXECUTE _exec;
               --
               --  Старое значение проверяемой записи уходит в историю
               --
               _exec := format (_ins_hist, p_schema_hist_name  
                                 --
                               ,_rr.id_area           
                               ,_rr.id_country        
                               ,_rr.nm_area           
                               ,_rr.nm_area_full      
                               ,_rr.id_area_type      
                               ,_rr.id_area_parent    
                               ,_rr.kd_timezone       
                               ,_rr.pr_detailed   
                               
                               ,now()          -- _rr.dt_data_del 
                               
                               ,_rr.kd_oktmo          
                               ,_rr.nm_fias_guid      
                               
                               ,_rr1.id_area        -- _rr.id_data_etalon    
                               
                               ,_rr.kd_okato          
                               ,_rr.nm_zipcode        
                               ,_rr.kd_kladr          
                               ,_rr.vl_addr_latitude  
                               ,_rr.vl_addr_longitude
                               ,-1 -- ID региона
               ); 
               EXECUTE _exec;
               --      
               -- Обновляется проверяемую запись данными дублёра
               --
               _exec = format (_upd_id, p_schema_name
                                   --
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
                                  --
                                ,NULL   
                                ,NULL
                                  --
                                ,_rr1.kd_okato                        
                                ,_rr1.nm_zipcode       
                                ,_rr1.kd_kladr  
                                ,_rr1.vl_addr_latitude                              
                                ,_rr1.vl_addr_longitude              
                                  --   
                                ,_rr.id_area              
               );
               EXECUTE _exec;
               fcase := 6; -- ДУБЛЁР ФИЗИЧЕСКИ УДАЛЯЕТСЯ, проверяемая запись жива.
               
               INSERT INTO gar_tmp.adr_area_aux (id_area, op_sign)
                 VALUES (_rr.id_area, UPD_OP)
                   ON CONFLICT (id_area) DO UPDATE SET op_sign = UPD_OP
                        WHERE (gar_tmp.adr_area_aux.id_area = excluded.id_area);                
               
           END IF; -- _rr.id_area IS NOT NULL
           
        ELSIF (_rr.id_area < BOUND_VALUE) AND (_rr1.id_area < BOUND_VALUE)           
		 THEN   -- связываем         
             _exec = format (_upd_id, p_schema_name
                                 --
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
                                --
                               ,_rr1.dt_data_del      
                               ,p_id_area 
                                --
                               ,_rr1.kd_okato           
                               ,_rr1.nm_zipcode         
                               ,_rr1.kd_kladr           
                               ,_rr1.vl_addr_latitude 
                               ,_rr1.vl_addr_longitude
                                --   
                               ,_rr1.id_area               
             );
             EXECUTE _exec; -- Связали. 
             --  
             INSERT INTO gar_tmp.adr_area_aux (id_area, op_sign)  
                VALUES (_rr1.id_area, UPD_OP)
                  ON CONFLICT (id_area) DO UPDATE SET op_sign = UPD_OP
                      WHERE (gar_tmp.adr_area_aux.id_area = excluded.id_area); 
             --     
             fcase := 7; -- Дублёр СТАЛ НЕ актуален,  проверяемая -актуальна 
                         -- ДУБЛЁР ЛОГИЧЕСКИ УДАЛЯЕТСЯ
          
        END IF; -- (_rr1.dt_data_del <=  p_bound_date) AND (_rr1.dt_data_del IS NOT NULL)
     
        id_area_subj := p_id_area;
        id_area_obj  := _rr1.id_area;
        nm_area      := _rr1.nm_area;
        nm_fias_guid := _rr1.nm_fias_guid;   
        
     END IF; --  _rr1.id_area IS NOT NULL
                 
     RETURN NEXT;
    END;
  $$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.fp_adr_area_del_twin 
    (text, bigint, integer, bigint, integer, varchar(120), uuid, date, text)
    IS 'Удаление/Слияние дублей. АДРЕСНЫЕ ПРОСТРАНСТВА.';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- CALL gar_tmp_pcg_trans.fp_adr_area_del_twin (
--               p_schema_name    := 'unnsi'  
--              ,p_id_house       := 2400298628   --  NOT NULL
--              ,p_id_area        := 32107        --  NOT NULL
--              ,p_id_area      := 353679       --      NULL
--              ,p_nm_house_full  := 'Д. 31Б/21'    --  NOT NULL
--              ,p_nm_fias_guid   := 'ba6461f5-8ea5-470d-a637-34cc42ea14ba'
-- );	
-- SELECT * FROM unnsi.adr_house WHERE ((id_area = 32107) AND 
--                                      (upper(nm_house_full::text) = 'Д. 31Б/21') AND (id_street=353679));
-- BEGIN;
-- UPDATE unnsi.adr_house SET dt_data_del = '2018-01-22 00:00:00' WHERE (id_house = 24026341);
-- COMMIT;
-- ROLLBACK;
