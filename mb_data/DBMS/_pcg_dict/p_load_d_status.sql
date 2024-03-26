DROP PROCEDURE IF EXISTS pcg_dict.p_load_d_status();
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_d_status (
)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$$
 BEGIN   
    INSERT INTO dict.dct_status (kd_status
                               , nm_status
                               , nm_description
                               , kd_sys_entity
                               , dt_change
    )
    SELECT * 
      FROM dblink ('ccrm',
                   $_$ SELECT kd_status, 
                            nm_status, 
                            nm_description,
                            kd_sys_entity, 
                            dt_change
                       FROM dict.d_status
                   $_$
                   ) 
      AS dct_status (kd_status      int4, 
                     nm_status      text, 
                     nm_description text,
                     kd_sys_entity  int4, 
                     dt_change      timestamp
                    )                      
    ON CONFLICT (kd_status) DO
    UPDATE SET nm_status      = excluded.nm_status,
               nm_description = excluded.nm_description,
               dt_change      = excluded.dt_change
    WHERE dct_status.nm_status <> excluded.nm_status
       OR dct_status.nm_description IS DISTINCT FROM excluded.nm_description
       OR dct_status.dt_change <> excluded.dt_change;
       
  EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_DICT.P_LOAD_D_STATUS: % -- %', SQLSTATE, SQLERRM;
        END;         
                        
 END;     
$$;   

COMMENT ON PROCEDURE pcg_dict.p_load_d_status() IS 'Заполнение таблицы "C_статус"';

-- USE CASE
--            CALL pcg_dict.p_load_d_status ();
--            SELECT * FROM dict.dct_status;  -- 70
--            SELECT count (1) FROM dict.dct_status;  -- 70

