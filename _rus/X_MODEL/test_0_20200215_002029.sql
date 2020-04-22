CREATE TABLE obj_object (
	object_id id_t NOT NULL,
	parent_object_id id_t,
	object_type_id id_t NOT NULL,
	object_stype_id id_t,
	object_short_name t_str60,
	object_uuid t_guid NOT NULL,
	object_create_date t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	object_mod_date t_timestamp,
	object_read_date t_timestamp,
	object_deact_date t_timestamp,
	object_secret_id id_t NOT NULL,
	object_owner_id id_t,
	object_owner1_id t_guid,
	id_log id_t
);
ALTER TABLE obj_object ADD CONSTRAINT pk_obj_object PRIMARY KEY(object_id);
CREATE UNIQUE INDEX ak1_obj_object ON obj_object (object_uuid);
CREATE INDEX ie1_obj_object ON obj_object (object_owner_id);
CREATE INDEX ie2_obj_object ON obj_object (object_owner1_id);
CREATE INDEX ie3_obj_object ON obj_object (object_type_id);
CREATE INDEX ie4_obj_object ON obj_object (object_create_date,object_mod_date,object_read_date);
ALTER TABLE obj_object ADD CONSTRAINT fk_obj_object_grouping FOREIGN KEY (parent_object_id) REFERENCES obj_object(object_id) ON DELETE RESTRICT ON UPDATE RESTRICT;
CREATE TABLE obj_codifier_hist (
	codif_id id_t NOT NULL DEFAULT NULL::bigint,
	parent_codif_id id_t,
	small_code t_code1 NOT NULL,
	codif_code t_str60 NOT NULL,
	codif_name t_str250 NOT NULL,
	create_date t_timestamp NOT NULL DEFAULT NULL::timestamp without time zone,
	date_from t_timestamp NOT NULL DEFAULT NULL::timestamp without time zone,
	date_to t_timestamp NOT NULL DEFAULT NULL::timestamp without time zone,
	codif_uuid t_guid NOT NULL,
	id_log id_t,
	codif_hist_id id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass)
);
CREATE TABLE com_log (
	id_log id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass),
	user_name t_str250 NOT NULL,
	host_name t_str250,
	impact_type t_code1 NOT NULL,
	impact_date t_timestamp NOT NULL,
	impact_descr t_text NOT NULL,
	schema_name t_sysname NOT NULL DEFAULT 'com'::character varying
);
ALTER TABLE com_log ADD CONSTRAINT pk_com_log PRIMARY KEY(id_log);
CREATE INDEX ie1_com_log ON com_log (impact_date,impact_type);
CREATE INDEX ie2_com_log ON com_log (user_name,impact_date,impact_type);
CREATE TABLE obj_errors (
	err_code t_code5 NOT NULL,
	message_out t_text NOT NULL,
	sch_name t_sysname NOT NULL DEFAULT ''::character varying,
	qty small_t NOT NULL DEFAULT 0
);
ALTER TABLE obj_errors ADD CONSTRAINT pk_obj_errors PRIMARY KEY(err_code);
CREATE INDEX ie1_obj_errors ON obj_errors (sch_name);
CREATE TABLE all_log (
	id_log id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass),
	user_name t_str250 NOT NULL,
	host_name t_str250,
	impact_type t_code1 NOT NULL,
	impact_date t_timestamp NOT NULL,
	impact_descr t_text NOT NULL,
	schema_name t_sysname NOT NULL
);
ALTER TABLE all_log ADD CONSTRAINT pk_all_log PRIMARY KEY(id_log);
CREATE INDEX ie1_all_log ON all_log (schema_name,impact_date,impact_type);
CREATE INDEX ie2_all_log ON all_log (user_name);
CREATE TABLE obj_codifier (
	codif_id id_t NOT NULL DEFAULT nextval('obj_codifier_codif_id_seq'::regclass),
	parent_codif_id id_t,
	small_code t_code1 NOT NULL,
	codif_code t_str60 NOT NULL,
	codif_name t_str250 NOT NULL,
	create_date t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	date_from t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	date_to t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	codif_uuid t_guid NOT NULL,
	id_log id_t
);
ALTER TABLE obj_codifier ADD CONSTRAINT pk_obj_codifier PRIMARY KEY(codif_id);
CREATE UNIQUE INDEX ak1_obj_codifier ON obj_codifier (codif_code);
CREATE UNIQUE INDEX ak2_obj_codifier ON obj_codifier (codif_name,parent_codif_id);
CREATE UNIQUE INDEX ak3_obj_codifier ON obj_codifier (small_code);
CREATE UNIQUE INDEX ak4_obj_codifier ON obj_codifier (codif_uuid);
CREATE TABLE com_obj_nso_relation (
	obj_object_id id_t NOT NULL,
	nso_record_id id_t NOT NULL,
	perm_type_id id_t NOT NULL,
	rel_date_create t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	rel_status t_boolean NOT NULL DEFAULT true,
	id_log id_t
);
CREATE TABLE nso_domain_column (
	attr_id id_t NOT NULL DEFAULT nextval('nso_domain_column_attr_id_seq'::regclass),
	parent_attr_id id_t,
	attr_type_id id_t NOT NULL,
	small_code t_code1 NOT NULL,
	attr_uuid t_guid NOT NULL,
	attr_create_date t_timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP)::timestamp(0) without time zone,
	is_intra_op t_boolean NOT NULL DEFAULT false,
	attr_code t_str60 NOT NULL,
	attr_name t_str250 NOT NULL,
	domain_nso_id id_t,
	domain_nso_code t_str60,
	date_from t_timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP)::t_timestamp,
	date_to t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	id_log id_t
);
ALTER TABLE nso_domain_column ADD CONSTRAINT pk_nso_domain_column PRIMARY KEY(attr_id);
CREATE UNIQUE INDEX ak1_nso_domain_column ON nso_domain_column (attr_code);
CREATE UNIQUE INDEX ak2_nso_domain_column ON nso_domain_column (attr_name);
CREATE UNIQUE INDEX ak3_nso_domain_column ON nso_domain_column (attr_uuid);
CREATE INDEX ie1_nso_domain_column ON nso_domain_column (date_from);
CREATE TABLE obj_object_hist (
	object_id id_t NOT NULL DEFAULT NULL::bigint,
	parent_object_id id_t,
	object_type_id id_t NOT NULL,
	object_stype_id id_t,
	object_short_name t_str60,
	object_uuid t_guid NOT NULL,
	object_create_date t_timestamp NOT NULL DEFAULT NULL::timestamp without time zone,
	object_mod_date t_timestamp,
	object_read_date t_timestamp,
	object_deact_date t_timestamp,
	object_secret_id id_t NOT NULL,
	object_owner_id id_t,
	object_owner1_id t_guid,
	id_log id_t,
	object_hist_id id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass)
);
CREATE TABLE exn_obj_relation (
	exn_parent_object_id id_t NOT NULL,
	exn_obj_object_id id_t NOT NULL,
	exn_perm_type_id id_t NOT NULL,
	exn_date_create t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	exn_status t_boolean NOT NULL DEFAULT false,
	id_log id_t
);
ALTER TABLE exn_obj_relation ADD CONSTRAINT pk_pmt_obj_relation PRIMARY KEY(exn_parent_object_id,exn_obj_object_id,exn_perm_type_id);
CREATE TABLE nso_domain_column_hist (
	attr_id id_t NOT NULL DEFAULT NULL::bigint,
	parent_attr_id id_t,
	attr_type_id id_t NOT NULL,
	small_code t_code1 NOT NULL,
	attr_uuid t_guid NOT NULL,
	attr_create_date t_timestamp NOT NULL DEFAULT NULL::timestamp without time zone,
	is_intra_op t_boolean NOT NULL DEFAULT NULL::boolean,
	attr_code t_str60 NOT NULL,
	attr_name t_str250 NOT NULL,
	domain_nso_id id_t,
	domain_nso_code t_str60,
	date_from t_timestamp NOT NULL DEFAULT NULL::timestamp without time zone,
	date_to t_timestamp NOT NULL DEFAULT NULL::timestamp without time zone,
	id_log id_t,
	domain_hist_id id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass)
);
ALTER TABLE nso_domain_column_hist ADD CONSTRAINT pk_nso_domain_column_hist PRIMARY KEY(domain_hist_id);
CREATE UNIQUE INDEX ak1_domain_hist ON nso_domain_column_hist (attr_id,id_log);
CREATE INDEX ie1_domain_hist ON nso_domain_column_hist (date_from);
CREATE TABLE sys_errors (
	err_id bigserial NOT NULL DEFAULT nextval('sys_errors_err_id_seq1'::regclass),
	err_code t_code5 NOT NULL,
	message_out t_text,
	sch_name t_sysname NOT NULL,
	constr_name t_sysname NOT NULL,
	opr_type t_code1 NOT NULL,
	tbl_name t_sysname NOT NULL
);
ALTER TABLE sys_errors ADD CONSTRAINT pk_sys_errors PRIMARY KEY(err_id);
CREATE UNIQUE INDEX ak1_sys_errors ON sys_errors (err_code,constr_name,tbl_name,opr_type);
ALTER TABLE obj_codifier_hist ADD CONSTRAINT fk_obj_codifier_hist_has_com_log FOREIGN KEY (id_log) REFERENCES com_log(id_log) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE obj_codifier ADD CONSTRAINT fk_obj_codifier_can_has_com_log FOREIGN KEY (id_log) REFERENCES com_log(id_log) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE obj_codifier ADD CONSTRAINT fk_obj_codifier_grouping_obj_codifier FOREIGN KEY (parent_codif_id) REFERENCES obj_codifier(codif_id) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE nso_domain_column ADD CONSTRAINT fk_nso_domain_column_can_have_com_log FOREIGN KEY (id_log) REFERENCES com_log(id_log) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE nso_domain_column ADD CONSTRAINT fk_nso_domain_column_grouping_nso_domain_column FOREIGN KEY (parent_attr_id) REFERENCES nso_domain_column(attr_id) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE nso_domain_column ADD CONSTRAINT fk_obj_codifier_typify_nso_domain_column FOREIGN KEY (attr_type_id) REFERENCES obj_codifier(codif_id) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE obj_object_hist ADD CONSTRAINT fk_obj_object_hist_hase_com_log FOREIGN KEY (id_log) REFERENCES com_log(id_log) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE nso_domain_column_hist ADD CONSTRAINT fk_nso_domain_column_hist_hase_com_log FOREIGN KEY (id_log) REFERENCES com_log(id_log) ON DELETE RESTRICT ON UPDATE RESTRICT;
