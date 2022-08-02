DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_check_twins_1 (
                  text, text, boolean, date, text
 );  
-- 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_check_twins_1 (
        p_schema_name       text  
       ,p_conn_name         text  
       ,p_mode              boolean = FALSE -- Постобработка.
       ,p_bound_date        date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name  text = 'gar_tmp'             
)
    LANGUAGE plpgsql SECURITY DEFINER
  AS
$$
  -- ========================================================================
  --  2022-07-28 Функция фильтрующая дубли. Сканирует всю "unnsi.adr_house",
  --               требует неуникального индекса "adr_house_ak1".
  -- ========================================================================
  DECLARE
   _rr      record;
   _qty_1   integer;

   _select text := $_$
       WITH x (
                 id_house
                ,id_area
                ,id_street
                ,nm_house_full
                ,nm_fias_guid
                ,rn
       ) 
        AS (
             SELECT 
               id_house 
              ,id_area
              ,id_street
              ,nm_house_full
              ,nm_fias_guid
              ,(count (1) OVER (PARTITION BY id_area, upper (nm_house_full), id_street)) AS rn 
             FROM  %I.adr_house WHERE (id_data_etalon IS NULL)
         ) 
         , z (
                 id_house
                ,id_area
                ,id_street
                ,nm_house_full
                ,nm_fias_guid
            ) AS (
                   SELECT   
                           x.id_house
                          ,x.id_area
                          ,x.id_street
                          ,x.nm_house_full
                          ,x.nm_fias_guid
                   
                   FROM x WHERE (rn = 2) AND (nm_fias_guid IS NOT NULL)
            )
              SELECT DISTINCT ON (z.id_area, upper(z.nm_house_full), z.id_street) 
       
                 z.id_house
                ,z.id_area
                ,z.id_street
                ,z.nm_house_full
                ,z.nm_fias_guid
              
              FROM z;
   $_$;
   
   _exec text;
   
  BEGIN
    _qty_1 := 0;
    --
    _exec := format (_select, p_schema_name);
    --
    FOR _rr IN SELECT x1.* FROM gar_link.dblink (p_conn_name, _exec) 
          AS x1
            (
                 id_house      bigint
                ,id_area       bigint
                ,id_street     bigint 
                ,nm_house_full varchar(250)
                ,nm_fias_guid  uuid 
             )                             
     --                    
     LOOP
        EXIT WHEN (_rr.id_house IS NULL);
        --
        _qty_1 := _qty_1 + gar_tmp_pcg_trans.fp_adr_house_del_twin_1 (
                  p_schema_name       :=  p_schema_name 
                 ,p_id_house          :=  _rr.id_house     
                 ,p_id_area           :=  _rr.id_area      
                 ,p_id_street         :=  _rr.id_street    
                 ,p_nm_house_full     :=  _rr.nm_house_full
                 ,p_nm_fias_guid      :=  _rr.nm_fias_guid 
                 ,p_mode              :=  p_mode
                 ,p_bound_date        :=  p_bound_date       -- Только для режима Post обработки.
                 ,p_schema_hist_name  :=  p_schema_hist_name           
        );
     END LOOP;
       
     RAISE NOTICE 'Houses 1 (ak1). qty = % ', _qty_1;
       
  END;
$$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_check_twins_1 (text, text, boolean, date, text) 
                   IS 'Постобработка, фильтрация дублей';
-- ------------------------------------------------------------------------
--  USE CASE:
--  CALL gar_tmp_pcg_trans.p_adr_house_check_twins_1 (
--                         'unnsi'
--                       , gar_link.f_conn_set(10)
--                       , FALSE
--                       , '2022-01-01 00:00:00'
--                       , 'gar_tmp'
-- );
-- ------------------------------------------------------------------------

