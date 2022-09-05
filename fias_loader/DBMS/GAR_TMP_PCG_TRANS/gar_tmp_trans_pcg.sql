
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW gar_tmp_pcg_trans.version
 AS
 SELECT '$Revision:1738$ modified $RevDate:2022-09-05$'::text AS version; 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_seq_crt (text, bigint);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_seq_crt (text, text, bigint, bigint);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_seq_crt (text, bigint, bigint, text);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_seq_crt (text, bigint, bigint, text, text, text, text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_obj_seq_crt (
              p_seq_name        text   -- Имя последовательности
             ,p_id_region       bigint -- ID региона
             ,p_init_value      bigint -- Начальное значение
              --                                  Схемы
             ,p_adr_area_sch    text = 'unnsi' --   Адресные пространства
             ,p_adr_street_sch  text = 'unnsi' --   Улицы
             ,p_adr_house_sch   text = 'unnsi' --   Дома
              --
             ,p_seq_hist_name   text  = NULL  -- Имя исторической последовательности (УСТАРЕЛО)
)
    RETURNS SETOF bigint
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
     _r   bigint;
     _rh  bigint;
           
     _exec text;
 
     _sq_set text = $_$ 
                        SELECT setval('%s'::regclass, %s::bigint);
                    $_$; 
                     
     _smax text = $_$
          WITH x (max_id) AS (
             SELECT MAX (id_area) FROM %I.adr_area 
                       WHERE (id_area >= %s) AND (id_area < %s)
                UNION 
             SELECT MAX (id_street) FROM %I.adr_street 
                       WHERE (id_street >= %s) AND (id_street < %s)
                UNION 
             SELECT MAX (id_house) FROM %I.adr_house 
                       WHERE (id_house >= %s) AND (id_house < %s)
          )
            SELECT coalesce (MAX(x.max_id), 1) FROM x ;      
      $_$;               
 
     _seq_name      text := btrim (lower (p_seq_name));      -- Имя последовательности
     _seq_hist_name text := btrim (lower (p_seq_hist_name)); -- Имя исторической последовательности (УСТАРЕЛО)
     _id_region  bigint := p_id_region;  -- ID региона
     _init_value bigint := p_init_value; -- Начальное значение    
 
     _val     bigint;
     _min_val bigint;
     _max_val bigint;
      
   BEGIN
     -- --------------------------------------------------------------------------
     --  2021-12-10 Nick  Создание и установка значения для последовательной,
     --    генерирующей ID адресных объектов.
     -- --------------------------------------------------------------------------
     --  2022-01-13 Nick  Последовательности для актуальных и исторических данных 
     --                   становятся независимыми.
     -- --------------------------------------------------------------------------
     --  2022-04-12 Nick. На фиг все премудрости, последовательность одна.
     --  2022-05-16 Nick. Последовательности устанавливаются исходя из актуальных 
     --                    значения в таблицах.
     -- --------------------------------------------------------------------------
     _min_val := _init_value * _id_region;
     _max_val := _min_val + (_init_value / 100) * 99;

     _exec := format (_smax
                         ,p_adr_area_sch  ,_min_val, _max_val
                         ,p_adr_street_sch,_min_val, _max_val
                         ,p_adr_house_sch ,_min_val, _max_val
      );
      EXECUTE _exec INTO _val;
      
      IF NOT (_val = 1 ) THEN
           _val := _val + 10;
      END IF;
      
      _exec := format (_sq_set, _seq_name, _val);
      EXECUTE _exec INTO _r;
      
      RETURN NEXT _r;     
      
      IF (p_seq_hist_name IS NOT NULL)
        THEN
            _exec := format (_sq_set, _seq_hist_name, (_r + 10000000000::bigint));
             EXECUTE _exec INTO _rh;
        
             RETURN NEXT _rh;
      END IF;
   END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_obj_seq_crt (text, bigint, bigint, text, text, text, text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_obj_seq_crt (text, bigint, bigint, text, text, text, text) 
IS 'Установка последовательности для формирования ID новых адресныях объектов';
----------------------------------------------------------------------------------
-- USE CASE:
-----------------------------------------------------------------
--  SELECT gar_tmp_pcg_trans.f_xxx_obj_seq_crt 
--    ('gar_tmp.obj_seq', 22, 100000000, 'gar_tmp.obj_hist_seq');
-- --------------------------------------------------------------
-- DROP SEQUENCE gar_tmp.obj_1_seq;
-- DROP SEQUENCE gar_tmp.obj_hist_1_seq;
-- CREATE SEQUENCE gar_tmp.obj_1_seq INCREMENT 1 START 1;
-- CREATE SEQUENCE gar_tmp.obj_hist_1_seq INCREMENT 1 START 1;
-----------------------------------------------------------------  
-- SELECT gar_tmp_pcg_trans.f_xxx_obj_seq_crt ('gar_tmp.obj_seq', 2, 100000000, 'gar_tmp.obj_hist_seq');
--   200004262
-- 10200013033
-----------------------------------------------------------------

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_replace_char (text, char[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_replace_char (
        p_str   text 
       ,p_char  char[]  = ARRAY['*','&','$','@',':','.','(',')','/', '-', '_', '\']
)
    RETURNS text
    STABLE
    LANGUAGE plpgsql
 AS
  $$
     DECLARE
      cEMP   constant char = ''; 
      _char  char;
      _r     text;
     
     BEGIN
        _r := lower (btrim(p_str));
        FOREACH _char IN ARRAY p_char 
           LOOP
           _r := REPLACE (_r, _char, cEMP);
           END LOOP;
           
        RETURN  REPLACE (_r, ' ', ''); -- Только явно указанные константы
     END;
  $$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_replace_char (text, char[]) 
IS 'Функция удаляет символы-разделители из строки "gar_tmp.xxx_adr_area_type"';
--
-- USE CASE SELECT  gar_tmp_pcg_trans.f_xxx_replace_char (')/--))(as  ad. ((((dg$$5 67)/9---9//90-') 
--                         -- asaddg5679990

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- -------------------------------------------
--  Замечания к тексту функции.
--   - 1) Режим создантие новых записей
--   - 2) Режим обновления
--   - 3) Одно действие для списка схем  (Din SQL)
--     4) Курсор ??
--   + 5) Либо функция с отдельными параметрами
--   + 6) Курсор строитсмя извне ??


DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_area_type_set (
              text,integer,varchar(50),varchar(10),smallint,timestamp without time zone                   
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_area_type_set (
            p_schema_name        text  
           ,p_id_area_type       integer                     
           ,p_nm_area_type       varchar (50)                
           ,p_nm_area_type_short varchar(10)                 = NULL           
           ,p_pr_lead            smallint                    = 0                    
           ,p_dt_data_del        timestamp without time zone = NULL 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ----------------------------------------------------------------------
    --    2021-12-03  Создание/Обновление записи в ОТДАЛЁННОМ справочнике  
    --                  типов адресных пространств
    -- ----------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _ins text = $_$
               INSERT INTO %I.adr_area_type ( 
                    id_area_type       
                   ,nm_area_type       
                   ,nm_area_type_short 
                   ,pr_lead            
                   ,dt_data_del
               )
                 VALUES (   %L::integer
                           ,%L::varchar(50)           
                           ,%L::varchar(10)                 
                           ,%L::smallint
                           ,%L::timestamp without time zone 
                 );      
              $_$;

      _upd text = $_$
                      UPDATE %I.adr_area_type SET  
                               nm_area_type       = %L::varchar(50)           
                              ,nm_area_type_short = %L::varchar(10)                           
                              ,pr_lead            = %L::smallint                 
                              ,dt_data_del        = %L::timestamp without time zone           
                      WHERE (id_area_type = %L::integer);        
        $_$;      
    BEGIN
    _exec := format (_ins, p_schema_name, p_id_area_type, p_nm_area_type, p_nm_area_type_short 
                      ,p_pr_lead, p_dt_data_del);            
     EXECUTE _exec;
    
    EXCEPTION  -- Возникает на отдалённоми сервере            
       WHEN unique_violation THEN 

            _exec := format (_upd, p_schema_name, p_nm_area_type, p_nm_area_type_short 
                             ,p_pr_lead, p_dt_data_del, p_id_area_type
            );            
            EXECUTE _exec;  
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_area_type_set ( text,integer,varchar(50),varchar(10),smallint,timestamp without time zone) 
         IS 'Создание/Обновление записи в ОТДАЛЁННОМ справочнике типов адресных пространств';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_area_type_set ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_area_type_set ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);

--ЗАМЕЧАНИЕ:  повторяющееся значение ключа нарушает ограничение уникальности "cin_p_area_type"
--ЗАМЕЧАНИЕ:  23505


-- Класс 23 — Нарушение ограничения целостности
-- 23000	integrity_constraint_violation
-- 23001	restrict_violation
-- 23502	not_null_violation
-- 23503	foreign_key_violation
-- 23505	unique_violation
-- 23514	check_violation
-- 23P01	exclusion_violation



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_type_set (
              text,integer,varchar(50),varchar(10), timestamp without time zone                   
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_street_type_set (
            p_schema_name          text  
           ,p_id_street_type       integer  
           ,p_nm_street_type       varchar(50)  
           ,p_nm_street_type_short varchar(10)  
           ,p_dt_data_del          timestamp without time zone = NULL 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ----------------------------------------------------------------------
    --    2021-12-03  Создание/Обновление записи в ОТДАЛЁННОМ справочнике  
    --                  типов улиц
    -- ----------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _ins text = $_$
               INSERT INTO %I.adr_street_type ( 
                    id_street_type       
                   ,nm_street_type       
                   ,nm_street_type_short 
                   ,dt_data_del
               )
                 VALUES (   %L::integer
                           ,%L::varchar(50)           
                           ,%L::varchar(10)                 
                           ,%L::timestamp without time zone 
                 );      
              $_$;

      _upd text = $_$
                      UPDATE %I.adr_street_type SET  
                               nm_street_type       = %L::varchar(50)           
                              ,nm_street_type_short = %L::varchar(10)                           
                              ,dt_data_del          = %L::timestamp without time zone           
                      WHERE (id_street_type = %L::integer);        
        $_$;      
    BEGIN
    _exec := format (_ins, p_schema_name, p_id_street_type, p_nm_street_type
                      ,p_nm_street_type_short, p_dt_data_del 
     );            
     EXECUTE _exec;
    
    EXCEPTION  -- Возникает на отдалённоми сервере            
       WHEN unique_violation THEN 

            _exec := format (_upd, p_schema_name, p_nm_street_type, p_nm_street_type_short 
                             ,p_dt_data_del, p_id_street_type  
            );            
            EXECUTE _exec;  
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_type_set (text, integer, varchar(50), varchar(10), timestamp without time zone) 
         IS 'Создание/Обновление записи в ОТДАЛЁННОМ справочнике типов улиц';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_street_type_set ('unsi', 1, 'fff', 'sss',  NULL);
--     CALL gar_tmp_pcg_trans.p_adr_street_type_set ('unsi', 12, 'zzzКвартал','xxxкв-л', NULL);
--     CALL gar_tmp_pcg_trans.p_adr_street_type_set ('unsi', 12, 'Квартал','в-л', NULL);
-- ----------------------------------------------------------------------------------------------
-- ERROR: ОШИБКА:  повторяющееся значение ключа нарушает ограничение уникальности "cin_u_street_type_1"
-- ПОДРОБНОСТИ:  Ключ "(nm_street_type)=(zzzКвартал)" уже существует.
------------------------------------------------------------------------------------------------
         --12 Квартал	кв-л	NULL

-- 



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_type_set (
              text,integer,varchar(50),varchar(10), integer, timestamp without time zone                   
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_type_set (
            p_schema_name          text  
           ,p_id_house_type        integer  
           ,p_nm_house_type        varchar(50)  
           ,p_nm_house_type_short  varchar(10) 
           ,p_kd_house_type_lvl    integer
           ,p_dt_data_del          timestamp without time zone = NULL 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ----------------------------------------------------------------------
    --    2021-12-03  Создание/Обновление записи в ОТДАЛЁННОМ справочнике  
    --                  типов домов/строений
    -- ----------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _ins text = $_$
               INSERT INTO %I.adr_house_type ( 
                    id_house_type       
                   ,nm_house_type       
                   ,nm_house_type_short
                   ,kd_house_type_lvl
                   ,dt_data_del
               )
                 VALUES (   %L::integer
                           ,%L::varchar(50)           
                           ,%L::varchar(10)  
                           ,%L::integer
                           ,%L::timestamp without time zone 
                 );      
              $_$;

      _upd text = $_$
                      UPDATE %I.adr_house_type SET  
                               nm_house_type       = %L::varchar(50)           
                              ,nm_house_type_short = %L::varchar(10)      
                              ,kd_house_type_lvl   = %L::integer
                              ,dt_data_del         = %L::timestamp without time zone           
                      WHERE (id_house_type = %L::integer);        
        $_$;      
    BEGIN
    _exec := format (_ins, p_schema_name, p_id_house_type, p_nm_house_type
                      ,p_nm_house_type_short, p_kd_house_type_lvl, p_dt_data_del 
     );            
     EXECUTE _exec;
    
    EXCEPTION  -- Возникает на отдалённоми сервере            
       WHEN unique_violation THEN 

            _exec := format (_upd, p_schema_name, p_nm_house_type, p_nm_house_type_short 
                             ,p_kd_house_type_lvl, p_dt_data_del, p_id_house_type  
            );            
            EXECUTE _exec;  
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_type_set 
  (text, integer, varchar(50), varchar(10), integer, timestamp without time zone) 
         IS 'Создание/Обновление записи в ОТДАЛЁННОМ справочнике типов типов домов/строений';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_house_type_set ('unsi', 1, 'fff', 'sss',  NULL);
--     CALL gar_tmp_pcg_trans.p_adr_house_type_set ('unsi', 4, 'Корпус','корп.', 2, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_house_type_set ('unsi', 24, 'Корпус','корп.', 2, NULL);
--     4	Корпус	корп.	2	NULL
-- ----------------------------------------------------------------------------------------------

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data (text, date);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data (text, date, text[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data (
        p_schema_name  text  
       ,p_date         date   = current_date
       ,p_stop_list    text[] = NULL
)
    RETURNS SETOF gar_tmp.xxx_adr_area_type
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
       WITH x (
               fias_id            
              ,fias_type_name     
              ,fias_type_shortname
              ,fias_row_key
      
      ) AS (
             SELECT
                 at.id            
                ,at.type_name     
                ,at.type_shortname
                ,gar_tmp_pcg_trans.f_xxx_replace_char (at.type_name) AS row_key
                
             FROM gar_fias.as_addr_obj_type at WHERE (at.is_active) -- AND (at.end_date > %L) 
               ORDER BY at.type_name, at.id                         -- 2021-12-13
      ),
         z (
               fias_ids  
              ,fias_type_names
              ,fias_type_shortnames
              ,fias_row_key       
         ) 
            AS (
                  SELECT array_agg (x.fias_id)
				        ,array_agg (fias_type_name)
				        ,array_agg (fias_type_shortname)
				        ,x.fias_row_key  
                  FROM x GROUP BY x.fias_row_key      
               )
         , y (
                  fias_ids             
                 ,id_area_type        
                 ,fias_type_name      
                 ,nm_area_type        
                 ,fias_type_shortname
                 ,nm_area_type_short  
                 ,pr_lead        
                 ,fias_row_key        
                 ,is_twin                          
         ) AS (
                SELECT 
                       z.fias_ids  
                      ,nt.id_area_type
                      --
                      ,z.fias_type_names[1] 
                      ,nt.nm_area_type 
                      --
                      ,z.fias_type_shortnames[1]
                      ,nt.nm_area_type_short
                      ,nt.pr_lead
                      --
                      ,COALESCE (z.fias_row_key, gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_area_type))                      
                      ,FALSE          
                
                FROM z
                  FULL JOIN %I.adr_area_type nt 
                      ON (z.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_area_type))
                           AND (nt.dt_data_del IS NULL)
                         ORDER BY z.fias_type_names[1] 
             )
                INSERT INTO __adr_area_type  (
                          fias_ids            
                         ,id_area_type        
                         ,fias_type_name      
                         ,nm_area_type        
                         ,fias_type_shortname 
                         ,nm_area_type_short  
                         ,pr_lead             
                         ,fias_row_key        
                         ,is_twin                             
                 )
                   SELECT y.fias_ids           
                         ,y.id_area_type       
                         ,y.fias_type_name     
                         ,y.nm_area_type       
                         ,y.fias_type_shortname
                         ,y.nm_area_type_short 
                         ,y.pr_lead            
                         ,y.fias_row_key       
                         ,y.is_twin  
                         
                FROM y WHERE ((NOT (y.fias_row_key = ANY (%L))) AND %L IS NOT NULL) OR (%L IS NULL);           
    $_$;
    
    _del_something text = $_$
                   DELETE FROM %I.adr_area_type nt
                              WHERE (gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_area_type) = ANY (%L));
    $_$;    
            
   BEGIN
    -- ----------------------------------------------------------------------------------------
    --  2021-12-01 Nick    
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_adr_area_type"
    -- ----------------------------------------------------------------------------------------
    --     p_schema_name text -- Имя схемы-источника._
    --     p_date      date   -- Дата на которую формируется выборка    
    -- ----------------------------------------------------------------------------------------
    --    2021-12-13 активная запись, со истёкшим сроком действия, но в таблице 
    --        с данными есть ссылки на "просроченый тип".
    --    Убран DISTINCT  отношение n <-> 1  (тип фиас тип adr_area).
    -- ----------------------------------------------------------------------------------------
    --   2022-02-18 Добавлен stop_list. Расширенный список ТИПОВ форимруется на эталонной базе,  
    --     типы попавшие в stop_list нужно вычистить в эталоне сразу-же. В функции типа SET они 
    --     будут вычищены на остальных базах.
    -- ----------------------------------------------------------------------------------------
    
    CREATE TEMP TABLE __adr_area_type (LIKE gar_tmp.xxx_adr_area_type)
       ON COMMIT DROP;
    --
    _exec := format (_select,  p_date, p_schema_name, p_stop_list, p_stop_list, p_stop_list);
    EXECUTE (_exec);
    --
    IF (p_stop_list IS NOT NULL)
      THEN
           _exec := format (_del_something, p_schema_name, p_stop_list);
           EXECUTE _exec;
    END IF;    
    --
    RETURN QUERY SELECT * FROM __adr_area_type ORDER BY id_area_type;
   
   END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data (text, date, text[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data (text, date, text[]) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_adr_area_type"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE 
--  SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data ('unnsi'
-- 	,p_stop_list := ARRAY['внутригородскаятерриториявнутригородскоемуниципальноеобразованиегородафедеральногозначения'
-- 						  ,'внутригородскаятерриториявнутригородскоемуници']);
--    ORDER BY id_area_type -- 163 -- , '2015-11-01'
--
--    SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data ('unsi')
--         EXCEPT
--    SELECT * FROM gar_tmp.xxx_adr_area_type ORDER BY 2;
-- ------------------------------------------------------------
-- ALTER TABLE gar_tmp.xxx_adr_area ADD COLUMN addr_obj_type_id bigint;
-- COMMENT ON COLUMN gar_tmp.xxx_adr_area.addr_obj_type_id IS
-- 'ID типа объекта';

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_area_type_set (text,text[],integer[],date);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_area_type_set (text,text[],integer[],date, text[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_type_set (
       
        p_schema_etalon  text 
       ,p_schemas        text[]
       ,p_op_type        integer[] = ARRAY[1,2] 
       ,p_date           date      = current_date
       ,p_stop_list      text[]    = NULL
)

  RETURNS SETOF integer

    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_tmp, public
 AS
  $$
    -- ----------------------------------------------------------------------------------------------
    --  2021-12-01 Nick Запомнить промежуточные данные, типы адресных объектов, обновить ОТДАЛЁННЫЕ 
    --                  справочники.
    -- ----------------------------------------------------------------------------------------
    --   2022-02-18 Добавлен stop_list. Расширенный список ТИПОВ формируется на эталонной базе,  
    --     типы попавшие в stop_list нужно вычистить в эталоне в функции типа SHOW . 
    --     В функции типа SET они будут вычищены на остальных базах.    
    -- ----------------------------------------------------------------------------------------------
    --     p_schema_etalon  text      -- Схема с эталонными справочниками.
    --     p_schemas        text[]    -- Список обновляемых схем (Здесь может быть эталон).
    --     p_op_type        integer[] -- Список выполняемых операций, пока только две.     
    --     p_date           date      -- Дата на которую формируется выборка из "gar_fias".       
    -- ----------------------------------------------------------------------------------------------    
    DECLARE
      _r  integer;
      
      _OP_1 CONSTANT integer = 1;
      _OP_2 CONSTANT integer = 2;
      
      _schema_name text;
      _qty         integer = 0;
      _rdata       RECORD;
      _exec text;
      
      _del_something text = $_$
           DELETE FROM %I.adr_area_type nt
                  WHERE (gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_area_type) = ANY (%L));
       $_$;     
       
    BEGIN 
       IF p_stop_list IS NOT NULL
         THEN
              DELETE FROM gar_tmp.xxx_adr_area_type WHERE (fias_row_key = ANY (p_stop_list));
       END IF;    
       --
       -- 1) Запомнить данные в промежуточной структуре. Выбираем из справочника-эталона.(ОТДАЛЁННЫЙ СПРАВОЧНИК).
       --
       IF (_OP_1 = ANY (p_op_type))
         THEN
            INSERT INTO gar_tmp.xxx_adr_area_type AS z (
                        fias_ids             
                       ,id_area_type        
                       ,fias_type_name      
                       ,nm_area_type        
                       ,fias_type_shortname 
                       ,nm_area_type_short  
                       ,pr_lead 
                       ,fias_row_key        
                       ,is_twin                   
            
             )       
               SELECT   x.fias_ids          
                       ,x.id_area_type        
                       ,x.fias_type_name      
                       ,x.nm_area_type        
                       ,x.fias_type_shortname 
                       ,x.nm_area_type_short  
                       ,x.pr_lead 
                       ,x.fias_row_key        
                       ,x.is_twin           
               
               FROM gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data (p_schema_etalon, p_date, p_stop_list) x
               
                ON CONFLICT (fias_row_key) DO 
                    
                    UPDATE
                         SET
                             fias_ids            = excluded.fias_ids 
                            ,id_area_type        = excluded.id_area_type       
                            ,fias_type_name      = excluded.fias_type_name     
                            ,nm_area_type        = excluded.nm_area_type       
                            ,fias_type_shortname = excluded.fias_type_shortname
                            ,nm_area_type_short  = excluded.nm_area_type_short 
                            ,pr_lead             = excluded.pr_lead 
                            ,is_twin             = excluded.is_twin    
                       
                    WHERE (z.fias_row_key = excluded.fias_row_key);
                  
            GET DIAGNOSTICS _r = ROW_COUNT;
            RETURN NEXT _r; 
       END IF;
       --
       -- 2) Обновить данными из промежуточной структуры. Схемы-Цели (ОТДАЛЁННЫЕ СПРАВОЧНИКИ).
       --       
       --   2.1) Цикл по схемам-целям
       --           2.1.1) Цикл по записям из промежуточно сруктуры.
       --                    с обновлением отдалённого справочниками.                    
       IF (_OP_2 = ANY (p_op_type))
         THEN
         
           FOREACH _schema_name IN ARRAY p_schemas 
           LOOP
         
             IF (p_stop_list IS NOT NULL)
               THEN
                   _exec := format (_del_something, _schema_name, p_stop_list);
                   EXECUTE _exec;
             END IF;
             --    
             FOR _rdata IN 
                 SELECT 
                     COALESCE (id_area_type, (fias_ids[1] + 1000))                   AS id_area_type
                    ,COALESCE (nm_area_type, fias_type_name::varchar(50))            AS fias_type_name 
                    ,COALESCE (nm_area_type_short, fias_type_shortname::varchar(10)) AS nm_area_type_short
                    ,COALESCE (pr_lead, 0::smallint)                                 AS pr_lead
                    ,NULL                                                            AS data_del
                    ,fias_row_key   
             	FROM gar_tmp.xxx_adr_area_type ORDER BY fias_row_key
             LOOP
             
                  CALL gar_tmp_pcg_trans.p_adr_area_type_set (
                        p_schema_name        := _schema_name             ::text   
                       ,p_id_area_type       := _rdata.id_area_type      ::integer                    
                       ,p_nm_area_type       := _rdata.fias_type_name    ::varchar (50)               
                       ,p_nm_area_type_short := _rdata.nm_area_type_short::varchar(10)                        
                       ,p_pr_lead            := _rdata.pr_lead           ::smallint                      
                       ,p_dt_data_del        := _rdata.data_del          ::timestamp without time zone
                  );
                  _qty := _qty + 1; 
             END LOOP;  
             
             RETURN NEXT _qty;
             _qty := 0;
                  
           END LOOP; -- FOREACH _schema_name
         
       END IF;
    END;         
$$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_type_set (text,text[],integer[],date, text[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_type_set (text,text[],integer[],date, text[]) 
IS 'Запомнить промежуточные данные, типы адресных объектов, обновить ОТДАЛЁННЫЕ справочники.';
----------------------------------------------------------------------------------
-- USE CASE:
--  SELECT gar_tmp_pcg_trans.f_xxx_adr_area_type_set ('unnsi',ARRAY['unsi'], ARRAY [1,2]
-- ,p_stop_list := ARRAY['внутригородскаятерриториявнутригородскоемуниципальноеобразованиегородафедеральногозначения'
-- 						  ,'внутригородскаятерриториявнутригородскоемуници']
-- );  

-- ERROR: ОШИБКА:  команда ON CONFLICT DO UPDATE не может менять строку повторно
-- ПОДСКАЗКА:  Проверьте, не содержат ли строки, которые должна добавить команда, дублирующиеся значения, подпадающие под ограничения.
-- КОНТЕКСТ:  SQL-оператор: "INSERT INTO gar_tmp.xxx_adr_area_type AS z (

--  SELECT gar_tmp_pcg_trans.f_xxx_adr_area_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [1]); -- 128  / 165
--  SELECT gar_tmp_pcg_trans.f_xxx_adr_area_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [2]);  -- 164
	 
-- 1)
--  SELECT * FROM gar_tmp.xxx_adr_area_type ORDER BY id_area_type -- 164
--  TRUNCATE TABLE gar_tmp.xxx_adr_area_type;
--  SELECT * FROM gar_tmp.xxx_adr_area_type; -- 0
--  SELECT gar_tmp_pcg_trans.f_xxx_adr_area_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [1]); --129
-- SELECT * FROM gar_tmp.xxx_adr_area_type;
-- SELECT gar_tmp_pcg_trans.f_xxx_adr_area_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [2]);

-- 1,2)
--  SELECT * FROM gar_tmp.xxx_adr_area_type; -- 129
--  TRUNCATE TABLE gar_tmp.xxx_adr_area_type;
--  SELECT * FROM unnsi.adr_area_type ORDER BY 1; -- 0
--  SELECT gar_tmp_pcg_trans.f_xxx_adr_area_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [1,2]); --129
--129, 129, 129
-- select * from unsi.adr_area_type  order by id_area_type WHERE (nm_area_type_short = 'снт'); --

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_street_type_show_data (text, date);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_street_type_show_data (text, date, text[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_show_data (
        p_schema_name  text  
       ,p_date         date   = current_date
       ,p_stop_list    text[] = NULL
)
    RETURNS SETOF gar_tmp.xxx_adr_street_type
    LANGUAGE plpgsql
 AS
  $$
    -- --------------------------------------------------------------------------
    --  2021-12-02 Nick 
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_street_type"
    --     + stop_list. Расширенный список ТИПОВ формируется на эталонной базе, то 
    --       типы попавшие в stop_list нужно вычистить сразу-же. В функции типа SET они 
    --       будут вычищены на остальных базах.
    -- --------------------------------------------------------------------------------------
    --     p_schema_name text   -- Имя схемы-источника._
    --     p_date        date   -- Дата на которую формируется выборка    
    --     p_stop_list   text[] -- список исключаемых типов
    -- --------------------------------------------------------------------------------------    

    DECLARE
    _exec   text;
    _select text = $_$
       WITH z (   
               fias_id            
              ,fias_type_name     
              ,fias_type_shortname
              ,fias_row_key
      
      ) AS (
             SELECT
                 at.id            
                ,at.type_name     
                ,at.type_shortname
                ,gar_tmp_pcg_trans.f_xxx_replace_char (at.type_name) AS row_key
                
             FROM gar_fias.as_addr_obj_type at WHERE (at.is_active) -- AND at.end_date > %L) 
                 AND (at.type_level IN ('7','8'))                          -- 2021-12-14 Nick
               ORDER BY at.type_name, at.id 
      )
      , y (
               fias_ids            
              ,fias_type_names     
              ,fias_type_shortnames
              ,fias_row_key
          ) AS (
                 SELECT array_agg (z.fias_id)            
                       ,array_agg (z.fias_type_name)     
                       ,array_agg (z.fias_type_shortname)
                       ,z.fias_row_key
                       
                 FROM z GROUP BY z.fias_row_key
            )
       , x (
                fias_ids              
               ,id_street_type       
               ,fias_type_name       
               ,nm_street_type       
               ,fias_type_shortname  
               ,nm_street_type_short 
               ,fias_row_key         
               ,is_twin               
               
         ) AS (
                SELECT 
                 y.fias_ids    
                ,st.id_street_type  
                ,y.fias_type_names[1]  
                ,st.nm_street_type
                ,y.fias_type_shortnames[1]
                ,st.nm_street_type_short
                ,COALESCE (y.fias_row_key, gar_tmp_pcg_trans.f_xxx_replace_char (st.nm_street_type))                      
                ,FALSE
                
          FROM y
          
          FULL JOIN %I.adr_street_type st  
                  ON (y.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char (st.nm_street_type))
                           AND
                         (st.dt_data_del IS NULL) ORDER BY y.fias_row_key
         )
          INSERT INTO __adr_street_type ( 
                                            fias_ids             
                                           ,id_street_type       
                                           ,fias_type_name       
                                           ,nm_street_type       
                                           ,fias_type_shortname  
                                           ,nm_street_type_short 
                                           ,fias_row_key         
                                           ,is_twin                 
          )
          
          SELECT      x.fias_ids             
                     ,x.id_street_type       
                     ,x.fias_type_name       
                     ,x.nm_street_type       
                     ,x.fias_type_shortname  
                     ,x.nm_street_type_short 
                     ,x.fias_row_key         
                     ,x.is_twin                   
          
          FROM x WHERE ((NOT (x.fias_row_key = ANY (%L))) AND %L IS NOT NULL) OR (%L IS NULL);           ;
    $_$;
    --    
    _del_something text = $_$
          DELETE FROM %I.adr_street_type nt
                WHERE (gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_street_type) = ANY (%L));
    $_$;    
    
    BEGIN
      CREATE TEMP TABLE __adr_street_type (LIKE gar_tmp.xxx_adr_street_type)
        ON COMMIT DROP;
      --
      _exec := format (_select, p_date, p_schema_name, p_stop_list, p_stop_list, p_stop_list);-- p_date, 
      EXECUTE (_exec);
      --
      IF (p_stop_list IS NOT NULL)
        THEN
           _exec := format (_del_something, p_schema_name, p_stop_list);
           EXECUTE _exec;
      END IF;   
      
      RETURN QUERY SELECT * FROM __adr_street_type ORDER BY id_street_type;     
       
    END;
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_show_data (text, date, text[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_show_data (text, date, text[]) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_street_type"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE 
--           SELECT * FROM gar_tmp_pcg_trans.f_xxx_street_type_show_data ('unnsi'
--                 , p_stop_list := ARRAY ['юрты','усадьба']
-- ); -- 
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_street_type_show_data ('unnsi'); -- 
--   SELECT * FROM unsi.adr_street_type WHERE (id_street_type > 1000);
--   SELECT * FROM unnsi.adr_street_type WHERE (id_street_type > 1000);
--
--   delete FROM unsi.adr_street_type WHERE (id_street_type > 1000);
--   DELETE FROM unnsi.adr_street_type WHERE (id_street_type > 1000);

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_street_type_set (text,text[],integer[],date);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_set (
       
        p_schema_etalon  text 
       ,p_schemas        text[]
       ,p_op_type        integer[] = ARRAY[1,2] 
       ,p_date           date      = current_date
       ,p_stop_list    text[] = NULL       
)

  RETURNS SETOF integer

    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_tmp, public
 AS
  $$
    -- -----------------------------------------------------------------------------------
    --  2021-12-01/2021-12-14 Nick Запомнить промежуточные данные, типы улиц, обновить 
    --                  отдалённые справочники.
    -- -----------------------------------------------------------------------------------
    --   p_schema_etalon  text      -- Схема с эталонныями справочниками.
    --   p_schemas        text[]    -- Список обновляемых схем (Здесь может быть эталон).
    --   p_op_type        integer[] -- Список выполняемых операций, пока только две.     
    --   p_date           date      -- Дата на которую формируется выборка из "gar_fias".
    --   p_stop_list      text[]    -- список исключаемых типов
    -- -----------------------------------------------------------------------------------
    --     + stop_list. Расширенный список ТИПОВ формируется на эталонной базе, то 
    --       типы попавшие в stop_list нужно вычистить сразу-же. В функции типа SET они 
    --       будут вычищены на остальных базах.
    -- -----------------------------------------------------------------------------------
    DECLARE
      _r integer;
      
      _OP_1 CONSTANT integer = 1;
      _OP_2 CONSTANT integer = 2;
      
      _schema_name text;
      _qty         integer = 0;
      _rdata       RECORD;
    
      _exec text;
      
      _del_something text = $_$
           DELETE FROM %I.adr_street_type nt
                  WHERE (gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_street_type) = ANY (%L));
       $_$;       
    
    BEGIN   
     IF p_stop_list IS NOT NULL
       THEN
           DELETE FROM gar_tmp.xxx_adr_street_type WHERE (fias_row_key = ANY (p_stop_list));
     END IF;     
     --
     -- 1) Запомнить данные в промежуточной структуре. Выбираем из справочника-эталона.(ОТДАЛЁННЫЙ СПРАВОЧНИК).
     --
     IF (_OP_1 = ANY (p_op_type))
      THEN  
       INSERT INTO gar_tmp.xxx_adr_street_type AS z (
             fias_ids             
            ,id_street_type       
            ,fias_type_name      
            ,nm_street_type       
            ,fias_type_shortname  
            ,nm_street_type_short  
            ,fias_row_key        
            ,is_twin                    
        )       
          SELECT   x.fias_ids             
                  ,x.id_street_type       
                  ,x.fias_type_name      
                  ,x.nm_street_type     
                  ,x.fias_type_shortname 
                  ,x.nm_street_type_short 
                  ,x.fias_row_key        
                  ,x.is_twin             
          
          FROM gar_tmp_pcg_trans.f_xxx_street_type_show_data (p_schema_etalon, p_date, p_stop_list) x
               ON CONFLICT (fias_row_key) DO 
               
               UPDATE
                    SET
                        fias_ids             = excluded.fias_ids 
                       ,id_street_type       = excluded.id_street_type      
                       ,fias_type_name       = excluded.fias_type_name     
                       ,nm_street_type       = excluded.nm_street_type       
                       ,fias_type_shortname  = excluded.fias_type_shortname
                       ,nm_street_type_short = excluded.nm_street_type_short 
                       ,is_twin              = excluded.is_twin    
                  
               WHERE (z.fias_row_key = excluded.fias_row_key);
             
       GET DIAGNOSTICS _r = ROW_COUNT;
       RETURN NEXT _r;
     END IF;  
     --
     -- 2) Обновить данными из промежуточной структуры. Схемы-Цели (ОТДАЛЁННЫЕ СПРАВОЧНИКИ).
     --       
     --   2.1) Цикл по схемам-целям
     --           2.1.1) Цикл по записям из промежуточно сруктуры.
     --                    с обновлением отдалённого справочниками.                    
     --
     IF (_OP_2 = ANY (p_op_type))
       THEN
         FOREACH _schema_name IN ARRAY p_schemas 
         LOOP
            IF (p_stop_list IS NOT NULL)
               THEN
                   _exec := format (_del_something, _schema_name, p_stop_list);
                   EXECUTE _exec;
            END IF;
         
            FOR _rdata IN 
              SELECT 
                  COALESCE (id_street_type, (fias_ids[1] + 1000))                   AS id_street_type
                 ,COALESCE (nm_street_type, fias_type_name::varchar(50))            AS nm_street_type 
                 ,COALESCE (nm_street_type_short, fias_type_shortname::varchar(10)) AS nm_street_type_short
                 ,NULL                                                              AS data_del
                 ,fias_row_key                
              FROM gar_tmp.xxx_adr_street_type  ORDER BY fias_row_key
            LOOP 
            
               --- RAISE NOTICE '%', _rdata;
               CALL gar_tmp_pcg_trans.p_adr_street_type_set (
                      p_schema_name          := _schema_name               ::text  
                     ,p_id_street_type       := _rdata.id_street_type      ::integer  
                     ,p_nm_street_type       := _rdata.nm_street_type      ::varchar(50)  
                     ,p_nm_street_type_short := _rdata.nm_street_type_short::varchar(10)  
                     ,p_dt_data_del          := _rdata.data_del            ::timestamp without time zone                
               );
               _qty := _qty + 1;            
            END LOOP;
                
            RETURN NEXT _qty;
            _qty := 0;
                              
         END LOOP; -- FOREACH _schema_name
      
     END IF;     
    END;         
$$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_set (text,text[],integer[],date, text[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_set (text,text[],integer[],date, text[]) 
IS ' Запомнить промежуточные данные, типы улицы, обновить ОТДАЛЁННЫЕ справочники.';
----------------------------------------------------------------------------------
-- USE CASE:
--   SELECT * FROM  gar_tmp.xxx_adr_street_type order by 2;
--   TRUNCATE TABLE  gar_tmp.xxx_adr_street_type;

--  SELECT gar_tmp_pcg_trans.f_xxx_street_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [1,2]); -- 49, 49, 49
--  SELECT gar_tmp_pcg_trans.f_xxx_street_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [1]); -- 86
--  SELECT gar_tmp_pcg_trans.f_xxx_street_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [2]); -- 86

-- SELECT gar_tmp_pcg_trans.f_xxx_street_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [1,2]
--                 , p_stop_list := ARRAY ['юрты','усадьба']
-- ); -- 

-- 1)
--  SELECT * FROM gar_tmp.xxx_adr_street_type ORDER BY 1; -- 129
--  TRUNCATE TABLE gar_tmp.xxx_adr_area_type;
--  SELECT * FROM gar_tmp.xxx_adr_area_type; -- 0
--  SELECT gar_tmp_pcg_trans.f_xxx_street_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [1]); --129
-- --------------------------------
-- SELECT * FROM unsi.adr_street_type ORDER BY 1; WHERE (id_area_type >= 1000);
-- SELECT * FROM unnsi.adr_street_type ORDER BY 1;
-- DELETE FROM unsi.adr_street_type WHERE (id_area_type >= 1000);
-- DELETE FROM unnsi.adr_street_type WHERE (id_area_type >= 1000);
-------------------------------------
-- SELECT gar_tmp_pcg_trans.f_xxx_street_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [2]);



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_house_type_show_data (text, date);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_house_type_show_data (text, date, text[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_show_data (
          p_schema_name  text  
         ,p_date         date   = current_date
         ,p_stop_list    text[] = NULL
)
    RETURNS SETOF gar_tmp.xxx_adr_house_type
    LANGUAGE plpgsql
 AS
  $$
    -- --------------------------------------------------------------------------------------
    --  2021-12-01/2021-12-14 Nick 
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_adr_house_type"
    --  2022-02-18 добавлен столбец kd_house_type_lvl - 'Уровень типа номера (1-основной)'
    --     + stop_list. Расширенный список ТИПОВ форимруется на эталонной базе, то 
    --       типы попавшие в stop_list нужно вычистить сразу-же. В функции типа SET они 
    --       будут вычищены на остальных базах.
    -- --------------------------------------------------------------------------------------
    --     p_schema_name text -- Имя схемы-источника._
    --     p_date        date -- Дата на которую формируется выборка       
    -- --------------------------------------------------------------------------------------
    DECLARE
       _exec   text;
       _select text = $_$    
            WITH x (
                    fias_id            
                   ,fias_type_name     
                   ,fias_type_shortname
                   ,fias_row_key
           
           ) AS (
                  SELECT
                      ht.house_type_id            
                     ,ht.type_name     
                     ,ht.type_shortname
                     ,gar_tmp_pcg_trans.f_xxx_replace_char (ht.type_name) AS row_key
                     
                  FROM gar_fias.as_house_type ht WHERE (ht.is_active) -- AND ht.end_date > %L) 
                    ORDER BY ht.type_name, ht.house_type_id           --  2021-12-14 Nick
           ),
              z (
                    fias_ids            
                   ,fias_type_names     
                   ,fias_type_shortnames
                   ,fias_row_key       
              ) 
                 AS (
                       SELECT  array_agg (x.fias_id)
                              ,array_agg (x.fias_type_name)     
                              ,array_agg (x.fias_type_shortname)
                              ,x.fias_row_key  
                       FROM x 
                               GROUP BY x.fias_row_key    
                    )
               ,y  (
                      fias_ids             
                     ,id_house_type       
                     ,fias_type_name      
                     ,nm_house_type       
                     ,fias_type_shortname 
                     ,nm_house_type_short 
                     ,kd_house_type_lvl
                     ,fias_row_key        
                     ,is_twin                           
                   )
               
                   AS (     
                        SELECT 
                            z.fias_ids  
                           ,nt.id_house_type
                           --
                           ,z.fias_type_names[1] 
                           ,nt.nm_house_type 
                           --
                           ,z.fias_type_shortnames[1]
                           ,nt.nm_house_type_short
                           ,nt.kd_house_type_lvl    
                           --
                           ,COALESCE (z.fias_row_key, gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_house_type))
                           ,FALSE          
                     
                        FROM z
                          FULL JOIN %I.adr_house_type nt
                              ON (z.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_house_type))
                                   AND
                                 (nt.dt_data_del IS NULL) ORDER BY z.fias_type_names[1]
                    ) 
                      INSERT INTO __adr_house_type ( 
                                                     fias_ids           
                                                    ,id_house_type      
                                                    ,fias_type_name     
                                                    ,nm_house_type      
                                                    ,fias_type_shortname
                                                    ,nm_house_type_short
                                                    ,kd_house_type_lvl  
                                                    ,fias_row_key       
                                                    ,is_twin            
                      )
                      SELECT  
                             y.fias_ids             
                            ,y.id_house_type       
                            ,y.fias_type_name      
                            ,y.nm_house_type       
                            ,y.fias_type_shortname 
                            ,y.nm_house_type_short 
                            ,y.kd_house_type_lvl
                            ,y.fias_row_key        
                            ,y.is_twin           
                            
                      FROM y WHERE ((NOT (y.fias_row_key = ANY (%L))) AND %L IS NOT NULL) OR (%L IS NULL);  
       $_$;

       _del_something text = $_$
                   DELETE FROM %I.adr_house_type nt
                              WHERE (gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_house_type) = ANY (%L));
       $_$;
       
    BEGIN
      CREATE TEMP TABLE __adr_house_type (LIKE gar_tmp.xxx_adr_house_type)
        ON COMMIT DROP;
      --
      _exec := format (_select, p_date, p_schema_name, p_stop_list, p_stop_list, p_stop_list);
      EXECUTE (_exec);

      IF (p_stop_list IS NOT NULL)
        THEN
             _exec := format (_del_something, p_schema_name, p_stop_list);
             EXECUTE _exec;
      END IF;
      --
      RETURN QUERY SELECT * FROM __adr_house_type ORDER BY id_house_type;                      
    END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_show_data (text, date, text[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_show_data (text, date, text[]) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_house_type"';
----------------------------------------------------------------------------------
--       STOP_LIST CONSTANT text [] := ARRAY ['гараж','шахта']::text[];  
-- USE CASE:
--   EXPLAIN ANALyZE 
--     SELECT * FROM gar_tmp_pcg_trans.f_xxx_house_type_show_data ('unnsi', p_stop_list := ARRAY ['гараж','шахта']); --8
--     SELECT * FROM gar_tmp_pcg_trans.f_xxx_house_type_show_data ('unnsi'); 
--     SELECT * FROM unnsi.adr_house_type ORDER BY 1;
-- CALL gar_tmp_pcg_trans.p_gar_fias_crt_idx ();
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_house_type_show_data (); 
-- SELECT count (1) FROM gar_tmp_pcg_trans.as_addr_obj; --7345  --- 1312 ?
-- SELECT count (1) FROM gar_tmp_pcg_trans.as_addr_obj a WHERE (a.is_actual AND a.is_active); -- 6093  -- 60 ??
--
-- SELECT count (1) FROM gar_tmp_pcg_trans.as_addr_obj a WHERE (a.is_actual AND a.is_active)  -- 6093 ??
-- AND (a.end_date > p_date) 
--                         AND (a.start_date <= p_date);
-- ------------------------------------------------------------
-- ALTER TABLE gar_tmp.xxx_adr_area ADD COLUMN addr_obj_type_id bigint;
-- COMMENT ON COLUMN gar_tmp.xxx_adr_area.addr_obj_type_id IS
-- 'ID типа объекта';

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_house_type_set (text,text[],integer[],date);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_house_type_set (text, text[], integer[], date, text[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_set (
       
        p_schema_etalon  text 
       ,p_schemas        text[]
       ,p_op_type        integer[] = ARRAY[1,2] 
       ,p_date           date      = current_date
       ,p_stop_list      text[]    = NULL
)

  RETURNS SETOF integer

    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_tmp, public
 AS
  $$
    -- ----------------------------------------------------------------------------------------------
    --  2021-12-01 Nick Запомнить промежуточные данные, типы домов.
    --  2022-02-18 добавлен столбец kd_house_type_lvl - 'Уровень типа номера (1-основной)'
    -- ----------------------------------------------------------------------------------------------
    --   p_schema_etalon  text      -- Схема с эталонныями справочниками.
    --   p_schemas        text[]    -- Список обновляемых схем (Здесь может быть эталон).
    --   p_op_type        integer[] -- Список выполняемых операций, пока только две.     
    --   p_date           date      -- Дата на которую формируется выборка из "gar_fias".
    --   p_stop_list      text[]    -- Записи с rowkey,которые должны быть исключены из справочников
    -- ----------------------------------------------------------------------------------------------
    DECLARE
      _r  integer;
      
      _OP_1 CONSTANT integer = 1;
      _OP_2 CONSTANT integer = 2;
      
      _schema_name text;
      _qty         integer = 0;
      _rdata       RECORD;
      
      _exec text;
      
      _del_something text = $_$
           DELETE FROM %I.adr_house_type nt
                  WHERE (gar_tmp_pcg_trans.f_xxx_replace_char (nt.nm_house_type) = ANY (%L));
       $_$;      
      
    BEGIN   
     --
     -- 1) Запомнить данные в промежуточной структуре. Выбираем из справочника-эталона.(ОТДАЛЁННЫЙ СПРАВОЧНИК).
     --  
     IF p_stop_list IS NOT NULL
       THEN
            DELETE FROM gar_tmp.xxx_adr_house_type WHERE (fias_row_key = ANY (p_stop_list));
     END IF;
     
     IF (_OP_1 = ANY (p_op_type))
      THEN      
          INSERT INTO gar_tmp.xxx_adr_house_type AS z (
          
                fias_ids           
               ,id_house_type      
               ,fias_type_name     
               ,nm_house_type      
               ,fias_type_shortname
               ,nm_house_type_short
               ,kd_house_type_lvl  
               ,fias_row_key       
               ,is_twin
               
           )       
             SELECT   x.fias_ids             
                     ,x.id_house_type       
                     ,x.fias_type_name      
                     ,x.nm_house_type       
                     ,x.fias_type_shortname 
                     ,x.nm_house_type_short 
                     ,x.kd_house_type_lvl  
                     ,x.fias_row_key        
                     ,x.is_twin             
             
             FROM gar_tmp_pcg_trans.f_xxx_house_type_show_data (p_schema_etalon, p_date, p_stop_list) x
                  ON CONFLICT (fias_row_key) DO 
                  
                  UPDATE
                       SET
                           fias_ids            = excluded.fias_ids 
                          ,id_house_type       = excluded.id_house_type       
                          ,fias_type_name      = excluded.fias_type_name     
                          ,nm_house_type       = excluded.nm_house_type       
                          ,fias_type_shortname = excluded.fias_type_shortname
                          ,nm_house_type_short = excluded.nm_house_type_short
                          ,kd_house_type_lvl   = excluded.kd_house_type_lvl
                          ,is_twin             = excluded.is_twin    
                     
                  WHERE (z.fias_row_key = excluded.fias_row_key);
                
          GET DIAGNOSTICS _r = ROW_COUNT;
          RETURN NEXT _r;  
     END IF;  
     --
     -- 2) Обновить данными из промежуточной структуры. Схемы-Цели (ОТДАЛЁННЫЕ СПРАВОЧНИКИ).
     --       
     --   2.1) Цикл по схемам-целям
     --           2.1.1) Цикл по записям из промежуточно сруктуры.
     --                    с обновлением отдалённого справочниками.                    
     --    
     IF (_OP_2 = ANY (p_op_type))
       THEN
         FOREACH _schema_name IN ARRAY p_schemas 
         LOOP
            IF (p_stop_list IS NOT NULL)
              THEN
                   _exec := format (_del_something, _schema_name, p_stop_list);
                   EXECUTE _exec;
            END IF;
            --   
            FOR _rdata IN 
              SELECT 
                  COALESCE (id_house_type, (fias_ids[1] + 1000))                   AS id_house_type
                 ,COALESCE (nm_house_type, fias_type_name::varchar(50))            AS nm_house_type 
                 ,COALESCE (nm_house_type_short, fias_type_shortname::varchar(10)) AS nm_house_type_short
                 ,COALESCE (kd_house_type_lvl, 1)                                  AS kd_house_type_lvl
                 ,NULL                                                             AS data_del
                 ,fias_row_key                
              FROM gar_tmp.xxx_adr_house_type ORDER BY fias_row_key
              
            LOOP 
               CALL gar_tmp_pcg_trans.p_adr_house_type_set (

                    p_schema_name         := _schema_name              ::text  
                   ,p_id_house_type       := _rdata.id_house_type      ::integer  
                   ,p_nm_house_type       := _rdata.nm_house_type      ::varchar(50)  
                   ,p_nm_house_type_short := _rdata.nm_house_type_short::varchar(10) 
                   ,p_kd_house_type_lvl   := _rdata.kd_house_type_lvl  ::integer
                   ,p_dt_data_del         := _rdata.data_del           ::timestamp without time zone                
               );
               _qty := _qty + 1;            
            END LOOP;
                
            RETURN NEXT _qty;
            _qty := 0;
                              
         END LOOP; -- FOREACH _schema_name
      
     END IF;       
    END;         
$$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_set (text, text[], integer[], date, text[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_set (text, text[], integer[], date, text[]) 
IS ' Запомнить промежуточные данные, типы домовe, обновить ОТДАЛЁННЫЕ справочники.';
----------------------------------------------------------------------------------
-- USE CASE:
--  SELECT * FROM  gar_tmp.xxx_adr_house_type;
--  TRUNCATE TABLE  gar_tmp.xxx_adr_house_type;
--  SELECT * FROM  unsi.adr_house_type; 

-- SELECT gar_tmp_pcg_trans.f_xxx_house_type_set ('unnsi',ARRAY['unsi']
--                 , ARRAY [1,2], p_stop_list := ARRAY ['гараж','шахта']
-- ); -- 8, 8, 8
--  SELECT gar_tmp_pcg_trans.f_xxx_house_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [1]); -- 10
--  SELECT gar_tmp_pcg_trans.f_xxx_house_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [2]); 
	 
-- 1)
--  SELECT * FROM gar_tmp.xxx_adr_area_type; -- 129
--  TRUNCATE TABLE gar_tmp.xxx_adr_area_type;
--  SELECT * FROM gar_tmp.xxx_adr_area_type; -- 0
--  SELECT gar_tmp_pcg_trans.f_xxx_street_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [1]); --129
-- SELECT * FROM gar_tmp.xxx_adr_area_type;
-- SELECT gar_tmp_pcg_trans.f_xxx_street_type_set ('unsi',ARRAY['unnsi','unsi'], ARRAY [2]);

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp.f_xxx_adr_house_show_data (date, bigint);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_house_show_data (date, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_house_show_data (
       p_date           date   = current_date
      ,p_parent_obj_id  bigint = NULL
)
    RETURNS SETOF gar_tmp.xxx_adr_house
    STABLE
    LANGUAGE sql
 AS
  $$
    -- ---------------------------------------------------------------------------------------
    --  2021-10-20 Nick Функция для формирования таблицы-прототипа "gar_tmp.xxx_adr_house"
    --  2021-12-09/2021-12-20 Ревизия функции. 
    -- ---------------------------------------------------------------------------------------
    --   p_date          date   -- Дата на которую формируется выборка    
    --   p_parent_obj_id bigint -- Идентификатор родительского объекта, если NULL то все дома
    -- ---------------------------------------------------------------------------------------
    
WITH aa (
             id_house       
            ,id_addr_parent 
            --
            ,fias_guid        
            ,parent_fias_guid 
            --   
            ,nm_parent_obj  
	        ,region_code
	        --
	        ,parent_type_id
	        ,parent_type_name
	        ,parent_type_shortname
	        --
	        ,parent_level_id
	        ,parent_level_name
	        ,parent_short_name	        
	        --
            ,house_num
            ,add_num1
            ,add_num2
            --
            ,house_type 
            ,house_type_name
            ,house_type_shortname
            --
            ,add_type1
            ,add_type1_name
            ,add_type1_shortname
            --
            ,add_type2
            ,add_type2_name     
            ,add_type2_shortname
            --
            ,change_id
            --
            ,oper_type_id
            ,oper_type_name     
            --
            ,user_id
            ,rn
            
 ) AS (
        SELECT
           h.object_id
          ,NULLIF (ia.parent_obj_id, 0)
          --
          ,h.object_guid
          ,y.object_guid
          --
          ,y.object_name     -- e.g.  parent_name
	      ,ia.region_code
	       --
	      ,x.id
	      ,x.type_name
	      ,x.type_shortname
	      --
	      ,z.level_id
	      ,z.level_name
	      ,z.short_name
          
          ,h.house_num 
          ,h.add_num1
          ,h.add_num2
          --
          ,h.house_type
          ,t.type_name
          ,t.type_shortname
          --
          ,h.add_type1
          ,a1.type_name
          ,a1.type_shortname
          --
          ,h.add_type2
          ,a2.type_name
          ,a2.type_shortname
          --
          ,h.change_id
          --
          ,h.oper_type_id
          ,ot.oper_type_name
          --
          ,session_user
          --
          ,row_number() OVER (PARTITION BY ia.parent_obj_id, h.house_type, h.add_type1, h.add_type2
								  , upper(h.house_num), upper(h.add_num1), upper(h.add_num2) 
								  ORDER BY h.change_id DESC
                             ) AS rn
          
        FROM gar_fias.as_houses h
          INNER JOIN gar_fias.as_reestr_objects r ON ((r.object_id = h.object_id) AND (r.is_active))
          --
          INNER JOIN gar_fias.as_house_type t ON ((t.house_type_id = h.house_type) AND (t.is_active)
                                                     AND (t.end_date > p_date) AND (t.start_date <= p_date)
                                                 )
          --    Проверить      -- LEFT OUTER                             
          INNER JOIN gar_fias.as_adm_hierarchy ia ON ((ia.object_id = r.object_id) AND (ia.is_active) 
                                                           AND (ia.end_date > p_date) AND (ia.start_date <= p_date)
                                                     )
	      --  LEFT OUTER
          INNER JOIN gar_fias.as_addr_obj y ON (y.object_id = ia.parent_obj_id)  
                              AND ((y.is_actual AND y.is_active) AND (y.end_date > p_date) AND (y.start_date <= p_date)
                              )
          LEFT OUTER  JOIN gar_fias.as_object_level z ON (z.level_id = y.obj_level) AND (z.is_active) 
                                                     AND ((z.end_date > p_date) AND (z.start_date <= p_date)
                                                     )
          LEFT OUTER JOIN gar_fias.as_addr_obj_type x ON (x.id = y.type_id) AND (x.is_active)
                                                      AND ((x.end_date > p_date) AND (x.start_date <= p_date)
                                                      )
          LEFT OUTER JOIN gar_fias.as_add_house_type a1 ON (a1.add_type_id = h.add_type1) AND (a1.is_active)
                                                      AND ((a1.end_date > p_date) AND (a1.start_date <= p_date)
                                                      )
          LEFT OUTER JOIN gar_fias.as_add_house_type a2 ON (a2.add_type_id = h.add_type2)  AND (a2.is_active)
                                                      AND ((a2.end_date > p_date) AND (a2.start_date <= p_date)
                                                      )
          --
          LEFT OUTER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = h.oper_type_id) AND (ot.is_active)
                                                      AND ((ot.end_date > p_date) AND (ot.start_date <= p_date)
                                                      ) 
       WHERE ((h.is_actual AND h.is_active) AND (h.end_date > p_date) AND (h.start_date <= p_date)
                ) 
 )
   SELECT 
             aa.id_house       
            ,aa.id_addr_parent 
            --
            ,aa.fias_guid        
            ,aa.parent_fias_guid 
            --   
            ,aa.nm_parent_obj  
	        ,aa.region_code
	        --
	        ,aa.parent_type_id
	        ,aa.parent_type_name
	        ,aa.parent_type_shortname
	        --
	        ,aa.parent_level_id
	        ,aa.parent_level_name
	        ,aa.parent_short_name	        
	        --
            ,aa.house_num
            ,aa.add_num1
            ,aa.add_num2
            --
            ,aa.house_type 
            ,aa.house_type_name
            ,aa.house_type_shortname
            --
            ,aa.add_type1
            ,aa.add_type1_name
            ,aa.add_type1_shortname
            --
            ,aa.add_type2
            ,aa.add_type2_name     
            ,aa.add_type2_shortname
            --
            ,aa.oper_type_id
            ,aa.oper_type_name     
            --
            ,aa.user_id
   
   FROM aa 
        WHERE (((aa.id_addr_parent = p_parent_obj_id) AND (p_parent_obj_id IS NOT NULL))
                                OR
                          (p_parent_obj_id IS NULL)
              ) AND (aa.rn = 1) 
        ORDER BY aa.id_addr_parent, aa.id_house; 
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_house_show_data (date, bigint) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_house_show_data (date, bigint) 
IS 'Функция для формирования таблицы-прототипа "gar_tmp.xxx_adr_house"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_house_show_data (); -- 2 sec 96'167 rows
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_house_show_data (p_parent_obj_id := 1260);

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp.f_xxx_adr_house_load_data (date, bigint);
DROP FUNCTION IF EXISTS gar_tmp.f_xxx_adr_house_set_data (date, bigint);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_house_set_data (date, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_house_set_data (
         p_date           date   = now()::date
        ,p_parent_obj_id  bigint = NULL
) 
 RETURNS SETOF integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- =============================================================================
    -- Author: Nick
    -- Create date: 2021-10-20/2021-12-09
    -- -----------------------------------------------------------------------------  
    --           Загрузка прототипа таблицы домов "gar_tmp.xxx_adr_house".
    -- =============================================================================
    DECLARE
      _r  integer;
    
    BEGIN
       DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ie1; 
       --    
       INSERT INTO gar_tmp.xxx_adr_house AS x
        (
                                                id_house              
                                               ,id_addr_parent        
                                               ,fias_guid             
                                               ,parent_fias_guid      
                                               ,nm_parent_obj         
                                               ,region_code           
                                               ,parent_type_id        
                                               ,parent_type_name      
                                               ,parent_type_shortname 
                                               ,parent_level_id       
                                               ,parent_level_name     
                                               ,parent_short_name     
                                               ,house_num             
                                               ,add_num1              
                                               ,add_num2              
                                               ,house_type            
                                               ,house_type_name       
                                               ,house_type_shortname  
                                               ,add_type1             
                                               ,add_type1_name        
                                               ,add_type1_shortname   
                                               ,add_type2             
                                               ,add_type2_name        
                                               ,add_type2_shortname   
                                               ,oper_type_id            
                                               ,oper_type_name        
                                               ,user_id               
        )
          SELECT      x.id_house              
                     ,x.id_addr_parent        
                     ,x.fias_guid             
                     ,x.parent_fias_guid      
                     ,x.nm_parent_obj         
                     ,x.region_code           
                     ,x.parent_type_id        
                     ,x.parent_type_name      
                     ,x.parent_type_shortname 
                     ,x.parent_level_id       
                     ,x.parent_level_name     
                     ,x.parent_short_name     
                     ,x.house_num             
                     ,x.add_num1              
                     ,x.add_num2              
                     ,x.house_type            
                     ,x.house_type_name       
                     ,x.house_type_shortname  
                     ,x.add_type1             
                     ,x.add_type1_name        
                     ,x.add_type1_shortname   
                     ,x.add_type2             
                     ,x.add_type2_name        
                     ,x.add_type2_shortname   
                     ,x.oper_type_id            
                     ,x.oper_type_name        
                     ,x.user_id   
                     
          FROM gar_tmp_pcg_trans.f_xxx_adr_house_show_data (
                             p_date
                           , p_parent_obj_id
          ) x
          ON CONFLICT (id_house) DO 
               UPDATE
                    SET          
                      id_addr_parent        = excluded.id_addr_parent       
                     ,fias_guid             = excluded.fias_guid            
                     ,parent_fias_guid      = excluded.parent_fias_guid     
                     ,nm_parent_obj         = excluded.nm_parent_obj        
                     ,region_code           = excluded.region_code          
                     ,parent_type_id        = excluded.parent_type_id       
                     ,parent_type_name      = excluded.parent_type_name     
                     ,parent_type_shortname = excluded.parent_type_shortname
                     ,parent_level_id       = excluded.parent_level_id      
                     ,parent_level_name     = excluded.parent_level_name    
                     ,parent_short_name     = excluded.parent_short_name    
                     ,house_num             = excluded.house_num            
                     ,add_num1              = excluded.add_num1             
                     ,add_num2              = excluded.add_num2             
                     ,house_type            = excluded.house_type           
                     ,house_type_name       = excluded.house_type_name      
                     ,house_type_shortname  = excluded.house_type_shortname 
                     ,add_type1             = excluded.add_type1            
                     ,add_type1_name        = excluded.add_type1_name       
                     ,add_type1_shortname   = excluded.add_type1_shortname  
                     ,add_type2             = excluded.add_type2            
                     ,add_type2_name        = excluded.add_type2_name       
                     ,add_type2_shortname   = excluded.add_type2_shortname  
                     ,oper_type_id          = excluded.oper_type_id           
                     ,oper_type_name        = excluded.oper_type_name       
                     ,user_id               = excluded.user_id              

                WHERE (x.id_house = excluded.id_house);             
          
        GET DIAGNOSTICS _r = ROW_COUNT;
        CREATE INDEX IF NOT EXISTS _xxx_adr_house_ie1 
                       ON gar_tmp.xxx_adr_house USING btree (id_addr_parent);
        
        RETURN NEXT _r;
        --
    END;
  $$;

ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_house_set_data (date, bigint) OWNER TO postgres;

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_house_set_data (date, bigint) 
IS 'Загрузка прототипа таблицы домов "gar_tmp_pcg_trans.xxx_adr_house"';
--
--  USE CASE:
--         SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_house_set_data (); ---  15 min 253121 rows
--         SELECT * FROM gar_tmp.xxx_adr_house;  -- 253121
--         TRUNCATE TABLE gar_tmp.xxx_adr_house;  -- 253121
-- --------------------------------------------------------------------------------------------
--  SELECT lineno, avg_time, source FROM plpgsql_profiler_function_tb ('gar_tmp_pcg_trans.f_xxx_adr_house_set_data (bigint[], bigint[])');
--  SELECT * FROM plpgsql_profiler_function_tb ('gar_tmp_pcg_trans.f_xxx_adr_house_set_data (bigint[], bigint[])');
-- ------------------------------------------------------------------------------------------------------
--  SELECT * FROM plpgsql_profiler_function_statements_tb ('gar_tmp_pcg_trans.f_xxx_adr_house_set_data (bigint[], bigint[])');

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 (text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 (
        p_schema_name  text  
)
    RETURNS SETOF gar_tmp.xxx_obj_fias
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    TMP_TABLE_NAME CONSTANT text = '__adr_area_fias';
    
    _select text = $_$
    
      WITH x (
                 id_obj_fias   
                ,obj_guid_fias 
                ,type_object 
		        ,tree_d
		        ,level_d
      ) AS (
             SELECT
                 aa.id_addr_obj   
                ,aa.fias_guid     
                ,0 AS type_object
		        ,aa.tree_d
		        ,aa.level_d
                
             FROM gar_tmp.xxx_adr_area aa 
                    WHERE (aa.obj_level <> 8)--- AND NOT((nm_addr_obj ilike 'ГСК%%')))  
		        ORDER BY tree_d
      )
                INSERT INTO %I
                       SELECT 
                              nt.id_area      AS id_obj        
                             ,x.id_obj_fias   AS id_obj_fias   
                             ,x.obj_guid_fias AS obj_guid      
                             ,x.type_object   AS type_object   
                             --
                             ,x.tree_d
                             ,x.level_d
                       FROM x
                         LEFT JOIN LATERAL 
                              ( SELECT z.id_area, z.nm_fias_guid FROM ONLY %I.adr_area z
                                   WHERE (z.id_data_etalon IS NULL) AND (z.dt_data_del IS NULL) 
                                            AND
                                         (z.nm_fias_guid = x.obj_guid_fias)
                                ORDER BY z.id_area 
             
                              ) nt ON TRUE;                                 
            $_$;
            
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-06 Nick  АДРЕСНЫЕ ОБЪЕКТЫ БЕЗ УЛИЦ
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_obj_fias"
    -- --------------------------------------------------------------------------
    --     p_schema_name text -- Имя схемы-источника._
    -- --------------------------------------------------------------------------
    CREATE TEMP TABLE IF NOT EXISTS __adr_area_fias (LIKE gar_tmp.xxx_obj_fias)
        ON COMMIT DROP;
    TRUNCATE TABLE __adr_area_fias;    
    --
    _exec := format (_select, TMP_TABLE_NAME, p_schema_name); -- p_date, 
    EXECUTE (_exec);
    --
    RETURN QUERY SELECT * FROM __adr_area_fias;
   
   END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 (text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 (text) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_obj_fias"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE 
--      SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 ('unnsi') 
--              WHERE (obj_guid = 'ab4ac1b4-165d-4bab-be36-a974c4241902');
--     INSERT INTO gar_tmp.xxx_obj_fias 
--        SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 ('unsi'); 
--   SELECT * FROM gar_tmp.xxx_obj_fias;
-- CREATE INDEX IF NOT EXISTS _xxx_adr_area_ie3 
--     ON gar_tmp.xxx_adr_area USING btree (obj_level);
-- -------------------------------------------------------------------------------


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 (text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 (
        p_schema_name  text  
)
    RETURNS SETOF gar_tmp.xxx_obj_fias
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    TMP_TABLE_NAME CONSTANT text = '__adr_area_fias';
    
    _select text = $_$
    
      WITH x (
                 id_obj_fias   
                ,obj_guid_fias 
                ,type_object 
		        ,tree_d
		        ,level_d
      ) AS (
             SELECT
                 aa.id_addr_obj   
                ,aa.fias_guid     
                ,1 AS type_object
		        ,aa.tree_d
		        ,aa.level_d
                
             FROM gar_tmp.xxx_adr_area aa 
                    WHERE (aa.obj_level = 8)  
		        ORDER BY tree_d
      )
                INSERT INTO %I
                       SELECT 
                              nt.id_street    AS id_obj        
                             ,x.id_obj_fias   AS id_obj_fias   
                             ,x.obj_guid_fias AS obj_guid      
                             ,x.type_object   AS type_object   
                             --
                             ,x.tree_d
                             ,x.level_d
                       FROM x
                         LEFT JOIN LATERAL 
                              ( SELECT z.id_street, z.nm_fias_guid FROM ONLY %I.adr_street z
                                   WHERE (z.id_data_etalon IS NULL) AND (z.dt_data_del IS NULL) 
                                            AND
                                         (z.nm_fias_guid = x.obj_guid_fias)
                                ORDER BY z.id_street
             
                              ) nt ON TRUE;                                
            $_$;
            
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-06 Nick    УЛИЦЫ
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_obj_fias"
    -- --------------------------------------------------------------------------
    --     p_schema_name text -- Имя схемы-источника._
    -- --------------------------------------------------------------------------
    CREATE TEMP TABLE IF NOT EXISTS __adr_area_fias (LIKE gar_tmp.xxx_obj_fias)
        ON COMMIT DROP;
    TRUNCATE TABLE __adr_area_fias;
    --
    _exec := format (_select, TMP_TABLE_NAME, p_schema_name); -- p_date, 
    EXECUTE (_exec);
    --
    RETURN QUERY SELECT * FROM __adr_area_fias;
   
   END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 (text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 (text) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_obj_fias"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE 
--     SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 ('unsi') -- 5611
--     INSERT INTO gar_tmp.xxx_obj_fias 
--           SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 ('unnsi'); 
--   SELECT * FROM gar_tmp.xxx_obj_fias; -- 6031
--   TRUNCATE TABLE gar_tmp.xxx_obj_fias;
-- ------------------------------------------------------------
-- SELECT gar_link.f_server_is ();

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 (text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 (
        p_schema_name  text  
)
    RETURNS SETOF gar_tmp.xxx_obj_fias
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    TMP_TABLE_NAME CONSTANT text = '__adr_area_fias';
    
    _select text = $_$
    
      WITH x (
                 id_obj_fias   
                ,obj_guid_fias 
                ,type_object 
                 --
                ,id_area
                ,tree_d
                ,level_d
      ) AS (
             SELECT
                 ah.id_house 
                ,ah.fias_guid     
                ,2 AS type_object
                --
                ,aa.id_addr_obj
		        ,aa.tree_d
		        ,aa.level_d
                
             FROM gar_tmp.xxx_adr_house ah 
                INNER JOIN gar_tmp.xxx_adr_area aa 
                           ON (aa.id_addr_obj = ah.id_addr_parent) -- INNER  2022-03-02
		        ORDER BY aa.tree_d    
      )
            INSERT INTO %I
               SELECT 
                      nh.id_house     AS id_obj        
                     ,x.id_obj_fias   AS id_obj_fias   
                     ,x.obj_guid_fias AS obj_guid      
                     ,x.type_object   AS type_object   
                     --
                     ,x.tree_d
		             ,x.level_d
               FROM x
                      LEFT JOIN LATERAL 
                           ( SELECT z.id_house, z.nm_fias_guid FROM ONLY %I.adr_house z
                                WHERE (z.id_data_etalon IS NULL) AND (z.dt_data_del IS NULL) 
                                         AND
                                      (z.nm_fias_guid = x.obj_guid_fias)
                             ORDER BY z.id_house
                   
                           ) nh ON TRUE;                    
            $_$;
            
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-09 Nick  ДОМА
    --    Функция подготавливает исходные данные для таблицы-прототипа 
    --                    "gar_tmp.xxx_obj_fias"
    -- --------------------------------------------------------------------------
    --     p_schema_name text -- Имя схемы-источника._
    -- --------------------------------------------------------------------------
    CREATE TEMP TABLE IF NOT EXISTS __adr_area_fias (LIKE gar_tmp.xxx_obj_fias)
        ON COMMIT DROP;
    TRUNCATE TABLE __adr_area_fias;
    --
    _exec := format (_select, TMP_TABLE_NAME, p_schema_name); -- p_date, 
    EXECUTE (_exec);
    --
    RETURN QUERY SELECT * FROM __adr_area_fias;
   
   END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 (text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 (text) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_obj_fias"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE 
-- --     SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 ('unsi') -- 96167
--  SELECT * FROM gar_tmp.xxx_obj_fias WHERE (TYPE_OBJECT = 2)  ORDER BY 1; -- LIMIT 10;
--  ALTER TABLE gar_tmp.xxx_obj_fias ALTER COLUMN tree_d DROP NOT NULL;
--  ALTER TABLE gar_tmp.xxx_obj_fias ALTER COLUMN level_d DROP NOT NULL;
 
--  INSERT INTO gar_tmp.xxx_obj_fias 
--        SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 ('gar_tmp') -- 'unnsi' 2022-01-28
--  ON CONFLICT (obj_guid) DO NOTHING;  + 104
-- -------------------------------------------------------------------------------
-- count	type_object
--   420	0
-- 96167	2
--  5611	1



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_fias_set_data (text, text, text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_set_data (
       p_adr_area_sch     text -- Отдалённая/Локальная схема для хранения адресных областей
      ,p_adr_street_sch   text -- Отдалённая/Локальная схема для хранения улиц
      ,p_adr_house_sch    text -- Отдалённая/Локальная схема для хранения домов/строений
       --
      ,OUT rr integer -- Количество вставленных записей
)
    RETURNS SETOF integer
    LANGUAGE plpgsql
    SECURITY DEFINER
 AS
  $$
    -- -------------------------------------------------------------------------------
    --   2022-03-18. Заполнение управляющей таблицы. Несколько топорно.
    -- -------------------------------------------------------------------------------
    BEGIN
      TRUNCATE TABLE gar_tmp.xxx_obj_fias;
      --
      --  0)  ADR_AREAs
      --
     -- SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 ('unnsi'); -- 8653 rows, 
      INSERT INTO gar_tmp.xxx_obj_fias AS x0 
           SELECT  
                   id_obj      
                  ,id_obj_fias 
                  ,obj_guid    
                  ,type_object 
                  ,tree_d      
                  ,level_d     
                  
           FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 (p_adr_area_sch) 
           
      ON CONFLICT (obj_guid) DO UPDATE 
                             SET 
                                 id_obj      = excluded.id_obj     
                                ,id_obj_fias = excluded.id_obj_fias
                                ,type_object = excluded.type_object
                                ,tree_d      = excluded.tree_d     
                                ,level_d     = excluded.level_d    
                                
                             WHERE (x0.obj_guid = excluded.obj_guid); -- unnsi
      
      GET DIAGNOSTICS rr = ROW_COUNT;
      RETURN NEXT;
      --
      --  1)  Adr_streets
      --
      -- SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 ('unnsi'); -- 21046
      INSERT INTO gar_tmp.xxx_obj_fias AS x1
            SELECT 
                   id_obj      
                  ,id_obj_fias 
                  ,obj_guid    
                  ,type_object 
                  ,tree_d      
                  ,level_d     
            
            FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 (p_adr_street_sch)
            
      ON CONFLICT (obj_guid) DO UPDATE 
                             SET 
                                 id_obj      = excluded.id_obj     
                                ,id_obj_fias = excluded.id_obj_fias
                                ,type_object = excluded.type_object
                                ,tree_d      = excluded.tree_d     
                                ,level_d     = excluded.level_d    
                                
                             WHERE (x1.obj_guid = excluded.obj_guid); -- unnsi
       
      GET DIAGNOSTICS rr = ROW_COUNT;
      RETURN NEXT;  
      --
      -- 2) Houses
      --
      -- SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 ('unnsi'); -- 96167   5 min
      INSERT INTO gar_tmp.xxx_obj_fias AS x2
            SELECT  
                   id_obj      
                  ,id_obj_fias 
                  ,obj_guid    
                  ,type_object 
                  ,tree_d      
                  ,level_d     
            
            FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 (p_adr_house_sch) -- 'unnsi' 2022-01-28
      ON CONFLICT (obj_guid) DO UPDATE 
                             SET 
                                 id_obj      = excluded.id_obj     
                                ,id_obj_fias = excluded.id_obj_fias
                                ,type_object = excluded.type_object
                                ,tree_d      = excluded.tree_d     
                                ,level_d     = excluded.level_d    
                                
                             WHERE (x2.obj_guid = excluded.obj_guid); -- unnsi
            
      GET DIAGNOSTICS rr = ROW_COUNT;
      RETURN NEXT;       
            
    END;
  $$;
  
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_set_data (text, text, text)
                       IS 'Загрузка данных в таблицу, управляющую последующей обработкой';  
-- ----------------------------------------------------------------------------------------
-- USE CASE:
--       SELECT gar_link.f_server_is ('unnsi');   -- unsi_l
--       SELECT gar_link.f_server_is ('unsi');    -- unsi_l
--       SELECT gar_tmp_pcg_trans.f_xxx_obj_fias_set_data ('unnsi', 'unnsi', 'gar_tmp');
-- ---------------------------------------------------------------------------------------
--            Далее важно - распределение данных в рабочих таблицах.  
-- ---------------------------------------------------------------------------------------           
--            SELECT COUNT(1), type_object FROM gar_tmp.xxx_obj_fias
--                  WHERE (id_obj IS NULL) GROUP BY type_object ORDER BY 2;
--
--            SELECT COUNT(1), type_object FROM gar_tmp.xxx_obj_fias
--                  GROUP BY type_object ORDER BY 2;
-- --            
--             count	type_object
--                418	       0
--               5611	       1
--              96167          2   
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 ('unnsi'); -- 418
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 ('unnsi'); -- 5615
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 ('gar_tmp'); --  96167
-- -----------------------------------------------------------------------

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_get (text, uuid);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_area_get (
               p_schema        text -- Имя схемы
              ,p_nm_fias_guid  uuid -- аргумент
	          ,OUT rr          gar_tmp.adr_area_t 
)
    RETURNS gar_tmp.adr_area_t
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
                  SELECT 
                           id_area           --  bigint                      -- NOT NULL
                          ,id_country        --  integer                     -- NOT NULL
                          ,nm_area           --  varchar(120)                -- NOT NULL
                          ,nm_area_full      --  varchar(4000)               -- NOT NULL
                          ,id_area_type      --  integer                     --   NULL
                          ,id_area_parent    --  bigint                      --   NULL
                          ,kd_timezone       --  integer                     --   NULL
                          ,pr_detailed       --  smallint                    -- NOT NULL 
                          ,kd_oktmo          --  varchar(11)                 --   NULL
                          ,nm_fias_guid      --  uuid                        --   NULL
                          ,dt_data_del       --  timestamp without time zone --   NULL
                          ,id_data_etalon    --  bigint                      --   NULL
                          ,kd_okato          --  varchar(11)                 --   NULL
                          ,nm_zipcode        --  varchar(20)                 --   NULL
                          ,kd_kladr          --  varchar(15)                 --   NULL
                          ,vl_addr_latitude  --  numeric                     --   NULL
                          ,vl_addr_longitude --  numeric                     --   NULL
    
                  FROM ONLY %I.adr_area
                  
                        WHERE (nm_fias_guid = %L) 
                           AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-10 Nick  Дополнение адресных георегионов. Поиск по UUID
    --  2022-02-21 Опция ONLY.
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_nm_fias_guid);  
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_area_get (text, uuid) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_area_get (text, uuid) 
IS 'Получить запись из таблицы адресных георегионов. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_area_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_area_get ('unsi', 'bb1060ca-8070-4dba-b86b-207e6521734b');
    

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_get (text, integer, bigint, integer, varchar(120));
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_area_get (
               p_schema         text         -- Имя схемы
              ,p_id_country     integer      -- NOT NULL
              ,p_id_area_parent bigint       --     NULL
              ,p_id_area_type   integer      --     NULL
              ,p_nm_area        varchar(120) -- NOT NULL
              --
	          ,OUT rr           gar_tmp.adr_area_t 
)

    RETURNS gar_tmp.adr_area_t
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
                  SELECT 
                           id_area           --  bigint                      -- NOT NULL
                          ,id_country        --  integer                     -- NOT NULL
                          ,nm_area           --  varchar(120)                -- NOT NULL
                          ,nm_area_full      --  varchar(4000)               -- NOT NULL
                          ,id_area_type      --  integer                     --   NULL
                          ,id_area_parent    --  bigint                      --   NULL
                          ,kd_timezone       --  integer                     --   NULL
                          ,pr_detailed       --  smallint                    -- NOT NULL 
                          ,kd_oktmo          --  varchar(11)                 --   NULL
                          ,nm_fias_guid      --  uuid                        --   NULL
                          ,dt_data_del       --  timestamp without time zone --   NULL
                          ,id_data_etalon    --  bigint                      --   NULL
                          ,kd_okato          --  varchar(11)                 --   NULL
                          ,nm_zipcode        --  varchar(20)                 --   NULL
                          ,kd_kladr          --  varchar(15)                 --   NULL
                          ,vl_addr_latitude  --  numeric                     --   NULL
                          ,vl_addr_longitude --  numeric                     --   NULL
    
                  FROM ONLY %I.adr_area
                  
                  WHERE (id_country = %L) AND (id_area_parent IS NOT DISTINCT FROM %L) AND 
                        (id_area_type IS NOT DISTINCT FROM %L) AND (upper(nm_area::text) = upper(%L)) AND
                        (id_data_etalon IS NULL) AND (dt_data_del IS NULL);  
              $_$;

           
   BEGIN
    -- -----------------------------------------------------------------------------------
    --  2021-12-10/2022-01-28/2022-02-21  Nick.  
    --              Дополнение адресных георегионов. Поиск по уникальным параметрам
    -- -----------------------------------------------------------------------------------
     _exec := format (_select, 
                          p_schema, p_id_country, p_id_area_parent, p_id_area_type, p_nm_area
     );  
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_area_get (text, integer, bigint, integer, varchar(120)) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_area_get (text, integer, bigint, integer, varchar(120)) 
IS 'Получить запись из таблицы адресных георегионов. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_area_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_area_get ('unnsi', 185, 77, 40, 'Угличский');
    
--           SELECT nm_fias_guid FROM unnsi.adr_area 
--                               WHERE ((id_country = 185) AND (id_area_parent IS NOT DISTINCT FROM 77) AND 
--                                      (id_area_type IS NOT DISTINCT FROM 40) AND (upper(nm_area::text) = upper('Угличский')) AND
--                                      (id_data_etalon IS NULL) AND (dt_data_del IS NULL)  
--                                     );

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_get (text, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_area_get (
               p_schema   text   -- Имя схемы
              ,p_id_area  bigint -- аргумент
	          ,OUT rr     gar_tmp.adr_area_t 
)
    RETURNS gar_tmp.adr_area_t
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
                  SELECT 
                           id_area           --  bigint                      -- NOT NULL
                          ,id_country        --  integer                     -- NOT NULL
                          ,nm_area           --  varchar(120)                -- NOT NULL
                          ,nm_area_full      --  varchar(4000)               -- NOT NULL
                          ,id_area_type      --  integer                     --   NULL
                          ,id_area_parent    --  bigint                      --   NULL
                          ,kd_timezone       --  integer                     --   NULL
                          ,pr_detailed       --  smallint                    -- NOT NULL 
                          ,kd_oktmo          --  varchar(11)                 --   NULL
                          ,nm_fias_guid      --  uuid                        --   NULL
                          ,dt_data_del       --  timestamp without time zone --   NULL
                          ,id_data_etalon    --  bigint                      --   NULL
                          ,kd_okato          --  varchar(11)                 --   NULL
                          ,nm_zipcode        --  varchar(20)                 --   NULL
                          ,kd_kladr          --  varchar(15)                 --   NULL
                          ,vl_addr_latitude  --  numeric                     --   NULL
                          ,vl_addr_longitude --  numeric                     --   NULL
    
                  FROM ONLY %I.adr_area WHERE (id_area = %L);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-10 Nick  Дополнение адресных георегионов. Поиск по ID
    --  2022-02-21 Опция ONLY.
    --  2022-06-15 Выбираю запись любого типа, т.е актуальную, удалённую.
    -- --------------------------------------------------------------------------
    
     _exec := format (_select, p_schema, p_id_area);  
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_area_get (text, bigint) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_area_get (text, bigint) 
  IS 'Получить запись из таблицы адресных георегионов. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_area_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT * FROM gar_tmp_pcg_trans.f_adr_area_get ('unnsi', 271088);
--       SELECT * FROM gar_tmp_pcg_trans.f_adr_area_get ('unnsi', 199007);
    

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_street_get (text, uuid);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_street_get (
               p_schema        text -- Имя схемы
              ,p_nm_fias_guid  uuid -- аргумент
	          ,OUT rr          gar_tmp.adr_street_t
)
    RETURNS gar_tmp.adr_street_t
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
                  SELECT   id_street
                          ,id_area
                          ,nm_street
                          ,id_street_type
                          ,nm_street_full
                          ,nm_fias_guid
                          ,dt_data_del
                          ,id_data_etalon
                          ,kd_kladr
                          ,vl_addr_latitude
                          ,vl_addr_longitude   
                          
                  FROM ONLY %I.adr_street
                        WHERE (nm_fias_guid = %L) 
                             AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --     2021-12-15/2022-02-21  Nick.
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_nm_fias_guid);  
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_street_get (text, uuid) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_street_get (text, uuid) 
IS 'Получить запись из таблицы адресов улиц. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_street_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_street_get ('unsi', '431a03d5-d746-4dd7-9f4e-d5cd97f9930f');
--       SELECT gar_tmp_pcg_trans.f_adr_street_get ('unsi', 'db723758-0e6a-4a0b-aac2-79f77a4bc11e');
    

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_street_get (text, bigint, varchar(255), integer);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_street_get (
               p_schema          text -- Имя схемы
              ,p_id_area         bigint
              ,p_nm_street       varchar(255) 
              ,p_id_street_type  integer
	          ,OUT rr            gar_tmp.adr_street_t 
)
    RETURNS gar_tmp.adr_street_t
    LANGUAGE plpgsql
    
    
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
                  SELECT   id_street
                          ,id_area
                          ,nm_street
                          ,id_street_type
                          ,nm_street_full
                          ,nm_fias_guid
                          ,dt_data_del
                          ,id_data_etalon
                          ,kd_kladr
                          ,vl_addr_latitude
                          ,vl_addr_longitude   
                          
                  FROM ONLY %I.adr_street
                        WHERE (id_area = %L) AND 
                              (upper(nm_street::text) = upper(%L)) AND 
                              (id_street_type IS NOT DISTINCT FROM %L) AND 
                              (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --     2021-12-15/2022-01-28/2022-02-21   Nick.
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_id_area, p_nm_street, p_id_street_type); 
     
     EXECUTE _exec INTO rr;

     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_street_get (text, bigint, varchar(255), integer) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_street_get (text, bigint, varchar(255), integer) 
IS 'Получить запись из таблицы адресов улиц. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_street_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_street_get ('unnsi', 78, 'Речная', 38);
--       SELECT gar_tmp_pcg_trans.f_adr_street_get ('unnsi', 2311, 'Молодежный ГСК', 34);
    
--         SELECT nm_fias_guid FROM unnsi.adr_street 
--                               WHERE ((id_area = 78) AND 
--                                      (upper(nm_street::text) = upper('Речная')) AND 
--                                      (id_street_type IS NOT DISTINCT FROM 38) AND 
--                                      (id_data_etalon IS NULL) AND (dt_data_del IS NULL)
--                                     ); -- dbe358c4-4212-4103-9cea-d7c730d6da9a

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_street_get (text, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_street_get (
               p_schema      text   -- Имя схемы
              ,p_id_street   bigint -- аргумент
	          ,OUT rr        gar_tmp.adr_street_t
)
    RETURNS gar_tmp.adr_street_t
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
                  SELECT   id_street
                          ,id_area
                          ,nm_street
                          ,id_street_type
                          ,nm_street_full
                          ,nm_fias_guid
                          ,dt_data_del
                          ,id_data_etalon
                          ,kd_kladr
                          ,vl_addr_latitude
                          ,vl_addr_longitude   
                          
                  FROM ONLY %I.adr_street WHERE (id_street = %L); 
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --   2021-12-15/2022-02-21  Nick.
    --   2022-06-15 Выбираю запись любого типа, т.е актуальную, удалённую.
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_id_street);  
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_street_get (text, bigint) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_street_get (text, bigint) 
IS 'Получить запись из таблицы адресов улиц. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_street_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_street_get ('unsi', '431a03d5-d746-4dd7-9f4e-d5cd97f9930f');
--       SELECT gar_tmp_pcg_trans.f_adr_street_get ('unsi', 'db723758-0e6a-4a0b-aac2-79f77a4bc11e');
    

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_get (text, uuid);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_house_get (
               p_schema        text -- Имя схемы
              ,p_nm_fias_guid  uuid -- аргумент
	          ,OUT rr          gar_tmp.adr_house_t 
)
    RETURNS gar_tmp.adr_house_t
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
                  SELECT   
                  
                       id_house          
                      ,id_area           
                      ,id_street         
                      ,id_house_type_1   
                      ,nm_house_1        
                      ,id_house_type_2   
                      ,nm_house_2        
                      ,id_house_type_3   
                      ,nm_house_3        
                      ,nm_zipcode        
                      ,nm_house_full     
                      ,kd_oktmo          
                      ,nm_fias_guid      
                      ,dt_data_del       
                      ,id_data_etalon    
                      ,kd_okato          
                      ,vl_addr_latitude  
                      ,vl_addr_longitude 
                          
                  FROM ONLY %I.adr_house
                        WHERE (nm_fias_guid = %L)
                             AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --     2021-12-15 Nick.
    --     2022-02-07  Переход на базовые типы.
    --     2022-02-21  ONLY 
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_nm_fias_guid);  
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_house_get (text, uuid) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_house_get (text, uuid) 
IS 'Получить запись из таблицы адресов улиц. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_house_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_house_get ('unnsi', '982d22bc-b267-4717-a62d-427c83ce38a6');
--       SELECT gar_tmp_pcg_trans.f_adr_house_get ('unsi', 'db723758-0e6a-4a0b-aac2-79f77a4bc11e');
    

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_get (text, bigint, varchar(250), bigint);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_get (text, bigint, varchar(250), bigint, integer);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_house_get (
              p_schema         text -- Имя схемы
              --
             ,p_id_area         bigint       --  NOT NULL
             ,p_nm_house_full   varchar(250) --  NOT NULL
             ,p_id_street       bigint       --   NULL
             ,p_id_house_type_1 integer      --   NULL
              --
             ,OUT rr gar_tmp.adr_house_t 
)
    RETURNS gar_tmp.adr_house_t
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
         SELECT   
         
              id_house          
             ,id_area           
             ,id_street         
             ,id_house_type_1   
             ,nm_house_1        
             ,id_house_type_2   
             ,nm_house_2        
             ,id_house_type_3   
             ,nm_house_3        
             ,nm_zipcode        
             ,nm_house_full     
             ,kd_oktmo          
             ,nm_fias_guid      
             ,dt_data_del       
             ,id_data_etalon    
             ,kd_okato          
             ,vl_addr_latitude  
             ,vl_addr_longitude 
                 
         FROM ONLY %I.adr_house WHERE
              (id_area = %L::bigint) AND (upper(nm_house_full::text) = upper (%L)::text) AND
              (id_street IS NOT DISTINCT FROM %L::bigint) AND
              (id_house_type_1 IS NOT DISTINCT FROM %L::integer) AND
			  (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
      $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --     2022-01-27 Nick.
    --     2022-02-07 Переход на базовые типы.
    --     2022-02-11 В уникальность добавлен "id_house_type_1"
    --     2022-02-21  Опция ONLY
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_id_area, p_nm_house_full, p_id_street, p_id_house_type_1);  
     
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_house_get  (text, bigint, varchar(250), bigint, integer) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_house_get (text, bigint, varchar(250), bigint, integer)
IS 'Получить запись из таблицы адресов улиц. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_house_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_house_get ('gar_tmp', 1087, 'д. 74',  68730);
--       SELECT gar_tmp_pcg_trans.f_adr_house_get ('unnsi', 73908, 'д. 2', NULL, 2);
--       SELECT gar_tmp_pcg_trans.f_adr_house_get ('gar_tmp', 73908, 'д. 2', NULL);    
-- -----------------------------------------------------------------------------------
--  SELECT nm_fias_guid FROM unnsi.adr_house 
--                       WHERE ((id_area = 73908) AND (upper(nm_house_full::text) = upper('д. 2')) AND
--                              (id_street IS NOT DISTINCT FROM NULL) AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL)
--                       ); -- 001d7c82-92e0-4392-82f1-f9646e6c9f9f
-- SELECT * FROM unnsi.adr_house WHERE (nm_fias_guid = '001d7c82-92e0-4392-82f1-f9646e6c9f9f');
-- --
--  SELECT nm_fias_guid FROM unnsi.adr_house 
--                WHERE ((id_area = 91764) AND (upper(nm_house_full::text) = upper('дв. 10')) AND
--                       (id_street IS NOT DISTINCT FROM 588345) AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL)
--                       ); -- dfd85aa3-942b-4911-a8b9-a800514712d3
--
-- SELECT * FROM gar_tmp_pcg_trans.f_adr_house_get ('unnsi', 73908, 'д. 2', NULL, 2);
-- SELECT (gar_tmp_pcg_trans.f_adr_house_get ('unnsi', 73908, 'д. 2', NULL, 2)).id_house;
-- SELECT (gar_tmp_pcg_trans.f_adr_house_get ('unnsi', 73908, 'д. 2', NULL, 2)).nm_fias_guid;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_get (text, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_house_get (
               p_schema    text -- Имя схемы
              ,p_id_house  bigint -- аргумент
	          ,OUT rr      gar_tmp.adr_house_t 
)
    RETURNS gar_tmp.adr_house_t
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
                  SELECT   
                  
                       id_house          
                      ,id_area           
                      ,id_street         
                      ,id_house_type_1   
                      ,nm_house_1        
                      ,id_house_type_2   
                      ,nm_house_2        
                      ,id_house_type_3   
                      ,nm_house_3        
                      ,nm_zipcode        
                      ,nm_house_full     
                      ,kd_oktmo          
                      ,nm_fias_guid      
                      ,dt_data_del       
                      ,id_data_etalon    
                      ,kd_okato          
                      ,vl_addr_latitude  
                      ,vl_addr_longitude 
                          
                  FROM ONLY %I.adr_house
                        WHERE (id_house = %L);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --     2021-12-15 Nick.
    --     2022-02-07  Переход на базовые типы.
    --     2022-02-21  ONLY 
    --     2022-06-15 Выбираю запись любого типа, т.е актуальную, удалённую.    
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_id_house);  
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_house_get (text, bigint) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_house_get (text, bigint) 
IS 'Получить запись из таблицы адресов улиц. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_house_get(text,bigint) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT * FROM gar_tmp_pcg_trans.f_adr_house_get ('unnsi', 600033432);
--       SELECT * FROM gar_tmp_pcg_trans.f_adr_house_get ('unnsi', 600029845);

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_object_get (text, uuid);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_object_get (
               p_schema        text -- Имя схемы
              ,p_nm_fias_guid  uuid -- аргумент
	          ,OUT rr          gar_tmp.adr_objects_t
)
    RETURNS gar_tmp.adr_objects_t -- record
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
                  SELECT 
                        id_object         --  bigint                      
                       ,id_area           --  bigint                      
                       ,id_house          --  bigint                      
                       ,id_object_type    --  integer                     
                       ,id_street         --  bigint                      
                       ,nm_object         --  varchar(250)                
                       ,nm_object_full    --  varchar(500)                
                       ,nm_description    --  varchar(150)                
                       ,dt_data_del       --  timestamp without time zone 
                       ,id_data_etalon    --  bigint                      
                       ,id_metro_station  --  integer                     
                       ,id_autoroad       --  integer                     
                       ,nn_autoroad_km    --  numeric                     
                       ,nm_fias_guid      --  uuid                        
                       ,nm_zipcode        --  varchar(20)                 
                       ,kd_oktmo          --  varchar(11)                 
                       ,kd_okato          --  varchar(11)                 
                       ,vl_addr_latitude  --  numeric                     
                       ,vl_addr_longitude --  numeric                     
    
                  FROM ONLY %I.adr_objects
                  
                        WHERE (nm_fias_guid = %L) 
                              AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-17 Nick  Дополнение адресных объектов. Поиск по UUID
    --  2022-02-21 Опция ONLY
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_nm_fias_guid);  
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_objects_get (text, uuid) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_object_get (text, uuid) 
IS 'Получить запись из таблицы адресных объектов. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_objects_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_object_get  ('unsi'::text, 'bb1060ca-8070-4dba-b86b-207e6521734b'::uuid);
    

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_object_get (text, bigint, integer, varchar(500), bigint, bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_object_get (
                p_schema         text           -- Имя схемы
               ,p_id_area        bigint                      
               ,p_id_object_type integer                     
               ,p_nm_object_full varchar(500)                
               ,p_id_street      bigint                      
               ,p_id_house       bigint
               --
	          ,OUT rr   gar_tmp.adr_objects_t
)

    RETURNS gar_tmp.adr_objects_t -- record
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    
    _select text = $_$
                  SELECT 
                        id_object         --  bigint                      
                       ,id_area           --  bigint                      
                       ,id_house          --  bigint                      
                       ,id_object_type    --  integer                     
                       ,id_street         --  bigint                      
                       ,nm_object         --  varchar(250)                
                       ,nm_object_full    --  varchar(500)                
                       ,nm_description    --  varchar(150)                
                       ,dt_data_del       --  timestamp without time zone 
                       ,id_data_etalon    --  bigint                      
                       ,id_metro_station  --  integer                     
                       ,id_autoroad       --  integer                     
                       ,nn_autoroad_km    --  numeric                     
                       ,nm_fias_guid      --  uuid                        
                       ,nm_zipcode        --  varchar(20)                 
                       ,kd_oktmo          --  varchar(11)                 
                       ,kd_okato          --  varchar(11)                 
                       ,vl_addr_latitude  --  numeric                     
                       ,vl_addr_longitude --  numeric                     
    
                  FROM ONLY %I.adr_objects
                  
                    WHERE (id_area = %L::bigint) AND (id_object_type = %L::integer) AND
                          (upper(nm_object_full::text) = upper (%L)::text) AND 
                          (id_street IS NOT DISTINCT FROM %L::bigint) AND 
                          (id_house  IS NOT DISTINCT FROM %L::bigint) AND 
                          (id_data_etalon IS NULL) AND (dt_data_del IS NULL);  
              $_$;

           
   BEGIN
    -- ---------------------------------------------------------------------------------------
    --  2021-12-17/2022-01-28 Nick  Дополнение адресных объектов. Поиск по ключевым параметрам
    --  2022-02-21 Опция ONLY
    -- ---------------------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_id_area, p_id_object_type, p_nm_object_full, p_id_street, p_id_house);  
     
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_objects_get (text, bigint, integer, varchar(500), bigint, bigint) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_object_get (text, bigint, integer, varchar(500), bigint, bigint) 
IS 'Получить запись из таблицы адресных объектов. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_objects_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       
-- SELECT gar_tmp_pcg_trans.f_adr_object_get ('unnsi'::text, 124012::bigint, 17::integer, 'д. 3'::VARCHAR(500), 
-- 											 705895::bigint, 14959328::bigint);
-- --
-- SELECT gar_tmp_pcg_trans.f_adr_object_get ('gar_tmp'::text, 124012::bigint, 17::integer, 'д. 3'::VARCHAR(500), 
-- 											 705895::bigint, 14959328::bigint);
-- --
-- SELECT gar_tmp_pcg_trans.f_adr_object_get ('gar_tmp'::text, 73961::bigint, 17::integer, 'д. 32'::VARCHAR(500), 
-- 											 NULL::bigint, 14725686::bigint);
    

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_alt_tbl (boolean);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_alt_tbl (
        p_all  boolean = TRUE
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-13/2021-11-29/2022-03-03
    -- ----------------------------------------------------------------------------------------------------  
    -- Модификация таблиц в схеме gar_tmp. false - UNLOGGED таблицы.
    --                                      true  - LOGGED таблицы.
    -- ====================================================================================================
   
    BEGIN
       IF p_all THEN 
                ALTER TABLE  gar_tmp.adr_area    SET LOGGED;
                ALTER TABLE  gar_tmp.adr_street  SET LOGGED;
                ALTER TABLE  gar_tmp.adr_house   SET LOGGED;
                ALTER TABLE  gar_tmp.adr_objects SET LOGGED;
         ELSE
                ALTER TABLE  gar_tmp.adr_area     SET UNLOGGED;
                ALTER TABLE  gar_tmp.adr_street   SET UNLOGGED;
                ALTER TABLE  gar_tmp.adr_house    SET UNLOGGED;
                ALTER TABLE  gar_tmp.adr_objects  SET UNLOGGED;
       END IF;       
        
       RETURN;
    END;
  $$;

ALTER PROCEDURE gar_tmp_pcg_trans.p_alt_tbl (boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_alt_tbl (boolean) IS 'Модификация таблиц в схеме gar_fias.';
--
--  USE CASE:
--             CALL gar_tmp_pcg_trans.p_alt_tbl (FALSE); --  
--             CALL gar_tmp_pcg_trans.p_alt_tbl ();

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_clear_tbl (boolean);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_clear_tbl (
        p_all  boolean = FALSE
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-13/2021-11-25/2022-03-15
    -- ----------------------------------------------------------------------------------------------------  
    -- Очистка временных (буфферных таблиц). false - очищаются только таблицы-результаты
    --        true - все таблицы.
    -- 2022-03-15 -- История сохраняется всегда.
    -- ====================================================================================================
   
    BEGIN
    
      IF p_all THEN
      
	    TRUNCATE TABLE gar_tmp.xxx_adr_area_type;   -- Временная таблица для "С_Типы гео-региона (!)"
        TRUNCATE TABLE gar_tmp.xxx_adr_street_type; -- Временная таблица для "C_Типы улицы (!)"
        TRUNCATE TABLE gar_tmp.xxx_adr_house_type;  -- Временная таблица для "С_Типы номера (!)"
    
      END IF;
      -- 
	  TRUNCATE TABLE gar_tmp.xxx_adr_area;         -- Временная таблица. заполняется данными из "AS_ADDR_OBJ", "AS_REESTR_OBJECTS", "AS_ADM_HIERARCHY", "AS_MUN_HIERARCHY", "AS_OBJECT_LEVEL", "AS_STEADS_PARAMS"
	  TRUNCATE TABLE gar_tmp.xxx_adr_house;	       -- Адреса домов 
	  TRUNCATE TABLE gar_tmp.xxx_obj_fias;         -- Дополнительная связь адресных объектов с ГАР-ФИАС
      TRUNCATE TABLE gar_tmp.xxx_type_param_value; -- Для каждого объекта хранятся агрегированные пары "Тип" - "Значение"
      --
      DELETE FROM ONLY gar_tmp.adr_area;     -- 2022-03-10 Сохраняются данные в таблицах-наследниках.
      DELETE FROM ONLY gar_tmp.adr_house; 
	  DELETE FROM ONLY gar_tmp.adr_objects;
	  DELETE FROM ONLY gar_tmp.adr_street;    
	  
    END;
  $$;

ALTER PROCEDURE gar_tmp_pcg_trans.p_clear_tbl (boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_clear_tbl (boolean) IS 'Очистка временных (буфферных) таблиц';
--
--  USE CASE:
--             CALL gar_tmp_pcg_trans.p_clear_tbl (FALSE); --  
--             CALL gar_tmp_pcg_trans.p_clear_tbl ();

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_gar_fias_crt_idx (p_sw boolean);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_gar_fias_crt_idx (p_sw boolean = TRUE)

    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias, public

 AS 
   $$
    -- -----------------------------------------------------------------------
    --    2021-11-25/2021-12-09/2022-04-12/2022-07-12/2022-09-05
    --     Nick. Управление индексами в схеме "gar_fias"
    -- -----------------------------------------------------------------------
    --     p_sw boolean = TRUE  - удаление и создание индексов
    --                    FALSE - только удаление
    -- -----------------------------------------------------------------------
     BEGIN
       DROP INDEX IF EXISTS ie1_as_object_level;
       DROP INDEX IF EXISTS ie1_as_addr_obj;
       DROP INDEX IF EXISTS ie1_as_adm_hierarchy; 
       DROP INDEX IF EXISTS ie1_as_mun_hierarchy;
       DROP INDEX IF EXISTS ie1_as_houses;
       --
       IF (p_sw) THEN
       
           CREATE INDEX ie1_as_object_level 
             ON gar_fias.as_object_level (end_date, start_date)  -- level_id, 2022-04-12 
                                                          WHERE (is_active);
           --  
           CREATE INDEX ie1_as_addr_obj 
             ON gar_fias.as_addr_obj (obj_level, end_date, start_date) 
                                                          WHERE (is_actual AND is_active);
           --                                               
           CREATE INDEX ie1_as_adm_hierarchy 
                ON gar_fias.as_adm_hierarchy (parent_obj_id, end_date, start_date) 
                                                          WHERE (is_active); 
           --
           CREATE INDEX ie1_as_mun_hierarchy 
                ON gar_fias.as_mun_hierarchy (parent_obj_id, end_date, start_date) 
                                                          WHERE (is_active);
           --  2021-12-09                                               
                  
           CREATE INDEX ie1_as_houses   
                ON gar_fias.as_houses (end_date, start_date) WHERE (is_actual AND is_active);                                    
       END IF;
       --
       DROP INDEX IF EXISTS ie1_as_addr_obj_params;   
       DROP INDEX IF EXISTS ie1_as_apartments_params; 
       DROP INDEX IF EXISTS ie1_as_carplaces_params;  
       DROP INDEX IF EXISTS ie1_as_houses_params;     
       DROP INDEX IF EXISTS ie1_as_rooms_params;      
       DROP INDEX IF EXISTS ie1_as_steads_params;     
       --
       IF (p_sw) THEN
       
            CREATE INDEX ie1_as_addr_obj_params   
                        ON gar_fias.as_addr_obj_params (type_id, start_date, end_date);
            --                 
            CREATE INDEX ie1_as_apartments_params 
                        ON gar_fias.as_apartments_params (type_id, start_date, end_date);
            --                 
            CREATE INDEX ie1_as_carplaces_params  
                        ON gar_fias.as_carplaces_params (type_id, start_date, end_date);
            --                 
            CREATE INDEX ie1_as_houses_params     
                        ON gar_fias.as_houses_params (type_id, start_date, end_date);
            --                 
            CREATE INDEX ie1_as_rooms_params      
                        ON gar_fias.as_rooms_params (type_id, start_date, end_date);
            --                 
            CREATE INDEX ie1_as_steads_params     
                        ON gar_fias.as_steads_params (type_id, start_date, end_date);
       END IF;	
       --
       --  2022-04-12
       --
       DROP INDEX IF EXISTS gar_fias.iex_as_houses; 
       DROP INDEX IF EXISTS gar_fias.iex_as_steads; 
       DROP INDEX IF EXISTS gar_fias.ie1_as_steads;
       DROP INDEX IF EXISTS gar_fias.ie1_as_reestr_objects; -- !!!! Фигня
       DROP INDEX IF EXISTS gar_fias.ie1_as_operation_type;
       DROP INDEX IF EXISTS gar_fias.ie1_as_addr_obj_type;       
      
       IF (p_sw) THEN
       
         CREATE INDEX iex_as_houses
          ON gar_fias.as_houses USING hash (object_guid)
          WHERE is_actual AND is_active;   
         --       
         CREATE INDEX iex_as_steads
              ON gar_fias.as_steads USING hash (object_guid)
          WHERE is_actual AND is_active;       
         --
         CREATE INDEX ie1_as_steads
             ON gar_fias.as_steads USING btree
                 (end_date ASC NULLS LAST, start_date ASC NULLS LAST)
             WHERE is_actual AND is_active;         
         --
         CREATE INDEX ie1_as_operation_type
             ON gar_fias.as_operation_type USING btree
                 (end_date ASC NULLS LAST, start_date ASC NULLS LAST)
          WHERE is_active;    
         --
         CREATE INDEX ie1_as_addr_obj_type
          ON gar_fias.as_addr_obj_type USING btree
            (end_date ASC NULLS LAST, start_date ASC NULLS LAST)
          WHERE is_active;          
         --       
         CREATE INDEX ie1_as_reestr_objects
             ON gar_fias.as_reestr_objects USING btree
                 (object_id ASC NULLS LAST) WHERE is_active;
       END IF;
       --
       -- 2022-07-12
       --
       DROP INDEX IF EXISTS ie2_as_addr_obj;
       --
       IF (p_sw) THEN
       
         CREATE INDEX IF NOT EXISTS ie2_as_addr_obj 
             ON gar_fias.as_addr_obj  USING btree (upper(object_name))  
                   WHERE (is_actual AND is_active); 
                   
       END IF;
       --
       -- 2022-09-05
       --
       DROP INDEX IF EXISTS ie1_gap_adr_area;
       DROP INDEX IF EXISTS ie2_gap_adr_area;
       DROP INDEX IF EXISTS ie3_as_addr_obj ;
       DROP INDEX IF EXISTS ie4_as_addr_obj ;
       DROP INDEX IF EXISTS ie2_as_adm_hierarchy; 
       
       IF (p_sw) THEN
       
           CREATE INDEX IF NOT EXISTS ie1_gap_adr_area ON gar_fias.gap_adr_area 
                   USING btree (id_addr_parent, upper(nm_addr_obj), addr_obj_type_id, change_id);
           --
           CREATE INDEX IF NOT EXISTS ie2_gap_adr_area ON gar_fias.gap_adr_area 
                   USING btree (obj_level);
           --
           CREATE INDEX IF NOT EXISTS ie3_as_addr_obj ON gar_fias.as_addr_obj  
                   USING btree (object_guid, end_date, start_date) WHERE (is_actual AND is_active); 
           -- 
           CREATE INDEX IF NOT EXISTS ie4_as_addr_obj ON gar_fias.as_addr_obj 
                   USING btree (end_date, start_date) WHERE (is_actual AND is_active);
           -- 
           CREATE INDEX IF NOT EXISTS ie2_as_adm_hierarchy ON gar_fias.as_adm_hierarchy 
                   USING btree (end_date, start_date) WHERE (is_active);
                       
       END IF;
       
     END;
 $$;
  
ALTER PROCEDURE gar_tmp_pcg_trans.p_gar_fias_crt_idx (boolean) OWNER TO postgres;  

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_gar_fias_crt_idx (boolean) 
IS 'Управление индексами в схеме "gar_fias"';

--  CALL gar_tmp_pcg_trans.p_gar_fias_crt_idx (FALSE); 
--  CALL gar_tmp_pcg_trans.p_gar_fias_crt_idx (); -- Query returned successfully in 3 min 48 secs.

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_del_twin (
                  text, bigint, bigint, varchar(120), integer, uuid, boolean, date, text 
 );   
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_street_del_twin (
        p_schema_name      text  
        --
       ,p_id_street        bigint
       ,p_id_area          bigint      
       ,p_nm_street        varchar(120)
       ,p_id_street_type   integer
       ,p_nm_fias_guid     uuid 
        --            
       ,p_mode             boolean = TRUE  -- используется в процессе обработки
                                 --  FALSE -- в постобработке.
       ,p_bound_date       date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name text = 'gar_tmp'                     
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ---------------------------------------------------------------------------
    --  2022-04-22  оиск близнецов. Два режима: 
    --    Поиск в процессе обработки, загрузочное индексное покрытие. 
    --    Поиск в после обработки, эксплуатационное индексное покрытие:
    --    В процессе постобработки, 
    --            используется индекс ""adr_street_ak1",  без уникальности 
    --
    --         CREATE INDEX adr_street_ak1
    --             ON unnsi.adr_street USING btree
    --               (id_area                ASC NULLS LAST
    --               ,upper(nm_street::text) ASC NULLS LAST
    --               ,id_street_type         ASC NULLS LAST
    --             )
    --             WHERE id_data_etalon IS NULL
    --
    --    Историческая запись должна содержать ссылку на 
    --                     воздействующий субъект (id_data_etalon := id_street)
    -- ---------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _upd_id text = $_$
            UPDATE ONLY %I.adr_street SET  
                  id_area           = COALESCE (%L, id_area       )::bigint                                 
                , nm_street         = COALESCE (%L, nm_street     )::varchar(120)                       
                , id_street_type    = COALESCE (%L, id_street_type)::integer                                
                , nm_street_full    = COALESCE (%L, nm_street_full)::varchar(255)                           
                , nm_fias_guid      = COALESCE (%L, nm_fias_guid  )::uuid
                , dt_data_del       = COALESCE (dt_data_del, %L)::timestamp without time zone              --  NULL
                , id_data_etalon    = %L::bigint                                   --  NULL
                , kd_kladr          = COALESCE (%L, kd_kladr      )::varchar(15)
                , vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric                
                , vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric                
            WHERE (id_street = %L::bigint);        
       $_$;   
      --
      _upd_id_1 text = $_$
            UPDATE ONLY %I.adr_street SET  
                  id_area           = COALESCE (%L, id_area       )::bigint                                 
                , nm_street         = COALESCE (%L, nm_street     )::varchar(120)                       
                , id_street_type    = COALESCE (%L, id_street_type)::integer                                
                , nm_street_full    = COALESCE (%L, nm_street_full)::varchar(255)                           
                , nm_fias_guid      = COALESCE (%L, nm_fias_guid  )::uuid
                , dt_data_del       = %L::timestamp without time zone              --  NULL
                , id_data_etalon    = %L::bigint                                   --  NULL
                , kd_kladr          = COALESCE (%L, kd_kladr      )::varchar(15)
                , vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric                
                , vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric                
            WHERE (id_street = %L::bigint);   
       $_$;      
      -- 
       _select_u text = $_$
             SELECT s.* FROM ONLY %I.adr_street s WHERE (s.id_street = %L);
       $_$;
           --
       _del_twin  text = $_$             --        
              DELETE FROM ONLY %I.adr_street WHERE (id_street = %L);                     
       $_$;
       --
      _ins_hist text = $_$
            INSERT INTO %I.adr_street_hist (
                               id_street
                             , id_area
                             , nm_street
                             , id_street_type
                             , nm_street_full
                             , nm_fias_guid
                             , dt_data_del
                             , id_data_etalon
                             , kd_kladr
                             , vl_addr_latitude
                             , vl_addr_longitude
                             , id_region
            )
              VALUES (   %L::bigint                    
                        ,%L::bigint                    
                        ,%L::varchar(120)               
                        ,%L::integer                   
                        ,%L::varchar(255)               
                        ,%L::uuid 
                        ,%L::timestamp without time zone
                        ,%L::bigint                     
                        ,%L::varchar(15)               
                        ,%L::numeric                    
                        ,%L::numeric    
                        ,%L::bigint
              );      
        $_$;             
       -- -------------------------------------------------------------------------
       --
      _sel_twin_post  text = $_$     
           SELECT * FROM ONLY %I.adr_street
                   -- В пределах одного региона, одинаковые названия и типы, 
                   --   разница в UUIDs не важна
                   --
               WHERE ( (id_area = %L::bigint) AND    
                       (NOT (id_street = %L::bigint)) AND 
                       (
                           (upper(nm_street::text) = upper (%L)::text) AND
                           (id_street_type IS NOT DISTINCT FROM %L::bigint) 
                       ) AND (id_data_etalon IS NULL) 
                );
       $_$;
       --
      _rr    gar_tmp.adr_street_t; 
      _rr1   gar_tmp.adr_street_t; 
      
    BEGIN
     IF p_mode
       THEN -- Обработка
             NULL;             
       ELSE -- Постобработка
         _exec := format (_sel_twin_post, p_schema_name
                                ,p_id_area
                                ,p_id_street
                                 --
                                ,p_nm_street
                                ,p_id_street_type
                                 --
         );         
         EXECUTE _exec INTO _rr1; -- Поиск дублёра
         ----------------
         -- Двойники:  
         --
         IF (_rr1.id_street IS NOT NULL) -- Найден. 
           THEN
            IF (_rr1.dt_data_del <=  p_bound_date) AND (_rr1.dt_data_del IS NOT NULL)
              THEN
                   _exec = format (_upd_id, p_schema_name
                                       --
                                     ,_rr1.id_area           
                                     ,_rr1.nm_street         
                                     ,_rr1.id_street_type    
                                     ,_rr1.nm_street_full    
                                      --       
                                     ,_rr1.nm_fias_guid  
                                      --
                                     ,_rr1.dt_data_del      
                                     ,p_id_street 
                                      --
                                     ,_rr1.kd_kladr         
                                     ,_rr1.vl_addr_latitude 
                                     ,_rr1.vl_addr_longitude
                                      --   
                                     ,_rr1.id_street               
                     );
                     EXECUTE _exec; -- Связали.
            ELSE
               -- -----------------------------------------------------------------
               --  (dt_data_del >  p_bound_date) AND (dt_data_del IS NOT NULL) 
               --                   OR (dt_data_del IS NULL)
               -- -----------------------------------------------------------------
               -- Дублёр существует, он обновляется данными из проверяемой записи,
               -- проверяемая запись удаляется.
               -- -----------------------------------------------------------------
               _exec = format (_select_u, p_schema_name, p_id_street);
               EXECUTE _exec INTO _rr; -- проверяемая запись, полная структура.
               IF _rr.id_street IS NOT NULL 
                 THEN
                     _exec = format (_del_twin, p_schema_name, _rr.id_street);  
                     EXECUTE _exec;   -- Проверяемая запись
                     --
                     --    UPDATE _rr1 Обновление дублёра.
                     --    Старое значение уходит в историю
                     --
                     _exec := format (_ins_hist, p_schema_hist_name  
                                       --
                                     ,_rr1.id_street               
                                     ,_rr1.id_area           
                                     ,_rr1.nm_street         
                                     ,_rr1.id_street_type    
                                     ,_rr1.nm_street_full    
                                      --       
                                     ,_rr1.nm_fias_guid  
                                      --
                                     ,now()              --    _rr1.dt_data_del     
                                     ,_rr.id_street         --    _rr1.id_data_etalon     
                                      --
                                     ,_rr1.kd_kladr         
                                     ,_rr1.vl_addr_latitude 
                                     ,_rr1.vl_addr_longitude
                                      --   
                                     ,-1 -- ID региона
                     ); 
                     EXECUTE _exec;
                     --      
                     --  Обновляется старое значение  ??? Сколько их ??
                     --
                     _exec = format (_upd_id_1, p_schema_name
                                         --
                                       ,_rr1.id_area           
                                       ,_rr1.nm_street         
                                       ,_rr1.id_street_type    
                                       ,_rr1.nm_street_full    
                                        --       
                                       ,_rr1.nm_fias_guid  
                                        --
                                       ,NULL      
                                       ,NULL 
                                        --
                                       ,_rr1.kd_kladr         
                                       ,_rr1.vl_addr_latitude 
                                       ,_rr1.vl_addr_longitude
                                        --   
                                       ,_rr1.id_street               
                       );
                     
                     
                     EXECUTE _exec;
               END IF; -- _rr.id_street IS NOT NULL
            END IF; -- (_rr1.dt_data_del <=  p_bound_date) AND (_rr1.dt_data_del IS NOT NULL)
         END IF; --  _rr1.id_street IS NOT NULL
         
     END IF; -- p_mode
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_del_twin 
    (text, bigint, bigint, varchar(120), integer, uuid, boolean, date, text)
    IS 'Удаление/Слияние дублей. УЛИЦЫ';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- CALL gar_tmp_pcg_trans.p_adr_street_del_twin (
--               p_schema_name    := 'unnsi'  
--              ,p_id_house       := 2400298628   --  NOT NULL
--              ,p_id_area        := 32107        --  NOT NULL
--              ,p_id_street      := 353679       --      NULL
--              ,p_nm_house_full  := 'Д. 31Б/21'    --  NOT NULL
--              ,p_nm_fias_guid   := 'ba6461f5-8ea5-470d-a637-34cc42ea14ba'
-- );	
-- SELECT * FROM unnsi.adr_house WHERE ((id_area = 32107) AND 
--                                      (upper(nm_house_full::text) = 'Д. 31Б/21') AND (id_street=353679));
-- BEGIN;
-- UPDATE unnsi.adr_house SET dt_data_del = '2018-01-22 00:00:00' WHERE (id_house = 24026341);
-- COMMIT;
-- ROLLBACK;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_check_twins (
                  text, text, bigint [][], boolean, date, text
 );  
-- 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_street_check_twins (
        p_schema_name       text  
       ,p_conn_name         text  
       ,p_street_ids        bigint [][]       
       ,p_mode              boolean = FALSE -- Постобработка.
       ,p_bound_date        date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name  text = 'gar_tmp'             
)
    LANGUAGE plpgsql SECURITY DEFINER
  AS
$$
  -- ================================================================
  --  2022-04-29 Функция фильтрующая дубли.
  --  2022-05-15 Изменён порядок выборки записей.
  -- ================================================================
  DECLARE
   _rr      record;
   _z       bigint[];
   _arr_len integer;
   _i       integer := 1;

   _select text := $_$
      SELECT id_street, id_area, nm_street, id_street_type, nm_fias_guid
              FROM %I.adr_street 
                            WHERE (id_street >= %L) AND (id_street < %L)
                                 ORDER BY id_street DESC;	
   $_$;
   _exec text;
   
  BEGIN
    IF (p_street_ids IS NULL) 
      THEN
           RAISE 'Массив граничных значений не может быть NULL';
    END IF;
    _arr_len := array_length (p_street_ids, 1);
     --
     LOOP
       _z := p_street_ids [_i:_i];
       --
       _exec := format (_select, p_schema_name, (_z[1][1]), (_z[1][2]));
       --
       FOR _rr IN SELECT x1.* FROM gar_link.dblink (p_conn_name, _exec) 
             AS x1
               (
                    id_street      bigint
                   ,id_area        bigint
                   ,nm_street      varchar(120)
                   ,id_street_type integer
                   ,nm_fias_guid   uuid 
                )                             
        --                    
        LOOP
           EXIT WHEN (_rr.id_street IS NULL);
           --
           CALL gar_tmp_pcg_trans.p_adr_street_del_twin (
                     p_schema_name      := p_schema_name 
                     --
                    ,p_id_street        := _rr.id_street    
                    ,p_id_area          := _rr.id_area      
                    ,p_nm_street        := _rr.nm_street
                    ,p_id_street_type   := _rr.id_street_type
                    ,p_nm_fias_guid     := _rr.nm_fias_guid 
                     --
                    ,p_mode             := p_mode
                    ,p_bound_date       := p_bound_date       -- Только для режима Post обработки.
                    ,p_schema_hist_name := p_schema_hist_name
           );
        END LOOP;
       
        RAISE NOTICE 'Streets (ak1). Bounds: % - %', (_z[1][1]), (_z[1][2]);
       _i := _i + 1;
       
       EXIT WHEN (_i > _arr_len);
     END LOOP;
  END;
$$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_check_twins (text, text, bigint [][], boolean, date, text) 
                   IS 'Постобработка, фильтрация дублей УЛИЦЫ';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- SELECT * FROM unsi.adr_house WHERE(id_area = 78) AND (upper(nm_house_full::text)='Д. 100 ЛИТЕР АБ')
--                 AND (id_street= 1641)
-- SELECT gar_link.f_server_is();
-- SELECT * FROM gar_link.v_servers_active;
-- --------------------------------------------------------------------------
--   CALL gar_tmp_pcg_trans.p_adr_street_check_twins ('unnsi',gar_link.f_conn_set (3)
--          ,'{
--             {1100000000,1199000000}
--            ,{2400000000,2499000000}												   
--           }'
--   );
--
--           ,'{{2400000000,2499000000}
--             ,{7800000000,7899000000}
--             ,{3800000000,3899000000}

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_del_twin (
                  text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text 
 );   
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_del_twin_0 (
                  text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text 
 );    
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.fp_adr_house_del_twin_0 (
        p_schema_name      text  
       ,p_id_house         bigint       --  NOT NULL
       ,p_id_area          bigint       --  NOT NULL
       ,p_id_street        bigint       --      NULL
       ,p_nm_house_full    varchar(250) --  NOT NULL
       ,p_nm_fias_guid     uuid
       ,p_mode             boolean = TRUE  -- используется в процессе обработки
                                 --  FALSE -- в постобработке.
       ,p_bound_date       date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name text = 'gar_tmp'                     
)
    RETURNS integer
    LANGUAGE plpgsql 
    SECURITY DEFINER
    AS $$
    -- ---------------------------------------------------------------------------
    --  2022-02-28  Убираем дубли. 
    --  2022-02-28 Поиск близнецов. Два режима: 
    --    Поиск в процессе обработки, загрузочное индексное покрытие. 
    --    Поиск в после обработки, эксплуатационное индексное покрытие:
    --
    -- Используется технологический индекс (поиск в процессе обработки):
    --    UNIQUE INDEX _xxx_adr_house_ak1 ON unnsi.adr_house USING btree
    --                        (id_area ASC NULLS LAST
    --                        ,upper (nm_house_full::text) ASC NULLS LAST
    --                        ,id_street ASC NULLS LAST
    --                        ,id_house_type_1 ASC NULLS LAST
    --                        )
    --                    WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL)  
    -- ---------------------------------------------------------------------------
    --  2022-03-03  Двурежимная работа процедуры.
    --  Поиск в процессе постобработки, 
    --            используется индекс ""adr_house_ak1",  без уникальности 
    --
    --  INDEX adr_house_ak1
    --    ON unnsi.adr_house USING btree (id_area ASC NULLS LAST, upper(nm_house_full::text) ASC NULLS LAST
    --   , id_street ASC NULLS LAST)
    --    WHERE id_data_etalon IS NULL;
    -- ---------------------------------------------------------------------------
    --  2022-04-04 Постобработка, историческая запись должна содержать ссылку на 
    --             воздействующий субъект (id_data_etalon := id_house)
    --  --------------------------------------------------------------------------
    --  2022-06-20 Постобработка, только.
    -- ---------------------------------------------------------------------------
    -- 	ЗАМЕЧАНИЕ:  warning extra:00000:134:DECLARE:never read variable "_sel_twin_proc"
    --  ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_nm_fias_guid"
	
    DECLARE
      _exec text;
      
      _upd_id text = $_$
            UPDATE ONLY %I.adr_house SET  
            
                 id_area           = COALESCE (%L, id_area)::bigint               -- NOT NULL
                ,id_street         = COALESCE (%L, id_street)::bigint             --  NULL
                ,id_house_type_1   = COALESCE (%L, id_house_type_1)::integer      --  NULL
                ,nm_house_1        = COALESCE (%L, nm_house_1)::varchar(70)       --  NULL
                ,id_house_type_2   = %L::integer      -- COALESCE ( NULL , id_house_type_2)
                ,nm_house_2        = %L::varchar(50)  -- COALESCE ( NULL , nm_house_2)
                ,id_house_type_3   = %L::integer      -- COALESCE ( NULL , id_house_type_3)
                ,nm_house_3        = %L::varchar(50)  -- COALESCE ( NULL, nm_house_3)
                ,nm_zipcode        = COALESCE (%L, nm_zipcode)::varchar(20)       --  NULL
                ,nm_house_full     = COALESCE (%L, nm_house_full)::varchar(250)   -- NOT NULL
                ,kd_oktmo          = COALESCE (%L, kd_oktmo)::varchar(11)         --  NULL
                ,nm_fias_guid      = COALESCE (%L, nm_fias_guid)::uuid
                ,dt_data_del       = COALESCE (dt_data_del, %L)::timestamp without time zone              --  NULL
                ,id_data_etalon    = %L::bigint                                   --  NULL
                ,kd_okato          = COALESCE (%L, kd_okato)::varchar(11)         --  NULL
                ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric    --  NULL
                ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric    --  NULL
                    
            WHERE (id_house = %L::bigint);
        $_$;        
      --
      _upd_id_1 text = $_$
            UPDATE ONLY %I.adr_house SET  
            
                 id_area           = COALESCE (%L, id_area)::bigint               -- NOT NULL
                ,id_street         = COALESCE (%L, id_street)::bigint             --  NULL
                ,id_house_type_1   = COALESCE (%L, id_house_type_1)::integer      --  NULL
                ,nm_house_1        = COALESCE (%L, nm_house_1)::varchar(70)       --  NULL
                ,id_house_type_2   = %L::integer      -- COALESCE ( NULL , id_house_type_2)
                ,nm_house_2        = %L::varchar(50)  -- COALESCE ( NULL , nm_house_2)
                ,id_house_type_3   = %L::integer      -- COALESCE ( NULL , id_house_type_3)
                ,nm_house_3        = %L::varchar(50)  -- COALESCE ( NULL, nm_house_3)
                ,nm_zipcode        = COALESCE (%L, nm_zipcode)::varchar(20)       --  NULL
                ,nm_house_full     = COALESCE (%L, nm_house_full)::varchar(250)   -- NOT NULL
                ,kd_oktmo          = COALESCE (%L, kd_oktmo)::varchar(11)         --  NULL
                ,nm_fias_guid      = COALESCE (%L, nm_fias_guid)::uuid
                ,dt_data_del       = %L::timestamp without time zone              --  NULL
                ,id_data_etalon    = %L::bigint                                   --  NULL
                ,kd_okato          = COALESCE (%L, kd_okato)::varchar(11)         --  NULL
                ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric    --  NULL
                ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric    --  NULL
                    
            WHERE (id_house = %L::bigint);
        $_$;        
      -- 
       _select_u text = $_$
             SELECT h.* FROM ONLY %I.adr_house h WHERE (h.id_house = %L);
       $_$;
           --
       _del_twin  text = $_$             --        
              DELETE FROM ONLY %I.adr_house WHERE (id_house = %L);                     
       $_$;
       --
      _ins_hist text = $_$
             INSERT INTO %I.adr_house_hist (
                             id_house          -- bigint        NOT NULL
                            ,id_area           -- bigint        NOT NULL
                            ,id_street         -- bigint         NULL
                            ,id_house_type_1   -- integer        NULL
                            ,nm_house_1        -- varchar(70)    NULL
                            ,id_house_type_2   -- integer        NULL
                            ,nm_house_2        -- varchar(50)    NULL
                            ,id_house_type_3   -- integer        NULL
                            ,nm_house_3        -- varchar(50)    NULL
                            ,nm_zipcode        -- varchar(20)    NULL
                            ,nm_house_full     -- varchar(250)  NOT NULL
                            ,kd_oktmo          -- varchar(11)    NULL
                            ,nm_fias_guid      -- uuid           NULL 
                            ,dt_data_del       -- timestamp without time zone NULL
                            ,id_data_etalon    -- bigint        NULL
                            ,kd_okato          -- varchar(11)   NULL
                            ,vl_addr_latitude  -- numeric       NULL
                            ,vl_addr_longitude -- numeric       NULL
                            ,id_region         -- bigint
             )
               VALUES (   %L::bigint                   
                         ,%L::bigint                   
                         ,%L::bigint                    
                         ,%L::integer                  
                         ,%L::varchar(70)               
                         ,%L::integer                  
                         ,%L::varchar(50)               
                         ,%L::integer                  
                         ,%L::varchar(50)               
                         ,%L::varchar(20)  
                         ,%L::varchar(250)             
                         ,%L::varchar(11)               
                         ,%L::uuid
                         ,%L::timestamp without time zone
                         ,%L::bigint                   
                         ,%L::varchar(11)               
                         ,%L::numeric                  
                         ,%L::numeric  
                         ,%L::bigint
               ); 
        $_$;             
      -- -------------------------------------------------------------------------
      _sel_twin_proc  text = $_$
           SELECT * FROM ONLY %I.adr_house
               WHERE
                ((id_area = %L::bigint) AND 
                    (
                      (  -- На ОДНОЙ улице разные названия, UUIDs тождественны
                        (NOT (upper(nm_house_full::text) = upper (%L)::text)) AND
                        (id_street IS NOT DISTINCT FROM %L::bigint)  AND
                        (nm_fias_guid = %L::uuid)
                      )
                         OR
                      (     -- На РАЗНЫХ улицах одинаковые названия, UUIDs тождественны
                        (upper(nm_house_full::text) = upper (%L)::text) AND
                        (id_street IS DISTINCT FROM %L::bigint) AND 
                        (nm_fias_guid = %L::uuid)
                      )
                         OR
                      (   -- На ОДНОЙ улице одинаковые названия, UUIDs различаются
                        (upper(nm_house_full::text) = upper (%L)::text) AND
                        (id_street IS NOT DISTINCT FROM %L::bigint)  AND
                        (NOT (nm_fias_guid = %L::uuid))                   
                      )
                    ) 
                      AND 
                          ((id_data_etalon IS NULL) AND (dt_data_del IS NULL))    
                )
                
                OR -- Разные регионы (адресные пространства), одинаковые названия и UUID
                
                (((NOT (id_area = %L::bigint)) AND
                        (upper(nm_house_full::text) = upper (%L)::text) AND
                        (id_street IS NOT DISTINCT FROM %L::bigint) AND 
                        (nm_fias_guid = %L::uuid)
                 )
                     AND 
                 ((id_data_etalon IS NULL) AND (dt_data_del IS NULL))    
                );
       $_$;
       -- Различаются ID.      
      _sel_twin_post  text = $_$     
           SELECT * FROM ONLY %I.adr_house
                   -- В пределах одного региона, 
                   -- на ОДНОЙ улице одинаковые названия, разница в UUIDs не важна
                   --
               WHERE ((id_area = %L::bigint) AND    
                   (
                            (upper(nm_house_full::text) = upper (%L)::text) AND
                            (id_street IS NOT DISTINCT FROM %L::bigint)  AND
                            (NOT (id_house = %L::bigint))
                     
                   ) AND (id_data_etalon IS NULL) 
                );
                --
                -- Либо различные регионы, одинаковые UUIDs, разница в улицах не важна
                --
       $_$;
       --
      _rr    gar_tmp.adr_house_t; 
      _rr1   gar_tmp.adr_house_t; 
      _qty integer;
      
    BEGIN
     _qty := 0;
    
     IF p_mode
       THEN -- Обработка
         NULL;
             
       ELSE -- Постобработка
         _exec := format (_sel_twin_post, p_schema_name
                                ,p_id_area
                                 --
                                ,p_nm_house_full
                                ,p_id_street
                                 --
                                ,p_id_house
         );         
         EXECUTE _exec INTO _rr1; -- Поиск дублёра
         ----------------
         -- Двойники: см. определение выше
         --
         IF (_rr1.id_house IS NOT NULL) -- Найден. 
           THEN
            IF (_rr1.dt_data_del <=  p_bound_date) AND (_rr1.dt_data_del IS NOT NULL)
              THEN
                   _exec = format (_upd_id, p_schema_name
                                     ,_rr1.id_area          
                                     ,_rr1.id_street        
                                     ,_rr1.id_house_type_1  
                                     ,_rr1.nm_house_1       
                                     ,_rr1.id_house_type_2  
                                     ,_rr1.nm_house_2       
                                     ,_rr1.id_house_type_3  
                                     ,_rr1.nm_house_3       
                                     ,_rr1.nm_zipcode       
                                     ,_rr1.nm_house_full    
                                     ,_rr1.kd_oktmo         
                                     ,_rr1.nm_fias_guid     
                                     ,_rr1.dt_data_del      
                                     ,p_id_house  
                                     ,_rr1.kd_okato         
                                     ,_rr1.vl_addr_latitude 
                                     ,_rr1.vl_addr_longitude
                                      --   
                                     ,_rr1.id_house               
                     );
                     EXECUTE _exec; -- Связали.
                     _qty := 1;
            ELSE
               -- -----------------------------------------------------------------
               --  (dt_data_del >  p_bound_date) AND (dt_data_del IS NOT NULL) 
               --                   OR (dt_data_del IS NULL)
               -- -----------------------------------------------------------------
               -- Дублёр существует, он обновляется данными из проверяемой записи,
               -- проверяемая запись удаляется.
               -- -----------------------------------------------------------------
               _exec = format (_select_u, p_schema_name, p_id_house);
               EXECUTE _exec INTO _rr; -- проверяемая запись, полная структура.
               IF _rr.id_house IS NOT NULL 
                 THEN
                     _exec = format (_del_twin, p_schema_name, _rr.id_house);  
                     EXECUTE _exec;   -- Проверяемая запись
                     --
                     --    UPDATE _rr1 Обновление дублёра.
                     --    Старое значение уходит в историю
                     --
                     _exec := format (_ins_hist, p_schema_hist_name  
                                            --
                             ,_rr1.id_house  
                             ,_rr1.id_area           
                             ,_rr1.id_street         
                             ,_rr1.id_house_type_1   
                             ,_rr1.nm_house_1        
                             ,_rr1.id_house_type_2   
                             ,_rr1.nm_house_2        
                             ,_rr1.id_house_type_3   
                             ,_rr1.nm_house_3        
                             ,_rr1.nm_zipcode        
                             ,_rr1.nm_house_full     
                             ,_rr1.kd_oktmo          
                             ,_rr1.nm_fias_guid     -- 2022-04-04 
                             ,now()                 --    _rr1.dt_data_del     
                             ,_rr.id_house          --    _rr1.id_data_etalon     
                             ,_rr1.kd_okato          
                             ,_rr1.vl_addr_latitude  
                             ,_rr1.vl_addr_longitude
                             , -1 -- ID региона
                     ); 
                     EXECUTE _exec;
                     --      
                     --  Обновляется старое значение  ??? Сколько их ??
                     --
                     _exec = format (_upd_id_1, p_schema_name
                                     ,_rr.id_area          
                                     ,_rr.id_street        
                                     ,_rr.id_house_type_1  
                                     ,_rr.nm_house_1       
                                     ,_rr.id_house_type_2  
                                     ,_rr.nm_house_2       
                                     ,_rr.id_house_type_3  
                                     ,_rr.nm_house_3       
                                     ,_rr.nm_zipcode       
                                     ,_rr.nm_house_full    
                                     ,_rr.kd_oktmo         
                                     ,_rr1.nm_fias_guid   -- 2022-06-20 Сохраняется старый UUID  
                                     ,NULL      
                                     ,NULL  
                                     ,_rr.kd_okato         
                                     ,_rr.vl_addr_latitude 
                                     ,_rr.vl_addr_longitude
                                      --  
                                     ,_rr1.id_house               
                     );
                     EXECUTE _exec;
                     _qty := 1;
                     
               END IF; -- _rr.id_house IS NOT NULL
            END IF; -- (_rr1.dt_data_del <=  p_bound_date) AND (_rr1.dt_data_del IS NOT NULL)
         END IF; --  _rr1.id_house IS NOT NULL
     END IF; -- p_mode
     
     RETURN _qty;
    END;
  $$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.fp_adr_house_del_twin_0 
    (text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text)
    IS 'Удаление/Слияние дублей';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- CALL gar_tmp_pcg_trans.fp_adr_house_del_twin (
--               p_schema_name    := 'unnsi'  
--              ,p_id_house       := 2400298628   --  NOT NULL
--              ,p_id_area        := 32107        --  NOT NULL
--              ,p_id_street      := 353679       --      NULL
--              ,p_nm_house_full  := 'Д. 31Б/21'    --  NOT NULL
--              ,p_nm_fias_guid   := 'ba6461f5-8ea5-470d-a637-34cc42ea14ba'
-- );	
-- SELECT * FROM unnsi.adr_house WHERE ((id_area = 32107) AND 
--                                      (upper(nm_house_full::text) = 'Д. 31Б/21') AND (id_street=353679));
-- BEGIN;
-- UPDATE unnsi.adr_house SET dt_data_del = '2018-01-22 00:00:00' WHERE (id_house = 24026341);
-- COMMIT;
-- ROLLBACK;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_del_twin_1 (
                  text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text 
 );   
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_del_twin_1 (
                  text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text 
 );   
 
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.fp_adr_house_del_twin_1 (
        p_schema_name      text  
       ,p_id_house         bigint       --  NOT NULL
       ,p_id_area          bigint       --  NOT NULL
       ,p_id_street        bigint       --      NULL
       ,p_nm_house_full    varchar(250) --  NOT NULL
       ,p_nm_fias_guid     uuid
       ,p_mode             boolean = FALSE -- используется в процессе обработки
                                 --  FALSE -- в постобработке.
       ,p_bound_date       date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name text = 'gar_tmp'                     
)
    RETURNS integer
    LANGUAGE plpgsql 
    SECURITY DEFINER
    AS $$
    -- ---------------------------------------------------------------------------
    --  2022-02-28  Убираем дубли. 
    -- ---------------------------------------------------------------------------
    --  2022-06-06/2022-06-21/2022-07-28 Опытный вариант Постобработки. 
    -- ---------------------------------------------------------------------------
    -- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_nm_fias_guid"
    -- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_bound_date"
    -- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_schema_hist_name"   
    
    DECLARE
      _exec text;
      --
      _upd_id text = $_$
            UPDATE ONLY %I.adr_house SET  
            
                 id_area           = COALESCE (%L, id_area)::bigint               -- NOT NULL
                ,id_street         = COALESCE (%L, id_street)::bigint             --  NULL
                ,id_house_type_1   = COALESCE (%L, id_house_type_1)::integer      --  NULL
                ,nm_house_1        = COALESCE (%L, nm_house_1)::varchar(70)       --  NULL
                ,id_house_type_2   = %L::integer      -- COALESCE ( NULL , id_house_type_2)
                ,nm_house_2        = %L::varchar(50)  -- COALESCE ( NULL , nm_house_2)
                ,id_house_type_3   = %L::integer      -- COALESCE ( NULL , id_house_type_3)
                ,nm_house_3        = %L::varchar(50)  -- COALESCE ( NULL, nm_house_3)
                ,nm_zipcode        = COALESCE (%L, nm_zipcode)::varchar(20)       --  NULL
                ,nm_house_full     = COALESCE (%L, nm_house_full)::varchar(250)   -- NOT NULL
                ,kd_oktmo          = COALESCE (%L, kd_oktmo)::varchar(11)         --  NULL
                ,nm_fias_guid      = COALESCE (%L, nm_fias_guid)::uuid
                ,dt_data_del       = %L::timestamp without time zone              --  NULL
                ,id_data_etalon    = %L::bigint                                   --  NULL
                ,kd_okato          = COALESCE (%L, kd_okato)::varchar(11)         --  NULL
                ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric    --  NULL
                ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric    --  NULL
                    
            WHERE (id_house = %L::bigint);
        $_$;        
      -- -------------------------------------------------------------------------
      -- Различаются ID.
       
      _sel_twin_post  text = $_$     
           SELECT * FROM ONLY %I.adr_house
                   -- В пределах одного региона, 
                   -- на ОДНОЙ улице одинаковые названия, разница в UUIDs не важна
                   --
               WHERE ((id_area = %L::bigint) AND    
                   (
                            (upper(nm_house_full::text) = upper (%L)::text) AND
                            (id_street IS NOT DISTINCT FROM %L::bigint)  AND
                            (NOT (id_house = %L::bigint))
                     
                   ) AND (id_data_etalon IS NULL) 
                );

       $_$;
       --
      _rr1  gar_tmp.adr_house_t; 
      _qty  integer;
      
    BEGIN
     _qty := 0;
    
     IF p_mode
       THEN -- Обработка
          NULL;
             
       ELSE -- Постобработка
         _exec := format (_sel_twin_post, p_schema_name
                                ,p_id_area
                                 --
                                ,p_nm_house_full
                                ,p_id_street
                                 --
                                ,p_id_house
         );         
         EXECUTE _exec INTO _rr1; -- Поиск дублёра
         ----------------
         -- Двойники: см. определение выше
         --
         IF (_rr1.id_house IS NOT NULL) -- Найден. 
           THEN
            _exec = format (_upd_id, p_schema_name
                                     ,_rr1.id_area          
                                     ,_rr1.id_street        
                                     ,_rr1.id_house_type_1  
                                     ,_rr1.nm_house_1       
                                     ,_rr1.id_house_type_2  
                                     ,_rr1.nm_house_2       
                                     ,_rr1.id_house_type_3  
                                     ,_rr1.nm_house_3       
                                     ,_rr1.nm_zipcode       
                                     ,_rr1.nm_house_full    
                                     ,_rr1.kd_oktmo         
                                     ,_rr1.nm_fias_guid     
                                     ,coalesce (_rr1.dt_data_del, date (now()))   
                                     ,p_id_house  
                                     ,_rr1.kd_okato         
                                     ,_rr1.vl_addr_latitude 
                                     ,_rr1.vl_addr_longitude
                                      --   
                                     ,_rr1.id_house               
            );
            EXECUTE _exec; -- Связали.
            _qty := 1;
         END IF; -- _rr1.id_house IS NOT NULL
     END IF; -- p_mode
     
     RETURN _qty;
    END;
  $$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.fp_adr_house_del_twin_1 
    (text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text)
    IS 'Удаление/Слияние дублей';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- SELECT gar_tmp_pcg_trans.fp_adr_house_del_twin_1 (
--               p_schema_name    := 'unnsi'  
--              ,p_id_house       := 13696829   --  NOT NULL
--              ,p_id_area        := 126646        --  NOT NULL
--              ,p_id_street      := NULL       --      NULL
--              ,p_nm_house_full  := 'Д. 175Л'    --  NOT NULL
--              ,p_nm_fias_guid   := '0c755ac2-dd91-477d-b61e-68e6f3faef62'
-- );	-- 1
-- SELECT * FROM unnsi.adr_house WHERE (id_house IN (13696829, 26510189));


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_del_twin_2 (
                  text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text 
 );  
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_del_twin_2 (
                  text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text 
 ); 
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.fp_adr_house_del_twin_2 (
        p_schema_name      text  
       ,p_id_house         bigint       --  NOT NULL
       ,p_id_area          bigint       --  NOT NULL
       ,p_id_street        bigint       --      NULL
       ,p_nm_house_full    varchar(250) --  NOT NULL
       ,p_nm_fias_guid     uuid
       ,p_mode             boolean = FALSE -- используется в постобработке.
       ,p_bound_date       date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name text = 'gar_tmp'                     
)
-- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_id_street"
-- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_nm_house_full"

    RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
   
    AS $$
    -- ----------------------------------------------------------------------------------------
    --  2022-02-28  Убираем дубли. 
    -- ---------------------------------------------------------------------------------------
    --  2022-03-03  Двурежимная работа процедуры.
    --  Поиск в процессе постобработки, 
    --            используется индекс ""adr_house_ak1",  без уникальности 
    --  INDEX adr_house_ak1
    --    ON unnsi.adr_house USING btree (id_area ASC NULLS LAST, upper(nm_house_full::text) ASC NULLS LAST
    --   , id_street ASC NULLS LAST)
    --    WHERE id_data_etalon IS NULL;
    -- ---------------------------------------------------------------------------------------
    --  2022-04-04 Постобработка, историческая запись должна содержать ссылку на 
    --             воздействующий субъект (id_data_etalon := id_house)
    -- ---------------------------------------------------------------------------------------
    --  2022-06-06  Постобработка. Пока в 99 базе. Опытный вариант.
    --  2022-06-10  Постобработка. Пока в 99 базе. Ещё один опытный вариант.    
    --  2022-06-15  Постобработка. FIX. unsi_old2. Первый вариант, поддерживающий  целостность базы. 
    --  Соглашение о терминах:
    --     Проверяемая запись может иметь близнецов ("nm_fias_guid" СОВПАДАЮТ)
    --     Запись активна, если справедливо отношение:
    --          (dt_data_del IS NULL) AND (id_data_etalon IS NULL)
    --     Запись помечена на удаление: (dt_data_del IS NOT NULL) AND (id_data_etalon IS NULL)    
    --     Деактуализированная запись:  (dt_data_del IS NOT NULL) AND (id_data_etalon IS NOT NULL)
    -- ---------------------------------------------------------------------------------------
    --   Проверка записи:
    --     1) Найден дублёр, далее проверка его актуальности:
    --         1.1) Актуален, его "адресная область" так-же актуальна.
    --              сливаем записи, проверяемая запись удаляется 
    --
    --         1.2) Дублёр актуален, но его адресная облась НЕ АКТУАЛЬНА.
    --              Дублёр деактуализируется, его dt_data_del = dt_data_del адресной области.
    --
    --         1.3) Дублёр не актуален, в случае если dt_data_del < '2022-01-01' то 
    --               его id_data_etalon = id_house проверяемой записи.
    
    --         1.4) Дублёр не актуален, его dt_data_del >= '2022-01-01', то он удаляется.
    -- ---------------------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _upd_id text = $_$
            UPDATE ONLY %I.adr_house SET  
            
                 id_area           = COALESCE (%L, id_area)::bigint               -- NOT NULL
                ,id_street         = COALESCE (%L, id_street)::bigint             --  NULL
                ,id_house_type_1   = COALESCE (%L, id_house_type_1)::integer      --  NULL
                ,nm_house_1        = COALESCE (%L, nm_house_1)::varchar(70)       --  NULL
                ,id_house_type_2   = %L::integer      -- COALESCE ( NULL , id_house_type_2)
                ,nm_house_2        = %L::varchar(50)  -- COALESCE ( NULL , nm_house_2)
                ,id_house_type_3   = %L::integer      -- COALESCE ( NULL , id_house_type_3)
                ,nm_house_3        = %L::varchar(50)  -- COALESCE ( NULL, nm_house_3)
                ,nm_zipcode        = COALESCE (%L, nm_zipcode)::varchar(20)       --  NULL
                ,nm_house_full     = COALESCE (%L, nm_house_full)::varchar(250)   -- NOT NULL
                ,kd_oktmo          = COALESCE (%L, kd_oktmo)::varchar(11)         --  NULL
                ,nm_fias_guid      = COALESCE (%L, nm_fias_guid)::uuid
                ,dt_data_del       = %L::timestamp without time zone              --  NULL
                ,id_data_etalon    = %L::bigint                                   --  NULL
                ,kd_okato          = COALESCE (%L, kd_okato)::varchar(11)         --  NULL
                ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric    --  NULL
                ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric    --  NULL
                    
            WHERE (id_house = %L::bigint);
        $_$;        
      -- 
      --    _select_id text = $_$
      --          SELECT h.* FROM ONLY %I.adr_house h WHERE (h.id_house = %L);
      --    $_$;
           --
       _del_twin_id  text = $_$             --        
             DELETE FROM ONLY %I.adr_house WHERE (id_house = %L);                     
       $_$;
       --
      _ins_hist text = $_$
             INSERT INTO %I.adr_house_hist (
                             id_house          -- bigint        NOT NULL
                            ,id_area           -- bigint        NOT NULL
                            ,id_street         -- bigint         NULL
                            ,id_house_type_1   -- integer        NULL
                            ,nm_house_1        -- varchar(70)    NULL
                            ,id_house_type_2   -- integer        NULL
                            ,nm_house_2        -- varchar(50)    NULL
                            ,id_house_type_3   -- integer        NULL
                            ,nm_house_3        -- varchar(50)    NULL
                            ,nm_zipcode        -- varchar(20)    NULL
                            ,nm_house_full     -- varchar(250)  NOT NULL
                            ,kd_oktmo          -- varchar(11)    NULL
                            ,nm_fias_guid      -- uuid           NULL 
                            ,dt_data_del       -- timestamp without time zone NULL
                            ,id_data_etalon    -- bigint        NULL
                            ,kd_okato          -- varchar(11)   NULL
                            ,vl_addr_latitude  -- numeric       NULL
                            ,vl_addr_longitude -- numeric       NULL
                            ,id_region         -- bigint
             )
               VALUES (   %L::bigint                   
                         ,%L::bigint                   
                         ,%L::bigint                    
                         ,%L::integer                  
                         ,%L::varchar(70)               
                         ,%L::integer                  
                         ,%L::varchar(50)               
                         ,%L::integer                  
                         ,%L::varchar(50)               
                         ,%L::varchar(20)  
                         ,%L::varchar(250)             
                         ,%L::varchar(11)               
                         ,%L::uuid
                         ,%L::timestamp without time zone
                         ,%L::bigint                   
                         ,%L::varchar(11)               
                         ,%L::numeric                  
                         ,%L::numeric  
                         ,%L::bigint
               ); 
        $_$;             
      -- -------------------------------------------------------------------------
      _sel_twin_post_u  text = $_$  -- UUID совпадают    
           SELECT * FROM ONLY %I.adr_house
               WHERE ((nm_fias_guid = %L::uuid) AND (NOT (id_house = %L::bigint))
                     ) AND (id_data_etalon IS NULL); 
       $_$;
       --
      _rr    gar_tmp.adr_house_t; 
      _rr1   gar_tmp.adr_house_t; 
      _rr2   gar_tmp.adr_area_t;
      -- _rr3   gar_tmp.adr_street_t;
      _qty integer := 0;
      
    BEGIN
     IF p_mode
       THEN -- Обработка
          NULL;
       ELSE -- Постобработка
         _exec := format (_sel_twin_post_u, p_schema_name, p_nm_fias_guid, p_id_house);         
         EXECUTE _exec INTO _rr1; -- Поиск дублёра

         -- RAISE NOTICE 'Point 0.0) %', _rr;
         -- --------------------------------
         --  Двойники: см. определение выше
         -- --------------------------------
         IF (_rr1.id_house IS NOT NULL) -- Найден. 
           THEN
            -- RAISE NOTICE 'Point 0) % - %', p_id_house, _rr1;
                
            IF (_rr1.dt_data_del IS NULL)
              THEN
                  _rr2 := gar_tmp_pcg_trans.f_adr_area_get (p_schema_name, _rr1.id_area);
                  
                  -- RAISE NOTICE 'Point 1) %', _rr2;
                  
                  IF (_rr2.dt_data_del IS NULL) --- AND (_rr2.id_data_etalon IS NULL) 
                    THEN
                        --  1.1) Актуален, его "адресная область" так-же актуальна.
                        --       сливаем записи, проверяемая запись удаляется 
                        -- --------------------------------------------------------

                        _rr := gar_tmp_pcg_trans.f_adr_house_get (p_schema_name, p_id_house);
                        _exec = format (_del_twin_id, p_schema_name, p_id_house);  
                        EXECUTE _exec;   -- Проверяемая запись

                        -- RAISE NOTICE 'Point 2) % - %', p_id_house, _rr;
                        IF (_rr.id_data_etalon IS NULL) 
                         THEN
                            --
                            --    UPDATE _rr1 Обновление дублёра. 
                            --    Только в том случае, если проверяемая запись актуальна.
                            --    Старое значение уходит в историю
                            --
                            -- RAISE NOTICE 'Point 3.0)';
                            _exec := format (_ins_hist, p_schema_hist_name  
                                                   --
                                    ,_rr1.id_house  
                                    ,_rr1.id_area           
                                    ,_rr1.id_street         
                                    ,_rr1.id_house_type_1   
                                    ,_rr1.nm_house_1        
                                    ,_rr1.id_house_type_2   
                                    ,_rr1.nm_house_2        
                                    ,_rr1.id_house_type_3   
                                    ,_rr1.nm_house_3        
                                    ,_rr1.nm_zipcode        
                                    ,_rr1.nm_house_full     
                                    ,_rr1.kd_oktmo          
                                    ,_rr1.nm_fias_guid     -- 2022-04-04 
                                    ,now()                 --    _rr1.dt_data_del     
                                    ,p_id_house          --    _rr1.id_data_etalon     
                                    ,_rr1.kd_okato          
                                    ,_rr1.vl_addr_latitude  
                                    ,_rr1.vl_addr_longitude
                                    , -1 -- ID региона
                            ); 
                            EXECUTE _exec;

                            --  Обновляется старое значение  ??? Сколько их ??
                            _exec = format (_upd_id, p_schema_name
                                            ,_rr.id_area          
                                            ,_rr.id_street        
                                            ,_rr.id_house_type_1  
                                            ,_rr.nm_house_1       
                                            ,_rr.id_house_type_2  
                                            ,_rr.nm_house_2       
                                            ,_rr.id_house_type_3  
                                            ,_rr.nm_house_3       
                                            ,_rr.nm_zipcode       
                                            ,_rr.nm_house_full    
                                            ,_rr.kd_oktmo         
                                            ,_rr.nm_fias_guid     
                                            ,NULL      
                                            ,NULL  
                                            ,_rr.kd_okato         
                                            ,_rr.vl_addr_latitude 
                                            ,_rr.vl_addr_longitude
                                             --  
                                            ,_rr1.id_house               
                            );
                            EXECUTE _exec;
                            
                          ELSE -- Проверяемую запись в историю.   
                            -- RAISE NOTICE 'Point 3.1)';
                            
                            _exec := format (_ins_hist, p_schema_hist_name  
                                                   --
                                    ,_rr.id_house  
                                    ,_rr.id_area           
                                    ,_rr.id_street         
                                    ,_rr.id_house_type_1   
                                    ,_rr.nm_house_1        
                                    ,_rr.id_house_type_2   
                                    ,_rr.nm_house_2        
                                    ,_rr.id_house_type_3   
                                    ,_rr.nm_house_3        
                                    ,_rr.nm_zipcode        
                                    ,_rr.nm_house_full     
                                    ,_rr.kd_oktmo          
                                    ,_rr.nm_fias_guid      
                                    ,_rr.dt_data_del     
                                    ,_rr.id_data_etalon     
                                    ,_rr.kd_okato          
                                    ,_rr.vl_addr_latitude  
                                    ,_rr.vl_addr_longitude
                                    , -1 -- ID региона
                            ); 
                            EXECUTE _exec;
                            
                        END IF; -- (_rr.id_data_etalon IS NULL)
                        _qty := 1;
                        
                     ELSE
                     
                     -- 1.2) Дублёр актуален, но его адресная облась НЕ АКТУАЛЬНА.
                     --      Дублёр деактуализируется, его dt_data_del = dt_data_del адресной области.
                     --      Активной остаётся проверяемая запись.  
                     
                     -- RAISE NOTICE 'Point 4) %', p_id_house;
                     _exec = format (_upd_id, p_schema_name
                                     ,_rr1.id_area          
                                     ,_rr1.id_street        
                                     ,_rr1.id_house_type_1  
                                     ,_rr1.nm_house_1       
                                     ,_rr1.id_house_type_2  
                                     ,_rr1.nm_house_2       
                                     ,_rr1.id_house_type_3  
                                     ,_rr1.nm_house_3       
                                     ,_rr1.nm_zipcode       
                                     ,_rr1.nm_house_full    
                                     ,_rr1.kd_oktmo         
                                     ,_rr1.nm_fias_guid     
                                     ,_rr2.dt_data_del  --  dt_data_del    
                                     ,p_id_house     --  id_data_etalon 
                                     ,_rr1.kd_okato         
                                     ,_rr1.vl_addr_latitude 
                                     ,_rr1.vl_addr_longitude
                                      --  
                                     ,_rr1.id_house               
                     );
                     EXECUTE _exec;
                     _qty := 1;
                  END IF; -- (_rr2.dt_data_del IS NULL)
                  
             ELSE --  (_rr1.dt_data_del IS NOT NULL)    
                IF (_rr1.dt_data_del < p_bound_date)
                  THEN
                   -- 
                   -- 1.3) Дублёр не актуален, в случае если dt_data_del < '2022-01-01' то 
                   --      его id_data_etalon = id_house проверяемой записи.
                   --
                   -- RAISE NOTICE 'Point 5) %', p_id_house;
                   _exec = format (_upd_id, p_schema_name
                                     ,_rr1.id_area          
                                     ,_rr1.id_street        
                                     ,_rr1.id_house_type_1  
                                     ,_rr1.nm_house_1       
                                     ,_rr1.id_house_type_2  
                                     ,_rr1.nm_house_2       
                                     ,_rr1.id_house_type_3  
                                     ,_rr1.nm_house_3       
                                     ,_rr1.nm_zipcode       
                                     ,_rr1.nm_house_full    
                                     ,_rr1.kd_oktmo         
                                     ,_rr1.nm_fias_guid     
                                     ,_rr1.dt_data_del      
                                     ,p_id_house  
                                     ,_rr1.kd_okato         
                                     ,_rr1.vl_addr_latitude 
                                     ,_rr1.vl_addr_longitude
                                      --   
                                     ,_rr1.id_house               
                   );
                   EXECUTE _exec; -- Связали.
                   _qty := 1;
                     
                 ELSE -- (_rr1.dt_data_del >= p_bound_date)
                   --
                   --  1.4) Дублёр не актуален, его dt_data_del >= '2022-01-01', то он удаляется.
                   --
                   -- RAISE NOTICE 'Point 6) %', p_id_house;
                   _exec := format (_ins_hist, p_schema_hist_name  
                           ,_rr1.id_house  
                           ,_rr1.id_area           
                           ,_rr1.id_street         
                           ,_rr1.id_house_type_1   
                           ,_rr1.nm_house_1        
                           ,_rr1.id_house_type_2   
                           ,_rr1.nm_house_2        
                           ,_rr1.id_house_type_3   
                           ,_rr1.nm_house_3        
                           ,_rr1.nm_zipcode        
                           ,_rr1.nm_house_full     
                           ,_rr1.kd_oktmo          
                           ,_rr1.nm_fias_guid     -- 2022-04-04 
                           ,now()                 --    _rr1.dt_data_del     
                           ,p_id_house         --    _rr1.id_data_etalon     
                           ,_rr1.kd_okato          
                           ,_rr1.vl_addr_latitude  
                           ,_rr1.vl_addr_longitude
                           , -1 -- ID региона
                   ); 
                   EXECUTE _exec;
                   _exec = format (_del_twin_id, p_schema_name, _rr1.id_house);  
                   EXECUTE _exec;   -- Запись дублёр
                   _qty := 1;
                   
                END IF; -- (_rr1.dt_data_del < p_bound_date)
            END IF; -- _rr1.dt_data_del IS NULL
           
         END IF; --  _rr1.id_house IS NOT NULL
     END IF; -- p_mode
     
     RETURN _qty;
    END;
  $$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.fp_adr_house_del_twin_2 
    (text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text)
    IS 'Удаление/Слияние дублей';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- CALL gar_tmp_pcg_trans.fp_adr_house_del_twin_2 (
--               p_schema_name    := 'unnsi'  
--              ,p_id_house       := 2400298628   --  NOT NULL
--              ,p_id_area        := 32107        --  NOT NULL
--              ,p_id_street      := 353679       --      NULL
--              ,p_nm_house_full  := 'Д. 31Б/21'    --  NOT NULL
--              ,p_nm_fias_guid   := 'ba6461f5-8ea5-470d-a637-34cc42ea14ba'
-- );	
-- SELECT * FROM unnsi.adr_house WHERE ((id_area = 32107) AND 
--                                      (upper(nm_house_full::text) = 'Д. 31Б/21') AND (id_street=353679));
-- BEGIN;
-- UPDATE unnsi.adr_house SET dt_data_del = '2018-01-22 00:00:00' WHERE (id_house = 24026341);
-- COMMIT;
-- ROLLBACK;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_check_twins (
                  text, text, bigint [][], boolean
 ); 
 --
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_check_twins (
                  text, text, bigint [][], boolean, date, text
 );  
-- 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_check_twins (
        p_schema_name       text  
       ,p_conn_name         text  
       ,p_house_ids         bigint [][]       
       ,p_mode              boolean = FALSE -- Постобработка.
       ,p_bound_date        date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name text = 'gar_tmp'             
)
    LANGUAGE plpgsql SECURITY DEFINER
  AS
$$
  -- ========================================================================
  --  2022-03-15 Функция фильтрующая дубли.
  --  2022-05-15 Изменён порядок выборки записей.
  --  2022-06-23 Две функции: 
  --     gar_tmp_pcg_trans.fp_adr_house_del_twin_0 () удаление "AK1"
  --     gar_tmp_pcg_trans.fp_adr_house_del_twin_2 () удаление "nm_fias_guid"
  --  2022-07-27 Подключение постоянно, запрос выполняется дважды
  -- ========================================================================
  DECLARE
   _rr      record;
   _z       bigint[];
   _arr_len integer;
   _i       integer := 1;
   _qty_0   integer;
   _qty_2   integer;

   _select text := $_$
      SELECT id_house, id_area, id_street, nm_house_full, nm_fias_guid 
            FROM %I.adr_house 
                    WHERE (id_house >= %L) AND (id_house < %L)
                           ORDER BY id_house DESC;	
   $_$;
   _exec text;
   
  BEGIN
    IF (p_house_ids IS NULL) 
      THEN
           RAISE 'Массив граничных значений не может быть NULL';
    END IF;
    _arr_len := array_length (p_house_ids, 1);
     --
     LOOP
  	   _qty_0 := 0;
	   _qty_2 := 0;
       _z := p_house_ids [_i:_i];
       --
       _exec := format (_select, p_schema_name, (_z[1][1]), (_z[1][2]));
       --
       FOR _rr IN SELECT x1.* FROM gar_link.dblink (p_conn_name, _exec) 
             AS x1
               (
                    id_house      bigint
                   ,id_area       bigint
                   ,id_street     bigint 
                   ,nm_house_full varchar(250)
                   ,nm_fias_guid  uuid 
                )                             
        --                    
        LOOP
           EXIT WHEN (_rr.id_house IS NULL);
           --
           _qty_0 := _qty_0 + gar_tmp_pcg_trans.fp_adr_house_del_twin_0 (
                     p_schema_name       :=  p_schema_name 
                    ,p_id_house          :=  _rr.id_house     
                    ,p_id_area           :=  _rr.id_area      
                    ,p_id_street         :=  _rr.id_street    
                    ,p_nm_house_full     :=  _rr.nm_house_full
                    ,p_nm_fias_guid      :=  _rr.nm_fias_guid 
                    ,p_mode              :=  p_mode
                    ,p_bound_date        :=  p_bound_date       -- Только для режима Post обработки.
                    ,p_schema_hist_name  :=  p_schema_hist_name           
           );
        END LOOP;
        
        -- 2022-07-27 Подключение постоянно, запрос выполняется дважды

       FOR _rr IN SELECT x1.* FROM gar_link.dblink (p_conn_name, _exec) 
             AS x1
               (
                    id_house      bigint
                   ,id_area       bigint
                   ,id_street     bigint 
                   ,nm_house_full varchar(250)
                   ,nm_fias_guid  uuid 
                )                             
        --                    
        LOOP
           EXIT WHEN (_rr.id_house IS NULL);
           --
           _qty_2 := _qty_2 + gar_tmp_pcg_trans.fp_adr_house_del_twin_2 (
                     p_schema_name      := p_schema_name 
                    ,p_id_house         := _rr.id_house     
                    ,p_id_area          := _rr.id_area      
                    ,p_id_street        := _rr.id_street    
                    ,p_nm_house_full    := _rr.nm_house_full
                    ,p_nm_fias_guid     := _rr.nm_fias_guid 
                    ,p_mode             := p_mode
                    ,p_bound_date       := p_bound_date       -- Только для режима Post обработки.
                    ,p_schema_hist_name := p_schema_hist_name
           );
        END LOOP;
        
        RAISE NOTICE 'Houses 0 (ak1). Bounds: % - %, qty = % ', (_z[1][1]), (_z[1][2]), _qty_0;
        RAISE NOTICE 'Houses 2 (nm_fias_guid). Bounds: % - %, qty = % ', (_z[1][1]), (_z[1][2]), _qty_2;
        
       _i := _i + 1;
       EXIT WHEN (_i > _arr_len);
     END LOOP;
  END;
$$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_check_twins (text, text, bigint [][], boolean, date, text) 
                   IS 'Постобработка, фильтрация дублей';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- SELECT * FROM unsi.adr_house WHERE(id_area = 78) AND (upper(nm_house_full::text)='Д. 100 ЛИТЕР АБ')
--                 AND (id_street= 1641)
-- SELECT gar_link.f_server_is();
-- SELECT * FROM gar_link.v_servers_active;
-- --------------------------------------------------------------------------
--   CALL gar_tmp_pcg_trans.p_adr_house_check_twins ('unnsi',gar_link.f_conn_set (3)
--          ,'{
--             {1100000000,1199000000}
--            ,{2400000000,2499000000}												   
--           }'
--   );
--
--           ,'{{2400000000,2499000000}
--             ,{7800000000,7899000000}
--             ,{3800000000,3899000000}

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_check_twins_1 (
                  text, text, boolean, date, text
 );  
-- 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_check_twins_1 (
        p_schema_name       text  
       ,p_conn_name         text  
       ,p_mode              boolean = FALSE -- Постобработка.
       ,p_bound_date        date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name  text = 'gar_tmp'             
)
    LANGUAGE plpgsql SECURITY DEFINER
  AS
$$
  -- ========================================================================
  --  2022-07-28 Функция фильтрующая дубли. Сканирует всю "unnsi.adr_house",
  --               требует неуникального индекса "adr_house_ak1".
  -- ========================================================================
  DECLARE
   _rr      record;
   _qty_1   integer;

   _select text := $_$
       WITH x (
                 id_house
                ,id_area
                ,id_street
                ,nm_house_full
                ,nm_fias_guid
                ,rn
       ) 
        AS (
             SELECT 
               id_house 
              ,id_area
              ,id_street
              ,nm_house_full
              ,nm_fias_guid
              ,(count (1) OVER (PARTITION BY id_area, upper (nm_house_full), id_street)) AS rn 
             FROM  %I.adr_house WHERE (id_data_etalon IS NULL)
         ) 
         , z (
                 id_house
                ,id_area
                ,id_street
                ,nm_house_full
                ,nm_fias_guid
            ) AS (
                   SELECT   
                           x.id_house
                          ,x.id_area
                          ,x.id_street
                          ,x.nm_house_full
                          ,x.nm_fias_guid
                   
                   FROM x WHERE (rn = 2) AND (nm_fias_guid IS NOT NULL)
            )
              SELECT DISTINCT ON (z.id_area, upper(z.nm_house_full), z.id_street) 
       
                 z.id_house
                ,z.id_area
                ,z.id_street
                ,z.nm_house_full
                ,z.nm_fias_guid
              
              FROM z;
   $_$;
   
   _exec text;
   
  BEGIN
    _qty_1 := 0;
    --
    _exec := format (_select, p_schema_name);
    --
    FOR _rr IN SELECT x1.* FROM gar_link.dblink (p_conn_name, _exec) 
          AS x1
            (
                 id_house      bigint
                ,id_area       bigint
                ,id_street     bigint 
                ,nm_house_full varchar(250)
                ,nm_fias_guid  uuid 
             )                             
     --                    
     LOOP
        EXIT WHEN (_rr.id_house IS NULL);
        --
        _qty_1 := _qty_1 + gar_tmp_pcg_trans.fp_adr_house_del_twin_1 (
                  p_schema_name       :=  p_schema_name 
                 ,p_id_house          :=  _rr.id_house     
                 ,p_id_area           :=  _rr.id_area      
                 ,p_id_street         :=  _rr.id_street    
                 ,p_nm_house_full     :=  _rr.nm_house_full
                 ,p_nm_fias_guid      :=  _rr.nm_fias_guid 
                 ,p_mode              :=  p_mode
                 ,p_bound_date        :=  p_bound_date       -- Только для режима Post обработки.
                 ,p_schema_hist_name  :=  p_schema_hist_name           
        );
     END LOOP;
       
     RAISE NOTICE 'Houses 1 (ak1). qty = % ', _qty_1;
       
  END;
$$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_check_twins_1 (text, text, boolean, date, text) 
                   IS 'Постобработка, фильтрация дублей';
-- ------------------------------------------------------------------------
--  USE CASE:
--  CALL gar_tmp_pcg_trans.p_adr_house_check_twins_1 (
--                         'unnsi'
--                       , gar_link.f_conn_set(10)
--                       , FALSE
--                       , '2022-01-01 00:00:00'
--                       , 'gar_tmp'
-- );
-- ------------------------------------------------------------------------


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_del_twin (
                  text, bigint, bigint, bigint, varchar(250), uuid, boolean 
 ); 
-- 
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_del_twin (
                  text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text 
 );   
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_del_twin (
        p_schema_name      text  
       ,p_id_house         bigint       --  NOT NULL
       ,p_id_area          bigint       --  NOT NULL
       ,p_id_street        bigint       --      NULL
       ,p_nm_house_full    varchar(250) --  NOT NULL
       ,p_nm_fias_guid     uuid
       ,p_mode             boolean = TRUE  -- используется в процессе обработки
                                 --  FALSE -- в постобработке.
       ,p_bound_date       date = '2022-01-01'::date -- Только для режима Post обработки.
       ,p_schema_hist_name text = 'gar_tmp'                     
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ---------------------------------------------------------------------------
    --  2022-02-28  Убираем дубли. 
    --  2022-02-28 Поиск близнецов. Два режима: 
    --    Поиск в процессе обработки, загрузочное индексное покрытие. 
    --    Поиск в после обработки, эксплуатационное индексное покрытие:
    --
    -- Используется технологический индекс (поиск в процессе обработки):
    --    UNIQUE INDEX _xxx_adr_house_ak1 ON unnsi.adr_house USING btree
    --                        (id_area ASC NULLS LAST
    --                        ,upper (nm_house_full::text) ASC NULLS LAST
    --                        ,id_street ASC NULLS LAST
    --                        ,id_house_type_1 ASC NULLS LAST
    --                        )
    --                    WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL)  
    -- ---------------------------------------------------------------------------
    --  2022-03-03  Двурежимная работа процедуры.
    --  Поиск в процессе постобработки, 
    --            используется индекс ""adr_house_ak1",  без уникальности 
    --
    --  INDEX adr_house_ak1
    --    ON unnsi.adr_house USING btree (id_area ASC NULLS LAST, upper(nm_house_full::text) ASC NULLS LAST
    --   , id_street ASC NULLS LAST)
    --    WHERE id_data_etalon IS NULL;
    -- ---------------------------------------------------------------------------
    --  2022-04-04 Постобработка, историческая запись должна содержать ссылку на 
    --             воздействующий субъект (id_data_etalon := id_house)
    -- ---------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _upd_id text = $_$
            UPDATE ONLY %I.adr_house SET  
            
                 id_area           = COALESCE (%L, id_area)::bigint               -- NOT NULL
                ,id_street         = COALESCE (%L, id_street)::bigint             --  NULL
                ,id_house_type_1   = COALESCE (%L, id_house_type_1)::integer      --  NULL
                ,nm_house_1        = COALESCE (%L, nm_house_1)::varchar(70)       --  NULL
                ,id_house_type_2   = %L::integer      -- COALESCE ( NULL , id_house_type_2)
                ,nm_house_2        = %L::varchar(50)  -- COALESCE ( NULL , nm_house_2)
                ,id_house_type_3   = %L::integer      -- COALESCE ( NULL , id_house_type_3)
                ,nm_house_3        = %L::varchar(50)  -- COALESCE ( NULL, nm_house_3)
                ,nm_zipcode        = COALESCE (%L, nm_zipcode)::varchar(20)       --  NULL
                ,nm_house_full     = COALESCE (%L, nm_house_full)::varchar(250)   -- NOT NULL
                ,kd_oktmo          = COALESCE (%L, kd_oktmo)::varchar(11)         --  NULL
                ,nm_fias_guid      = COALESCE (%L, nm_fias_guid)::uuid
                ,dt_data_del       = COALESCE (dt_data_del, %L)::timestamp without time zone              --  NULL
                ,id_data_etalon    = %L::bigint                                   --  NULL
                ,kd_okato          = COALESCE (%L, kd_okato)::varchar(11)         --  NULL
                ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric    --  NULL
                ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric    --  NULL
                    
            WHERE (id_house = %L::bigint);
        $_$;        
      --
      _upd_id_1 text = $_$
            UPDATE ONLY %I.adr_house SET  
            
                 id_area           = COALESCE (%L, id_area)::bigint               -- NOT NULL
                ,id_street         = COALESCE (%L, id_street)::bigint             --  NULL
                ,id_house_type_1   = COALESCE (%L, id_house_type_1)::integer      --  NULL
                ,nm_house_1        = COALESCE (%L, nm_house_1)::varchar(70)       --  NULL
                ,id_house_type_2   = %L::integer      -- COALESCE ( NULL , id_house_type_2)
                ,nm_house_2        = %L::varchar(50)  -- COALESCE ( NULL , nm_house_2)
                ,id_house_type_3   = %L::integer      -- COALESCE ( NULL , id_house_type_3)
                ,nm_house_3        = %L::varchar(50)  -- COALESCE ( NULL, nm_house_3)
                ,nm_zipcode        = COALESCE (%L, nm_zipcode)::varchar(20)       --  NULL
                ,nm_house_full     = COALESCE (%L, nm_house_full)::varchar(250)   -- NOT NULL
                ,kd_oktmo          = COALESCE (%L, kd_oktmo)::varchar(11)         --  NULL
                ,nm_fias_guid      = COALESCE (%L, nm_fias_guid)::uuid
                ,dt_data_del       = %L::timestamp without time zone              --  NULL
                ,id_data_etalon    = %L::bigint                                   --  NULL
                ,kd_okato          = COALESCE (%L, kd_okato)::varchar(11)         --  NULL
                ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric    --  NULL
                ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric    --  NULL
                    
            WHERE (id_house = %L::bigint);
        $_$;        
      -- 
       _select_u text = $_$
             SELECT h.* FROM ONLY %I.adr_house h WHERE (h.id_house = %L);
       $_$;
           --
       _del_twin  text = $_$             --        
              DELETE FROM ONLY %I.adr_house WHERE (id_house = %L);                     
       $_$;
       --
      _ins_hist text = $_$
             INSERT INTO %I.adr_house_hist (
                             id_house          -- bigint        NOT NULL
                            ,id_area           -- bigint        NOT NULL
                            ,id_street         -- bigint         NULL
                            ,id_house_type_1   -- integer        NULL
                            ,nm_house_1        -- varchar(70)    NULL
                            ,id_house_type_2   -- integer        NULL
                            ,nm_house_2        -- varchar(50)    NULL
                            ,id_house_type_3   -- integer        NULL
                            ,nm_house_3        -- varchar(50)    NULL
                            ,nm_zipcode        -- varchar(20)    NULL
                            ,nm_house_full     -- varchar(250)  NOT NULL
                            ,kd_oktmo          -- varchar(11)    NULL
                            ,nm_fias_guid      -- uuid           NULL 
                            ,dt_data_del       -- timestamp without time zone NULL
                            ,id_data_etalon    -- bigint        NULL
                            ,kd_okato          -- varchar(11)   NULL
                            ,vl_addr_latitude  -- numeric       NULL
                            ,vl_addr_longitude -- numeric       NULL
                            ,id_region         -- bigint
             )
               VALUES (   %L::bigint                   
                         ,%L::bigint                   
                         ,%L::bigint                    
                         ,%L::integer                  
                         ,%L::varchar(70)               
                         ,%L::integer                  
                         ,%L::varchar(50)               
                         ,%L::integer                  
                         ,%L::varchar(50)               
                         ,%L::varchar(20)  
                         ,%L::varchar(250)             
                         ,%L::varchar(11)               
                         ,%L::uuid
                         ,%L::timestamp without time zone
                         ,%L::bigint                   
                         ,%L::varchar(11)               
                         ,%L::numeric                  
                         ,%L::numeric  
                         ,%L::bigint
               ); 
        $_$;             
      -- -------------------------------------------------------------------------
      _sel_twin_proc  text = $_$
           SELECT * FROM ONLY %I.adr_house
               WHERE
                ((id_area = %L::bigint) AND 
                    (
                      (  -- На ОДНОЙ улице разные названия, UUIDs тождественны
                        (NOT (upper(nm_house_full::text) = upper (%L)::text)) AND
                        (id_street IS NOT DISTINCT FROM %L::bigint)  AND
                        (nm_fias_guid = %L::uuid)
                      )
                         OR
                      (     -- На РАЗНЫХ улицах одинаковые названия, UUIDs тождественны
                        (upper(nm_house_full::text) = upper (%L)::text) AND
                        (id_street IS DISTINCT FROM %L::bigint) AND 
                        (nm_fias_guid = %L::uuid)
                      )
                         OR
                      (   -- На ОДНОЙ улице одинаковые названия, UUIDs различаются
                        (upper(nm_house_full::text) = upper (%L)::text) AND
                        (id_street IS NOT DISTINCT FROM %L::bigint)  AND
                        (NOT (nm_fias_guid = %L::uuid))                   
                      )
                    ) 
                      AND 
                          ((id_data_etalon IS NULL) AND (dt_data_del IS NULL))    
                )
                
                OR -- Разные регионы (адресные пространства), одинаковые названия и UUID
                
                (((NOT (id_area = %L::bigint)) AND
                        (upper(nm_house_full::text) = upper (%L)::text) AND
                        (id_street IS NOT DISTINCT FROM %L::bigint) AND 
                        (nm_fias_guid = %L::uuid)
                 )
                     AND 
                 ((id_data_etalon IS NULL) AND (dt_data_del IS NULL))    
                );
       $_$;
       -- Различаются ID.      
      _sel_twin_post  text = $_$     
           SELECT * FROM ONLY %I.adr_house
                   -- В пределах одного региона, 
                   -- на ОДНОЙ улице одинаковые названия, разница в UUIDs не важна
                   --
               WHERE ((id_area = %L::bigint) AND    
                   (
                            (upper(nm_house_full::text) = upper (%L)::text) AND
                            (id_street IS NOT DISTINCT FROM %L::bigint)  AND
                            (NOT (id_house = %L::bigint))
                     
                   ) AND (id_data_etalon IS NULL) 
                );
                --
                -- Либо различные регионы, одинаковые UUIDs, разница в улицах не важна
                --
       $_$;
       --
      _rr    gar_tmp.adr_house_t; 
      _rr1   gar_tmp.adr_house_t; 
      
    BEGIN
     IF p_mode
       THEN -- Обработка
         _exec := format (_sel_twin_proc, p_schema_name
                             ,p_id_area
                              --
                             ,p_nm_house_full
                             ,p_id_street
                             ,p_nm_fias_guid
                              --
                             ,p_nm_house_full
                             ,p_id_street
                             ,p_nm_fias_guid
                             --
                             ,p_nm_house_full
                             ,p_id_street
                             ,p_nm_fias_guid
                             -- 2022-03-17
                             -- Разные регионы (адресные пространства), 
                             -- одинаковые названия и UUID
                             ,p_id_area
                              --
                             ,p_nm_house_full
                             ,p_id_street
                             ,p_nm_fias_guid
                                
         );
         EXECUTE _exec INTO _rr1; -- Поиск дублёра.             

         IF (_rr1.id_house IS NOT NULL) -- Найден
           THEN
             _exec = format (_upd_id, p_schema_name
                               ,_rr1.id_area          
                               ,_rr1.id_street        
                               ,_rr1.id_house_type_1  
                               ,_rr1.nm_house_1       
                               ,_rr1.id_house_type_2  
                               ,_rr1.nm_house_2       
                               ,_rr1.id_house_type_3  
                               ,_rr1.nm_house_3       
                               ,_rr1.nm_zipcode       
                               ,_rr1.nm_house_full    
                               ,_rr1.kd_oktmo         
                               ,_rr1.nm_fias_guid     
                               ,now()      
                               ,p_id_house  
                               ,_rr1.kd_okato         
                               ,_rr1.vl_addr_latitude 
                               ,_rr1.vl_addr_longitude
                                --   
                               ,_rr1.id_house               
               );
               EXECUTE _exec; -- Связали
           
         END IF; --  _rr1.id_house IS NOT NULL
             
       ELSE -- Постобработка
         _exec := format (_sel_twin_post, p_schema_name
                                ,p_id_area
                                 --
                                ,p_nm_house_full
                                ,p_id_street
                                 --
                                ,p_id_house
         );         
         EXECUTE _exec INTO _rr1; -- Поиск дублёра
         ----------------
         -- Двойники: см. определение выше
         --
         IF (_rr1.id_house IS NOT NULL) -- Найден. 
           THEN
            IF (_rr1.dt_data_del <=  p_bound_date) AND (_rr1.dt_data_del IS NOT NULL)
              THEN
                   _exec = format (_upd_id, p_schema_name
                                     ,_rr1.id_area          
                                     ,_rr1.id_street        
                                     ,_rr1.id_house_type_1  
                                     ,_rr1.nm_house_1       
                                     ,_rr1.id_house_type_2  
                                     ,_rr1.nm_house_2       
                                     ,_rr1.id_house_type_3  
                                     ,_rr1.nm_house_3       
                                     ,_rr1.nm_zipcode       
                                     ,_rr1.nm_house_full    
                                     ,_rr1.kd_oktmo         
                                     ,_rr1.nm_fias_guid     
                                     ,_rr1.dt_data_del      
                                     ,p_id_house  
                                     ,_rr1.kd_okato         
                                     ,_rr1.vl_addr_latitude 
                                     ,_rr1.vl_addr_longitude
                                      --   
                                     ,_rr1.id_house               
                     );
                     EXECUTE _exec; -- Связали.
            ELSE
               -- -----------------------------------------------------------------
               --  (dt_data_del >  p_bound_date) AND (dt_data_del IS NOT NULL) 
               --                   OR (dt_data_del IS NULL)
               -- -----------------------------------------------------------------
               -- Дублёр существует, он обновляется данными из проверяемой записи,
               -- проверяемая запись удаляется.
               -- -----------------------------------------------------------------
               _exec = format (_select_u, p_schema_name, p_id_house);
               EXECUTE _exec INTO _rr; -- проверяемая запись, полная структура.
               IF _rr.id_house IS NOT NULL 
                 THEN
                     _exec = format (_del_twin, p_schema_name, _rr.id_house);  
                     EXECUTE _exec;   -- Проверяемая запись
                     --
                     --    UPDATE _rr1 Обновление дублёра.
                     --    Старое значение уходит в историю
                     --
                     _exec := format (_ins_hist, p_schema_hist_name  
                                            --
                             ,_rr1.id_house  
                             ,_rr1.id_area           
                             ,_rr1.id_street         
                             ,_rr1.id_house_type_1   
                             ,_rr1.nm_house_1        
                             ,_rr1.id_house_type_2   
                             ,_rr1.nm_house_2        
                             ,_rr1.id_house_type_3   
                             ,_rr1.nm_house_3        
                             ,_rr1.nm_zipcode        
                             ,_rr1.nm_house_full     
                             ,_rr1.kd_oktmo          
                             ,_rr1.nm_fias_guid     -- 2022-04-04 
                             ,now()                 --    _rr1.dt_data_del     
                             ,_rr.id_house          --    _rr1.id_data_etalon     
                             ,_rr1.kd_okato          
                             ,_rr1.vl_addr_latitude  
                             ,_rr1.vl_addr_longitude
                             , -1 -- ID региона
                     ); 
                     EXECUTE _exec;
                     --      
                     --  Обновляется старое значение  ??? Сколько их ??
                     --
                     _exec = format (_upd_id_1, p_schema_name
                                     ,_rr.id_area          
                                     ,_rr.id_street        
                                     ,_rr.id_house_type_1  
                                     ,_rr.nm_house_1       
                                     ,_rr.id_house_type_2  
                                     ,_rr.nm_house_2       
                                     ,_rr.id_house_type_3  
                                     ,_rr.nm_house_3       
                                     ,_rr.nm_zipcode       
                                     ,_rr.nm_house_full    
                                     ,_rr.kd_oktmo         
                                     ,_rr.nm_fias_guid     
                                     ,NULL      
                                     ,NULL  
                                     ,_rr.kd_okato         
                                     ,_rr.vl_addr_latitude 
                                     ,_rr.vl_addr_longitude
                                      --  
                                     ,_rr1.id_house               
                     );
                     EXECUTE _exec;
               END IF; -- _rr.id_house IS NOT NULL
            END IF; -- (_rr1.dt_data_del <=  p_bound_date) AND (_rr1.dt_data_del IS NOT NULL)
         END IF; --  _rr1.id_house IS NOT NULL
     END IF; -- p_mode
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_del_twin 
    (text, bigint, bigint, bigint, varchar(250), uuid, boolean, date, text)
    IS 'Удаление/Слияние дублей';
-- ------------------------------------------------------------------------
--  USE CASE:
-- ------------------------------------------------------------------------
-- CALL gar_tmp_pcg_trans.p_adr_house_del_twin (
--               p_schema_name    := 'unnsi'  
--              ,p_id_house       := 2400298628   --  NOT NULL
--              ,p_id_area        := 32107        --  NOT NULL
--              ,p_id_street      := 353679       --      NULL
--              ,p_nm_house_full  := 'Д. 31Б/21'    --  NOT NULL
--              ,p_nm_fias_guid   := 'ba6461f5-8ea5-470d-a637-34cc42ea14ba'
-- );	
-- SELECT * FROM unnsi.adr_house WHERE ((id_area = 32107) AND 
--                                      (upper(nm_house_full::text) = 'Д. 31Б/21') AND (id_street=353679));
-- BEGIN;
-- UPDATE unnsi.adr_house SET dt_data_del = '2018-01-22 00:00:00' WHERE (id_house = 24026341);
-- COMMIT;
-- ROLLBACK;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_unload_data (text, bigint, text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_house_unload_data (
              p_schema_name   text       -- схема на отдалённом сервере
             ,p_id_region     bigint     -- Номер региона.
             ,p_conn          text       -- connection dblink
)

        RETURNS TABLE  (
                          id_house          bigint
                         ,id_area           bigint
                         ,id_street         bigint 
                         ,id_house_type_1   integer 
                         ,nm_house_1        varchar(70)
                         ,id_house_type_2   integer 
                         ,nm_house_2        varchar(50)
                         ,id_house_type_3   integer 
                         ,nm_house_3        varchar(50) 
                         ,nm_zipcode        varchar(20) 
                         ,nm_house_full     varchar(250)
                         ,kd_oktmo          varchar(11) 
                         ,nm_fias_guid      uuid 
                         ,dt_data_del       timestamp without time zone 
                         ,id_data_etalon    bigint 
                         ,kd_okato          varchar(11)
                         ,vl_addr_latitude  numeric 
                         ,vl_addr_longitude numeric 
        )
        LANGUAGE plpgsql
        SECURITY DEFINER        
 AS $$
  -- -------------------------------------------------------------------------------------
  --  2021-12-31/2022-01-28  Загрузка регионального фрагмента из ОТДАЛЁННОГО справочника 
  --                         адресов домов.
  -- -------------------------------------------------------------------------------------
  DECLARE
    _exec text;
    
    _select text = $_$
  
           WITH RECURSIVE aa1 (
                                 id_area_parent             
                                ,id_area 
                                 --
                                ,tree_d            
                                ,level_d
                                ,cicle_d                               
            
            ) AS (
                     SELECT 
                         x.id_area_parent   
                        ,x.id_area    
                         --
                        ,CAST (ARRAY [x.id_area] AS bigint []) 
                        ,1
                        ,FALSE
                       
                     FROM %I.adr_area x 
                   
                        WHERE(x.id_area_parent IS NULL) AND (x.id_area = %L) AND
           	              (x.dt_data_del IS NULL) AND (x.id_data_etalon IS NULL)
                   
                     UNION ALL
                     
                     SELECT 
                         x.id_area_parent   
                        ,x.id_area  
                       -- --	       
                        ,CAST (aa1.tree_d || x.id_area AS bigint [])
                        ,(aa1.level_d + 1) t
                        ,x.id_area = ANY (aa1.tree_d)               
                       
                     FROM %I.adr_area x  
                      
                       INNER JOIN aa1 ON (aa1.id_area = x.id_area_parent ) AND (NOT aa1.cicle_d)
                       
           	      WHERE (x.dt_data_del IS NULL) AND (x.id_data_etalon IS NULL)
            )
               SELECT  h.id_house            
                     , aa1.id_area                   
                     , h.id_street         
                     , h.id_house_type_1     
                     , h.nm_house_1         
                     , h.id_house_type_2    
                     , h.nm_house_2            
                     , h.id_house_type_3    
                     , h.nm_house_3          
                     , h.nm_zipcode          
                     , h.nm_house_full       
                     , h.kd_oktmo           
                     , h.nm_fias_guid       
                     , h.dt_data_del         
                     , h.id_data_etalon     
                     , h.kd_okato            
                     , h.vl_addr_latitude   
                     , h.vl_addr_longitude                
                     
               FROM aa1 
                   INNER JOIN %I.adr_house h ON (h.id_area = aa1.id_area)
              
               WHERE (h.dt_data_del IS NULL) AND (h.id_data_etalon IS NULL) AND 
                     (h.nm_fias_guid IS NOT NULL); 
    $_$;
  
  BEGIN
    _exec := format (_select, p_schema_name, p_id_region, p_schema_name, p_schema_name);            
    -- RAISE NOTICE '%', _exec;  
      
    RETURN QUERY
         SELECT x1.* FROM gar_link.dblink (p_conn, _exec) AS x1
          (
                  id_house          bigint
                 ,id_area           bigint
                 ,id_street         bigint 
                 ,id_house_type_1   integer 
                 ,nm_house_1        varchar(70)
                 ,id_house_type_2   integer 
                 ,nm_house_2        varchar(50)
                 ,id_house_type_3   integer 
                 ,nm_house_3        varchar(50) 
                 ,nm_zipcode        varchar(20) 
                 ,nm_house_full     varchar(250)
                 ,kd_oktmo          varchar(11) 
                 ,nm_fias_guid      uuid 
                 ,dt_data_del       timestamp without time zone 
                 ,id_data_etalon    bigint 
                 ,kd_okato          varchar(11)
                 ,vl_addr_latitude  numeric 
                 ,vl_addr_longitude numeric 
           ); 
    END;             
$$;
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_house_unload_data (text, bigint, text) IS
'Загрузка регионального фрагмента из ОТДАЛЁННОГО справочника адресов домов';
-- -----------------------------------------------------
-- USE CASE:
--      SELECT * FROM gar_tmp_pcg_trans.f_adr_house_unload_data ('unnsi'
-- 				, 52, (gar_link.f_conn_set (4))
-- 	);
-- -------------------------------------------------------------------
-- Successfully run. Total query runtime: 5 secs 701 msec.
-- 891734 rows affected.

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_object_unload_data (text, bigint, text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_object_unload_data (
              p_schema_name   text       -- схема на отдалённом сервере
             ,p_id_region     bigint     -- Номер региона.
             ,p_conn          text       -- connection dblink
)

        RETURNS TABLE  (
                  id_object         bigint 
                 ,id_area           bigint 
                 ,id_house          bigint 
                 ,id_object_type    integer
                 ,id_street         bigint 
                 ,nm_object         varchar(250)
                 ,nm_object_full    varchar(500)
                 ,nm_description    varchar(150)
                 ,dt_data_del       timestamp without time zone 
                 ,id_data_etalon    bigint 
                 ,id_metro_station  integer
                 ,id_autoroad       integer
                 ,nn_autoroad_km    numeric
                 ,nm_fias_guid      uuid 
                 ,nm_zipcode        varchar(20)
                 ,kd_oktmo          varchar(11)
                 ,kd_okato          varchar(11)
                 ,vl_addr_latitude  numeric
                 ,vl_addr_longitude numeric
        )
        LANGUAGE plpgsql
        SECURITY DEFINER        
 AS $$
  -- -------------------------------------------------------------------------------------
  --  2021-12-31/2022-01-28  Загрузка регионального фрагмента из ОТДАЛЁННОГО справочника 
  --                         адресных объектов.
  -- -------------------------------------------------------------------------------------
  DECLARE
    _exec text;
    
    _select text = $_$
  
             WITH RECURSIVE aa1 (
                                   id_area_parent             
                                  ,id_area 
                                   --
                                  ,tree_d            
                                  ,level_d
                                  ,cicle_d                               
              
              ) AS (
                       SELECT 
                           x.id_area_parent   
                          ,x.id_area    
                           --
                          ,CAST (ARRAY [x.id_area] AS bigint []) 
                          ,1
                          ,FALSE
                         
                       FROM %I.adr_area x 
                     
                          WHERE(x.id_area_parent IS NULL) AND (x.id_area = %L) AND
	         	              (x.dt_data_del IS NULL) AND (x.id_data_etalon IS NULL)
	                 
                       UNION ALL
                       
                       SELECT 
                           x.id_area_parent   
                          ,x.id_area  
                         -- --	       
                          ,CAST (aa1.tree_d || x.id_area AS bigint [])
                          ,(aa1.level_d + 1) t
                          ,x.id_area = ANY (aa1.tree_d)               
                         
                       FROM %I.adr_area x  
                        
                         INNER JOIN aa1 ON (aa1.id_area = x.id_area_parent ) AND (NOT aa1.cicle_d)
                         
	         	      WHERE (x.dt_data_del IS NULL) AND (x.id_data_etalon IS NULL)
              )
          
               SELECT 
                       r.id_object        
                      ,aa1.id_area          
                      ,r.id_house         
                      ,r.id_object_type   
                      ,r.id_street        
                      ,r.nm_object        
                      ,r.nm_object_full   
                      ,r.nm_description   
                      ,r.dt_data_del      
                      ,r.id_data_etalon   
                      ,r.id_metro_station 
                      ,r.id_autoroad      
                      ,r.nn_autoroad_km   
                      ,r.nm_fias_guid     
                      ,r.nm_zipcode       
                      ,r.kd_oktmo         
                      ,r.kd_okato         
                      ,r.vl_addr_latitude 
                      ,r.vl_addr_longitude 
                     
               FROM aa1 
                INNER JOIN %I.adr_objects r ON (r.id_area = aa1.id_area) 
                
                 WHERE (r.dt_data_del IS NULL) AND (r.id_data_etalon IS NULL) AND 
                       (r.id_house IS NOT NULL);
    $_$;
  
  BEGIN
    _exec := format (_select, p_schema_name, p_id_region, p_schema_name, p_schema_name);            
    --  RAISE NOTICE '%', _exec;  
	 
    RETURN QUERY
         SELECT x1.* FROM gar_link.dblink (p_conn, _exec) AS x1
          (
                  id_object         bigint 
                 ,id_area           bigint 
                 ,id_house          bigint 
                 ,id_object_type    integer
                 ,id_street         bigint 
                 ,nm_object         varchar(250)
                 ,nm_object_full    varchar(500)
                 ,nm_description    varchar(150)
                 ,dt_data_del       timestamp without time zone 
                 ,id_data_etalon    bigint 
                 ,id_metro_station  integer
                 ,id_autoroad       integer
                 ,nn_autoroad_km    numeric
                 ,nm_fias_guid      uuid 
                 ,nm_zipcode        varchar(20)
                 ,kd_oktmo          varchar(11)
                 ,kd_okato          varchar(11)
                 ,vl_addr_latitude  numeric
                 ,vl_addr_longitude numeric
           ); 
    END;             
$$;
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_object_unload_data (text, bigint, text) IS
'Загрузка регионального фрагмента из ОТДАЛЁННОГО справочника адресных объектов';
-- -----------------------------------------------------
-- USE CASE:
--      SELECT * FROM gar_tmp_pcg_trans.f_adr_object_unload_data ('unnsi'
-- 				, 52, (gar_link.f_conn_set ('c_unnsi_l', 'unnsi_nl'))
-- 	);
-- -------------------------------------------------------------------
-- Successfully run. Total query runtime: 6 secs 701 msec.
-- 6 secs 483 msec. 813177 rows affected.
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_area_ins (
                text, bigint, integer, varchar(120), varchar(4000), integer, bigint, integer
               ,smallint, varchar(11), uuid, bigint, varchar(11), varchar(20), varchar(15)
               ,numeric, numeric                        
);

DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_area_ins (
                text, text, bigint, integer, varchar(120), varchar(4000), integer, bigint, integer
               ,smallint, varchar(11), uuid, bigint, varchar(11), varchar(20), varchar(15)
               ,numeric, numeric, boolean                        
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_area_ins (
            p_schema_name        text  
           ,p_schema_h           text 
            --
           ,p_id_area            bigint            --  NOT NULL
           ,p_id_country         integer           --  NOT NULL
           ,p_nm_area            varchar(120)      --  NOT NULL
           ,p_nm_area_full       varchar(4000)     --  NOT NULL
           ,p_id_area_type       integer           --    NULL
           ,p_id_area_parent     bigint            --    NULL
           ,p_kd_timezone        integer           --    NULL
           ,p_pr_detailed        smallint          --  NOT NULL 
           ,p_kd_oktmo           varchar(11)       --    NULL
           ,p_nm_fias_guid       uuid              --    NULL
           ,p_id_data_etalon     bigint            --    NULL
           ,p_kd_okato           varchar(11)       --    NULL
           ,p_nm_zipcode         varchar(20)       --    NULL
           ,p_kd_kladr           varchar(15)       --    NULL
           ,p_vl_addr_latitude   numeric           --    NULL
           ,p_vl_addr_longitude  numeric           --    NULL 
           --
           ,p_sw                 boolean
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------
    --    2021-12-14  Создание записи в ОТДАЛЁННОМ справочнике  
    --                   адресных пространств
    --    2021-12-21  Переход на другие правила уникальности. .. да в дышло. 
    --    2022-02-09  Управляемая история
    --    2022-02-21  Опция ONLY 
    -- -------------------------------------------------------------------------
    --   2022-05-19 "Cause belli" - квартет "id_area", upper("nm_house_full",
    --  "id_street", "id_house_type_1" не обеспечивает уникальность кортежа,
    --   т.к два последних атрибута являются опциональными. В то-же время 
    --   работа начиналась в тот момент, когда уникальность "nm_fias_guid"
    --   не обеспечивалась. Это причина "исчезновения" значений "nm_fias_guid"
    --   при выполнения обновлений. 
    --  Ввожу: 
    --        + upd_id, 
    --        + отказываюсь от суррогатного генератора "gar_tmp.obj_hist_seq"
    --  В дальнейшем распространяю это на остальные фунции типа "_ins", "_upd"
    --  "adr_area", "adr_street". 
    -- -------------------------------------------------------------------------
    --   2022-05-31 COALESCE только для NOT NULL полей.    
    -- -------------------------------------------------------------------------    
    DECLARE
      _exec text;
      
      _ins text = $_$
               INSERT INTO %I.adr_area ( 
               
                            id_area           
                           ,id_country        
                           ,nm_area           
                           ,nm_area_full      
                           ,id_area_type      
                           ,id_area_parent    
                           ,kd_timezone       
                           ,pr_detailed   
                           ,dt_data_del 
                           ,kd_oktmo          
                           ,nm_fias_guid      
                           ,id_data_etalon    
                           ,kd_okato          
                           ,nm_zipcode        
                           ,kd_kladr          
                           ,vl_addr_latitude  
                           ,vl_addr_longitude 
               )
                 VALUES (   %L::bigint                     
                           ,%L::integer                    
                           ,%L::varchar(120)                
                           ,%L::varchar(4000)              
                           ,%L::integer                     
                           ,%L::bigint                     
                           ,%L::integer                     
                           ,%L::smallint  
                           ,%L::timestamp without time zone
                           ,%L::varchar(11)                 
                           ,%L::uuid                       
                           ,%L::bigint                     
                           ,%L::varchar(11)                 
                           ,%L::varchar(20)                
                           ,%L::varchar(15)                 
                           ,%L::numeric                    
                           ,%L::numeric                     
                 );      
              $_$;

      _ins_hist text = $_$
               INSERT INTO %I.adr_area_hist ( 
               
                            id_area           
                           ,id_country        
                           ,nm_area           
                           ,nm_area_full      
                           ,id_area_type      
                           ,id_area_parent    
                           ,kd_timezone       
                           ,pr_detailed   
                           ,dt_data_del 
                           ,kd_oktmo          
                           ,nm_fias_guid      
                           ,id_data_etalon    
                           ,kd_okato          
                           ,nm_zipcode        
                           ,kd_kladr          
                           ,vl_addr_latitude  
                           ,vl_addr_longitude
                           ,id_region
               )
                 VALUES (   %L::bigint                     
                           ,%L::integer                    
                           ,%L::varchar(120)                
                           ,%L::varchar(4000)              
                           ,%L::integer                     
                           ,%L::bigint                     
                           ,%L::integer                     
                           ,%L::smallint  
                           ,%L::timestamp without time zone
                           ,%L::varchar(11)                 
                           ,%L::uuid                       
                           ,%L::bigint                     
                           ,%L::varchar(11)                 
                           ,%L::varchar(20)                
                           ,%L::varchar(15)                 
                           ,%L::numeric                    
                           ,%L::numeric
                           ,%L::bigint
                 );      
              $_$;
              
        -- 2022-05-19/2022-05-31
      _upd_id text = $_$
            UPDATE ONLY %I.adr_area SET  
                 id_country     = COALESCE (%L, id_country    )::integer       -- NOT NULL  
                ,nm_area        = COALESCE (%L, nm_area       )::varchar(120)  -- NOT NULL
                ,nm_area_full   = COALESCE (%L, nm_area_full  )::varchar(4000) -- NOT NULL                         
                ,id_area_type   = %L::integer
                ,id_area_parent = %L::bigint
                 --
                ,kd_timezone  = %L::integer                               
                ,pr_detailed  = COALESCE (%L, pr_detailed )::smallint          -- NOT NULL                          
                ,kd_oktmo     = %L::varchar(11)  
                ,nm_fias_guid = %L::uuid
                
                ,dt_data_del    = %L::timestamp without time zone
                ,id_data_etalon = %L::bigint
                 --
                ,kd_okato          = %L::varchar(11)                           
                ,nm_zipcode        = %L::varchar(20)                           
                ,kd_kladr          = %L::varchar(15)                
                ,vl_addr_latitude  = %L::numeric                               
                ,vl_addr_longitude = %L::numeric                               
                    
            WHERE (id_area = %L::bigint);         
        $_$;          
        -- 2022-05-19/2022-05-31
        
      _rr  gar_tmp.adr_area_t;   

    BEGIN
    --
    --  2022-05-19 Значения "p_nm_fias_guid" нет в базе.
    --
       _exec := format (_ins, p_schema_name
                             ,p_id_area          
                             ,p_id_country       
                             ,p_nm_area          
                             ,p_nm_area_full     
                             ,p_id_area_type     
                             ,p_id_area_parent   
                             ,p_kd_timezone      
                             ,p_pr_detailed
                             ,NULL
                             ,p_kd_oktmo         
                             ,p_nm_fias_guid     
                             ,NULL -- p_id_data_etalon   
                             ,p_kd_okato         
                             ,p_nm_zipcode       
                             ,p_kd_kladr         
                             ,p_vl_addr_latitude 
                             ,p_vl_addr_longitude                           
       );            
       EXECUTE _exec;
    
    EXCEPTION  -- Возникает на отдалённом сервере    Повторяю сделанное ???        
       WHEN unique_violation THEN 
          BEGIN
            -- Сработала основная уникальность "ak1".
            _rr =  gar_tmp_pcg_trans.f_adr_area_get (
                                        p_schema_name, p_id_country, p_id_area_parent
                                       ,p_id_area_type, p_nm_area
            );
            --
            -- Старые значения с новым ID и признаком удаления
            IF (_rr.id_area IS NOT NULL)  
              THEN
                   _exec := format (_ins_hist, p_schema_h
                   
                               ,_rr.id_area        
                               ,_rr.id_country       
                               ,_rr.nm_area          
                               ,_rr.nm_area_full     
                               ,_rr.id_area_type     
                               ,_rr.id_area_parent   
                               ,_rr.kd_timezone      
                               ,_rr.pr_detailed  
                               , now()      --  dt_data_del
                               ,_rr.kd_oktmo         
                               ,_rr.nm_fias_guid   
                               ,_rr.id_area -- id_data_etalon   
                               ,_rr.kd_okato         
                               ,_rr.nm_zipcode       
                               ,_rr.kd_kladr         
                               ,_rr.vl_addr_latitude 
                               ,_rr.vl_addr_longitude 
                               ,0 -- Регион "0" - Исключение во время процесса дополнения.
                   );            
                   EXECUTE _exec; 
                  --
                  -- update, 2022-05-19
                  --
                  _exec := format (_upd_id, p_schema_name 
                                      ,p_id_country       
                                      ,p_nm_area          
                                      ,p_nm_area_full     
                                      ,p_id_area_type     
                                      ,p_id_area_parent
                                       --
                                      ,p_kd_timezone      
                                      ,p_pr_detailed   
                                      ,p_kd_oktmo         
                                      ,p_nm_fias_guid 
                                      --
                                      , NULL  -- dt_data_del
                                      , NULL  -- id_data_etalon
                                      ,p_kd_okato  
                                      ,p_nm_zipcode       
                                      ,p_kd_kladr         
                                      ,p_vl_addr_latitude 
                                      ,p_vl_addr_longitude
                                      --
                                      ,_rr.id_area
                  );            
                  EXECUTE _exec;   -- Возможна смена UUID.
            END IF; -- _rr.id_area IS NOT NULL
          END; -- unique_violation
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_area_ins ( 
                 text, text, bigint, integer, varchar(120), varchar(4000), integer, bigint, integer
                ,smallint, varchar(11), uuid, bigint, varchar(11), varchar(20), varchar(15)
                ,numeric, numeric, boolean 
               ) 
         IS 'Создание/Обновление записи в ОТДАЛЁННОМ справочнике адресных пространств';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_area_ins ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_area_ins ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_area_upd (
                text, bigint, integer, varchar(120), varchar(4000), integer, bigint, integer
               ,smallint, varchar(11), uuid, bigint, varchar(11), varchar(20), varchar(15)
               ,numeric, numeric 
               ,bigint
);
--
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_area_upd (
                text, text, bigint, integer, varchar(120), varchar(4000), integer, bigint, integer
               ,smallint, varchar(11), uuid, bigint, varchar(11), varchar(20), varchar(15)
               ,numeric, numeric 
               ,bigint, boolean
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_area_upd (
            p_schema_name        text  
           ,p_schema_h           text 
            --
           ,p_id_area            bigint         --  NOT NULL
           ,p_id_country         integer        --  NOT NULL
           ,p_nm_area            varchar(120)   --  NOT NULL
           ,p_nm_area_full       varchar(4000)  --  NOT NULL
           ,p_id_area_type       integer        --    NULL
           ,p_id_area_parent     bigint         --    NULL
           ,p_kd_timezone        integer        --    NULL
           ,p_pr_detailed        smallint       --  NOT NULL 
           ,p_kd_oktmo           varchar(11)    --    NULL
           ,p_nm_fias_guid       uuid           --    NULL
           ,p_id_data_etalon     bigint         --    NULL
           ,p_kd_okato           varchar(11)    --    NULL
           ,p_nm_zipcode         varchar(20)    --    NULL
           ,p_kd_kladr           varchar(15)    --    NULL
           ,p_vl_addr_latitude   numeric        --    NULL
           ,p_vl_addr_longitude  numeric        --    NULL 
           ,p_oper_type_id       bigint         -- Тип операции, с портала GAR-FIAS
           --
           ,p_sw                 boolean        -- Создаём историю, либо нет   
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------------
    --    2021-12-14  Создание/Обновление записи в ОТДАЛЁННОМ справочнике  
    --                   адресных пространств
    --    2021-12-21  p_oper_type_id = 20. Изменение. 
    --                  Проверяем на наличие нарушителей уникальности  
    --    2022-02-01  Расширенная обработка нарушения уникальности по второму индексу
    --    2022-02-10  Управление созданием истории.
    --    2022-02-21  Опция ONLY 
    -- -------------------------------------------------------------------------------
    --   2022-05-19 "Cause belli" - квартет "id_area", upper("nm_house_full",
    --  "id_street", "id_house_type_1" не обеспечивает уникальность кортежа,
    --   т.к два последних атрибута являются опциональными. В то-же время 
    --   работа начиналась в тот момент, когда уникальность "nm_fias_guid"
    --   не обеспечивалась. Это причина "исчезновения" значений "nm_fias_guid"
    --   при выполнения обновлений. 
    --  Ввожу: 
    --        + upd_id, 
    --        + отказываюсь от суррогатного генератора "gar_tmp.obj_hist_seq"
    --  В дальнейшем распространяю это на остальные фунции типа "_ins", "_upd"
    --  "adr_area", "adr_street". 
    -- -------------------------------------------------------------------------------
    --   2022-05-31 COALESCE только для NOT NULL полей.    
    -- -------------------------------------------------------------------------------     
    DECLARE
      _exec text;
      
      _ins_hist text = $_$
               INSERT INTO %I.adr_area_hist ( 
               
                            id_area           
                           ,id_country        
                           ,nm_area           
                           ,nm_area_full      
                           ,id_area_type      
                           ,id_area_parent    
                           ,kd_timezone       
                           ,pr_detailed   
                           ,dt_data_del 
                           ,kd_oktmo          
                           ,nm_fias_guid      
                           ,id_data_etalon    
                           ,kd_okato          
                           ,nm_zipcode        
                           ,kd_kladr          
                           ,vl_addr_latitude  
                           ,vl_addr_longitude
                           ,id_region
               )
                 VALUES (   %L::bigint                     
                           ,%L::integer                    
                           ,%L::varchar(120)                
                           ,%L::varchar(4000)              
                           ,%L::integer                     
                           ,%L::bigint                     
                           ,%L::integer                     
                           ,%L::smallint  
                           ,%L::timestamp without time zone
                           ,%L::varchar(11)                 
                           ,%L::uuid                       
                           ,%L::bigint                     
                           ,%L::varchar(11)                 
                           ,%L::varchar(20)                
                           ,%L::varchar(15)                 
                           ,%L::numeric                    
                           ,%L::numeric
                           ,%L::bigint
                 );      
              $_$;
      --
        -- 2022-05-19/2022-05-31
      _upd_id text = $_$
            UPDATE ONLY %I.adr_area SET  
                 id_country     = COALESCE (%L, id_country    )::integer       -- NOT NULL  
                ,nm_area        = COALESCE (%L, nm_area       )::varchar(120)  -- NOT NULL
                ,nm_area_full   = COALESCE (%L, nm_area_full  )::varchar(4000) -- NOT NULL                         
                ,id_area_type   = %L::integer
                ,id_area_parent = %L::bigint
                 --
                ,kd_timezone  = %L::integer                               
                ,pr_detailed  = COALESCE (%L, pr_detailed )::smallint          -- NOT NULL                          
                ,kd_oktmo     = %L::varchar(11)  
                ,nm_fias_guid = %L::uuid
                
                ,dt_data_del    = %L::timestamp without time zone
                ,id_data_etalon = %L::bigint
                 --
                ,kd_okato          = %L::varchar(11)                           
                ,nm_zipcode        = %L::varchar(20)                           
                ,kd_kladr          = %L::varchar(15)                
                ,vl_addr_latitude  = %L::numeric                               
                ,vl_addr_longitude = %L::numeric                               
                    
            WHERE (id_area = %L::bigint);         
        $_$;          
        -- 2022-05-19/2022-05-31
        
      _rr   gar_tmp.adr_area_t; 
      _rr1  gar_tmp.adr_area_t;   

      -- _nm_fias_guid uuid;
      
      -- 2022-02-01 -- Общий родитель, одинаковые UUID но различные названия.
      --               Ту запись, которая уже была, ПЕРЕМЕЩАЕМ в историю со значением ID_REGION = 0
      --               (удаляем её из базы).
      _select_twin  text = $_$
          SELECT * FROM ONLY %I.adr_area 
                              WHERE ((nm_fias_guid = %L) AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL));
      $_$;     
      
      _del_twins  text = $_$
          DELETE FROM ONLY %I.adr_area WHERE (id_area = %L); 
      $_$;        
      -- 2022-02-01   
      
    BEGIN
    --
    -- 2022-05-19  Значение "p_nm_fias_guid" уже присутсвует в БД.
    --        Четвёрка "id_country", "id_area_parent", "id_area_type", "nm_area" 
    --        может вызвать исключение.    
    --
     _rr :=  gar_tmp_pcg_trans.f_adr_area_get (p_schema_name, p_nm_fias_guid);
                                              
     IF (_rr.id_area IS NOT NULL)
       THEN
        IF 
          ((_rr.id_country     IS DISTINCT FROM p_id_country)     AND (p_id_country IS NOT NULL)) OR                 
          ((_rr.id_area_parent IS DISTINCT FROM p_id_area_parent)) OR  --  AND (p_id_area_parent IS NOT NULL)                
          ((_rr.id_area_type   IS DISTINCT FROM p_id_area_type))   OR  --  AND (p_id_area_type   IS NOT NULL)  
          ((upper(_rr.nm_area) IS DISTINCT FROM upper(p_nm_area)) AND (p_nm_area IS NOT NULL)) OR      
          -- 2022-01-28 
          ((_rr.nm_fias_guid   IS DISTINCT FROM p_nm_fias_guid)   AND (p_nm_fias_guid  IS NOT NULL)) OR 
          ((upper(_rr.nm_area_full) IS DISTINCT FROM upper(p_nm_area_full)) AND (p_nm_area_full IS NOT NULL)) OR
          
          ((_rr.kd_oktmo     IS DISTINCT FROM p_kd_oktmo    )) OR --  AND (p_kd_oktmo     IS NOT NULL)
          ((_rr.kd_okato     IS DISTINCT FROM p_kd_okato    )) OR --  AND (p_kd_okato     IS NOT NULL)
          ((_rr.nm_zipcode   IS DISTINCT FROM p_nm_zipcode  )) OR --  AND (p_nm_zipcode   IS NOT NULL)  
          ((_rr.kd_kladr     IS DISTINCT FROM p_kd_kladr    ))    --  AND (p_kd_kladr     IS NOT NULL)
         
        THEN
           IF p_sw
             THEN
                -- Старые значения с новым ID и признаком удаления
                _exec := format (_ins_hist, p_schema_h
                                      ,_rr.id_area       
                                      ,_rr.id_country       
                                      ,_rr.nm_area          
                                      ,_rr.nm_area_full     
                                      ,_rr.id_area_type     
                                      ,_rr.id_area_parent   
                                      ,_rr.kd_timezone      
                                      ,_rr.pr_detailed  
                                      , now()      --  dt_data_del
                                      ,_rr.kd_oktmo         
                                      ,_rr.nm_fias_guid     
                                      ,_rr.id_area -- id_data_etalon   
                                      ,_rr.kd_okato         
                                      ,_rr.nm_zipcode       
                                      ,_rr.kd_kladr         
                                      ,_rr.vl_addr_latitude 
                                      ,_rr.vl_addr_longitude 
                                      --
                                      , NULL  -- id_region
                );            
                EXECUTE _exec;               
           END IF; -- p_sw
            -- update,  
            --
           _exec := format (_upd_id, p_schema_name 
                                    ,p_id_country       
                                    ,p_nm_area          
                                    ,p_nm_area_full     
                                    ,p_id_area_type     
                                    ,p_id_area_parent  
                                    --
                                    ,p_kd_timezone      
                                    ,p_pr_detailed   
                                    ,p_kd_oktmo         
                                    ,p_nm_fias_guid   
                                    
                                    ,NULL -- dt_data_del
                                    ,NULL -- data_etalon
                                    
                                    ,p_kd_okato  
                                    ,p_nm_zipcode       
                                    ,p_kd_kladr         
                                    ,p_vl_addr_latitude 
                                    ,p_vl_addr_longitude
                                     --
                                    ,_rr.id_area 
           );                       
           EXECUTE _exec;
           
        END IF; -- compare
        
     END IF; -- _rr.id_area IS NOT NULL
      
    -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    EXCEPTION  -- Возникает на отдалённом сервере    
      -- UNIQUE INDEX _xxx_adr_area_ie2 ON unnsi.adr_area USING btree (nm_fias_guid ASC NULLS LAST) 
    
      WHEN unique_violation THEN 
       BEGIN
        -- _exec := format (_select_twin, p_schema_name, p_nm_fias_guid);
        -- EXECUTE _exec INTO _rr1;  -- Дублёр
        -- Допустим, что это будет возможным. 
        
        _rr =  gar_tmp_pcg_trans.f_adr_area_get (p_schema_name, p_nm_fias_guid);  -- Основная запись
        _rr1 =  gar_tmp_pcg_trans.f_adr_area_get (p_schema_name, p_id_country
                                            ,p_id_area_parent, p_id_area_type, p_nm_area
        );
        
        IF (_rr1.id_area IS NOT NULL) -- Записываем в историю и сохраняем в базе вне основного контекста..
           THEN
             _exec := format (_ins_hist, p_schema_h
             
                         ,_rr1.id_area       
                         ,_rr1.id_country       
                         ,_rr1.nm_area          
                         ,_rr1.nm_area_full     
                         ,_rr1.id_area_type     
                         ,_rr1.id_area_parent   
                         ,_rr1.kd_timezone      
                         ,_rr1.pr_detailed  
                         , now()      --  dt_data_del
                         ,_rr1.kd_oktmo         
                         ,_rr1.nm_fias_guid   
                         ,_rr1.id_area -- id_data_etalon   
                         ,_rr1.kd_okato         
                         ,_rr1.nm_zipcode       
                         ,_rr1.kd_kladr         
                         ,_rr1.vl_addr_latitude 
                         ,_rr1.vl_addr_longitude 
                         ,0 -- Регион "0" - Исключение во время процесса дополнения.
             );            
             EXECUTE _exec;      
             --
             --  _exec := format (_del_twins, p_schema_name, _rr1.id_area);
             --  EXECUTE _exec;
             --
             _exec := format (_upd_id, p_schema_name 
                                       ,_rr1.id_country       
                                       ,_rr1.nm_area          
                                       ,_rr1.nm_area_full     
                                       ,_rr1.id_area_type     
                                       ,_rr1.id_area_parent  
                                       --
                                       ,_rr1.kd_timezone      
                                       ,_rr1.pr_detailed   
                                       ,_rr1.kd_oktmo         
                                       ,_rr1.nm_fias_guid   
                                       
                                       ,now()       -- dt_data_del
                                       ,_rr.id_area -- data_etalon
                                       
                                       ,_rr1.kd_okato  
                                       ,_rr1.nm_zipcode       
                                       ,_rr1.kd_kladr         
                                       ,_rr1.vl_addr_latitude 
                                       ,_rr1.vl_addr_longitude
                                        --
                                       ,_rr1.id_area 
             );                       
             EXECUTE _exec;
        END IF; -- _rr1.id_area IS NOT NULL
        
        -- Поскольку процесс обновления прервался, повторяю его.
        -- Старые значения в историю, но сечас это управляется переключателем.
        --
        IF (_rr.id_area IS NOT NULL) AND (_rr1.id_area IS NOT NULL)
           THEN
             IF p_sw
               THEN
                  -- Старые значения с новым ID и признаком удаления
                  _exec := format (_ins_hist, p_schema_h
                                        ,_rr.id_area       
                                        ,_rr.id_country       
                                        ,_rr.nm_area          
                                        ,_rr.nm_area_full     
                                        ,_rr.id_area_type     
                                        ,_rr.id_area_parent   
                                        ,_rr.kd_timezone      
                                        ,_rr.pr_detailed  
                                        , now()      --  dt_data_del
                                        ,_rr.kd_oktmo         
                                        ,_rr.nm_fias_guid     
                                        ,_rr.id_area -- id_data_etalon   
                                        ,_rr.kd_okato         
                                        ,_rr.nm_zipcode       
                                        ,_rr.kd_kladr         
                                        ,_rr.vl_addr_latitude 
                                        ,_rr.vl_addr_longitude 
                                        --
                                        , NULL  -- id_region
                  );            
                  EXECUTE _exec;               
             END IF;
               
              -- update,  
             _exec := format (_upd_id, p_schema_name 
                                     ,p_id_country       
                                     ,p_nm_area          
                                     ,p_nm_area_full     
                                     ,p_id_area_type     
                                     ,p_id_area_parent  
                                     --
                                     ,p_kd_timezone      
                                     ,p_pr_detailed   
                                     ,p_kd_oktmo         
                                     ,p_nm_fias_guid   
                                      --
                                     ,NULL -- dt_data_del
                                     ,NULL -- data_etalon
                                      --
                                     ,p_kd_okato  
                                     ,p_nm_zipcode       
                                     ,p_kd_kladr         
                                     ,p_vl_addr_latitude 
                                     ,p_vl_addr_longitude
                                      --
                                     ,_rr.id_area 
             );                       
             EXECUTE _exec;             
        --
        END IF; -- _rr.id_area IS NOT NULL    
       END;  -- unique_violation
       -- +++++++++
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_area_upd 
               (text, text, bigint, integer, varchar(120), varchar(4000), integer, bigint, integer
               ,smallint, varchar(11), uuid, bigint, varchar(11), varchar(20), varchar(15)
               ,numeric, numeric,bigint, boolean
               ) 
         IS 'Обновление записи в ОТДАЛЁННОМ справочнике адресных пространств';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_area_upd ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_area_upd ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_ins (
                text, bigint, bigint, varchar(120), integer, varchar(255)      
               ,uuid, bigint, varchar(15), numeric, numeric                             
 ); 
 
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_ins (
                text, text, bigint, bigint, varchar(120), integer, varchar(255)      
               ,uuid, bigint, varchar(15), numeric, numeric, boolean                             
 );  
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_street_ins (
             p_schema_name       text  
            ,p_schema_h          text 
             --
            ,p_id_street         bigint        -- NOT NULL 
            ,p_id_area           bigint        -- NOT NULL 
            ,p_nm_street         varchar(120)  -- NOT NULL 
            ,p_id_street_type    integer       --  NULL 
            ,p_nm_street_full    varchar(255)  -- NOT NULL  
            ,p_nm_fias_guid      uuid          --  NULL 
            ,p_id_data_etalon    bigint        --  NULL 
            ,p_kd_kladr          varchar(15)   --  NULL  
            ,p_vl_addr_latitude  numeric       --  NULL 
            ,p_vl_addr_longitude numeric       --  NULL    
             --
            ,p_sw                boolean            
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ----------------------------------------------------------------------
    --    2021-12-14/2021-12-24/2022-01-27/2022-02-10
    --       Создание записи в ОТДАЛЁННОМ справочнике  адресов улиц
    -- ----------------------------------------------------------------------
    --   2022-02-21  Опция ONLY для UPDARE, DELETE, SELECT.
    --   2022-05-19 "Cause belli" - квартет "id_area", upper("nm_house_full",
    --  "id_street", "id_house_type_1" не обеспечивает уникальность кортежа,
    --   т.к два последних атрибута являются опциональными. В то-же время 
    --   работа начиналась в тот момент, когда уникальность "nm_fias_guid"
    --   не обеспечивалась. Это причина "исчезновения" значений "nm_fias_guid"
    --   при выполнения обновлений. 
    --  Ввожу: 
    --        + upd_id, 
    --        + отказываюсь от суррогатного генератора "gar_tmp.obj_hist_seq"
    --  В дальнейшем распространяю это на остальные фунции типа "_ins", "_upd"
    --  "adr_area", "adr_street".     
    -- ----------------------------------------------------------------------
    --  2022-05-31 COALESCE только для NOT NULL полей.    
    -- -----------------------------------------------------------------------    
    DECLARE
      _exec  text;
      
      _ins text = $_$
               INSERT INTO %I.adr_street (
                                  id_street
                                , id_area
                                , nm_street
                                , id_street_type
                                , nm_street_full
                                , nm_fias_guid
                                , dt_data_del
                                , id_data_etalon
                                , kd_kladr
                                , vl_addr_latitude
                                , vl_addr_longitude
               )
                 VALUES (   %L::bigint                    
                           ,%L::bigint                    
                           ,%L::varchar(120)               
                           ,%L::integer                   
                           ,%L::varchar(255)               
                           ,%L::uuid 
                           ,%L::timestamp without time zone
                           ,%L::bigint                     
                           ,%L::varchar(15)               
                           ,%L::numeric                    
                           ,%L::numeric                   
                 );      
              $_$;
              
     _ins_hist text = $_$
               INSERT INTO %I.adr_street_hist (
                                  id_street
                                , id_area
                                , nm_street
                                , id_street_type
                                , nm_street_full
                                , nm_fias_guid
                                , dt_data_del
                                , id_data_etalon
                                , kd_kladr
                                , vl_addr_latitude
                                , vl_addr_longitude
                                , id_region
               )
                 VALUES (   %L::bigint                    
                           ,%L::bigint                    
                           ,%L::varchar(120)               
                           ,%L::integer                   
                           ,%L::varchar(255)               
                           ,%L::uuid 
                           ,%L::timestamp without time zone
                           ,%L::bigint                     
                           ,%L::varchar(15)               
                           ,%L::numeric                    
                           ,%L::numeric    
                           ,%L::bigint
                 );      
              $_$;

      -- 2022-05-31        
      _upd_id text = $_$
            UPDATE ONLY %I.adr_street SET  
                  id_area           = COALESCE (%L, id_area  )::bigint                                 
                , nm_street         = COALESCE (%L, nm_street)::varchar(120)                       
                , id_street_type    = %L::integer                                
                , nm_street_full    = COALESCE (%L, nm_street_full)::varchar(255)                           
                , nm_fias_guid      = %L::uuid                        
                , dt_data_del       = %L::timestamp without time zone                      
                , id_data_etalon    = %L::bigint                      
                , kd_kladr          = %L::varchar(15)                 
                , vl_addr_latitude  = %L::numeric                     
                , vl_addr_longitude = %L::numeric                     
            WHERE (id_street = %L::bigint);        
       $_$;        
       -- 2022-05-31
        
      _rr  gar_tmp.adr_street_t;   
      
    BEGIN
    --
    --  2022-05-19 uuid нет в базе. Есть триада, определяющая уникальность AK
    --
      _exec := format (_ins, p_schema_name
                       ,p_id_street        
                       ,p_id_area          
                       ,p_nm_street        
                       ,p_id_street_type   
                       ,p_nm_street_full   
                       ,p_nm_fias_guid   
                       ,NULL  -- dt_data_del
                       ,NULL  -- p_id_data_etalon   
                       ,p_kd_kladr         
                       ,p_vl_addr_latitude 
                       ,p_vl_addr_longitude
      );            
      EXECUTE _exec;      
      
    EXCEPTION  -- Возникает на отдалённоми сервере, уникальность AK.            
       WHEN unique_violation THEN 
          BEGIN
            _rr =  gar_tmp_pcg_trans.f_adr_street_get (p_schema_name
                                    ,p_id_area, p_nm_street, p_id_street_type
            );
            IF (_rr.id_street IS NOT NULL) 
              THEN
                --
                -- Старые значения с новым ID и признаком удаления
                -----------------------------------------------
                _exec := format (_ins_hist, p_schema_h
                                 ,_rr.id_street       
                                 ,_rr.id_area          
                                 ,_rr.nm_street        
                                 ,_rr.id_street_type   
                                 ,_rr.nm_street_full   
                                 ,_rr.nm_fias_guid   
                                 ,now()          -- dt_data_del
                                 ,_rr.id_street  -- p_id_data_etalon   
                                 ,_rr.kd_kladr         
                                 ,_rr.vl_addr_latitude 
                                 ,_rr.vl_addr_longitude
                                 ,0 -- Регион "0" - Исключение во время процесса дополнения.
                );            
                EXECUTE _exec;    
            
                -- update,  
                _exec := format (_upd_id, p_schema_name
                                       ,p_id_area                       
                                       ,p_nm_street                 
                                       ,p_id_street_type                
                                       ,p_nm_street_full                
                                       ,p_nm_fias_guid
                                       --
                                       ,NULL -- nm_data_del                              
                                       ,NULL -- id_data_etalon
                                       --
                                       ,p_kd_kladr          
                                       ,p_vl_addr_latitude  
                                       ,p_vl_addr_longitude 
                                      
                                       ,_rr.id_street
                );
                EXECUTE _exec; -- Смена значения UUID
            
            END IF; -- _rr.id_street IS NOT NULL
 		  END;  -- unique_violation
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_ins (
                text, text, bigint, bigint, varchar(120), integer, varchar(255)      
               ,uuid, bigint, varchar(15), numeric, numeric, boolean
) IS 'Создание записи в ОТДАЛЁННОМ справочнике улиц';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_street_ins ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_street_ins ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);
-- ------------------------------------------------------------------------------------



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_upd (
                text, bigint, bigint, varchar(120), integer, varchar(255)      
               ,uuid, bigint, varchar(15), numeric, numeric, bigint                             
 ); 
 
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_upd (
                text, text, bigint, bigint, varchar(120), integer, varchar(255)      
               ,uuid, bigint, varchar(15), numeric, numeric, bigint, boolean                             
 ); 
 
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_upd (
                text, text, bigint, bigint, varchar(120), integer, varchar(255)      
               ,uuid, bigint, varchar(15), numeric, numeric, bigint, boolean, boolean                             
 );  
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_street_upd (
             p_schema_name        text  
            ,p_schema_h           text 
             --
            ,p_id_street         bigint        -- NOT NULL 
            ,p_id_area           bigint        -- NOT NULL 
            ,p_nm_street         varchar(120)  -- NOT NULL 
            ,p_id_street_type    integer       --  NULL 
            ,p_nm_street_full    varchar(255)  -- NOT NULL  
            ,p_nm_fias_guid      uuid          --  NULL 
            ,p_id_data_etalon    bigint        --  NULL 
            ,p_kd_kladr          varchar(15)   --  NULL  
            ,p_vl_addr_latitude  numeric       --  NULL 
            ,p_vl_addr_longitude numeric       --  NULL   
            ,p_oper_type_id      bigint        -- Тип операции, с портала GAR-FIAS  
             --
            ,p_sw     boolean -- Создаём историю, либо нет 
            ,p_duble  boolean -- Обязательное выявление дубликатов
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------------
    --   2021-12-14/2022-01-28
    --           Создание/Обновление записи в ОТДАЛЁННОМ справочнике улиц.
    --   2022-02-01  Расширенная обработка нарушения уникальности по второму индексу
    --   2022-02-21  Опция ONLY для UPDARE, DELETE, SELECT.
    --   2022-02-28  Дубликаты не удаляются
    -- -------------------------------------------------------------------------------
    --   2022-05-19 "Cause belli" - квартет "id_area", upper("nm_house_full",
    --  "id_street", "id_house_type_1" не обеспечивает уникальность кортежа,
    --   т.к два последних атрибута являются опциональными. В то-же время 
    --   работа начиналась в тот момент, когда уникальность "nm_fias_guid"
    --   не обеспечивалась. Это причина "исчезновения" значений "nm_fias_guid"
    --   при выполнения обновлений. 
    --  Ввожу: 
    --        + upd_id, 
    --        + отказываюсь от суррогатного генератора "gar_tmp.obj_hist_seq"
    --  В дальнейшем распространяю это на остальные фунции типа "_ins", "_upd"
    -- -------------------------------------------------------------------------------  
    --   2022-05-31 COALESCE только для NOT NULL полей.    
    -- ----------------------------------------------------------------------- ------
    
    DECLARE
      _exec    text;
      
      _ins_hist text = $_$
               INSERT INTO %I.adr_street_hist (
                                  id_street
                                , id_area
                                , nm_street
                                , id_street_type
                                , nm_street_full
                                , nm_fias_guid
                                , dt_data_del
                                , id_data_etalon
                                , kd_kladr
                                , vl_addr_latitude
                                , vl_addr_longitude
                                , id_region
               )
                 VALUES (   %L::bigint                    
                           ,%L::bigint                    
                           ,%L::varchar(120)               
                           ,%L::integer                   
                           ,%L::varchar(255)               
                           ,%L::uuid 
                           ,%L::timestamp without time zone
                           ,%L::bigint                     
                           ,%L::varchar(15)               
                           ,%L::numeric                    
                           ,%L::numeric    
                           ,%L::bigint
                 );      
              $_$;
              
      -- 2022-05-31        
      _upd_id text = $_$
            UPDATE ONLY %I.adr_street SET  
                  id_area           = COALESCE (%L, id_area  )::bigint                                 
                , nm_street         = COALESCE (%L, nm_street)::varchar(120)                       
                , id_street_type    = %L::integer                                
                , nm_street_full    = COALESCE (%L, nm_street_full)::varchar(255)                           
                , nm_fias_guid      = %L::uuid                        
                , dt_data_del       = %L::timestamp without time zone                      
                , id_data_etalon    = %L::bigint                      
                , kd_kladr          = %L::varchar(15)                 
                , vl_addr_latitude  = %L::numeric                     
                , vl_addr_longitude = %L::numeric                     
            WHERE (id_street = %L::bigint);        
       $_$;        
       -- 2022-05-31
        
       -- 2022-02-10 ---------------------------------------------------------
      _sel_twin text = $_$
            SELECT * FROM ONLY  %I.adr_street
                
            WHERE (id_area = %L::bigint) AND 
                  (NOT (upper(nm_street) = upper(%L)::text)) AND 
                  (id_street_type IS NOT DISTINCT FROM %L::integer) AND 
                  (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
       $_$;          
          --        (nm_fias_guid = %L::uuid) AND
        
       _del_twins  text = $_$       
           DELETE FROM ONLY %I.adr_street WHERE (id_street = %L);         
       $_$;    
       
       -- 2022-02-10 ---------------------------------------------------------
       
     _rr   gar_tmp.adr_street_t;
     _rr1  gar_tmp.adr_street_t; 
  
    BEGIN
      --
      --  2022-05-19. UUID существует в БД, значения триады образующие уникальность AK
      --        могут быть изменены.
      --
      _rr := gar_tmp_pcg_trans.f_adr_street_get (p_schema_name, p_nm_fias_guid);
      
      IF p_duble -- Обязательный поиск дублей   
        THEN
           _exec := format (_sel_twin, p_schema_name  
                                    ,p_id_area, p_nm_street, p_id_street_type                  
            );
            EXECUTE _exec INTO _rr1;
--                                    ,p_nm_fias_guid 
            --
            IF _rr1.id_street IS NOT NULL 
              THEN
                --   В историю, потом удалять
                 _exec := format (_ins_hist, p_schema_h
                                        ,_rr1.id_street    
                                        ,_rr1.id_area          
                                        ,_rr1.nm_street        
                                        ,_rr1.id_street_type   
                                        ,_rr1.nm_street_full   
                                        ,_rr1.nm_fias_guid   
                                        ,now()          --  dt_data_del
                                        ,_rr1.id_street  -- p_id_data_etalon   
                                        ,_rr1.kd_kladr         
                                        ,_rr1.vl_addr_latitude 
                                        ,_rr1.vl_addr_longitude
                                        --
                                        ,-1 --Признак принудительного поиска дублей
                 );            
                 EXECUTE _exec;
                 
                 -- _exec := format (_del_twins, p_schema_name, _rr1.id_street);
                 -- EXECUTE _exec; 
               
               _exec := format (_upd_id, p_schema_name
                      ,_rr1.id_area                       
                      ,_rr1.nm_street                 
                      ,_rr1.id_street_type                
                      ,_rr1.nm_street_full                
                      ,_rr1.nm_fias_guid
                      --
                      ,now()                              
                      ,_rr.id_street
                      --
                      ,_rr1.kd_kladr          
                      ,_rr1.vl_addr_latitude  
                      ,_rr1.vl_addr_longitude 
                     
                      ,_rr1.id_street
               );
               EXECUTE _exec;
                 
                 
            END IF; -- _rr1.id_street IS NOT NULL
      END IF; -- Обязательный поиск дублей 
    
      IF (_rr.id_street IS NOT NULL)  
        THEN  
             IF 
               -- 2022-05-31
               ((_rr.id_area               IS DISTINCT FROM p_id_area) AND (p_id_area IS NOT NULL)) OR
               ((upper(_rr.nm_street)      IS DISTINCT FROM upper(p_nm_street)) AND (p_nm_street IS NOT NULL)) OR
               ((_rr.id_street_type        IS DISTINCT FROM p_id_street_type)) OR  --  AND (p_id_street_type IS NOT NULL)
               ((upper(_rr.nm_street_full) IS DISTINCT FROM upper(p_nm_street_full)) AND (p_nm_street_full IS NOT NULL)) OR                
               --
               -- 2022-01-28
               ((_rr.nm_fias_guid IS DISTINCT FROM p_nm_fias_guid) AND (p_nm_fias_guid IS NOT NULL)) OR                
               -- 2022-01-28
               --
               ((_rr.kd_kladr IS DISTINCT FROM p_kd_kladr )) --  AND (p_kd_kladr IS NOT NULL) 
               -- 2022-05-31 
               THEN -- Сохраняю старые значения с новым ID     
                 
                IF p_sw 
                   THEN 
                    _exec := format (_ins_hist, p_schema_h
                                           ,_rr.id_street    
                                           ,_rr.id_area          
                                           ,_rr.nm_street        
                                           ,_rr.id_street_type   
                                           ,_rr.nm_street_full   
                                           ,_rr.nm_fias_guid   
                                           ,now()          --  dt_data_del
                                           ,_rr.id_street  -- p_id_data_etalon   
                                           ,_rr.kd_kladr         
                                           ,_rr.vl_addr_latitude 
                                           ,_rr.vl_addr_longitude
                                           --
                                           ,NULL
                    );            
                    EXECUTE _exec;
                END IF;
                    -- update, 
               _exec := format (_upd_id, p_schema_name
                      ,p_id_area                       
                      ,p_nm_street                 
                      ,p_id_street_type                
                      ,p_nm_street_full                
                      ,p_nm_fias_guid
                      --
                      ,NULL                              
                      ,NULL
                      --
                      ,p_kd_kladr          
                      ,p_vl_addr_latitude  
                      ,p_vl_addr_longitude 
                     
                      ,_rr.id_street
               );
               EXECUTE _exec;                    
                    
             END IF; -- compare
      END IF; -- rr.id_street IS NOT NULL  
     
    -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    EXCEPTION  -- Возникает на отдалённом сервере   
     --  UNIQUE INDEX _xxx_adr_street_ie2 ON unnsi.adr_street USING btree (nm_fias_guid ASC NULLS LAST)
     --    Ошибку могла дать триада "id_area", "nm_street", "id_street_type".
     
      WHEN unique_violation THEN 
        BEGIN
          _rr = gar_tmp_pcg_trans.f_adr_street_get (p_schema_name, p_nm_fias_guid);
          _rr1 = gar_tmp_pcg_trans.f_adr_street_get (p_schema_name
                                         , p_id_area, p_nm_street, p_id_street_type);
          ---
          --_exec := format (_sel_twin, p_schema_name, 
          --                       p_id_area, p_nm_street, p_id_street_type, p_nm_fias_guid
          --);   
          --EXECUTE _exec INTO _rr1;
          
          IF _rr1.id_street IS NOT NULL 
            THEN
            --   В историю, потом удалять
               _exec := format (_ins_hist, p_schema_h
                                      ,_rr1.id_street    
                                      ,_rr1.id_area          
                                      ,_rr1.nm_street        
                                      ,_rr1.id_street_type   
                                      ,_rr1.nm_street_full   
                                      ,_rr1.nm_fias_guid   
                                      ,now()          --  dt_data_del
                                      ,_rr1.id_street  -- p_id_data_etalon   
                                      ,_rr1.kd_kladr         
                                      ,_rr1.vl_addr_latitude 
                                      ,_rr1.vl_addr_longitude
                                      --
                                      ,0
               );            
               EXECUTE _exec;
               
               -- _exec := format (_del_twins, p_schema_name, _rr1.id_street);
               -- EXECUTE _exec;
            
               _exec := format (_upd_id, p_schema_name
                      ,_rr1.id_area                       
                      ,_rr1.nm_street                 
                      ,_rr1.id_street_type                
                      ,_rr1.nm_street_full                
                      ,_rr1.nm_fias_guid
                      --
                      ,now()                              
                      ,_rr.id_street
                      --
                      ,_rr1.kd_kladr          
                      ,_rr1.vl_addr_latitude  
                      ,_rr1.vl_addr_longitude 
                     
                      ,_rr1.id_street
               );
               EXECUTE _exec;
               
          END IF; -- 2022-02-10 -- _rr1.id_street IS NOT NULL 
                 
          -- Повторяем прерванную операцию.       
          IF (_rr.id_street IS NOT NULL) AND (_rr1.id_street IS NOT NULL) 
             THEN
              IF p_sw THEN  
                 --
                 -- Старые значения с новым ID и признаком удаления
                 -----------------------------------------------
                 _exec := format (_ins_hist, p_schema_h
                                  ,_rr.id_street        
                                  ,_rr.id_area          
                                  ,_rr.nm_street        
                                  ,_rr.id_street_type   
                                  ,_rr.nm_street_full   
                                  ,_rr.nm_fias_guid   
                                  ,now()          -- dt_data_del
                                  ,_rr.id_street  -- p_id_data_etalon   
                                  ,_rr.kd_kladr         
                                  ,_rr.vl_addr_latitude 
                                  ,_rr.vl_addr_longitude
                                  , NULL
                 );            
                 EXECUTE _exec;  
              END IF;
              
              -- update,  
              _exec := format (_upd_id, p_schema_name
                     ,p_id_area                       
                     ,p_nm_street                 
                     ,p_id_street_type                
                     ,p_nm_street_full                
                     ,p_nm_fias_guid
                     --
                     ,NULL -- p_dt_data_del                          
                     ,NULL -- p_id_data_etalon     
                     --
                     ,p_kd_kladr          
                     ,p_vl_addr_latitude  
                     ,p_vl_addr_longitude 
                    
                     ,_rr.id_street
              );
              EXECUTE _exec;              
              
          END IF;  -- COMPARE _rr. (_rr.id_street IS NOT NULL) AND (_rr1.id_street IS NOT NULL)             
 	    END; -- unique_violation	
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_upd (
               text, text, bigint, bigint, varchar(120), integer, varchar(255)      
               ,uuid, bigint, varchar(15), numeric, numeric, bigint, boolean, boolean
               ) 
         IS 'Обновление записи в ОТДАЛЁННОМ справочнике улиц';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_street_upd ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_street_upd ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);


     
 
      

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_ins (
                text,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                    ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                    ,uuid,bigint,varchar(11),numeric,numeric                             
 ); 
 
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_ins (
                  text, text
                 ,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                 ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                 ,uuid,bigint,varchar(11),numeric,numeric
                 ,bigint, boolean
 );   
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_ins (
                  text, text
                 ,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                 ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                 ,uuid,bigint,varchar(11),numeric,numeric
                 ,boolean
 );  
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_ins (
              p_schema_name        text  
             ,p_schema_h           text 
               --
             ,p_id_house           bigint       --  NOT NULL
             ,p_id_area            bigint       --  NOT NULL
             ,p_id_street          bigint       --   NULL
             ,p_id_house_type_1    integer      --   NULL
             ,p_nm_house_1         varchar(70)  --   NULL
             ,p_id_house_type_2    integer      --   NULL
             ,p_nm_house_2         varchar(50)  --   NULL
             ,p_id_house_type_3    integer      --   NULL
             ,p_nm_house_3         varchar(50)  --   NULL
             ,p_nm_zipcode         varchar(20)  --   NULL
             ,p_nm_house_full      varchar(250) --  NOT NULL
             ,p_kd_oktmo           varchar(11)  --   NULL
             ,p_nm_fias_guid       uuid         --   NULL 
             ,p_id_data_etalon     bigint       --  NULL
             ,p_kd_okato           varchar(11)  --  NULL
             ,p_vl_addr_latitude   numeric      --  NULL
             ,p_vl_addr_longitude  numeric      --  NULL 
              --
             ,p_sw  boolean              
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------
    --   2021-12-14/2022-01-28  
    --    Создание/Обновление записи в ОТДАЛЁННОМ справочнике  адресов домов.
    --   2022-02-07 Переход на базовые типы
    --   2022-02-11 История в отдельной схеме.
    --   2022-02-21 ONLY для UPDATE, DELETE, SELECT.
    --   2022-03-02 Возня с двойниками.
    -- -------------------------------------------------------------------------
    --   2022-05-19 "Cause belli" - квартет "id_area", upper("nm_house_full",
    --  "id_street", "id_house_type_1" не обеспечивает уникальность кортежа,
    --   т.к два последних атрибута являются опциональными. В то-же время 
    --   работа начиналась в тот момент, когда уникальность "nm_fias_guid"
    --   не обеспечивалась. Это причина "исчезновения" значений "nm_fias_guid"
    --   при выполнения обновлений. 
    --  Ввожу: 
    --        + upd_id, 
    --        + отказываюсь от суррогатного генератора "gar_tmp.obj_hist_seq"
    --  В дальнейшем распространяю это на остальные фунции типа "_ins", "_upd"
    -- ------------------------------------------------------------------------- 
    --  2022-05-31 COALESCE только для NOT NULL полей.    
    -- -------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      -- 2022-05-19/2022-05-31
      _upd_id text = $_$
            UPDATE ONLY %I.adr_house SET  
            
                 id_area           = COALESCE (%L, id_area)::bigint  -- NOT NULL
                ,id_street         = %L::bigint                      --     NULL
                ,id_house_type_1   = %L::integer                     --     NULL
                ,nm_house_1        = %L::varchar(70)                 --     NULL
                ,id_house_type_2   = %L::integer                     --     NULL
                ,nm_house_2        = %L::varchar(50)                 --     NULL
                ,id_house_type_3   = %L::integer                     --     NULL
                ,nm_house_3        = %L::varchar(50)                 --     NULL
                ,nm_zipcode        = %L::varchar(20)                 --     NULL
                ,nm_house_full     = COALESCE (%L, nm_house_full)::varchar(250)   -- NOT NULL
                ,kd_oktmo          = %L::varchar(11)                 --  NULL
                ,nm_fias_guid      = %L::uuid                        --  NULL
                ,dt_data_del       = %L::timestamp without time zone --  NULL
                ,id_data_etalon    = %L::bigint                      --  NULL
                ,kd_okato          = %L::varchar(11)                 --  NULL
                ,vl_addr_latitude  = %L::numeric                     --  NULL
                ,vl_addr_longitude = %L::numeric                     --  NULL
                    
            WHERE (id_house = %L::bigint);
        $_$;
      -- 2022-05-19/2022-05-31
      
      _ins text = $_$
               INSERT INTO %I.adr_house (
                               id_house          -- bigint        NOT NULL
                              ,id_area           -- bigint        NOT NULL
                              ,id_street         -- bigint         NULL
                              ,id_house_type_1   -- integer        NULL
                              ,nm_house_1        -- varchar(70)    NULL
                              ,id_house_type_2   -- integer        NULL
                              ,nm_house_2        -- varchar(50)    NULL
                              ,id_house_type_3   -- integer        NULL
                              ,nm_house_3        -- varchar(50)    NULL
                              ,nm_zipcode        -- varchar(20)    NULL
                              ,nm_house_full     -- varchar(250)  NOT NULL
                              ,kd_oktmo          -- varchar(11)    NULL
                              ,nm_fias_guid      -- uuid           NULL 
                              ,dt_data_del       -- timestamp without time zone NULL
                              ,id_data_etalon    -- bigint        NULL
                              ,kd_okato          -- varchar(11)   NULL
                              ,vl_addr_latitude  -- numeric       NULL
                              ,vl_addr_longitude -- numeric       NULL
               )
                 VALUES (   %L::bigint                   
                           ,%L::bigint                   
                           ,%L::bigint                    
                           ,%L::integer                  
                           ,%L::varchar(70)               
                           ,%L::integer                  
                           ,%L::varchar(50)               
                           ,%L::integer                  
                           ,%L::varchar(50)               
                           ,%L::varchar(20)  
                           ,%L::varchar(250)             
                           ,%L::varchar(11)               
                           ,%L::uuid
                           ,%L::timestamp without time zone
                           ,%L::bigint                   
                           ,%L::varchar(11)               
                           ,%L::numeric                  
                           ,%L::numeric                   
                 );      
              $_$;
      -- 2022-02-11
      _ins_hist text = $_$
               INSERT INTO %I.adr_house_hist (
                               id_house          -- bigint        NOT NULL
                              ,id_area           -- bigint        NOT NULL
                              ,id_street         -- bigint         NULL
                              ,id_house_type_1   -- integer        NULL
                              ,nm_house_1        -- varchar(70)    NULL
                              ,id_house_type_2   -- integer        NULL
                              ,nm_house_2        -- varchar(50)    NULL
                              ,id_house_type_3   -- integer        NULL
                              ,nm_house_3        -- varchar(50)    NULL
                              ,nm_zipcode        -- varchar(20)    NULL
                              ,nm_house_full     -- varchar(250)  NOT NULL
                              ,kd_oktmo          -- varchar(11)    NULL
                              ,nm_fias_guid      -- uuid           NULL 
                              ,dt_data_del       -- timestamp without time zone NULL
                              ,id_data_etalon    -- bigint        NULL
                              ,kd_okato          -- varchar(11)   NULL
                              ,vl_addr_latitude  -- numeric       NULL
                              ,vl_addr_longitude -- numeric       NULL
                              ,id_region         -- bigint  
               )
                 VALUES (   %L::bigint                   
                           ,%L::bigint                   
                           ,%L::bigint                    
                           ,%L::integer                  
                           ,%L::varchar(70)               
                           ,%L::integer                  
                           ,%L::varchar(50)               
                           ,%L::integer                  
                           ,%L::varchar(50)               
                           ,%L::varchar(20)  
                           ,%L::varchar(250)             
                           ,%L::varchar(11)               
                           ,%L::uuid
                           ,%L::timestamp without time zone
                           ,%L::bigint                   
                           ,%L::varchar(11)               
                           ,%L::numeric                  
                           ,%L::numeric                   
                           ,%L::bigint
                 );      
              $_$;
        -- 2022-02-11      
      --
      _rr  gar_tmp.adr_house_t;   
      
    BEGIN
     --
     --  2022-05-19 uuid нет в базе. Есть четвёрка, определяющая уникальность AK.
     --
      IF p_sw 
             THEN
                 CALL gar_tmp_pcg_trans.p_adr_house_del_twin (
                         p_schema_name   := p_schema_name
                        ,p_id_house      := p_id_house
                        ,p_id_area       := p_id_area
                        ,p_id_street     := p_id_street
                        ,p_nm_house_full := p_nm_house_full
                        ,p_nm_fias_guid  := p_nm_fias_guid
                        ,p_mode          := TRUE -- Обработка                        
                 );
      END IF;
      --
      _exec := format (_ins, p_schema_name
                            ,p_id_house          
                            ,p_id_area           
                            ,p_id_street         
                            ,p_id_house_type_1   
                            ,p_nm_house_1        
                            ,p_id_house_type_2   
                            ,p_nm_house_2        
                            ,p_id_house_type_3   
                            ,p_nm_house_3        
                            ,p_nm_zipcode        
                            ,p_nm_house_full     
                            ,p_kd_oktmo          
                            ,p_nm_fias_guid   
                            ,NULL -- p_dt_data_del
                            ,NULL -- p_id_data_etalon    
                            ,p_kd_okato          
                            ,p_vl_addr_latitude  
                            ,p_vl_addr_longitude 
      );            
      EXECUTE _exec;         
      
    EXCEPTION  -- Возникает на отдалённом сервере            
       WHEN unique_violation THEN 
         BEGIN
          -- 2022-05-19, создание записи, рассматриваемого UUID нет в базе.
          --   Сработала основная уникальность "ak1".
          _rr := gar_tmp_pcg_trans.f_adr_house_get (p_schema_name
                                                   ,p_id_area
                                                   ,p_nm_house_full
                                                   ,p_id_street
                                                   ,p_id_house_type_1
          );
     
          IF (_rr.id_house IS NOT NULL) 
            THEN
             -- Запоминаю всегда старые с новым ID, переключатель "p_sw" - игнорирую
             _exec := format (_ins_hist, p_schema_h
                                    --
                   ,_rr.id_house         
                   ,_rr.id_area           
                   ,_rr.id_street         
                   ,_rr.id_house_type_1   
                   ,_rr.nm_house_1        
                   ,_rr.id_house_type_2   
                   ,_rr.nm_house_2        
                   ,_rr.id_house_type_3   
                   ,_rr.nm_house_3        
                   ,_rr.nm_zipcode        
                   ,_rr.nm_house_full     
                   ,_rr.kd_oktmo          
                   ,_rr.nm_fias_guid   
                   ,now()             -- dt_data_del
                   ,_rr.id_house      -- id_data_etalon  
                   ,_rr.kd_okato          
                   ,_rr.vl_addr_latitude  
                   ,_rr.vl_addr_longitude 
                   --
                   ,0 -- Регион "0" - Исключение во время процесса дополнения.
             );            
             EXECUTE _exec; 
             -- ------------------------------------------------------------------------
             --  Продолжаю ранее прерванные операции. 
             --    update, используя атрибуты образующие уникальность отдельной записи.  
             --  2022-05-19 uuid однако. Используется существующий ID.
             -- ------------------------------------------------------------------------
             _exec = format (_upd_id, p_schema_name
                              ,p_id_area          
                              ,p_id_street        
                              ,p_id_house_type_1  
                              ,p_nm_house_1       
                              ,p_id_house_type_2  
                              ,p_nm_house_2       
                              ,p_id_house_type_3  
                              ,p_nm_house_3       
                              ,p_nm_zipcode       
                              ,p_nm_house_full    
                              ,p_kd_oktmo         
                              ,p_nm_fias_guid    
                              ,NULL -- p_dt_data_del      
                              ,NULL -- p_id_data_etalon   
                              ,p_kd_okato         
                              ,p_vl_addr_latitude 
                              ,p_vl_addr_longitude
                               --  
                              ,_rr.id_house               
              );
              EXECUTE _exec;  -- Результат - сменился UUID у записи.
              --
              IF p_sw
                THEN
                      CALL gar_tmp_pcg_trans.p_adr_house_del_twin (
                              p_schema_name   := p_schema_name
                             ,p_id_house      := p_id_house
                             ,p_id_area       := p_id_area
                             ,p_id_street     := p_id_street
                             ,p_nm_house_full := p_nm_house_full
                             ,p_nm_fias_guid  := p_nm_fias_guid
                             ,p_mode          := TRUE -- Обработка
                      );
              END IF; -- psw
          END IF; -- _rr.id_house IS NOT NULL
         END; -- unique_violation
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_ins (
                  text, text
                 ,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                 ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                 ,uuid,bigint,varchar(11),numeric,numeric
                 ,boolean                         
) 
         IS 'Создание записи в ОТДАЛЁННОМ справочнике адресов домов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_house_ins ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_house_ins ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_upd (
                text,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                    ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                    ,uuid,bigint,varchar(11),numeric,numeric
                    ,bigint
 );
 
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_upd (
                    text, bigint, bigint, bigint, integer, varchar(70), integer, varchar(50)
                  , integer, varchar(50), varchar(20), varchar(250), varchar(11)
                  , uuid, bigint, varchar(11), numeric, numeric, bigint
);
--
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_upd (
                 text, text
                ,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                ,uuid,bigint,varchar(11),numeric,numeric,bigint, boolean, boolean
 );
-- 
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_upd (
                 text, text
                ,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                ,uuid,bigint,varchar(11),numeric,numeric, boolean, boolean, boolean
 ); 
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.fp_adr_house_upd (
              p_schema_name        text   -- Схема с данными
             ,p_schema_h           text   -- Историческая схема
               --
             ,p_id_house           bigint       --  NOT NULL
             ,p_id_area            bigint       --  NOT NULL
             ,p_id_street          bigint       --   NULL
             ,p_id_house_type_1    integer      --   NULL
             ,p_nm_house_1         varchar(70)  --   NULL
             ,p_id_house_type_2    integer      --   NULL
             ,p_nm_house_2         varchar(50)  --   NULL
             ,p_id_house_type_3    integer      --   NULL
             ,p_nm_house_3         varchar(50)  --   NULL
             ,p_nm_zipcode         varchar(20)  --   NULL
             ,p_nm_house_full      varchar(250) --  NOT NULL
             ,p_kd_oktmo           varchar(11)  --   NULL
             ,p_nm_fias_guid       uuid         --   NULL 
             ,p_id_data_etalon     bigint       --  NULL
             ,p_kd_okato           varchar(11)  --  NULL
             ,p_vl_addr_latitude   numeric      --  NULL
             ,p_vl_addr_longitude  numeric      --  NULL 
             --
             ,p_sw    boolean -- Создаётся историческая запись.  
             ,p_duble boolean -- Обязательное выявление дубликатов
             ,p_del   boolean -- Убираю дубли при обработки EXCEPTION              
             
)
    RETURNS bigint[] 
    LANGUAGE plpgsql SECURITY DEFINER
    
    AS $$
    -- -----------------------------------------------------------------------------
    --  2021-12-14/2021-12-25/2022-01-27  
    --         Обновление записи в ОТДАЛЁННОМ справочнике адресов домов.
    --  2022-02-01  Расширенная обработка нарушения уникальности по второму индексу  
    --  2022-02-11  История в отдельной схеме
    --  2022-02-21   ONLY - UPDATE, DELETE, SELECT
    --  2022-02-28  Расширенный поиск дублей.
    -- ----------------------------------------------------------------------------
    --   2022-05-19 "Cause belli" - квартет "id_area", upper("nm_house_full",
    --  "id_street", "id_house_type_1" не обеспечивает уникальность кортежа,
    --   т.к два последних атрибута являются опциональными. В то-же время 
    --   работа начиналась в тот момент, когда уникальность "nm_fias_guid"
    --   не обеспечивалась. Это причина "исчезновения" значений "nm_fias_guid"
    --   при выполнения обновлений. 
    --  Ввожу: 
    --        + upd_id, 
    --        + отказываюсь от суррогатного генератора "gar_tmp.obj_hist_seq"
    --  В дальнейшем распространяю это на остальные фунции типа "_ins", "_upd"
    -- ----------------------------------------------------------------------------------- 
    --  2022-05-31 COALESCE только для NOT NULL полей.    
    -- -----------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _id_houses bigint[] := ARRAY[NULL, NULL]::bigint[]; 
         -- [1] - обработанный, [2] - двойник.
      
      _id_house_new  bigint;
      _id_house_hist bigint;
      --
      _ins_hist text = $_$
               INSERT INTO %I.adr_house_hist (
                               id_house          -- bigint        NOT NULL
                              ,id_area           -- bigint        NOT NULL
                              ,id_street         -- bigint         NULL
                              ,id_house_type_1   -- integer        NULL
                              ,nm_house_1        -- varchar(70)    NULL
                              ,id_house_type_2   -- integer        NULL
                              ,nm_house_2        -- varchar(50)    NULL
                              ,id_house_type_3   -- integer        NULL
                              ,nm_house_3        -- varchar(50)    NULL
                              ,nm_zipcode        -- varchar(20)    NULL
                              ,nm_house_full     -- varchar(250)  NOT NULL
                              ,kd_oktmo          -- varchar(11)    NULL
                              ,nm_fias_guid      -- uuid           NULL 
                              ,dt_data_del       -- timestamp without time zone NULL
                              ,id_data_etalon    -- bigint        NULL
                              ,kd_okato          -- varchar(11)   NULL
                              ,vl_addr_latitude  -- numeric       NULL
                              ,vl_addr_longitude -- numeric       NULL
                              ,id_region         -- bigint
               )
                 VALUES (   %L::bigint                   
                           ,%L::bigint                   
                           ,%L::bigint                    
                           ,%L::integer                  
                           ,%L::varchar(70)               
                           ,%L::integer                  
                           ,%L::varchar(50)               
                           ,%L::integer                  
                           ,%L::varchar(50)               
                           ,%L::varchar(20)  
                           ,%L::varchar(250)             
                           ,%L::varchar(11)               
                           ,%L::uuid
                           ,%L::timestamp without time zone
                           ,%L::bigint                   
                           ,%L::varchar(11)               
                           ,%L::numeric                  
                           ,%L::numeric  
                           ,%L::bigint
                 ) 
                    RETURNING id_house;      
              $_$;      
      --
      -- 2022-05-31
      _upd_id text = $_$
            UPDATE ONLY %I.adr_house SET  
            
                 id_area           = COALESCE (%L, id_area)::bigint  -- NOT NULL
                ,id_street         = %L::bigint                      --     NULL
                ,id_house_type_1   = %L::integer                     --     NULL
                ,nm_house_1        = %L::varchar(70)                 --     NULL
                ,id_house_type_2   = %L::integer                     --     NULL
                ,nm_house_2        = %L::varchar(50)                 --     NULL
                ,id_house_type_3   = %L::integer                     --     NULL
                ,nm_house_3        = %L::varchar(50)                 --     NULL
                ,nm_zipcode        = %L::varchar(20)                 --     NULL
                ,nm_house_full     = COALESCE (%L, nm_house_full)::varchar(250)   -- NOT NULL
                ,kd_oktmo          = %L::varchar(11)                 --  NULL
                ,nm_fias_guid      = %L::uuid                        --  NULL
                ,dt_data_del       = %L::timestamp without time zone --  NULL
                ,id_data_etalon    = %L::bigint                      --  NULL
                ,kd_okato          = %L::varchar(11)                 --  NULL
                ,vl_addr_latitude  = %L::numeric                     --  NULL
                ,vl_addr_longitude = %L::numeric                     --  NULL
                    
            WHERE (id_house = %L::bigint);
        $_$;
      -- 2022-05-31        
      --
      
       _del_twin  text = $_$             --  
           DELETE FROM ONLY %I.adr_house WHERE (id_house = %L);                 
       $_$;         
       
       _rr  gar_tmp.adr_house_t; 
       _rr1 gar_tmp.adr_house_t;
      
    BEGIN
     -- _rr := gar_tmp_pcg_trans.f_adr_house_get (p_schema_name
     --         , p_id_area, p_nm_house_full, p_id_street, p_id_house_type_1
     -- ); 
     -- 2022-05-19 Обновляюсь. Значимым явяляется UUID
     _rr := gar_tmp_pcg_trans.f_adr_house_get (p_schema_name, p_nm_fias_guid); 
     _id_house_new := _rr.id_house;
     
     IF p_duble -- Обязательный поиск дублей   
        THEN
                 CALL gar_tmp_pcg_trans.p_adr_house_del_twin (
                         p_schema_name   := p_schema_name
                        ,p_id_house      := _rr.id_house
                        ,p_id_area       := _rr.id_area
                        ,p_id_street     := _rr.id_street
                        ,p_nm_house_full := _rr.nm_house_full
                        ,p_nm_fias_guid  := _rr.nm_fias_guid
                        ,p_mode          := TRUE -- Обработка                           
                 );
        
     END IF; --- p_duble
     
     IF (_rr.id_house IS NOT NULL)  
       THEN  
          IF 
             -- 2022-05-31
             ((_rr.id_area         IS DISTINCT FROM p_id_area) AND (p_id_area IS NOT NULL)) OR
             ((_rr.id_street       IS DISTINCT FROM p_id_street)      ) OR -- AND (p_id_street       IS NOT NULL)
             ((_rr.id_house_type_1 IS DISTINCT FROM p_id_house_type_1)) OR -- AND (p_id_house_type_1 IS NOT NULL)
             ((_rr.id_house_type_2 IS DISTINCT FROM p_id_house_type_2)) OR -- AND (p_id_house_type_2 IS NOT NULL)
             ((_rr.id_house_type_3 IS DISTINCT FROM p_id_house_type_3)) OR -- AND (p_id_house_type_3 IS NOT NULL)
             --  2022-01-27
             ((_rr.nm_house_1 IS DISTINCT FROM p_nm_house_1)) OR           --  AND (p_nm_house_1 IS NOT NULL)
             ((_rr.nm_house_2 IS DISTINCT FROM p_nm_house_2)) OR           --  AND (p_nm_house_2 IS NOT NULL)
             ((_rr.nm_house_3 IS DISTINCT FROM p_nm_house_3)) OR           --  AND (p_nm_house_3 IS NOT NULL)
             --
             ((_rr.nm_fias_guid IS DISTINCT FROM p_nm_fias_guid) AND (p_nm_fias_guid IS NOT NULL)) OR
             --  2022-01-27                      
             ((upper(_rr.nm_house_full) IS DISTINCT FROM upper(p_nm_house_full)) AND (p_nm_house_full IS NOT NULL)) OR                  
             ((_rr.nm_zipcode      IS DISTINCT FROM p_nm_zipcode)) OR -- AND (p_nm_zipcode    IS NOT NULL)
             ((_rr.kd_oktmo        IS DISTINCT FROM p_kd_oktmo)  )    -- AND (p_kd_oktmo      IS NOT NULL)
             -- 2022-05-31
                
            THEN --> UPDATE
              -- Запоминаю старые с новым ID
              -- 2022-05-19 Без нового ID
              IF (p_sw) THEN 
                 _exec := format (_ins_hist, p_schema_h
                                        --
                         ,_rr.id_house    
                         ,_rr.id_area           
                         ,_rr.id_street         
                         ,_rr.id_house_type_1   
                         ,_rr.nm_house_1        
                         ,_rr.id_house_type_2   
                         ,_rr.nm_house_2        
                         ,_rr.id_house_type_3   
                         ,_rr.nm_house_3        
                         ,_rr.nm_zipcode        
                         ,_rr.nm_house_full     
                         ,_rr.kd_oktmo          
                         ,_rr.nm_fias_guid   
                         ,now()            -- p_dt_data_del
                         ,_rr.id_house     -- id_data_etalon 
                         ,_rr.kd_okato          
                         ,_rr.vl_addr_latitude  
                         ,_rr.vl_addr_longitude
                         , NULL
                 );            
                 EXECUTE _exec INTO _id_house_hist;
              END IF; -- -- p_sw   
              --
              --  Выполняю UPDATE  2022-05-19 UPDATE ID
              --
              _exec = format (_upd_id, p_schema_name
                              ,p_id_area          
                              ,p_id_street        
                              ,p_id_house_type_1  
                              ,p_nm_house_1       
                              ,p_id_house_type_2  
                              ,p_nm_house_2       
                              ,p_id_house_type_3  
                              ,p_nm_house_3       
                              ,p_nm_zipcode       
                              ,p_nm_house_full    
                              ,p_kd_oktmo         
                              ,p_nm_fias_guid     
                              ,NULL      
                              ,NULL  
                              ,p_kd_okato         
                              ,p_vl_addr_latitude 
                              ,p_vl_addr_longitude
                               --   
                              ,_rr.id_house               
              );
              EXECUTE _exec;  
            END IF; -- compare
        ELSE
             _id_house_new := NULL;
     END IF; -- rr.id_house IS NOT NULL  
   
     _id_houses [1] := _id_house_new;
     RETURN _id_houses;
     
    -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     EXCEPTION  -- Возникает на отдалённоми сервере    
     --
     -- UNIQUE INDEX _xxx_adr_house_ie2 ON gar_tmp.adr_house USING btree (nm_fias_guid ASC NULLS LAST)    
     --       всегда существует в БД.
     --
       WHEN unique_violation THEN 
         BEGIN
           _rr  := gar_tmp_pcg_trans.f_adr_house_get (p_schema_name, p_nm_fias_guid);
           _rr1 := gar_tmp_pcg_trans.f_adr_house_get (p_schema_name
                        , p_id_area, p_nm_house_full, p_id_street, p_id_house_type_1
           ); 
           IF (_rr1.id_house IS NOT NULL)
              THEN
                  -- Зловредный дубль
                _exec := format (_ins_hist, p_schema_h
                                       --
                                      ,_rr1.id_house    
                                      ,_rr1.id_area           
                                      ,_rr1.id_street         
                                      ,_rr1.id_house_type_1   
                                      ,_rr1.nm_house_1        
                                      ,_rr1.id_house_type_2   
                                      ,_rr1.nm_house_2        
                                      ,_rr1.id_house_type_3   
                                      ,_rr1.nm_house_3        
                                      ,_rr1.nm_zipcode        
                                      ,_rr1.nm_house_full     
                                      ,_rr1.kd_oktmo          
                                      ,_rr1.nm_fias_guid   
                                      ,now()            -- p_dt_data_del
                                      ,_rr1.id_house     -- id_data_etalon 
                                      ,_rr1.kd_okato          
                                      ,_rr1.vl_addr_latitude  
                                      ,_rr1.vl_addr_longitude
                                      , 0
                );            
                EXECUTE _exec INTO _id_house_hist;  
               ---------------------------------------------------------
               IF p_del -- иЗБАВЛЯЕМСЯ ОТ ДУБЛЕЙ.
                 THEN
                     _exec := format (_del_twin, p_schema_name, _rr1.id_house); -- ??
                     EXECUTE _exec;      -- Проверить функционал, удаляющий дубли.
                 ELSE    
                     _exec = format (_upd_id, p_schema_name
                                      ,_rr1.id_area          
                                      ,_rr1.id_street        
                                      ,_rr1.id_house_type_1  
                                      ,_rr1.nm_house_1       
                                      ,_rr1.id_house_type_2  
                                      ,_rr1.nm_house_2       
                                      ,_rr1.id_house_type_3  
                                      ,_rr1.nm_house_3       
                                      ,_rr1.nm_zipcode       
                                      ,_rr1.nm_house_full    
                                      ,_rr1.kd_oktmo         
                                      ,_rr1.nm_fias_guid     
                                      ,now()      
                                      ,_rr.id_house  
                                      ,_rr1.kd_okato         
                                      ,_rr1.vl_addr_latitude 
                                      ,_rr1.vl_addr_longitude
                                       --  
                                      ,_rr1.id_house               
                      );
                      EXECUTE _exec;
               END IF;  -- иЗБАВЛЯЕМСЯ ОТ ДУБЛЕЙ.
           END IF; -- _rr1.id_house IS NOT NULL
           --
           -- Повторяю прерванную операцию, от дублей избавился.
           IF (_rr.id_house IS NOT NULL) AND (_rr1.id_house IS NOT NULL)
             THEN
               IF p_sw THEN
                 --
                 -- Старые значения с новым ID и признаком удаления
                 -- 2022-05-19
                 -----------------------------------------------
                 _exec := format (_ins_hist, p_schema_h
                                        --
                                   ,_rr.id_house    
                                   ,_rr.id_area           
                                   ,_rr.id_street         
                                   ,_rr.id_house_type_1   
                                   ,_rr.nm_house_1        
                                   ,_rr.id_house_type_2   
                                   ,_rr.nm_house_2        
                                   ,_rr.id_house_type_3   
                                   ,_rr.nm_house_3        
                                   ,_rr.nm_zipcode        
                                   ,_rr.nm_house_full     
                                   ,_rr.kd_oktmo          
                                   ,_rr.nm_fias_guid   
                                   ,now()            -- p_dt_data_del
                                   ,_rr.id_house     -- id_data_etalon 
                                   ,_rr.kd_okato          
                                   ,_rr.vl_addr_latitude  
                                   ,_rr.vl_addr_longitude
                                   ,NULL
                 );            
                 EXECUTE _exec INTO _id_house_hist;      
               END IF;  -- p_sw  
               --
               -- update, используя атрибуты образующие уникальность-1 отдельной записи.  
               -- 
               _exec = format (_upd_id, p_schema_name
                                ,p_id_area          
                                ,p_id_street        
                                ,p_id_house_type_1  
                                ,p_nm_house_1       
                                ,p_id_house_type_2  
                                ,p_nm_house_2       
                                ,p_id_house_type_3  
                                ,p_nm_house_3       
                                ,p_nm_zipcode       
                                ,p_nm_house_full    
                                ,p_kd_oktmo         
                                ,p_nm_fias_guid     
                                ,NULL      
                                ,NULL  
                                ,p_kd_okato         
                                ,p_vl_addr_latitude 
                                ,p_vl_addr_longitude
                                 --  
                                ,_rr.id_house               
                );
               EXECUTE _exec;
               
             ELSE
                  _id_house_new := NULL;     
           END IF; -- compare _rr
          
           _id_houses [1] := _id_house_new; -- 2022-05-19 UUID цел, но остальные 
           RETURN _id_houses;               -- атрибуты образующие основную уникальность изменились. 
          
  	    END; -- unique_violation
    END;
  $$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.fp_adr_house_upd (
                 text, text
                ,bigint,bigint,bigint,integer,varchar(70),integer,varchar(50)     
                ,integer,varchar(50),varchar(20),varchar(250),varchar(11)
                ,uuid,bigint,varchar(11),numeric,numeric, boolean, boolean, boolean                          
) 
         IS 'Обновление записи в ОТДАЛЁННОМ справочнике адресов домов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.fp_adr_house_upd ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.fp_adr_house_upd ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_unload (text);
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_unload (text, bigint);

DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_unload (text, bigint, text);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_unload (
              p_schema_name   text  
             ,p_id_region     bigint
             ,p_conn          text       -- connection dblink             
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------------------
    --  2021-12-31/2022-01-28  Загрузка фрагмента из ОТДАЛЁННОГО справочника адресов домов.
    -- -------------------------------------------------------------------------------------
    BEGIN
      ALTER TABLE gar_tmp.adr_house DROP CONSTRAINT IF EXISTS pk_adr_house;
      ALTER TABLE gar_tmp.adr_house DROP CONSTRAINT IF EXISTS pk_tmp_adr_house;
      DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ak1;
      DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ie2;
      --
      DELETE FROM ONLY gar_tmp.adr_house;   -- 2022-02-17
      
      INSERT INTO gar_tmp.adr_house (
                             id_house           
                            ,id_area            
                            ,id_street          
                            ,id_house_type_1    
                            ,nm_house_1         
                            ,id_house_type_2    
                            ,nm_house_2         
                            ,id_house_type_3    
                            ,nm_house_3         
                            ,nm_zipcode         
                            ,nm_house_full      
                            ,kd_oktmo           
                            ,nm_fias_guid       
                            ,dt_data_del        
                            ,id_data_etalon     
                            ,kd_okato           
                            ,vl_addr_latitude   
                            ,vl_addr_longitude 
       ) 
          SELECT * FROM gar_tmp_pcg_trans.f_adr_house_unload_data (
                      p_schema_name
	     			 ,p_id_region
	     			 ,p_conn
 	     );           
      
      ALTER TABLE gar_tmp.adr_house ADD CONSTRAINT pk_adr_house PRIMARY KEY (id_house);
      
      CREATE UNIQUE INDEX IF NOT EXISTS _xxx_adr_house_ak1
          ON gar_tmp.adr_house USING btree
          ( id_area ASC NULLS LAST
           ,upper(nm_house_full::text) ASC NULLS LAST
           ,id_street ASC NULLS LAST
           ,id_house_type_1 ASC NULLS LAST           
          )
          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;
      
      CREATE UNIQUE INDEX IF NOT EXISTS _xxx_adr_house_ie2
          ON gar_tmp.adr_house USING btree
          (nm_fias_guid ASC NULLS LAST)
          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;      
      
    -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE WARNING 'P_ADR_HOUSE_LOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_unload (text, bigint, text) 
         IS 'Загрузка фрагмента ОТДАЛЁННОМ справочника адресов домов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--    CALL gar_tmp_pcg_trans.p_adr_house_unload (
--                                 'unnsi'
--                                , 52
--                                ,(gar_link.f_conn_set ('c_unnsi_l', 'unnsi_nl'))
-- );
--    SELECT count(1) AS qty_adr_house FROM gar_tmp.adr_house; -- 891734
-- 265508,950 мс (04:25,509)


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_upload (text, text); 
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_upload (text); 
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_upload (text, date); 

DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_upload (text, date, boolean); 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_upload (
              p_schema_name  text  
             ,p_date_proc    date = current_date
             ,p_del          boolean = FALSE -- В fp_adr_house убирались дубли при обработки EXCEPTION N 
                                             -- теперь убираю их в основной таблице 
           )
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- --------------------------------------------------------------------------
    --  2021-12-31 Обратная загрузка обработанного фрагмента ОТДАЛЁННОГО 
    --              справочника адресов домов.
    -- --------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _del_tw text = $_$
           WITH z (id_house) AS (
                 SELECT y.id_house FROM ONLY gar_tmp.adr_house y
                   UNION 
                 SELECT x.id_data_etalon FROM gar_tmp.adr_house_hist x 
                    WHERE ((date(x.dt_data_del) = %L) AND (x.id_region = 0)) 
           ) 
            DELETE FROM ONLY %I.adr_house h USING z WHERE (h.id_house = z.id_house);    
      $_$;
      
      _del text = $_$
         DELETE FROM ONLY %I.adr_house h USING ONLY gar_tmp.adr_house z 
                            WHERE (h.id_house = z.id_house);    
      $_$;      
      
      _ins text = $_$
                 INSERT INTO %I.adr_house 
                     SELECT 
                              h.id_house           
                             ,h.id_area            
                             ,h.id_street          
                             ,h.id_house_type_1    
                             ,h.nm_house_1         
                             ,h.id_house_type_2    
                             ,h.nm_house_2         
                             ,h.id_house_type_3    
                             ,h.nm_house_3         
                             ,h.nm_zipcode         
                             ,h.nm_house_full      
                             ,h.kd_oktmo           
                             ,h.nm_fias_guid       
                             ,h.dt_data_del        
                             ,h.id_data_etalon     
                             ,h.kd_okato           
                             ,h.vl_addr_latitude   
                             ,h.vl_addr_longitude  
                     FROM ONLY gar_tmp.adr_house h;
      $_$;			   

    BEGIN
      -- ALTER TABLE %I.adr_objects ADD CONSTRAINT adr_objects_pkey PRIMARY KEY (id_object);
      -- DROP INDEX IF EXISTS %I._xxx_adr_objects_ak1;
      -- DROP INDEX IF EXISTS %I._xxx_adr_objects_ie2;
      --  + Остальные индексы, для таблицы объектов на отдалённом сервере.
      --  dblink-функционал.
      --
      IF p_del 
        THEN
              _exec := format (_del_tw, p_date_proc, p_schema_name);
        ELSE
              _exec := format (_del, p_schema_name); 
      END IF;
	  -- RAISE NOTICE '%', _exec;
      EXECUTE _exec;  
      --
      _exec := format (_ins, p_schema_name);   
	  -- RAISE NOTICE '%', _exec;      
      EXECUTE _exec;  
      --
      -- + Далее отдалённо, восстанавливается индексное покрытие.     
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE WARNING 'P_ADR_OBJECT_LOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_upload (text, date, boolean) 
   IS 'Обратная загрузка обработанного фрагмента ОТДАЛЁННОГО справочника адресов домов.';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_house_upload ('unnsi');
--     CALL gar_tmp_pcg_trans.p_adr_house_upload ('unsi', current_date);
--     CALL gar_tmp_pcg_trans.p_adr_house_upload ('unsi', current_date, false);
--     CALL gar_tmp_pcg_trans.p_adr_house_upload ('unsi', current_date, true);


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_ins (
                text, bigint, bigint, bigint, integer, bigint, varchar(250), varchar(500), varchar(150) 
                     ,bigint, integer, integer, numeric, uuid, varchar(20), varchar(11), varchar(11)
                     ,numeric, numeric                           
 ); 
--
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_ins (
                 text, text
                ,bigint, bigint, bigint, integer, bigint, varchar(250), varchar(500), varchar(150) 
                ,bigint, integer, integer, numeric, uuid, varchar(20), varchar(11), varchar(11)
                ,numeric, numeric, boolean                           
 ); 
 CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_object_ins (
              p_schema_name        text  
             ,p_schema_h           text 
               --
             ,p_id_object         bigint       --  NOT NULL
             ,p_id_area           bigint       --  NOT NULL
             ,p_id_house          bigint       --      NULL
             ,p_id_object_type    integer      --  NOT NULL
             ,p_id_street         bigint       --      NULL
             ,p_nm_object         varchar(250) --      NULL
             ,p_nm_object_full    varchar(500) --  NOT NULL
             ,p_nm_description    varchar(150) --      NULL
             ,p_id_data_etalon    bigint       --      NULL
             ,p_id_metro_station  integer      --      NULL
             ,p_id_autoroad       integer      --      NULL
             ,p_nn_autoroad_km    numeric      --      NULL
             ,p_nm_fias_guid      uuid         --      NULL
             ,p_nm_zipcode        varchar(20)  --      NULL
             ,p_kd_oktmo          varchar(11)  --      NULL
             ,p_kd_okato          varchar(11)  --      NULL
             ,p_vl_addr_latitude  numeric      --      NULL
             ,p_vl_addr_longitude numeric      --      NULL
             --
             ,p_sw  boolean                
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ------------------------------------------------------------------------------------
    --   2021-12-17 Создание/Обновление записи в ОТДАЛЁННОМ справочнике адресных объектов
    --   2022-02-07 Переход на базовые типы.
    --   2022-02-11 История в отдельной схеме.
    --   2022-02-21 ONLY для UPDATE, SELECT, DELETE.
    -- ------------------------------------------------------------------------------------
    DECLARE
      _exec text;
     
      _ins text = $_$
               INSERT INTO %I.adr_objects (
                              id_object        --  NOT NULL
                             ,id_area          --  NOT NULL
                             ,id_house         --      NULL
                             ,id_object_type   --  NOT NULL
                             ,id_street        --      NULL
                             ,nm_object        --      NULL
                             ,nm_object_full   --  NOT NULL
                             ,nm_description   --      NULL
                             ,dt_data_del      --      NULL    
                             ,id_data_etalon   --      NULL
                             ,id_metro_station --      NULL
                             ,id_autoroad      --      NULL
                             ,nn_autoroad_km   --      NULL
                             ,nm_fias_guid     --      NULL
                             ,nm_zipcode       --      NULL
                             ,kd_oktmo         --      NULL
                             ,kd_okato         --      NULL
                             ,vl_addr_latitude --      NULL
                             ,vl_addr_longitude --      NULL
               )
                 VALUES (   %L::bigint                  
                           ,%L::bigint                  
                           ,%L::bigint                   
                           ,%L::integer                 
                           ,%L::bigint                   
                           ,%L::varchar(250)            
                           ,%L::varchar(500)             
                           ,%L::varchar(150)   
                           ,%L::timestamp without time zone
                           ,%L::bigint                   
                           ,%L::integer     
                           ,%L::integer                 
                           ,%L::numeric                  
                           ,%L::uuid                    
                           ,%L::varchar(20)             
                           ,%L::varchar(11)              
                           ,%L::varchar(11)             
                           ,%L::numeric                  
                           ,%L::numeric                 
                 );      
              $_$;
              
      -- 2022-02-11
      _ins_hist text = $_$
               INSERT INTO %I.adr_objects_hist (
                              id_object        --  NOT NULL
                             ,id_area          --  NOT NULL
                             ,id_house         --      NULL
                             ,id_object_type   --  NOT NULL
                             ,id_street        --      NULL
                             ,nm_object        --      NULL
                             ,nm_object_full   --  NOT NULL
                             ,nm_description   --      NULL
                             ,dt_data_del      --      NULL    
                             ,id_data_etalon   --      NULL
                             ,id_metro_station --      NULL
                             ,id_autoroad      --      NULL
                             ,nn_autoroad_km   --      NULL
                             ,nm_fias_guid     --      NULL
                             ,nm_zipcode       --      NULL
                             ,kd_oktmo         --      NULL
                             ,kd_okato         --      NULL
                             ,vl_addr_latitude --      NULL
                             ,vl_addr_longitude --     NULL
                             ,id_region
               )
                 VALUES (   %L::bigint                  
                           ,%L::bigint                  
                           ,%L::bigint                   
                           ,%L::integer                 
                           ,%L::bigint                   
                           ,%L::varchar(250)            
                           ,%L::varchar(500)             
                           ,%L::varchar(150)   
                           ,%L::timestamp without time zone
                           ,%L::bigint                   
                           ,%L::integer     
                           ,%L::integer                 
                           ,%L::numeric                  
                           ,%L::uuid                    
                           ,%L::varchar(20)             
                           ,%L::varchar(11)              
                           ,%L::varchar(11)             
                           ,%L::numeric                  
                           ,%L::numeric
                           ,%L::bigint
                 );      
              $_$;
              -- 2022-02-11
              
      _upd text = $_$
                      UPDATE ONLY %I.adr_objects SET  
                      
                              ,nm_object         = COALESCE (%L, nm_object     )::varchar(250)    --  NULL
                              ,nm_description    = COALESCE (%L, nm_description)::varchar(150)    --  NULL
                              ,dt_data_del       = %L::timestamp without time zone  --  NULL
                              ,id_data_etalon    = %L::bigint                       --  NULL
                              ,id_metro_station  = COALESCE (%L, id_metro_station )::integer         -- NOT NULL
                              ,id_autoroad       = COALESCE (%L, id_autoroad      )::integer         --  NULL
                              ,nn_autoroad_km    = COALESCE (%L, nn_autoroad_km   )::numeric         
                              ,nm_fias_guid      = COALESCE (%L, nm_fias_guid     )::uuid            --  NULL
                              ,nm_zipcode        = COALESCE (%L, nm_zipcode       )::varchar(20)     --  NULL
                              ,kd_oktmo          = COALESCE (%L, kd_oktmo         )::varchar(11)     --  NULL
                              ,kd_okato          = COALESCE (%L, kd_okato         )::varchar(11)     --  NULL          
                              ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric         --  NULL
                              ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric         --  NULL
                                                        
                      WHERE ((id_area = %L) AND (id_object_type = %L) AND 
                             (upper(nm_object_full::text) = upper(%L)) AND
                             (id_street IS NOT DISTINCT FROM  %L) AND 
                             (id_house IS NOT DISTINCT FROM %L) AND 
                             (id_data_etalon IS NULL) AND (dt_data_del IS NULL)
                            );   
        $_$;  

      _rr  gar_tmp.adr_objects_t;   
      
    BEGIN
      _exec := format (_ins, p_schema_name
                       ,p_id_object         --  bigint       --  NOT NULL
                       ,p_id_area           --  bigint       --  NOT NULL
                       ,p_id_house          --  bigint       --      NULL
                       ,p_id_object_type    --  integer      --  NOT NULL
                       ,p_id_street         --  bigint       --      NULL
                       ,p_nm_object         --  varchar(250) --      NULL
                       ,p_nm_object_full    --  varchar(500) --  NOT NULL
                       ,p_nm_description    --  varchar(150) --      NULL
                       ,NULL                -- 
                       ,NULL                --  id_data_etalon    --  bigint       --      NULL
                       ,p_id_metro_station  --  integer      --      NULL
                       ,p_id_autoroad       --  integer      --      NULL
                       ,p_nn_autoroad_km    --  numeric      --      NULL
                       ,p_nm_fias_guid      --  uuid         --      NULL
                       ,p_nm_zipcode        --  varchar(20)  --      NULL
                       ,p_kd_oktmo          --  varchar(11)  --      NULL
                       ,p_kd_okato          --  varchar(11)  --      NULL
                       ,p_vl_addr_latitude  --  numeric      --      NULL
                       ,p_vl_addr_longitude --  numeric      --      NULL
      );            
      EXECUTE _exec;

    EXCEPTION  -- Возникает на отдалённом сервере            
       WHEN unique_violation THEN 
        BEGIN
          _rr := gar_tmp_pcg_trans.f_adr_object_get (p_schema_name, p_id_area, p_id_object_type
                                   ,p_nm_object_full , p_id_street, p_id_house
          ); 
           
          IF (_rr.id_object IS NOT NULL) 
            THEN 
                  -- Запоминаю старые с новым ID
                  _exec := format (_ins_hist, p_schema_h
                  
                         ,nextval ('gar_tmp.obj_hist_seq')       --  bigint    --  NOT NULL
                         ,_rr.id_area           --  bigint       --  NOT NULL
                         ,_rr.id_house          --  bigint       --      NULL
                         ,_rr.id_object_type    --  integer      --  NOT NULL
                         ,_rr.id_street         --  bigint       --      NULL
                         ,_rr.nm_object         --  varchar(250) --      NULL
                         ,_rr.nm_object_full    --  varchar(500) --  NOT NULL
                         ,_rr.nm_description    --  varchar(150) --      NULL
                         ,now()
                         ,_rr.id_object        -- id_data_etalon    --  bigint       --      NULL
                         ,_rr.id_metro_station  --  integer      --      NULL
                         ,_rr.id_autoroad       --  integer      --      NULL
                         ,_rr.nn_autoroad_km    --  numeric      --      NULL
                         ,_rr.nm_fias_guid      --  uuid         --      NULL
                         ,_rr.nm_zipcode        --  varchar(20)  --      NULL
                         ,_rr.kd_oktmo          --  varchar(11)  --      NULL
                         ,_rr.kd_okato          --  varchar(11)  --      NULL
                         ,_rr.vl_addr_latitude  --  numeric      --      NULL
                         ,_rr.vl_addr_longitude --  numeric      --      NULL
                          --
                         ,0 -- Регион "0" - Исключение во время процесса дополнения.                              
                  );            
                  EXECUTE _exec;  
          END IF;
          --
          -- update, используя атрибуты образующие уникальность отдельной записи.  
          --            
          _exec := format (_upd, p_schema_name
         
                     ,p_nm_object         
                     ,p_nm_description    
                     ,NULL   -- dt_data_del       
                     ,NULL   -- id_data_etalon    
                     ,p_id_metro_station  
                     ,p_id_autoroad       
                     ,p_nn_autoroad_km    
                     ,p_nm_fias_guid      
                     ,p_nm_zipcode        
                     ,p_kd_oktmo          
                     ,p_kd_okato                 
                     ,p_vl_addr_latitude  
                     ,p_vl_addr_longitude
                     --
                     ,p_id_area           
                     ,p_id_object_type    
                     ,p_nm_object_full    
                     ,p_id_street         
                     ,p_id_house          
           ); 
          EXECUTE _exec;          
        END;  
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_object_ins (
                 text, text
                ,bigint, bigint, bigint, integer, bigint, varchar(250), varchar(500), varchar(150) 
                ,bigint, integer, integer, numeric, uuid, varchar(20), varchar(11), varchar(11)
                ,numeric, numeric, boolean                               
) 
         IS 'Создание записи в ОТДАЛЁННОМ справочнике адресных объектов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_object_ins ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_object_ins ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_upd (
                text, bigint, bigint, bigint, integer, bigint, varchar(250), varchar(500), varchar(150) 
                     ,bigint, integer, integer, numeric, uuid, varchar(20), varchar(11), varchar(11)
                     ,numeric, numeric, bigint                           
 ); 

DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_upd (
                 text, text
                ,bigint, bigint, bigint, integer, bigint, varchar(250), varchar(500), varchar(150) 
                ,bigint, integer, integer, numeric, uuid, varchar(20), varchar(11), varchar(11)
                ,numeric, numeric, bigint, boolean                           
 ); 
 CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_object_upd (
              p_schema_name        text   -- Схема с данными
             ,p_schema_h           text   -- Историческая схема
               --
             ,p_id_object         bigint       --  NOT NULL
             ,p_id_area           bigint       --  NOT NULL
             ,p_id_house          bigint       --      NULL
             ,p_id_object_type    integer      --  NOT NULL
             ,p_id_street         bigint       --      NULL
             ,p_nm_object         varchar(250) --      NULL
             ,p_nm_object_full    varchar(500) --  NOT NULL
             ,p_nm_description    varchar(150) --      NULL
             ,p_id_data_etalon    bigint       --      NULL
             ,p_id_metro_station  integer      --      NULL
             ,p_id_autoroad       integer      --      NULL
             ,p_nn_autoroad_km    numeric      --      NULL
             ,p_nm_fias_guid      uuid         --      NULL
             ,p_nm_zipcode        varchar(20)  --      NULL
             ,p_kd_oktmo          varchar(11)  --      NULL
             ,p_kd_okato          varchar(11)  --      NULL
             ,p_vl_addr_latitude  numeric      --      NULL
             ,p_vl_addr_longitude numeric      --      NULL
              --
             ,p_twin_id     bigint
             ,p_sw          boolean -- Создаётся историческая зап
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ------------------------------------------------------------------------------------
    --   2021-12-17/2021-12-26/2022-01-27 
    --               Обновление записи в ОТДАЛЁННОМ справочнике адресных объектов
    --   2022-02-07  Переход на базовые типы.
    --   2022-02-14  Поиск и удаление дублей.
    --   2022-02-21  ONLY для SELECT, UPDATE, DELETE
    -- ------------------------------------------------------------------------------------
    DECLARE
      _exec text;
     
      _ins text = $_$
               INSERT INTO %I.adr_objects (
                              id_object        --  NOT NULL
                             ,id_area          --  NOT NULL
                             ,id_house         --      NULL
                             ,id_object_type   --  NOT NULL
                             ,id_street        --      NULL
                             ,nm_object        --      NULL
                             ,nm_object_full   --  NOT NULL
                             ,nm_description   --      NULL
                             ,dt_data_del      --      NULL    
                             ,id_data_etalon   --      NULL
                             ,id_metro_station --      NULL
                             ,id_autoroad      --      NULL
                             ,nn_autoroad_km   --      NULL
                             ,nm_fias_guid     --      NULL
                             ,nm_zipcode       --      NULL
                             ,kd_oktmo         --      NULL
                             ,kd_okato         --      NULL
                             ,vl_addr_latitude --      NULL
                             ,vl_addr_longitude --      NULL
               )
                 VALUES (   %L::bigint                  
                           ,%L::bigint                  
                           ,%L::bigint                   
                           ,%L::integer                 
                           ,%L::bigint                   
                           ,%L::varchar(250)            
                           ,%L::varchar(500)             
                           ,%L::varchar(150)   
                           ,%L::timestamp without time zone
                           ,%L::bigint                   
                           ,%L::integer     
                           ,%L::integer                 
                           ,%L::numeric                  
                           ,%L::uuid                    
                           ,%L::varchar(20)             
                           ,%L::varchar(11)              
                           ,%L::varchar(11)             
                           ,%L::numeric                  
                           ,%L::numeric                 
                 );      
              $_$;
              
      -- 2022-02-11
      _ins_hist text = $_$
               INSERT INTO %I.adr_objects_hist (
                              id_object        --  NOT NULL
                             ,id_area          --  NOT NULL
                             ,id_house         --      NULL
                             ,id_object_type   --  NOT NULL
                             ,id_street        --      NULL
                             ,nm_object        --      NULL
                             ,nm_object_full   --  NOT NULL
                             ,nm_description   --      NULL
                             ,dt_data_del      --      NULL    
                             ,id_data_etalon   --      NULL
                             ,id_metro_station --      NULL
                             ,id_autoroad      --      NULL
                             ,nn_autoroad_km   --      NULL
                             ,nm_fias_guid     --      NULL
                             ,nm_zipcode       --      NULL
                             ,kd_oktmo         --      NULL
                             ,kd_okato         --      NULL
                             ,vl_addr_latitude --      NULL
                             ,vl_addr_longitude --     NULL
                             ,id_region
               )
                 VALUES (   %L::bigint                  
                           ,%L::bigint                  
                           ,%L::bigint                   
                           ,%L::integer                 
                           ,%L::bigint                   
                           ,%L::varchar(250)            
                           ,%L::varchar(500)             
                           ,%L::varchar(150)   
                           ,%L::timestamp without time zone
                           ,%L::bigint                   
                           ,%L::integer     
                           ,%L::integer                 
                           ,%L::numeric                  
                           ,%L::uuid                    
                           ,%L::varchar(20)             
                           ,%L::varchar(11)              
                           ,%L::varchar(11)             
                           ,%L::numeric                  
                           ,%L::numeric
                           ,%L::bigint
                 );      
              $_$;
            -- 2022-02-11              
      _upd_u text = $_$
             UPDATE ONLY %I.adr_objects SET  
             
                   id_area           = COALESCE (%L, id_area)::bigint               --  NULL
                  ,id_house          = COALESCE (%L, id_house)::bigint              --  NULL
                  ,id_object_type    = COALESCE (%L, id_object_type)::integer       --  NULL
                  ,id_street         = COALESCE (%L, id_street)::bigint             --  NULL
                  ,nm_object         = COALESCE (%L, nm_object)::varchar(250)       --  NULL
                  ,nm_object_full    = COALESCE (%L, nm_object_full)::varchar(500)  --  NULL
                  ,nm_description    = COALESCE (%L, nm_description)::varchar(150)  --  NULL
                  ,dt_data_del       =  %L::timestamp without time zone             --  NULL
                  ,id_data_etalon    =  %L::bigint                                  --  NULL
                  ,id_metro_station  = COALESCE (%L, id_metro_station)::integer     -- NOT NULL
                  ,id_autoroad       = COALESCE (%L, id_autoroad)::integer          --  NULL
                  ,nn_autoroad_km    = COALESCE (%L, nn_autoroad_km)::numeric           
                  ,nm_zipcode        = COALESCE (%L, nm_zipcode)::varchar(20)       --  NULL
                  ,kd_oktmo          = COALESCE (%L, kd_oktmo)::varchar(11)         --  NULL
                  ,kd_okato          = COALESCE (%L, kd_okato)::varchar(11)         --  NULL          
                  ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude)::numeric     --  NULL
                  ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric    --  NULL
          
             WHERE (nm_fias_guid = %L::uuid) AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL);        
        $_$;   
       --
      _upd text = $_$
                  UPDATE ONLY %I.adr_objects SET
                  
                            nm_object         = COALESCE (%L, nm_object     )::varchar(250)    --  NULL
                           ,nm_description    = COALESCE (%L, nm_description)::varchar(150)    --  NULL
                           ,dt_data_del       =  %L::timestamp without time zone --  NULL
                           ,id_data_etalon    =  %L::bigint                      --  NULL
                           ,id_metro_station  = COALESCE (%L, id_metro_station )::integer         -- NOT NULL
                           ,id_autoroad       = COALESCE (%L, id_autoroad      )::integer         --  NULL
                           ,nn_autoroad_km    = COALESCE (%L, nn_autoroad_km   )::numeric         
                           ,nm_fias_guid      = COALESCE (%L, nm_fias_guid     )::uuid            --  NULL
                           ,nm_zipcode        = COALESCE (%L, nm_zipcode       )::varchar(20)     --  NULL
                           ,kd_oktmo          = COALESCE (%L, kd_oktmo         )::varchar(11)     --  NULL
                           ,kd_okato          = COALESCE (%L, kd_okato         )::varchar(11)     --  NULL          
                           ,vl_addr_latitude  = COALESCE (%L, vl_addr_latitude )::numeric         --  NULL
                           ,vl_addr_longitude = COALESCE (%L, vl_addr_longitude)::numeric         --  NULL
                            --                           
                   WHERE  (id_area = %L::bigint) AND (id_object_type = %L::integer) AND
                          (upper(nm_object_full::text) = upper (%L)::text) AND 
                          (id_street IS NOT DISTINCT FROM %L::bigint) AND 
                          (id_house  IS NOT DISTINCT FROM %L::bigint) AND 
                          (id_data_etalon IS NULL) AND (dt_data_del IS NULL);      
        $_$;  
        
        _sel_twin text = $_$
           SELECT * FROM ONLY %I.adr_objects 
               WHERE (id_area = %L::bigint) AND (id_house = %L::bigint) AND 
                    (nm_fias_guid = %L::uuid) AND  
                    (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
        $_$;
        
       _del_twin  text = $_$             --  
           DELETE FROM ONLY %I.adr_objects WHERE (id_object = %L);                 
       $_$;         
        
      _rr  gar_tmp.adr_objects_t; -- RECORD;   
      _rr1 gar_tmp.adr_objects_t;
      
    BEGIN
      IF p_twin_id IS NOT NULL
        THEN
          _exec := format (_sel_twin, p_schema_name, p_id_area, p_twin_id, p_nm_fias_guid);  
          EXECUTE _exec INTO _rr1;
          --
          -- Двойники: различаются по первому альтернатиному ключу (степень различия в ID дома)
          --           но имеют одинаковые UUID
          IF (_rr1.id_object IS NOT NULL)
            THEN
               _exec := format (_ins_hist, p_schema_h
                    --
                   ,nextval('gar_tmp.obj_hist_seq')  --  bigint  --  NOT NULL
                   ,_rr1.id_area           --  bigint       --  NOT NULL
                   ,_rr1.id_house          --  bigint       --      NULL
                   ,_rr1.id_object_type    --  integer      --  NOT NULL
                   ,_rr1.id_street         --  bigint       --      NULL
                   ,_rr1.nm_object         --  varchar(250) --      NULL
                   ,_rr1.nm_object_full    --  varchar(500) --  NOT NULL
                   ,_rr1.nm_description    --  varchar(150) --      NULL
                   ,now()
                   ,_rr1.id_object        -- id_data_etalon    --  bigint       --      NULL
                   ,_rr1.id_metro_station  --  integer      --      NULL
                   ,_rr1.id_autoroad       --  integer      --      NULL
                   ,_rr1.nn_autoroad_km    --  numeric      --      NULL
                   ,_rr1.nm_fias_guid      --  uuid         --      NULL
                   ,_rr1.nm_zipcode        --  varchar(20)  --      NULL
                   ,_rr1.kd_oktmo          --  varchar(11)  --      NULL
                   ,_rr1.kd_okato          --  varchar(11)  --      NULL
                   ,_rr1.vl_addr_latitude  --  numeric      --      NULL
                   ,_rr1.vl_addr_longitude --  numeric      --      NULL
                   ,-1  --Признак принудительного поиска дублей
              );            
              EXECUTE _exec;            
              --
              _exec := format (_del_twin, p_schema_name, _rr1.id_object);
              EXECUTE _exec;
              
          END IF;-- _rr1.id_object IS NOT NULL
      END IF; -- TWINS
    
      _rr := gar_tmp_pcg_trans.f_adr_object_get (p_schema_name, 
                       p_id_area, p_id_object_type, p_nm_object_full, p_id_street, p_id_house 
      ); 
      --     
      IF (_rr.id_object IS NOT NULL)  
        THEN   -- ->  UPDATE
           IF
              ((_rr.id_area        IS DISTINCT FROM p_id_area       ) AND (p_id_area        IS NOT NULL)) OR
              ((_rr.id_street      IS DISTINCT FROM p_id_street     ) AND (p_id_street      IS NOT NULL)) OR
              ((_rr.id_house       IS DISTINCT FROM p_id_house      ) AND (p_id_house       IS NOT NULL)) OR
              ((_rr.nm_object_full IS DISTINCT FROM p_nm_object_full) AND (p_nm_object_full IS NOT NULL)) OR                
              ((_rr.nm_zipcode     IS DISTINCT FROM p_nm_zipcode    ) AND (p_nm_zipcode     IS NOT NULL)) OR 
                -- 
              ((_rr.nm_fias_guid   IS DISTINCT FROM p_nm_fias_guid  ) AND (p_nm_fias_guid   IS NOT NULL)) OR
              ((_rr.id_object_type IS DISTINCT FROM p_id_object_type) AND (p_id_object_type IS NOT NULL)) OR
                -- 
              ((_rr.kd_oktmo       IS DISTINCT FROM p_kd_oktmo      ) AND (p_kd_oktmo       IS NOT NULL)) OR  
              ((_rr.kd_okato       IS DISTINCT FROM p_kd_okato      ) AND (p_kd_okato       IS NOT NULL)) 
              
             THEN
               IF p_sw THEN -- Пишем в историю старые данные.
                 _exec := format (_ins_hist, p_schema_h
                          ,nextval('gar_tmp.obj_hist_seq')::bigint  --  NOT NULL
                          ,_rr.id_area          -- bigint       --  NOT NULL
                          ,_rr.id_house         -- bigint       --      NULL
                          ,_rr.id_object_type   -- integer      --  NOT NULL
                          ,_rr.id_street        -- bigint       --      NULL
                          ,_rr.nm_object        -- varchar(250) --      NULL
                          ,_rr.nm_object_full   -- varchar(500) --  NOT NULL
                          ,_rr.nm_description   -- varchar(150) --      NULL
                          ,now()
                          ,_rr.id_object         -- bigint       --      NULL  -- -- id_data_etalon
                          ,_rr.id_metro_station  -- integer      --      NULL
                          ,_rr.id_autoroad       -- integer      --      NULL
                          ,_rr.nn_autoroad_km    -- numeric      --      NULL
                          ,_rr.nm_fias_guid      -- uuid         --      NULL
                          ,_rr.nm_zipcode        -- varchar(20)  --      NULL
                          ,_rr.kd_oktmo          -- varchar(11)  --      NULL
                          ,_rr.kd_okato          -- varchar(11)  --      NULL
                          ,_rr.vl_addr_latitude  -- numeric      --      NULL
                          ,_rr.vl_addr_longitude -- numeric      --      NULL
                          , NULL
                 );            
                 EXECUTE _exec;
               END IF; -- p_sw -- пишем в историю 
               --
               _exec := format (_upd, p_schema_name
                 
                            ,p_nm_object         
                            ,p_nm_description    
                            ,NULL   -- dt_data_del       
                            ,NULL   -- id_data_etalon    
                            ,p_id_metro_station  
                            ,p_id_autoroad       
                            ,p_nn_autoroad_km    
                            ,p_nm_fias_guid      
                            ,p_nm_zipcode        
                            ,p_kd_oktmo          
                            ,p_kd_okato                 
                            ,p_vl_addr_latitude  
                            ,p_vl_addr_longitude
                            --
                            ,p_id_area      
                            ,p_id_object_type    
                            ,p_nm_object_full    
                            ,p_id_street         
                            ,p_id_house          
                  );
               EXECUTE _exec;   
           END IF; -- compare   
            
         ELSE  -- INSERT -- _rr.id_object IS NULL
           -- Дома и адресные объекто строго не сихронизированы. 
           -- Обновляемой записи из "adr_house" может и не быть в "adr_objects".
            -- 
           _exec := format (_ins, p_schema_name
                            ,p_id_object         --  bigint       --  NOT NULL
                            ,p_id_area           --  bigint       --  NOT NULL
                            ,p_id_house          --  bigint       --      NULL
                            ,p_id_object_type    --  integer      --  NOT NULL
                            ,p_id_street         --  bigint       --      NULL
                            ,p_nm_object         --  varchar(250) --      NULL
                            ,p_nm_object_full    --  varchar(500) --  NOT NULL
                            ,p_nm_description    --  varchar(150) --      NULL
                            ,NULL                -- 
                            ,NULL    -- p_id_data_etalon    --  bigint    NULL
                            ,p_id_metro_station  --  integer      --      NULL
                            ,p_id_autoroad       --  integer      --      NULL
                            ,p_nn_autoroad_km    --  numeric      --      NULL
                            ,p_nm_fias_guid      --  uuid         --      NULL
                            ,p_nm_zipcode        --  varchar(20)  --      NULL
                            ,p_kd_oktmo          --  varchar(11)  --      NULL
                            ,p_kd_okato          --  varchar(11)  --      NULL
                            ,p_vl_addr_latitude  --  numeric      --      NULL
                            ,p_vl_addr_longitude --  numeric      --      NULL
           );            
           EXECUTE _exec;
      END IF; -- _rr.id_object IS NOT NULL
      
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
    
    EXCEPTION  -- Возникает на отдалённоми сервере               
      WHEN unique_violation THEN 
        BEGIN
          _rr1 := (p_schema_name, p_id_area, p_id_object_type, p_nm_object_full, p_id_street, p_id_house); 
          IF ( _rr1.id_object IS NOT NULL)
            THEN
              -- Запоминаю старые данные с новым ID
              _exec := format (_ins_hist, p_schema_h
                         ,nextval('gar_tmp.obj_hist_seq')  --  bigint  --  NOT NULL
                         ,_rr1.id_area           --  bigint       --  NOT NULL
                         ,_rr1.id_house          --  bigint       --      NULL
                         ,_rr1.id_object_type    --  integer      --  NOT NULL
                         ,_rr1.id_street         --  bigint       --      NULL
                         ,_rr1.nm_object         --  varchar(250) --      NULL
                         ,_rr1.nm_object_full    --  varchar(500) --  NOT NULL
                         ,_rr1.nm_description    --  varchar(150) --      NULL
                         ,now()
                         ,_rr1.id_object        -- id_data_etalon    --  bigint       --      NULL
                         ,_rr1.id_metro_station  --  integer      --      NULL
                         ,_rr1.id_autoroad       --  integer      --      NULL
                         ,_rr1.nn_autoroad_km    --  numeric      --      NULL
                         ,_rr1.nm_fias_guid      --  uuid         --      NULL
                         ,_rr1.nm_zipcode        --  varchar(20)  --      NULL
                         ,_rr1.kd_oktmo          --  varchar(11)  --      NULL
                         ,_rr1.kd_okato          --  varchar(11)  --      NULL
                         ,_rr1.vl_addr_latitude  --  numeric      --      NULL
                         ,_rr1.vl_addr_longitude --  numeric      --      NULL
                         , 0
              );            
              EXECUTE _exec;     
              -- 
              _exec := format (_del_twin, p_schema_name, _rr1.id_object);
              EXECUTE _exec;              
              --
              -- Продолжаю прерванную операцию  
              --
              _rr := (p_schema_name, p_id_area, p_id_object_type, p_nm_object_full, p_id_street, p_id_house); 
              IF (_rr.id_object IS NOT NULL) 
               THEN
                 IF p_sw THEN
                   -- Запоминаю старые данные с новым ID
                   _exec := format (_ins_hist, p_schema_h
                        ,nextval('gar_tmp.obj_hist_seq')  --  bigint  --  NOT NULL
                        ,_rr.id_area           --  bigint       --  NOT NULL
                        ,_rr.id_house          --  bigint       --      NULL
                        ,_rr.id_object_type    --  integer      --  NOT NULL
                        ,_rr.id_street         --  bigint       --      NULL
                        ,_rr.nm_object         --  varchar(250) --      NULL
                        ,_rr.nm_object_full    --  varchar(500) --  NOT NULL
                        ,_rr.nm_description    --  varchar(150) --      NULL
                        ,now()
                        ,_rr.id_object        -- id_data_etalon    --  bigint       --      NULL
                        ,_rr.id_metro_station  --  integer      --      NULL
                        ,_rr.id_autoroad       --  integer      --      NULL
                        ,_rr.nn_autoroad_km    --  numeric      --      NULL
                        ,_rr.nm_fias_guid      --  uuid         --      NULL
                        ,_rr.nm_zipcode        --  varchar(20)  --      NULL
                        ,_rr.kd_oktmo          --  varchar(11)  --      NULL
                        ,_rr.kd_okato          --  varchar(11)  --      NULL
                        ,_rr.vl_addr_latitude  --  numeric      --      NULL
                        ,_rr.vl_addr_longitude --  numeric      --      NULL
                        , NULL
                   );            
                   EXECUTE _exec;     
                 END IF; -- Сохраняю исходные данные.
              
                 -- Обновляю запись.
                 _exec := format (_upd, p_schema_name
                 
                            ,p_nm_object         
                            ,p_nm_description    
                            ,NULL   -- dt_data_del       
                            ,NULL   -- id_data_etalon    
                            ,p_id_metro_station  
                            ,p_id_autoroad       
                            ,p_nn_autoroad_km    
                            ,p_nm_fias_guid      
                            ,p_nm_zipcode        
                            ,p_kd_oktmo          
                            ,p_kd_okato                 
                            ,p_vl_addr_latitude  
                            ,p_vl_addr_longitude
                            --
                            ,p_id_area      
                            ,p_id_object_type   
                            ,p_nm_object_full    
                            ,p_id_street         
                            ,p_id_house          
                  ); 
                 EXECUTE _exec;
              END IF; -- -- _rr.id_object IS NOT NULL
          END IF; -- _rr1.id_object IS NOT NULL
 	    END; -- unique_violation	
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_object_upd (
                 text, text
                ,bigint, bigint, bigint, integer, bigint, varchar(250), varchar(500), varchar(150) 
                ,bigint, integer, integer, numeric, uuid, varchar(20), varchar(11), varchar(11)
                ,numeric, numeric, bigint, boolean                            
) 
         IS 'Обновление записи в ОТДАЛЁННОМ справочнике адресных объектов';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
-- -----------------------------------------------------------------------------------------------
-- 
-- ЗАМЕЧАНИЕ:  процедура gar_tmp_pcg_trans.p_adr_object_upd(text,pg_catalog.int8,pg_catalog.int8,pg_catalog.int8,pg_catalog.int4,pg_catalog.int8,pg_catalog.varchar,pg_catalog.varchar,pg_catalog.varchar,pg_catalog.int8,pg_catalog.int4,pg_catalog.int4,pg_catalog.numeric,uuid,pg_catalog.varchar,pg_catalog.varchar,pg_catalog.varchar,pg_catalog.numeric,pg_catalog.numeric,pg_catalog.int8) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:42804:256:присваивание:target type is different type than source type
-- ЗАМЕЧАНИЕ:  Detail: cast "text" value to "bigint" type
-- ЗАМЕЧАНИЕ:  Hint: The input expression type does not have an assignment cast to the target type.
-- ЗАМЕЧАНИЕ:  Context: at assignment to variable "_rr" declared on line 149
-- ЗАМЕЧАНИЕ:  warning:42804:256:присваивание:target type is different type than source type
-- ЗАМЕЧАНИЕ:  Detail: cast "character varying" value to "integer" type
-- ЗАМЕЧАНИЕ:  Hint: The input expression type does not have an assignment cast to the target type.
-- ЗАМЕЧАНИЕ:  Context: at assignment to variable "_rr" declared on line 149
-- ЗАМЕЧАНИЕ:  warning:00000:256:присваивание:too few attributes for composite variable
-- ЗАМЕЧАНИЕ:  Context: at assignment to variable "_rr" declared on line 149
-- ЗАМЕЧАНИЕ:  warning extra:00000:101:DECLARE:never read variable "_upd_u"
-- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_id_data_etalon"
-- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_oper_type_id"
-- ЗАМЕЧАНИЕ:  (FUNCTION,1652988,gar_tmp_pcg_trans,f_adr_object_get,"(text,bigint,integer,character varying,bigint,bigint)")
-- COMMENT
-- 
-- Query returned successfully in 219 msec.
-- 


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_unload (text); 
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_unload (text, bigint); 

DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_unload (text, bigint, text); 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_object_unload (
              p_schema_name   text    -- Имя схемы на отдалённом сервере  
             ,p_id_region     bigint  -- ID региона
             ,p_conn          text    -- Соединение с отдалённым сервером. 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- --------------------------------------------------------------------------
    --  2021-12-31 Загрузка фрагмента ОТДАЛЁННОГО справочника адресных объектов.
    --  2022-01-28 Перегружаю все региональные объекты типа "Дом"
    -- --------------------------------------------------------------------------

    BEGIN
      ALTER TABLE gar_tmp.adr_objects DROP CONSTRAINT IF EXISTS pk_tmp_adr_objects;
      ALTER TABLE gar_tmp.adr_objects DROP CONSTRAINT IF EXISTS pk_adr_objects;
      DROP INDEX IF EXISTS gar_tmp._xxx_adr_objects_ak1;
      DROP INDEX IF EXISTS gar_tmp._xxx_adr_objects_ie2;
      --
      DELETE FROM ONLY gar_tmp.adr_objects; -- 2022-02-17
      --
      INSERT INTO gar_tmp.adr_objects (
               id_object           
              ,id_area             
              ,id_house            
              ,id_object_type      
              ,id_street           
              ,nm_object           
              ,nm_object_full      
              ,nm_description      
              ,dt_data_del         
              ,id_data_etalon      
              ,id_metro_station    
              ,id_autoroad         
              ,nn_autoroad_km      
              ,nm_fias_guid        
              ,nm_zipcode          
              ,kd_oktmo            
              ,kd_okato            
              ,vl_addr_latitude    
              ,vl_addr_longitude  
          )
           SELECT * FROM gar_tmp_pcg_trans.f_adr_object_unload_data (
                     p_schema_name
          			,p_id_region
          			,p_conn 
           );
      --
      ALTER TABLE gar_tmp.adr_objects ADD CONSTRAINT pk_adr_objects PRIMARY KEY (id_object);
      --    
      CREATE UNIQUE INDEX _xxx_adr_objects_ak1
          ON gar_tmp.adr_objects USING btree
          (
             id_area         ASC NULLS LAST
            ,id_object_type ASC NULLS LAST
            ,upper (nm_object_full::text) ASC NULLS LAST
            ,id_street ASC NULLS LAST
            ,id_house   ASC NULLS LAST
          )
          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;
      --      
      CREATE INDEX _xxx_adr_objects_ie2
          ON gar_tmp.adr_objects USING btree
          (nm_fias_guid ASC NULLS LAST)
          WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;    
    
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE WARNING 'P_ADR_OBJECT_LOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_object_unload (text, bigint, text) 
   IS ' Загрузка фрагмента ОТДАЛЁННОГО справочника адресных объектов.';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_object_unload ('unnsi', 52, (gar_link.f_conn_set ('c_unnsi_l', 'unnsi_nl')));
-- Query returned successfully in 11 secs 566 msec.
   
-- SELECT * FROM gar_tmp.adr_objects;     -- 813177 rows affected. 





-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_object_upload (text); 
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_object_upload (
              p_schema_name     text  
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- --------------------------------------------------------------------------
    --  2021-12-31 Обратная загрузка обработанного фрагмента ОТДАЛЁННОГО 
    --              справочника адресных объектов.
    -- --------------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _del text = $_$
           DELETE FROM ONLY %I.adr_objects x USING ONLY gar_tmp.adr_objects t WHERE (x.id_object = t.id_object);    
      $_$;
      
      _ins text = $_$
           INSERT INTO %I.adr_objects 
               SELECT 
                       x.id_object           
                      ,x.id_area             
                      ,x.id_house            
                      ,x.id_object_type      
                      ,x.id_street           
                      ,x.nm_object           
                      ,x.nm_object_full      
                      ,x.nm_description      
                      ,x.dt_data_del         
                      ,x.id_data_etalon      
                      ,x.id_metro_station    
                      ,x.id_autoroad         
                      ,x.nn_autoroad_km      
                      ,x.nm_fias_guid        
                      ,x.nm_zipcode          
                      ,x.kd_oktmo            
                      ,x.kd_okato            
                      ,x.vl_addr_latitude    
                      ,x.vl_addr_longitude   
               FROM ONLY gar_tmp.adr_objects x;
      $_$;			   

    BEGIN
      -- ALTER TABLE %I.adr_objects ADD CONSTRAINT adr_objects_pkey PRIMARY KEY (id_object);
      -- DROP INDEX IF EXISTS %I._xxx_adr_objects_ak1;
      -- DROP INDEX IF EXISTS %I._xxx_adr_objects_ie2;
      --  + Остальные индексы, для таблицы объектов на отдалённом сервере.
      --  dblink-функционал.
      --
      _exec := format (_del, p_schema_name);            
      EXECUTE _exec;  
      --
      _exec := format (_ins, p_schema_name);            
      EXECUTE _exec;  
      --
      -- + Далее отдалённо, восстанавливается индексное покрытие.     
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE WARNING 'P_ADR_OBJECT_LOAD: % -- %', SQLSTATE, SQLERRM;
        END;
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_object_upload (text) 
   IS 'Обратная загрузка обработанного фрагмента ОТДАЛЁННОГО справочника адресных объектов.';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_object_upload ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_object_upload ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_ins (text);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_ins (text, uuid[]);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_ins (text[], uuid[]);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_ins (text, text, text, uuid[], boolean);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_area_ins (
           p_schema_data    text -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl     text -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist    text -- Схема для хранения исторических данных 
          ,p_nm_guids_fias  uuid[]  = NULL -- Список обрабатываемых GUID, NULL - все.
          ,p_sw_hist        boolean = TRUE -- Создаётся историческая запись.
)
    RETURNS integer
    LANGUAGE plpgsql
	SET search_path=gar_tmp_pcg_trans, gar_tmp, public
 AS
  $$
   DECLARE
     _r_ins   integer := 0;   
     
     _data   RECORD;  
     _parent gar_tmp.adr_area_t;
     
     _id_area_type         bigint;
     _area_type_short_name text;
     --
     --  2021-12-20
     --
     _id_area    bigint;
           
   BEGIN
    -- ------------------------------------------------------------------------------
    --  2021-12-10/2021-12-19/2022-02-09 Nick  Дополнение адресных георегионов.
    --  2022-02-21 - фильтрация данных по справочнику типов.  
    -- ------------------------------------------------------------------------------
    --  p_schema_data   -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
    --  p_schema_etl    -- Схема эталон, обычно локальный сервер, копия p_schema_data 
    --  p_schema_hist   -- Схема для хранения исторических данных 
    --  p_nm_guids_fias -- Список обрабатываемых GUID, NULL - все.
    --  p_sw_hist       -- Создаётся историческая запись.
    -- ------------------------------------------------------------------------------
    FOR _data IN 
           SELECT 
                x.id_addr_obj AS id_area     
                --
               ,x.nm_addr_obj AS nm_area     
               ,x.nm_addr_obj AS nm_area_full
               --
               ,x.addr_obj_type_id AS id_area_type
               ,x.addr_obj_type    AS nm_area_type         
                --
               ,x.id_addr_parent   AS id_area_parent     
               ,x.parent_fias_guid AS nm_fias_guid_parent
               --
               ,(p.type_param_value -> '7'::text)  AS kd_oktmo
               --
               ,x.fias_guid AS nm_fias_guid  
                --
               ,(p.type_param_value -> '6'::text)  AS kd_okato    --  varchar(11) null,
               ,(p.type_param_value -> '5'::text)  AS nm_zipcode  --  varchar(20) null,
               ,(p.type_param_value -> '11::text') AS kd_kladr    --  varchar(15) null,
                --
               ,x.tree_d                
               ,x.level_d               
                --
               ,x.obj_level       
               ,x.level_name      
               --
               ,x.oper_type_id    
               ,x.oper_type_name  
               
            FROM gar_tmp.xxx_adr_area x  
               INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = x.fias_guid) 
               LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (x.id_addr_obj = p.object_id)
	            
	        WHERE (f.id_obj IS NULL) AND (f.type_object = 0) 
	                 AND
	              (((x.fias_guid = ANY (p_nm_guids_fias)) AND 
	               (p_nm_guids_fias IS NOT NULL)) OR (p_nm_guids_fias IS NULL)
	              )
	        ORDER BY x.tree_d 
     
       LOOP
          -- Код страны
          -- часовой пояс
          -- Полное имя       Это всё забираем у родителя  (полная инфа о родителе.
          
          -- Тип, вычисляется на локальных данных.
          
           SELECT id_area_type, nm_area_type_short 
              INTO _id_area_type, _area_type_short_name
           FROM gar_tmp.xxx_adr_area_type WHERE (_data.id_area_type = ANY (fias_ids));
           --
           CONTINUE WHEN ((_id_area_type IS NULL) OR (_area_type_short_name IS NULL) OR
                          (_data.nm_area IS NULL) 
           ); -- 2022-02-21
           --
          _id_area := nextval('gar_tmp.obj_seq'); 
           _parent := gar_tmp_pcg_trans.f_adr_area_get (p_schema_etl, _data.nm_fias_guid_parent);
           
           CALL gar_tmp_pcg_trans.p_adr_area_ins (
                  p_schema_name       := p_schema_data                    --  text  
                 ,p_schema_h          := p_schema_hist     
                  --
                 ,p_id_area           := _id_area                    --  bigint      --  NOT NULL
                 ,p_id_country        := COALESCE (_parent.id_country, 185)::integer --  NOT NULL
                 ,p_nm_area           := _data.nm_area::varchar(120)                 --  NOT NULL
                 ,p_nm_area_full      := btrim ((COALESCE (_parent.nm_area_full, '') ||  ', ' || 
                                                   _data.nm_area || ' ' ||
                                                   _area_type_short_name
                                               ), ',')::varchar(4000)                --  NOT NULL
                 ,p_id_area_type      := _id_area_type       ::integer                --    NULL
                 ,p_id_area_parent    := _parent.id_area     ::bigint                 --    NULL
                 ,p_kd_timezone       := _parent.kd_timezone ::integer                --    NULL
                 ,p_pr_detailed       := COALESCE (_parent.pr_detailed, 0)::smallint  -- NOT NULL 
                 ,p_kd_oktmo          := _data.kd_oktmo      ::varchar(11)            --    NULL
                 ,p_nm_fias_guid      := _data.nm_fias_guid  ::uuid                   --    NULL
                 ,p_id_data_etalon    := NULL                ::bigint                 --    NULL
                 ,p_kd_okato          := _data.kd_okato  ::varchar(11)                --    NULL
                 ,p_nm_zipcode        := _data.nm_zipcode::varchar(20)                --    NULL
                 ,p_kd_kladr          := _data.kd_kladr  ::varchar(15)                --    NULL
                 ,p_vl_addr_latitude  := NULL::numeric                                --    NULL
                 ,p_vl_addr_longitude := NULL::numeric                                --    NULL  
                  --
                 ,p_sw                := p_sw_hist
           );
             
           _r_ins := _r_ins + 1; 
       END LOOP;
   
    RETURN _r_ins;
   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_area_ins (text, text, text, uuid[], boolean) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_area_ins (text, text, text, uuid[], boolean)
IS 'Дополнение адресных георегионов';
----------------------------------------------------------------------------------
-- USE CASE:
-- SELECT gar_tmp_pcg_trans.f_adr_area_ins ('unsi'); 
-- ЗАМЕЧАНИЕ:  (2825,185,Хачемзий,"Адыгея Респ, Кошехабльский р-н, Хачемзий аул",5,94,,1,79615412126,,79215000020,385423,01002000020)
-- SELECT * from gar_tmp.obj_seq;
--    --   {2,94,50000001}
-- select * from unsi.adr_area where (id_area > 50000000)
-- DELETE from unsi.adr_area where (id_area > 50000000)

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_upd (text);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_upd (text,uuid[]);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_upd (text[],uuid[]);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_upd (text, text, text, uuid[], boolean);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_area_upd (
           p_schema_data    text -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl     text -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist    text -- Схема для хранения исторических данных 
          ,p_nm_guids_fias  uuid[]  = NULL -- Список обрабатываемых GUID, NULL - все.
          ,p_sw_hist        boolean = TRUE -- Создаётся историческая запись.
)
    RETURNS integer
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
     _r_upd   integer := 0;   
     
     _data   RECORD;  
     _parent gar_tmp.adr_area_t;
     
     _id_area_type         bigint;
     _area_type_short_name text;
     --
     --  2021-12-20
     --
     _schema_name  text;
     _id_area      bigint;
           
   BEGIN
    -- ---------------------------------------------------------------------------------
    --  2021-12-10/2022-02-10 Nick  Обновление адресных георегионов.
    --  2022-02-21 - фильтрация данных по справочнику типов.  
    -- ---------------------------------------------------------------------------------
    --     p_schema_data   -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
    --    ,p_schema_etl    -- Схема эталон, обычно локальный сервер, копия p_schema_data 
    --    ,p_schema_hist   -- Схема для хранения исторических данных 
    --    ,p_nm_guids_fias -- Список обрабатываемых GUID, NULL - все.
    --    ,p_sw_hist       -- Создаётся историческая запись.    
    -- ---------------------------------------------------------------------------------
    FOR _data IN 
           SELECT 
                f.id_obj 
               ,id_obj_fias
                --
               ,x.id_addr_obj AS id_area     
                --
               ,x.nm_addr_obj AS nm_area     
               ,x.nm_addr_obj AS nm_area_full
               --
               ,x.addr_obj_type_id AS id_area_type
               ,x.addr_obj_type    AS nm_area_type         
                --
               ,x.id_addr_parent   AS id_area_parent     
               ,x.parent_fias_guid AS nm_fias_guid_parent
               --
               ,(p.type_param_value -> '7'::text)  AS kd_oktmo
               --
               ,x.fias_guid AS nm_fias_guid  
                --
               ,(p.type_param_value -> '6'::text)  AS kd_okato    --  varchar(11) null,
               ,(p.type_param_value -> '5'::text)  AS nm_zipcode  --  varchar(20) null,
               ,(p.type_param_value -> '11'::text) AS kd_kladr    --  varchar(15) null,
                --
               ,x.tree_d                
               ,x.level_d               
                --
               ,x.obj_level       
               ,x.level_name      
               --
               ,x.oper_type_id    
               ,x.oper_type_name  
               
            FROM gar_tmp.xxx_adr_area x  
               INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = x.fias_guid) 
               LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (x.id_addr_obj = p.object_id)
	            
	        WHERE (f.id_obj IS NOT NULL) AND (f.type_object = 0) AND
	              (((x.fias_guid = ANY (p_nm_guids_fias)) AND 
	               (p_nm_guids_fias IS NOT NULL)) OR (p_nm_guids_fias IS NULL)
	              )
	        
	        ORDER BY x.tree_d 
     
       LOOP
           SELECT id_area_type, nm_area_type_short 
              INTO _id_area_type, _area_type_short_name
           FROM gar_tmp.xxx_adr_area_type WHERE (_data.id_area_type = ANY (fias_ids));
           --
           CONTINUE WHEN ((_id_area_type IS NULL) OR (_area_type_short_name IS NULL) OR
                          (_data.nm_area IS NULL) 
           ); -- 2022-02-21
           --         
           _parent := gar_tmp_pcg_trans.f_adr_area_get (p_schema_etl, _data.nm_fias_guid_parent);
         
           CALL gar_tmp_pcg_trans.p_adr_area_upd (
                  p_schema_name       := p_schema_data                    --  text  
                 ,p_schema_h          := p_schema_hist   
                  --   ID сохраняется 
                 ,p_id_area           := _id_area --  bigint                           --  NOT NULL
                 ,p_id_country        := COALESCE (_parent.id_country, 185)::integer   --  NOT NULL
                 ,p_nm_area           := _data.nm_area::varchar(120)                   --  NOT NULL
                 ,p_nm_area_full      := btrim ((COALESCE (_parent.nm_area_full, '') ||  ', ' || 
                                                   _data.nm_area || ' ' ||
                                                   _area_type_short_name
                                               ), ',')::varchar(4000)                  
                 ,p_id_area_type      := _id_area_type       ::integer       --    NULL
                 ,p_id_area_parent    := _parent.id_area     ::bigint        --    NULL
                 ,p_kd_timezone       := _parent.kd_timezone ::integer       --    NULL
                 ,p_pr_detailed       := COALESCE (_parent.pr_detailed, 0)::smallint      --  NOT NULL 
                 ,p_kd_oktmo          := _data.kd_oktmo      ::varchar(11)   --    NULL
                 ,p_nm_fias_guid      := _data.nm_fias_guid  ::uuid          --    NULL
                 ,p_id_data_etalon    := NULL                ::bigint        --    NULL
                 ,p_kd_okato          := _data.kd_okato  ::varchar(11)       --    NULL
                 ,p_nm_zipcode        := _data.nm_zipcode::varchar(20)       --    NULL
                 ,p_kd_kladr          := _data.kd_kladr  ::varchar(15)       --    NULL
                 ,p_vl_addr_latitude  := NULL::numeric                       --    NULL
                 ,p_vl_addr_longitude := NULL::numeric                       --    NULL   
                 ,p_oper_type_id      := _data.oper_type_id
                  --
                 ,p_sw                := p_sw_hist                 
           );
                
           _r_upd := _r_upd + 1; 
       END LOOP;
   
    RETURN _r_upd;
   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_area_upd (text, text, text, uuid[], boolean) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_area_upd (text, text, text, uuid[], boolean)
IS 'Обновление георегионов';
----------------------------------------------------------------------------------
-- USE CASE:
-- SELECT gar_tmp_pcg_trans.f_adr_area_upd ('unsi'); 
-- ЗАМЕЧАНИЕ:  (2825,185,Хачемзий,"Адыгея Респ, Кошехабльский р-н, Хачемзий аул",5,94,,1,79615412126,,79215000020,385423,01002000020)
-- SELECT * from gar_tmp.obj_seq;
--    --   {2,94,50000001}
-- select * from unsi.adr_area where (id_area > 50000000)
-- DELETE from unsi.adr_area where (id_area > 50000000)

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_street_ins (text[], uuid[]);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_street_ins (text, text, text, uuid[], boolean);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_street_ins (
           p_schema_data    text -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl     text -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist    text -- Схема для хранения исторических данных 
          ,p_nm_guids_fias  uuid[]  = NULL -- Список обрабатываемых GUID, NULL - все.
          ,p_sw_hist        boolean = TRUE -- Создаётся историческая запись.          
)
    RETURNS integer
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
     _r_ins   integer := 0;  
     
     _data   RECORD;  
     _parent gar_tmp.adr_area_t;
     
     _id_street_type          bigint;
     _street_type_short_name  text;     
     --
     --  2021-12-20
     --
     _id_street   bigint;     
           
   BEGIN
    -- --------------------------------------------------------------------------------
    --  2021-12-14 Nick  Дополнение адресов улиц.
    --  2022-02-21 - фильтрация данных по справочнику типов.  
    -- --------------------------------------------------------------------------------
    --   p_schema_data   -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
    --   p_schema_etl    -- Схема эталон, обычно локальный сервер, копия p_schema_data 
    --   p_schema_hist   -- Схема для хранения исторических данных 
    --   p_nm_guids_fias -- Список обрабатываемых GUID, NULL - все.
    --   p_sw_hist       -- Создаётся историческая запись.        --
    -- --------------------------------------------------------------------------------
    FOR _data IN 
           SELECT 
                x.id_addr_obj AS id_street     
                --
               ,x.nm_addr_obj AS nm_street     
               ,x.nm_addr_obj AS nm_street_full
               --
               ,x.addr_obj_type_id AS id_street_type
               ,x.addr_obj_type    AS nm_street_type         
                --
               ,x.id_addr_parent   AS id_area     
               ,x.parent_fias_guid AS nm_fias_guid_area
               --
               ,x.fias_guid AS nm_fias_guid  
               ,(p.type_param_value -> '11'::text) AS kd_kladr    --  varchar(15) null,
                --
               ,x.tree_d                
               ,x.level_d               
                --
               ,x.obj_level       
               ,x.level_name      
               --
               ,x.oper_type_id    
               ,x.oper_type_name  
               
            FROM gar_tmp.xxx_adr_area x  
               INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = x.fias_guid) 
               LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (x.id_addr_obj = p.object_id)
   
          WHERE (f.id_obj IS NULL) AND (f.type_object = 1) 
                    AND
                  (((x.fias_guid = ANY (p_nm_guids_fias)) AND 
	               (p_nm_guids_fias IS NOT NULL)) OR (p_nm_guids_fias IS NULL)
	              )
          ORDER BY x.tree_d 
  
       LOOP
          SELECT id_street_type, nm_street_type_short 
              INTO _id_street_type, _street_type_short_name
           FROM gar_tmp.xxx_adr_street_type WHERE (_data.id_street_type = ANY (fias_ids));
          CONTINUE WHEN ((_id_street_type IS NULL) OR (_street_type_short_name IS NULL)); -- 2022-02-21     

          _parent := gar_tmp_pcg_trans.f_adr_area_get (p_schema_etl, _data.nm_fias_guid_area);
          CONTINUE WHEN (_parent.id_area IS NULL) OR (_data.nm_street IS NULL); 
          
          _id_street := nextval(' gar_tmp.obj_seq');                           

          CALL gar_tmp_pcg_trans.p_adr_street_ins (
              p_schema_name       := p_schema_data                   --  text  
             ,p_schema_h          := p_schema_hist     
              --
             ,p_id_street         :=  _id_street                     -- bigint       -- NOT NULL 
             ,p_id_area           :=  _parent.id_area                -- bigint       -- NOT NULL 
             ,p_nm_street         :=  _data.nm_street::varchar(120)                -- NOT NULL 
             ,p_id_street_type    :=  _id_street_type::integer                     --  NULL 
             ,p_nm_street_full    :=  COALESCE ((_data.nm_street || ' ' || _street_type_short_name)
                                                ,_data.nm_street
                                      )::varchar(255)  -- NOT NULL  -- Nick 2021-12-30  
             ,p_nm_fias_guid      :=  _data.nm_fias_guid::uuid           --  NULL 
             ,p_id_data_etalon    :=  NULL::bigint                       --  NULL 
             ,p_kd_kladr          :=  _data.kd_kladr::varchar(15)        --  NULL  
             ,p_vl_addr_latitude  :=  NULL::numeric                      --  NULL 
             ,p_vl_addr_longitude :=  NULL::numeric                      --  NULL     
                  --
             ,p_sw                := p_sw_hist             
          );
          
         _r_ins := _r_ins + 1; 
       END LOOP;
   
    RETURN _r_ins;
    
   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_street_ins (text, text, text, uuid[], boolean) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_street_ins (text, text, text, uuid[], boolean) 
IS 'Дополнение адресов улиц';
----------------------------------------------------------------------------------
-- USE CASE:
-- SELECT gar_tmp_pcg_trans.f_adr_street_ins ('unsi') ; 
-- SELECT * from gar_tmp.obj_seq;
-- SELECT * FROM  gar_tmp_pcg_trans.f_adr_street_show (2) WHERE ( id_street > 50000000);
-- SELECT * FROM unsi.adr_street WHERE ( id_street > 50000000);
-- DELETE FROM unsi.adr_street WHERE ( id_street > 50000000);

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_street_upd (text[], uuid[]);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_street_upd (text, text, text, uuid[], boolean);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_street_upd (text, text, text, uuid[], boolean, boolean);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_street_upd (
           p_schema_data    text -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl     text -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist    text -- Схема для хранения исторических данных 
          ,p_nm_guids_fias  uuid[]  = NULL -- Список обрабатываемых GUID, NULL - все.
          ,p_sw_hist        boolean = TRUE  -- Создаётся историческая запись.  
          ,p_sw_duble       boolean = FALSE -- Обязательное выявление дубликатов
)
    RETURNS integer
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
     _r_upd   integer := 0;  
     
     _data   RECORD;  
     _parent gar_tmp.adr_area_t;
     
     _id_street_type          bigint;
     _street_type_short_name  text;     
     --
     --  2021-12-20
     --
     _id_street   bigint; 
     
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-14/2022-02-10 Nick  Обновление адресов улиц.
    --  2022-02-21 - фильтрация данных по справочнику типов.  
    -- --------------------------------------------------------------------------
    --  p_schema_data   -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
    --  p_schema_etl    -- Схема эталон, обычно локальный сервер, копия p_schema_data 
    --  p_schema_hist   -- Схема для хранения исторических данных 
    --  p_nm_guids_fias -- Список обрабатываемых GUID, NULL - все.
    --  p_sw_hist       -- Создаётся историческая запись.   
    --  p_sw_duble      -- Обязательное выяление дубликатов
    -- --------------------------------------------------------------------------
    FOR _data IN 
           SELECT 
                x.id_addr_obj AS id_street     
                --
               ,x.nm_addr_obj AS nm_street     
               ,x.nm_addr_obj AS nm_street_full
               --
               ,x.addr_obj_type_id AS id_street_type
               ,x.addr_obj_type    AS nm_street_type         
                --
               ,x.id_addr_parent   AS id_area     
               ,x.parent_fias_guid AS nm_fias_guid_area
               --
               ,x.fias_guid AS nm_fias_guid  
               ,(p.type_param_value -> '11'::text) AS kd_kladr    --  varchar(15) null,
                --
               ,x.tree_d                
               ,x.level_d               
                --
               ,x.obj_level       
               ,x.level_name      
               --
               ,x.oper_type_id    
               ,x.oper_type_name  
               
            FROM gar_tmp.xxx_adr_area x  
               INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = x.fias_guid) 
               LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (x.id_addr_obj = p.object_id)
   
          WHERE (f.id_obj IS NOT NULL) AND (f.type_object = 1) 
                    AND
                  (((x.fias_guid = ANY (p_nm_guids_fias)) AND 
	               (p_nm_guids_fias IS NOT NULL)) OR (p_nm_guids_fias IS NULL)
	              )          
          ORDER BY x.tree_d 
       LOOP
       
          SELECT id_street_type, nm_street_type_short 
              INTO _id_street_type, _street_type_short_name
           FROM gar_tmp.xxx_adr_street_type WHERE (_data.id_street_type = ANY (fias_ids));
          CONTINUE WHEN ((_id_street_type IS NULL) OR (_street_type_short_name IS NULL)); -- 2022-02-21     
         
          _parent := gar_tmp_pcg_trans.f_adr_area_get (p_schema_etl, _data.nm_fias_guid_area);
          CONTINUE WHEN ((_parent.id_area IS NULL) OR (_data.nm_street IS NULL)); 
          
          CALL gar_tmp_pcg_trans.p_adr_street_upd (
              p_schema_name       := p_schema_data                    --  text  
             ,p_schema_h          := p_schema_hist   
              --
             ,p_id_street         :=  _id_street   -- bigint                      -- NOT NULL 
             ,p_id_area           :=  _parent.id_area                -- bigint    -- NOT NULL 
             ,p_nm_street         :=  _data.nm_street::varchar(120)               -- NOT NULL 
             ,p_id_street_type    :=  _id_street_type::integer                    --  NULL 
             ,p_nm_street_full    :=  (_data.nm_street || ' ' || _street_type_short_name)::varchar(255)  -- NOT NULL  
             ,p_nm_fias_guid      :=  _data.nm_fias_guid::uuid           --  NULL 
             ,p_id_data_etalon    :=  NULL::bigint                       --  NULL 
             ,p_kd_kladr          :=  _data.kd_kladr::varchar(15)        --  NULL  
             ,p_vl_addr_latitude  :=  NULL::numeric                      --  NULL 
             ,p_vl_addr_longitude :=  NULL::numeric                      --  NULL
              -- 
             ,p_oper_type_id :=  _data.oper_type_id  -- Операция
             ,p_sw    := p_sw_hist 
             ,p_duble := p_sw_duble
          );
          
          _r_upd := _r_upd + 1; 
       END LOOP;
   
    RETURN _r_upd;
    
   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_street_upd (text, text, text, uuid[], boolean, boolean) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_street_upd (text, text, text, uuid[], boolean, boolean) 
IS 'Обновление адресов улиц';
----------------------------------------------------------------------------------
-- USE CASE:
-- SELECT gar_tmp_pcg_trans.f_adr_street_upd ('unsi') ; 
-- SELECT * from gar_tmp.obj_seq;
-- SELECT * FROM  gar_tmp_pcg_trans.f_adr_street_show (2) WHERE ( id_street > 50000000);
-- SELECT * FROM unsi.adr_street WHERE ( id_street > 50000000);
-- DELETE FROM unsi.adr_street WHERE ( id_street > 50000000);

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_ins (text[], uuid[]);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_ins (text, text, uuid[]);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_ins (text, text, uuid[], boolean);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_ins (text, text, text, uuid[], boolean, boolean);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_house_ins (
           p_schema_data    text -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl     text -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist    text -- Схема для хранения исторических данных 
          ,p_nm_guids_fias  uuid[]  = NULL  -- Список обрабатываемых GUID, NULL - все.
          ,p_sw             boolean = TRUE  -- Включить дополнение/обновление adr_objects
          ,p_sw_twin        boolean = FALSE -- Включается поиск двойников        
)
    RETURNS integer
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
     _data   RECORD;  
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
     
   BEGIN
    -- ----------------------------------------------------------------------------------------
    --  2021-12-10 Nick  Обновление и дополнение адресных свойств домов.
    --  2022-01-24 Одна схема с обрабатываемыми данными и одна - для ссылки,
    --              на таблицы "адресные пространства" и улицы".
    --  2022-02-10  Исторические данные в отдельной схеме.
    --      -- --------------------------------------------------------------------------------
    --  2022-05-20 "Cause belli" - Необходимо определять дополнительные типы по их
    --                                имени, поставляемом в агрегированной структуре "xxx".
    --   Было:
    --    SELECT id_house_type, nm_house_type_short INTO _id_house_type_2, _nm_house_type_2
    --      FROM gar_tmp.xxx_adr_house_type WHERE (_data.add_type1 = kd_house_type_lvl) LIMIT 1;
    --    
    --    Необходимо          
    --    SELECT id_house_type, nm_house_type_short INTO _id_house_type_2, _nm_house_type_2
    --      FROM gar_tmp.xxx_adr_house_type 
    --                      WHERE (lower(_data.add_type1_name) = lower(nm_house_type)) LIMIT 1;          
    --    --          
    --    SELECT id_house_type, nm_house_type_short INTO _id_house_type_3, _nm_house_type_3
    --      FROM gar_tmp.xxx_adr_house_type 
    --                      WHERE (lower(_data.add_type2_name) = lower(nm_house_type)) LIMIT 1; 
    -- ----------------------------------------------------------------------------------------
    --   2022-05-31 Уточняю определение родительского объекта и правила вычисления типов.   
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
              
           FROM gar_tmp.xxx_adr_house h  -- 96167
              
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
    
         CONTINUE WHEN (_id_area IS NULL); -- НЕ были загружены Ни улицы, Ни адресные объекты.
         --                                -- ??? Костыль 
         _id_house_type_1 := NULL; 
         _nm_house_type_1 := NULL;
         
         IF (_data.house_type IS NOT NULL) 
           THEN  -- 2022-05-20 !!! Создаются новые записи
             SELECT id_house_type, nm_house_type_short INTO _id_house_type_1, _nm_house_type_1
               FROM gar_tmp.xxx_adr_house_type WHERE (_data.house_type = ANY (fias_ids));  
         END IF;                                      
         
         CONTINUE WHEN ((_id_house_type_1 IS NULL) OR (_nm_house_type_1 IS NULL)); -- 2022-02-21
         
         _nm_house_full := '';
         _nm_house_full := _nm_house_full || _nm_house_type_1 || ' ' || _data.house_num || ' ';
         
         _id_house_type_2 := NULL; 
         _nm_house_type_2 := NULL;
         
         IF (_data.add_type1 IS NOT NULL) 
           THEN
              SELECT y1.id_house_type, y1.nm_house_type_short 
                                             INTO _id_house_type_2, _nm_house_type_2
                FROM gar_tmp.xxx_adr_house_type y1 
                    WHERE (btrim(lower(_data.add_type1_name)) = btrim(lower(y1.nm_house_type))) LIMIT 1;   
              --
              -- 2022-05-31
              IF ( _id_house_type_2 IS NULL) OR (_nm_house_type_2 IS NULL)
                THEN
                    SELECT z1.id_house_type, z1.nm_house_type_short 
                                      INTO _id_house_type_2, _nm_house_type_2
                      FROM gar_tmp.xxx_adr_house_type z1 
                          WHERE (_data.add_type1 = z1.kd_house_type_lvl) LIMIT 1;   
              END IF;
              -- 2022-05-31
         END IF;         
         --
         _id_house_type_3 := NULL; 
         _nm_house_type_3 := NULL;
         --
         IF (_data.add_type2 IS NOT NULL) 
           THEN
              SELECT y2.id_house_type, y2.nm_house_type_short 
                                              INTO _id_house_type_3, _nm_house_type_3
                FROM gar_tmp.xxx_adr_house_type y2 
                   WHERE (btrim(lower(_data.add_type2_name)) = btrim(lower(y2.nm_house_type))) LIMIT 1;   
              -- 2022-05-31
              IF ( _id_house_type_3 IS NULL) OR (_nm_house_type_3 IS NULL)
                THEN
                    SELECT z2.id_house_type, z2.nm_house_type_short 
                                      INTO _id_house_type_3, _nm_house_type_3
                      FROM gar_tmp.xxx_adr_house_type z2 
                          WHERE (_data.add_type2 = z2.kd_house_type_lvl) LIMIT 1;   
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

    RETURN _r_ins;
    
   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_house_ins (text, text, text, uuid[], boolean, boolean) OWNER TO postgres;  

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

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_upd (text[], uuid[]);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_upd (text, text, uuid[]);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_upd (text, text, uuid[], boolean);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_upd (text, text, text, uuid[], boolean, boolean, boolean);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_upd 
                           (text, text, text, uuid[], boolean, boolean, boolean, boolean);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_house_upd (

           p_schema_data    text -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl     text -- Схема эталон, обычно локальный сервер, копия p_schema_data 
          ,p_schema_hist    text -- Схема для хранения исторических данных 
          ,p_nm_guids_fias  uuid[]  = NULL -- Список обрабатываемых GUID, NULL - все.
          ,p_sw_hist   boolean = TRUE  -- Создаётся историческая запись.  
          ,p_sw_duble  boolean = FALSE -- Обязательное выявление дубликатов
          ,p_sw        boolean = FALSE -- Включить дополнение/обновление adr_objects
          ,p_del       boolean = FALSE -- Убираю дубли при обработки EXCEPTION 
)
    RETURNS integer
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
      ID_OBJECT_TYPE constant integer := 17; -- Это костыль, 
      --              кодификация типов разошлась с ГАР-ФИАС.
      --   Свести можно только том случае, если будет подружаться более широкая 
      --   номенклатура адресных объектов: квартиры, участки, автостоянки.            
   
     _r_upd   integer := 0;   
     --
     _data   RECORD;  
     _parent gar_tmp.adr_street_t;
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
    
    _id_houses  bigint[]; 
     --
     --  2021-12-26
     --
     _id_object    bigint;     
     
   BEGIN
    -- -----------------------------------------------------------------------------------
    --  2021-12-10 Nick  Обновление и дополнение адресных свойств домов.
    --  2022-01-24 Одна схема с обрабатываемыми данными и одна - для ссылки,
    --              на таблицы "адресные пространства" и улицы".
    --  2022-02-11 Выделение истории в отдельную таблицу.
    -- -----------------------------------------------------------------------------------
    --  2022-05-20 "Cause belli" - Необходимо определять дополнительные типы по их
    --                                имени, поставляемом в агрегированной структуре "xxx".
    --   Было:
    --    SELECT id_house_type, nm_house_type_short INTO _id_house_type_2, _nm_house_type_2
    --      FROM gar_tmp.xxx_adr_house_type WHERE (_data.add_type1 = kd_house_type_lvl) LIMIT 1;
    --    
    --    Необходимо          
    --    SELECT id_house_type, nm_house_type_short INTO _id_house_type_2, _nm_house_type_2
    --      FROM gar_tmp.xxx_adr_house_type 
    --                       WHERE (lower(_data.add_type1_name) = lower(nm_house_type)) LIMIT 1;          
    --    --          
    --    SELECT id_house_type, nm_house_type_short INTO _id_house_type_3, _nm_house_type_3
    --      FROM gar_tmp.xxx_adr_house_type 
    --                      WHERE (lower(_data.add_type2_name) = lower(nm_house_type)) LIMIT 1;          
    -- -----------------------------------------------------------------------------------
    --   2022-05-31 Уточняю определение родительского объекта и правила вычисления типов.    
    -- ----------------------------------------------------------------------------------- 
    --     p_schema_data    -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
    --    ,p_schema_etl     -- Схема эталон, обычно локальный сервер, копия p_schema_data 
    --    ,p_schema_hist    -- Схема для хранения исторических данных 
    --    ,p_nm_guids_fias  -- Список обрабатываемых GUID, NULL - все.
    -- -----------------------------------------------------------------------------------
    --    ,p_sw_hist  -- Создаётся историческая запись.  
    --    ,p_sw_duble -- Обязательное выявление дубликатов
    --    ,p_sw       -- Включить дополнение/обновление adr_objects
    --    ,p_del      -- Убираю дубли при обработки EXCEPTION 
    -- -----------------------------------------------------------------------------------
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
              , h.house_num             AS house_num
              --
              , h.add_num1              AS add_num1            
              , h.add_num2              AS add_num2            
              , h.house_type            AS house_type          
              , h.house_type_name       AS house_type_name     
              , h.house_type_shortname  AS house_type_shortname
              --
              , h.add_type1             AS add_type1          
              , h.add_type1_name        AS add_type1_name     
              , h.add_type1_shortname   AS add_type1_shortname
              , h.add_type2             AS add_type2          
              , h.add_type2_name        AS add_type2_name     
              , h.add_type2_shortname   AS add_type2_shortname
                --
               ,(p.type_param_value -> '5'::text) AS nm_zipcode   
               ,(p.type_param_value -> '7'::text) AS kd_oktmo
               ,(p.type_param_value -> '6'::text) AS kd_okato    
              --
              , h.oper_type_id
              , h.oper_type_name
              
           FROM gar_tmp.xxx_adr_house h   
              
              INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = h.fias_guid) 
              LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (h.id_house = p.object_id)              
              
            WHERE (f.id_obj IS NOT NULL) AND (f.type_object = 2) 
                    AND
                  (((h.fias_guid = ANY (p_nm_guids_fias)) AND 
	               (p_nm_guids_fias IS NOT NULL)) OR (p_nm_guids_fias IS NULL)
	              )                     
       LOOP
      
         -- 2022-05-31
         --              level_id |           level_name       
         --             ----------+------------------------------------
         --                     1 | Субъект РФ                               
         --                     2 | Административный район                   
         --                     3 | Муниципальный район                      
         --                     4 | Сельское/городское поселение             
         --                     5 | Город                                    
         --                     6 | Населенный пункт                         
         --                     7 | Элемент планировочной структуры          
         --                     8 | Элемент улично-дорожной сети             
         --                     9 | Земельный участок                        
         
         IF (_data.parent_level_id IN (8, 9))  -- ??
           THEN
              _parent := gar_tmp_pcg_trans.f_adr_street_get (p_schema_etl, _data.nm_fias_guid_parent);
              _id_area   := _parent.id_area;   
              _id_street := _parent.id_street;    
           
           ELSE
            _id_area   := (gar_tmp_pcg_trans.f_adr_area_get (p_schema_etl, _data.nm_fias_guid_parent)).id_area;   
            _id_street := NULL;  
           
         END IF;
         
         CONTINUE WHEN (_id_area IS NULL); -- НЕ были загружены Ни улицы, Ни адресные объекты.
         -- 2022-05-31
         
         _id_house_type_1 := NULL; 
         _nm_house_type_1 := NULL;
         
         IF (_data.house_type IS NOT NULL) 
           THEN -- 2022-05-20 Обновляются старые ДАННЫЕ.
             SELECT id_house_type, nm_house_type_short INTO _id_house_type_1, _nm_house_type_1
               FROM gar_tmp.xxx_adr_house_type 
                         WHERE (_data.house_type = ANY (fias_ids));  
         END IF;
         
         CONTINUE WHEN ((_id_house_type_1 IS NULL) OR (_nm_house_type_1 IS NULL)); -- 2022-02-21
         
         _nm_house_full := '';
         _nm_house_full := _nm_house_full || _nm_house_type_1 || ' ' || _data.house_num || ' ';
         
         _id_house_type_2 := NULL; 
         _nm_house_type_2 := NULL;
         
         IF (_data.add_type1 IS NOT NULL) 
           THEN
              SELECT y1.id_house_type, y1.nm_house_type_short 
                                             INTO _id_house_type_2, _nm_house_type_2
                FROM gar_tmp.xxx_adr_house_type y1 
                    WHERE (btrim(lower(_data.add_type1_name)) = btrim(lower(y1.nm_house_type))) LIMIT 1;   
              --
              -- 2022-05-31
              IF ( _id_house_type_2 IS NULL) OR (_nm_house_type_2 IS NULL)
                THEN
                    SELECT z1.id_house_type, z1.nm_house_type_short 
                                      INTO _id_house_type_2, _nm_house_type_2
                      FROM gar_tmp.xxx_adr_house_type z1 
                          WHERE (_data.add_type1 = z1.kd_house_type_lvl) LIMIT 1;   
              END IF;
              -- 2022-05-31
         END IF;
         --
         _id_house_type_3 := NULL; 
         _nm_house_type_3 := NULL;
         
         IF (_data.add_type2 IS NOT NULL) 
           THEN
              SELECT y2.id_house_type, y2.nm_house_type_short 
                                              INTO _id_house_type_3, _nm_house_type_3
                FROM gar_tmp.xxx_adr_house_type y2 
                   WHERE (btrim(lower(_data.add_type2_name)) = btrim(lower(y2.nm_house_type))) LIMIT 1;   
              -- 2022-05-31
              IF ( _id_house_type_3 IS NULL) OR (_nm_house_type_3 IS NULL)
                THEN
                    SELECT z2.id_house_type, z2.nm_house_type_short 
                                      INTO _id_house_type_3, _nm_house_type_3
                      FROM gar_tmp.xxx_adr_house_type z2 
                          WHERE (_data.add_type2 = z2.kd_house_type_lvl) LIMIT 1;   
              END IF;
              -- 2022-05-31
         END IF;        
         --
         IF (_data.add_num1 IS NOT NULL) AND (_nm_house_type_2 IS NOT NULL)
           THEN
              _nm_house_full := _nm_house_full || _nm_house_type_2 || ' ' ||  _data.add_num1 || ' ';    
            ELSE         
                _id_house_type_2 := NULL;
                _nm_house_type_2 := NULL;                
         END IF;
         --
         IF (_data.add_num2 IS NOT NULL) AND (_nm_house_type_3 IS NOT NULL)
           THEN
                _nm_house_full := _nm_house_full || _nm_house_type_3 || ' ' ||  _data.add_num2;     
            ELSE                
                _id_house_type_3 := NULL;
                _nm_house_type_3 := NULL;    
         END IF;    
         
         _nm_house_full := btrim (_nm_house_full); 
    --
    --     p_schema_data    -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
    --    ,p_schema_etl     -- Схема эталон, обычно локальный сервер, копия p_schema_data 
    --    ,p_schema_hist    -- Схема для хранения исторических данных 
    --    ,p_nm_guids_fias  -- Список обрабатываемых GUID, NULL - все.
    --    ,p_sw_hist        -- Создаётся историческая запись.  
    --    ,p_sw_duble       -- Обязательное выявление дубликатов
    --    ,p_sw             -- Включить дополнение/обновление adr_objects         
         
         _id_houses := gar_tmp_pcg_trans.fp_adr_house_upd (
         
               p_schema_name := p_schema_data
              ,p_schema_h    := p_schema_hist   -- Историческая схема
                --
              ,p_id_house  := NULL::bigint  --          --  NOT NULL
              ,p_id_area   :=  _id_area::bigint         --  NOT NULL
              ,p_id_street :=  _id_street::bigint       --   NULL
               --
              ,p_id_house_type_1   := _id_house_type_1::integer    --   NULL
              ,p_nm_house_1        := _data.house_num::varchar(70) --   NULL
              ,p_id_house_type_2   := _id_house_type_2::integer    --   NULL
              ,p_nm_house_2        := _data.add_num1::varchar(50)  --   NULL
              ,p_id_house_type_3   := _id_house_type_3::integer    --   NULL
              ,p_nm_house_3        := _data.add_num2::varchar(50)  --   NULL
               --
              ,p_nm_zipcode        := _data.nm_zipcode::varchar(20)   --   NULL
              ,p_nm_house_full     := _nm_house_full --  varchar(250) --  NOT NULL
              ,p_kd_oktmo          := _data.kd_oktmo::varchar(11)  --  NULL
              ,p_nm_fias_guid      := _data.nm_fias_guid::uuid     --  NULL  
              ,p_id_data_etalon    := NULL::bigint                 --  NULL
              ,p_kd_okato          := _data.kd_okato::varchar(11)  --  NULL
              ,p_vl_addr_latitude  := NULL::numeric      --  NULL
              ,p_vl_addr_longitude := NULL::numeric      --  NULL 
              --
              ,p_sw    := p_sw_hist   -- Создаётся историческая запись.  
              ,p_duble := p_sw_duble  -- Обязательное выявление дубликатов   
              ,p_del   := p_del       -- Убираю дубли при обработки EXCEPTION               
         );
        ---   -- Адресный объект, пока только улицы (участки, квартиры и офисы). 
        ---   ----------------------------------------------------------------------
         IF ((p_sw) AND (_id_houses[1] IS NOT NULL)) 
           THEN
                  _id_object := _id_houses[1];
                  
                  CALL gar_tmp_pcg_trans.p_adr_object_upd (        
                        p_schema_name := p_schema_data
                       ,p_schema_h    := p_schema_hist   -- Историческая схема
                         --
                       ,p_id_object := _id_object::bigint   --  NOT NULL
                       ,p_id_area   := _id_area::bigint                --  NOT NULL
                       ,p_id_house  := _id_houses[1]::bigint           --  NOT NULL
                       ,p_id_object_type   := ID_OBJECT_TYPE::integer  --   NOT NULL
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
                       ,p_twin_id := _id_houses[2] --_Его необходимо удалить.
                       ,p_sw      := p_sw_hist   -- Создаётся историческая запис
                  );   
          END IF;
         ----------------------------------------------------------------------  
       
         _r_upd := _r_upd + 1; 
       END LOOP;           
           
    RETURN _r_upd;
    
   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_house_upd (text, text, text, uuid[], boolean, boolean, boolean) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_house_upd (text, text, text, uuid[]
  , boolean, boolean, boolean, boolean) 
IS 'Обновление адресных свойств домов';
----------------------------------------------------------------------------------
-- USE CASE:
-- SELECT gar_tmp_pcg_trans.f_adr_house_upd ('unsi'); 
-- SELECT * from gar_tmp.obj_seq;
-- SELECT * FROM unsi.adr_house WHERE (id_house > 50000000);
-- SELECT * FROM unsi.adr_objects WHERE (id_object > 50000000);
-- DELETE FROM unsi.adr_house WHERE (id_house > 50000000);
-- DELETE FROM unsi.adr_objects WHERE (id_object > 50000000);
-- SELECT * FROM gar_tmp_pcg_trans.f_adr_house_show (2);

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_show_params_value (bigint[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_show_params_value (
       p_param_type_ids  bigint[] = ARRAY [5,6,7,10,11]::bigint[]
)
    RETURNS TABLE 

    ( object_id         bigint
     ,type_param_value  public.hstore
    ) 

    STABLE
    LANGUAGE sql
 AS
  $$
    -- ----------------------------------------------------------------------------------------------
    --  2021-11-24 Nick Получить список величин параметров объекта. Агрегация пар "Тип" - "Значение"
    -- ----------------------------------------------------------------------------------------------
    --           p_param_type_ids bigint[] -- Список типов параметров 
    -- ----------------------------------------------------------------------------------------------
    WITH a1 (  object_id
              ,type_id
              ,param_value
     )        
      AS (    
            SELECT z1.object_id, z1.type_id, z1.obj_value AS param_value FROM gar_fias.as_addr_obj_params z1 
                   WHERE (z1.type_id = ANY (p_param_type_ids)) 
                            AND (z1.start_date <= current_date) AND (z1.end_date > current_date)
               
              UNION ALL
            
            SELECT z2.object_id, z2.type_id, z2.param_value AS param_value FROM gar_fias.as_apartments_params z2
                   WHERE (z2.type_id = ANY (p_param_type_ids))
                            AND (z2.start_date <= current_date) AND (z2.end_date > current_date) 
            
              UNION ALL
            
            SELECT z3.object_id, z3.type_id, z3.param_value AS param_value FROM gar_fias.as_carplaces_params z3
                   WHERE (z3.type_id = ANY (p_param_type_ids))
                            AND (z3.start_date <= current_date) AND (z3.end_date > current_date)  
            
              UNION ALL
            
            SELECT z4.object_id, z4.type_id, z4.value AS param_value FROM gar_fias.as_houses_params z4
                   WHERE (z4.type_id = ANY (p_param_type_ids))
                            AND (z4.start_date <= current_date) AND (z4.end_date > current_date)  
                            
              UNION ALL
            
            SELECT z5.object_id, z5.type_id, z5.value AS param_value FROM gar_fias.as_rooms_params z5
                   WHERE (z5.type_id = ANY (p_param_type_ids))
                            AND (z5.start_date <= current_date) AND (z5.end_date > current_date)   
                            
              UNION ALL
            
            SELECT z6.object_id, z6.type_id, z6.type_value AS param_value FROM gar_fias.as_steads_params z6
                   WHERE (z6.type_id = ANY (p_param_type_ids))
                            AND (z6.start_date <= current_date) AND (z6.end_date > current_date)
      )
       --
      ,a2 (   object_id
             ,type_id
             ,param_value  
              
          ) AS (
                 SELECT a1.object_id, a1.type_id, a1.param_value 
                     FROM a1 
                       ORDER BY a1.object_id, a1.type_id
                 
             )
       --       
      ,a3 (  object_id
             ,type_param_value
             
           ) AS (  
                  SELECT a2.object_id, public.hstore ( array_agg (a2.type_id)::text[]
                                                      ,array_agg (a2.param_value)
                                      ) 
                   FROM a2
                            GROUP BY a2.object_id      
      )
        SELECT * FROM a3;
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_show_params_value (bigint[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_show_params_value (bigint[]) 
IS 'Получить список величин параметров объекта. Агрегация пар "Тип" - "Значение"';
----------------------------------------------------------------------------------
-- USE CASE:
--
-- SELECT * FROM gar_tmp_pcg_trans.f_show_params_value () WHERE (object_id = 60933804); 
 
-- Successfully run. Total query runtime: 3 secs 674 msec.  2862964 rows affected. NN
-- 302571 rows affected.	 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_set_params_value (bigint[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_set_params_value (
       p_param_type_ids  bigint[] = ARRAY [5,6,7,10,11]::bigint[]
) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_tmp, public
 AS
  $$
    -- ----------------------------------------------------------------------------------------------
    --  2021-11-24 Nick Для каждого объекта запомнить пары "Тип" - "Значение"
    -- ----------------------------------------------------------------------------------------------
    --           p_param_type_ids bigint[] -- Список типов параметров 
    -- ----------------------------------------------------------------------------------------------
    DECLARE
      _r  integer;
    
    BEGIN    
       INSERT INTO gar_tmp.xxx_type_param_value (object_id, type_param_value) 
             SELECT object_id, type_param_value 
                          FROM gar_tmp_pcg_trans.f_show_params_value (p_param_type_ids)
        ON CONFLICT (object_id) DO NOTHING;                  
             
       GET DIAGNOSTICS _r = ROW_COUNT;
       RETURN _r;      
    END;         
$$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_set_params_value (bigint[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_set_params_value (bigint[]) 
IS ' Запомнить агрегированные пары "Тип" - "Значение"';
----------------------------------------------------------------------------------
-- USE CASE:
--  truncate table gar_tmp.xxx_type_param_value ;
-- SELECT gar_tmp_pcg_trans.f_set_params_value (); -- NN 2862964
-- select * from  gar_tmp.xxx_type_param_value ;
--
--  SELECT object_id
--     ,(type_param_value -> '5') AS zipcode
--     ,(type_param_value -> '6') AS okato
--     ,(type_param_value -> '7') AS oktmo
--     ,(type_param_value -> '11') AS kladr
-- FROM gar_tmp.xxx_type_param_value WHERE (object_id <= 3);
 
	 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_area_show_data (date, bigint, bigint[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_show_data (
       p_date          date     = current_date
      ,p_obj_level     bigint   = 10
      ,p_oper_type_ids bigint[] = NULL::bigint[]
)
    RETURNS SETOF gar_tmp.xxx_adr_area
    STABLE
    LANGUAGE sql
 AS
  $$
    -- ---------------------------------------------------------------------------------------
    --  2021-10-19/2021-11-19/2022-08-17 Nick 
    --    Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_adr_area"
    --  2021-12-20 - Могут быть несколько активных записей с различными UUID, описывающих
    --  один и тот-же адресный объект. Выбираю самую свежую (по максимальнлому ID изменения).
    -- ---------------------------------------------------------------------------------------
    --   p_date      date         -- Дата на которую формируется выборка    
    --   p_obj_level bigint       -- Предельный уровень адресных объектов в иерархии.
    --   p_oper_type_ids bigint[] -- Необходимые типы операций  
    -- ---------------------------------------------------------------------------------------
    
    WITH RECURSIVE aa1 (
                         id_addr_obj       
                        ,id_addr_parent 
                        --
                        ,fias_guid        
                        ,parent_fias_guid 
                        --   
                        ,nm_addr_obj   
                        ,addr_obj_type_id  
                        ,addr_obj_type   
                        --
                        ,obj_level
                        ,level_name
                        --
                        ,region_code  -- 2021-12-01
                        ,area_code    
                        ,city_code    
                        ,place_code   
                        ,plan_code    
                        ,street_code    
                        --
                        ,change_id
                        ,prev_id
                        --
                        ,oper_type_id
                        ,oper_type_name               
                        --
                        ,start_date 
                        ,end_date    
                        --
                        ,tree_d            
                        ,level_d
                        ,cicle_d  
     ) AS (
        SELECT
           a.object_id
          ,NULLIF (ia.parent_obj_id, 0)
          --
          ,a.object_guid
          ,NULL::uuid
          --
          ,a.object_name
          ,a.type_id
          ,a.type_name
          --
          ,a.obj_level
          ,l.level_name
           --
          ,ia.region_code  -- 2021-12-01
          ,ia.area_code    
          ,ia.city_code    
          ,ia.place_code   
          ,ia.plan_code    
          ,ia.street_code    
           --             --
          ,a.change_id
          ,a.prev_id
           --             --
          ,a.oper_type_id
          ,ot.oper_type_name
          --
          ,a.start_date 
          ,a.end_date              
          --
          ,CAST (ARRAY [a.object_id] AS bigint []) 
          ,1
          ,FALSE
          
        FROM gar_fias.as_adm_hierarchy ia
        
          INNER JOIN gar_fias.as_addr_obj a 
                       ON (ia.object_id = a.object_id) AND
                          ((a.is_actual AND a.is_active) AND (a.end_date > p_date) AND
                               (a.start_date <= p_date)
                          )
          --                
          INNER JOIN gar_fias.as_object_level l 
                       ON (a.obj_level = l.level_id) AND (l.is_active) AND
                          ((l.end_date > p_date) AND (l.start_date <= p_date))
          --
          INNER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = a.oper_type_id) AND 
                                          (ot.is_active) AND ((ot.end_date > p_date) AND 
                                          (ot.start_date <= p_date))                            
        
        WHERE ((ia.parent_obj_id = 0) OR (ia.parent_obj_id IS NULL)) AND
              (ia.is_active) AND (ia.end_date > p_date) AND (ia.start_date <= p_date)

     
                 UNION ALL
    
        SELECT
           a.object_id
          ,ia.parent_obj_id
          --
          ,a.object_guid
          ,z.object_guid
          --
          ,a.object_name
          ,a.type_id          
          ,a.type_name
          --
          ,a.obj_level
          ,l.level_name
           --
          ,ia.region_code  -- 2021-12-01
          ,ia.area_code    
          ,ia.city_code    
          ,ia.place_code   
          ,ia.plan_code    
          ,ia.street_code    
           --             --
          ,a.change_id
          ,a.prev_id
           --             --
          ,a.oper_type_id
          ,ot.oper_type_name
          --
          ,a.start_date 
          ,a.end_date              
          --	       
          ,CAST (aa1.tree_d || a.object_id AS bigint [])
          ,(aa1.level_d + 1) t
          ,a.object_id = ANY (aa1.tree_d)   
        
           FROM gar_fias.as_addr_obj a
              INNER JOIN gar_fias.as_adm_hierarchy ia ON ((ia.object_id = a.object_id) AND (ia.is_active) 
                                                           AND (ia.end_date > p_date) 
                                                           AND (ia.start_date <= p_date)
                                                         )
              INNER JOIN gar_fias.as_addr_obj z ON (ia.parent_obj_id = z.object_id)
                                          AND ((z.is_actual AND z.is_active) AND (z.end_date > p_date) 
                                                  AND (z.start_date <= p_date)
                                          )
              INNER JOIN gar_fias.as_object_level l ON (a.obj_level = l.level_id) AND (l.is_active) 
                                                         AND ((l.end_date > p_date) AND
                                                              (l.start_date <= p_date)
                                                         )
              INNER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = a.oper_type_id) AND 
                                          (ot.is_active) AND ((ot.end_date > p_date) AND 
                                          (ot.start_date <= p_date))
                                          
              INNER JOIN aa1 ON (aa1.id_addr_obj = ia.parent_obj_id) AND (NOT aa1.cicle_d)
          
        WHERE (a.obj_level <= p_obj_level) 
                AND ((a.is_actual AND a.is_active) AND (a.end_date > p_date) 
                        AND (a.start_date <= p_date)
                )
     )
      , bb1 (   
                id_addr_obj       
               ,id_addr_parent 
               --
               ,fias_guid        
               ,parent_fias_guid 
               --   
               ,nm_addr_obj   
               ,addr_obj_type_id  
               ,addr_obj_type   
               --
               ,obj_level
               ,level_name
               --
               ,region_code  -- 2021-12-01
               ,area_code    
               ,city_code    
               ,place_code   
               ,plan_code    
               ,street_code    
               --
               ,change_id
               ,prev_id
               --
               ,oper_type_id
               ,oper_type_name               
               --
               ,start_date 
               ,end_date    
               --
               ,tree_d            
               ,level_d
               --
               ,rn
      )
       AS (
            SELECT  
                    aa1.id_addr_obj       
                   ,aa1.id_addr_parent 
                   --
                   ,aa1.fias_guid        
                   ,aa1.parent_fias_guid 
                   --   
                   ,aa1.nm_addr_obj    
                   ,aa1.addr_obj_type_id   
                   ,aa1.addr_obj_type               
                   --
                   ,aa1.obj_level
                   ,aa1.level_name
                    --
                   ,aa1.region_code  -- 2021-12-01
                   ,aa1.area_code    
                   ,aa1.city_code    
                   ,aa1.place_code   
                   ,aa1.plan_code    
                   ,aa1.street_code    
                    --             --
                   ,aa1.change_id
                   ,aa1.prev_id
                   --             --
                   ,aa1.oper_type_id
                   ,aa1.oper_type_name		 
                    --
                   ,aa1.start_date 
                   ,aa1.end_date              
                    --               
                   ,aa1.tree_d            
                   ,aa1.level_d

                  , max(aa1.change_id) OVER (PARTITION BY aa1.id_addr_parent 
                                            ,aa1.addr_obj_type-- _id  
                                            ,UPPER(aa1.nm_addr_obj) 
                                       ORDER BY aa1.change_id   
                    ) AS rn
                  
            FROM aa1 
              WHERE ((aa1.oper_type_id = ANY (p_oper_type_ids)) AND (p_oper_type_ids IS NOT NULL))
                       OR
                    (p_oper_type_ids IS NULL)  ORDER BY aa1.tree_d
          )
           SELECT
                    bb1.id_addr_obj       
                   ,bb1.id_addr_parent 
                   --
                   ,bb1.fias_guid        
                   ,bb1.parent_fias_guid 
                   --   
                   ,bb1.nm_addr_obj    
                   ,COALESCE (bb1.addr_obj_type_id,
                     (SELECT z.id FROM gar_fias.as_addr_obj_type z 
                            WHERE (z.type_shortname = bb1.addr_obj_type) 
--                                    AND     2022-08-17 В справочниках GAR может быть
--                                 (z.end_date > p_date)  несколько активных записей.
                                    AND 
                                 (z.type_level::bigint = bb1.obj_level)            
                      )
                    ) AS addr_obj_type_id
                   ,bb1.addr_obj_type               
                   --
                   ,bb1.obj_level
                   ,bb1.level_name
                    --
                   ,bb1.region_code  -- 2021-12-01
                   ,bb1.area_code    
                   ,bb1.city_code    
                   ,bb1.place_code   
                   ,bb1.plan_code    
                   ,bb1.street_code    
                    --             --
                   ,bb1.oper_type_id
                   ,bb1.oper_type_name		 
                    --
                   ,bb1.start_date 
                   ,bb1.end_date              
                    --               
                   ,bb1.tree_d            
                   ,bb1.level_d           
           FROM bb1 WHERE (bb1.change_id = bb1.rn);   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_show_data (date, bigint, bigint[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_show_data (date, bigint, bigint[]) 
IS 'Функция подготавливает исходные данные для таблицы-прототипа "gar_tmp.xxx_adr_area"';
----------------------------------------------------------------------------------
-- USE CASE:
--    EXPLAIN ANALyZE SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_show_data (); -- 1184
-- CALL gar_tmp_pcg_trans.p_gar_fias_crt_idx ();
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_show_data (p_obj_level := 22); 
-- SELECT count (1) FROM gar_tmp_pcg_trans.as_addr_obj; --7345  --- 1312 ?
-- SELECT count (1) FROM gar_tmp_pcg_trans.as_addr_obj a WHERE (a.is_actual AND a.is_active); -- 6093  -- 60 ??
--
-- SELECT count (1) FROM gar_tmp_pcg_trans.as_addr_obj a WHERE (a.is_actual AND a.is_active)  -- 6093 ??
-- AND (a.end_date > p_date) 
--                         AND (a.start_date <= p_date);
-- ------------------------------------------------------------
-- ALTER TABLE gar_tmp.xxx_adr_area ADD COLUMN addr_obj_type_id bigint;
-- COMMENT ON COLUMN gar_tmp.xxx_adr_area.addr_obj_type_id IS
-- 'ID типа объекта';

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_area_set_data (date, bigint, bigint[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_set_data (

       p_date          date     = current_date
      ,p_obj_level     bigint   = 10
      ,p_oper_type_ids bigint[] = NULL::bigint[]
      
) RETURNS integer

    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_tmp, public
 AS
  $$
    -- ----------------------------------------------------------------------------------------------
    --  2021-11-25 Nick Запомнить промежуточные данные, адресные объекты.
    -- ----------------------------------------------------------------------------------------------
    --      p_date          date     = Дата, на которую выбираются данные
    --     ,p_obj_level     bigint   = Уровень объекта
    --     ,p_oper_type_ids bigint[] = Типы операций.
    -- ----------------------------------------------------------------------------------------------
    DECLARE
      _r  integer;
    
    BEGIN   
       DROP INDEX IF EXISTS gar_tmp._xxx_adr_area_ie3;
       --    
       INSERT INTO gar_tmp.xxx_adr_area AS z (
       
                                  id_addr_obj      
                                 ,id_addr_parent   
                                 ,fias_guid        
                                 ,parent_fias_guid 
                                 ,nm_addr_obj   
                                 ,addr_obj_type_id   
                                 ,addr_obj_type    
                                 ,obj_level        
                                 ,level_name   
                                  --
                                 ,region_code  -- 2021-12-01
                                 ,area_code    
                                 ,city_code    
                                 ,place_code   
                                 ,plan_code    
                                 ,street_code    
                                  --                                 
                                 ,oper_type_id     
                                 ,oper_type_name  
                                  --
                                 ,start_date 
                                 ,end_date  
                                  --
                                 ,tree_d           
                                 ,level_d          
        )       
          SELECT   x.id_addr_obj      
                  ,x.id_addr_parent   
                  ,x.fias_guid        
                  ,x.parent_fias_guid 
                  ,x.nm_addr_obj  
                  ,x.addr_obj_type_id     
                  ,x.addr_obj_type    
                  ,x.obj_level        
                  ,x.level_name
                   --
                  ,x.region_code  -- 2021-12-01
                  ,x.area_code    
                  ,x.city_code    
                  ,x.place_code   
                  ,x.plan_code    
                  ,x.street_code    
                   --                                 
                  ,x.oper_type_id     
                  ,x.oper_type_name  
                   --
                  ,x.start_date 
                  ,x.end_date  
                   --                  
                  ,x.tree_d           
                  ,x.level_d          
          
          FROM gar_tmp_pcg_trans.f_xxx_adr_area_show_data (
                                 p_date          
                                ,p_obj_level     
                                ,p_oper_type_ids 
          ) x
               ON CONFLICT (id_addr_obj) DO 
               
               UPDATE
                    SET
                          id_addr_parent   = excluded.id_addr_parent    
                         ,fias_guid        = excluded.fias_guid       
                         ,parent_fias_guid = excluded.parent_fias_guid
                         ,nm_addr_obj      = excluded.nm_addr_obj    
                         ,addr_obj_type_id = excluded.addr_obj_type_id                            
                         ,addr_obj_type    = excluded.addr_obj_type   
                         ,obj_level        = excluded.obj_level       
                         ,level_name       = excluded.level_name      
                          --
                         ,region_code      = excluded.region_code -- 2021-12-01
                         ,area_code        = excluded.area_code  
                         ,city_code        = excluded.city_code  
                         ,place_code       = excluded.place_code 
                         ,plan_code        = excluded.plan_code  
                         ,street_code      = excluded.street_code
                          --                                 
                         ,oper_type_id     = excluded.oper_type_id    
                         ,oper_type_name   = excluded.oper_type_name
                          --
                         ,start_date       = excluded.start_date  -- 2021-12-06
                         ,end_date         = excluded.end_date
                          -- 
                         ,tree_d           = excluded.tree_d          
                         ,level_d          = excluded.level_d         
                  
               WHERE (z.id_addr_obj = excluded.id_addr_obj);
             
       GET DIAGNOSTICS _r = ROW_COUNT;
       
       CREATE INDEX IF NOT EXISTS _xxx_adr_area_ie3 
                                    ON gar_tmp.xxx_adr_area USING btree (obj_level);
       RETURN _r;      
    END;         
$$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_set_data (date, bigint, bigint[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_set_data (date, bigint, bigint[]) 
IS ' Запомнить промежуточные данные, адресные объекты';
----------------------------------------------------------------------------------
-- USE CASE:
--  SELECT * FROM gar_tmp.xxx_adr_area;  -- 19186
--  TRUNCATE TABLE gar_tmp.xxx_adr_area;
--  SELECT gar_tmp_pcg_trans.f_xxx_adr_area_set_data (); -- 19186
 
	 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
