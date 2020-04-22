-- -----------------
-- 2015-08-20 Роман
-- Процедура вывода иерархического списка зависимостей при помощи регулярного выражения
-- 2015-09-12 Nick Теперь название функции имеет стуктуру, принятую в проекте. 
-- ------------------------------------------------------------------------------------
SET search_path = auth, nso, com, app, db_info, public, pg_catalog;

DROP FUNCTION IF EXISTS db_info.db_info_f_dependency_tree_s ( text );
CREATE OR REPLACE FUNCTION db_info.db_info_f_dependency_tree_s(search_pattern text)
  RETURNS TABLE(dependency_tree text)
  SECURITY DEFINER LANGUAGE SQL
  AS 
$function$
      WITH target AS (
        SELECT objid, dependency_chain
        FROM db_info.v_dependency
        WHERE object_identity ~ search_pattern
      )
      , list AS (
        SELECT
          format('%*s%s %s', -4*level
                , CASE WHEN object_identity ~ search_pattern THEN '*' END
                , object_type, object_identity
          ) AS dependency_tree
        , dependency_sort_chain
        FROM target
        JOIN db_info.v_dependency db_info
          ON db_info.objid = ANY(target.dependency_chain)
          OR target.objid = ANY(db_info.dependency_chain)
        WHERE LENGTH(search_pattern) > 0
        -- Если регулярка пустая
        UNION
        -- Запрашиваем все зависимости
        SELECT
          format('%*s%s %s', 4*level, '', object_type, object_identity) AS depedency_tree
        , dependency_sort_chain
        FROM db_info.v_dependency
        WHERE LENGTH(COALESCE(search_pattern,'')) = 0
      )
      SELECT dependency_tree FROM list ORDER BY dependency_sort_chain;
$function$ ;
 
COMMENT ON FUNCTION db_info.db_info_f_dependency_tree_s(search_pattern text) IS 'Функция построения иерархического списка зависимостей при помощи регулярного выражения'; 
 
-- SELECT db_info.db_info_f_dependency_tree_s(''::text);