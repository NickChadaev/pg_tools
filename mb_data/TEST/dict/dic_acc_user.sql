-- View: dict.acc_user

-- DROP MATERIALIZED VIEW IF EXISTS dict.acc_user;

CREATE MATERIALIZED VIEW IF NOT EXISTS dict.acc_user
TABLESPACE pg_default
AS
 SELECT jsonb_to_recordset.acc_id_usr,
    jsonb_to_recordset.nm_usr,
    jsonb_to_recordset.nm_last,
    jsonb_to_recordset.nm_first,
    jsonb_to_recordset.nm_middle,
    jsonb_to_recordset.nm_email,
    jsonb_to_recordset.id_facility,
    jsonb_to_recordset.nm_tel,
    jsonb_to_recordset.nm_position,
    jsonb_to_recordset.nn_pers_num,
    jsonb_to_recordset.pr_access,
    jsonb_to_recordset.kd_otd,
    (ARRAY( SELECT jsonb_array_elements_text(jsonb_to_recordset.kd_otd_list) AS jsonb_array_elements_text))::integer[] AS kd_otd_list,
    jsonb_to_recordset.id_parent_usr
   FROM jsonb_to_recordset(json.admin('AllUsers'::character varying
         , NULL::character varying[]
         , NULL::character varying[]) -> 'data'::text) jsonb_to_recordset(acc_id_usr integer
         , nm_usr   character varying(81)
         , nm_last   character varying(150)
         , nm_first  character varying(150)
         , nm_middle character varying(150)
         , nm_email     character varying(100)
         , id_facility  integer
         , nm_tel       character varying(200)
         , nm_position  character varying(100)
         , nn_pers_num  character varying(10)
         , pr_access    boolean, kd_otd integer
         , kd_otd_list   jsonb
         , id_parent_usr integer
    )
WITH DATA;

ALTER TABLE IF EXISTS dict.acc_user
    OWNER TO crm;

COMMENT ON MATERIALIZED VIEW dict.acc_user
    IS 'Таблица пользователей';

GRANT SELECT, REFERENCES ON TABLE dict.acc_user TO PUBLIC;
GRANT ALL ON TABLE dict.acc_user TO crm;
GRANT SELECT ON TABLE dict.acc_user TO report_crm;

CREATE UNIQUE INDEX acc_user_pk
    ON dict.acc_user USING btree
    (acc_id_usr)
    TABLESPACE pg_default;
