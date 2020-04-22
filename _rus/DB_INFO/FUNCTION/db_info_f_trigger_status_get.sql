-- ================================================================ 
--  Author:		 Nick 
--  Create date: 2015-11-04
--  Description: Получить статус триггера. 
/* -- ============================================================= 
	Входные параметры:
	                 p_trigger_name  t_sysname - имя триггера.
   ---------------------------------------------------------------- 
	Выходные параметры
			           состояние триггера  t_boolean
   -- ============================================================= */
SET search_path=db_info,public,pg_catalog;

DROP FUNCTION IF EXISTS db_info_f_trigger_status_get ( t_sysname );
CREATE OR REPLACE FUNCTION db_info_f_trigger_status_get ( p_trigger_name  t_sysname )
  RETURNS t_boolean   
AS
 $$
   BEGIN
       RETURN ( SELECT (tgenabled != 'D') AS tr_status FROM pg_trigger
                   WHERE (tgname = btrim(lower(p_trigger_name)))
		 );
   END;
 $$
    STRICT STABLE  -- Пока, потому, что использую SET
    SECURITY DEFINER -- 2015-04-05 Nick
    LANGUAGE plpgsql;

 COMMENT ON FUNCTION db_info_f_trigger_status_get ( t_sysname ) IS 'Получить состояние триггера';
-- ----------------------------------------------------------------------------------------------------------
-- SELECT * FROM db_info.db_info_f_trigger_status_get ('tr_ind_value_plan_hist');
