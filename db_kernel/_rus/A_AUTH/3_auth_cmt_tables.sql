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
/*  2017-12-18 Nick. Дополнительные определения для таблицы auth.auth_log_1. */
/*  ------------------------------------------------------------------------ */
/*  2018-03-12 Nick. Исправление ошибки, сделанной 2 года назад.             */
/* ========================================================================= */
SET search_path=auth,nso,com,public,pg_catalog;
/*==============================================================*/
/* Table: auth_user_hist                                        */
/*==============================================================*/
comment on column auth_user_hist.user_id           IS 'Идентификатор пользователя';
comment on column auth_user_hist.user_login        IS 'LOGIN пользователя';
comment on column auth_user_hist.user_password     IS 'Пароль пользователя';
comment on column auth_user_hist.user_reg_date     IS 'Дата регистрации пользователя';
comment on column auth_user_hist.passwd_until_date IS 'Дата кончания действия пароля';
comment on column auth_user_hist.user_is_blocked   IS 'Признак заблокированного пользователя';
comment on column auth_user_hist.user_time_logout  IS 'Допустимое время неактивности';
comment on column auth_user_hist.user_block_until  IS 'Дата окончания блокировки';
comment on column auth_user_hist.user_block_reason IS 'Причина блокировки';
comment on column auth_user_hist.user_employe_id   IS 'Идентификатор сотрудника';
--
-- comment on column auth_user_hist.auth_user_role_id  IS 'Идентификатор связи Роль Пользователя';  -- Nick 2015-09-12
-- comment on column auth_user_hist.auth_user_id       IS 'Идентификатор пользователя';             -- Nick 2015-09-12 
-- comment on column auth_user_hist.auth_role_id       IS 'Идентификатор роли';                     -- Nick 2015-09-12
-- comment on column auth_user_hist.ur_reg_date              IS 'Дата создания связи';     2016-03-11 Nick
-- comment on column auth_user_hist.ur_upd_date              IS 'Дата обновления связи';   2016-03-11 Nick
-- comment on column auth_user_hist.ur_descr                 IS 'Описание связи';          2016-03-11 Nick
--
-- ALTER TABLE auth_user_hist DROP COLUMN auth_user_id;
--
ALTER TABLE auth_user_hist ALTER COLUMN user_id                  DROP DEFAULT;           
-- ALTER TABLE auth_user_hist ALTER COLUMN user_reg_date            DROP DEFAULT;
ALTER TABLE auth_user_hist ALTER COLUMN passwd_until_date        DROP DEFAULT;
ALTER TABLE auth_user_hist ALTER COLUMN user_is_blocked          DROP DEFAULT;
ALTER TABLE auth_user_hist ALTER COLUMN user_time_logout         DROP DEFAULT;
ALTER TABLE auth_user_hist ALTER COLUMN user_block_until         DROP DEFAULT;
--
-- ALTER TABLE auth_user_hist ALTER COLUMN auth_user_role_id  DROP DEFAULT;  -- Nick 2015-09-12
-- ALTER TABLE auth_user_hist ALTER COLUMN ur_reg_date        DROP DEFAULT;  -- Nick 2016-03-11
--
-- -----------------------------
-- AUTH_SERVER_OBJECT_PERM_HIST
--
COMMENT ON COLUMN auth_server_object_perm_hist.role_perm_serv_object_id IS 'Идентификатор серверной связи';
COMMENT ON COLUMN auth_server_object_perm_hist.role_id                  IS 'Идентификатор роли';
COMMENT ON COLUMN auth_server_object_perm_hist.serv_object_id           IS 'Идентификатор серверного объекта';
COMMENT ON COLUMN auth_server_object_perm_hist.serv_perm_id             IS 'Идентификатор серверного разрешения';
COMMENT ON COLUMN auth_server_object_perm_hist.ps_is_active             IS 'Признак активности серверной связи';
COMMENT ON COLUMN auth_server_object_perm_hist.ps_date_create           IS 'Дата создания серверной связи';
COMMENT ON COLUMN auth_server_object_perm_hist.ps_date_update           IS 'Дата обновления серверной связи';
COMMENT ON COLUMN auth_server_object_perm_hist.ps_serv_descr            IS 'Описание серверной связи';
--
ALTER TABLE auth_server_object_perm_hist ALTER COLUMN role_perm_serv_object_id DROP DEFAULT; 
ALTER TABLE auth_server_object_perm_hist ALTER COLUMN ps_is_active   DROP DEFAULT; 
ALTER TABLE auth_server_object_perm_hist ALTER COLUMN ps_date_create DROP DEFAULT; 
ALTER TABLE auth_server_object_perm_hist ALTER COLUMN ps_date_update DROP DEFAULT; 
--
COMMENT ON COLUMN auth_server_object_perm_hist.serv_object_id                IS 'Идентификатор серверного объекта';
COMMENT ON COLUMN auth_server_object_perm_hist.parent_serv_object_id         IS 'Идентификатор родительского серверного объекта';
COMMENT ON COLUMN auth_server_object_perm_hist.auth_serv_object_type_id      IS 'Идентификатор типа серверного объекта';
COMMENT ON COLUMN auth_server_object_perm_hist.auth_server_object_type_scode IS 'Краткий код серверного типа объекта';
COMMENT ON COLUMN auth_server_object_perm_hist.auth_schema                   IS 'Схема';
COMMENT ON COLUMN auth_server_object_perm_hist.auth_server_object_code       IS 'Код серверного объекта';
COMMENT ON COLUMN auth_server_object_perm_hist.auth_server_object_name       IS 'Наименование серверного объекта';
--
ALTER table auth_server_object_perm_hist ALTER COLUMN serv_object_id DROP DEFAULT; 
ALTER table auth_server_object_perm_hist ALTER COLUMN auth_server_object_type_scode DROP DEFAULT;
--
COMMENT ON COLUMN auth_server_object_perm_hist.serv_perm_id      IS 'Идентификатор серверного разрешения';
COMMENT ON COLUMN auth_server_object_perm_hist.sp_serv_perm_code IS 'Код серверного разрешения';
COMMENT ON COLUMN auth_server_object_perm_hist.can_select        IS 'Возможность выборки';
COMMENT ON COLUMN auth_server_object_perm_hist.can_insert        IS 'Возможность создания данных';
COMMENT ON COLUMN auth_server_object_perm_hist.can_update        IS 'Возможность обновления';
COMMENT ON COLUMN auth_server_object_perm_hist.can_delete        IS 'Возможность удаления';
COMMENT ON COLUMN auth_server_object_perm_hist.can_truncate      IS 'Возможность очистки от данных';
COMMENT ON COLUMN auth_server_object_perm_hist.can_reference     IS 'Возможность создания ограничений';
COMMENT ON COLUMN auth_server_object_perm_hist.can_trigger       IS 'Возможность создания/управления триггерами';
COMMENT ON COLUMN auth_server_object_perm_hist.can_execute       IS 'Возможность выполнения';
COMMENT ON COLUMN auth_server_object_perm_hist.can_usage         IS 'Возможность использования';
COMMENT ON COLUMN auth_server_object_perm_hist.can_create        is 'Возможность создания объектов';
COMMENT ON COLUMN auth_server_object_perm_hist.can_connect       IS 'Возможность соединения с внешними объектами';
COMMENT ON COLUMN auth_server_object_perm_hist.can_temp          IS 'Возможность создания временных объектов';
--
ALTER table auth_server_object_perm_hist ALTER COLUMN serv_perm_id  DROP DEFAULT; 
ALTER table auth_server_object_perm_hist ALTER COLUMN can_select    DROP DEFAULT; 
ALTER table auth_server_object_perm_hist ALTER COLUMN can_insert    DROP DEFAULT; 
ALTER table auth_server_object_perm_hist ALTER COLUMN can_update    DROP DEFAULT; 
ALTER table auth_server_object_perm_hist ALTER COLUMN can_delete    DROP DEFAULT; 
ALTER table auth_server_object_perm_hist ALTER COLUMN can_truncate  DROP DEFAULT; 
ALTER table auth_server_object_perm_hist ALTER COLUMN can_reference DROP DEFAULT; 
ALTER table auth_server_object_perm_hist ALTER COLUMN can_trigger   DROP DEFAULT; 
ALTER table auth_server_object_perm_hist ALTER COLUMN can_execute   DROP DEFAULT; 
ALTER table auth_server_object_perm_hist ALTER COLUMN can_usage     DROP DEFAULT; 
ALTER table auth_server_object_perm_hist ALTER COLUMN can_create    DROP DEFAULT; 
ALTER table auth_server_object_perm_hist ALTER COLUMN can_connect   DROP DEFAULT; 
ALTER table auth_server_object_perm_hist ALTER COLUMN can_temp      DROP DEFAULT; 
-- ----------------------------
-- AUTH_CLIENT_OBJECT_PERM_HIST   
--
COMMENT ON COLUMN auth_client_object_perm_hist.role_perm_client_object_id IS 'Идентификатор клиентской связи';
COMMENT ON COLUMN auth_client_object_perm_hist.apr_role_id                IS 'Идентификатор прикладной роли';       -- Nick 2018-03-01
COMMENT ON COLUMN auth_client_object_perm_hist.client_object_id           IS 'Идентификатор клиентского объекта';
COMMENT ON COLUMN auth_client_object_perm_hist.client_perm_id             IS 'Идентификатор разрешения';
COMMENT ON COLUMN auth_client_object_perm_hist.client_is_active           IS 'Признак активности клиентской связи';
COMMENT ON COLUMN auth_client_object_perm_hist.client_date_create         IS 'Дата создания клиентской связи';
COMMENT ON COLUMN auth_client_object_perm_hist.client_date_update         IS 'Дата обновления клиентской связи';
COMMENT ON COLUMN auth_client_object_perm_hist.client_perm_descr          IS 'Описание клиентской связи';
--
ALTER table auth_client_object_perm_hist ALTER COLUMN role_perm_client_object_id DROP DEFAULT; 
ALTER table auth_client_object_perm_hist ALTER COLUMN client_is_active   DROP DEFAULT; 
ALTER table auth_client_object_perm_hist ALTER COLUMN client_date_create DROP DEFAULT; 
ALTER table auth_client_object_perm_hist ALTER COLUMN client_date_update DROP DEFAULT; 
--
COMMENT ON COLUMN auth_client_object_perm_hist.client_object_id        IS 'Идентификатор объекта';
COMMENT ON COLUMN auth_client_object_perm_hist.parent_client_object_id IS 'Идентификатор родительского объекта';
COMMENT ON COLUMN auth_client_object_perm_hist.client_object_type_id   IS 'Тип объекта';
COMMENT ON COLUMN auth_client_object_perm_hist.client_object_code      IS 'Код объекта';
COMMENT ON COLUMN auth_client_object_perm_hist.client_object_name      IS 'Наименование';
--
ALTER table auth_client_object_perm_hist ALTER COLUMN client_object_id DROP DEFAULT; 
--
COMMENT ON COLUMN auth_client_object_perm_hist.client_perm_id    IS 'Идентификатор разрешения';
COMMENT ON COLUMN auth_client_object_perm_hist.client_perm_code  IS 'Код разрешения';
COMMENT ON COLUMN auth_client_object_perm_hist.client_perm_value IS 'Величина';
--
ALTER TABLE auth.auth_client_object_perm_hist ALTER COLUMN client_perm_id DROP DEFAULT; 
ALTER TABLE auth.auth_client_object_perm_hist ALTER COLUMN client_perm_value  DROP DEFAULT; 
-- ---------------------------------------------------- --
-- AUTH_DATA_ACCESS_PERM_HIST  EMOVED Nick 2018-03-01   --
-- ---------------------------------------------------- --
--
/*==============================================================*/
/* Table: auth_group_role_hist   REMOVED Nick 2016-12-31       */
/*==============================================================*/
-- -------------------------------------------------------------------
-- 2016-03-11 Nick   2018-03-12 Ошибка, сделанная 2 года тому назад.
-- -------------------------------------------------------------------
ALTER TABLE auth.auth_user_role_hist ALTER COLUMN user_id      DROP DEFAULT;
ALTER TABLE auth.auth_user_role_hist ALTER COLUMN role_id      DROP DEFAULT;
ALTER TABLE auth.auth_user_role_hist ALTER COLUMN init_role_id DROP DEFAULT;
ALTER TABLE auth.auth_user_role_hist ALTER COLUMN is_active    DROP DEFAULT;
ALTER TABLE auth.auth_user_role_hist ALTER COLUMN ur_reg_date  DROP DEFAULT;
ALTER TABLE auth.auth_user_role_hist ALTER COLUMN ur_upd_date  DROP DEFAULT;
-- ---------------------------------------------------------------------
COMMENT ON COLUMN auth.auth_user_role_hist.user_id      IS 'Идентификатор пользователя';
COMMENT ON COLUMN auth.auth_user_role_hist.role_id      IS 'Идентификатор роли';
COMMENT ON COLUMN auth.auth_user_role_hist.init_role_id IS 'Идентификатор начальной_роли';
COMMENT ON COLUMN auth.auth_user_role_hist.is_active    IS 'Признак активности связи';
COMMENT ON COLUMN auth.auth_user_role_hist.ur_reg_date  IS 'Дата создания связи';
COMMENT ON COLUMN auth.auth_user_role_hist.ur_upd_date  IS 'Дата обновления связи';
COMMENT ON COLUMN auth.auth_user_role_hist.ur_descr     IS 'Описание связи';
COMMENT ON COLUMN auth.auth_user_role_hist.id_log       is 'Идентификатор журнала';
--
-- Nick 2017-12-18
--
DROP INDEX IF EXISTS ie1_auth_log_1;  
CREATE INDEX ie1_auth_log_1 ON auth.auth_log_1 ( impact_date, impact_type );  

DROP INDEX IF EXISTS ie2_auth_log_1;
CREATE INDEX ie2_auth_log_1 ON auth.auth_log_1 ( user_name );

ALTER TABLE auth.auth_log_1 DROP CONSTRAINT IF EXISTS ak2_auth_log_1;
ALTER TABLE auth.auth_log_1 ADD CONSTRAINT pk_auth_log_1 UNIQUE ( id_log );

ALTER TABLE auth.auth_log_1 ALTER COLUMN schema_name SET DEFAULT 'AUTH';  
ALTER TABLE auth.auth_log_1 ALTER COLUMN id_log SET DEFAULT nextval('com.all_history_id_seq'::regclass) 
