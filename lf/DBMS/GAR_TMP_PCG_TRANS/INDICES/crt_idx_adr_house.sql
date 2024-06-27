--
--  2023-01-16 Nick.
--
CREATE UNIQUE INDEX IF NOT EXISTS adr_house_ak1
    ON unnsi.adr_house USING btree
    (id_area ASC NULLS LAST, upper(nm_house_full::text) ASC NULLS LAST, id_street ASC NULLS LAST)
WHERE id_data_etalon IS NULL;
-- Index: adr_house_i1

CREATE INDEX IF NOT EXISTS adr_house_i1
    ON unnsi.adr_house USING btree (id_area ASC NULLS LAST) ;
-- Index: adr_house_i2

CREATE INDEX IF NOT EXISTS adr_house_i2
    ON unnsi.adr_house USING btree (id_street ASC NULLS LAST);
-- Index: adr_house_i3

CREATE INDEX IF NOT EXISTS adr_house_i3
    ON unnsi.adr_house USING btree (id_house_type_1 ASC NULLS LAST);
-- Index: adr_house_i4

CREATE INDEX IF NOT EXISTS adr_house_i4
    ON unnsi.adr_house USING btree (id_house_type_2 ASC NULLS LAST);
-- Index: adr_house_i5

CREATE INDEX IF NOT EXISTS adr_house_i5
    ON unnsi.adr_house USING btree (id_house_type_3 ASC NULLS LAST);
-- Index: adr_house_i7

CREATE INDEX IF NOT EXISTS adr_house_i7
    ON unnsi.adr_house USING btree (nm_fias_guid ASC NULLS LAST);
-- Index: adr_house_idx1

CREATE INDEX IF NOT EXISTS adr_house_idx1
    ON unnsi.adr_house USING btree (id_area ASC NULLS LAST)
WHERE id_street IS NULL;
