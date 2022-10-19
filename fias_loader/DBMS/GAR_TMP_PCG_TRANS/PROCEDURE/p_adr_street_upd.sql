DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_upd (
                text, text, bigint, bigint, varchar(120), integer, varchar(255)      
               ,uuid, bigint, varchar(15), numeric, numeric, bigint, boolean, boolean                             
 );  
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_street_upd (
             p_schema_name        text  
            ,p_schema_h           text 
             --
            ,p_id_street         bigint        -- NOT NULL 
            ,p_id_area           bigint        -- NOT NULL 
            ,p_nm_street         varchar(120)  -- NOT NULL 
            ,p_id_street_type    integer       --  NULL 
            ,p_nm_street_full    varchar(255)  -- NOT NULL  
            ,p_nm_fias_guid      uuid          --  NULL 
            ,p_id_data_etalon    bigint        --  NULL 
            ,p_kd_kladr          varchar(15)   --  NULL  
            ,p_vl_addr_latitude  numeric       --  NULL 
            ,p_vl_addr_longitude numeric       --  NULL   
            ,p_oper_type_id      bigint        -- Тип операции, с портала GAR-FIAS  
             --
            ,p_sw     boolean -- Создаём историю, либо нет 
            ,p_duble  boolean -- Обязательное выявление дубликатов
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------------
    --   2021-12-14/2022-01-28
    --           Создание/Обновление записи в ОТДАЛЁННОМ справочнике улиц.
    --   2022-02-01  Расширенная обработка нарушения уникальности по второму индексу
    --   2022-02-21  Опция ONLY для UPDARE, DELETE, SELECT.
    --   2022-02-28  Дубликаты не удаляются
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
    -- -------------------------------------------------------------------------------  
    --   2022-05-31 COALESCE только для NOT NULL полей.    
    -- -------------------------------------------------------------------------------
    --   2022-10-18 Вспомогательные таблицы..
    -- -------------------------------------------------------------------------------     
    
    DECLARE
      _exec    text;
      
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
              
      -- 2022-05-31        
      _upd_id text = $_$
            UPDATE ONLY %I.adr_street SET  
                  id_area           = COALESCE (%L, id_area  )::bigint                                 
                , nm_street         = COALESCE (%L, nm_street)::varchar(120)                       
                , id_street_type    = %L::integer                                
                , nm_street_full    = COALESCE (%L, nm_street_full)::varchar(255)                           
                , nm_fias_guid      = %L::uuid                        
                , dt_data_del       = %L::timestamp without time zone                      
                , id_data_etalon    = %L::bigint                      
                , kd_kladr          = %L::varchar(15)                 
                , vl_addr_latitude  = %L::numeric                     
                , vl_addr_longitude = %L::numeric                     
            WHERE (id_street = %L::bigint);        
       $_$;        
       -- 2022-05-31
        
       -- 2022-02-10 ---------------------------------------------------------
      _sel_twin text = $_$
            SELECT * FROM ONLY  %I.adr_street
                
            WHERE (id_area = %L::bigint) AND 
                  (NOT (upper(nm_street) = upper(%L)::text)) AND 
                  (id_street_type IS NOT DISTINCT FROM %L::integer) AND 
                  (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
       $_$;          
          --        (nm_fias_guid = %L::uuid) AND
        
       _del_twins  text = $_$       
           DELETE FROM ONLY %I.adr_street WHERE (id_street = %L);         
       $_$;    
       
       -- 2022-02-10 ---------------------------------------------------------
       
     _rr   gar_tmp.adr_street_t;
     _rr1  gar_tmp.adr_street_t; 
     
     -- 2022-10-19
     UPD_OP CONSTANT char(1) := 'U';      
  
    BEGIN
      --
      --  2022-05-19. UUID существует в БД, значения триады образующие уникальность AK
      --        могут быть изменены.
      --
      _rr := gar_tmp_pcg_trans.f_adr_street_get (p_schema_name, p_nm_fias_guid);
      
      IF p_duble -- Обязательный поиск дублей   
        THEN
           _exec := format (_sel_twin, p_schema_name  
                                    ,p_id_area, p_nm_street, p_id_street_type                  
            );
            EXECUTE _exec INTO _rr1;
--                                    ,p_nm_fias_guid 
            --
            IF _rr1.id_street IS NOT NULL 
              THEN
                --   В историю, потом удалять
                 _exec := format (_ins_hist, p_schema_h
                                        ,_rr1.id_street    
                                        ,_rr1.id_area          
                                        ,_rr1.nm_street        
                                        ,_rr1.id_street_type   
                                        ,_rr1.nm_street_full   
                                        ,_rr1.nm_fias_guid   
                                        ,now()          --  dt_data_del
                                        ,_rr1.id_street  -- p_id_data_etalon   
                                        ,_rr1.kd_kladr         
                                        ,_rr1.vl_addr_latitude 
                                        ,_rr1.vl_addr_longitude
                                        --
                                        ,-1 --Признак принудительного поиска дублей
                 );            
                 EXECUTE _exec;
                 
                 -- _exec := format (_del_twins, p_schema_name, _rr1.id_street);
                 -- EXECUTE _exec; 
               
               _exec := format (_upd_id, p_schema_name
                      ,_rr1.id_area                       
                      ,_rr1.nm_street                 
                      ,_rr1.id_street_type                
                      ,_rr1.nm_street_full                
                      ,_rr1.nm_fias_guid
                      --
                      ,now()                              
                      ,_rr.id_street
                      --
                      ,_rr1.kd_kladr          
                      ,_rr1.vl_addr_latitude  
                      ,_rr1.vl_addr_longitude 
                     
                      ,_rr1.id_street
               );
               EXECUTE _exec;
                 
                 
            END IF; -- _rr1.id_street IS NOT NULL
      END IF; -- Обязательный поиск дублей 
    
      IF (_rr.id_street IS NOT NULL)  
        THEN  
             IF 
               -- 2022-05-31
               ((_rr.id_area               IS DISTINCT FROM p_id_area) AND (p_id_area IS NOT NULL)) OR
               ((upper(_rr.nm_street)      IS DISTINCT FROM upper(p_nm_street)) AND (p_nm_street IS NOT NULL)) OR
               ((_rr.id_street_type        IS DISTINCT FROM p_id_street_type)) OR  --  AND (p_id_street_type IS NOT NULL)
               ((upper(_rr.nm_street_full) IS DISTINCT FROM upper(p_nm_street_full)) AND (p_nm_street_full IS NOT NULL)) OR                
               --
               -- 2022-01-28
               ((_rr.nm_fias_guid IS DISTINCT FROM p_nm_fias_guid) AND (p_nm_fias_guid IS NOT NULL)) OR                
               -- 2022-01-28
               --
               ((_rr.kd_kladr IS DISTINCT FROM p_kd_kladr )) --  AND (p_kd_kladr IS NOT NULL) 
               -- 2022-05-31 
               THEN -- Сохраняю старые значения с новым ID     
                 
                IF p_sw 
                   THEN 
                    _exec := format (_ins_hist, p_schema_h
                                           ,_rr.id_street    
                                           ,_rr.id_area          
                                           ,_rr.nm_street        
                                           ,_rr.id_street_type   
                                           ,_rr.nm_street_full   
                                           ,_rr.nm_fias_guid   
                                           ,now()          --  dt_data_del
                                           ,_rr.id_street  -- p_id_data_etalon   
                                           ,_rr.kd_kladr         
                                           ,_rr.vl_addr_latitude 
                                           ,_rr.vl_addr_longitude
                                           --
                                           ,NULL
                    );            
                    EXECUTE _exec;
                END IF;
                    -- update, 
               _exec := format (_upd_id, p_schema_name
                      ,p_id_area                       
                      ,p_nm_street                 
                      ,p_id_street_type                
                      ,p_nm_street_full                
                      ,p_nm_fias_guid
                      --
                      ,NULL                              
                      ,NULL
                      --
                      ,p_kd_kladr          
                      ,p_vl_addr_latitude  
                      ,p_vl_addr_longitude 
                     
                      ,_rr.id_street
               );
               EXECUTE _exec;    
               
               INSERT INTO gar_tmp.adr_street_aux (id_street, op_sign)
                VALUES (_rr.id_street, UPD_OP)
                   ON CONFLICT (id_street) DO UPDATE SET op_sign = UPD_OP
                       WHERE (gar_tmp.adr_street_aux.id_street = excluded.id_street);               
                    
             END IF; -- compare
      END IF; -- rr.id_street IS NOT NULL  
     
    -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    EXCEPTION  -- Возникает на отдалённом сервере   
     --  UNIQUE INDEX _xxx_adr_street_ie2 ON unnsi.adr_street USING btree (nm_fias_guid ASC NULLS LAST)
     --    Ошибку могла дать триада "id_area", "nm_street", "id_street_type".
     
      WHEN unique_violation THEN 
        BEGIN
          _rr = gar_tmp_pcg_trans.f_adr_street_get (p_schema_name, p_nm_fias_guid);
          _rr1 = gar_tmp_pcg_trans.f_adr_street_get (p_schema_name
                                         , p_id_area, p_nm_street, p_id_street_type);
          ---
          --_exec := format (_sel_twin, p_schema_name, 
          --                       p_id_area, p_nm_street, p_id_street_type, p_nm_fias_guid
          --);   
          --EXECUTE _exec INTO _rr1;
          
          IF _rr1.id_street IS NOT NULL 
            THEN
            --   В историю, потом удалять
               _exec := format (_ins_hist, p_schema_h
                                      ,_rr1.id_street    
                                      ,_rr1.id_area          
                                      ,_rr1.nm_street        
                                      ,_rr1.id_street_type   
                                      ,_rr1.nm_street_full   
                                      ,_rr1.nm_fias_guid   
                                      ,now()          --  dt_data_del
                                      ,_rr1.id_street  -- p_id_data_etalon   
                                      ,_rr1.kd_kladr         
                                      ,_rr1.vl_addr_latitude 
                                      ,_rr1.vl_addr_longitude
                                      --
                                      ,0
               );            
               EXECUTE _exec;
               
               -- _exec := format (_del_twins, p_schema_name, _rr1.id_street);
               -- EXECUTE _exec;
            
               _exec := format (_upd_id, p_schema_name
                      ,_rr1.id_area                       
                      ,_rr1.nm_street                 
                      ,_rr1.id_street_type                
                      ,_rr1.nm_street_full                
                      ,_rr1.nm_fias_guid
                      --
                      ,now()                              
                      ,_rr.id_street
                      --
                      ,_rr1.kd_kladr          
                      ,_rr1.vl_addr_latitude  
                      ,_rr1.vl_addr_longitude 
                     
                      ,_rr1.id_street
               );
               EXECUTE _exec;
               
          END IF; -- 2022-02-10 -- _rr1.id_street IS NOT NULL 
                 
          -- Повторяем прерванную операцию.       
          IF (_rr.id_street IS NOT NULL) AND (_rr1.id_street IS NOT NULL) 
             THEN
              IF p_sw THEN  
                 --
                 -- Старые значения с новым ID и признаком удаления
                 -----------------------------------------------
                 _exec := format (_ins_hist, p_schema_h
                                  ,_rr.id_street        
                                  ,_rr.id_area          
                                  ,_rr.nm_street        
                                  ,_rr.id_street_type   
                                  ,_rr.nm_street_full   
                                  ,_rr.nm_fias_guid   
                                  ,now()          -- dt_data_del
                                  ,_rr.id_street  -- p_id_data_etalon   
                                  ,_rr.kd_kladr         
                                  ,_rr.vl_addr_latitude 
                                  ,_rr.vl_addr_longitude
                                  , NULL
                 );            
                 EXECUTE _exec;  
              END IF;
              
              -- update,  
              _exec := format (_upd_id, p_schema_name
                     ,p_id_area                       
                     ,p_nm_street                 
                     ,p_id_street_type                
                     ,p_nm_street_full                
                     ,p_nm_fias_guid
                     --
                     ,NULL -- p_dt_data_del                          
                     ,NULL -- p_id_data_etalon     
                     --
                     ,p_kd_kladr          
                     ,p_vl_addr_latitude  
                     ,p_vl_addr_longitude 
                    
                     ,_rr.id_street
              );
              EXECUTE _exec;  
              
              INSERT INTO gar_tmp.adr_street_aux (id_street, op_sign)
                VALUES (_rr.id_street, UPD_OP)
                   ON CONFLICT (id_street) DO UPDATE SET op_sign = UPD_OP
                       WHERE (gar_tmp.adr_street_aux.id_street = excluded.id_street);              
              
          END IF;  -- COMPARE _rr. (_rr.id_street IS NOT NULL) AND (_rr1.id_street IS NOT NULL)             
 	    END; -- unique_violation	
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_upd (
               text, text, bigint, bigint, varchar(120), integer, varchar(255)      
               ,uuid, bigint, varchar(15), numeric, numeric, bigint, boolean, boolean
               ) 
         IS 'Обновление записи в ОТДАЛЁННОМ справочнике улиц';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_street_upd ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_street_upd ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);


     
 
      
