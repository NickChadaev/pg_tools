-- ====================================================================================================================
-- Author: Gregory
-- Create date: 2016-12-11
-- Description:	Отображение агрегированных записей заголовка НСО
-- ====================================================================================================================
/* --------------------------------------------------------------------------------------------------------------------
    Входные параметры:
        1) p_mas_object_id t_arr_id    -- Массив идентификаторов НСО
        2) p_for_date      t_timestamp -- "На дату"
        
    Выходные параметры:
        1) col_id      id_t        -- Идентификатор колонки
        2) col_code    t_str60     -- Код колонки
        3) parent_id   id_t        -- Идентификатор родительской колонки
        4) parent_code t_str60     -- Код родительской колонки
        5) col_name    t_str250    -- Имя колонки
        6) attr_id     id_t        -- Идентификатор атрибута
        7) nso_id      id_t        -- Идентификатор НСО
        8) number_col  small_t     -- Номер колонки
        9) mandatory   t_boolean   -- Обязательность заполнения
       10) final_sw    t_boolean   -- Последний атрибут
       11) date_from   t_timestamp -- Дата начала актуальности
       12) date_to     t_timestamp -- Дата конца актуальности
       13) log_id      id_t        -- Идентификатор журнала
       14) impact      t_code1     -- Воздействие(I - добавление, U - обновление, D - удаление, T - древообразующая)

    Особенности:
        -- Отображает состояние записи на указанную дату, если запись была удалена impact = D
        -- Воздействие(I/U/D) отображается только для запрошеныйх в массиве p_mas_object_id записей
        -- Записи необходимые для позиционирования запрошенных записей в иерархии кодификатора отмечены impact = T
        -- Функция выполняется только в рамках таблиц nso.nso_column_head и nso.nso_column_head_hist
        -- Финальная колонка(final_sw) расчитана на сквозную нумерацию
-------------------------------------------------------------------------------------------------------------------- */
SET search_path = nso, public;
DROP FUNCTION IF EXISTS nso.nso_f_column_head_s(public.t_arr_id,public.t_timestamp);
CREATE OR REPLACE FUNCTION nso.nso_f_column_head_s (
        p_mas_object_id public.t_arr_id
       ,p_for_date      public.t_timestamp
                DEFAULT now()
)
RETURNS TABLE (
        col_id          id_t
       ,col_code        t_str60
       ,parent_id       id_t
       ,parent_code     t_str60
       ,col_name        t_str250
       ,attr_id         id_t
       ,nso_id          id_t
       ,number_col      small_t
       ,mandatory       t_boolean
       ,final_sw        t_boolean
       ,date_from       t_timestamp
       ,date_to         t_timestamp
       ,log_id          id_t
       ,impact          t_code1
)
AS
$$
#variable_conflict use_column
DECLARE
        _opr oid = 'nso.nso_column_head'::regclass::oid;
BEGIN
        RAISE NOTICE 'nso_f_column_head_s(%, %)', p_mas_object_id, p_for_date;
        RETURN QUERY
        WITH format AS (
                WITH section AS (
                        WITH history AS (
                                SELECT
                                        col_id::id_t
                                       ,col_code
                                       ,parent_col_id AS parent_id
                                       ,col_name
                                       ,attr_id
                                       ,nso_id
                                       ,number_col
                                       ,mandatory
                                       ,date_from
                                       ,date_to
                                       ,log_id
                                       ,tableoid = _opr AS opr
                                       ,count(*) OVER (
                                                PARTITION BY col_id
                                        ) AS cnt
                                       ,row_number() OVER (
                                                PARTITION BY col_id
                                                ORDER BY
                                                        date_from ASC
                                                       ,date_to ASC
                                                       ,log_id ASC
                                                       ,tableoid DESC
                                        ) AS num
                                FROM nso.nso_column_head
                        )
                        SELECT DISTINCT ON(col_id)
                                col_id
                               ,col_code
                               ,parent_id
                               ,col_name
                               ,attr_id
                               ,nso_id
                               ,number_col
                               ,mandatory
                               ,date_from
                               ,date_to
                               ,log_id
                               ,opr
                               ,CASE
                                        WHEN
                                                date_to <= p_for_date
                                            AND num = cnt
                                            AND opr = FALSE
                                        THEN 'D'
                                        WHEN num = 1
                                        THEN 'I'
                                        ELSE 'U'
                                END AS impact
                        FROM history
                        WHERE date_from <= p_for_date
                        ORDER BY
                                col_id
                               ,num DESC
                )
                SELECT
                        col_id
                       ,col_code
                       ,parent_id
                       ,col_name
                       ,attr_id
                       ,nso_id
                       ,number_col
                       ,mandatory
                       ,date_from
                       ,date_to
                       ,log_id
                       ,opr
                       ,CASE
                                WHEN number_col != 0
                                THEN impact
                                ELSE 'T'
                        END::t_code1 AS impact
                FROM section
                WHERE nso_id = ANY(p_mas_object_id)
        )
        SELECT
                cur.col_id
               ,cur.col_code
               ,cur.parent_id
               ,par.col_code
               ,cur.col_name
               ,cur.attr_id
               ,cur.nso_id
               ,cur.number_col
               ,cur.mandatory
               ,((cur.number_col + 1) = count(*) OVER (
                        PARTITION BY
                                cur.nso_id
                               ,cur.opr
                ))::t_boolean AS final_sw
               ,cur.date_from
               ,cur.date_to
               ,cur.log_id
               ,cur.impact
        FROM format cur
        LEFT JOIN format par
        ON par.col_id = cur.parent_id;
END;
$$
LANGUAGE plpgsql
SECURITY DEFINER;
COMMENT ON FUNCTION nso.nso_f_column_head_s(public.t_arr_id,public.t_timestamp)
IS '4684: Отображение агрегированных записей заголовка НСО
    Входные параметры:
        1) p_mas_object_id t_arr_id    -- Массив идентификаторов НСО
        2) p_for_date      t_timestamp -- "На дату"
        
    Выходные параметры:
        1) col_id      id_t        -- Идентификатор колонки
        2) col_code    t_str60     -- Код колонки
        3) parent_id   id_t        -- Идентификатор родительской колонки
        4) parent_code t_str60     -- Код родительской колонки
        5) col_name    t_str250    -- Имя колонки
        6) attr_id     id_t        -- Идентификатор атрибута
        7) nso_id      id_t        -- Идентификатор НСО
        8) number_col  small_t     -- Номер колонки
        9) mandatory   t_boolean   -- Обязательность заполнения
       10) final_sw    t_boolean   -- Последний атрибут
       11) date_from   t_timestamp -- Дата начала актуальности
       12) date_to     t_timestamp -- Дата конца актуальности
       13) log_id      id_t        -- Идентификатор журнала
       14) impact      t_code1     -- Воздействие(I - добавление, U - обновление, D - удаление, T - древообразующая)

    Особенности:
        -- Отображает состояние записи на указанную дату, если запись была удалена impact = D
        -- Воздействие(I/U/D) отображается только для запрошеныйх в массиве p_mas_object_id записей
        -- Записи необходимые для позиционирования запрошенных записей в иерархии кодификатора отмечены impact = T
        -- Функция выполняется только в рамках таблиц nso.nso_column_head и nso.nso_column_head_hist
        -- Финальная колонка(final_sw) расчитана на сквозную нумерацию';

-- SELECT * FROM nso.nso_f_column_head_s(ARRAY[34]);
-- SELECT * FROM nso.nso_f_column_head_s(ARRAY[14,15,16,17,28]);
