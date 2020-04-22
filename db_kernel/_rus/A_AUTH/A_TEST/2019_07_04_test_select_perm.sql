      SELECT c.oid::oid
           , c.relnamespace, CAST(
          (CASE WHEN CAST( c.oid::regclass AS text) ~ '^\S+\.\S+'::text
                THEN CAST( c.oid::regclass AS text)
                ELSE n.nspname || '.' || CAST( c.oid::regclass AS text) 
           END ) AS text) AS tblname
          FROM pg_class c
               INNER JOIN pg_namespace n ON (c.relnamespace = n.oid)
       WHERE (
              ( n.nspname <> 'information_schema' )
--          AND ( n.nspname <> 'pg_catalog' )
          AND ( n.nspname NOT LIKE 'pg_temp%' )          
          AND c.relkind = 'r')
          ORDER BY c.relnamespace
--
-- ----------------------------------------------------------------------
--
         SELECT
           c.oid 
          ,n.nspname || '.' || c.relname AS tblname
       FROM pg_namespace n 
            JOIN pg_class c ON n.oid = c.relnamespace
       WHERE ( (c.relkind = 'r')
          AND ( n.nspname <> 'information_schema' )
          --AND ( n.nspname <> 'pg_catalog' )
          AND ( n.nspname NOT LIKE 'pg_temp%' )  
          )
--
-- -----------------------------------------------------------------------
--
WITH iuser AS ( SELECT btrim ('postgres') AS uname
      )
      ,iclass AS
       (          
         SELECT
             c.oid 
            ,n.nspname || '.' || c.relname AS tblname
            ,c.relnamespace
          FROM pg_namespace n 
                 JOIN pg_class c ON n.oid = c.relnamespace
          WHERE ( (c.relkind = 'r')
            AND ( n.nspname <> 'information_schema' )
            AND ( n.nspname NOT LIKE 'pg_temp%' )  
          )
        )
          SELECT
           u.uname
          ,c.tblname
          ,has_table_privilege (u.uname, c.oid,'SELECT')       AS is_select
          ,has_table_privilege (u.uname, c.oid,'INSERT')       AS is_insert
          ,has_table_privilege (u.uname, c.oid,'UPDATE')       AS is_update 
          ,has_table_privilege (u.uname, c.oid,'DELETE')       AS is_delete
          ,has_table_privilege (u.uname, c.oid,'TRUNCATE')     AS is_truncate
          ,has_table_privilege (u.uname, c.oid,'REFERENCES')   AS is_references
          ,has_table_privilege (u.uname, c.oid,'TRIGGER')      AS is_trigger
            
         FROM iclass c
            , iuser u
          WHERE has_table_privilege (u.uname, c.oid, 'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER' )
                  AND
                has_schema_privilege (u.uname, c.relnamespace,'USAGE') 
         ORDER BY c.tblname;       
       