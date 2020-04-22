-- ----------------
-- 2015-08-20 Роман
-- Процедура вывода иерархического списка зависимостей по именам отношений (входной параметр текстового масива)
-- 2015-09-12 Nick Теперь название функции имеет стуктуру, принятую в проекте. 
-- ------------------------------------------------------------------------------------------------------------

SET search_path = auth, nso, com, app, db_info, public, pg_catalog;

DROP FUNCTION IF EXISTS db_info.db_info_f_dependency_tree_s( text[] );
CREATE OR REPLACE FUNCTION db_info.db_info_f_dependency_tree_s(object_names text[])
  RETURNS TABLE(dependency_tree text)
  SECURITY DEFINER LANGUAGE SQL
  AS 
$$
  WITH target AS (
    SELECT objid, dependency_chain
    FROM db_info.v_dependency
    JOIN unnest(object_names) AS target(objname) ON objid = objname::regclass
  )
  , list AS (
    SELECT DISTINCT
      format('%*s%s %s', -4*level
            , CASE WHEN object_identity = ANY(object_names) THEN '*' END
            , object_type, object_identity
      ) AS dependency_tree
    , dependency_sort_chain
    FROM target
    JOIN db_info.v_dependency db_info
      ON db_info.objid = ANY(target.dependency_chain) -- root-bound chain
      OR target.objid = ANY(db_info.dependency_chain) -- leaf-bound chain
  )
  SELECT dependency_tree FROM list
  ORDER BY dependency_sort_chain;
$$ ;

COMMENT ON FUNCTION db_info.db_info_f_dependency_tree_s( text[] ) IS 'Функция построения иерархического списка зависимостей по именам отношений';

--SELECT db_info.db_info_f_dependency_tree_s('{app_appendix,app_appendix_data}'::text[]);