-- =====================================================================================================================
-- Author: Gregory
-- Create date: 2015-09-25
-- Description: Удаление записи
-- 2015-10-03  Возвращаю ID удалённой записи. Nick
-- -----------------------------------------------
--  2015-10-14 Исправления ревизия 846   Gregory   
--  2016-07-13 Gregory. Контроль уникальности. 
-- =====================================================================================================================
/* ---------------------------------------------------------------------------------------------------------------------
        Входные параметры:
                1) p_rec_uuid t_guid -- Идентификатор записи
	Выходные параметры:
                1) _result        result_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение
--------------------------------------------------------------------------------------------------------------------- */
SET search_path = nso, public, pg_catalog;
DROP FUNCTION IF EXISTS nso.nso_p_record_d ( public.t_guid );
CREATE OR REPLACE FUNCTION nso.nso_p_record_d
(
        p_rec_uuid public.t_guid -- Идентификатор записи
)
RETURNS result_t AS 
$$
DECLARE
        _rec_id          public.id_t;
        _nso_id          public.id_t;
        _nso_code        public.t_str60;
        _is_active       public.t_boolean;
        _unique_check    public.t_boolean; -- 2016-07-13 Gregory
        _result          public.result_t;
        c_ERR_FUNC_NAME  public.t_sysname = 'nso_p_record_d';
        c_MESS_OK        public.t_str1024 = 'Успешно удалена запись.';
BEGIN
        IF p_rec_uuid IS NULL
        THEN
                RAISE SQLSTATE '60000'; -- NULL значения запрещены
        END IF;

        SELECT rec_id, nso_code, active_sign, nso_id, unique_check -- Nick 2016-07-29 Пропущено было
        INTO _rec_id, _nso_code, _is_active, _nso_id, _unique_check
        FROM ONLY nso.nso_object
        JOIN ONLY nso.nso_record
        USING (nso_id)
        WHERE rec_uuid = p_rec_uuid;

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
                        WHERE rec_id = _rec_id;
                END IF;
--- Gregory 2016-07-13
                PERFORM nso.nso_p_nso_log_i('5','Удаление данных объекта: ' || _nso_code);
                DELETE FROM ONLY nso.nso_abs WHERE rec_id = _rec_id;
                DELETE FROM ONLY nso.nso_blob WHERE rec_id = _rec_id;   
                DELETE FROM ONLY nso.nso_ref WHERE rec_id = _rec_id;
                DELETE FROM ONLY nso.nso_record WHERE rec_id = _rec_id;

                UPDATE ONLY nso.nso_object
                SET nso_release = nso_release + 1
                WHERE nso_id = _nso_id;
        ELSE
                RAISE SQLSTATE '60004'; -- Запись не найдена
        END IF;

        	_result.rc = _rec_id; -- Nick 2015-10-03  Так более информативно.
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

COMMENT ON FUNCTION nso.nso_p_record_d ( public.t_guid )
IS '3493: Удаление записи
            Входные параметры:
                1) p_nso_uuid public.t_guid -- Идентификатор записи
	         Выходные параметры:
                1) _result        public.result_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение';

-- SELECT * FROM nso.nso_f_record_select_all('SPR_RNTD');
-- SELECT * FROM nso.nso_p_record_d('45dda8e1-9bfa-4d26-8181-0b78a978ba02'::t_guid);

-- SELECT * FROM nso_p_record_d(NULL::t_guid);
-- -1;"Все параметры явялются обязательными, NULL значения запрещены. Ошибка произошла в функции: "nso_p_record_d"."

-- SELECT * FROM nso_p_record_d(newid());
-- -1;"Запись не найдена. Ошибка произошла в функции: "nso_p_record_d"."

-- SELECT * FROM nso_p_record_d('3a0616b8-ca77-457d-8353-8a64f1549dc9'::t_guid);
-- SELECT * FROM nso.nso_record WHERE ( rec_uuid = '88EFF3A2-326F-4155-AAE2-EB587D91EF5F'::t_guid );

-- 0;"Успешно удалена запись."
-- --------------------------------------------------------------------------------------------------
-- SELECT * FROM nso.v_spr_ex_enterprise;
-- 2730||'ФГУП "СПб завод "Госметр"'|'Федеральное государственное унитарное предприятие "Санкт-Петербургский завод "Госметр"'|'7816007081'|'781601001'|'226394   '|'192007, г. Санкт-Петербург, ул. Курская, д. 28/32'|'192007, г. Санкт-Петербург, ул. Курская, д. 28/32'|'192007, г. Санкт-Петербург, ул. Курская, д. 28/32'|'192007   '|'98af102d-a359-49f6-9699-764946ae49d7'
-- 1043||'ООО "ПРОЛАЙН"'|'Общество с ограниченной ответственностью "ПРОЛАЙН"'|'7814051744'|'781000000'|'44304474 '|'г. Санкт-Петербург'|'г. Санкт-Петербург'|'г. Санкт-Петербург'|'г. Сан   '|'4f41a1aa-be2b-4bd1-8b03-e9b35db9ba07'
-- -------------------------------------
-- SELECT * FROM nso_p_record_d ( '98af102d-a359-49f6-9699-764946ae49d7'::t_guid );
-- 2730|'Успешно удалена запись.'
-- SELECT * FROM nso_p_record_d ( 1043::id_t );
-- -------------------------------------------
-- 1348||'ЗАО "НПЦ "ЛИНА"'|'ЗАО "Научно-производственный центр "ЛИНА"'|'7722018747'|'772201001'|'17166319 '|'111250, г. Москва, ул. Красноказарменная, д. 14а'|'111250, г. Москва, ул. Красноказарменная, д. 14а'|'111250, г. Москва, ул. Красноказарменная, д. 14а'|'111250   '|'53afb665-0b87-4fb6-9913-a388f3d9a2f9'
-- 2513||'ЗАО "ПЕТРОАВИАМОНТАЖ"'|'Закрытое акционерное общество "ПЕТРОАВИАМОНТАЖ"'|'7805039116'|'781601001'|'35505423 '|'192236, г. Санкт-Петербург, ул.Софийская, д.10-в'|'192236, г. Санкт-Петербург, ул.Софийская, д.10-в'|'192236, г. Санкт-Петербург, ул.Софийская, д.10-в'|'192236   '|'659754b4-eba3-45e4-98bf-21176bd1878c'
-- SELECT * FROM nso_p_record_d ( 1043::id_t );
--
-- SELECT * FROM nso.nso_record_unique WHERE ( rec_id IN ( 1348, 2513 ) );
-- SELECT * FROM nso_p_record_d ( '53AFB665-0B87-4FB6-9913-A388F3D9A2F9'::t_guid );
-- SELECT * FROM nso_p_record_d ( '659754B4-EBA3-45E4-98BF-21176BD1878C'::t_guid );
--
-- SELECT * FROM nso.nso_log WHERE impact_type = '5'
-- SELECT * FROM nso.v_spr_blob
-- SELECT * FROM nso.nso_abs_hist WHERE log_id = 21667
-- SELECT * FROM nso.nso_blob_hist WHERE log_id = 21667
-- SELECT * FROM nso.nso_ref_hist

-- SELECT * FROM ONLY nso.nso_record WHERE nso_id = 7;
-- SELECT * FROM nso_p_record_d('88eff3a2-326f-4155-aae2-eb587d91ef5f'::t_guid);
-- -1;"НСО не активен. Запрещено удаление записей. Ошибка произошла в функции: "nso_p_record_d"."
-- -------------------------------------------------------------
-- SELECT * FROM com.all_v_event_log WHERE ( sch_name = 'nso' );
-- 105|'postgres'|'::1/128'|'2015-10-13 20:16:25'|'nso'|'5'|'Удаление данных, запись и ячейки'|'Удаление данных объекта: CL_TEST'
-- 104|'postgres'|'::1/128'|'2015-10-13 20:16:19'|'nso'|'1'|'Активация НСО'|'НСО активирован. CL_TEST. Тестовый классификатор'
-- 103|'postgres'|'::1/128'|'2015-10-13 20:14:26'|'nso'|'2'|'Выключение (деактивация) НСО'|'НСО деактивирован. CL_TEST. Тестовый классификатор'
-- 102|'postgres'|'::1/128'|'2015-10-13 19:48:08'|'nso'|'4'|'Обновление данных, запись и ячейки'|'Обновление данных объекта: CL_TEST'
-- 101|'postgres'|'::1/128'|'2015-10-13 19:33:15'|'nso'|'5'|'Удаление данных, запись и ячейки'|'Удаление данных объекта: CL_TEST'
-- 100|'postgres'|'::1/128'|'2015-10-13 19:25:31'|'nso'|'4'|'Обновление данных, запись и ячейки'|'Обновление данных объекта: CL_TEST'


