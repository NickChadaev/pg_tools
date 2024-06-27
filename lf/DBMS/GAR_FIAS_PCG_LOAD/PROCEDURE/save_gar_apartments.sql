DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_apartments (bigint,bigint,uuid,bigint,varchar(50),bigint,bigint,bigint,bigint,date,date,date,boolean,boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_apartments (
                    i_id           gar_fias.as_apartments.id%TYPE
                   ,i_object_id    gar_fias.as_apartments.object_id%TYPE
                   ,i_object_guid  gar_fias.as_apartments.object_guid%TYPE
                   ,i_change_id    gar_fias.as_apartments.change_id%TYPE
                   ,i_apart_number gar_fias.as_apartments.apart_number%TYPE
                   ,i_apart_type   gar_fias.as_apartments.apart_type_id%TYPE
                   ,i_oper_type_id gar_fias.as_apartments.oper_type_id%TYPE
                   ,i_prev_id      gar_fias.as_apartments.prev_id%TYPE
                   ,i_next_id      gar_fias.as_apartments.next_id%TYPE
                   ,i_update_date  gar_fias.as_apartments.update_date%TYPE
                   ,i_start_date   gar_fias.as_apartments.start_date%TYPE
                   ,i_end_date     gar_fias.as_apartments.end_date%TYPE
                   ,i_is_actual    gar_fias.as_apartments.is_actual%TYPE
                   ,i_is_active    gar_fias.as_apartments.is_active%TYPE
    )                          
    LANGUAGE plpgsql SECURITY DEFINER
          SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    --  Author: Nick
    --  Create date: 2021-11-10 Под загрузчик ГИС Интеграци
    -- ----------------------------------------------------------------------------------------------------  
    --           Сохранение списка помещений
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_apartments AS a (
                    id
                   ,object_id
                   ,object_guid
                   ,change_id
                   ,apart_number
                   ,apart_type_id
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
                   ,i_apart_number 
                   ,i_apart_type   
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
                    object_id     = excluded.object_id
                   ,object_guid   = excluded.object_guid
                   ,change_id     = excluded.change_id
                   ,apart_number  = excluded.apart_number
                   ,apart_type_id = excluded.apart_type_id
                   ,oper_type_id  = excluded.oper_type_id
                   ,prev_id       = excluded.prev_id
                   ,next_id       = excluded.next_id
                   ,update_date   = excluded.update_date
                   ,start_date    = excluded.start_date
                   ,end_date      = excluded.end_date
                   ,is_actual     = excluded.is_actual
                   ,is_active     = excluded.is_active                 
         
        WHERE (a.id = excluded.id);           
        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_apartments (bigint,bigint,uuid,bigint,varchar(50),bigint,bigint,bigint,bigint,date,date,date,boolean,boolean) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_apartments (bigint,bigint,uuid,bigint,varchar(50),bigint,bigint,bigint,bigint,date,date,date,boolean,boolean) 
   IS 'Сохранение списка помещений';
--
--  USE CASE:

