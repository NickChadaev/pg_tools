DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_street_check_twins_local (text, date, text);  
-- 
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.fp_adr_street_check_twins_local (
        p_schema_name       text  
       ,p_bound_date        date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name  text = 'gar_tmp'             
)
    LANGUAGE plpgsql SECURITY DEFINER
  AS
$$
  -- ================================================================
  --  2022-04-29 Функция фильтрующая дубли.
  --  2022-05-15 Изменён порядок выборки записей.
  --  2022-11-03 Вариант для работы в локальной секции.
  -- ================================================================
  DECLARE
   _rr      record;
   _z       bigint[];
   _arr_len integer;
   _i       integer := 1;

   _select text := $_$
      SELECT id_street, id_area, nm_street, id_street_type, nm_fias_guid
              FROM %I.adr_street 
                            WHERE (id_street >= %L) AND (id_street < %L)
                                 ORDER BY id_street DESC;	
   $_$;
   _exec text;
   
  BEGIN
    IF (p_street_ids IS NULL) 
      THEN
           RAISE 'Массив граничных значений не может быть NULL';
    END IF;
    _arr_len := array_length (p_street_ids, 1);
     --
     LOOP
       _z := p_street_ids [_i:_i];
       --
       _exec := format (_select, p_schema_name, (_z[1][1]), (_z[1][2]));
       --
       FOR _rr IN SELECT x1.* FROM gar_link.dblink (p_conn_name, _exec) 
             AS x1
               (
                    id_street      bigint
                   ,id_area        bigint
                   ,nm_street      varchar(120)
                   ,id_street_type integer
                   ,nm_fias_guid   uuid 
                )                             
        --                    
        LOOP
           EXIT WHEN (_rr.id_street IS NULL);
           --
           CALL gar_tmp_pcg_trans.p_adr_street_del_twin (
                     p_schema_name      := p_schema_name 
                     --
                    ,p_id_street        := _rr.id_street    
                    ,p_id_area          := _rr.id_area      
                    ,p_nm_street        := _rr.nm_street
                    ,p_id_street_type   := _rr.id_street_type
                    ,p_nm_fias_guid     := _rr.nm_fias_guid 
                     --
                    ,p_mode             := p_mode
                    ,p_bound_date       := p_bound_date       -- Только для режима Post обработки.
                    ,p_schema_hist_name := p_schema_hist_name
           );
        END LOOP;
       
        RAISE NOTICE 'Streets (ak1). Bounds: % - %', (_z[1][1]), (_z[1][2]);
       _i := _i + 1;
       
       EXIT WHEN (_i > _arr_len);
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
--   CALL gar_tmp_pcg_trans.fp_adr_street_check_twins_local ('unnsi',gar_link.f_conn_set (3)
--          ,'{
--             {1100000000,1199000000}
--            ,{2400000000,2499000000}												   
--           }'
--   );
--
--           ,'{{2400000000,2499000000}
--             ,{7800000000,7899000000}
--             ,{3800000000,3899000000}
