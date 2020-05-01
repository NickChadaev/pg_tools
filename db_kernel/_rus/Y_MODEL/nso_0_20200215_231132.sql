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
ALTER TABLE nso_domain_column ADD CONSTRAINT fk_nso_domain_column_grouping_nso_domain_column FOREIGN KEY (parent_attr_id) REFERENCES nso_domain_column(attr_id) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE nso_domain_column ADD CONSTRAINT fk_obj_codifier_typify_nso_domain_column FOREIGN KEY (attr_type_id) REFERENCES obj_codifier(codif_id) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE nso_column_head ADD CONSTRAINT fk_nso_domain_column_define_nso_column_head FOREIGN KEY (attr_id) REFERENCES nso_domain_column(attr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_column_head ADD CONSTRAINT fk_nso_log_idents_nso_column_head FOREIGN KEY (log_id) REFERENCES nso_log(id_log) ON DELETE NO ACTION ON UPDATE NO ACTION;
