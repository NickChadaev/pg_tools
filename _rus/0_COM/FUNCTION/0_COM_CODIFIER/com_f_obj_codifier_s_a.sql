-- ====================================================================================================================
-- Author: Gregory
-- Create date: 2016-12-07
-- Description:	Отображение записей кодификатора
-- ====================================================================================================================
/* --------------------------------------------------------------------------------------------------------------------
    Входные параметры:
        1) p_mas_codif_id t_arr_id    -- Массив идентификаторов кодификатора
        2) p_for_date     t_timestamp -- "На дату"
        
    Выходные параметры:
        1) codif_id    id_t        -- Идентификатор экземпляра
        2) codif_uuid  t_guid      -- UUID экземпляра
        3) parent_id   id_t        -- Идентификатор родителя 
        4) parent_uuid t_guid      -- UUID родителя
        5) codif_code  t_str60     -- Код
        6) codif_name  t_str250    -- Наименование
        7) small_code  t_code1     -- Краткий код
        8) date_from   t_timestamp -- Дата начала актуальности
        9) date_to     t_timestamp -- Дата конца актуальности
       10) log_id      id_t        -- Идентификатор журнала
       11) impact      t_code1     -- Воздействие(I - добавление, U - обновление, D - удаление, T - древообразующая)

    Особенности:
        -- Отображает состояние записи на указанную дату, если запись была удалена impact = D
        -- Воздействие(I/U/D) отображается только для запрошеныйх в массиве p_mas_codif_id записей
        -- Записи необходимые для позиционирования запрошенных записей в иерархии кодификатора отмечены impact = T
        -- Функция выполняется только в рамках таблиц com.obj_codifier и com.obj_codifier_hist
-------------------------------------------------------------------------------------------------------------------- */
SET search_path = com, public;
DROP FUNCTION IF EXISTS com.com_f_obj_codifier_s(public.t_arr_id,public.t_timestamp);
CREATE OR REPLACE FUNCTION com.com_f_obj_codifier_s (
        p_mas_codif_id public.t_arr_id    -- Массив идентификаторов кодификатора
       ,p_for_date     public.t_timestamp -- "На дату"
                DEFAULT now()
)
RETURNS TABLE (
        codif_id    public.id_t        -- Идентификатор экземпляра
       ,codif_uuid  public.t_guid      -- UUID экземпляра
       ,parent_id   public.id_t        -- Идентификатор родителя 
       ,parent_uuid public.t_guid      -- UUID родителя
       ,codif_code  public.t_str60     -- Код
       ,codif_name  public.t_str250    -- Наименование
       ,small_code  public.t_code1     -- Краткий код
       ,date_from   public.t_timestamp -- Дата начала актуальности
       ,date_to     public.t_timestamp -- Дата конца актуальности
       ,log_id      public.id_t        -- Идентификатор журнала
       ,impact      public.t_code1     -- Воздействие
)
AS
$$
#variable_conflict use_column
DECLARE
        _opr oid = 'com.obj_codifier'::regclass::oid;
BEGIN
        RAISE NOTICE 'com_f_obj_codifier_s(%, %)', p_mas_codif_id, p_for_date;
        RETURN QUERY
        WITH format AS (
                WITH RECURSIVE branch AS (
                        WITH section AS (
                                WITH history AS (
                                        SELECT
                                                codif_id::id_t
                                               ,parent_codif_id
                                               ,codif_uuid
                                               ,codif_code
                                               ,codif_name
                                               ,small_code
                                               ,date_from
                                               ,date_to
                                               ,id_log
                                               ,tableoid = _opr AS opr
                                               ,count(*) OVER ( PARTITION BY codif_id ) AS cnt
                                               ,row_number() OVER (
                                                        PARTITION BY codif_id
                                                        ORDER BY
                                                                date_from ASC
                                                               ,date_to ASC
                                                               ,id_log ASC
                                                               ,tableoid DESC
                                                ) AS num
                                        FROM com.obj_codifier
                                )
                                SELECT DISTINCT ON(codif_id)
                                        codif_id
                                       ,parent_codif_id
                                       ,codif_uuid
                                       ,codif_code
                                       ,codif_name
                                       ,small_code
                                       ,date_from
                                       ,date_to
                                       ,id_log
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
                                        codif_id
                                       ,num DESC
                        )
                        SELECT
                                codif_id
                               ,parent_codif_id
                               ,codif_uuid
                               ,codif_code
                               ,codif_name
                               ,small_code
                               ,date_from
                               ,date_to
                               ,id_log
                               ,impact
                               ,'N' AS role
                        FROM section
                        WHERE codif_id = ANY(p_mas_codif_id)
                        
                        UNION

                        SELECT
                                sec.codif_id
                               ,sec.parent_codif_id
                               ,sec.codif_uuid
                               ,sec.codif_code
                               ,sec.codif_name
                               ,sec.small_code
                               ,sec.date_from
                               ,sec.date_to
                               ,sec.id_log
                               ,sec.impact
                               ,'P' AS role
                        FROM 
                                branch bra
                               ,section sec
                        WHERE sec.codif_id = bra.parent_codif_id
                )
                SELECT DISTINCT ON(cur.codif_id)
                        cur.codif_id
                       ,cur.codif_uuid
                       ,cur.parent_codif_id
                       ,par.codif_uuid AS parent_uuid
                       ,cur.codif_code
                       ,cur.codif_name
                       ,cur.small_code
                       ,cur.date_from
                       ,cur.date_to
                       ,cur.id_log
                       ,CASE
                                WHEN cur.role = 'N'
                                THEN cur.impact
                                ELSE 'T'
                        END::t_code1 AS impact
                FROM branch cur
                LEFT JOIN branch par
                ON par.codif_id = cur.parent_codif_id
                ORDER BY
                        cur.codif_id
                       ,cur.role ASC
        )
        SELECT
                codif_id
               ,codif_uuid
               ,parent_codif_id
               ,parent_uuid
               ,codif_code
               ,codif_name
               ,small_code
               ,date_from
               ,date_to
               ,id_log
               ,impact
        FROM format;
END;
$$
LANGUAGE plpgsql
SECURITY INVOKER;
COMMENT ON FUNCTION com.com_f_obj_codifier_s(public.t_arr_id,public.t_timestamp)
IS '4617: Отображение агрегированных записей кодификатора.
    Входные параметры:
        1) p_mas_codif_id t_arr_id    -- Массив идентификаторов кодификатора
        2) p_for_date     t_timestamp -- "На дату"
        
    Выходные параметры:
        1) codif_id    id_t        -- Идентификатор экземпляра
        2) codif_uuid  t_guid      -- UUID экземпляра
        3) parent_id   id_t        -- Идентификатор родителя 
        4) parent_uuid t_guid      -- UUID родителя
        5) codif_code  t_str60     -- Код
        6) codif_name  t_str250    -- Наименование
        7) small_code  t_code1     -- Краткий код
        8) date_from   t_timestamp -- Дата начала актуальности
        9) date_to     t_timestamp -- Дата конца актуальности
       10) log_id      id_t        -- Идентификатор журнала
       11) impact      t_code1     -- Воздействие(I - добавление, U - обновление, D - удаление, T - древообразующая)

    Особенности:
        -- Отображает состояние записи на указанную дату, если запись была удалена impact = D
        -- Воздействие(I/U/D) отображается только для запрошеныйх в массиве p_mas_codif_id записей
        -- Записи необходимые для позиционирования запрошенных записей в иерархии кодификатора отмечены impact = T
        -- Функция выполняется только в рамках таблиц com.obj_codifier и com.obj_codifier_hist';

-- SELECT * FROM com.com_f_obj_codifier_s(ARRAY[296]);
-- SELECT * FROM com.com_f_obj_codifier_s(ARRAY[296,73,15]);
-- SELECT * FROM com.com_f_obj_codifier_s(ARRAY[92,93,94]); -- "ODC" "ODB" "ODF" удалены
-- SELECT * FROM com.com_f_obj_codifier_s(ARRAY[92,92,92], '2015-12-03 19:10:04'); -- I
-- SELECT * FROM com.com_f_obj_codifier_s(ARRAY[92,92,92], '2015-12-03 19:10:05'); -- D
-- SELECT * FROM com.com_f_obj_codifier_s(ARRAY[92,93,94], '2015-12-03 19:10:04');
