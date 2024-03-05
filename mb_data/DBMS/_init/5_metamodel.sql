--
--   2024-03-04
--
DROP TABLE IF EXISTS metamodel.m_entity_attribute CASCADE; 
CREATE TABLE metamodel.m_entity_attribute (
  kd_entity      INTEGER NOT NULL,
  kd_attribute   INTEGER NOT NULL,
  nm_attribute   VARCHAR(100) NOT NULL,
  nm_attr_desc   TEXT,
  nm_title       VARCHAR(500),
  kd_dict_entity INTEGER,
  nm_column_name VARCHAR(63) NOT NULL,
  pr_active      BOOLEAN DEFAULT true NOT NULL,
  kd_attr_type   SMALLINT,
  CONSTRAINT m_entity_attribute_key PRIMARY KEY(kd_entity, kd_attribute)
) ;

COMMENT ON TABLE metamodel.m_entity_attribute
IS 'Связь сущности и атрибута.';

COMMENT ON COLUMN metamodel.m_entity_attribute.kd_entity
IS 'ИД сущности';

COMMENT ON COLUMN metamodel.m_entity_attribute.kd_attribute
IS 'ИД атрибута';

COMMENT ON COLUMN metamodel.m_entity_attribute.nm_attribute
IS 'Наименование атрибута';

COMMENT ON COLUMN metamodel.m_entity_attribute.nm_attr_desc
IS 'Полное наименование атрибута';

COMMENT ON COLUMN metamodel.m_entity_attribute.nm_title
IS 'Наименование атрибута в интерфейсе (только для процессов и доп. сущностей)';

COMMENT ON COLUMN metamodel.m_entity_attribute.kd_dict_entity
IS 'Код справочной сущности';

COMMENT ON COLUMN metamodel.m_entity_attribute.nm_column_name
IS 'Физическое наименование атрибута';

COMMENT ON COLUMN metamodel.m_entity_attribute.pr_active
IS 'Признак активности атрибута. Если false, то в процессе он не используется';

