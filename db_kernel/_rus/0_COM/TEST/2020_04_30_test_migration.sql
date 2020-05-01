--
-- 2020-04-30 Убираю ссылки
--
SELECT * FROM f_show_fk_descr (
   	   p_ref_schema_name := 'com'   -- Наименование родительской схемы
      ,p_ref_table_name  := 'com_log'   -- Наименование родительской таблицы
	 ); 
--
ALTER TABLE com.obj_codifier DROP CONSTRAINT fk_obj_codifier_can_has_com_log;
ALTER TABLE com.com_obj_nso_relation DROP CONSTRAINT fk_com_obj_nso_relation_hase_com_log;
ALTER TABLE com.exn_obj_relation DROP CONSTRAINT fk_exn_obj_relation_hase_com_log;
ALTER TABLE com.nso_domain_column_hist DROP CONSTRAINT fk_nso_domain_column_hist_hase_com_log;
ALTER TABLE com.obj_codifier DROP CONSTRAINT fk_obj_codifier_can_has_com_log;
ALTER TABLE com.obj_codifier_hist DROP CONSTRAINT fk_obj_codifier_hist_has_com_log;
ALTER TABLE com.obj_object DROP CONSTRAINT fk_obj_object_can_have_com_log;
ALTER TABLE com.obj_object_hist DROP CONSTRAINT fk_obj_object_hist_hase_com_log;
ALTER TABLE com.com_log_1 ALTER COLUMN schema_name SET DEFAULT 'com';
--
ALTER TABLE com.nso_domain_column
   ADD CONSTRAINT fk_nso_domain_column_can_have_com_log_1 FOREIGN KEY (id_log)
      REFERENCES com.all_log_1 (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
	  -- ERROR:  ОШИБКА:  в целевой внешней таблице "all_log_1" нет ограничения уникальности, соответствующего данным ключам
DROP TABLE IF EXISTS com.all_log CASCADE;
--------------------------------------------------------------------
-- ЗАМЕЧАНИЕ:  удаление распространяется на ещё 3 объекта
-- ПОДРОБНОСТИ:  удаление распространяется на объект таблица com_log
-- удаление распространяется на объект таблица nso_log
-- удаление распространяется на объект представление x_log_1
-- DROP TABLE
--
SELECT * FROM f_show_fk_descr (
   	   p_ref_schema_name := 'nso'   -- Наименование родительской схемы
      ,p_ref_table_name  := 'nso_log'   -- Наименование родительской таблицы
	 ); 
--
-- 2020-04-30 Секционирование наследованиением (заготовки)
--
DROP TABLE obj_object_0;
DROP TABLE obj_object_1;

CREATE TABLE com.obj_object_0 (
)inherits (obj_object);

COMMENT ON TABLE com.obj_object_0 IS 'Обобщённое описание объекта. Секция №0';
--
CREATE TABLE com.obj_object_1 (
)inherits (obj_object);

COMMENT ON TABLE com.obj_object_1 IS 'Обобщённое описание объекта. Секция №1';	 
--
-- Историческая таблица.
--
DROP TABLE IF EXISTS com.obj_object_hist CASCADE;
/*==============================================================*/
/* Table: obj_object_hist                                       */
/*==============================================================*/
CREATE TABLE com.obj_object_hist (
   object_id            public.id_t         NOT NULL,
   parent_object_id     public.id_t         NULL,
   object_type_id       public.id_t         NOT NULL,
   object_stype_id      public.id_t             NULL,  -- 2015-11-16 Nick
   object_short_name    public.t_str60          NULL,
   object_uuid          public.t_guid       NOT NULL,
   object_create_date   public.t_timestamp  NOT NULL,
   object_mod_date      public.t_timestamp  NULL,
   object_read_date     public.t_timestamp  NULL,
   object_deact_date    public.t_timestamp  NULL,    -- Nick 2017-12-10
   object_secret_id     public.id_t         NOT NULL,
   object_owner_id      public.id_t         NULL,    -- Nick 2017-02-18
   object_owner1_id     public.t_guid       NULL,    -- Nick 2017-11-16/2017-12-18
   id_log               public.id_t         NULL
);

COMMENT ON TABLE com.obj_object_hist IS 'Обобщённое описание объекта. История';

COMMENT ON COLUMN com.obj_object_hist.object_id          IS 'Идентификатор объекта';
COMMENT ON COLUMN com.obj_object_hist.parent_object_id   IS 'Идентификатор родительского объекта';
COMMENT ON COLUMN com.obj_object_hist.object_type_id     IS 'Идентификатор типа объекта';
COMMENT ON COLUMN com.obj_object_hist.object_stype_id    IS 'Идентификатор типа объекта-потомка (подтип)';
COMMENT ON COLUMN com.obj_object_hist.object_short_name  IS 'Краткое наименование объекта';
COMMENT ON COLUMN com.obj_object_hist.object_uuid        IS 'UUID объекта';
COMMENT ON COLUMN com.obj_object_hist.object_create_date IS 'Дата создания';
COMMENT ON COLUMN com.obj_object_hist.object_mod_date    IS 'Дата последнего изменения';
COMMENT ON COLUMN com.obj_object_hist.object_read_date   IS 'Дата последнего просмотра';
COMMENT ON COLUMN com.obj_object_hist.object_deact_date  IS 'Дата деактивации объекта';
COMMENT ON COLUMN com.obj_object_hist.object_owner_id    IS 'Создатель/Модификатор объекта';
COMMENT ON COLUMN com.obj_object_hist.object_owner1_id   IS 'Организация-Владелец';
COMMENT ON COLUMN com.obj_object_hist.object_secret_id   IS 'Гриф секретности';
COMMENT ON COLUMN com.obj_object_hist.id_log             IS 'Идентификатор журнала';

ALTER TABLE com.obj_object_hist ADD CONSTRAINT pk_obj_object_hist PRIMARY KEY (object_id);

/*==============================================================*/
/* Index: ak1_obj_object                                         */
/*==============================================================*/
CREATE UNIQUE INDEX ak1_obj_object_hist ON com.obj_object_hist (object_uuid);
-- 2017-02-23 Nick
/*==============================================================*/
/* Index: ie1_obj_object                                        */
/*==============================================================*/
CREATE INDEX ie1_obj_object_hist ON  com.obj_object_hist (object_owner_id);
CREATE INDEX ie2_obj_object_hist ON  com.obj_object_hist (object_owner1_id);
--
--  2017-12-01 Nick Дополнительные индексы.
--  
CREATE INDEX ie3_obj_object_hist ON com.obj_object_hist ( object_type_id );
CREATE INDEX ie4_obj_object_hist ON com.obj_object_hist ( object_create_date, object_mod_date, object_read_date );
