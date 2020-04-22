CREATE TABLE nso_domain_column (
	attr_id bigserial NOT NULL DEFAULT nextval('com.nso_domain_column_attr_id_seq'::regclass),
	parent_attr_id id_t,
	attr_type_id id_t NOT NULL,
	small_code t_code1 NOT NULL,
	attr_uuid t_guid NOT NULL,
	attr_create_date t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	is_intra_op t_boolean NOT NULL DEFAULT false,
	attr_code t_str60 NOT NULL,
	attr_name t_str250 NOT NULL,
	domain_nso_id id_t,
	date_from t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	date_to t_timestamp NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
	id_log id_t,
	domain_nso_code t_str60
);
ALTER TABLE nso_domain_column ADD CONSTRAINT pk_nso_domain_column PRIMARY KEY(attr_id);
CREATE UNIQUE INDEX ak1_nso_domain_column ON nso_domain_column (attr_code);
CREATE UNIQUE INDEX ak2_nso_domain_column ON nso_domain_column (attr_name);
CREATE UNIQUE INDEX ak3_nso_domain_column ON nso_domain_column (attr_uuid);
CREATE INDEX ie1_nso_domain_column ON nso_domain_column (date_from);
