DROP FUNCTION IF EXISTS gar_version_pcg_support.save_gar_version (date, boolean, timestamp without time zone, timestamp without time zone, text, text);
DROP FUNCTION IF EXISTS gar_version_pcg_support.save_gar_version (date, boolean, timestamp without time zone, text, timestamp without time zone, text);

CREATE OR REPLACE FUNCTION gar_version_pcg_support.save_gar_version (

                  i_nm_garfias_version gar_version.garfias_version.nm_garfias_version%TYPE
                 ,i_kd_download_type   gar_version.garfias_version.kd_download_type%TYPE
                 ,i_dt_download        gar_version.garfias_version.dt_download%TYPE
                 ,i_arc_path           gar_version.garfias_version.arc_path%TYPE
                 ,i_dt_create          gar_version.garfias_version.dt_create%TYPE = NULL
                 ,i_id_user            gar_version.garfias_version.id_user%TYPE   = session_user
) 
  RETURNS gar_version.garfias_version.id_garfias_version%TYPE
  
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_version_pcg_support, gar_version, public
    
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-11-09
    -- ----------------------------------------------------------------------------------------------------  
    --    Сохранение Версии ГАР ФИАС
    -- ====================================================================================================
    DECLARE
       _id_garfias_version gar_version.garfias_version.id_garfias_version%TYPE;
    
    BEGIN
        INSERT INTO gar_version.garfias_version AS v 
        (
                  nm_garfias_version 
                 ,kd_download_type   
                 ,dt_download        
                 ,dt_create          
                 ,id_user            
                 ,arc_path           
        )
          VALUES (
                  i_nm_garfias_version
                 ,i_kd_download_type  
                 ,i_dt_download       
                 ,i_dt_create         
                 ,i_id_user           
                 ,i_arc_path          
          )           
             ON CONFLICT (nm_garfias_version) DO UPDATE
                 SET 
                      kd_download_type   = excluded.kd_download_type  
                     ,dt_download        = excluded.dt_download       
                     ,dt_create          = excluded.dt_create         
                     ,id_user            = excluded.id_user           
                     ,arc_path           = excluded.arc_path          
                 
                 WHERE (v.nm_garfias_version = excluded.nm_garfias_version)
             
        RETURNING v.id_garfias_version INTO _id_garfias_version;   
        
      RETURN _id_garfias_version;
      
    END;
  $$;

ALTER FUNCTION gar_version_pcg_support.save_gar_version (date, boolean, timestamp without time zone, text, timestamp without time zone, text) OWNER TO postgres;

COMMENT ON FUNCTION gar_version_pcg_support.save_gar_version (date, boolean, timestamp without time zone, text, timestamp without time zone, text) 
            IS 'Сохранение Версии ГАР ФИАС';
--
--  USE CASE:
--
--  SELECT gar_version_pcg_support.save_gar_version (
--                    i_nm_garfias_version := '2021-09-27'
--                   ,i_kd_download_type   := FALSE 
--                   ,i_dt_download        := now()
--                   ,i_arc_path           := '/media/rootadmin/Transcend/gar_xml.zip'
--                    --
--                   ,i_dt_create          := NULL
--                   ,i_id_user            := session_user                  
--  );                 

-- SELECT gar_version_pcg_support.save_gar_version (
-- 
--       i_nm_garfias_version  := '2021-09-27'::date  
--      ,i_kd_download_type    := FALSE ::boolean  
--      ,i_dt_download         := now()::timestamp without time zone  
--      ,i_arc_path            := '/media/rootadmin/Transcend/gar_xml.zip'::text  
-- );
