DROP FUNCTION IF EXISTS export_version.f_version_put (date, boolean, bigint, text, numeric(3,0));
CREATE OR REPLACE FUNCTION export_version.f_version_put (
            p_dt_gar_version  date
          , p_kd_export_type  boolean
          , p_id_region       bigint
          , p_seq_name        text
          , p_node_id         numeric (3,0)

) 
  RETURNS bigint
  
    LANGUAGE plpgsql SECURITY DEFINER
    
    AS $$
    -- ========================================================================
    -- Author: Nick
    -- Create date: 2022-12-09
    -- ------------------------------------------------------------------------
    --  2023-04-05 Обновление, добавлены: "dt_export", "nm_user"
    -- ========================================================================
    DECLARE
       _id_un_export bigint;
       _seq_value    bigint;
       
       _get_seq_value text = $_$
              SELECT last_value FROM %s;
       $_$;
    
    BEGIN
        EXECUTE format(_get_seq_value, p_seq_name) INTO _seq_value;
    
        INSERT INTO export_version.un_export ( dt_gar_version
                                              ,kd_export_type
                                              ,id_region
                                              ,seq_value      
                                              ,node_id                                                     
         )
         VALUES ( p_dt_gar_version
                 ,p_kd_export_type
                 ,p_id_region  
                 ,_seq_value
                 ,p_node_id
         )    
          ON CONFLICT (dt_gar_version) DO UPDATE
                 SET 
                      kd_export_type = excluded.kd_export_type  
                     ,id_region      = excluded.id_region  
                     ,seq_value      = excluded.seq_value
                     ,node_id        = excluded.node_id 
                     ,dt_export      = now()
                     ,nm_user        = SESSION_USER
                 WHERE (export_version.un_export.dt_gar_version = excluded.dt_gar_version)
             
        RETURNING id_un_export INTO _id_un_export;   
        
      RETURN _id_un_export;
    END;
  $$;

ALTER FUNCTION export_version.f_version_put (date, boolean, bigint, text,numeric(3,0)) OWNER TO postgres;

COMMENT ON FUNCTION export_version.f_version_put (date, boolean, bigint, text,numeric(3,0))
IS 'Сохранение Версии Обработанных Адресных Данных';
-- ------------------------------------------------------------------------------------------------------
--  USE CASE:
--
--  SELECT export_version.f_version_put (
--                    p_dt_gar_version := '2022-11-21'::date
--                   ,p_kd_export_type := True 
--                   ,p_id_region      := 77
--                   ,p_seq_name       := 'gar_tmp.obj_seq'
--                   ,p_node_id        := 11
--  );                 
-- --
-- SELECT * FROM export_version.un_export;
