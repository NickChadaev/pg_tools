/*=========================================================================== */
/* DBMS name:      PostgreSQL 8                                               */
/* Created on:     10.02.2015 18:25:11                                        */
/*    2015-03-21 Появился частичный индекс на кратком коде                    */
/*    29.03.2015 18:19:37 Добавлен объект                                     */
/*    28.04.2015 Изменена иерархия объектов                                   */
/* -------------------------------------------------------------------------- */                                                               
/* 2015-05-28:  Добавлены атрибуты в Кодификатор                              */                                                                
/*    Дата создания              date_create                                  */        
/*    Дата начала актуальности   date_from                                    */
/*    Дата конца актуальности    date_to                                      */
/*    UUID                       codif_uuid                                   */
/*              Добавлена nso_domain_column                                   */ 
/* -------------------------------------------------------------------------  */
/* Nick 2015-10-02 Добавлена таблица "Конфигурация ПТК"                       */
/* -------------------------------------------------------------------------- */
/* 2016-11-07 Nick  Общая последовательность для исторических таблиц и LOG.   */
/*      Все LOG таблицы наследуют от "ALL_LOG".                               */
/* 2017-12-10 Nick  Мелкие доделки. Удаление DEFAULT в исторических таблицах. */
/* 2019-05-23 Nick  Новое ядро                                                */
/*============================================================================*/

SET search_path=com, public, pg_catalog;
/*==============================================================*/
/* Table: nso_domain_column_hist                                */
/*==============================================================*/
ALTER TABLE com.nso_domain_column_hist ALTER COLUMN attr_id          DROP DEFAULT;
ALTER TABLE com.nso_domain_column_hist ALTER COLUMN attr_create_date DROP DEFAULT;
ALTER TABLE com.nso_domain_column_hist ALTER COLUMN is_intra_op      DROP DEFAULT;
ALTER TABLE com.nso_domain_column_hist ALTER COLUMN date_from        DROP DEFAULT;
ALTER TABLE com.nso_domain_column_hist ALTER COLUMN date_to          DROP DEFAULT;

/*==============================================================*/
/* Index: ak1_domain_hist                                       */
/*==============================================================*/
create unique index ak1_domain_hist on nso_domain_column_hist (
attr_id,
id_log
);

/*==============================================================*/
/* Index: ie1_domain_hist                                       */
/*==============================================================*/
create  index ie1_domain_hist on nso_domain_column_hist (
date_from
);
--
comment on column nso_domain_column_hist.attr_id is
'Идентификатор атрибута';

comment on column nso_domain_column_hist.parent_attr_id is
'Идентификатор родительского атрибута';

comment on column nso_domain_column_hist.attr_type_id is
'Тип атрибута';

comment on column nso_domain_column_hist.small_code is
'Краткий код типа атрибута';

comment on column nso_domain_column_hist.attr_uuid is
'UUID атрибута';

comment on column nso_domain_column_hist.attr_create_date is
'Дата создания';

comment on column nso_domain_column_hist.is_intra_op is
'Признак итраоперабельности';

comment on column nso_domain_column_hist.attr_code is
'Код атрибута';

comment on column nso_domain_column_hist.attr_name is
'Наименование атрибута';

comment on column nso_domain_column_hist.domain_nso_id is
'Идентификатор НСО домена';

comment on column nso_domain_column_hist.date_from is
'Дата начала актуальности';

comment on column nso_domain_column_hist.date_to is
'Дата конца актуальности';

comment on column nso_domain_column_hist.id_log is
'Идентификатор журнала';

-- /*==============================================================*/
-- /* Table: obj_object_hist                                       */
-- /*==============================================================*/
-- 
-- ALTER TABLE com.obj_object_hist ALTER COLUMN object_id          DROP DEFAULT;
-- ALTER TABLE com.obj_object_hist ALTER COLUMN object_create_date DROP DEFAULT;
-- 
-- comment on column obj_object_hist.object_id is
-- 'Идентификатор объекта';
-- 
-- comment on column obj_object_hist.parent_object_id is
-- 'Идентификатор родительского объекта';
-- 
-- comment on column obj_object_hist.object_type_id is
-- 'Идентификатор типа объекта';
-- 
-- comment on column obj_object_hist.object_uuid is
-- 'UUID объекта';
-- 
-- comment on column obj_object_hist.object_create_date is
-- 'Дата создания';
-- 
-- comment on column obj_object_hist.object_mod_date is
-- 'Дата последнего изменения';
-- 
-- comment on column obj_object_hist.object_read_date is
-- 'Дата последнего просмотра';
-- 
-- -- 2017-12-10
-- COMMENT ON COLUMN com.obj_object_hist.object_deact_date IS 'Дата деактивации объекта';
-- 
-- comment on column obj_object_hist.object_owner_id is
-- 'Владелец';
-- 
-- comment on column obj_object_hist.object_secret_id is
-- 'Гриф секретности';
-- 
-- comment on column obj_object_hist.id_log is
-- 'Идентификатор журнала';
-- 
/*==============================================================*/
/* Table: obj_codifier_hist                                     */
/*==============================================================*/

ALTER TABLE com.obj_codifier_hist ALTER COLUMN codif_id    DROP DEFAULT;
ALTER TABLE com.obj_codifier_hist ALTER COLUMN create_date DROP DEFAULT;
ALTER TABLE com.obj_codifier_hist ALTER COLUMN date_from   DROP DEFAULT;
ALTER TABLE com.obj_codifier_hist ALTER COLUMN date_to     DROP DEFAULT;

comment on column obj_codifier_hist.codif_id is
'Идентификатор экземпляра';

comment on column obj_codifier_hist.parent_codif_id is
'Идентификатор родителя';

comment on column obj_codifier_hist.small_code is
'Краткий код';

comment on column obj_codifier_hist.codif_code is
'Код';

comment on column obj_codifier_hist.codif_name is
'Наименование';

comment on column obj_codifier_hist.create_date is
'Дата создания';

comment on column obj_codifier_hist.date_from is
'Дата начала актуальности';

comment on column obj_codifier_hist.date_to is
'Дата конца актуальности';

comment on column obj_codifier_hist.codif_uuid is
'UUID';

comment on column obj_codifier_hist.id_log is
'Идентификатор журнала';

-- --
-- -- 2015-10-02
-- --
-- /*==============================================================*/
-- /* Table: com_log                                               */
-- /*==============================================================*/
-- -- Добавлены воздействия D и E --
-- -- Добавлены воздействия F и G -- 2016-01-26 Gregory
-- 
-- ALTER TABLE com.com_log DROP CONSTRAINT IF EXISTS chk_com_log_impact_type;
-- ALTER TABLE com.com_log ADD CONSTRAINT chk_com_log_impact_type 
--             CHECK ( 
--                        impact_type = '0' -- создание записи в кодификаторе
--                     OR impact_type = '1' -- удаление записи в кодификаторе
--                     OR impact_type = '2' -- обновление данных в кодификаторе
--                     ---------------------------------------------------------- 
--                     OR impact_type = '3' -- создание атрибута в домене.
--                     OR impact_type = '4' -- удаление атрибута из домена 
--                     OR impact_type = '5' -- обновление атрибута в домене .
--                     ---------------------------------------------------------- 
--                     OR impact_type = '6' -- создание  объекта
--                     OR impact_type = '7' -- обновление объекта
--                     OR impact_type = 'Q' -- обновление объекта с изменением уровня секретности  -- Nick 2017-02-08
--                     OR impact_type = '8' -- удаление объекта.
--                     OR impact_type = '9' -- создание записи в конфигурации
--                     ---------------------------------------------------------- 
--                     OR impact_type = 'A' -- обновление записи в  конфигурации  2015-10-02  Nick
--                     OR impact_type = 'B' -- удаление записи в конфигурации
--                     OR impact_type = 'C' -- установка текущей конфигурации
--                     ----------------------------------------------------------
--                     OR impact_type = 'D' -- экспорт ветви кодификатора в XML
--                     OR impact_type = 'E' -- импорт ветви кодификатора из XML
--                     ----------------------------------------------------------
--                     OR impact_type = 'F' -- экспорт ветви домена колонки в XML 2016-01-26 Gregory
--                     OR impact_type = 'G' -- импорт ветви домена колонки из XML
--                     ----------------------------------------------------------
--                     OR impact_type = 'N' -- Выключение текущего ПТК
--                     OR impact_type = 'H' -- Установка текущего ПТК
--                     OR impact_type = 'I' -- Создание нового ПТК
--                     OR impact_type = 'J' -- Обновление ПТК
--                     OR impact_type = 'K' -- Удаление ПТК
--                     OR impact_type = 'L' -- Экспорт ПТК
--                     OR impact_type = 'M' -- Импорт ПТК
-- );
-- 
-- CREATE INDEX ie1_com_log ON com.com_log ( impact_date, impact_type );
-- -- CREATE INDEX ie2_com_log ON com.com_log ( user_name );
-- 
-- ALTER TABLE com.com_log ADD CONSTRAINT ak2_com_log UNIQUE ( id_log );
-- --
-- ALTER TABLE com.com_log ALTER COLUMN schema_name SET DEFAULT 'COM'; 
-- ALTER TABLE com.com_log ALTER COLUMN id_log SET DEFAULT nextval('com.all_history_id_seq'::regclass) 
-- 
-- -- SELECT impact_type, impact_descr FROM com.com_log WHERE impact_type = 'D' OR impact_type = 'E';
-- -- "D";"Экспорт ветви кодивикатора "C_IND_TYPE" в XML."
-- -- "E";"Импорт ветви кодификатора "C_IND_TYPE" из XML."

