-- =====================================================================================================================
-- Author: Gregory
-- Create date: 2015-09-28
-- Description: Обновление записи
-- --------------------------------------------
-- 2015-10-14 Исправления ревизия 846   Gregory 
-- 2015-12-11 Redmine gap #174 При проверке ссылочного значения введён контроль на NULL,
--            Если ссылочное значение = NULL, то делаем проверку принадлежности к домену. Nick  
-- 2016-07-13 Gregory. Контроль уникальности.
-- 2016-11-12 Nick,  Абсолютное значение типа t_text (t_arr_values -> t_arr_text, t_str2048 -> t_text) 
/* ---------------------------------------------------------------------------------------------------------------------
        Входные параметры:
                1) p_rec_uuid        t_guid       -- Идентификатор текущей записи
                2) p_parent_rec_uuid t_guid       -- Идентификатор родительской записи
                -- p_nso_code        t_str60      -- Код НСО
                3) p_mas_val         t_arr_text   -- Массив значений для ячеек, для ссылочного значения передаём UUID
                4) p_silent_mode     t_boolean    -- Режим тишины, выводятся только сообщения связанные с EXECEPTION
                5) p_actual          t_boolean    -- Актуальность
                6) p_date_from       t_timestamp  -- Дата начала актуальности
                7) p_date_to         t_timestamp  -- Дата завершения актуальности
	Выходные параметры:
                1) _result        result_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение
--------------------------------------------------------------------------------------------------------------------- */
SET search_path = nso, com, public;

-- удаление распространяется на объект правило r_nso_spr_pre_job_list_u для отношения: представление v_spr_pre_job_list
-- удаление распространяется на объект правило r_nso_spr_report_list_u для отношения: представление v_spr_report_list

-- DROP FUNCTION IF EXISTS nso.nso_p_record_u (t_guid, t_guid, t_arr_values, t_boolean, t_timestamp, t_timestamp ) CASCADE; -- -- Старое надо удалять, едрёна вошь !!
-- DROP FUNCTION IF EXISTS nso.nso_p_record_u (t_guid, t_guid, t_arr_text, t_boolean, t_boolean,t_timestamp,t_timestamp) ;--CASCADE
CREATE OR REPLACE FUNCTION nso.nso_p_record_u
(
        p_rec_uuid        t_guid       -- Идентификатор текущей записи
       ,p_parent_rec_uuid t_guid       -- Идентификатор родительской записи
       ,p_mas_val         t_arr_text   -- Массив значений для ячеек, для ссылочного значения передаём UUID
       ,p_silent_mode     t_boolean    -- Режим тишины, выводятся только сообщения связанные с EXECEPTION
                DEFAULT TRUE
       ,p_actual          t_boolean    -- Актуальность
                DEFAULT NULL           -- было TRUE
       ,p_date_from       t_timestamp  -- Дата начала актуальности
                DEFAULT CURRENT_TIMESTAMP::TIMESTAMP(0) WITHOUT TIME ZONE
       ,p_date_to         t_timestamp  -- Дата завершения актуальности
                DEFAULT '9999-12-31 00:00:00'::TIMESTAMP(0) WITHOUT TIME ZONE
)
RETURNS result_t AS
$$
DECLARE
        _rec_id id_t;
        _nso_id id_t;
        _nso_code t_str60;
        _parent_rec_id id_t;
        _arr_column column_t[];
        
        с_FUNC_NAME        t_sysname  := 'nso_p_record_u';
        c_DOMAIN_NODE      t_str60    := 'C_DOMEN_NODE';
        c_MES000           t_str1024  := 'Выполнено успешно';

        _ref_rec_id  id_t;
        _unique_check t_boolean; -- 2016-07-13 Gregory

        rsp_main result_t;
        
        _rsp     result_t;
        _len_p_mas_val      t_int;
        _len_arr_type_code  t_int;
        _ind                t_int := 1;
BEGIN
        SELECT rec_id, nso_id
        INTO _rec_id, _nso_id
        FROM ONLY nso.nso_record
        WHERE rec_uuid = p_rec_uuid;

        IF ( _rec_id IS NULL ) THEN  -- Nick 2015-12-11   Гриня, порву как Шарик шапку.
              RAISE SQLSTATE '60021';
        END IF;                      -- Nick 2015_12-11 

        SELECT nso_code, unique_check
        INTO _nso_code, _unique_check
        FROM ONLY nso.nso_object
        WHERE nso_id = _nso_id;

        -- Nick 2017-09-25
        _parent_rec_id := NULL;
        IF ( p_parent_rec_uuid IS NOT NULL) 
        THEN
             IF nso_f_record_is_valid ( _nso_code, p_parent_rec_uuid ) 
             THEN
                _parent_rec_id := nso.nso_f_record_get_id ( p_parent_rec_uuid );
             ELSE
                 RAISE 'Родительский UUID "%", не принадлежит справочнику "%"', p_parent_rec_uuid, _nso_code;
             END IF;
        END IF;
        -- Nick 2017-09-25

        -- SELECT rec_id
        -- INTO _parent_rec_id
        -- FROM ONLY nso.nso_record
        -- WHERE rec_uuid = p_parent_rec_uuid;

        SELECT ARRAY
        (
                SELECT ROW
                (
                        col_id
                       ,attr_type_scode
                       ,CASE WHEN key_type_scode IS NULL
                             THEN '0'
                             ELSE key_type_scode
                        END
                )
                FROM nso.nso_f_column_head_nso_s(upper(btrim(_nso_code)))
                WHERE attr_type_code <> c_DOMAIN_NODE -- 'C_DOMEN_NODE'
                ORDER BY number_col
        )
        INTO _arr_column;
        
        _len_p_mas_val     := array_length ( p_mas_val, 1);
        _len_arr_type_code := array_length (_arr_column, 1);
-----
   	IF ( _len_p_mas_val = _len_arr_type_code )  		
   	THEN 
                --- 2016-07-14 Gregory
                IF _unique_check
                THEN
                        UPDATE nso.nso_record_unique
                        SET unique_check = FALSE
                        WHERE rec_id = _rec_id;
                END IF;
                ---			
                WHILE ( _ind <= _len_arr_type_code )
                LOOP 
                     _rsp := com.com_f_value_check ( _arr_column [_ind].col_stype, p_mas_val [_ind] );
                     IF ( _rsp.rc = -1 ) THEN
                           RAISE EXCEPTION '%', _rsp.errm ; -- Ошибка преобразования типа
                     END IF;
                     IF ( NOT p_silent_mode ) THEN
                                    RAISE NOTICE '%', _rsp.errm;
                     END IF;
                     _ind := _ind + 1;
                END LOOP;
        ELSE
                RAISE SQLSTATE '63017'; -- 'Количество атрибутов не соответствует структуре заголовка';
   	END IF;
-----
        UPDATE ONLY nso.nso_record
        SET
                parent_rec_id = COALESCE(_parent_rec_id, parent_rec_id)
               ,actual = COALESCE(p_actual, actual)
               ,date_from = COALESCE(p_date_from, date_from)
               ,date_to = COALESCE(p_date_to, date_to)
        WHERE rec_id = _rec_id;

-----
        _ind = 1;
   	WHILE ( _ind <= _len_p_mas_val ) LOOP   
         IF ( _arr_column [_ind].col_stype = 'T' ) THEN -- Ссылка
            IF ( p_mas_val [_ind] IS NOT NULL ) THEN -- Nick 2015-12-11 Redmine gap #174
                  --  ---------------     
                  --  Nick 2015-07-06
                  --  -----------------------------------------------------------------------
                  --  Определить тот домен, к которому принадлежит атрибут, это nso_id.  !!!!
                  --
                  _nso_id := ( SELECT d.domain_nso_id FROM ONLY nso.nso_column_head nh, ONLY com.nso_domain_column d 
                                                                      WHERE ( nh.attr_id = d.attr_id ) AND ( nh.col_id = _arr_column [_ind].col_id )
                  ); -- ID НСО-домена.
                  _ref_rec_id := ( SELECT r.rec_id FROM ONLY nso.nso_record r 
                                         WHERE (r.rec_uuid = CAST ( p_mas_val [_ind] AS t_guid )) AND ( r.nso_id = _nso_id)
                  );-- Разыменование UUID-ссылки в ID
                  IF ( _ref_rec_id IS NULL ) THEN
                     RAISE SQLSTATE '90003'; -- 'Неправильное ссылочное значение, не принадлежащее НСО-ДОМЕНУ'; 
                  END IF;
            ELSE
                  _ref_rec_id := NULL;
            END IF;
            --
            UPDATE ONLY nso.nso_ref
            SET
                 is_actual = COALESCE(p_actual, is_actual)
                ,ref_rec_id = COALESCE(_ref_rec_id, ref_rec_id)
            WHERE rec_id = _rec_id AND col_id = _arr_column[_ind].col_id;
                   -- иначе значение атрибута либо BLOB либо абсолютное 
   	   ELSE
   	          IF ( _arr_column [_ind].col_stype <> 'q' ) THEN -- BLOB   Создаём запись с пустым значением, потом - функция  blob_push
                        -- Абсолютная величина
                        UPDATE ONLY nso.nso_abs
                        SET
                                is_actual = COALESCE(p_actual, is_actual)
                               ,val_cell_abs = COALESCE(p_mas_val[_ind], val_cell_abs)
                        WHERE rec_id = _rec_id AND col_id = _arr_column[_ind].col_id;
                -- 
                END IF; -- NOT BLOB ??    
   	   END IF; -- Ссылка ??
   	   
         _ind := _ind + 1;
   	END LOOP;-- while
-----

        --- 2016-07-14 Gregory
        IF _unique_check
        THEN
                UPDATE nso.nso_record_unique
                SET unique_check = TRUE
                WHERE rec_id = _rec_id;
        END IF;
        --- 2016-07-13 Gregory

        rsp_main := (_rec_id, c_MES000);
        RETURN rsp_main;
EXCEPTION
        WHEN OTHERS THEN 
                BEGIN
                        rsp_main := (-1, com.f_error_handling(SQLSTATE, SQLERRM, с_FUNC_NAME));
                        RETURN rsp_main;			
   		END;
END;
$$
LANGUAGE plpgsql
SECURITY DEFINER;

COMMENT ON FUNCTION nso.nso_p_record_u( t_guid, t_guid, t_arr_text, t_boolean, t_boolean, t_timestamp, t_timestamp)
IS '7060: Обновление записи.
                1) p_rec_uuid        t_guid       -- Идентификатор текущей записи
                2) p_parent_rec_uuid t_guid       -- Идентификатор родительской записи
                3) p_mas_val         t_arr_text   -- Массив значений для ячеек, для ссылочного значения передаём UUID
                4) p_silent_mode     t_boolean    -- Режим тишины, выводятся только сообщения связанные с EXECEPTION
                5) p_actual          t_boolean    -- Актуальность
                6) p_date_from       t_timestamp  -- Дата начала актуальности
                7) p_date_to         t_timestamp  -- Дата завершения актуальности
	Выходные параметры:
                1) _result        result_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение';

-- SELECT * FROM nso.nso_f_record_select_all('SPR_RNTD');
-- SELECT * FROM nso.nso_f_record_s('f56079d0-6627-4e20-bfad-7d5215846fbf'::t_guid);
-- SELECT * FROM nso.nso_p_record_u(
--         'f56079d0-6627-4e20-bfad-7d5215846fbf'
--        ,NULL
--        ,ARRAY['CODE-CODE','NAME3','f56079d0-6627-4e20-bfad-7d5215846fbf','45dda8e1-9bfa-4d26-8181-0b78a978ba0d']
-- )
-- SELECT * FROM nso.nso_p_record_u(
--         '03aac81b-927f-432f-870a-bdd521d4208f'
--        ,NULL
--        ,ARRAY['CODE-CODE','NAME3','Text']
-- )
-- SELECT * FROM nso.nso_p_record_u(
--         '03aac81b-927f-432f-870a-bdd521d4208f'
--        ,NULL
--        ,ARRAY['CODE-CODE','NAME3','CODE NAME']
-- )

-- SELECT * FROM nso.nso_f_nso_object_unique_check('kl_secr');
-- SELECT * FROM nso.nso_p_object_unique_check_on('kl_secr', TRUE);
-- SELECT * FROM nso.nso_p_object_unique_check_on('kl_secr', FALSE);
-- SELECT * FROM nso.nso_record_unique;

-- SELECT * FROM nso.v_kl_secr;

-- SELECT * FROM nso.nso_p_record_d(3957);
/*
SELECT * FROM nso.nso_p_record_u(
        'bccfd146-46be-4c37-aab0-fcb00fd0bef4'
       ,NULL
       ,ARRAY['2','ДСП','Ограниченно Конфиденциально']
);
*/


                
-- -------------------------------------------------------------------------------------------------------------------
--
-- UPDATE ONLY nso.nso_object SET nso_select = nso.nso_f_select_c ('SPR_EMPLOYE') WHERE nso_code = 'SPR_EMPLOYE';
-- SELECT * FROM nso.nso_p_view_c ('SPR_EMPLOYE');
-- -----------------------------------------------
-- удаление распространяется на объект правило r_nso_spr_pre_job_list_u для отношения: представление v_spr_pre_job_list
-- удаление распространяется на объект правило r_nso_spr_report_list_u для отношения: представление v_spr_report_list
-- --------------------------------------------------------------------------------------------------------------------
-- SELECT * FROM nso.nso_p_view_c ('SPR_PRE_JOB_LIST'); -- ОТ него зависят
-- SELECT * FROM v_SPR_PRE_JOB_LIST ORDER BY 3;
-- SELECT * FROM v_SPR_REPORT_LIST;
-- SELECT * FROM nso.nso_p_view_c ('SPR_REPORT_LIST');
--
-- SELECT * FROM nso.nso_p_record_u('bd59ac54-3946-4e9f-81bb-ac24733812e3', NULL, ARRAY[0::varchar,0::varchar,0::varchar,0::varchar,0::varchar,0::varchar,0::varchar,0::varchar,0::varchar]);
-- SELECT * FROM ONLY nso.nso_record WHERE rec_id = 6;
-- SELECT * FROM ONLY nso.nso_column_head WHERE nso_id = 14;
-- SELECT * FROM nso.nso_f_column_head_nso_s('SPR_DIVISION');
-- --------------------------------------------------------------
-- SELECT * FROM nso.nso_f_record_select_all ('CL_TEST'); 
-- SELECT * FROM nso.nso_p_record_u ( 'c32f2057-c741-4e8e-931c-e1b1c6daf615'::t_guid, NULL::t_guid, ARRAY['ТЕСТ551', null, '211DA7AB-5800-489A-A742-D0045CA202A6']::t_arr_values, false);
-- -1|'Ошибку: "повторяющееся значение ключа нарушает ограничение уникальности "ak1_nso_record_unique"" с кодом: "23505" необходимо добавить в таблицу по обработки ошибок для функции:  nso_p_record_u. 
--              Ошибка произошла в функции: "nso_p_record_u".'
--
-- SELECT * FROM nso.nso_p_record_u('bd59ac54-3946-4e9f-81bb-ac24733812e3', NULL, ARRAY[0::varchar,0::varchar,0::varchar,0::varchar,0::varchar,0::varchar,0::varchar,0::varchar,0::varchar]); 
-- 3612||'27b1a6a8-8c9b-4ade-8e65-65b567b012b1'
-- 3612||'27b1a6a8-8c9b-4ade-8e65-65b567b012b1'
-- 
-- SELECT * FROM v_cl_test;
-- UPDATE nso.v_cl_test SET cl_test_fc_code_1 = 'ВИННИ-ПУХИ ДУРАКИ' WHERE ( rec_id = 4)
-- ---------------------------
-- Как будет работать ссылка ?
-- SELECT * FROM nso.nso_f_column_head_nso_s('SPR_DIVISION');
-- SELECT * FROM nso.nso_p_view_c( 'SPR_DIVISION', FALSE );
-- SELECT * FROM nso.v_spr_division;
-- --------------------------------------------------------------------------------------------
-- INSERT INTO nso.v_spr_division ( spr_division_fc_code_1, spr_division_fc_exn_2, rec_uuid ) 
-- VALUES  ('Центр информационных ресурсов', '39F15BD7-7023-4CCA-8688-14FAA376F5F3', newid() );
-- --------------------------------------------------------------------------------------------
-- UPDATE nso.v_spr_division SET spr_division_fc_exn_2 = 'E6D06F44-E428-461C-A21A-2B7EDA986233'
--    WHERE ( rec_id = 3613 );
--
-- SELECT * FROM nso.v_spr_division;
-- ---------------------------------------------------------------------------------------------------------- 
-- SELECT * FROM nso.nso_p_column_head_i ( 'CL_TEST', 'D_CL_TEST', 'FC_NAME', 2::small_t, TRUE, NULL, TRUE) ;
-- `
-- SELECT * FROM com.all_v_event_log WHERE id_log = 94 
-- SELECT * FROM nso_column_head_hist ORDER BY log_id DESC;
-- SELECT * FROM nso.nso_p_view_c( 'CL_TEST', FALSE );
-- SELECT * FROM v_cl_test;
-- DROP INDEX ak1_nso_column_head_hist;
-- UPDATE nso.v_cl_test SET cl_test_fc_name_2 = '-----'
-- SELECT * FROM v_cl_test;
-- UPDATE nso.v_cl_test SET cl_test_fc_code_1 = '+++++'                             
-- SELECT * FROM v_cl_test;
-- SELECT * FROM nso.nso_f_column_head_nso_s('CL_TEST');
-- SELECT * FROM nso.nso_p_view_c('SPR_OBJECT_STATUS', false, 'nso');
-- SELECT * FROM nso.nso_p_view_c('CL_TEST', false, 'nso');

-- SELECT * FROM nso.nso_p_view_c('CL_TEST', false, 'com');
