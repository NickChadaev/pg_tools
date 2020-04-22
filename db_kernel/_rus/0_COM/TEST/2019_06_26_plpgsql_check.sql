select * from pg_settings where ( name ~* 'shared');
select * from pg_settings where ( name ~* 'shared');
--
SELECT * FROM plpgsql_show_dependency_tb ('com_codifier.obj_p_codifier_d(t_str60)');
------------------------------------------------------------------------------------
-- 'FUNCTION'|16731|'com_codifier'|'com_f_obj_codifier_get_id' |'(t_str60)'
-- 'FUNCTION'|16750|'com_error'   |'f_error_handling'          |'(exception_type_t,t_arr_text)'
-- 'FUNCTION'|16788|'utl'         |'com_f_empty_string_to_null'|'(t_text)'
-- 'RELATION'|16851|'com'         |'obj_codifier'              |''

SELECT * FROM plpgsql_show_dependency_tb ('com_codifier.obj_p_codifier_i(t_str60, t_str60, t_str250, t_guid, t_code1)');
------------------------------------------------------------------------------------------------------------------------
-- 'FUNCTION'|16731|'com_codifier'|'com_f_obj_codifier_get_id' |'(t_str60)'
-- 'FUNCTION'|16750|'com_error'   |'f_error_handling'          |'(exception_type_t,t_arr_text)'
-- 'FUNCTION'|16788|'utl'         |'com_f_empty_string_to_null'|'(t_text)'
-- 'RELATION'|16851|'com'         |'obj_codifier'              |''

SELECT * FROM plpgsql_profiler_function_tb ('com_codifier.obj_p_codifier_i(t_str60, t_str60, t_str250, t_guid, t_code1)');
SELECT * FROM plpgsql_profiler_function_tb ('com_domain.nso_p_domain_column_u (id_t,id_t,id_t,t_boolean,t_str60,t_str250,id_t,t_guid)');
------------------------------------------------------------------------------------------------------------------------
SELECT * FROM com_codifier.com_f_obj_codifier_s_sys();
SELECT * FROM plpgsql_profiler_function_tb ('com_codifier.com_f_obj_codifier_s_sys(t_str60, t_timestamp, t_int, t_text)');
-- Track function -- all ???
--
SELECT * FROM plpgsql_check_function_tb ('com_domain.nso_p_domain_column_u (id_t,id_t,id_t,t_boolean,t_str60,t_str250,id_t,t_guid)');
------------------------------------------------------------------------------------------------------------------------
-- 'com_codifier.obj_p_codifier_i'|18|'DECLARE'|'00000'|'never read variable "c_mess01"'|''|''|'warning extra'||''|''

SELECT * FROM plpgsql_check_function_tb ('com_codifier.obj_p_codifier_i(t_str60, t_str60, t_str250, t_guid, t_code1)'
                                          , performance_warnings := true);
---------------------------------------------------------------------------------------------------------------------
-- 'com_codifier.obj_p_codifier_i'|30|'statement block'|'42804'|'target type is different type than source type'|'cast "text" value to "t_sysname" type'|'Hidden casting can be a performance issue.'|'performance'||''|'during statement block local variable "c_err_func_name" initialization on line 15'
-- 'com_codifier.obj_p_codifier_i'|30|'statement block'|'42804'|'target type is different type than source type'|'cast "text" value to "t_sysname" type'|'Hidden casting can be a performance issue.'|'performance'||''|'during statement block local variable "c_seq_name" initialization on line 16'
-- 'com_codifier.obj_p_codifier_i'|30|'statement block'|'42804'|'target type is different type than source type'|'cast "text" value to "t_str1024" type'|'Hidden casting can be a performance issue.'|'performance'||''|'during statement block local variable "c_mess00" initialization on line 17'
-- 'com_codifier.obj_p_codifier_i'|30|'statement block'|'42804'|'target type is different type than source type'|'cast "text" value to "t_str1024" type'|'Hidden casting can be a performance issue.'|'performance'||''|'during statement block local variable "c_mess01" initialization on line 18'
-- 'com_codifier.obj_p_codifier_i'|30|'statement block'|'42804'|'target type is different type than source type'|'cast "t_text" value to "t_str60" type'|'Hidden casting can be a performance issue.'|'performance'||''|'during statement block local variable "_parent_code" initialization on line 23'
-- 'com_codifier.obj_p_codifier_i'|30|'statement block'|'42804'|'target type is different type than source type'|'cast "t_text" value to "t_str60" type'|'Hidden casting can be a performance issue.'|'performance'||''|'during statement block local variable "_code" initialization on line 24'
-- 'com_codifier.obj_p_codifier_i'|30|'statement block'|'42804'|'target type is different type than source type'|'cast "t_text" value to "t_str250" type'|'Hidden casting can be a performance issue.'|'performance'||''|'during statement block local variable "_name" initialization on line 25'
-- 'com_codifier.obj_p_codifier_i'|30|'statement block'|'42804'|'target type is different type than source type'|'cast "text[]" value to "t_arr_text" type'|'Hidden casting can be a performance issue.'|'performance'||''|'during statement block local variable "_err_args" initialization on line 28'
-- 'com_codifier.obj_p_codifier_i'|40|'assignment'|'42804'|'target type is different type than source type'|'cast "t_str60" value to "text" type'|'Hidden casting can be a performance issue.'|'performance'||''|'at assignment to element of variable "_err_args" declared on line 28'
-- 'com_codifier.obj_p_codifier_i'|61|'assignment'|'42804'|'target type is different type than source type'|'cast "t_str1024" value to "text" type'|'Hidden casting can be a performance issue.'|'performance'||''|'at assignment to variable "rsp_main" declared on line 20'
-- 'com_codifier.obj_p_codifier_i'|63|'assignment'|'42804'|'target type is different type than source type'|'cast "t_str60" value to "text" type'|'Hidden casting can be a performance issue.'|'performance'||''|'at assignment to element of variable "_err_args" declared on line 28'
-- 'com_codifier.obj_p_codifier_i'|84|'assignment'|'42804'|'target type is different type than source type'|'cast "t_sysname" value to "text" type'|'Hidden casting can be a performance issue.'|'performance'||''|'at assignment to variable "exception_type_t.func_name" declared on line 0'
-- 'com_codifier.obj_p_codifier_i'|86|'assignment'|'42804'|'target type is different type than source type'|'cast "integer" value to "bigint" type'|'Hidden casting can be a performance issue.'|'performance'||''|'at assignment to variable "rsp_main" declared on line 20'
-- 'com_codifier.obj_p_codifier_i'|86|'assignment'|'42804'|'target type is different type than source type'|'cast "t_text" value to "text" type'|'Hidden casting can be a performance issue.'|'performance'||''|'at assignment to variable "rsp_main" declared on line 20'
-- 'com_codifier.obj_p_codifier_i'|18|'DECLARE'|'00000'|'never read variable "c_mess01"'|''|''|'warning extra'||''|''
                                          
SELECT * FROM plpgsql_check_function_tb ('com_codifier.obj_p_codifier_i(t_str60, t_str60, t_str250, t_guid, t_code1)');
-- --------------------------------------------------------------------------------------------------------------------
-- 'com_codifier.obj_p_codifier_i'|18|'DECLARE'|'00000'|'never read variable "c_mess01"'|''|''|'warning extra'

SELECT * FROM plpgsql_check_function_tb ('com_error.f_error_handling (exception_type_t, t_sysname, t_sysname)');
-----------------------------------------------------------------------------------------------------------------
-- 'com_error.f_error_handling'|34|'DECLARE'|'00000'|'never read variable "c_emp"'  |''|''|'warning extra'||''|''
-- 'com_error.f_error_handling'|40|'DECLARE'|'00000'|'never read variable "ch_dtab"'|''|''|'warning extra'||''|''
-- 'com_error.f_error_handling'|48|'DECLARE'|'00000'|'never read variable "_qty"'   |''|''|'warning extra'||''|''
-- 'com_error.f_error_handling'|  |'       '|'00000'|'parameter "$3" is never read' |''|''|'warning extra'||''|''

SELECT * FROM plpgsql_check_function_tb ('com_error.f_error_handling (exception_type_t, t_arr_text)');
------------------------------------------------------------------------------------------------------
-- 'com_error.f_error_handling'|34|'DECLARE'|'00000'|'never read variable "c_mes001"'|''|''|'warning extra'||''|''
-- 'com_error.f_error_handling'|35|'DECLARE'|'00000'|'never read variable "c_mes002"'|''|''|'warning extra'||''|''
-- 'com_error.f_error_handling'|56|'DECLARE'|'00000'|'never read variable "ch_dtab"' |''|''|'warning extra'||''|''

SELECT * FROM plpgsql_check_function_tb ('com_error.com_f_value_check (t_code1, t_text)');
---------------------------------------------------------------------------------------------
-- 'com_f_value_check'|299|'assignment'|'42804'|'target type is different type than source type'
-- 'com_f_value_check'|303|'assignment'|'42804'|'target type is different type than source type'
-- 'com_f_value_check'| 87|'DECLARE'   |'00000'|'unused variable "_test_t_date"'
-- 'com_f_value_check'|101|'DECLARE'   |'00000'|'unused variable "_test_id_t"'
-- 'com_f_value_check'| 71|'DECLARE'|'00000'|'never read variable "_test_small_t"'
-- 'com_f_value_check'| 72|'DECLARE'|'00000'|'never read variable "_test_t_int"'
-- 'com_f_value_check'| 73|'DECLARE'|'00000'|'never read variable "_test_longint_t"'
-- 'com_f_value_check'| 75|'DECLARE'|'00000'|'never read variable "_test_t_boolean"'
-- 'com_f_value_check'| 76|'DECLARE'|'00000'|'never read variable "_test_t_code1"'
-- 'com_f_value_check'| 77|'DECLARE'|'00000'|'never read variable "_test_t_code2"'
-- 'com_f_value_check'| 78|'DECLARE'|'00000'|'never read variable "_test_t_code5"'
-- 'com_f_value_check'| 79|'DECLARE'|'00000'|'never read variable "_test_t_str20"'
-- 'com_f_value_check'| 80|'DECLARE'|'00000'|'never read variable "_test_t_str60"'
-- 'com_f_value_check'| 81|'DECLARE'|'00000'|'never read variable "_test_t_str250"'
-- 'com_f_value_check'| 83|'DECLARE'|'00000'|'never read variable "_test_t_str1024"'
-- 'com_f_value_check'| 84|'DECLARE'|'00000'|'never read variable "_test_t_str2048"'
-- 'com_f_value_check'| 85|'DECLARE'|'00000'|'never read variable "_test_t_timestamp"'
-- 'com_f_value_check'| 86|'DECLARE'|'00000'|'never read variable "_test_t_timestampz"'
-- 'com_f_value_check'| 88|'DECLARE'|'00000'|'never read variable "_test_ip_t"'
-- 'com_f_value_check'| 89|'DECLARE'|'00000'|'never read variable "_test_xml_t"'
-- 'com_f_value_check'| 90|'DECLARE'|'00000'|'never read variable "_test_t_guid"'
-- 'com_f_value_check'| 91|'DECLARE'|'00000'|'never read variable "_test_t_sysname"'
-- 'com_f_value_check'| 92|'DECLARE'|'00000'|'never read variable "_test_t_fieldname"'
-- 'com_f_value_check'| 93|'DECLARE'|'00000'|'never read variable "_test_t_money"'
-- 'com_f_value_check'| 94|'DECLARE'|'00000'|'never read variable "_test_t_inn_ul"'
-- 'com_f_value_check'| 95|'DECLARE'|'00000'|'never read variable "_test_t_kpp"'
-- 'com_f_value_check'| 96|'DECLARE'|'00000'|'never read variable "_test_t_phone_nmb"'
-- 'com_f_value_check'| 99|'DECLARE'|'00000'|'never read variable "_test_t_inn_pp"'
-- 'com_f_value_check'|100|'DECLARE'|'00000'|'never read variable "_test_t_decimal"'
-- 'com_f_value_check'|104|'DECLARE'|'00000'|'never read variable "_test_hstore"'
-- 'com_f_value_check'|105|'DECLARE'|'00000'|'never read variable "_test_text"'
-- 'com_f_value_check'|111|'DECLARE'|'00000'|'never read variable "cnull"'

SELECT * FROM db_info.f_show_proc_list(p_proc_lang_list := 'plpgsql');
----------------------------------------------------------------------
SELECT proc_oid, nsp_name, proc_name, plpgsql_check_function(proc_oid), args_line, proc_info 
                FROM db_info.f_show_proc_list(p_proc_lang_list := 'plpgsql');
----------------------------------------------------------------------------
             
 SELECT p.oid, p.proname, plpgsql_check_function(p.oid)
     FROM pg_catalog.pg_namespace n
      JOIN pg_catalog.pg_proc p ON pronamespace = n.oid
      JOIN pg_catalog.pg_language l ON p.prolang = l.oid
 WHERE l.lanname = 'plpgsql' AND p.prorettype <> 2279 AND NOT (proname ~* 'plpgsql');

