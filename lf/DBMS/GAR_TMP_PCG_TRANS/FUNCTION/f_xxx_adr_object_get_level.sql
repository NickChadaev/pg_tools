DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_adr_object_get_level (bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_adr_object_get_level (

        p_type_id           bigint   
      , OUT new_level       bigint
      , OUT new_level_descr text
      
) RETURNS setof record

    LANGUAGE plpgsql
    IMMUTABLE
 AS
  $$
  BEGIN
    -- --------------------------------------------------------------------
    --  2023-11-09 Nick Избавляемся от ФИАСовского деления на уровни,
    --                Там ногу сломать можно.
    -- --------------------------------------------------------------------
    -- -------------------------------------------------------------------
    IF (EXISTS (SELECT 1 FROM gar_tmp.xxx_adr_area_type x WHERE (p_type_id = ANY (x.fias_ids))
                       )
               )
    THEN 
          new_level := 0;
          new_level_descr := 'Адресный объект';
          
    ELSIF (EXISTS (SELECT 1 FROM gar_tmp.xxx_adr_street_type x WHERE (p_type_id = ANY (x.fias_ids))
                       )
               )
    THEN 
          new_level := 1;
          new_level_descr := 'Элемент дорожной структуры';
    ELSE
          new_level := -1;
          new_level_descr := 'Зачение не определено';
    END IF;
       
   RETURN NEXT;    
       
  END;     
$$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_adr_object_get_level (bigint) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_adr_object_get_level (bigint) 
IS ' Запомнить промежуточные данные, адресные объекты';
----------------------------------------------------------------------------------
-- USE CASE:
--  EXPLAIN ANALYZE SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_object_get_level (423);  
--  SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_object_get_level (137); 
--  SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_object_get_level (999); 
	 
