DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_adm_hierarchy (bigint, bigint, bigint, bigint, varchar(4), varchar(4), varchar(4), varchar(4), varchar(4), varchar(4), bigint, bigint, date, date, date, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_adm_hierarchy (
                          i_id            gar_fias.as_adm_hierarchy.id%TYPE
                         ,i_object_id     gar_fias.as_adm_hierarchy.object_id%TYPE
                         ,i_parent_obj_id gar_fias.as_adm_hierarchy.parent_obj_id%TYPE
                         ,i_change_id     gar_fias.as_adm_hierarchy.change_id%TYPE
                         ,i_region_code   gar_fias.as_adm_hierarchy.region_code%TYPE
                         ,i_area_code     gar_fias.as_adm_hierarchy.area_code%TYPE
                         ,i_city_code     gar_fias.as_adm_hierarchy.city_code%TYPE
                         ,i_place_code    gar_fias.as_adm_hierarchy.place_code%TYPE
                         ,i_plan_code     gar_fias.as_adm_hierarchy.plan_code%TYPE
                         ,i_street_code   gar_fias.as_adm_hierarchy.street_code%TYPE
                         ,i_prev_id       gar_fias.as_adm_hierarchy.prev_id%TYPE
                         ,i_next_id       gar_fias.as_adm_hierarchy.next_id%TYPE
                         ,i_update_date   gar_fias.as_adm_hierarchy.update_date%TYPE
                         ,i_start_date    gar_fias.as_adm_hierarchy.start_date%TYPE
                         ,i_end_date      gar_fias.as_adm_hierarchy.end_date%TYPE
                         ,i_is_active     gar_fias.as_adm_hierarchy.is_active%TYPE
) 
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-07
    -- Updates:  2021-11-03 Модификация под загрузчик ГИС Интеграция.    
    -- ----------------------------------------------------------------------------------------------------  
    --  Загрузка иерархии в адинистративном делении. 
    -- ====================================================================================================
    
    BEGIN
        INSERT INTO gar_fias.as_adm_hierarchy AS i (
                            id
                           ,object_id
                           ,parent_obj_id
                           ,change_id
                           ,region_code
                           ,area_code
                           ,city_code
                           ,place_code
                           ,plan_code
                           ,street_code
                           ,prev_id
                           ,next_id
                           ,update_date
                           ,start_date
                           ,end_date
                           ,is_active       
         )
           VALUES (
                      i_id            
                     ,i_object_id     
                     ,i_parent_obj_id 
                     ,i_change_id     
                     ,i_region_code   
                     ,i_area_code     
                     ,i_city_code     
                     ,i_place_code    
                     ,i_plan_code     
                     ,i_street_code   
                     ,i_prev_id       
                     ,i_next_id       
                     ,i_update_date   
                     ,i_start_date    
                     ,i_end_date      
                     ,i_is_active     
            )
         ON CONFLICT (id) DO UPDATE SET 
                            id            = excluded.id           
                           ,object_id     = excluded.object_id    
                           ,parent_obj_id = excluded.parent_obj_id
                           ,change_id     = excluded.change_id    
                           ,region_code   = excluded.region_code  
                           ,area_code     = excluded.area_code    
                           ,city_code     = excluded.city_code    
                           ,place_code    = excluded.place_code   
                           ,plan_code     = excluded.plan_code    
                           ,street_code   = excluded.street_code  
                           ,prev_id       = excluded.prev_id      
                           ,next_id       = excluded.next_id      
                           ,update_date   = excluded.update_date  
                           ,start_date    = excluded.start_date   
                           ,end_date      = excluded.end_date     
                           ,is_active     = excluded.is_active              
          
         WHERE (i.id = excluded.id);                        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_adm_hierarchy (bigint, bigint, bigint, bigint, varchar(4), varchar(4), varchar(4), varchar(4), varchar(4), varchar(4), bigint, bigint, date, date, date, boolean)
     OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_adm_hierarchy (bigint, bigint, bigint, bigint, varchar(4), varchar(4), varchar(4), varchar(4), varchar(4), varchar(4), bigint, bigint, date, date, date, boolean)
      IS 'Сохранение иерархии в адинистративном делении.';
--
--  USE CASE:
