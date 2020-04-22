CREATE SEQUENCE auth.auth_role_attr_id_seq
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;
--
-------------------------------------------------------------------------------------------------
--
CREATE TABLE auth.auth_role_attr (
	role_attr_id    public.id_t DEFAULT nextval('auth.auth_role_attr_id_seq'::regclass) NOT NULL,
	attr_type_id    public.id_t     NOT NULL,
	attr_id         public.id_t     NOT NULL,
	attr_scode      public.t_code1  NOT NULL,
	attr_code       public.t_str60  NOT NULL,
	attr_name       public.t_str250 NOT NULL,
	def_value       public.t_text,
	date_create     public.t_timestamp DEFAULT (now())::public.t_timestamp NOT NULL,
	date_update_use public.t_timestamp,
	used            public.t_boolean   DEFAULT false NOT NULL,
	id_log public.id_t
);

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
COMMENT ON COLUMN auth.auth_role_attr.id_log          IS 'Идентификатор журнала';

--------------------------------------------------------------------------------
ALTER TABLE auth.auth_role_attr
	ADD CONSTRAINT ak1_auth_role_attr UNIQUE (attr_code);
--------------------------------------------------------------------------------
ALTER TABLE auth.auth_role_attr
	ADD CONSTRAINT pk_auth_role_attr PRIMARY KEY (role_attr_id);
--------------------------------------------------------------------------------
ALTER TABLE auth.auth_role_attr
	ADD CONSTRAINT fk_auth_role_attr_can_have_auth_log FOREIGN KEY (id_log) REFERENCES auth.auth_log(id_log) ON UPDATE RESTRICT ON DELETE RESTRICT;
--------------------------------------------------------------------------------
ALTER TABLE auth.auth_role_attr
	ADD CONSTRAINT fk_nso_domain_column_defines_auth_role_attr FOREIGN KEY (attr_id) REFERENCES com.nso_domain_column(attr_id) ON UPDATE RESTRICT ON DELETE RESTRICT;
--------------------------------------------------------------------------------
ALTER TABLE auth.auth_role_attr
	ADD CONSTRAINT fk_obj_codifier_defines_attr_type_id FOREIGN KEY (attr_type_id) REFERENCES com.obj_codifier(codif_id) ON UPDATE RESTRICT ON DELETE RESTRICT;
--------------------------------------------------------------------------------
ALTER SEQUENCE auth.auth_role_attr_id_seq
	OWNED BY auth.auth_role_attr.role_attr_id;