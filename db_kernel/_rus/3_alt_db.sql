/*=================================================================*/
/* DBMS name:      PostgreSQL 9                                    */
/* Created on:     19.08.2013 19:55:00                             */
/* --------------------------------------------------------------- */
/*  При создании оъектов в базе необходимо в имени объекта явно    */
/*  указывать схему, например: CREATE VEIW nso.xxx_yy_zz ..., либо */
/*  явно устанавливать текущий путь поиска командой SET, например, */
/*  SET searchpath=nso; CREATE VIEW xxx_yyy_zz ...                 */
/*  Для выполнения команд SELECT можно опустить команду SET, либо  */
/*  уточнение имени. Например будут корректно работать два запроса:*/
/*                SELECT * FROM obj_codifier;                      */
/*                SELECT * FROM ind_type;                          */
/* --------------------------------------------------------------- */
/*  По умолчанию любой объект будет создан в схеме public.         */
/*=================================================================*/
/* 2013-10-24  Новая схема объектов, остальное - старое.           */
/* 2013-12-12  Новый процедурный слой у НСО, новый ГИС ( РОО )     */ 
/* 2014-03-12  Новый процедурный слой у НСО, новая схема объектов, */
/*             новая схема показателей. Пустая схема "Документы".  */
/* 2014-07-02 Новая версия БД ЕМД - 3.0                            */
/* ----------------------------------------------------------------*/
/* 2015-04-05 Домен ЕБД.                                           */
/* 2015-12-11 Две базы: боевая RED LEVEL, тестовая YELLOW LEVEL    */
/* ----------------------------------------------------------------*/
/* 2018-12-14 Новое ядро                                           */
/*=================================================================*/
--
ALTER DATABASE db_k SET search_path = public, com, com_codifier, com_domain, com_object, com_relation, com_error
                                     ,nso, nso_structure, nso_data, nso_exchange
                                     ,ind, ind_structure, ind_data, ind_exchange
                                     ,auth, auth_serv_obj, auth_apr, auth_exchange, uio, utl, db_info, pg_catalog; 
-- ----------------------------------------------------------------------------------------------
COMMENT ON DATABASE db_k IS 'Прототип базы. Ядро 2.0 от 2018-12-14. (Hg Ревизия 78)';
-- 
CREATE EXTENSION adminpack SCHEMA pg_catalog;
COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';
--
CREATE EXTENSION hstore SCHEMA public;
COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';
--
CREATE EXTENSION pg_buffercache SCHEMA public;
COMMENT ON EXTENSION pg_buffercache IS 'examine the shared buffer cache';
--
CREATE EXTENSION pgcrypto SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
--
CREATE EXTENSION dblink SCHEMA public;
COMMENT ON EXTENSION plpgsql IS 'DB <-> DB connect ';
--
CREATE EXTENSION "uuid-ossp" SCHEMA public;
COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
--
CREATE EXTENSION xml2 SCHEMA public;
COMMENT ON EXTENSION xml2 IS 'XPath querying and XSLT';
