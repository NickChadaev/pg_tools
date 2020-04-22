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
ALTER TABLE obj_codifier ADD CONSTRAINT fk_obj_codifier_grouping_obj_codifier FOREIGN KEY (parent_codif_id) REFERENCES obj_codifier(codif_id) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE nso_object ADD CONSTRAINT fk_obj_codifier_typify_nso_object FOREIGN KEY (nso_type_id) REFERENCES obj_codifier(codif_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_record ADD CONSTRAINT fk_nso_object_contains_nso_records FOREIGN KEY (nso_id) REFERENCES nso_object(nso_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_record ADD CONSTRAINT fk_nso_rec_groups_nso_rec FOREIGN KEY (parent_rec_id) REFERENCES nso_record(rec_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
