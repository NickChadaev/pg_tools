DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_adr_area_set_data (uuid, date, text);
CREATE OR REPLACE FUNCTION gar_fias_pcg_load.f_adr_area_set_data (

       p_fias_guid  uuid 
      ,p_date       date = current_date
      ,p_descr      text = NULL
      
) RETURNS integer

    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_tmp, public
 AS
  $$
    -- ----------------------------------------------------------------------------------------------
    --  2022-08-28 Nick Запомнить дефектные данные, адресные объекты.
    -- ----------------------------------------------------------------------------------------------
    -- ----------------------------------------------------------------------------------------------
    DECLARE
      _r  integer;
    
    BEGIN   
        WITH x (  id_addr_obj       
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
        )
         AS (
             SELECT * FROM gar_fias_pcg_load.f_adr_area_show_data(p_fias_guid)  
            )
              
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
                   ,COALESCE (x.id_lead, x.id_addr_obj)          	   
                   ,x.tree_d           
                   ,x.level_d   
                    --
                   ,p_date 
                   ,p_descr            
             
             FROM x WHERE (x.id_lead IS NOT NULL)    
        
                UNION ALL
        		
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
                   ,COALESCE (x.id_lead, x.id_addr_obj)          	   
                   ,x.tree_d           
                   ,x.level_d  
                    --
                   ,p_date   
                   ,p_descr            
                  
        	 FROM x WHERE (x.id_addr_obj IN (SELECT id_lead FROM x WHERE (id_lead IS NOT NULL)))    
              ORDER BY id_addr_parent, addr_obj_type, nm_addr_obj, change_id DESC
    
        ON CONFLICT (id_addr_obj, date_create) DO NOTHING ;
            
       GET DIAGNOSTICS _r = ROW_COUNT;
       RETURN _r;      
    END;         
$$;
 
ALTER FUNCTION gar_fias_pcg_load.f_adr_area_set_data (uuid, date, text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_fias_pcg_load.f_adr_area_set_data (uuid, date, text) 
IS ' Запомнить дефектные данные, адресные объекты';
----------------------------------------------------------------------------------
-- USE CASE:
--  SELECT * FROM gar_tmp.xxx_adr_area;  -- 19186
--  TRUNCATE TABLE gar_tmp.xxx_adr_area;
--  SELECT gar_fias_pcg_load.f_adr_area_set_data (); -- 19186
 
	 
