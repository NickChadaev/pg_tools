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
DROP TABLE obj_codifier;
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
ALTER TABLE obj_codifier ADD CONSTRAINT fk_obj_codifier_grouping_obj_codifier FOREIGN KEY (parent_codif_id) REFERENCES obj_codifier(codif_id) ON DELETE RESTRICT ON UPDATE RESTRICT;
