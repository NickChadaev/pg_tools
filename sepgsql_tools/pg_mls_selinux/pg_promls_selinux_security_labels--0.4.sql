-- ---------------------------------------------------------------------------- --
--  2020-03-15  Nick Версия 0.4                                                 --
--  2020-04-08  Nick Обратная адаптация на ALT                                  --
-- ---------------------------------------------------------------------------- --
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_get_tuple_label_t  (text, int)        IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_column_label_t (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_con_t          (text)             IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0-s3';
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_db_label_t     (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_func_label_t   (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_sch_label_t    (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_seq_label_t    (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_table_label_t  (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_tuple_label_t  (text, int,  text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';   
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_set_view_label_t   (text, text, text) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
--
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.sepgsql_check_tuple_label (text, varchar(10), text[], boolean) IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0'; -- 2020-01-10
--
-- 2019-11-26 Триггерные функции
--
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.f_tg_after_i()  IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.f_tg_before_d() IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.f_tg_after_u()  IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
--
-- 2020-03-27 Новые функции
--
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.pg_promls_table_remove (text, text, text, text[], text, text) 
   IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
--
SECURITY LABEL FOR 'selinux' ON FUNCTION sepgsql.pg_promls_table_add (text, text, text[], text, text, text, text) 
   IS 'generic_u:object_r:sepgsql_trusted_proc_exec_t:s0';
