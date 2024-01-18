DROP PROCEDURE IF EXISTS gar_fias_pcg_load.p_twin_addr_obj_put (uuid, uuid, bigint, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.p_twin_addr_obj_put (
                     p_fias_guid_new  uuid
                    ,p_fias_guid_old  uuid
                    ,p_obj_level      bigint
                    ,p_date_create    date
    )
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2023-11-02
    -- ----------------------------------------------------------------------------------------------------  
    --    Создание/Обновление записи в таблице объектов-двойников.
    -- ====================================================================================================
   
    BEGIN
        
        INSERT INTO gar_fias.twin_addr_objects AS x (

                        fias_guid_new
                       ,fias_guid_old
                       ,obj_level  
                       ,date_create
        )
          VALUES (   p_fias_guid_new
                    ,p_fias_guid_old
                    ,p_obj_level
                    ,p_date_create
          )
          
        ON CONFLICT ON CONSTRAINT pk_twin_adr_objects DO 
            
            UPDATE SET obj_level   = excluded.obj_level  
                      ,date_create = excluded.date_create
                       
            WHERE (x.fias_guid_new = excluded.fias_guid_new) AND 
                  (x.fias_guid_old = excluded.fias_guid_old);    
        
       RETURN;
       
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.p_twin_addr_obj_put (uuid, uuid, bigint, date) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.p_twin_addr_obj_put (uuid, uuid, bigint, date) 
               IS 'Создание/Обновление записи в таблице объектов-двойников.';
--
--  USE CASE:
--           CALL gar_fias_pcg_load.p_twin_addr_obj_put ('700939ad-a9ce-4b62-a457-bc4c3547d81a', '018bfbea-b302-4bec-8063-747eed228d5e', 0, current_date); --  
--           SELECT * FROM gar_fias.twin_addr_objects;
--           TRUNCATE TABLE gar_fias.twin_addr_objects;
--           CALL gar_fias_pcg_load.p_twin_addr_obj_put ('700939ad-a9ce-4b62-a457-bc4c3547d81a', '018bfbea-b302-4bec-8063-747eed228d5e', -1, current_date);
