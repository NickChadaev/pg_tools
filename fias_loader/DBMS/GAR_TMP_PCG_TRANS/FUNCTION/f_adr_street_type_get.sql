DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_street_type_get (text, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_street_type_get (
               p_schema                 text   -- Имя схемы
              ,p_id_addr_obj_fias_type  bigint -- ID типа - ФИАС.
              ,OUT id_street_type       bigint   
              ,OUT nm_street_type_short text  
)
    RETURNS setof record 
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
     
     OBJECT_KIND constant char(1) = '1'; -- Улицы
   
    _exec   text;
    --
    -- Прилетел ID FIAS. Нужно сразу найти справочный id и краткое имя.
    --    делаем это, используя fias_row_key.
    --    Преобразуем этот id, сразу из FIAS_ID в ЕС НСИ id, используя obj_alias.
    --    В том случае, если преобразование не удалось, используем уже готовый 
    --    ЕС НСИ id.
    --
    _select text = 
        $_$
           WITH x AS (
              SELECT  et.id_street_type
                    , et.nm_street_type
                    , et.nm_street_type_short
                    , xt.fias_row_key 
                 FROM %I.adr_street_type et
                   INNER JOIN gar_tmp.xxx_adr_street_type xt 
                      ON (xt.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char(et.nm_street_type))
               WHERE (%s = ANY(xt.fias_ids))
            )
            
           ,z AS (
                  SELECT max(z.id_object_type) AS id_street_type FROM x
                      INNER JOIN gar_tmp.xxx_object_type_alias z 
                            ON (z.fias_row_key = x.fias_row_key) AND (z.object_kind = %L)
                )
                
           ,f AS (
                    SELECT coalesce (z.id_street_type, x.id_street_type) AS id_street_type FROM z
                    CROSS JOIN x
                 )
                    SELECT a.id_street_type, a.nm_street_type_short FROM %I.adr_street_type a
                    INNER JOIN f ON (a.id_street_type = f.id_street_type);		 
        $_$;
           
   BEGIN
    -- --------------------------------------------------------------------------
    --  2022-11-21 Nick Преобразование ID улицы FIAS (as_adr_object_type) -> ЕС НСИ
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_id_addr_obj_fias_type, OBJECT_KIND, p_schema);  
     -- RAISE NOTICE '%', _exec;
     EXECUTE _exec INTO id_street_type, nm_street_type_short; 
     
     RETURN NEXT; 

   END;                   
  $$;
 
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_street_type_get (text, bigint) 
  IS 'Преобразование ID улицы FIAS -> ЕС НСИ.';

--
--  USE CASE:
--       SELECT * FROM gar_tmp_pcg_trans.f_street_type_get ('gar_tmp', 15);
--       SELECT * FROM gar_tmp_pcg_trans.f_street_type_get ('unnsi', 51);
--       SELECT * FROM gar_tmp_pcg_trans.f_street_type_get ('gar_tmp', 51) ;
--       SELECT * FROM gar_tmp_pcg_trans.f_street_type_get ('gar_tmp', 41) 
--       SELECT * FROM gar_tmp_pcg_trans.f_street_type_get ('gar_tmp', 9941) 
--  SELECT * FROM  gar_tmp.adr_street_type ORDER BY id_area_type; 
