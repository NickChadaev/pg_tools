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



