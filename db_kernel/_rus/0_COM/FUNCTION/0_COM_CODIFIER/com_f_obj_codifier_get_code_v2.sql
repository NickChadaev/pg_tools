-- ================================================================ 
--  Author:		 Nick 
--  Create date: 2015-11-23
--  Description:	Выбор кода записи кодификатора по её ID.
/* -- ============================================================= 
	Входные параметры
	                    p_codif_id  id_t  - ID записи кодификатора
   ---------------------------------------------------------------- 
	Выходные параметры
			              код записи кодификатора t_str69
   -- ============================================================= */
DROP FUNCTION IF EXISTS com_codifier.com_f_obj_codifier_get_code ( public.id_t );
CREATE OR REPLACE FUNCTION com_codifier.com_f_obj_codifier_get_code (p_codif_id public.id_t )
  RETURNS public.t_str60   
  SET search_path=com_codifier,com,public,pg_catalog  
AS
 $$
    SELECT codif_code FROM ONLY com.obj_codifier WHERE (codif_id = p_codif_id);
 $$
    IMMUTABLE  -- 2018-04-14
    SECURITY INVOKER -- 2015-04-05 Nick
    LANGUAGE sql;

COMMENT ON FUNCTION com_codifier.com_f_obj_codifier_get_code (public.id_t) IS '41: Выбор кода записи кодификатора по её ID
	Входные параметры
	                    p_codif_id  id_t  - ID записи кодификатора
   ---------------------------------------------------------------- 
 	Выходные параметры
			              код записи кодификатора t_str69
   ';
-- ----------------------------------------------------------------------------------------------------
-- SELECT * FROM com_f_obj_codifier_get_code (36);
-- select * from com.obj_codifier;
