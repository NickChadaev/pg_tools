DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_addr_obj_division (bigint, bigint, bigint, bigint);

CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_division (
                             i_id        gar_fias.as_addr_obj_division.id%TYPE
                            ,i_parent_id gar_fias.as_addr_obj_division.parent_id%TYPE
                            ,i_child_id  gar_fias.as_addr_obj_division.child_id%TYPE
                            ,i_change_id gar_fias.as_addr_obj_division.change_id%TYPE
) 
    LANGUAGE plpgsql
    
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-11  Под загрузчик ГИС-Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --                  Сохранение списка переподчинения адресных объектов.
    -- ====================================================================================================
    BEGIN
	   INSERT INTO gar_fias.as_addr_obj_division AS d (
                             id        
                            ,parent_id 
                            ,child_id  
                            ,change_id     
       )
        VALUES (     i_id        
                    ,i_parent_id 
                    ,i_child_id  
                    ,i_change_id    
        )
        ON CONFLICT (id) DO
        
             UPDATE   SET    parent_id = excluded.parent_id
                            ,child_id  = excluded.child_id 
                            ,change_id = excluded.change_id     
    
              WHERE (d.id = excluded.id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_division (bigint, bigint, bigint, bigint) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_division (bigint, bigint, bigint, bigint) 
   IS 'Сохранение списка переподчинения адресных объектов.';
--
--  USE CASE:
