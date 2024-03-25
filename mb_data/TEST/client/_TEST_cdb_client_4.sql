  -- ===================================================================== --
  --    2024-03-21  Вариант №2  селекция по выбранным контактам. Контакт   --
  --      регистрируется в определённом регионе (p_id_facility bigint).    --
  -- ===================================================================== --
   
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
                             
           WHERE ((cs.dt_change >= '2023-01-14' AND cs.dt_change < '2024-03-14')
                                     OR 
                  (cs.dt_beg >= '2023-01-14' AND cs.dt_beg < '2024-03-14')
                 ) 
                   AND (u.id_facility = 22); -- 67  ROWS


                         -- ('2023-01-14', '2024-03-14', 22);
---
-- -================================================================================================           
           SELECT DISTINCT ON (cc.id_client)   -- 63
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
                 -- ---------------------------
                ,ca.id_client_additional
                ,ca.id_client 
                ,ca.kd_entity 
                ,ca.data 
                ,ca.id_ls
                
           FROM clientdb.cdb_client cc 
           
             LEFT JOIN clientdb.cdb_client_additional ca ON (ca.id_client = cc.id_client)
             INNER JOIN contacts.cm_contact cs ON (cs.id_entity = cc.id_client)       
			 INNER JOIN dict.acc_user u ON (cs.id_usr_create = u.acc_id_usr )
                             
           WHERE ((cs.dt_change >= '2023-01-14' AND cs.dt_change < '2024-03-14')
                                     OR 
                  (cs.dt_beg >= '2023-01-14' AND cs.dt_beg < '2024-03-14')
                 ) 
                   AND (u.id_facility = 22); -- 67
--
-- =========================================================================================
--
---
-- -================================================================================================           
           SELECT DISTINCT ON (cc.id_client)   -- 63
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
                 -- ---------------------------
                ,ca.id_client_additional -- 63
                ,ca.id_client 
                ,ca.kd_entity 
                ,ca.data 
                ,ca.id_ls
                
           FROM clientdb.cdb_client cc 
           
             LEFT JOIN clientdb.cdb_client_additional ca ON (ca.id_client = cc.id_client)
             INNER JOIN contacts.cm_contact cs ON (cs.id_entity = cc.id_client)       
			 INNER JOIN dict.acc_user u ON (cs.id_usr_create = u.acc_id_usr )
                             
           WHERE ((cs.dt_change >= '2023-01-14' AND cs.dt_change < '2024-03-14')
                                     OR 
                  (cs.dt_beg >= '2023-01-14' AND cs.dt_beg < '2024-03-14')
                 ) 
                   AND (u.id_facility = 22); -- 67

-- ========================================================================================

-- -================================================================================================           
           SELECT DISTINCT ON (cc.id_client)   -- 63
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
                 -- ---------------------------
                ,ca.id_client_additional
                ,ca.id_client 
                ,ca.kd_entity 
                ,ca.data 
                ,ca.id_ls
                
           FROM clientdb.cdb_client cc 
           
             LEFT JOIN clientdb.cdb_client_additional ca ON (ca.id_client = cc.id_client)
             INNER JOIN contacts.cm_contact cs ON (cs.id_entity = cc.id_client)       
			 INNER JOIN dict.acc_user u ON (cs.id_usr_create = u.acc_id_usr )
                             
           WHERE ((cs.dt_change >= '2023-01-14' AND cs.dt_change < '2024-03-14')
                                     OR 
                  (cs.dt_beg >= '2023-01-14' AND cs.dt_beg < '2024-03-14')
                 ) 
                   AND (u.id_facility = 22); -- 67

-- ==================================================================================           
                   ---
           SELECT DISTINCT ON (cc.id_client)   -- 63
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
                 -- ---------------------------
                ,ca.id_client_additional
                ,ca.id_client 
                ,ca.kd_entity 
                ,ca.data 
                ,ca.id_ls
                --
                ,ls.id_ls 
                ,ls.id_dict_facility 
                ,ls.id_client 
                ,ls.dt_en 
                ,ls.nm_ls 
                ,ls.id_ls_role 
                ,ls.dt_create 
                
           FROM clientdb.cdb_client cc 
           
             LEFT JOIN clientdb.cdb_client_additional ca ON (ca.id_client = cc.id_client)
             --
             INNER JOIN contacts.cm_contact cs ON (cs.id_entity = cc.id_client)       
			 INNER JOIN dict.acc_user u ON (cs.id_usr_create = u.acc_id_usr )
             --                
             LEFT JOIN clientdb.cdb_ls ls ON (ls.id_client =  = cc.id_client)
                             
           WHERE ((cs.dt_change >= '2023-01-14' AND cs.dt_change < '2024-03-14')
                                     OR 
                  (cs.dt_beg >= '2023-01-14' AND cs.dt_beg < '2024-03-14')
                 ) 
                   AND (u.id_facility = 22); -- 67

-- ==============================================================================================
   CREATE TEMPORARY TABLE IF NOT EXISTS __xxx_client (
           
                 cc_id_client             bigint
                ,cc_id_client_united      bigint  
                ,cc_id_client_jur_parent  bigint 
                ,cc_kd_tp_client          integer
                ,cc_kd_system             integer
                ,cc_kd_process            integer
                ,cc_dt_reg                timestamp without time zone 
                ,cc_pr_jur_contact_only   boolean
                ,cc_pr_delete             boolean
                ,cc_jsonb_insert          jsonb 
                 -- ---------------------------
                ,ca_id_client_additional  bigint 
                ,ca_id_client             bigint 
                ,ca_kd_entity             integer
                ,ca_data                  jsonb 
                ,ca_id_ls                 bigint  
                -- -----------------------------
                ,ls_id_ls                 bigint
                ,ls_id_dict_facility      bigint 
                ,ls_id_client             bigint
                ,ls_dt_en                 date
                ,ls_nm_ls                 varchar(255)
                ,ls_id_ls_role            bigint
                ,ls_dt_create             timestamp without timr zone
                -- ---------------------------------------------------
) ON COMMIT DROP;






    INSERT INTO clientdb.cdb_client_additional (
                 id_client_additional
               , id_client
               , kd_entity
               , data
               , id_ls
    )
    SELECT cdb_client_additional.* 
      FROM dblink ('ccrm',
                   format ($_$ SELECT  id_client_additional
                                     ,id_client 
                                     ,kd_entity 
                                     ,data 
                                     ,id_ls
                                     
                               FROM clientdb.cdb_client_additional
                               WHERE (dt_change >= %1L AND dt_change < %2L)
                               $_$, p_dt_start, p_dt_end 
                    ) 
            )
      AS cdb_client_additional ( id_client_additional bigint 
                                ,id_client            bigint 
                                ,kd_entity            int4 
                                ,data                 jsonb 
                                ,id_ls                bigint
                               )
                 
-- -======================================================================
                 
                 
   _exec  text = format ($_$ SELECT  id_ls 
                                   ,id_dict_facility 
                                   ,id_client 
                                   ,dt_en 
                                   ,nm_ls 
                                   ,id_ls_role 
                                   ,dt_create 
                              FROM clientdb.cdb_ls
                              
                            WHERE ((dt_change >= %1$L AND dt_change < %2$L)
                                     OR 
                                   (dt_create >= %1$L AND dt_create < %2$L)
                                  )
                                     AND
                                  (id_dict_facility =  %3$L)  
                         $_$, p_dt_start, p_dt_end, p_id_facility);


  
  BEGIN
    INSERT INTO clientdb.cdb_ls (id_ls
                               , id_dict_facility
                               , id_client
                               , dt_en
                               , nm_ls
                               , id_ls_role
                               , dt_create
    )
    SELECT cdb_ls.* FROM dblink ('ccrm', _exec) 
      AS cdb_ls (     id_ls            bigint 
                    , id_dict_facility int4 
                    , id_client        bigint 
                    , dt_en            timestamp 
                    , nm_ls            text 
                    , id_ls_role       int4 
                    , dt_create        timestamp
                )
    --Костыль   
     INNER JOIN clientdb.cdb_client cc ON (cc.id_client = cdb_ls.id_client)
                
    WHERE cdb_ls.id_client NOT IN (
                       SELECT unnest(vl_param) id_client FROM dict.dct_spec_params WHERE kd_param = 1
    )                     
    ON conflict (id_ls) DO    
    
    
    -- Журнал -- тлькодаты
            
-- ======================================================================-=
                 
                 
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
   SELECT * FROM dblink ('ccrm', _exec ) 
                            
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
     OR cdb_client.id_client_jur_parent IS DISTINCT FROM excluded.id_client_jur_parent
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
--            SELECT count(1) FROM clientdb.cdb_client;
--            DELETE FROM clientdb.cdb_client;  --   

   
-- ========================================================================================
-- ========================================================================================

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
                                WHERE id_house = CAST(cc.data -> 'ADDR_FIZ' ->> 'id_addr' AS bigint)
                               )
                              )
                )
                 -- 
                ,ca.id_client_additional
                ,ca.id_client 
                ,ca.kd_entity 
                ,ca.data 
                ,ca.id_ls
                --
                ,ls.id_ls 
                ,ls.id_dict_facility 
                ,ls.id_client 
                ,ls.dt_en 
                ,ls.nm_ls 
                ,ls.id_ls_role 
                ,ls.dt_create 
                
           FROM clientdb.cdb_client cc 
           
             INNER JOIN contacts.cm_contact cs ON (cs.id_entity = cc.id_client)       
			 INNER JOIN dict.acc_user        u ON (cs.id_usr_create = u.acc_id_usr )
           
             JOIN clientdb.cdb_client_additional ca ON (ca.id_client = cc.id_client)
             LEFT JOIN clientdb.cdb_ls                ls ON (ls.id_client = cc.id_client)
                             
           WHERE ((cs.dt_change >= '2023-01-14 00:00:00' AND cs.dt_change < '2024-03-14 00:00:00')
                                     OR 
                  (cs.dt_beg >= '2023-01-14 00:00:00' AND cs.dt_beg < '2024-03-14 00:00:00')
                 ) 
                   AND (u.id_facility = '22');
