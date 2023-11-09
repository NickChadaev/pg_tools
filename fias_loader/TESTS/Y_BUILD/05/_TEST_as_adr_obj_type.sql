--
--  2023-11-09  -- 05
--
WITH z (
          qty
         ,fias_row_key
       )
     AS (    
           SELECT  count(1)
                ,  gar_tmp_pcg_trans.f_xxx_replace_char(type_name)  FROM gar_fias.as_addr_obj_type GROUP BY type_name  
         )
          SELECT z.fias_row_key, t.*  FROM z 
            INNER JOIN gar_fias.as_addr_obj_type t ON (gar_tmp_pcg_trans.f_xxx_replace_char(t.type_name) = z.fias_row_key)

          WHERE (z.qty > 1) ORDER BY z.fias_row_key  ;        
--
-- ========================================================================================================================
--
-- SELECT id, type_level, type_name, type_shortname, type_descr, update_date, start_date, end_date, is_active
-- FROM gar_fias.as_addr_obj_type;
--
-- ========================================================================================================================
--
WITH z (
          qty
         ,fias_row_key
       )
     AS (    
           SELECT  count(1)
                ,  gar_tmp_pcg_trans.f_xxx_replace_char(type_name)  FROM gar_fias.as_addr_obj_type GROUP BY type_name  
         )
          SELECT z.fias_row_key, array_agg(t.id) AS fias_ids FROM z 
            INNER JOIN gar_fias.as_addr_obj_type t ON (gar_tmp_pcg_trans.f_xxx_replace_char(t.type_name) = z.fias_row_key)

          WHERE (z.qty > 1) GROUP BY z.fias_row_key ORDER BY z.fias_row_key  ; 
--
-- ========================================================================================================================
--
EXPLAIN ANALYZE
WITH z (
          qty
         ,fias_row_key
       )
     AS (    
           SELECT  count(1)
                ,  gar_tmp_pcg_trans.f_xxx_replace_char(type_name)  
           FROM gar_fias.as_addr_obj_type GROUP BY type_name  
         )
      ,x (
            fias_row_key 
           ,fias_ids
         )  
      AS (    
           SELECT z.fias_row_key, array_agg(t.id) AS fias_ids FROM z 
             INNER JOIN gar_fias.as_addr_obj_type t ON (gar_tmp_pcg_trans.f_xxx_replace_char(t.type_name) = z.fias_row_key)
           WHERE (z.qty > 1) GROUP BY z.fias_row_key ORDER BY z.fias_row_key  
         )
        SELECT x.* 
               ,a.fias_ids, a.id_area_type, a.fias_type_name, a.nm_area_type, a.fias_type_shortname, a.nm_area_type_short, a.pr_lead, a.is_twin 
        FROM x       
              INNER JOIN gar_tmp.xxx_adr_area_type a ON (a.fias_row_key = x.fias_row_key); -- 90

------------------------------------------------------------------------------------------------------------------------------------ 
WITH z (
          qty
         ,fias_row_key
       )
     AS (    
           SELECT  count(1)
                ,  gar_tmp_pcg_trans.f_xxx_replace_char(type_name)  
           FROM gar_fias.as_addr_obj_type GROUP BY type_name  
         )
      ,x (
            fias_row_key 
           ,fias_ids
         )  
      AS (    
           SELECT z.fias_row_key, array_agg(t.id) AS fias_ids FROM z 
             INNER JOIN gar_fias.as_addr_obj_type t ON (gar_tmp_pcg_trans.f_xxx_replace_char(t.type_name) = z.fias_row_key)
           WHERE (z.qty > 1) GROUP BY z.fias_row_key ORDER BY z.fias_row_key  
         )
        SELECT x.* 
               ,s.fias_ids, s.id_street_type, s.fias_type_name, s.nm_street_type, s.fias_type_shortname, s.nm_street_type_short, s.is_twin 
        FROM x       
              INNER JOIN gar_tmp.xxx_adr_street_type s ON (s.fias_row_key = x.fias_row_key); -- 46

------------------------------------------------------------------------------------------------------------------------------------

SELECT fias_ids, id_area_type, fias_type_name, nm_area_type, fias_type_shortname, nm_area_type_short, pr_lead, fias_row_key, is_twin
FROM gar_tmp.xxx_adr_area_type; -- 142


SELECT fias_ids, id_street_type, fias_type_name, nm_street_type, fias_type_shortname, nm_street_type_short, fias_row_key, is_twin
FROM gar_tmp.xxx_adr_street_type;  -- 56

----------------------------------------------
SELECT id, object_id, object_guid, change_id, object_name, type_id, type_name, obj_level, oper_type_id, prev_id, next_id, update_date, start_date, end_date, is_actual, is_active
FROM gar_fias.as_addr_obj;


CREATE INDEX ie1_xxx_adr_area_type ON gar_tmp.xxx_adr_area_type USING GIN (fias_ids);
DROP INDEX gar_tmp.ie1_xxx_adr_area_type;

explain ANALYZE
SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (ARRAY[423]::bigint[] && fias_ids); 

explain ANALYZE
SELECT * FROM gar_tmp.xxx_adr_area_type WHERE (423::bigint = ANY (fias_ids));


SELECT fias_row_key FROM gar_tmp.xxx_adr_street_type 
  INTERSECT
SELECT fias_row_key FROM gar_tmp.xxx_adr_area_type 
 



   