DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data (text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data (
          p_schema_name  text  
)
    RETURNS setof gar_tmp.zzz_adr_area_type_t 
 
    LANGUAGE plpgsql
 AS
  $$
    -- ---------------------------------------------------------------
    --  2022-11-14 Nick Промежуточный набор данных.
    -- ----------------------------------------------------------------
    DECLARE
       _exec   text;
       _select text = $_$  
            INSERT INTO %I
            SELECT  
                   t.id_area_type       -- integer     -- ID типа дома, ОСНОВНОЙ	
                  ,t.nm_area_type       -- varchar(50) -- Наименованиек типа дома, ОСНОВНОЕ
                  ,t.nm_area_type_short -- varchar(10) -- Краткое наименованиек типа дома, ОСНОВНОЕ
                  ,t.pr_lead            -- smallint NOT NULL,    -- Признак ОСНОВНОЙ
                  ,t.dt_data_del	    -- timestamp without time zone -- Дата удаления ОСНОВНАЯ
                   ----
                  ,x.fias_ids           ::bigint[]    AS fias_ids               -- Исходные идентификаторы ГАР-ФИАС 
                  ,x.id_area_type       ::integer     AS id_area_type_tmp       -- ID типа дома, ПРОМЕЖУТОЧНЫЙ
                  ,x.fias_type_name	    ::varchar(50) AS fias_type_name	        -- Наименованиек типа дома, ГАР-ФИАС
                  ,x.nm_area_type       ::varchar(50) AS nm_area_type_tmp  	    -- Наименованиек типа дома, ПРОМЕЖУТОЧНОЕ
                  ,x.fias_type_shortname::varchar(20) AS fias_type_shortname    -- Краткое имя типа, ГАР-ФИАС
                  ,x.nm_area_type_short ::varchar(10) AS nm_area_type_short_tmp -- Краткое наименованиек типа дома ПРОМЕЖУТОЧНОЕ,
                  ,x.fias_row_key	    ::text        AS fias_row_key	        -- Уникальный идентификатор строки
                  
            FROM gar_tmp.xxx_adr_area_type x 
            
             LEFT JOIN %I.adr_area_type t
                   ON (x.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char (t.nm_area_type))
             ORDER BY t.id_area_type;       
       $_$;

    BEGIN
      CREATE TEMP TABLE IF NOT EXISTS __adr_area_type_z OF gar_tmp.zzz_adr_area_type_t
        ON COMMIT DROP;
      DELETE FROM __adr_area_type_z;  
      --
      _exec := format (_select, '__adr_area_type_z', p_schema_name);
      EXECUTE (_exec);
      --
      RETURN QUERY SELECT * FROM __adr_area_type_z ORDER BY id_area_type;                      
    END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data (text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data (text) 
IS 'Функция отображает "тип adr_area" из промежуточного хранилища.';
----------------------------------------------------------------------------------
-- USE CASE:
--           SELECT * FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp'); 
--           SELECT * FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('unnsi'); 
--
