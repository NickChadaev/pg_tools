DROP PROCEDURE IF EXISTS gar_link.p_adr_street_idx_set_uniq (text, text, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_link.p_adr_street_idx_set_uniq (
           p_conn         text -- Именованное dblink-соединение   
          ,p_schema_name  text -- Имя отдалённой схемы 
          ,p_mode_t       boolean = TRUE -- Выбор типа индексов TRUE  - Эксплутационные
                                         --                    ,FALSE - Загрузочные
          ,p_uniq_sw      boolean = TRUE -- Уникальность "ak1", "ie2" - 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS 

  $$
   -- --------------------------------------------------------------------------
   --  2022-03-24  unnsi.adr_house  Управление уникальностью: 
   --     Эксплуатационные индексы - "ak1" - либо уникальный, либо нет.
   --     Загрузочные  индексы - "ie2" - либо уникальный либо нет.
   --     Фактически реализована пара последовательных команд: DROP/CREATE.
   -- --------------------------------------------------------------------------                 
    DECLARE 
      _mess text;
      --                                      
      -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      _u_idx_name_0 text := 'adr_street_ak1 ';                           
      _u_idx_sign_0 text := 'ON %I.adr_street USING btree (id_area, upper((nm_street)::text), id_street_type)
   WHERE (id_data_etalon IS NULL)';                           
       --
      _idx_name_1  text := '_xxx_adr_street_ie2 ';
      _idx_sign_1  text := 'ON %I.adr_street USING btree (nm_fias_guid ASC NULLS LAST)
                            WHERE id_data_etalon IS NULL AND dt_data_del IS NULL';
       -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       
      _crt_idx    text := $_$ CREATE INDEX IF NOT EXISTS %s; $_$;  
      _crt_un_idx text := $_$ CREATE UNIQUE INDEX IF NOT EXISTS %s; $_$; 
      _drp_idx    text := $_$ DROP INDEX IF EXISTS %I.%s; $_$;       
      
      _exec    text;
   
    BEGIN
     IF p_mode_t  -- Эксплуатационное покрытие
       THEN
         -- Комплексный индекс
         --
         _exec := format (_drp_idx, p_schema_name, _u_idx_name_0);
         RAISE NOTICE '%', _exec;   
           
         SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
         RAISE NOTICE '%', _mess;            
        
         IF p_uniq_sw -- 2022-03-04
           THEN
               _exec := format (_crt_un_idx, (_u_idx_name_0 || format (_u_idx_sign_0, p_schema_name)));
           ELSE
               _exec := format (_crt_idx, (_u_idx_name_0 || format (_u_idx_sign_0, p_schema_name)));
         END IF;
         RAISE NOTICE '%', _exec;
              
         SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
         RAISE NOTICE '%', _mess;
        
      ELSE -- Загрузочное покрытие.
      
         -- Уникальный индекс переделанный из обычного. (UUID - уникален).
         _exec := format (_drp_idx, p_schema_name, _idx_name_1);
         RAISE NOTICE '%', _exec;   
           
         SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
         RAISE NOTICE '%', _mess; 
         --      
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
     END IF; -- p_mode_t   
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_adr_street_idx_set_uniq (text, text, boolean, boolean) 
  IS 'Управление индексами (Установка уникальности) в отдалённой таблице "adr_street".';  
-- ----- ------------------------------------------------------------------------------
-- USE CASE:
--
-- CALL gar_link.p_adr_street_idx_set_uniq (gar_link.f_conn_set(3), 'unnsi', true, true); 
--    Эксплуатационное покрытие, комплексный уникальный.
--
-- CALL gar_link.p_adr_street_idx_set_uniq (gar_link.f_conn_set(3), 'unnsi', true, false); 
--    Эксплуатационное покрытие, комплексный неуникальный.
--
-- SELECT gar_link.f_server_is(); -- unnsi_l
-- SELECT * FROM gar_link.v_servers_active;  -- 2
-- CALL gar_link.p_adr_street_idx_set_uniq (gar_link.f_conn_set(2), 'unnsi', true, false); -- Неуникальный эксплуатационный
-- CALL gar_link.p_adr_street_idx_set_uniq (gar_link.f_conn_set(2), 'unnsi', true, true); -- Неуникальный эксплуатационный
--   Ключ (id_area, upper(nm_street::text), id_street_type)=(172927, ЛИЛОВЫЙ, 37) дублируется.
--
-- CALL gar_link.p_adr_street_idx_set_uniq (gar_link.f_conn_set(2), 'unnsi', false, false); -- Неуникальный загрузочные
-- CALL gar_link.p_adr_street_idx_set_uniq (gar_link.f_conn_set(2), 'unnsi', false, true);
--  Ключ (nm_fias_guid)=(9225e8bc-559d-4aa2-b72d-5896641e4e02) дублируется.




 
