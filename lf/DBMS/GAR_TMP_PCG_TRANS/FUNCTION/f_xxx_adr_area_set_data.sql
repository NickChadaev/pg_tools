DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_area_set_data (date, bigint, bigint[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_set_data (

       p_date          date     = current_date
      ,p_obj_level     bigint   = 14
      ,p_oper_type_ids bigint[] = NULL::bigint[]
      
) RETURNS integer

    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_tmp, public
 AS
  $$
    -- ----------------------------------------------------------------------------------------------
    --  2021-11-25 Nick Запомнить промежуточные данные, адресные объекты.
    -- ----------------------------------------------------------------------------------------------
    --      p_date          date     = Дата, на которую выбираются данные
    --     ,p_obj_level     bigint   = Уровень объекта
    --     ,p_oper_type_ids bigint[] = Типы операций.
    -- ----------------------------------------------------------------------------------------------
    DECLARE
      _r  integer;
    
    BEGIN   
       DROP INDEX IF EXISTS gar_tmp._xxx_adr_area_ie3;
       --    
       INSERT INTO gar_tmp.xxx_adr_area AS z (
       
                                  id_addr_obj      
                                 ,id_addr_parent   
                                 ,fias_guid        
                                 ,parent_fias_guid 
                                 ,nm_addr_obj   
                                 ,addr_obj_type_id   
                                 ,addr_obj_type    
                                 ,obj_level        
                                 ,level_name   
                                  --
                                 ,region_code  -- 2021-12-01
                                 ,area_code    
                                 ,city_code    
                                 ,place_code   
                                 ,plan_code    
                                 ,street_code    
                                  --                                 
                                 ,oper_type_id     
                                 ,oper_type_name  
                                  --
                                 ,start_date 
                                 ,end_date  
                                  --
                                 ,tree_d           
                                 ,level_d          
        )       
          SELECT   x.id_addr_obj      
                  ,x.id_addr_parent   
                  ,x.fias_guid        
                  ,x.parent_fias_guid 
                  ,x.nm_addr_obj  
                  ,x.addr_obj_type_id     
                  ,x.addr_obj_type    
                  ,x.obj_level        
                  ,x.level_name
                   --
                  ,x.region_code  -- 2021-12-01
                  ,x.area_code    
                  ,x.city_code    
                  ,x.place_code   
                  ,x.plan_code    
                  ,x.street_code    
                   --                                 
                  ,x.oper_type_id     
                  ,x.oper_type_name  
                   --
                  ,x.start_date 
                  ,x.end_date  
                   --                  
                  ,x.tree_d           
                  ,x.level_d          
          
          FROM gar_tmp_pcg_trans.f_xxx_adr_area_show_data (
                                 p_date          
                                ,p_obj_level     
                                ,p_oper_type_ids 
          ) x
               ON CONFLICT (id_addr_obj) DO 
               
               UPDATE
                    SET
                          id_addr_parent   = excluded.id_addr_parent    
                         ,fias_guid        = excluded.fias_guid       
                         ,parent_fias_guid = excluded.parent_fias_guid
                         ,nm_addr_obj      = excluded.nm_addr_obj    
                         ,addr_obj_type_id = excluded.addr_obj_type_id                            
                         ,addr_obj_type    = excluded.addr_obj_type   
                         ,obj_level        = excluded.obj_level       
                         ,level_name       = excluded.level_name      
                          --
                         ,region_code      = excluded.region_code -- 2021-12-01
                         ,area_code        = excluded.area_code  
                         ,city_code        = excluded.city_code  
                         ,place_code       = excluded.place_code 
                         ,plan_code        = excluded.plan_code  
                         ,street_code      = excluded.street_code
                          --                                 
                         ,oper_type_id     = excluded.oper_type_id    
                         ,oper_type_name   = excluded.oper_type_name
                          --
                         ,start_date       = excluded.start_date  -- 2021-12-06
                         ,end_date         = excluded.end_date
                          -- 
                         ,tree_d           = excluded.tree_d          
                         ,level_d          = excluded.level_d         
                  
               WHERE (z.id_addr_obj = excluded.id_addr_obj);
             
       GET DIAGNOSTICS _r = ROW_COUNT;
       
       CREATE INDEX IF NOT EXISTS _xxx_adr_area_ie3 
                                    ON gar_tmp.xxx_adr_area USING btree (obj_level);
       RETURN _r;      
    END;         
$$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_set_data (date, bigint, bigint[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_set_data (date, bigint, bigint[]) 
IS ' Запомнить промежуточные данные, адресные объекты';
----------------------------------------------------------------------------------
-- USE CASE:
--  SELECT * FROM gar_tmp.xxx_adr_area;  -- 19186
--  TRUNCATE TABLE gar_tmp.xxx_adr_area;
--  SELECT gar_tmp_pcg_trans.f_xxx_adr_area_set_data (); -- 19186
 
	 
