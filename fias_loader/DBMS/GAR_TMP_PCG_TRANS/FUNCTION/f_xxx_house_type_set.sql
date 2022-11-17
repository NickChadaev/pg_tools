DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_house_type_set (text, text[], integer[], date, text[]);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_house_type_set (text, text[], integer[]);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_house_type_set (text, text[], integer[], integer, boolean);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_set (
        p_schema_etalon text 
       ,p_schemas       text[]
       ,p_op_type       integer[] = ARRAY[1,2]
       ,p_delta         integer   = 2
       ,p_clear_all     boolean   = TRUE
)

  RETURNS SETOF integer

    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_tmp, public
 AS
  $$
    -- ----------------------------------------------------------------------------------------------
    --  2021-12-01 Nick Запомнить промежуточные данные, типы домов.
    --  2022-02-18 добавлен столбец kd_house_type_lvl - 'Уровень типа номера (1-основной)'
    --  2022-11-11 Меняю USE CASE таблицы, теперь это буфер для последующего дополнения 
    --             адресного справочника.    
    -- ----------------------------------------------------------------------------------------------
    --   p_schema_etalon  text      -- Схема с эталонныями справочниками.
    --   p_schemas        text[]    -- Список обновляемых схем (Здесь может быть эталон).
    --   p_op_type        integer[] -- Список выполняемых операций, пока только две.     
    -- ----------------------------------------------------------------------------------------------
    DECLARE
      _r  integer;
      
      _OP_1 CONSTANT integer = 1;
      _OP_2 CONSTANT integer = 2;
      _LD   CONSTANT integer = 1000;
      
      _schema_name text;
      _qty         integer = 0;
      _rdata       RECORD;
      
      _exec text;
      
      _del_something text = $_$
           DELETE FROM %I.adr_house_type;
       $_$;      
     
    BEGIN   
     --
     -- 1) Запомнить данные в промежуточной структуре. Выбираем из справочника-эталона.
     --  
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
                     ,COALESCE (x.id_house_type, (x.fias_ids[1] + _LD)) AS id_house_type
                     ,x.fias_type_name      
                     ,COALESCE (x.nm_house_type, x.fias_type_name::varchar(50)) AS nm_house_type 
                     ,x.fias_type_shortname
                     ,COALESCE (x.nm_house_type_short, x.fias_type_shortname::varchar(10)) AS nm_house_type_short
                     ,COALESCE (x.kd_house_type_lvl, 1) AS kd_house_type_lvl
                     ,x.fias_row_key        
                     ,x.is_twin  
                     
             FROM gar_tmp_pcg_trans.f_xxx_house_type_show_data (p_schema_etalon) x
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
     -- 2) Обновить данными из промежуточной структуры. Схемы-Цели (ЛОКАЛЬНЫЕ И ОТДАЛЁННЫЕ СПРАВОЧНИКИ).
     --       
     --   2.1) Цикл по схемам-целям
     --           2.1.1) Цикл по записям из промежуточно структуры.
     --                    с обновлением ЦЕЛЕЙ.                    
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
                    WHEN z.id_house_type < _LD
                      THEN z.id_house_type
                      ELSE row_number() OVER ()  
                  END AS id_house_type
                  
                 ,z.id_house_type       AS id_house_type_aux
                 ,z.nm_house_type       AS nm_house_type 
                 ,z.nm_house_type_short AS nm_house_type_short
                 ,z.kd_house_type_lvl   AS kd_house_type_lvl
                 ,NULL AS data_del
                 ,z.fias_row_key   
                 
              FROM gar_tmp.xxx_adr_house_type z ORDER BY z.id_house_type
              
            LOOP 
               CALL gar_tmp_pcg_trans.p_adr_house_type_set (

                  p_schema_name   := _schema_name::text  
                 ,p_id_house_type := CASE 
                                       WHEN _rdata.id_house_type_aux < _LD
                                         THEN 
                                            _rdata.id_house_type
                                         ELSE   
                                            (_rdata.id_house_type + p_delta)::integer  
                                     END::integer
                 
                 ,p_nm_house_type       := _rdata.nm_house_type::varchar(50)  
                 ,p_nm_house_type_short := _rdata.nm_house_type_short::varchar(10) 
                 ,p_kd_house_type_lvl   := _rdata.kd_house_type_lvl::integer
                 ,p_dt_data_del         := _rdata.data_del::timestamp without time zone                
                 
               );
               _qty := _qty + 1;            
            END LOOP;
                
            RETURN NEXT _qty;
            _qty := 0;
                              
         END LOOP; -- FOREACH _schema_name
      
     END IF;       
    END;         
$$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_set (text, text[], integer[], integer, boolean) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_house_type_set (text, text[], integer[], integer, boolean) 
IS ' Запомнить промежуточные данные, типы домов, обновить ОТДАЛЁННЫЕ справочники.';
----------------------------------------------------------------------------------
-- USE CASE:
--  SELECT * FROM  gar_tmp.xxx_adr_house_type;
--  TRUNCATE TABLE gar_tmp.adr_house_type;
--  TRUNCATE TABLE gar_tmp.xxx_adr_house_type;
--  SELECT * FROM  gar_tmp.adr_house_type ORDER BY id_house_type; 
--  SELECT * FROM  unnsi.adr_house_type ORDER BY id_house_type; 
--
-- SELECT gar_tmp_pcg_trans.f_xxx_house_type_set ('gar_tmp',NULL, ARRAY [1]); -- 12
-- SELECT * FROM gar_tmp_pcg_trans.f_zzz_house_type_show_tmp_data ('gar_tmp'); 
-- SELECT gar_tmp_pcg_trans.f_xxx_house_type_set ('gar_tmp',ARRAY['unnsi'], ARRAY [2]);
-- SELECT gar_tmp_pcg_trans.f_xxx_house_type_set ('gar_tmp',ARRAY['gar_tmp','unnsi'], ARRAY [2]);
