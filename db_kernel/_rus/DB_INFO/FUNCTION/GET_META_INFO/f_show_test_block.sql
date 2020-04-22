	-- ====================================================================================================================
-- Author: Gregory
-- Create date: 2016-02-23
-- Description:	Генерация тестового DO блока для процедуры
-- ====================================================================================================================
/* --------------------------------------------------------------------------------------------------------------------
	Входные параметры:
                1) p_proc_oid     oid       -- Идентификатор объекта процедуры
                2) p_is_need_file t_boolean -- Выгрузка в файл / в результат процедуры
		3) p_dir          t_str1024 -- Каталог
	Выходные параметры:
		1) _result        t_text    -- Путь к файлу / Результирующий контент / Ошибка
-------------------------------------------------------------------------------------------------------------------- */
SET search_path = db_info, public;
DROP FUNCTION IF EXISTS db_info.f_show_test_block(oid,t_boolean,t_str1024);
CREATE OR REPLACE FUNCTION db_info.f_show_test_block
(
        p_proc_oid     oid
       ,p_is_need_file t_boolean DEFAULT true
       ,p_dir          t_str1024 DEFAULT '/tmp'
)
RETURNS t_text AS
$$
DECLARE
        _sch_name t_sysname;
        _pro_name t_sysname;
        _arg_list record;
        _arg_decl t_text;
        _pro_info_in t_text;
        _pro_args_in t_text;
        _pro_ret_arg t_sysname;
        _pro_exec t_text;
        _pro_info_out t_text;
        _pro_args_out t_text;
        _file t_str2048;
        _result t_text;
        c_T t_code1 := E'\t';
        c_TT t_code2 := E'\t\t';
        c_RN t_code2 := E'\r\n';
        c_SS t_code2 := E'\$\$';
BEGIN
        SELECT nspname, proname
        INTO _sch_name, _pro_name
        FROM pg_catalog.pg_proc pcpp
        JOIN pg_catalog.pg_namespace pcpn
        ON pcpn.oid = pcpp.pronamespace
        WHERE pcpp.oid = p_proc_oid;

        _arg_decl = '';
        _pro_info_in = c_T || '_notice = format (' || c_RN ||
                c_TT || '''%s++************** Тестирование процедуры ' || _sch_name || '.' || _pro_name || ' ****************'' ||' || c_RN ||   -- Nick 2017-01-28
                c_TT || '''%sАргументы:'' ||' || c_RN;
        _pro_args_in = '';
        _pro_ret_arg = '';
        _pro_exec = '';
        _pro_info_out = c_T || 'IF FOUND' || c_RN || c_T || 'THEN' || c_RN ||
                c_TT || '_notice = _notice || format (' || c_RN ||
                c_TT || c_T || '''%sРезультат:'' ||' || c_RN;
        _pro_args_out = '';

        FOR _arg_list IN
        (
                WITH RECURSIVE path AS (
                        WITH args AS (
                                SELECT
                                        arg_sequ_num
                                       ,arg_parent_num
                                       ,arg_in_out
                                       ,arg_name
                                       ,arg_type
                                       ,arg_default
                                       ,arg_info
                                FROM db_info.f_show_proc_args(p_proc_oid)
                        )
                        SELECT
                                arg_sequ_num
                               ,arg_parent_num
                               ,arg_in_out
                               ,arg_name
                               ,arg_type
                               ,arg_default
                               ,arg_info
                               ,arg_name AS arg_abs_name
                        FROM args
                        WHERE arg_parent_num = 0

                        UNION

                        SELECT
                                args.arg_sequ_num
                               ,args.arg_parent_num
                               ,args.arg_in_out
                               ,args.arg_name
                               ,args.arg_type
                               ,args.arg_default
                               ,args.arg_info
                               ,(path.arg_abs_name || '.' || args.arg_name)::t_sysname AS arg_abs_name
                        FROM
                                path
                               ,args
                        WHERE args.arg_parent_num = path.arg_sequ_num
                )
                SELECT
                        arg_sequ_num
                       ,arg_parent_num
                       ,arg_in_out
                       ,arg_name
                       ,arg_type
                       ,arg_default
                       ,arg_info
                       ,arg_abs_name
                FROM path
        )
        LOOP
                IF _arg_list.arg_parent_num = 0
                THEN
                        _arg_decl = _arg_decl || c_T || _arg_list.arg_name || ' ' || _arg_list.arg_type || ';' || c_RN;
                        IF _arg_list.arg_in_out = 'o'
                        THEN
                                _pro_ret_arg = _arg_list.arg_name;
                        END IF;
                END IF;
                IF _arg_list.arg_in_out = 'i'
                THEN 
                        _pro_info_in = _pro_info_in || c_TT || c_T || '''%s';
                        IF _arg_list.arg_info IS NOT NULL
                        THEN
                                _pro_info_in = _pro_info_in || _arg_list.arg_info ;
                        ELSE
                                _pro_info_in = _pro_info_in || _arg_list.arg_name;
                        END IF;
                        _pro_info_in = _pro_info_in || ' %L'' ||' || c_RN;
                        _pro_args_in = _pro_args_in || c_TT || 'c_RN || c_TT, ' || _arg_list.arg_name || ',' || c_RN;
                        _pro_exec = _pro_exec || c_TT || _arg_list.arg_name || ',' || c_RN;
                END IF;
                IF _arg_list.arg_in_out != 'i' --AND _arg_list.arg_parent_num != 0
                THEN
                        _pro_info_out = _pro_info_out || c_TT || c_TT || '''%s';
                        IF _arg_list.arg_info IS NOT NULL
                        THEN
                                _pro_info_out = _pro_info_out || _arg_list.arg_info ;
                        ELSE
                                _pro_info_out = _pro_info_out || _arg_list.arg_name;
                        END IF;
                        _pro_info_out = _pro_info_out || ' %L'' ||' || c_RN;
                        _pro_args_out = _pro_args_out || c_TT || c_T || 'c_RN || c_TT, ' || _arg_list.arg_abs_name || ',' || c_RN;
                END IF;
        END LOOP;

        _arg_decl = _arg_decl || c_T || '_notice t_text;' || c_RN ||
                c_T || 'c_T t_code1 = E''\t'';' ||c_RN ||
                c_T || 'c_TT t_code2 = E''\t\t'';' || c_RN ||
                c_T || 'c_RN t_code2 = E''\r'';'; -- Nick 2017-01-28 c_T || 'c_RN t_code2 = E''\r\n'';';
      
        _pro_info_in = rtrim(_pro_info_in, ' ||' || c_RN);
        _pro_args_in = rtrim(_pro_args_in, ',' || c_RN);  

        _pro_info_in = _pro_info_in || ',' || c_RN ||
                c_TT || 'c_RN || c_T,' || c_RN ||
                c_TT || 'c_RN || c_T,' || c_RN ||
                _pro_args_in || c_RN || c_T || ');';

        _pro_exec = rtrim(_pro_exec, ',' || c_RN);
        _pro_exec = c_T || 'SELECT * FROM ' || _sch_name || '.' || _pro_name || ' (' || c_RN ||
                _pro_exec || c_RN ||
                c_T || ')' || c_RN ||
                c_T || 'INTO ' || _pro_ret_arg || ';';
        -- Nick 2017-01-28 -- pro_info_out = rtrim (_pro_info_out, ' ||' || c_RN);
        _pro_info_out = _pro_info_out || c_TT || c_T || '''%s''';

         -- Nick 2017-01-28
        -- _pro_args_out = rtrim(_pro_args_out, ',' || c_RN);
        _pro_args_out = _pro_args_out || c_TT || c_T || 'c_RN || c_T ||'  
        '''--********************************************************************************''';
        --
        _pro_info_out = _pro_info_out || ',' || c_RN ||
                c_TT || c_T || 'c_RN || c_T,' || c_RN ||
                _pro_args_out || c_RN || c_TT ||
                ');' || c_RN || c_T || 'END IF;';
         --
        _result = 'DO' || c_RN || c_SS || c_RN || 'DECLARE' || c_RN ||
                _arg_decl || c_RN || 'BEGIN' || c_RN || _pro_info_in || c_RN || c_RN ||
                _pro_exec || c_RN || c_RN || _pro_info_out || c_RN || c_RN ||
                c_T || 'RAISE NOTICE ''%'', _notice;' || c_RN || c_RN ||
        --        c_T || 'RAISE SQLSTATE ''P0001'';' || c_RN ||  Nick 2017-01-28
                'EXCEPTION' || c_RN || c_T || 
                'WHEN OTHERS THEN' || c_RN || c_T || --  Nick 2017-01-28
                 'BEGIN' || c_RN || c_TT || 
                 'RAISE NOTICE ''ОШИБКА: %, %'', SQLSTATE, SQLERRM;' || c_RN || c_T || 
                 'END;' || c_RN ||
                'END;' || c_RN || c_SS;

        IF p_is_need_file
        THEN
                _file = p_dir || '/' || 'test_block_' || lower(btrim(_sch_name)) || '_' || upper(btrim(_pro_name)) || '_' ||
                replace(replace(((current_timestamp)::t_timestamp)::t_str100, ':', '-'), ' ', '-') || '.sql';
                EXECUTE 'COPY (SELECT ''' || replace(_result, '''', '''''') || ''') TO ''' || _file || ''' WITH CSV QUOTE '' ''';
                _result = _file;
        END IF;
        
        RETURN _result;
END;
$$
LANGUAGE plpgsql
SECURITY DEFINER ;
COMMENT ON FUNCTION db_info.f_show_test_block(oid,t_boolean,t_str1024)
IS '4972: Генерация тестового DO блока для процедуры.
        Входные параметры:
                1) p_proc_oid     oid       -- Идентификатор объекта процедуры
                2) p_is_need_file t_boolean -- Выгрузка в файл - TRUE/ в результат процедуры - FALSE
		3) p_dir          t_str1024 -- Каталог ''/tmp''
	Выходные параметры:
		1) _result        t_text    -- Путь к файлу / Результирующий контент / Ошибка';

-- SELECT * FROM db_info.f_show_proc_args('ind.ind_p_indicator_ti'::regproc::oid);
-- SELECT * FROM db_info.f_show_test_block('ind.ind_p_indicator_ti'::regproc::oid);
-- '/tmp/test_block_ind_IND_P_INDICATOR_TI_2016-09-21-17-09-04.sql'
/*DO
$$
DECLARE
        _execute t_text;
BEGIN
        SELECT db_info.f_show_test_block(162364, FALSE) --('nso_f_object_s_sys'::regproc::oid)
        INTO _execute;
        EXECUTE _execute;
END;
$$*/
