/* -- ============================================================= 
	Входные параметры
	                    p_nso_object_id  public.id_t  - ID НСО
   ---------------------------------------------------------------- 
	Выходные параметры
			              код объекта public.t_str60
   -- ============================================================= */

DROP FUNCTION IF EXISTS nso_structure.nso_f_object_get_code ( public.id_t );
CREATE OR REPLACE FUNCTION nso_structure.nso_f_object_get_code ( p_nso_object_id  public.id_t )
  RETURNS public.t_str60   
AS
 $$
    -- ============================================================= 
    --  Author:		 Nick 
    --  Create date: 2016-05-25
    --  Description:	Получить код объекта НСО по его ID.
    -- =============================================================
    SELECT nso_code FROM ONLY nso.nso_object WHERE ( nso_id = p_nso_object_id );
 $$
    STABLE  -- Пока 
    SECURITY DEFINER -- 2015-04-05 Nick
    LANGUAGE sql;

COMMENT ON FUNCTION nso_structure.nso_f_object_get_code ( public.id_t ) IS '189: Получить код НСО по его ID
	Входные параметры
	                    p_nso_object_id  public.id_t  - ID НСО
   ---------------------------------------------------------------- 
 	Выходные параметры
			              код объекта public.t_str60
   ';
-- ------------------------------------------------------------------------------------------
-- SELECT * FROM nso_structure.nso_f_object_get_code (8);
-- SELECT * FROM nso_structure.nso_f_object_get_code (11);
