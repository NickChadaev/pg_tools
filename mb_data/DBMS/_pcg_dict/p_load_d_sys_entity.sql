DROP PROCEDURE IF EXISTS pcg_dict.p_load_d_sys_entity ();
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_d_sys_entity (
)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$$
 BEGIN        
    INSERT INTO dict.dct_sys_entity (kd_sys_entity
                                   , nm_sys_entity
                                   , nm_description
                                   , nm_table_name
    )
    SELECT * 
      FROM dblink ('ccrm',
                   $_$ SELECT kd_sys_entity, 
                            nm_sys_entity, 
                            nm_description, 
                            nm_table_name
                       FROM dict.d_sys_entity
                   $_$
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
             
  EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_DICT.P_LOAD_D_SYS_ENTITY: % -- %', SQLSTATE, SQLERRM;
        END;        
             
 END;     
$$;      

COMMENT ON PROCEDURE pcg_dict.p_load_d_sys_entity() IS
 'Реестр системных сущностей, которые НЕ ведутся метамоделью Смородины-Диалог';
 
--   USE CASE
--            SELECT * FROM dict.dct_sys_entity;
--            CALL pcg_dict.p_load_d_sys_entity ();
--            SELECT count(1) FROM dict.dct_sys_entity;
