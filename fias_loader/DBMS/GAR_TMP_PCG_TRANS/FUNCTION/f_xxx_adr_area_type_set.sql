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
