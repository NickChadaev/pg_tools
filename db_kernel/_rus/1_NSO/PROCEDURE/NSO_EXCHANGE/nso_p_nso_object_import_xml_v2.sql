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
-- 2017-06-22  Gregory перевод с xpath_table на xpath.
-- 2017-09-12  Nick переход под старое ядро.
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

DROP FUNCTION IF EXISTS nso.nso_p_nso_object_import_xml2 ( public.t_filename,public.t_boolean,public.t_text );
CREATE OR REPLACE FUNCTION nso.nso_p_nso_object_import_xml2
(
     p_file    public.t_filename                              -- Файл  
    ,p_is_dbg  public.t_boolean  DEFAULT FALSE -- Переменная для управления режимом отладки:  FALSE нет отладки
    ,p_xml     public.t_text     DEFAULT NULL                 -- содержание <body>...</body> DEFAULT NULL
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
        
	с_ERR_FUNC_NAME  t_sysname = 'nso_p_nso_object_import_xml2';

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

        /*INSERT INTO _tbl_nso_object (
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
        ON ( t.nso_code = cur.nso_code OR t.nso_uuid = cur.nso_uuid );*/

        WITH objrows AS (
                SELECT unnest(xpath('/body/objects/row', data))::text AS objxml
                FROM _tbl_xml
        )
       ,objraw AS (
                SELECT
                        xpath_string(objxml, '/row/parent_nso_code')  AS parent_nso_code
                       ,xpath_string(objxml, '/row/nso_type_code')    AS nso_type_code
                       ,xpath_string(objxml, '/row/nso_code')         AS nso_code
                       ,xpath_string(objxml, '/row/nso_name')         AS nso_name
                       ,xpath_string(objxml, '/row/nso_uuid')::t_guid AS nso_uuid
                       ,xpath_string(objxml, '/row/is_group_nso')     AS is_group_nso
                       ,xpath_string(objxml, '/row/date_from')        AS date_from
                       ,xpath_string(objxml, '/row/date_to')          AS date_to
                       ,xpath_string(objxml, '/row/is_intra_op')      AS is_intra_op
                       ,xpath_string(objxml, '/row/unique_check')     AS unique_check
                       ,xpath_string(objxml, '/row/impact')           AS impact
               FROM objrows
        )
        INSERT INTO _tbl_nso_object
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
               ,NULLIF(t.unique_check, NULL)::t_boolean
               ,NULLIF(t.impact, NULL)::t_code1
               ,cur.unique_check
        FROM objraw t
        LEFT OUTER JOIN ONLY nso.nso_object cur
        ON
                (t.nso_code = cur.nso_code) 
             OR (t.nso_uuid = cur.nso_uuid);

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
                                -- --
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
                                --                 RAISE NOTICE 'DECLINE DELETE % (%)', _current.nso_code, _current.impact;
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
                                -- -- Nick 2017-12-14
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

        /*INSERT INTO _tbl_nso_column_head (
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
        );*/

        WITH colrows AS (
                SELECT unnest(xpath('/body/columns/row', data))::text AS colxml
                FROM _tbl_xml
        )
       ,colraw AS (
                SELECT
                        xpath_string(colxml, '/row/nso_code')        AS nso_code
                       ,xpath_string(colxml, '/row/parent_col_code') AS parent_col_code
                       ,xpath_string(colxml, '/row/attr_code')       AS attr_code
                       ,xpath_string(colxml, '/row/number_col')      AS number_col
                       ,xpath_string(colxml, '/row/mandatory')       AS mandatory
                       ,xpath_string(colxml, '/row/act_name')        AS act_name
                       ,xpath_string(colxml, '/row/final_sw')        AS final_sw
                       ,xpath_string(colxml, '/row/act_code')        AS act_code
                       ,xpath_string(colxml, '/row/impact')          AS impact
               FROM colrows
        )
        INSERT INTO _tbl_nso_column_head
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
        FROM colraw;

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
                        WHERE
                                col_code = _current.act_code
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
                                                WHERE
                                                        col_code = _current.act_code
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

        /*INSERT INTO _tbl_nso_key (
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
        );*/

        WITH keyrows AS (
                SELECT unnest(xpath('/body/keys/row', data))::text AS keyxml
                FROM _tbl_xml
        )
       ,keyraw AS (
                SELECT
                        xpath_string(keyxml, '/row/key_code')      AS key_code
                       ,xpath_string(keyxml, '/row/nso_code')      AS nso_code
                       ,xpath_string(keyxml, '/row/key_type_code') AS key_type_code
                       ,xpath_string(keyxml, '/row/attr_codes')    AS attr_codes
                       ,xpath_string(keyxml, '/row/on_off')        AS on_off
                       ,xpath_string(keyxml, '/row/date_from')     AS date_from
                       ,xpath_string(keyxml, '/row/date_to')       AS date_to
                       ,xpath_string(keyxml, '/row/impact')        AS impact
               FROM keyrows
        )
        INSERT INTO _tbl_nso_key
        SELECT
                NULLIF(key_code, '')::t_str60
               ,NULLIF(nso_code, '')::t_str60
               ,NULLIF(key_type_code, '')::t_str60
               ,NULLIF(attr_codes, NULL)::t_arr_code
               ,NULLIF(on_off, NULL)::t_boolean
               ,NULLIF(date_from, NULL)::t_timestamp
               ,NULLIF(date_to, NULL)::t_timestamp
               ,NULLIF(impact, NULL)::t_code1
        FROM keyraw;

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

        /*INSERT INTO _tbl_nso_record (
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
        );*/

        WITH recrows AS (
                SELECT unnest(xpath('/body/records/row', data))::text AS rowxml
                FROM _tbl_xml
        )
       ,recraw AS (
                SELECT
                        xpath_string(rowxml, '/row/rec_order')       AS rec_order
                       ,xpath_string(rowxml, '/row/rec_uuid')        AS rec_uuid
                       ,xpath_string(rowxml, '/row/parent_rec_uuid') AS parent_rec_uuid
                       ,xpath_string(rowxml, '/row/nso_code')        AS nso_code
                       ,xpath_string(rowxml, '/row/mas_val')         AS mas_val
                       ,xpath_string(rowxml, '/row/actual')          AS actual
                       ,xpath_string(rowxml, '/row/date_from')       AS date_from
                       ,xpath_string(rowxml, '/row/date_to')         AS date_to
                       ,xpath_string(rowxml, '/row/impact')          AS impact
               FROM recrows
        )
        INSERT INTO _tbl_nso_record
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
        FROM recraw;

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

COMMENT ON FUNCTION nso.nso_p_nso_object_import_xml2 (public.t_filename, public.t_boolean, public.t_text)
IS '7828/600: Импорт нормативно-справочного объекта из XML. Метод XPATH.

  Входные параметры:
    1) p_file    public.t_filename   -- Файл. Обязательное для заполнения 
    2) p_is_dbg  public.t_boolean    -- Переменная для управления режимом отладки: FALSE  - нет отладки
    3) p_xml     public.t_text       -- содержание <body>...</body>. Обязательное для заполнения, допускается NULL
  Выходные параметры:
    1) _result          result_t                -- Пользовательский тип для индикации успешности выполнения
    1.1) _result.rc     bigint                  -- 0 (при успехе) / -1 (при ошибке)
    1.2) _result.errm   character varying(2048) -- Сообщение
';

-- SELECT * FROM nso.nso_p_nso_object_import_xml2('/tmp/nso_nso_object_SPR_RNTD_hd_2017-12-12-00-19-55.xml', TRUE);

-- SELECT * FROM _tbl_nso_record;
-- Суммарное время выполнения запроса: 5745 ms.
-- 53502 строки получено.

-- SELECT * FROM nso.nso_p_nso_object_import_xml2('/tmp/nso_nso_object_SPR_OKP_d_2017-06-01-04-36-39.296333.xml');
-- 0;'/tmp/nso_nso_object_SPR_OKP_d_2017-06-01-04-36-39.296333.xml'
-- Суммарное время выполнения запроса: 222306 ms. -- insert(first run), debug
-- Суммарное время выполнения запроса: 223445 ms. -- update(second run)
-- 1 строка получена.

-- SELECT * FROM nso.nso_p_nso_object_import_xml2('/tmp/nso_nso_object_SPR_OKP_h_2017-06-01-04-35-59.615329.xml', TRUE);

-- ЗАМЕЧАНИЕ:  таблица "_tbl_xml" не существует, пропускается
-- CONTEXT:  SQL-оператор: "DROP TABLE IF EXISTS _tbl_xml"
-- функция PL/pgSQL nso_p_nso_object_import_xml2(t_filename,t_boolean,t_text), строка 17, оператор SQL-оператор
-- ЗАМЕЧАНИЕ:  COPY _tbl_xml(data) FROM '/tmp/nso_nso_object_SPR_OKP_h_2017-06-01-04-35-59.615329.xml' ENCODING 'UTF8'
-- ЗАМЕЧАНИЕ:  таблица "_tbl_nso_object" не существует, пропускается
-- CONTEXT:  SQL-оператор: "DROP TABLE IF EXISTS _tbl_nso_object"
-- функция PL/pgSQL nso_p_nso_object_import_xml2(t_filename,t_boolean,t_text), строка 73, оператор SQL-оператор
-- ЗАМЕЧАНИЕ:  Qty of _tbl_nso_object = "3"
-- ЗАМЕЧАНИЕ:  Импорт ветви нормативно-справочного объекта "SPR_OKP" из XML.
-- ЗАМЕЧАНИЕ:  CHECK NSO_ROOT (T)
-- ЗАМЕЧАНИЕ:  CHECK NSO_IN_OUT_OBJECTS (T)
-- ЗАМЕЧАНИЕ:  INSERT SPR_OKP (I)
-- ЗАМЕЧАНИЕ:  таблица "_tbl_nso_column_head" не существует, пропускается
-- CONTEXT:  SQL-оператор: "DROP TABLE IF EXISTS _tbl_nso_column_head"
-- функция PL/pgSQL nso_p_nso_object_import_xml2(t_filename,t_boolean,t_text), строка 330, оператор SQL-оператор
-- ЗАМЕЧАНИЕ:  UPDATE D_SPR_OKP (I)
-- ЗАМЕЧАНИЕ:  INSERT CODE (I)
-- ЗАМЕЧАНИЕ:  INSERT SHORT_NAME (I)
-- ЗАМЕЧАНИЕ:  INSERT KC (I)
-- ЗАМЕЧАНИЕ:  INSERT FULL_NAME (I)
-- ЗАМЕЧАНИЕ:  INSERT DT_MODIF (I)
-- ЗАМЕЧАНИЕ:  таблица "_tbl_nso_key" не существует, пропускается
-- CONTEXT:  SQL-оператор: "DROP TABLE IF EXISTS _tbl_nso_key"
-- функция PL/pgSQL nso_p_nso_object_import_xml2(t_filename,t_boolean,t_text), строка 478, оператор SQL-оператор
-- ЗАМЕЧАНИЕ:  INSERT K_SPR_OKP_AKKEY1 (I)
-- ЗАМЕЧАНИЕ:  INSERT K_SPR_OKP_DEFKEY (I)
-- ЗАМЕЧАНИЕ:  таблица "_tbl_nso_record" не существует, пропускается
-- CONTEXT:  SQL-оператор: "DROP TABLE IF EXISTS _tbl_nso_record"
-- функция PL/pgSQL nso_p_nso_object_import_xml2(t_filename,t_boolean,t_text), строка 597, оператор SQL-оператор
-- ЗАМЕЧАНИЕ:  Контроль уникальности Активен. SPR_OKP. ОКП
-- CONTEXT:  функция PL/pgSQL nso_p_nso_object_import_xml2(t_filename,t_boolean,t_text), строка 739, оператор присваивание
-- ЗАМЕЧАНИЕ:  SPR_OKP - Контроль уникальности Активен.
