DROP PROCEDURE IF EXISTS pcg_clientdb.clients (timestamp, timestamp, bigint);
CREATE OR REPLACE PROCEDURE pcg_clientdb.clients (
        p_dt_start    timestamp
       ,p_dt_end      timestamp
       ,p_id_facility bigint    
)

  LANGUAGE plpgsql
  SECURITY INVOKER
AS  
$$
  -- ===================================================================== --
  --    2024-03-21  Вариант №1  селекция по пользователю создавшему запись --
  -- ===================================================================== --
  DECLARE

   _exec text = format ($_$ 
           SELECT 
                 cc.id_client
                ,cc.id_client_united  
                ,cc.id_client_jur_parent 
                ,cc.kd_tp_client 
                ,cc.kd_system 
                ,cc.kd_process  
                ,cc.dt_reg  
                ,cc.pr_jur_contact_only  
                ,cc.pr_delete 
                ,jsonb_insert (cc.data, 
                   '{ADDR_FIZ, nm_fias_guid}', 
                     to_jsonb ((SELECT nm_fias_guid::text FROM unnsi.adr_house ah 
                                WHERE id_house = cast("data" -> 'ADDR_FIZ' ->> 'id_addr' AS bigint)
                               )
                              )
                )
           FROM clientdb.cdb_client cc
              JOIN dict.acc_user u ON (u.acc_id_usr = cc.id_usr)
           
                    WHERE ((dt_change >= %1$L AND  dt_change < %2$L) OR 
                           (dt_reg >= %1$L AND dt_reg < %2$L)
                          ) AND (u.id_facility = %3$L)
           $_$, p_dt_start, p_dt_end, p_id_facility);
  
  BEGIN
  
  RAISE '%', _exec;
  
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
    FROM dblink ('ccrm', _exec ) 
                            
    AS cdb_client ( id_client            bigint  
                   ,id_client_united     bigint  
                   ,id_client_jur_parent bigint  
                   ,kd_tp_client         int4 
                   ,kd_system            int4  
                   ,kd_process           bigint  
                   ,dt_reg               timestamp  
                   ,pr_jur_contact_only  boolean  
                   ,pr_delete            boolean 
                   ,data                 jsonb
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

COMMENT ON PROCEDURE pcg_clientdb.clients  (timestamp, timestamp, bigint) IS
'Загрузка данных по клиентам';

-- USE CASE 
--            CALL pcg_clientdb.clients ('2023-01-14', '2024-03-14', 22);
--            SELECT * FROM clientdb.cdb_client;
--            DELETE FROM dict.dct_crm_service;  --   

   
