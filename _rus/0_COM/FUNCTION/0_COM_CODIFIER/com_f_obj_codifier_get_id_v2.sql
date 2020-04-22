-- ================================================================ 
--  Author:		 Nick 
--  Create date: 2015-11-23
--  Description:	Выбор ID записи кодификатора по её коду.
/* -- ============================================================= 
	Входные параметры
	             p_codif_t_str60  t_str60  - код записи кодификатора
   ---------------------------------------------------------------- 
	Выходные параметры
			              ID записи кодификатора id_t
   -- ============================================================= */
DROP FUNCTION IF EXISTS com_codifier.com_f_obj_codifier_get_id (public.t_str60);
CREATE OR REPLACE FUNCTION com_codifier.com_f_obj_codifier_get_id (p_codif_code public.t_str60)
  RETURNS public.id_t  
  SET search_path=com_codifier,com,public,pg_catalog  
AS
 $$
    SELECT codif_id::public.id_t FROM ONLY com.obj_codifier WHERE (codif_code = p_codif_code);
 $$
    IMMUTABLE  -- 2018-04-14
    SECURITY INVOKER -- 2015-04-05 Nick
    LANGUAGE sql;

COMMENT ON FUNCTION com_codifier.com_f_obj_codifier_get_id ( public.t_str60 ) IS '66: Выбор ID записи кодификатора по её коду 
	Входные параметры
	             p_codif_code  public.t_str60  - код записи кодификатора
   ---------------------------------------------------------------- 
	Выходные параметры
			     ID записи кодификатора public.id_t
   ';
-- ----------------------------------------------------------------------------------------------------
-- SELECT * FROM com.obj_codifier limit 10;
-- SELECT * FROM com_codifier.com_f_obj_codifier_get_id ('C_CODIF_ROOT');

--  EXPLAIN ANALYZE
--      SELECT codif_id::public.id_t FROM ONLY com.obj_codifier WHERE (codif_code = 'C_CODIF_ROOT');
-- -------------------------------------------------------------------------------
-- "Seq Scan on obj_codifier  (cost=0.00..1.11 rows=1 width=8) (actual time=0.023..0.027 rows=1 loops=1)"
-- "  Filter: ((codif_code)::text = 'C_CODIF_ROOT'::text)"
-- "  Rows Removed by Filter: 8"
-- "Planning time: 0.228 ms"
-- "Execution time: 0.071 ms"
