DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_ins (
                text, text, bigint, bigint, varchar(120), integer, varchar(255)      
               ,uuid, bigint, varchar(15), numeric, numeric, boolean                             
 );  
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_street_ins (
             p_schema_name       text  
            ,p_schema_h          text 
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
             --
            ,p_sw                boolean            
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ----------------------------------------------------------------------
    --    2021-12-14/2021-12-24/2022-01-27/2022-02-10
    --       Создание записи в ОТДАЛЁННОМ справочнике  адресов улиц
    -- ----------------------------------------------------------------------
    --   2022-02-21  Опция ONLY для UPDARE, DELETE, SELECT.
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
    -- ----------------------------------------------------------------------
    --  2022-05-31 COALESCE только для NOT NULL полей.    
    -- -------------------------------------------------------------------------
    --   2022-10-18 Вспомогательные таблицы..
    --   2023-10-23 Сохраняется оригинальный UUID при обработке дубля.    
    -- -------------------------------------------------------------------------    
    
    DECLARE
      _exec  text;
      
      _ins text = $_$
               INSERT INTO %I.adr_street (
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
                 ) RETURNING id_street;      
              $_$;
              
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
        
      _rr  gar_tmp.adr_street_t; 
      
       -- 2022-10-18
      _id_street bigint; 
      INS_OP CONSTANT char(1) := 'I';
      UPD_OP CONSTANT char(1) := 'U';      
      
    BEGIN
    --
    --  2022-05-19 uuid нет в базе. Есть триада, определяющая уникальность AK
    --
      _exec := format (_ins, p_schema_name
                       ,p_id_street        
                       ,p_id_area          
                       ,p_nm_street        
                       ,p_id_street_type   
                       ,p_nm_street_full   
                       ,p_nm_fias_guid   
                       ,NULL  -- dt_data_del
                       ,NULL  -- p_id_data_etalon   
                       ,p_kd_kladr         
                       ,p_vl_addr_latitude 
                       ,p_vl_addr_longitude
      );            
      EXECUTE _exec INTO _id_street;
      
      INSERT INTO gar_tmp.adr_street_aux (id_street, op_sign)
       VALUES (_id_street, INS_OP)
          ON CONFLICT (id_street) DO UPDATE SET op_sign = INS_OP
              WHERE (gar_tmp.adr_street_aux.id_street = excluded.id_street);
      
    EXCEPTION  -- Возникает на отдалённоми сервере, уникальность AK.            
       WHEN unique_violation THEN 
          BEGIN
            _rr =  gar_tmp_pcg_trans.f_adr_street_get (p_schema_name
                                    ,p_id_area, p_nm_street, p_id_street_type
            );
            IF (_rr.id_street IS NOT NULL) 
              THEN
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
                                 ,0 -- Регион "0" - Исключение во время процесса дополнения.
                );            
                EXECUTE _exec;    
            
                -- update,  
                _exec := format (_upd_id
                                       , p_schema_name
                                       ,_rr.id_area                       
                                       ,_rr.nm_street                 
                                       ,_rr.id_street_type                
                                       ,_rr.nm_street_full                
                                       ,_rr.nm_fias_guid
                                       --
                                       ,now() -- nm_data_del                              
                                       ,p_id_street -- id_data_etalon
                                       --
                                       ,_rr.kd_kladr          
                                       ,_rr.vl_addr_latitude  
                                       ,_rr.vl_addr_longitude 
                                      
                                       ,_rr.id_street
                );
                EXECUTE _exec; --  2023-10-23 / Отменяется. Смена значения UUID
                
                INSERT INTO gar_tmp.adr_street_aux (id_street, op_sign)
                  VALUES (_rr.id_street, UPD_OP)
                    ON CONFLICT (id_street) DO UPDATE SET op_sign = UPD_OP
                        WHERE (gar_tmp.adr_street_aux.id_street = excluded.id_street);  
                        
            END IF; -- _rr.id_street IS NOT NULL
            -- 
            -- Продолжаю прерванный ранее процесс.
            --
            _exec := format (_ins
                                    , p_schema_name
                                    , p_id_street        
                                    , p_id_area          
                                    , p_nm_street        
                                    , p_id_street_type   
                                    , p_nm_street_full   
                                    , p_nm_fias_guid   
                                    , NULL  -- dt_data_del
                                    , NULL  -- p_id_data_etalon   
                                    , p_kd_kladr         
                                    , p_vl_addr_latitude 
                                    , p_vl_addr_longitude
            );            
            EXECUTE _exec INTO _id_street;
            
            INSERT INTO gar_tmp.adr_street_aux (id_street, op_sign)
             VALUES (_id_street, INS_OP)
                ON CONFLICT (id_street) DO UPDATE SET op_sign = INS_OP
                    WHERE (gar_tmp.adr_street_aux.id_street = excluded.id_street);
                    
 		  END;  -- unique_violation
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_ins (
                text, text, bigint, bigint, varchar(120), integer, varchar(255)      
               ,uuid, bigint, varchar(15), numeric, numeric, boolean
) IS 'Создание записи в ОТДАЛЁННОМ справочнике улиц';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_street_ins ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_street_ins ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);
-- ------------------------------------------------------------------------------------


