DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_param_type (bigint, varchar(50), varchar(250), varchar(250), boolean, date, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_param_type (
                              i_id             gar_fias.as_param_type.type_id%TYPE
                             ,i_type_name      gar_fias.as_param_type.type_name%TYPE
                             ,i_type_desc      gar_fias.as_param_type.type_desc%TYPE
                             ,i_type_code      gar_fias.as_param_type.type_code%TYPE
                             ,i_is_active      gar_fias.as_param_type.is_active%TYPE
                             ,i_update_date    gar_fias.as_param_type.update_date%TYPE
                             ,i_start_date     gar_fias.as_param_type.start_date%TYPE
                             ,i_end_date       gar_fias.as_param_type.end_date%TYPE    
                             
)  LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick  Сохранение списка типов параметров.
    -- Create date: 2021-11-11 Под загрузчик ГИС Интеграция.
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_param_type AS a (  type_id 
                                                  ,type_name 
                                                  ,type_code 
                                                  ,type_desc 
                                                  ,update_date 
                                                  ,start_date 
                                                  ,end_date 
                                                  ,is_active         
                   )
          VALUES (    i_id             
                     ,i_type_name      
                     ,i_type_code 
                     ,i_type_desc      
                     ,i_update_date    
                     ,i_start_date     
                     ,i_end_date       
                     ,i_is_active          
         )
           ON CONFLICT (type_id) DO UPDATE
           
                        SET  type_name    = excluded.type_name      
                            ,type_code    = excluded.type_code 
                            ,type_desc    = excluded.type_desc     
                            ,update_date  = excluded.update_date    
                            ,start_date   = excluded.start_date     
                            ,end_date     = excluded.end_date       
                            ,is_active    = excluded.is_active 
                            
                WHERE (a.type_id = excluded.type_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_param_type (bigint, varchar(50), varchar(250), varchar(250), boolean, date, date, date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_param_type (bigint, varchar(50), varchar(250), varchar(250), boolean, date, date, date) 
    IS 'Сохранение списка признаков владений (типов домов)';
--
--  USE CASE:
--

