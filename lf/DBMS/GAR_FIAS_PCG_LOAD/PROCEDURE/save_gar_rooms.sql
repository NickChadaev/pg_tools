DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_rooms (bigint, bigint, uuid, bigint, varchar(50), bigint, bigint, bigint, bigint, date, date, date, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_rooms (
                            
                          i_id           gar_fias.as_rooms.id%TYPE
                         ,i_object_id    gar_fias.as_rooms.object_id%TYPE
                         ,i_object_guid  gar_fias.as_rooms.object_guid%TYPE
                         ,i_change_id    gar_fias.as_rooms.change_id%TYPE
                         ,i_room_number  gar_fias.as_rooms.room_number%TYPE
                         ,i_room_type    gar_fias.as_rooms.room_type_id%TYPE
                         ,i_oper_type_id gar_fias.as_rooms.oper_type_id%TYPE
                         ,i_prev_id      gar_fias.as_rooms.prev_id%TYPE
                         ,i_next_id      gar_fias.as_rooms.next_id%TYPE
                         ,i_update_date  gar_fias.as_rooms.update_date%TYPE
                         ,i_start_date   gar_fias.as_rooms.start_date%TYPE
                         ,i_end_date     gar_fias.as_rooms.end_date%TYPE
                         ,i_is_actual    gar_fias.as_rooms.is_actual%TYPE
                         ,i_is_active    gar_fias.as_rooms.is_active%TYPE                            
                             
    )                          
    LANGUAGE plpgsql SECURITY DEFINER
          SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    --    Author: Nick Сохранение списка помещений. 
    --    Create date: 2021-11-12 Под загрузчик ГИС Интеграция 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_rooms AS h (
        
                          id
                         ,object_id
                         ,object_guid
                         ,change_id
                         ,room_number
                         ,room_type_id
                         ,oper_type_id
                         ,prev_id
                         ,next_id
                         ,update_date
                         ,start_date
                         ,end_date
                         ,is_actual
                         ,is_active          
        )
          VALUES (
                          i_id           
                         ,i_object_id    
                         ,i_object_guid  
                         ,i_change_id    
                         ,i_room_number  
                         ,i_room_type    
                         ,i_oper_type_id 
                         ,i_prev_id      
                         ,i_next_id      
                         ,i_update_date  
                         ,i_start_date   
                         ,i_end_date     
                         ,i_is_actual    
                         ,i_is_active         
          )
           
         ON CONFLICT (id) DO UPDATE
                SET
                          object_id    = excluded.object_id
                         ,object_guid  = excluded.object_guid
                         ,change_id    = excluded.change_id
                         ,room_number  = excluded.room_number
                         ,room_type_id = excluded.room_type_id
                         ,oper_type_id = excluded.oper_type_id
                         ,prev_id      = excluded.prev_id
                         ,next_id      = excluded.next_id
                         ,update_date  = excluded.update_date
                         ,start_date   = excluded.start_date
                         ,end_date     = excluded.end_date
                         ,is_actual    = excluded.is_actual
                         ,is_active    = excluded.is_active            
         
        WHERE (h.id = excluded.id);           
        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_rooms (bigint, bigint, uuid, bigint, varchar(50), bigint, bigint, bigint, bigint, date, date, date, boolean, boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_rooms (bigint, bigint, uuid, bigint, varchar(50), bigint, bigint, bigint, bigint, date, date, date, boolean, boolean)
  IS 'Сохранение списка помещений';
--
--  USE CASE:


