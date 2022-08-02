DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_change_history (bigint, bigint, uuid, bigint, bigint, date);

CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_change_history (
                         i_change_id     gar_fias.as_change_history.change_id%TYPE
                        ,i_object_id     gar_fias.as_change_history.object_id%TYPE
                        ,i_adr_object_id gar_fias.as_change_history.adr_object_uuid%TYPE
                        ,i_oper_type_id  gar_fias.as_change_history.oper_type_id%TYPE
                        ,i_ndoc_id       gar_fias.as_change_history.ndoc_id%TYPE
                        ,i_change_date   gar_fias.as_change_history.change_date%TYPE 
) 
  LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias_pcg_loadgar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick. 2021-10-21
    -- Updates:  2021-11-03 Модификация под загрузчик ГИС Интеграция.     
    -- ----------------------------------------------------------------------------------------------------  
    --  Сохранение параметров истории изменений адресного объекта. 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_change_history AS c (
                                         change_id
                                        ,object_id
                                        ,adr_object_uuid
                                        ,oper_type_id
                                        ,ndoc_id
                                        ,change_date         
        )
          VALUES (       i_change_id     
                        ,i_object_id     
                        ,i_adr_object_id 
                        ,i_oper_type_id  
                        ,i_ndoc_id
                        ,i_change_date            
          )
            ON CONFLICT (change_id) DO 
                UPDATE
                      SET
                           object_id       = excluded.object_id
                          ,adr_object_uuid = excluded.adr_object_uuid
                          ,oper_type_id    = excluded.oper_type_id
                          ,ndoc_id         = excluded.ndoc_id
                          ,change_date     = excluded.change_date                                
                          
                    WHERE (c.change_id = excluded.change_id);           
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_change_history (bigint, bigint, uuid, bigint, bigint, date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_change_history (bigint, bigint, uuid, bigint, bigint, date) 
IS 'Сохранение параметров истории изменений адресного объекта';
--
--  USE CASE:
