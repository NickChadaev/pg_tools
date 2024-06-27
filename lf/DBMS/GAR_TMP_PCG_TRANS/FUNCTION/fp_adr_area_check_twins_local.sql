DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_area_check_twins_local (text, date, text);  
-- 
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.fp_adr_area_check_twins_local (
        p_schema_name       text  
       ,p_bound_date        date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name  text = 'gar_tmp'             
        --
       ,OUT fcase         integer
       ,OUT id_area_subj  bigint
       ,OUT id_area_obj   bigint
       ,OUT nm_area       varchar(255)
       ,OUT nm_fias_guid  uuid       
)
    RETURNS setof record
    LANGUAGE plpgsql 
    SECURITY DEFINER
  AS
$$
  -- ================================================================
  --  2023-01-17 Функция фильтрующая дубли.
  -- ================================================================
  DECLARE
   _rr record;
     
  BEGIN
    FOR _rr IN WITH x (
                         id_area         
                        ,id_country      
                        ,nm_area         
                        ,nm_area_full   
                        ,id_area_type   
                        ,id_area_parent
                        ,nm_fias_guid  
                        ,dt_data_del    
                        ,id_data_etalon 
                        ,rn
       ) 
        AS (
             SELECT  a.id_area       
                    ,a.id_country    
                    ,a.nm_area       
                    ,a.nm_area_full  
                    ,a.id_area_type  
                    ,a.id_area_parent
                    ,a.nm_fias_guid  
                    ,a.dt_data_del   
                    ,a.id_data_etalon
                    ,(count (1) OVER (PARTITION BY a.id_country, a.id_area_parent, a.id_area_type, upper(a.nm_area))) AS rn 
                    
             FROM gar_tmp.adr_area a WHERE (a.id_data_etalon IS NULL)
           ) 
           ,z (  id_area        
                ,id_country     
                ,nm_area        
                ,nm_area_full   
                ,id_area_type   
                ,id_area_parent
                ,nm_fias_guid  
                ,dt_data_del    
                ,id_data_etalon 
                
              ) AS (
                   SELECT  x.id_area       
                          ,x.id_country    
                          ,x.nm_area       
                          ,x.nm_area_full  
                          ,x.id_area_type  
                          ,x.id_area_parent
                          ,x.nm_fias_guid  
                          ,x.dt_data_del   					
                          ,x.id_data_etalon
                   
                   FROM x WHERE (x.rn >= 2) AND (x.nm_fias_guid IS NOT NULL)
            ) -- Значим, но у него есть близнецы
              SELECT 
                      z.id_area       
                     ,z.id_country    
                     ,z.nm_area       
                     ,z.nm_area_full  
                     ,z.id_area_type  
                     ,z.id_area_parent
                     ,z.nm_fias_guid  
                     ,z.dt_data_del   
                     ,z.id_data_etalon
              
              FROM z WHERE (z.dt_data_del IS NULL)
     LOOP
       EXIT WHEN (_rr.id_area IS NULL);
        --
       SELECT f.fcase, f.id_area_subj, f.id_area_obj, f.nm_area, f.nm_fias_guid 
       INTO fcase, id_area_subj, id_area_obj, nm_area, nm_fias_guid 
       
       FROM gar_tmp_pcg_trans.fp_adr_area_del_twin (
                  p_schema_name := p_schema_name 
                 ,p_id_area     := _rr.id_area      
                  --
                 ,p_id_country     := _rr.id_country
                 ,p_id_area_parent := _rr.id_area_parent
                 ,p_id_area_type   := _rr.id_area_type
                 ,p_nm_area        := _rr.nm_area                  
                  --                
                 ,p_nm_fias_guid   := _rr.nm_fias_guid 
                  --
                 ,p_bound_date       := p_bound_date        
                 ,p_schema_hist_name := p_schema_hist_name
       ) f;
     --   
     RETURN NEXT;  
     END LOOP;
  END;
$$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.fp_adr_area_check_twins_local (text, date, text) 
                   IS 'Постобработка, фильтрация дублей АДРЕСНЫЕ ПРОСТРАНСТВА.';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------

