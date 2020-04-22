-- =====================================================================================================================
-- Author: Gregory
-- Create date: 2016-07-14
-- Description: Формирование уникального признака записи НСО (для уникального индекса)
--   2016-07-28 Nick. При объявлении переменной тип с явным указанием схемы.
--   2016-11-12  Nick, Абсолютное значение типа t_text (t_arr_values -> t_arr_text, t_str2048 -> t_text) 
--   2017-12-22 Gregory:  индекс в коментариях оголился
--   2018-12-19 Nick Новое ядро, не знаю, что там оголилось.
-- =====================================================================================================================
/* ---------------------------------------------------------------------------------------------------------------------
        Входные параметры:
                1) p_rec_id   public.id_t    -- Идентификатор НСО
                2) p_key_code public.t_code1 -- Краткий код ключа
	Выходные параметры:
                1) _result    public.t_text  -- Признак уникальности
--------------------------------------------------------------------------------------------------------------------- */
SET search_path = com, nso, nso_data, public, pg_catalog;
DROP FUNCTION IF EXISTS nso_data.nso_f_nso_record_unique_sign_idx (public.id_t, public.t_code1) CASCADE;
-- --------------------------------------------------------------------------------------------------------------------------
-- ОШИБКА:  удалить объект функция nso_f_nso_record_unique_sign_idx(id_t,t_code1) нельзя, так как от него зависят другие объекты
-- DETAIL:  индекс ak1_nso_record_unique зависит от объекта функция nso_f_nso_record_unique_sign_idx(id_t,t_code1)
-- HINT:  Для удаления зависимых объектов используйте DROP ... CASCADE.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION nso_data.nso_f_nso_record_unique_sign_idx (
        p_rec_id   public.id_t    -- Идентификатор НСО
       ,p_key_code public.t_code1 -- Краткий код ключа
)
RETURNS public.t_text AS
$$
DECLARE
        _result public.t_text; 
BEGIN
        WITH attrs AS (
                       SELECT na.val_cell_abs::t_text FROM ONLY nso.nso_record nr
                              JOIN ONLY nso.nso_key nk USING (nso_id)
                              JOIN ONLY nso.nso_key_attr nka ON nka.key_id = nk.key_id
                              JOIN ONLY nso.nso_abs na       ON na.rec_id = nr.rec_id AND na.col_id = nka.col_id
                       WHERE
                               nr.rec_id = p_rec_id AND na.s_key_code = p_key_code
                       ORDER BY nka.column_nm
        )
         SELECT array_to_string (array_agg (attrs.val_cell_abs::text), '')
         INTO _result FROM attrs;
        
        RETURN _result;
END;
$$
IMMUTABLE
SECURITY DEFINER
LANGUAGE plpgsql;

COMMENT ON FUNCTION nso_data.nso_f_nso_record_unique_sign_idx ( public.id_t, public.t_code1 )
IS '7923/640/5: Формирование уникального признака записи НСО (для уникального индекса)
        Входные параметры:
                1) p_rec_id   public.id_t    -- Идентификатор НСО
                2) p_key_code public.t_code1 -- Краткий код ключа
	Выходные параметры:
                1) _result    public.t_text  -- Признак уникальности';

-- SELECT * FROM nso.nso_f_nso_record_unique_sign_idx(2899, 'a');
-- SELECT * FROM nso.nso_f_nso_record_unique_sign_idx(688, 'a');

-- DROP INDEX IF EXISTS ak1_nso_record_unique;
-- CREATE UNIQUE INDEX ak1_nso_record_unique ON nso.nso_record_unique (
--      scode,
--      unique_check,
--      nso.nso_f_nso_record_unique_sign_idx(rec_id,scode)
-- )
-- WHERE unique_check IS TRUE;
