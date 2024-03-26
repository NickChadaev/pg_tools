DROP PROCEDURE IF EXISTS pcg_metamodel.p_load_mm_0 ();
CREATE OR REPLACE PROCEDURE pcg_metamodel.p_load_mm_0 (
)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$$
 BEGIN
  --
  -- 2024-03-06   
  --
  INSERT INTO metamodel.m_entity_attribute (kd_entity
                                          , kd_attribute
                                          , nm_attribute
                                          , nm_attr_desc
                                          , nm_title
                                          , kd_dict_entity
                                          , nm_column_name
                                          , pr_active
                                          , kd_attr_type  --comment
                                          )
  SELECT * 
    FROM dblink ('ccrm',
                 $_$ SELECT DISTINCT
                          mea.kd_entity,
                          mea.kd_attribute,
                          ma.nm_attribute,
                          ma.nm_attr_desc,
                          CASE
                            WHEN mp.kd_entity IN (SELECT kd_entity FROM metamodel.m_entity 
                                                     WHERE kd_entity_parent in (3000,4000))
                              THEN REPLACE(REPLACE(ue.nm_title, '<b>', ''), '/b', '')
                            ELSE NULL
                          END nm_title,
                          
                          mea.kd_dict_entity,
                          mea.nm_column_name,
                          mea.pr_active,
                          ma.kd_attr_type
                          
                          FROM metamodel.m_entity_attribute mea
                             JOIN metamodel.m_attribute ma ON mea.kd_attribute = ma.kd_attribute
                             
                             LEFT JOIN uiconf.ui_element_mm_prop mp
                               ON mea.kd_entity = mp.kd_entity
                              AND mea.kd_attribute = mp.kd_attribute
                              AND mp.id_element =
                                 (SELECT max(id_element)
                                    FROM uiconf.ui_element_mm_prop
                                      WHERE mp.kd_entity = kd_entity AND mp.kd_attribute = kd_attribute
                                 )
                             LEFT JOIN uiconf.ui_element ue ON mp.id_element = ue.id_element
                      $_$ -- 2974 ROWS
                      
      ) 
       AS m_entity_attribute (kd_entity     int4,
                              kd_attribute   int4,
                              nm_attribute   text,
                              nm_attr_desc   text,
                              nm_title       text,
                              kd_dict_entity int4,
                              nm_column_name text,
                              pr_active      boolean,
                              kd_attr_type   int4
                              )                        
  ON CONFLICT (kd_entity, kd_attribute) 
  DO
  UPDATE SET nm_attribute   = excluded.nm_attribute,
             nm_attr_desc   = excluded.nm_attr_desc,
             nm_title       = excluded.nm_title,
             kd_dict_entity = excluded.kd_dict_entity,
             nm_column_name = excluded.nm_column_name,
             pr_active      = excluded.pr_active,
             kd_attr_type   = excluded.kd_attr_type
             
  WHERE m_entity_attribute.nm_attribute <> excluded.nm_attribute   -- ?? IS DISTINCT
     OR m_entity_attribute.nm_attr_desc   IS DISTINCT FROM excluded.nm_attr_desc
     OR m_entity_attribute.nm_title       IS DISTINCT FROM excluded.nm_title
     OR m_entity_attribute.kd_dict_entity IS DISTINCT FROM excluded.kd_dict_entity
     OR m_entity_attribute.nm_column_name <> excluded.nm_column_name
     OR m_entity_attribute.pr_active      <> excluded.pr_active
     OR m_entity_attribute.kd_attr_type   <> excluded.kd_attr_type; 
     
  EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_METAMODEL.P_LOAD_MM_0: % -- %', SQLSTATE, SQLERRM;
        END;       
     
 END;     
$$;

COMMENT ON PROCEDURE pcg_metamodel.p_load_mm_0() IS 'Загрузка связей сущностей и атрибутов';
