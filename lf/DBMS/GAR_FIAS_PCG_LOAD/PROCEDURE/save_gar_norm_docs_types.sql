DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_norm_docs_types (bigint, varchar(500), date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_norm_docs_types (
                      i_id         gar_fias.as_norm_docs_types.doc_type_id%TYPE
                     ,i_doc_name   gar_fias.as_norm_docs_types.doc_name%TYPE
                     ,i_start_date gar_fias.as_norm_docs_types.start_date%TYPE
                     ,i_end_date   gar_fias.as_norm_docs_types.end_date%TYPE                             
                             
)  LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-05
    -- Updates:  2021-11-02 Модификация под загрузчик ГИС Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --    Сохранение списка нормативных документов. 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_norm_docs_types AS a (  
                      doc_type_id
                     ,doc_name   
                     ,start_date 
                     ,end_date          
                   )
          VALUES (    i_id         
                     ,i_doc_name   
                     ,i_start_date 
                     ,i_end_date       
         )
           ON CONFLICT (doc_type_id) DO UPDATE
           
                        SET 
                            doc_name   = excluded.doc_name 
                           ,start_date = excluded.start_date 
                           ,end_date   = excluded.end_date 
                            
                WHERE (a.doc_type_id = excluded.doc_type_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_norm_docs_types (bigint, varchar(500), date, date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_norm_docs_types (bigint, varchar(500), date, date) IS 'Сохранение списка нормативных документов';
--
--  USE CASE:
--

     
