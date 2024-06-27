DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_show_params_value (bigint[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_show_params_value (
       p_param_type_ids  bigint[] = ARRAY [5,6,7,10,11]::bigint[]
)
    RETURNS TABLE 

    ( object_id         bigint
     ,type_param_value  public.hstore
    ) 

    STABLE
    LANGUAGE sql
 AS
  $$
    -- ----------------------------------------------------------------------------------------------
    --  2021-11-24 Nick Получить список величин параметров объекта. Агрегация пар "Тип" - "Значение"
    -- ----------------------------------------------------------------------------------------------
    --           p_param_type_ids bigint[] -- Список типов параметров 
    -- ----------------------------------------------------------------------------------------------
    WITH a1 (  object_id
              ,type_id
              ,param_value
     )        
      AS (    
            SELECT z1.object_id, z1.type_id, z1.obj_value AS param_value FROM gar_fias.as_addr_obj_params z1 
                   WHERE (z1.type_id = ANY (p_param_type_ids)) 
                            AND (z1.start_date <= current_date) AND (z1.end_date > current_date)
               
              UNION ALL
            
            SELECT z2.object_id, z2.type_id, z2.param_value AS param_value FROM gar_fias.as_apartments_params z2
                   WHERE (z2.type_id = ANY (p_param_type_ids))
                            AND (z2.start_date <= current_date) AND (z2.end_date > current_date) 
            
              UNION ALL
            
            SELECT z3.object_id, z3.type_id, z3.param_value AS param_value FROM gar_fias.as_carplaces_params z3
                   WHERE (z3.type_id = ANY (p_param_type_ids))
                            AND (z3.start_date <= current_date) AND (z3.end_date > current_date)  
            
              UNION ALL
            
            SELECT z4.object_id, z4.type_id, z4.value AS param_value FROM gar_fias.as_houses_params z4
                   WHERE (z4.type_id = ANY (p_param_type_ids))
                            AND (z4.start_date <= current_date) AND (z4.end_date > current_date)  
                            
              UNION ALL
            
            SELECT z5.object_id, z5.type_id, z5.value AS param_value FROM gar_fias.as_rooms_params z5
                   WHERE (z5.type_id = ANY (p_param_type_ids))
                            AND (z5.start_date <= current_date) AND (z5.end_date > current_date)   
                            
              UNION ALL
            
            SELECT z6.object_id, z6.type_id, z6.type_value AS param_value FROM gar_fias.as_steads_params z6
                   WHERE (z6.type_id = ANY (p_param_type_ids))
                            AND (z6.start_date <= current_date) AND (z6.end_date > current_date)
      )
       --
      ,a2 (   object_id
             ,type_id
             ,param_value  
              
          ) AS (
                 SELECT a1.object_id, a1.type_id, a1.param_value 
                     FROM a1 
                       ORDER BY a1.object_id, a1.type_id
                 
             )
       --       
      ,a3 (  object_id
             ,type_param_value
             
           ) AS (  
                  SELECT a2.object_id, public.hstore ( array_agg (a2.type_id)::text[]
                                                      ,array_agg (a2.param_value)
                                      ) 
                   FROM a2
                            GROUP BY a2.object_id      
      )
        SELECT * FROM a3;
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_show_params_value (bigint[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_show_params_value (bigint[]) 
IS 'Получить список величин параметров объекта. Агрегация пар "Тип" - "Значение"';
----------------------------------------------------------------------------------
-- USE CASE:
--
-- SELECT * FROM gar_tmp_pcg_trans.f_show_params_value () WHERE (object_id = 60933804); 
 
-- Successfully run. Total query runtime: 3 secs 674 msec.  2862964 rows affected. NN
-- 302571 rows affected.	 
