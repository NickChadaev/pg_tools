/* -- ============================================================= 
	Входные параметры
	             p_nso_code  public.t_str60  - код НСО
   ---------------------------------------------------------------- 
	Выходные параметры
			              ID НСО public.id_t
   -- ============================================================= */
DROP FUNCTION IF EXISTS nso_structure.nso_f_object_get_id ( public.t_str60 );
CREATE OR REPLACE FUNCTION nso_structure.nso_f_object_get_id ( p_nso_code  public.t_str60 )
  RETURNS public.id_t  
AS
 $$
   -- ================================================================ 
   --  Author:		 Nick 
   --  Create date: 2016-05-26
   --  Description:	Получить ID НСО по его коду.
   -- ================================================================ 
    SELECT nso_id::public.id_t FROM ONLY nso.nso_object WHERE (nso_code = p_nso_code);
 $$
    STABLE  -- Пока 
    SECURITY DEFINER -- 2015-04-05 Nick
    LANGUAGE sql;

COMMENT ON FUNCTION nso_structure.nso_f_object_get_id ( public.t_str60 ) IS '189: Получить ID НСО по его коду 
                  	Входные параметры
                  	             p_nso_code  public.t_str60  - код НСО
                     --------------------------------------------- 
                  	Выходные параметры
                  			              ID НСО public.id_t
   ';

-- SELECT * FROM nso_structure.nso_f_object_get_id ('SPR_rntd');   
-- -------------------------------------------------- 
-- SELECT * FROM ONLY nso.nso_object LIMIT 10;
-- SELECT * FROM nso_structure.nso_f_object_get_id ('SPR_LOCAL');
