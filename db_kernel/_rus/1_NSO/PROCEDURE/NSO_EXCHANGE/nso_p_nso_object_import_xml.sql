-- ====================================================================================================================
-- Author: Gregory
-- Create date: 2016-01-07
-- Description:	Импорт нормативно-справочного объекта из XML
-- 2016-05-18 Nick Проблемы с _nso_root.
-- 2016-05-19  В входном XML-документе появился новый атрибут "impact"   t_code1 Gregory
-- 2016-05-22  В выходном XML-документе появились служебные атрибуты: узел, диапазон дат.
-- 2016_05_25  Petr выполнение импорта НСИ через УиО
-- 2016-08-01  Gregory добавлен nso.nso_object.unique_check
-- 2017_05_26  Gregory изменение вызова nso_p_column_head_u, изменение уникальности ak1_nso_column_head
-- 2017_05_28  Gregory отладочные сообщения cкрыты условием p_is_dbg DEFAULT com.f_debug_status()
-- --------------------------------------------------------------------------------------------------------------------
-- 2016-10-04  Nick  LEFT OUTER JOIN ONLY nso.nso_object cur -- 
--                   ON ( t.nso_code = cur.nso_code OR t.nso_uuid = cur.nso_uuid );
--                         Тем самым допускается импорт несуществующего объекта.  
-- 2017-12-14  Nick закомментарен IF THEN ELSE - внутри котрого идут обпащения к схеме UIO
-- ====================================================================================================================
/* --------------------------------------------------------------------------------------------------------------------
Входные параметры:
    1) p_file    public.t_filename   -- t_sysname  -- Файл
    2) p_is_dbg  public.t_boolean    -- Переменная для управления режимом отладки
    3) p_xml     public.t_text       -- содержание <body>...</body>
  Выходные параметры:
    1) _result          result_t                -- Пользовательский тип для индикации успешности выполнения
    1.1) _result.rc     bigint                  -- 0 (при успехе) / -1 (при ошибке)
    1.2) _result.errm   character varying(2048) -- Сообщение
-------------------------------------------------------------------------------------------------------------------- 
*/
SET search_path = nso, public;

DROP FUNCTION IF EXISTS nso.nso_p_nso_object_import_xml ( public.t_filename );
DROP FUNCTION IF EXISTS nso.nso_p_nso_object_import_xml ( public.t_filename,public.t_boolean,public.t_text );

CREATE OR REPLACE FUNCTION nso.nso_p_nso_object_import_xml
(
     p_file    public.t_filename                -- Файл  
    ,p_is_dbg  public.t_boolean  DEFAULT FALSE  -- Переменная для управления режимом отладки:  FALSE нет отладки
    ,p_xml     public.t_text     DEFAULT NULL   -- содержание <body>...</body> DEFAULT NULL
)
RETURNS result_t AS 
$$
DECLARE
        _root_code       t_str60;
        --
        _head            t_boolean;     -- 2016-06-22 Gregory
        _data            t_boolean;
        _date_from       t_timestamp;
        _date_to         t_timestamp;   -- 2016-05-22 Gregory
        --
        _execute         t_text;
        _current         record;
        _result          result_t;
	     с_ERR_FUNC_NAME  t_sysname = 'nso_p_nso_object_import_xml';

BEGIN
        DROP TABLE IF EXISTS _tbl_xml;
        CREATE TEMPORARY TABLE _tbl_xml (
                id serial
               ,data xml_t
        )
        ON COMMIT DROP;
--        _execute = 'COPY _tbl_xml(data) FROM ''' || p_file || ''' ENCODING ''UTF8''';
--        RAISE NOTICE '%', _execute;
--        EXECUTE _execute;

-- INFO  Gregory 2016-05-22
        -- Читаем XML файл во временную таблицу  добавлено Petr 2016-05-25
        IF ( p_xml IS NULL ) THEN 
           -- прочитать из файла
           _execute = 'COPY _tbl_xml(data) FROM ''' || p_file || ''' ENCODING ''UTF8''';
           IF p_is_dbg THEN
              RAISE NOTICE '%', _execute;
           END IF;
           EXECUTE _execute;
        ELSE
          INSERT 	INTO _tbl_xml(data) VALUES (p_xml::xml);
        END  IF;

        SELECT 
                NULLIF(nso_code, NULL)::t_str60
               ,NULLIF(head, NULL)::t_boolean
               ,NULLIF(data, NULL)::t_boolean
               ,NULLIF(date_from, NULL)::t_timestamp
               ,NULLIF(date_to, NULL)::t_timestamp
        INTO
                _root_code
               ,_head
               ,_data
               ,_date_from
               ,_date_to
        FROM xpath_table (
                'id'
               ,'data'
               ,'_tbl_xml'
               ,'info/nso_code'
                        || '|info/head'
                        || '|info/data'
                        || '|info/date_from'
                        || '|info/date_to'
               ,'1 = 1'
        )
        AS t (
                id integer
               ,nso_code t_str60
               ,head t_boolean
               ,data t_boolean
               ,date_from t_timestamp
               ,date_to t_timestamp
        );
-- NSO_OBJECT Gregory 2016-05-22

        DROP TABLE IF EXISTS _tbl_nso_object;
        CREATE TEMPORARY TABLE _tbl_nso_object (               
                parent_nso_code t_str60
               ,nso_type_code t_str60
               ,nso_code t_str60
               ,nso_name t_str250
               ,nso_uuid t_guid
               ,is_group_nso t_boolean
               ,date_from t_timestamp
               ,date_to t_timestamp
               ,is_intra_op t_boolean
               ,unique_check t_boolean -- 2016-08-01 Gregory
               ,impact t_code1
               ,unique_is_on t_boolean -- 2016-08-01 Gregory
        )
        ON COMMIT DROP;

        INSERT INTO _tbl_nso_object (
                parent_nso_code
               ,nso_type_code
               ,nso_code
               ,nso_name
               ,nso_uuid
               ,is_group_nso
               ,date_from
               ,date_to
               ,is_intra_op
               ,unique_check
               ,impact
               ,unique_is_on
        )
        SELECT
                NULLIF(t.parent_nso_code, '')::t_str60
               ,NULLIF(t.nso_type_code, '')::t_str60
               ,NULLIF(t.nso_code, '')::t_str60
               ,NULLIF(t.nso_name, '')::t_str250
               ,NULLIF(t.nso_uuid, NULL)::t_guid
               ,NULLIF(t.is_group_nso, NULL)::t_boolean
               ,NULLIF(t.date_from, NULL)::t_timestamp
               ,NULLIF(t.date_to, NULL)::t_timestamp
               ,NULLIF(t.is_intra_op, NULL)::t_boolean
               ,NULLIF(t.unique_check, NULL)::t_boolean -- 2016-08-01 Gregory
               ,NULLIF(t.impact, NULL)::t_code1
               ,cur.unique_check
        FROM xpath_table (
                'id'
               ,'data'
               ,'_tbl_xml'
               ,'objects/row/parent_nso_code'
                        || '|objects/row/nso_type_code'
                        || '|objects/row/nso_code'
                        || '|objects/row/nso_name'
                        || '|objects/row/nso_uuid'
                        || '|objects/row/is_group_nso'
                        || '|objects/row/date_from'
                        || '|objects/row/date_to'
                        || '|objects/row/is_intra_op'
                        || '|objects/row/unique_check'
                        || '|objects/row/impact'
               ,'1 = 1'
        )
        AS t (
                id integer
               ,parent_nso_code t_str60
               ,nso_type_code t_str60
               ,nso_code t_str60
               ,nso_name t_str250
               ,nso_uuid t_guid
               ,is_group_nso t_boolean
               ,date_from t_timestamp
               ,date_to t_timestamp
               ,is_intra_op t_boolean
               ,unique_check t_boolean -- 2016-08-01 Gregory
               ,impact t_code1
        )
         LEFT OUTER JOIN ONLY nso.nso_object cur -- Nick 2016-10-04
        ON ( t.nso_code = cur.nso_code OR t.nso_uuid = cur.nso_uuid );

        -- 2016-05-18 Nick ------------------------------------------------------------------
        IF p_is_dbg THEN
           RAISE NOTICE 'Qty of _tbl_nso_object = "%" ', (SELECT count(*) FROM _tbl_nso_object);
        END IF;
        -- Qty of _tbl_nso_object = "0"   Что очень странно, таблица-то пустая.

        -- SELECT nso_code INTO _root_code FROM _tbl_nso_object WHERE (parent_nso_code IS NULL);
        IF ( _root_code is null ) then
              _root_code := 'NSO_ROOT'; -- Nick 2016-05-18
        end if;

        IF p_is_dbg THEN
              RAISE NOTICE 'Импорт ветви нормативно-справочного объекта "%" из XML.', _root_code;
        END IF;
        PERFORM nso.nso_p_nso_log_i ('Z', 'Импорт НСО "' || _root_code || '" из XML.'); -- Nick 2016-05-16
        -- 2016-05-18 Nick ------------------------------------------------------------------------------
        
        FOR _current IN --SELECT * FROM _tbl_nso_object
        WITH RECURSIVE t AS (
                (SELECT DISTINCT ON(nso_code)
                        parent_nso_code
                       ,nso_type_code
                       ,nso_code
                       ,nso_name
                       ,nso_uuid
                       ,is_group_nso
                       ,date_from
                       ,date_to
                       ,is_intra_op
                       ,impact
                       ,unique_is_on
                FROM _tbl_nso_object
                WHERE parent_nso_code IS NULL -- WHERE nso_code = _root_code
                ORDER BY nso_code, date_from DESC, date_to DESC)
        
                UNION
        
                (SELECT DISTINCT ON(o.nso_code)
                        o.parent_nso_code
                       ,o.nso_type_code
                       ,o.nso_code
                       ,o.nso_name
                       ,o.nso_uuid
                       ,o.is_group_nso
                       ,o.date_from
                       ,o.date_to
                       ,o.is_intra_op
                       ,o.impact
                       ,o.unique_is_on
                FROM _tbl_nso_object o, t
                WHERE
                        o.parent_nso_code = t.nso_code
                     OR o.nso_code = t.parent_nso_code
                ORDER BY o.nso_code, o.date_from DESC, o.date_to DESC)
        )
        SELECT
                parent_nso_code
               ,nso_type_code
               ,nso_code
               ,nso_name
               ,nso_uuid
               ,is_group_nso
               ,date_from
               ,date_to
               ,is_intra_op
               ,impact
               ,unique_is_on
        FROM t

        LOOP
                IF EXISTS (
                        SELECT 1
                        FROM ONLY nso.nso_object
                        WHERE
                                nso_code = _current.nso_code
                             OR nso_uuid = _current.nso_uuid
                        LIMIT 1
                )
                THEN
                        IF _current.unique_is_on IS TRUE
                        THEN
                                _result = nso.nso_p_object_unique_check_on (
                                        _current.nso_code
                                       ,FALSE
                                );
                                IF p_is_dbg THEN
                                        RAISE NOTICE '% - %', _current.nso_code, _result.errm;
                                END IF;
                        END IF;
                                
                        IF _current.impact IN ('T','R')
                        THEN
                                IF p_is_dbg THEN
                                        RAISE NOTICE 'CHECK % (%)', _current.nso_code, _current.impact;
                                END IF;
                        ELSIF _current.impact = 'D'
                        THEN
-- "Ошибку: "UPDATE или DELETE в таблице "nso_record"
-- нарушает ограничение внешнего ключа "fk_nso_record_defines_main_route_file_mrf_module_id"
-- таблицы "main_route_file"" с кодом: "23503" необходимо добавить в таблицу по обработки ошибок для функции:  nso_p_ob (...)"
                                --  
                                NULL; -- Nick 2017-12-14
                                --
                                -- IF EXISTS (
                                --         SELECT 1
                                --         FROM ONLY nso.nso_object no
                                --         JOIN ONLY nso.nso_record nr
                                --         USING(nso_id)
                                --         JOIN uio.main_route_file mrf
                                --         ON mrf.mrf_module_id = nr.rec_id
                                --         WHERE
                                --                 no.nso_code = _current.nso_code
                                --              OR no.nso_uuid = _current.nso_uuid
                                --         LIMIT 1
                                -- )
                                -- THEN
                                --         IF p_is_dbg THEN
                                --         RAISE NOTICE 'DECLINE DELETE % (%)', _current.nso_code, _current.impact;
                                --         END IF;
                                -- ELSE
                                --         IF p_is_dbg THEN
                                --                 RAISE NOTICE 'DELETE % (%)', _current.nso_code, _current.impact;
                                --         END IF;
                                --                 _result = nso.nso_p_object_d (
                                --                         _current.nso_code
                                --                        ,_current.is_group_nso
                                --                 );
                                -- END IF;
                                --
                                -- Nick 2017-12-14
                        ELSE
                                IF p_is_dbg THEN
                                        RAISE NOTICE 'UPDATE % (%)', _current.nso_code, _current.impact;
                                END IF;
                                _result = nso.nso_p_object_u (
                                        (
                                                SELECT nso_code
                                                FROM ONLY nso.nso_object
                                                WHERE
                                                        nso_code = _current.nso_code
                                                     OR nso_uuid = _current.nso_uuid
                                                LIMIT 1
                                        )
                                       ,_current.parent_nso_code
                                       ,_current.nso_type_code
                                       ,_current.nso_uuid
                                       ,_current.is_intra_op
                                       ,_current.nso_code
                                       ,_current.nso_name
                                       ,_current.date_from
                                       ,_current.date_to
                                );
                        END IF;
                ELSE
                        IF _current.impact = 'D'
                        THEN
                                IF p_is_dbg THEN 
                                RAISE NOTICE 'PASS % (%)', _current.nso_code, _current.impact;
                                END IF;
                        ELSE
                                IF p_is_dbg THEN
                                        RAISE NOTICE 'INSERT % (%)', _current.nso_code, _current.impact;
                                END IF;
                                _result = nso.nso_p_object_i (
                                        _current.parent_nso_code
                                       ,_current.nso_type_code
                                       ,_current.nso_code
                                       ,_current.nso_name
                                       ,_current.nso_uuid
                                       ,_current.is_group_nso
                                       ,_current.date_from
                                       ,_current.date_to
                                );
                        END IF;
                END IF;
                
                IF _result.rc < 0
                THEN
                        RAISE EXCEPTION '%', _result.errm;
                END IF;
        END LOOP;

-- NSO_COLUMN_HEAD

        DROP TABLE IF EXISTS _tbl_nso_column_head;
        CREATE TEMPORARY TABLE _tbl_nso_column_head (
                nso_code t_str60
               ,parent_col_code t_str60
               ,attr_code t_str60
               ,number_col small_t
               ,mandatory t_boolean
               ,act_name t_str250
               ,final_sw t_boolean
               ,act_code t_str60
               ,impact t_code1
        )
        ON COMMIT DROP;

        INSERT INTO _tbl_nso_column_head (
                nso_code
               ,parent_col_code
               ,attr_code
               ,number_col
               ,mandatory
               ,act_name
               ,final_sw
               ,act_code
               ,impact
        )
        SELECT
                NULLIF(nso_code, '')::t_str60
               ,NULLIF(parent_col_code, '')::t_str60
               ,NULLIF(attr_code, '')::t_str60
               ,NULLIF(number_col, NULL)::small_t
               ,NULLIF(mandatory, NULL)::t_boolean
               ,NULLIF(act_name, '')::t_str250
               ,NULLIF(final_sw, NULL)::t_boolean
               ,NULLIF(act_code, '')::t_str60
               ,NULLIF(impact, '')::t_code1
        FROM xpath_table (
                'id'
               ,'data'
               ,'_tbl_xml'
               ,'columns/row/nso_code'
                        || '|columns/row/parent_col_code'
                        || '|columns/row/attr_code'
                        || '|columns/row/number_col'
                        || '|columns/row/mandatory'
                        || '|columns/row/act_name'
                        || '|columns/row/final_sw'
                        || '|columns/row/act_code'
                        || '|columns/row/impact'
               ,'1 = 1'
        )
        AS t (
                id integer
               ,nso_code t_str60
               ,parent_col_code t_str60
               ,attr_code t_str60
               ,number_col small_t
               ,mandatory t_boolean
               ,act_name t_str250
               ,final_sw t_boolean
               ,act_code t_str60
               ,impact t_code1
        );

        FOR _current IN
                SELECT *
                FROM _tbl_nso_column_head
                ORDER BY
                        nso_code
                       ,number_col
        LOOP
                IF EXISTS (
                        SELECT 1
                        FROM ONLY nso.nso_column_head
                        JOIN ONLY nso.nso_object
                        USING(nso_id)
                        WHERE col_code = _current.act_code
                            AND nso_code = _current.nso_code -- 2017_05_26 Gregory
                        LIMIT 1
                )
                THEN
                        IF _current.impact = 'D'
                        THEN
                                IF p_is_dbg THEN
                                RAISE NOTICE 'FAKE DELETE % (%)', _current.act_code, _current.impact;
                                END IF;
                                /*_result = nso.nso_p_column_head_d (
                                        _current.nso_code
                                       ,_current.number_col
                                );*/
-- "Невозможно удалить запись из таблицы nso_column_head, т.к. значение из колонки col_id "ИДЕНТИФИКАТОР КОЛОНКИ"
-- уже связано со значением в колонке parent_col_id "ИДЕНТИФИКАТОР РОДИТЕЛЬСКОЙ КОЛОНКИ" таблицы nso_column_head.
-- Ошибка произошла в функции: "nso_p_ (...)"
                        ELSE
                                IF p_is_dbg THEN
                                        RAISE NOTICE 'UPDATE % (%)', _current.act_code, _current.impact;
                                END IF;
                                _result =  nso.nso_p_column_head_u (
                                        (
                                                SELECT col_id
                                                FROM ONLY nso.nso_column_head
                                                JOIN ONLY nso.nso_object
                                                USING(nso_id)
                                                WHERE col_code = _current.act_code
                                                    AND nso_code = _current.nso_code -- 2017_05_26 Gregory
                                        )
                                       ,( -- 2017_05_26 Gregory
                                                SELECT attr_id
                                                FROM ONLY com.nso_domain_column
                                                WHERE attr_code = _current.attr_code
                                        )
                                       ,_current.act_code
                                       ,_current.act_name
                                       ,_current.number_col
                                );
                        END IF;
                ELSE
                        IF _current.impact = 'D'
                        THEN
                                IF p_is_dbg THEN 
                                RAISE NOTICE 'PASS % (%)', _current.act_code, _current.impact;
                                END IF;
                        ELSE
                                IF p_is_dbg THEN
                                        RAISE NOTICE 'INSERT % (%)', _current.act_code, _current.impact;
                                END IF;
                                _result = nso.nso_p_column_head_i (
                                        _current.nso_code
                                       ,_current.parent_col_code
                                       ,_current.attr_code
                                       ,_current.number_col
                                       ,_current.mandatory
                                       ,_current.act_name
                                       ,_current.final_sw
                                       ,_current.act_code
                                );
                        END IF;
                END IF;

                IF _result.rc < 0
                THEN
                        RAISE EXCEPTION '%', _result.errm;
                END IF;
        END LOOP;

-- NSO_KEY

        DROP TABLE IF EXISTS _tbl_nso_key;
        CREATE TEMPORARY TABLE _tbl_nso_key (
                key_code t_str60
               ,nso_code t_str60
               ,key_type_code t_str60
               ,attr_codes t_arr_code
               ,on_off t_boolean
               ,date_from t_timestamp
               ,date_to t_timestamp
               ,impact t_code1
        )
        ON COMMIT DROP;

        INSERT INTO _tbl_nso_key (
                key_code
               ,nso_code
               ,key_type_code
               ,attr_codes
               ,on_off
               ,date_from
               ,date_to
               ,impact
        )
        SELECT
                NULLIF(key_code, '')::t_str60
               ,NULLIF(nso_code, '')::t_str60
               ,NULLIF(key_type_code, '')::t_str60
               ,NULLIF(attr_codes, NULL)::t_arr_code
               ,NULLIF(on_off, NULL)::t_boolean
               ,NULLIF(date_from, NULL)::t_timestamp
               ,NULLIF(date_to, NULL)::t_timestamp
               ,NULLIF(impact, NULL)::t_code1
        FROM xpath_table (
                'id'
               ,'data'
               ,'_tbl_xml'
               ,'keys/row/key_code'
                        || '|keys/row/nso_code'
                        || '|keys/row/key_type_code'
                        || '|keys/row/attr_codes'
                        || '|keys/row/on_off'
                        || '|keys/row/date_from'
                        || '|keys/row/date_to'
                        || '|keys/row/impact'
               ,'1 = 1'
        )
        AS t (
                id integer
               ,key_code t_str60
               ,nso_code t_str60
               ,key_type_code t_str60
               ,attr_codes t_arr_code
               ,on_off t_boolean
               ,date_from t_timestamp
               ,date_to t_timestamp
               ,impact t_code1
        );

        FOR _current IN
                SELECT *
                FROM _tbl_nso_key
        LOOP
                IF EXISTS (
                        SELECT 1
                        FROM ONLY nso.nso_key
                        WHERE key_code = _current.key_code
                        LIMIT 1
                )
                THEN
                        IF _current.impact = 'D'
                        THEN
                                IF p_is_dbg THEN
                                RAISE NOTICE 'DELETE % (%)', _current.key_code, _current.impact;
                                END IF;
                                _result = nso.nso_p_key_d (
                                        _current.key_code
                                );
                        ELSE
                                IF p_is_dbg THEN
                                        RAISE NOTICE 'UPDATE % (%)', _current.key_code, _current.impact;
                                END IF;
                                _result = nso.nso_p_key_u (
                                        _current.key_code
                                       ,_current.key_type_code
                                       ,_current.attr_codes
                                       ,_current.on_off
                                       ,_current.date_from
                                       ,_current.date_to
                                );
                        END IF;
                ELSE
                        IF _current.impact = 'D'
                        THEN 
                                IF p_is_dbg THEN 
                                RAISE NOTICE 'PASS % (%)', _current.key_code, _current.impact;
                                END IF;
                        ELSE
                                IF p_is_dbg THEN
                                        RAISE NOTICE 'INSERT % (%)', _current.key_code, _current.impact;
                                END IF;
                                _result = nso.nso_p_key_i (
                                        _current.nso_code
                                       ,_current.key_type_code
                                       ,_current.attr_codes
                                       ,_current.on_off
                                       ,_current.date_from
                                       ,_current.date_to
                                );
                        END IF;
                END IF;

                IF _result.rc < 0
                THEN
                        RAISE EXCEPTION '%', _result.errm;
                END IF;
        END LOOP;

-- NSO_RECORD

        DROP TABLE IF EXISTS _tbl_nso_record;
        CREATE TEMPORARY TABLE _tbl_nso_record (
                rec_order longint_t
               ,rec_uuid t_guid
               ,parent_rec_uuid t_guid
               ,nso_code t_str60
               ,mas_val t_arr_values 
               ,actual t_boolean
               ,date_from t_timestamp
               ,date_to t_timestamp
               ,impact t_code1
        )
        ON COMMIT DROP;

        INSERT INTO _tbl_nso_record (
                rec_order
               ,rec_uuid
               ,parent_rec_uuid
               ,nso_code
               ,mas_val 
               ,actual
               ,date_from
               ,date_to
               ,impact
        )
        SELECT
                NULLIF(rec_order, NULL)::longint_t
               ,NULLIF(rec_uuid, NULL)::t_guid
               ,(CASE WHEN parent_rec_uuid = '' THEN NULL ELSE parent_rec_uuid END)::t_guid
               ,NULLIF(nso_code, '')::t_str60
               ,NULLIF(mas_val, NULL)::t_arr_values
               ,NULLIF(actual, NULL)::t_boolean
               ,NULLIF(date_from, NULL)::t_timestamp
               ,NULLIF(date_to, NULL)::t_timestamp
               ,NULLIF(impact, NULL)::t_code1
        FROM xpath_table (
                'id'
               ,'data'
               ,'_tbl_xml'
               ,'records/row/rec_order'
                        || '|records/row/rec_uuid'
                        || '|records/row/parent_rec_uuid'
                        || '|records/row/nso_code'
                        || '|records/row/mas_val'
                        || '|records/row/actual'
                        || '|records/row/date_from'
                        || '|records/row/date_to'
                        || '|records/row/impact'
               ,'1 = 1'
        )
        AS t (
                id integer
               ,rec_order longint_t
               ,rec_uuid t_guid
               ,parent_rec_uuid t_str60 -- t_guid
               ,nso_code t_str60
               ,mas_val t_text
               ,actual t_boolean
               ,date_from t_timestamp
               ,date_to t_timestamp
               ,impact t_code1
        );

        FOR _current IN
                SELECT *
                FROM _tbl_nso_record
                ORDER BY rec_order DESC
        LOOP
                IF EXISTS (
                        SELECT 1
                        FROM ONLY nso.nso_record
                        WHERE rec_uuid = _current.rec_uuid
                        LIMIT 1
                )
                THEN
                        IF _current.impact = 'X'
                        THEN
                                IF p_is_dbg THEN
                                        RAISE NOTICE 'CHECK % % (%)', _current.rec_uuid, _current.nso_code, _current.impact;
                                END IF;
                        ELSIF _current.impact = 'D'
                        THEN
                                IF p_is_dbg THEN
                                RAISE NOTICE 'FAKE DELETE % % (%)', _current.rec_uuid, _current.nso_code, _current.impact;
                                END IF;
                                /*_result = nso.nso_p_record_d (
                                        _current.rec_uuid
                                );*/
-- Невозможно удалить запись из таблицы nso_record, т.к. значение из колонки rec_id "ИДЕНТИФИКАТОР  ЗАПИСИ"
-- уже связано со значением в колонке rmc_module_id "ИДЕНТИФИКАТОР МОДУЛЯ" таблицы route_module_config.
-- Ошибка произошла в функции: "nso_p_record_d".
                        ELSE
                                IF p_is_dbg THEN
                                        RAISE NOTICE 'UPDATE % % (%)', _current.rec_uuid, _current.nso_code, _current.impact;
                                END IF;
                                _result = nso.nso_p_record_u (
                                        _current.rec_uuid
                                       ,_current.parent_rec_uuid
                                       ,_current.mas_val
                                       ,true --silent_mode
                                       ,_current.actual
                                       ,_current.date_from
                                       ,_current.date_to
                                );
                        END IF;
                ELSE
                        IF _current.impact = 'D'
                        THEN
                                IF p_is_dbg THEN 
                                RAISE NOTICE 'PASS % % (%)', _current.rec_uuid, _current.nso_code, _current.impact;
                                END IF;
                        ELSE
                                IF p_is_dbg THEN
                                        RAISE NOTICE 'INSERT % % (%)', _current.rec_uuid, _current.nso_code, _current.impact;
                                END IF;
                                _result = nso.nso_p_record_i (
                                        _current.rec_uuid
                                       ,_current.parent_rec_uuid
                                       ,_current.nso_code
                                       ,_current.mas_val
                                       ,true --silent_mode
                                       ,_current.actual
                                       ,_current.date_from
                                       ,_current.date_to
                                );
                        END IF;
                END IF;

                IF _result.rc < 0
                THEN
                        --RAISE EXCEPTION '%', _result.errm;
                        RAISE NOTICE '%', _result.errm;
                END IF;
        END LOOP;

        FOR _current IN
                SELECT
                        nso_code
                       ,unique_check
                FROM _tbl_nso_object
                WHERE unique_check IS TRUE
        LOOP
                _result = nso.nso_p_object_unique_check_on (
                        _current.nso_code
                       ,TRUE
                );
                IF p_is_dbg THEN
                        RAISE NOTICE '% - %', _current.nso_code, _result.errm;
                END IF;
        END LOOP;

        _result := (0, p_file);
	RETURN _result;
EXCEPTION
        WHEN OTHERS THEN 
                BEGIN
                        _result := (-1, com.f_error_handling(SQLSTATE, SQLERRM, с_ERR_FUNC_NAME));
                        RETURN _result;			
   		END;
END;
$$
LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION nso.nso_p_nso_object_import_xml (public.t_filename, public.t_boolean, public.t_text)
IS '7828/600: Импорт нормативно-справочного объекта из XML.

  Входные параметры:
    1) p_file    public.t_filename   -- Файл. Обязательное для заполнения 
    2) p_is_dbg  public.t_boolean    -- Переменная для управления режимом отладки: FALSE  - нет отладки
    3) p_xml     public.t_text       -- содержание <body>...</body>. Обязательное для заполнения, допускается NULL
  Выходные параметры:
    1) _result          result_t                -- Пользовательский тип для индикации успешности выполнения
    1.1) _result.rc     bigint                  -- 0 (при успехе) / -1 (при ошибке)
    1.2) _result.errm   character varying(2048) -- Сообщение
';

-- SELECT * FROM nso.nso_p_nso_object_import_xml('/tmp/nso_nso_object_NSO_IN_OUT_OBJECTS_h_2017-05-26-18-52-42.658074.xml', TRUE);
-- SELECT * FROM nso.nso_p_nso_object_import_xml('/tmp/nso_nso_object_NSO_IN_OUT_OBJECTS_h_2017-05-26-18-52-42.658074.xml');

-- SELECT * FROM nso.nso_p_nso_object_import_xml('/tmp/nso_nso_object_SPR_PTK_hd_2017-03-24-15-02-15.xml');
-- SELECT * FROM nso.nso_f_column_head_nso_s('SPR_PTK');

-- SELECT * FROM nso.nso_p_nso_object_import_xml('/tmp/nso_nso_object_SPR_QUERY_hd_2016-10-06-07-24-12.401262.xml');
-- SELECT * FROM nso.nso_p_object_unique_check_on('KL_SECR', false);
-- SELECT * FROM nso.v_kl_secr
-- SELECT * FROM nso.nso_p_view_c('SPR_QUERY', false, 'etl');
-- SELECT DISTINCT * FROM nso.v_SPR_QUERY ORDER BY 4; -- 944 
-- 'Роль отсутствует. Ошибка произошла в функции: "nso_p_view_c (t_str60, boolean_t, sysname_t)".'
-- UPDATE v_kl_secr SET kl_secr_fc_code_2 = 'СС' WHERE rec_id = 32
-- SELECT * FROM nso.nso_p_object_unique_check_on('KL_SECR', true);
-- -1;"Ошибку: "повторяющееся значение ключа нарушает ограничение уникальности "ak1_nso_record_unique"" с кодом: "23505" необходимо добавить в таблицу по обработки ошибок для функции:  nso_p_object_unique_check_on. Ошибка произошла в функции: "nso_p_object_unique (...)"
-- SELECT * FROM nso.nso_p_nso_object_import_xml('/tmp/nso_nso_object_KL_SECR_hd_2016-08-02-00-01-40.xml');
-- 0;"/tmp/nso_nso_object_KL_SECR_hd_2016-08-02-00-01-40.xml"
-- KL_SECR - Контроль уникальности Активен.
-- KL_SECR - Ошибку: "повторяющееся значение ключа нарушает ограничение уникальности "ak1_nso_record_unique"" с кодом: "23505" необходимо добавить в таблицу по обработки ошибок для функции:  nso_p_object_unique_check_on. Ошибка произошла в функции: "nso_p_object_unique_check_on".

-- SELECT * FROM nso.nso_f_nso_object_export_xml('SPR_POSITION', TRUE, '/tmp', TRUE, TRUE, now()::t_timestamp, now()::t_timestamp);
-- SELECT * FROM nso.nso_p_nso_object_import_xml('/tmp/nso_nso_object_SPR_POSITION_hd_2016-05-19-01-01-59.xml');

-- SELECT * FROM nso.nso_f_nso_object_export_xml('NSO_ROOT', TRUE, '/tmp', TRUE, TRUE, '2016-02-11 00:00:00', now()::t_timestamp);
-- SELECT * FROM nso.nso_p_nso_object_import_xml('/tmp/nso_nso_object_NSO_ROOT_hd_2016-05-24-23-08-41.xml', true);
-- "Ошибку: "UPDATE или DELETE в таблице "nso_record" нарушает ограничение внешнего ключа "fk_nso_record_defines_main_route_file_mrf_module_id" таблицы "main_route_file"" с кодом: "23503" необходимо добавить в таблицу по обработки ошибок для функции:  nso_p_ob (...)"

-- SELECT * FROM nso.nso_p_nso_object_import_xml('/tmp/nso/nso_nso_object_SPR_POSITION_d_2016-05-18-14-42-29.xml'); 
-- SELECT * FROM _tbl_nso_object;

-- SELECT * FROM nso.nso_p_nso_object_import_xml('/tmp/nso_nso_object_SPR_EMPLOYE_hd_2016-01-20-23-10-21.xml');
-- SELECT * FROM nso.nso_p_nso_object_import_xml('/tmp/nso_nso_object_NSO_ROOT_hd_2016-01-20-23-22-46.xml');

-- SELECT * FROM nso.nso_p_nso_object_import_xml('/xml_data/nso_nso_object_CL_LOCAL_2016-02-16-00-49-57.xml');
-- SELECT * FROM nso.nso_p_nso_object_import_xml('/tmp/nso_nso_object_CL_LOCAL_2016-02-16-00-50-51.xml');

-- SELECT * FROM _tbl_xml
-- SELECT DISTINCT ON(nso_code) * FROM _tbl_nso_object ORDER BY nso_code
-- SELECT * FROM _tbl_nso_column_head
-- SELECT * FROM _tbl_nso_key

/* SELECT * FROM nso.nso_p_object_i (
        'CL_LOCAL'
       ,'C_NSO_CLASS'
       ,'CL_TEST_NEW'
       ,'Новый тестовый классификатор'
       ,'57f81f10-3aa4-4b08-a028-7a595cf8b8c1'
       ,'false'
       ,'2015-11-09T16:58:31'
       ,'2015-11-09T16:58:31'
)*/

-- SELECT * FROM ONLY nso.nso_object WHERE nso_uuid = '57f81f10-3aa4-4b08-a028-7a595cf8b8c1'
-- SELECT * FROM com.obj_errors WHERE message_out ILIKE '%неверный тип нсо%'
-- SELECT c.codif_id FROM ONLY com.obj_codifier c WHERE btrim (c.codif_code) = 'C_RSK_IMPCT'
-- SELECT * FROM com.com_p_obj_codifier_import_xml('/tmp/com_obj_codifier_C_CODIF_ROOT_2016-01-21-00-17-07.xml')
-- "Ошибку: "новая строка в отношении "com_log" нарушает ограничение-проверку "chk_com_log_impact_type"" с кодом: "23514" необходимо добавить в таблицу по обработки ошибок для функции:  com_p_obj_codifier_import_xml. Ошибка произошла в функции: "com_p_obj_codi (...)"
/*ALTER TABLE com.com_log
  DROP CONSTRAINT chk_com_log_impact_type;
ALTER TABLE com.com_log   
  ADD CONSTRAINT chk_com_log_impact_type 
            CHECK ( 
                       impact_type = '0' -- создание записи в кодификаторе
                    OR impact_type = '1' -- удаление записи в кодификаторе
                    OR impact_type = '2' -- обновление данных в кодификаторе
                    ---------------------------------------------------------- 
                    OR impact_type = '3' -- создание атрибута в домене.
                    OR impact_type = '4' -- удаление атрибута из домена 
                    OR impact_type = '5' -- обновление атрибута в домене .
                    ---------------------------------------------------------- 
                    OR impact_type = '6' -- создание  объекта
                    OR impact_type = '7' -- обновление объекта
                    OR impact_type = '8' -- удаление объекта.
                    OR impact_type = '9' -- создание записи в конфигурации
                    ---------------------------------------------------------- 
                    OR impact_type = 'A' -- обновление записи в  конфигурации  2015-10-02  Nick
                    OR impact_type = 'B' -- удаление записи в конфигурации
                    OR impact_type = 'C' -- установка текущей конфигурации
                    ----------------------------------------------------------
                    OR impact_type = 'D' -- экспорт ветви кодивикатора в XML
                    OR impact_type = 'E' -- импорт ветви кодификатора из XML
);*/

-- INSERT D_CL_TEST
-- "Все параметры явялются обязательными, NULL значения запрещены. Ошибка произошла в функции: "nso_p_column_head_i".. Ошибка произошла в функции: "nso_p_nso_object_import_xml"."
-- SELECT * FROM ONLY com.nso_domain_column
-- SELECT * FROM ONLY nso.nso_column_head
-- SELECT 1 FROM ONLY nso.nso_column_head WHERE col_code = 'D_CL_TEST' LIMIT 1
