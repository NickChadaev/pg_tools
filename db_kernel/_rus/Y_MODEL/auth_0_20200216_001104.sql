DROP TABLE ind_indicator;
DROP TABLE ind_type_header;
CREATE TABLE auth_log (
	id_log id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass),
	user_name t_str250 NOT NULL,
	host_name t_str250,
	impact_date t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone
);
ALTER TABLE auth_log ADD CONSTRAINT pk_auth_log PRIMARY KEY(id_log);
CREATE INDEX ie1_auth_log ON auth_log (user_name);
CREATE INDEX ie2_auth_log ON auth_log (user_name,impact_date);
CREATE TABLE auth_role_attr (
	role_attr_id id_t NOT NULL DEFAULT nextval('auth_role_attr_id_seq'::regclass),
	attr_type_id id_t NOT NULL,
	attr_id id_t NOT NULL,
	attr_scode t_code1 NOT NULL,
	attr_code t_str60 NOT NULL,
	attr_name t_str250 NOT NULL,
	def_value t_text,
	date_create t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	date_update_use t_timestamp,
	used t_boolean NOT NULL DEFAULT false,
	id_log id_t
);
ALTER TABLE auth_role_attr ADD CONSTRAINT pk_auth_role_attr PRIMARY KEY(role_attr_id);
CREATE UNIQUE INDEX ak1_auth_role_attr ON auth_role_attr (attr_code);
CREATE TABLE auth_role (
	role_id id_t NOT NULL DEFAULT nextval('auth_role_role_id_seq'::regclass),
	system_oid oid,
	role_name t_sysname NOT NULL,
	parent_role_id id_t,
	date_create t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	date_update t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	role_description t_str1024,
	id_log id_t
);
ALTER TABLE auth_role ADD CONSTRAINT pk_auth_role PRIMARY KEY(role_id);
CREATE UNIQUE INDEX ak1_auth_role ON auth_role (role_name);
ALTER TABLE auth_role_attr ADD CONSTRAINT fk_auth_role_attr_can_have_auth_log FOREIGN KEY (id_log) REFERENCES auth_log(id_log) ON DELETE RESTRICT ON UPDATE RESTRICT;
