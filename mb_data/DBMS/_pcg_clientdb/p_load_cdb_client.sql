
DROP PROCEDURE IF EXISTS pcg_clientdb.clients (timestamp, timestamp);
CREATE OR REPLACE PROCEDURE pcg_clientdb.clients (
  p_dt_start timestamp,
  p_dt_end   timestamp
)
$body$
  DECLARE
    v_dt_st timestamp;
    v_dt_en timestamp;
  BEGIN
  
  INSERT INTO clientdb.cdb_client (id_client
                                 , id_client_united
                                 , id_client_jur_parent
                                 , kd_tp_client
                                 , kd_system
                                 , kd_process
                                 , dt_reg
                                 , pr_jur_contact_only
                                 , pr_delete
                                 , data
   )
  SELECT * 
    FROM dblink ('ccrm',
                 format ($_$ SELECT 
                                 id_client, 
                                 id_client_united, 
                                 id_client_jur_parent, 
                                 kd_tp_client,
                                 kd_system, 
                                 kd_process, 
                                 dt_reg, 
                                 pr_jur_contact_only, 
                                 pr_delete,
                                 jsonb_insert (data, 
                                              '{ADDR_FIZ, nm_fias_guid}', 
                                                to_jsonb ((SELECT nm_fias_guid::text FROM unnsi.adr_house ah 
                                                           WHERE id_house = cast("data" -> 'ADDR_FIZ' ->> 'id_addr' AS bigint)
                                                          )
                                                         )
                                               )
                            FROM clientdb.cdb_client
                                     WHERE (dt_change >= %1L AND  dt_change < %2L)
                                        OR (dt_reg >= %3L AND dt_reg < %4L)
                            $_$, p_dt_start, p_dt_end, p_dt_start, p_dt_end)
    ) 
                            
    AS cdb_client (id_client            bigint, 
                   id_client_united     bigint, 
                   id_client_jur_parent bigint, 
                   kd_tp_client         int4,
                   kd_system            int4, 
                   kd_process           bigint, 
                   dt_reg               timestamp, 
                   pr_jur_contact_only  boolean, 
                   pr_delete            boolean,
                   data                 jsonb
        )
  WHERE id_client NOT IN (SELECT unnest(vl_param) id_client FROM dict.dct_spec_params WHERE kd_param = 1)                   
  
  ON conflict (id_client) DO
  UPDATE SET id_client_united     = excluded.id_client_united,
             id_client_jur_parent = excluded.id_client_jur_parent,
             pr_jur_contact_only  = excluded.pr_jur_contact_only,
             pr_delete            = excluded.pr_delete,
             data                 = excluded.data
             
  WHERE cdb_client.id_client_united     <> excluded.id_client_united
     OR cdb_client.id_client_united     IS DISTINCT FROM excluded.id_client_united
     OR cdb_client.id_client_jur_parent <> excluded.id_client_jur_parent
     OR cdb_client.id_client_jur_parent is distinct from excluded.id_client_jur_parent
     OR cdb_client.pr_jur_contact_only  <> excluded.pr_jur_contact_only
     OR cdb_client.pr_delete            <> excluded.pr_delete
     OR cdb_client.data                 <> excluded.data;

  END;     
$$;                

COMMENT ON PROCEDURE pcg_clientdb.clients (timestamp, timestamp) IS
'Загрузка данных по клиентам';

-- USE CASE 
--            CALL pcg_dict.p_load_d_tp_client();
--            CALL pcg_dict.p_load_d_crm_service();
--            SELECT * FROM dict.dct_crm_service;  --   
--            SELECT count(1) FROM dict.dct_crm_service;  -- 458
   
