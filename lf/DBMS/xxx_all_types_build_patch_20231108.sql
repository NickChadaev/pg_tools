-- ---------------------------------------------------------------------
--  2023-11-08  Расширение массива "fias_ids" для тех случаев, когда
--              в ФИАС адресный объект становится элементом дорожно-
--              транспортной-структуры и наоборот элемент дорожно-
--              транспортной структуры попадает на уровень адресных
--              объектов.  В ФИАС и не такое бывает.
-- ---------------------------------------------------------------------
--  Базы: unsi_test_05, unsi_test_23, unsi_test_50

 BEGIN;
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
        UPDATE gar_tmp.xxx_adr_area_type AS a
            SET fias_ids = x.fias_ids
               ,is_twin  = TRUE
        FROM x
        WHERE (a.fias_row_key = x.fias_row_key);

 SELECT * FROM gar_tmp.xxx_adr_area_type ORDER BY id_area_type; -- WHERE (is_twin);
 --- ROLLBACK;
 COMMIT;  
--
 BEGIN;
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
                 UPDATE gar_tmp.xxx_adr_street_type AS s
                     SET fias_ids = x.fias_ids
                        ,is_twin  = TRUE
                 FROM x
                 WHERE (s.fias_row_key = x.fias_row_key);              -- 46
                 
 SELECT * FROM gar_tmp.xxx_adr_street_type ORDER BY id_street_type; 
 -- ROLLBACK;  
 COMMIT;  
