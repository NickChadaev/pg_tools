ALTER TABLE obj_object DROP CONSTRAINT fk_obj_object_grouping;
DROP TABLE obj_object;
ALTER TABLE obj_codifier_hist DROP CONSTRAINT fk_obj_codifier_hist_has_com_log;
DROP TABLE obj_codifier_hist;
ALTER TABLE obj_object_hist DROP CONSTRAINT fk_obj_object_hist_hase_com_log;
DROP TABLE obj_object_hist;
ALTER TABLE nso_domain_column DROP CONSTRAINT fk_obj_codifier_typify_nso_domain_column;
ALTER TABLE obj_codifier DROP CONSTRAINT fk_obj_codifier_grouping_obj_codifier;
ALTER TABLE obj_codifier DROP CONSTRAINT fk_obj_codifier_can_has_com_log;
DROP TABLE obj_codifier;
ALTER TABLE nso_domain_column DROP CONSTRAINT fk_nso_domain_column_grouping_nso_domain_column;
ALTER TABLE nso_domain_column DROP CONSTRAINT fk_nso_domain_column_can_have_com_log;
DROP TABLE nso_domain_column;
DROP TABLE obj_errors;
DROP TABLE sys_errors;
ALTER TABLE nso_domain_column_hist DROP CONSTRAINT fk_nso_domain_column_hist_hase_com_log;
DROP TABLE nso_domain_column_hist;
DROP TABLE com_log;
DROP TABLE com_obj_nso_relation;
DROP TABLE all_log;
DROP TABLE exn_obj_relation;
CREATE TABLE ind_indicator (
	ind_id id_t NOT NULL DEFAULT nextval('ind_indicator_ind_id_seq'::regclass),
	parent_ind_id id_t,
	ind_type_id id_t NOT NULL,
	subject_id id_t,
	object_id id_t NOT NULL,
	date_system_write t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone
);
ALTER TABLE ind_indicator ADD CONSTRAINT pk_ind_indicator PRIMARY KEY(ind_id);
CREATE INDEX ie1_ind_indicator ON ind_indicator (object_id,ind_id);
CREATE INDEX ie2_ind_indicator ON ind_indicator (object_id,subject_id,ind_type_id);
CREATE TABLE ind_type_header (
	column_id id_t NOT NULL DEFAULT nextval('ind_type_header_column_id_seq'::regclass),
	parent_column_id id_t,
	ind_type_id id_t NOT NULL,
	ind_type_code t_str60 NOT NULL,
	attr_id id_t NOT NULL,
	column_code t_str60 NOT NULL,
	col_nmb small_t NOT NULL,
	column_name t_str250 NOT NULL,
	column_scode t_code1 NOT NULL,
	unit_measure_id id_t,
	date_from t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	date_to t_timestamp NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
	column_structure t_arr_id,
	ind_select t_description
);
ALTER TABLE ind_type_header ADD CONSTRAINT pk_ind_type_header PRIMARY KEY(column_id);
CREATE UNIQUE INDEX ak1_ind_type_header ON ind_type_header (attr_id,column_code,ind_type_id);
CREATE INDEX ie1_ind_type_header ON ind_type_header (ind_type_code);
