DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_object_level (bigint, varchar(100), varchar(50), date, date, date, boolean);

CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_object_level (
                           i_level_id     gar_fias.as_object_level.level_id%TYPE
                          ,i_level_name   gar_fias.as_object_level.level_name%TYPE
                          ,i_short_name   gar_fias.as_object_level.short_name%TYPE                          
                          ,i_update_date  gar_fias.as_object_level.update_date%TYPE
                          ,i_start_date   gar_fias.as_object_level.start_date%TYPE
                          ,i_end_date     gar_fias.as_object_level.end_date%TYPE
                          ,i_is_active    gar_fias.as_object_level.is_active%TYPE
) 
    LANGUAGE plpgsql
    
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-05
    --    2021-11-08 -- 
    --      Модификация под загрузчик ГИС-Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --  Сохранение списка уровней адресных объектов. 
    -- ====================================================================================================
    BEGIN
	   INSERT INTO gar_fias.as_object_level AS l (
                                level_id   
                               ,level_name 
                               ,short_name  
                               ,update_date
                               ,start_date 
                               ,end_date   
                               ,is_active       
       )
        VALUES (   i_level_id    
                  ,i_level_name  
                  ,i_short_name                          
                  ,i_update_date 
                  ,i_start_date  
                  ,i_end_date    
                  ,i_is_active        
        )
        ON CONFLICT (level_id) DO
        
             UPDATE   SET                    
                           level_name   = excluded.level_name 
                          ,short_name   = excluded.short_name 
                          ,update_date  = excluded.update_date
                          ,start_date   = excluded.start_date 
                          ,end_date     = excluded.end_date   
                          ,is_active    = excluded.is_active     
    
              WHERE (l.level_id = excluded.level_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_object_level (bigint, varchar(100), varchar(50), date, date, date, boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_object_level (bigint, varchar(100), varchar(50), date, date, date, boolean) IS 'Сохранение списка уровней адресных объектов.';
--
--  USE CASE:
