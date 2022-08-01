DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_get_twins ( varchar(250));
CREATE OR REPLACE FUNCTION gar_fias_pcg_load.f_addr_obj_get_twins (
       p_nm_addr_obj  varchar(250)    
)
    RETURNS 
       TABLE (
                 id_addr_obj        bigint    
                ,fias_guid          uuid
                ,nm_addr_obj_full   text 
                ,change_id          bigint
                ,start_date         date
                ,end_date           date
       )
    STABLE
    LANGUAGE sql
 AS
  $$
      SELECT object_id, object_guid
        ,(SELECT string_agg ((nm_addr_obj || ' ' || addr_obj_type || '.'), ', ')
             FROM gar_fias_pcg_load.f_addr_obj_get_parents (object_guid)
         )
        ,change_id, start_date, end_date	  
       FROM gar_fias.as_addr_obj
       
      WHERE (upper (object_name) = upper(btrim(p_nm_addr_obj))) 
               AND is_active AND is_actual;
  $$;
 
ALTER FUNCTION gar_fias_pcg_load.f_addr_obj_get_twins (varchar(250)) OWNER TO postgres;  

COMMENT ON FUNCTION gar_fias_pcg_load.f_addr_obj_get_twins (varchar(250))
    IS 'Функция формирует список объектов-двойников';    
-- --------------
--  USE CASE:
--   EXPLAIN   SELECT * FROM gar_fias_pcg_load.f_addr_obj_get_twins ('вОЛКОВО');
