/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     02.02.2022 16:19:52                          */
/* ------------------------------------------------------------ */
/*     СВОДИМ в единое целое все внешие сервера.                */
/*==============================================================*/

SET search_path=gar_link;

/*==============================================================*/
/* Table: gar_link.foreign_servers                              */
/*==============================================================*/
DROP TABLE IF EXISTS gar_link.foreign_servers CASCADE;
CREATE TABLE gar_link.foreign_servers (
      node_id        numeric(3)  NOT NULL
    , fserver_name   text        NOT NULL
    , host           inet        NOT NULL  
    , dbname         text        NOT NULL  
    , port           numeric(4)  NOT NULL  
    , db_conn_name   text        NOT NULL
    , local_sch_name text        NOT NULL
    , active_sign    boolean     NOT NULL DEFAULT false
    , date_create    timestamp   NOT NULL DEFAULT now()
    );

ALTER TABLE gar_link.foreign_servers ADD CONSTRAINT pk_foreign_servers PRIMARY KEY (node_id);

ALTER TABLE gar_link.foreign_servers ADD CONSTRAINT ak1_foreign_servers UNIQUE (fserver_name);
ALTER TABLE gar_link.foreign_servers ADD CONSTRAINT ak2_foreign_servers UNIQUE (db_conn_name);

COMMENT ON TABLE gar_link.foreign_servers IS 'Список внешних серверов';

COMMENT ON COLUMN gar_link.foreign_servers.node_id        IS 'Номер внешнего сервера';
COMMENT ON COLUMN gar_link.foreign_servers.fserver_name   IS 'Имя внешнего сервера';
COMMENT ON COLUMN gar_link.foreign_servers.host           IS 'IP-адрес';
COMMENT ON COLUMN gar_link.foreign_servers.dbname         IS 'Имя базы данных';
COMMENT ON COLUMN gar_link.foreign_servers.port           IS 'Порт';
COMMENT ON COLUMN gar_link.foreign_servers.db_conn_name   IS 'Имя DB-LINK соединения';
COMMENT ON COLUMN gar_link.foreign_servers.local_sch_name IS 'Имя локальной схемы';
COMMENT ON COLUMN gar_link.foreign_servers.active_sign    IS 'Признак активного соединения';
COMMENT ON COLUMN gar_link.foreign_servers.date_create    IS 'Дата создания записи';
--
--
--
/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     02.02.2022 16:19:52                          */
/* ------------------------------------------------------------ */
/*     СВОДИМ в единое целое все внешие сервера.                */
/*==============================================================*/

-- SET search_path=gar_link;

/*==============================================================*/
/* Table: gar_link.foreign_servers                              */
/*==============================================================*/
-- INSERT INTO gar_link.foreign_servers (node_id, fserver_name, host
--                         , dbname, port, db_conn_name, local_sch_name, active_sign
--)
-- VALUES (1,'unnsi_dev','10.196.35.11','ccrm_dev',  5432, 'c_ccrm_dev',  'unnsi', true)
--       ,(2,'unnsi_l',  '127.0.0.1',   'unnsi',     5434, 'c_unnsi_l',   'unnsi', false)
--       ,(9,'unnsi_ml', '127.0.0.1',   'unnsi_m',   5434, 'c_unnsi_ml',  'unnsi', false)
--       ,(4,'unnsi_nl', '127.0.0.1',   'unnsi_n',   5434, 'c_unnsi_nl',  'unnsi', false)
--       ,(5,'unnsi_p2', '10.196.35.45','unsi',      5432, 'c_unsi_p2',   'unsi' , false)
--       ,(6,'unsi_l',   '127.0.0.1',   'unsi',      5434, 'c_unsi_l',    'unsi' , false)
--       ,(3,'unnsi_m2l','127.0.0.1',   'unnsi_m2',  5434, 'c_unnsi_m2l', 'unnsi', true)       
-- ;
-- SELECT * FROM gar_link.foreign_servers;
