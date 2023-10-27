DROP FUNCTION IF EXISTS gar_fias_pcg_load."_NEW_f_adr_area_show_data" (uuid, date, bigint);
DROP FUNCTION IF EXISTS gar_fias_pcg_load."_NEW_f_adr_area_show_data" (uuid, date, bigint,integer);
CREATE OR REPLACE FUNCTION gar_fias_pcg_load."_NEW_f_adr_area_show_data" (
       p_fias_guid     uuid     
      ,p_date          date     = current_date
      ,p_obj_level     bigint   = 16
      ,p_qty           integer  = 0
)
    RETURNS SETOF gar_fias.gap_adr_area_t
    STABLE
    LANGUAGE sql
 AS
  $$
    -- ---------------------------------------------------------------------------------------
    --  2022-08-29 Nick  Отображение исходных данных в формате "gar_fias.gap_adr_area_t"
    --  2022-12-29 Убрана проверка -- (gar_fias.as_addr_obj_type.is_active) 
    --                  В ФИАС полно противоречий, эта проверка углубляет их.    
    
        --  2023-10-02  - Исправлены ошибки в рекурсивной части запроса и в оконной функции.
    --      Выключена фильтрация по периоду актуальности. Убрана на фиг фильтрация по типам 
    --      операций. Уровень адресных объектов уменьшен до 14 (обратный отсчёт).
    
    --  2023-10-06 "as_addr_obj" может содержать неактивные записи с валидным диапазоном акту-
    --             альности, потомки у этих записей могут быть активными. Например активными
    --             дома, но не активна улица их содержащая.
    --
    --  2023-10-11 Пришлось ввести " SELECT DISTINCT ON (bb1.id_addr_obj) Иначе подряд 
    --   выполняются два действия: INSERT и UNPDATE ON CONLICT, что вызывает ошибку postgres.
    --   Ошибка проявилась на 50 регионе (Московская обл).
    --
    --  2023-10-20 Окно определяется строго по ID типа, а не по его имени.
    -- ---------------------------------------------------------------------------------------
    WITH RECURSIVE aa1 (
                         id_addr_obj       
                        ,id_addr_parent 
                        --
                        ,fias_guid        
                        ,parent_fias_guid 
                        --   
                        ,nm_addr_obj   
                        ,addr_obj_type_id  
                        ,addr_obj_type   
                        --
                        ,obj_level
                        ,level_name
                        --
                        ,region_code  
                        ,area_code    
                        ,city_code    
                        ,place_code   
                        ,plan_code    
                        ,street_code    
                        --
                        ,change_id
                        ,prev_id
                        --
                        ,oper_type_id
                        ,oper_type_name               
                        --
                        ,start_date 
                        ,end_date    
                        --
                        ,id_lead           		   
                        ,tree_d           
                        ,level_d                                      
                        ,cicle_d  
                        
                        
                        
     ) AS (
            SELECT
               a.object_id
              ,NULLIF (h1.parent_obj_id, 0)
              --
              ,a.object_guid
              ,z.object_guid
              --
              ,a.object_name
              ,a.type_id
              ,a.type_name
              --
              ,a.obj_level
              ,l.level_name
               --
              ,h1.region_code  -- 2021-12-01
              ,h1.area_code    
              ,h1.city_code    
              ,h1.place_code   
              ,h1.plan_code    
              ,h1.street_code    
               --             --
              ,a.change_id
              ,a.prev_id
               --             --
              ,a.oper_type_id
              ,ot.oper_type_name
              --
              ,a.start_date 
              ,a.end_date              
               --
              ,NULL AS id_lead              
              ,CAST (ARRAY [a.object_id] AS bigint []) 
              ,1
              ,FALSE
              
            FROM gar_fias.as_adm_hierarchy h1
                 	            
              INNER JOIN gar_fias.as_addr_obj     a ON (h1.object_id = a.object_id) AND (a.end_date > p_date)                   	            
              INNER JOIN gar_fias.as_object_level l ON (a.obj_level = l.level_id) AND (l.is_active) 
              INNER JOIN gar_fias.as_operation_type ot  
                           ON (ot.oper_type_id = a.oper_type_id) AND (ot.is_active)   

              LEFT JOIN gar_fias.as_addr_obj z ON (h1.parent_obj_id = z.object_id) AND (z.end_date > p_date)  
                                                 
            WHERE ((((h1.parent_obj_id = 0) OR (h1.parent_obj_id IS NULL)) AND (p_fias_guid IS NULL))
                         OR
                   ((a.object_guid = p_fias_guid) AND (p_fias_guid IS NOT NULL))
                  )
                    AND (h1.is_active) 
         
                     UNION ALL
        
            SELECT
               a.object_id
              ,h2.parent_obj_id
              --
              ,a.object_guid
              ,z.object_guid
              --
              ,a.object_name
              ,a.type_id          
              ,a.type_name
              --
              ,a.obj_level
              ,l.level_name
               --
              ,h2.region_code  -- 2021-12-01
              ,h2.area_code    
              ,h2.city_code    
              ,h2.place_code   
              ,h2.plan_code    
              ,h2.street_code    
               --             --
              ,a.change_id
              ,a.prev_id
               --             --
              ,a.oper_type_id
              ,ot.oper_type_name
              --
              ,a.start_date 
              ,a.end_date              
              --	       
              ,NULL AS id_lead
                        
              ,CAST (aa1.tree_d || a.object_id AS bigint [])
              ,(aa1.level_d + 1) t
              ,a.object_id = ANY (aa1.tree_d)   
            
            FROM gar_fias.as_adm_hierarchy h2
                 	
              INNER JOIN aa1 ON (h2.parent_obj_id = aa1.id_addr_obj ) 
                       
              INNER JOIN gar_fias.as_addr_obj        a ON (h2.object_id = a.object_id) AND (a.end_date > p_date)                         
             -- INNER JOIN gar_fias.as_addr_obj        z ON (h2.parent_obj_id = z.object_id) AND (z.end_date > p_date)  
              INNER JOIN gar_fias.as_object_level    l ON (a.obj_level = l.level_id) AND (l.is_active) 
              INNER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = a.oper_type_id) AND (ot.is_active) 

              LEFT JOIN gar_fias.as_addr_obj z ON (h2.parent_obj_id = z.object_id) AND (z.end_date > p_date)                
              
            WHERE (h2.is_active)        
      )
      , bb1 (   
                id_addr_obj       
               ,id_addr_parent 
               --
               ,fias_guid        
               ,parent_fias_guid 
               --   
               ,nm_addr_obj   
               ,addr_obj_type_id  
               ,addr_obj_type   
               --
               ,obj_level
               ,level_name
               --
               ,region_code  -- 2021-12-01
               ,area_code    
               ,city_code    
               ,place_code   
               ,plan_code    
               ,street_code    
               --
               ,change_id
               ,prev_id
               --
               ,oper_type_id
               ,oper_type_name               
               --
               ,start_date 
               ,end_date    
               --
               ,id_lead
               ,qty
               --
               ,tree_d            
               ,level_d
      )
       AS (
            SELECT  
                    aa1.id_addr_obj       
                   ,aa1.id_addr_parent 
                   --
                   ,aa1.fias_guid        
                   ,aa1.parent_fias_guid 
                   --   
                   ,aa1.nm_addr_obj    
                   ,aa1.addr_obj_type_id   
                   ,aa1.addr_obj_type               
                   --
                   ,aa1.obj_level
                   ,aa1.level_name
                    --
                   ,aa1.region_code  -- 2021-12-01
                   ,aa1.area_code    
                   ,aa1.city_code    
                   ,aa1.place_code   
                   ,aa1.plan_code    
                   ,aa1.street_code    
                    --             --
                   ,aa1.change_id
                   ,aa1.prev_id
                   --             --
                   ,aa1.oper_type_id
                   ,aa1.oper_type_name		 
                    --
                   ,aa1.start_date 
                   ,aa1.end_date              
                    --               
                   ,max (aa1.id_addr_obj) 
                       OVER (PARTITION BY aa1.id_addr_parent -- 
                                         ,aa1.addr_obj_type_id  
                                         ,UPPER(aa1.nm_addr_obj) 
                    ) AS id_lead
                    --
                   ,count (aa1.id_addr_obj) 
                       OVER (PARTITION BY aa1.id_addr_parent -- 
                                         ,aa1.addr_obj_type_id  
                                         ,UPPER(aa1.nm_addr_obj) 
                    ) AS qty
                    
                   ,aa1.tree_d            
                   ,aa1.level_d
                  
            FROM aa1 WHERE (aa1.obj_level <= p_obj_level)
            
		   -- ORDER BY aa1.tree_d
          )
        , cc1 (   
                id_addr_obj       
               ,id_addr_parent 
               --
               ,fias_guid        
               ,parent_fias_guid 
               --   
               ,nm_addr_obj   
               ,addr_obj_type_id  
               ,addr_obj_type   
               --
               ,obj_level
               ,level_name
               --
               ,region_code  -- 2021-12-01
               ,area_code    
               ,city_code    
               ,place_code   
               ,plan_code    
               ,street_code    
               --
               ,change_id
               ,prev_id
               --
               ,oper_type_id
               ,oper_type_name               
               --
               ,start_date 
               ,end_date    
               --
               ,id_lead
               ,tree_d            
               ,level_d
      )
       AS (
          SELECT DISTINCT ON (bb1.id_addr_obj) -- 2023-10-11
                    bb1.id_addr_obj       
                   ,bb1.id_addr_parent 
                   --
                   ,bb1.fias_guid        
                   ,bb1.parent_fias_guid 
                   --   
                   ,bb1.nm_addr_obj    
                   ,COALESCE (bb1.addr_obj_type_id,
                     (
                       WITH z (
                                 type_id
                                ,type_level
                                ,is_active
                                ,fias_row_key
                       )
                         AS (
                             SELECT   t.id
                                     ,t.type_level
                                     ,t.is_active
                                     ,gar_tmp_pcg_trans.f_xxx_replace_char (t.type_name)
                             FROM gar_fias.as_addr_obj_type t 
                               WHERE (t.type_shortname = bb1.addr_obj_type) AND 
                                     (t.type_level::bigint = bb1.obj_level)            
                             )
                       , v (type_id)
                         AS (
                             SELECT r.id FROM gar_fias.as_addr_obj_type r, z 
                              WHERE (gar_tmp_pcg_trans.f_xxx_replace_char (r.type_name)
                                       = 
                                     z.fias_row_key
                                    ) 
                                           AND 
                                    (r.type_level = z.type_level) AND (r.is_active) -- 2022-12-29 
                           )  
                             SELECT 
                                 CASE 
                                   WHEN NOT z.is_active THEN (SELECT v.type_id FROM v)
                                      ELSE 
                                           z.type_id
                                 END AS type_id
                             FROM z
                      )
                    ) AS addr_obj_type_id
                   ,bb1.addr_obj_type               
                   --
                   ,bb1.obj_level
                   ,bb1.level_name
                    --
                   ,bb1.region_code  -- 2021-12-01
                   ,bb1.area_code    
                   ,bb1.city_code    
                   ,bb1.place_code   
                   ,bb1.plan_code    
                   ,bb1.street_code    
                    --
                   ,bb1.change_id
                   ,bb1.prev_id
                      --           --
                   ,bb1.oper_type_id
                   ,bb1.oper_type_name		 
                    --
                   ,bb1.start_date 
                   ,bb1.end_date              
                    --            
                   ,bb1.id_lead                    
                   ,bb1.tree_d            
                   ,bb1.level_d      
                   
           FROM bb1 WHERE (bb1.qty > p_qty)
         )
           SELECT * FROM cc1  
             ORDER BY cc1.id_addr_parent, cc1.addr_obj_type, cc1.nm_addr_obj;
  $$;
 
ALTER FUNCTION gar_fias_pcg_load."_NEW_f_adr_area_show_data" (uuid, date, bigint, integer) OWNER TO postgres;  

COMMENT ON FUNCTION gar_fias_pcg_load."_NEW_f_adr_area_show_data" (uuid, date, bigint, integer) 
IS 'Отображение исходных данных в формате "gar_fias.gap_adr_area_t"';
----------------------------------------------------------------------------------
-- USE CASE:
-- SELECT * FROM gar_fias_pcg_load."_NEW_f_adr_area_show_data" (p_fias_guid := '8b87e6c4-617a-4d32-9414-fada8d0d3e8b'::uuid); --  
-- SELECT * FROM gar_fias_pcg_load."_NEW_f_adr_area_show_data" (p_fias_guid := 'b81b942b-ccca-4559-9365-d03af2a03d88'::uuid);  
-- SELECT * FROM gar_fias_pcg_load."_NEW_f_adr_area_show_data" (p_fias_guid := NULL::uuid)-- 26543 строки получено.
-- SELECT * FROM gar_fias_pcg_load."_NEW_f_adr_area_show_data" (p_fias_guid := NULL::uuid, p_qty := 1) -- 13
-- SELECT * FROM gar_fias_pcg_load."_NEW_f_adr_area_show_data" (p_fias_guid := '21ab76d1-fab6-4b4f-a4dc-4871a93b7aab'::uuid) -- 1 -- 81637
-- SELECT * FROM gar_fias_pcg_load."_NEW_f_adr_area_show_data" (p_fias_guid := 'd2f48256-c10a-4806-b281-9b5b85d56616'::uuid) -- 1 -- 81317
-- SELECT * FROM gar_fias_pcg_load."_NEW_f_adr_area_show_data" (p_fias_guid := '1bde5cf4-7943-4b17-9718-2c1d96742be5'::uuid) order by nm_addr_obj-- 1
-- 
--   SELECT * FROM gar_fias_pcg_load.f_xxx_adr_area_show_data (); -- 69598

-- SELECT * FROM unnsi.adr_area WHERE (nm_fias_guid = 'b0aa0895-e596-4a25-a0aa-0c69c83f0f9e'::uuid);
-- SELECT * FROM unnsi.adr_area WHERE(id_area_parent = 104565);  - нет 8-ми записей
-- SELECT * FROM unnsi.adr_area WHERE (nm_fias_guid = '80a6adb4-a120-4f45-9a50-646ee565d37a');
