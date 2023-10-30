--
--   2023-10-27 Продолжаю rebuild
--
-- 1)

"8b87e6c4-617a-4d32-9414-fada8d0d3e8b"	"bb301a7c-c4f5-4c00-a564-b4854377bfbb"	"БУДЕННОВСКАЯ"	204	15

SELECT a.* FROM gar_fias.as_addr_obj a WHERE (a.object_guid = '8b87e6c4-617a-4d32-9414-fada8d0d3e8b'); -- 82811
SELECT a.* FROM gar_fias.as_addr_obj a WHERE (a.object_guid = 'bb301a7c-c4f5-4c00-a564-b4854377bfbb'); -- 82471

select n.* from gar_fias.as_adm_hierarchy n where n.parent_obj_id = 82811
     UNION ALL
select n.* from gar_fias.as_adm_hierarchy n where n.parent_obj_id = 82471

                            
EXPLAIN ANALYZE
SELECT a.* FROM gar_fias.as_addr_obj a 
                            WHERE (a.object_guid = '21ab76d1-fab6-4b4f-a4dc-4871a93b7aab') AND
                                  (a.is_actual) AND (a.is_active) AND 
                                  (a.end_date > CURRENT_DATE) AND (a.start_date <= CURRENT_DATE);
---
EXPLAIN ANALYZE
SELECT a.* FROM gar_fias.as_addr_obj a 
                            WHERE (a.object_guid = '21ab76d1-fab6-4b4f-a4dc-4871a93b7aab') ; -- 81637

SELECT * FROM gar_fias_pcg_load."_NEW_f_adr_area_show_data" ('d2f48256-c10a-4806-b281-9b5b85d56616'::uuid) --??????  Непонятно !!!!!!!
                            WHERE (level_d > 1) 
SELECT a.* FROM gar_fias.as_addr_obj a 
                            WHERE (a.object_guid = 'd2f48256-c10a-4806-b281-9b5b85d56616') ;       -- 81317                     

          -- 0) Заменяю старого родителя на нового
          chld_qty_tot := gar_fias_pcg_load.f_addr_obj_update_parent (
                            _rec_one.fias_guid_old, _rec_one.fias_guid_new, p_date_2
          );
          
          -- 1) Старого родителя убрать: is actual, is_active <---- FALSE.
          UPDATE gar_fias.as_addr_obj SET is_actual = FALSE, is_active = FALSE
           WHERE (object_guid = _rec_one.fias_guid_old);     -- 81317
           -- Дата конечная уменьшается.
         
-- Что происходит здесь ????

select n.*
--, a.* 
from gar_fias.as_adm_hierarchy n
 --  join gar_fias.as_addr_obj a ON (a.object_id = n.object_id) -- 100932902

where n.parent_obj_id = 81637  -- Новый                           100932902

select * FROM gar_fias.as_addr_obj a where (a.object_id = 100932902);


select * from gar_fias.as_adm_hierarchy where parent_obj_id = 81317  -- Старый  100933314
                                                                                104321781
select * FROM gar_fias.as_addr_obj a where (a.object_id in (100932902, 100933314, 104321781)); --нет
select * FROM gar_fias.as_houses a where (a.object_id in (100932902, 100933314, 104321781)); -- Дома
--  у них сменится родитель  !!!!!!!!
                                                                                
      WITH z (
                 id_addr_obj
      )
       AS (
--             SELECT id_addr_obj
--                  FROM gar_fias_pcg_load.f_adr_area_show_data (p_parent_fias_guid_old::uuid)
--                             WHERE (level_d > 1) 

              SELECT x.object_id FROM gar_fias.as_addr_obj x 
                            WHERE (x.object_guid = p_parent_fias_guid_old)

          )
          UPDATE gar_fias.as_adm_hierarchy n SET parent_obj_id = _id_parent_new 
                FROM z
                    WHERE (z.id_addr_obj = n.object_id) AND (n.is_active);

--
SELECT (current_date - interval '1 year');
--