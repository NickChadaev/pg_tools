-- ==================================================================== 
--  Создание схем.
-- --------------------------------------------------------------------
--  2015-03-18 Nick
--  2015-06-26 Nick - Добавлена схема DRC.
--  2015-07-27 Nick - Добавлена схема UIO.
--  2016-07-20 Nick - Подсистема сбора данных 
--  2017-09-01 Nick - Добавлена схема UTL - вспомогательный функционал
--  2018-12-14 Nick - Новое деление на схемы
-- ====================================================================
-- 0
CREATE SCHEMA com;
COMMENT ON SCHEMA com IS 'Общие данные'; 
--
CREATE SCHEMA com_codifier;
COMMENT ON SCHEMA com_codifier IS 'Общие данные. Функции для кодификатора'; 
--
CREATE SCHEMA com_domain;
COMMENT ON SCHEMA com_domain IS 'Общие данные. Функции для домена колонок'; 
--
CREATE SCHEMA com_object;
COMMENT ON SCHEMA com_object IS 'Общие данные. Функции для объектов'; 
--
CREATE SCHEMA com_relation;
COMMENT ON SCHEMA com_relation IS 'Общие данные. Функции для отношений между объектами'; 
--
CREATE SCHEMA com_error;
COMMENT ON SCHEMA com_error IS 'Общие данные. Функции обработки ошибок'; 
--
CREATE SCHEMA com_exchange;
COMMENT ON SCHEMA com_exchange IS 'Общие данные. Функции обмена'; 
--
-- 1
CREATE SCHEMA nso;
COMMENT ON SCHEMA nso IS 'Нормативно-справочная информация'; 
--
CREATE SCHEMA nso_structure;
COMMENT ON SCHEMA nso_structure IS 'Нормативно-справочная информация. Функции управляющие структурой'; 
--
CREATE SCHEMA nso_data;
COMMENT ON SCHEMA nso_data IS 'Нормативно-справочная информация. Функции управляющие данными'; 
--
CREATE SCHEMA nso_exchange;
COMMENT ON SCHEMA nso_exchange IS 'Нормативно-справочная информация. Функции обмена'; 
--
-- 2
CREATE SCHEMA ind;
COMMENT ON SCHEMA ind IS 'Показатели'; 
--
CREATE SCHEMA ind_structure;
COMMENT ON SCHEMA ind_structure IS 'Показатели. Функции управляющие структурой'; 
--
CREATE SCHEMA ind_data;
COMMENT ON SCHEMA ind_data IS 'Показатели. Функции управляющие данными'; 
--
CREATE SCHEMA ind_exchange;
COMMENT ON SCHEMA ind_exchange IS 'Показатели. Функции обмена'; 
--
-- 3  -- Nick 2015-07-27
CREATE SCHEMA uio;
COMMENT ON SCHEMA uio IS 'Обмен данными'; 
--
-- 4
CREATE SCHEMA auth;
COMMENT ON SCHEMA auth IS 'Управление доступом к объектам'; 
--
CREATE SCHEMA auth_serv_obj;
COMMENT ON SCHEMA auth_serv_obj IS 'Управление доступом к объектам. Функции для серверных объектов'; 
--
CREATE SCHEMA auth_apr;
COMMENT ON SCHEMA auth_apr IS 'Управление доступом к объектам. Функции для прикладных ролей'; 
--
CREATE SCHEMA auth_exchange;
COMMENT ON SCHEMA auth_exchange IS 'Управление доступом к объектам. Функции обмена'; 
--
-- 5
CREATE SCHEMA db_info;
COMMENT ON SCHEMA db_info IS 'Информация о БД'; 
--
-- 6
CREATE SCHEMA utl;
COMMENT ON SCHEMA utl IS 'Вспомогательный функционал';


