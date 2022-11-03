--
-- 2022-11-03 Создание неуникального эксплуатационного индексного покрытия 
--            в локальной базе.
--
BEGIN;
  -- Убираю процессинговые индексы.
  DROP INDEX IF EXISTS gar_tmp._xxx_adr_street_ak1;
  DROP INDEX IF EXISTS gar_tmp._xxx_adr_street_ie2;
  
  -- Создаю неуникальные эксплуатационные

  DROP INDEX IF EXISTS  gar_tmp.adr_street_ak1;
  CREATE INDEX IF NOT EXISTS adr_street_ak1
    ON gar_tmp.adr_street USING btree
    (id_area ASC NULLS LAST, upper(nm_street::text) COLLATE pg_catalog."default" ASC NULLS LAST, id_street_type ASC NULLS LAST)
    TABLESPACE pg_default
    WHERE id_data_etalon IS NULL;
  -- Index: adr_street_i1
  
  DROP INDEX IF EXISTS  gar_tmp.adr_street_i1;
  CREATE INDEX IF NOT EXISTS adr_street_i1
    ON gar_tmp.adr_street USING btree
    (id_area ASC NULLS LAST)
    TABLESPACE pg_default;
  -- Index: adr_street_i2
  
  DROP INDEX IF EXISTS  gar_tmp.adr_street_i2;
  CREATE INDEX IF NOT EXISTS adr_street_i2
    ON gar_tmp.adr_street USING btree
    (id_street_type ASC NULLS LAST)
    TABLESPACE pg_default;
  -- Index: adr_street_i3
  
  DROP INDEX IF EXISTS  gar_tmp.adr_street_i3;
  CREATE INDEX IF NOT EXISTS adr_street_i3
    ON gar_tmp.adr_street USING btree
    (id_data_etalon ASC NULLS LAST)
    TABLESPACE pg_default;
  -- Index: adr_street_i4
  
  DROP INDEX IF EXISTS  gar_tmp.adr_street_i4;
  CREATE INDEX IF NOT EXISTS adr_street_i4
    ON gar_tmp.adr_street USING btree
    (nm_fias_guid ASC NULLS LAST)
    TABLESPACE pg_default;

COMMIT;
