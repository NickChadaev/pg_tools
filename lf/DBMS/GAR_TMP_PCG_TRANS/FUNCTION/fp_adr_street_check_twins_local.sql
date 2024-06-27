DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_street_check_twins_local (text, date, text);  
-- 
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.fp_adr_street_check_twins_local (
        p_schema_name       text  
       ,p_bound_date        date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name  text = 'gar_tmp'             
        --
       ,OUT fcase           integer
       ,OUT id_street_subj  bigint
       ,OUT id_street_obj   bigint
       ,OUT nm_street_full  varchar(255)
       ,OUT nm_fias_guid    uuid       
)
    RETURNS setof record
    LANGUAGE plpgsql 
    SECURITY DEFINER
  AS
$$
  -- ================================================================
  --  2022-04-29 Функция фильтрующая дубли.
  --  2022-05-15 Изменён порядок выборки записей.
  --  2022-11-03 Вариант для работы с локальной секцией.
  -- ================================================================
  DECLARE
   _rr record;
     
    --   id_street      bigint
    --  ,id_area        bigint
    --  ,nm_street      varchar(255)
    --  ,id_street_type integer
    --  ,nm_fias_guid   uuid 
  
  BEGIN
    FOR _rr IN WITH x (
                        id_street      
                       ,id_area        
                       ,nm_street      
                       ,id_street_type 
                       ,nm_street_full 
                       ,nm_fias_guid   
                       ,dt_data_del    
                       ,id_data_etalon 
                       ,rn
       ) 
        AS (
             SELECT  s.id_street      
                    ,s.id_area        
                    ,s.nm_street      
                    ,s.id_street_type 
                    ,s.nm_street_full 
                    ,s.nm_fias_guid   
                    ,s.dt_data_del    
                    ,s.id_data_etalon 
                    ,(count (1) OVER (PARTITION BY s.id_area, upper (s.nm_street), s.id_street_type)) AS rn 
              
             FROM gar_tmp.adr_street s WHERE (s.id_data_etalon IS NULL)
           ) 
           ,z (  id_street      
                ,id_area        
                ,nm_street      
                ,id_street_type 
                ,nm_street_full 
                ,nm_fias_guid   
                ,dt_data_del    
                ,id_data_etalon 	
                
            ) AS (
                   SELECT  x.id_street      
                          ,x.id_area        
                          ,x.nm_street      
                          ,x.id_street_type 
                          ,x.nm_street_full 
                          ,x.nm_fias_guid   
                          ,x.dt_data_del    
                          ,x.id_data_etalon 					
                   
                   FROM x WHERE (x.rn = 2) AND (x.nm_fias_guid IS NOT NULL)
            )
              SELECT -- DISTINCT ON (z.id_area, upper (z.nm_street), z.id_street_type) 
                      z.id_street      
                     ,z.id_area        
                     ,z.nm_street      
                     ,z.id_street_type 
                     ,z.nm_street_full 
                     ,z.nm_fias_guid   
                     ,z.dt_data_del    
                     ,z.id_data_etalon  
              
              FROM z WHERE (z.dt_data_del IS NULL)
     LOOP
       EXIT WHEN (_rr.id_street IS NULL);
        --
       SELECT f.fcase, f.id_street_subj, f.id_street_obj, f.nm_street_full, f.nm_fias_guid 
       INTO fcase, id_street_subj, id_street_obj, nm_street_full, nm_fias_guid 
       
       FROM gar_tmp_pcg_trans.fp_adr_street_del_twin (
                  p_schema_name      := p_schema_name 
                  --
                 ,p_id_street        := _rr.id_street    
                 ,p_id_area          := _rr.id_area      
                 ,p_nm_street        := _rr.nm_street
                 ,p_id_street_type   := _rr.id_street_type
                 ,p_nm_fias_guid     := _rr.nm_fias_guid 
                  --
                 ,p_bound_date       := p_bound_date        
                 ,p_schema_hist_name := p_schema_hist_name
       ) f;
     --   
     RETURN NEXT;  
     END LOOP;
  END;
$$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.fp_adr_street_check_twins_local (text, date, text) 
                   IS 'Постобработка, фильтрация дублей УЛИЦЫ';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- SELECT * FROM unsi.adr_house WHERE(id_area = 78) AND (upper(nm_house_full::text)='Д. 100 ЛИТЕР АБ')
--                 AND (id_street= 1641)
-- SELECT gar_link.f_server_is();
-- SELECT * FROM gar_link.v_servers_active;
-- --------------------------------------------------------------------------

