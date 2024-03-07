DROP PROCEDURE IF EXISTS pcg_dict.p_load_d_crm_service();
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_d_crm_service (
)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$body$
 BEGIN 

    INSERT INTO dict.dct_crm_service (id_crm_service
                                    , nm_crm_service
                                    , id_dict_facility
                                    , kd_tp_client
                                    , kd_entity
                                    , pr_gro
    )
    SELECT * 
      FROM dblink ('ccrm',
                   $$ SELECT dcs.id_crm_service,
                            sn.nm_dict nm_crm_service,
                            dcs.id_dict_facility,
                            dcs.kd_tp_client,
                            dcs.kd_entity,
                            CASE
                              WHEN dcs.kd_entity BETWEEN 3200 AND 3300
                                OR dcs.kd_entity = 13340 
                              THEN TRUE
                              ELSE FALSE
                            end pr_gro
                       FROM dict_cm.d_crm_service dcs
                       JOIN dict.d_crm_service_name sn ON dcs.id_dict_name = sn.id_dict
                    $$
            ) 
      AS dct_crm_service (id_crm_service   uuid,
                          nm_crm_service   text,
                          id_dict_facility int4,
                          kd_tp_client     int4,
                          kd_entity        int4,
                          pr_gro           boolean
                         )                      
    ON CONFLICT (id_crm_service) DO
    UPDATE SET nm_crm_service   = excluded.nm_crm_service,
               id_dict_facility = excluded.id_dict_facility 
               
    WHERE dct_crm_service.nm_crm_service   <> excluded.nm_crm_service
       OR dct_crm_service.id_dict_facility <> excluded.id_dict_facility;

END;     
$body$;                

-- USE CASE
--            CALL pcg_dict.p_load_d_crm_service();
--            SELECT * FROM dict.dct_crm_service;  --   
--            SELECT count(1) FROM dict.dct_crm_service;  -- 458
