DROP PROCEDURE IF EXISTS pcg_dict.p_load_d_sys_entity ();
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_d_sys_entity (
)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$body$
 BEGIN        
    INSERT INTO dict.dct_sys_entity (kd_sys_entity
                                   , nm_sys_entity
                                   , nm_description
                                   , nm_table_name
    )
    SELECT * 
      FROM dblink ('ccrm',
                   $$SELECT kd_sys_entity, 
                            nm_sys_entity, 
                            nm_description, 
                            nm_table_name
                       FROM dict.d_sys_entity
                       $$
    ) 
      AS dct_sys_entity (kd_sys_entity  int4, 
                         nm_sys_entity  text, 
                         nm_description text, 
                         nm_table_name  text
                        )                      
    ON CONFLICT (kd_sys_entity) DO
    UPDATE SET nm_sys_entity  = excluded.nm_sys_entity,
               nm_description = excluded.nm_description,
               nm_table_name  = excluded.nm_table_name
               
    WHERE dct_sys_entity.nm_sys_entity <> excluded.nm_sys_entity
       OR dct_sys_entity.nm_description IS DISTINCT FROM excluded.nm_description
       OR dct_sys_entity.nm_table_name <> excluded.nm_table_name;
                 
 END;     
$body$;                

-- USE CASE
--            CALL pcg_dict.p_load_d_sys_entity ();
