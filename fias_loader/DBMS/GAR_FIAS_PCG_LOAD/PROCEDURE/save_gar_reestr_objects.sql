DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_reestr_objects (bigint, uuid, bigint, boolean, bigint, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_reestr_objects (
                                  i_object_id    gar_fias.as_reestr_objects.object_id%TYPE
                                 ,i_object_guid  gar_fias.as_reestr_objects.object_guid%TYPE
                                 ,i_change_id    gar_fias.as_reestr_objects.change_id%TYPE
                                 ,i_is_active    gar_fias.as_reestr_objects.is_active%TYPE
                                 ,i_level_id     gar_fias.as_reestr_objects.level_id%TYPE
                                 ,i_create_date  gar_fias.as_reestr_objects.create_date%TYPE
                                 ,i_update_date  gar_fias.as_reestr_objects.update_date%TYPE
) 
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-05
    --   2021-11-08 Модификация пол загрузчик ГАР ФИАС.
    -- ----------------------------------------------------------------------------------------------------  
    -- Сохранение реестра адресных элементов. 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_reestr_objects AS r (
                                       object_id   
                                      ,object_guid 
                                      ,change_id   
                                      ,is_active   
                                      ,level_id    
                                      ,create_date 
                                      ,update_date        
        )
          VALUES (     i_object_id  
                      ,i_object_guid
                      ,i_change_id  
                      ,i_is_active  
                      ,i_level_id   
                      ,i_create_date
                      ,i_update_date          
          )
           ON CONFLICT (object_id) DO 
           
             UPDATE   SET   object_guid  = excluded.object_guid
                           ,change_id    = excluded.change_id
                           ,is_active    = excluded.is_active
                           ,level_id     = excluded.level_id
                           ,create_date  = excluded.create_date
                           ,update_date  = excluded.update_date 
                           
             WHERE (r.object_id = excluded.object_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_reestr_objects (bigint, uuid, bigint, boolean, bigint, date, date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_reestr_objects (bigint, uuid, bigint, boolean, bigint, date, date) 
      IS 'Сохранение реестра адресных элементов.';
--
--  USE CASE:


