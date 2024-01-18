DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_adr_area_set_data (uuid, date, text);
DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_adr_area_set_data (uuid, date, bigint, integer, text);

DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_area_set_data (uuid, date, bigint, integer, text);
CREATE OR REPLACE FUNCTION gar_fias_pcg_load.f_addr_area_set_data ( 
       
       p_fias_guid     uuid     
      ,p_date          date     = current_date
      ,p_obj_level     bigint   = 16
      ,p_qty           integer  = 0
      ,p_descr      text = NULL
      
) RETURNS integer

    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_tmp, public
 AS
  $$
    -- ---------------------------------------------------------------------
    --  2022-08-28 Nick Запомнить дефектные данные, адресные объекты.
    -- ---------------------------------------------------------------------
    --  2923-10-23 Ревизия.
    -- ---------------------------------------------------------------------
    DECLARE
      _r  integer;
    
    BEGIN   
            INSERT INTO gar_fias.gap_adr_area AS z (            
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
                                  ,region_code       
                                  ,area_code         
                                  ,city_code         
                                  ,place_code        
                                  ,plan_code         
                                  ,street_code       
                                  --
                                  ,change_id        
                                  ,prev_id          
                                  --
                                  ,oper_type_id     
                                  ,oper_type_name   
                                   --                         
                                  ,start_date       
                                  ,end_date         
                                   --
                                  ,id_lead          	   
                                  ,tree_d           
                                  ,level_d          
                                   --                                     
                                  ,date_create    
                                  ,descr_gap      
            )
             SELECT x.id_addr_obj       
                   ,x.id_addr_parent    
                   ,x.fias_guid         
                   ,x.parent_fias_guid  
                   ,x.nm_addr_obj       
                   ,x.addr_obj_type_id  
                   ,x.addr_obj_type     
                   ,x.obj_level         
                   ,x.level_name        
                   --
                   ,x.region_code      
                   ,x.area_code        
                   ,x.city_code        
                   ,x.place_code       
                   ,x.plan_code        
                   ,x.street_code      
                    --
                   ,x.change_id    
                   ,x.prev_id      
                    --
                   ,x.oper_type_id     
                   ,x.oper_type_name   
                    --                         
                   ,x.start_date       
                   ,x.end_date         
                    --
                   ,x.id_lead          	   
                   ,x.tree_d           
                   ,x.level_d   
                    --
                   ,p_date 
                   ,p_descr            
             
             FROM  gar_fias_pcg_load.f_addr_area_show_data (p_fias_guid, p_date, p_obj_level, p_qty) x 
        
        ON CONFLICT (id_addr_obj, date_create) DO NOTHING ;
            
       GET DIAGNOSTICS _r = ROW_COUNT;
       RETURN _r;      
    END;         
$$;
 
ALTER FUNCTION gar_fias_pcg_load.f_addr_area_set_data (uuid, date, bigint, integer, text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_fias_pcg_load.f_addr_area_set_data (uuid, date, bigint, integer, text) 
IS ' Запомнить дефектные данные, адресные объекты';
----------------------------------------------------------------------------------
-- USE CASE:
--  BEGIN;
--        SELECT * FROM gar_fias.gap_adr_area;  -- 2115 строк получено.
--        SELECT gar_fias_pcg_load.f_adr_area_set_data (NULL, current_date, 'Дагестан'); -- 13
--        SELECT * FROM gar_fias.gap_adr_area;  -- 2128 строк получено.
--  ROLLBACK; 
--  COMMIT;
	 
