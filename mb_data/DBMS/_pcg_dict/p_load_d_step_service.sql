DROP PROCEDURE IF EXISTS pcg_dict.p_load_d_step_service();
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_d_step_service(
)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$$
  BEGIN 

     INSERT INTO dict.dct_step_service (id_step, nm_step)
     SELECT * 
       FROM dblink ('ccrm',
                    $_$ SELECT bs.id_step,
                              bs.nm_step
                        FROM scenery.bp_step bs
                      WHERE bs.kd_step_type = 2 -- Шаг выполнения задачи пользователем.
                    $_$
                ) 
         AS dct_step_service (id_step uuid,
                              nm_step text
         )                      
     ON CONFLICT (id_step) DO
     UPDATE SET nm_step = excluded.nm_step
     
     WHERE dct_step_service.nm_step IS DISTINCT FROM excluded.nm_step;
     
  EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_DICT.P_LOAD_D_STEP_SERVICE: % -- %', SQLSTATE, SQLERRM;
        END;  

  END;     
$$;                

COMMENT ON PROCEDURE pcg_dict.p_load_d_step_service() 
     IS 'Заполнение таблицы "Шаг задачи процесса"';

-- USE CASE
--            CALL pcg_dict.p_load_d_step_service();
--            SELECT * FROM dict.dct_step_service;  --   
--            SELECT count(1) FROM dict.dct_step_service;  --  2543
