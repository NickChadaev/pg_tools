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
                                WHERE id_house = cast(cc.data -> 'ADDR_FIZ' ->> 'id_addr' AS bigint)
                               )
                              )
                )
           FROM clientdb.cdb_client cc
              JOIN dict.acc_user u ON (u.acc_id_usr = cc.id_usr)
           
                    WHERE ((dt_change >= '2023-01-14 00:00:00' AND  dt_change < '2024-03-14 00:00:00') OR 
                           (dt_reg >= '2023-01-14 00:00:00' AND dt_reg < '2024-03-14 00:00:00')
                          ) AND (u.id_facility = '22');-- 56

                          
-- ============================================================================
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
                                WHERE id_house = cast(cc.data -> 'ADDR_FIZ' ->> 'id_addr' AS bigint)
                               )
                              )
                )
           FROM clientdb.cdb_client cc
		      JOIN contacts.cm_contact CS on (cs.id_entity =  cc.id_client)
              --JOIN contacts.cm_service cs ON (cs.id_service = cc.kd_process) 
              JOIN dict.acc_user u ON (u.acc_id_usr = cs.id_usr_create)
           
               WHERE
			        ((cc.dt_change >= '2023-01-14 00:00:00' AND cc.dt_change < '2024-03-14 00:00:00') OR 
                       (dt_reg >= '2023-01-14 00:00:00' AND dt_reg < '2024-03-14 00:00:00')
                      ) AND
					 (u.id_facility = '22') 
-- 					 AND
--                     (cs.dt_change < '2024-03-14 00:00:00' OR cs.dt_create < '2024-03-14 00:00:00')
-- ============================================================================

   _exec text = format ($_$ SELECT
                                   cs.id_service
                                  ,cs.id_contact
                                  ,cs.id_service_parent
                                  ,cs.id_jur_contact
                                  ,cs.dt_create
                                  ,cs.id_crm_service
                                  ,cs.kd_system
                                  ,cs."data"
                                  ,cs.nn_ls
                                  ,cs.id_reg_ls
                                  ,cs.id_reg
                                  ,cs.id_usr_create
                                  ,cs.pr_reject
                                  ,si.id_scenario_instance
                                  ,si.kd_status kd_scenario_status
                                  ,CASE
                                       WHEN si.kd_status = 11 THEN TRUE
                                       ELSE FALSE
                                   END pr_ended
                                  ,si.dt_complete
                             FROM contacts.cm_service cs
                             
                           INNER JOIN dict.acc_user u ON (cs.id_usr_create = u.acc_id_usr)
                           
                           -- Экземпляр сценария процесса
                           LEFT JOIN scenery.bpe_scenario_instance si
                                                     ON cs.id_service = si.id_sys_entity
                            AND si.kd_sys_entity = 9
                            AND si.id_scenario_instance_parent IS NULL
                           
                           WHERE (cs.dt_change < %1$L OR cs.dt_create < %1$L)
                             AND (cs.pr_previous = FALSE) AND (u.id_facility = %2$L)
          $_$, p_dt_end, p_id_facility
        );
