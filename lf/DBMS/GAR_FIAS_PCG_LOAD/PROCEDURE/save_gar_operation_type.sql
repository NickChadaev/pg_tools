DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_operation_type (bigint, varchar(100), varchar(100), varchaR(250), date, date, date, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_operation_type (
                        i_oper_type_id    gar_fias.as_operation_type.oper_type_id%TYPE
                       ,i_oper_type_name  gar_fias.as_operation_type.oper_type_name%TYPE
                       ,i_short_name      gar_fias.as_operation_type.short_name%TYPE
                       ,i_descr           gar_fias.as_operation_type.descr%TYPE
                       ,i_update_date     gar_fias.as_operation_type.update_date%TYPE
                       ,i_start_date      gar_fias.as_operation_type.start_date%TYPE
                       ,i_end_date        gar_fias.as_operation_type.end_date%TYPE
                       ,i_is_active       gar_fias.as_operation_type.is_active%TYPE
) 
    LANGUAGE plpgsql 
    AS $$
    BEGIN
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-04
    -- Updates:  2021-11-08 Модификация под загрузчик ГИС Интеграция    
    -- ----------------------------------------------------------------------------------------------------  
    -- Сохранение списка статусов действий. 
     -- ====================================================================================================
     INSERT INTO gar_fias.as_operation_type AS t(  oper_type_id   
                                                  ,oper_type_name 
                                                  ,short_name     
                                                  ,descr          
                                                  ,update_date    
                                                  ,start_date     
                                                  ,end_date       
                                                  ,is_active         
     )
      VALUES (   i_oper_type_id
                ,i_oper_type_name
                ,i_short_name
                ,i_descr
                ,i_update_date
                ,i_start_date
                ,i_end_date
                ,i_is_active
      )
        ON CONFLICT (oper_type_id) DO 
                     UPDATE
                            SET   oper_type_name = excluded.oper_type_name
                                 ,short_name     = excluded.short_name    
                                 ,descr          = excluded.descr         
                                 ,update_date    = excluded.update_date   
                                 ,start_date     = excluded.start_date    
                                 ,end_date       = excluded.end_date      
                                 ,is_active      = excluded.is_active 
                                 
                      WHERE (t.oper_type_id = excluded.oper_type_id);                  
   END;          
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_operation_type (bigint, varchar(100), varchar(100), varchaR(250), date, date, date, boolean)
     OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_operation_type (bigint, varchar(100), varchar(100), varchaR(250), date, date, date, boolean) 
IS 'Сохранение списка статусов действий';
-- -----------------------------------------------------------------------------------------------------
-- USE CASE:
