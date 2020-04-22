DROP FUNCTION IF EXISTS com_domain.com_f_domain_get_id (public.t_str60);
CREATE OR REPLACE FUNCTION com_domain.com_f_domain_get_id (p_attr_code public.t_str60)
  RETURNS public.id_t  
  SET search_path=com_domain,com,public,pg_catalog  
AS
 $$
    -- ============================================================ 
    --  Author:		 Nick 
    --  Create date: 2019-07-02
    --  Description:	Выбор ID записи домена колонки по её коду.
    -- ============================================================ 
 
    SELECT attr_id::public.id_t FROM ONLY com.nso_domain_column WHERE (attr_code = p_attr_code);
 $$
    IMMUTABLE  -- 2018-04-14
    SECURITY INVOKER -- 2015-04-05 Nick
    LANGUAGE sql;

COMMENT ON FUNCTION com_domain.com_f_domain_get_id (public.t_str60) IS '110: Выбор ID записи домена колонок по её коду 
	Входные параметры
	             p_attr_code  public.t_str60  - код записи домена колонок
   ------------------------------------------------------------------------ 
	Выходные параметры
			     ID записи домена колонок public.id_t
   ';
-- ----------------------------------------------------------------------------------------------------
-- SELECT * FROM com.nso_domain_column limit 10;
-- SELECT * FROM com_domain.com_f_domain_get_id ('APP_NODE');

