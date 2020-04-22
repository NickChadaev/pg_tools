-- ====================================================================================================================
-- Author: Gregory
-- Create date: 2017-12-14
-- Description:	Получение имени схемы по названию процедуры
-- ====================================================================================================================
/* --------------------------------------------------------------------------------------------------------------------
	Входные параметры:
		1) p_proc_name  public.t_sysname  -- Название процедуры
	Выходные параметры:
                1) public.t_sysname  -- Последовательный номер аргумента
-------------------------------------------------------------------------------------------------------------------- */
SET search_path = public, pg_catalog;

DROP FUNCTION IF EXISTS db_info.f_get_proc_nspname(public.t_sysname);
CREATE OR REPLACE FUNCTION db_info.f_get_proc_nspname (
        p_proc_name  public.t_sysname  -- Название процедуры
)
RETURNS public.t_sysname AS
$$
BEGIN
        RETURN (
                SELECT nspname
                FROM pg_catalog.pg_proc prc
                JOIN pg_catalog.pg_namespace nsp
                ON nsp.oid = prc.pronamespace
                WHERE prc.proname = lower(btrim(reverse((string_to_array(reverse((string_to_array(p_proc_name, '('))[1]), '.'))[1])))
                LIMIT 1
        )::public.t_sysname;
END;
$$
SECURITY DEFINER
LANGUAGE plpgsql;

COMMENT ON FUNCTION db_info.f_get_proc_nspname(public.t_sysname)
IS '7850/601: Получение имени схемы по названию процедуры.
    Входные параметры:
        1) p_proc_name  public.t_sysname  -- Название процедуры
    Выходные параметры:
        1) public.t_sysname  -- Последовательный номер аргумента';

-- SELECT * FROM db_info.f_get_proc_nspname('nso_p_column_head_i');
-- 'nso'
-- SELECT * FROM db_info.f_get_proc_nspname('com_f_obj_codifier_s_sys');
-- 'com'
-- SELECT * FROM db_info.f_get_proc_nspname('');
-- '<NULL>'
-- SELECT * FROM db_info.f_get_proc_nspname(NULL);
-- '<NULL>'
