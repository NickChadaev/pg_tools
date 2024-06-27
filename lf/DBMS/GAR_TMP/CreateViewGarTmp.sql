--
--   2023-10-04  Сервисное представление.  Важно
--
DROP VIEW IF EXISTS gar_tmp.v_object_level CASCADE;
CREATE OR REPLACE VIEW gar_tmp.v_object_level AS
   
   SELECT level_id
        , level_name
        , short_name
        , update_date
        , start_date
        , end_date
        , is_active
        
	FROM gar_fias.as_object_level ORDER BY level_id;
	
COMMENT ON VIEW gar_tmp.v_object_level IS 'Уровни адресных объектов';

COMMENT ON COLUMN gar_tmp.v_object_level.level_id    IS 'Идентификатор уровня';
COMMENT ON COLUMN gar_tmp.v_object_level.level_name  IS 'Наименование уровня';
COMMENT ON COLUMN gar_tmp.v_object_level.short_name  IS 'Краткое наименование уровня';
COMMENT ON COLUMN gar_tmp.v_object_level.update_date IS 'Дата обновления';
COMMENT ON COLUMN gar_tmp.v_object_level.start_date  IS 'Начала периода актуальности';
COMMENT ON COLUMN gar_tmp.v_object_level.end_date    IS 'Конец периода актуальности';
COMMENT ON COLUMN gar_tmp.v_object_level.is_active   IS 'Признак актуальности';
--
-- SELECT * FROM gar_tmp.v_object_level;
