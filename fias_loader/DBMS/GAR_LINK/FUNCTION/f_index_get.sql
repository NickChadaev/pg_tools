DROP FUNCTION IF EXISTS gar_link.f_index_get (text, text, text, boolean, boolean, boolean);
CREATE OR REPLACE FUNCTION gar_link.f_index_get (
           p_schema_name text -- Имя схемы приёмника.
          ,p_table_name  text -- Имя таблицы 
          ,p_idx_name    text -- Имя индекса.   
          ,p_mode_c      boolean = TRUE -- Создание индексов FALSE - удаление
          ,p_kind_index  boolean = TRUE -- Вид индекса -- FALSE -- эксплуатационный.
          ,p_unique_sign boolean = NULL -- Используем признак уникальности из таблицы.
          ,OUT exec      text
)
    RETURNS setof text
    LANGUAGE plpgsql 
    SECURITY DEFINER
    AS 
  $$
   -- --------------------------------------------------------------------------
   --   2022-11-09  Формирование индексного выражения, создание/удаления.
   -- --------------------------------------------------------------------------                 
    DECLARE 
      _crt_idx    text := $_$ CREATE INDEX IF NOT EXISTS %s; $_$;  
      _crt_un_idx text := $_$ CREATE UNIQUE INDEX IF NOT EXISTS %s; $_$; 
      _drp_idx    text := $_$ DROP INDEX IF EXISTS %I.%s; $_$; 
      
      _rr record;
      _exec text;
      
      _schema_name text := lower(btrim(p_schema_name)); -- Имя схемы приёмника.
      _table_name  text := lower(btrim(p_table_name));  -- Имя таблицы 
      _idx_name    text := lower(btrim(p_idx_name));    -- Имя индекса.   
   
    BEGIN
     FOR _rr IN 
            SELECT i.table_name, i.index_name, i.index_body, i.index_kind, i.unique_sign 
                 FROM gar_link.adr_indecies i 
                    WHERE (_table_name = i.table_name) AND (i.index_kind = p_kind_index)
      LOOP
        IF p_mode_c -- Create
          THEN 
            _exec := format (_crt_idx, (_rr.index_name || ' ' || format (_rr.index_body, _schema_name)));
            
           ELSE --Drop
                _exec := format (_drp_idx, _schema_name, _rr.index_name);
        END IF; --

        exec = _exec;        
        RETURN NEXT;

     END LOOP;    
    END;
  $$;
  
COMMENT ON FUNCTION gar_link.f_index_get (text, text, text, boolean, boolean, boolean) 
  IS 'Получить индексное выражение/Список индексных выражений';  
-- ----- ----------------------------------------------------
-- USE CASE:
--   SELECT gar_link.f_index_get ( 
--            p_schema_name := 'gar_tmp'  -- Имя схемы приёмника.
--           ,p_table_name  := 'adr_area' -- Имя таблицы 
--           ,p_idx_name    := NULL       -- Имя индекса.   
--           ,p_mode_c      := TRUE -- Создание индексов FALSE - удаление
--           ,p_kind_index  := TRUE -- Вид индекса -- FALSE -- эксплуатационный.
-- );
--   SELECT gar_link.f_index_get ( 
--            p_schema_name := 'gar_tmp'  -- Имя схемы приёмника.
--           ,p_table_name  := 'adr_area' -- Имя таблицы 
--           ,p_idx_name    := NULL       -- Имя индекса.   
--           ,p_mode_c      := FALSE -- Создание индексов FALSE - удаление
--           ,p_kind_index  := TRUE -- Вид индекса -- FALSE -- эксплуатационный.
-- );
-- --
--   SELECT gar_link.f_index_get ( 
--            p_schema_name := 'gar_tmp'  -- Имя схемы приёмника.
--           ,p_table_name  := 'adr_area' -- Имя таблицы 
--           ,p_idx_name    := NULL       -- Имя индекса.   
--           ,p_mode_c      := TRUE -- Создание индексов FALSE - удаление
--           ,p_kind_index  := FALSE -- Вид индекса -- FALSE -- эксплуатационный.
-- );
--   SELECT gar_link.f_index_get ( 
--            p_schema_name := 'gar_tmp'  -- Имя схемы приёмника.
--           ,p_table_name  := 'adr_area' -- Имя таблицы 
--           ,p_idx_name    := NULL       -- Имя индекса.   
--           ,p_mode_c      := FALSE -- Создание индексов FALSE - удаление
--           ,p_kind_index  := FALSE -- Вид индекса -- FALSE -- эксплуатационный.
-- );
