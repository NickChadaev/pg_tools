ALTER TABLE obj_object_hist DROP CONSTRAINT fk_obj_object_hist_hase_com_log;
DROP TABLE obj_object_hist;
ALTER TABLE obj_object DROP CONSTRAINT fk_obj_object_grouping;
DROP TABLE obj_object;
ALTER TABLE nso_domain_column_hist DROP CONSTRAINT fk_nso_domain_column_hist_hase_com_log;
ALTER TABLE nso_domain_column DROP CONSTRAINT fk_nso_domain_column_can_have_com_log;
ALTER TABLE obj_codifier DROP CONSTRAINT fk_obj_codifier_can_has_com_log;
ALTER TABLE obj_codifier_hist DROP CONSTRAINT fk_obj_codifier_hist_has_com_log;
DROP TABLE com_log;
ALTER TABLE nso_domain_column DROP CONSTRAINT fk_obj_codifier_typify_nso_domain_column;
ALTER TABLE nso_domain_column DROP CONSTRAINT fk_nso_domain_column_grouping_nso_domain_column;
DROP TABLE nso_domain_column;
DROP TABLE obj_errors;
DROP TABLE sys_errors;
ALTER TABLE obj_codifier DROP CONSTRAINT fk_obj_codifier_grouping_obj_codifier;
DROP TABLE obj_codifier;
DROP TABLE obj_codifier_hist;
DROP TABLE exn_obj_relation;
DROP TABLE nso_domain_column_hist;
DROP TABLE all_log;
DROP TABLE com_obj_nso_relation;
CREATE TABLE nso_key_hist (
	key_id id_t NOT NULL DEFAULT nextval('nso_key_key_id_seq'::regclass),
	nso_id id_t NOT NULL,
	key_type_id id_t NOT NULL,
	key_small_code t_code1 NOT NULL,
	key_code t_str60 NOT NULL,
	on_off t_boolean NOT NULL DEFAULT true,
	date_from t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	date_to t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	log_id id_t NOT NULL DEFAULT 0,
	key_hist_id id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass)
);
ALTER TABLE nso_key_hist ADD CONSTRAINT pk_nso_key_hist PRIMARY KEY(key_hist_id);
CREATE TABLE nso_log (
	id_log id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass),
	user_name t_str250 NOT NULL,
	host_name t_str250,
	impact_type t_code1 NOT NULL,
	impact_date t_timestamp NOT NULL,
	impact_descr t_text NOT NULL,
	schema_name t_sysname NOT NULL
);
CREATE TABLE nso_key_attr (
	key_id id_t NOT NULL,
	col_id id_t NOT NULL,
	column_nm small_t NOT NULL DEFAULT 0,
	date_from t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	date_to t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	log_id id_t NOT NULL DEFAULT 0
);
ALTER TABLE nso_key_attr ADD CONSTRAINT pk_nso_key_attr PRIMARY KEY(key_id,col_id);
CREATE TABLE nso_key_attr_hist (
	key_id id_t NOT NULL,
	col_id id_t NOT NULL,
	column_nm small_t NOT NULL DEFAULT 0,
	date_from t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	date_to t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	log_id id_t NOT NULL DEFAULT 0,
	key_attr_hist_id id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass)
);
ALTER TABLE nso_key_attr_hist ADD CONSTRAINT pk_nso_key_attr_hist PRIMARY KEY(key_attr_hist_id);
CREATE TABLE nso_abs_0 (
	rec_id id_t NOT NULL,
	col_id id_t NOT NULL,
	s_type_code t_code1 NOT NULL,
	s_key_code t_code1 NOT NULL DEFAULT '0'::bpchar,
	section_number smallint NOT NULL DEFAULT 0,
	is_actual t_boolean NOT NULL DEFAULT true,
	log_id id_t NOT NULL DEFAULT 0,
	val_cell_abs t_text
);
ALTER TABLE nso_abs_0 ADD CONSTRAINT pk_nso_abs_0 PRIMARY KEY(section_number,rec_id,col_id);
CREATE INDEX ie_a_nso_abs_0 ON nso_abs_0 (val_cell_abs);
CREATE INDEX ie_b_nso_abs_0 ON nso_abs_0 (val_cell_abs);
CREATE INDEX ie_c_nso_abs_0 ON nso_abs_0 (val_cell_abs);
CREATE INDEX ie_d_nso_abs_0 ON nso_abs_0 (val_cell_abs);
CREATE INDEX ie_e_nso_abs_0 ON nso_abs_0 (val_cell_abs);
CREATE INDEX ie_g_nso_abs_0 ON nso_abs_0 (val_cell_abs);
CREATE TABLE nso_column_head (
	col_id id_t NOT NULL DEFAULT nextval('nso_column_head_col_id_seq'::regclass),
	parent_col_id id_t,
	attr_id id_t NOT NULL,
	attr_scode t_code1 NOT NULL,
	nso_id id_t NOT NULL,
	col_code t_str60 NOT NULL,
	col_name t_str250 NOT NULL,
	number_col small_t NOT NULL DEFAULT 0,
	mandatory t_boolean NOT NULL DEFAULT false,
	date_from t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	date_to t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	log_id id_t NOT NULL DEFAULT 0
);
ALTER TABLE nso_column_head ADD CONSTRAINT pk_nso_column_head PRIMARY KEY(col_id);
CREATE UNIQUE INDEX ak1_nso_column_head ON nso_column_head (nso_id,col_code);
CREATE INDEX ie2_nso_column_head ON nso_column_head (col_name);
CREATE TABLE nso_section (
	section_number smallint NOT NULL DEFAULT nextval('section_number_seq'::regclass),
	crt_on_nso_abs t_boolean NOT NULL DEFAULT true,
	crt_on_nso_blob t_boolean NOT NULL DEFAULT false,
	date_from t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	date_to t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	section_descr t_text,
	crt_table_1 t_text,
	crt_table_2 t_text,
	crt_trigger_1 t_text,
	crt_trigger_2 t_text,
	log_id id_t
);
ALTER TABLE nso_section ADD CONSTRAINT pk_nso_section PRIMARY KEY(section_number);
CREATE TABLE nso_key (
	key_id id_t NOT NULL DEFAULT nextval('nso_key_key_id_seq'::regclass),
	nso_id id_t NOT NULL,
	key_type_id id_t NOT NULL,
	key_small_code t_code1 NOT NULL,
	key_code t_str60 NOT NULL,
	on_off t_boolean NOT NULL DEFAULT true,
	date_from t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	date_to t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	log_id id_t NOT NULL DEFAULT 0
);
ALTER TABLE nso_key ADD CONSTRAINT pk_nso_key PRIMARY KEY(key_id);
CREATE UNIQUE INDEX ak1_nso_key ON nso_key (key_code);
CREATE TABLE nso_ref (
	rec_id id_t NOT NULL,
	col_id id_t NOT NULL,
	is_actual t_boolean NOT NULL DEFAULT true,
	log_id id_t NOT NULL DEFAULT 0,
	ref_rec_id id_t
);
ALTER TABLE nso_ref ADD CONSTRAINT pk_nso_ref PRIMARY KEY(rec_id,col_id);
CREATE TABLE nso_abs (
	rec_id id_t NOT NULL,
	col_id id_t NOT NULL,
	s_type_code t_code1 NOT NULL,
	s_key_code t_code1 NOT NULL DEFAULT '0'::bpchar,
	section_number smallint NOT NULL DEFAULT 0,
	is_actual t_boolean NOT NULL DEFAULT true,
	log_id id_t NOT NULL DEFAULT 0,
	val_cell_abs t_text
);
CREATE TABLE nso_abs_hist (
	rec_id id_t NOT NULL,
	col_id id_t NOT NULL,
	s_type_code t_code1 NOT NULL,
	s_key_code t_code1 NOT NULL,
	section_number smallint NOT NULL,
	is_actual t_boolean NOT NULL,
	log_id id_t NOT NULL,
	val_cell_abs t_text,
	abs_hist_id id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass)
);
ALTER TABLE nso_abs_hist ADD CONSTRAINT pk_nso_abs_hist PRIMARY KEY(abs_hist_id);
CREATE TABLE nso_record_unique (
	rec_id id_t NOT NULL,
	scode t_code1 NOT NULL,
	unique_check t_boolean NOT NULL DEFAULT false
);
ALTER TABLE nso_record_unique ADD CONSTRAINT pk_nso_record_unique PRIMARY KEY(rec_id,scode);
CREATE UNIQUE INDEX ak1_nso_record_unique ON nso_record_unique (scode,unique_check,nso_f_nso_record_unique_sign_idx(rec_id, scode));
CREATE TABLE nso_blob_0 (
	rec_id id_t NOT NULL,
	col_id id_t NOT NULL,
	is_actual t_boolean NOT NULL DEFAULT true,
	log_id id_t NOT NULL DEFAULT 0,
	s_type_code t_code1 NOT NULL DEFAULT '0'::bpchar,
	section_number smallint NOT NULL DEFAULT 0,
	val_cel_hash t_str100,
	val_cel_data_name t_fullname,
	val_cell_blob t_blob
);
ALTER TABLE nso_blob_0 ADD CONSTRAINT pk_nso_blob_0 PRIMARY KEY(section_number,rec_id,col_id);
CREATE TABLE nso_object (
	nso_id id_t NOT NULL DEFAULT nextval('nso_object_nso_id_seq'::regclass),
	parent_nso_id id_t,
	nso_type_id id_t NOT NULL,
	nso_uuid t_guid NOT NULL,
	date_create t_timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP)::t_timestamp,
	nso_release small_t NOT NULL DEFAULT 0,
	active_sign t_boolean NOT NULL DEFAULT false,
	is_group_nso t_boolean NOT NULL DEFAULT false,
	is_intra_op t_boolean NOT NULL DEFAULT false,
	is_m_view t_boolean NOT NULL DEFAULT false,
	unique_check t_boolean NOT NULL DEFAULT false,
	nso_code t_str60 NOT NULL,
	nso_name t_str250 NOT NULL,
	nso_select t_text,
	section_number smallint NOT NULL DEFAULT 0,
	date_from t_timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP)::t_timestamp,
	date_to t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	id_log id_t NOT NULL DEFAULT 0
);
ALTER TABLE nso_object ADD CONSTRAINT pk_nso_object PRIMARY KEY(nso_id);
CREATE UNIQUE INDEX ak1_nso_object ON nso_object (nso_code);
CREATE UNIQUE INDEX ak2_nso_object ON nso_object (nso_name);
CREATE UNIQUE INDEX ak3_nso_object ON nso_object (nso_uuid);
CREATE INDEX ie1_nso_object ON nso_object (date_from);
CREATE TABLE nso_ref_hist (
	rec_id id_t NOT NULL,
	col_id id_t NOT NULL,
	is_actual t_boolean NOT NULL DEFAULT true,
	log_id id_t NOT NULL DEFAULT 0,
	ref_rec_id id_t,
	ref_hist_id id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass)
);
ALTER TABLE nso_ref_hist ADD CONSTRAINT pk_nso_ref_hist PRIMARY KEY(ref_hist_id);
CREATE TABLE nso_object_hist (
	nso_id id_t NOT NULL DEFAULT nextval('nso_object_nso_id_seq'::regclass),
	parent_nso_id id_t,
	nso_type_id id_t NOT NULL,
	nso_uuid t_guid NOT NULL,
	date_create t_timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP)::t_timestamp,
	nso_release small_t NOT NULL DEFAULT 0,
	active_sign t_boolean NOT NULL DEFAULT false,
	is_group_nso t_boolean NOT NULL DEFAULT false,
	is_intra_op t_boolean NOT NULL DEFAULT false,
	is_m_view t_boolean NOT NULL DEFAULT false,
	unique_check t_boolean NOT NULL DEFAULT false,
	nso_code t_str60 NOT NULL,
	nso_name t_str250 NOT NULL,
	nso_select t_text,
	section_number smallint NOT NULL DEFAULT 0,
	date_from t_timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP)::t_timestamp,
	date_to t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	id_log id_t NOT NULL DEFAULT 0,
	obj_hist_id id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass)
);
ALTER TABLE nso_object_hist ADD CONSTRAINT pk_nso_object_hist PRIMARY KEY(obj_hist_id);
CREATE TABLE nso_blob_hist (
	rec_id id_t NOT NULL,
	col_id id_t NOT NULL,
	is_actual t_boolean NOT NULL,
	log_id id_t NOT NULL,
	s_type_code t_code1 NOT NULL,
	section_number smallint NOT NULL,
	val_cel_hash t_str100,
	val_cel_data_name t_fullname,
	val_cell_blob t_blob,
	blob_hist_id id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass)
);
ALTER TABLE nso_blob_hist ADD CONSTRAINT pk_nso_blob_hist PRIMARY KEY(blob_hist_id);
CREATE TABLE nso_column_head_hist (
	col_id id_t NOT NULL DEFAULT nextval('nso_column_head_col_id_seq'::regclass),
	parent_col_id id_t,
	attr_id id_t NOT NULL,
	attr_scode t_code1 NOT NULL,
	nso_id id_t NOT NULL,
	col_code t_str60 NOT NULL,
	col_name t_str250 NOT NULL,
	number_col small_t NOT NULL DEFAULT 0,
	mandatory t_boolean NOT NULL DEFAULT false,
	date_from t_timestamp NOT NULL DEFAULT (now())::t_timestamp,
	date_to t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	log_id id_t NOT NULL DEFAULT 0,
	col_hist_id id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass)
);
ALTER TABLE nso_column_head_hist ADD CONSTRAINT pk_nso_column_head_hist PRIMARY KEY(col_hist_id);
CREATE TABLE nso_record (
	rec_id id_t NOT NULL DEFAULT nextval('nso_record_rec_id_seq'::regclass),
	parent_rec_id id_t,
	rec_uuid t_guid NOT NULL,
	nso_id id_t NOT NULL,
	actual t_boolean NOT NULL DEFAULT true,
	section_number smallint NOT NULL DEFAULT 0,
	date_from t_timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP)::t_timestamp,
	date_to t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	log_id id_t NOT NULL DEFAULT 0
);
ALTER TABLE nso_record ADD CONSTRAINT pk_nso_record PRIMARY KEY(rec_id);
CREATE UNIQUE INDEX ak1_nso_record ON nso_record (rec_uuid);
CREATE INDEX ie1_nso_record ON nso_record (date_from);
CREATE INDEX ie2_nso_record ON nso_record (nso_id);
CREATE TABLE nso_record_hist (
	rec_id id_t NOT NULL DEFAULT nextval('nso_record_rec_id_seq'::regclass),
	parent_rec_id id_t,
	rec_uuid t_guid NOT NULL,
	nso_id id_t NOT NULL,
	actual t_boolean NOT NULL DEFAULT true,
	section_number smallint NOT NULL DEFAULT 0,
	date_from t_timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP)::t_timestamp,
	date_to t_timestamp NOT NULL DEFAULT ('9999-12-31 00:00:00'::timestamp without time zone)::t_timestamp,
	log_id id_t NOT NULL DEFAULT 0,
	rec_hist id_t NOT NULL DEFAULT nextval('all_history_id_seq'::regclass)
);
ALTER TABLE nso_record_hist ADD CONSTRAINT pk_nso_record_hist PRIMARY KEY(rec_hist);
CREATE TABLE nso_blob (
	rec_id id_t NOT NULL,
	col_id id_t NOT NULL,
	is_actual t_boolean NOT NULL DEFAULT true,
	log_id id_t NOT NULL DEFAULT 0,
	s_type_code t_code1 NOT NULL DEFAULT '0'::bpchar,
	section_number smallint NOT NULL DEFAULT 0,
	val_cel_hash t_str100,
	val_cel_data_name t_fullname,
	val_cell_blob t_blob
);
