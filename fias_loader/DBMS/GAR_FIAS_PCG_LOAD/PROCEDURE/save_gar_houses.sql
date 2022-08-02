DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_houses(bigint, bigint, uuid, bigint, character varying, character varying, character varying, bigint, bigint, bigint, bigint, bigint, bigint, date, date, date, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_houses (
                              i_id           gar_fias.as_houses.id%TYPE
                             ,i_object_id    gar_fias.as_houses.object_id%TYPE
                             ,i_object_guid  gar_fias.as_houses.object_guid%TYPE
                             ,i_change_id    gar_fias.as_houses.change_id%TYPE
                             ,i_house_num    gar_fias.as_houses.house_num%TYPE
                             ,i_add_num1     gar_fias.as_houses.add_num1%TYPE
                             ,i_add_num2     gar_fias.as_houses.add_num2%TYPE
                             ,i_house_type   gar_fias.as_houses.house_type%TYPE
                             ,i_add_type1    gar_fias.as_houses.add_type1%TYPE
                             ,i_add_type2    gar_fias.as_houses.add_type2%TYPE
                             ,i_oper_type_id gar_fias.as_houses.oper_type_id%TYPE
                             ,i_prev_id      gar_fias.as_houses.prev_id%TYPE
                             ,i_next_id      gar_fias.as_houses.next_id%TYPE
                             ,i_update_date  gar_fias.as_houses.update_date%TYPE
                             ,i_start_date   gar_fias.as_houses.start_date%TYPE
                             ,i_end_date     gar_fias.as_houses.end_date%TYPE
                             ,i_is_actual    gar_fias.as_houses.is_actual%TYPE
                             ,i_is_active    gar_fias.as_houses.is_active%TYPE 
    )                          
    LANGUAGE plpgsql SECURITY DEFINER
          SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    --  Author: Nick
    --  Create date: 2021-10-13
    --  Updates:  2021-11-03 Модификация под загрузчик ГИС Интеграция    
    -- ----------------------------------------------------------------------------------------------------  
    --  Сохранение списка домов. 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_houses AS h (
                              id
                             ,object_id
                             ,object_guid
                             ,change_id
                             ,house_num
                             ,add_num1
                             ,add_num2
                             ,house_type
                             ,add_type1
                             ,add_type2
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
                    ,i_house_num    
                    ,i_add_num1     
                    ,i_add_num2     
                    ,i_house_type   
                    ,i_add_type1    
                    ,i_add_type2    
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
                    ,house_num    = excluded.house_num
                    ,add_num1     = excluded.add_num1
                    ,add_num2     = excluded.add_num2
                    ,house_type   = excluded.house_type
                    ,add_type1    = excluded.add_type1
                    ,add_type2    = excluded.add_type2
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

ALTER PROCEDURE gar_fias_pcg_load.save_gar_houses(bigint, bigint, uuid, bigint, character varying, character varying, character varying, bigint, bigint, bigint, bigint, bigint, bigint, date, date, date, boolean, boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_houses(bigint, bigint, uuid, bigint, character varying, character varying, character varying, bigint, bigint, bigint, bigint, bigint, bigint, date, date, date, boolean, boolean) 
   IS 'Сохранение списка домов';
--
--  USE CASE:

