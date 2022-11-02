DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.p_adr_house_check_twins_local (
                  text, date, text
 ); 
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.p_adr_house_check_twins_local (
        p_schema_name       text  
       ,p_bound_date        date = '2022-01-01'::date  
       ,p_schema_hist_name  text = 'gar_tmp' 
        --
       ,OUT fcase          integer
       ,OUT id_house_subj  bigint
       ,OUT id_house_obj   bigint
       ,OUT nm_house_full   varchar(250)
       ,OUT nm_fias_guid   uuid       
)
    RETURNS setof record
    LANGUAGE plpgsql 
    SECURITY DEFINER
  AS
$$
  -- ========================================================================
  --  2022-03-15 Функция фильтрующая дубли.
  --  2022-05-15 Изменён порядок выборки записей.
  --  2022-06-23 Две функции: 
  --     gar_tmp_pcg_trans.fp_adr_house_del_twin_0 () удаление "AK1"
  --     gar_tmp_pcg_trans.fp_adr_house_del_twin_2 () удаление "nm_fias_guid"
  --  2022-07-27 Подключение постоянно, запрос выполняется дважды
  --  2022-10-31 Вариант для работы в локальной региональной базе.
  -- ========================================================================
  DECLARE
   _rr      record;
   -- ---------------------------------
   --     id_house      bigint
   --    ,id_area       bigint
   --    ,id_street     bigint 
   --    ,nm_house_full varchar(250)
   --    ,nm_fias_guid  uuid 
   -- ---------------------------------
  
  BEGIN
    --
    FOR _rr IN  WITH x (
                         id_house
                        ,id_area
                        ,id_street
                        ,nm_house_full
                        ,nm_fias_guid
                        ,id_data_etalon
                        ,dt_data_del           
                        ,rn
     ) 
        AS (
             SELECT 
               h.id_house 
              ,h.id_area
              ,h.id_street
              ,h.nm_house_full
              ,h.nm_fias_guid
              ,h.id_data_etalon
              ,h.dt_data_del
              ,(count (1) OVER (PARTITION BY h.id_area, upper (h.nm_house_full), h.id_street)) AS rn 
             FROM gar_tmp.adr_house h WHERE (h.id_data_etalon IS NULL)
         ) 
         , z (
                 id_house
                ,id_area
                ,id_street
                ,nm_house_full
                ,nm_fias_guid
                ,dt_data_del
            ) AS (
                   SELECT   
                           x.id_house
                          ,x.id_area
                          ,x.id_street
                          ,x.nm_house_full
                          ,x.nm_fias_guid
                          ,x.dt_data_del
                   
                   FROM x WHERE (rn = 2) AND (x.nm_fias_guid IS NOT NULL) AND (x.dt_data_del IS NULL)
            )
              SELECT DISTINCT ON (z.id_area, upper(z.nm_house_full), z.id_street) 
              
                 z.id_house
                ,z.id_area
                ,z.id_street
                ,z.nm_house_full
                ,z.nm_fias_guid
              
              FROM z
     LOOP
        EXIT WHEN (_rr.id_house IS NULL);
        --
        SELECT f0.fcase, f0.id_house_subj, f0.id_house_obj, f0.nm_house_full, f0.nm_fias_guid
        INTO fcase, id_house_subj, id_house_obj, nm_house_full, nm_fias_guid 
        
        FROM gar_tmp_pcg_trans.fp_adr_house_del_twin_local_0 (
                  p_schema_name       :=  p_schema_name 
                 ,p_id_house          :=  _rr.id_house     
                 ,p_id_area           :=  _rr.id_area      
                 ,p_id_street         :=  _rr.id_street    
                 ,p_nm_house_full     :=  _rr.nm_house_full
                 ,p_nm_fias_guid      :=  _rr.nm_fias_guid 
                 ,p_bound_date        :=  p_bound_date       
                 ,p_schema_hist_name  :=  p_schema_hist_name           
        ) f0;
        --            
        RETURN NEXT;  
     END LOOP;
     --
     FOR _rr IN  WITH x (
                 id_house
                ,id_area
                ,id_street
                ,nm_house_full
                ,nm_fias_guid
                ,id_data_etalon
                ,dt_data_del
                ,rn
       ) 
        AS (
             SELECT 
               h.id_house 
              ,h.id_area
              ,h.id_street
              ,h.nm_house_full
              ,h.nm_fias_guid
              ,h.id_data_etalon
              ,h.dt_data_del              
              ,(count (1) OVER (PARTITION BY h.nm_fias_guid)) AS rn 
             FROM gar_tmp.adr_house h WHERE (h.id_data_etalon IS NULL)
         ) 
         , z (
                 id_house
                ,id_area
                ,id_street
                ,nm_house_full
                ,nm_fias_guid
                ,dt_data_del                 
            ) AS (
                   SELECT   
                           x.id_house
                          ,x.id_area
                          ,x.id_street
                          ,x.nm_house_full
                          ,x.nm_fias_guid
                          ,x.dt_data_del                           
                   
                   FROM x WHERE (rn = 2) AND (x.nm_fias_guid IS NOT NULL) AND
                                (x.dt_data_del IS NULL)
            )
              SELECT  DISTINCT ON (z.nm_fias_guid) 
                      z.id_house
                     ,z.id_area
                     ,z.id_street
                     ,z.nm_house_full
                     ,z.nm_fias_guid
              
              FROM z 
     LOOP
        EXIT WHEN (_rr.id_house IS NULL);
        --
       SELECT f1.fcase, f1.id_house_subj, f1.id_house_obj, f1.nm_house_full, f1.nm_fias_guid 
       INTO fcase, id_house_subj, id_house_obj, nm_house_full, nm_fias_guid 
       
       FROM gar_tmp_pcg_trans.fp_adr_house_del_twin_local_1 (
                 p_schema_name      := p_schema_name 
                ,p_id_house         := _rr.id_house     
                ,p_id_area          := _rr.id_area      
                ,p_id_street        := _rr.id_street    
                ,p_nm_house_full    := _rr.nm_house_full
                ,p_nm_fias_guid     := _rr.nm_fias_guid 
                ,p_bound_date       := p_bound_date       
                ,p_schema_hist_name := p_schema_hist_name
       ) f1;
        --            
        RETURN NEXT;  
     END LOOP;
        
  END;
$$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.p_adr_house_check_twins_local (text, date, text) 
                   IS 'Постобработка, фильтрация дублей';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- SELECT * FROM unsi.adr_house WHERE(id_area = 78) AND (upper(nm_house_full::text)='Д. 100 ЛИТЕР АБ')
