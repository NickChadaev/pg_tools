DROP FUNCTION IF EXISTS export_version.f_version_put (date, boolean, bigint);
CREATE OR REPLACE FUNCTION export_version.f_version_put (
            p_dt_gar_version  date
          , p_kd_export_type  boolean
          , p_id_region       bigint

) 
  RETURNS bigint
  
    LANGUAGE plpgsql SECURITY DEFINER
    
    AS $$
    -- ========================================================================
    -- Author: Nick
    -- Create date: 2022-12-09
    -- ------------------------------------------------------------------------  
    -- ========================================================================
    DECLARE
       _id_un_export bigint;
    
    BEGIN
    
        INSERT INTO export_version.un_export ( dt_gar_version
                                              ,kd_export_type
                                              ,id_region
         )
         VALUES ( p_dt_gar_version
                 ,p_kd_export_type
                 ,p_id_region     
        )    
          ON CONFLICT (dt_gar_version) DO UPDATE
                 SET 
                      dt_gar_version = excluded.dt_gar_version  
                     ,kd_export_type = excluded.kd_export_type  
                     ,id_region      = excluded.id_region  
                 
                 WHERE (export_version.un_export.dt_gar_version = excluded.dt_gar_version)
             
        RETURNING id_un_export INTO _id_un_export;   
        
      RETURN _id_un_export;
    END;
  $$;

ALTER FUNCTION export_version.f_version_put (date, boolean, bigint) OWNER TO postgres;

COMMENT ON FUNCTION export_version.f_version_put (date, boolean, bigint) IS 'Сохранение Версии ГАР ФИАС';
-- ------------------------------------------------------------------------------------------------------
--  USE CASE:
--
--  SELECT export_version.f_version_put (
--                    p_dt_gar_version := '2022-11-21'::date
--                   ,p_kd_export_type := True 
--                   ,p_id_region      := 77
--  );                 
-- --
-- SELECT * FROM export_version.un_export;
