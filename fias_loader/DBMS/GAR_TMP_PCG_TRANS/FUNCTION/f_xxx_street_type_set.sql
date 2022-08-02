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


