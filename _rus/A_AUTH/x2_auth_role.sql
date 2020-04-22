SET search_path=auth,nso,com,public,pg_catalog;
/*==============================================================*/
/* Table: auth_role                                             */
/*==============================================================*/
DROP TABLE IF EXISTS auth.auth_role CASCADE;
DROP SEQUENCE IF EXISTS auth.auth_role_role_id_seq;

CREATE SEQUENCE auth.auth_role_role_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE auth.auth_role (
   role_id		      public.id_t	NOT NULL DEFAULT nextval('auth_role_role_id_seq'::regclass),
   system_oid		   oid			    NULL,
   role_name		   public.t_sysname     NOT NULL,    -- 2015-12-15 Roman
   parent_role_id	   public.id_t		    NULL,
   date_create		   public.t_timestamp	NOT NULL DEFAULT now()::public.t_timestamp,
   date_update		   public.t_timestamp	NOT NULL DEFAULT '9999-12-31 00:00:00'::public.t_timestamp,
   role_description	   public.t_str1024         NULL,
   id_log		   public.id_t		    NULL
);

COMMENT ON TABLE auth.auth_role IS 'Роль';

COMMENT ON COLUMN auth.auth_role.role_id          IS 'Идентификатор роли';
COMMENT ON COLUMN auth.auth_role.system_oid       IS 'Системный OID';
COMMENT ON COLUMN auth.auth_role.role_name        IS  'Имя роли'; -- 2015-12-15 Roman
COMMENT ON COLUMN auth.auth_role.parent_role_id   IS 'Идентификатор родительской роли';
COMMENT ON COLUMN auth.auth_role.date_create      IS 'Дата создания';
COMMENT ON COLUMN auth.auth_role.date_update      IS 'Дата обновления';
COMMENT ON COLUMN auth.auth_role.role_description IS 'Описание роли';
COMMENT ON COLUMN auth.auth_role.id_log           IS 'Идентификатор журнала';

ALTER TABLE auth.auth_role
  ADD CONSTRAINT pk_auth_role PRIMARY KEY (role_id);

ALTER TABLE auth.auth_role
  ADD CONSTRAINT ak1_auth_role UNIQUE (role_name);  -- 2015-12-15 Roman

ALTER SEQUENCE auth.auth_role_role_id_seq
  OWNED BY auth.auth_role.role_id;
