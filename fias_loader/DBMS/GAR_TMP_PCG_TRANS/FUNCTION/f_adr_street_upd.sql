DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_street_upd (text, text, text, uuid[], boolean, boolean);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_street_upd (
           p_schema_data    text -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl     text -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist    text -- Схема для хранения исторических данных 
          ,p_nm_guids_fias  uuid[]  = NULL -- Список обрабатываемых GUID, NULL - все.
          ,p_sw_hist        boolean = TRUE  -- Создаётся историческая запись.  
          ,p_sw_duble       boolean = FALSE -- Обязательное выявление дубликатов
           --
          ,OUT total_row  integer  -- Общее количество обработанных строк.
          ,OUT upd_row    integer  -- Из них обновлено.
)
    RETURNS setof record
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
     _r_upd   integer := 0;  
     
     _data   RECORD;  
     _parent gar_tmp.adr_area_t;
     
     _id_street_type          bigint;
     _street_type_short_name  text;     
     --
     --  2021-12-20
     --
     _id_street   bigint;
     --
     -- 2022-10-18
     --
     UPD_OP CONSTANT char(1) := 'U';
     
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-14/2022-02-10 Nick  Обновление адресов улиц.
    --  2022-02-21 - фильтрация данных по справочнику типов.  
    -- --------------------------------------------------------------------------
    --  p_schema_data   -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
    --  p_schema_etl    -- Схема эталон, обычно локальный сервер, копия p_schema_data 
    --  p_schema_hist   -- Схема для хранения исторических данных 
    --  p_nm_guids_fias -- Список обрабатываемых GUID, NULL - все.
    --  p_sw_hist       -- Создаётся историческая запись.   
    --  p_sw_duble      -- Обязательное выяление дубликатов
    -- --------------------------------------------------------------------------
    FOR _data IN 
           SELECT 
                x.id_addr_obj AS id_street     
                --
               ,x.nm_addr_obj AS nm_street     
               ,x.nm_addr_obj AS nm_street_full
               --
               ,x.addr_obj_type_id AS id_street_type
               ,x.addr_obj_type    AS nm_street_type         
                --
               ,x.id_addr_parent   AS id_area     
               ,x.parent_fias_guid AS nm_fias_guid_area
               --
               ,x.fias_guid AS nm_fias_guid  
               ,(p.type_param_value -> '11'::text) AS kd_kladr    --  varchar(15) null,
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
   
          WHERE (f.id_obj IS NOT NULL) AND (f.type_object = 1) 
                    AND
                  (((x.fias_guid = ANY (p_nm_guids_fias)) AND 
	               (p_nm_guids_fias IS NOT NULL)) OR (p_nm_guids_fias IS NULL)
	              )          
          ORDER BY x.tree_d 
       LOOP
       
          SELECT id_street_type, nm_street_type_short 
              INTO _id_street_type, _street_type_short_name
           FROM gar_tmp.xxx_adr_street_type WHERE (_data.id_street_type = ANY (fias_ids));
          CONTINUE WHEN ((_id_street_type IS NULL) OR (_street_type_short_name IS NULL)); -- 2022-02-21     
         
          _parent := gar_tmp_pcg_trans.f_adr_area_get (p_schema_etl, _data.nm_fias_guid_area);
          CONTINUE WHEN ((_parent.id_area IS NULL) OR (_data.nm_street IS NULL)); 
          
          CALL gar_tmp_pcg_trans.p_adr_street_upd (
              p_schema_name       := p_schema_data                    --  text  
             ,p_schema_h          := p_schema_hist   
              --
             ,p_id_street         :=  _id_street   -- bigint                      -- NOT NULL 
             ,p_id_area           :=  _parent.id_area                -- bigint    -- NOT NULL 
             ,p_nm_street         :=  _data.nm_street::varchar(120)               -- NOT NULL 
             ,p_id_street_type    :=  _id_street_type::integer                    --  NULL 
             ,p_nm_street_full    :=  (_data.nm_street || ' ' || _street_type_short_name)::varchar(255)  -- NOT NULL  
             ,p_nm_fias_guid      :=  _data.nm_fias_guid::uuid           --  NULL 
             ,p_id_data_etalon    :=  NULL::bigint                       --  NULL 
             ,p_kd_kladr          :=  _data.kd_kladr::varchar(15)        --  NULL  
             ,p_vl_addr_latitude  :=  NULL::numeric                      --  NULL 
             ,p_vl_addr_longitude :=  NULL::numeric                      --  NULL
              -- 
             ,p_oper_type_id :=  _data.oper_type_id  -- Операция
             ,p_sw    := p_sw_hist 
             ,p_duble := p_sw_duble
          );
          
          _r_upd := _r_upd + 1; 
       END LOOP;
   
    total_row := _r_upd;
    upd_row := (SELECT count(1) FROM gar_tmp.adr_street_aux WHERE (op_sign = UPD_OP));
    
    RETURN NEXT;       
    
   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_street_upd (text, text, text, uuid[], boolean, boolean) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_street_upd (text, text, text, uuid[], boolean, boolean) 
IS 'Обновление адресов улиц';
----------------------------------------------------------------------------------
-- USE CASE:
-- SELECT gar_tmp_pcg_trans.f_adr_street_upd ('unsi') ; 
-- SELECT * from gar_tmp.obj_seq;
-- SELECT * FROM  gar_tmp_pcg_trans.f_adr_street_show (2) WHERE ( id_street > 50000000);
-- SELECT * FROM unsi.adr_street WHERE ( id_street > 50000000);
-- DELETE FROM unsi.adr_street WHERE ( id_street > 50000000);
