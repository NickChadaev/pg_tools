DROP PROCEDURE IF EXISTS gar_link.p_adr_house_idx_set_uniq (text, text, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_link.p_adr_house_idx_set_uniq (
         p_schema_name text -- Имя отдалённой схемы 
        ,p_conn        text    = NULL -- Именованное dblink-соединение  
        ,p_mode_t      boolean = TRUE -- Выбор типа индексов TRUE  - Эксплутационные
                                      --                    ,FALSE - Загрузочные
        ,p_uniq_sw     boolean = TRUE -- Уникальность "ak1", "ie2" - 
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
      _exec text;
      TABLE_NAME constant text = 'adr_house';
   
    BEGIN
     IF p_mode_t  -- Эксплуатационное покрытие
       THEN
         --
         CALL gar_link.p_execute_idx (
              p_exec := gar_link.f_index_get ( 
                     p_schema_name := p_schema_name    -- Имя схемы приёмника.
                    ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                    ,p_index_name  := 'adr_house_ak1' -- Имя индекса.   
                    ,p_mode_c      := FALSE            -- Создание индексов FALSE - удаление
                    ,p_kind_index  := TRUE             -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
              )
             ,p_conn := p_conn
           );
         --  
         CALL gar_link.p_execute_idx (
              p_exec := gar_link.f_index_get ( 
                     p_schema_name := p_schema_name    -- Имя схемы приёмника.
                    ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                    ,p_index_name  := 'adr_house_ak1' -- Имя индекса.   
                    ,p_mode_c      := TRUE         -- Создание индексов FALSE - удаление
                    ,p_kind_index  := TRUE         -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
                    ,p_unique_sign := p_uniq_sw
              )
             ,p_conn := p_conn
           );        
         
      ELSE -- Процессинговое покрытие.
         --
         CALL gar_link.p_execute_idx (
              p_exec := gar_link.f_index_get ( 
                           p_schema_name := p_schema_name    -- Имя схемы приёмника.
                          ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                          ,p_index_name  := '_xxx_adr_house_ie2' -- Имя индекса.   
                          ,p_mode_c      := FALSE            -- Создание индексов FALSE - удаление
                          ,p_kind_index  := FALSE         -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
              )
             ,p_conn := p_conn
           );
         --  
         CALL gar_link.p_execute_idx (
              p_exec := gar_link.f_index_get ( 
                           p_schema_name := p_schema_name    -- Имя схемы приёмника.
                          ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                          ,p_index_name  := '_xxx_adr_house_ie2' -- Имя индекса.   
                          ,p_mode_c      := TRUE         -- Создание индексов FALSE - удаление
                          ,p_kind_index  := FALSE         -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
                          ,p_unique_sign := p_uniq_sw
              )
             ,p_conn := p_conn
           );        
     END IF; -- p_mode_t   
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_adr_house_idx_set_uniq (text, text, boolean, boolean) 
  IS 'Управление индексами (Установка уникальности) в отдалённой таблице "adr_house".';  
-- ----- ------------------------------------------------------------------------------
-- USE CASE:
--
-- CALL gar_link.p_adr_house_idx_set_uniq (gar_link.f_conn_set(3), 'unnsi', true, true); 
--    Эксплуатационное покрытие, комплексный уникальный.
--
-- CALL gar_link.p_adr_house_idx_set_uniq (gar_link.f_conn_set(3), 'unnsi', true, false); 
--    Эксплуатационное покрытие, комплексный неуникальный.
--
-- CALL gar_link.p_adr_house_idx_set_uniq (gar_link.f_conn_set(4), 'unnsi', true, false); -- Убираю эксплуатационные
-- CALL gar_link.p_adr_house_idx_set_uniq (gar_link.f_conn_set(4), 'unnsi', false, false); -- Убираю загрузочные




 
