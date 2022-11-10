DROP PROCEDURE IF EXISTS gar_link.p_adr_area_idx (text, text, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_link.p_adr_area_idx (
              p_conn         text -- Именованное dblink-соединение   
             ,p_schema_name  text -- Имя отдалённой схемы 
             ,p_mode_t       boolean = TRUE -- Выбор типа индексов TRUE  - Эксплутационные
                                            --                    ,FALSE - Загрузочные
             ,p_mode_c       boolean = TRUE  -- Создание индексов FALSE - удаление             
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS 

  $$
   -- --------------------------------------------------------------------------
   --   2021-01-31  unnsi.adr_area  Управление индексами в отдалённой таблице.
   --   2022-11-10  Использованиен индексного хранилища. 
   -- --------------------------------------------------------------------------                 
    DECLARE 
     _mess    text;
     _exec    text;
     TABLE_NAME constant text = 'adr_area';
   
    BEGIN
     FOR _exec IN  SELECT gar_link.f_index_get ( 
                p_schema_name := p_schema_name  -- Имя схемы приёмника.
               ,p_table_name  := TABLE_NAME -- Имя таблицы 
               ,p_index_name  := NULL       -- Имя индекса.   
               ,p_mode_c      := p_mode_c -- Создание индексов FALSE - удаление
               ,p_kind_index  := p_mode_t -- Вид индекса -- FALSE -- эксплуатационный.
     )
      LOOP 
         SELECT xx1.mess INTO _mess FROM gar_link.dblink (p_conn, _exec) xx1 ( mess text); 
         RAISE NOTICE '%', _mess;
      END LOOP;
      --
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_adr_area_idx (text, text, boolean, boolean) 
  IS 'Управление индексами в отдалённой таблице "adr_area".';  
-- ----- ----------------------------------------------------
-- USE CASE:
-- SELECT gar_link.f_server_is();
-- SELECT * FROM gar_link.v_servers_active;

-- CALL gar_link.p_adr_area_idx (gar_link.f_conn_set(12), 'unnsi', true, true); -- Создаю эксплуатационные
-- CALL gar_link.p_adr_area_idx (gar_link.f_conn_set(4), 'unnsi', false, true); -- Создание загрузочных
--
-- CALL gar_link.p_adr_area_idx (gar_link.f_conn_set(4), 'unnsi', true, false); -- Убираю эксплуатационные
-- CALL gar_link.p_adr_area_idx (gar_link.f_conn_set(12), 'unnsi', false, false); -- Убираю загрузочные




 
