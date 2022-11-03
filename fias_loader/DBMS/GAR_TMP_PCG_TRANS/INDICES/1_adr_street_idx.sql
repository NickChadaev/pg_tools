--
-- 2022-11-03 Тестирование результатов Пост-обработки. 
--      Обеспечивается ли сохранение уникальности индексного покрытия ??
--
BEGIN;

  DROP INDEX IF EXISTS  gar_tmp.adr_street_ak1;
  CREATE UNIQUE INDEX IF NOT EXISTS adr_street_ak1
    ON unnsi.adr_street USING btree
    (id_area ASC NULLS LAST, upper(nm_street::text) COLLATE pg_catalog."default" ASC NULLS LAST, id_street_type ASC NULLS LAST)
    TABLESPACE pg_default
    WHERE id_data_etalon IS NULL;

COMMIT;
--

DROP INDEX IF EXISTS  gar_tmp.adr_street_ak1;
DROP INDEX IF EXISTS  gar_tmp.adr_street_i1;
DROP INDEX IF EXISTS  gar_tmp.adr_street_i2;
DROP INDEX IF EXISTS  gar_tmp.adr_street_i3;
DROP INDEX IF EXISTS  gar_tmp.adr_street_i4;

BEGIN;

  CREATE UNIQUE INDEX IF NOT EXISTS _xxx_adr_street_ak1
    ON gar_tmp.adr_street USING btree
    (id_area ASC NULLS LAST, upper(nm_street::text) COLLATE pg_catalog."default" ASC NULLS LAST, id_street_type ASC NULLS LAST)
    TABLESPACE pg_default
    WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;
  
  CREATE UNIQUE INDEX IF NOT EXISTS _xxx_adr_street_ie2
    ON gar_tmp.adr_street USING btree
    (nm_fias_guid ASC NULLS LAST)
    TABLESPACE pg_default
    WHERE id_data_etalon IS NULL AND dt_data_del IS NULL;
      
COMMIT;
