DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_zzz_house_type_show_tmp_data (text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_zzz_house_type_show_tmp_data (
          p_schema_name  text  
)
    RETURNS setof gar_tmp.zzz_adr_house_t 
 
    LANGUAGE plpgsql
 AS
  $$
    -- ---------------------------------------------------------------
    --  2022-11-14 Nick Промежуточный набо данных.
    -- ----------------------------------------------------------------
    DECLARE
       _exec   text;
       _select text = $_$  
            INSERT INTO __adr_house_type
            SELECT  
                   t.id_house_type       -- integer     -- ID типа дома, ОСНОВНОЙ	
                  ,t.nm_house_type       -- varchar(50) -- Наименованиек типа дома, ОСНОВНОЕ
                  ,t.nm_house_type_short -- varchar(10) -- Краткое наименованиек типа дома, ОСНОВНОЕ
                  ,t.kd_house_type_lvl   -- integer     -- Код уровня ОСНОВНОЙ
                  ,t.dt_data_del	     -- timestamp without time zone -- Дата удаления ОСНОВНАЯ
                   ----
                  ,x.fias_ids            AS fias_ids                -- bigint[]    -- Исходные идентификаторы ГАР-ФИАС 
                  ,x.id_house_type       AS id_house_type_tmp       -- integer     -- ID типа дома, ПРОМЕЖУТОЧНЫЙ
                  ,x.fias_type_name	     AS fias_type_name	        -- varchar(50) -- Наименованиек типа дома, ГАР-ФИАС
                  ,x.nm_house_type  	 AS nm_house_type_tmp  	    -- varchar(50) -- Наименованиек типа дома, ПРОМЕЖУТОЧНОЕ
                  ,x.fias_type_shortname AS fias_type_shortname     -- varchar(20) -- Краткое имя типа, ГАР-ФИАС
                  ,x.nm_house_type_short AS nm_house_type_short_tmp -- varchar(10) -- Краткое наименованиек типа дома ПРОМЕЖУТОЧНОЕ,
                  ,x.fias_row_key	     AS fias_row_key	        -- text -- Уникальный идентификатор строки
                  
            FROM %I.adr_house_type t
            
             LEFT JOIN  gar_tmp.xxx_adr_house_type x 
                   ON (x.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char (t.nm_house_type))
             ORDER BY t.id_house_type;       
       $_$;

    BEGIN
      CREATE TEMP TABLE __adr_house_type OF gar_tmp.zzz_adr_house_t
        ON COMMIT DROP;
      --
      _exec := format (_select, p_schema_name);
      EXECUTE (_exec);
      --
      RETURN QUERY SELECT * FROM __adr_house_type ORDER BY id_house_type;                      
    END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_zzz_house_type_show_tmp_data (text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_zzz_house_type_show_tmp_data (text) 
IS 'Функция отображает "тип дома" из промежуточного хранилища.';
----------------------------------------------------------------------------------
-- USE CASE:
--           SELECT * FROM gar_tmp_pcg_trans.f_zzz_house_type_show_tmp_data ('gar_tmp'); 
--           SELECT * FROM gar_tmp_pcg_trans.f_zzz_house_type_show_tmp_data ('unnsi'); 
--
