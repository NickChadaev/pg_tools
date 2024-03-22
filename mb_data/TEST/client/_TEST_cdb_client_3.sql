           SELECT DISTINCT ON (cc.id_client)
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
                                WHERE id_house = cast(cc.data -> 'ADDR_FIZ' ->> 'id_addr' AS bigint)
                               )
                              )
                )
           FROM clientdb.cdb_client cc
           
             INNER JOIN contacts.cm_contact cs ON (cs.id_entity = cc.id_client)       
			 INNER JOIN dict.acc_user u ON (cs.id_usr_create = u.acc_id_usr )
                             
           WHERE ((cs.dt_change >= '2023-01-14 00:00:00' AND cs.dt_change < '2024-03-14 00:00:00')
                                     OR 
                  (cs.dt_beg >= '2023-01-14 00:00:00' AND cs.dt_beg < '2024-03-14 00:00:00')
                 ) 
                   AND
                 (u.id_facility = '22')
