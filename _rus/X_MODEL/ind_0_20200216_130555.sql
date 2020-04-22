CREATE TABLE ind_indicator (
	ind_id id_t NOT NULL DEFAULT nextval('ind.ind_indicator_ind_id_seq'::regclass),
	parent_ind_id id_t,
	ind_type_id id_t NOT NULL,
	object_id id_t NOT NULL,
	date_system_write t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	subject_id id_t
);
ALTER TABLE ind_indicator ADD CONSTRAINT pk_ind_indicator PRIMARY KEY(ind_id);
CREATE INDEX ie1_ind_indicator ON ind_indicator (object_id,ind_id);
CREATE INDEX ie2_ind_indicator ON ind_indicator (object_id,subject_id,ind_type_id);
DROP TABLE ind_indicator;
CREATE TABLE ind_indicator (
	ind_id id_t NOT NULL DEFAULT nextval('ind.ind_indicator_ind_id_seq'::regclass),
	parent_ind_id id_t,
	ind_type_id id_t NOT NULL,
	object_id id_t NOT NULL,
	date_system_write t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	subject_id id_t
);
ALTER TABLE ind_indicator ADD CONSTRAINT pk_ind_indicator PRIMARY KEY(ind_id);
CREATE INDEX ie1_ind_indicator ON ind_indicator (object_id,ind_id);
CREATE INDEX ie2_ind_indicator ON ind_indicator (object_id,subject_id,ind_type_id);
ALTER TABLE ind_indicator ADD CONSTRAINT fk_ind_indicator_grouping_itself FOREIGN KEY (parent_ind_id) REFERENCES ind_indicator(ind_id) ON DELETE RESTRICT ON UPDATE RESTRICT;
CREATE TABLE obj_codifier (
	codif_id bigserial NOT NULL DEFAULT nextval('com.obj_codifier_codif_id_seq'::regclass),
	parent_codif_id id_t,
	small_code t_code1 NOT NULL,
	codif_code t_str60 NOT NULL,
	codif_name t_str250 NOT NULL,
	create_date t_timestamp NOT NULL DEFAULT (('now'::text)::timestamp(0) with time zone)::timestamp(0) without time zone,
	date_from t_timestamp NOT NULL DEFAULT (('now'::text)::timestamp(0) with time zone)::timestamp(0) without time zone,
	date_to t_timestamp NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
	codif_uuid t_guid NOT NULL,
	id_log id_t
);
ALTER TABLE obj_codifier ADD CONSTRAINT pk_obj_codifier PRIMARY KEY(codif_id);
CREATE UNIQUE INDEX ak1_obj_codifier ON obj_codifier (codif_code);
CREATE UNIQUE INDEX ak2_obj_codifier ON obj_codifier (codif_name,parent_codif_id);
CREATE UNIQUE INDEX ak3_obj_codifier ON obj_codifier (small_code);
CREATE UNIQUE INDEX ak4_obj_codifier ON obj_codifier (codif_uuid);
ALTER TABLE obj_codifier ADD CONSTRAINT fk_obj_codifier_grouping_obj_codifier FOREIGN KEY (parent_codif_id) REFERENCES obj_codifier(codif_id) ON DELETE RESTRICT ON UPDATE RESTRICT;
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
DROP TABLE obj_object;
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
DROP TABLE obj_codifier;
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
DROP TABLE obj_object;
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
ALTER TABLE obj_codifier ADD CONSTRAINT fk_obj_codifier_grouping_obj_codifier FOREIGN KEY (parent_codif_id) REFERENCES obj_codifier(codif_id) ON DELETE RESTRICT ON UPDATE RESTRICT;
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
DROP TABLE obj_object;
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
CREATE TABLE obj_object (
	object_id bigserial NOT NULL DEFAULT nextval('com.obj_object_object_id_seq'::regclass),
	parent_object_id id_t,
	object_type_id id_t NOT NULL,
	object_uuid t_guid NOT NULL,
	object_create_date t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	object_mod_date t_timestamp,
	object_read_date t_timestamp,
	object_secret_id id_t NOT NULL,
	object_owner_id id_t NOT NULL,
	id_log id_t,
	object_owner1_id t_guid,
	object_deact_date t_timestamp,
	object_stype_id id_t
);
ALTER TABLE obj_object ADD CONSTRAINT pk_obj_object PRIMARY KEY(object_id);
CREATE UNIQUE INDEX ak1_obj_object ON obj_object (object_uuid);
DROP TABLE obj_object;
CREATE TABLE obj_object (
	object_id bigserial NOT NULL DEFAULT nextval('com.obj_object_object_id_seq'::regclass),
	parent_object_id id_t,
	object_type_id id_t NOT NULL,
	object_uuid t_guid NOT NULL,
	object_create_date t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	object_mod_date t_timestamp,
	object_read_date t_timestamp,
	object_secret_id id_t NOT NULL,
	object_owner_id id_t NOT NULL,
	id_log id_t,
	object_owner1_id t_guid,
	object_deact_date t_timestamp,
	object_stype_id id_t
);
ALTER TABLE obj_object ADD CONSTRAINT pk_obj_object PRIMARY KEY(object_id);
CREATE UNIQUE INDEX ak1_obj_object ON obj_object (object_uuid);
CREATE TABLE obj_object_hist (
	object_id bigserial NOT NULL DEFAULT nextval('com.obj_object_object_id_seq'::regclass),
	parent_object_id id_t,
	object_type_id id_t NOT NULL,
	object_uuid t_guid NOT NULL,
	object_create_date t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	object_mod_date t_timestamp,
	object_read_date t_timestamp,
	object_secret_id id_t NOT NULL,
	object_owner_id id_t NOT NULL,
	id_log id_t NOT NULL,
	object_owner1_id t_guid,
	object_deact_date t_timestamp,
	object_stype_id id_t,
	object_hist_id bigserial NOT NULL DEFAULT nextval('com.all_history_id_seq'::regclass)
);
ALTER TABLE obj_object_hist ADD CONSTRAINT pk_obj_object_hist PRIMARY KEY(object_hist_id);
CREATE TABLE obj_object (
	object_id bigserial NOT NULL DEFAULT nextval('com.obj_object_object_id_seq'::regclass),
	parent_object_id id_t,
	object_type_id id_t NOT NULL,
	object_uuid t_guid NOT NULL,
	object_create_date t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	object_mod_date t_timestamp,
	object_read_date t_timestamp,
	object_secret_id id_t NOT NULL,
	object_owner_id id_t NOT NULL,
	id_log id_t,
	object_owner1_id t_guid,
	object_deact_date t_timestamp,
	object_stype_id id_t
);
ALTER TABLE obj_object ADD CONSTRAINT pk_obj_object PRIMARY KEY(object_id);
CREATE UNIQUE INDEX ak1_obj_object ON obj_object (object_uuid);
DROP TABLE obj_object;
CREATE TABLE obj_object (
	object_id bigserial NOT NULL DEFAULT nextval('com.obj_object_object_id_seq'::regclass),
	parent_object_id id_t,
	object_type_id id_t NOT NULL,
	object_uuid t_guid NOT NULL,
	object_create_date t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	object_mod_date t_timestamp,
	object_read_date t_timestamp,
	object_secret_id id_t NOT NULL,
	object_owner_id id_t NOT NULL,
	id_log id_t,
	object_owner1_id t_guid,
	object_deact_date t_timestamp,
	object_stype_id id_t
);
ALTER TABLE obj_object ADD CONSTRAINT pk_obj_object PRIMARY KEY(object_id);
CREATE UNIQUE INDEX ak1_obj_object ON obj_object (object_uuid);
CREATE TABLE obj_object (
	object_id bigserial NOT NULL DEFAULT nextval('com.obj_object_object_id_seq'::regclass),
	parent_object_id id_t,
	object_type_id id_t NOT NULL,
	object_uuid t_guid NOT NULL,
	object_create_date t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	object_mod_date t_timestamp,
	object_read_date t_timestamp,
	object_secret_id id_t NOT NULL,
	object_owner_id id_t NOT NULL,
	id_log id_t,
	object_owner1_id t_guid,
	object_deact_date t_timestamp,
	object_stype_id id_t
);
ALTER TABLE obj_object ADD CONSTRAINT pk_obj_object PRIMARY KEY(object_id);
CREATE UNIQUE INDEX ak1_obj_object ON obj_object (object_uuid);
DROP TABLE obj_object;
CREATE TABLE obj_object (
	object_id bigserial NOT NULL DEFAULT nextval('com.obj_object_object_id_seq'::regclass),
	parent_object_id id_t,
	object_type_id id_t NOT NULL,
	object_uuid t_guid NOT NULL,
	object_create_date t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	object_mod_date t_timestamp,
	object_read_date t_timestamp,
	object_secret_id id_t NOT NULL,
	object_owner_id id_t NOT NULL,
	id_log id_t,
	object_owner1_id t_guid,
	object_deact_date t_timestamp,
	object_stype_id id_t
);
ALTER TABLE obj_object ADD CONSTRAINT pk_obj_object PRIMARY KEY(object_id);
CREATE UNIQUE INDEX ak1_obj_object ON obj_object (object_uuid);
CREATE TABLE obj_object_hist (
	object_id bigserial NOT NULL DEFAULT nextval('com.obj_object_object_id_seq'::regclass),
	parent_object_id id_t,
	object_type_id id_t NOT NULL,
	object_uuid t_guid NOT NULL,
	object_create_date t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	object_mod_date t_timestamp,
	object_read_date t_timestamp,
	object_secret_id id_t NOT NULL,
	object_owner_id id_t NOT NULL,
	id_log id_t NOT NULL,
	object_owner1_id t_guid,
	object_deact_date t_timestamp,
	object_stype_id id_t,
	object_hist_id bigserial NOT NULL DEFAULT nextval('com.all_history_id_seq'::regclass)
);
ALTER TABLE obj_object_hist ADD CONSTRAINT pk_obj_object_hist PRIMARY KEY(object_hist_id);
DROP TABLE obj_object_hist;
CREATE TABLE obj_object_hist (
	object_id bigserial NOT NULL DEFAULT nextval('com.obj_object_object_id_seq'::regclass),
	parent_object_id id_t,
	object_type_id id_t NOT NULL,
	object_uuid t_guid NOT NULL,
	object_create_date t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	object_mod_date t_timestamp,
	object_read_date t_timestamp,
	object_secret_id id_t NOT NULL,
	object_owner_id id_t NOT NULL,
	id_log id_t NOT NULL,
	object_owner1_id t_guid,
	object_deact_date t_timestamp,
	object_stype_id id_t,
	object_hist_id bigserial NOT NULL DEFAULT nextval('com.all_history_id_seq'::regclass)
);
ALTER TABLE obj_object_hist ADD CONSTRAINT pk_obj_object_hist PRIMARY KEY(object_hist_id);
