DROP PROCEDURE IF EXISTS gar_link.p_adr_objects_idx (text, text, boolean, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_link.p_adr_objects_idx (
           p_conn         text -- Именованное dblink-соединение   
          ,p_schema_name  text -- Имя отдалённой схемы 
          ,p_mode_t       boolean = TRUE -- Выбор типа индексов TRUE  - Эксплутационные
                                         --                    ,FALSE - Загрузочные
          ,p_mode_c       boolean = TRUE  -- Создание индексов FALSE - удаление  
          ,p_uniq_x2      boolean = TRUE  -- Уникальность второго загрузочного индекса.
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS 

  $$
   -- --------------------------------------------------------------------------
   --   2021-01-31  unnsi.adr_object  Управление индексами в отдалённой таблице.
   -- --------------------------------------------------------------------------                 
    DECLARE 
       _mess text;
       --
      _idx_name    text;

      _idx_names_0 text[] := ARRAY [
                                  'adr_objects_i1 '
                                 ,'adr_objects_i2 '
                                 ,'adr_objects_i3 '
                                 ,'adr_objects_i4 '
                                 ,'adr_objects_i8 '
                                 ]::text[];
       --
      _idx_signs_0 text[] := ARRAY [
                                  'ON %I.adr_objects USING btree (id_area)'
                                 ,'ON %I.adr_objects USING btree (id_street)'
                                 ,'ON %I.adr_objects USING btree (id_house)'
                                 ,'ON %I.adr_objects USING btree (id_object_type)'
                                 ,'ON %I.adr_objects USING btree (nm_fias_guid)'
                                 ]::text[];
                                        
      _u_idx_name_0 text := 'adr_objects_ak1 ';                           

      _u_idx_sign_0 text := 'ON %I.adr_objects USING btree (id_area, id_object_type, upper((nm_object_full)::text), id_street, id_house)
    WHERE (id_data_etalon IS NULL)';  
       --
       ---- 
       --
      _idx_name_1  text := '_xxx_adr_objects_ie2 ';

      _idx_sign_1  text := 'ON %I.adr_objects USING btree
                          (nm_fias_guid ASC NULLS LAST)
                          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL';
                     
      _u_idx_name_1 text := '_xxx_adr_objects_ak1 ';
       --
      _u_idx_sign_1 text := 'ON %I.adr_objects USING btree
                ( id_area ASC NULLS LAST
                , id_object_type ASC NULLS LAST
                , upper(nm_object_full::text) ASC NULLS LAST
                , id_street ASC NULLS LAST
                , id_house ASC NULLS LAST
                )
            WHERE id_data_etalon IS NULL AND dt_data_del IS NULL';          
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
           _exec := format (_crt_un_idx, (_u_idx_name_0 || format (_u_idx_sign_0, p_schema_name)));
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
           IF p_uniq_x2
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
  
COMMENT ON PROCEDURE gar_link.p_adr_objects_idx (text, text, boolean, boolean, boolean) 
  IS 'Управление индексами в отдалённой таблице "adr_objects".';  
-- ----- ----------------------------------------------------
-- USE CASE:
--
-- CALL gar_link.p_adr_objects_idx (gar_link.f_conn_set(4), 'unnsi', true, true); -- Создаю эксплуатационные
-- CALL gar_link.p_adr_objects_idx (gar_link.f_conn_set(4), 'unnsi', false, true, false); -- Создание загрузочных
--
-- CALL gar_link.p_adr_objects_idx (gar_link.f_conn_set(4), 'unnsi', true, false); -- Убираю эксплуатационные
-- CALL gar_link.p_adr_objects_idx (gar_link.f_conn_set(4), 'unnsi', false, false); -- Убираю загрузочные




 
