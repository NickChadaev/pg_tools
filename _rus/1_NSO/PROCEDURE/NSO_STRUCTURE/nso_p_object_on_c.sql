-- =====================================================================================================================
-- Author: Gregory
-- Create date: 2015-09-03
-- Description: Активация и деактивация нормативно-справочного объекта
-- 2015-10-06 Реализовано каскадная операция активации/деактивации.
-- =====================================================================================================================
/* ---------------------------------------------------------------------------------------------------------------------
        Входные параметры:
                1) p_nso_code    t_str60   -- Код НСО, поисковый аргумент, всегда NOT NULL
                2) p_active_sign t_boolean -- Признак активного НСО, TRUE - НСО включен, FALSE - НСО выключен
	Выходные параметры:
                1) _result        result_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- ID НСО (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение "НСО активирован/НСО деактивирован" (при успехе)
--------------------------------------------------------------------------------------------------------------------- */
SET search_path = com, nso, public, pg_catalog;
DROP FUNCTION IF EXISTS nso.nso_p_object_on(t_str60,t_boolean);
CREATE OR REPLACE FUNCTION nso.nso_p_object_on
(
        p_nso_code    t_str60   -- Код НСО, поисковый аргумент, всегда NOT NULL
       ,p_active_sign t_boolean -- Признак активного НСО, TRUE - НСО включен, FALSE - НСО выключен
)
RETURNS result_t AS 
$$
DECLARE
        _log_id   id_t;
        _nso_id   id_t;
        _group    t_boolean;
        _nso_name t_str250;
        --                      
        _tr_nso_key_ud     t_boolean;
        _tr_nso_record_ud  t_boolean;
        _tr_nso_abs_ud     t_boolean;
        _tr_nso_blob_ud    t_boolean;
        _tr_nso_ref_ud     t_boolean;
        _tr_nso_object_ud  t_boolean;

        _result          result_t;
        
        c_ERR_FUNC_NAME  t_sysname = 'nso_p_object_on';
        c_MESS_ON        t_str1024 = 'НСО активирован.';
        c_MESS_OFF       t_str1024 = 'НСО деактивирован.';

        _group_op t_str1024;  -- Nick 2015-10-05
        
BEGIN
        IF p_nso_code IS NOT NULL
        THEN
                SELECT n.nso_id, (c.codif_code = 'C_NSO_NODE' OR n.is_group_nso), n.nso_name INTO _nso_id, _group, _nso_name -- Nick убрал алиас NO
                FROM ONLY nso.nso_object n JOIN ONLY com.obj_codifier c ON n.nso_type_id = c.codif_id
                WHERE upper(btrim( n.nso_code)) = upper(btrim(p_nso_code));
        ELSE
                RAISE SQLSTATE '60000'; -- NULL значения запрещены
        END IF;

        -- Nick 2015-10-07 
        IF ( _group ) THEN
                   _group_op := '. ГРУППОВАЯ ОПЕРАЦИЯ';
            ELSE
                _group_op := '';
        END IF;
        -- Nick 2015-10-07

        SELECT tgenabled != 'D' INTO _tr_nso_key_ud    FROM pg_trigger WHERE tgname = 'tr_nso_key_ud';
        SELECT tgenabled != 'D' INTO _tr_nso_record_ud FROM pg_trigger WHERE tgname = 'tr_nso_record_ud';
        SELECT tgenabled != 'D' INTO _tr_nso_abs_ud    FROM pg_trigger WHERE tgname = 'tr_nso_abs_ud';
        SELECT tgenabled != 'D' INTO _tr_nso_blob_ud   FROM pg_trigger WHERE tgname = 'tr_nso_blob_ud';
        SELECT tgenabled != 'D' INTO _tr_nso_ref_ud    FROM pg_trigger WHERE tgname = 'tr_nso_ref_ud';
        SELECT tgenabled != 'D' INTO _tr_nso_object_ud FROM pg_trigger WHERE tgname = 'tr_nso_object_ud';

        -- ----------------------------------------------------------------------------------------------------------------------------------
        -- RAISE NOTICE '% % % % % %', _tr_nso_key_ud, _tr_nso_record_ud, _tr_nso_abs_ud, _tr_nso_blob_ud, _tr_nso_ref_ud, _tr_nso_object_ud;
        --
        -- 1) Nick 2015-09-11
        -- 
        IF _tr_nso_key_ud    THEN ALTER TABLE nso.nso_key    DISABLE TRIGGER tr_nso_key_ud;    END IF;        
        IF _tr_nso_record_ud THEN ALTER TABLE nso.nso_record DISABLE TRIGGER tr_nso_record_ud; END IF;     
        IF _tr_nso_abs_ud    THEN ALTER TABLE nso.nso_abs    DISABLE TRIGGER tr_nso_abs_ud;    END IF;     
        IF _tr_nso_blob_ud   THEN ALTER TABLE nso.nso_blob   DISABLE TRIGGER tr_nso_blob_ud;   END IF;     
        IF _tr_nso_ref_ud    THEN ALTER TABLE nso.nso_ref    DISABLE TRIGGER tr_nso_ref_ud;    END IF;     
        IF _tr_nso_object_ud THEN ALTER TABLE nso.nso_object DISABLE TRIGGER tr_nso_object_ud; END IF;     
        -- ------------------------------------------------------------------------------------------
        -- 2) Nick 2015-09-11  Запись в LOG, определить id_log. остальные UPDATE делать с этим ID_LOG
        -- ------------------------------------------------------------------------------------------
        IF p_active_sign 
        THEN -- ON
                _log_id = nso.nso_p_nso_log_i ('1', c_MESS_ON  || ' ' || p_nso_code || '. ' || _nso_name || _group_op);
        ELSE -- OFF
                _log_id = nso.nso_p_nso_log_i ('2', c_MESS_OFF || ' ' || p_nso_code || '. ' || _nso_name || _group_op);
        END IF;

        IF _group IS TRUE
        THEN
                PERFORM nso.nso_p_object_on(nso_code, p_active_sign) FROM ONLY nso.nso_object WHERE parent_nso_id = _nso_id;
        END IF;
        -- --------------------------------------------------------
        -- 3) Nick 2015-09-11  Сделали UPDATE подчинённым таблицам.
        -- --------------------------------------------------------
        UPDATE ONLY nso.nso_object SET active_sign = p_active_sign, id_log = _log_id WHERE nso_id = _nso_id RETURNING nso_id INTO _nso_id;
        UPDATE ONLY nso.nso_key SET on_off = p_active_sign, log_id = _log_id WHERE nso_id = _nso_id;
        UPDATE ONLY nso.nso_record SET actual = p_active_sign, log_id = _log_id WHERE nso_id = _nso_id;
        UPDATE ONLY nso.nso_abs SET is_actual = p_active_sign, log_id = _log_id WHERE rec_id IN
                (SELECT rec_id FROM ONLY nso.nso_record WHERE nso_id = _nso_id);   
        UPDATE ONLY nso.nso_blob SET is_actual = p_active_sign, log_id = _log_id WHERE rec_id IN
                (SELECT rec_id FROM ONLY nso.nso_record WHERE nso_id = _nso_id);  
        UPDATE ONLY nso.nso_ref SET is_actual = p_active_sign, log_id = _log_id WHERE rec_id IN
                (SELECT rec_id FROM ONLY nso.nso_record WHERE nso_id = _nso_id);

        IF _tr_nso_key_ud    THEN ALTER TABLE nso.nso_key    ENABLE TRIGGER tr_nso_key_ud;    END IF;        
        IF _tr_nso_record_ud THEN ALTER TABLE nso.nso_record ENABLE TRIGGER tr_nso_record_ud; END IF;     
        IF _tr_nso_abs_ud    THEN ALTER TABLE nso.nso_abs    ENABLE TRIGGER tr_nso_abs_ud;    END IF;     
        IF _tr_nso_blob_ud   THEN ALTER TABLE nso.nso_blob   ENABLE TRIGGER tr_nso_blob_ud;   END IF;     
        IF _tr_nso_ref_ud    THEN ALTER TABLE nso.nso_ref    ENABLE TRIGGER tr_nso_ref_ud;    END IF;     
        IF _tr_nso_object_ud THEN ALTER TABLE nso.nso_object ENABLE TRIGGER tr_nso_object_ud; END IF;   

        IF _nso_id IS NOT NULL
        THEN
                _result.rc = _nso_id;
                IF p_active_sign
                THEN
                        _result.errm = c_MESS_ON;
                ELSE
                        _result.errm = c_MESS_OFF;
                END IF;
        ELSE
                RAISE SQLSTATE '60004'; -- Запись не найдена 
  	     END IF;
  	
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

COMMENT ON FUNCTION nso.nso_p_object_on(t_str60,t_boolean)
IS '2126: Активация и деактивация Нормативно-Справочного Объекта
        Входные параметры:
                1) p_nso_code    t_str60   -- Код НСО, поисковый аргумент, всегда NOT NULL
                2) p_active_sign t_boolean -- Признак активного НСО, TRUE - НСО включен, FALSE - НСО выключен
	Выходные параметры:
                1) _result        result_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- ID НСО (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение "НСО активирован/НСО деактивирован" (при успехе)';

-- SELECT * FROM ONLY nso.nso_object WHERE nso_id = 31;
-- SELECT * FROM nso.nso_p_object_on('SPR_RNTD', TRUE);

-- SELECT * FROM ONLY nso.nso_key WHERE nso_id = 31;
-- SELECT * FROM ONLY nso.nso_record WHERE nso_id = 31;
-- SELECT * FROM ONLY nso.nso_abs WHERE rec_id IN (2899,2897);
-- SELECT * FROM ONLY nso.nso_blob WHERE rec_id IN (2899,2897);
-- SELECT * FROM ONLY nso.nso_ref WHERE rec_id IN (2899,2897);

-- SELECT * FROM ONLY nso.nso_key_hist WHERE nso_id = 31; 1 1
-- SELECT * FROM ONLY nso.nso_record_hist WHERE nso_id = 31; 3 3
-- SELECT * FROM ONLY nso.nso_abs_hist WHERE rec_id IN (2899,2897); 14 14
-- SELECT * FROM ONLY nso.nso_blob_hist WHERE rec_id IN (2899,2897); 0 0
-- SELECT * FROM ONLY nso.nso_ref_hist WHERE rec_id IN (2899,2897); 2 2

                
-------------------------------------------------------------------------------------------------------------------------
-- SELECT * FROM nso.nso_f_object_s_sys('CL_LOCAL');
-- SELECT * FROM all_v_event_log WHERE ( sch_name = 'nso' ) AND ( impact_date >= '2015-10-06' );
-- 79|'postgres'|'::1/128'|'2015-10-07 11:54:43'|'nso'|'2'|'Выключение (деактивация) НСО'|'Деактивация НСО: CL_LOCAL'

-- SELECT * FROM nso.nso_f_object_s_sys();
-- SELECT * FROM nso.nso_p_object_on('SPR_OBJECT_STATUS', TRUE);
-- 24;"НСО активирован."

-- SELECT * FROM nso.nso_p_object_on('CL_LOCAL', FALSE);
-- 5|'НСО деактивирован.'
-- SELECT * FROM all_v_event_log WHERE ( sch_name = 'nso' ) AND ( impact_date >= '2015-10-06' );
-- SELECT * FROM nso.nso_p_object_on('BUBLIK', TRUE);

-- -1;"Запись не найдена. Ошибка произошла в функции: "nso_p_object_on"."

-- 1) SELECT * FROM nso.nso_p_object_on('CL_LOCAL', TRUE);  -- Nick
-- 5|'НСО активирован.'
-- SELECT * FROM all_v_event_log WHERE ( sch_name = 'nso' ) AND ( impact_date >= '2015-10-06' );
-- -----------------------
-- ЗАМЕЧАНИЕ:  t t t t t t
-- ЗАМЕЧАНИЕ:  f f f f f f
-- CONTEXT:  SQL-оператор: "SELECT nso.nso_p_object_on(nso_code, p_active_sign) FROM ONLY nso.nso_object WHERE parent_nso_id = _nso_id"
-- функция PL/pgSQL nso_p_object_on(t_str60,t_boolean), строка 62, оператор PERFORM
-- ЗАМЕЧАНИЕ:  f f f f f f
-- CONTEXT:  SQL-оператор: "SELECT nso.nso_p_object_on(nso_code, p_active_sign) FROM ONLY nso.nso_object WHERE parent_nso_id = _nso_id"

-- функция PL/pgSQL nso_p_object_on(t_str60,t_boolean), строка 62, оператор PERFORM
-- ЗАМЕЧАНИЕ:  f f f f f f
-- CONTEXT:  SQL-оператор: "SELECT nso.nso_p_object_on(nso_code, p_active_sign) FROM ONLY nso.nso_object WHERE parent_nso_id = _nso_id"

-- функция PL/pgSQL nso_p_object_on(t_str60,t_boolean), строка 62, оператор PERFORM
-- ЗАМЕЧАНИЕ:  f f f f f f
-- CONTEXT:  SQL-оператор: "SELECT nso.nso_p_object_on(nso_code, p_active_sign) FROM ONLY nso.nso_object WHERE parent_nso_id = _nso_id"

-- функция PL/pgSQL nso_p_object_on(t_str60,t_boolean), строка 62, оператор PERFORM
-- Суммарное время выполнения запроса: 78 ms.
-- 1 строка получена
-- -----------------
-- 2) SELECT * FROM all_v_event_log WHERE ( sch_name = 'nso' ) AND ( impact_date >= '2015-10-06' );
-- 80|'postgres'|'::1/128'|'2015-10-07 12:00:23'|'nso'|'1'|'Активация НСО'|'Активация НСО: CL_LOCAL'
-- ------------------------------------------------------------------------------------------------
-- SELECT * FROM nso.nso_record WHERE ( log_id = 80 );
-- SELECT * FROM nso.nso_object WHERE ( id_log = 80 );

-- SELECT * FROM nso.nso_f_object_s_sys('CL_LOCAL');    -- 1 родитель + 4 ребёнка

-- SELECT * FROM nso.nso_p_object_on('BUBLIK', TRUE);

-- SELECT * FROM nso.nso_log
-- SELECT * FROM nso.nso_object WHERE id_log = 21619
-- SELECT * FROM nso.nso_key WHERE log_id = 21619
-- SELECT * FROM nso.nso_record WHERE log_id = 21623
-- SELECT * FROM nso.nso_abs WHERE log_id = 21619
-- SELECT * FROM nso.nso_blob WHERE log_id = 21619
-- SELECT * FROM nso.nso_ref WHERE log_id = 21619

-- SELECT * FROM nso.nso_p_object_on('CL_LOCAL', TRUE);
-- SELECT * FROM nso.nso_p_object_on('CL_TEST', FALSE);
-- SELECT * FROM ONLY nso.nso_object WHERE parent_nso_id = 5 OR nso_id = 5
-- SELECT * FROM nso.nso_p_view_c ('SPR_BLOB');
-- SELECT length (upper(newid()::varchar)) AS len, upper(newid()::varchar) AS value;
--
-- 'SPR_BLOB'
-- 2) SELECT * FROM all_v_event_log WHERE ( sch_name = 'nso' ) AND ( impact_date >= '2015-10-06' );
-- SELECT * FROM nso.nso_f_object_s_sys('SPR_BLOB');
-- SELECT * FROM nso.nso_p_object_on('SPR_BLOB', true);