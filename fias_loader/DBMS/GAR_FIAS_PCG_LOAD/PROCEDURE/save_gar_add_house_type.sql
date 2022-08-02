DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_add_house_type (bigint, character varying, character varying, character varying, date, date, date, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_add_house_type (
                      i_id             gar_fias.as_add_house_type.add_type_id%TYPE
                     ,i_type_name      gar_fias.as_add_house_type.type_name%TYPE
                     ,i_type_shortname gar_fias.as_add_house_type.type_shortname%TYPE
                     ,i_type_desc      gar_fias.as_add_house_type.type_descr%TYPE
                     ,i_update_date    gar_fias.as_add_house_type.update_date%TYPE
                     ,i_start_date     gar_fias.as_add_house_type.start_date%TYPE
                     ,i_end_date       gar_fias.as_add_house_type.end_date%TYPE
                     ,i_is_active      gar_fias.as_add_house_type.is_active%TYPE

)  LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-05
    -- Updates:  2021-11-02 Модификация под загрузчик ГИС Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --    Сохранение списка ДОПОЛНИТЕЛЬНЫХ признаков владения (типов домов). 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_add_house_type AS a (  add_type_id 
                                                  ,type_name 
                                                  ,type_shortname 
                                                  ,type_descr 
                                                  ,update_date 
                                                  ,start_date 
                                                  ,end_date 
                                                  ,is_active         
                   )
          VALUES (    i_id             
                     ,i_type_name      
                     ,i_type_shortname 
                     ,i_type_desc      
                     ,i_update_date    
                     ,i_start_date     
                     ,i_end_date       
                     ,i_is_active          
         )
           ON CONFLICT (add_type_id) 
              DO UPDATE SET  add_type_id    = excluded.add_type_id    
                            ,type_name      = excluded.type_name      
                            ,type_shortname = excluded.type_shortname 
                            ,type_descr     = excluded.type_descr     
                            ,update_date    = excluded.update_date    
                            ,start_date     = excluded.start_date     
                            ,end_date       = excluded.end_date       
                            ,is_active      = excluded.is_active                
                WHERE (a.add_type_id = excluded.add_type_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_add_house_type (bigint, character varying, character varying, character varying, date, date, date, boolean) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_add_house_type (bigint, character varying, character varying, character varying, date, date, date, boolean) 
      IS 'Сохранение списка дополнительных признаков владений (типов домов)';
--
--  USE CASE:
--
