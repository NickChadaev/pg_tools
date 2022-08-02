-- 
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_del_twin_1 (
                  text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text 
 );   
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_del_twin_1 (
                  text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text 
 );   
 
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.fp_adr_house_del_twin_1 (
        p_schema_name      text  
       ,p_id_house         bigint       --  NOT NULL
       ,p_id_area          bigint       --  NOT NULL
       ,p_id_street        bigint       --      NULL
       ,p_nm_house_full    varchar(250) --  NOT NULL
       ,p_nm_fias_guid     uuid
       ,p_mode             boolean = FALSE -- используется в процессе обработки
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
    -- ---------------------------------------------------------------------------
    --  2022-06-06/2022-06-21/2022-07-28 Опытный вариант Постобработки. 
    -- ---------------------------------------------------------------------------
    -- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_nm_fias_guid"
    -- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_bound_date"
    -- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_schema_hist_name"   
    
    DECLARE
      _exec text;
      --
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
      -- -------------------------------------------------------------------------
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

       $_$;
       --
      _rr1  gar_tmp.adr_house_t; 
      _qty  integer;
      
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
                                     ,coalesce (_rr1.dt_data_del, date (now()))   
                                     ,p_id_house  
                                     ,_rr1.kd_okato         
                                     ,_rr1.vl_addr_latitude 
                                     ,_rr1.vl_addr_longitude
                                      --   
                                     ,_rr1.id_house               
            );
            EXECUTE _exec; -- Связали.
            _qty := 1;
         END IF; -- _rr1.id_house IS NOT NULL
     END IF; -- p_mode
     
     RETURN _qty;
    END;
  $$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.fp_adr_house_del_twin_1 
    (text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text)
    IS 'Удаление/Слияние дублей';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- SELECT gar_tmp_pcg_trans.fp_adr_house_del_twin_1 (
--               p_schema_name    := 'unnsi'  
--              ,p_id_house       := 13696829   --  NOT NULL
--              ,p_id_area        := 126646        --  NOT NULL
--              ,p_id_street      := NULL       --      NULL
--              ,p_nm_house_full  := 'Д. 175Л'    --  NOT NULL
--              ,p_nm_fias_guid   := '0c755ac2-dd91-477d-b61e-68e6f3faef62'
-- );	-- 1
-- SELECT * FROM unnsi.adr_house WHERE (id_house IN (13696829, 26510189));

