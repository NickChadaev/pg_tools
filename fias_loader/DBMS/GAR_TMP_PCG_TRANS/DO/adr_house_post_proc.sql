--   qty    id_house_type_1	nm_house_type	nm_house_type_short
--   249240 2               Дом	д.
--   8707   5               Строение	стр.
--   2924   1               Владение	вл.
--   2890   8               Здание	зд.
--   2198   3               Домовладение	дв.
--   294    9               Гараж	г-ж
--   170    6               Сооружение	соор.
--   104    NULL           NULL	NULL
--   7      1005           NULL	NULL
--   5      4	           Корпус	корп.

BEGIN;
 --     
 --  1) Создать в adr_house_aux   UPDATE
 --
 WITH a0 AS (
             SELECT h.id_house AS id_obj FROM gar_tmp.adr_house h WHERE (h.id_house_type_1 > 1000)
                UNION ALL
             SELECT h.id_house AS id_obj FROM gar_tmp.adr_house h WHERE (h.id_house_type_2 > 1000)
                UNION ALL
             SELECT h.id_house AS id_obj FROM gar_tmp.adr_house h WHERE (h.id_house_type_3 > 1000)
      )
      ,a1 AS (
              INSERT INTO gar_tmp.adr_house_aux (id_house, op_sign)
               SELECT a0.id_obj, 'U' FROM a0 
                 ON CONFLICT (id_house) DO UPDATE SET op_sign = 'U'
                    WHERE (gar_tmp.adr_house_aux.id_house = excluded.id_house)                  
              RETURNING * 
             )  
       SELECT a1.* FROM a1 ORDER BY 1;
 --
 -- 2) Вытащить и обновить TYPE_1  
 --
 WITH ax1 AS (    
              SELECT h.id_house
                ,h.id_area
                ,upper(h.nm_house_full::text) AS nm_house_full
                ,h.id_street
                ,h.id_house_type_1                
                 --                
                ,a.house_type_id
                ,(gar_tmp_pcg_trans.f_xxx_replace_char (a.type_name)) AS fias_row_key
                
              FROM gar_tmp.adr_house h 
                        LEFT JOIN gar_fias.as_house_type a ON ((h.id_house_type_1 - 1000) = a.house_type_id)  
              WHERE (h.id_house_type_1 > 1000)
  )
   , az1 AS (SELECT ax1.id_house, x.id_house_type FROM ax1
              LEFT JOIN gar_tmp.adr_house_type x 
                  ON (ax1.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char(x.nm_house_type))
              WHERE (NOT EXISTS (SELECT 1 FROM gar_tmp.adr_house 
                                  WHERE ((id_area = ax1.id_area) AND 
                                         (upper(nm_house_full) = ax1.nm_house_full) AND
                                         (id_street IS NOT DISTINCT FROM ax1.id_street) AND 
                                         (id_house_type_1 IS NOT DISTINCT FROM x.id_house_type)
                                        )
                                )
                     )
            )
   , ay1 AS (UPDATE gar_tmp.adr_house SET id_house_type_1 = az1.id_house_type
                FROM az1 WHERE (gar_tmp.adr_house.id_house = az1.id_house)
             RETURNING * 
     )  
       SELECT * FROM ay1 ORDER BY 1;
 --
 -- 3) Вытащить и обновить TYPE_2  
 --
 WITH ax2 AS (    
              SELECT h.id_house
                ,h.nm_house_full
                ,a.house_type_id
                ,(gar_tmp_pcg_trans.f_xxx_replace_char (a.type_name)) AS fias_row_key
              FROM gar_tmp.adr_house h 
                        LEFT JOIN gar_fias.as_house_type a ON ((h.id_house_type_2 - 1000) = a.house_type_id)  
              WHERE (h.id_house_type_2 > 1000)
  )
   , az2 AS (SELECT ax2.id_house, x.id_house_type FROM ax2
              LEFT JOIN gar_tmp.adr_house_type x 
                  ON (ax2.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char(x.nm_house_type))
     )
   , ay2 AS (UPDATE gar_tmp.adr_house SET id_house_type_2 = az2.id_house_type
                FROM az2 WHERE (gar_tmp.adr_house.id_house = az2.id_house)
             RETURNING * 
     )  
     SELECT * FROM ay2 ORDER BY 1;   
 --
 -- 4) Вытащить и обновить TYPE_3  
 --
 WITH ax3 AS (    
              SELECT h.id_house
                ,h.nm_house_full
                ,a.house_type_id
                ,(gar_tmp_pcg_trans.f_xxx_replace_char (a.type_name)) AS fias_row_key
              FROM gar_tmp.adr_house h 
                        LEFT JOIN gar_fias.as_house_type a ON ((h.id_house_type_3 - 1000) = a.house_type_id)  
              WHERE (h.id_house_type_3 > 1000)
  )
   , az3 AS (SELECT ax3.id_house, x.id_house_type FROM ax3
              LEFT JOIN gar_tmp.adr_house_type x 
                  ON (ax3.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char(x.nm_house_type))
     )
   , ay3 AS (UPDATE gar_tmp.adr_house SET id_house_type_3 = az3.id_house_type
                FROM az3 WHERE (gar_tmp.adr_house.id_house = az3.id_house)
             RETURNING * 
     )  
     SELECT * FROM ay3 ORDER BY 1;   
 --
 -- 5) Что осталось
 --
   WITH z0 AS (
                DELETE FROM gar_tmp.adr_house h WHERE (h.id_house_type_1 > 1000)
                RETURNING *
   )             
     SELECT * FROM z0;
   
--  WITH z0 AS (
--               SELECT h.id_house
--                 ,h.id_area
--                 ,upper(h.nm_house_full::text) AS nm_house_full
--                 ,h.id_street
--                 ,h.id_house_type_1                
--                  --                
--                 ,a.house_type_id
--                 ,(gar_tmp_pcg_trans.f_xxx_replace_char (a.type_name)) AS fias_row_key
--                 
--               FROM gar_tmp.adr_house h 
--                         LEFT JOIN gar_fias.as_house_type a ON ((h.id_house_type_1 - 1000) = a.house_type_id)  
--               WHERE (h.id_house_type_1 > 1000)      
--       )
--      ,z1 AS (SELECT h1.id_house
--                    ,h1.id_area
--                    ,upper(h1.nm_house_full::text) AS nm_house_full
--                    ,h1.id_street
--                    ,h1.id_house_type_1                
--            FROM gar_tmp.adr_house h1
--               LEFT JOIN gar_tmp.adr_house_type x 
--                   ON (z0.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char(x.nm_house_type))
--             )                      
--              SELECT * FROM z0;
-- ROLLBACK;
COMMIT;
