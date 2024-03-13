DROP PROCEDURE IF EXISTS pcg_dict.p_load_d_system();
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_d_system (
)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$body$
 BEGIN 

    INSERT INTO dict.dct_system (kd_system
                               , nm_system
                               , nm_description
                               , pr_billing
                               , pr_lk
                               , kd_tp_client
    )
    SELECT * 
      FROM dblink ('ccrm',
                   $$ SELECT kd_system,
                            nm_system,
                            nm_description,
                            pr_billing,
                            pr_lk,
                            kd_tp_client
                       FROM dict.d_system
                    $$
            ) 
      AS dct_system (kd_system      int4,
                     nm_system      text,
                     nm_description text,
                     pr_billing     boolean,
                     pr_lk          boolean,
                     kd_tp_client   int4
    )                      
    ON CONFLICT (kd_system) DO
    UPDATE SET nm_system      = excluded.nm_system,
               nm_description = excluded.nm_description,
               pr_billing     = excluded.pr_billing,
               pr_lk          = excluded.pr_lk,
               kd_tp_client   = excluded.kd_tp_client
    
    WHERE dct_system.nm_description IS DISTINCT FROM excluded.nm_description
       OR dct_system.kd_tp_client   IS DISTINCT FROM excluded.kd_tp_client
       OR dct_system.nm_system  <> excluded.nm_system
       OR dct_system.pr_billing <> excluded.pr_billing
       OR dct_system.pr_lk      <> excluded.pr_lk;
                              
 END;     
$body$;         

COMMENT ON PROCEDURE pcg_dict.p_load_d_system() IS 'Загрузка таблицы "С_Системы"';
-- USE CASE
--            CALL pcg_dict.p_load_d_system();
--            SELECT * FROM dict.dct_system;  --  50
--            SELECT count(1) FROM dict.dct_system;  
