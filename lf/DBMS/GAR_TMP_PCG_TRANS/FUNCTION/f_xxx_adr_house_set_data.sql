DROP FUNCTION IF EXISTS gar_tmp.f_xxx_adr_house_load_data (date, bigint);
DROP FUNCTION IF EXISTS gar_tmp.f_xxx_adr_house_set_data (date, bigint);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_house_set_data (date, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_house_set_data (
         p_date           date   = now()::date
        ,p_parent_obj_id  bigint = NULL
) 
 RETURNS SETOF integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- =============================================================================
    -- Author: Nick
    -- Create date: 2021-10-20/2021-12-09
    -- -----------------------------------------------------------------------------  
    --           Загрузка прототипа таблицы домов "gar_tmp.xxx_adr_house".
    -- =============================================================================
    DECLARE
      _r  integer;
    
    BEGIN
       DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ie1; 
       --    
       INSERT INTO gar_tmp.xxx_adr_house AS x
        (
                                                id_house              
                                               ,id_addr_parent        
                                               ,fias_guid             
                                               ,parent_fias_guid      
                                               ,nm_parent_obj         
                                               ,region_code           
                                               ,parent_type_id        
                                               ,parent_type_name      
                                               ,parent_type_shortname 
                                               ,parent_level_id       
                                               ,parent_level_name     
                                               ,parent_short_name     
                                               ,house_num             
                                               ,add_num1              
                                               ,add_num2              
                                               ,house_type            
                                               ,house_type_name       
                                               ,house_type_shortname  
                                               ,add_type1             
                                               ,add_type1_name        
                                               ,add_type1_shortname   
                                               ,add_type2             
                                               ,add_type2_name        
                                               ,add_type2_shortname   
                                               ,oper_type_id            
                                               ,oper_type_name        
                                               ,user_id               
        )
          SELECT      x.id_house              
                     ,x.id_addr_parent        
                     ,x.fias_guid             
                     ,x.parent_fias_guid      
                     ,x.nm_parent_obj         
                     ,x.region_code           
                     ,x.parent_type_id        
                     ,x.parent_type_name      
                     ,x.parent_type_shortname 
                     ,x.parent_level_id       
                     ,x.parent_level_name     
                     ,x.parent_short_name     
                     ,x.house_num             
                     ,x.add_num1              
                     ,x.add_num2              
                     ,x.house_type            
                     ,x.house_type_name       
                     ,x.house_type_shortname  
                     ,x.add_type1             
                     ,x.add_type1_name        
                     ,x.add_type1_shortname   
                     ,x.add_type2             
                     ,x.add_type2_name        
                     ,x.add_type2_shortname   
                     ,x.oper_type_id            
                     ,x.oper_type_name        
                     ,x.user_id   
                     
          FROM gar_tmp_pcg_trans.f_xxx_adr_house_show_data (
                             p_date
                           , p_parent_obj_id
          ) x
          ON CONFLICT (id_house) DO 
               UPDATE
                    SET          
                      id_addr_parent        = excluded.id_addr_parent       
                     ,fias_guid             = excluded.fias_guid            
                     ,parent_fias_guid      = excluded.parent_fias_guid     
                     ,nm_parent_obj         = excluded.nm_parent_obj        
                     ,region_code           = excluded.region_code          
                     ,parent_type_id        = excluded.parent_type_id       
                     ,parent_type_name      = excluded.parent_type_name     
                     ,parent_type_shortname = excluded.parent_type_shortname
                     ,parent_level_id       = excluded.parent_level_id      
                     ,parent_level_name     = excluded.parent_level_name    
                     ,parent_short_name     = excluded.parent_short_name    
                     ,house_num             = excluded.house_num            
                     ,add_num1              = excluded.add_num1             
                     ,add_num2              = excluded.add_num2             
                     ,house_type            = excluded.house_type           
                     ,house_type_name       = excluded.house_type_name      
                     ,house_type_shortname  = excluded.house_type_shortname 
                     ,add_type1             = excluded.add_type1            
                     ,add_type1_name        = excluded.add_type1_name       
                     ,add_type1_shortname   = excluded.add_type1_shortname  
                     ,add_type2             = excluded.add_type2            
                     ,add_type2_name        = excluded.add_type2_name       
                     ,add_type2_shortname   = excluded.add_type2_shortname  
                     ,oper_type_id          = excluded.oper_type_id           
                     ,oper_type_name        = excluded.oper_type_name       
                     ,user_id               = excluded.user_id              

                WHERE (x.id_house = excluded.id_house);             
          
        GET DIAGNOSTICS _r = ROW_COUNT;
        CREATE INDEX IF NOT EXISTS _xxx_adr_house_ie1 
                       ON gar_tmp.xxx_adr_house USING btree (id_addr_parent);
        
        RETURN NEXT _r;
        --
    END;
  $$;

ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_house_set_data (date, bigint) OWNER TO postgres;

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_house_set_data (date, bigint) 
IS 'Загрузка прототипа таблицы домов "gar_tmp_pcg_trans.xxx_adr_house"';
--
--  USE CASE:
--         SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_house_set_data (); ---  15 min 253121 rows
--         SELECT * FROM gar_tmp.xxx_adr_house;  -- 253121
--         TRUNCATE TABLE gar_tmp.xxx_adr_house;  -- 253121
-- --------------------------------------------------------------------------------------------
--  SELECT lineno, avg_time, source FROM plpgsql_profiler_function_tb ('gar_tmp_pcg_trans.f_xxx_adr_house_set_data (bigint[], bigint[])');
--  SELECT * FROM plpgsql_profiler_function_tb ('gar_tmp_pcg_trans.f_xxx_adr_house_set_data (bigint[], bigint[])');
-- ------------------------------------------------------------------------------------------------------
--  SELECT * FROM plpgsql_profiler_function_statements_tb ('gar_tmp_pcg_trans.f_xxx_adr_house_set_data (bigint[], bigint[])');
