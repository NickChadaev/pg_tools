DROP FUNCTION IF EXISTS gar_link.f_server_is (text);
CREATE OR REPLACE FUNCTION gar_link.f_server_is (
              p_fschema_name text = 'unnsi'
        )
        RETURNS text
        LANGUAGE sql
   AS 
 $$
  -- ----------------------------------------------------------------
  --   2022-02-24. Определение текущего  стороннего сервера.
  -- ----------------------------------------------------------------
   SELECT foreign_server_name FROM  information_schema.foreign_tables
                    WHERE  (foreign_table_schema = p_fschema_name) AND 
                           (foreign_table_name = 'adr_area');
  
 $$;


COMMENT ON FUNCTION gar_link.f_server_is (text) IS 'Определение текущего стороннего сервера.';
-- --------------------------------
-- USE CASE:
--      SELECT  gar_link.f_server_is ('unnsi'); 
--      SELECT  * FROM gar_link.foreign_servers ;        -- OK 
