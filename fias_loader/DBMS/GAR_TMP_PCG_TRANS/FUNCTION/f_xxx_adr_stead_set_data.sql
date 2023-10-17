DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_stead_set_data (date, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_stead_set_data (
         p_date           date   = now()::date
        ,p_parent_obj_id  bigint = NULL
) 
 RETURNS SETOF integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- =============================================================================
    -- Author: Nick
    -- Create date: 2023-10-16
    -- -----------------------------------------------------------------------------  
    --       Загрузка прототипа таблицы земельных участков "gar_tmp.xxx_adr_stead".
    -- =============================================================================
    DECLARE
      _r  integer;
    
    BEGIN
       DROP INDEX IF EXISTS gar_tmp._xxx_adr_stead_ie1; 
       --    
       INSERT INTO gar_tmp.xxx_adr_stead AS x
        (
                                id_stead              
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
                               ,stead_num             
                               ,oper_type_id          
                               ,oper_type_name                 
        )  -- 
          SELECT      z.id_stead              
                     ,z.id_addr_parent        
                     ,z.fias_guid             
                     ,z.parent_fias_guid      
                     ,z.nm_parent_obj         
                     ,z.region_code           
                     ,z.parent_type_id        
                     ,z.parent_type_name      
                     ,z.parent_type_shortname 
                     ,z.parent_level_id       
                     ,z.parent_level_name     
                     ,z.stead_num             
                     ,z.oper_type_id          
                     ,z.oper_type_name        
                     
          FROM gar_tmp_pcg_trans.f_xxx_adr_stead_show_data (
                             p_date
                           , p_parent_obj_id
          ) z
          ON CONFLICT (id_stead) DO 
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
                     ,stead_num             = excluded.stead_num            
                     ,oper_type_id          = excluded.oper_type_id         
                     ,oper_type_name        = excluded.oper_type_name       
                     
                WHERE (x.id_stead = excluded.id_stead);             
          
        GET DIAGNOSTICS _r = ROW_COUNT;
        CREATE INDEX IF NOT EXISTS _xxx_adr_stead_ie1 
                       ON gar_tmp.xxx_adr_stead USING btree (id_addr_parent);
        
        RETURN NEXT _r;
        --
    END;
  $$;

ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_stead_set_data (date, bigint) OWNER TO postgres;

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_stead_set_data (date, bigint) 
IS 'Загрузка прототипа таблицы земельных участков "gar_tmp_pcg_trans.xxx_adr_stead"';
--
--  USE CASE:
--         SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_stead_set_data (); ---  15 min 253121 rows
--         SELECT * FROM gar_tmp.xxx_adr_stead;  -- 253121
--         TRUNCATE TABLE gar_tmp.xxx_adr_stead;  -- 253121
-- --------------------------------------------------------------------------------------------
--  SELECT lineno, avg_time, source FROM plpgsql_profiler_function_tb ('gar_tmp_pcg_trans.f_xxx_adr_stead_set_data (bigint[], bigint[])');
--  SELECT * FROM plpgsql_profiler_function_tb ('gar_tmp_pcg_trans.f_xxx_adr_stead_set_data (bigint[], bigint[])');
-- ------------------------------------------------------------------------------------------------------
--  SELECT * FROM plpgsql_profiler_function_statements_tb ('gar_tmp_pcg_trans.f_xxx_adr_stead_set_data (bigint[], bigint[])');
