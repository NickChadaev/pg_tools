DROP PROCEDURE IF EXISTS pcg_dict.p_load_d_dict;
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_d_dict (
)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$body$
 BEGIN
   INSERT INTO dict.dct_dict (id_dict
                            , id_dict_parent
                            , kd_dict_entity
                            , pr_delete
                            , nm_dict
                            , nm_dict_full
               )
   SELECT * 
     FROM dblink ('ccrm',
                  $$SELECT id_dict,
                           id_dict_parent,
                           kd_dict_entity,
                           pr_delete,
                           nm_dict,
                           nm_dict_full
                      FROM dict.d_dict
                      $$) 
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

 END;     
$body$;
