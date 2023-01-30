DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_area_type_set (text,text[],integer[],date, text[]);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_area_type_set (text,text[],integer[],integer,boolean);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_type_set (
       
        p_schema_etalon text 
       ,p_schemas       text[]
       ,p_op_type       integer[] = ARRAY[1,2] 
       ,p_delta         integer   = 0
       ,p_clear_all     boolean   = TRUE
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
        -- ----------------------------------------------------------------------------------------
    --   2022-11-11 Меняю USE CASE таблицы, теперь это буфер для последующего дополнения 
    --             адресного справочника.
    -- ----------------------------------------------------------------------------------------------
    --     p_schema_etalon  text      -- Схема с эталонными справочниками.
    --     p_schemas        text[]    -- Список обновляемых схем (Здесь может быть эталон).
    --     p_op_type        integer[] -- Список выполняемых операций, пока только две.     
    --     p_date           date      -- Дата на которую формируется выборка из "gar_fias".       
    -- ----------------------------------------------------------------------------------------------    
    DECLARE
      _r  integer;
      
      _OP_1 CONSTANT integer := 1;
      _OP_2 CONSTANT integer := 2;
      _LD   CONSTANT integer := 1000;      
      
      _schema_name text;
      _qty         integer := 0;
      _rdata       RECORD;
      _exec text;
      
      _del_something text = $_$
           DELETE FROM %I.adr_area_type nt;
       $_$;     
       
    BEGIN 
       --
       -- 1) Запомнить данные в промежуточной структуре. Выбираем из справочника-эталона.
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
                       ,COALESCE (x.id_area_type, (fias_ids[1] + _LD)) AS id_area_type
                       ,x.fias_type_name      
                       ,COALESCE (x.nm_area_type, x.fias_type_name) AS nm_area_type 
                       ,x.fias_type_shortname 
                       ,COALESCE (x.nm_area_type_short, fias_type_shortname) AS nm_area_type_short
                       ,COALESCE (x.pr_lead, 0::smallint) AS pr_lead       
                       -- ------------------------------------------------------     
                       ,x.fias_row_key        
                       ,x.is_twin      
 
               FROM gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data (p_schema_etalon) 
                         x ORDER BY x.id_area_type, x.fias_type_name
               
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
       END IF; -- _OP_1
       --
       -- 2) Обновить данными из промежуточной структуры. Схемы-Цели (ЛОКАЛЬНЫЕ И ОТДАЛЁННЫЕ СПРАВОЧНИКИ).
       --       
       --   2.1) Цикл по схемам-целям
       --           2.1.1) Цикл по записям из промежуточно сруктуры.
       --                    с обновлением ЦЕЛЕЙ.      
       --
       IF (_OP_2 = ANY (p_op_type))
         THEN
           DROP SEQUENCE IF EXISTS  xxx_adr_area_type_seq;
           CREATE TEMPORARY SEQUENCE IF NOT EXISTS  xxx_adr_area_type_seq;
           --
           FOREACH _schema_name IN ARRAY p_schemas 
           LOOP
             PERFORM setval('xxx_adr_area_type_seq'::regclass
		          ,(SELECT MAX (z.id_area_type) FROM gar_tmp.xxx_adr_area_type z 
                     WHERE (z.id_area_type < _LD)) , true);
             --        
             IF p_clear_all
               THEN
                   _exec := format (_del_something, _schema_name);
                   EXECUTE _exec;
             END IF;
             --    
             FOR _rdata IN
             
                 SELECT 
                  CASE 
                      WHEN z.id_area_type < _LD
                        THEN z.id_area_type
                        ELSE nextval('xxx_adr_area_type_seq'::regclass) + p_delta
                  END AS id_area_type
                  
                 ,z.nm_area_type       AS nm_area_type 
                 ,z.nm_area_type_short AS nm_area_type_short
                 ,z.pr_lead            AS pr_lead
                 ,NULL AS data_del
                 ,z.fias_row_key 

             	FROM gar_tmp.xxx_adr_area_type z ORDER BY z.id_area_type
             LOOP
             
                  CALL gar_tmp_pcg_trans.p_adr_area_type_set (
                        p_schema_name  := _schema_name::text   
                       ,p_id_area_type := _rdata.id_area_type::integer
                       ,p_nm_area_type := _rdata.nm_area_type::varchar (50)               
                       ,p_nm_area_type_short := _rdata.nm_area_type_short::varchar(10)                        
                       ,p_pr_lead            := _rdata.pr_lead           ::smallint                      
                       ,p_dt_data_del        := _rdata.data_del          ::timestamp without time zone
                  );
                  _qty := _qty + 1; 
             END LOOP;  
             
             RETURN NEXT _qty;
             _qty := 0;
                  
           END LOOP; -- FOREACH _schema_name

        DROP SEQUENCE IF EXISTS  xxx_adr_area_type_seq;
       END IF; -- _OP_2
    END;         
$$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_type_set (text,text[],integer[],integer,boolean) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_area_type_set (text,text[],integer[],integer,boolean) 
IS 'Запомнить промежуточные данные, типы адресных объектов, обновить ОТДАЛЁННЫЕ справочники.';
----------------------------------------------------------------------------------
-- USE CASE:
--    SELECT * FROM  gar_tmp.xxx_adr_area_type;
--    TRUNCATE TABLE  gar_tmp.xxx_adr_area_type;       -- DONE
--  TRUNCATE TABLE  gar_tmp.adr_area_type;       -- DONE
--   delete from  unnsi.adr_area_type;  
--    SELECT * FROM  gar_tmp.adr_area_type ORDER BY id_area_type; 
--    SELECT * FROM  gar_test.adr_area_type ORDER BY id_area_type; 
--    
--    SELECT gar_tmp_pcg_trans.f_xxx_adr_area_type_set ('gar_tmp'::text,NULL, ARRAY [1]); -- 117
--    SELECT gar_tmp_pcg_trans.f_xxx_adr_area_type_set ('gar_tmp',ARRAY['unnsi'], ARRAY [2]); -- 117
--    SELECT gar_tmp_pcg_trans.f_xxx_adr_area_type_set ('gar_tmp',ARRAY['gar_tmp','gar_test'], ARRAY [2]);
