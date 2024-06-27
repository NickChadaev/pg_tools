DROP PROCEDURE IF EXISTS gar_link.p_execute_idx (text, text);
CREATE OR REPLACE PROCEDURE gar_link.p_execute_idx (
              p_exec  text        -- Исполняемое выражение.
             ,p_conn  text = NULL -- Именованное dblink-соединение   
           
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS 

  $$
   -- --------------------------------------------------------------------------
   --   2022-11-22  Использованиен индексного хранилища. 
   -- --------------------------------------------------------------------------                 
    DECLARE 
     _mess  text;
   
    BEGIN
        IF (p_conn IS NOT NULL) 
          THEN
             SELECT xx1.mess INTO _mess 
                        FROM gar_link.dblink (p_conn, p_exec) xx1 ( mess text);
          ELSE
               EXECUTE p_exec;
        END IF; 
        
        RAISE NOTICE '%', p_exec;
    END;
  $$;
  
COMMENT ON PROCEDURE gar_link.p_execute_idx (text, text) 
  IS 'Создание индексов в отдалённой/локальной таблице';  
-- ----- ----------------------------------------------------
-- USE CASE:
-- SELECT gar_link.f_server_is();
-- SELECT * FROM gar_link.v_servers_active;





 
