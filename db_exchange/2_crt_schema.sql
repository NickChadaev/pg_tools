﻿-- ===================================================================================================== 
--  Создание схем.
-- -----------------------------------------------------------------------------------------------------
--  2015-03-18 Nick
--  2018-12-14 Nick - Новое деление на схемы
--  2020-08-14 Nick - Единый скрипт разделяется на части, для каждой функциональной группы - свой скрипт
--  2020-11-14 Nick - Дополнительные функциональные схемы.
-- =======================================================================================================
-- 
DROP SCHEMA IF EXISTS uio CASCADE;
CREATE SCHEMA uio;
COMMENT ON SCHEMA uio IS 'Обмен данными'; 
--
DROP SCHEMA IF EXISTS uio_pgq CASCADE;
CREATE SCHEMA uio_pgq;
COMMENT ON SCHEMA uio_pgq IS 'Функции, обеспечивающие взаимодействие с PGQ';
--
DROP SCHEMA IF EXISTS uio_func CASCADE;
CREATE SCHEMA uio_func;
COMMENT ON SCHEMA uio_func IS 'Обменные функции общего назначения';
