DROP PROCEDURE IF EXISTS pcg_clientdb.clients (timestamp, timestamp, bigint);

DROP PROCEDURE IF EXISTS pcg_clientdb.p_load_cbd_clients (timestamp, timestamp, bigint);
CREATE OR REPLACE PROCEDURE pcg_clientdb.p_load_cbd_clients (
        p_dt_start    timestamp
       ,p_dt_end      timestamp
       ,p_id_facility bigint    
)

  LANGUAGE plpgsql
  SECURITY INVOKER
AS  
$$
  -- ===================================================================== --
  --  2024-03-21  Вариант №3  селекция по выбранным контактам. Контакт     --
  --      регистрируется в определённом регионе (p_id_facility bigint).    --
  --  2024-03-25  зАГРУЗКА ДАННЫХ ПО КЛМЕНТАМ, доп. данныхе и  лицевые     --
  --      счета, одним запросом во временнуб таблицу, далее по частям      --
  --      в таблицы целевой БД.                                            -- 
  -- ===================================================================== --
  DECLARE

   _exec text = format ($_$ 
                   ---
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
           
             LEFT JOIN clientdb.cdb_client_additional ca ON (ca.id_client = cc.id_client)
             LEFT JOIN clientdb.cdb_ls                ls ON (ls.id_client = cc.id_client)
                             
           WHERE ((cs.dt_change >= %1$L AND cs.dt_change < %2$L)
                                     OR 
                  (cs.dt_beg >= %1$L AND cs.dt_beg < %2$L)
                 ) 
                   AND (u.id_facility = %3$L);
            $_$,  
                 p_dt_start, p_dt_end, p_id_facility);

  BEGIN
  
   -- RAISE '%', _exec;
    --
    -- Временная таблица.
    --
    CREATE TEMPORARY TABLE IF NOT EXISTS __xxx_client (
                  --  
                  cc_id_client             bigint
                 ,cc_id_client_united      bigint  
                 ,cc_id_client_jur_parent  bigint 
                 ,cc_kd_tp_client          integer
                 ,cc_kd_system             integer
                 ,cc_kd_process            bigint
                 ,cc_dt_reg                timestamp without time zone 
                 ,cc_pr_jur_contact_only   boolean
                 ,cc_pr_delete             boolean
                 ,cc_data                  jsonb 
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
                 ,ls_dt_create             timestamp without time zone
                 --
                 ,CONSTRAINT __xxx_client_pkey PRIMARY KEY (cc_id_client) 
                 -- ---------------------------------------------------
   ) ON COMMIT DROP;
   DELETE FROM  __xxx_client ;
   --
   --  Хрен Вам во всю морду.
   --
   INSERT INTO __xxx_client (
                               cc_id_client           
                              ,cc_id_client_united    
                              ,cc_id_client_jur_parent
                              ,cc_kd_tp_client        
                              ,cc_kd_system           
                              ,cc_kd_process          
                              ,cc_dt_reg              
                              ,cc_pr_jur_contact_only 
                              ,cc_pr_delete           
                              ,cc_data                
                               -- --------------------
                              ,ca_id_client_additional
                              ,ca_id_client           
                              ,ca_kd_entity           
                              ,ca_data                
                              ,ca_id_ls               
                              -- ---------------------
                              ,ls_id_ls               
                              ,ls_id_dict_facility    
                              ,ls_id_client           
                              ,ls_dt_en               
                              ,ls_nm_ls               
                              ,ls_id_ls_role          
                              ,ls_dt_create           
   )
    SELECT * FROM dblink ('ccrm', _exec ) 
    AS __xxx (
                  cc_id_client             bigint
                 ,cc_id_client_united      bigint  
                 ,cc_id_client_jur_parent  bigint 
                 ,cc_kd_tp_client          integer
                 ,cc_kd_system             integer
                 ,cc_kd_process            bigint
                 ,cc_dt_reg                timestamp without time zone 
                 ,cc_pr_jur_contact_only   boolean
                 ,cc_pr_delete             boolean
                 ,cc_data                  jsonb 
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
                 ,ls_dt_create             timestamp without time zone
        ) 
     ON conflict (cc_id_client) DO NOTHING;     
--
-- 1) Загрузка данных по клиентам
  
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
   SELECT    cc_id_client            
            ,cc_id_client_united     
            ,cc_id_client_jur_parent 
            ,cc_kd_tp_client         
            ,cc_kd_system            
            ,cc_kd_process           
            ,cc_dt_reg               
            ,cc_pr_jur_contact_only  
            ,cc_pr_delete            
            ,cc_data                 
   FROM __xxx_client
       WHERE cc_id_client NOT IN (SELECT unnest(vl_param) id_client 
                                       FROM dict.dct_spec_params WHERE kd_param = 1
             )                   
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
--  
--  2) Загрузка данных по подключённым лицевым счетам
--
    INSERT INTO clientdb.cdb_ls (id_ls
                               , id_dict_facility
                               , id_client
                               , dt_en
                               , nm_ls
                               , id_ls_role
                               , dt_create
    )
    SELECT  ls_id_ls           
           ,ls_id_dict_facility
           ,ls_id_client       
           ,ls_dt_en           
           ,ls_nm_ls           
           ,ls_id_ls_role      
           ,ls_dt_create        
    FROM __xxx_client  

    WHERE (ls_id_ls IS NOT NULL) AND
           ls_id_client NOT IN (
                  SELECT unnest(vl_param) id_client FROM dict.dct_spec_params WHERE kd_param = 1
    )                     
    ON conflict (id_ls) DO
    UPDATE SET dt_en      = excluded.dt_en,
               id_ls_role = excluded.id_ls_role
               
    WHERE cdb_ls.dt_en      <> excluded.dt_en
       OR cdb_ls.dt_en      IS DISTINCT FROM excluded.dt_en
       OR cdb_ls.id_ls_role <> excluded.id_ls_role
       OR cdb_ls.id_ls_role IS DISTINCT FROM excluded.id_ls_role;
--
--   3) 'Загрузка адресов клиентов. 
--           Соответсвует метамодельной сущности 2100 "Дополнительная сущность клиента"'
--
    INSERT INTO clientdb.cdb_client_additional (
                 id_client_additional
               , id_client
               , kd_entity
               , data
               , id_ls
    )
    SELECT  ca_id_client_additional
           ,ca_id_client           
           ,ca_kd_entity           
           ,ca_data                
           ,ca_id_ls                  
    FROM __xxx_client WHERE (ca_id_client_additional IS NOT NULL) AND
         ca_id_client NOT IN (SELECT unnest(vl_param) id_client 
                                   FROM dict.dct_spec_params WHERE kd_param = 1
   )                     
    ON conflict (id_client_additional) DO
        UPDATE SET DATA = excluded.data WHERE cdb_client_additional.data <> excluded.data;
       
    EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_CLIENTDB.P_LOAD_CBD_CLIENTS: % -- %', SQLSTATE, SQLERRM;
        END;       
  END;     
$$;                

COMMENT ON PROCEDURE pcg_clientdb.p_load_cbd_clients (timestamp, timestamp, bigint) IS
'Загрузка данных по клиентам';

-- USE CASE 
--            CALL pcg_clientdb.clients ('2023-01-14', '2024-03-14', 22);
--            SELECT count(1) FROM __xxx_client; -- 67
--            SELECT * FROM clientdb.cdb_client;
--            SELECT count(1) FROM clientdb.cdb_client; -- 67
--            SELECT count(1) FROM clientdb.cdb_ls;     -- 51
--            SELECT count(1) FROM clientdb.cdb_client_additional -- 63

--            DELETE FROM clientdb.cdb_client;  --   
-- -----------------------------------------------------------------------------
--  Распределение данных:
--   SELECT count(1), ls_id_dict_facility FROM __xxx_client GROUP BY ls_id_dict_facility
--        ORDER BY ls_id_dict_facility;
----------------------------------------------------------------------------------------
--  SELECT count(1), ls_id_dict_facility FROM __xxx_client GROUP BY ls_id_dict_facility
--       ORDER BY ls_id_dict_facility;
--  -----------------------------------
--   count | ls_id_dict_facility 
--  -------+---------------------
--       3 |                   1
--      46 |                  22
--       1 |                  29
--       1 |                  42
--      16 |                    
 
