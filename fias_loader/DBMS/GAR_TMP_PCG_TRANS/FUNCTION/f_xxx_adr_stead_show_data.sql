DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_stead_show_data (date, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_stead_show_data (
       p_date           date   = current_date
      ,p_parent_obj_id  bigint = NULL
)
    RETURNS SETOF gar_tmp.xxx_adr_stead
    STABLE
    LANGUAGE sql
 AS
  $$
    -- ---------------------------------------------------------------------------------------
    --  2023-10-16 Nick Функция для формирования таблицы-прототипа "gar_tmp.xxx_adr_steads"
    -- ---------------------------------------------------------------------------------------
    --   p_date          date   -- Дата на которую формируется выборка    
    --   p_parent_obj_id bigint -- Идентификатор родительского объекта, если NULL то все дома
    -- ---------------------------------------------------------------------------------------
    
WITH aa (
             id_stead             
            ,id_addr_parent       
            ,fias_guid            
            ,parent_fias_guid 
            --
            ,nm_parent_obj        
            ,region_code 
            
            ,parent_type_id       
            ,parent_type_name     
            ,parent_type_shortname
            --
            ,parent_level_id      
            ,parent_level_name    
        --    ,parent_short_name        
            ,stead_num 
            --
            ,change_id
            ,oper_type_id         
            ,oper_type_name  
            ,rn
            
 ) AS (
        SELECT
           s.object_id
          ,NULLIF (ia.parent_obj_id, 0)
          --
          ,s.object_guid
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
     --     ,z.short_name
          --          
          ,s.steads_number
          --
          ,s.change_id
          --
          ,s.oper_type_id
          ,ot.oper_type_name
          --
          ,max(s.change_id) OVER (PARTITION BY ia.parent_obj_id, upper(s.steads_number)) AS rn
          
        FROM gar_fias.as_steads s
          --
          INNER JOIN gar_fias.as_adm_hierarchy ia ON (ia.object_id = s.object_id) AND (ia.is_active) 
          INNER JOIN gar_fias.as_addr_obj       y ON (y.object_id = ia.parent_obj_id) AND (y.end_date > p_date) 
          -- 
          LEFT OUTER JOIN gar_fias.as_object_level  z ON (z.level_id = y.obj_level) AND (z.is_active) 
          LEFT OUTER JOIN gar_fias.as_addr_obj_type x ON (x.id = y.type_id)
          --
          LEFT OUTER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = s.oper_type_id) AND (ot.is_active)

       WHERE (s.is_actual AND s.is_active) 
 )
   SELECT  DISTINCT ON (aa.id_stead)
   
             aa.id_stead             
            ,aa.id_addr_parent       
            ,aa.fias_guid            
            ,aa.parent_fias_guid     
            ,aa.nm_parent_obj        
            ,aa.region_code          
            ,aa.parent_type_id       
            ,aa.parent_type_name     
            ,aa.parent_type_shortname
            ,aa.parent_level_id      
            ,aa.parent_level_name    
         --   ,aa.parent_short_name        
            ,aa.stead_num            
            ,aa.oper_type_id         
            ,aa.oper_type_name       
   
   FROM aa 
        WHERE (((aa.id_addr_parent = p_parent_obj_id) AND (p_parent_obj_id IS NOT NULL))
                                OR
                          (p_parent_obj_id IS NULL)
              ) AND (aa.rn = aa.change_id) 
              
        ORDER BY aa.id_stead; -- 2023-10-11 aa.id_addr_parent, 
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_stead_show_data (date, bigint) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_stead_show_data (date, bigint) 
IS 'Функция для формирования таблицы-прототипа "gar_tmp.xxx_adr_stead"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_stead_show_data (); -- 295 157 rows
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_stead_show_data (p_parent_obj_id := 1260);

