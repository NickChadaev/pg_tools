/* --------------------------------------------------------------------------------------------------------------------
    Входные параметры:
        1) p_nso_id id_t    -- Идентификатор НСО
    Выходные параметры:
        1) <noname> public.small_t -- Размер заголовка НСО / NULL если НСО не найден
-------------------------------------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS nso_structure.nso_f_column_head_size_get (public.id_t);
CREATE OR REPLACE FUNCTION nso_structure.nso_f_column_head_size_get (p_nso_id public.id_t)
RETURNS public.small_t 
   SET SEARCH_PATH=nso_structure, nso, com, public, pg_catalog
 AS
 $$
    -- =====================================================================
    -- Author: Gregory
    -- Create date: 2017-05-21
    -- Description:	Размер заголовка НСО
    -- 2019-08-07 Nick Новое ядро.
    -- ======================================================================
    SELECT (NULLIF(count(*), 0) - 1)::public.small_t 
                     FROM ONLY nso.nso_column_head WHERE (nso_id = p_nso_id);
 $$
  LANGUAGE sql
  STABLE;

COMMENT ON FUNCTION nso_structure.nso_f_column_head_size_get(public.id_t)
IS '196: Размер заголовка НСО.
    
    Входные параметры:
        1) p_nso_id id_t    -- Идентификатор НСО
        
    Выходные параметры:
        1) <noname> public.small_t -- Размер заголовка НСО / NULL если НСО не найден';
-- -----------------------------------------------------------------------------------
-- SELECT * FROM nso_structure.nso_f_object_s_sys ();
-- SELECT * FROM nso_structure.nso_f_column_head_size_get(42);
-- SELECT * FROM nso_structure.nso_f_column_head_size_get(4777); -- 7 -- 'EXN_DATA_PERMISSION'
-- SELECT * FROM nso_structure.nso_f_column_head_size_get(19); -- 0 -- 'TC_636'
-- SELECT * FROM nso_structure.nso_f_column_head_size_get(NULL); -- <NULL> -- null
-- SELECT * FROM nso_structure.nso_f_column_head_size_get(100500); -- <NULL> -- null
