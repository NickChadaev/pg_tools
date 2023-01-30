DROP PROCEDURE IF EXISTS gar_link.p_adr_street_idx_set_uniq (text, text, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_link.p_adr_street_idx_set_uniq (
           p_schema_name  text -- Имя отдалённой схемы 
          ,p_conn         text -- Именованное dblink-соединение   
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
   --  2022-11-22 Используется индексное хранилище.
   -- --------------------------------------------------------------------------                 
    DECLARE 
      _mess text;
      _exec text;
      TABLE_NAME constant text = 'adr_street';
   
    BEGIN
     IF p_mode_t  -- Эксплуатационное покрытие
       THEN
         _exec := gar_link.f_index_get ( 
                     p_schema_name := p_schema_name    -- Имя схемы приёмника.
                    ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                    ,p_index_name  := 'adr_street_ak1' -- Имя индекса.   
                    ,p_mode_c      := FALSE            -- Создание индексов FALSE - удаление
                    ,p_kind_index  := TRUE             -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
         );
         CALL gar_link.p_execute_idx (_exec, p_conn);
         --  
         _exec := gar_link.f_index_get ( 
                     p_schema_name := p_schema_name    -- Имя схемы приёмника.
                    ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                    ,p_index_name  := 'adr_street_ak1' -- Имя индекса.   
                    ,p_mode_c      := TRUE         -- Создание индексов FALSE - удаление
                    ,p_kind_index  := TRUE         -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
                    ,p_unique_sign := p_uniq_sw
         );         
         CALL gar_link.p_execute_idx (_exec, p_conn);        
         
      ELSE -- Процессинговое покрытие.
         --
         _exec := gar_link.f_index_get ( 
                      p_schema_name := p_schema_name    -- Имя схемы приёмника.
                     ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                     ,p_index_name  := '_xxx_adr_street_ie2' -- Имя индекса.   
                     ,p_mode_c      := FALSE            -- Создание индексов FALSE - удаление
                     ,p_kind_index  := FALSE         -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
         );         
         CALL gar_link.p_execute_idx (_exec, p_conn);
         --  
         _exec := gar_link.f_index_get ( 
                           p_schema_name := p_schema_name    -- Имя схемы приёмника.
                          ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                          ,p_index_name  := '_xxx_adr_street_ie2' -- Имя индекса.   
                          ,p_mode_c      := TRUE         -- Создание индексов FALSE - удаление
                          ,p_kind_index  := FALSE         -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
                          ,p_unique_sign := p_uniq_sw
         );         
         CALL gar_link.p_execute_idx (_exec, p_conn);        
     END IF; -- p_mode_t   
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_adr_street_idx_set_uniq (text, text, boolean, boolean) 
  IS 'Управление индексами (Установка уникальности) в отдалённой/локальной таблице "adr_street".';  
-- ----- ------------------------------------------------------------------------------
-- USE CASE:
--
-- CALL gar_link.p_adr_street_idx_set_uniq (gar_link.f_conn_set(3), 'unnsi', true, true); 
--
-- CALL gar_link.p_adr_street_idx_set_uniq ('gar_tmp', NULL, true, true);
--
-- SELECT gar_link.f_server_is();  
-- SELECT * FROM gar_link.v_servers_active;   

-- CALL gar_link.p_adr_street_idx_set_uniq (gar_link.f_conn_set(2), 'unnsi', true, false); -- Неуникальный эксплуатационный




 
