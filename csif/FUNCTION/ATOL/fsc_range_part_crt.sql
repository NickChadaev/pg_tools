-- FUNCTION: fsc_receipt_pcg.fsc_range_part_crt(text, text, text, date, date, text, text, text)

DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_range_part_crt(text, text, text, date, date, text, text, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_range_part_crt(
       p_parent_sch_name  text 
     , p_parent_tbl_name  text 
     , p_constr_name      text 
     , p_min_bound        date
     , p_max_bound        date
     , p_part_sch_name    text DEFAULT NULL::text 
     , p_pref_1           text DEFAULT 'fsc'::text 
     , p_pref_2           text DEFAULT 'chk'::text 
     , OUT l_result    boolean 
     , OUT l_part_name text
 )
    RETURNS SETOF record 
    SECURITY DEFINER
    LANGUAGE plpgsql

AS $$
   -- ============================================================================ --
   --    2023-04-13  прототип функции, создающей секции с временными диапазонами
   -- ============================================================================ --

   DECLARE
      _crt_part  text = $_$
   
            CREATE TABLE %s.%s_%s PARTITION OF %s.%s
            ( 
                CONSTRAINT %s_%s CHECK (dt_create >= %L AND dt_create < %L)
            )
                FOR VALUES FROM (%L) TO (%L);
               
       $_$;

      _exec text;      
      _part_sch_name text := COALESCE (p_part_sch_name, p_parent_sch_name);
      
   BEGIN
      _exec := format (_crt_part 
                       ,_part_sch_name
                       , p_pref_1 
                       , p_constr_name
                       , p_parent_sch_name 
                       , p_parent_tbl_name 
                       , p_pref_2
                       , p_constr_name
                       , p_min_bound
                       , p_max_bound
                       , p_min_bound
                       , p_max_bound
       );
	     
	  EXECUTE (_exec);
	     
       l_result    := TRUE;
       l_part_name := btrim (_exec);
      
       RETURN NEXT;
   END;
  
$$;

ALTER FUNCTION fsc_receipt_pcg.fsc_range_part_crt(text, text, text, date, date, text, text, text)
    OWNER TO postgres;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_range_part_crt (text, text, text, date, date, text, text, text)     
    IS 'Прототип функции, создающей секции с временными диапазонами';
