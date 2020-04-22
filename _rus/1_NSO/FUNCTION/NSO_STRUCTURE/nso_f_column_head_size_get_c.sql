/* --------------------------------------------------------------------------------------------------------------------
    Входные параметры:
        1) p_nso_code t_str60 -- Идентификатор НСО
    Выходные параметры:
        1) <noname>   public.small_t -- Размер заголовка НСО / NULL если НСО не найден
-------------------------------------------------------------------------------------------------------------------- */
SET search_path = nso, public;

DROP FUNCTION IF EXISTS nso_structure.nso_f_column_head_size_get (public.t_str60);
CREATE OR REPLACE FUNCTION nso_structure.nso_f_column_head_size_get (
        p_nso_code public.t_str60
)
RETURNS public.small_t 
  SET SEARCH_PATH=nso_structure, nso, com, public, pg_catalog
AS
 $$
   -- ==========================================================
   -- Author: Gregory
   -- Create date: 2017-05-21
   -- Description:	Размер заголовка НСО
   -- 2019-08-07 Nick Новое ядро 
   -- ==========================================================
    SELECT (NULLIF(count(*), 0) - 1)::public.small_t FROM ONLY nso.nso_object
       JOIN ONLY nso.nso_column_head USING (nso_id)
    WHERE nso_code = p_nso_code;
 $$
   LANGUAGE sql
   STABLE;
COMMENT ON FUNCTION nso_structure.nso_f_column_head_size_get (public.t_str60)
IS '196: Размер заголовка НСО.
    Входные параметры:
        1) p_nso_code t_str60 -- Идентификатор НСО
    Выходные параметры:
        1) <noname>   public.small_t -- Размер заголовка НСО / NULL если НСО не найден';
-- ------------------------------------------------------------------------------------
-- SELECT * FROM nso_structure.nso_f_object_s_sys ();
-- SELECT * FROM nso_structure.nso_f_column_head_size_get('CL_OKV');
-- SELECT * FROM nso_structure.nso_f_column_head_size_get('CL_OKV2');
