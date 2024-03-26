DROP PROCEDURE IF EXISTS pcg_dict.p_load_d_dict();

DROP PROCEDURE IF EXISTS pcg_dict.p_load_d_dict (bigint, integer);
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_d_dict (

           p_id_facility    bigint  DEFAULT NULL
         , p_kd_dict_entity integer DEFAULT NULL 

)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$$
-- ==================================================================== --
--   2024-03-13   Что грузить, пока всё.  Хотя возможна выборочная
--                загрузка.
-- ====================================================================
 DECLARE
  _select text =  $_$ SELECT id_dict,
                           id_dict_parent,
                           kd_dict_entity,
                           pr_delete,
                           nm_dict,
                           nm_dict_full
                      FROM dict.d_dict
                       WHERE (
                              ((id_dict = %1$L) AND (%1$L IS NOT NULL))
                                OR
                              (%1$L IS NULL)  
                             )
                               AND
                             (
                              ((kd_dict_entity = %2$L) AND (%2$L IS NOT NULL))
                                OR
                              (%2$L IS NULL)  
                             )                               
                  $_$;
  _exec  text;

 BEGIN   
   _exec = format(_select, p_id_facility, p_kd_dict_entity);
    
   INSERT INTO dict.dct_dict (id_dict
                            , id_dict_parent
                            , kd_dict_entity
                            , pr_delete
                            , nm_dict
                            , nm_dict_full
    )
   SELECT * 
     FROM dblink ('ccrm', _exec) 
     AS dct_dict (id_dict        bigint,
                  id_dict_parent bigint,
                  kd_dict_entity int4,
                  pr_delete      boolean,
                  nm_dict        text,
                  nm_dict_full   text
     )                      
   ON conflict (id_dict, kd_dict_entity) 
   DO
   UPDATE SET id_dict_parent = excluded.id_dict_parent,
              nm_dict        = excluded.nm_dict,
              nm_dict_full   = excluded.nm_dict_full,
              pr_delete      = excluded.pr_delete
              
   WHERE dct_dict.id_dict_parent IS DISTINCT FROM excluded.id_dict_parent
      OR dct_dict.nm_dict <> excluded.nm_dict
      OR dct_dict.nm_dict_full   IS DISTINCT FROM excluded.nm_dict_full
      OR dct_dict.pr_delete <> excluded.pr_delete;
       
  EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_DICT.P_LOAD_D_DICT: % -- %', SQLSTATE, SQLERRM;
        END;         
 END;     
$$;

COMMENT ON PROCEDURE pcg_dict.p_load_d_dict (bigint, integer) IS
                            'Загрузка таблицы "С_Значения справочников"';

-- USE CASE^
--    CALL pcg_dict.p_load_d_dict ();  -- 16202
--    SELECT * FROM dict.dct_dict;
--    SELECT count (1) FROM dict.dct_dict;  --
