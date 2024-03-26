DROP PROCEDURE IF EXISTS pcg_dict.p_load_d_service_status();
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_d_service_status (
)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$$
 BEGIN 
    INSERT INTO dict.dct_service_status (kd_status
                                       , kd_dict_entity
                                       , nm_status
                                       , nm_description
                                       , dt_change
    )
    SELECT * 
      FROM dblink ('ccrm',
                   $_$ SELECT id_dict,
                            kd_dict_entity,
                            nm_dict, 
                            nm_dict_full,
                            dt_change
                       FROM dict.d_service_status
                   $_$
        ) 
      AS dct_service_status ( kd_status      int4,
                              kd_dict_entity int8, 
                              nm_status      text, 
                              nm_description text,
                              dt_change      timestamp
                     )                      
    ON CONFLICT (kd_status) DO
    UPDATE SET nm_status      = excluded.nm_status,
               nm_description = excluded.nm_description,
               dt_change      = excluded.dt_change
               
    WHERE dct_service_status.nm_status <> excluded.nm_status
       OR dct_service_status.nm_description IS DISTINCT FROM excluded.nm_description
       OR dct_service_status.dt_change <> excluded.dt_change;
       
  EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_DICT.P_LOAD_D_SERVICE_STATUS: % -- %', SQLSTATE, SQLERRM;
        END;     
 END;     
$$;                

COMMENT ON PROCEDURE pcg_dict.p_load_d_service_status() 
IS 'Заполнение таблицы "Справочник статусов процессов"';


-- USE CASE
--            CALL pcg_dict.p_load_d_service_status();
--            SELECT * FROM dict.dct_service_status;  -- 15       
--            SELECT count(1) FROM dict.dct_service_status;  -- 15       
