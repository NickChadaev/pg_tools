-- ----------------
-- 2015-08-20 Роман
-- Процедура вывода иерархического списка зависимостей по OID (входной параметр масив oid)
-- 2015-09-12 Nick Теперь название функции имеет стуктуру, принятую в проекте. 
-- ---------------------------------------------------------------------------------------
SET search_path = auth, nso, com, app, db_info, public, pg_catalog;

DROP FUNCTION IF EXISTS db_info.db_info_f_dependency_tree_s( oid[] );
CREATE OR REPLACE FUNCTION db_info.db_info_f_dependency_tree_s(object_ids oid[])
  RETURNS TABLE(dependency_tree text)
  SECURITY DEFINER LANGUAGE SQL
  AS 
$function$
       WITH target AS (
         SELECT objid, dependency_chain
         FROM db_info.v_dependency
         JOIN unnest(object_ids) AS target(objid) USING (objid)
       )
       , list AS (
         SELECT DISTINCT
           format('%*s%s %s', -4*level
                 , CASE WHEN db_info.objid = ANY(object_ids) THEN '*' END
                 , object_type, object_identity
           ) AS dependency_tree
         , dependency_sort_chain
         FROM target
         JOIN db_info.v_dependency db_info
           ON db_info.objid = ANY(target.dependency_chain) -- корневая граница
           OR target.objid = ANY(db_info.dependency_chain) -- дочерняя граница
       )
       SELECT dependency_tree FROM list
       ORDER BY dependency_sort_chain;
$function$ ;

COMMENT ON FUNCTION db_info.db_info_f_dependency_tree_s( oid[] ) IS 'Функция построения иерархического списка зависимостей по OID (входной параметр масив oid)';


/*
  SELECT db_info.db_info_f_dependency_tree_s ( ARRAY(
	SELECT oid FROM pg_trigger WHERE tgname ~ 'tr_' )  );
*/