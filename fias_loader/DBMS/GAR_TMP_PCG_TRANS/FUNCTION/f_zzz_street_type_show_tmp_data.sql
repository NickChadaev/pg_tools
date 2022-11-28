DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data (text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data (
          p_schema_name  text  
)
    RETURNS setof gar_tmp.zzz_adr_street_type_t 
 
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
                   t.id_street_type       -- integer,
                  ,t.nm_street_type       -- character varying(50),
                  ,t.nm_street_type_short -- character varying(10),
                  ,t.dt_data_del          -- timestamp without time zone,
                   ----
                  ,x.fias_ids            ::bigint[]    AS fias_ids                 -- Исходные идентификаторы ГАР-ФИАС 
                  ,x.id_street_type      ::integer     AS id_street_type_tmp       -- ID типа, ПРОМЕЖУТОЧНЫЙ
                  ,x.fias_type_name      ::varchar(50) AS fias_type_name	       -- Наименованиек типа, ГАР-ФИАС
                  ,x.nm_street_type      ::varchar(50) AS nm_street_type_tmp  	   -- Наименованиек дома, ПРОМЕЖУТОЧНОЕ
                  ,x.fias_type_shortname ::varchar(20) AS fias_type_shortname      -- Краткое имя, ГАР-ФИАС
                  ,x.nm_street_type_short::varchar(10) AS nm_street_type_short_tmp -- Краткое наименованиек типа ПРОМЕЖУТОЧНОЕ,
                  ,x.fias_row_key        ::text        AS fias_row_key	           -- Уникальный идентификатор строки
                  
            FROM gar_tmp.xxx_adr_street_type x 
            
             LEFT JOIN %I.adr_street_type t 
                   ON (x.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char (t.nm_street_type))
             ORDER BY t.id_street_type;       
       $_$;

    BEGIN
      CREATE TEMP TABLE IF NOT EXISTS __adr_street_type_z OF gar_tmp.zzz_adr_street_type_t
        ON COMMIT DROP;
      --
      DELETE FROM __adr_street_type_z;
      _exec := format (_select, '__adr_street_type_z', p_schema_name);
      EXECUTE (_exec);
      --
      RETURN QUERY SELECT * FROM __adr_street_type_z ORDER BY id_street_type;                      
    END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data (text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data (text) 
IS 'Функция отображает "тип дома" из промежуточного хранилища.';
----------------------------------------------------------------------------------
-- USE CASE:
--           SELECT * FROM gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data ('gar_tmp'); 
--           SELECT * FROM gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data ('unnsi'); 
--
