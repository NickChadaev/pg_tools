-- -----------------
--  2019-06-28  Nick
-- -----------------
SELECT * FROM plpgsql_check_function_tb ('com_domain.nso_p_domain_column_i ( t_str60, t_str60, t_str60, t_str250, t_guid, t_str60)');
----
-- Состояние дл исправления кода функции, обращение к обработчику ошибок - старое
-- "nso_p_domain_column_i";124;"assignment";"42883";"function com_error.f_error_handling(text, text, t_sysname) does not exist";"";"No function matches the given name and argument types. You might need to add explicit type casts.";"error";16;"SELECT ( -1, ( com_error.f_error_handling ( SQLSTATE, SQLERRM, с_ERR_FUNC_NAME )))";"at assignment to variable "rsp_main" declared on line 19"

