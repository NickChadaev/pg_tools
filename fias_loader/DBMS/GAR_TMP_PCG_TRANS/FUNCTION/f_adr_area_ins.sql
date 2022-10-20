DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_ins (text, text, text, uuid[], boolean);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_area_ins (
           p_schema_data    text -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl     text -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist    text -- Схема для хранения исторических данных 
          ,p_nm_guids_fias  uuid[]  = NULL -- Список обрабатываемых GUID, NULL - все.
          ,p_sw_hist        boolean = TRUE -- Создаётся историческая запись.
           --
          ,OUT total_row  integer  -- Общее количество обработанных строк.
          ,OUT ins_row    integer  -- Из них добавлено 
          ,OUT upd_row    integer  -- Из них обновлено (конфликты).
)
    RETURNS setof record
    LANGUAGE plpgsql
	SET search_path=gar_tmp_pcg_trans, gar_tmp, public
 AS
  $$
   DECLARE
     _r_ins   integer := 0;   
     
     _data   RECORD;  
     _parent gar_tmp.adr_area_t;
     
     _id_area_type         bigint;
     _area_type_short_name text;
     --
     --  2021-12-20
     --
     _id_area  bigint;
     
     -- 2022-10-18
     --
     INS_OP CONSTANT char(1) := 'I';
     UPD_OP CONSTANT char(1) := 'U';
           
   BEGIN
    -- ------------------------------------------------------------------------------
    --  2021-12-10/2021-12-19/2022-02-09 Nick  Дополнение адресных георегионов.
    --  2022-02-21 - фильтрация данных по справочнику типов.  
    --  2022-10-19 - вспомогательные таблицы.
    -- ------------------------------------------------------------------------------
    --  p_schema_data   -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
    --  p_schema_etl    -- Схема эталон, обычно локальный сервер, копия p_schema_data 
    --  p_schema_hist   -- Схема для хранения исторических данных 
    --  p_nm_guids_fias -- Список обрабатываемых GUID, NULL - все.
    --  p_sw_hist       -- Создаётся историческая запись.
    -- ------------------------------------------------------------------------------
    FOR _data IN 
           SELECT 
                x.id_addr_obj AS id_area     
                --
               ,x.nm_addr_obj AS nm_area     
               ,x.nm_addr_obj AS nm_area_full
               --
               ,x.addr_obj_type_id AS id_area_type
               ,x.addr_obj_type    AS nm_area_type         
                --
               ,x.id_addr_parent   AS id_area_parent     
               ,x.parent_fias_guid AS nm_fias_guid_parent
               --
               ,(p.type_param_value -> '7'::text)  AS kd_oktmo
               --
               ,x.fias_guid AS nm_fias_guid  
                --
               ,(p.type_param_value -> '6'::text)  AS kd_okato    --  varchar(11) null,
               ,(p.type_param_value -> '5'::text)  AS nm_zipcode  --  varchar(20) null,
               ,(p.type_param_value -> '11::text') AS kd_kladr    --  varchar(15) null,
                --
               ,x.tree_d                
               ,x.level_d               
                --
               ,x.obj_level       
               ,x.level_name      
               --
               ,x.oper_type_id    
               ,x.oper_type_name  
               
            FROM gar_tmp.xxx_adr_area x  
               INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = x.fias_guid) 
               LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (x.id_addr_obj = p.object_id)
	            
	        WHERE (f.id_obj IS NULL) AND (f.type_object = 0) 
	                 AND
	              (((x.fias_guid = ANY (p_nm_guids_fias)) AND 
	               (p_nm_guids_fias IS NOT NULL)) OR (p_nm_guids_fias IS NULL)
	              )
	        ORDER BY x.tree_d 
     
       LOOP
          -- Код страны
          -- часовой пояс
          -- Полное имя       Это всё забираем у родителя  (полная инфа о родителе.
          
          -- Тип, вычисляется на локальных данных.
          
           SELECT id_area_type, nm_area_type_short 
              INTO _id_area_type, _area_type_short_name
           FROM gar_tmp.xxx_adr_area_type WHERE (_data.id_area_type = ANY (fias_ids));
           --
           CONTINUE WHEN ((_id_area_type IS NULL) OR (_area_type_short_name IS NULL) OR
                          (_data.nm_area IS NULL) 
           ); -- 2022-02-21
           --
          _id_area := nextval('gar_tmp.obj_seq'); 
           _parent := gar_tmp_pcg_trans.f_adr_area_get (p_schema_etl, _data.nm_fias_guid_parent);
           
           CALL gar_tmp_pcg_trans.p_adr_area_ins (
                  p_schema_name       := p_schema_data                    --  text  
                 ,p_schema_h          := p_schema_hist     
                  --
                 ,p_id_area           := _id_area                    --  bigint      --  NOT NULL
                 ,p_id_country        := COALESCE (_parent.id_country, 185)::integer --  NOT NULL
                 ,p_nm_area           := _data.nm_area::varchar(120)                 --  NOT NULL
                 ,p_nm_area_full      := btrim ((COALESCE (_parent.nm_area_full, '') ||  ', ' || 
                                                   _data.nm_area || ' ' ||
                                                   _area_type_short_name
                                               ), ',')::varchar(4000)                --  NOT NULL
                 ,p_id_area_type      := _id_area_type       ::integer                --    NULL
                 ,p_id_area_parent    := _parent.id_area     ::bigint                 --    NULL
                 ,p_kd_timezone       := _parent.kd_timezone ::integer                --    NULL
                 ,p_pr_detailed       := COALESCE (_parent.pr_detailed, 0)::smallint  -- NOT NULL 
                 ,p_kd_oktmo          := _data.kd_oktmo      ::varchar(11)            --    NULL
                 ,p_nm_fias_guid      := _data.nm_fias_guid  ::uuid                   --    NULL
                 ,p_id_data_etalon    := NULL                ::bigint                 --    NULL
                 ,p_kd_okato          := _data.kd_okato  ::varchar(11)                --    NULL
                 ,p_nm_zipcode        := _data.nm_zipcode::varchar(20)                --    NULL
                 ,p_kd_kladr          := _data.kd_kladr  ::varchar(15)                --    NULL
                 ,p_vl_addr_latitude  := NULL::numeric                                --    NULL
                 ,p_vl_addr_longitude := NULL::numeric                                --    NULL  
                  --
                 ,p_sw                := p_sw_hist
           );
             
           _r_ins := _r_ins + 1; 
       END LOOP;
   
    total_row := _r_ins;
    ins_row := (SELECT count(1) FROM gar_tmp.adr_area_aux WHERE (op_sign = INS_OP));
    upd_row := (SELECT count(1) FROM gar_tmp.adr_area_aux WHERE (op_sign = UPD_OP));
    
    RETURN NEXT;
   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_area_ins (text, text, text, uuid[], boolean) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_area_ins (text, text, text, uuid[], boolean)
IS 'Дополнение адресных георегионов';
----------------------------------------------------------------------------------
-- USE CASE:
-- SELECT gar_tmp_pcg_trans.f_adr_area_ins ('unsi'); 
-- ЗАМЕЧАНИЕ:  (2825,185,Хачемзий,"Адыгея Респ, Кошехабльский р-н, Хачемзий аул",5,94,,1,79615412126,,79215000020,385423,01002000020)
-- SELECT * from gar_tmp.obj_seq;
--    --   {2,94,50000001}
-- select * from unsi.adr_area where (id_area > 50000000)
-- DELETE from unsi.adr_area where (id_area > 50000000)
