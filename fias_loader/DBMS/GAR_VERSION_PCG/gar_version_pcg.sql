
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_version_pcg_support.save_gar_files_by_region (bigint, integer, text);
DROP FUNCTION IF EXISTS gar_version_pcg_support.save_gar_files_by_region (date, integer, text);
CREATE OR REPLACE FUNCTION gar_version_pcg_support.save_gar_files_by_region (

       i_nm_garfias_version  gar_version.garfias_version.nm_garfias_version%TYPE
      ,i_id_region           gar_version.garfias_files_by_region.id_region%TYPE
      ,i_file_path           gar_version.garfias_files_by_region.file_path%TYPE                    
) 
  RETURNS gar_version.garfias_files_by_region.id_file_version%TYPE
  
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_version_pcg_support, gar_version, public
    
    AS $$
    -- ====================================================================================================
    -- Author: Nick                                       
    -- Create date: 2021-11-09/2021-11-17
    -- ----------------------------------------------------------------------------------------------------  
    --    Сохранение Версии файла ГАР ФИАС
    -- ====================================================================================================
    DECLARE
       _id_file_version    gar_version.garfias_files_by_region.id_file_version%TYPE;
       _id_garfias_version gar_version.garfias_version.id_garfias_version%TYPE;
    
    BEGIN
        SELECT id_garfias_version INTO _id_garfias_version FROM gar_version.garfias_version 
                               WHERE (nm_garfias_version = i_nm_garfias_version);
    
        INSERT INTO gar_version.garfias_files_by_region AS v 
        (
             id_garfias_version
            ,id_region         
            ,file_path         
        )
          VALUES (
                    _id_garfias_version
                   ,i_id_region         
                   ,i_file_path         
          )           
            ON CONFLICT (file_path) DO 
                         UPDATE SET
                                id_garfias_version = excluded.id_garfias_version
                               ,id_region          = excluded.id_region         
                           WHERE (V.file_path = excluded.file_path)
             
        RETURNING v.id_file_version INTO _id_file_version;   
        
      RETURN _id_file_version;
      
    END;
  $$;

ALTER FUNCTION gar_version_pcg_support.save_gar_files_by_region (date, integer, text) OWNER TO postgres;

COMMENT ON FUNCTION gar_version_pcg_support.save_gar_files_by_region (date, integer, text) IS 'Сохранение Версии ГАР ФИАС';
--
--  USE CASE:

-- SELECT gar_version_pcg_support.save_gar_files_by_region ('2021-09-27', NULL, '/media/rootadmin/Transcend/FIAS_GAR1/AS_ADDHOUSE_TYPES_20210927_bc9df1c0-f77b-4e00-a49b-0a3c92254c66.XML');




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
