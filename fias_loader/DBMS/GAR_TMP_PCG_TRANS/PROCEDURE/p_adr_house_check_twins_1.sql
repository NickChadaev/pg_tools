DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_check_twins (
                  text, text, bigint [][], boolean
 ); 
 --
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_check_twins (
                  text, text, bigint [][], boolean, date, text
 );  
-- 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_check_twins (
        p_schema_name       text  
       ,p_conn_name         text  
       ,p_house_ids         bigint [][]       
       ,p_mode              boolean = FALSE -- Постобработка.
       ,p_bound_date        date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name text = 'gar_tmp'             
)
    LANGUAGE plpgsql SECURITY DEFINER
  AS
$$
  -- ========================================================================
  --  2022-03-15 Функция фильтрующая дубли.
  --  2022-05-15 Изменён порядок выборки записей.
  --  2022-06-23 Две функции: 
  --     gar_tmp_pcg_trans.fp_adr_house_del_twin_0 () удаление "AK1"
  --     gar_tmp_pcg_trans.fp_adr_house_del_twin_2 () удаление "nm_fias_guid"
  --  2022-07-27 Подключение постоянно, запрос выполняется дважды
  -- ========================================================================
  DECLARE
   _rr      record;
   _z       bigint[];
   _arr_len integer;
   _i       integer := 1;
   _qty_0   integer;
   _qty_2   integer;

   _select text := $_$
      SELECT id_house, id_area, id_street, nm_house_full, nm_fias_guid 
            FROM %I.adr_house 
                    WHERE (id_house >= %L) AND (id_house < %L)
                           ORDER BY id_house DESC;	
   $_$;
   _exec text;
   
  BEGIN
    IF (p_house_ids IS NULL) 
      THEN
           RAISE 'Массив граничных значений не может быть NULL';
    END IF;
    _arr_len := array_length (p_house_ids, 1);
     --
     LOOP
  	   _qty_0 := 0;
	   _qty_2 := 0;
       _z := p_house_ids [_i:_i];
       --
       _exec := format (_select, p_schema_name, (_z[1][1]), (_z[1][2]));
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
           _qty_0 := _qty_0 + gar_tmp_pcg_trans.fp_adr_house_del_twin_0 (
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
        
        -- 2022-07-27 Подключение постоянно, запрос выполняется дважды

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
           _qty_2 := _qty_2 + gar_tmp_pcg_trans.fp_adr_house_del_twin_2 (
                     p_schema_name      := p_schema_name 
                    ,p_id_house         := _rr.id_house     
                    ,p_id_area          := _rr.id_area      
                    ,p_id_street        := _rr.id_street    
                    ,p_nm_house_full    := _rr.nm_house_full
                    ,p_nm_fias_guid     := _rr.nm_fias_guid 
                    ,p_mode             := p_mode
                    ,p_bound_date       := p_bound_date       -- Только для режима Post обработки.
                    ,p_schema_hist_name := p_schema_hist_name
           );
        END LOOP;
        
        RAISE NOTICE 'Houses 0 (ak1). Bounds: % - %, qty = % ', (_z[1][1]), (_z[1][2]), _qty_0;
        RAISE NOTICE 'Houses 2 (nm_fias_guid). Bounds: % - %, qty = % ', (_z[1][1]), (_z[1][2]), _qty_2;
        
       _i := _i + 1;
       EXIT WHEN (_i > _arr_len);
     END LOOP;
  END;
$$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_check_twins (text, text, bigint [][], boolean, date, text) 
                   IS 'Постобработка, фильтрация дублей';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- SELECT * FROM unsi.adr_house WHERE(id_area = 78) AND (upper(nm_house_full::text)='Д. 100 ЛИТЕР АБ')
--                 AND (id_street= 1641)
-- SELECT gar_link.f_server_is();
-- SELECT * FROM gar_link.v_servers_active;
-- --------------------------------------------------------------------------
--   CALL gar_tmp_pcg_trans.p_adr_house_check_twins ('unnsi',gar_link.f_conn_set (3)
--          ,'{
--             {1100000000,1199000000}
--            ,{2400000000,2499000000}												   
--           }'
--   );
--
--           ,'{{2400000000,2499000000}
--             ,{7800000000,7899000000}
--             ,{3800000000,3899000000}
