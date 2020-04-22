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
DROP FUNCTION IF EXISTS com_domain.com_f_domain_get_code ( public.id_t );
CREATE OR REPLACE FUNCTION com_domain.com_f_domain_get_code (p_attr_id public.id_t )
  RETURNS public.t_str60   
  SET search_path=com_domain,com,public,pg_catalog  
AS
 $$
    SELECT attr_code FROM ONLY com.nso_domain_column WHERE (attr_id = p_attr_id);
 $$
    IMMUTABLE  -- 2018-04-14
    SECURITY INVOKER -- 2015-04-05 Nick
    LANGUAGE sql;

COMMENT ON FUNCTION com_domain.com_f_domain_get_code (public.id_t) IS '110: Выбор кода записи домена колонок по её ID
	Входные параметры
	                    p_attr_id public.id_t  - ID записи домена колонок
   ----------------------------------------------------------------------- 
 	Выходные параметры
			              код записи домена колонок t_str69
   ';
-- ----------------------------------------------------------------------------------------------------
-- SELECT * FROM com.nso_domain_column limit 10;
-- SELECT * FROM com_domain.com_f_domain_get_code (24); -- 'APP_NODE'
