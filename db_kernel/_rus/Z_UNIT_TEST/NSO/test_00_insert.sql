\unset ECHO
\set QUIET 1
-- Turn off echo and keep things quiet.

-- Format the output for nice TAP.
\pset format unaligned
\pset tuples_only true
\pset pager off

-- Revert all changes on failure.
\set ON_ERROR_ROLLBACK 1
\set ON_ERROR_STOP true

BEGIN;
-- Plan the tests.
SELECT pgtap.plan(3);

-- Run the tests.  -- Nick 2020-04-07
\i INS/insert_test.sql
SELECT pgtap.pass( 'Тест "OBJ::insert_test пройден"' );
--
\i INS/insert_test_column_header.sql
SELECT pgtap.pass( 'Тест "HDR::insert_test пройден"' );
--
\i INS/insert_test_key_1.sql
SELECT pgtap.pass( 'Тест "KEY::insert_test пройден"' );
--
-- Finish the tests and clean up.
SELECT * FROM pgtap.finish();
COMMIT;

-- ---------------------------------------------------------------------------------------------
-- $>pg_prove -U postgres -d db_k test_00_insert.sql 2> test_00_insert.txt
-- test_00_insert.sql .. ok   
-- All tests successful.
-- Files=1, Tests=3,  2 wallclock secs ( 0.05 usr  0.01 sys +  0.01 cusr  0.00 csys =  0.07 CPU)
-- Result: PASS
-- --------------------------------------------------------------------------------------------