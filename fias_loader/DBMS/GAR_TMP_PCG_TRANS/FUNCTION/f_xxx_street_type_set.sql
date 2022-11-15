DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_street_type_set(text, text[], integer[], date, text[]);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_street_type_set (text,text[],integer[],date,integer,boolean);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_set (
       
        p_schema_etalon  text 
       ,p_schemas        text[]
       ,p_op_type        integer[] = ARRAY[1,2] 
       ,p_date           date      = current_date
       ,p_delta          integer   = 0
       ,p_clear_all      boolean   = TRUE       
)

  RETURNS SETOF integer

    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_tmp, public
 AS
  $$
    -- -----------------------------------------------------------------------------------
    --  2021-12-01/2021-12-14 Nick Запомнить промежуточные данные, типы улиц, обновить 
    --                  отдалённые справочники.
    --  2022-11-11 Меняю USE CASE таблицы, теперь это буфер для последующего дополнения 
    --             адресного справочника.        
    -- -----------------------------------------------------------------------------------
    DECLARE
      _r integer;
      
      _OP_1 CONSTANT integer = 1;
      _OP_2 CONSTANT integer = 2;
      _LD   CONSTANT integer = 1000;      
      
      _schema_name text;
      _qty         integer = 0;
      _rdata       RECORD;
    
      _exec text;
      
      _del_something text = $_$
           DELETE FROM %I.adr_street_type nt;
       $_$;       
    
    BEGIN   
     --
     -- 1) Запомнить данные в промежуточной структуре. Выбираем из справочника-эталона.
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
                  ,COALESCE (x.id_street_type, (x.fias_ids[1] + _LD)) AS id_street_type
                  ,x.fias_type_name      
                  ,COALESCE (x.nm_street_type, x.fias_type_name) AS nm_street_type 
                  ,x.fias_type_shortname 
                  ,COALESCE (x.nm_street_type_short, x.fias_type_shortname) AS nm_street_type_short
                  ,x.fias_row_key        
                  ,x.is_twin 
                  
          FROM gar_tmp_pcg_trans.f_xxx_street_type_show_data (p_schema_etalon) x
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
            IF p_clear_all
              THEN
                   _exec := format (_del_something, _schema_name);
                   EXECUTE _exec;
            END IF;
            -- 
            FOR _rdata IN 
              SELECT 
                  CASE 
                    WHEN z.id_street_type < _LD
                      THEN z.id_street_type
                      ELSE row_number() OVER ()  
                  END AS id_street_type
                  --                  
                 ,z.id_street_type       AS id_street_type_aux
                 ,z.nm_street_type       AS nm_street_type 
                 ,z.nm_street_type_short AS nm_street_type_short
                 ,NULL AS data_del
                 ,z.fias_row_key   
                 
              FROM gar_tmp.xxx_adr_street_type z ORDER BY z.fias_row_key
            LOOP 
            
               CALL gar_tmp_pcg_trans.p_adr_street_type_set (
                      p_schema_name := _schema_name::text  
                      
                     ,p_id_street_type := 
                           CASE 
                               WHEN _rdata.id_street_type_aux < _LD
                                 THEN 
                                    _rdata.id_street_type
                                 ELSE   
                                    (_rdata.id_street_type + p_delta)::integer  
                           END::integer                     
                     
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
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_set (text,text[],integer[],date,integer,boolean) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_street_type_set (text,text[],integer[],date,integer,boolean) 
IS ' Запомнить промежуточные данные, типы улицы, обновить ОТДАЛЁННЫЕ справочники.';
----------------------------------------------------------------------------------
-- USE CASE:

--  SELECT * FROM  gar_tmp.xxx_adr_street_type;
--  TRUNCATE TABLE  gar_tmp.xxx_adr_street_type;
--  SELECT * FROM  gar_tmp.adr_street_type ORDER BY id_street_type; 
--  SELECT * FROM  unnsi.adr_street_type ORDER BY id_street_type; 
--
-- SELECT gar_tmp_pcg_trans.f_xxx_street_type_set ('gar_tmp',ARRAY['unnsi'], ARRAY [1]); -- 78
-- SELECT gar_tmp_pcg_trans.f_xxx_street_type_set ('gar_tmp',ARRAY['unnsi'], ARRAY [2]);
-- SELECT gar_tmp_pcg_trans.f_xxx_street_type_set ('gar_tmp',ARRAY['gar_tmp','unnsi'], ARRAY [2]);
