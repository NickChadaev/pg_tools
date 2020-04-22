DROP FUNCTION IF EXISTS nso_structure.nso_f_key_get_code ( public.id_t );
CREATE OR REPLACE FUNCTION nso_structure.nso_f_key_get_code ( p_key_id  public.id_t )
  RETURNS public.t_str60   
AS
 $$
    -- ============================================================= 
    --  Author:		 Nick 
    --  Create date: 2020-01-16
    --  Description:	Получить код ключа его ID.
    -- =============================================================
    SELECT key_code FROM ONLY nso.nso_key WHERE (key_id = p_key_id);
 $$
    STABLE  -- Пока 
    SECURITY DEFINER -- 2015-04-05 Nick
    LANGUAGE sql;

COMMENT ON FUNCTION nso_structure.nso_f_key_get_code ( public.id_t ) IS '259: Получить код ключа по его ID
	Входные параметры
	                    p_key_id  public.id_t  - ID ключа
   ---------------------------------------------------------------- 
 	Выходные параметры
			              код ключа public.t_str60
   ';
-- ------------------------------------------------------------------------------------------
-- SELECT * FROM nso_structure.nso_f_key_get_code (8);
-- SELECT * FROM nso_structure.nso_f_key_get_code (11);
