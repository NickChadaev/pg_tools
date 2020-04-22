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

-- Load the TAP functions.
BEGIN;
-- \i /usr/pgsql-12/share/extension/pgtap.sql
SET search_path=pgtap, pgq, public, com, com_codifier, com_domain, com_object, com_relation, com_error, nso, nso_structure, nso_data, nso_exchange, ind, ind_structure, ind_data, ind_exchange, auth, auth_serv_obj, auth_apr, auth_exchange, uio, utl, db_info, pg_catalog;
-- SHOW search_path;

-- Plan the tests.
SELECT pgtap.plan(2);

-- Run the tests.  -- Nick 2020-04-02
\i insert_test.sql
SELECT pgtap.pass( 'Тест "DC::insert_test пройден"' );
--
\i insert_test.sql
SELECT pgtap.pass( 'Тест "DC::insert_test пройден"' );

-- Finish the tests and clean up.
SELECT * FROM pgtap.finish();
ROLLBACK;
