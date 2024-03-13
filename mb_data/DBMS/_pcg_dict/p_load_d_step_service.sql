DROP PROCEDURE IF EXISTS pcg_dict.p_load_d_step_service();
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_d_step_service(
)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$body$
 BEGIN 

     INSERT INTO dict.dct_step_service (id_step, nm_step)
     SELECT * 
       FROM dblink ('ccrm',
                    $$ SELECT bs.id_step,
                              bs.nm_step
                        FROM scenery.bp_step bs
                      WHERE bs.kd_step_type = 2 -- Шаг выполнения задачи пользователем.
                    $$
                ) 
         AS dct_step_service (id_step uuid,
                              nm_step text
         )                      
     ON CONFLICT (id_step) DO
     UPDATE SET nm_step = excluded.nm_step
     
     WHERE dct_step_service.nm_step IS DISTINCT FROM excluded.nm_step;

END;     
$body$;                

COMMENT ON PROCEDURE pcg_dict.p_load_d_step_service() 
     IS 'Заполнение таблицы "Шаг задачи процесса"';

-- USE CASE
--            CALL pcg_dict.p_load_d_step_service();
--            SELECT * FROM dict.dct_step_service;  --   
--            SELECT count(1) FROM dict.dct_step_service;  --  2543
