/* ========================================================================= */
/*  DBMS name:      PostgreSQL 8                                             */
/*  Created on:     20.04.2015 19:11:22                                      */
/*    2015-05-29  тип t_timestampz заменён на public.t_timestamp             */
/*         заменены значения по умолчанию  и правятся функции                */ 
/*  ------------------------------------------------------------------------ */
/*   2015-07-03  Добавлены группа и клиентские объекты.                      */
/*  ------------------------------------------------------------------------ */
/*  Новая генерация схемы: 21.07.2015 16:46:18                               */
/*  ------------------------------------------------------------------------ */
/*  Новая генерация схемы: 06.08.2015                                        */ 
/*  2015-08-25     Добавлены ограничения на доступ к данным.                 */
/*  2015-09-26     constraint ak1_auth_server_object                         */
/*     UNIQUE (auth_server_object_code, auth_schema, parent_serv_object_id)  */
/* ------------------------------------------------------------------------- */
/*  2015-10-03 Roman:  Удалены таблицы: auth_role_perm_serv_object,          */ 
/*                                      auth_role_perm_serv_object_hist      */  
/*  Cоответствие LOGIN,  роли, матрицы прав доступа к серверному объекту     */
/*  auth_role_perm_serv_object - Роль и разрешение для серверного объекта    */
/*  cтала единой таблицей, объединяющей роль, серверный объект и разрешение. */ 
/*  ------------------------------------------------------------------------ */
/*  Nick:  По такой-же схеме сделана модификация клиетской части.            */
/*  ------------------------------------------------------------------------ */
/*  2015-10-21 Roman:  Введена таблица auth_log_data                         */ 
/*                Из auth_log удаляются IMPACT_TYPE, IMPACT_DESCR            */
/*  ------------------------------------------------------------------------ */
/*  2015-11-02 Roman:  Изменения типов воздействия для таблицы данных        */
/*                                    логирования                            */
/* ------------------------------------------------------------------------- */
/* 2015-12-15 Roman:  Rev 1355. Добавлены атрибуты user_login в auth_user,   */
/*                                       role_name в auth_role               */ 
/* ------------------------------------------------------------------------- */
/* 2015-12-30 Roman:   Добавлен новый тип воздействия Отзыв привилегий       */
/* ------------------------------------------------------------------------- */
/* 2016-03-09 Roman:   Из исторической таблицы auth_user_hist удалены поля   */
/*                     связи пользователя с ролями                           */
/*                     Добавлена историческая таблица auth_user_role_hist    */
/* ------------------------------------------------------------------------- */
/* 2016-03-10 Roman:   В исторической таблице auth_user_hist                 */
/*                     значения атрибутов системной роли могут быть нулевыми */
/*                     в случае отсутствия системной роли.                   */
/*                     В исторической таблице auth_role_hist аналогично      */
/* ------------------------------------------------------------------------- */
/*  Created on:     30.07.2016 19:18:23   Nick                               */
/* ------------------------------------------------------------------------- */
/*  2016-08-08  Nick атрибут "date_update" ->  "date_update_use"             */
/*            Новый атрибут used  boolean_t DEFAULT FALSE                    */
/* --------------------------------------------------------------------------*/
/* 2016-11-12 Nick  Новая версия журнала auth_log_1,                         */
/*                        старую структуру постепенно выводим из работы      */
/* --------------------------------------------------------------------------*/
/* 2016-12-30 Nick  Убраны группы: "auth_group", "auth_group_role",          */
/*                  "auth_group_role_hist" изменён перечень событий          */
/*           DROP TABLE IF EXISTS auth_group CASCADE;                        */
/*           DROP TABLE IF EXISTS auth_group_role CASCADE;                   */
/*           DROP TABLE IF EXISTS auth_group_role_hist CASCADE;              */
/* ------------------------------------------------------------------------- */
/* 2017-01-03 Nick  Убраны старые таблицы, ограничиывющие доступ к данным.   */
/*             "auth_role_data_access_perm", "auth_data_types_access_perm",  */
/*             "auth_data_access_perm", "auth_data_access_perm_hist"         */
/* ------------------------------------------------------------------------- */
/*          DROP TABLE IF EXISTS auth_role_data_access_perm CASCADE;         */
/*          DROP TABLE IF EXISTS auth_data_types_access_perm  CASCADE;       */
/*          DROP TABLE IF EXISTS auth_data_access_perm  CASCADE;             */
/*          DROP TABLE IF EXISTS auth_data_access_perm_hist CASCADE;         */
/* ------------------------------------------------------------------------- */
/* 2017-0103 Nick Исторические таблицы: "auth_user_hist", "auth_role_hist"   */
/*        , "auth_user_role_hist", "auth_server_object_perm_hist"            */ 
/*        , "auth_client_object_perm_hist"                                   */
/*          используют общую последовательность "com.all_history_id_seq"     */ 
/*                Выполнить скрипт "x_auth_alt_tbl_2.sql"                    */ 
/* ------------------------------------------------------------------------- */
/* 2017-01-25 Nick Impact_descr t_text, LOG_DATA - "com.all_history_id_seq"  */
/* ------------------------------------------------------------------------- */
/* 2017-02-14 Nick ur_upd_date опциональная, допускаются NULL                */
/* ------------------------------------------------------------------------- */
/* 2018-01-18 Nick  Нет собственных атрибутов у LOG-таблиц-наследников.      */
/* ==========================================================================*/
SET search_path=auth,nso,com,public,pg_catalog;

DROP TABLE IF EXISTS auth.auth_log_1 CASCADE;
/*==============================================================*/
/* Table: auth.auth_log_1                                       */
/*==============================================================*/
create table auth.auth_log_1 (
   -- auth_id_log  BIGSERIAL   not NULL -- 2018-01-18 Nick
) inherits (com.all_log);

comment on table auth.auth_log_1 is
'Журнал учёта изменений, новая версия.';

/*==============================================================*/
/* Table: auth_perm_serv_object REMOVED ONLY                    */
/*==============================================================*/
DROP TABLE IF EXISTS auth.auth_perm_serv_object CASCADE;
DROP SEQUENCE IF EXISTS auth.auth_perm_serv_object_perm_serv_object_id_seq;

/*==============================================================*/
/* Table: auth_user                                             */
/*==============================================================*/
DROP TABLE IF EXISTS auth.auth_user CASCADE;
DROP SEQUENCE IF EXISTS auth.auth_user_user_id_seq;

CREATE SEQUENCE auth.auth_user_user_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE auth.auth_user (
   user_id		         public.id_t		NOT NULL DEFAULT nextval('auth_user_user_id_seq'::regclass),
   system_oid	         oid			NULL,
   user_login           public.t_sysname    NOT NULL,    -- 2015-12-15 Roman
   date_create	         public.t_timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
   date_update	         public.t_timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
   succsessfully_auth	public.t_boolean	  NOT NULL DEFAULT false,
   last_auth_date	      public.t_timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
   group_id		         public.id_t		         NULL,
   ind_perm		         public.t_boolean    NOT NULL DEFAULT true,
   user_employe_id	   public.id_t	        NOT NULL,
   low_level_id		   public.id_t	        NOT NULL,
   high_level_id	      public.id_t	        NOT NULL,
   id_log		         public.id_t	            NULL
);
-- -----------------------------------------------
COMMENT ON TABLE auth.auth_user IS
'Пользователь';

COMMENT ON COLUMN auth.auth_user.user_id IS
'Идентификатор пользователя';

COMMENT ON COLUMN auth.auth_user.system_oid IS
'Системный OID';

COMMENT ON COLUMN auth.auth_user.user_login IS    -- Roman 2015-12-15
'Логин пользователя';

COMMENT ON COLUMN auth.auth_user.date_create IS
'Дата создания';

COMMENT ON COLUMN auth.auth_user.date_update IS
'Дата обновления';

COMMENT ON COLUMN auth.auth_user.succsessfully_auth IS
'Признак успешной аутентификации';

COMMENT ON COLUMN auth.auth_user.last_auth_date IS
'Дата последней аутентификации';

COMMENT ON COLUMN auth.auth_user.group_id IS
'Идентификатор группы';

COMMENT ON COLUMN auth.auth_user.ind_perm IS
'Индивидуальные права';

COMMENT ON COLUMN auth.auth_user.user_employe_id IS
'Идентификатор сотрудника';

COMMENT ON COLUMN auth.auth_user.low_level_id IS
'Идентификатор низшего уровня секретности';

COMMENT ON COLUMN auth.auth_user.high_level_id IS
'Идентификатор высшего уровня секретности';

COMMENT ON COLUMN auth_user.id_log IS
'Идентификатор журнала';
-- ------------------------------------------------
--

ALTER TABLE auth.auth_user
  ADD CONSTRAINT pk_auth_user PRIMARY KEY (user_id);

ALTER TABLE auth.auth_user
  ADD CONSTRAINT ak1_auth_user UNIQUE (user_login); -- 2015-12-15 Roman

ALTER SEQUENCE auth.auth_user_user_id_seq
  OWNED BY auth.auth_user.user_id;

/*==============================================================*/
/* Table: auth_user_hist                                        */
/*==============================================================*/
DROP TABLE IF EXISTS auth.auth_user_hist CASCADE;
CREATE TABLE auth.auth_user_hist (
   user_hist_id         public.id_t             NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'::regclass), -- Nick 2017-01-03
   date_from            public.t_timestamp      NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,     
   date_to              public.t_timestamp      NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone, 
   id_log               public.id_t             NOT NULL,
   --
   user_id              public.id_t             NOT NULL,
   user_login           public.t_sysname        NOT NULL,
   -- Nick 2016-03-11 DROP NOT NULL
   user_password        public.t_text           NULL,       -- Roman
   group_id             public.id_t             NULL,       -- Эти значения могут быть нулевыми 
   user_reg_date        public.t_timestamp      NULL,       -- в случае отсутствия системной роли
   passwd_until_date    public.t_timestamp      NULL,       -- 
   -- Nick 2016-03-11 DROP NOT NULL
   user_is_blocked      public.t_boolean        NOT NULL,
   user_time_logout     public.t_int            NOT NULL,
   user_block_until     public.t_timestamp      NULL,
   user_block_reason    public.t_text           NULL,
   user_qty_try_conn    public.small_t          NOT NULL,
   user_employe_id      public.id_t             NOT NULL,
   ind_perm             public.t_boolean        NOT NULL,
   low_level_id         public.id_t             NOT NULL,
   high_level_id        public.id_t             NOT NULL 
   -- Nick 2016-03-11 DROP ur_....
--   ur_role_id           public.id_t             NOT NULL,
--   ur_init_role_id      public.id_t             NOT NULL,
--   is_active            public.t_boolean        NOT NULL,
--   ur_reg_date          public.t_timestamp      NOT NULL,
--   ur_upd_date          public.t_timestamp      NULL,
--   ur_descr             public.t_fullname       NULL
);

COMMENT ON TABLE auth.auth_user_hist IS
'Пользователь, история изменений';

COMMENT ON COLUMN auth.auth_user_hist.user_hist_id IS
'Идентификатор истории изменений';

COMMENT ON COLUMN auth.auth_user_hist.date_from IS
'Начало интервала актуальности';

COMMENT ON COLUMN auth.auth_user_hist.date_to IS
'Конец интервала актуальности';

COMMENT ON COLUMN auth.auth_user_hist.id_log IS
'Идентификатор журнала';
-- --------------------------------------------------
COMMENT ON COLUMN auth.auth_user_hist.user_id IS
'Идентификатор пользователя';

COMMENT ON COLUMN auth.auth_user_hist.user_login IS
'LOGIN пользователя';

COMMENT ON COLUMN auth.auth_user_hist.user_password IS
'Пароль пользователя';

COMMENT ON COLUMN auth.auth_user_hist.group_id IS
'Идентификатор группы';

COMMENT ON COLUMN auth.auth_user_hist.user_reg_date IS
'Дата регистрации пользователя';

COMMENT ON COLUMN auth.auth_user_hist.passwd_until_date IS
'Дата окончания действия пароля';

COMMENT ON COLUMN auth.auth_user_hist.user_is_blocked IS
'Признак заблокированного пользователя';

COMMENT ON COLUMN auth.auth_user_hist.user_time_logout IS
'Допустимое время неактивности';

COMMENT ON COLUMN auth.auth_user_hist.user_block_until IS
'Дата окончания блокировки';

COMMENT ON COLUMN auth.auth_user_hist.user_block_reason IS
'Причина блокировки';

COMMENT ON COLUMN auth.auth_user_hist.user_qty_try_conn IS
'Количество возможных  неуспешных попыток соединения';

COMMENT ON COLUMN auth.auth_user_hist.user_employe_id IS
'Идентификатор сотрудника';

COMMENT ON COLUMN auth.auth_user_hist.ind_perm IS
'Индивидуальные права';

COMMENT ON COLUMN auth.auth_user_hist.low_level_id IS
'Идентификатор низшего уровня секретности';

COMMENT ON COLUMN auth.auth_user_hist.high_level_id IS
'Идентификатор высшего уровня секретности';
-- 
-- Nick 2016-03-11 DROP NOT NULL
-- ----------------------------------------------
-- COMMENT ON COLUMN auth.auth_user_hist.ur_role_id IS 
-- 'Идентификатор роли';
-- 
-- COMMENT ON COLUMN auth.auth_user_hist.ur_init_role_id IS 
-- 'Идентификатор начальной_роли';
-- 
-- COMMENT ON COLUMN auth.auth_user_hist.is_active IS 
-- 'Признак активности связи';
-- 
-- COMMENT ON COLUMN auth.auth_user_hist.ur_reg_date IS 
-- 'Дата создания связи';
-- 
-- COMMENT ON COLUMN auth.auth_user_hist.ur_upd_date IS 
-- 'Дата обновления связи';
-- 
-- COMMENT ON COLUMN auth.auth_user_hist.ur_descr IS 
-- 'Описание связи';
--
-- ----------------------------------------------
--
ALTER TABLE auth.auth_user_hist
  ADD CONSTRAINT pk_auth_user_hist PRIMARY KEY (user_hist_id);

/*==============================================================*/
/* Table: auth_log                                              */
/*==============================================================*/
DROP TABLE IF EXISTS auth.auth_log CASCADE;
CREATE TABLE auth_log (
   id_log               public.id_t                 NOT NULL DEFAULT NEXTVAL ('all_history_id_seq'::regclass), -- Nick 2017-01-25
   user_name            public.t_str250             NOT NULL,
   host_name            public.t_str250             NOT NULL,
   impact_date          public.t_timestamp          NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone
);

COMMENT ON TABLE auth.auth_log IS 
'Журнал изменений';

COMMENT ON COLUMN auth.auth_log.id_log IS 
'Идентификатор журнала';

COMMENT ON COLUMN auth.auth_log.user_name IS 
'Имя пользователя';

COMMENT ON COLUMN auth.auth_log.host_name IS 
'Имя хоста';

COMMENT ON COLUMN auth.auth_log.impact_date IS 
'Дата воздействия';

ALTER TABLE auth.auth_log
  ADD CONSTRAINT pk_auth_log PRIMARY KEY (id_log);

/*==============================================================*/
/* Index: ie1_auth_log                                          */
/*==============================================================*/
CREATE INDEX ie1_auth_log ON auth.auth_log (
user_name
);

-- ----------------
-- 2015-10-21 Nick
-- ----------------
/*==============================================================*/
/* Table: auth_log_data                                         */
/*==============================================================*/
DROP TABLE IF EXISTS auth.auth_log_data CASCADE;
DROP SEQUENCE IF EXISTS auth.auth_log_data_data_log_id_seq;

CREATE SEQUENCE auth.auth_log_data_data_log_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE auth.auth_log_data (
   data_log_id          id_t                 NOT NULL DEFAULT NEXTVAL('auth_log_data_data_log_id_seq'),
   id_log               id_t                 NOT NULL,
   impact_type          t_code1              NOT NULL,
   impact_descr         t_text               NOT NULL    -- Nick 2017-01-25
);

COMMENT ON TABLE auth.auth_log_data IS
'Журнал изменений - данные';

COMMENT ON COLUMN auth.auth_log_data.data_log_id IS
'Журнал, данные ID';

COMMENT ON COLUMN auth.auth_log_data.id_log IS
'Идентификатор журнала';

COMMENT ON COLUMN auth.auth_log_data.impact_type IS
'Тип воздействия';

COMMENT ON COLUMN auth.auth_log_data.impact_descr IS
'Описание воздействия';

-- ------------------------------------------------
-- 2015-10-25 Роман -- Второй вариант
-- 2016-12-29 Timur -- Третий вариант
-- ------------------------------------------------
ALTER TABLE auth.auth_log_data
  ADD  CONSTRAINT chk_auth_log_data_impact_type 
      CHECK (
	   impact_type	= '0'::public.t_code1  --  Создание пользователя.
	OR impact_type	= '1'::public.t_code1  --  Удаление пользователя.

	OR impact_type	= '2'::public.t_code1  --  Удаление связи пользователь - группа.
	OR impact_type	= '3'::public.t_code1  --  Установка связи пользователь - группа.

	OR impact_type	= '4'::public.t_code1  --  Изменение идентификатора сотрудника для пользователя.

	OR impact_type	= '5'::public.t_code1  --  Изменение минимального грифа секретности для пользователя.
	OR impact_type	= '6'::public.t_code1  --  Изменение максимального грифа секретности для пользователя.

	OR impact_type	= '7'::public.t_code1  --  Установлены индивидуальные права для системной роли пользователя
	OR impact_type	= '8'::public.t_code1  --  Отменены индивидуальные права для системной роли пользователя

	OR impact_type	= 'A'::public.t_code1  --  Добавлена строка в матрицу разрешений для серверных объектов
	OR impact_type	= 'B'::public.t_code1  --  Добавлена строка в матрицу разрешений для клиентских объектов
	OR impact_type	= 'C'::public.t_code1  --  Изменена строка в матрице разрешений для серверных объектов
	OR impact_type	= 'D'::public.t_code1  --  Изменена строка в матрице разрешений для клиентских объектов
	OR impact_type	= 'E'::public.t_code1  --  Удалена строка из матрицы разрешений для серверных объектов
	OR impact_type	= 'F'::public.t_code1  --  Удалена строка из матрицы разрешений для клиентских объектов

	OR impact_type	= 'G'::public.t_code1  --  Пользователь начал сессию
	OR impact_type	= 'H'::public.t_code1  --  Пользователь завершил сессию

	OR impact_type	= 'I'::public.t_code1  --  Изменение защищенного атрибута пользователя (блокировка, срок действия пароля, количество подключение и т.д.)
	OR impact_type	= 'J'::public.t_code1  --  Изменение защищенного атрибута роли (возможность блокирования пользователей и т.д.)

	OR impact_type	= 'M'::public.t_code1  --  Создана роль
	OR impact_type	= 'N'::public.t_code1  --  Изменение роли
	OR impact_type	= 'O'::public.t_code1  --  Удалена роль

	OR impact_type	= 'P'::public.t_code1  --  Создана связь роли - серверного объекта и рaзрешения
	OR impact_type	= 'Q'::public.t_code1  --  Изменение связи роль - серверный объект и разрешение
	OR impact_type	= 'R'::public.t_code1  --  Удаление связи роль - серверный объект и разрешение

	OR impact_type	= 'S'::public.t_code1  --  Создание серверного объекта
	OR impact_type	= 'T'::public.t_code1  --  Изменение серверного объекта
	OR impact_type	= 'U'::public.t_code1  --  Удаление серверного объекта

	OR impact_type	= 'V'::public.t_code1  --  Создание связи пользователя с начальной и эффективной ролью.
	OR impact_type	= 'W'::public.t_code1  --  Удаление связи пользователя с начальной и эффективной ролью.
	OR impact_type	= 'X'::public.t_code1  --  Изменение начальной роли пользователя.
	OR impact_type	= 'Y'::public.t_code1  --  Изменение эффективной роли пользователя.
	OR impact_type	= 'Z'::public.t_code1  --  Деактивация связи пользователя с эффективной ролью.
 
   OR impact_type  = 'и'::public.t_code1 --  Отзыв привилегий
           --
   OR impact_type = 'a'::public.t_code1 -- Экспорт пользователя в XML- документ.
   OR impact_type = 'b'::public.t_code1 -- Импорт пользователя из XML- документ.
           -- 
   OR impact_type = 'd'::public.t_code1 -- Назначены права на ОКР/СЧ ОКР для пользователя
   OR impact_type = 'f'::public.t_code1 -- Изменены права на ОКР/СЧ ОКР для пользователя
   OR impact_type = 'g'::public.t_code1 -- Отозваны права на ОКР/СЧ ОКР для пользователя
);

ALTER TABLE auth.auth_log_data
   ADD CONSTRAINT pk_auth_log_data PRIMARY KEY (data_log_id);

ALTER SEQUENCE auth.auth_log_data_data_log_id_seq 
   OWNED BY auth.auth_log_data.data_log_id;                    

/*==============================================================*/
/* Table: auth_sql_clause_log                                   */
/* Roman: RENAME COLUMN log_id TO data_log_id                   */
/*==============================================================*/
DROP TABLE IF EXISTS auth.auth_sql_clause_log CASCADE;
DROP SEQUENCE IF EXISTS auth.auth_sql_clause_log_auth_sql_id_seq CASCADE;

CREATE SEQUENCE auth.auth_sql_clause_log_auth_sql_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
CREATE TABLE auth.auth_sql_clause_log (
   auth_sql_id		public.id_t		         NOT NULL DEFAULT NEXTVAL ('auth_sql_clause_log_auth_sql_id_seq'::regclass),
   auth_create_date	public.t_timestamp	NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
   data_log_id		public.id_t		         NOT NULL,
   sql_clause		public.t_text		      NOT NULL   -- 2015-11-05 Роман
);

COMMENT ON TABLE auth.auth_sql_clause_log IS 
'Список выполненых команд';

COMMENT ON COLUMN auth.auth_sql_clause_log.auth_sql_id IS 
'Идентификатор';

COMMENT ON COLUMN auth.auth_sql_clause_log.auth_create_date IS 
'Дата создания';

COMMENT ON COLUMN auth.auth_sql_clause_log.data_log_id IS 
'Журнал, данные ID';

COMMENT ON COLUMN auth.auth_sql_clause_log.sql_clause IS 
'Выполненная команда';

ALTER TABLE auth.auth_sql_clause_log
  ADD CONSTRAINT pk_auth_sql_clause_log PRIMARY KEY (auth_sql_id);
--
ALTER SEQUENCE auth.auth_sql_clause_log_auth_sql_id_seq
  OWNED BY auth.auth_sql_clause_log.auth_sql_id;

/*==============================================================*/
/* Table: auth_role                                             */
/*==============================================================*/
DROP TABLE IF EXISTS auth.auth_role CASCADE;
DROP SEQUENCE IF EXISTS auth.auth_role_role_id_seq;

CREATE SEQUENCE auth.auth_role_role_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE auth.auth_role (
   role_id		      public.id_t		      NOT NULL DEFAULT nextval('auth_role_role_id_seq'::regclass),
   system_oid		   oid			         NULL,
   role_name		   public.t_sysname     NOT NULL,    -- 2015-12-15 Roman
   parent_role_id	   public.id_t		      NULL,
   date_create		   public.t_timestamp	NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
   date_update		   public.t_timestamp	NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
   role_description	public.t_str1024   	NULL,
   id_log		      public.id_t		      NULL
);

COMMENT ON TABLE auth.auth_role IS 'Роль';

COMMENT ON COLUMN auth.auth_role.role_id IS 
'Идентификатор роли';

COMMENT ON COLUMN auth.auth_role.system_oid IS 
'Системный OID';

COMMENT ON COLUMN auth.auth_role.role_name IS  -- 2015-12-15 Roman
'Имя роли';

COMMENT ON COLUMN auth.auth_role.parent_role_id IS 
'Идентификатор родительской роли';

COMMENT ON COLUMN auth.auth_role.date_create IS 
'Дата создания';

COMMENT ON COLUMN auth.auth_role.date_update IS 
'Дата обновления';

COMMENT ON COLUMN auth.auth_role.role_description IS 
'Описание роли';

COMMENT ON COLUMN auth.auth_role.id_log IS 
'Идентификатор журнала';

ALTER TABLE auth.auth_role
  ADD CONSTRAINT pk_auth_role PRIMARY KEY (role_id);

ALTER TABLE auth.auth_role
  ADD CONSTRAINT ak1_auth_role UNIQUE (role_name);  -- 2015-12-15 Roman

ALTER SEQUENCE auth.auth_role_role_id_seq
  OWNED BY auth.auth_role.role_id;
--
/*==============================================================*/
/* Table: auth_role_hist                                        */
/*==============================================================*/
DROP TABLE IF EXISTS auth_role_hist CASCADE;
CREATE TABLE auth_role_hist (
   role_hist_id       public.id_t           NOT NULL DEFAULT nextval('com.all_history_id_seq'::regclass), -- Nick 2017-01-03
   date_from          public.t_timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
   date_to            public.t_timestamp    NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
   id_log             public.id_t           NOT NULL,
   --
   parent_role_id     public.id_t               NULL,
   role_name          public.t_str60        NOT NULL,
   date_create        public.t_timestamp    NOT NULL,
   date_update        public.t_timestamp    NOT NULL,
   -- Nick 2016-03-11 DROP NOT NULL
   is_superuser       public.t_boolean          NULL,   -- Roman
   is_createdb        public.t_boolean          NULL,   -- Эти значения могут быть нулевыми
   is_createrole      public.t_boolean          NULL,   -- в случае отсутствия системной
   is_inherit         public.t_boolean          NULL,   -- роли
   is_replication     public.t_boolean          NULL,
   is_block           public.t_boolean          NULL,
   is_send_recieve    public.t_boolean          NULL,
      -- Nick 2016-03-11 DROP NOT NULL
   role_description   public.t_str1024          NULL 
 );

COMMENT ON TABLE auth_role_hist IS 'Роль, история изменений';

COMMENT ON COLUMN auth_role_hist.role_hist_id IS 
'Идентификатор истории роли';

COMMENT ON COLUMN auth_role_hist.date_from IS 
'Дата начала актуальности';

COMMENT ON COLUMN auth_role_hist.date_to IS 
'Дата окончания актуальности';

COMMENT ON COLUMN auth_role_hist.id_log IS 
'Идентификатор журнала';
--
COMMENT ON COLUMN auth_role_hist.parent_role_id IS 
'Идентификатор родительской роли';

COMMENT ON COLUMN auth_role_hist.role_name IS 
'Имя роли';

COMMENT ON COLUMN auth_role_hist.date_create IS 
'Дата создания роли';

COMMENT ON COLUMN auth_role_hist.date_update IS 
'Дата обновления роли';

COMMENT ON COLUMN auth_role_hist.is_superuser IS 
'Суперпользователь';

COMMENT ON COLUMN auth_role_hist.is_createdb IS 
'Создание базы';

COMMENT ON COLUMN auth_role_hist.is_createrole IS 
'Создание роли';

COMMENT ON COLUMN auth_role_hist.is_inherit IS 
'Наследование';

COMMENT ON COLUMN auth_role_hist.is_replication IS 
'Репликация';

COMMENT ON COLUMN auth_role_hist.is_block IS 
'Возможность блокирования пользователей';

COMMENT ON COLUMN auth_role_hist.is_send_recieve IS 
'Возможность приёма - передачи данных';

COMMENT ON COLUMN auth_role_hist.role_description IS 
'Описание роли';
--
ALTER TABLE auth_role_hist
   ADD CONSTRAINT pk_auth_role_hist PRIMARY KEY (role_hist_id);

/*==============================================================*/
/* Table: auth_user_role                                        */
/*==============================================================*/
DROP TABLE IF EXISTS auth.auth_user_role CASCADE;
CREATE TABLE auth.auth_user_role (
   user_id		   public.id_t		NOT NULL,
   role_id		   public.id_t		NOT NULL,
   init_role_id	public.id_t		NOT NULL,
   is_active		public.t_boolean   	NOT NULL DEFAULT false,
   ur_reg_date		public.t_timestamp	NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
   ur_upd_date		public.t_timestamp	NULL, -- NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone, Nick 2017-02-14
   ur_descr		   public.t_fullname	   NULL,
   id_log		   public.id_t		      NULL
);

COMMENT ON TABLE auth.auth_user_role IS 
'Пользователю соответствует роль, на основании этого соответствия выдаются права.';

COMMENT ON COLUMN auth.auth_user_role.user_id IS 
'Идентификатор пользователя';

COMMENT ON COLUMN auth.auth_user_role.role_id IS 
'Идентификатор роли';

COMMENT ON COLUMN auth.auth_user_role.init_role_id IS 
'Идентификатор начальной_роли';

COMMENT ON COLUMN auth.auth_user_role.is_active IS 
'Признак активности связи';

COMMENT ON COLUMN auth.auth_user_role.ur_reg_date IS 
'Дата создания связи';

COMMENT ON COLUMN auth.auth_user_role.ur_upd_date IS 
'Дата обновления связи';

COMMENT ON COLUMN auth.auth_user_role.ur_descr IS 
'Описание связи';

COMMENT ON COLUMN auth.auth_user_role.id_log IS
'Идентификатор журнала';

ALTER TABLE auth.auth_user_role
   ADD CONSTRAINT pk_auth_user_role PRIMARY KEY (user_id, role_id);

ALTER TABLE auth.auth_user_role
   ADD CONSTRAINT ak1_auth_user_role UNIQUE (user_id, is_active);

-- 2016-03-11 Nick, new table
/*==============================================================*/
/* Table: auth_user_role_hist                                   */
/*==============================================================*/
DROP TABLE IF EXISTS auth.auth_user_role_hist CASCADE;
CREATE TABLE auth.auth_user_role_hist (
   user_role_hist_id    public.id_t         NOT NULL DEFAULT nextval('com.all_history_id_seq'::regclass), -- Идентификатор истории изменений -- 2017-01-03
   date_from            public.t_timestamp  NOT NULL DEFAULT (now())::timestamp(0) without time zone, -- Начало интервала актуальности
   date_to              public.t_timestamp  NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone -- Конец интервала актуальности
) INHERITS (auth.auth_user_role);

COMMENT ON TABLE auth.auth_user_role_hist IS
'Историческая таблица связи пользователя с ролями(начальной и эффективной).';

COMMENT ON COLUMN auth.auth_user_role_hist.user_role_hist_id IS
'Идентификатор истории изменений';

COMMENT ON COLUMN auth.auth_user_role_hist.date_from IS
'Начало интервала актуальности';

COMMENT ON COLUMN auth.auth_user_role_hist.date_to IS
'Конец интервала актуальности';

ALTER TABLE auth.auth_user_role_hist
   ADD CONSTRAINT pk_auth_user_role_hist PRIMARY KEY (user_role_hist_id);

-- 2016-03-11 Nick, new table.

/*==============================================================*/
/* Table: auth_role_perm_serv_object         REMOVED  Roman     */
/*==============================================================*/
/*==============================================================*/
-- /* Table: auth_role_perm_serv_object_hist REMOVED  Roman     */
/*==============================================================*/

/*==============================================================*/
/* Table: auth_role_perm_client_object  2017-11-18              */
/*==============================================================*/
DROP TABLE IF EXISTS auth.auth_role_perm_client_object CASCADE;
CREATE TABLE auth.auth_role_perm_client_object (
      role_perm_client_object_id   bigserial,              
      apr_role_id                  public.id_t        NOT NULL,  
      client_object_id             public.id_t        NOT NULL,  
      client_is_active             public.t_boolean   NOT NULL DEFAULT TRUE,                       
      client_date_create           public.t_timestamp NOT NULL DEFAULT now()::public.t_timestamp,  
      client_date_update           public.t_timestamp, 
      client_perm_descr            public.t_fullname,  
      id_log                       public.id_t        
);

COMMENT ON TABLE auth.auth_role_perm_client_object IS 'Команды, доступные ролям';

COMMENT ON COLUMN auth.auth_role_perm_client_object.role_perm_client_object_id IS 'Идентификатор клиентской связи';
COMMENT ON COLUMN auth.auth_role_perm_client_object.apr_role_id                IS 'Идентификатор прикладной роли';
COMMENT ON COLUMN auth.auth_role_perm_client_object.client_object_id           IS 'Идентификатор клиентского объекта (Ссылка на пользовательскую функцию)';
COMMENT ON COLUMN auth.auth_role_perm_client_object.client_is_active           IS 'Признак активности клиентской связи';
COMMENT ON COLUMN auth.auth_role_perm_client_object.client_date_create         IS 'Дата создания клиентской связи';
COMMENT ON COLUMN auth.auth_role_perm_client_object.client_date_update         IS 'Дата обновления клиентской связи';
COMMENT ON COLUMN auth.auth_role_perm_client_object.client_perm_descr          IS 'Описание клиентской связи';
COMMENT ON COLUMN auth.auth_role_perm_client_object.id_log                     IS 'Идентификатор журнала';

ALTER TABLE auth.auth_role_perm_client_object
   ADD CONSTRAINT pk_auth_role_perm_client_object PRIMARY KEY (role_perm_client_object_id);
--
ALTER TABLE auth.auth_role_perm_client_object
   ADD CONSTRAINT ak1_auth_role_perm_clie_auth_per UNIQUE (apr_role_id, client_object_id);

/*==============================================================*/
/* Table: auth_role_perm_serv_object  RENAME  Roman             */
/*==============================================================*/
DROP TABLE IF EXISTS auth_role_perm_serv_object CASCADE;
DROP SEQUENCE IF EXISTS auth_role_perm_serv_object_role_perm_serv_object_id_seq CASCADE;

CREATE SEQUENCE auth_role_perm_serv_object_role_perm_serv_object_id_seq
                                            INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
CREATE TABLE auth_role_perm_serv_object (
       role_perm_serv_object_id    public.id_t           NOT NULL DEFAULT NEXTVAL ('auth_role_perm_serv_object_role_perm_serv_object_id_seq'),
       role_id		                 public.id_t           NOT NULL,
       serv_object_id              public.id_t           NOT NULL,
       serv_perm_id                public.id_t           NOT NULL,
       ps_is_active                public.t_boolean      NOT NULL DEFAULT false,
       ps_date_create              public.t_timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
       ps_date_update              public.t_timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
       ps_serv_descr               public.t_fullname     NULL,
       id_log                      public.id_t           NULL
);

COMMENT ON TABLE auth_role_perm_serv_object IS 
'Связь роли, серверного объекта и разрешение для серверного объекта.';

COMMENT ON COLUMN auth_role_perm_serv_object.role_perm_serv_object_id IS 
'Идентификатор серверной связи';

COMMENT ON COLUMN auth_role_perm_serv_object.role_id IS 
'Идентификатор роли';

COMMENT ON COLUMN auth_role_perm_serv_object.serv_object_id IS 
'Идентификатор серверного объекта';

COMMENT ON COLUMN auth_role_perm_serv_object.serv_perm_id IS 
'Идентификатор серверного разрешения';

COMMENT ON COLUMN auth_role_perm_serv_object.ps_is_active IS 
'Признак активности серверной связи';

COMMENT ON COLUMN auth_role_perm_serv_object.ps_date_create IS 
'Дата создания серверной связи';

COMMENT ON COLUMN auth_role_perm_serv_object.ps_date_update IS 
'Дата обновления серверной связи';

COMMENT ON COLUMN auth_role_perm_serv_object.ps_serv_descr IS 
'Описание серверной связи';

COMMENT ON COLUMN auth_role_perm_serv_object.id_log IS 
'Идентификатор журнала.';

ALTER TABLE auth_role_perm_serv_object
   ADD CONSTRAINT pk_auth_role_perm_serv_object PRIMARY KEY (role_perm_serv_object_id);

ALTER TABLE auth_role_perm_serv_object
   ADD CONSTRAINT ak1_auth_role_perm_serv_object UNIQUE (role_id, serv_object_id, serv_perm_id);

ALTER SEQUENCE auth_role_perm_serv_object_role_perm_serv_object_id_seq OWNED BY auth_role_perm_serv_object.role_perm_serv_object_id;
--
/*==============================================================*/
/* Table: auth_server_permission                                */
/*==============================================================*/
DROP TABLE IF EXISTS auth_server_permission CASCADE;
DROP SEQUENCE IF EXISTS auth_server_permissions_serv_perm_id_seq CASCADE;

CREATE SEQUENCE auth_server_permissions_serv_perm_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
CREATE TABLE auth_server_permission (
   serv_perm_id         public.id_t           NOT NULL DEFAULT NEXTVAL ('auth_server_permissions_serv_perm_id_seq'),
   sp_serv_perm_code    public.t_str100       NOT NULL,	-- Nick "всё взад" Изм. Роман (NULL - всё запрещено + т.к. этот код будет содержать расшифровку в текстовом виде увеличил размерность)
   can_select           public.t_boolean      NOT NULL DEFAULT FALSE,
   can_insert           public.t_boolean      NOT NULL DEFAULT FALSE,
   can_update           public.t_boolean      NOT NULL DEFAULT FALSE,
   can_delete           public.t_boolean      NOT NULL DEFAULT FALSE,
   can_truncate         public.t_boolean      NOT NULL DEFAULT FALSE,
   can_reference        public.t_boolean      NOT NULL DEFAULT FALSE,
   can_trigger          public.t_boolean      NOT NULL DEFAULT FALSE,
   can_execute          public.t_boolean      NOT NULL DEFAULT FALSE,
   can_usage            public.t_boolean      NOT NULL DEFAULT FALSE,
   can_create           public.t_boolean      NOT NULL DEFAULT FALSE,
   can_connect          public.t_boolean      NOT NULL DEFAULT FALSE,
   can_temp             public.t_boolean      NOT NULL DEFAULT FALSE,
   id_log               public.id_t           NULL
);

COMMENT ON TABLE auth_server_permission IS 
'Набор разрешений, для выполнения серверных операций.';

COMMENT ON COLUMN auth_server_permission.serv_perm_id IS 
'Идентификатор серверного разрешения';

COMMENT ON COLUMN auth_server_permission.sp_serv_perm_code IS 
'Код серверного разрешения';

COMMENT ON COLUMN auth_server_permission.can_select IS 
'Возможность выборки';

COMMENT ON COLUMN auth_server_permission.can_insert IS 
'Возможность создания данных';

COMMENT ON COLUMN auth_server_permission.can_update IS 
'Возможность обновления';

COMMENT ON COLUMN auth_server_permission.can_delete IS 
'Возможность удаления';

COMMENT ON COLUMN auth_server_permission.can_truncate IS 
'Возможность очистки от данных';

COMMENT ON COLUMN auth_server_permission.can_reference IS 
'Возможность создания ограничений';

COMMENT ON COLUMN auth_server_permission.can_trigger IS 
'Возможность создания/управления триггерами';

COMMENT ON COLUMN auth_server_permission.can_execute IS 
'Возможность выполнения';

COMMENT ON COLUMN auth_server_permission.can_usage IS 
'Возможность использования';

COMMENT ON COLUMN auth_server_permission.can_create IS 
'Возможность создания объектов';

COMMENT ON COLUMN auth_server_permission.can_connect IS 
'Возможность соединения с внешними объектами';

COMMENT ON COLUMN auth_server_permission.can_temp IS 
'Возможность создания временных объектов';

COMMENT ON COLUMN auth_server_permission.id_log IS 
'Идентификатор журнала';

ALTER TABLE auth_server_permission
   ADD CONSTRAINT pk_auth_server_permission PRIMARY KEY (serv_perm_id);

ALTER TABLE auth_server_permission
   ADD CONSTRAINT ak1_auth_server_permission UNIQUE ( can_select
                                                    , can_update
                                                    , can_insert
                                                    , can_delete
                                                    , can_reference
                                                    , can_execute
                                                    , can_truncate
                                                    , can_trigger
                                                    , can_usage
                                                    , can_create
                                                    , can_connect
                                                    , can_temp
);

ALTER TABLE auth_server_permission
   ADD CONSTRAINT ak2_auth_server_permission UNIQUE (sp_serv_perm_code);

ALTER SEQUENCE auth_server_permissions_serv_perm_id_seq 
                                     OWNED BY auth_server_permission.serv_perm_id;

--
/*==============================================================*/
/* Table: auth_server_object                                    */
/*==============================================================*/
DROP TABLE IF EXISTS auth_server_object CASCADE;
DROP SEQUENCE IF EXISTS auth_server_object_serv_object_id_seq CASCADE;

CREATE SEQUENCE auth_server_object_serv_object_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
CREATE TABLE auth_server_object (
   serv_object_id                  public.id_t        NOT NULL DEFAULT NEXTVAL ('auth_server_object_serv_object_id_seq'),
   parent_serv_object_id           public.id_t            NULL,
   auth_serv_object_type_id        public.id_t        NOT NULL,
   auth_server_object_type_scode   public.t_code1     NOT NULL DEFAULT '0',
   auth_schema                     public.t_sysname       NULL,
   auth_server_object_code         public.t_str1024   NOT NULL,
   auth_server_object_name         public.t_str1024   NOT NULL,
   id_log                          public.id_t            NULL
);

COMMENT ON TABLE auth_server_object IS 
'Защищаемый объект воздейстия, это база данных, схема, таблица, представление, хранимая процедура (функция).';

COMMENT ON COLUMN auth_server_object.serv_object_id IS 
'Идентификатор серверного объекта';

COMMENT ON COLUMN auth_server_object.parent_serv_object_id IS 
'Идентификатор родительского серверного объекта';

COMMENT ON COLUMN auth_server_object.auth_serv_object_type_id IS 
'Идентификатор типа серверного объекта';

COMMENT ON COLUMN auth_server_object.auth_server_object_type_scode IS 
'Краткий код серверного типа объекта';

COMMENT ON COLUMN auth_server_object.auth_schema IS 
'Схема';

COMMENT ON COLUMN auth_server_object.auth_server_object_code IS 
'Код серверного объекта';

COMMENT ON COLUMN auth_server_object.auth_server_object_name IS 
'Наименование серверного объекта';

COMMENT ON COLUMN auth_server_object.id_log is
'Идентификатор журнала';

ALTER TABLE auth_server_object
   ADD CONSTRAINT pk_auth_server_object primary key (serv_object_id);

ALTER TABLE auth_server_object
   ADD constraint ak1_auth_server_object UNIQUE (auth_server_object_code, auth_schema, parent_serv_object_id);

ALTER SEQUENCE auth_server_object_serv_object_id_seq OWNED BY auth_server_object.serv_object_id;
--
/*==============================================================*/
/* Table: auth_server_object_perm_hist                          */
/*==============================================================*/
DROP TABLE IF EXISTS auth_server_object_perm_hist CASCADE;
CREATE TABLE auth_server_object_perm_hist (
   server_object_perm_id   public.id_t            NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'), -- Nick 2017-01-03
   date_from               public.t_timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
   date_to                 public.t_timestamp     NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
   id_log                  public.id_t            NOT NULL
)
INHERITS
(
     auth_role_perm_serv_object, auth_server_object, auth_server_permission 
);

COMMENT ON TABLE auth_server_object_perm_hist IS 
'История изменений (серверная часть)';

COMMENT ON COLUMN auth_server_object_perm_hist.server_object_perm_id IS 
'Идентификатор истории (серверная часть)';

COMMENT ON COLUMN auth_server_object_perm_hist.date_from IS 
'Дата начала актуальности';

COMMENT ON COLUMN auth_server_object_perm_hist.date_to IS 
'Дата конца актуальности';

COMMENT ON COLUMN auth_server_object_perm_hist.id_log IS 
'Идентификатор журнала';

ALTER TABLE auth_server_object_perm_hist
   ADD CONSTRAINT pk_auth_server_object_perm_hist PRIMARY KEY (server_object_perm_id);
--
/*==============================================================*/
/* Table: auth_client_object                                    */
/*==============================================================*/
DROP TABLE IF EXISTS auth_client_object CASCADE;
DROP SEQUENCE IF EXISTS auth_client_object_client_object_id_seq; 

CREATE SEQUENCE auth_client_object_client_object_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
CREATE TABLE auth_client_object (
        client_object_id          public.id_t           NOT NULL DEFAULT NEXTVAL ('auth_client_object_client_object_id_seq'),
        parent_client_object_id   public.id_t               NULL,
        client_object_type_id     public.id_t           NOT NULL,
        client_object_code        public.t_str60        NOT NULL,
        client_object_name        public.t_str250       NOT NULL,
        id_log                    public.id_t               NULL
);

COMMENT ON TABLE auth_client_object IS 
'Объект (клиентская часть)';

COMMENT ON COLUMN auth_client_object.client_object_id IS 
'Идентификатор объекта';

COMMENT ON COLUMN auth_client_object.parent_client_object_id IS 
'Идентификатор родительского объекта';

COMMENT ON COLUMN auth_client_object.client_object_type_id IS 
'Тип объекта';

COMMENT ON COLUMN auth_client_object.client_object_code IS 
'Код объекта';

COMMENT ON COLUMN auth_client_object.client_object_name IS 
'Наименование';

COMMENT ON COLUMN auth_client_object.id_log IS 
'Идентификатор журнала';

ALTER TABLE auth_client_object
   ADD CONSTRAINT pk_auth_client_object PRIMARY KEY (client_object_id);

ALTER TABLE auth_client_object
   ADD CONSTRAINT ak1_auth_client_object UNIQUE (client_object_code);

ALTER SEQUENCE auth_client_object_client_object_id_seq OWNED BY auth_client_object.client_object_id;
--
/*==============================================================*/
/* Table: auth_client_permition                                 */
/*==============================================================*/
DROP TABLE IF EXISTS auth_client_permition CASCADE;
DROP SEQUENCE IF EXISTS auth_client_permition_client_perm_id_seq CASCADE;

CREATE SEQUENCE auth_client_permition_client_perm_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1; 
CREATE TABLE auth_client_permition (
   client_perm_id       public.id_t        NOT NULL DEFAULT NEXTVAL ('auth_client_permition_client_perm_id_seq'),
   client_perm_code     public.t_str60     NOT NULL,
   client_perm_value    public.t_boolean   NOT NULL DEFAULT FALSE,
   id_log               public.id_t            NULL
);

COMMENT ON TABLE auth_client_permition IS
'Домен клиентских разрешений';

COMMENT ON COLUMN auth_client_permition.client_perm_id IS 
'Идентификатор разрешения';

COMMENT ON COLUMN auth_client_permition.client_perm_code IS 
'Код разрешения';

COMMENT ON COLUMN auth_client_permition.client_perm_value IS 
'Величина';

COMMENT ON COLUMN auth_client_permition.id_log IS 
'Идентификатор журнала';

ALTER TABLE auth_client_permition
   ADD CONSTRAINT pk_auth_client_permition PRIMARY KEY (client_perm_id);

ALTER TABLE auth_client_permition
   ADD CONSTRAINT ak1_auth_client_permition UNIQUE (client_perm_code);

ALTER SEQUENCE auth_client_permition_client_perm_id_seq OWNED BY auth_client_permition.client_perm_id; 
-- ---------------------------------------------------------------------------------------------------
-- 2018-03-01 Nick
--
--  /*==============================================================*/
--  /* Table: auth_role_perm_client_object                          */
--  /*==============================================================*/
--  DROP TABLE IF EXISTS auth_role_perm_client_object CASCADE;
--  DROP SEQUENCE IF EXISTS auth_role_perm_client_object_role_perm_client_object_id_seq;
--  CREATE SEQUENCE auth_role_perm_client_object_role_perm_client_object_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
--  
--  CREATE TABLE auth_role_perm_client_object (
--       role_perm_client_object_id   public.id_t            NOT NULL DEFAULT NEXTVAL ('auth_role_perm_client_object_role_perm_client_object_id_seq'),
--       role_id	                   public.id_t            NOT NULL,
--       client_object_id             public.id_t            NOT NULL,
--       client_perm_id               public.id_t            NOT NULL,
--       client_is_active             public.t_boolean       NOT NULL DEFAULT FALSE,
--       client_date_create           public.t_timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
--       client_date_update           public.t_timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
--       client_perm_descr            public.t_fullname      NULL,
--       id_log                       public.id_t            NULL
--  );
--  
--  COMMENT ON TABLE auth_role_perm_client_object IS 
--  'Связь роли, клиенского объекта и разрешение для клиентского объекта.';
--  
--  COMMENT ON COLUMN auth_role_perm_client_object.role_perm_client_object_id IS 
--  'Идентификатор клиентской связи';
--  
--  COMMENT ON COLUMN auth_role_perm_client_object.role_id IS 
--  'Идентификатор роли';
--  
--  COMMENT ON COLUMN auth_role_perm_client_object.client_object_id IS 
--  'Идентификатор клиентского объекта';
--  
--  COMMENT ON COLUMN auth_role_perm_client_object.client_perm_id IS 
--  'Идентификатор разрешения';
--  
--  COMMENT ON COLUMN auth_role_perm_client_object.client_is_active IS 
--  'Признак активности клиентской связи';
--  
--  COMMENT ON COLUMN auth_role_perm_client_object.client_date_create IS 
--  'Дата создания клиентской связи';
--  
--  COMMENT ON COLUMN auth_role_perm_client_object.client_date_update IS 
--  'Дата обновления клиентской связи';
--  
--  COMMENT ON COLUMN auth_role_perm_client_object.client_perm_descr IS 
--  'Описание клиентской связи';
--  
--  COMMENT ON COLUMN auth_role_perm_client_object.id_log IS 
--  'Идентификатор журнала';
--  
--  ALTER TABLE auth_role_perm_client_object
--     ADD CONSTRAINT pk_auth_role_perm_client_object primary key (role_perm_client_object_id);
--  
--  ALTER TABLE auth_role_perm_client_object
--     ADD CONSTRAINT ak1_auth_role_perm_clie_auth_per UNIQUE (role_id, client_object_id, client_perm_id);
--  
--  ALTER SEQUENCE auth_role_perm_client_object_role_perm_client_object_id_seq
--                                       OWNED BY auth_role_perm_client_object.role_perm_client_object_id;
-- --------------------------------------------------------------------------------------------------------
-- 2018-03-01 Nick
-- --------------------------------------------------------------------------------------------------------

/*==============================================================*/
/* Table: auth_client_object_perm_hist                          */
/*==============================================================*/
DROP TABLE IF EXISTS auth_client_object_perm_hist CASCADE;
CREATE TABLE auth_client_object_perm_hist (
   client_object_perm_id   public.id_t            NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'),
   date_from               public.t_timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP::timestamp(0) without time zone,
   date_to                 public.t_timestamp     NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
   id_log                  public.id_t            NOT NULL
)
INHERITS
(
    auth_role_perm_client_object, auth_client_object, auth_client_permition
);

COMMENT ON TABLE auth_client_object_perm_hist IS 
'История изменений (клиентская часть)';

COMMENT ON COLUMN auth_client_object_perm_hist.client_object_perm_id IS 
'Идентификатор истории изменений (клиентская часть)';

COMMENT ON COLUMN auth_client_object_perm_hist.date_from IS 
'Дата начала актуальности';

COMMENT ON COLUMN auth_client_object_perm_hist.date_to IS 
'Дата конца актуальности';

COMMENT ON COLUMN auth_client_object_perm_hist.id_log IS 
'Идентификатор журнала';

ALTER TABLE auth_client_object_perm_hist
   ADD CONSTRAINT pk_auth_client_object_perm_hist PRIMARY KEY (client_object_perm_id);
--
/*==============================================================*/
/* Table: auth_group           REMOVED Nick 2016-12-31          */
/*==============================================================*/
/*==============================================================*/
/* Table: auth_group_role     REMOVED Nick 2016-12-31         */
/*==============================================================*/
/*==============================================================*/
/* Table: auth_group_role_hist   REMOVED Nick 2016-12-31       */
/*==============================================================*/
/*==============================================================*/
/* Table: auth_role_data_access_perm   REMOVED. Nick 2017-01-03 */
/*==============================================================*/
--
/*==============================================================*/
/* Table: auth_data_types_access_perm REMOVED. Nick 2017-01-03  */
/*==============================================================*/
--
/*==============================================================*/
/* Table: auth_data_access_perm   REMOVED. Nick 2017-01-03      */
/*==============================================================*/
/*==============================================================*/
/* Table: auth_data_access_perm_hist REMOVED. Nick 2017-01-03   */
/*==============================================================*/
   
/*==============================================================*/
/* Table:               auth.auth_role_attr                     */
/*==============================================================*/
DROP TABLE IF EXISTS auth.auth_role_attr CASCADE;
DROP SEQUENCE IF EXISTS auth.auth_role_attr_id_seq;

CREATE SEQUENCE auth.auth_role_attr_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
CREATE TABLE auth.auth_role_attr (
    role_attr_id      public.id_t		  NOT NULL DEFAULT NEXTVAL ('auth_role_attr_id_seq'::regclass) 
   ,attr_type_id      public.id_t	         NOT NULL  -- "preffix":"user_attr"
   ,attr_id           public.id_t            NOT NULL   
   ,attr_scode        public.t_code1         NOT NULL   
   ,attr_code         public.t_str60         NOT NULL 
   ,attr_name         public.t_str250        NOT NULL  
   ,def_value         public.t_text              NULL    -- ,"def_value":"CURRENT_TIMESTAMP"
   ,date_create	    public.t_timestamp  	NOT NULL DEFAULT CURRENT_TIMESTAMP::t_timestamp
   ,date_update_use	 public.t_timestamp	       NULL
   ,used              public.t_boolean    NOT NULL DEFAULT FALSE     
   ,id_log		       public.id_t		          NULL
);
-- -----------------------------------------------
ALTER TABLE auth.auth_role_attr 
  ADD CONSTRAINT pk_auth_role_attr PRIMARY KEY (role_attr_id);

ALTER TABLE auth.auth_role_attr
  ADD CONSTRAINT ak1_auth_role_attr UNIQUE (attr_code); -- 2015-12-15 Roman

ALTER SEQUENCE auth.auth_role_attr_id_seq OWNED BY auth.auth_role_attr.role_attr_id;

COMMENT ON TABLE auth.auth_role_attr IS 'Дополнительный атрибут роли';

COMMENT ON COLUMN auth.auth_role_attr.role_attr_id    IS 'Идентификатор атрибута';
COMMENT ON COLUMN auth.auth_role_attr.attr_type_id    IS 'Тип атрибута';
COMMENT ON COLUMN auth.auth_role_attr.attr_id         IS 'ID элемента домена атрибутов';
COMMENT ON COLUMN auth.auth_role_attr.attr_scode      IS 'Краткий код типа данных';
COMMENT ON COLUMN auth.auth_role_attr.attr_code       IS 'Код атрибута';
COMMENT ON COLUMN auth.auth_role_attr.attr_name       IS 'Имя атрибута';
COMMENT ON COLUMN auth.auth_role_attr.def_value       IS 'Значение по умолчанию';
COMMENT ON COLUMN auth.auth_role_attr.date_create     IS 'Дата создания';
COMMENT ON COLUMN auth.auth_role_attr.date_update_use IS 'Дата обновления';
COMMENT ON COLUMN auth.auth_role_attr.used            IS 'Признак использования атрибута в роли';
COMMENT ON COLUMN auth_role_attr.id_log               IS 'Идентификатор журнала';
-- --------------------------------------------------------------------------------------------------------------------
--  ЗАМЕЧАНИЕ:  последовательность "auth_server_object_perm_hist_server_object_perm_id" не существует, пропускается
--  ЗАМЕЧАНИЕ:  слияние нескольких наследованных определений колонки "serv_object_id"
--  ЗАМЕЧАНИЕ:  слияние нескольких наследованных определений колонки "id_log"
--  ЗАМЕЧАНИЕ:  слияние нескольких наследованных определений колонки "serv_perm_id"
--  ЗАМЕЧАНИЕ:  слияние нескольких наследованных определений колонки "id_log"
--  ЗАМЕЧАНИЕ:  слияние колонки "id_log" с наследованным определением
-- --------------------------------------------------------------------------------------------------------------------
--  ЗАМЕЧАНИЕ:  последовательность "auth_client_object_perm_hist_client_object_perm_id_seq" не существует, пропускается
--  ЗАМЕЧАНИЕ:  слияние нескольких наследованных определений колонки "id_log"
--  ЗАМЕЧАНИЕ:  слияние нескольких наследованных определений колонки "client_object_id"
--  ЗАМЕЧАНИЕ:  слияние нескольких наследованных определений колонки "client_perm_id"
--  ЗАМЕЧАНИЕ:  слияние нескольких наследованных определений колонки "id_log"
--  ЗАМЕЧАНИЕ:  слияние колонки "id_log" с наследованным определением
-- ------------------------------------------------------------------
--  ЗАМЕЧАНИЕ:  таблица "auth_group_role_hist" не существует, пропускается
--  ЗАМЕЧАНИЕ:  последовательность "auth_role_group_hist_role_group_hist_id_seq" не существует, пропускается
--  ЗАМЕЧАНИЕ:  слияние нескольких наследованных определений колонки "group_id"
--  ЗАМЕЧАНИЕ:  слияние колонки "id_log" с наследованным определением
--  -----------------------------------------------------------
--  ЗАМЕЧАНИЕ:  последовательность "auth_data_access_perm_hist_auth_type_data_id_seq" не существует, пропускается
--  ЗАМЕЧАНИЕ:  слияние нескольких наследованных определений колонки "data_perm_id"
--  ЗАМЕЧАНИЕ:  слияние нескольких наследованных определений колонки "data_perm_id"
--  ЗАМЕЧАНИЕ:  слияние нескольких наследованных определений колонки "id_log"
--  ЗАМЕЧАНИЕ:  слияние колонки "date_from" с наследованным определением
--  ЗАМЕЧАНИЕ:  слияние колонки "date_to" с наследованным определением
--  ЗАМЕЧАНИЕ:  слияние колонки "id_log" с наследованным определением
-- ----------------------------------------------------------------------------------
--    2017-11-17 Nick
-- -------------------
DROP TABLE IF EXISTS auth.apr_glb_role CASCADE;
/*==============================================================*/
/* Table: apr_glb_role                                          */
/*==============================================================*/
create table auth.apr_glb_role (
   apr_role_id          public.id_t           NOT NULL,
   role_type_id         public.id_t           NOT NULL,
   parent_apr_role_id   public.id_t           NULL,
   glb_role_name        public.t_str250       NOT NULL,
   is_active            public.t_boolean      NOT NULL DEFAULT TRUE,
   group_sign           public.t_boolean      NOT NULL DEFAULT FALSE,
   date_from            public.t_timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP::public.t_timestamp,     
   date_to              public.t_timestamp    NOT NULL DEFAULT '9999-12-31 00:00:00'::public.t_timestamp, 
   id_log               public.id_t        
);

COMMENT ON TABLE auth.apr_glb_role IS 'Глобальная прикладная роль';

COMMENT ON COLUMN auth.apr_glb_role.apr_role_id        IS 'Идентификатор роли-объекта';
COMMENT ON COLUMN auth.apr_glb_role.role_type_id       IS 'Ссылка на тип прикладной роли';
COMMENT ON COLUMN auth.apr_glb_role.parent_apr_role_id IS 'Идентификатор родительской роли';
COMMENT ON COLUMN auth.apr_glb_role.glb_role_name      IS 'Наименование прикладной роли';
COMMENT ON COLUMN auth.apr_glb_role.is_active          IS 'Признак активности';
COMMENT ON COLUMN auth.apr_glb_role.group_sign         IS 'Групповой признак';
COMMENT ON COLUMN auth.apr_glb_role.date_from          IS 'Дата начала актуальности';
COMMENT ON COLUMN auth.apr_glb_role.date_to            IS 'Дата окончания атуальности';
COMMENT ON COLUMN auth.apr_glb_role.id_log             IS 'Идентификатор журнала';
--
ALTER TABLE auth.apr_glb_role
   ADD CONSTRAINT pk_apr_role PRIMARY KEY (apr_role_id);
--
CREATE INDEX ie1_apr_glb_role ON auth.apr_glb_role (role_type_id);

DROP TABLE IF EXISTS auth.apr_glb_role_hist CASCADE;
/*==============================================================*/
/* Table: apr_glb_role_hist                                     */
/*==============================================================*/
CREATE TABLE auth.apr_glb_role_hist (
   apr_glb_role_hist_id  public.id_t  NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'::regclass) -- Общий счётчик -- com.all_history_id_seq
)
inherits (auth.apr_glb_role);

COMMENT ON TABLE auth.apr_glb_role_hist IS 'Глобальная прикладная роль, история';

COMMENT ON COLUMN auth.apr_glb_role_hist.apr_glb_role_hist_id IS 'Идентификатор  истории';

ALTER TABLE auth.apr_glb_role_hist
   ADD CONSTRAINT pk_apr_glb_role_hist PRIMARY KEY (apr_glb_role_hist_id);

--
-- ALTER TABLE auth.apr_glb_role_access
--   ADD CONSTRAINT fk_apr_role_has_access_apr_role FOREIGN KEY (apr_role_id)
--      REFERENCES auth.apr_glb_role (role_id)
--      ON DELETE RESTRICT ON UPDATE RESTRICT;


DROP TABLE IF EXISTS auth.apr_obj_role CASCADE;
/*==============================================================*/
/* Table: apr_obj_role                                          */
/*==============================================================*/
CREATE TABLE auth.apr_obj_role (
   apr_role_id        public.id_t           NOT NULL,
   perm_rec_id        public.id_t           NOT NULL,
   obj_object_id      public.id_t           NOT NULL,
   obj_role_name      public.t_str250       NULL,
   is_active          public.t_boolean      NULL DEFAULT TRUE,                                    
   date_from          public.t_timestamp    NULL DEFAULT CURRENT_TIMESTAMP::public.t_timestamp,    
   date_to            public.t_timestamp    NULL DEFAULT '9999-12-31 00:00:00'::public.t_timestamp,
   id_log             public.id_t        
);

COMMENT ON TABLE auth.apr_obj_role IS 'Объектовая прикладная роль';

COMMENT ON COLUMN auth.apr_obj_role.apr_role_id   IS 'Идентификатор роли-объекта';
COMMENT ON COLUMN auth.apr_obj_role.perm_rec_id   IS 'Идентификатор разрешения';
COMMENT ON COLUMN auth.apr_obj_role.obj_object_id IS 'Идентификатор защищаемого объекта';
COMMENT ON COLUMN auth.apr_obj_role.obj_role_name IS 'Наименование прикладной роли';
COMMENT ON COLUMN auth.apr_obj_role.is_active     IS 'Признак активности';
COMMENT ON COLUMN auth.apr_obj_role.date_from     IS 'Дата начала актуальности';
COMMENT ON COLUMN auth.apr_obj_role.date_to       IS 'Дата конца актуальности';
COMMENT ON COLUMN auth.apr_obj_role.id_log        IS 'Идентификатор журнала';

ALTER TABLE auth.apr_obj_role
   ADD CONSTRAINT pk_apr_obj_role PRIMARY KEY (apr_role_id);

ALTER TABLE auth.apr_obj_role
   ADD CONSTRAINT ak1_apr_obj_role UNIQUE (obj_object_id, perm_rec_id);

DROP TABLE IF EXISTS auth.apr_obj_role_hist CASCADE ;
/*==============================================================*/
/* Table: apr_obj_role_hist                                     */
/*==============================================================*/
CREATE TABLE auth.apr_obj_role_hist (
     apr_obj_role_hist_id  public.id_t  NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'::regclass) -- com.all_history_id_seq
)
inherits (auth.apr_obj_role);

COMMENT ON TABLE auth.apr_obj_role_hist IS 'Объектовая прикладная роль, история изменений';

COMMENT ON COLUMN auth.apr_obj_role_hist.apr_obj_role_hist_id IS 'Идентификатор истории';

ALTER TABLE auth.apr_obj_role_hist
   ADD CONSTRAINT pk_apr_obj_role_hist PRIMARY KEY (apr_obj_role_hist_id);
--
--
DROP TABLE IF EXISTS auth.apr_glb_role_access CASCADE;
/*==============================================================*/
/* Table: apr_glb_role_access                                   */
/*==============================================================*/
CREATE TABLE auth.apr_glb_role_access (
   role_access_id      bigserial NOT NULL,    -- public.id_t  NOT NULL
   apr_role_id         public.id_t           NOT NULL,
   object_type_id      public.id_t           NOT NULL,
   perm_rec_id         public.id_t           NOT NULL,
   type_restriction    public.t_text         NULL,
   date_from           public.t_timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP::public.t_timestamp,     
   date_to             public.t_timestamp    NOT NULL DEFAULT '9999-12-31 00:00:00'::public.t_timestamp, 
   id_log              public.id_t        
);

COMMENT ON TABLE auth.apr_glb_role_access IS 'Права ролей';

COMMENT ON COLUMN auth.apr_glb_role_access.role_access_id     IS 'Идентификатор записи';
COMMENT ON COLUMN auth.apr_glb_role_access.apr_role_id        IS 'Идентификатор роли-объекта';
COMMENT ON COLUMN auth.apr_glb_role_access.object_type_id     IS 'Идентификатор типа объекта';
COMMENT ON COLUMN auth.apr_glb_role_access.perm_rec_id        IS 'Ссылка на справочник';
COMMENT ON COLUMN auth.apr_glb_role_access.type_restriction   IS 'Ограничения доступа для типа';
COMMENT ON COLUMN auth.apr_glb_role_access.date_from          IS 'Дата начала актуальности';
COMMENT ON COLUMN auth.apr_glb_role_access.date_to            IS 'Дата конца актуальности';
COMMENT ON COLUMN auth.apr_glb_role_access.id_log             IS 'Идентификатор журнала';

ALTER TABLE auth.apr_glb_role_access
   ADD CONSTRAINT pk_apr_role_access PRIMARY KEY (role_access_id);

ALTER TABLE auth.apr_glb_role_access
   ADD CONSTRAINT ak1_apr_role_access UNIQUE (apr_role_id, object_type_id);
--
--
drop table IF EXISTS auth.apr_glb_role_access_hist CASCADE;
/*==============================================================*/
/* Table: apr_glb_role_access_hist                              */
/*==============================================================*/
CREATE TABLE auth.apr_glb_role_access_hist (
   apr_glb_role_access_hist_id   public.id_t  NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'::regclass) -- com.all_history_id_seq
)
inherits (auth.apr_glb_role_access);

COMMENT ON TABLE auth.apr_glb_role_access_hist IS 'Права роли (свойства прикладной роли) история';

COMMENT ON COLUMN auth.apr_glb_role_access_hist.apr_glb_role_access_hist_id IS 'Идентификатор истории';

ALTER TABLE auth.apr_glb_role_access_hist ADD CONSTRAINT pk_apr_glb_role_access_hist PRIMARY KEY (apr_glb_role_access_hist_id);
--
--
DROP TABLE IF EXISTS auth.apr_role_user CASCADE;
/*==============================================================*/
/* Table: apr_role_user                                         */
/*==============================================================*/
CREATE TABLE auth.apr_role_user (
   apr_role_user_id   BIGSERIAL             NOT NULL,
   user_id            public.id_t           NOT NULL,
   user_login         public.t_sysname      NOT NULL,
   apr_role_id        public.id_t           NOT NULL,
   is_active          public.t_boolean      NOT NULL DEFAULT TRUE,
   descr              public.t_text         NULL,
   date_from          public.t_timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP::public.t_timestamp,     
   date_to            public.t_timestamp    NOT NULL DEFAULT '9999-12-31 00:00:00'::public.t_timestamp, 
   id_log             public.id_t        
);

COMMENT ON TABLE auth.apr_role_user IS 'Назначение пользователей на роли';

COMMENT ON COLUMN auth.apr_role_user.apr_role_user_id IS 'Идентификатор назначения';
COMMENT ON COLUMN auth.apr_role_user.user_id          IS 'Ссылка на пользователя';
COMMENT ON COLUMN auth.apr_role_user.user_login       IS 'Профиль пользователя';
COMMENT ON COLUMN auth.apr_role_user.apr_role_id      IS 'Идентификатор роли-объекта';
COMMENT ON COLUMN auth.apr_role_user.is_active        IS 'Признак активности';
COMMENT ON COLUMN auth.apr_role_user.descr            IS 'Описание';
COMMENT ON COLUMN auth.apr_role_user.date_from        IS 'Дата начала актуальности';
COMMENT ON COLUMN auth.apr_role_user.date_to          IS 'Дата конца актуальности';
COMMENT ON COLUMN auth.apr_role_user.id_log           IS 'Идентификатор журнала';

ALTER TABLE auth.apr_role_user
   ADD CONSTRAINT pk_apr_role_user PRIMARY KEY (apr_role_user_id);

ALTER TABLE auth.apr_role_user
   ADD CONSTRAINT ak1_apr_role_user UNIQUE (user_id, apr_role_id);

/*==============================================================*/
/* Index: ie1_apr_role_user                                     */
/*==============================================================*/
CREATE INDEX ie1_apr_role_user ON auth.apr_role_user (user_login);
--
-- ------------------------------------------------------------------------
--
DROP TABLE IF EXISTS auth.apr_role_user_hist;
/*==============================================================*/
/* Table: apr_role_user_hist                                    */
/*==============================================================*/
create table auth.apr_role_user_hist (
   apr_role_user_hist_id   public.id_t  NOT NULL DEFAULT NEXTVAL ('com.all_history_id_seq'::regclass) -- com.all_history_id_seq
)
inherits (auth.apr_role_user);

COMMENT ON TABLE auth.apr_role_user_hist IS 'Назначение пользователей на роли, история изменений';

COMMENT ON COLUMN auth.apr_role_user_hist.apr_role_user_hist_id IS 'Идентификатор истории';

ALTER TABLE auth.apr_role_user_hist
   ADD CONSTRAINT pk_apr_role_user_hist PRIMARY KEY (apr_role_user_hist_id);

