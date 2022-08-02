DROP PROCEDURE IF EXISTS gar_link.p_adr_house_idx (text, text, boolean, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_link.p_adr_house_idx (
           p_conn         text -- Именованное dblink-соединение   
          ,p_schema_name  text -- Имя отдалённой схемы 
          ,p_mode_t       boolean = TRUE -- Выбор типа индексов TRUE  - Эксплутационные
                                         --                    ,FALSE - Загрузочные
          ,p_mode_c       boolean = TRUE  -- Создание индексов FALSE   - удаление  
          ,p_uniq_sw      boolean = TRUE  -- Уникальность "ak1", "ie2" - 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS 

  $$
   -- -----------------------------------------------------------------------------------
   --  2021-01-31  unnsi.adr_house  Управление индексами в отдалённой таблице.
   --  2022-02-11  В уникальный первого загрузочного индекса добавлен "id_house_type_1".
   --  2022-03-04  Изменения в управлении уникальности: 
   --     Эксплуатационные индексы - "ak1" - либо уникальный, либо нет.
   --     Загрузочные  индексы - "ie2" - либо уникальный либо нет.
   -- ------------------------------------------------------------------------------------                 
    DECLARE 
       _mess text;
       --
      _idx_name    text;

      _idx_names_0 text[] := ARRAY [
                                  'adr_house_i1 '
                                 ,'adr_house_i2 '
                                 ,'adr_house_i3 '
                                 ,'adr_house_i4 '
                                 ,'adr_house_i5 '
                                 ,'adr_house_i7 '
                                 ,'adr_house_idx1 '                                 
                                 ]::text[];
       --
      _idx_signs_0 text[] := ARRAY [
                                  'ON %I.adr_house USING btree (id_area)'
                                 ,'ON %I.adr_house USING btree (id_street)'
                                 ,'ON %I.adr_house USING btree (id_house_type_1)'
                                 ,'ON %I.adr_house USING btree (id_house_type_2)'
                                 ,'ON %I.adr_house USING btree (id_house_type_3)'
                                 ,'ON %I.adr_house USING btree (nm_fias_guid)'
                                 ,'ON %I.adr_house USING btree (id_area) WHERE (id_street IS NULL)'
                                 
                                 ]::text[];
                                        
      _u_idx_name_0 text := 'adr_house_ak1 ';                           

      _u_idx_sign_0 text := 'ON %I.adr_house USING btree (id_area, upper((nm_house_full)::text), id_street)  WHERE (id_data_etalon IS NULL)';  
       --
       ---- 
       --
      _idx_name_1  text := '_xxx_adr_house_ie2 ';

      _idx_sign_1  text := 'ON %I.adr_house USING btree (nm_fias_guid ASC NULLS LAST)
                        WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL)';
                     
      _u_idx_name_1 text := '_xxx_adr_house_ak1 ';
       --
      _u_idx_sign_1 text := 'ON %I.adr_house USING btree
                              (id_area ASC NULLS LAST
                              ,upper (nm_house_full::text) ASC NULLS LAST
                              ,id_street ASC NULLS LAST
                              ,id_house_type_1 ASC NULLS LAST
                              )
                          WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL)';          
       --                   
       ----
       --
      _crt_idx    text := $_$ CREATE INDEX IF NOT EXISTS %s; $_$;  
      _crt_un_idx text := $_$ CREATE UNIQUE INDEX IF NOT EXISTS %s; $_$; 
      _drp_idx    text := $_$ DROP INDEX IF EXISTS %I.%s; $_$; 
      
      _exec    text;
      _qty     integer;
      _i       integer := 1;
   
    BEGIN
     IF p_mode_t  -- Эксплутационные индексы
        THEN
        _qty := array_length (_idx_names_0, 1);
        
        LOOP
          _idx_name := _idx_names_0 [_i];
          IF p_mode_c -- Create
            THEN 
              _exec := format (_crt_idx, _idx_name || format (_idx_signs_0 [_i], p_schema_name));
              RAISE NOTICE '%', _exec;
               
              SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
              RAISE NOTICE '%', _mess;
                     
             ELSE --Drop
                  _exec := format (_drp_idx, p_schema_name, _idx_name);
                  RAISE NOTICE '%', _exec;
                     
                  SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
                  RAISE NOTICE '%', _mess;
          END IF; -- p_mode_c Create/Drop
          --
          _i := _i + 1;
          EXIT WHEN (_i > _qty);
        END LOOP;
        
        -- Уникальный индекс
        IF p_mode_c
         THEN
           IF p_uniq_sw -- 2022-03-04
             THEN
                 _exec := format (_crt_un_idx, (_u_idx_name_0 || format (_u_idx_sign_0, p_schema_name)));
             ELSE
                 _exec := format (_crt_idx, (_u_idx_name_0 || format (_u_idx_sign_0, p_schema_name)));
           END IF;
           RAISE NOTICE '%', _exec;
              
           SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
           RAISE NOTICE '%', _mess;
         ---  
         ELSE -- drop
             _exec := format (_drp_idx, p_schema_name, _u_idx_name_0);
             RAISE NOTICE '%', _exec;   
               
             SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
             RAISE NOTICE '%', _mess;            
        
        END IF; -- p_mode_c
        
      ELSE -- Загрузочные индексы.
      
        IF p_mode_c
         THEN
         -- Уникальный индекс переделанный из обычного.
           IF p_uniq_sw
             THEN
                 _exec := format (_crt_un_idx, (_idx_name_1 || format (_idx_sign_1, p_schema_name)));
             ELSE
                 _exec := format (_crt_idx, (_idx_name_1 || format (_idx_sign_1, p_schema_name)));
           END IF;
           RAISE NOTICE '%', _exec;
              
           SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
           RAISE NOTICE '%', _mess;           
           --
           -- Уникальный комплексный индекс.
           _exec := format (_crt_un_idx, (_u_idx_name_1 || format (_u_idx_sign_1, p_schema_name)));
           RAISE NOTICE '%', _exec;
              
           SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
           RAISE NOTICE '%', _mess;
         ---  
         ELSE -- drop
             _exec := format (_drp_idx, p_schema_name, _idx_name_1);
             RAISE NOTICE '%', _exec;   
               
             SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
             RAISE NOTICE '%', _mess;           
         
             _exec := format (_drp_idx, p_schema_name, _u_idx_name_1);
             RAISE NOTICE '%', _exec;   
               
             SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
             RAISE NOTICE '%', _mess;            
        
        END IF; -- p_mode_c      
        
     END IF; -- p_mode_t   
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_adr_house_idx (text, text, boolean, boolean, boolean) 
  IS 'Управление индексами в отдалённой таблице "adr_house".';  
-- ----- ----------------------------------------------------
-- USE CASE:
--
-- CALL gar_link.p_adr_house_idx (gar_link.f_conn_set(4), 'unnsi', true, true); -- Создаю эксплуатационные
-- CALL gar_link.p_adr_house_idx (gar_link.f_conn_set(4), 'unnsi', false, true, false); -- Создание загрузочных
--
-- CALL gar_link.p_adr_house_idx (gar_link.f_conn_set(4), 'unnsi', true, false); -- Убираю эксплуатационные
-- CALL gar_link.p_adr_house_idx (gar_link.f_conn_set(4), 'unnsi', false, false); -- Убираю загрузочные




 
