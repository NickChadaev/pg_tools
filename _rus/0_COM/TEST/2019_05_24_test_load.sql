SHOW sepgsql.permissive;
SHOW sepgsql.debug_audit; 
select sepgsql_getcon();
select (inet_client_addr () IS NULL);
select * from com.obj_codifier;

delete from only com.nso_domain_column;
delete from only com.nso_domain_column_hist;

delete from only com.obj_codifier;
delete from only com.obj_codifier_hist;

delete from com.all_log;