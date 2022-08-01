DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_area_show_data (date, bigint, bigint[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_show_data (
       p_date          date     = current_date
      ,p_obj_level     bigint   = 10
      ,p_oper_type_ids bigint[] = NULL::bigint[]
)
    RETURNS SETOF gar_tmp.xxx_adr_area
    STABLE
    LANGUAGE sql
 AS
  $$
    -- ---------------------------------------------------------------------------------------
    --  2021-10-19/2021-11-19 Nick 
    --    Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_adr_area"
    --  2021-12-20 - Могут быть несколько активных записей с различными UUID, описывающих
    --  один и тот-же адресный объект. Выбираю самую свежую (по максимальнлому ID изменения).
    -- ---------------------------------------------------------------------------------------
    --   p_date      date         -- Дата на которую формируется выборка    
    --   p_obj_level bigint       -- Предельный уровень адресных объектов в иерархии.
    --   p_oper_type_ids bigint[] -- Необходимые типы операций  
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
                        ,tree_d            
                        ,level_d
                        ,cicle_d  
     ) AS (
        SELECT
           a.object_id
          ,NULLIF (ia.parent_obj_id, 0)
          --
          ,a.object_guid
          ,NULL::uuid
          --
          ,a.object_name
          ,a.type_id
          ,a.type_name
          --
          ,a.obj_level
          ,l.level_name
           --
          ,ia.region_code  -- 2021-12-01
          ,ia.area_code    
          ,ia.city_code    
          ,ia.place_code   
          ,ia.plan_code    
          ,ia.street_code    
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
          ,CAST (ARRAY [a.object_id] AS bigint []) 
          ,1
          ,FALSE
          
        FROM gar_fias.as_adm_hierarchy ia
        
          INNER JOIN gar_fias.as_addr_obj a 
                       ON (ia.object_id = a.object_id) AND
                          ((a.is_actual AND a.is_active) AND (a.end_date > p_date) AND
                               (a.start_date <= p_date)
                          )
          --                
          INNER JOIN gar_fias.as_object_level l 
                       ON (a.obj_level = l.level_id) AND (l.is_active) AND
                          ((l.end_date > p_date) AND (l.start_date <= p_date))
          --
          INNER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = a.oper_type_id) AND 
                                          (ot.is_active) AND ((ot.end_date > p_date) AND 
                                          (ot.start_date <= p_date))                            
        
        WHERE ((ia.parent_obj_id = 0) OR (ia.parent_obj_id IS NULL)) AND
              (ia.is_active) AND (ia.end_date > p_date) AND (ia.start_date <= p_date)

     
                 UNION ALL
    
        SELECT
           a.object_id
          ,ia.parent_obj_id
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
          ,ia.region_code  -- 2021-12-01
          ,ia.area_code    
          ,ia.city_code    
          ,ia.place_code   
          ,ia.plan_code    
          ,ia.street_code    
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
          ,CAST (aa1.tree_d || a.object_id AS bigint [])
          ,(aa1.level_d + 1) t
          ,a.object_id = ANY (aa1.tree_d)   
        
           FROM gar_fias.as_addr_obj a
              INNER JOIN gar_fias.as_adm_hierarchy ia ON ((ia.object_id = a.object_id) AND (ia.is_active) 
                                                           AND (ia.end_date > p_date) 
                                                           AND (ia.start_date <= p_date)
                                                         )
              INNER JOIN gar_fias.as_addr_obj z ON (ia.parent_obj_id = z.object_id)
                                          AND ((z.is_actual AND z.is_active) AND (z.end_date > p_date) 
                                                  AND (z.start_date <= p_date)
                                          )
              INNER JOIN gar_fias.as_object_level l ON (a.obj_level = l.level_id) AND (l.is_active) 
                                                         AND ((l.end_date > p_date) AND
                                                              (l.start_date <= p_date)
                                                         )
              INNER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = a.oper_type_id) AND 
                                          (ot.is_active) AND ((ot.end_date > p_date) AND 
                                          (ot.start_date <= p_date))
                                          
              INNER JOIN aa1 ON (aa1.id_addr_obj = ia.parent_obj_id) AND (NOT aa1.cicle_d)
          
        WHERE (a.obj_level <= p_obj_level) 
                AND ((a.is_actual AND a.is_active) AND (a.end_date > p_date) 
                        AND (a.start_date <= p_date)
                )
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
               ,tree_d            
               ,level_d
               --
               ,rn
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
                   ,aa1.tree_d            
                   ,aa1.level_d

                   ,row_number() OVER (PARTITION BY aa1.id_addr_parent
                                                   ,aa1.addr_obj_type_id  
								                   ,UPPER(aa1.nm_addr_obj) 
								       ORDER BY aa1.change_id DESC, aa1.prev_id DESC
                    ) AS rn
                  
            FROM aa1 
              WHERE ((aa1.oper_type_id = ANY (p_oper_type_ids)) AND (p_oper_type_ids IS NOT NULL))
                       OR
                    (p_oper_type_ids IS NULL)  ORDER BY aa1.tree_d
          )
           SELECT
                    bb1.id_addr_obj       
                   ,bb1.id_addr_parent 
                   --
                   ,bb1.fias_guid        
                   ,bb1.parent_fias_guid 
                   --   
                   ,bb1.nm_addr_obj    
                   ,bb1.addr_obj_type_id   
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
                    --             --
                   ,bb1.oper_type_id
                   ,bb1.oper_type_name		 
                    --
                   ,bb1.start_date 
                   ,bb1.end_date              
                    --               
                   ,bb1.tree_d            
                   ,bb1.level_d           
           FROM bb1 WHERE ( bb1.rn = 1);  -- LIMIT 10; -- 6033 -- 2021-10-19  -- 6093
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_show_data (date, bigint, bigint[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_show_data (date, bigint, bigint[]) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_adr_area"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_show_data (); -- 1184
-- CALL gar_tmp_pcg_trans.p_gar_fias_crt_idx ();
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_show_data (p_obj_level := 22); 
-- SELECT count (1) FROM gar_tmp_pcg_trans.as_addr_obj; --7345  --- 1312 ?
-- SELECT count (1) FROM gar_tmp_pcg_trans.as_addr_obj a WHERE (a.is_actual AND a.is_active); -- 6093  -- 60 ??
--
-- SELECT count (1) FROM gar_tmp_pcg_trans.as_addr_obj a WHERE (a.is_actual AND a.is_active)  -- 6093 ??
-- AND (a.end_date > p_date) 
--                         AND (a.start_date <= p_date);
-- ------------------------------------------------------------
-- ALTER TABLE gar_tmp.xxx_adr_area ADD COLUMN addr_obj_type_id bigint;
-- COMMENT ON COLUMN gar_tmp.xxx_adr_area.addr_obj_type_id IS
-- 'ID типа объекта';
