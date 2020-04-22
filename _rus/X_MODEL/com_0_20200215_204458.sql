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
