-- View: dict.otdel_mv

-- DROP MATERIALIZED VIEW IF EXISTS dict.otdel_mv;

CREATE MATERIALIZED VIEW IF NOT EXISTS dict.otdel_mv
TABLESPACE pg_default
AS
 SELECT jsonb_to_recordset.kd_otd,
    jsonb_to_recordset.kd_parent_otd,
    jsonb_to_recordset.id_facility,
    jsonb_to_recordset.nm_otd,
    jsonb_to_recordset.nm_otd_full,
    jsonb_to_recordset.nm_otd_addr,
    jsonb_to_recordset.nm_otd_email
    
   FROM jsonb_to_recordset ( json.admin ('AllOtdels'::character varying
                                        , NULL::character varying[]
                                        , NULL::character varying[]
                                        ) -> 'data'::text
   ) 
   
   jsonb_to_recordset (kd_otd        integer
                     , kd_parent_otd integer
                     , id_facility   integer
                     , nm_otd        character varying(200)
                     , nm_otd_full   text
                     , nm_otd_addr   text
                     , nm_otd_email  character varying(200)
   )
WITH DATA;

ALTER TABLE IF EXISTS dict.otdel_mv
    OWNER TO crm;

COMMENT ON MATERIALIZED VIEW dict.otdel_mv
    IS 'Таблица отделений';

GRANT SELECT, REFERENCES ON TABLE dict.otdel_mv TO PUBLIC;
GRANT ALL ON TABLE dict.otdel_mv TO crm;
GRANT SELECT ON TABLE dict.otdel_mv TO report_crm;

CREATE UNIQUE INDEX otdel_mv_pk
    ON dict.otdel_mv USING btree
    (kd_otd)
    TABLESPACE pg_default;
