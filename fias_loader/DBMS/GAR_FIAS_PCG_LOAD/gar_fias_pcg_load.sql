
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Версия пакета. Дата общей сборки, либо последняя дата обновления.
--
CREATE OR REPLACE VIEW gar_fias_pcg_load.version
 AS
 SELECT '$Revision:1765$ modified $RevDate:2022-09-23$'::text AS version; 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_adr_area_show_data (uuid, date, bigint);
CREATE OR REPLACE FUNCTION gar_fias_pcg_load.f_adr_area_show_data (
       p_fias_guid     uuid     
      ,p_date          date     = current_date
      ,p_obj_level     bigint   = 10
)
    RETURNS SETOF gar_fias.gap_adr_area_t
    STABLE
    LANGUAGE sql
 AS
  $$
    -- ---------------------------------------------------------------------------------------
    --  2022-08-29 Nick 
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
          ,NULL AS id_lead
          ,CAST (ARRAY [a.object_id] AS bigint []) 
          ,1
          ,FALSE
          
        FROM gar_fias.as_addr_obj a
        
          INNER JOIN  gar_fias.as_adm_hierarchy ia
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
        
        WHERE ((((ia.parent_obj_id = 0) OR (ia.parent_obj_id IS NULL)) AND (p_fias_guid IS NULL))
                  OR  
               ((a.object_guid = p_fias_guid) AND (p_fias_guid IS NOT NULL))
              )
                   AND 
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
          ,NULL AS id_lead
          
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
               ,id_lead
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
                   ,lead (aa1.id_addr_obj) 
                       OVER (PARTITION BY aa1.id_addr_parent -- count (1) 
                                         ,aa1.addr_obj_type-- _id  
                                         ,UPPER(aa1.nm_addr_obj) 
                             ORDER BY aa1.change_id   
                    ) AS id_lead
                    --
                   ,aa1.tree_d            
                   ,aa1.level_d
                  
            FROM aa1 
          )
           SELECT
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
                                    (r.type_level = z.type_level) AND (r.is_active) 
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
                    --                    
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
                   ,bb1.change_id
                   ,bb1.prev_id
                   --             --
                   ,bb1.oper_type_id
                   ,bb1.oper_type_name		 
                    --
                   ,bb1.start_date 
                   ,bb1.end_date              
                    --               
                   ,bb1.id_lead
                   ,bb1.tree_d            
                   ,bb1.level_d 
                   
           FROM bb1  
            ORDER BY bb1.id_addr_parent, bb1.addr_obj_type, bb1.nm_addr_obj;
  $$;
 
ALTER FUNCTION gar_fias_pcg_load.f_adr_area_show_data (uuid, date, bigint) OWNER TO postgres;  

COMMENT ON FUNCTION gar_fias_pcg_load.f_adr_area_show_data (uuid, date, bigint) 
IS 'Отображение исходных данных в формате "gar_fias.gap_adr_area_t"';
----------------------------------------------------------------------------------
-- USE CASE:
-- SELECT * FROM gar_fias_pcg_load.f_adr_area_show_data (p_fias_guid := '22f712f4-091f-4adf-af7f-129ee95b4468'::uuid); -- 69598
-- SELECT * FROM gar_fias_pcg_load.f_adr_area_show_data (p_fias_guid := 'b0aa0895-e596-4a25-a0aa-0c69c83f0f9e'::uuid);  
-- SELECT * FROM gar_fias_pcg_load.f_adr_area_show_data (p_fias_guid := NULL::uuid) WHERE (nm_addr_obj ilike 'Аметистовый%'); 
--      57a0587f-59a4-4445-8ef4-d35998fdf3fd  Аметистовый
--   SELECT * FROM gar_fias_pcg_load.f_xxx_adr_area_show_data () WHERE (nm_addr_obj ilike 'Аметистовый%'); 
--   SELECT * FROM gar_fias_pcg_load.f_xxx_adr_area_show_data (); -- 69598

-- SELECT * FROM unnsi.adr_area WHERE (nm_fias_guid = 'b0aa0895-e596-4a25-a0aa-0c69c83f0f9e'::uuid);
-- SELECT * FROM unnsi.adr_area WHERE(id_area_parent = 104565);  - нет 8-ми записей
-- SELECT * FROM unnsi.adr_area WHERE (nm_fias_guid = '80a6adb4-a120-4f45-9a50-646ee565d37a');

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_update_parent (uuid, uuid, date);
CREATE OR REPLACE FUNCTION gar_fias_pcg_load.f_addr_obj_update_parent (
         p_parent_fias_guid_old  uuid
        ,p_parent_fias_guid_new  uuid
        ,p_date                  date = current_date        
  )
    RETURNS integer
    LANGUAGE plpgsql 
    SECURITY DEFINER
    AS $$
    -- =================================================================================
    -- Author: Nick
    -- Create date: 2022-07-08
    -- --------------------------------------------------------------------------------- 
    -- Модификация отношения подчинённости в схеме gar_fias.
    --                        p_parent_fias_guid_old  uuid -- старый родитель
    --                       ,p_parent_fias_guid_new  uuid -- новый родтель
    -- =================================================================================
    DECLARE 
      _id_parent_new   bigint;
      _r integer := 0;
      
    BEGIN
      _id_parent_new := (SELECT a.object_id FROM gar_fias.as_addr_obj a 
                            WHERE (a.object_guid = p_parent_fias_guid_new) AND
                                  (a.is_actual) AND (a.is_active) AND 
                                  (a.end_date > p_date) AND (a.start_date <= p_date)
                          );
      WITH z (
                 id_addr_obj
      )
       AS (
            SELECT id_addr_obj
                 FROM gar_fias_pcg_load.f_adr_area_show_data (p_parent_fias_guid_old::uuid)
                            WHERE (level_d > 1) 
          )
          UPDATE gar_fias.as_adm_hierarchy n SET parent_obj_id = _id_parent_new 
                FROM z
                    WHERE (z.id_addr_obj = n.object_id) AND (n.is_active)
                      AND (n.end_date > p_date) AND (n.start_date <= p_date);
    
       GET DIAGNOSTICS _r = ROW_COUNT;
       RETURN _r;
    END;
  $$;

ALTER FUNCTION gar_fias_pcg_load.f_addr_obj_update_parent (uuid, uuid, date) OWNER TO postgres;

COMMENT ON FUNCTION gar_fias_pcg_load.f_addr_obj_update_parent (uuid, uuid, date) 
IS 'Модификация отношения подчинённости в схеме gar_fias. ТОЛЬКО АКТИВНЫЕ И АКТУАЛЬНЫЕ ОБЪЕКТЫ.';
--
--  USE CASE:
--
-- SELECT gar_fias_pcg_load.f_addr_obj_update_parent ('80a6adb4-a120-4f45-9a50-646ee565d37a', 'b0aa0895-e596-4a25-a0aa-0c69c83f0f9e')

-- SELECT * FROM gar_fias_pcg_load.f_adr_area_show_data ('b0aa0895-e596-4a25-a0aa-0c69c83f0f9e'::uuid);
-- SELECT * FROM gar_fias_pcg_load.f_adr_area_show_data ('80a6adb4-a120-4f45-9a50-646ee565d37a'::uuid);

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_adr_area_set_data (uuid, date, text);
CREATE OR REPLACE FUNCTION gar_fias_pcg_load.f_adr_area_set_data (

       p_fias_guid  uuid 
      ,p_date       date = current_date
      ,p_descr      text = NULL
      
) RETURNS integer

    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_tmp, public
 AS
  $$
    -- ----------------------------------------------------------------------------------------------
    --  2022-08-28 Nick Запомнить дефектные данные, адресные объекты.
    -- ----------------------------------------------------------------------------------------------
    -- ----------------------------------------------------------------------------------------------
    DECLARE
      _r  integer;
    
    BEGIN   
        WITH x (  id_addr_obj       
                 ,id_addr_parent    
                 ,fias_guid         
                 ,parent_fias_guid  
                 ,nm_addr_obj       
                 ,addr_obj_type_id  
                 ,addr_obj_type     
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
        )
         AS (
             SELECT * FROM gar_fias_pcg_load.f_adr_area_show_data(p_fias_guid)  
            )
              
            INSERT INTO gar_fias.gap_adr_area AS z (            
                                   id_addr_obj      
                                  ,id_addr_parent   
                                  ,fias_guid        
                                  ,parent_fias_guid 
                                  ,nm_addr_obj       
                                  ,addr_obj_type_id 
                                  ,addr_obj_type    
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
                                   --                                     
                                  ,date_create    
                                  ,descr_gap      
            )
             SELECT x.id_addr_obj       
                   ,x.id_addr_parent    
                   ,x.fias_guid         
                   ,x.parent_fias_guid  
                   ,x.nm_addr_obj       
                   ,x.addr_obj_type_id  
                   ,x.addr_obj_type     
                   ,x.obj_level         
                   ,x.level_name        
                   --
                   ,x.region_code      
                   ,x.area_code        
                   ,x.city_code        
                   ,x.place_code       
                   ,x.plan_code        
                   ,x.street_code      
                    --
                   ,x.change_id    
                   ,x.prev_id      
                    --
                   ,x.oper_type_id     
                   ,x.oper_type_name   
                    --                         
                   ,x.start_date       
                   ,x.end_date         
                    --
                   ,COALESCE (x.id_lead, x.id_addr_obj)          	   
                   ,x.tree_d           
                   ,x.level_d   
                    --
                   ,p_date 
                   ,p_descr            
             
             FROM x WHERE (x.id_lead IS NOT NULL)    
        
                UNION ALL
        		
             SELECT x.id_addr_obj       
                   ,x.id_addr_parent    
                   ,x.fias_guid         
                   ,x.parent_fias_guid  
                   ,x.nm_addr_obj       
                   ,x.addr_obj_type_id  
                   ,x.addr_obj_type     
                   ,x.obj_level         
                   ,x.level_name        
                    --
                   ,x.region_code      
                   ,x.area_code        
                   ,x.city_code        
                   ,x.place_code       
                   ,x.plan_code        
                   ,x.street_code      
                   --
                   ,x.change_id    
                   ,x.prev_id      
                    --
                   ,x.oper_type_id     
                   ,x.oper_type_name   
                    --                         
                   ,x.start_date       
                   ,x.end_date         
                    --
                   ,COALESCE (x.id_lead, x.id_addr_obj)          	   
                   ,x.tree_d           
                   ,x.level_d  
                    --
                   ,p_date   
                   ,p_descr            
                  
        	 FROM x WHERE (x.id_addr_obj IN (SELECT id_lead FROM x WHERE (id_lead IS NOT NULL)))    
              ORDER BY id_addr_parent, addr_obj_type, nm_addr_obj, change_id DESC
    
        ON CONFLICT (id_addr_obj, date_create) DO NOTHING ;
            
       GET DIAGNOSTICS _r = ROW_COUNT;
       RETURN _r;      
    END;         
$$;
 
ALTER FUNCTION gar_fias_pcg_load.f_adr_area_set_data (uuid, date, text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_fias_pcg_load.f_adr_area_set_data (uuid, date, text) 
IS ' Запомнить дефектные данные, адресные объекты';
----------------------------------------------------------------------------------
-- USE CASE:
--  SELECT * FROM gar_tmp.xxx_adr_area;  -- 19186
--  TRUNCATE TABLE gar_tmp.xxx_adr_area;
--  SELECT gar_fias_pcg_load.f_adr_area_set_data (); -- 19186
 
	 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
                    ,tree_d            
                    ,level_d
                    ,cicle_d  
   ) AS (
          SELECT
             a.object_id
            ,NULLIF (ia.parent_obj_id, 0)
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
            ,ia.region_code  
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
          
            LEFT  JOIN gar_fias.as_addr_obj z ON (ia.parent_obj_id = z.object_id) 
                                            AND ((z.is_actual AND z.is_active) AND (z.end_date > p_date) 
                                            AND (z.start_date <= p_date)
                                      )
          
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
                                                                         
          WHERE  (a.object_guid = p_fias_guid) AND  (ia.is_active) AND (ia.end_date > p_date) AND (ia.start_date <= p_date)   
       
       
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
            ,ia.region_code   
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
            ,(aa1.level_d - 1) t
            ,a.object_id = ANY (aa1.tree_d)   
          
             FROM gar_fias.as_addr_obj a
                INNER JOIN gar_fias.as_adm_hierarchy ia ON ((ia.object_id = a.object_id) AND (ia.is_active) 
                                                             AND (ia.end_date > p_date) 
                                                             AND (ia.start_date <= p_date)
                                                           )
               LEFT  JOIN gar_fias.as_addr_obj z ON (ia.parent_obj_id = z.object_id)
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
                                            
                INNER JOIN aa1 ON (aa1.id_addr_parent = ia.object_id) AND (NOT aa1.cicle_d)
            
          WHERE  
                  ((a.is_actual AND a.is_active) AND (a.end_date > p_date) 
                          AND (a.start_date <= p_date)
                  )
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
                     ,aa1.tree_d            
                     ,aa1.level_d
                    
              FROM aa1 ORDER BY aa1.tree_d
 $$;
 
ALTER FUNCTION gar_fias_pcg_load.f_addr_obj_get_parents (uuid, date) OWNER TO postgres;  

COMMENT ON FUNCTION gar_fias_pcg_load.f_addr_obj_get_parents (uuid, date)
    IS 'Функция подготавливает список вышестоящих объектов. ';
----------------------------------------------------------------------------------
-- USE CASE:
--  explain SELECT * FROM gar_fias_pcg_load.f_addr_obj_get_parents ('b0aa0895-e596-4a25-a0aa-0c69c83f0f9e');
-- SELECT * FROM gar_fias_pcg_load.f_addr_obj_get_parents ('583e68da-a531-4613-9257-b5926ef418aa');
-- SELECT * FROM gar_fias_pcg_load.f_addr_obj_get_parents ('80a6adb4-a120-4f45-9a50-646ee565d37a');

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_get_twins ( varchar(250));
CREATE OR REPLACE FUNCTION gar_fias_pcg_load.f_addr_obj_get_twins (
       p_nm_addr_obj  varchar(250)    
)
    RETURNS 
       TABLE (
                 id_addr_obj        bigint    
                ,fias_guid          uuid
                ,nm_addr_obj_full   text 
                ,change_id          bigint
                ,start_date         date
                ,end_date           date
       )
    STABLE
    LANGUAGE sql
 AS
  $$
      SELECT object_id, object_guid
        ,(SELECT string_agg ((nm_addr_obj || ' ' || addr_obj_type || '.'), ', ')
             FROM gar_fias_pcg_load.f_addr_obj_get_parents (object_guid)
         )
        ,change_id, start_date, end_date	  
       FROM gar_fias.as_addr_obj
       
      WHERE (upper (object_name) = upper(btrim(p_nm_addr_obj))) 
               AND is_active AND is_actual;
  $$;
 
ALTER FUNCTION gar_fias_pcg_load.f_addr_obj_get_twins (varchar(250)) OWNER TO postgres;  

COMMENT ON FUNCTION gar_fias_pcg_load.f_addr_obj_get_twins (varchar(250))
    IS 'Функция формирует список объектов-двойников';    
-- --------------
--  USE CASE:
--   EXPLAIN   SELECT * FROM gar_fias_pcg_load.f_addr_obj_get_twins ('вОЛКОВО');

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_update_children (uuid, uuid, date);

DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_update_children (date, integer[], uuid[], date);
CREATE OR REPLACE FUNCTION gar_fias_pcg_load.f_addr_obj_update_children (
         p_date_1     date                      -- Обрабатываемвя дата
        ,p_obj_level  integer[] = ARRAY[6,7]    -- Уровни адресных объектов
        ,p_fias_guid  uuid[]    = NULL::uuid[]  -- Выбранные UUID, опционально
        ,p_date_2     date      = current_date  -- Текущая дата (передаётся как параметр ??)
         --
        ,OUT fias_guid_new    uuid         -- UUID актуального объекта.
        ,OUT nm_addr_obj      varchar(250) -- Наименование адресного объекта. 
        ,OUT addr_obj_type_id bigint       -- Тип адрессного объекта.
        ,OUT chld_qty_tot     integer      -- Общее количество подчинённых объектов 
        ,OUT chld_qty_unact   integer      -- Неактуальные.
  )
    RETURNS setof record
    LANGUAGE plpgsql 
    SECURITY DEFINER
    AS $$
    -- ================================================================================
    -- Author: Nick
    -- Create date: 2022-08-31/2022-09-01
    -- -------------------------------------------------------------------------------- 
    -- Модификация отношения подчинённости в схеме gar_fias.
    --      Для выбранного родителя, оставляю актуальных детей.
    -- ================================================================================
  DECLARE
    _rec_one record; 
    
  BEGIN
    -- ------------------------------------------------------------------------------
    -- Цикл по таблице ошибок. (obj_level IN (6,7)). Парные записи, вначале новый 
    --   адресный объект, потом старый. 
    -- Должны совпадать: id_addr_parent, upper(nm_addr_obj), addr_obj_type_id.
    -- Далее обработка (пункты 0,1,2). 
    -- -----------------------------------------------------------------------------
  
    FOR _rec_one IN 
     WITH z (  change_id
              ,id_addr_parent
              ,nm_addr_obj
              ,addr_obj_type_id
              ,date_create
         ) AS 
           (
             -- Выбираю записи, принадлежание обрабатываемой дате.
             SELECT  MAX(x.change_id) AS change_id
                    ,x.id_addr_parent
                    ,upper(x.nm_addr_obj)
                    ,x.addr_obj_type_id
                    ,x.date_create
                   
                  FROM gar_fias.gap_adr_area x 
                    WHERE (x.obj_level = ANY(p_obj_level)) AND 
                          (x.date_create = p_date_1) AND
                          (((x.fias_guid = ANY (p_fias_guid)) AND (p_fias_guid IS NOT NULL))
                             OR (p_fias_guid IS NULL)
                          )	                                  
                   GROUP BY x.id_addr_parent
                          ,upper(x.nm_addr_obj)
                          ,x.addr_obj_type_id
                          ,x.date_create 
            )
              SELECT a.fias_guid AS fias_guid_new
                   , b.fias_guid AS fias_guid_old 
                   , z.id_addr_parent  
                   , a.nm_addr_obj 
                   , z.addr_obj_type_id              
                   , z.change_id AS change_id_new
                   , b.change_id AS change_id_old
              FROM z
                JOIN gar_fias.gap_adr_area a ON (z.id_addr_parent = a.id_addr_parent)  AND
                                                (z.nm_addr_obj = upper(a.nm_addr_obj)) AND
                                                (z.addr_obj_type_id = a.addr_obj_type_id) AND
                                                (z.change_id = a.change_id) AND
                                                (z.date_create = a.date_create)
                 --                                
                JOIN gar_fias.gap_adr_area b ON (z.id_addr_parent = b.id_addr_parent)  AND
                                                (z.nm_addr_obj = upper(b.nm_addr_obj)) AND
                                                (z.addr_obj_type_id = b.addr_obj_type_id) AND
												(b.date_create = z.date_create) AND                                                 
                                                (z.change_id > b.change_id)		  

      LOOP
          -- 0) Заменяю старого родителя на нового
          chld_qty_tot := gar_fias_pcg_load.f_addr_obj_update_parent (
                            _rec_one.fias_guid_old, _rec_one.fias_guid_new, p_date_2
          );
          
          -- 1) Старого родителя убрать: is actual, is_active <---- FALSE.
          UPDATE gar_fias.as_addr_obj SET is_actual = FALSE, is_active = FALSE
           WHERE (object_guid = _rec_one.fias_guid_old);
         
          -- 2) Убрать неактуальных детей. (id_lead IS not NULL) убрать is actual, is_active <---- FALSE.
          WITH z (id_addr_obj)
              AS (
                   SELECT id_addr_obj 
                       FROM gar_fias_pcg_load.f_adr_area_show_data (_rec_one.fias_guid_new)
                              WHERE (id_lead IS not NULL)
                 )
             UPDATE gar_fias.as_addr_obj x SET is_actual = FALSE, is_active = FALSE
              FROM z
                      WHERE (x.object_id = z.id_addr_obj);
        
        GET DIAGNOSTICS chld_qty_unact = ROW_COUNT;
        
        fias_guid_new    := _rec_one.fias_guid_new;
        nm_addr_obj      := _rec_one.nm_addr_obj; 
        addr_obj_type_id := _rec_one.addr_obj_type_id;
        
        RETURN NEXT;
      END LOOP;
  END;
 $$;

COMMENT ON FUNCTION gar_fias_pcg_load.f_addr_obj_update_children (date, integer[], uuid[], date) IS 
'ТОЛЬКО АКТИВНЫЕ И АКТУАЛЬНЫЕ ОБЪЕКТЫ. Модификация отношения подчинённости в схеме gar_fias,
с дективацией более ранних объектов.';
--
--  USE CASE:
--

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.p_alt_tbl (boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.p_alt_tbl (
        p_all  boolean = TRUE
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-13/2021-11-29
    -- ----------------------------------------------------------------------------------------------------  
    -- Модификация таблиц в схеме gar_fias. false - UNLOGGED таблицы.
    --                                      true  - LOGGED таблицы.
    -- ====================================================================================================
   
    BEGIN
       IF p_all THEN 
                ALTER TABLE  gar_fias.as_addr_obj SET LOGGED;
                ALTER TABLE  gar_fias.as_addr_obj_division SET LOGGED;
                ALTER TABLE  gar_fias.as_addr_obj_params SET LOGGED;
                ALTER TABLE  gar_fias.as_addr_obj_type SET LOGGED;
                ALTER TABLE  gar_fias.as_add_house_type SET LOGGED;
                ALTER TABLE  gar_fias.as_adm_hierarchy SET LOGGED;
                ALTER TABLE  gar_fias.as_apartments SET LOGGED;
                ALTER TABLE  gar_fias.as_apartments_params SET LOGGED;
                ALTER TABLE  gar_fias.as_apartment_type SET LOGGED;
                ALTER TABLE  gar_fias.as_carplaces SET LOGGED;
                ALTER TABLE  gar_fias.as_carplaces_params SET LOGGED;
                ALTER TABLE  gar_fias.as_change_history SET LOGGED;
                ALTER TABLE  gar_fias.as_houses SET LOGGED;
                ALTER TABLE  gar_fias.as_houses_params SET LOGGED;
                ALTER TABLE  gar_fias.as_house_type SET LOGGED; 
                ALTER TABLE  gar_fias.as_mun_hierarchy SET LOGGED;
                ALTER TABLE  gar_fias.as_normative_docs SET LOGGED;
                ALTER TABLE  gar_fias.as_norm_docs_kinds SET LOGGED;
                ALTER TABLE  gar_fias.as_norm_docs_types SET LOGGED;
                ALTER TABLE  gar_fias.as_object_level SET LOGGED;
                ALTER TABLE  gar_fias.as_operation_type SET LOGGED; 
                ALTER TABLE  gar_fias.as_param_type SET LOGGED;
                ALTER TABLE  gar_fias.as_reestr_objects SET LOGGED;
                ALTER TABLE  gar_fias.as_rooms SET LOGGED;
                ALTER TABLE  gar_fias.as_rooms_params SET LOGGED;
                ALTER TABLE  gar_fias.as_room_type SET LOGGED;
                ALTER TABLE  gar_fias.as_steads SET LOGGED;
                ALTER TABLE  gar_fias.as_steads_params SET LOGGED;         
         ELSE
                ALTER TABLE  gar_fias.as_addr_obj SET UNLOGGED;
                ALTER TABLE  gar_fias.as_addr_obj_division SET UNLOGGED;
                ALTER TABLE  gar_fias.as_addr_obj_params SET UNLOGGED;
                ALTER TABLE  gar_fias.as_addr_obj_type SET UNLOGGED;
                ALTER TABLE  gar_fias.as_add_house_type SET UNLOGGED;
                ALTER TABLE  gar_fias.as_adm_hierarchy SET UNLOGGED;
                ALTER TABLE  gar_fias.as_apartments SET UNLOGGED;
                ALTER TABLE  gar_fias.as_apartments_params SET UNLOGGED;
                ALTER TABLE  gar_fias.as_apartment_type SET UNLOGGED;
                ALTER TABLE  gar_fias.as_carplaces SET UNLOGGED;
                ALTER TABLE  gar_fias.as_carplaces_params SET UNLOGGED;
                ALTER TABLE  gar_fias.as_change_history SET UNLOGGED;
                ALTER TABLE  gar_fias.as_houses SET UNLOGGED;
                ALTER TABLE  gar_fias.as_houses_params SET UNLOGGED;
                ALTER TABLE  gar_fias.as_house_type SET UNLOGGED; 
                ALTER TABLE  gar_fias.as_mun_hierarchy SET UNLOGGED;
                ALTER TABLE  gar_fias.as_normative_docs SET UNLOGGED;
                ALTER TABLE  gar_fias.as_norm_docs_kinds SET UNLOGGED;
                ALTER TABLE  gar_fias.as_norm_docs_types SET UNLOGGED;
                ALTER TABLE  gar_fias.as_object_level SET UNLOGGED;
                ALTER TABLE  gar_fias.as_operation_type SET UNLOGGED; 
                ALTER TABLE  gar_fias.as_param_type SET UNLOGGED;
                ALTER TABLE  gar_fias.as_reestr_objects SET UNLOGGED;
                ALTER TABLE  gar_fias.as_rooms SET UNLOGGED;
                ALTER TABLE  gar_fias.as_rooms_params SET UNLOGGED;
                ALTER TABLE  gar_fias.as_room_type SET UNLOGGED;
                ALTER TABLE  gar_fias.as_steads SET UNLOGGED;
                ALTER TABLE  gar_fias.as_steads_params SET UNLOGGED;         
       END IF;       
        
       RETURN;
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.p_alt_tbl (boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.p_alt_tbl (boolean) IS 'Модификация таблиц в схеме gar_fias.';
--
--  USE CASE:
--             CALL gar_fias_pcg_load.p_alt_tbl (FALSE); --  
--             CALL gar_fias_pcg_load.p_alt_tbl ();

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_fias_pcg_load.del_gar_addr_obj (bigint);
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.del_gar_all ();
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.del_gar_all ()
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ==============================================================================
    -- Author: Nick
    -- Create date: 2021-11-23
    -- ------------------------------------------------------------------------------  
    -- 'Очистка таблиц в схеме "gar_fias"'
    -- ==============================================================================
   
    BEGIN
    
     TRUNCATE TABLE gar_fias.as_add_house_type;	
     TRUNCATE TABLE gar_fias.as_addr_obj;	        -- Классификатор адресообразующих элементов
     TRUNCATE TABLE gar_fias.as_addr_obj_division;	-- Переподчинение адресных элементов
     TRUNCATE TABLE gar_fias.as_addr_obj_params;	-- Параметры адресообразующего элемента
     TRUNCATE TABLE gar_fias.as_addr_obj_type;     	-- Типы адресных объектов
     TRUNCATE TABLE gar_fias.as_adm_hierarchy;      -- Иерархия в административном делении
     TRUNCATE TABLE gar_fias.as_apartment_type;	    -- Типы помещений
     TRUNCATE TABLE gar_fias.as_apartments;	        -- Помещения
     TRUNCATE TABLE gar_fias.as_apartments_params;  -- Параметры помещения
     TRUNCATE TABLE gar_fias.as_carplaces;	        -- Сведения по машино-местам
     TRUNCATE TABLE gar_fias.as_carplaces_params;	-- Параметры машиноместа
     TRUNCATE TABLE gar_fias.as_change_history;	    -- История изменений
     --
     TRUNCATE TABLE gar_fias.as_house_type;	     -- Признаки владения (Типы домов)
     TRUNCATE TABLE gar_fias.as_houses;	         -- Номерам домов
     TRUNCATE TABLE gar_fias.as_houses_params;   --
     TRUNCATE TABLE gar_fias.as_mun_hierarchy;   -- Иерархия в муниципальном делении
     TRUNCATE TABLE gar_fias.as_norm_docs_kinds; -- Вид документа
     TRUNCATE TABLE gar_fias.as_norm_docs_types; -- Тип нормативного документа
     TRUNCATE TABLE gar_fias.as_normative_docs;  -- Нормативные документы
     TRUNCATE TABLE gar_fias.as_object_level;	 -- Уровни адресных объектов
     TRUNCATE TABLE gar_fias.as_operation_type;  -- Статусы действия
     TRUNCATE TABLE gar_fias.as_param_type;	     -- Типы параметров
     TRUNCATE TABLE gar_fias.as_reestr_objects;  -- Сведения об элементе реестра
     TRUNCATE TABLE gar_fias.as_room_type;       -- Типы комнат
     TRUNCATE TABLE gar_fias.as_rooms;	         -- Комнаты
     TRUNCATE TABLE gar_fias.as_rooms_params;	 -- Параметры комнаты
     TRUNCATE TABLE gar_fias.as_steads;          -- Земельные участки
     TRUNCATE TABLE gar_fias.as_steads_params;	 -- Параметры земельных участков 
 
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.del_gar_all () OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.del_gar_all () IS 'Очистка таблиц в схеме "gar_fias"';
--
--  USE CASE:
--      SELECT * FROM gar_fias.as_addr_obj;
--      CALL gar_fias_pcg_load.del_gar_all ();

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_addr_obj (bigint, bigint, uuid, bigint, character varying, character varying, bigint, bigint, bigint, bigint, date, date, date, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_addr_obj (
                            i_id           gar_fias.as_addr_obj.id%TYPE           
                           ,i_object_id    gar_fias.as_addr_obj.object_id%TYPE
                           ,i_object_guid  gar_fias.as_addr_obj.object_guid%TYPE
                           ,i_change_id    gar_fias.as_addr_obj.change_id%TYPE
                           ,i_object_name  gar_fias.as_addr_obj.object_name%TYPE
                           ,i_type_name    gar_fias.as_addr_obj.type_name%TYPE
                           ,i_obj_level    gar_fias.as_addr_obj.obj_level%TYPE
                           ,i_oper_type_id gar_fias.as_addr_obj.oper_type_id%TYPE
                           ,i_prev_id      gar_fias.as_addr_obj.prev_id%TYPE
                           ,i_next_id      gar_fias.as_addr_obj.next_id%TYPE
                           ,i_update_date  gar_fias.as_addr_obj.update_date%TYPE
                           ,i_start_date   gar_fias.as_addr_obj.start_date%TYPE
                           ,i_end_date     gar_fias.as_addr_obj.end_date%TYPE
                           ,i_is_actual    gar_fias.as_addr_obj.is_actual%TYPE
                           ,i_is_active    gar_fias.as_addr_obj.is_active%TYPE
                           
)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-07
    -- Updates:  2021-10-28 Модификация под загрузчик ГИС Интеграция.
    --           2022-01-26/2022-09-19 Неоднозначность в определении типов
    -- ----------------------------------------------------------------------------------------------------  
    -- Загрузка классификатора адресных объектов. Источник: внешний парсер.
    --  Предварительно должны быть загружены: "as_operation_type", "as_reestr_objects", "as_object_level".
    --  Два этапа выполнения: 1) собственно загрузка, 2) обновление столбца "type_id".
    --  Для второго эапа должна быть загружена таблица "gar_fias.as_addr_obj_type".
    --  Дополнительные параметры адресного объекта грузятся после загрузки основного объекта "as_addr_obj",
    --     (таблица "gar_fias.as_addr_obj_params").
    -- ====================================================================================================
   
    BEGIN
        INSERT INTO gar_fias.as_addr_obj AS i (
        
                            id            
                           ,object_id    
                           ,object_guid  
                           ,change_id    
                           ,object_name  
                           ,type_name    
                           ,obj_level    
                           ,oper_type_id 
                           ,prev_id      
                           ,next_id      
                           ,update_date  
                           ,start_date   
                           ,end_date     
                           ,is_actual    
                           ,is_active    
        )
          VALUES (
                            i_id          
                           ,i_object_id   
                           ,i_object_guid 
                           ,i_change_id   
                           ,i_object_name 
                           ,i_type_name   
                           ,i_obj_level   
                           ,i_oper_type_id
                           ,i_prev_id     
                           ,i_next_id     
                           ,i_update_date 
                           ,i_start_date  
                           ,i_end_date    
                           ,i_is_actual   
                           ,i_is_active   
                 )
                 ON CONFLICT (id) DO 
                    UPDATE 
                         SET 
                            object_id    = excluded.object_id   
                           ,object_guid  = excluded.object_guid 
                           ,change_id    = excluded.change_id   
                           ,object_name  = excluded.object_name 
                           ,type_name    = excluded.type_name   
                           ,obj_level    = excluded.obj_level   
                           ,oper_type_id = excluded.oper_type_id
                           ,prev_id      = excluded.prev_id     
                           ,next_id      = excluded.next_id     
                           ,update_date  = excluded.update_date 
                           ,start_date   = excluded.start_date  
                           ,end_date     = excluded.end_date    
                           ,is_actual    = excluded.is_actual   
                           ,is_active    = excluded.is_active   
                    
                    WHERE (i.id = excluded.id);
        --
        WITH x AS (
                    SELECT z.id AS type_id, z.type_shortname 
                        FROM gar_fias.as_addr_obj_type z WHERE (z.type_shortname = i_type_name) AND 
               			      (z.is_active) AND (z.type_level::bigint = i_obj_level)            
        )
        UPDATE gar_fias.as_addr_obj u SET type_id = x.type_id 
           FROM x  
                 WHERE (u.type_name = x.type_shortname) AND (u.id = i_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_addr_obj (bigint, bigint, uuid, bigint, character varying, character varying, bigint, bigint, bigint, bigint, date, date, date, boolean, boolean)
     OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_addr_obj (bigint, bigint, uuid, bigint, character varying, character varying, bigint, bigint, bigint, bigint, date, date, date, boolean, boolean)
     IS 'Загрузка классификатора адресообразующих элементов';
--
--  USE CASE:
-- --------------------------------------------------------------------------------------------

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_normative_docs (bigint, varchar(1500), date, varchar(150), bigint, bigint, date, varchar(255), date, varchar(100), date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_normative_docs (

               i_id          gar_fias.as_normative_docs.ndoc_id%TYPE
              ,i_doc_name    gar_fias.as_normative_docs.doc_name%TYPE
              ,i_doc_date    gar_fias.as_normative_docs.doc_date%TYPE
              ,i_doc_number  gar_fias.as_normative_docs.doc_number%TYPE
              ,i_doc_type    gar_fias.as_normative_docs.doc_type_id%TYPE
              ,i_doc_kind    gar_fias.as_normative_docs.doc_kind_id%TYPE
              ,i_update_date gar_fias.as_normative_docs.update_date%TYPE
              ,i_org_name    gar_fias.as_normative_docs.org_name%TYPE
              ,i_acc_date    gar_fias.as_normative_docs.acc_date%TYPE
              ,i_reg_num     gar_fias.as_normative_docs.reg_num%TYPE 
              ,i_reg_date    gar_fias.as_normative_docs.reg_date%TYPE
                           
) LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick Сохранение нормативных документов.
    -- Create date: 2021-11-11 Под загрузчик ГИС Интеграция
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_normative_docs AS i (
        
                          ndoc_id
                         ,doc_name
                         ,doc_date
                         ,doc_number
                         ,doc_type_id
                         ,doc_kind_id
                         ,update_date
                         ,org_name
                         ,acc_date
                         ,reg_num 
                         ,reg_date 
        )
         VALUES (
                          i_id          
                         ,i_doc_name    
                         ,i_doc_date    
                         ,i_doc_number  
                         ,i_doc_type    
                         ,i_doc_kind    
                         ,i_update_date 
                         ,i_org_name    
                         ,i_acc_date    
                         ,i_reg_num     
                         ,i_reg_date    
         )
          ON CONFLICT (ndoc_id) DO UPDATE  
                         SET
                              doc_name    = excluded.doc_name   
                             ,doc_date    = excluded.doc_date   
                             ,doc_number  = excluded.doc_number 
                             ,doc_type_id = excluded.doc_type_id
                             ,doc_kind_id = excluded.doc_kind_id
                             ,update_date = excluded.update_date
                             ,org_name    = excluded.org_name   
                             ,acc_date    = excluded.acc_date   
                             ,reg_num     = excluded.reg_num    
                             ,reg_date    = excluded.reg_date     
          
                  WHERE (i.ndoc_id = excluded.ndoc_id);           
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_normative_docs (bigint, varchar(1500), date, varchar(150), bigint, bigint, date, varchar(255), date, varchar(100), date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_normative_docs (bigint, varchar(1500), date, varchar(150), bigint, bigint, date, varchar(255), date, varchar(100), date) 
     IS 'Сохранение нормативных документов';
--
--  USE CASE:



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_apartments (bigint,bigint,uuid,bigint,varchar(50),bigint,bigint,bigint,bigint,date,date,date,boolean,boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_apartments (
                    i_id           gar_fias.as_apartments.id%TYPE
                   ,i_object_id    gar_fias.as_apartments.object_id%TYPE
                   ,i_object_guid  gar_fias.as_apartments.object_guid%TYPE
                   ,i_change_id    gar_fias.as_apartments.change_id%TYPE
                   ,i_apart_number gar_fias.as_apartments.apart_number%TYPE
                   ,i_apart_type   gar_fias.as_apartments.apart_type_id%TYPE
                   ,i_oper_type_id gar_fias.as_apartments.oper_type_id%TYPE
                   ,i_prev_id      gar_fias.as_apartments.prev_id%TYPE
                   ,i_next_id      gar_fias.as_apartments.next_id%TYPE
                   ,i_update_date  gar_fias.as_apartments.update_date%TYPE
                   ,i_start_date   gar_fias.as_apartments.start_date%TYPE
                   ,i_end_date     gar_fias.as_apartments.end_date%TYPE
                   ,i_is_actual    gar_fias.as_apartments.is_actual%TYPE
                   ,i_is_active    gar_fias.as_apartments.is_active%TYPE
    )                          
    LANGUAGE plpgsql SECURITY DEFINER
          SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    --  Author: Nick
    --  Create date: 2021-11-10 Под загрузчик ГИС Интеграци
    -- ----------------------------------------------------------------------------------------------------  
    --           Сохранение списка помещений
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_apartments AS a (
                    id
                   ,object_id
                   ,object_guid
                   ,change_id
                   ,apart_number
                   ,apart_type_id
                   ,oper_type_id
                   ,prev_id
                   ,next_id
                   ,update_date
                   ,start_date
                   ,end_date
                   ,is_actual
                   ,is_active      
        )
          VALUES (
                    i_id           
                   ,i_object_id    
                   ,i_object_guid  
                   ,i_change_id    
                   ,i_apart_number 
                   ,i_apart_type   
                   ,i_oper_type_id 
                   ,i_prev_id      
                   ,i_next_id      
                   ,i_update_date  
                   ,i_start_date   
                   ,i_end_date     
                   ,i_is_actual    
                   ,i_is_active      
          )
           
         ON CONFLICT (id) DO UPDATE
                SET
                    object_id     = excluded.object_id
                   ,object_guid   = excluded.object_guid
                   ,change_id     = excluded.change_id
                   ,apart_number  = excluded.apart_number
                   ,apart_type_id = excluded.apart_type_id
                   ,oper_type_id  = excluded.oper_type_id
                   ,prev_id       = excluded.prev_id
                   ,next_id       = excluded.next_id
                   ,update_date   = excluded.update_date
                   ,start_date    = excluded.start_date
                   ,end_date      = excluded.end_date
                   ,is_actual     = excluded.is_actual
                   ,is_active     = excluded.is_active                 
         
        WHERE (a.id = excluded.id);           
        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_apartments (bigint,bigint,uuid,bigint,varchar(50),bigint,bigint,bigint,bigint,date,date,date,boolean,boolean) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_apartments (bigint,bigint,uuid,bigint,varchar(50),bigint,bigint,bigint,bigint,date,date,date,boolean,boolean) 
   IS 'Сохранение списка помещений';
--
--  USE CASE:


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_adm_hierarchy (bigint, bigint, bigint, bigint, varchar(4), varchar(4), varchar(4), varchar(4), varchar(4), varchar(4), bigint, bigint, date, date, date, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_adm_hierarchy (
                          i_id            gar_fias.as_adm_hierarchy.id%TYPE
                         ,i_object_id     gar_fias.as_adm_hierarchy.object_id%TYPE
                         ,i_parent_obj_id gar_fias.as_adm_hierarchy.parent_obj_id%TYPE
                         ,i_change_id     gar_fias.as_adm_hierarchy.change_id%TYPE
                         ,i_region_code   gar_fias.as_adm_hierarchy.region_code%TYPE
                         ,i_area_code     gar_fias.as_adm_hierarchy.area_code%TYPE
                         ,i_city_code     gar_fias.as_adm_hierarchy.city_code%TYPE
                         ,i_place_code    gar_fias.as_adm_hierarchy.place_code%TYPE
                         ,i_plan_code     gar_fias.as_adm_hierarchy.plan_code%TYPE
                         ,i_street_code   gar_fias.as_adm_hierarchy.street_code%TYPE
                         ,i_prev_id       gar_fias.as_adm_hierarchy.prev_id%TYPE
                         ,i_next_id       gar_fias.as_adm_hierarchy.next_id%TYPE
                         ,i_update_date   gar_fias.as_adm_hierarchy.update_date%TYPE
                         ,i_start_date    gar_fias.as_adm_hierarchy.start_date%TYPE
                         ,i_end_date      gar_fias.as_adm_hierarchy.end_date%TYPE
                         ,i_is_active     gar_fias.as_adm_hierarchy.is_active%TYPE
) 
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-07
    -- Updates:  2021-11-03 Модификация под загрузчик ГИС Интеграция.    
    -- ----------------------------------------------------------------------------------------------------  
    --  Загрузка иерархии в адинистративном делении. 
    -- ====================================================================================================
    
    BEGIN
        INSERT INTO gar_fias.as_adm_hierarchy AS i (
                            id
                           ,object_id
                           ,parent_obj_id
                           ,change_id
                           ,region_code
                           ,area_code
                           ,city_code
                           ,place_code
                           ,plan_code
                           ,street_code
                           ,prev_id
                           ,next_id
                           ,update_date
                           ,start_date
                           ,end_date
                           ,is_active       
         )
           VALUES (
                      i_id            
                     ,i_object_id     
                     ,i_parent_obj_id 
                     ,i_change_id     
                     ,i_region_code   
                     ,i_area_code     
                     ,i_city_code     
                     ,i_place_code    
                     ,i_plan_code     
                     ,i_street_code   
                     ,i_prev_id       
                     ,i_next_id       
                     ,i_update_date   
                     ,i_start_date    
                     ,i_end_date      
                     ,i_is_active     
            )
         ON CONFLICT (id) DO UPDATE SET 
                            id            = excluded.id           
                           ,object_id     = excluded.object_id    
                           ,parent_obj_id = excluded.parent_obj_id
                           ,change_id     = excluded.change_id    
                           ,region_code   = excluded.region_code  
                           ,area_code     = excluded.area_code    
                           ,city_code     = excluded.city_code    
                           ,place_code    = excluded.place_code   
                           ,plan_code     = excluded.plan_code    
                           ,street_code   = excluded.street_code  
                           ,prev_id       = excluded.prev_id      
                           ,next_id       = excluded.next_id      
                           ,update_date   = excluded.update_date  
                           ,start_date    = excluded.start_date   
                           ,end_date      = excluded.end_date     
                           ,is_active     = excluded.is_active              
          
         WHERE (i.id = excluded.id);                        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_adm_hierarchy (bigint, bigint, bigint, bigint, varchar(4), varchar(4), varchar(4), varchar(4), varchar(4), varchar(4), bigint, bigint, date, date, date, boolean)
     OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_adm_hierarchy (bigint, bigint, bigint, bigint, varchar(4), varchar(4), varchar(4), varchar(4), varchar(4), varchar(4), bigint, bigint, date, date, date, boolean)
      IS 'Сохранение иерархии в адинистративном делении.';
--
--  USE CASE:

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_room_type (bigint, varchar(100), varchar(250), date, date, date, boolean);
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_room_type (bigint, varchar(100), varchar(50), varchar(250), date, date, date, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_room_type (

                         i_id          gar_fias.as_room_type.type_id%TYPE
                        ,i_type_name   gar_fias.as_room_type.type_name%TYPE
                        ,i_short_name  gar_fias.as_room_type.short_name%TYPE
                        ,i_type_desc   gar_fias.as_room_type.type_desc%TYPE
                        ,i_update_date gar_fias.as_room_type.update_date%TYPE
                        ,i_start_date  gar_fias.as_room_type.start_date%TYPE
                        ,i_end_date    gar_fias.as_room_type.end_date%TYPE                       
                        ,i_is_active   gar_fias.as_room_type.is_active%TYPE
                       
) 
    LANGUAGE plpgsql 
    AS $$
    BEGIN
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-11-12 Модификация под загрузчик ГИС Интеграция
    -- ----------------------------------------------------------------------------------------------------  
    --    Сохранение списка типов помещений. 
    -- ====================================================================================================
     INSERT INTO gar_fias.as_room_type AS t (   
                         type_id
                        ,type_name
                        ,short_name
                        ,type_desc
                        ,update_date
                        ,start_date
                        ,end_date                       
                        ,is_active
     )
      VALUES (   
                         i_id         
                        ,i_type_name 
                        ,i_short_name
                        ,i_type_desc  
                        ,i_update_date
                        ,i_start_date 
                        ,i_end_date                       
                        ,i_is_active  
      )
        ON CONFLICT (type_id) DO 
        
                     UPDATE
                            SET  type_name   = excluded.type_name
                                ,short_name  = excluded.short_name
                                ,type_desc   = excluded.type_desc
                                ,update_date = excluded.update_date
                                ,start_date  = excluded.start_date
                                ,end_date    = excluded.end_date                       
                                ,is_active   = excluded.is_active
                                 
                      WHERE (t.type_id = excluded.type_id);                  
   END;          
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_room_type (bigint, varchar(100), varchar(50), varchar(250), date, date, date, boolean)
     OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_room_type (bigint, varchar(100), varchar(50), varchar(250), date, date, date, boolean) 
IS 'Сохранение списка типов помещений';
-- -----------------------------------------------------------------------------------------------------
-- USE CASE:


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_rooms (bigint, bigint, uuid, bigint, varchar(50), bigint, bigint, bigint, bigint, date, date, date, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_rooms (
                            
                          i_id           gar_fias.as_rooms.id%TYPE
                         ,i_object_id    gar_fias.as_rooms.object_id%TYPE
                         ,i_object_guid  gar_fias.as_rooms.object_guid%TYPE
                         ,i_change_id    gar_fias.as_rooms.change_id%TYPE
                         ,i_room_number  gar_fias.as_rooms.room_number%TYPE
                         ,i_room_type    gar_fias.as_rooms.room_type_id%TYPE
                         ,i_oper_type_id gar_fias.as_rooms.oper_type_id%TYPE
                         ,i_prev_id      gar_fias.as_rooms.prev_id%TYPE
                         ,i_next_id      gar_fias.as_rooms.next_id%TYPE
                         ,i_update_date  gar_fias.as_rooms.update_date%TYPE
                         ,i_start_date   gar_fias.as_rooms.start_date%TYPE
                         ,i_end_date     gar_fias.as_rooms.end_date%TYPE
                         ,i_is_actual    gar_fias.as_rooms.is_actual%TYPE
                         ,i_is_active    gar_fias.as_rooms.is_active%TYPE                            
                             
    )                          
    LANGUAGE plpgsql SECURITY DEFINER
          SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    --    Author: Nick Сохранение списка помещений. 
    --    Create date: 2021-11-12 Под загрузчик ГИС Интеграция 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_rooms AS h (
        
                          id
                         ,object_id
                         ,object_guid
                         ,change_id
                         ,room_number
                         ,room_type_id
                         ,oper_type_id
                         ,prev_id
                         ,next_id
                         ,update_date
                         ,start_date
                         ,end_date
                         ,is_actual
                         ,is_active          
        )
          VALUES (
                          i_id           
                         ,i_object_id    
                         ,i_object_guid  
                         ,i_change_id    
                         ,i_room_number  
                         ,i_room_type    
                         ,i_oper_type_id 
                         ,i_prev_id      
                         ,i_next_id      
                         ,i_update_date  
                         ,i_start_date   
                         ,i_end_date     
                         ,i_is_actual    
                         ,i_is_active         
          )
           
         ON CONFLICT (id) DO UPDATE
                SET
                          object_id    = excluded.object_id
                         ,object_guid  = excluded.object_guid
                         ,change_id    = excluded.change_id
                         ,room_number  = excluded.room_number
                         ,room_type_id = excluded.room_type_id
                         ,oper_type_id = excluded.oper_type_id
                         ,prev_id      = excluded.prev_id
                         ,next_id      = excluded.next_id
                         ,update_date  = excluded.update_date
                         ,start_date   = excluded.start_date
                         ,end_date     = excluded.end_date
                         ,is_actual    = excluded.is_actual
                         ,is_active    = excluded.is_active            
         
        WHERE (h.id = excluded.id);           
        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_rooms (bigint, bigint, uuid, bigint, varchar(50), bigint, bigint, bigint, bigint, date, date, date, boolean, boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_rooms (bigint, bigint, uuid, bigint, varchar(50), bigint, bigint, bigint, bigint, date, date, date, boolean, boolean)
  IS 'Сохранение списка помещений';
--
--  USE CASE:



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_rooms_params(bigint, bigint, bigint, bigint, bigint, text, date, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_rooms_params (

                            i_id            gar_fias.as_rooms_params.id%TYPE
                           ,i_object_id     gar_fias.as_rooms_params.object_id%TYPE
                           ,i_change_id     gar_fias.as_rooms_params.change_id%TYPE
                           ,i_change_id_end gar_fias.as_rooms_params.change_id_end%TYPE
                           ,i_type_id       gar_fias.as_rooms_params.type_id%TYPE
                           ,i_value         gar_fias.as_rooms_params.value%TYPE
                           ,i_update_date   gar_fias.as_rooms_params.update_date%TYPE
                           ,i_start_date    gar_fias.as_rooms_params.start_date%TYPE
                           ,i_end_date      gar_fias.as_rooms_params.end_date%TYPE
                           
) LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick Сохранение параметров помещения
    -- Create date: 2021-11-12 Под загрузчик ГИС Интеграция
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_rooms_params AS i (
                                                        id           
                                                       ,object_id    
                                                       ,change_id    
                                                       ,change_id_end
                                                       ,type_id      
                                                       ,value        
                                                       ,update_date  
                                                       ,start_date   
                                                       ,end_date     
        )
         VALUES (
                     i_id            
                    ,i_object_id     
                    ,i_change_id     
                    ,i_change_id_end 
                    ,i_type_id       
                    ,i_value         
                    ,i_update_date   
                    ,i_start_date    
                    ,i_end_date      
         )
          ON CONFLICT (id) DO UPDATE  
                         SET
                                 object_id     = excluded.object_id        
                                ,change_id     = excluded.change_id    
                                ,change_id_end = excluded.change_id_end
                                ,type_id       = excluded.type_id      
                                ,value         = excluded.value    
                                ,update_date   = excluded.update_date  
                                ,start_date    = excluded.start_date   
                                ,end_date      = excluded.end_date     
          
                  WHERE (i.id = excluded.id);           
        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_rooms_params (bigint,bigint,bigint,bigint,bigint,text,date,date,date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_rooms_params (bigint,bigint,bigint,bigint,bigint,text,date,date,date) 
     IS 'Сохранение параметров помещения';
--
--  USE CASE:


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_norm_docs_kinds (bigint, varchar(500));
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_norm_docs_kinds (

                       i_id        gar_fias.as_norm_docs_kinds.doc_kind_id%TYPE
                      ,i_doc_name  gar_fias.as_norm_docs_kinds.doc_name%TYPE                     
                             
)  LANGUAGE plpgsql SECURITY DEFINER

    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    --   Author: Nick Сохранение списка видов документов
    --   Create date: 2021-11-11
    --   Updates:  2021-11-02 Модификация под загрузчик ГИС Интеграция.
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_norm_docs_kinds AS a (  
                      doc_kind_id
                     ,doc_name   
                   )
          VALUES (    i_id         
                     ,i_doc_name   
          )
             ON CONFLICT (doc_kind_id) DO UPDATE
           
                        SET 
                            doc_name   = excluded.doc_name 
                           
              WHERE (a.doc_kind_id = excluded.doc_kind_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_norm_docs_kinds (bigint, varchar(500)) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_norm_docs_kinds (bigint, varchar(500)) IS 'Сохранение списка нормативных документов';
--
--  USE CASE:
--

     

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_norm_docs_types (bigint, varchar(500), date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_norm_docs_types (
                      i_id         gar_fias.as_norm_docs_types.doc_type_id%TYPE
                     ,i_doc_name   gar_fias.as_norm_docs_types.doc_name%TYPE
                     ,i_start_date gar_fias.as_norm_docs_types.start_date%TYPE
                     ,i_end_date   gar_fias.as_norm_docs_types.end_date%TYPE                             
                             
)  LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-05
    -- Updates:  2021-11-02 Модификация под загрузчик ГИС Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --    Сохранение списка нормативных документов. 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_norm_docs_types AS a (  
                      doc_type_id
                     ,doc_name   
                     ,start_date 
                     ,end_date          
                   )
          VALUES (    i_id         
                     ,i_doc_name   
                     ,i_start_date 
                     ,i_end_date       
         )
           ON CONFLICT (doc_type_id) DO UPDATE
           
                        SET 
                            doc_name   = excluded.doc_name 
                           ,start_date = excluded.start_date 
                           ,end_date   = excluded.end_date 
                            
                WHERE (a.doc_type_id = excluded.doc_type_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_norm_docs_types (bigint, varchar(500), date, date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_norm_docs_types (bigint, varchar(500), date, date) IS 'Сохранение списка нормативных документов';
--
--  USE CASE:
--

     

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_param_type (bigint, varchar(50), varchar(250), varchar(250), boolean, date, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_param_type (
                              i_id             gar_fias.as_param_type.type_id%TYPE
                             ,i_type_name      gar_fias.as_param_type.type_name%TYPE
                             ,i_type_desc      gar_fias.as_param_type.type_desc%TYPE
                             ,i_type_code      gar_fias.as_param_type.type_code%TYPE
                             ,i_is_active      gar_fias.as_param_type.is_active%TYPE
                             ,i_update_date    gar_fias.as_param_type.update_date%TYPE
                             ,i_start_date     gar_fias.as_param_type.start_date%TYPE
                             ,i_end_date       gar_fias.as_param_type.end_date%TYPE    
                             
)  LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick  Сохранение списка типов параметров.
    -- Create date: 2021-11-11 Под загрузчик ГИС Интеграция.
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_param_type AS a (  type_id 
                                                  ,type_name 
                                                  ,type_code 
                                                  ,type_desc 
                                                  ,update_date 
                                                  ,start_date 
                                                  ,end_date 
                                                  ,is_active         
                   )
          VALUES (    i_id             
                     ,i_type_name      
                     ,i_type_code 
                     ,i_type_desc      
                     ,i_update_date    
                     ,i_start_date     
                     ,i_end_date       
                     ,i_is_active          
         )
           ON CONFLICT (type_id) DO UPDATE
           
                        SET  type_name    = excluded.type_name      
                            ,type_code    = excluded.type_code 
                            ,type_desc    = excluded.type_desc     
                            ,update_date  = excluded.update_date    
                            ,start_date   = excluded.start_date     
                            ,end_date     = excluded.end_date       
                            ,is_active    = excluded.is_active 
                            
                WHERE (a.type_id = excluded.type_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_param_type (bigint, varchar(50), varchar(250), varchar(250), boolean, date, date, date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_param_type (bigint, varchar(50), varchar(250), varchar(250), boolean, date, date, date) 
    IS 'Сохранение списка признаков владений (типов домов)';
--
--  USE CASE:
--


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_houses_params(bigint, bigint, bigint, bigint, bigint, text, date, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_houses_params (

                            i_id            gar_fias.as_houses_params.id%TYPE
                           ,i_object_id     gar_fias.as_houses_params.object_id%TYPE
                           ,i_change_id     gar_fias.as_houses_params.change_id%TYPE
                           ,i_change_id_end gar_fias.as_houses_params.change_id_end%TYPE
                           ,i_type_id       gar_fias.as_houses_params.type_id%TYPE
                           ,i_value         gar_fias.as_houses_params.value%TYPE
                           ,i_update_date   gar_fias.as_houses_params.update_date%TYPE
                           ,i_start_date    gar_fias.as_houses_params.start_date%TYPE
                           ,i_end_date      gar_fias.as_houses_params.end_date%TYPE
                           
) LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick Сохранение параметров строения
    -- Create date: 2021-11-11 Под загрузчик ГИС Интеграция
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_houses_params AS i (
                                                        id           
                                                       ,object_id    
                                                       ,change_id    
                                                       ,change_id_end
                                                       ,type_id      
                                                       ,value        
                                                       ,update_date  
                                                       ,start_date   
                                                       ,end_date     
        )
         VALUES (
                     i_id            
                    ,i_object_id     
                    ,i_change_id     
                    ,i_change_id_end 
                    ,i_type_id       
                    ,i_value         
                    ,i_update_date   
                    ,i_start_date    
                    ,i_end_date      
         )
          ON CONFLICT (id) DO UPDATE  
                         SET
                                 object_id     = excluded.object_id        
                                ,change_id     = excluded.change_id    
                                ,change_id_end = excluded.change_id_end
                                ,type_id       = excluded.type_id      
                                ,value         = excluded.value    
                                ,update_date   = excluded.update_date  
                                ,start_date    = excluded.start_date   
                                ,end_date      = excluded.end_date     
          
                  WHERE (i.id = excluded.id);           
        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_houses_params (bigint,bigint,bigint,bigint,bigint,text,date,date,date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_houses_params (bigint,bigint,bigint,bigint,bigint,text,date,date,date) 
     IS 'Сохранение параметров строения';
--
--  USE CASE:


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_carplaces_params (bigint, bigint, bigint, bigint, bigint, varchar(100), date, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_carplaces_params (

                            i_id            gar_fias.as_carplaces_params.id%TYPE
                           ,i_object_id     gar_fias.as_carplaces_params.object_id%TYPE
                           ,i_change_id     gar_fias.as_carplaces_params.change_id%TYPE
                           ,i_change_id_end gar_fias.as_carplaces_params.change_id_end%TYPE
                           ,i_type_id       gar_fias.as_carplaces_params.type_id%TYPE
                           ,i_value         gar_fias.as_carplaces_params.param_value%TYPE
                           ,i_update_date   gar_fias.as_carplaces_params.update_date%TYPE
                           ,i_start_date    gar_fias.as_carplaces_params.start_date%TYPE
                           ,i_end_date      gar_fias.as_carplaces_params.end_date%TYPE
                                   
) LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick   Сохранение параметров машиноместа
    -- Create date: 2021-11-11 Под загрузчик ГИС Интеграция
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_carplaces_params AS i (
                                                        id           
                                                       ,object_id    
                                                       ,change_id    
                                                       ,change_id_end
                                                       ,type_id      
                                                       ,param_value        
                                                       ,update_date  
                                                       ,start_date   
                                                       ,end_date     
        )
         VALUES (
                     i_id            
                    ,i_object_id     
                    ,i_change_id     
                    ,i_change_id_end 
                    ,i_type_id       
                    ,i_value         
                    ,i_update_date   
                    ,i_start_date    
                    ,i_end_date      
         )
          ON CONFLICT (id) DO UPDATE  
                         SET
                                 object_id     = excluded.object_id        
                                ,change_id     = excluded.change_id    
                                ,change_id_end = excluded.change_id_end
                                ,type_id       = excluded.type_id      
                                ,param_value   = excluded.param_value    
                                ,update_date   = excluded.update_date  
                                ,start_date    = excluded.start_date   
                                ,end_date      = excluded.end_date     
          
                  WHERE (i.id = excluded.id);           
        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_carplaces_params (bigint, bigint, bigint, bigint, bigint, varchar(100), date, date, date) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_carplaces_params (bigint, bigint, bigint, bigint, bigint, varchar(100), date, date, date) 
      IS 'Сохранение параметров машиноместа';
--
--  USE CASE:



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_carplaces (bigint, bigint, uuid, bigint, character varying, bigint, bigint, bigint, date, date, date, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_carplaces (
                         i_id              gar_fias.as_carplaces.id%TYPE
                        ,i_object_id       gar_fias.as_carplaces.object_id%TYPE
                        ,i_object_guid     gar_fias.as_carplaces.object_guid%TYPE
                        ,i_change_id       gar_fias.as_carplaces.change_id%TYPE
                        ,i_carplace_number gar_fias.as_carplaces.carplace_number%TYPE
                        ,i_oper_type_id    gar_fias.as_carplaces.oper_type_id%TYPE
                        ,i_prev_id         gar_fias.as_carplaces.prev_id%TYPE
                        ,i_next_id         gar_fias.as_carplaces.next_id%TYPE
                        ,i_update_date     gar_fias.as_carplaces.update_date%TYPE
                        ,i_start_date      gar_fias.as_carplaces.start_date%TYPE
                        ,i_end_date        gar_fias.as_carplaces.end_date%TYPE
                        ,i_is_actual       gar_fias.as_carplaces.is_actual%TYPE
                        ,i_is_active       gar_fias.as_carplaces.is_active%TYPE
    )                          
    LANGUAGE plpgsql SECURITY DEFINER
          SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    --  Author: Nick
    --  Create date: 2021-11-03 Под загрузчик ГИС Интеграция
    -- ----------------------------------------------------------------------------------------------------  
    --                 Сохранение списка машиномест. 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_carplaces AS c (
                         id
                        ,object_id
                        ,object_guid
                        ,change_id
                        ,carplace_number
                        ,oper_type_id
                        ,prev_id
                        ,next_id
                        ,update_date
                        ,start_date
                        ,end_date
                        ,is_actual
                        ,is_active     
        )
          VALUES (
                         i_id             
                        ,i_object_id      
                        ,i_object_guid    
                        ,i_change_id      
                        ,i_carplace_number
                        ,i_oper_type_id   
                        ,i_prev_id        
                        ,i_next_id        
                        ,i_update_date    
                        ,i_start_date     
                        ,i_end_date       
                        ,i_is_actual      
                        ,i_is_active      
          )
           
         ON CONFLICT (id) DO UPDATE
                SET
                         object_id       = excluded.object_id
                        ,object_guid     = excluded.object_guid
                        ,change_id       = excluded.change_id
                        ,carplace_number = excluded.carplace_number
                        ,oper_type_id    = excluded.oper_type_id
                        ,prev_id         = excluded.prev_id
                        ,next_id         = excluded.next_id
                        ,update_date     = excluded.update_date
                        ,start_date      = excluded.start_date
                        ,end_date        = excluded.end_date
                        ,is_actual       = excluded.is_actual
                        ,is_active       = excluded.is_active                
         
        WHERE (c.id = excluded.id);           
        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_carplaces (bigint, bigint, uuid, bigint, character varying, bigint, bigint, bigint, date, date, date, boolean, boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_carplaces (bigint, bigint, uuid, bigint, character varying, bigint, bigint, bigint, date, date, date, boolean, boolean) 
   IS 'Сохранение списка машиномест';
--
--  USE CASE:



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_apartments_params(bigint, bigint, bigint, bigint, bigint, text, date, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_apartments_params (

                            i_id            gar_fias.as_apartments_params.id%TYPE
                           ,i_object_id     gar_fias.as_apartments_params.object_id%TYPE
                           ,i_change_id     gar_fias.as_apartments_params.change_id%TYPE
                           ,i_change_id_end gar_fias.as_apartments_params.change_id_end%TYPE
                           ,i_type_id       gar_fias.as_apartments_params.type_id%TYPE
                           ,i_value         gar_fias.as_apartments_params.param_value%TYPE
                           ,i_update_date   gar_fias.as_apartments_params.update_date%TYPE
                           ,i_start_date    gar_fias.as_apartments_params.start_date%TYPE
                           ,i_end_date      gar_fias.as_apartments_params.end_date%TYPE
                           
) LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-11-10 Под загрузчик ГИС Интеграция
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_apartments_params AS i (
                                                        id           
                                                       ,object_id    
                                                       ,change_id    
                                                       ,change_id_end
                                                       ,type_id      
                                                       ,param_value        
                                                       ,update_date  
                                                       ,start_date   
                                                       ,end_date     
        )
         VALUES (
                     i_id            
                    ,i_object_id     
                    ,i_change_id     
                    ,i_change_id_end 
                    ,i_type_id       
                    ,i_value         
                    ,i_update_date   
                    ,i_start_date    
                    ,i_end_date      
         )
          ON CONFLICT (id) DO UPDATE  
                         SET
                                 object_id     = excluded.object_id        
                                ,change_id     = excluded.change_id    
                                ,change_id_end = excluded.change_id_end
                                ,type_id       = excluded.type_id      
                                ,param_value   = excluded.param_value    
                                ,update_date   = excluded.update_date  
                                ,start_date    = excluded.start_date   
                                ,end_date      = excluded.end_date     
          
                  WHERE (i.id = excluded.id);           
        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_apartments_params (bigint,bigint,bigint,bigint,bigint,text,date,date,date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_apartments_params (bigint,bigint,bigint,bigint,bigint,text,date,date,date) 
     IS 'Сохраненеие параметров помещения';
--
--  USE CASE:


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_apartment_type (bigint, varchar(100), varchar(50), varchar(250), boolean, date, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_apartment_type (
                              i_id             gar_fias.as_apartment_type.apart_type_id%TYPE
                             ,i_type_name      gar_fias.as_apartment_type.type_name%TYPE
                             ,i_type_shortname gar_fias.as_apartment_type.type_shortname%TYPE
                             ,i_type_desc      gar_fias.as_apartment_type.type_desc%TYPE
                             ,i_is_active      gar_fias.as_apartment_type.is_active%TYPE
                             ,i_update_date    gar_fias.as_apartment_type.update_date%TYPE
                             ,i_start_date     gar_fias.as_apartment_type.start_date%TYPE
                             ,i_end_date       gar_fias.as_apartment_type.end_date%TYPE                     

)  LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-05
    -- Updates:  2021-11-02 Модификация под загрузчик ГИС Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --       Сохранение списка типов помещений. 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_apartment_type AS a (
                                                   apart_type_id 
                                                  ,type_name 
                                                  ,type_shortname 
                                                  ,type_desc 
                                                  ,update_date 
                                                  ,start_date 
                                                  ,end_date 
                                                  ,is_active         
                   )
          VALUES (    i_id             
                     ,i_type_name      
                     ,i_type_shortname 
                     ,i_type_desc      
                     ,i_update_date    
                     ,i_start_date     
                     ,i_end_date       
                     ,i_is_active          
         )
           ON CONFLICT (apart_type_id) DO UPDATE
                        SET  type_name      = excluded.type_name      
                            ,type_shortname = excluded.type_shortname 
                            ,type_desc      = excluded.type_desc    
                            ,update_date    = excluded.update_date    
                            ,start_date     = excluded.start_date     
                            ,end_date       = excluded.end_date       
                            ,is_active      = excluded.is_active                
                WHERE (a.apart_type_id = excluded.apart_type_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_apartment_type (bigint, varchar(100), varchar(50), varchar(250), boolean, date, date, date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_apartment_type (bigint, varchar(100), varchar(50), varchar(250), boolean, date, date, date) 
    IS 'Сохранение списка типов помещений';
--
--  USE CASE:
--

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_house_type (bigint, character varying, character varying, character varying, boolean, date, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_house_type (
                              i_id             gar_fias.as_house_type.house_type_id%TYPE
                             ,i_type_name      gar_fias.as_house_type.type_name%TYPE
                             ,i_type_shortname gar_fias.as_house_type.type_shortname%TYPE
                             ,i_type_desc      gar_fias.as_house_type.type_descr%TYPE
                             ,i_is_active      gar_fias.as_house_type.is_active%TYPE
                             ,i_update_date    gar_fias.as_house_type.update_date%TYPE
                             ,i_start_date     gar_fias.as_house_type.start_date%TYPE
                             ,i_end_date       gar_fias.as_house_type.end_date%TYPE                     

)  LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-05
    -- Updates:  2021-11-02 Модификация под загрузчик ГИС Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --    Сохранение списка признаков владения (типов домов). 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_house_type AS a (  house_type_id 
                                                  ,type_name 
                                                  ,type_shortname 
                                                  ,type_descr 
                                                  ,update_date 
                                                  ,start_date 
                                                  ,end_date 
                                                  ,is_active         
                   )
          VALUES (    i_id             
                     ,i_type_name      
                     ,i_type_shortname 
                     ,i_type_desc      
                     ,i_update_date    
                     ,i_start_date     
                     ,i_end_date       
                     ,i_is_active          
         )
           ON CONFLICT (house_type_id) DO UPDATE
                        SET  type_name      = excluded.type_name      
                            ,type_shortname = excluded.type_shortname 
                            ,type_descr     = excluded.type_descr     
                            ,update_date    = excluded.update_date    
                            ,start_date     = excluded.start_date     
                            ,end_date       = excluded.end_date       
                            ,is_active      = excluded.is_active                
                WHERE (a.house_type_id = excluded.house_type_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_house_type (bigint, character varying, character varying, character varying, boolean, date, date, date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_house_type (bigint, character varying, character varying, character varying, boolean, date, date, date) 
    IS 'Сохранение списка признаков владений (типов домов)';
--
--  USE CASE:
--

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_addr_obj_division (bigint, bigint, bigint, bigint);

CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_division (
                             i_id        gar_fias.as_addr_obj_division.id%TYPE
                            ,i_parent_id gar_fias.as_addr_obj_division.parent_id%TYPE
                            ,i_child_id  gar_fias.as_addr_obj_division.child_id%TYPE
                            ,i_change_id gar_fias.as_addr_obj_division.change_id%TYPE
) 
    LANGUAGE plpgsql
    
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-11  Под загрузчик ГИС-Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --                  Сохранение списка переподчинения адресных объектов.
    -- ====================================================================================================
    BEGIN
	   INSERT INTO gar_fias.as_addr_obj_division AS d (
                             id        
                            ,parent_id 
                            ,child_id  
                            ,change_id     
       )
        VALUES (     i_id        
                    ,i_parent_id 
                    ,i_child_id  
                    ,i_change_id    
        )
        ON CONFLICT (id) DO
        
             UPDATE   SET    parent_id = excluded.parent_id
                            ,child_id  = excluded.child_id 
                            ,change_id = excluded.change_id     
    
              WHERE (d.id = excluded.id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_division (bigint, bigint, bigint, bigint) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_division (bigint, bigint, bigint, bigint) 
   IS 'Сохранение списка переподчинения адресных объектов.';
--
--  USE CASE:

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_steads_params (bigint, bigint, bigint, bigint, bigint, text, date, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_steads_params (
                  i_id            gar_fias.as_steads_params.id%TYPE
                 ,i_object_id     gar_fias.as_steads_params.object_id%TYPE
                 ,i_change_id     gar_fias.as_steads_params.change_id%TYPE
                 ,i_change_id_end gar_fias.as_steads_params.change_id_end%TYPE
                 ,i_type_id       gar_fias.as_steads_params.type_id%TYPE
                 ,i_value         gar_fias.as_steads_params.type_value%TYPE
                 ,i_update_date   gar_fias.as_steads_params.update_date%TYPE
                 ,i_start_date    gar_fias.as_steads_params.start_date%TYPE
                 ,i_end_date      gar_fias.as_steads_params.end_date%TYPE
) 
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-13
    --  2021_11_08 Модификация под загрузчик/парсер ГИС Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --    Сохранение списка параметров земельных участков.
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_steads_params AS p (
        
                  id
                 ,object_id
                 ,change_id
                 ,change_id_end
                 ,type_id
                 ,type_value
                 ,update_date
                 ,start_date
                 ,end_date
        )
          VALUES (
                  i_id            
                 ,i_object_id     
                 ,i_change_id     
                 ,i_change_id_end 
                 ,i_type_id       
                 ,i_value         
                 ,i_update_date   
                 ,i_start_date    
                 ,i_end_date      
          )           
         ON CONFLICT (id) DO UPDATE
             SET 
                  id            = excluded.id
                 ,object_id     = excluded.object_id
                 ,change_id     = excluded.change_id
                 ,change_id_end = excluded.change_id_end
                 ,type_id       = excluded.type_id
                 ,type_value    = excluded.type_value
                 ,update_date   = excluded.update_date
                 ,start_date    = excluded.start_date
                 ,end_date      = excluded.end_date
             
             WHERE (p.id = excluded.id);           
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_steads_params (bigint, bigint, bigint, bigint, bigint, text, date, date, date) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_steads_params (bigint, bigint, bigint, bigint, bigint, text, date, date, date) 
            IS 'Сохранение списка параметров земельных участков';
--
--  USE CASE:



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_steads (bigint, bigint, uuid, bigint, varchar(250), bigint, bigint, bigint, date, date, date, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_steads (
                           i_id            gar_fias.as_steads.id%TYPE
                          ,i_object_id     gar_fias.as_steads.object_id%TYPE
                          ,i_object_guid   gar_fias.as_steads.object_guid%TYPE
                          ,i_change_id     gar_fias.as_steads.change_id%TYPE
                          ,i_steads_number gar_fias.as_steads.steads_number%TYPE
                          ,i_oper_type_id  gar_fias.as_steads.oper_type_id%TYPE
                          ,i_prev_id       gar_fias.as_steads.prev_id%TYPE
                          ,i_next_id       gar_fias.as_steads.next_id%TYPE
                          ,i_update_date   gar_fias.as_steads.update_date%TYPE
                          ,i_start_date    gar_fias.as_steads.start_date%TYPE
                          ,i_end_date      gar_fias.as_steads.end_date%TYPE
                          ,i_is_actual     gar_fias.as_steads.is_actual%TYPE
                          ,i_is_active     gar_fias.as_steads.is_active%TYPE
) 
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-13
    --   2021-11-08 Модификация под загрузчик ГИС Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --   Сохранение списка земельных участков.
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_steads AS s (   id            
                                               ,object_id     
                                               ,object_guid   
                                               ,change_id     
                                               ,steads_number 
                                               ,oper_type_id  
                                               ,prev_id       
                                               ,next_id       
                                               ,update_date   
                                               ,start_date    
                                               ,end_date      
                                               ,is_actual     
                                               ,is_active     
        )
         VALUES (    i_id           
                    ,i_object_id    
                    ,i_object_guid  
                    ,i_change_id    
                    ,i_steads_number
                    ,i_oper_type_id 
                    ,i_prev_id      
                    ,i_next_id      
                    ,i_update_date  
                    ,i_start_date   
                    ,i_end_date     
                    ,i_is_actual    
                    ,i_is_active    
         )
         ON CONFLICT (id) DO UPDATE
            SET  
                           object_id     = excluded.object_id
                          ,object_guid   = excluded.object_guid
                          ,change_id     = excluded.change_id
                          ,steads_number = excluded.steads_number
                          ,oper_type_id  = excluded.oper_type_id
                          ,prev_id       = excluded.prev_id
                          ,next_id       = excluded.next_id
                          ,update_date   = excluded.update_date
                          ,start_date    = excluded.start_date
                          ,end_date      = excluded.end_date
                          ,is_actual     = excluded.is_actual
                          ,is_active     = excluded.is_active
            
            WHERE (s.id = excluded.id);           
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_steads (bigint, bigint, uuid, bigint, varchar(250), bigint, bigint, bigint, date, date, date, boolean, boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_steads (bigint, bigint, uuid, bigint, varchar(250), bigint, bigint, bigint, date, date, date, boolean, boolean)
 IS 'Сохранение списка земельных участков';
--
--  USE CASE:
 
 
 
 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_reestr_objects (bigint, uuid, bigint, boolean, bigint, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_reestr_objects (
                                  i_object_id    gar_fias.as_reestr_objects.object_id%TYPE
                                 ,i_object_guid  gar_fias.as_reestr_objects.object_guid%TYPE
                                 ,i_change_id    gar_fias.as_reestr_objects.change_id%TYPE
                                 ,i_is_active    gar_fias.as_reestr_objects.is_active%TYPE
                                 ,i_level_id     gar_fias.as_reestr_objects.level_id%TYPE
                                 ,i_create_date  gar_fias.as_reestr_objects.create_date%TYPE
                                 ,i_update_date  gar_fias.as_reestr_objects.update_date%TYPE
) 
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-05
    --   2021-11-08 Модификация пол загрузчик ГАР ФИАС.
    -- ----------------------------------------------------------------------------------------------------  
    -- Сохранение реестра адресных элементов. 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_reestr_objects AS r (
                                       object_id   
                                      ,object_guid 
                                      ,change_id   
                                      ,is_active   
                                      ,level_id    
                                      ,create_date 
                                      ,update_date        
        )
          VALUES (     i_object_id  
                      ,i_object_guid
                      ,i_change_id  
                      ,i_is_active  
                      ,i_level_id   
                      ,i_create_date
                      ,i_update_date          
          )
           ON CONFLICT (object_id) DO 
           
             UPDATE   SET   object_guid  = excluded.object_guid
                           ,change_id    = excluded.change_id
                           ,is_active    = excluded.is_active
                           ,level_id     = excluded.level_id
                           ,create_date  = excluded.create_date
                           ,update_date  = excluded.update_date 
                           
             WHERE (r.object_id = excluded.object_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_reestr_objects (bigint, uuid, bigint, boolean, bigint, date, date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_reestr_objects (bigint, uuid, bigint, boolean, bigint, date, date) 
      IS 'Сохранение реестра адресных элементов.';
--
--  USE CASE:



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_operation_type (bigint, varchar(100), varchar(100), varchaR(250), date, date, date, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_operation_type (
                        i_oper_type_id    gar_fias.as_operation_type.oper_type_id%TYPE
                       ,i_oper_type_name  gar_fias.as_operation_type.oper_type_name%TYPE
                       ,i_short_name      gar_fias.as_operation_type.short_name%TYPE
                       ,i_descr           gar_fias.as_operation_type.descr%TYPE
                       ,i_update_date     gar_fias.as_operation_type.update_date%TYPE
                       ,i_start_date      gar_fias.as_operation_type.start_date%TYPE
                       ,i_end_date        gar_fias.as_operation_type.end_date%TYPE
                       ,i_is_active       gar_fias.as_operation_type.is_active%TYPE
) 
    LANGUAGE plpgsql 
    AS $$
    BEGIN
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-04
    -- Updates:  2021-11-08 Модификация под загрузчик ГИС Интеграция    
    -- ----------------------------------------------------------------------------------------------------  
    -- Сохранение списка статусов действий. 
     -- ====================================================================================================
     INSERT INTO gar_fias.as_operation_type AS t(  oper_type_id   
                                                  ,oper_type_name 
                                                  ,short_name     
                                                  ,descr          
                                                  ,update_date    
                                                  ,start_date     
                                                  ,end_date       
                                                  ,is_active         
     )
      VALUES (   i_oper_type_id
                ,i_oper_type_name
                ,i_short_name
                ,i_descr
                ,i_update_date
                ,i_start_date
                ,i_end_date
                ,i_is_active
      )
        ON CONFLICT (oper_type_id) DO 
                     UPDATE
                            SET   oper_type_name = excluded.oper_type_name
                                 ,short_name     = excluded.short_name    
                                 ,descr          = excluded.descr         
                                 ,update_date    = excluded.update_date   
                                 ,start_date     = excluded.start_date    
                                 ,end_date       = excluded.end_date      
                                 ,is_active      = excluded.is_active 
                                 
                      WHERE (t.oper_type_id = excluded.oper_type_id);                  
   END;          
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_operation_type (bigint, varchar(100), varchar(100), varchaR(250), date, date, date, boolean)
     OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_operation_type (bigint, varchar(100), varchar(100), varchaR(250), date, date, date, boolean) 
IS 'Сохранение списка статусов действий';
-- -----------------------------------------------------------------------------------------------------
-- USE CASE:

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_object_level (bigint, varchar(100), varchar(50), date, date, date, boolean);

CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_object_level (
                           i_level_id     gar_fias.as_object_level.level_id%TYPE
                          ,i_level_name   gar_fias.as_object_level.level_name%TYPE
                          ,i_short_name   gar_fias.as_object_level.short_name%TYPE                          
                          ,i_update_date  gar_fias.as_object_level.update_date%TYPE
                          ,i_start_date   gar_fias.as_object_level.start_date%TYPE
                          ,i_end_date     gar_fias.as_object_level.end_date%TYPE
                          ,i_is_active    gar_fias.as_object_level.is_active%TYPE
) 
    LANGUAGE plpgsql
    
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-05
    --    2021-11-08 -- 
    --      Модификация под загрузчик ГИС-Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --  Сохранение списка уровней адресных объектов. 
    -- ====================================================================================================
    BEGIN
	   INSERT INTO gar_fias.as_object_level AS l (
                                level_id   
                               ,level_name 
                               ,short_name  
                               ,update_date
                               ,start_date 
                               ,end_date   
                               ,is_active       
       )
        VALUES (   i_level_id    
                  ,i_level_name  
                  ,i_short_name                          
                  ,i_update_date 
                  ,i_start_date  
                  ,i_end_date    
                  ,i_is_active        
        )
        ON CONFLICT (level_id) DO
        
             UPDATE   SET                    
                           level_name   = excluded.level_name 
                          ,short_name   = excluded.short_name 
                          ,update_date  = excluded.update_date
                          ,start_date   = excluded.start_date 
                          ,end_date     = excluded.end_date   
                          ,is_active    = excluded.is_active     
    
              WHERE (l.level_id = excluded.level_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_object_level (bigint, varchar(100), varchar(50), date, date, date, boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_object_level (bigint, varchar(100), varchar(50), date, date, date, boolean) IS 'Сохранение списка уровней адресных объектов.';
--
--  USE CASE:

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_mun_hierarchy (bigint, bigint, bigint, bigint, character varying, bigint, bigint, date, date, date, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_mun_hierarchy (
                               i_id            gar_fias.as_mun_hierarchy.id%TYPE
                              ,i_object_id     gar_fias.as_mun_hierarchy.object_id%TYPE
                              ,i_parent_obj_id gar_fias.as_mun_hierarchy.parent_obj_id%TYPE
                              ,i_change_id     gar_fias.as_mun_hierarchy.change_id%TYPE
                              ,i_oktmo         gar_fias.as_mun_hierarchy.oktmo%TYPE
                              ,i_prev_id       gar_fias.as_mun_hierarchy.prev_id%TYPE
                              ,i_next_id       gar_fias.as_mun_hierarchy.next_id%TYPE
                              ,i_update_date   gar_fias.as_mun_hierarchy.update_date%TYPE
                              ,i_start_date    gar_fias.as_mun_hierarchy.start_date%TYPE
                              ,i_end_date      gar_fias.as_mun_hierarchy.end_date%TYPE
                              ,i_is_active     gar_fias.as_mun_hierarchy.is_active%TYPE
) 
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-07
    --  Updates:  2021-11-03 Модификация под загрузчик ГИС Интеграци    
    -- ----------------------------------------------------------------------------------------------------  
    --  Сохранение данных об иерархии в муниципальном делении. 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_mun_hierarchy AS i (
                               id           
                              ,object_id    
                              ,parent_obj_id
                              ,change_id    
                              ,oktmo        
                              ,prev_id      
                              ,next_id      
                              ,update_date  
                              ,start_date   
                              ,end_date     
                              ,is_active    
        ) 
          VALUES (
                    i_id           
                   ,i_object_id    
                   ,i_parent_obj_id
                   ,i_change_id    
                   ,i_oktmo        
                   ,i_prev_id      
                   ,i_next_id      
                   ,i_update_date  
                   ,i_start_date   
                   ,i_end_date     
                   ,i_is_active    
           )
             ON CONFLICT (id) DO UPDATE
                    SET
                         id            = excluded.id           
                        ,object_id     = excluded.object_id    
                        ,parent_obj_id = excluded.parent_obj_id
                        ,change_id     = excluded.change_id    
                        ,oktmo         = excluded.oktmo        
                        ,prev_id       = excluded.prev_id      
                        ,next_id       = excluded.next_id      
                        ,update_date   = excluded.update_date  
                        ,start_date    = excluded.start_date   
                        ,end_date      = excluded.end_date     
                        ,is_active     = excluded.is_active    

                WHERE (i.id = excluded.id);           
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_mun_hierarchy (bigint, bigint, bigint, bigint, character varying, bigint, bigint, date, date, date, boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_mun_hierarchy (bigint, bigint, bigint, bigint, character varying, bigint, bigint, date, date, date, boolean) 
   IS 'Сохранение данных об иерархии в муниципальном делении.';
--
--  USE CASE:
--------------------------------------------------------------------------------------------------------------------------------------



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_houses(bigint, bigint, uuid, bigint, character varying, character varying, character varying, bigint, bigint, bigint, bigint, bigint, bigint, date, date, date, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_houses (
                              i_id           gar_fias.as_houses.id%TYPE
                             ,i_object_id    gar_fias.as_houses.object_id%TYPE
                             ,i_object_guid  gar_fias.as_houses.object_guid%TYPE
                             ,i_change_id    gar_fias.as_houses.change_id%TYPE
                             ,i_house_num    gar_fias.as_houses.house_num%TYPE
                             ,i_add_num1     gar_fias.as_houses.add_num1%TYPE
                             ,i_add_num2     gar_fias.as_houses.add_num2%TYPE
                             ,i_house_type   gar_fias.as_houses.house_type%TYPE
                             ,i_add_type1    gar_fias.as_houses.add_type1%TYPE
                             ,i_add_type2    gar_fias.as_houses.add_type2%TYPE
                             ,i_oper_type_id gar_fias.as_houses.oper_type_id%TYPE
                             ,i_prev_id      gar_fias.as_houses.prev_id%TYPE
                             ,i_next_id      gar_fias.as_houses.next_id%TYPE
                             ,i_update_date  gar_fias.as_houses.update_date%TYPE
                             ,i_start_date   gar_fias.as_houses.start_date%TYPE
                             ,i_end_date     gar_fias.as_houses.end_date%TYPE
                             ,i_is_actual    gar_fias.as_houses.is_actual%TYPE
                             ,i_is_active    gar_fias.as_houses.is_active%TYPE 
    )                          
    LANGUAGE plpgsql SECURITY DEFINER
          SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    --  Author: Nick
    --  Create date: 2021-10-13
    --  Updates:  2021-11-03 Модификация под загрузчик ГИС Интеграция    
    -- ----------------------------------------------------------------------------------------------------  
    --  Сохранение списка домов. 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_houses AS h (
                              id
                             ,object_id
                             ,object_guid
                             ,change_id
                             ,house_num
                             ,add_num1
                             ,add_num2
                             ,house_type
                             ,add_type1
                             ,add_type2
                             ,oper_type_id
                             ,prev_id
                             ,next_id
                             ,update_date
                             ,start_date
                             ,end_date
                             ,is_actual
                             ,is_active         
        )
          VALUES (
                     i_id           
                    ,i_object_id    
                    ,i_object_guid  
                    ,i_change_id    
                    ,i_house_num    
                    ,i_add_num1     
                    ,i_add_num2     
                    ,i_house_type   
                    ,i_add_type1    
                    ,i_add_type2    
                    ,i_oper_type_id 
                    ,i_prev_id      
                    ,i_next_id      
                    ,i_update_date  
                    ,i_start_date   
                    ,i_end_date     
                    ,i_is_actual    
                    ,i_is_active        
          )
           
         ON CONFLICT (id) DO UPDATE
                SET
                     object_id    = excluded.object_id
                    ,object_guid  = excluded.object_guid
                    ,change_id    = excluded.change_id
                    ,house_num    = excluded.house_num
                    ,add_num1     = excluded.add_num1
                    ,add_num2     = excluded.add_num2
                    ,house_type   = excluded.house_type
                    ,add_type1    = excluded.add_type1
                    ,add_type2    = excluded.add_type2
                    ,oper_type_id = excluded.oper_type_id
                    ,prev_id      = excluded.prev_id
                    ,next_id      = excluded.next_id
                    ,update_date  = excluded.update_date
                    ,start_date   = excluded.start_date
                    ,end_date     = excluded.end_date
                    ,is_actual    = excluded.is_actual
                    ,is_active    = excluded.is_active                 
         
        WHERE (h.id = excluded.id);           
        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_houses(bigint, bigint, uuid, bigint, character varying, character varying, character varying, bigint, bigint, bigint, bigint, bigint, bigint, date, date, date, boolean, boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_houses(bigint, bigint, uuid, bigint, character varying, character varying, character varying, bigint, bigint, bigint, bigint, bigint, bigint, date, date, date, boolean, boolean) 
   IS 'Сохранение списка домов';
--
--  USE CASE:


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_change_history (bigint, bigint, uuid, bigint, bigint, date);

CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_change_history (
                         i_change_id     gar_fias.as_change_history.change_id%TYPE
                        ,i_object_id     gar_fias.as_change_history.object_id%TYPE
                        ,i_adr_object_id gar_fias.as_change_history.adr_object_uuid%TYPE
                        ,i_oper_type_id  gar_fias.as_change_history.oper_type_id%TYPE
                        ,i_ndoc_id       gar_fias.as_change_history.ndoc_id%TYPE
                        ,i_change_date   gar_fias.as_change_history.change_date%TYPE 
) 
  LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias_pcg_loadgar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick. 2021-10-21
    -- Updates:  2021-11-03 Модификация под загрузчик ГИС Интеграция.     
    -- ----------------------------------------------------------------------------------------------------  
    --  Сохранение параметров истории изменений адресного объекта. 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_change_history AS c (
                                         change_id
                                        ,object_id
                                        ,adr_object_uuid
                                        ,oper_type_id
                                        ,ndoc_id
                                        ,change_date         
        )
          VALUES (       i_change_id     
                        ,i_object_id     
                        ,i_adr_object_id 
                        ,i_oper_type_id  
                        ,i_ndoc_id
                        ,i_change_date            
          )
            ON CONFLICT (change_id) DO 
                UPDATE
                      SET
                           object_id       = excluded.object_id
                          ,adr_object_uuid = excluded.adr_object_uuid
                          ,oper_type_id    = excluded.oper_type_id
                          ,ndoc_id         = excluded.ndoc_id
                          ,change_date     = excluded.change_date                                
                          
                    WHERE (c.change_id = excluded.change_id);           
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_change_history (bigint, bigint, uuid, bigint, bigint, date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_change_history (bigint, bigint, uuid, bigint, bigint, date) 
IS 'Сохранение параметров истории изменений адресного объекта';
--
--  USE CASE:

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_add_house_type (bigint, character varying, character varying, character varying, date, date, date, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_add_house_type (
                      i_id             gar_fias.as_add_house_type.add_type_id%TYPE
                     ,i_type_name      gar_fias.as_add_house_type.type_name%TYPE
                     ,i_type_shortname gar_fias.as_add_house_type.type_shortname%TYPE
                     ,i_type_desc      gar_fias.as_add_house_type.type_descr%TYPE
                     ,i_update_date    gar_fias.as_add_house_type.update_date%TYPE
                     ,i_start_date     gar_fias.as_add_house_type.start_date%TYPE
                     ,i_end_date       gar_fias.as_add_house_type.end_date%TYPE
                     ,i_is_active      gar_fias.as_add_house_type.is_active%TYPE

)  LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias_pcg_load, gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-05
    -- Updates:  2021-11-02 Модификация под загрузчик ГИС Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --    Сохранение списка ДОПОЛНИТЕЛЬНЫХ признаков владения (типов домов). 
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_add_house_type AS a (  add_type_id 
                                                  ,type_name 
                                                  ,type_shortname 
                                                  ,type_descr 
                                                  ,update_date 
                                                  ,start_date 
                                                  ,end_date 
                                                  ,is_active         
                   )
          VALUES (    i_id             
                     ,i_type_name      
                     ,i_type_shortname 
                     ,i_type_desc      
                     ,i_update_date    
                     ,i_start_date     
                     ,i_end_date       
                     ,i_is_active          
         )
           ON CONFLICT (add_type_id) 
              DO UPDATE SET  add_type_id    = excluded.add_type_id    
                            ,type_name      = excluded.type_name      
                            ,type_shortname = excluded.type_shortname 
                            ,type_descr     = excluded.type_descr     
                            ,update_date    = excluded.update_date    
                            ,start_date     = excluded.start_date     
                            ,end_date       = excluded.end_date       
                            ,is_active      = excluded.is_active                
                WHERE (a.add_type_id = excluded.add_type_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_add_house_type (bigint, character varying, character varying, character varying, date, date, date, boolean) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_add_house_type (bigint, character varying, character varying, character varying, date, date, date, boolean) 
      IS 'Сохранение списка дополнительных признаков владений (типов домов)';
--
--  USE CASE:
--

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_addr_obj_type (bigint, character varying, character varying, character varying, character varying, date, date, date, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_type (
                                i_id             gar_fias.as_addr_obj_type.id%TYPE
                               ,i_type_level     gar_fias.as_addr_obj_type.type_level%TYPE
                               ,i_type_name      gar_fias.as_addr_obj_type.type_name%TYPE
                               ,i_type_shortname gar_fias.as_addr_obj_type.type_shortname%TYPE
                               ,i_type_desc      gar_fias.as_addr_obj_type.type_descr%TYPE
                               ,i_update_date    gar_fias.as_addr_obj_type.update_date%TYPE
                               ,i_start_date     gar_fias.as_addr_obj_type.start_date%TYPE
                               ,i_end_date       gar_fias.as_addr_obj_type.end_date%TYPE
                               ,i_is_active      gar_fias.as_addr_obj_type.is_active%TYPE

) LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-07
    -- Updates:  2021-11-02 Модификация под загрузчик ГИС Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --  Загрузка списка типов адресообразующих элементов. 
    --    На входе: Данные для формирования одной записи. После загрузки таблицы можно приступать
    --               загрузке адресообразующих элемнентов.
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_addr_obj_type AS i (
                                id
                               ,type_level
                               ,type_name
                               ,type_shortname 
                               ,type_descr
                               ,update_date  
                               ,start_date
                               ,end_date
                               ,is_active
        )
         VALUES (
                                i_id             
                               ,i_type_level     
                               ,i_type_name      
                               ,i_type_shortname 
                               ,i_type_desc      
                               ,i_update_date    
                               ,i_start_date     
                               ,i_end_date       
                               ,i_is_active        
         )
          ON CONFLICT (id) DO UPDATE  
                         SET
                                 id             = excluded.id   
                                ,type_level     = excluded.type_level
                                ,type_name      = excluded.type_name
                                ,type_shortname = excluded.type_shortname
                                ,type_descr     = excluded.type_descr
                                ,update_date    = excluded.update_date  
                                ,start_date     = excluded.start_date
                                ,end_date       = excluded.end_date
                                ,is_active      = excluded.is_active
          
                  WHERE (i.id = excluded.id);           
        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_type (bigint, character varying, character varying, character varying, character varying, date, date, date, boolean) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_type (bigint, character varying, character varying, character varying, character varying, date, date, date, boolean) 
      IS 'Сохранение списка типов адресообразующих элементов';
--
--  USE CASE:

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_addr_obj_params(bigint, bigint, bigint, bigint, bigint, text, date, date, date);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_params (
                            i_id            gar_fias.as_addr_obj_params.id%TYPE
                           ,i_object_id     gar_fias.as_addr_obj_params.object_id%TYPE
                           ,i_change_id     gar_fias.as_addr_obj_params.change_id%TYPE
                           ,i_change_id_end gar_fias.as_addr_obj_params.change_id_end%TYPE
                           ,i_type_id       gar_fias.as_addr_obj_params.type_id%TYPE
                           ,i_value         gar_fias.as_addr_obj_params.obj_value%TYPE
                           ,i_update_date   gar_fias.as_addr_obj_params.update_date%TYPE
                           ,i_start_date    gar_fias.as_addr_obj_params.start_date%TYPE
                           ,i_end_date      gar_fias.as_addr_obj_params.end_date%TYPE

) LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-07
    -- Updates:  2021-11-02 Модификация под загрузчик ГИС Интеграция.
    -- ----------------------------------------------------------------------------------------------------  
    --  Сохраненеие параметров адресообразующего элемента. 
    --    На входе: Данные для формирования одной записи. После загрузки таблицы можно приступать
    --               загрузке адресообразующих элемнентов.
    -- ====================================================================================================
    BEGIN
        INSERT INTO gar_fias.as_addr_obj_params AS i (
                                                        id           
                                                       ,object_id    
                                                       ,change_id    
                                                       ,change_id_end
                                                       ,type_id      
                                                       ,obj_value        
                                                       ,update_date  
                                                       ,start_date   
                                                       ,end_date     
        )
         VALUES (
                     i_id            
                    ,i_object_id     
                    ,i_change_id     
                    ,i_change_id_end 
                    ,i_type_id       
                    ,i_value         
                    ,i_update_date   
                    ,i_start_date    
                    ,i_end_date      
         )
          ON CONFLICT (id) DO UPDATE  
                         SET
                                 object_id     = excluded.object_id        
                                ,change_id     = excluded.change_id    
                                ,change_id_end = excluded.change_id_end
                                ,type_id       = excluded.type_id      
                                ,obj_value     = excluded.obj_value    
                                ,update_date   = excluded.update_date  
                                ,start_date    = excluded.start_date   
                                ,end_date      = excluded.end_date     
          
                  WHERE (i.id = excluded.id);           
        
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_params(bigint, bigint, bigint, bigint, bigint, text, date, date, date) OWNER TO postgres;
COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_addr_obj_params(bigint, bigint, bigint, bigint, bigint, text, date, date, date) 
      IS 'Загрузка параметров адресообразующего элемента';
--
--  USE CASE:

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
