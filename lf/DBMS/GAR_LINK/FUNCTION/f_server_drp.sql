DROP FUNCTION IF EXISTS gar_link.f_server_drp (text);
CREATE OR REPLACE FUNCTION gar_link.f_server_drp (
            p_server_name_f text
        )
        RETURNS numeric(3)
        LANGUAGE plpgsql
        SECURITY DEFINER
   AS 
 $$
   -- -----------------------------------------------------------------------------------
   --  2022-05-05 Удаление стороннего сервера.
   -- -----------------------------------------------------------------------------------
   --     p_server_name_f -- Имя удаляемого стороннего сервера.
   -- -----------------------------------------------------------------------------------
   
   DECLARE
     
     _server_name_f  text := btrim(lower(p_server_name_f));
     _node_id        numeric(3);
     
   BEGIN
    DROP SERVER IF EXISTS _server_name_f CASCADE; 

    DELETE FROM gar_link.foreign_servers WHERE (fserver_name = _server_name_f)
      RETURNING node_id INTO _node_id;
                        
    RETURN _node_id;
    
   END;
$$;   

COMMENT ON FUNCTION gar_link.f_server_drp (text) IS 'Удаление стороннего сервера';
-- ------------
-- USE CASE:
-- SELECT gar_link.f_server_drp ('unnsi_m2l');
-- SELECT gar_link.f_server_drp ('unnsi_m2l11');
-- SELECT gar_link.f_server_drp ('unnsi_m7l');
-- ----------------------------------------------
-- SELECT * FROM gar_link.f_schema_import (
--             p_fserver_name  := 'unnsi_m8l'
--            ,p_fschema_name  := 'unnsi'
--            ,p_lschema_name  := 'unnsi'
--            ,p_lschema_descr := 'Эталон 2022-05-21'     
--         );

-- SELECT * FROM GAR_LINK.v_servers_active;
    
-- ЗАМЕЧАНИЕ:  удаление распространяется на объект сопоставление для пользователя postgres на сервере unnsi_m8l11
--
-- f_server_drp 
--------------
--            1
