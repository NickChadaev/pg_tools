DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_get_parents (uuid, date);
CREATE OR REPLACE FUNCTION gar_fias_pcg_load.f_addr_obj_get_parents (
       p_fias_guid     uuid     
      ,p_date          date     = current_date
)
    RETURNS 
       TABLE (
                 id_addr_obj        bigint    
                ,id_addr_parent     bigint
                --
                ,fias_guid          uuid
                ,parent_fias_guid   uuid
                --   
                ,nm_addr_obj        varchar(250)
                ,addr_obj_type_id   bigint
                ,addr_obj_type      varchar(50)
                --
                ,obj_level          bigint
                ,level_name         varchar(100)
                --
                ,region_code        varchar (4)
                --
                ,change_id          bigint
                ,prev_id            bigint
                --
                ,oper_type_id       bigint
                ,oper_type_name     varchar(100)          
                --
                ,start_date         date
                ,end_date           date
                --
                ,is_actual          boolean
                ,is_active          boolean 
                --
                ,tree_d             bigint[] 
                ,level_d            integer
       )
    STABLE
    LANGUAGE sql
 AS
  $$
    -- -------------------------------------------------------------------------------------
    --  2022-07-08 Nick 
    --    Функция подготавливает формирует список вышестоящих объектов. 
    --     Исходные данные для исправления проблем, связанных с существованием  несколько 
    --     активных записей с различными UUID, описывающих один и тот-же адресный объект. 
    --     Как следствие могут быть получены несколько отношений подчинённости.
    -- ---------------------------------------------------------------------------------------
    --   p_fias_guid    uuid         -- UUID проверяемого объекта.
    --   p_date         date         -- Дата на которую формируется выборка    
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
                         ,is_actual
                         ,is_active                   
                         --
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
                ,h1.region_code  
                 --              
                ,a.change_id
                ,a.prev_id
                 --              
                ,a.oper_type_id
                ,ot.oper_type_name
                --
                ,a.start_date 
                ,a.end_date     
                --
                ,a.is_actual
                ,a.is_active            
                --
                ,CAST (ARRAY [a.object_id] AS bigint []) 
                ,0
                ,FALSE
            
          FROM gar_fias.as_adm_hierarchy h1
          
            INNER JOIN gar_fias.as_addr_obj       a  ON (h1.object_id = a.object_id) AND (a.end_date > p_date)
            INNER JOIN gar_fias.as_object_level   l  ON (a.obj_level = l.level_id)   AND (l.is_active) 
            INNER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = a.oper_type_id) AND (ot.is_active) AND (ot.end_date > p_date) 
         
            LEFT  JOIN gar_fias.as_addr_obj z ON (h1.parent_obj_id = z.object_id) AND (z.end_date > p_date)
                                                                         
          WHERE (a.object_guid = p_fias_guid) AND (h1.is_active) 
       
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
                ,h2.region_code   
                 --             
                ,a.change_id
                ,a.prev_id
                 --              
                ,a.oper_type_id
                ,ot.oper_type_name
                --
                ,a.start_date 
                ,a.end_date  
                --
                ,a.is_actual
                ,a.is_active
                --	       
                ,CAST (aa1.tree_d || a.object_id AS bigint [])
                ,(aa1.level_d - 1) t
                ,a.object_id = ANY (aa1.tree_d)   
          
          FROM gar_fias.as_adm_hierarchy h2 
             
                INNER JOIN gar_fias.as_addr_obj        a ON (h2.object_id = a.object_id) AND (a.end_date > p_date)
                INNER JOIN gar_fias.as_object_level    l ON (a.obj_level = l.level_id) AND (l.is_active) AND (l.end_date > p_date) 
                INNER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = a.oper_type_id) AND (ot.is_active) AND (ot.end_date > p_date) 
                
                INNER JOIN aa1 ON (aa1.id_addr_parent = h2.object_id) AND (NOT aa1.cicle_d)
            
                LEFT  JOIN gar_fias.as_addr_obj z ON (h2.parent_obj_id = z.object_id) AND (z.end_date > p_date) 

          WHERE (h2.is_active) AND (h2.end_date > p_date) 
         )
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
                     ,aa1.region_code   
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
                     ,aa1.is_actual
                     ,aa1.is_active                       
                      --               
                     ,aa1.tree_d            
                     ,aa1.level_d
                    
              FROM aa1 ORDER BY aa1.tree_d;
 $$;
 
ALTER FUNCTION gar_fias_pcg_load.f_addr_obj_get_parents (uuid, date) OWNER TO postgres;  

COMMENT ON FUNCTION gar_fias_pcg_load.f_addr_obj_get_parents (uuid, date)
    IS 'Функция подготавливает список вышестоящих объектов. ';
------------------------------------------------------------------------------------
-- USE CASE:
--           DROP INDEX IF EXISTS gar_fias.ie3_as_addr_obj ;
--           CREATE INDEX IF NOT EXISTS ie3_as_addr_obj ON gar_fias.as_addr_obj USING btree (object_guid) ; 
           
--  explain SELECT * FROM gar_fias_pcg_load.f_addr_obj_get_parents ('8b87e6c4-617a-4d32-9414-fada8d0d3e8b');
-- SELECT * FROM gar_fias_pcg_load.f_addr_obj_get_parents ('51ad2527-f117-4269-8efe-8e72d3817f2b');
-- SELECT * FROM gar_fias_pcg_load.f_addr_obj_get_parents ('80a6adb4-a120-4f45-9a50-646ee565d37a');
