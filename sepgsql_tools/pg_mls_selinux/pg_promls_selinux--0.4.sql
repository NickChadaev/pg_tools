/* -------------------------------------------------------------------------------------------------------
   2020-04-04 Nick Версия 0.4
   2020-04-08  Nick Обратная адаптация на ALT                                  

   --  Перед выполнением CREATE EXTENSION должнабыть создана роль:
   --   CREATE ROLE sepgsql_role WITH NOLOGIN NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
  --------------------------------------------------------------------------------------------------------   
*/

\echo Use "CREATE EXTENSION pg_mls_selinux" to load this file. \quit

COMMENT ON SCHEMA sepgsql IS 'SEPGSQL-MLS с построчным разделением доступа'; 

CREATE SEQUENCE sepgsql.all_rec_id_seq INCREMENT 1 START 1;
--
-- 2020-04-04 Nick
--
CREATE TABLE sepgsql.sepgsql_tuple_z (
                                    table_name      text  NOT NULL
                                   ,rec_id          int   NOT NULL
                                   ,security_label  varchar(32)  NOT NULL
) PARTITION BY LIST (table_name);

COMMENT ON TABLE sepgsql.sepgsql_tuple_z IS 'Глобальный ID защищаемой строки + SE-user, SE-role';
--
COMMENT ON COLUMN sepgsql.sepgsql_tuple_z.table_name     IS 'Имя защищаемой таблицы';
COMMENT ON COLUMN sepgsql.sepgsql_tuple_z.rec_id         IS 'ID защищаемой строки';
COMMENT ON COLUMN sepgsql.sepgsql_tuple_z.security_label IS 'SE-user, SE-role';
--
ALTER TABLE sepgsql.sepgsql_tuple_z ADD CONSTRAINT pk_sepgsql_tuple_z PRIMARY KEY (table_name, rec_id);
--
-- 2020-04-04 Nick
--
-- ----------------------------------------------------------------------------------------------------
--  Функции типа "GET"
-- -----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_get_column_label 
          ( p_col_name text                    -- Имя столбца
          , p_provider text DEFAULT 'selinux'  -- Имя провайдера
          )
 RETURNS text 
   AS 
     -- ------------------------------------------------------------------
     --      2019-08-28 Nick Получение контекста безопасности столбца.
     --      2019-10-04 Nick Схема sepgsql.
     -- ------------------------------------------------------------------
     $$
       SELECT label FROM pg_seclabels 
                WHERE (objname = btrim(lower(p_col_name))) AND 
                      (objtype = 'column') AND (provider = btrim(lower(p_provider)));
     $$ 
        LANGUAGE sql IMMUTABLE;

COMMENT ON FUNCTION sepgsql.sepgsql_get_column_label (text, text) 
   IS '318: Получение контекста безопасности столбца
             1)   p_col_name text                      -- Имя столбца
             2) , p_provider text DEFAULT ''selinux''  -- Имя провайдера
       
       Пример использования:   
              SELECT * FROM sepgsql_get_column_label (''obj_codifier.codif_id'')
   ';        
--
-- SELECT * FROM sepgsql_get_column_label ('obj_codifier.codif_id', 'selinux');
--
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_get_db_label 
          ( p_db_name  text                    -- Имя базы
          , p_provider text DEFAULT 'selinux'  -- Имя провайдера
          )
 RETURNS text 
   AS 
     -- ------------------------------------------------------------------
     --      2019-08-28 Nick Получение контекста безопасности базы.
     --      2019-10-04 Nick Схема sepgsql
     -- ------------------------------------------------------------------
     $$
       SELECT s.label FROM pg_shseclabel s, pg_database d 
                   WHERE (d.oid = s.objoid) AND (s.provider = btrim(lower(p_provider))) AND 
                         (d.datname = btrim(p_db_name));
     $$ 
        LANGUAGE sql IMMUTABLE;

COMMENT ON FUNCTION sepgsql.sepgsql_get_db_label (text, text) 
   IS '706: Получение контекста безопасности базы
             1)   p_db_name  text                      -- Имя базы
             2) , p_provider text DEFAULT ''selinux''  -- Имя провайдера
       
       Пример использования:   
              SELECT * FROM sepgsql.sepgsql_get_db_label (''db_k'')
   ';        
--
-- SELECT * FROM sepgsql_get_db_label ('db_k');
--
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_get_func_label (
                  p_func_name  text
                , p_provider   text DEFAULT 'selinux'  -- Имя провайдера

)
 RETURNS text 
   AS 
     -- ------------------------------------------------------------------
     --  2019-04-20 Nick  Получение контекста безопасности функции.
     --  2019-10-04 Nick  Новая схема sepgsql.
     --  2019-11-25 Nick  Переход от OID к имени функции.
     -- ------------------------------------------------------------------
     $$
       SELECT label FROM pg_seclabels
             WHERE (objoid = (btrim(lower(p_func_name)))::regproc) AND (objtype = 'function') AND (provider = btrim(lower(p_provider)));
     $$ 
        LANGUAGE sql IMMUTABLE;

COMMENT ON FUNCTION sepgsql.sepgsql_get_func_label (text, text) 
   IS '706: Получение контекста безопасности функции.
             1)  p_func_name text                      -- Имя функции
             2) ,p_provider  text DEFAULT ''selinux''  -- Имя провайдера
       
       Пример использования:   
              SELECT * FROM sepgsql_get_func_label (''utl.utl_p_match_import_xml'')
   ';        
--
-- SELECT * FROM sepgsql_get_func_label ('utl.utl_p_match_import_xml', 'selinux')
--
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_get_sch_label 
          ( p_sch_name text                    -- Имя схемы
          , p_provider text DEFAULT 'selinux'  -- Имя провайдера
          )
 RETURNS text 
   AS 
     -- ------------------------------------------------------------------
     --      2019-08-28 Nick Получение контекста безопасности схемы.
     --      2019-10-04  Схема sepgsql
     --      2019-11-25 Nick Переход от OID к имени схемы.
     -- ------------------------------------------------------------------
     $$
       SELECT label FROM pg_seclabels 
            WHERE (objoid = (btrim(lower(p_sch_name)))::regnamespace) AND (objtype = 'schema') AND (provider = btrim(lower(p_provider)));
     $$ 
        LANGUAGE sql IMMUTABLE;

COMMENT ON FUNCTION sepgsql.sepgsql_get_sch_label (text, text) 
   IS '706: Получение контекста безопасности схемы.
             1)  p_sch_name text                     -- Имя схемы
             2) ,p_provider text DEFAULT ''selinux'' -- Имя провайдера
       
       Пример использования:   
              SELECT * FROM sepgsql_get_sch_label (''bookings'')
   ';        
--
-- SELECT * FROM sepgsql_get_sch_label ('bookings', 'selinux');
--
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_get_seq_label 
          ( p_seq_name text                   -- Имя последовательности
          , p_provider text DEFAULT 'selinux' -- Имя провайдера
          )
 RETURNS text 
   AS 
     -- ------------------------------------------------------------------
     --  2019-08-28 Nick Получение контекста безопасности sequence.
     --  2019-10-04  Новая схема sepgsql. 
     --  2019-11-25 Nick Переход от OID к имени последовательности  
     -- ------------------------------------------------------------------
     $$
       SELECT label FROM pg_seclabels
             WHERE (objoid = (btrim(lower(p_seq_name)))::regclass) AND (objtype = 'sequence') AND (provider = btrim(lower(p_provider)));
     $$ 
        LANGUAGE sql IMMUTABLE;

COMMENT ON FUNCTION sepgsql.sepgsql_get_seq_label (text, text) 
   IS '706: Получение контекста безопасности последовательности.
             1)  p_seq_name text                     -- Имя последовательности
             2) ,p_provider text DEFAULT ''selinux'' -- Имя провайдера
       
       Пример использования:   
              SELECT * FROM sepgsql_get_seq_label (''flights_flight_id_seq'')
   ';        
--
-- SELECT * FROM sepgsql_get_seq_label ('flights_flight_id_seq', 'selinux');
--
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_get_table_label 
          ( p_table_name text                    -- Имя таблицы
          , p_provider   text DEFAULT 'selinux'  -- Имя провайдера
          )
 RETURNS text 
   AS 
     -- ------------------------------------------------------------------
     --  2019-04-20 Nick Получение контекста безопасности таблицы.
     --  2019-10-04 Новая схема sepgsql
     --  2019-11-25 Переход от OID к имени таблицы.
     -- ------------------------------------------------------------------
     $$
       SELECT label FROM pg_seclabels 
           WHERE (objoid = (btrim(lower(p_table_name)))::regclass) AND (objtype = 'table') AND (provider = btrim(lower(p_provider)));
     $$ 
        LANGUAGE sql IMMUTABLE;

COMMENT ON FUNCTION sepgsql.sepgsql_get_table_label (text, text) 
   IS '706: Получение контекста безопасности таблицы.
             1)  p_table_name text                     -- Имя таблицы
             2) ,p_provider   text DEFAULT ''selinux'' -- Имя провайдера
       
       Пример использования:   
              SELECT * FROM sepgsql_get_table_label (''bookings.bookings'')
   ';        
--
-- SELECT * FROM sepgsql_get_table_label ('bookings.bookings', 'selinux')
--
-- 2020-04-04
--
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_get_tuple_label_t 
          ( p_tablename  text -- Имя таблицы
          , p_rec_id     int  -- ID записи
          )
 RETURNS text 
   AS 
     -- -----------------------------------------------------------------------------
     --  2019-10-03 Nick Получение контекста безопасности строки таблицы.
     --  2019-10-04  Новая схема sepgsql. Более компактный вариант запроса.
     --  2019-10-08  Секционирование по имени таблицы.
     --  2019-10-29 Nick Функция выполняется в доверенном контексте. 
     --  2019-11-25 Nick Модифицированная старая схема хранения.
     --  2020-04-03 Nick Ещё раз модификация схемы хранения, версия расширения 0.0.4 
     -- -----------------------------------------------------------------------------
$$
 DECLARE
   cDP char(1) := ':';
   --
   cERR    text := 'ОШИБКА: ';
   cMES0XX text := 'NULL значения запрещены';
   --
   _table_name  text := btrim (lower(p_tablename)); 
   --
   _exec           text;
   _se_type        text;
   _security_label varchar (32);
   _s_lvs          varchar (10);
 
 BEGIN
   IF (_table_name IS NULL) OR ( p_rec_id IS NULL)
     THEN RAISE '%', cMES0XX;
   END IF;
 
   _exec := 'SHOW tuple.se_type;';
   EXECUTE _exec INTO _se_type;
   _se_type := COALESCE (_se_type, 'sepgsql_tuple_t');
   --
   SELECT t.security_label INTO _security_label
          FROM sepgsql.sepgsql_tuple_z t 
              WHERE (t.table_name = _table_name) AND (t.rec_id =  p_rec_id);
   --
   _exec := 'SELECT s_lvs FROM ' || _table_name || ' WHERE (rec_id = ' || p_rec_id || ');';
   EXECUTE _exec INTO _s_lvs;
   
   RETURN _security_label || cDP || _se_type || cDP || _s_lvs;
      
 EXCEPTION
     WHEN OTHERS THEN 
        BEGIN
             RETURN cERR || SQLERRM;			
        END; 
 END;      
$$ 
     LANGUAGE plpgsql;

COMMENT ON FUNCTION sepgsql.sepgsql_get_tuple_label_t (text, int) 
   IS '30: Получение контекста безопасности строки таблицы.
             1)  p_tablename  text -- Имя таблицы
             2) ,p_rec_id     int  -- ID записи
       
       Пример использования:   
              SELECT * FROM sepgsql_get_tuple_label_t (''bookings.airports'', 100)
   ';        
--
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_get_tuple_label_t (text, int) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
--
-- SELECT * FROM sepgsql_get_tuple_label_t ('bookings.airports', 100);
-- SELECT * FROM sepgsql_get_tuple_label_t ('bookings.aircrafts', 10);
--
-- 2020-04-04
--
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_get_view_label 
          ( p_view_name text                    -- Имя представления
          , p_provider  text DEFAULT 'selinux'  -- Имя провайдера
          )
 RETURNS text 
   AS 
     -- ------------------------------------------------------------------
     --  2019-08-28 Nick Получение контекста безопасности представления.
     --  2019-10-04  Новая схема sepgsql.
     --  2019-11-25 Nick переход от OID к имени представления
     -- ------------------------------------------------------------------
     $$
       SELECT label FROM pg_seclabels
             WHERE (objoid = (btrim(lower(p_view_name)))::regclass) AND (objtype = 'view') AND (provider = btrim(lower(p_provider)));
     $$ 
        LANGUAGE sql IMMUTABLE;

COMMENT ON FUNCTION sepgsql.sepgsql_get_view_label (text, text) 
   IS '706: Получение контекста безопасности представления.
             1)  p_view_name text                    -- Имя представления
             2) ,p_provider text DEFAULT ''selinux'' -- Имя провайдера
       
       Пример использования:   
              SELECT * FROM sepgsql_get_view_label (''bookings.flights_v'')
   ';        
--
-- SELECT * FROM sepgsql_get_view_label ('bookings.flights_v', 'selinux');
-- ------------------------------------------------------------
--   Функции типа SET
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_set_column_label_t (
            p_column_name   text                    -- Имя столбца
          , p_new_context  text                    -- Новый контекст столбца      
          , p_provider     text DEFAULT 'selinux'  -- Имя провайдера
        )
  RETURNS text  
     SECURITY DEFINER 
     LANGUAGE plpgsql 
  AS   
$$
    -- =======================================================================================================
    --  2019-09-26 Nick Установка контекста безопасности столбца. Доверенная функция-обёртка над оператором
    --                   "SECURITY LABEL"
    --  2019-10-04  Новая схема sepgsql
    -- =======================================================================================================
 DECLARE 
  _column_name  text := NULLIF (lower(btrim (p_column_name)), '');  -- Имя столбца
  _new_context  text := NULLIF (lower(btrim (p_new_context)), ''); -- Новый контекст                                                         
  _provider     text := NULLIF (lower(btrim (p_provider)), '');    -- Провайдер                                                         
 
  MESS01  text := 'SECURITY LABEL FOR ''';
  MESS02  text := ''' ON COLUMN '; 
  MESS03  text := ' IS '''; 
  MESS04  text := ''''; 

  _exec_str text := '';
  
 BEGIN
   IF (_column_name IS NULL)
     THEN
         RAISE 'Имя столбца должно быть отличным от NULL';  
   END IF;
   --   
   IF (_new_context IS NULL)
     THEN
         RAISE 'Величина нового контекста должна быть отличной от NULL';  
   END IF;
   --
   IF (_provider IS NULL)
     THEN
         RAISE 'Провайдер должен быть отличным от NULL';  
   END IF;
  
   _exec_str := MESS01 || _provider || MESS02 || _column_name || MESS03 || _new_context || MESS04;
   EXECUTE _exec_str;
    
   RETURN _new_context;

 EXCEPTION
     WHEN OTHERS  THEN 
        BEGIN
          RETURN SQLERRM;			
        END; 
 END;
$$;

COMMENT ON FUNCTION sepgsql.sepgsql_set_column_label_t (text, text, text) 
   IS '379: Установка нового контекста столбца. Доверенная функция-обёртка над штатным "SECURITY LABEL" 

    Аргументы:
            p_column_name  text                      -- Имя столбца
          , p_new_context  text                      -- Новый контекст столбца      
          , p_provider     text DEFAULT ''selinux''  -- Имя провайдера
    
   	Выходные величины: 
        Текст нового контекста - успешное выполнение
        Сообщение об ошибке в противном случае.
        
    Пример использования:
        SELECT sepgsql.sepgsql_set_column_label_t (''my_sch.t44.f40'', ''generic_u:object_r:sepgsql_table_t:s1:c1'');
 
   ';
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_column_label_t (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';

CREATE OR REPLACE FUNCTION sepgsql.sepgsql_set_con_t (
        p_new_context  text -- Новый контекст безопасности сесии      
 )
  RETURNS text  
     SECURITY DEFINER 
     LANGUAGE plpgsql 
  AS   
$$
    -- =======================================================================================================
    --  2019-09-04 Nick Установка контекста сессии. Доверенная функция-обёртка над штатной "sepgsql_setcon()"
    --  2019-10-04  Новая схема sepgsql.
    -- =======================================================================================================
 DECLARE 
  _new_context  text := NULLIF (lower(btrim (p_new_context)), ''); -- Новый контекст                                                         
  
 BEGIN

    RETURN sepgsql_setcon (_new_context);

 EXCEPTION
     WHEN OTHERS  THEN 
        BEGIN
          RETURN SQLERRM;			
        END; 
 END;
$$;

COMMENT ON FUNCTION sepgsql.sepgsql_set_con_t (text) 
   IS '350: Установка контекста сессии. Доверенная функция-обёртка над штатной "sepgsql_setcon()" 

    Аргументы:
         p_new_context  text -- Новый контекст безопасности сесии
                                NULL - возвращаемся к начальному домену клиента. 
    
   	Выходные величины: 
   	    true - контекст успешно установлен
        Сообщение об ошибке в противном случае.
        
    Пример использования:
        SELECT * FROM sepgsql_set_con_t (''generic_u:generic_r:generic_t:s1-s3:c0.c15'');
 
   ';
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_con_t (text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0-s3';
-- ??
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_set_db_label_t (
            p_db_name     text                    -- Имя базы
          , p_new_context  text                    -- Новый контекст базы      
          , p_provider     text DEFAULT 'selinux'  -- Имя провайдера
        )
  RETURNS text  
     SECURITY DEFINER 
     LANGUAGE plpgsql 
  AS   
$$
    -- ===================================================================================================================
    --  2019-09-27 Nick Установка контекста безопасности базы. Доверенная функция-обёртка над оператором "SECURITY LABEL"
    --  2019-10-04  Новая схема sepgsql
    -- ===================================================================================================================
 DECLARE 
  _db_name      text := NULLIF (lower(btrim (p_db_name)), '');     -- Имя базы
  _new_context  text := NULLIF (lower(btrim (p_new_context)), ''); -- Новый контекст                                                         
  _provider     text := NULLIF (lower(btrim (p_provider)), '');    -- Провайдер                                                         
 
  MESS01  text := 'SECURITY LABEL FOR ''';
  MESS02  text := ''' ON DATABASE '; 
  MESS03  text := ' IS '''; 
  MESS04  text := ''''; 

  _exec_str text := '';
  
 BEGIN
   IF (_db_name IS NULL)
     THEN
         RAISE 'Имя базы должно быть отличным от NULL';  
   END IF;
   --   
   IF (_new_context IS NULL)
     THEN
         RAISE 'Величина нового контекста должна быть отличной от NULL';  
   END IF;
   --
   IF (_provider IS NULL)
     THEN
         RAISE 'Провайдер должен быть отличным от NULL';  
   END IF;
  
   _exec_str := MESS01 || _provider || MESS02 || _db_name || MESS03 || _new_context || MESS04;
   EXECUTE _exec_str;
    
   RETURN _new_context;

 EXCEPTION
     WHEN OTHERS  THEN 
        BEGIN
          RETURN SQLERRM;			
        END; 
 END;
$$;

COMMENT ON FUNCTION sepgsql.sepgsql_set_db_label_t (text, text, text) 
   IS '436: Установка нового контекста базы. Доверенная функция-обёртка над штатным "SECURITY LABEL" 

    Аргументы:
            p_db_name      text                      -- Имя базы
          , p_new_context  text                      -- Новый контекст базы      
          , p_provider     text DEFAULT ''selinux''  -- Имя провайдера
    
   	Выходные величины: 
        Текст нового контекста - успешное выполнение
        Сообщение об ошибке в противном случае.
        
    Пример использования:
        SELECT sepgsql.sepgsql_set_db_label_t (''test_0'', ''generic_u:object_r:sepgsql_db_t:s0'');
 
   ';
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_db_label_t (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';

CREATE OR REPLACE FUNCTION sepgsql.sepgsql_set_func_label_t (
            p_func_name   text                     -- Имя функции
          , p_new_context  text                    -- Новый контекст функции      
          , p_provider     text DEFAULT 'selinux'  -- Имя провайдера
        )
  RETURNS text  
     SECURITY DEFINER 
     LANGUAGE plpgsql 
  AS   
$$
    -- ===========================================================================================================
    --  2019-09-26 Nick Установка контекста безопасности функции. Доверенная функция-обёртка над оператором
    --                   "SECURITY LABEL"
    --  2019-10-04  Новая схема sepgsql
    -- ===========================================================================================================
 DECLARE 
  _func_name    text := NULLIF (lower(btrim (p_func_name)), '');   -- Имя функции
  _new_context  text := NULLIF (lower(btrim (p_new_context)), ''); -- Новый контекст                                                         
  _provider     text := NULLIF (lower(btrim (p_provider)), '');    -- Провайдер                                                         
 
  MESS01  text := 'SECURITY LABEL FOR ''';
  MESS02  text := ''' ON FUNCTION '; 
  MESS03  text := ' IS '''; 
  MESS04  text := ''''; 

  _exec_str text := '';
  
 BEGIN
   IF (_func_name IS NULL)
     THEN
         RAISE 'Имя функции должно быть отличным от NULL';  
   END IF;
   --   
   IF (_new_context IS NULL)
     THEN
         RAISE 'Величина нового контекста должна быть отличной от NULL';  
   END IF;
   --
   IF (_provider IS NULL)
     THEN
         RAISE 'Провайдер должен быть отличным от NULL';  
   END IF;
  
   _exec_str := MESS01 || _provider || MESS02 || _func_name || MESS03 || _new_context || MESS04;
   EXECUTE _exec_str;
    
   RETURN _new_context;

 EXCEPTION
     WHEN OTHERS  THEN 
        BEGIN
          RETURN SQLERRM;			
        END; 
 END;
$$;

COMMENT ON FUNCTION sepgsql.sepgsql_set_func_label_t (text, text, text) 
   IS '432: Установка нового контекста функции. Доверенная функция-обёртка над штатным "SECURITY LABEL" 

    Аргументы:
            p_func_name    text                      -- Имя функции
          , p_new_context  text                      -- Новый контекст функции      
          , p_provider     text DEFAULT ''selinux''  -- Имя провайдера
    
   	Выходные величины: 
   	    Текст нового контекста - успешное выполнение
        Сообщение об ошибке в противном случае.
        
    Пример использования:
        SELECT * FROM sepgsql.sepgsql_set_func_label_t (''my_sch.f_f2t (p_rec_id int)'', ''generic_u:object_r:sepgsql_proc_exec_t:s0-s3:c0.c15'');
 
   ';
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_func_label_t (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';

CREATE OR REPLACE FUNCTION sepgsql.sepgsql_set_sch_label_t (
            p_sch_name     text                    -- Имя схемы
          , p_new_context  text                    -- Новый контекст схемы      
          , p_provider     text DEFAULT 'selinux'  -- Имя провайдера
        )
  RETURNS text  
     SECURITY DEFINER 
     LANGUAGE plpgsql 
  AS   
$$
    -- =======================================================================================================
    --  2019-09-27 Nick Установка контекста безопасности схемы. Доверенная функция-обёртка 
    --                    над оператором "SECURITY LABEL"
    --  2019-10-04 Новая схема хранения sepgsql
    -- =======================================================================================================
 DECLARE 
  _sch_name     text := NULLIF (lower(btrim (p_sch_name)), '');    -- Имя схемы
  _new_context  text := NULLIF (lower(btrim (p_new_context)), ''); -- Новый контекст                                                         
  _provider     text := NULLIF (lower(btrim (p_provider)), '');    -- Провайдер                                                         
 
  MESS01  text := 'SECURITY LABEL FOR ''';
  MESS02  text := ''' ON SCHEMA '; 
  MESS03  text := ' IS '''; 
  MESS04  text := ''''; 

  _exec_str text := '';
  
 BEGIN
   IF (_sch_name IS NULL)
     THEN
         RAISE 'Имя схемы должно быть отличным от NULL';  
   END IF;
   --   
   IF (_new_context IS NULL)
     THEN
         RAISE 'Величина нового контекста должна быть отличной от NULL';  
   END IF;
   --
   IF (_provider IS NULL)
     THEN
         RAISE 'Провайдер должен быть отличным от NULL';  
   END IF;
  
   _exec_str := MESS01 || _provider || MESS02 || _sch_name || MESS03 || _new_context || MESS04;
   EXECUTE _exec_str;
    
   RETURN _new_context;

 EXCEPTION
     WHEN OTHERS  THEN 
        BEGIN
          RETURN SQLERRM;			
        END; 
 END;
$$;

COMMENT ON FUNCTION sepgsql.sepgsql_set_sch_label_t (text, text, text) 
   IS '436: Установка нового контекста схемы. Доверенная функция-обёртка над штатным "SECURITY LABEL" 

    Аргументы:
            p_sch_name     text                      -- Имя схемы
          , p_new_context  text                      -- Новый контекст схемы      
          , p_provider     text DEFAULT ''selinux''  -- Имя провайдера
    
   	Выходные величины: 
        Текст нового контекста - успешное выполнение
        Сообщение об ошибке в противном случае.
        
    Пример использования:
        SELECT sepgsql.sepgsql_set_sch_label_t (''my_sch'', ''generic_u:object_r:sepgsql_schema_t:s0'');
 
   ';
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_sch_label_t (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';

CREATE OR REPLACE FUNCTION sepgsql.sepgsql_set_seq_label_t (
            p_seq_name     text                    -- Имя последовательности
          , p_new_context  text                    -- Новый контекст последовательности      
          , p_provider     text DEFAULT 'selinux'  -- Имя провайдера
        )
  RETURNS text  
     SECURITY DEFINER 
     LANGUAGE plpgsql 
  AS   
$$
    -- =======================================================================================================
    --  2019-09-27 Nick Установка контекста безопасности последовательности. Доверенная функция-обёртка 
    --                    над оператором "SECURITY LABEL"
    --  2019-10-04 Nick  Новая схема sepgsql.
    -- =======================================================================================================
 DECLARE 
  _seq_name     text := NULLIF (lower(btrim (p_seq_name)), '');    -- Имя последовательности
  _new_context  text := NULLIF (lower(btrim (p_new_context)), ''); -- Новый контекст                                                         
  _provider     text := NULLIF (lower(btrim (p_provider)), '');    -- Провайдер                                                         
 
  MESS01  text := 'SECURITY LABEL FOR ''';
  MESS02  text := ''' ON SEQUENCE '; 
  MESS03  text := ' IS '''; 
  MESS04  text := ''''; 

  _exec_str text := '';
  
 BEGIN
   IF (_seq_name IS NULL)
     THEN
         RAISE 'Имя последовательности должно быть отличным от NULL';  
   END IF;
   --   
   IF (_new_context IS NULL)
     THEN
         RAISE 'Величина нового контекста должна быть отличной от NULL';  
   END IF;
   --
   IF (_provider IS NULL)
     THEN
         RAISE 'Провайдер должен быть отличным от NULL';  
   END IF;
  
   _exec_str := MESS01 || _provider || MESS02 || _seq_name || MESS03 || _new_context || MESS04;
   EXECUTE _exec_str;
    
   RETURN _new_context;

 EXCEPTION
     WHEN OTHERS  THEN 
        BEGIN
          RETURN SQLERRM;			
        END; 
 END;
$$;

COMMENT ON FUNCTION sepgsql.sepgsql_set_seq_label_t (text, text, text) 
   IS '436: Установка нового контекста последовательности. Доверенная функция-обёртка над штатным "SECURITY LABEL" 

    Аргументы:
            p_seq_name  text                         -- Имя последовательности
          , p_new_context  text                      -- Новый контекст последовательности      
          , p_provider     text DEFAULT ''selinux''  -- Имя провайдера
    
   	Выходные величины: 
        Текст нового контекста - успешное выполнение
        Сообщение об ошибке в противном случае.
        
    Пример использования:
        SELECT sepgsql.sepgsql_set_seq_label_t (''my_sch.t33_f30_seq'', ''generic_u:object_r:sepgsql_seq_t:s3'');
 
   ';
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_seq_label_t (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';

CREATE OR REPLACE FUNCTION sepgsql.sepgsql_set_table_label_t (
            p_table_name   text                    -- Имя таблицы
          , p_new_context  text                    -- Новый контекст таблицы      
          , p_provider     text DEFAULT 'selinux'  -- Имя провайдера
        )
  RETURNS text  
     SECURITY DEFINER 
     LANGUAGE plpgsql 
  AS   
$$
    -- =======================================================================================================
    --  2019-09-04 Nick Установка контекста безопасности таблицы. Доверенная функция-обёртка над оператором
    --                   "SECURITY LABEL"
    --  2019-10-04 Nick Схема "sepgsql".
    -- =======================================================================================================
 DECLARE 
  _table_name   text := NULLIF (lower(btrim (p_table_name)), '');  -- Имя таблицы
  _new_context  text := NULLIF (lower(btrim (p_new_context)), ''); -- Новый контекст                                                         
  _provider     text := NULLIF (lower(btrim (p_provider)), '');    -- Провайдер                                                         
 
  MESS01  text := 'SECURITY LABEL FOR ''';
  MESS02  text := ''' ON TABLE '; 
  MESS03  text := ' IS '''; 
  MESS04  text := ''''; 

  _exec_str text := '';
  
 BEGIN
   IF (_table_name IS NULL)
     THEN
         RAISE 'Имя таблицы должно быть отличным от NULL';  
   END IF;
   --   
   IF (_new_context IS NULL)
     THEN
         RAISE 'Величина нового контекста должна быть отличной от NULL';  
   END IF;
   --
   IF (_provider IS NULL)
     THEN
         RAISE 'Провайдер должен быть отличным от NULL';  
   END IF;
  
   _exec_str := MESS01 || _provider || MESS02 || _table_name || MESS03 || _new_context || MESS04;
   EXECUTE _exec_str;
    
   RETURN _new_context;

 EXCEPTION
     WHEN OTHERS  THEN 
        BEGIN
          RETURN SQLERRM;			
        END; 
 END;
$$;

COMMENT ON FUNCTION sepgsql.sepgsql_set_table_label_t (text, text, text) 
   IS '379: Установка нового контекста таблицы. Доверенная функция-обёртка над штатным "SECURITY LABEL" 

    Аргументы:
            p_table_name   text                      -- Имя таблицы
          , p_new_context  text                      -- Новый контекст таблицы      
          , p_provider     text DEFAULT ''selinux''  -- Имя провайдера
    
   	Выходные величины: 
        Текст нового контекста - успешное выполнение
        Сообщение об ошибке в противном случае.
        
    Пример использования:
        SELECT * FROM sepgsql.sepgsql_set_table_label_t (''my_sch.t44'', ''generic_u:object_r:sepgsql_table_t:s0-s3:c0.c15'');
 
   ';
--   
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_table_label_t (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
--
-- 2020-04-04 Nick
--
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_set_tuple_label_t 
          ( p_tablename  text  -- Имя таблицы
           ,p_rec_id     int   -- ID записи
           ,p_sec_label  text  -- Метка безопасности
          )
 RETURNS text 
   AS 
     -- -------------------------------------------------------------------------------
     --  2019-10-03 Nick Установка контекста безопасности строки таблицы.
     --  2019-10-04  Новая схема sepgsql Компактная схема хранения.
     --  2019-10-08  Секционирование по имени таблицы, выполнение в доверенном домене.
     --  2019-11-26  Заменяем bigint на int
     --  2019-12-02 Nick Дополнительный технический атрибут "s_lvl" содержит уровень и
     --                  категорию безопасности. Модифицируется функцией типа SET.     
     --  2020-04-03 Распределённое хранение.
     -- -------------------------------------------------------------------------------
 $$
      DECLARE 
         cSE_KEY text := 'sepgsql';
         cERR    text := 'SEPGSQL. ОШИБКА: ';
          
         _table_name     text := lower(btrim(p_tablename)); 
         _new_sec_label  text := lower(btrim(p_sec_label));
         --
         _security_label text;
         _exec_str       text := ''; -- Динамический SQL
         
      BEGIN
       IF (_table_name IS NULL)
         THEN
             RAISE 'Имя таблицы должно быть отличным от NULL';  
       END IF;
       --
       -- Проверяю, есть ли таблица.
       --
       _exec_str := 'SELECT 1 FROM ' || _table_name || ' LIMIT 1;';
       EXECUTE _exec_str;
       --   
       IF (_new_sec_label IS NULL)
         THEN
             RAISE 'Величина нового контекста должна быть отличной от NULL';  
       END IF;      
       --
       IF (p_rec_id IS NULL)
         THEN
             RAISE 'Величина технического ID записи должна быть отличной от NULL';  
       END IF;   
       --
       IF (position (cSE_KEY IN _new_sec_label) <= 0)
         THEN
             RAISE 'Неправильный SE-тип контекста';
       END IF;
       --
       -- 2020-04-03
       --
       UPDATE sepgsql.sepgsql_tuple_z 
           SET security_label = SUBSTRING (_new_sec_label FROM 1 FOR (position (cSE_KEY IN _new_sec_label) -2)) 
                WHERE (table_name = _table_name) AND (rec_id = p_rec_id);
       -- 2020-04-03
       IF FOUND
         THEN
              --
              -- 2019-12-02 Далее динамический SQL Обновляем краткий контекст в прикладной таблице.        
              -- UPDATE _table_name SET s_lvl = sepgsql.sepgsql_create_lvl_label (_security_label) 
              --                                                            WHERE ( rec_id = p_rec_id ); 
              -- 2020-04-04 Nick
              --
              _exec_str := 'UPDATE ' || _table_name || 
                        ' SET s_lvs = sepgsql.sepgsql_create_tuple_label (''' || 
                        _new_sec_label || ''', true) WHERE (rec_id = ' || p_rec_id || ' );';
             EXECUTE _exec_str;
         ELSE 
       END IF;
       
       RETURN _new_sec_label;
       
      EXCEPTION
           WHEN OTHERS THEN 
              BEGIN
                 RETURN cERR || SQLERRM;		
              END;        
      END; 
 $$ 
   LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

COMMENT ON FUNCTION sepgsql.sepgsql_set_tuple_label_t (text, int, text) 
   IS '30: Установка контекста безопасности строки таблицы.
             1)  p_tablename  text -- Имя таблицы
             2) ,p_rec_id     int  -- ID записи
             3) ,p_sec_label  text -- Метка безопасности
       
       Пример использования:   
            SELECT * FROM sepgsql.sepgsql_set_tuple_label_t (''bookings.aircrafts''::text, 14, ''generic_u:object_r:sepgsql_tuple_t:s3:c0''::text);
   ';        
   
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_tuple_label_t (text, int, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';   
--
-- SELECT * FROM sepgsql.sepgsql_set_tuple_label_t ('bookings.aircrafts'::text, 14, 'generic_u:object_r:sepgsql_tuple_t:s3:c0'::text);
-- SELECT * FROM sepgsql.sepgsql_set_tuple_label_t ('bookings1.aircrafts'::text, 14, 'generic_u:object_r:sepgsql_tuple_t:s3:c0'::text); 
-- SELECT * FROM sepgsql.sepgsql_set_tuple_label_t ('bookings.aircrafts'::text, 14, 'generic_u:object_r:se2pgsql2_tuple_t:s3:c0'::text); 
--
-- 2020-04-04 Nick
--
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_set_view_label_t (
            p_view_name   text                    -- Имя представления
          , p_new_context  text                    -- Новый контекст представления      
          , p_provider     text DEFAULT 'selinux'  -- Имя провайдера
        )
  RETURNS text  
     SECURITY DEFINER 
     LANGUAGE plpgsql 
  AS   
$$
    -- ===========================================================================================================
    --  2019-09-26 Nick Установка контекста безопасности представления. Доверенная функция-обёртка над оператором
    --                   "SECURITY LABEL"
    --  2019-10-04  Новая схема  sepgsql
    -- ===========================================================================================================
 DECLARE 
  _view_name    text := NULLIF (lower(btrim (p_view_name)), '');   -- Имя представления
  _new_context  text := NULLIF (lower(btrim (p_new_context)), ''); -- Новый контекст                                                         
  _provider     text := NULLIF (lower(btrim (p_provider)), '');    -- Провайдер                                                         
 
  MESS01  text := 'SECURITY LABEL FOR ''';
  MESS02  text := ''' ON VIEW '; 
  MESS03  text := ' IS '''; 
  MESS04  text := ''''; 

  _exec_str text := '';
  
 BEGIN
   IF (_view_name IS NULL)
     THEN
         RAISE 'Имя VIEW должно быть отличным от NULL';  
   END IF;
   --   
   IF (_new_context IS NULL)
     THEN
         RAISE 'Величина нового контекста должна быть отличной от NULL';  
   END IF;
   --
   IF (_provider IS NULL)
     THEN
         RAISE 'Провайдер должен быть отличным от NULL';  
   END IF;
  
   _exec_str := MESS01 || _provider || MESS02 || _view_name || MESS03 || _new_context || MESS04;
   EXECUTE _exec_str;
    
   RETURN _new_context;

 EXCEPTION
     WHEN OTHERS  THEN 
        BEGIN
          RETURN SQLERRM;			
        END; 
 END;
$$;

COMMENT ON FUNCTION sepgsql.sepgsql_set_view_label_t (text, text, text) 
   IS '432: Установка нового контекста представления. Доверенная функция-обёртка над штатным "SECURITY LABEL" 

    Аргументы:
            p_view_name    text                      -- Имя представления
          , p_new_context  text                      -- Новый контекст представления      
          , p_provider     text DEFAULT ''selinux''  -- Имя провайдера
    
   	Выходные величины: 
   	    true - контекст успешно установлен
        Сообщение об ошибке в противном случае.
        
    Пример использования:
        SELECT * FROM sepgsql.sepgsql_set_view_label_t (''my_sch.t44'', ''generic_u:object_r:sepgsql_view_t:s0-s3:c0.c15'');
 
   ';
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_view_label_t (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
-- ----------------------------------------------------------------------------------------------------------------------------------------------------
--  Функции типа CHECK 2020-04-04 Nick. Удаляю лишнее: "sepgsql.sepgsql_check_tuple_label_t()"
-- -------------------
--
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_check_cltb_con ( 
            p_client_context  text   -- Контекст клиента
           ,p_table_context   text   -- Контекст таблицы
          )
 RETURNS boolean 
   AS 
     $$
       -- ----------------------------------------------------------------------- -- 
       --  2019-11-07 Nick Сравнение контекстов клиента и таблицы.                --
       --    1) Уровень и категория таблицы всегда комплексные.                   --
       --    2) Клиент: один уровень и одна категория. При работе по через сокет  --
       --       они могут быть комплексными.                                      --
       --    3) Уровень клиента принадлежит уровню таблицы:                       --  
       --       <cli_level> >= <tbl_min_level> AND <cli_level> <= <tbl_max_level> --
       --    4) Категория клиента "покрывается" категорией таблицы.  т.е          --
       --                 <cli_cat> = ANY [<массив значений <tbl_cat>]            --
       -- ----------------------------------------------------------------------- --
       -- 2019-11-09 Nick Всё, что касается категорий, как клиента, так и таблицы --
       --      необходимо доработать. Пока мутно и неясно                         --
       -- ----------------------------------------------------------------------- --
       -- 2020-03-18 Функция стала работать с таблицами имеющими простой уровень  --
       -- ----------------------------------------------------------------------- -- 
      DECLARE
        cEM  char(1) := '';
        cDP  char(1) := ':';
        cMN  char(1) := '-';
        cPT  char(1) := '.';
        cCM  char(1) := ',';
        --
        _client_context  text := NULLIF (btrim (lower (p_client_context)), cEM);
        _table_context   text := NULLIF (btrim (lower (p_table_context)), cEM);
        
        _cl_level text;
        --
        _min_tbl_level text;
        _max_tbl_level text;
        --        
        _cl_cat  text;
        _tbl_cat text[];
        
      BEGIN
        IF (_client_context IS NULL) OR (_table_context IS NULL) 
           THEN
                RETURN false;
        END IF;   
        -- 
        -- RAISE NOTICE 'P1. client_context = "%", table_context = "%"', _client_context, _table_context;
        --         
        _client_context := substring (_client_context FROM ( position ( cDP IN _client_context) + 1 )); -- Долой пользователя
        _client_context := substring (_client_context FROM ( position ( cDP IN _client_context) + 1 )); -- Долой роль
        _client_context := substring (_client_context FROM ( position ( cDP IN _client_context) + 1 )); -- Долой тип       
        _client_context := substring (_client_context FROM 1 );        
        --
        -- RAISE NOTICE  'P2. client_context = %', _client_context;
        -- ЗАМЕЧАНИЕ:  P2. client_context = s0-s0:c0.c15
        --
        -- Клиент
        --     Выделяю один уровень (младший в случае комплексного),
        --     Выделяю одну категорию (младшую в случае комплексной).        
        --
        IF (position (cDP IN _client_context) > 0)
          THEN
            IF (position (cMN IN _client_context) > 0)
              THEN
                 _cl_level := substring (_client_context FROM 1 FOR (position (cMN IN _client_context) - 1)); 
              ELSE 
                   _cl_level := substring (_client_context FROM 1 FOR (position (cDP IN _client_context) - 1)); 
            END IF;
            --
            IF (position (cDP IN _client_context) > 0)
              THEN
               _cl_cat := substring (_client_context FROM (position (cDP IN _client_context) + 1) FOR 3);
              ELSE
                  _cl_cat := cEM;
            END IF;
          ELSE  
              _cl_level := _client_context;
              _cl_cat := cEM;
        END IF;    
        --
        _cl_cat := btrim (_cl_cat, cPT);
        _cl_cat := btrim (_cl_cat, cCM);
        
       -- RAISE NOTICE  'P3. cl_level = %, cl_cat = %', _cl_level, _cl_cat;
        --
        _table_context := substring (_table_context FROM( position( cDP IN _table_context) + 1 )); -- Долой пользователя
        _table_context := substring (_table_context FROM( position( cDP IN _table_context) + 1 )); -- Долой роль
        _table_context := substring (_table_context FROM( position( cDP IN _table_context) + 1 )); -- Долой тип
        _table_context := substring (_table_context FROM 1 );        
        --
        -- RAISE NOTICE  'P4. table_context = %', _table_context;
        -- ЗАМЕЧАНИЕ:  P4. table_context = s0-s3:c0

        --  Таблица 
        --    1) Выделяю уровень.   min, max.
        --    2) Выделяю категорию, Создаю массив значений [c0... c15]. -- Template
        --             Выделяю из него только те значения, которые есть у таблицы.        
        
        -- Nick 2020-03-18
        IF (position (cMN IN _table_context) > 0)
          THEN
               _min_tbl_level := substring (_table_context FROM 1 FOR (position (cMN IN _table_context) - 1));
               _max_tbl_level := substring (_table_context FROM (position (cMN IN _table_context) + 1) FOR 2);
          ELSE 
               _min_tbl_level := substring (_table_context FROM 1 FOR (position (cDP IN _table_context) - 1)); 
               _max_tbl_level := _min_tbl_level;
        END IF;
        
        -- _min_tbl_level := substring (_table_context FROM 1 FOR (position (cMN IN _table_context) - 1));
        -- _max_tbl_level := substring (_table_context FROM (position (cMN IN _table_context) + 1) FOR 2);
        
        -- Nick 2020-03-18 
        --
        -- RAISE NOTICE  'P5. min_tbl_level = "%", max_tbl_level = "%"', _min_tbl_level, _max_tbl_level;
        --
        -- Категория
        --
        _tbl_cat := ARRAY [substring (_table_context FROM (position (cDP IN _table_context) + 1))];
        -- RAISE NOTICE  'P6. _tbl_cat = "%"', _tbl_cat;       
       
        RETURN (_cl_level >= _min_tbl_level) AND (_cl_level <= _max_tbl_level) AND (_cl_cat = ANY (_tbl_cat));
 
      END;
     $$ 
        LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION sepgsql.sepgsql_check_cltb_con (text, text) 
   IS '1163: Сравнение контекстов безопасности клиента и таблицы.
             1)  p_cl_context text -- Контекст клиента
             2) ,p_tb_context text -- Контекст таблицы
       
       Пример использования:   
              SELECT * FROM sepgsql.sepgsql_check_cltb_con (
                    ''generic_u_u:generic_r:generic_t:s0:c0''
                    ''generic_u:object_r:sepgsql_table_t:s0-s3:c0''
                    )
   '; 
--
--
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_check_tuple_label
      ( 
        p_client_context text           -- Контекст безопасности клиента
      , p_row_context    varchar(10)    -- Контекст безопасности строки
      , p_arr_perm       text[]  = NULL -- Массив декларативных прав, пока не используется
      , p_sw_blpd        boolean = TRUE -- Переключатель TRUE, сравнение согласно модели БЭЛЛ-ЛаПАДУЛЫ (свой уровень и всё вниз),
                                        -- FALSE - строгое сравнение, видим только свой уровень.
      )
 RETURNS boolean 
   AS 
     $$
       -- ---------------------------------------------------------------------------------- --
       --  2019-11-28 Nick Функция работает с кратким контекстом строки (УРОВЕНЬ:КАТЕГОРИЯ). --      
       -- ---------------------------------------------------------------------------------- --
      DECLARE
        cDP char (1) := ':';
        _client_context  text;
        _row_context     text;
              
      BEGIN
        _client_context := p_client_context; 
         --         
        _client_context := substring (_client_context FROM ( position( cDP IN _client_context) + 1 )); -- Долой пользователя
        _client_context := substring (_client_context FROM ( position( cDP IN _client_context) + 1 ));       -- Долой роль
        _client_context := substring (_client_context FROM ( position( cDP IN _client_context) + 1 ));       -- Долой тип
        _client_context := substring (_client_context FROM 1 FOR 2);        
         --
        _row_context := substring (p_row_context FROM 1 FOR 2); -- Nick 2019-11-28         
        --
        -- RAISE NOTICE 'P0. p_sw_blpd = %, row_context = %', p_sw_blpd, _row_context;
        --        
        RETURN COALESCE ((CASE WHEN p_sw_blpd THEN (_row_context <= _client_context) ELSE (_row_context = _client_context) END), FALSE); -- 2019-10-28  Nick      
      END;
     $$ 
        LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION sepgsql.sepgsql_check_tuple_label (text, varchar(10), text[], boolean) 
   IS '752: Проверки метки безопасности строки.
          1)  p_client_context text            -- Контекст безопасности клиента
          2) ,p_row_context    varchar(5)      -- Краткий контекст безопасности строки
          3) ,p_arr_perm       text[]  = NULL  -- Массив декларативных прав, пока не используется
          4) ,p_sw_blpd        boolean = TRUE  -- Переключатель TRUE, сравнение согласно модели БЭЛЛ-ЛаПАДУЛЫ (свой уровень и всё вниз),
                                         FALSE -- Строгое сравнение, видим только свой уровень.
   ';     
-- ----------------------------------------------------------------------------- --
--  Функции типа CREATE 2020-04-04 Удаляю: "sepgsql.sepgsql_create_lvl_label()"  --
-- ----------------------------------------------------------------------------- --
CREATE OR REPLACE FUNCTION sepgsql.sepgsql_create_tuple_label 
          (   p_cl_context   text  -- Полный контекст клиента
            , p_sw boolean = true  -- Переключатель TRUE  - создаём часть метки (s:c)
          )                        --               FALSE - создаём часть метки (u:r)  
 RETURNS text 
   AS 
     $$
       -- ---------------------------------------------------------------------------------------------- --
       --  2019-12-03 Nick Создание короткой метки безопасности строки (<уровень>:<категория>)           --
       --   Используется при создании новой строки в прикладной таблице (установка значения столбца      --
       --   "s_lvl"), участвует в создании полной метки безопасности, совместно с фукцией                --
       --   " sepgsql.sepgsql_create_tuple_label (text, text, text)".                                    -- 
       --  2020-04-03 Nick Два режима: создаём часть метки (s:c) либо (u:r)                              --
       -- ---------------------------------------------------------------------------------------------- --
      DECLARE
        DP char(1) := ':';      
        PP char(1) := '.';
        EM char(1) := '';
        --
        _cl_context text := btrim (lower (p_cl_context));
        --
        _cl_u       text;  -- 2020-04-03 Пользователь
        _cl_r       text;  -- 2020-04-03 Роль
        --
        _cl_level   text;
        _cl_cat     text;
        
      BEGIN
        _cl_u := substring (_cl_context FROM 1 FOR ( position (DP IN _cl_context) - 1));       -- Пользователь
        _cl_context := substring (_cl_context FROM ( position (DP IN _cl_context) + 1)); -- Долой пользователя
        -- 
        _cl_r := substring (_cl_context FROM 1 FOR ( position (DP IN _cl_context) - 1));       -- Роль
        _cl_context := substring (_cl_context FROM ( position (DP IN _cl_context) + 1)); -- Долой роль
        --
        _cl_context := substring (_cl_context FROM ( position (DP IN _cl_context) + 1)); -- Долой тип/домен        --
        --
        IF p_sw THEN
            IF ((position (DP IN _cl_context) - 1) > 0) -- Уровень + Категория
              THEN
                _cl_level := substring (_cl_context FROM 1 FOR (position (DP IN _cl_context) - 1)); 
                _cl_level := substring (_cl_level FROM 1 FOR 2);
                -- 
                -- RAISE NOTICE 'P11, %', _cl_level;
                _cl_cat := substring (_cl_context FROM ( position ( DP IN _cl_context) + 1 )); -- Категория
                -- RAISE NOTICE 'P12, %', _cl_cat;
                --            
                IF (NULLIF ( _cl_cat, EM) IS NOT NULL)
                  THEN
                    _cl_cat := substring (_cl_cat FROM 1 FOR 3);
                    _cl_cat := btrim (_cl_cat, PP);
                  ELSE  
                      _cl_cat := NULL;
                  END IF;
                --
                -- RAISE NOTICE 'P2, %, %, %', _cl_context, _cl_level, _cl_cat;
                --       
              ELSE  -- Только уровень
                  _cl_level := substring (_cl_context FROM 1 FOR 2);
                  _cl_cat := NULL;
            END IF;
            
            RETURN 
              CASE 
                  WHEN _cl_cat IS NOT NULL 
                     THEN 
                          _cl_level || DP || _cl_cat        
                  ELSE
                          _cl_level        
              END; -- CASE 2
          ELSE 
               RETURN _cl_u || DP || _cl_r ;
        END IF;   
          
      END;
     $$ 
        LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION sepgsql.sepgsql_create_tuple_label (text, boolean) 
   IS '32: Создание частей метки безопасности строки: 
                              либо (<уровень>:<категория>) либо (<пользователь>:<роль>)
           Параметры:                   
             1)  p_cl_context  text    -- Контекст клиента
             2)  p_sw          boolean -- Переключатель
       
       Пример использования:   
              SELECT sepgsql_create_tuple_label (sepgsql_getcon(), true);
			  SELECT sepgsql_create_tuple_label (sepgsql_getcon(), false);
   ';  
----------------------------------------------------------------------------
--            SELECT sepgsql_getcon(); -- "generic_u:object_r:netlabel_peer_t:s0:c0"
--   2020-04-04 Nick
-- ------------------------------------------------------------
--  Функции типа AUTH
-- -----------------------------------------------------------
CREATE OR REPLACE FUNCTION sepgsql.auth_f_function_privileges (
        p_role_name    varchar(120)    -- логин пользователя
)
  RETURNS TABLE (rolename      varchar(120)
               , sch_name      text
               , func_name     text
               , lang_name     text
               , func_type     text
               , is_execute    boolean          
 )
AS
$$
    /*=======================================================================*/
    /* DBMS name:      PostgreSQL 8                                          */
    /* Created on:     09.08.2015 12:14:00                                   */
    /* Модификация: 2015-08-18                                               */
    /*      Отображение эффективных привелегий роли для функций.  Роман.     */
    /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
    /* 2017-12-26 Gregory  -- Модификация                                    */   
    /*=======================================================================*/
    WITH iuser AS ( SELECT btrim (p_role_name) AS uname
          )
          ,iclass AS
           (          
             SELECT
                       p.oid
                      ,t.protype::text
                      ,l.lanname::text
                      ,n.nspname::text
                      ,p.proname::text
                      
               FROM pg_proc p
                 JOIN pg_namespace n ON n.oid = p.pronamespace
                 JOIN pg_language  l ON l.oid = p.prolang
               JOIN LATERAL ( SELECT  
                                CASE
                                   WHEN p.prorettype = 'trigger'::regtype THEN 'trigger'
                                    ELSE 'normal'
                                END::varchar(120) AS protype
               ) AS t
                      ON TRUE          
             WHERE ( n.nspname !~ '(^information_schema|^pg_cat.*)' )              
     )
              SELECT
               u.uname
              ,f.nspname 
              ,f.proname
              ,f.lanname
              ,f.protype
              ,has_function_privilege (u.uname, f.oid, 'EXECUTE') AS is_execute
                
             FROM iclass f, iuser u
              WHERE has_function_privilege ( u.uname, f.oid, 'EXECUTE') AND
                    has_schema_privilege (u.uname, f.nspname,'USAGE') 
                 ORDER BY f.nspname;       
$$ 
  LANGUAGE sql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION sepgsql.auth_f_function_privileges ( varchar(120) ) 
 IS '704: Отображение эффективных привелегий роли для функций.

Входные параметры:
    1)  p_role_name    varchar(120)    -- Имя роли

Выходные параметры:
       1)  rolename    varchar(120)  -- Имя роли
       2) ,sch_name    text          -- Имя схемы
       3) ,func_name   text          -- Имя функции
       4) ,lang_name   text          -- Язык
       5) ,func_type   text          -- Тип функции
       6) ,is_execute  boolean       -- Права на выполнение
';  

-- SELECT * FROM auth_f_function_privileges ('postgres') WHERE ( lang_name ~* 'sql|python')

CREATE OR REPLACE FUNCTION sepgsql.auth_f_schema_privileges (
        p_role_name    varchar(120)    -- логин пользователя
)
  RETURNS TABLE (rolename      varchar(120)
               , sch_name      text
               , is_create     boolean          
               , is_usage      boolean          
  )
AS
$$
    /*=======================================================================*/
    /* DBMS name:      PostgreSQL 8                                          */
    /* Created on:     09.08.2015 12:14:00                                   */
    /* Модификация: 2015-08-18                                               */
    /*      Отображение эффективных привелегий роли для схем.  Роман.        */
    /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
    /*=======================================================================*/
    WITH iuser AS ( SELECT btrim (p_role_name) AS uname
          )
          ,iclass AS
           (          
             SELECT
                 n.oid 
                ,n.nspname
                
              FROM pg_namespace n 
              WHERE ( n.nspname <> 'information_schema' )
                AND ( n.nspname !~ '^pg_temp.*' )  
              )
              SELECT
               u.uname
              ,n.nspname::text
              ,has_schema_privilege (u.uname, n.oid,'CREATE') AS is_create
              ,has_schema_privilege (u.uname, n.oid,'USAGE')  AS is_usage
                
             FROM iclass n, iuser u
              WHERE ( n.nspname !~ '(^information_schema|^pg_t.*)' ) AND
                      ( has_schema_privilege (u.uname, n.oid, 'CREATE,USAGE'))
                 ORDER BY n.nspname;       
$$ 
  LANGUAGE sql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION sepgsql.auth_f_schema_privileges (varchar(120))	                                                                       
 IS '704: Отображение эффективных привелегий роли для схем.

Входные параметры:
    1)  p_role_name    varchar(120)    -- Имя роли

Выходные параметры:
    1)  rolename        varchar(120),   -- Имя роли
    2) ,sch_name        text,           -- Имя схемы
    3) ,is_create       boolean         -- Права на CREATE 
    4) ,is_usage        boolean         -- Права на USAGE
';  
--- SELECT * FROM auth_f_schema_privileges('postgres');
--
CREATE OR REPLACE FUNCTION sepgsql.auth_f_sequence_privileges (
        p_role_name    varchar(120)    -- логин пользователя
)
  RETURNS TABLE (rolename      varchar(120)
               , sch_name      varchar(120) 
               , seqname       text
               , is_select     boolean          
               , is_update     boolean          
               , is_usage      boolean           
  )
AS
$$
  /*====================================================================== */
  /* DBMS name:      PostgreSQL 8                                          */
  /* Created on:     09.08.2015 12:14:00                                   */
  /* Модификация: 2015-08-18                                               */
  /*   Отображение эффективных привелегий роли для последовательностей.    */
  /*                          Роман.                                       */
  /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
  /*=======================================================================*/
    WITH iuser AS ( SELECT btrim (p_role_name) AS uname
          )
          ,iclass AS
           (          
             SELECT
                 c.oid 
                ,n.nspname AS sch_name 
                ,c.relname AS seqname
                ,c.relnamespace
                
              FROM pg_namespace n 
                     JOIN pg_class c ON n.oid = c.relnamespace
              WHERE ( (c.relkind = 'S')
                AND ( n.nspname <> 'information_schema' )
                AND ( n.nspname !~ '^pg_temp.*' )  
              )
            )
              SELECT
               u.uname::varchar(120)
              ,c.sch_name::varchar(120) 
              ,c.seqname::text
              ,has_sequence_privilege (u.uname, c.oid,'SELECT') AS is_select
              ,has_sequence_privilege (u.uname, c.oid,'UPDATE') AS is_update
              ,has_sequence_privilege (u.uname, c.oid,'USAGE')  AS is_usage 
                
             FROM iclass c, iuser u
              WHERE has_sequence_privilege (u.uname, c.oid, 'SELECT,UPDATE,USAGE')
                      AND
                    has_schema_privilege (u.uname, c.relnamespace,'USAGE') 

              ORDER BY c.seqname;       
$$ 
   LANGUAGE sql 
   STABLE SECURITY DEFINER;

COMMENT ON FUNCTION sepgsql.auth_f_sequence_privileges ( varchar(120) ) 
IS '704: Отображение эффективных привелегий роли для последовательностей.

Входные параметры:
    1)  p_role_name      varchar(120)    -- Имя роли

Выходные параметры:
    1)   rolename        varchar(120)   -- Имя роли
    2)  ,sch_name        varchar(120)   -- Имя схемы 
    3)  ,sequencename    text           -- Наименование последовательности
    4)  ,is_select       boolean        -- Права на SELECT 
    5)  ,is_update       boolean        -- Права на UPDATE 
    6)  ,is_usage        boolean        -- Права на USAGE  
';

--- SELECT * FROM auth_f_sequence_privileges('postgres');
--- SELECT * FROM auth.auth_f_sequence_privileges('auth_manager');

CREATE OR REPLACE FUNCTION sepgsql.auth_f_table_privileges (
        p_role_name    varchar (120)    -- логин пользователя
       ,p_sys_all      boolean  = FALSE  --  Отображаются только прикладные таблицы
)
  RETURNS TABLE (rolename      varchar(120)
               , sch_name      varchar(120)
               , tablename     text
               , is_select     boolean          
               , is_insert     boolean          
               , is_update     boolean           
               , is_delete     boolean          
               , is_truncate   boolean            
               , is_references boolean              
               , is_trigger    boolean           
  )
AS
$$
    /*======================================================================*/
    /* DBMS name:      PostgreSQL 8                                         */
    /* Created on:     09.08.2015 12:14:00                                  */
    /* Модификация: 2015-08-18                                              */
    /*      Отображение эффективных привелегий роли для таблиц.  Роман.     */
    /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
    /*=======================================================================*/
    WITH iuser AS ( SELECT btrim (p_role_name) AS uname
          )
          ,iclass AS
           (          
             SELECT
                 c.oid
                ,n.nspname 
                ,c.relname  
                ,c.relnamespace
              FROM pg_namespace n 
                     JOIN pg_class c ON n.oid = c.relnamespace
              WHERE ( (c.relkind = 'r')
                      AND ( n.nspname <> 'information_schema' )
                      AND ( n.nspname !~ '^pg_temp.*' )  
                      AND ((p_sys_all) OR ((NOT p_sys_all) AND (c.relname !~ '^pg_*')))
              )
            )
              SELECT
               u.uname::varchar(120)
              ,c.nspname::varchar(120) 
              ,c.relname::text  
              ,has_table_privilege (u.uname, c.oid,'SELECT')       AS is_select
              ,has_table_privilege (u.uname, c.oid,'INSERT')       AS is_insert
              ,has_table_privilege (u.uname, c.oid,'UPDATE')       AS is_update 
              ,has_table_privilege (u.uname, c.oid,'DELETE')       AS is_delete
              ,has_table_privilege (u.uname, c.oid,'TRUNCATE')     AS is_truncate
              ,has_table_privilege (u.uname, c.oid,'REFERENCES')   AS is_references
              ,has_table_privilege (u.uname, c.oid,'TRIGGER')      AS is_trigger
                
             FROM iclass c, iuser u
              WHERE has_table_privilege (u.uname, c.oid, 'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER' )
                      AND
                    has_schema_privilege (u.uname, c.relnamespace,'USAGE') 
             ORDER BY c.nspname, c.relname;       
$$ 
  LANGUAGE sql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION sepgsql.auth_f_table_privileges ( varchar(120), boolean ) 
 IS '704: Отображение эффективных привелегий роли для таблиц.

Входные параметры:
    1)  p_role_name    varchar(120)    -- Имя роли
    2)  p_sys_all      boolean  = TRUE  -- Отображаются все таблицы (в том числе из "pg_catalog")
                                = FALSE -- Отображаются только прикладные таблицы 

Выходные параметры:
    1)  rolename        varchar(120)    -- Имя роли
    2) ,sch_name        varchar(120)    -- Имя схемы 
    3) ,tablename       text            -- Имя таблицы
    4) ,is_select       boolean         -- Права на select 
    5) ,is_insert       boolean         -- Права на insert
    6) ,is_update       boolean         -- Права на update
    7) ,is_delete       boolean         -- Права на delete 
    8) ,is_truncate     boolean         -- Права на truncate 
    9) ,is_references   boolean         -- Права на references  
   10) ,is_trigger      boolean         -- Права на trigger
';  
--- SELECT * FROM auth_f_table_privileges('postgres');

CREATE OR REPLACE FUNCTION sepgsql.auth_f_view_privileges (
        p_role_name    varchar(120)    -- логин пользователя
)
  RETURNS TABLE (rolename      varchar(120)
               , sch_name      varchar(120)
               , viewname      text
               , is_select     boolean          
               , is_insert     boolean          
               , is_update     boolean           
               , is_delete     boolean          
               , is_truncate   boolean            
               , is_references boolean              
               , is_trigger    boolean           
  )
AS
$$
    /*=======================================================================*/
    /* DBMS name:      PostgreSQL 8                                          */
    /* Created on:     09.08.2015 12:14:00                                   */
    /* Модификация: 2015-08-18                                               */
    /*     Отображение эффективных привелегий роли для view       Роман.     */
    /* 2015-09-12 Revision 1319 Roman, изменены типы данных в выходной сетке.*/
    /*=======================================================================*/
    WITH iuser AS ( SELECT btrim (p_role_name) AS uname
          )
          ,iclass AS
           (          
             SELECT
                 c.oid 
                ,n.nspname 
                ,c.relname 
                ,c.relnamespace
              FROM pg_namespace n 
                     JOIN pg_class c ON n.oid = c.relnamespace
              WHERE ( (c.relkind IN ('v', 'm'))
                AND ( n.nspname <> 'information_schema' )
                AND ( n.nspname !~ '^pg_temp.*' )  
              )
            )
              SELECT
               u.uname::varchar(120)
              ,c.nspname::varchar(120)
              ,c.relname::text               
              ,has_table_privilege (u.uname, c.oid,'SELECT')       AS is_select
              ,has_table_privilege (u.uname, c.oid,'INSERT')       AS is_insert
              ,has_table_privilege (u.uname, c.oid,'UPDATE')       AS is_update 
              ,has_table_privilege (u.uname, c.oid,'DELETE')       AS is_delete
              ,has_table_privilege (u.uname, c.oid,'TRUNCATE')     AS is_truncate
              ,has_table_privilege (u.uname, c.oid,'REFERENCES')   AS is_references
              ,has_table_privilege (u.uname, c.oid,'TRIGGER')      AS is_trigger
                
             FROM iclass c, iuser u
              WHERE has_table_privilege (u.uname, c.oid, 'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER' )
                      AND
                    has_schema_privilege (u.uname, c.relnamespace,'USAGE') 
             ORDER BY c.nspname,c.relname;       
$$ 
  LANGUAGE sql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION sepgsql.auth_f_view_privileges ( varchar(120) ) 
 IS '704: Отображение эффективных привелегий роли для view.

Входные параметры:
    1)  p_role_name    varchar(120)    -- Имя роли

Выходные параметры:
    1)  username        varchar(120)    -- Имя роли
    2) ,sch_name        varchar(120)    -- Имя схемы
    3) ,viewname        text            -- Имя view
    4) ,is_select       boolean         -- Права на select 
    5) ,is_insert       boolean         -- Права на insert
    6) ,is_update       boolean         -- Права на update
    7) ,is_delete       boolean         -- Права на delete 
    8) ,is_truncate     boolean         -- Права на truncate 
    9) ,is_references   boolean         -- Права на references  
   10) ,is_trigger      boolean         -- Права на trigger
    
';  
--- SELECT * FROM auth_f_view_privileges('postgres');
CREATE OR REPLACE FUNCTION sepgsql.auth_f_column_privileges (
          p_role_name    text          -- Имя роли
        , p_sch_name     text = NULL   -- Имя схемы 
        , p_tablename    text = NULL   -- Имя таблицы
        , p_sys_all      boolean       = FALSE  -- Отображаются только прикладные таблицы
)
  RETURNS TABLE (rolename           varchar(120)
               , sch_name           varchar(120)
               , tablename          varchar(120)
               , column_number      smallint
               , column_name        varchar(120)
               , type_name          varchar(120)
               , is_select          boolean          
               , is_insert          boolean          
               , is_update          boolean           
               , is_references      boolean     
               , column_description text
  )
AS
  $$
  -- ----------------------------------------------------------
  --  2020-01-09 Nick. Отображение привилегий для столбцов.
  -- ---------------------------------------------------------- 
    WITH iuser AS ( SELECT btrim (lower (p_role_name)) AS uname
         )
          SELECT 
               u.uname                   AS rolename
             , n.nspname::VARCHAR(120)   AS sch_name
             , c.relname::VARCHAR(120)   AS tablename
             , a.attnum::SMALLINT        AS column_number
             , a.attname::VARCHAR  (120) AS column_name
             , t1.typname::VARCHAR (120) AS type_name
               --
             , has_column_privilege (u.uname, c.relname, a.attnum, 'SELECT') AS is_select   
             , has_column_privilege (u.uname, c.relname, a.attnum, 'INSERT') AS is_insert               
             , has_column_privilege (u.uname, c.relname, a.attnum, 'UPDATE') AS is_update               
             , has_column_privilege (u.uname, c.relname, a.attnum, 'REFERENCES') AS is_references               
               -- 
             , d.description::text AS column_description
             
          FROM iuser u, pg_namespace n
                      INNER JOIN pg_class c     ON ( n.oid = c.relnamespace )
                      INNER JOIN pg_attribute a ON (( a.attrelid = c.oid ) AND ( a.attnum > 0 ))
                      INNER JOIN pg_type t1     ON ( a.atttypid = t1.oid )
                      LEFT OUTER JOIN pg_description d  ON ((d.objoid = a.attrelid) AND (a.attnum = d.objsubid))
          WHERE
                 (c.relkind = 'r') 
             AND (n.nspname <> 'information_schema')
             AND (n.nspname !~ '^pg_temp.*')  
             AND ((p_sys_all) OR ((NOT p_sys_all) AND (c.relname !~ '^pg_*')))                 
             AND (n.nspname = COALESCE (btrim (lower (p_sch_name)), n.nspname))
             AND (c.relname = COALESCE (btrim (lower (p_tablename)), c.relname ))                
             AND (has_schema_privilege (u.uname, n.nspname,'USAGE'));
$$ 
  LANGUAGE sql STABLE SECURITY DEFINER;
  
COMMENT ON FUNCTION sepgsql.auth_f_column_privileges (text, text, text, boolean) 
 IS '882: Отображение эффективных привилегий роли для столбца таблицы.
 
 Входные параметры:
    1)  p_role_name    text          -- Имя роли
    2) ,p_sch_name     text = NULL   -- Имя схемы 
    3) ,p_tablename    text = NULL   -- Имя таблицы
    4) ,p_sys_all      boolean  = TRUE  -- Отображаются все таблицы (в том числе из "pg_catalog")
                                = FALSE -- Отображаются только прикладные таблицы 
 Выходные параметры:
    1)  rolename           varchar(120) -- Имя роли
    2) ,sch_name           varchar(120) -- Имя схемы 
    3) ,tablename          varchar(120) -- Имя таблицы
    4) ,column_number      smallint     -- Номер столбца
    5) ,column_name        varchar(120) -- Имя столбца    
    4) ,is_select          boolean      -- Право на select 
    5) ,is_insert          boolean      -- Право на insert
    6) ,is_update          boolean      -- Право на update
    9) ,is_references      boolean      -- Право на references  
   10) ,column_description text         -- Описание столбца 
';  
--
-- SELECT * FROM sepgsql.auth_f_column_privileges (session_user, p_sys_all := true);
--
-- ---------------------------------------------------
--   Триггерные функции. 2020-04-04 Nick
-- ---------------------------------------------------
CREATE OR REPLACE FUNCTION sepgsql.f_tg_after_i()
  RETURNS trigger AS
$$
  -- ------------------------------------------------------------------------------ --
  -- 2019-10-04 Nick Триггерная функция обрабатывающая события INSERT в таблицах БД -- 
  -- 2019-10-08 Nick Секционирование по имени.                                      --
  -- 2019-10-20 Nick Вариант для demo                                               --  
  -- 2019-11-26 Nick Единое наименование технического столбца.                      --
  --            Триггерная функция входит в состав расширения, привязка триггеров   --
  --            выполняется в постинсталляционном скрипте.                          --
  -- 2019-12-02 Nick Дополнительный технический атрибут "s_lvl" содержит уровень и  --
  --              категорию безопасности. Модифицируется функции типа CREATE, SET.  --
  -- 2020-04-03 Nick  Расширение 0.4 Метка в неполном формате (ПОЛЬЗОВАТЕЛЬ, РОЛЬ) 
  -- ------------------------------------------------------------------------------ --
  DECLARE
     PP char(1) := '.';  
  
   BEGIN
     --
     INSERT INTO sepgsql.sepgsql_tuple_z ( table_name, rec_id, security_label ) 
                     VALUES (
                             (lower (TG_TABLE_SCHEMA || PP || TG_TABLE_NAME))
                            ,NEW.rec_id
                            ,sepgsql.sepgsql_create_tuple_label (sepgsql_getcon(), false)
     );
          
     RETURN NEW;
   END;
$$
  LANGUAGE plpgsql VOLATILE 
  SECURITY DEFINER;

COMMENT ON FUNCTION sepgsql.f_tg_after_i() IS '32: Триггерная функция обрабатывающая события INSERT в таблицах БД';
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.f_tg_after_i() IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
--
CREATE OR REPLACE FUNCTION sepgsql.f_tg_before_d()
  RETURNS trigger AS
$$
  -- -------------------------------------------------------------------------------- --
  -- 2019-10-07 Nick Триггерная функция обрабатывающая события DELETE в таблицах БД   --
  -- 2019-10-08 Nick секционирование по имени.                                        --
  -- 2019-10-20 Nick Вариант для Demo                                                 --
  -- 2019-11-26 Nick Единое наименование технического столбца.                        --
  --            Триггерная функция входит в состав расширения, привязка триггеров     --
  --            в постинсталляционный скрипт.                                         --
  -- -------------------------------------------------------------------------------- --
  DECLARE
     _cur_t	    text; 	-- Текущая таблица 

   BEGIN
     _cur_t := lower (TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME);

     DELETE FROM sepgsql.sepgsql_tuple_z WHERE (table_name = _cur_t) AND (rec_id = OLD.rec_id);

     RETURN OLD;
   END;
$$
  LANGUAGE plpgsql VOLATILE 
  SECURITY DEFINER;

COMMENT ON FUNCTION sepgsql.f_tg_before_d() IS '32: Триггерная функция обрабатывающая события DELETE в таблицах БД';
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.f_tg_before_d() IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
--
CREATE OR REPLACE FUNCTION sepgsql.f_tg_after_u()
  RETURNS trigger AS
$$
  -- ----------------------------------------------------------------------------------
  -- 2019-11-26 Nick Единое наименование технического столбца. Обновление технического  --
  --            столбца разрешено только для владельца базы.                            --
  --            Триггерная функция входит в состав расширения, привязка триггеров       --
  --            в постинсталляционный скрипт.                                           --
  -- ----------------------------------------------------------------------------------
  --
  DECLARE
     _cur_t	    text; 	-- Текущая таблица 

   BEGIN
     _cur_t := lower (TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME);
     --
     IF ((OLD.rec_id <> NEW.rec_id) OR (OLD.s_lvs <> NEW.s_lvs)) AND (session_user !~* '^(public|postgres)$')  
       THEN
            RETURN OLD;
       ELSE  -- ((OLD.rec_id = NEW.rec_id) AND (OLD.s_lvs = NEW.s_lvs)) OR (session_user ~* '^(public|postgres)$')
            RETURN NEW;     
     END IF;
     
     RETURN NEW;
   END;
$$
  LANGUAGE plpgsql VOLATILE 
  SECURITY DEFINER;

COMMENT ON FUNCTION sepgsql.f_tg_after_u() IS '32: Триггерная функция обрабатывающая события UPDATE в таблицах БД';
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.f_tg_after_u() IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
--
-- ------------------------------------------------------------------------------- --
-- 2020-03-27 Nick  Новая версия расширения. Роль "sepgsql_role".                       --
-- ------------------------------------------------------------------------------- --
-- DROP FUNCTION IF EXISTS sepgsql.f_show_tbv_descr ( text, char[], text );
CREATE OR REPLACE FUNCTION sepgsql.f_show_tbv_descr  
	 (
	   p_schema_name  text   = NULL -- Наименование схемы    
      ,p_object_type  CHAR[] = array ['r', 'v', 'm', 'c', 't', 'f', 'p'] -- тип объекта 'r' - таблица, 'v' - представление, 'm' - материализованное представление.  
	  ,p_provider     text   = 'selinux'  -- Имя провайдера 
	 ) 
RETURNS TABLE (
		           schema_name     VARCHAR  (64)  -- Наименование схемы
		          ,objoid          oid      -- OID объекта
		          ,obj_type        VARCHAR  (20)  -- Тип объекта
		          ,obj_name        VARCHAR  (64)  -- Наименование объекта
		          ,obj_description VARCHAR  (250) -- Описание объекта
		          ,seclabel        text           -- Метка безопасности
			     ) 
AS
 $$
    -- --------------------------------------------------------------------------------------------- --
 	--  Дата: 22.08.2013  Nick                                                                       --
    -- --------------------------------------------------------------------------------------------- --
    --  За основу взят текст из статьи: Лихачёв В. Н. "ОБРАБОТКА ОШИБОК ОГРАНИЧЕНИЙ ДЛЯ БАЗ ДАННЫХ   -- 
    --              POSTGRESQL".   Калужский университет.                                            --             
    -- --------------------------------------------------------------------------------------------- --
    --     Применение:                                                                               --
    --        SELECT * FROM f_show_tbv_descr (); -- Все схемы и таблицы.                             --
    --        SELECT * FROM f_show_tbv_descr('nso'); -- Все таблицы из схемы НСО                     --
    --        SELECT * FROM f_show_tbv_descr('nso', 'v'); -- Все представленя из схемы НСО           --
    --        SELECT * FROM f_show_tbv_descr ( null, 'v'); -- Все схемы и представления.             --
    -- --------------------------------------------------------------------------------------------- --
    -- 2015.02.15 Адаптация под домен EBD                                                            --
    -- 2015-04-05  Добавлены: STABLE SECURITY DEFINER ;                                              --
    -- 2015-10-13 Материализованные представления                                                    --
    -- 2016-01-22 Типы сущностей согласованы с проектом ASK_U.                                       --
    --                 добавлены новые типы: 't' - pg_toast, 'c' - user defined type                 --
    -- 2019-02-26 Новый тип сущности: внешняя таблица.    
    -- 2020-01-23 Новый тип сущности: секционированная таблица. 
    -- --------------------------------------------------------------------------------------------- --
	BEGIN
	 RETURN QUERY 
         SELECT
           n.nspname::VARCHAR  (64)   AS schema_name 
          ,c.oid::oid        AS objoid   
          ,CASE c.relkind
              WHEN 'r' THEN 'table'
              WHEN 'v' THEN 'view'
              WHEN 'm' THEN 'mat_view'
              WHEN 'c' THEN 'type' 
              WHEN 't' THEN 'pg_toast'
              WHEN 'f' THEN 'ftable' -- 2019-02-26
              WHEN 'p' THEN 'ptable' -- 2020-01-23
              ELSE 'undef'
           END::VARCHAR  (20)            AS obj_type    
          ,c.relname::VARCHAR  (64)      AS obj_name 
          ,d.description::VARCHAR  (250) AS obj_description 
          ,sl.label

       FROM pg_namespace n 
            JOIN pg_class c ON n.oid = c.relnamespace
            LEFT OUTER JOIN pg_description d ON (( d.objoid = c.oid ) AND ( d.objsubid = 0 ))
            LEFT OUTER JOIN 
                 LATERAL ( SELECT s.label, s.objoid FROM pg_seclabels s
                           WHERE (s.objoid = c.oid)    AND 
                                 (s.objtype = CASE c.relkind
                                                 WHEN 'r' THEN 'table'
                                                 WHEN 'v' THEN 'view'
                                                 WHEN 'm' THEN 'mat_view' -- ???
                                                 WHEN 'c' THEN 'type' 
                                                 WHEN 't' THEN 'pg_toast'
                                                 WHEN 'f' THEN 'table'  -- 2019-02-26
                                                 WHEN 'p' THEN 'table'  -- 2020-01-23
                                                 ELSE 'undef'
                                              END
                                  ) AND (s.provider = btrim(lower(p_provider)))            
            
            ) sl ON (c.oid = sl.objoid) 
              
       WHERE (
              ( n.nspname <> 'information_schema' )
          AND ( n.nspname <> 'pg_catalog' )
          AND ( n.nspname NOT LIKE 'pg_temp%' )
          AND (n.nspname = COALESCE (BTRIM (LOWER (p_schema_name )), n.nspname )) 
          AND (c.relkind = ANY(p_object_type)) 
          );  
   END;
 $$
    SET search_path=sepgsql, public, pg_catalog
    STABLE            
    SECURITY DEFINER
    LANGUAGE plpgsql;

COMMENT ON FUNCTION sepgsql.f_show_tbv_descr ( text, char[], text ) IS '6: Получение описание таблицы/представления

  Раздел или область применения: Сервис
  Входные параметры:
   	 p_schema_name    VARCHAR  	 -- Наименование схемы
    ,p_object_type    CHAR(1)[]  -- тип объекта ''r'' - таблица, ''v'' - представление. ''t'' - pg_toast, ''c'' - user defined type   
    ,p_provider       TEXT   = ''selinux''  -- Имя провайдера безопасности

  Выходные параметры: 
	(
		  schema_name     VARCHAR  (20)  NOT NULL - Наименование схемы
		 ,objoid          INTEGER        NOT NULL - OID объекта
		 ,obj_type        VARCHAR  (20)  NOT NULL - Тип объекта
		 ,obj_name        VARCHAR  (64)  NOT NULL - Наименование объекта
		 ,obj_description VARCHAR (250)      NULL - Описание объекта
		 ,seclabel        TEXT           NOT NULL - Метка безопасности     
	)

  Пример использования: 
        SELECT * FROM f_show_tbv_descr ( ''com'', ARRAY[''r'',''v'',''f'']);
        SELECT * FROM f_show_tbv_descr ( NULL, ARRAY[''r'',''v'',''f'']) ORDER BY schema_name, obj_name;
';
-- ----------------------------------------------------------
CREATE OR REPLACE FUNCTION sepgsql.f_show_col_descr
     (
       p_schema_name  VARCHAR (20) = NULL -- Наименование схемы
      ,p_obj_name     VARCHAR (64) = NULL -- Наименование объекта
      ,p_object_type  CHAR(1) []   = array ['r', 'v', 'm', 'c', 't', 'f', 'p'] -- Тип объекта 'r' - таблица, 'v' - представление.
      ,p_provider     text   = 'selinux'  -- Имя провайдера 
    )
RETURNS TABLE (
                  schema_name         VARCHAR  (20)  -- Наименование схемы
                , objoid              INTEGER        -- OID объекта
                , obj_type            VARCHAR  (20)  -- Тип объекта
                , obj_name            VARCHAR  (64)  -- Наименование объекта
                , attr_number         SMALLINT       -- Номер атрибута
                , column_name         VARCHAR  (64)  -- Наименование атрибута
                , type_name           VARCHAR  (64)  -- Наименование типа
                , type_len            INTEGER        -- Длина типа
                , type_prec           INTEGER        -- Точность поля
                , base_name           VARCHAR  (64)  -- Имя базового типа
                , type_category       CHAR(1)        -- Категория типа
                , column_description  VARCHAR (250)  -- Описание столбца
                , not_null            BOOLEAN        -- Признак NOT NULL
                , has_default         BOOLEAN        -- Признак DEFAULT VALUE
                , default_value       TEXT           -- Значение по умолчанию
                , seclabel            TEXT           -- Метка безопасности
              )
AS 
 $$
/*------------------------------------------------------------------------------------
   Описание  f_show_col_descr
   Получение описание столбцов таблицы/представления.
   Необходимо доработать блок, выводящий информацию о типе столбца.
   Раздел или область применения: Сервис

    История:
     Дата: 22.08.2013  NIck
     -- ------------------------
    2015-04-05  Добавлены:
                  STABLE  SECURITY DEFINER
    2016-01-22  Типы сущностей согласованы с проектом ASK_U,
                 добавлены новые типы: 't' - pg_toast, 'c' - user defined type
    2016-02-12 Roman - Длина отображается корректно.
    2017-05-19 Nick  - длина отображается ещё корректнее
    2019-02-26 Новый тип сущности: внешняя таблица.
    2020-01-23 Новый тип сущности: секционированная таблица 
    ---------------------------------------------------------------------------------------------
     За основу взят текст из статьи: Лихачёв В. Н. "ОБРАБОТКА ОШИБОК ОГРАНИЧЕНИЙ ДЛЯ БАЗ ДАННЫХ
                 POSTGRESQL".   Калужский университет.
    ----------------------------------------------------------------------------------------------*/

     DECLARE  
        C_NUM_TYPES text [] := ARRAY ['t_money', 't_decimal', 'money', 'numeric', 'decimal'];
       
     BEGIN
      RETURN QUERY
          SELECT
               n.nspname::VARCHAR(20) AS schema_name
             , c.oid::INTEGER AS objoid
             , CASE c.relkind
                  WHEN 'r' THEN 'table'
                  WHEN 'v' THEN 'view'
                  WHEN 'm' THEN 'mat_view'
                  WHEN 'c' THEN 'type'
                  WHEN 't' THEN 'pg_toast'
                  WHEN 'f' THEN 'ftable' -- 2019-02-26
                  WHEN 'p' THEN 'stable' -- 2020-01-23
                     ELSE 'undef'
               END::varchar(20)         AS obj_type
             , c.relname::VARCHAR(64)   AS obj_name
             , a.attnum::SMALLINT       AS attr_number
             , a.attname::VARCHAR  (64) AS column_name
             , t1.typname::VARCHAR (64) AS type_name
               -- Nick 2017-05-19
             , 
               CASE
                WHEN NOT (t1.typname = ANY (C_NUM_TYPES))
                    THEN -- Nick 2019-02-27
                       COALESCE (t2.character_maximum_length, (
                          CASE  
                             WHEN ((t1.typlen = -1) AND ( NOT t1.typbyval ) and (t1.typcategory = 'S' ) AND 
                                   (t1.typtypmod > 0)
                                  ) 
                             THEN
                                (t1.typtypmod - 4)::INTEGER 
                             ELSE
                                  t1.typlen::INTEGER 
                          END
                         )
                       ) -- Nick 2019-02-27            
                         ELSE
                              t2.numeric_precision::INTEGER             
                END AS type_len
                --
              , CASE  
                     WHEN ( t1.typname = ANY (C_NUM_TYPES))
                       THEN
                           t2.numeric_scale::INTEGER 
                       ELSE
                           0::INTEGER             
                END AS numerci_scale
               -- 
             , t2.data_type::VARCHAR (64) AS base_name
             , t1.typcategory::CHAR(1)  
               -- Nick 2017-05-19
             , d.description::VARCHAR (250) AS column_description
             , a.attnotnull::BOOLEAN   AS not_null
             , a.atthasdef::BOOLEAN    AS has_default
             , t2.column_default::TEXT AS default_value
             , sl.label  AS seclabel
             
          FROM pg_namespace n
                INNER JOIN pg_class c     ON ( n.oid = c.relnamespace )
                INNER JOIN pg_attribute a ON (( a.attrelid = c.oid ) AND ( a.attnum > 0 ))
                INNER JOIN pg_type t1     ON ( a.atttypid = t1.oid )
                LEFT OUTER join information_schema.columns t2 ON 
                            (t2.table_schema = n.nspname) AND (t2.table_name = c.relname) AND
                            (t2.ordinal_position = a.attnum)
                LEFT OUTER JOIN pg_description d ON ((d.objoid = a.attrelid) AND (a.attnum = d.objsubid))
                LEFT OUTER JOIN                              
                 LATERAL ( SELECT s.label, s.objoid, s.objsubid FROM pg_seclabels s
                           WHERE (s.objoid = c.oid) AND (s.objsubid = a.attnum) AND
                                 (s.objtype = 'column') AND (s.provider = btrim(lower(p_provider)))            
            
            ) sl ON (sl.objoid = c.oid) AND (sl.objsubid = a.attnum)                            
          WHERE
               ( c.relkind = ANY (p_object_type ))
           AND ( n.nspname = COALESCE ( lower ( p_schema_name ), n.nspname ) )
           AND ( c.relname = COALESCE ( lower (btrim ( p_obj_name )), c.relname ))
        ORDER BY c.relname, a.attnum;
    END;
    $$
        SET search_path=sepgsql, public, pg_catalog
        STABLE
        SECURITY DEFINER
        LANGUAGE plpgsql;

COMMENT ON FUNCTION sepgsql.f_show_col_descr (varchar, varchar, char[], text) 
                                IS '6: Получение описание столбцов таблицы/представления

   Раздел или область применения: Сервис
   Входные параметры:
       p_schema_name    VARCHAR (20)    -- Наименование схемы
      ,p_obj_name       VARCHAR (64)    -- Наименование объекта
      ,p_object_type    CHAR(1) []      -- Тип объекта ''r'' - таблица, ''v'' - представление, ''t'' - pg_toast, ''c'' - user defined type.
      ,p_provider       TEXT   = ''selinux''  -- Имя провайдера безопасности

   Выходные параметры:
    (
                  schema_name         VARCHAR  (20)  -- Наименование схемы
                , objoid              INTEGER        -- OID объекта
                , obj_type            VARCHAR  (20)  -- Тип объекта
                , obj_name            VARCHAR  (64)  -- Наименование объекта
                , attr_number         SMALLINT       -- Номер атрибута
                , column_name         VARCHAR  (64)  -- Наименование атрибута
                , type_name           VARCHAR  (64)  -- Наименование типа
                , type_len            INTEGER        -- Длина типа
                , type_prec           INTEGER        -- Точность поля
                , base_name           VARCHAR  (64)  -- Имя базового типа
                , type_category       CHAR(1)        -- Категория типа
                , column_description  VARCHAR (250)  -- Описание столбца
                , not_null            BOOLEAN        -- Признак NOT NULL
                , has_default         BOOLEAN        -- Признак DEFAULT VALUE
                , default_value       TEXT           -- Значение по умолчанию 
		        ,seclabel            TEXT           -- Метка безопаснос                
    )
    Пример использования:
             SELECT * FROM f_show_col_descr (); -- Все таблицы во всех схемах.
             SELECT * FROM f_show_col_descr ( NULL, NULL, ARRAY[''v''] ) ORDER BY schema_name, obj_name;  -- Все представления.
             SELECT * FROM f_show_col_descr ( ''obj'', NULL, ARRAY [''v'', ''r''] ) ORDER BY schema_name, obj_name, attr_number; -- Все представления в схеме "Объекты".
    
    Категории типа:
          A - Массив
          B - Логический
          C - Составной
          D - Дата/время
          E - Перечисление
          G - Геометрический
          I - Сетевой адрес
          N - Число
          P - Псевдотип
          R - Диапазон 
          S - Строка
          T - Интервал
          U - Пользовательский
          V - Битовая строка
          X - Неизвестный тип (unknown)
';
--
-- 2020-04-04 Nick
--
CREATE OR REPLACE FUNCTION sepgsql.f_show_proc_list
(
        p_nsp_name_list   text  -- Список схем ( NULL / '[NOT] public, sepgsql' / 'com, nso' )
                DEFAULT 'NOT pg_catalog, information_schema, public, sepgsql'
       ,p_proc_name_like  text  -- Фрагменты наименования процедуры ( NULL / '[NOT] _p_' / '_f_, _sys' )
                DEFAULT NULL
       ,p_proc_type_list  text  -- Список типов процедур ( NULL / '[NOT] agg, trigger, window' / 'normal' )
                DEFAULT 'normal'
       ,p_proc_lang_list  text  -- Список языков ( NULL / '[NOT] internal, c' / 'sql, plpgsql' )
                DEFAULT 'sql, plpgsql'
       ,p_provider       text   = 'selinux'  -- Имя провайдера. Nick 2020-04-04          
)
RETURNS TABLE (
        proc_oid   oid               -- OID процедуры
       ,proc_type  VARCHAR(120)  -- Тип процедуры
       ,proc_lang  VARCHAR(120)  -- Язык процедуры
       ,nsp_name   VARCHAR(120)  -- Наименование схемы
       ,proc_name  VARCHAR(120)  -- Наименование процедуры
       ,args_line  text     -- Строка аргументов
	   ,label      text     -- Контекст безопасности
       ,proc_info  text     -- Описание процедуры
)
AS
$$
  --  ==============================================================================================
  --  Author: Gregory
  --  Create date: 2017-12-26
  --  Description: Отображение списка процедур
  --  2018-01-17 Gregory добавлен proc_info (первая строка из комментария)
  --  2019-03-01 Nick Переход на pg 11.1  
  --  2020-04-04 Nick Включена в состав расширения "pg_promls_selinux"
  --  ==============================================================================================
  DECLARE
        _nsp_arr    text[] := string_to_array(regexp_replace(p_nsp_name_list, 'not|[\r\n\s]?', '', 'ig'), ',');
        _nsp_not    boolean  := EXISTS (SELECT regexp_matches(p_nsp_name_list, '(not)', 'i'));
        _name_parts text := '%' || replace(replace(regexp_replace(p_proc_name_like, 'not|[\r\n\s]?', '', 'ig'), ',', '%'), '_', '\_') || '%';
        _name_not   boolean  := EXISTS (SELECT regexp_matches(p_proc_name_like, '(not)', 'i'));
        _type_arr   text[] := string_to_array(regexp_replace(p_proc_type_list, 'not|[\r\n\s]?', '', 'ig'), ',');
        _type_not   boolean  := EXISTS (SELECT regexp_matches(p_proc_type_list, '(not)', 'i'));
        _lang_arr   text[] := string_to_array(regexp_replace(p_proc_lang_list, 'not|[\r\n\s]?', '', 'ig'), ',');
        _lang_not   boolean  := EXISTS (SELECT regexp_matches(p_proc_lang_list, '(not)', 'i'));
BEGIN
        RETURN QUERY
        SELECT
                p.oid
               ,t.protype
               ,l.lanname::VARCHAR(120)
               ,n.nspname::VARCHAR(120)
               ,p.proname::VARCHAR(120)
               ,('( ' || pg_get_function_arguments (p.oid)::text || ' )')::text
               ,sl.label
               ,substring (description, '([^\r\n]*)')::text
        FROM pg_proc p
          JOIN pg_namespace n ON n.oid = p.pronamespace
          JOIN pg_language  l ON l.oid = p.prolang
          LEFT JOIN pg_description d ON d.objoid = p.oid
          JOIN LATERAL ( SELECT  
                         -- Nick 2019-03-01   
                         CASE
--                            WHEN p.proisagg THEN 'agg'
--                            WHEN p.proiswindow THEN 'window'
                            WHEN p.prorettype = 'trigger'::regtype THEN 'trigger'
                             ELSE 'normal'
                         END::VARCHAR(120) AS protype
                         -- Nick 2019-03-01
          ) AS t ON TRUE
          -- 2020-04-04 Nick
          LEFT OUTER JOIN 
                 LATERAL ( SELECT s.label, s.objoid FROM pg_seclabels s
                           WHERE (s.objoid = p.oid)       AND 
                                 (s.objtype = 'function') AND 
                                 (s.provider = btrim(lower(p_provider)))            
            
            ) sl ON (p.oid = sl.objoid) 

        WHERE
                (
                        _nsp_arr IS NULL
                     OR (
                                _nsp_arr IS NOT NULL
                            AND (
                                        (
                                                _nsp_not IS FALSE
                                            AND n.nspname = ANY(_nsp_arr)
                                        )
                                     OR (
                                                _nsp_not IS TRUE
                                            AND n.nspname != ALL(_nsp_arr)
                                        )
                                )
                                
                        )
                )
            AND (
                        _name_parts IS NULL
                     OR (
                                _name_parts IS NOT NULL
                            AND (
                                        (
                                                _name_not IS FALSE
                                            AND p.proname ILIKE _name_parts
                                        )
                                     OR (
                                                _name_not IS TRUE
                                            AND p.proname NOT ILIKE _name_parts
                                        )
                                )
                                
                        )
                )
            AND (
                        _type_arr IS NULL
                     OR (
                                _type_arr IS NOT NULL
                            AND (
                                        (
                                                _type_not IS FALSE
                                            AND protype = ANY(_type_arr)
                                        )
                                     OR (
                                                _type_not IS TRUE
                                            AND protype != ALL(_type_arr)
                                        )
                                )
                                
                        )
                )
            AND (
                        _lang_arr IS NULL
                     OR (
                                _lang_arr IS NOT NULL
                            AND (
                                        (
                                                _lang_not IS FALSE
                                            AND l.lanname = ANY(_lang_arr)
                                        )
                                     OR (
                                                _lang_not IS TRUE
                                            AND l.lanname != ALL(_lang_arr)
                                        )
                                )
                                
                        )
                )
        ORDER BY
                n.nspname
               ,p.proname;
  END;
$$
   SET search_path = sepgsql, public, pg_catalog
   SECURITY DEFINER
   LANGUAGE plpgsql;

COMMENT ON FUNCTION sepgsql.f_show_proc_list (text, text, text, text, text)
IS '33: Отображение списка процедур.
    Входные параметры:
        1) p_nsp_name_list   text  -- Список схем ( NULL / ''[NOT] public, sepgsql'' / ''com, nso'' )
                DEFAULT ''NOT pg_catalog, information_schema, public, sepgsql''
        2) p_proc_name_like  text  -- Фрагменты наименования процедуры ( NULL / ''[NOT] _p_'' / ''_f_, _sys'' )
                DEFAULT NULL
        3) p_proc_type_list  text  -- Список типов процедур ( NULL / ''[NOT] agg, trigger, window'' / ''normal'' )
                DEFAULT ''normal''
        4) p_proc_lang_list  text  -- Список языков ( NULL / ''[NOT] internal, c'' / ''sql, plpgsql'' )
                DEFAULT ''sql, plpgsql''
        5) p__provedir       text = ''selinux''
 
    Выходные параметры:
        1) proc_oid   oid               -- OID процедуры
        2) proc_type  VARCHAR(120)  -- Тип процедуры
        3) proc_lang  VARCHAR(120)  -- Язык процедуры
        4) nsp_name   VARCHAR(120)  -- Наименование схемы
        5) proc_name  VARCHAR(120)  -- Наименование процедуры
        6) args_line  text     -- Строка аргументов
        7) label      text     -- Метка безопасности
        8) proc_info  text     -- Описание процедуры';
--        
-- -- 2020-04-04 Nick      
--
CREATE OR REPLACE FUNCTION sepgsql.pg_promls_table_add (
       p_app_sch_name  text -- NOT NULL    --  Имя прикладной схемы, прикладных схем может быть несколько.              
      ,p_table_name    text -- NOT NULL    --  Имя таблицы, одна таблица в одной схеме.
      ,p_roles         text[] = ARRAY ['sepgsql_role'] --  Роли- участники
      ,p_se_user_role  text   = 'generic_u:object_r'
      ,p_table_range   text   = 's0:c0' --  ТАБЛИЦА: Уровень, категория (по умолчанию)
      ,p_tuple_range   text   = 's0:c0' --  СТРОКА: Уровень, категория (по умолчанию)
      ,p_tuple_type    text   = 'sepgsql_tuple_t' --  Метка строки (по умолчанию)
    )
  RETURNS text
     SECURITY DEFINER 
     LANGUAGE plpgsql 
  AS
$$
  -- ====================================================================================================== --
  --  2020-03-21  Функция включает MLS доступ для выбранной таблицы. Выполняемые этапы:                     --
  --    Часть 1:                                                                                            --
  --       1)  Создание дополнительных секции.                                                              --
  --       2)  Модификация прикладной таблицы.                                                              --
  --       3)  Установка метки на таблицу и секцию.                                                        --
  --       4)  Создание меток строк в хранилище (выполняется в том случае, если таблица заполнена).         --                           --
  --       5)  Привязка триггерных функций к прикладной таблице                                             --
  --       6)  Создание политик.                                                                            --
  --    Часть 2:                                                                                            --
  --       7) Отзыв привелегий у роли PUBLIC.                                                               --
  --       8) Установка привелегий для ролей (явное перечисление).                                          --
  -- ------------------------------------------------------------------------------------------------------ --
  --  2020-04-03 Nick. Модификация под новую структуру хранения                                             --
  -- ====================================================================================================== -- 

 DECLARE 
   cP  char(1) := '.';
   cDP char(1) := ':';
   
   cPATTERN_SCHEMA text := 'sepgsql';
   cPATTERN_NAME   text := 'sepgsql_tuple_z';
   cTABLE_TYPE     text := 'sepgsql_table_t';
   --
   cERR    text := 'SEPGSQL. Ошибка: ';
   cMES0XX text := 'NULL значения запрещены';
   --
   _app_sch_name  text   := btrim (lower(p_app_sch_name));  -- NOT NULL --  Имя прикладной схемы.
   _table_name    text   := btrim (lower(p_table_name));    -- NOT NULL --  Имя таблицы, одна таблица в одной схеме.
   _roles         text[] := COALESCE (p_roles, ARRAY ['sepgsql_role']); --  Роли- участники
   _se_user_role  text   := COALESCE ((btrim (lower(p_se_user_role))), 'generic_u:object_r');
   _table_range   text   := COALESCE ((btrim (lower(p_table_range))), 's0:c0'); -- ТАБЛИЦА: Уровень, категория (по умолчанию)
   _tuple_range   text   := COALESCE ((btrim (lower(p_tuple_range))), 's0:c0'); -- СТРОКА:  Уровень, категория (по умолчанию)
   _tuple_type    text   := COALESCE ((btrim (lower(p_tuple_type))),  'sepgsql_tuple_t'); --  Метка строки (по умолчанию)
   
   _real_tbl_name  text;
   _real_ptrn_name text;
   _section_name   text;
   _mod_number     int;

   _res_str  text;
   _exec     text;     
   _exec_str text [];
      -- 2020-03-25 Roles
   _role    text;
   _fn_name text;
   
 BEGIN
  IF (_app_sch_name IS NULL) OR ( _table_name IS NULL)
    THEN RAISE '%', cMES0XX;
  END IF;
  --
  IF (NOT EXISTS (SELECT 1 FROM sepgsql.f_show_col_descr (_app_sch_name, _table_name))
     )
    THEN
        RAISE 'Схема "%", либо Таблица "%" не существуют', _app_sch_name, _table_name;
  END IF;
  --
  _real_tbl_name  := _app_sch_name || cP || _table_name;
  _real_ptrn_name := cPATTERN_SCHEMA || cP || cPATTERN_NAME;
  -- --------------------------------------------------------
  --   ЧАСТЬ №1: 1)   Создание дополнительных секций.                                                     
  -- --------------------------------------------------
  SELECT (count(*) -1) INTO _mod_number 
      FROM sepgsql.f_show_tbv_descr ( cPATTERN_SCHEMA, ARRAY['p', 'r']) WHERE (obj_name ~* cPATTERN_NAME);
  --
  _section_name := _real_ptrn_name || '_' || _mod_number ;
  --
  _exec_str := CAST (_exec_str::text[] || 
                      ('CREATE TABLE ' || _section_name || ' PARTITION OF ' || _real_ptrn_name || 
                       ' FOR VALUES IN ' || '(''' || _real_tbl_name || ''');'
                      )::text 
   AS text[]);
  -- 
  _exec_str := CAST (_exec_str::text[] || 
                      ('COMMENT ON TABLE ' || _section_name || 
                       ' IS ' || '''Метка безопасности строки, секция №' || _mod_number || ' -- ' ||  
                       _real_tbl_name || ''';'
                      )::text
   AS text[]);
  -- ---------------------------------------            
  --   2)  Модификация прикладных таблиц.                                                        --
  -- --------------------------------------- 
  _exec_str := CAST (_exec_str::text[] || ('ALTER TABLE ' || _real_tbl_name || ' DROP COLUMN IF EXISTS rec_id CASCADE;') AS text[]);
  _exec_str := CAST (_exec_str::text[] || ('ALTER TABLE ' || _real_tbl_name || ' DROP COLUMN IF EXISTS s_lvs CASCADE;') AS text[]);
  _exec_str := CAST (_exec_str || ('ALTER TABLE ' || _real_tbl_name || 
                                  ' ADD COLUMN rec_id int NOT NULL DEFAULT ' || 
                                  ' nextval(''sepgsql.all_rec_id_seq''::regclass);'
                                  )::text
   AS text[]);
  --
  _exec_str := CAST (_exec_str::text[] || ('ALTER TABLE ' || _real_tbl_name || ' ADD CONSTRAINT ak1_' || 
                                            _table_name || ' UNIQUE (rec_id);'
                                          )::text  
   AS text[]);
   --               
  _exec_str := CAST (_exec_str::text[] || ('ALTER TABLE ' || _real_tbl_name || 
             ' ADD COLUMN s_lvs varchar (10) NOT NULL DEFAULT sepgsql.sepgsql_create_tuple_label (sepgsql_getcon(), true);'
             )::text
   AS text[]); 
               
  _exec_str := CAST (_exec_str::text[] || ('COMMENT ON COLUMN ' || _real_tbl_name || 
                                         '.rec_id IS ''Глобальный ID строки'';'
                                         )::text
   AS text[]);
  _exec_str := CAST (_exec_str::text[] || ('COMMENT ON COLUMN ' || _real_tbl_name || 
                                          '.s_lvs  IS ''Уровень безопасности строки'';'
                                         )::text
   AS text[]);
  -- ---------------------------------------------
  --  3)   Установка меток на таблицы и секции.                           --
  -- ---------------------------------------------
  _exec_str := CAST (_exec_str::text[] || ('SELECT sepgsql.sepgsql_set_table_label_t ( ''' || _real_tbl_name || ''', ''' ||
                                           _se_user_role || cDP || cTABLE_TYPE || cDP || _table_range || ''');'
                                         )::text
   AS text[]);

  _exec_str := CAST (_exec_str::text[] || ('SELECT sepgsql.sepgsql_set_table_label_t ( ''' || _section_name ||
                                     ''', ''' || _se_user_role || cDP || cTABLE_TYPE || cDP || _table_range || ''');'
                                          )::text
   AS text[]);
  -- ----------------------------------------
  --  4) Создание меток строк в хранилище.                                              --
  -- ----------------------------------------
  -- _exec_str := CAST (_exec_str::text[] || ( 'INSERT INTO sepgsql.sepgsql_tuple_z (table_name, rec_id, security_label) ' ||
  --                  'SELECT ''' || _real_tbl_name || ''', rec_id, ''' || (_se_user_role || cDP || _tuple_type || 
  --                    cDP || _tuple_range) || ''' FROM ' || _real_tbl_name || '; '
  --                    )::text
  --  AS text[]);  
  --  --
  -- 2020-04-03 Nick
  _exec_str := CAST (_exec_str::text[] || ( 'INSERT INTO sepgsql.sepgsql_tuple_z (table_name, rec_id, security_label) ' ||
                   'SELECT ''' || _real_tbl_name || ''', rec_id, ''' || 
                   sepgsql.sepgsql_create_tuple_label (sepgsql_getcon(), false) || ''' FROM ' || 
                   _real_tbl_name || '; '
               )::text
   AS text[]);  
   -- 2020-04-03 Nick  
  -- --------------------------------------------------------- --
  --  5)  Привязка Триггерных функций к прикладным таблицам.   --
  -- --------------------------------------------------------- --
  _exec_str := CAST (_exec_str::text[] || ( 'CREATE TRIGGER tg_' || _table_name || '_i AFTER INSERT ON ' || 
                                             _real_tbl_name || ' FOR EACH ROW EXECUTE PROCEDURE sepgsql.f_tg_after_i();'
                                          )::text
   AS text[]);
  --             
  _exec_str := CAST (_exec_str::text[] || ( 'CREATE TRIGGER tg_' || _table_name || '_d BEFORE DELETE ON '|| 
                                           _real_tbl_name || ' FOR EACH ROW EXECUTE PROCEDURE sepgsql.f_tg_before_d();'
                                         )::text
   AS text[]);
  --  
  _exec_str := CAST (_exec_str::text[] || ( 'CREATE TRIGGER tg_' || _table_name || 
                                            '_u AFTER INSERT  ON '|| _real_tbl_name ||
                                            ' FOR EACH ROW EXECUTE PROCEDURE sepgsql.f_tg_after_u();'
               )::text
   AS text[]);
  -- ---------------------------------------------------- --
  --  6)                      Создание политик.           --
  -- ---------------------------------------------------- --
  _exec_str := CAST (_exec_str::text[] || ('ALTER TABLE ' || _real_tbl_name || ' ENABLE ROW LEVEL SECURITY;') AS text[]); 
   
  -- SELECT
  _exec_str := CAST (_exec_str::text[] || ('DROP POLICY IF EXISTS mls_select ON ' || _real_tbl_name || ' CASCADE;') AS text[]);
  --
  _exec_str := CAST (_exec_str::text[] || ('CREATE POLICY mls_select ON ' || _real_tbl_name ||
                    ' FOR SELECT USING (sepgsql.sepgsql_check_tuple_label (sepgsql_getcon(), s_lvs));'
                     )::text
   AS text[]);
        
   -- INSERT
  _exec_str := CAST (_exec_str::text[] || ('DROP POLICY IF EXISTS mls_insert ON ' || _real_tbl_name || ' CASCADE;')::text AS text[]);
  --   
  _exec_str := CAST (_exec_str::text[] || ('CREATE POLICY mls_insert ON ' || _real_tbl_name ||  
                     ' FOR INSERT WITH CHECK ((sepgsql.sepgsql_create_tuple_label (sepgsql_getcon(), false) IS NOT NULL) AND' || 
                     ' (sepgsql.sepgsql_create_tuple_label (sepgsql_getcon(), true) IS NOT NULL)) ;'
                        )::text
  AS text[]);
       
  -- UPDATE
  _exec_str := CAST (_exec_str::text[] || ('DROP POLICY IF EXISTS mls_update ON ' || _real_tbl_name || ' CASCADE;')::text 
  AS text[]);
  --  
  _exec_str := CAST (_exec_str::text[] || ('CREATE POLICY mls_update ON ' || _real_tbl_name || 
                       ' FOR UPDATE USING (sepgsql.sepgsql_check_tuple_label (sepgsql_getcon(), s_lvs));'
         )::text
  AS text[]);
   
   -- DELETE
  _exec_str := CAST (_exec_str::text[] || ('DROP POLICY IF EXISTS mls_delete ON ' || _real_tbl_name || ' CASCADE;')::text AS text[]);
  --   
  _exec_str := CAST (_exec_str::text[] || ('CREATE POLICY mls_delete ON ' || _real_tbl_name ||  
                        ' FOR DELETE USING (sepgsql.sepgsql_check_tuple_label (sepgsql_getcon(), s_lvs));'
                )::text
  AS text[]);
   
  -- --------------------------------------------------------------------
  --   ЧАСТЬ №2: 7) Отзыв привелегий у роли PUBLIC.                                                               --
  -- --------------------------------------------------------------------
    -- Секция
   _exec := 'REVOKE ALL ON TABLE ' || _section_name || ' FROM public;';
   _exec_str := _exec_str || _exec ;
   
   -- Прикладная таблица
   -- _exec := 'REVOKE ALL ON SCHEMA ' || _app_sch_name || ' FROM public;';
   -- _exec_str := _exec_str || _exec ;
   
   _exec := 'REVOKE ALL ON TABLE ' || _real_tbl_name || ' FROM public;'; 
   _exec_str := _exec_str || _exec ;
   
   -- ---------------------------------------------------------
   --  8) Установка привелегий для ролей (явное перечисление).                                          --
   -- ---------------------------------------------------------
   FOREACH _role IN ARRAY _roles
   LOOP
      _role := lower(btrim (_role));
      
      -- Секция   
      _exec := 'GRANT SELECT ON TABLE ' || _section_name || ' TO ' || _role || ';';        
      _exec_str := _exec_str || _exec ;  
      --       
      -- _exec := 'GRANT USAGE ON SCHEMA ' || _app_sch_name || ' TO ' || _role || ';';
      -- _exec_str := _exec_str || _exec ;  
      
      -- Таблицы, столбцы за исключением "s_lvs"
      SELECT string_agg (column_name, ',') INTO _res_str 
                      FROM sepgsql.f_show_col_descr (_app_sch_name, _table_name)
                          WHERE ( column_name <> 's_lvs');
      
      _exec := 'GRANT SELECT (' || _res_str || ', rec_id ) ON ' || _real_tbl_name || ' TO ' || _role || ';';
      _exec_str := _exec_str || _exec ;
              --
      -- Столбец "s_lvs"
      _exec := 'GRANT INSERT (s_lvs) ON ' || _real_tbl_name || ' TO ' || _role || ';';
      _exec_str := _exec_str || _exec ;
      
      -- Назначения на всю таблицу
      --
      _exec := 'GRANT INSERT, UPDATE, DELETE ON TABLE ' || _real_tbl_name || ' TO ' || _role || ';';    
      _exec_str := _exec_str || _exec ;
   END LOOP;

   
   _mod_number := 1;
   FOREACH _exec IN ARRAY _exec_str
     LOOP
         RAISE NOTICE 'p%: %', _mod_number, _exec;
         EXECUTE ( _exec );
         _mod_number := _mod_number + 1;
     END LOOP;     
   
   
  RETURN 'true'::text;

 EXCEPTION
     WHEN OTHERS THEN 
        BEGIN
             RETURN cERR || SQLERRM;			
        END; 
 END;
$$;
        
COMMENT ON FUNCTION sepgsql.pg_promls_table_add (text, text, text[], text, text, text, text) IS 
                '30: Добавляем таблицу в политику MLS. Доверенный контекст.
                
                  ВЫПОЛНЯТЬ С ПРАВАМИ от SUPERUSER-ВЛАДЕЛЕЦ БАЗЫ       
     
  Входные параметры:   
       p_app_sch_name  text -- NOT NULL                  --  Имя прикладной схемы, прикладных схем может быть несколько.              
      ,p_table_name    text -- NOT NULL                  --  Имя таблицы, одна таблица в одной схеме.
      ,p_roles         text[] = ARRAY [''sepgsql_role''] --  Роли- участники
      ,p_se_user_role  text   = ''generic_u:object_r''
      ,p_table_range   text   = ''s0:c0''           --  ТАБЛИЦА: Уровень, категория (по умолчанию)
      ,p_tuple_range   text   = ''s0:c0''           --  СТРОКА: Уровень, категория (по умолчанию)
      ,p_tuple_type    text   = ''sepgsql_tuple_t'' --  Метка строки (по умолчанию)
  
  Пример выполнения:

  SELECT sepgsql.pg_promls_table_add (
                           ''bookings'', ''ticket_flights''
                          ,p_roles := ARRAY [''sepgsql_role''], p_table_range:=''s0-s3:c0''
  );
';
--
-- SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.pg_mls_table_add (text, text, text[], text, text, text, text) IS 
--          'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
--
CREATE OR REPLACE FUNCTION sepgsql.pg_promls_table_remove (
       p_app_sch_name  text -- NOT NULL    --  Имя прикладной схемы, прикладных схем может быть несколько.              
      ,p_table_name    text -- NOT NULL    --  Имя таблицы, одна таблица в одной схеме.
      ,p_section_name  text -- NOT NULL    --  Имя секции с метками  
      ,p_roles         text[] = ARRAY ['sepgsql_role'] --  Роли- участники
      ,p_se_user_role  text   = 'generic_u:object_r' -- SE user, SE role
      ,p_table_range   text   = 's0:c0' --  ТАБЛИЦА: Уровень, категория (по умолчанию)
    )
  RETURNS text  
     SECURITY DEFINER 
     LANGUAGE plpgsql 
  AS
$$
  -- ====================================================================================================== --
  --  2020-03-21  Функция выключает MLS доступ для выбранной таблицы. Выполняемые этапы:                    --
  --      6)  Удаление политик.     
  --      5)  Отвязка Триггерных функций от прикладных таблиц.     ----
  --      2)  Обратная модификация прикладных таблиц.                                                               --
  --      1)  Удаление дополнительных секций.                                                                                               --
  -- ====================================================================================================== -- 

 DECLARE 
   cP  char(1) := '.';
   cDP char(1) := ':';
   
   cPATTERN_SCHEMA text := 'sepgsql';
   cPATTERN_NAME   text := 'sepgsql_tuple_z';
   cTABLE_TYPE     text := 'sepgsql_table_t';
   
   cERR    text := 'SEPGSQL. Ошибка: ';
   cMES0XX text := 'NULL значения запрещены';

   _app_sch_name  text := btrim (lower(p_app_sch_name));  -- NOT NULL --  Имя прикладной схемы.
   _table_name    text := btrim (lower(p_table_name));    -- NOT NULL --  Имя таблицы, одна таблица в одной схеме.
   _section_name  text := btrim (lower(p_section_name));  -- NIT NULL --  Имя секции
   --   
   _se_user_role  text := COALESCE ((btrim (lower(p_se_user_role))), 'generic_u:object_r');
   _table_range   text := COALESCE ((btrim (lower(p_table_range))), 's0:c0'); -- ТАБЛИЦА: Уровень, категория (по умолчанию)
   --   
   _roles text[] := COALESCE (p_roles, ARRAY ['sepgsql_role']); --  Роли- участники
   _role  text;
   --
   _real_tbl_name  text;
   _real_ptrn_name text;
   _mod_number     int;

   _result   boolean;
   _res_str  text;
   _exec     text;     
   _exec_str text [];
   
 BEGIN
  IF (_app_sch_name IS NULL) OR (_table_name IS NULL) OR (_section_name IS NULL)
         THEN  
               RAISE '%', cMES0XX;
  END IF;

  _real_tbl_name  := _app_sch_name || cP || _table_name;
  _real_ptrn_name := cPATTERN_SCHEMA || cP || cPATTERN_NAME;
  
  _exec := 'SELECT (EXISTS (SELECT 1 FROM ' || _section_name ||' WHERE (table_name = ''' || _real_tbl_name || ''')));'; 
  EXECUTE (_exec) INTO _result;
  IF ( NOT _result )
    THEN
          RAISE 'Секция "%" не соответствует защищаемой таблице "%"', _section_name, _real_tbl_name;
  END IF;
  -- ---------------------------------------------------- --
  --  6)              Удаление политик.                   --
  -- ---------------------------------------------------- --
  _exec_str := CAST (_exec_str::text[] || ('DROP POLICY IF EXISTS mls_select ON ' || _real_tbl_name || ' CASCADE;') AS text[]);
  _exec_str := CAST (_exec_str::text[] || ('DROP POLICY IF EXISTS mls_insert ON ' || _real_tbl_name || ' CASCADE;')::text AS text[]);
  _exec_str := CAST (_exec_str::text[] || ('DROP POLICY IF EXISTS mls_update ON ' || _real_tbl_name || ' CASCADE;')::text AS text[]);
  _exec_str := CAST (_exec_str::text[] || ('DROP POLICY IF EXISTS mls_delete ON ' || _real_tbl_name || ' CASCADE;')::text AS text[]);

  _exec_str := CAST (_exec_str::text[] || ('ALTER TABLE ' || _real_tbl_name || ' DISABLE ROW LEVEL SECURITY;') AS text[]); 

  -- --------------------------------------------------------- --
  --  5)  Отвязка Триггерных функций от прикладных таблиц.     --
  -- --------------------------------------------------------- --
  _exec_str := CAST (_exec_str::text[] || ( 'DROP TRIGGER IF EXISTS tg_' || _table_name || '_i ON ' || _real_tbl_name || ';')::text AS text[]);
  _exec_str := CAST (_exec_str::text[] || ( 'DROP TRIGGER IF EXISTS tg_' || _table_name || '_d ON ' || _real_tbl_name || ';')::text AS text[]);
  _exec_str := CAST (_exec_str::text[] || ( 'DROP TRIGGER IF EXISTS tg_' || _table_name || '_u ON ' || _real_tbl_name || ';')::text AS text[]);

  -- ----------------------------------------------            
  --   2)  Обратная модификация прикладных таблиц.                                                        --
  -- ---------------------------------------------- 
  _exec_str := CAST (_exec_str::text[] || ('ALTER TABLE ' || _real_tbl_name || ' DROP COLUMN IF EXISTS rec_id CASCADE;') AS text[]);
  _exec_str := CAST (_exec_str::text[] || ('ALTER TABLE ' || _real_tbl_name || ' DROP COLUMN IF EXISTS s_lvs CASCADE;') AS text[]);

   -- --------------------------------------------------------
  --   1)   Удаление дополнительных секций.                                                     
  -- --------------------------------------------------
  --
 _exec_str := CAST (_exec_str::text[] || ('DROP TABLE ' || p_section_name)::text AS text[]);
 
  -- ----------------------------
  --    0) Метка по умолчанию
  -- ----------------------------
  _exec_str := CAST (_exec_str::text[] || ('SELECT sepgsql.sepgsql_set_table_label_t ( ''' || _real_tbl_name || ''', ''' ||
                                           _se_user_role || cDP || cTABLE_TYPE || cDP || _table_range || ''');'
                                         )::text
   AS text[]);  
   
   -- ---------------------------------------------------------
   -- Отзывы привелегий у ролей участников, отдаём всё PUBLIC 
   -- ---------------------------------------------------------
   FOREACH _role IN ARRAY _roles
   LOOP
      _role := lower (btrim (_role));
      --      
      -- Назначения на всю таблицу
      --
      _exec := 'REVOKE INSERT, UPDATE, DELETE ON TABLE ' || _real_tbl_name || ' FROM ' || _role || ';';    
      _exec_str := _exec_str || _exec ;
      --
      _exec := 'GRANT ALL ON TABLE ' || _real_tbl_name || ' TO public;';    
      _exec_str := _exec_str || _exec ; 
      
      -- Таблицы, столбцы за исключением "s_lvs"
      SELECT string_agg (column_name, ',') INTO _res_str 
                      FROM sepgsql.f_show_col_descr (_app_sch_name, _table_name)
                          WHERE (column_name NOT IN ( 'rec_id', 's_lvs'));
      
      _exec := 'REVOKE SELECT (' || _res_str || ' ) ON ' || _real_tbl_name || ' FROM ' || _role || ';';
      _exec_str := _exec_str || _exec ;
    
   END LOOP;
  
  _mod_number := 1;
  FOREACH _exec IN ARRAY _exec_str
     LOOP
        EXECUTE ( _exec );             
        RAISE NOTICE 'p%: %', _mod_number, _exec;
        _mod_number := _mod_number + 1;
     END LOOP;  
   
  RETURN 'true'::text;

 EXCEPTION
     WHEN OTHERS THEN 
        BEGIN
             RETURN cERR || SQLERRM;			
        END; 
 END;
$$;

COMMENT ON FUNCTION sepgsql.pg_promls_table_remove (text, text, text, text[], text, text) IS 
                '29: Исключаем таблицу из MLS. Доверенный контекст.
 
      Входные параметры:
       p_app_sch_name  text -- NOT NULL    --  Имя прикладной схемы, прикладных схем может быть несколько.              
      ,p_table_name    text -- NOT NULL    --  Имя таблицы, одна таблица в одной схеме.
      ,p_section_name  text -- NOT NULL    --  Имя секции с метками  
      ,p_roles         text[] = ARRAY [''sepgsql_role''] --  Роли- участники
      ,p_se_user_role  text   = ''generic_u:object_r''   -- SE user, SE role
      ,p_table_range   text   = ''s0:c0''                --  ТАБЛИЦА: Уровень, категория (по умолчанию)    
 ';
--
-- -----------------------------------------------------------------------------------------------------------------
--
REVOKE ALL ON SCHEMA   sepgsql                   FROM public;
REVOKE ALL ON SEQUENCE sepgsql.all_rec_id_seq    FROM public;
REVOKE ALL ON TABLE    sepgsql.sepgsql_tuple_z   FROM public; -- 'Метка безопасности строки'
--
-- GET
--
REVOKE ALL ON FUNCTION sepgsql.sepgsql_get_column_label  (text, text) FROM public;
REVOKE ALL ON FUNCTION sepgsql.sepgsql_get_db_label      (text, text) FROM public;
REVOKE ALL ON FUNCTION sepgsql.sepgsql_get_func_label    (text, text) FROM public;   -- 2019-11-26
REVOKE ALL ON FUNCTION sepgsql.sepgsql_get_sch_label     (text, text) FROM public;   -- 2019-11-26
REVOKE ALL ON FUNCTION sepgsql.sepgsql_get_seq_label     (text, text) FROM public;   -- 2019-11-26 
REVOKE ALL ON FUNCTION sepgsql.sepgsql_get_table_label   (text, text) FROM public;   -- 2019-11-26
REVOKE ALL ON FUNCTION sepgsql.sepgsql_get_tuple_label_t (text, int)  FROM public;
REVOKE ALL ON FUNCTION sepgsql.sepgsql_get_view_label    (text, text) FROM public;   -- 2019-11-26
--
-- SET
--                                                                  
REVOKE ALL ON FUNCTION sepgsql.sepgsql_set_column_label_t (text, text, text)  FROM public;
REVOKE ALL ON FUNCTION sepgsql.sepgsql_set_con_t          (text)              FROM public;
REVOKE ALL ON FUNCTION sepgsql.sepgsql_set_db_label_t     (text, text, text)  FROM public;
REVOKE ALL ON FUNCTION sepgsql.sepgsql_set_func_label_t   (text, text, text)  FROM public;
REVOKE ALL ON FUNCTION sepgsql.sepgsql_set_sch_label_t    (text, text, text)  FROM public;
REVOKE ALL ON FUNCTION sepgsql.sepgsql_set_seq_label_t    (text, text, text)  FROM public;
REVOKE ALL ON FUNCTION sepgsql.sepgsql_set_table_label_t  (text, text, text)  FROM public;
REVOKE ALL ON FUNCTION sepgsql.sepgsql_set_tuple_label_t  (text, int,  text)  FROM public;
REVOKE ALL ON FUNCTION sepgsql.sepgsql_set_view_label_t   (text, text, text)  FROM public;
--
-- CHECK
--
REVOKE ALL ON FUNCTION sepgsql.sepgsql_check_tuple_label   (text, varchar(10), text[], boolean) FROM public; -- 2019-12-05
REVOKE ALL ON FUNCTION sepgsql.sepgsql_check_cltb_con      (text, text)                         FROM public;
--
-- CREATE
--
REVOKE ALL ON FUNCTION sepgsql.sepgsql_create_tuple_label (text, boolean) FROM public;
--
-- AUTH
--
REVOKE ALL ON FUNCTION sepgsql.auth_f_function_privileges (varchar(120))              FROM public;
REVOKE ALL ON FUNCTION sepgsql.auth_f_schema_privileges   (varchar(120))              FROM public;
REVOKE ALL ON FUNCTION sepgsql.auth_f_sequence_privileges (varchar(120))              FROM public;
REVOKE ALL ON FUNCTION sepgsql.auth_f_table_privileges    (varchar(120), boolean)     FROM public;
REVOKE ALL ON FUNCTION sepgsql.auth_f_view_privileges     (varchar(120))              FROM public;
REVOKE ALL ON FUNCTION sepgsql.auth_f_column_privileges   (text, text, text, boolean) FROM public; -- 2020-01-10
--
-- DB_INFO
--
REVOKE ALL ON FUNCTION sepgsql.f_show_tbv_descr (text, char[], text)                  FROM public; -- 2020-03-27
REVOKE ALL ON FUNCTION sepgsql.f_show_col_descr (varchar, varchar, char[], text)      FROM public; -- 2020-03-27
REVOKE ALL ON FUNCTION sepgsql.f_show_proc_list (text, text, text, text, text)        FROM public; -- 2020-04-04/2020-03-27

-- ================================================================= --
--  2) Установка привелегий для пользователей (явное перечисление).  --
-- ================================================================= --
-- ------------------------------------------------------------------------------------------------- -- 
--  2019-10-23 Grants на секции и функции                                                            -- 
--  2019-10-30 Функции типа GET, CHECK, работающие со строками, выполняются в доверительном домене.  -- 
--  2019-11-10 Nick Ревизия                                                                          -- 
--  2019-11-19  Nick  Новая схема хранения, bigint -> int                                            -- 
--  2019-11-26  Nick  OID заменён именем объекта, изменена сигнатура функции check.                  -- 
--  2019-12-05  Nick  Ограничиваются права обычных пользователей на схему "sepgsql" и ееё объекты.   --
-- ------------------------------------------------------------------------------------------------- --
-- 2020-03-27 Nick  Новая версия расширения. Роль "sepgsql_role".                                         --
-- ------------------------------------------------------------------------------------------------- -- 
GRANT USAGE  ON SCHEMA sepgsql                  TO sepgsql_role; --
GRANT USAGE  ON SEQUENCE sepgsql.all_rec_id_seq TO sepgsql_role;
GRANT SELECT ON TABLE sepgsql.sepgsql_tuple_z   TO sepgsql_role;  -- 'Метка безопасности строки'
-- ---------------------------------- 
--  2019-11-10 Функции, по новой.
--  2019-11-26, 2019-12-05 - Ревизия 
--  2020-01-10, Новая функция.
-- ----------------------------------
--  GET
--
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_get_column_label  (text, text) TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_get_db_label      (text, text) TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_get_func_label    (text, text) TO sepgsql_role;   -- 2019-11-26
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_get_sch_label     (text, text) TO sepgsql_role;   -- 2019-11-26
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_get_seq_label     (text, text) TO sepgsql_role;   -- 2019-11-26
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_get_table_label   (text, text) TO sepgsql_role;   -- 2019-11-26
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_get_tuple_label_t (text, int)  TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_get_view_label    (text, text) TO sepgsql_role;   -- 2019-11-26
--
-- SET
--
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_set_column_label_t (text, text, text)  TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_set_con_t          (text)              TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_set_db_label_t     (text, text, text)  TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_set_func_label_t   (text, text, text)  TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_set_sch_label_t    (text, text, text)  TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_set_seq_label_t    (text, text, text)  TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_set_table_label_t  (text, text, text)  TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_set_tuple_label_t  (text, int, text)   TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_set_view_label_t   (text, text, text)  TO sepgsql_role;
--
-- CHECK
--
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_check_cltb_con      (text, text)                         TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_check_tuple_label   (text, varchar(10), text[], boolean) TO sepgsql_role; -- 2019-12-05
--
-- CREATE
--
GRANT EXECUTE ON FUNCTION sepgsql.sepgsql_create_tuple_label (text, boolean) TO sepgsql_role;
--
-- AUTH
--
GRANT EXECUTE ON FUNCTION sepgsql.auth_f_function_privileges (varchar(120))              TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.auth_f_schema_privileges   (varchar(120))              TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.auth_f_sequence_privileges (varchar(120))              TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.auth_f_table_privileges    (varchar(120), boolean)     TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.auth_f_view_privileges     (varchar(120))              TO sepgsql_role;
GRANT EXECUTE ON FUNCTION sepgsql.auth_f_column_privileges   (text, text, text, boolean) TO sepgsql_role; -- 2020-01-10
--
-- DB_INFO
--
GRANT EXECUTE ON FUNCTION sepgsql.f_show_tbv_descr (text, char[], text)             TO sepgsql_role; -- 2020-03-27
GRANT EXECUTE ON FUNCTION sepgsql.f_show_col_descr (varchar, varchar, char[], text) TO sepgsql_role; -- 2020-03-27
GRANT EXECUTE ON FUNCTION sepgsql.f_show_proc_list (text, text, text, text, text)   TO sepgsql_role; -- 2020-04-04
