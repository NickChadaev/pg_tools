--
--  2019-07-16 Nick
--
SELECT n.nspname, p.oid, p.proname, plpgsql_check_function(p.oid)
   FROM pg_catalog.pg_namespace n
   JOIN pg_catalog.pg_proc p ON pronamespace = n.oid
   JOIN pg_catalog.pg_language l ON p.prolang = l.oid
  WHERE l.lanname = 'plpgsql' AND p.prorettype <> 2279 AND n.nspname ~* 'com';
 -- ---  Комплексная проверка
 SELECT n.nspname, p.oid, p.proname, ch.*
   FROM pg_catalog.pg_namespace n
   JOIN pg_catalog.pg_proc p ON pronamespace = n.oid
   JOIN pg_catalog.pg_language l ON p.prolang = l.oid
   ,LATERAL (SELECT * FROM plpgsql_check_function_tb (p.oid) ) ch
  WHERE l.lanname = 'plpgsql' AND p.prorettype <> 2279 AND n.nspname ~* 'com';