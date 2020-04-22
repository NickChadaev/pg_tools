-- =====================================================================================================================
-- Author: Gregory
-- Create date: 2016-07-13
-- Description: Проверка наличия записей нарушающих критерии уникальности НСО
--   2016-11-12  Nick, Абсолютное значение типа t_text (t_arr_values -> t_arr_text, t_str2048 -> t_text) 
--   2018-12-19 Nick Новое ядро.
-- =====================================================================================================================
/* ---------------------------------------------------------------------------------------------------------------------
        Входные параметры:
                1) p_nso_code   t_str60   -- Код НСО
	Выходные параметры:
                1) nso_id       id_t      -- Идентификатор НСО
                2) nso_code     t_str60   -- Код НСО
                3) key_id       id_t      -- Идентификатор ключа
                4) key_code     t_str60   -- Код ключа
                5) key_s_code   t_code1   -- Краткий код ключа
                6) key_num      small_t   -- Номер ключа
                7) col_id       id_t      -- Идентификатор колонки
                8) col_code     t_str60   -- Код колонки
                9) col_num      small_t   -- Номер колонки
               10) rec_id       id_t      -- Идентификатор записи
               11) val_cell_abs t_text -- Значение колонки
               12) uni_data     t_text    -- Уникальное значение ключа
               13) uni_count    longint_t -- Количество повторений
--------------------------------------------------------------------------------------------------------------------- */
SET search_path = nso, nso_data, com, public, pg_catalog;
DROP FUNCTION IF EXISTS nso_data.nso_f_nso_object_unique_check (public.t_str60);
CREATE OR REPLACE FUNCTION nso_data.nso_f_nso_object_unique_check (
        p_nso_code public.t_str60 -- Код НСО
)
RETURNS TABLE (
        nso_id       public.id_t      -- Идентификатор НСО
       ,nso_code     public.t_str60   -- Код НСО
       ,key_id       public.id_t      -- Идентификатор ключа
       ,key_code     public.t_str60   -- Код ключа
       ,key_s_code   public.t_code1   -- Краткий код ключа
       ,key_num      public.small_t   -- Номер ключа
       ,col_id       public.id_t      -- Идентификатор колонки
       ,col_code     public.t_str60   -- Код колонки
       ,col_num      public.small_t   -- Номер колонки
       ,rec_id       public.id_t      -- Идентификатор записи
       ,val_cell_abs public.t_text    -- Значение колонки
       ,uni_data     public.t_text    -- Уникальное значение ключа
       ,uni_count    public.longint_t -- Количество повторений
)
AS
$$
DECLARE
BEGIN
        RETURN QUERY
        WITH attributes AS (
                SELECT
                        no.nso_id
                       ,no.nso_code
                       ,nk.key_id
                       ,nk.key_code
                       ,oc.small_code AS key_s_code
                       ,nka.column_nm AS key_num
                       ,nch.col_id
                       ,nch.col_code
                       ,nch.number_col AS col_num
                FROM ONLY com.obj_codifier oc
                JOIN ONLY nso.nso_key nk
                ON nk.key_type_id = oc.codif_id
                JOIN ONLY nso.nso_object no
                ON no.nso_id = nk.nso_id
                JOIN ONLY nso.nso_key_attr nka
                ON nka.key_id = nk.key_id
                JOIN ONLY nso.nso_column_head nch
                ON nch.col_id = nka.col_id
                WHERE
                        oc.codif_code IN (
                                'PKKEY'
                               ,'AKKEY1'
                               ,'AKKEY2'
                               ,'AKKEY3'
                        )
                    AND upper(btrim(no.nso_code)) = upper(btrim(p_nso_code))
                ORDER BY nka.column_nm
        )
       ,values AS (
                SELECT
                        attr.col_id
                       ,na.rec_id
                       ,na.val_cell_abs::t_text
                FROM attributes attr
                JOIN ONLY nso.nso_abs na
                ON na.col_id = attr.col_id
                WHERE
                        na.col_id = attr.col_id
                    AND na.s_key_code = attr.key_s_code
                ORDER BY
                        na.rec_id
                       ,attr.key_num
        )
       ,uniques AS (
                SELECT
                        val.rec_id
                       ,array_to_string(array_agg(lower(btrim(val.val_cell_abs::t_text))), '') AS data
                FROM values val
                GROUP BY val.rec_id
        )
       ,counts AS (
                SELECT
                        uni.data
                       ,count(uni.data)
                FROM uniques uni
                GROUP BY uni.data
        )
        SELECT
                attr.nso_id::public.id_t
               ,attr.nso_code::public.t_str60
               ,attr.key_id::public.id_t
               ,attr.key_code::public.t_str60
               ,attr.key_s_code::public.t_code1
               ,attr.key_num::public.small_t
               ,attr.col_id::public.id_T
               ,attr.col_code::t_str60
               ,attr.col_num::public.small_t
               ,val.rec_id::public.id_t
               ,val.val_cell_abs::public.t_text
               ,uni.data::public.t_text
               ,cnt.count::public.longint_t
        FROM counts cnt
        JOIN uniques uni
        ON uni.data = cnt.data
        JOIN values val
        ON val.rec_id = uni.rec_id
        JOIN attributes attr
        ON attr.col_id = val.col_id
        WHERE cnt.count > 1
        
        ORDER BY
                col_num
               ,val_cell_abs
               ,rec_id;
END;
$$
SECURITY DEFINER
LANGUAGE plpgsql;

COMMENT ON FUNCTION nso_data.nso_f_nso_object_unique_check(public.t_str60)
IS '4232/5: Проверка наличия записей нарушающих критерии уникальности НСО.
        Входные параметры:
                1) p_nso_code   public.t_str60   -- Код НСО
	Выходные параметры:
                1) nso_id       public.id_t      -- Идентификатор НСО
                2) nso_code     public.t_str60   -- Код НСО
                3) key_id       public.id_t      -- Идентификатор ключа
                4) key_code     public.t_str60   -- Код ключа
                5) key_s_code   public.t_code1   -- Краткий код ключа
                6) key_num      public.small_t   -- Номер ключа
                7) col_id       public.id_t      -- Идентификатор колонки
                8) col_code     public.t_str60   -- Код колонки
                9) col_num      public.small_t   -- Номер колонки
               10) rec_id       public.id_t      -- Идентификатор записи
               11) val_cell_abs public.t_text    -- Значение колонки
               12) uni_data     public.t_text    -- Уникальное значение ключа
               13) uni_count    public.longint_t -- Количество повторений';

-- SELECT * FROM nso.nso_f_nso_object_unique_check('spr_rntd');
-- SELECT * FROM nso.nso_f_nso_object_unique_check('spr_employe');
-- SELECT * FROM nso.nso_f_nso_object_unique_check('spr_ex_enterprise');

-- SELECT * FROM nso.nso_f_column_head_nso_s('spr_rntd');
-- SELECT * FROM nso.nso_f_record_select_all('spr_rntd');
