DROP TABLE ind_indicator;
DROP TABLE ind_type_header;
CREATE VIEW ind_v_contest_list AS SELECT l.ind_type_id,     c.codif_code AS ind_type_code,     c.codif_name AS ind_type_name,     l.context_sign,     d.context_descr,     c.date_from AS ind_type_date_create,     c.codif_uuid AS ind_type_uuid    FROM ind.ind_context_list l,     ind.v_spr_context_list d,     ONLY com.obj_codifier c   WHERE (((d.context_id)::smallint = (l.context_sign)::smallint) AND ((l.ind_type_id)::bigint = c.codif_id))   ORDER BY c.codif_code, l.context_sign;
CREATE TABLE ind_context_list (
	ind_list_id id_t NOT NULL DEFAULT nextval('ind.ind_context_list_ind_list_id_seq'::regclass),
	ind_list_parent_id id_t,
	ind_type_id id_t NOT NULL,
	context_sign small_t NOT NULL DEFAULT 0
);
ALTER TABLE ind_context_list ADD CONSTRAINT pk_ind_context_list PRIMARY KEY(ind_list_id);
CREATE UNIQUE INDEX ak1_ind_context_list ON ind_context_list (ind_type_id,context_sign);
CREATE TABLE ind_value_history (
	ind_id id_t NOT NULL,
	column_id id_t NOT NULL,
	context_sign small_t NOT NULL DEFAULT NULL::smallint,
	date_from t_timestamp NOT NULL DEFAULT NULL::timestamp without time zone,
	date_to t_timestamp NOT NULL DEFAULT NULL::timestamp without time zone,
	small_code t_code1 NOT NULL,
	ind_abs_value t_str2048,
	ind_ref_value_id id_t,
	ind_abs_history_id id_t NOT NULL DEFAULT nextval('com.all_history_id_seq'::regclass)
);
ALTER TABLE ind_value_history ADD CONSTRAINT pk_ind_value_history PRIMARY KEY(ind_abs_history_id);
CREATE INDEX ie1_ind_value_history ON ind_value_history (ind_id,date_from,context_sign);
CREATE INDEX ie2_ind_value_history ON ind_value_history (small_code,context_sign);
CREATE INDEX ie_1_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_a_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_h_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_n_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_t_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_И_ind_value_history ON ind_value_history (small_code);
CREATE TABLE ind_type_obj_type (
	ind_type_id id_t NOT NULL,
	obj_object_type_id id_t NOT NULL,
	constr_status t_boolean NOT NULL DEFAULT true,
	constr_date_create t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	constr_descr t_fullname
);
ALTER TABLE ind_type_obj_type ADD CONSTRAINT pk_ind_type_obj_type PRIMARY KEY(obj_object_type_id,ind_type_id);
CREATE VIEW v_spr_context_list AS WITH rr(rec_id, parent_rec_id, rec_uuid, date_from, n_col, ref_id, n_value) AS (          WITH dt(nso_id, rec_id, parent_rec_id, rec_uuid, date_from, col_id, ns_col) AS (                  SELECT o.nso_id,                     r.rec_id,                     r.parent_rec_id,                     r.rec_uuid,                     r.date_from,                     h.col_id,                     h.number_col                    FROM ((ONLY nso.nso_object o                      JOIN ONLY nso.nso_column_head h ON (((o.nso_id = (h.nso_id)::bigint) AND ((h.number_col)::smallint > 0))))                      JOIN ONLY nso.nso_record r ON ((o.nso_id = (r.nso_id)::bigint)))                   WHERE ((o.nso_code)::text = 'SPR_CONTEXT_LIST'::text)                 )          SELECT dt.rec_id,             dt.parent_rec_id,             dt.rec_uuid,             dt.date_from,             dt.ns_col,             (NULL::bigint)::id_t AS ref_id,             a.val_cell_abs AS ns_value            FROM (dt              JOIN ONLY nso.nso_abs a ON ((((a.rec_id)::bigint = dt.rec_id) AND ((a.col_id)::bigint = dt.col_id))))         UNION          SELECT dt.rec_id,             dt.parent_rec_id,             dt.rec_uuid,             dt.date_from,             dt.ns_col,             r.ref_rec_id,             (nso.nso_f_record_def_val(r.ref_rec_id))::t_text AS ns_value            FROM (dt              JOIN ONLY nso.nso_ref r ON ((((r.rec_id)::bigint = dt.rec_id) AND ((r.col_id)::bigint = dt.col_id))))         UNION          SELECT dt.rec_id,             dt.parent_rec_id,             dt.rec_uuid,             dt.date_from,             dt.ns_col,             (NULL::bigint)::id_t AS id_t,             ((((((                 CASE                     WHEN ((b.s_type_code)::bpchar = 'н'::bpchar) THEN 'JPG'::text                     WHEN ((b.s_type_code)::bpchar = 'п'::bpchar) THEN 'PNG'::text                     WHEN ((b.s_type_code)::bpchar = 'т'::bpchar) THEN 'BMP'::text                     WHEN ((b.s_type_code)::bpchar = 'у'::bpchar) THEN 'PDF'::text                     WHEN ((b.s_type_code)::bpchar = 'ф'::bpchar) THEN 'GIF'::text                     WHEN ((b.s_type_code)::bpchar = 'х'::bpchar) THEN 'TIFF'::text                     WHEN ((b.s_type_code)::bpchar = 'ц'::bpchar) THEN 'DOC'::text                     WHEN ((b.s_type_code)::bpchar = 'ч'::bpchar) THEN 'XLS'::text                     WHEN ((b.s_type_code)::bpchar = 'ш'::bpchar) THEN 'PPT'::text                     WHEN ((b.s_type_code)::bpchar = 'щ'::bpchar) THEN 'ODT'::text                     WHEN ((b.s_type_code)::bpchar = 'ъ'::bpchar) THEN 'ODP'::text                     WHEN ((b.s_type_code)::bpchar = 'ы'::bpchar) THEN 'ODS'::text                     WHEN ((b.s_type_code)::bpchar = 'ь'::bpchar) THEN 'ODG'::text                     WHEN ((b.s_type_code)::bpchar = 'э'::bpchar) THEN 'DOCX'::text                     WHEN ((b.s_type_code)::bpchar = 'ю'::bpchar) THEN 'XLSX'::text                     WHEN ((b.s_type_code)::bpchar = 'я'::bpchar) THEN 'PPTX'::text                     WHEN ((b.s_type_code)::bpchar = 'ё'::bpchar) THEN 'TXT'::text                     ELSE NULL::text                 END || ' | '::text) || (b.val_cel_data_name)::text) || ' ('::text) || pg_size_pretty((octet_length((b.val_cell_blob)::bytea))::bigint)) || ')'::text))::t_text AS n_value            FROM (dt              JOIN ONLY nso.nso_blob b ON ((((b.rec_id)::bigint = dt.rec_id) AND ((b.col_id)::bigint = dt.col_id))))         )  SELECT rr.rec_id,     rr.parent_rec_id,     (max(         CASE rr.n_col             WHEN 1 THEN (com.com_f_empty_string_to_null(rr.n_value))::text             ELSE NULL::text         END))::small_t AS context_id,     (max(         CASE rr.n_col             WHEN 2 THEN (com.com_f_empty_string_to_null(rr.n_value))::text             ELSE NULL::text         END))::t_str250 AS context_descr,     rr.rec_uuid,     rr.date_from    FROM rr   GROUP BY rr.rec_id, rr.parent_rec_id, rr.rec_uuid, rr.date_from;
CREATE VIEW v_c_ind_value AS WITH v(object_id, ind_id, date_from, date_to, column_id, col_nmb, column_code, small_code, context_sign, ind_type_id, ind_value, measure_unit_name) AS (          WITH x(object_id, ind_id, date_from, date_to, column_id, col_nmb, column_code, small_code, ind_abs_value, ind_ref_value_id, ind_ref_value, measure_unit_name, context_sign, ind_type_id) AS (                  SELECT i.object_id,                     i.ind_id,                     r.date_from,                     r.date_to,                     b.column_id,                     b.col_nmb,                     b.base_name AS column_code,                     b.small_code,                     r.ind_abs_value,                     r.ind_ref_value_id,                         CASE                             WHEN (r.ind_ref_value_id IS NOT NULL) THEN (nso.nso_f_record_def_val(r.ind_ref_value_id))::character varying                             ELSE NULL::character varying                         END AS nso_f_record_def_val,                         CASE                             WHEN (b.unit_measure_id IS NOT NULL) THEN (nso.nso_f_record_def_val(b.unit_measure_id))::character varying                             ELSE NULL::character varying                         END AS nso_f_record_def_val,                     r.context_sign,                     i.ind_type_id                    FROM (((ind.ind_indicator i                      JOIN ind.ind_base b ON (((i.ind_id)::bigint = (b.ind_id)::bigint)))                      JOIN ONLY ind.ind_value r ON ((((r.ind_id)::bigint = (b.ind_id)::bigint) AND ((r.column_id)::bigint = (b.column_id)::bigint))))                      JOIN ind.ind_type_header h ON ((((i.ind_type_id)::bigint = (h.ind_type_id)::bigint) AND ((h.ind_type_code)::text = 'C_IND_VALUE'::text) AND ((h.col_nmb)::smallint = 0))))                 )          SELECT x.object_id,             x.ind_id,             x.date_from,             x.date_to,             x.column_id,             x.col_nmb,             x.column_code,             x.small_code,             x.context_sign,             x.ind_type_id,             x.ind_abs_value,             x.measure_unit_name            FROM x           WHERE ((x.small_code)::bpchar <> 'T'::bpchar)         UNION          SELECT x.object_id,             x.ind_id,             x.date_from,             x.date_to,             x.column_id,             x.col_nmb,             x.column_code,             x.small_code,             x.context_sign,             x.ind_type_id,             x.ind_ref_value,             x.measure_unit_name            FROM x           WHERE ((x.small_code)::bpchar = 'T'::bpchar)   ORDER BY 2, 3, 5         ), pv AS (          SELECT DISTINCT v_1.ind_type_id,             v_1.context_sign            FROM v v_1         ), cd AS (          SELECT pv.ind_type_id,             pv.context_sign,             ((ind.ind_f_context_descr_get(pv.ind_type_id))[((pv.context_sign)::smallint + ((1)::small_t)::smallint)])::t_str60 AS context_descr            FROM pv         )  SELECT v.object_id,     v.ind_id,     v.context_sign,     cd.context_descr,     (max((         CASE v.col_nmb             WHEN 1 THEN v.ind_value             ELSE NULL::character varying         END)::text))::t_str60 AS add_attr    FROM (v      JOIN cd USING (ind_type_id, context_sign))   GROUP BY v.object_id, v.ind_id, v.context_sign, cd.context_descr   ORDER BY v.object_id;
CREATE TABLE ind_value (
	ind_id id_t NOT NULL,
	column_id id_t NOT NULL,
	context_sign small_t NOT NULL DEFAULT 0,
	date_from t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	date_to t_timestamp NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
	small_code t_code1 NOT NULL,
	ind_abs_value t_str2048,
	ind_ref_value_id id_t
);
ALTER TABLE ind_value ADD CONSTRAINT pk_ind_value PRIMARY KEY(ind_id,column_id,context_sign);
CREATE INDEX ie1_ind_value ON ind_value (ind_id,date_from,context_sign);
CREATE INDEX ie2_ind_value ON ind_value (small_code,context_sign);
CREATE INDEX ie_1_ind_value ON ind_value (small_code);
CREATE INDEX ie_a_ind_value ON ind_value (small_code);
CREATE INDEX ie_h_ind_value ON ind_value (small_code);
CREATE INDEX ie_n_ind_value ON ind_value (small_code);
CREATE INDEX ie_t_ind_value ON ind_value (small_code);
CREATE INDEX ie_И_ind_value ON ind_value (small_code);
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
CREATE TABLE ind_type_header (
	column_id id_t NOT NULL DEFAULT nextval('ind.ind_type_header_column_id_seq'::regclass),
	parent_column_id id_t,
	ind_type_id id_t NOT NULL,
	attr_id id_t NOT NULL,
	column_code t_str60 NOT NULL,
	col_nmb small_t NOT NULL,
	column_name t_str250 NOT NULL,
	column_scode t_code1 NOT NULL,
	unit_measure_id id_t,
	date_from t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	date_to t_timestamp NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
	date_system_write t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	column_structure t_arr_id,
	ind_type_code t_str60 NOT NULL,
	ind_select t_description
);
ALTER TABLE ind_type_header ADD CONSTRAINT pk_ind_type_header PRIMARY KEY(column_id);
CREATE UNIQUE INDEX ak1_ind_type_header ON ind_type_header (attr_id,column_code,ind_type_id);
CREATE INDEX ie1_ind_type_header ON ind_type_header (ind_type_code);
CREATE TABLE ind_base (
	ind_id id_t NOT NULL,
	column_id id_t NOT NULL,
	col_nmb small_t NOT NULL,
	unit_measure_id id_t,
	small_code t_code1 NOT NULL,
	base_name t_str60 NOT NULL,
	ind_type_id id_t NOT NULL
);
ALTER TABLE ind_base ADD CONSTRAINT pk_ind_base PRIMARY KEY(ind_id,column_id);
CREATE INDEX ie2_ind_base ON ind_base (small_code);
CREATE INDEX ie_1_ind_base ON ind_base (small_code);
CREATE INDEX ie_a_ind_base ON ind_base (small_code);
CREATE INDEX ie_h_ind_base ON ind_base (small_code);
CREATE INDEX ie_n_ind_base ON ind_base (small_code);
CREATE INDEX ie_t_ind_base ON ind_base (small_code);
CREATE INDEX ie_И_ind_base ON ind_base (small_code);
CREATE VIEW v_c_ind_obj_measure AS WITH v(object_id, ind_id, date_from, date_to, column_id, col_nmb, column_code, small_code, context_sign, ind_type_id, ind_value, measure_unit_name) AS (          WITH x(object_id, ind_id, date_from, date_to, column_id, col_nmb, column_code, small_code, ind_abs_value, ind_ref_value_id, ind_ref_value, measure_unit_name, context_sign, ind_type_id) AS (                  SELECT i.object_id,                     i.ind_id,                     r.date_from,                     r.date_to,                     b.column_id,                     b.col_nmb,                     b.base_name AS column_code,                     b.small_code,                     r.ind_abs_value,                     r.ind_ref_value_id,                         CASE                             WHEN (r.ind_ref_value_id IS NOT NULL) THEN (nso.nso_f_record_def_val(r.ind_ref_value_id))::character varying                             ELSE NULL::character varying                         END AS nso_f_record_def_val,                         CASE                             WHEN (b.unit_measure_id IS NOT NULL) THEN (nso.nso_f_record_def_val(b.unit_measure_id))::character varying                             ELSE NULL::character varying                         END AS nso_f_record_def_val,                     r.context_sign,                     i.ind_type_id                    FROM (((ind.ind_indicator i                      JOIN ind.ind_base b ON (((i.ind_id)::bigint = (b.ind_id)::bigint)))                      JOIN ONLY ind.ind_value r ON ((((r.ind_id)::bigint = (b.ind_id)::bigint) AND ((r.column_id)::bigint = (b.column_id)::bigint))))                      JOIN ind.ind_type_header h ON ((((i.ind_type_id)::bigint = (h.ind_type_id)::bigint) AND ((h.ind_type_code)::text = 'C_IND_OBJ_MEASURE'::text) AND ((h.col_nmb)::smallint = 0))))                 )          SELECT x.object_id,             x.ind_id,             x.date_from,             x.date_to,             x.column_id,             x.col_nmb,             x.column_code,             x.small_code,             x.context_sign,             x.ind_type_id,             x.ind_abs_value,             x.measure_unit_name            FROM x           WHERE ((x.small_code)::bpchar <> 'T'::bpchar)         UNION          SELECT x.object_id,             x.ind_id,             x.date_from,             x.date_to,             x.column_id,             x.col_nmb,             x.column_code,             x.small_code,             x.context_sign,             x.ind_type_id,             x.ind_ref_value,             x.measure_unit_name            FROM x           WHERE ((x.small_code)::bpchar = 'T'::bpchar)   ORDER BY 2, 3, 5         ), pv AS (          SELECT DISTINCT v_1.ind_type_id,             v_1.context_sign            FROM v v_1         ), cd AS (          SELECT pv.ind_type_id,             pv.context_sign,             ((ind.ind_f_context_descr_get(pv.ind_type_id))[((pv.context_sign)::smallint + ((1)::small_t)::smallint)])::t_str60 AS context_descr            FROM pv         )  SELECT v.object_id,     v.ind_id,     v.context_sign,     cd.context_descr,     (max((         CASE v.col_nmb             WHEN 1 THEN v.ind_value             ELSE NULL::character varying         END)::text))::t_date AS date_start,     (max((         CASE v.col_nmb             WHEN 2 THEN v.ind_value             ELSE NULL::character varying         END)::text))::t_date AS date_finish,     (max((         CASE v.col_nmb             WHEN 3 THEN v.ind_value             ELSE NULL::character varying         END)::text))::small_t AS duration,     (max((         CASE v.col_nmb             WHEN 4 THEN v.ind_value             ELSE NULL::character varying         END)::text))::t_decimal AS percent,     (max((         CASE v.col_nmb             WHEN 5 THEN v.ind_value             ELSE NULL::character varying         END)::text))::t_money AS cost,     (max((         CASE v.col_nmb             WHEN 6 THEN v.ind_value             ELSE NULL::character varying         END)::text))::t_str2048 AS currency,     (max((         CASE v.col_nmb             WHEN 7 THEN v.ind_value             ELSE NULL::character varying         END)::text))::t_decimal AS prepayment    FROM (v      JOIN cd USING (ind_type_id, context_sign))   GROUP BY v.object_id, v.ind_id, v.context_sign, cd.context_descr   ORDER BY v.object_id;
ALTER TABLE ind_context_list ADD CONSTRAINT fk_ind_context_list_grouping_ind_context_list FOREIGN KEY (ind_list_parent_id) REFERENCES ind_context_list(ind_list_id) ON DELETE RESTRICT ON UPDATE RESTRICT;
CREATE TABLE ind_type_header (
	column_id id_t NOT NULL DEFAULT nextval('ind.ind_type_header_column_id_seq'::regclass),
	parent_column_id id_t,
	ind_type_id id_t NOT NULL,
	attr_id id_t NOT NULL,
	column_code t_str60 NOT NULL,
	col_nmb small_t NOT NULL,
	column_name t_str250 NOT NULL,
	column_scode t_code1 NOT NULL,
	unit_measure_id id_t,
	date_from t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	date_to t_timestamp NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
	date_system_write t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	column_structure t_arr_id,
	ind_type_code t_str60 NOT NULL,
	ind_select t_description
);
ALTER TABLE ind_type_header ADD CONSTRAINT pk_ind_type_header PRIMARY KEY(column_id);
CREATE UNIQUE INDEX ak1_ind_type_header ON ind_type_header (attr_id,column_code,ind_type_id);
CREATE INDEX ie1_ind_type_header ON ind_type_header (ind_type_code);
DROP TABLE ind_type_header;
CREATE TABLE ind_type_header (
	column_id id_t NOT NULL DEFAULT nextval('ind.ind_type_header_column_id_seq'::regclass),
	parent_column_id id_t,
	ind_type_id id_t NOT NULL,
	attr_id id_t NOT NULL,
	column_code t_str60 NOT NULL,
	col_nmb small_t NOT NULL,
	column_name t_str250 NOT NULL,
	column_scode t_code1 NOT NULL,
	unit_measure_id id_t,
	date_from t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	date_to t_timestamp NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
	date_system_write t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	column_structure t_arr_id,
	ind_type_code t_str60 NOT NULL,
	ind_select t_description
);
ALTER TABLE ind_type_header ADD CONSTRAINT pk_ind_type_header PRIMARY KEY(column_id);
CREATE UNIQUE INDEX ak1_ind_type_header ON ind_type_header (attr_id,column_code,ind_type_id);
CREATE INDEX ie1_ind_type_header ON ind_type_header (ind_type_code);
CREATE TABLE ind_value (
	ind_id id_t NOT NULL,
	column_id id_t NOT NULL,
	context_sign small_t NOT NULL DEFAULT 0,
	date_from t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	date_to t_timestamp NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
	small_code t_code1 NOT NULL,
	ind_abs_value t_str2048,
	ind_ref_value_id id_t
);
ALTER TABLE ind_value ADD CONSTRAINT pk_ind_value PRIMARY KEY(ind_id,column_id,context_sign);
CREATE INDEX ie1_ind_value ON ind_value (ind_id,date_from,context_sign);
CREATE INDEX ie2_ind_value ON ind_value (small_code,context_sign);
CREATE INDEX ie_1_ind_value ON ind_value (small_code);
CREATE INDEX ie_a_ind_value ON ind_value (small_code);
CREATE INDEX ie_h_ind_value ON ind_value (small_code);
CREATE INDEX ie_n_ind_value ON ind_value (small_code);
CREATE INDEX ie_t_ind_value ON ind_value (small_code);
CREATE INDEX ie_И_ind_value ON ind_value (small_code);
DROP TABLE ind_value;
CREATE TABLE ind_value (
	ind_id id_t NOT NULL,
	column_id id_t NOT NULL,
	context_sign small_t NOT NULL DEFAULT 0,
	date_from t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	date_to t_timestamp NOT NULL DEFAULT '9999-12-31 00:00:00'::timestamp(0) without time zone,
	small_code t_code1 NOT NULL,
	ind_abs_value t_str2048,
	ind_ref_value_id id_t
);
ALTER TABLE ind_value ADD CONSTRAINT pk_ind_value PRIMARY KEY(ind_id,column_id,context_sign);
CREATE INDEX ie1_ind_value ON ind_value (ind_id,date_from,context_sign);
CREATE INDEX ie2_ind_value ON ind_value (small_code,context_sign);
CREATE INDEX ie_1_ind_value ON ind_value (small_code);
CREATE INDEX ie_a_ind_value ON ind_value (small_code);
CREATE INDEX ie_h_ind_value ON ind_value (small_code);
CREATE INDEX ie_n_ind_value ON ind_value (small_code);
CREATE INDEX ie_t_ind_value ON ind_value (small_code);
CREATE INDEX ie_И_ind_value ON ind_value (small_code);
CREATE TABLE ind_type_obj_type (
	ind_type_id id_t NOT NULL,
	obj_object_type_id id_t NOT NULL,
	constr_status t_boolean NOT NULL DEFAULT true,
	constr_date_create t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	constr_descr t_fullname
);
ALTER TABLE ind_type_obj_type ADD CONSTRAINT pk_ind_type_obj_type PRIMARY KEY(obj_object_type_id,ind_type_id);
DROP TABLE ind_type_obj_type;
CREATE TABLE ind_type_obj_type (
	ind_type_id id_t NOT NULL,
	obj_object_type_id id_t NOT NULL,
	constr_status t_boolean NOT NULL DEFAULT true,
	constr_date_create t_timestamp NOT NULL DEFAULT (now())::timestamp(0) without time zone,
	constr_descr t_fullname
);
ALTER TABLE ind_type_obj_type ADD CONSTRAINT pk_ind_type_obj_type PRIMARY KEY(obj_object_type_id,ind_type_id);
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
CREATE TABLE ind_value_history (
	ind_id id_t NOT NULL,
	column_id id_t NOT NULL,
	context_sign small_t NOT NULL DEFAULT NULL::smallint,
	date_from t_timestamp NOT NULL DEFAULT NULL::timestamp without time zone,
	date_to t_timestamp NOT NULL DEFAULT NULL::timestamp without time zone,
	small_code t_code1 NOT NULL,
	ind_abs_value t_str2048,
	ind_ref_value_id id_t,
	ind_abs_history_id id_t NOT NULL DEFAULT nextval('com.all_history_id_seq'::regclass)
);
ALTER TABLE ind_value_history ADD CONSTRAINT pk_ind_value_history PRIMARY KEY(ind_abs_history_id);
CREATE INDEX ie1_ind_value_history ON ind_value_history (ind_id,date_from,context_sign);
CREATE INDEX ie2_ind_value_history ON ind_value_history (small_code,context_sign);
CREATE INDEX ie_1_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_a_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_h_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_n_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_t_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_И_ind_value_history ON ind_value_history (small_code);
DROP TABLE ind_value_history;
CREATE TABLE ind_value_history (
	ind_id id_t NOT NULL,
	column_id id_t NOT NULL,
	context_sign small_t NOT NULL DEFAULT NULL::smallint,
	date_from t_timestamp NOT NULL DEFAULT NULL::timestamp without time zone,
	date_to t_timestamp NOT NULL DEFAULT NULL::timestamp without time zone,
	small_code t_code1 NOT NULL,
	ind_abs_value t_str2048,
	ind_ref_value_id id_t,
	ind_abs_history_id id_t NOT NULL DEFAULT nextval('com.all_history_id_seq'::regclass)
);
ALTER TABLE ind_value_history ADD CONSTRAINT pk_ind_value_history PRIMARY KEY(ind_abs_history_id);
CREATE INDEX ie1_ind_value_history ON ind_value_history (ind_id,date_from,context_sign);
CREATE INDEX ie2_ind_value_history ON ind_value_history (small_code,context_sign);
CREATE INDEX ie_1_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_a_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_h_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_n_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_t_ind_value_history ON ind_value_history (small_code);
CREATE INDEX ie_И_ind_value_history ON ind_value_history (small_code);
ALTER TABLE ind_type_header ADD CONSTRAINT fk_ind_type_header_builds_header FOREIGN KEY (parent_column_id) REFERENCES ind_type_header(column_id) ON DELETE RESTRICT ON UPDATE RESTRICT;
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
