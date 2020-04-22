--
-- 2019-07-07 Nick
--
drop table t1 ;
drop table t2 ;
--
CREATE SCHEMA test;

create table test.t1 (f1 serial,  f2 date, f3 text);
create table test.t2 (f11 int, f12 text); 
--
create role almaz10 nologin  nosuperuser;
comment on role almaz10 IS 'Тестовая роль, права на выполнение f1(), права на выполнение f2()';
--
create role almaz20 nologin  nosuperuser;
comment on role almaz20 IS 'Тестовая роль, права на IUD для t1, t2';
-- -------------------------------------------------------------------
INSERT INTO test.t1 (f2,f3) SELECT now()::date, (random ()*(generate_series(1, 1000000))) || '_TEST'; 
   --
INSERT INTO test.t2 (f11, f12) SELECT generate_series(1, 1000000), (random ()*1000) || '_TEST_2';;     
--
CREATE OR REPLACE FUNCTION test.f1 (pf1 int )
RETURNS TABLE (f1 int,  f2 date, f3 text)
 AS
     $$
        SELECT f1, f2, f3 FROM test.t1 WHERE ((f1 = pf1) AND (pf1 IS NOT NULL)) OR (pf1 IS NULL);               
     $$ 
         LANGUAGE sql
	 SECURITY DEFINER;
--
SELECT * FROM test.f1 (780);
--
CREATE OR REPLACE FUNCTION test.f2 (pf2 int )
RETURNS TABLE (f11 int,  f12 text)
 AS
     $$
        SELECT f11, f12  FROM test.t2 WHERE ((f11 = pf2) AND (pf2 IS NOT NULL)) OR (pf2 IS NULL);               
     $$ 
         LANGUAGE sql
	 SECURITY DEFINER;         
-------------------------
SELECT * FROM test.f2 (780);

--
--  Отнимаю права у PUBLIC.
--
REVOKE ALL ON SCHEMA test FROM public;
REVOKE ALL ON TABLE test.t1 FROM public;
REVOKE ALL ON TABLE test.t2 FROM public;
REVOKE ALL ON SEQUENCE test.t1_f1_seq FROM public;
REVOKE ALL ON FUNCTION test.f1 FROM public;
REVOKE ALL ON FUNCTION test.f2 FROM public;
--
-- Что получилось
--
SELECT * FROM auth_f_table_privileges ('almaz10') WHERE ( tablename ~* 'test' ); -- ???
-- ----------------------------------------------------------------------------

-- create role almaz10 nologin  nosuperuser;
-- comment on role almaz10 IS 'Тестовая роль, права на выполнение f1(), права на выполнение f2()';
-- 
-- create role almaz20 nologin  nosuperuser;
-- comment on role almaz20 IS 'Тестовая роль, права на IUD для t1, t2';
--

GRANT USAGE ON SCHEMA test TO almaz10; 
GRANT USAGE ON SCHEMA test TO almaz20; 

SELECT * FROM auth_f_schema_privileges ('almaz10');
----------------------------------------------------
-- "almaz10";"pg_catalog";f;t
-- "almaz10";"public";t;t
-- "almaz10";"test";f;t

GRANT execute ON function test.f1 (int) TO almaz10; 
GRANT EXECUTE ON function test.f2 (int) TO almaz10;
--
GRANT INSERT, UPDATE, DELETE, TRUNCATE ON TABLE test.t1 TO almaz20;
GRANT INSERT, UPDATE, DELETE, TRUNCATE ON TABLE test.t2 TO almaz20;
-- 
-- Что получилось ???
--
SELECT * FROM auth_f_table_privileges ('almaz10') WHERE ( sch_name = 'test' ); -- ???
SELECT * FROM auth_f_table_privileges ('almaz20') WHERE ( sch_name = 'test' ); 
SELECT * FROM auth_f_function_privileges ('almaz10') WHERE ( sch_name = 'test' ); 

-- ПРобуем

SET SESSION AUTHORIZATION almaz10;
SELECT SESSION_USER, CURRENT_USER;
----------------------------------
-- "almaz10";"almaz10"

SELECT * FROM test.f2 (780);   -- 780;"90.3510390780866_TEST_2"
SELECT * FROM test.f1 (3380);  -- 3380;"2019-07-08";"956.323158349842_TEST"
---------------------------------
select * from test.t1 limit 10; -- ERROR:  permission denied for relation t1
INSERT INTO test.t1 (f2,f3) SELECT now()::date, (random ()*(generate_series(1, 100))) || '_TEST'; 
-- ERROR:  permission denied for relation t1

RESET SESSION AUTHORIZATION;
SELECT SESSION_USER, CURRENT_USER;

SET SESSION AUTHORIZATION almaz20;
SELECT SESSION_USER, CURRENT_USER;

SELECT * FROM test.f1 (3380);  -- ERROR: permission denied for function f1

INSERT INTO test.t1 (f2,f3) SELECT now()::date, (random ()*(generate_series(1, 100000))) || '_AGAIN_TEST'; 
-- ERROR:  permission denied for sequence t1_f1_seq   НЕпредусмотрел однако.

RESET SESSION AUTHORIZATION;
GRANT SELECT,UPDATE,USAGE ON sequence test.t1_f1_seq TO almaz20;

SELECT * FROM auth_f_sequence_privileges ('almaz20'); 
-- "almaz20";"test.t1_f1_seq";t;t;t

SET SESSION AUTHORIZATION almaz20;
SELECT SESSION_USER, CURRENT_USER;

INSERT INTO test.t1 (f2,f3) SELECT now()::date, (random ()*(generate_series(1, 100000))) || '_AGAIN_TEST'; 
-- Query returned successfully: 100000 rows affected, 535 msec execution time.

RESET SESSION AUTHORIZATION;