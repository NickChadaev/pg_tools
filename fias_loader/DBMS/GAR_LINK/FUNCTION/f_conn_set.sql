DROP FUNCTION IF EXISTS gar_link.f_conn_set (text, text);
DROP FUNCTION IF EXISTS gar_link.f_conn_set (numeric(3));
CREATE OR REPLACE FUNCTION gar_link.f_conn_set (
              p_node_id  numeric(3)
             ,OUT conn text
        )
        RETURNS text
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path=gar_link
   AS 
 $$
 -- ----------------------------------------------------------------
 --    2021-12-31/2022-02-02  Установка соединения, 
 --
   DECLARE
     _status       text;
     _conn_name    text;
     _fserver_name text;
     
   BEGIN
     SELECT fserver_name, db_conn_name INTO _fserver_name, _conn_name
          FROM  gar_link.foreign_servers WHERE (node_id = p_node_id) AND (active_sign);
     
     IF _fserver_name IS NULL 
       THEN
         RAISE '"fserver_name" IS NULL';
     END IF;  
     --
     IF _conn_name IS NULL 
       THEN
         RAISE '"conn_name" IS NULL';
     END IF;
     --
     IF COALESCE ((_conn_name <> ALL (gar_link.dblink_get_connections ())), TRUE) 
     THEN
         BEGIN
            _status := gar_link.dblink_connect (_conn_name, _fserver_name);
            IF ( _status = 'OK' ) THEN
                  conn := _conn_name;
            END IF;
             
          EXCEPTION WHEN others 
          THEN
             RAISE 'GAR_LINK.F_CONN_SET: %: failed to open the connection: % %',
                     _conn_name, SQLSTATE, SQLERRM;
         END;
         
      ELSE   
                conn := _conn_name;
     END IF;
   END;
 $$;
-- dblink_is_busy или dblink_get_result, 

COMMENT ON FUNCTION gar_link.f_conn_set (numeric(3)) IS 'Установка соединения DBLINK';
-- --------------------------------
-- USE CASE:
--      SELECT  gar_link.f_conn_set (4); 
--      SELECT gar_link.dblink_get_connections ();
--      SELECT gar_link.dblink_disconnect ('c_unnsi_nl') ;
