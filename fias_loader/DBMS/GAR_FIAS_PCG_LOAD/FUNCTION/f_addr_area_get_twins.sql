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
                ,is_actual          boolean
                ,is_active          boolean
       )
    STABLE
    LANGUAGE sql
 AS
  $$
      SELECT object_id
           , object_guid
           , (SELECT string_agg ((nm_addr_obj || ' ' || addr_obj_type || '.'), ', ')
               FROM gar_fias_pcg_load.f_addr_obj_get_parents (object_guid)
             )
          , change_id
          , start_date
          , end_date
          ,is_actual
          ,is_active
          	  
       FROM gar_fias.as_addr_obj
       
      WHERE (upper (object_name) = upper(btrim(p_nm_addr_obj))) 
             ;--  AND is_active AND is_actual;
  $$;
 
ALTER FUNCTION gar_fias_pcg_load.f_addr_obj_get_twins (varchar(250)) OWNER TO postgres;  

COMMENT ON FUNCTION gar_fias_pcg_load.f_addr_obj_get_twins (varchar(250))
    IS 'Функция формирует список объектов-двойников';    
-- --------------
--  USE CASE:
--   EXPLAIN   SELECT * FROM gar_fias_pcg_load.f_addr_obj_get_twins ('Буденновская');
-----------------------------------------------------------------------------------------------------------
-- "id_addr_obj"|"fias_guid"|"nm_addr_obj_full"|"change_id"|"start_date"|"end_date"|"is_actual"|"is_active"
-- 82811|"8b87e6c4-617a-4d32-9414-fada8d0d3e8b"|"Буденновская ул., Кизляр г., Дагестан Респ."|233561|"2019-10-29"|"2079-06-06"|t|t
-- 78962|"ddf6a4e7-5207-42fd-8af3-89c905d0f368"|"Буденновская ул., Кизляр г., Дагестан Респ."|223919|"2014-02-20"|"2079-06-06"|f|f
-- 82471|"bb301a7c-c4f5-4c00-a564-b4854377bfbb"|"Буденновская ул., Кизляр г., Дагестан Респ."|232768|"2019-10-18"|"2079-06-06"|f|f

