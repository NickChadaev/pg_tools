DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.p_adr_house_check_twins_local (
                  text, bigint [], date, text
 );  
-- 
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.p_adr_house_check_twins_local (
        p_schema_name       text  
       ,p_house_ids         bigint []     
       ,p_bound_date        date = '2022-01-01'::date  
       ,p_schema_hist_name  text = 'gar_tmp' 
        --
       ,OUT fcase          integer
       ,OUT id_house_subj  bigint
       ,OUT id_house_obj   bigint
       ,OUT nm_hose_full   varchar(250)
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
   _z       bigint[];

   -- ---------------------------------
   --     id_house      bigint
   --    ,id_area       bigint
   --    ,id_street     bigint 
   --    ,nm_house_full varchar(250)
   --    ,nm_fias_guid  uuid 
   -- ---------------------------------
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
    --
    _exec := format (_select, p_schema_name, p_house_ids[1], p_house_ids[2]);
    --
    FOR _rr IN EXECUTE _exec
     LOOP
        EXIT WHEN (_rr.id_house IS NULL);
        --
        SELECT f0.* INTO fcase, id_house_subj, id_house_obj, nm_hose_full, nm_fias_guid 
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
      --   SELECT f1.* INTO fcase, id_house_subj, id_house_obj, nm_hose_full, nm_fias_guid 
      --   FROM gar_tmp_pcg_trans.fp_adr_house_del_twin_local_1 (
      --             p_schema_name      := p_schema_name 
      --            ,p_id_house         := _rr.id_house     
      --            ,p_id_area          := _rr.id_area      
      --            ,p_id_street        := _rr.id_street    
      --            ,p_nm_house_full    := _rr.nm_house_full
      --            ,p_nm_fias_guid     := _rr.nm_fias_guid 
      --            ,p_bound_date       := p_bound_date       
      --            ,p_schema_hist_name := p_schema_hist_name
      --   ) f1;
     END LOOP;
     --
     RETURN NEXT;   
  END;
$$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.p_adr_house_check_twins_local (text, bigint [], date, text) 
                   IS 'Постобработка, фильтрация дублей';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- SELECT * FROM unsi.adr_house WHERE(id_area = 78) AND (upper(nm_house_full::text)='Д. 100 ЛИТЕР АБ')
--                 AND (id_street= 1641)
-- SELECT gar_link.f_server_is();
-- SELECT * FROM gar_link.v_servers_active;
-- --------------------------------------------------------------------------
--   CALL gar_tmp_pcg_trans.p_adr_house_check_twins_local ('unnsi',gar_link.f_conn_set (3)
--          ,'{
--             {1100000000,1199000000}
--            ,{2400000000,2499000000}												   
--           }'
--   );
--
--           ,'{{2400000000,2499000000}
--             ,{7800000000,7899000000}
--             ,{3800000000,3899000000}
