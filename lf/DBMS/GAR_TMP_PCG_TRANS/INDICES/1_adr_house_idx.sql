--
-- 2022-11-02 Тестирование результатов Пост-обработки. 
--      Обеспечивается ли сохранение уникальности индексного покрытия ??
--
BEGIN;

  DROP INDEX IF EXISTS  gar_tmp.adr_house_ak1;
  CREATE UNIQUE INDEX IF NOT EXISTS adr_house_ak1
    ON gar_tmp.adr_house USING btree
    (id_area ASC NULLS LAST, upper(nm_house_full::text) COLLATE pg_catalog."default" ASC NULLS LAST, id_street ASC NULLS LAST)
    TABLESPACE pg_default
    WHERE id_data_etalon IS NULL;

COMMIT;
--

DROP INDEX IF EXISTS  gar_tmp.adr_house_ak1;
DROP INDEX IF EXISTS  gar_tmp.adr_house_i1;
DROP INDEX IF EXISTS  gar_tmp.adr_house_i2;
DROP INDEX IF EXISTS  gar_tmp.adr_house_i3;
DROP INDEX IF EXISTS  gar_tmp.adr_house_i4;
DROP INDEX IF EXISTS  gar_tmp.adr_house_i5;
DROP INDEX IF EXISTS  gar_tmp.adr_house_i7;
DROP INDEX IF EXISTS  gar_tmp.adr_house_idx1;

BEGIN;

  CREATE UNIQUE INDEX IF NOT EXISTS _xxx_adr_house_ak1
      ON gar_tmp.adr_house USING btree
      (id_area ASC NULLS LAST, upper(nm_house_full::text) COLLATE pg_catalog."default" ASC NULLS LAST, id_street ASC NULLS LAST, id_house_type_1 ASC NULLS LAST)
      TABLESPACE pg_default
      WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;
  
  CREATE UNIQUE INDEX IF NOT EXISTS _xxx_adr_house_ie2
      ON gar_tmp.adr_house USING btree
      (nm_fias_guid ASC NULLS LAST)
      TABLESPACE pg_default
      WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;
      
COMMIT;
