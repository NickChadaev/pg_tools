--
-- 2022-11-02 Создание неуникального эксплуатационного индексного покрытия 
--            в локальной базе.
--
BEGIN;
  -- Убираю процессинговые индексы.
  DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ak1;
  DROP INDEX IF EXISTS gar_tmp._xxx_adr_house_ie2;
  
  -- Создаю неуникальные эксплуатационные

  DROP INDEX IF EXISTS  gar_tmp.adr_house_ak1;
  CREATE INDEX IF NOT EXISTS adr_house_ak1
      ON gar_tmp.adr_house USING btree
      (id_area ASC NULLS LAST, upper(nm_house_full::text) COLLATE pg_catalog."default" ASC NULLS LAST, id_street ASC NULLS LAST)
      TABLESPACE pg_default
      WHERE id_data_etalon IS NULL;
  -- Index: adr_house_i1
  
  DROP INDEX IF EXISTS  gar_tmp.adr_house_i1;
  CREATE INDEX IF NOT EXISTS adr_house_i1
      ON gar_tmp.adr_house USING btree
      (id_area ASC NULLS LAST)
      TABLESPACE pg_default;
  -- Index: adr_house_i2
  
  DROP INDEX IF EXISTS  gar_tmp.adr_house_i2;
  CREATE INDEX IF NOT EXISTS adr_house_i2
      ON gar_tmp.adr_house USING btree
      (id_street ASC NULLS LAST)
      TABLESPACE pg_default;
  -- Index: adr_house_i3
  
  DROP INDEX IF EXISTS  gar_tmp.adr_house_i3;
  CREATE INDEX IF NOT EXISTS adr_house_i3
      ON gar_tmp.adr_house USING btree
      (id_house_type_1 ASC NULLS LAST)
      TABLESPACE pg_default;
  -- Index: adr_house_i4
  
  DROP INDEX IF EXISTS  gar_tmp.adr_house_i4;
  CREATE INDEX IF NOT EXISTS adr_house_i4
      ON gar_tmp.adr_house USING btree
      (id_house_type_2 ASC NULLS LAST)
      TABLESPACE pg_default;
  -- Index: adr_house_i5
  
  DROP INDEX IF EXISTS  gar_tmp.adr_house_i5;
  CREATE INDEX IF NOT EXISTS adr_house_i5
      ON gar_tmp.adr_house USING btree
      (id_house_type_3 ASC NULLS LAST)
      TABLESPACE pg_default;
  -- Index: adr_house_i7
  
  DROP INDEX IF EXISTS  gar_tmp.adr_house_i7;
  CREATE INDEX IF NOT EXISTS adr_house_i7
      ON gar_tmp.adr_house USING btree
      (nm_fias_guid ASC NULLS LAST)
      TABLESPACE pg_default;
  -- Index: adr_house_idx1
  
  DROP INDEX IF EXISTS  gar_tmp.adr_house_idx1;
  CREATE INDEX IF NOT EXISTS adr_house_idx1
      ON gar_tmp.adr_house USING btree
      (id_area ASC NULLS LAST)
      TABLESPACE pg_default
      WHERE id_street IS NULL;

COMMIT;
