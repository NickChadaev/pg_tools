DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_street_type_get (text, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_street_type_get (
               p_schema                text   -- Имя схемы
              ,p_id_area_fias_type     bigint -- ID типа - ФИАС.
              ,OUT id_area_type        bigint 
              ,OUT nm_area_type_short  text  
)
    RETURNS setof record 
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
     
     OBJECT_KIND constant char(1) = '0'; -- адресные пространства.
   
    _exec   text;
    --
    -- Прилетел ID FIAS. Нужно сразу найти справочный id и краткое имя.
    --    делаем это, используя fias_row_key.
    --    Преобразуем этот id, сразу из FIAS_ID в ЕС НСИ id, используя obj_alias.
    --    В том случае, если преобразование не удалось, используем уже готовы 
    --    ЕС НСИ id.
    --
    _select text = 
        $_$
           WITH x AS (
              SELECT  et.id_area_type
                    , et.nm_area_type
                    , et.nm_area_type_short
                    , xt.fias_row_key 
                 FROM %I.adr_area_type et
                   INNER JOIN gar_tmp.xxx_adr_area_type xt 
                      ON (xt.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char (et.nm_area_type))
               WHERE (%s = ANY(xt.fias_ids))
            )
            
           ,z AS (
                  SELECT max(z.id_object_type) AS id_area_type FROM x
                      INNER JOIN gar_tmp.xxx_object_type_alias z 
                            ON (z.fias_row_key = x.fias_row_key) AND (z.object_kind = %L)
                )
                
           ,f AS (
                    SELECT coalesce (z.id_area_type, x.id_area_type ) AS id_area_type FROM z
                    CROSS JOIN x
                 )
                    SELECT a.id_area_type, a.nm_area_type_short FROM %I.adr_area_type a
                    INNER JOIN f ON (a.id_area_type = f.id_area_type);		 
        $_$;
           
   BEGIN
    -- --------------------------------------------------------------------------
    --  2022-11-21 Nick Преобразование ID адресного региона FIAS -> ЕС НСИ
    -- --------------------------------------------------------------------------
    
     _exec := format (_select, p_schema, p_id_area_fias_type, OBJECT_KIND, p_schema);  
     -- RAISE NOTICE '%', _exec;
     EXECUTE _exec INTO id_area_type, nm_area_type_short;  
     
     RETURN NEXT; 

   END;                   
  $$;
 
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_street_type_get (text, bigint) 
  IS 'Преобразование ID адресного улицы FIAS -> ЕС НСИ.';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_street_type_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT * FROM gar_tmp_pcg_trans.f_street_type_get ('gar_tmp', 15);
--       SELECT * FROM gar_tmp_pcg_trans.f_street_type_get ('unnsi', 51);
--       SELECT * FROM gar_tmp_pcg_trans.f_street_type_get ('gar_tmp', 51) ;
--       SELECT * FROM gar_tmp_pcg_trans.f_street_type_get ('gar_tmp', 41) 
--       SELECT * FROM gar_tmp_pcg_trans.f_street_type_get ('gar_tmp', 9941) 
--  SELECT * FROM  gar_tmp.adr_street_type ORDER BY id_area_type; 
