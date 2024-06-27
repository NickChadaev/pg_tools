DROP FUNCTION IF EXISTS gar_link.f_active_set (numeric(3));
CREATE OR REPLACE FUNCTION gar_link.f_active_set (
              p_node_id  numeric(3)
        )
        RETURNS text
        LANGUAGE sql
   AS 
 $$
  -- ----------------------------------------------------------------
  --   2022-02-02. Установка активно соединения
  -- ----------------------------------------------------------------
  UPDATE gar_link.foreign_servers SET active_sign = TRUE WHERE (node_id = p_node_id)
    RETURNING  fserver_name;
  
 $$;


COMMENT ON FUNCTION gar_link.f_active_set (numeric(3)) IS 'Установка активно соединения';
-- --------------------------------
-- USE CASE:
--      SELECT  gar_link.f_active_set (4); 
--      SELECT  * FROM gar_link.foreign_servers ;        -- OK 
