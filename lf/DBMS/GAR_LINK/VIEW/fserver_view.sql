DROP VIEW IF EXISTS gar_link.v_servers_active CASCADE;
CREATE VIEW gar_link.v_servers_active AS 
   SELECT  
            node_id        
          , fserver_name   
          , host           
          , dbname         
          , port           
          , db_conn_name   
          , local_sch_name 
          , date_create   
      FROM gar_link.foreign_servers    
   WHERE active_sign ORDER BY node_id;

COMMENT ON VIEW gar_link.v_servers_active IS 'Список АКТИВНЫХ внешних серверов';

COMMENT ON COLUMN gar_link.v_servers_active.node_id        IS 'Номер внешнего сервера';
COMMENT ON COLUMN gar_link.v_servers_active.fserver_name   IS 'Имя внешнего сервера';
COMMENT ON COLUMN gar_link.v_servers_active.host           IS 'IP-адрес';
COMMENT ON COLUMN gar_link.v_servers_active.dbname         IS 'Имя базы данных';
COMMENT ON COLUMN gar_link.v_servers_active.port           IS 'Порт';
COMMENT ON COLUMN gar_link.v_servers_active.db_conn_name   IS 'Имя DB-LINK соединения';
COMMENT ON COLUMN gar_link.v_servers_active.local_sch_name IS 'Имя локальной схемы';
COMMENT ON COLUMN gar_link.v_servers_active.date_create    IS 'Дата создания записи';
--
-- SELECT * FROM gar_link.v_servers_active;