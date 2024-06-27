DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_norm_docs_kinds (bigint, varchar(500));
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_norm_docs_kinds (

                       i_id        gar_fias.as_norm_docs_kinds.doc_kind_id%TYPE
                      ,i_doc_name  gar_fias.as_norm_docs_kinds.doc_name%TYPE                     
                             
)  LANGUAGE plpgsql SECURITY DEFINER

    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    --   Author: Nick Сохранение списка видов документов
    --   Create date: 2021-11-11
    --   Updates:  2021-11-02 Модификация под загрузчик ГИС Интеграция.
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_norm_docs_kinds AS a (  
                      doc_kind_id
                     ,doc_name   
                   )
          VALUES (    i_id         
                     ,i_doc_name   
          )
             ON CONFLICT (doc_kind_id) DO UPDATE
           
                        SET 
                            doc_name   = excluded.doc_name 
                           
              WHERE (a.doc_kind_id = excluded.doc_kind_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_norm_docs_kinds (bigint, varchar(500)) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_norm_docs_kinds (bigint, varchar(500)) IS 'Сохранение списка нормативных документов';
--
--  USE CASE:
--

     
