DROP PROCEDURE IF EXISTS gar_link.p_adr_street_idx (text, text, boolean, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_link.p_adr_street_idx (
      p_schema_name  text -- Имя отдалённой схемы 
     ,p_conn         text    = NULL -- Именованное dblink-соединение   
     ,p_mode_t       boolean = TRUE -- Выбор типа индексов TRUE  - Эксплутационные
                                    --                    ,FALSE - Загрузочные
     ,p_mode_c       boolean = TRUE  -- Создание индексов FALSE - удаление  
     ,p_uniq_sw      boolean = TRUE  -- Уникальность "ak1", "ie2" -          
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS 

  $$
   -- --------------------------------------------------------------------------
   --  2022-01-31  unnsi. adr_street  Управление индексами в отдалённой таблице.
   --  2022-04-29  Изменения в управлении уникальности, "p_uniq_sw": 
   --     Эксплуатационные индексы - "ak1" - либо уникальный, либо нет.
   --     Загрузочные  индексы - "ie2" - либо уникальный либо нет.
   -- --------------------------------------------------------------------------
   --  2022-11-10  Использованиен индексного хранилища. 
   -- --------------------------------------------------------------------------                 
    DECLARE 
      _mess text;
      _exec text;
      TABLE_NAME constant text = 'adr_street';
   
    BEGIN
     IF NOT p_mode_c -- Удаление.
       THEN
           FOR _exec IN  SELECT gar_link.f_index_get ( 
                 p_schema_name := p_schema_name -- Имя схемы приёмника.
                ,p_table_name  := TABLE_NAME    -- Имя таблицы 
                ,p_index_name  := NULL          -- Имя индекса.   
                ,p_mode_c      := FALSE         -- Создание индексов FALSE - удаление
                ,p_kind_index  := p_mode_t      -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный..
           )
            LOOP 
                 CALL gar_link.p_execute_idx (_exec, p_conn);
            END LOOP;    
    
      ELSIF p_mode_t -- Создание, эксплуатационные (начинается веселие).
          THEN
             CALL gar_link.p_execute_idx (
                   p_exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_street_i1' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
                   )
                  ,p_conn := p_conn
             );
             --
             CALL gar_link.p_execute_idx (
                   p_exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_street_i2' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
                   )
                  ,p_conn := p_conn
             );
             --
             CALL gar_link.p_execute_idx (
                   p_exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_street_i3' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
                   )
                  ,p_conn := p_conn
             );
             --
             CALL gar_link.p_execute_idx (
                   p_exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name   -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME      -- Имя таблицы 
                       ,p_index_name  := 'adr_street_i4' -- Имя индекса.   
                       ,p_mode_c      := TRUE            -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE            -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
                   )
                  ,p_conn := p_conn
             );
             --             
             CALL gar_link.p_execute_idx (
                   p_exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name    -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                       ,p_index_name  := 'adr_street_ak1' -- Имя индекса.   
                       ,p_mode_c      := TRUE             -- Создание индексов FALSE - удаление
                       ,p_kind_index  := TRUE             -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
                   )
                  ,p_conn := p_conn
             );             --
             
          ELSE -- Процессинговые индексы.
          
             CALL gar_link.p_execute_idx (
                   p_exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name    -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                       ,p_index_name  := '_xxx_adr_street_ie2' -- Имя индекса.   
                       ,p_mode_c      := TRUE             -- Создание индексов FALSE - удаление
                       ,p_kind_index  := FALSE             -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
                   )
                  ,p_conn := p_conn
             );          
             --
             CALL gar_link.p_execute_idx (
                   p_exec := gar_link.f_index_get ( 
                        p_schema_name := p_schema_name    -- Имя схемы приёмника.
                       ,p_table_name  := TABLE_NAME       -- Имя таблицы 
                       ,p_index_name  := '_xxx_adr_street_ak1' -- Имя индекса.   
                       ,p_mode_c      := TRUE             -- Создание индексов FALSE - удаление
                       ,p_kind_index  := FALSE             -- Вид индекса (FALSE - процессинговый) -- TRUE -- эксплуатационный.
                   )
                  ,p_conn := p_conn
             );               
     END IF; -- p_mode_c -- Удаление, создание.
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_adr_street_idx (text, text, boolean, boolean, boolean) 
  IS 'Управление индексами в отдалённой таблице "adr_street".';  
-- ----- ----------------------------------------------------
-- USE CASE:
--
-- SELECT gar_link.f_server_is(); -- unnsi_m12l
-- SELECT * FROM gar_link.v_servers_active;  -- 12
--
-- CALL gar_link.p_execute_idx (gar_link.f_conn_set(12), 'unnsi', false, false); -- Убиваю процессинговые
-- CALL gar_link.p_execute_idx (gar_link.f_conn_set(12), 'unnsi', false, true); -- Создаю процессинговые
-- CALL gar_link.p_execute_idx (gar_link.f_conn_set(12), 'unnsi', false, false); -- Убиваю процессинговые
-- CALL gar_link.p_execute_idx (gar_link.f_conn_set(12), 'unnsi', false, true, false); -- Создаю процессинговые, второй не уникальный
-- CALL gar_link.p_execute_idx (gar_link.f_conn_set(12), 'unnsi', false, false); -- Убиваю процессинговые
--
-- CALL gar_link.p_execute_idx (gar_link.f_conn_set(12), 'unnsi', true, true); -- Создаю эксплуатационные
-- CALL gar_link.p_execute_idx (gar_link.f_conn_set(12), 'unnsi', true, false); -- Убиваю эксплуатационные
-- CALL gar_link.p_execute_idx (gar_link.f_conn_set(12), 'unnsi', true, true, false); -- Создаю эксплуатационные? всё неуникально.
-- CALL gar_link.p_execute_idx (gar_link.f_conn_set(12), 'unnsi', true, false); -- Убиваю эксплуатационные 
--
-- CALL gar_link.p_execute_idx (gar_link.f_conn_set(12), 'unnsi', false, true); -- Создаю процессинговые
