-- Table: gar_tmp.xxx_adr_house_type

-- DROP TABLE gar_tmp.xxx_adr_house_type;

CREATE TABLE gar_tmp.xxx_adr_house_type
(
    fias_ids bigint[],
    id_house_type integer,
    fias_type_name character varying(50) COLLATE pg_catalog."default",
    nm_house_type character varying(50) COLLATE pg_catalog."default",
    fias_type_shortname character varying(20) COLLATE pg_catalog."default",
    nm_house_type_short character varying(10) COLLATE pg_catalog."default",
    kd_house_type_lvl integer DEFAULT 1,
    fias_row_key text COLLATE pg_catalog."default" NOT NULL,
    is_twin boolean DEFAULT false,
    CONSTRAINT pk_xxx_adr_house_type PRIMARY KEY (fias_row_key)
)

TABLESPACE pg_default;

ALTER TABLE gar_tmp.xxx_adr_house_type
    OWNER to postgres;

COMMENT ON TABLE gar_tmp.xxx_adr_house_type
    IS 'Временная таблица для "С_Типы номера (!)"';

COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.fias_ids
    IS 'IDs из схемы GAR_FIAS отношение n - 1';

COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.id_house_type
    IS 'ID из схемы UNNSI';

COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.fias_type_name
    IS 'Полное наименование из схемы GAR_FIAS';

COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.nm_house_type
    IS 'Полное наименование из схемы UNNSI';

COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.fias_type_shortname
    IS 'Полное наименование из схемы GAR_FIAS';

COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.nm_house_type_short
    IS 'Краткое наименование из схемы UNNSI';

COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.kd_house_type_lvl
    IS 'Уровень типа номера (1-основной)';

COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.fias_row_key
    IS 'Текстовый ключ строки';

COMMENT ON COLUMN gar_tmp.xxx_adr_house_type.is_twin
    IS 'Признак дубля';