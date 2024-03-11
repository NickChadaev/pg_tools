-- View: dict.otdel_map_mv

-- DROP MATERIALIZED VIEW IF EXISTS dict.otdel_map_mv;

CREATE MATERIALIZED VIEW IF NOT EXISTS dict.otdel_map_mv
TABLESPACE pg_default
AS
 SELECT t.id_org_object,
    t.kd_system,
    t.kd_otd
   FROM jsonb_to_recordset(json.admin('BillingOtdMap'::character varying
                   , NULL::character varying[]
                   , NULL::character varying[]) -> 'data'::text) 
                   
                     t (id_org_object text
                      , kd_system integer
                      , kd_otd integer
                     )
WITH DATA;

ALTER TABLE IF EXISTS dict.otdel_map_mv
    OWNER TO crm;

COMMENT ON MATERIALIZED VIEW dict.otdel_map_mv
    IS 'Маппинг биллинговых отделений';

GRANT SELECT, REFERENCES ON TABLE dict.otdel_map_mv TO PUBLIC;
GRANT ALL ON TABLE dict.otdel_map_mv TO crm;
GRANT SELECT ON TABLE dict.otdel_map_mv TO report_crm;

CREATE UNIQUE INDEX otdel_map_mv_pk
    ON dict.otdel_map_mv USING btree
    (id_org_object COLLATE pg_catalog."default", kd_system)
    TABLESPACE pg_default;
