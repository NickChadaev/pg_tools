DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_agg ( date, uuid[]);
CREATE OR REPLACE FUNCTION gar_fias_pcg_load.f_addr_obj_agg (
        p_curr_date date   = current_date
       ,p_uuids     uuid[] = NULL
)
    RETURNS 
       TABLE (
                 fias_guid_new      uuid
                ,fias_guid_old      uuid
                ,nm_addr_obj        text 
                ,addr_obj_type_id   bigint
                ,obj_level          bigint
       )
    STABLE
    LANGUAGE sql
 AS
  $$
     WITH z (   id_addr_obj
               ,id_addr_parent
               ,nm_addr_obj
               ,addr_obj_type_id
               ,date_create
               ,id_lead
               ,obj_level
      ) AS 
        (
          -- Выбираю записи, принадлежание обрабатываемой дате.
          SELECT  x.id_addr_obj
                 ,x.id_addr_parent
                 ,upper(x.nm_addr_obj)
                 ,x.addr_obj_type_id
                 ,x.date_create
                 ,x.id_lead
                 ,x.obj_level
                
               FROM gar_fias.gap_adr_area x WHERE (x.date_create = p_curr_date) AND 
                   (((x.fias_guid = ANY (p_uuids)) AND (p_uuids IS NOT NULL)) OR
                    (p_uuids IS NULL)
                   )  
         )
         
           SELECT DISTINCT ON (a.fias_guid, b.fias_guid)
                  a.fias_guid AS fias_guid_new
                , b.fias_guid AS fias_guid_old 
                , z.nm_addr_obj 
                , z.addr_obj_type_id              
                , z.obj_level
           FROM z
             JOIN gar_fias.gap_adr_area a ON (z.id_lead = a.id_addr_obj) AND  (z.date_create = a.date_create)
             JOIN gar_fias.gap_adr_area b ON (z.id_lead <> b.id_addr_obj) AND (b.date_create = z.date_create) AND
                                             (z.id_addr_parent = b.id_addr_parent)  AND
                                             (z.nm_addr_obj = upper(b.nm_addr_obj)) AND
                                             (z.addr_obj_type_id = b.addr_obj_type_id); 
  $$;
 
ALTER FUNCTION gar_fias_pcg_load.f_addr_obj_agg (date, uuid[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_fias_pcg_load.f_addr_obj_agg (date, uuid[])
    IS 'Функция формирует список объектов-двойников';    
-- --------------
--  USE CASE:
--   EXPLAIN   SELECT * FROM gar_fias_pcg_load.f_addr_obj_agg (current_date, ARRAY['5470bf73-8900-4e4b-935c-d2724ea3ca3e', 'e4404769-507d-488e-9211-390769a182a0', '884e0862-aa3b-463d-9ac3-06bc2b1fdab8']::uuid[]);
-----------------------------------------------------------------------------------------------------------


