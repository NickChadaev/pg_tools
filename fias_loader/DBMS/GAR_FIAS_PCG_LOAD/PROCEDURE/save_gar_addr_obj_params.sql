DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_addr_obj_params(bigint, bigint, bigint, bigint, bigint, text, date, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_params (
                            i_id            gar_fias.as_addr_obj_params.id%TYPE
                           ,i_object_id     gar_fias.as_addr_obj_params.object_id%TYPE
                           ,i_change_id     gar_fias.as_addr_obj_params.change_id%TYPE
                           ,i_change_id_end gar_fias.as_addr_obj_params.change_id_end%TYPE
                           ,i_type_id       gar_fias.as_addr_obj_params.type_id%TYPE
                           ,i_value         gar_fias.as_addr_obj_params.obj_value%TYPE
                           ,i_update_date   gar_fias.as_addr_obj_params.update_date%TYPE
                           ,i_start_date    gar_fias.as_addr_obj_params.start_date%TYPE
                           ,i_end_date      gar_fias.as_addr_obj_params.end_date%TYPE

) LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-07
    -- Updates:  2021-11-02 Модификация под загрузчик ГИС Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --  Сохраненеие параметров адресообразующего элемента. 
    --    На входе: Данные для формирования одной записи. После загрузки таблицы можно приступать
    --               загрузке адресообразующих элемнентов.
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_addr_obj_params AS i (
                                                        id           
                                                       ,object_id    
                                                       ,change_id    
                                                       ,change_id_end
                                                       ,type_id      
                                                       ,obj_value        
                                                       ,update_date  
                                                       ,start_date   
                                                       ,end_date     
        )
         VALUES (
                     i_id            
                    ,i_object_id     
                    ,i_change_id     
                    ,i_change_id_end 
                    ,i_type_id       
                    ,i_value         
                    ,i_update_date   
                    ,i_start_date    
                    ,i_end_date      
         )
          ON CONFLICT (id) DO UPDATE  
                         SET
                                 object_id     = excluded.object_id        
                                ,change_id     = excluded.change_id    
                                ,change_id_end = excluded.change_id_end
                                ,type_id       = excluded.type_id      
                                ,obj_value     = excluded.obj_value    
                                ,update_date   = excluded.update_date  
                                ,start_date    = excluded.start_date   
                                ,end_date      = excluded.end_date     
          
                  WHERE (i.id = excluded.id);           
        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_params(bigint, bigint, bigint, bigint, bigint, text, date, date, date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_params(bigint, bigint, bigint, bigint, bigint, text, date, date, date) 
      IS 'Загрузка параметров адресообразующего элемента';
--
--  USE CASE:
