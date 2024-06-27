DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_room_type (bigint, varchar(100), varchar(250), date, date, date, boolean);
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_room_type (bigint, varchar(100), varchar(50), varchar(250), date, date, date, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_room_type (

                         i_id          gar_fias.as_room_type.type_id%TYPE
                        ,i_type_name   gar_fias.as_room_type.type_name%TYPE
                        ,i_short_name  gar_fias.as_room_type.short_name%TYPE
                        ,i_type_desc   gar_fias.as_room_type.type_desc%TYPE
                        ,i_update_date gar_fias.as_room_type.update_date%TYPE
                        ,i_start_date  gar_fias.as_room_type.start_date%TYPE
                        ,i_end_date    gar_fias.as_room_type.end_date%TYPE                       
                        ,i_is_active   gar_fias.as_room_type.is_active%TYPE
                       
) 
    LANGUAGE plpgsql 
    AS $$
    BEGIN
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-11-12 Модификация под загрузчик ГИС Интеграция
    -- ----------------------------------------------------------------------------------------------------  
    --    Сохранение списка типов помещений. 
    -- ====================================================================================================
     INSERT INTO gar_fias.as_room_type AS t (   
                         type_id
                        ,type_name
                        ,short_name
                        ,type_desc
                        ,update_date
                        ,start_date
                        ,end_date                       
                        ,is_active
     )
      VALUES (   
                         i_id         
                        ,i_type_name 
                        ,i_short_name
                        ,i_type_desc  
                        ,i_update_date
                        ,i_start_date 
                        ,i_end_date                       
                        ,i_is_active  
      )
        ON CONFLICT (type_id) DO 
        
                     UPDATE
                            SET  type_name   = excluded.type_name
                                ,short_name  = excluded.short_name
                                ,type_desc   = excluded.type_desc
                                ,update_date = excluded.update_date
                                ,start_date  = excluded.start_date
                                ,end_date    = excluded.end_date                       
                                ,is_active   = excluded.is_active
                                 
                      WHERE (t.type_id = excluded.type_id);                  
   END;          
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_room_type (bigint, varchar(100), varchar(50), varchar(250), date, date, date, boolean)
     OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_room_type (bigint, varchar(100), varchar(50), varchar(250), date, date, date, boolean) 
IS 'Сохранение списка типов помещений';
-- -----------------------------------------------------------------------------------------------------
-- USE CASE:

