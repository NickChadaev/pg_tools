DROP FUNCTION IF EXISTS export_version.f_version_by_obj_put (date, text, text, char(1), text);
CREATE OR REPLACE FUNCTION export_version.f_version_by_obj_put (
                 p_dt_gar_version  date
                ,p_sch_object      text 
                ,p_nm_object       text
                ,p_object_kind     char(1)
                ,p_file_path       text              
) 
  RETURNS bigint
  
  LANGUAGE plpgsql SECURITY DEFINER
  
  AS $$
  -- =====================================================================
  --    Author: Nick                                       
  --    Create date: 2022-12-09
  -- ---------------------------------------------------------------------  
  -- =====================================================================
  DECLARE
     _id_un_export_by_obj  bigint;
     _id_un_export         bigint;
  
  BEGIN
    SELECT id_un_export INTO _id_un_export FROM export_version.un_export 
                           WHERE (dt_gar_version = p_dt_gar_version);
    IF (NOT found)
      THEN
          _id_un_export_by_obj := NULL;
      ELSE
        INSERT INTO export_version.un_export_by_obj AS v
        (        id_un_export
                ,nm_object
                ,object_kind
                ,qty_main
                ,qty_aux
                ,seq_value
                ,file_path
         )
             VALUES (_id_un_export
                    ,p_nm_object
                    ,p_object_kind
                    ,0
                    ,0
                    ,(SELECT last_value FROM gar_tmp.obj_seq)
                    ,p_file_path
             )                                
            ON CONFLICT (id_un_export, object_kind) 
            DO 
                 UPDATE SET  nm_object = excluded.nm_object
                            ,qty_main  = excluded.qty_main 
                            ,qty_aux   = excluded.qty_aux  
                            ,seq_value = excluded.seq_value
                            ,file_path = excluded.file_path
                            
                   WHERE (v.id_un_export = excluded.id_un_export) AND
                         (v.object_kind = excluded.object_kind)
             
        RETURNING v.id_un_export_by_obj INTO _id_un_export_by_obj;   
    END IF;  
      
    RETURN _id_un_export_by_obj;
  END;
$$;

ALTER FUNCTION export_version.f_version_by_obj_put (date, text, text, char(1), text) OWNER TO postgres;

COMMENT ON FUNCTION export_version.f_version_by_obj_put (date, text, text, char(1), text) IS 'Сохранение Версии ГАР ФИАС';
--
--  USE CASE:

-- SELECT export_version.f_version_by_obj_put ('2021-09-27', NULL, '/media/rootadmin/Transcend/FIAS_GAR1/AS_ADDHOUSE_TYPES_20210927_bc9df1c0-f77b-4e00-a49b-0a3c92254c66.XML');



