--
--  2023-01-16 Nick.
--
CREATE UNIQUE INDEX IF NOT EXISTS adr_area_ak1
    ON unnsi.adr_area USING btree
    (id_country ASC NULLS LAST, id_area_parent ASC NULLS LAST, id_area_type ASC NULLS LAST, upper(nm_area::text) ASC NULLS LAST)
WHERE id_data_etalon IS NULL;
-- Index: adr_area_i1

CREATE INDEX IF NOT EXISTS adr_area_i1
    ON unnsi.adr_area USING btree (id_area_parent ASC NULLS LAST);
-- Index: adr_area_i2

CREATE INDEX IF NOT EXISTS adr_area_i2 
    ON unnsi.adr_area USING btree (id_area_type ASC NULLS LAST);
-- Index: adr_area_i3

CREATE INDEX IF NOT EXISTS adr_area_i3 ON unnsi.adr_area USING btree (id_country ASC NULLS LAST);
-- Index: adr_area_i4

CREATE INDEX IF NOT EXISTS adr_area_i4 ON unnsi.adr_area USING btree (kd_timezone ASC NULLS LAST);
-- Index: adr_area_i5

CREATE INDEX IF NOT EXISTS adr_area_i5 ON unnsi.adr_area USING btree (id_data_etalon ASC NULLS LAST);
-- Index: adr_area_i6

CREATE INDEX IF NOT EXISTS adr_area_i6 
    ON unnsi.adr_area USING btree 
        (id_country ASC NULLS LAST, upper(nm_area_full::text) ASC NULLS LAST);
-- Index: adr_area_i7

CREATE INDEX IF NOT EXISTS adr_area_i7 ON unnsi.adr_area USING btree (nm_fias_guid ASC NULLS LAST);
-- Index: adr_area_i8

CREATE INDEX IF NOT EXISTS adr_area_i8 ON unnsi.adr_area USING btree 
    (id_country ASC NULLS LAST, upper(nm_area::text) ASC NULLS LAST);
-- Index: adr_area_i9

CREATE INDEX IF NOT EXISTS adr_area_i9 ON unnsi.adr_area USING btree (kd_okato ASC NULLS LAST);
-- Index: index_nm_area_on_adr_area_trigram

CREATE INDEX IF NOT EXISTS index_nm_area_on_adr_area_trigram 
     ON unnsi.adr_area USING gin (nm_area gin_trgm_ops);
