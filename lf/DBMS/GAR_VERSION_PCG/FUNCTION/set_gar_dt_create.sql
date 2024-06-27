DROP FUNCTION IF EXISTS gar_version_pcg_support.set_gar_dt_create (bigint, timestamp without time zone);
DROP FUNCTION IF EXISTS gar_version_pcg_support.set_gar_dt_create (date, timestamp without time zone);
CREATE OR REPLACE FUNCTION gar_version_pcg_support.set_gar_dt_create (

                  i_nm_garfias_version gar_version.garfias_version.nm_garfias_version%TYPE
                 ,i_dt_create          gar_version.garfias_version.dt_create%TYPE
) 
  RETURNS gar_version.garfias_version.id_garfias_version%TYPE
  
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_version_pcg_support, gar_version, public
    
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-11-09/2021-11-17
    -- ----------------------------------------------------------------------------------------------------  
    --    Установка даты загрузки данных ГАР ФИАС в Систему. 
    -- ====================================================================================================
    DECLARE
       _id_garfias_version  gar_version.garfias_version.id_garfias_version%TYPE;
    
    BEGIN
        UPDATE gar_version.garfias_version
             SET 
                 dt_create = i_dt_create         
             
             WHERE (nm_garfias_version = i_nm_garfias_version)
             
        RETURNING id_garfias_version INTO _id_garfias_version;   
        
      RETURN _id_garfias_version;
      
    END;
  $$;

ALTER FUNCTION gar_version_pcg_support.set_gar_dt_create (date, timestamp without time zone) OWNER TO postgres;

COMMENT ON FUNCTION gar_version_pcg_support.set_gar_dt_create (date, timestamp without time zone) 
            IS 'Установка даты загрузки данных ГАР ФИАС в Систему';
--
--  USE CASE:
-- BEGIN;
--  SELECT gar_version_pcg_support.set_gar_dt_create ('2021-09-27'::date, now()::timestamp without time zone); 
--  SELECT * FROM gar_version.garfias_version;
-- ROLLBACK; 

