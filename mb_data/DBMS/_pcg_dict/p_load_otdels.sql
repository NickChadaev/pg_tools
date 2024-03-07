DROP PROCEDURE IF EXISTS pcg_dict.p_load_otdels();
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_otdels(
)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$body$
 BEGIN   -- 2024-03-07  Непонятно.

     INSERT INTO dict.dct_otdels (kd_otd
                                , kd_otd_parent
                                , nm_otd
                                , id_facility
     )
     SELECT * 
       FROM dblink ('ccrm',
                    $$  SELECT kd_otd,
                               kd_parent_otd,
                               nm_otd,
                               id_facility
                               from dict.otdel_mv
                   $$) 
       AS dct_otdels (kd_otd        bigint,
                      kd_otd_parent bigint,
                      nm_otd        text,
                      id_facility   int4
                     )                      
     ON CONFLICT (kd_otd) DO
     UPDATE SET kd_otd_parent = excluded.kd_otd_parent,
                nm_otd        = excluded.nm_otd,
                id_facility   = excluded.id_facility
                
     WHERE dct_otdels.kd_otd_parent IS DISTINCT FROM excluded.kd_otd_parent
        OR dct_otdels.nm_otd      <> excluded.nm_otd
        OR dct_otdels.id_facility <> excluded.id_facility;

END;     
$body$;                

-- USE CASE
--            CALL pcg_dict.p_load_otdels();
--            SELECT * FROM dict.dct_otdels;  --   
--            SELECT count(1) FROM dict.dct_otdels;  --   915
