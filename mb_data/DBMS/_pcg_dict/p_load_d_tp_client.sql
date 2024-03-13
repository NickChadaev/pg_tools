DROP PROCEDURE IF EXISTS pcg_dict.p_load_d_tp_client();
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_d_tp_client (
)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$body$
 BEGIN 
    INSERT INTO dict.dct_tp_client (kd_tp_client
                                  , nm_tp_client
                                  , nm_abbreviation
    )
    SELECT * 
      FROM dblink ('ccrm',
                   $$ SELECT kd_tp_client, 
                             nm_tp_client, 
                             nm_abbreviation
                       FROM dict.d_tp_client
                   $$
                  ) 
      AS dct_tp_client (kd_tp_client    int4, 
                        nm_tp_client    text, 
                        nm_abbreviation text
     )                      
    ON CONFLICT (kd_tp_client) do
    UPDATE SET nm_tp_client = excluded.nm_tp_client,
               nm_abbreviation = excluded.nm_abbreviation
    
    WHERE dct_tp_client.nm_tp_client <> excluded.nm_tp_client
       OR dct_tp_client.nm_abbreviation IS DISTINCT FROM excluded.nm_abbreviation;
                               
 END;     
$body$;                

COMMENT ON PROCEDURE pcg_dict.p_load_d_tp_client() IS 'Загрузка справочника типов клиеннтов';
-- USE CASE
--            CALL pcg_dict.p_load_d_tp_client();
--            SELECT * FROM dict.dct_tp_client;  --  2
--            SELECT count(1) FROM dict.dct_tp_client;  
