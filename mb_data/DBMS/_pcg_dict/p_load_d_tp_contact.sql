DROP PROCEDURE IF EXISTS pcg_dict.p_load_d_tp_contact();
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_d_tp_contact (
)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$body$
 BEGIN 

   INSERT INTO dict.dct_tp_contact (kd_tp_contact
                                  , nm_tp_contact
                                  , nm_description
        )
   SELECT * 
     FROM dblink ('ccrm',
                  $$ SELECT kd_tp_contact,
                           nm_tp_contact,
                           nm_description
                      from dict_cm.d_tp_contact 
                  $$
                 ) 
     AS dct_tp_contact (kd_tp_contact  int4,
                        nm_tp_contact  text,
                        nm_description text
            )                      
   ON CONFLICT (kd_tp_contact) DO
   UPDATE SET nm_tp_contact  = excluded.nm_tp_contact,
              nm_description = excluded.nm_description
              
   WHERE dct_tp_contact.nm_tp_contact <> excluded.nm_tp_contact
      OR dct_tp_contact.nm_description IS DISTINCT FROM excluded.nm_description;

END;     
$body$;                

-- USE CASE
--            CALL pcg_dict.p_load_d_tp_contact();
--            SELECT * FROM dict.dct_tp_contact;  --   
--            SELECT count(1) FROM dict.dct_tp_contact;  --  2
