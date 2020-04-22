-- =====================================================================================================================
-- Author: Gregory
-- Create date: 2015-09-25
-- Description: Удаление записи
-- 2015-10-03  Возвращаю ID удалённой записи. Nick
-- ------------------------------------------------ 
--  2015-10-14 Исправления ревизия 846   Gregory   
--  2016-07-13 Gregory. Контроль уникальности.
-- =====================================================================================================================
/* ---------------------------------------------------------------------------------------------------------------------
   Входные параметры:
                1) p_rec_id id_t -- Идентификатор записи
	Выходные параметры:
                1) _result        result_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение
--------------------------------------------------------------------------------------------------------------------- */
SET search_path = nso, public, pg_catalog;
--DROP FUNCTION IF EXISTS nso.nso_p_record_d(id_t);
CREATE OR REPLACE FUNCTION nso.nso_p_record_d
(
        p_rec_id    id_t      -- Идентификатор записи
)
RETURNS result_t AS 
$$
DECLARE
        _nso_id id_t;           -- 2016-07-13 Gregory 
        _nso_code t_str60;
        _is_active t_boolean;
        _unique_check t_boolean; -- 2016-07-13 Gregory
        _result result_t;
        c_ERR_FUNC_NAME t_sysname = 'nso_p_record_d';
        c_MESS_OK t_str1024 = 'Успешно удалена запись.';
BEGIN
        IF p_rec_id IS NULL
        THEN
                RAISE SQLSTATE '60000'; -- NULL значения запрещены
        END IF;

        SELECT nso_code, active_sign, nso_id, unique_check
        INTO _nso_code, _is_active, _nso_id, _unique_check
        FROM ONLY nso.nso_object
        JOIN ONLY nso.nso_record
        USING(nso_id)
        WHERE rec_id = p_rec_id;

        IF NOT _is_active
        THEN
                RAISE SQLSTATE '63020'; -- НСО не активен. Запрещено удаление записей.
        END IF;

        IF _nso_code IS NOT NULL
        THEN
--- 2016-07-13 Gregory unique_check
                IF _unique_check
                THEN
                        DELETE FROM nso.nso_record_unique
                        WHERE rec_id = p_rec_id;
                END IF;
--- 2016-07-13 Gregory
                PERFORM nso.nso_p_nso_log_i('5','Удаление данных объекта: ' || _nso_code);
                DELETE FROM ONLY nso.nso_abs WHERE rec_id = p_rec_id;
                DELETE FROM ONLY nso.nso_blob WHERE rec_id = p_rec_id;   
                DELETE FROM ONLY nso.nso_ref WHERE rec_id = p_rec_id;
                DELETE FROM ONLY nso.nso_record WHERE rec_id = p_rec_id;

                UPDATE ONLY nso.nso_object
                SET nso_release = nso_release + 1
                WHERE nso_id = _nso_id;
        ELSE
                RAISE SQLSTATE '60004'; -- Запись не найдена
        END IF;

     	_result.rc = p_rec_id; -- Nick 2015-10-03  Так более информативно.
        _result.errm = c_MESS_OK;
        
        RETURN _result;
EXCEPTION
        WHEN OTHERS THEN
                BEGIN
                        _result.rc = -1;
                        _result.errm = com.f_error_handling(SQLSTATE, SQLERRM, c_ERR_FUNC_NAME);
                        RETURN _result;
                END;
END;
$$
LANGUAGE plpgsql
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION nso.nso_p_record_d(id_t)
IS '3414: Удаление записи
        Входные параметры:
                1) p_nso_id id_t -- Идентификатор записи
	Выходные параметры:
                1) _result        result_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение';

-- SELECT * FROM nso.nso_p_record_d(8);

-- SELECT * FROM nso_p_record_d(NULL::id_t);
-- -1;"Все параметры явялются обязательными, NULL значения запрещены. Ошибка произошла в функции: "nso_p_record_d"."

-- SELECT * FROM nso_p_record_d(100500);
-- -1;"Запись не найдена. Ошибка произошла в функции: "nso_p_record_d"."

-- SELECT * FROM nso_p_record_d(3551);
-- 0;"Успешно удалена запись."

-- SELECT * FROM nso.nso_log WHERE impact_type = '5'
-- SELECT * FROM nso.v_spr_blob
-- SELECT * FROM nso.nso_abs_hist WHERE log_id = 21666
-- SELECT * FROM nso.nso_blob_hist WHERE log_id = 21666
-- SELECT * FROM nso.nso_ref_hist

-- INSERT INTO com.obj_errors VALUES('63020','НСО не активен. Запрещено удаление записей','nso');
-- SELECT * FROM ONLY nso.nso_object WHERE nso_code = 'CL_TEST'
-- SELECT * FROM nso.nso_p_object_on('CL_TEST', TRUE);
-- SELECT * FROM nso.nso_f_record_select_all ('CL_TEST');
-- SELECT * FROM ONLY nso.nso_record WHERE nso_id = 7;
-- SELECT * FROM nso_p_record_d(3612);
-- -1;"НСО не активен. Запрещено удаление записей. Ошибка произошла в функции: "nso_p_record_d"."

-- SELECT * FROM nso.nso_p_object_d ('SPR_EMPLOYE');
/* UPDATE com.sys_errors SET message_out = 'Ошибка при удалении записи. Запись является владельцем объекта, удаление невозможно.' 
	WHERE err_code = '23503' AND opr_type = 'd' AND constr_name = 'fk_nso_record_is_owner_obj_object';
*/
-- -1;"Ошибка при удалении записи. Запись является владельцем объекта, удаление невозможно.. Ошибка произошла в функции: "nso_p_object_d"."

