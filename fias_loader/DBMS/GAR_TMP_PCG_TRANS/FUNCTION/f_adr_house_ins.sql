DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_ins (text, text, text, uuid[], boolean, boolean);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_house_ins (
           p_schema_data    text -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl     text -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist    text -- Схема для хранения исторических данных 
          ,p_nm_guids_fias  uuid[]  = NULL  -- Список обрабатываемых GUID, NULL - все.
          ,p_sw             boolean = TRUE  -- Включить дополнение/обновление adr_objects
          ,p_sw_twin        boolean = FALSE -- Включается поиск двойников        
           --
          ,OUT total_row  integer  -- Общее количество обработанных строк.
          ,OUT ins_row    integer  -- Из них добавлено 
          ,OUT upd_row    integer  -- Из них обновлено (конфликты).
)
    RETURNS setof record
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
      ID_OBJECT_TYPE constant integer := 17; -- Это костыль, 
      --              кодификация типов разошлась с ГАР-ФИАС.
      --   Свести можно только том случае, если будет подружаться более широкая 
      --   номенклатура адресных объектов: квартиры, участки, автостоянки.            
   
     _r_ins   integer := 0;   
     --
     _parent gar_tmp.adr_street_t;
     _data   gar_tmp.xxx_adr_house_proc_t;  
     --
     _id_area    bigint;   
     _id_street  bigint;    
     --
     _id_house_type_1   bigint;  
     _id_house_type_2   bigint;  
     _id_house_type_3   bigint;
     --
     _nm_house_type_1   text;  -- 2022-02-21
     _nm_house_type_2   text;  
     _nm_house_type_3   text;
     --     
     _nm_house_full varchar(250); 

     _id_house  bigint; 

     _id_object    bigint;   
     
     -- 2022-10-18
     --
     INS_OP CONSTANT char(1) := 'I';
     UPD_OP CONSTANT char(1) := 'U';  
     
    -- 2022-11-25
    _select_type_0 text = 
        $_$
            SELECT y1.id_house_type, y1.nm_house_type_short 
              FROM %I.adr_house_type y1 
                  WHERE (%L = btrim(lower(y1.nm_house_type))) LIMIT 1;   
        $_$;     
        --
    _select_type_1 text = 
        $_$
             SELECT z1.id_house_type, z1.nm_house_type_short 
               FROM %I.xxx_adr_house_type z1 
                   WHERE (%L = z1.kd_house_type_lvl) LIMIT 1; 
        $_$;
        
    _exec text;    
     
   BEGIN
    -- ----------------------------------------------------------------------------------------
    --  2021-12-10 Nick  Обновление и дополнение адресных свойств домов.
    --  2022-01-24 Одна схема с обрабатываемыми данными и одна - для ссылки,
    --              на таблицы "адресные пространства" и улицы".
    --  2022-02-10  Исторические данные в отдельной схеме.
    --      -- --------------------------------------------------------------------------------
    --  2022-05-20 "Cause belli" - Необходимо определять дополнительные типы по их
    --                             именам, поставляемом в агрегированной структуре "xxx".
    --  Было:
    --    SELECT id_house_type, nm_house_type_short INTO _id_house_type_2, _nm_house_type_2
    --      FROM gar_tmp.xxx_adr_house_type WHERE (_data.add_type1 = kd_house_type_lvl) LIMIT 1;
    --    
    --  Необходимо          
    --    SELECT id_house_type, nm_house_type_short INTO _id_house_type_2, _nm_house_type_2
    --      FROM gar_tmp.xxx_adr_house_type 
    --                      WHERE (lower(_data.add_type1_name) = lower(nm_house_type)) LIMIT 1;          
    --    --          
    --    SELECT id_house_type, nm_house_type_short INTO _id_house_type_3, _nm_house_type_3
    --      FROM gar_tmp.xxx_adr_house_type 
    --                      WHERE (lower(_data.add_type2_name) = lower(nm_house_type)) LIMIT 1; 
    -- ----------------------------------------------------------------------------------------
    --   2022-05-31 - Уточняю определение родительского объекта и правила вычисления типов.   
    --   2022-10-18 - Вспомогательные таблицы.
    --   2022-11-21 - Преобразование типов ФИАС -> ЕС НСИ.  
    --   2023-10-23 - Родитель не находится, запись помещается в GAP-таблицу. _data.check_kind := 2
    -- ----------------------------------------------------------------------------------------
    --     p_schema_data   -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
    --    ,p_schema_etl    -- Схема эталон, обычно локальный сервер, копия p_schema_data 
    --    ,p_schema_hist   -- Схема для хранения исторических данных 
    --    ,p_nm_guids_fias -- Список обрабатываемых GUID, NULL - все.
    --    ,p_sw            -- Включить дополнение/обновление adr_objects
    --    ,p_sw_twin       -- Включается поиск двойников   
    -- ----------------------------------------------------------------------------------------
    FOR _data IN 
          SELECT 
                h.id_house
              , h.id_addr_parent
              , h.fias_guid         AS nm_fias_guid
              , h.parent_fias_guid  AS nm_fias_guid_parent
              , h.nm_parent_obj
              , h.region_code
              --
              , h.parent_type_id
              , h.parent_type_name
              , h.parent_type_shortname
              , h.parent_level_id
              , h.parent_level_name
              , h.parent_short_name
              -- 
              , h.house_num                AS house_num
              --
              , h.add_num1                 AS add_num1            
              , h.add_num2                 AS add_num2            
              , h.house_type               AS house_type          
              , h.house_type_name          AS house_type_name     
              , h.house_type_shortname     AS house_type_shortname
              --
              , h.add_type1                AS add_type1          
              , h.add_type1_name           AS add_type1_name     
              , h.add_type1_shortname      AS add_type1_shortname
              , h.add_type2                AS add_type2          
              , h.add_type2_name           AS add_type2_name     
              , h.add_type2_shortname      AS add_type2_shortname
                --
               ,(p.type_param_value -> '5'::text)  AS nm_zipcode   
               ,(p.type_param_value -> '7'::text)  AS kd_oktmo
               ,(p.type_param_value -> '6'::text)  AS kd_okato    
              --
              , h.oper_type_id
              , h.oper_type_name
              
           FROM gar_tmp.xxx_adr_house h  
              
              INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = h.fias_guid) 
              LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (h.id_house = p.object_id)              
              
            WHERE (f.id_obj IS NULL) AND (f.type_object = 2) 
                    AND
                  (((h.fias_guid = ANY (p_nm_guids_fias)) AND 
	               (p_nm_guids_fias IS NOT NULL)) OR (p_nm_guids_fias IS NULL)
	              )                     
       LOOP
         _parent := gar_tmp_pcg_trans.f_adr_street_get (p_schema_etl, _data.nm_fias_guid_parent);
         _id_area   := _parent.id_area;   
         _id_street := _parent.id_street;    
         
         IF (_id_area IS NULL) 
           THEN                                            -- _schema_name
             _id_area   := (gar_tmp_pcg_trans.f_adr_area_get (p_schema_etl, _data.nm_fias_guid_parent)).id_area;   
             _id_street := NULL;  
         END IF;
         --  
         --                               
         IF (_id_area IS NULL)     -- НЕ были загружены Ни улицы, Ни адресные объекты.
           THEN                    -- ??? Костыль 
                 _data.check_kind := 2;
                 CALL gar_tmp_pcg_trans.p_xxx_adr_house_gap_put (_data);
                 CONTINUE;  
         END IF;
         
         _id_house_type_1 := NULL; 
         _nm_house_type_1 := NULL;
         --
         -- 2022-05-20 !!! Создаются новые записи.
         -- 2022-11-21/2022-12-05, Тип, вычисляется на локальных данных.
         --
         IF (EXISTS (SELECT 1 FROM gar_tmp.xxx_adr_house_type 
                                WHERE (_data.house_type = ANY (fias_ids))
                    )
             ) 
           THEN  
              SELECT  id_house_type, nm_house_type_short 
                        INTO _id_house_type_1, _nm_house_type_1
              FROM gar_tmp_pcg_trans.f_house_type_get (p_schema_etl, _data.house_type);
              
           ELSIF (_data.house_type IS NOT NULL) 
               THEN
                    CALL gar_tmp_pcg_trans.p_xxx_adr_house_gap_put (_data);
         END IF;         
         --
         IF ((_id_house_type_1 IS NULL) OR (_nm_house_type_1 IS NULL))-- 2022-02-21
           THEN                     
                 _data.check_kind := 2;
                 CALL gar_tmp_pcg_trans.p_xxx_adr_house_gap_put (_data);
                 CONTINUE;  
         END IF;
         --
         _nm_house_full := '';
         _nm_house_full := _nm_house_full || _nm_house_type_1 || ' ' || _data.house_num || ' ';
         
         _id_house_type_2 := NULL; 
         _nm_house_type_2 := NULL;
         
         IF (_data.add_type1 IS NOT NULL) 
           THEN
             -- SELECT y1.id_house_type, y1.nm_house_type_short 
             --                                INTO _id_house_type_2, _nm_house_type_2
             --   FROM gar_tmp.xxx_adr_house_type y1 
             --       WHERE (btrim(lower(_data.add_type1_name)) = btrim(lower(y1.nm_house_type))) LIMIT 1;   
             -- --   
              _exec := format (_select_type_0, p_schema_etl, btrim(lower(_data.add_type1_name))); 
              EXECUTE _exec INTO _id_house_type_2, _nm_house_type_2;  
              --
              -- 2022-05-31
              IF ( _id_house_type_2 IS NULL) OR (_nm_house_type_2 IS NULL)
                THEN
                  --  SELECT z1.id_house_type, z1.nm_house_type_short 
                  --                    INTO _id_house_type_2, _nm_house_type_2
                  --    FROM gar_tmp.xxx_adr_house_type z1 
                  --        WHERE (_data.add_type1 = z1.kd_house_type_lvl) LIMIT 1; 
                     --
                    _exec := format (_select_type_1, p_schema_etl, _data.add_type1); 
                    EXECUTE _exec INTO _id_house_type_2, _nm_house_type_2;                       
              END IF;
              -- 2022-05-31
         END IF;         
         --
         _id_house_type_3 := NULL; 
         _nm_house_type_3 := NULL;
         --
         IF (_data.add_type2 IS NOT NULL) 
           THEN
              -- SELECT y2.id_house_type, y2.nm_house_type_short 
              --                                 INTO _id_house_type_3, _nm_house_type_3
              --   FROM gar_tmp.xxx_adr_house_type y2 
              --      WHERE (btrim(lower(_data.add_type2_name)) = btrim(lower(y2.nm_house_type))) LIMIT 1;
                   
              _exec := format (_select_type_0, p_schema_etl, btrim(lower(_data.add_type2_name))); 
              EXECUTE _exec INTO _id_house_type_3, _nm_house_type_3;  
              
              -- 2022-05-31
              IF ( _id_house_type_3 IS NULL) OR (_nm_house_type_3 IS NULL)
                THEN
                   -- SELECT z2.id_house_type, z2.nm_house_type_short 
                   --                   INTO _id_house_type_3, _nm_house_type_3
                   --   FROM gar_tmp.xxx_adr_house_type z2 
                   --       WHERE (_data.add_type2 = z2.kd_house_type_lvl) LIMIT 1;   
                          
                    _exec := format (_select_type_1, p_schema_etl, _data.add_type2); 
                    EXECUTE _exec INTO _id_house_type_3, _nm_house_type_3;                       
                          
              END IF;
              -- 2022-05-31
         END IF;        
         --         
         IF (_data.add_num1 IS NOT NULL) AND (_nm_house_type_2 IS NOT NULL)
           THEN
             _nm_house_full := _nm_house_full || _nm_house_type_2 || ' ' || _data.add_num1 || ' ';    
            ELSE         
                _id_house_type_2 := NULL;
                _nm_house_type_2 := NULL;
         END IF;
         --
         IF (_data.add_num2 IS NOT NULL) AND (_nm_house_type_3 IS NOT NULL)
           THEN
               _nm_house_full := _nm_house_full || _nm_house_type_3 || ' ' || _data.add_num2;     
            ELSE                
                _id_house_type_3 := NULL;
                _nm_house_type_3 := NULL;
         END IF;    
         
         _id_house  := nextval (' gar_tmp.obj_seq'); 
         _id_object := _id_house;  
         _nm_house_full := btrim (_nm_house_full); 
         
         CALL  gar_tmp_pcg_trans.p_adr_house_ins (
         
               p_schema_name := p_schema_data
              ,p_schema_h    := p_schema_hist       
                --
              ,p_id_house := _id_house --  bigint       --  NOT NULL
               --
              ,p_id_area   :=  _id_area::bigint         --  NOT NULL
              ,p_id_street :=  _id_street::bigint       --   NULL
               --
              ,p_id_house_type_1   :=  _id_house_type_1::integer           --   NULL
              ,p_nm_house_1        :=  _data.house_num::varchar(70)        --   NULL
              ,p_id_house_type_2   :=  _id_house_type_2::integer           --   NULL
              ,p_nm_house_2        :=  _data.add_num1::varchar(50)   --   NULL
              ,p_id_house_type_3   :=  _id_house_type_3::integer           --   NULL
              ,p_nm_house_3        :=  _data.add_num2::varchar(50)   --   NULL
               --
              ,p_nm_zipcode        := _data.nm_zipcode::varchar(20)  --   NULL
              
              ,p_nm_house_full     := _nm_house_full --  varchar(250) --  NOT NULL
              
              ,p_kd_oktmo          := _data.kd_oktmo::varchar(11)  --  NULL
              ,p_nm_fias_guid      := _data.nm_fias_guid::uuid     --  NULL  
              ,p_id_data_etalon    := NULL::bigint       --  NULL
              ,p_kd_okato          := _data.kd_okato::varchar(11)  --  NULL
              ,p_vl_addr_latitude  := NULL::numeric      --  NULL
              ,p_vl_addr_longitude := NULL::numeric      --  NULL 
               --
              ,p_sw := p_sw_twin 
         );
         -- Адресный объект, пока только улицы (участки, квартиры и офисы).
         IF p_sw  THEN -- дополняем адресные объекты
         ----------------------------------------------------------------------
                 CALL gar_tmp_pcg_trans.p_adr_object_ins (
         
                       p_schema_name := p_schema_data
                      ,p_schema_h    := p_schema_hist                  
                        --
                      ,p_id_object := _id_object   --  NOT NULL
                      ,p_id_area   := _id_area::bigint               --  NOT NULL
                      ,p_id_house  := _id_house::bigint              --  NOT NULL
                      ,p_id_object_type   := ID_OBJECT_TYPE          --  NOT NULL
                      ,p_id_street        := _id_street::bigint                  -- NULL 
                      ,p_nm_object        := _nm_house_full::varchar(250) --      NULL
                      ,p_nm_object_full   := _nm_house_full::varchar(500) --  NOT NULL
                      ,p_nm_description   := _nm_house_full::varchar(150) --      NULL
                      ,p_id_data_etalon   := NULL::bigint                 --      NULL
                      ,p_id_metro_station := NULL::integer      --      NULL
                      ,p_id_autoroad      := NULL::integer      --      NULL
                      ,p_nn_autoroad_km   := NULL::numeric      --      NULL
                      ,p_nm_fias_guid     := _data.nm_fias_guid::uuid      --  NULL
                      ,p_nm_zipcode       := _data.nm_zipcode::varchar(20) --  NULL
                      ,p_kd_oktmo         := _data.kd_oktmo::varchar(11)   --  NULL
                      ,p_kd_okato         := _data.kd_okato::varchar(11)   --  NULL
                      ,p_vl_addr_latitude  := NULL::numeric      --  NULL
                      ,p_vl_addr_longitude := NULL::numeric      --  NULL 
                       --
                      ,p_sw := p_sw_twin                       
                 );         
         ----------------------------------------------------------------------  
         END IF;
  
         _r_ins := _r_ins + 1; 
         
       END LOOP; -- FOR _data SELECT
    
    total_row := _r_ins;
    ins_row := (SELECT count(1) FROM gar_tmp.adr_house_aux WHERE (op_sign = INS_OP));
    upd_row := (SELECT count(1) FROM gar_tmp.adr_house_aux WHERE (op_sign = UPD_OP));
    
    RETURN NEXT;    
   END;                   
  $$;
 
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_house_ins (text, text, text, uuid[], boolean, boolean) 
IS 'Дополнение адресных свойств домов';
----------------------------------------------------------------------------------
-- USE CASE:
-- SELECT gar_tmp_pcg_trans.f_adr_house_ins ('unsi'); 
-- SELECT * from gar_tmp.obj_seq;
-- SELECT * FROM unsi.adr_house WHERE (id_house > 50000000);
-- SELECT * FROM unsi.adr_objects WHERE (id_object > 50000000);
-- DELETE FROM unsi.adr_house WHERE (id_house > 50000000);
-- DELETE FROM unsi.adr_objects WHERE (id_object > 50000000);
-- SELECT * FROM gar_tmp_pcg_trans.f_adr_house_show (2);
