--
--  2023-01-16 Nick.
--
CREATE UNIQUE INDEX IF NOT EXISTS adr_street_ak1
    ON unnsi.adr_street USING btree
    (id_area ASC NULLS LAST, upper(nm_street::text) ASC NULLS LAST, id_street_type ASC NULLS LAST)
WHERE id_data_etalon IS NULL;
-- Index: adr_street_i1

CREATE INDEX IF NOT EXISTS adr_street_i1 
    ON unnsi.adr_street USING btree (id_area ASC NULLS LAST);
-- Index: adr_street_i2

CREATE INDEX IF NOT EXISTS adr_street_i2
    ON unnsi.adr_street USING btree (id_street_type ASC NULLS LAST);
-- Index: adr_street_i3

CREATE INDEX IF NOT EXISTS adr_street_i3
    ON unnsi.adr_street USING btree (id_data_etalon ASC NULLS LAST);
-- Index: adr_street_i4

CREATE INDEX IF NOT EXISTS adr_street_i4
    ON unnsi.adr_street USING btree (nm_fias_guid ASC NULLS LAST);
