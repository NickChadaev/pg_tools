DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_house_type (bigint, character varying, character varying, character varying, boolean, date, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_house_type (
                              i_id             gar_fias.as_house_type.house_type_id%TYPE
                             ,i_type_name      gar_fias.as_house_type.type_name%TYPE
                             ,i_type_shortname gar_fias.as_house_type.type_shortname%TYPE
                             ,i_type_desc      gar_fias.as_house_type.type_descr%TYPE
                             ,i_is_active      gar_fias.as_house_type.is_active%TYPE
                             ,i_update_date    gar_fias.as_house_type.update_date%TYPE
                             ,i_start_date     gar_fias.as_house_type.start_date%TYPE
                             ,i_end_date       gar_fias.as_house_type.end_date%TYPE                     

)  LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-05
    -- Updates:  2021-11-02 Модификация под загрузчик ГИС Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --    Сохранение списка признаков владения (типов домов). 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_house_type AS a (  house_type_id 
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
           ON CONFLICT (house_type_id) DO UPDATE
                        SET  type_name      = excluded.type_name      
                            ,type_shortname = excluded.type_shortname 
                            ,type_descr     = excluded.type_descr     
                            ,update_date    = excluded.update_date    
                            ,start_date     = excluded.start_date     
                            ,end_date       = excluded.end_date       
                            ,is_active      = excluded.is_active                
                WHERE (a.house_type_id = excluded.house_type_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_house_type (bigint, character varying, character varying, character varying, boolean, date, date, date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_house_type (bigint, character varying, character varying, character varying, boolean, date, date, date) 
    IS 'Сохранение списка признаков владений (типов домов)';
--
--  USE CASE:
--
