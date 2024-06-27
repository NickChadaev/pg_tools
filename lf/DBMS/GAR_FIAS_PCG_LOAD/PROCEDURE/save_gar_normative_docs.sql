DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_normative_docs (bigint, varchar(1500), date, varchar(150), bigint, bigint, date, varchar(255), date, varchar(100), date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_normative_docs (

               i_id          gar_fias.as_normative_docs.ndoc_id%TYPE
              ,i_doc_name    gar_fias.as_normative_docs.doc_name%TYPE
              ,i_doc_date    gar_fias.as_normative_docs.doc_date%TYPE
              ,i_doc_number  gar_fias.as_normative_docs.doc_number%TYPE
              ,i_doc_type    gar_fias.as_normative_docs.doc_type_id%TYPE
              ,i_doc_kind    gar_fias.as_normative_docs.doc_kind_id%TYPE
              ,i_update_date gar_fias.as_normative_docs.update_date%TYPE
              ,i_org_name    gar_fias.as_normative_docs.org_name%TYPE
              ,i_acc_date    gar_fias.as_normative_docs.acc_date%TYPE
              ,i_reg_num     gar_fias.as_normative_docs.reg_num%TYPE 
              ,i_reg_date    gar_fias.as_normative_docs.reg_date%TYPE
                           
) LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick Сохранение нормативных документов.
    -- Create date: 2021-11-11 Под загрузчик ГИС Интеграция
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_normative_docs AS i (
        
                          ndoc_id
                         ,doc_name
                         ,doc_date
                         ,doc_number
                         ,doc_type_id
                         ,doc_kind_id
                         ,update_date
                         ,org_name
                         ,acc_date
                         ,reg_num 
                         ,reg_date 
        )
         VALUES (
                          i_id          
                         ,i_doc_name    
                         ,i_doc_date    
                         ,i_doc_number  
                         ,i_doc_type    
                         ,i_doc_kind    
                         ,i_update_date 
                         ,i_org_name    
                         ,i_acc_date    
                         ,i_reg_num     
                         ,i_reg_date    
         )
          ON CONFLICT (ndoc_id) DO UPDATE  
                         SET
                              doc_name    = excluded.doc_name   
                             ,doc_date    = excluded.doc_date   
                             ,doc_number  = excluded.doc_number 
                             ,doc_type_id = excluded.doc_type_id
                             ,doc_kind_id = excluded.doc_kind_id
                             ,update_date = excluded.update_date
                             ,org_name    = excluded.org_name   
                             ,acc_date    = excluded.acc_date   
                             ,reg_num     = excluded.reg_num    
                             ,reg_date    = excluded.reg_date     
          
                  WHERE (i.ndoc_id = excluded.ndoc_id);           
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_normative_docs (bigint, varchar(1500), date, varchar(150), bigint, bigint, date, varchar(255), date, varchar(100), date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_normative_docs (bigint, varchar(1500), date, varchar(150), bigint, bigint, date, varchar(255), date, varchar(100), date) 
     IS 'Сохранение нормативных документов';
--
--  USE CASE:


