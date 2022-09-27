DROP FUNCTION IF EXISTS gar_tmp.f_xxx_adr_house_show_data (date, bigint);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_house_show_data (date, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_house_show_data (
       p_date           date   = current_date
      ,p_parent_obj_id  bigint = NULL
)
    RETURNS SETOF gar_tmp.xxx_adr_house
    STABLE
    LANGUAGE sql
 AS
  $$
    -- ---------------------------------------------------------------------------------------
    --  2021-10-20 Nick Функция для формирования таблицы-прототипа "gar_tmp.xxx_adr_house"
    --  2021-12-09/2021-12-20 Ревизия функции. 
    --  2022-09-26 
    --   Тип дома принимается всегда, диапазон актуальности и признак активности - игнорируются.
    -- ---------------------------------------------------------------------------------------
    --   p_date          date   -- Дата на которую формируется выборка    
    --   p_parent_obj_id bigint -- Идентификатор родительского объекта, если NULL то все дома
    -- ---------------------------------------------------------------------------------------
    
WITH aa (
             id_house       
            ,id_addr_parent 
            --
            ,fias_guid        
            ,parent_fias_guid 
            --   
            ,nm_parent_obj  
            ,region_code
            --
            ,parent_type_id
            ,parent_type_name
            ,parent_type_shortname
            --
            ,parent_level_id
            ,parent_level_name
            ,parent_short_name	        
            --
            ,house_num
            ,add_num1
            ,add_num2
            --
            ,house_type 
            ,house_type_name
            ,house_type_shortname
            --
            ,add_type1
            ,add_type1_name
            ,add_type1_shortname
            --
            ,add_type2
            ,add_type2_name     
            ,add_type2_shortname
            --
            ,change_id
            --
            ,oper_type_id
            ,oper_type_name     
            --
            ,user_id
            ,rn
            
 ) AS (
        SELECT
           h.object_id
          ,NULLIF (ia.parent_obj_id, 0)
          --
          ,h.object_guid
          ,y.object_guid
          --
          ,y.object_name     -- e.g.  parent_name
          ,ia.region_code
           --
          ,x.id
          ,x.type_name
          ,x.type_shortname
          --
          ,z.level_id
          ,z.level_name
          ,z.short_name
          --          
          ,h.house_num 
          ,h.add_num1
          ,h.add_num2
          --
          ,h.house_type
          ,t.type_name
          ,t.type_shortname
          --
          ,h.add_type1
          ,a1.type_name
          ,a1.type_shortname
          --
          ,h.add_type2
          ,a2.type_name
          ,a2.type_shortname
          --
          ,h.change_id
          --
          ,h.oper_type_id
          ,ot.oper_type_name
          --
          ,session_user
          --
          ,row_number() OVER (PARTITION BY ia.parent_obj_id, h.house_type, h.add_type1, h.add_type2
                                         , upper(h.house_num), upper(h.add_num1), upper(h.add_num2) 
                                         ORDER BY h.change_id DESC
                             ) AS rn
          
        FROM gar_fias.as_houses h
          INNER JOIN gar_fias.as_reestr_objects r ON ((r.object_id = h.object_id) AND (r.is_active))
          --
          INNER JOIN gar_fias.as_house_type t ON ((t.house_type_id = h.house_type) 
                                                   --  AND (t.is_active)
                                                   --  AND (t.end_date > p_date) AND (t.start_date <= p_date)
                                                 )
          --    Проверить      -- LEFT OUTER                             
          INNER JOIN gar_fias.as_adm_hierarchy ia ON ((ia.object_id = r.object_id) AND (ia.is_active) 
                                                           AND (ia.end_date > p_date) AND (ia.start_date <= p_date)
                                                     )
	      --  LEFT OUTER
          INNER JOIN gar_fias.as_addr_obj y ON (y.object_id = ia.parent_obj_id)  
                              AND ((y.is_actual AND y.is_active) AND (y.end_date > p_date) AND (y.start_date <= p_date)
                              )
          LEFT OUTER  JOIN gar_fias.as_object_level z ON (z.level_id = y.obj_level) AND (z.is_active) 
                                                     AND ((z.end_date > p_date) AND (z.start_date <= p_date)
                                                     )
          LEFT OUTER JOIN gar_fias.as_addr_obj_type x ON (x.id = y.type_id) AND (x.is_active)
                                                      AND ((x.end_date > p_date) AND (x.start_date <= p_date)
                                                      )
          LEFT OUTER JOIN gar_fias.as_add_house_type a1 ON (a1.add_type_id = h.add_type1) 
                                                      -- AND (a1.is_active)
                                                      -- AND ((a1.end_date > p_date) AND (a1.start_date <= p_date)
                                                      --)
          LEFT OUTER JOIN gar_fias.as_add_house_type a2 ON (a2.add_type_id = h.add_type2)  
                                                      -- AND (a2.is_active)
                                                      -- AND ((a2.end_date > p_date) AND (a2.start_date <= p_date)
                                                      --)
          --
          LEFT OUTER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = h.oper_type_id) AND (ot.is_active)
                                                      AND ((ot.end_date > p_date) AND (ot.start_date <= p_date)
                                                      ) 
       WHERE ((h.is_actual AND h.is_active) AND (h.end_date > p_date) AND (h.start_date <= p_date)
                ) 
 )
   SELECT 
             aa.id_house       
            ,aa.id_addr_parent 
            --
            ,aa.fias_guid        
            ,aa.parent_fias_guid 
            --   
            ,aa.nm_parent_obj  
            ,aa.region_code
            --
            ,aa.parent_type_id
            ,aa.parent_type_name
            ,aa.parent_type_shortname
            --
            ,aa.parent_level_id
            ,aa.parent_level_name
            ,aa.parent_short_name	        
            --
            ,aa.house_num
            ,aa.add_num1
            ,aa.add_num2
            --
            ,aa.house_type 
            ,aa.house_type_name
            ,aa.house_type_shortname
            --
            ,aa.add_type1
            ,aa.add_type1_name
            ,aa.add_type1_shortname
            --
            ,aa.add_type2
            ,aa.add_type2_name     
            ,aa.add_type2_shortname
            --
            ,aa.oper_type_id
            ,aa.oper_type_name     
            --
            ,aa.user_id
   
   FROM aa 
        WHERE (((aa.id_addr_parent = p_parent_obj_id) AND (p_parent_obj_id IS NOT NULL))
                                OR
                          (p_parent_obj_id IS NULL)
              ) AND (aa.rn = 1) 
        ORDER BY aa.id_addr_parent, aa.id_house; 
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_house_show_data (date, bigint) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_house_show_data (date, bigint) 
IS 'Функция для формирования таблицы-прототипа "gar_tmp.xxx_adr_house"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_house_show_data (); -- 2 sec 96'167 rows
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_house_show_data (p_parent_obj_id := 1260);
