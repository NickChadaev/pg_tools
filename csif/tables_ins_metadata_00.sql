--
--   2023-06-17/2023-07-28 Заполнение метаданных
--
DELETE FROM dict.metadata WHERE (code_metadata = 'ABR0');
INSERT INTO dict.metadata(
     code_metadata  -- char(4) NOT NULL 
    ,descr_metadata -- text    NOT NULL 
    ,crt_table      -- text    NOT NULL 
     --
    ,ins_table_0    -- text    NOT NULL 
    ,ins_table_1    -- text    
    ,ins_table_2    -- text  
     --
    ,sel_table_0    -- text    NOT NULL	
    ,sel_table_1    -- text    NOT NULL	
    ,sel_table_2    -- text    NULL   
     --
    ,drop_table     -- text    NOT NULL
    ,delete_from    -- text    NOT NULL	
    ,where_bad      -- text
     --
    ,call_proc_fin  -- text 
)
VALUES ('ABR0'                                                                      -- arg
      , 'Реестры типа ABR (Банковские выписки)'                                     -- 0
      , $$ CREATE TEMPORARY TABLE IF NOT EXISTS __abr_body_0 (                      -- 1 
      
                id_pmt     integer 
               ,p_date_1   text
               ,sum_1      decimal (16,2)
               ,account_1  text
               ,name_1     text
               ,inn_1      text
               ,name_2     text
               ,bik_2      text
               ,account_2  text
               ,name_3     text
               ,f1         text
               ,f2         text  
               ,descr      text
               ,f3         text		
               
           ) ON COMMIT PRESERVE ROWS;

           CREATE TEMPORARY TABLE IF NOT EXISTS __abr_body_bad_0 (      
             
                dt_create  timestamp(0) WITHOUT TIME ZONE NOT NULL DEFAULT now()
                 
             ) INHERITS (__abr_body_0) ON COMMIT PRESERVE ROWS;  
        $$
      , $$  INSERT INTO __abr_body_0 (                                              -- 2
      
                id_pmt     -- integer 
               ,p_date_1   -- text
               ,sum_1      -- decimal (16,2)
               ,account_1  -- text
               ,name_1     -- text
               ,inn_1      -- text
               ,name_2     -- text
               ,bik_2      -- text
               ,account_2  -- text
               ,name_3     -- text
               ,f1         -- text
               ,f2         -- text  
               ,descr      -- text
               ,f3         -- text

            )
          VALUES (
           
                %s -- id_pmt     -- integer 
               ,%s -- p_date_1   -- text
               ,%s -- sum_1      -- decimal (16,2)
               ,%s -- account_1  -- text
               ,%s -- name_1     -- text
               ,%s -- inn_1      -- text
               ,%s -- name_2     -- text
               ,%s -- bik_2      -- text
               ,%s -- account_2  -- text
               ,%s -- name_3     -- text
               ,%s -- f1         -- text
               ,%s -- f2         -- text  
               ,%s -- descr      -- text
               ,%s -- f3         -- text
               
           );
      $$	
  
     , $$ INSERT INTO fiscalization.fsc_source_reestr (                      -- 3
      
            dt_create               -- timestamp(0) without time zone NOT NULL DEFAULT now(),
           ,company_email           -- text              NOT NULL 
           ,company_sno             -- sno_t             NOT NULL 
           ,company_inn             -- text              NOT NULL 
           ,company_payment_address -- text              NOT NULL 
           ,company_phones          -- text[]  
           ,company_name            -- text  
           ,company_bik             -- text  
           ,client_name             -- text              NOT NULL 
           ,client_inn              -- text              NOT NULL 
           ,pmt_type                -- integer           NOT NULL 
           ,pmt_sum                 -- numeric(10,2)     NOT NULL 
           ,item_name               -- text              NOT NULL 
           ,item_price              -- numeric(10,2)     NOT NULL 
           ,item_measure            -- integer           NOT NULL
           ,item_sum                -- numeric(10,2)     NOT NULL
           ,item_payment_method     -- payment_method_t  NOT NULL 
           ,payment_object          -- integer           NOT NULL 
           ,item_vat                -- vat_t             NOT NULL 
           ,client_account          -- text  
           ,company_account         -- text  
           ,company_paying_agent    -- boolean NOT NULL DEFAULT false
           ,bank_name               -- text  
           ,bank_inn                -- text  
           ,bank_bik                -- text  
           ,bank_phones             -- text[]  
           ,bank_addr               -- text  
           ,type_source_reestr      -- integer NOT NULL DEFAULT 0 
           ,external_id             -- text    NOT NULL 
           ,id_pay                  -- bigint 
           ,rcp_type                -- integer  NOT NULL DEFAULT 0 
     )
       VALUES (
                 %L::timestamp(0) without time zone --  dt_create
                ,%L::text             --  company_email            
                ,%L::sno_t            --  company_sno              
                ,%L::text             --  company_inn              
                ,%L::text             --  company_payment_address  
                ,%L::text[]           --  company_phones          
                ,%L::text             --  company_name            
                ,%L::text             --  company_bik             
                ,%L::text             --  client_name              
                ,%L::text             --  client_inn               
                ,%L::integer          --  pmt_type                 
                ,%L::numeric(10,2)    --  pmt_sum                  
                ,%L::text             --  item_name                
                ,%L::numeric(10,2)    --  item_price               
                ,%L::integer          --  item_measure            
                ,%L::numeric(10,2)    --  item_sum                
                ,%L::payment_method_t --  item_payment_method      
                ,%L::integer          --  payment_object           
                ,%L::vat_t            --  item_vat                 
                ,%L::text             --  client_account     
                ,%L::text             --  company_account    
                ,%L::boolean          --  company_paying_agent 
                ,%L::text             --  bank_name            
                ,%L::text             --  bank_inn             
                ,%L::text             --  bank_bik             
                ,%L::text[]           --  bank_phones          
                ,%L::text             --  bank_addr     
                ,%L::integer          --  type_source_reestr  
                ,%L::text             --  external_id        
                ,%L::bigint           --  id_pay    
                ,%L::operation_t      --  rcp_type    
       );
    $$
   -----------------	
      , $$  INSERT INTO __abr_body_bad_0 (                                    -- 4
      
                id_pmt     -- integer 
               ,p_date_1   -- text
               ,sum_1      -- decimal (16,2)
               ,account_1  -- text
               ,name_1     -- text
               ,inn_1      -- text
               ,name_2     -- text
               ,bik_2      -- text
               ,account_2  -- text
               ,name_3     -- text
               ,f1         -- text
               ,f2         -- text  
               ,descr      -- text
               ,f3         -- text

		      )
		    VALUES (
		    
                %s -- id_pmt     -- integer 
               ,%s -- p_date_1   -- text
               ,%s -- sum_1      -- decimal (16,2)
               ,%s -- account_1  -- text
               ,%s -- name_1     -- text
               ,%s -- inn_1      -- text
               ,%s -- name_2     -- text
               ,%s -- bik_2      -- text
               ,%s -- account_2  -- text
               ,%s -- name_3     -- text
               ,%s -- f1         -- text
               ,%s -- f2         -- text  
               ,%s -- descr      -- text
               ,%s -- f3         -- text
               
           );
      $$	

      , $$ SELECT   id_pmt    -- integer                                          -- 5
                   ,p_date_1  -- text
                   ,sum_1     -- decimal (16,2)
                   ,account_1 -- text
                   ,name_1    -- text
                   ,inn_1     -- text
                   ,name_2    -- text
                   ,bik_2     -- text
                   ,account_2 -- text
                   ,name_3    -- text
                   ,f1        -- text
                   ,f2        -- text  
                   ,descr     -- text
                   ,f3        -- text		 
                   
           FROM ONLY __abr_body_0 WHERE ({0});
      $$

      , $$ SELECT   id_pmt    -- integer                                          -- 6
                   ,p_date_1  -- text
                   ,sum_1     -- decimal (16,2)
                   ,account_1 -- text
                   ,name_1    -- text
                   ,inn_1     -- text
                   ,name_2    -- text
                   ,bik_2     -- text
                   ,account_2 -- text
                   ,name_3    -- text
                   ,f1        -- text
                   ,f2        -- text  
                   ,descr     -- text
                   ,f3        -- text		 
                   
           FROM ONLY __abr_body_bad_0;
      $$      
      
      , $$ SELECT 	 --  Клиент                                                    -- 7
                 to_date (p_date_1, 'dd.mm.yyyy')  AS dt_create
                 -- Компания
               , '{1}'  AS company_email
               , '{2}'  AS company_sno     --  общая система налогообложения
               
               , x2.inn            AS company_inn
               , x2.nm_org_address AS company_payment_addr   -- !
               , x2.nm_org_phones  AS company_phones 
               , name_2            AS company_name   --- Добавлено   2023-06-09
               , bik_2             AS company_bik        
                 
               -- Клиент  
               , name_1    AS client_name
               , inn_1     AS client_inn          -- '0' --отбрасываем
               
               --Платёж 
               , {3}     AS pmt_type -- безналичный 
               , sum_1   AS pmt_sum
               
               -- Услуга
--               , descr  AS item_name
               , substr (descr, 1, 128) AS item_name 

               , sum_1  AS item_price
               , {4}    AS item_measure -- Единица измерения
               , sum_1  AS item_sum
               , '{5}'  AS item_payment_method     -- полный расчет.  full_payment
               , {6}      AS payment_object -- признак предмета расчёта (о реализуемом товаре)
                
               , CASE
                      WHEN (descr ilike '%НДС не облагается%') THEN 'vat0'
                      WHEN (descr ilike '%В т.ч. НДС%') THEN 'vat20'
                      WHEN (descr ilike '%Без НДС%') THEN 'none'
                      ELSE 'none' 
                 END::vat_t AS item_vat 
                 
                --------------------------------------------------
                --       Опциональные.
                -- 
               , account_1     AS client_account        
               , account_2     AS company_account    
      
               , NOT (fsc_receipt_pcg.f_xxx_replace_char(name_2) = 
                      fsc_receipt_pcg.f_xxx_replace_char(name_3)
                      ) AS company_paying_agent
               
               , name_3            AS bank_name  
               , x3.inn            AS bank_inn
               , x3.bik            AS bank_bik
               , x3.nm_org_phones  AS bank_phones
      		   , x3.nm_org_address AS bank_addr 
			   , {7}               AS type_source_reestr   -- 
			   , public.uuid_generate_v4()::text AS external_id   
			   , id_pmt            AS id_pay
			   , '{8}'             AS rcp_type
		
              FROM __abr_body_0 
      		
                 LEFT JOIN fiscalization.fsc_org x2 ON (
                             fsc_receipt_pcg.f_xxx_replace_char(x2.nm_org_name) = 
                             fsc_receipt_pcg.f_xxx_replace_char(name_2)
                 )
                 LEFT JOIN fiscalization.fsc_org x3 ON (
                             fsc_receipt_pcg.f_xxx_replace_char(x3.nm_org_name) = 
                             fsc_receipt_pcg.f_xxx_replace_char(name_3)
                 )
      			  WHERE NOT ({0});
        $$
        
      , $$ DROP TABLE IF NOT EXISTS __abr_body_0;                                  --  8
       $$
       
      , $$ DELETE FROM __abr_body_0 WHERE({0});                                    --  9
       $$
       
      , $$ (NULLIF (btrim(inn_1), '') IS NULL) OR                                  -- 10
           (NULLIF (inn_1, '0') IS NULL) OR
           (sum_1 > 42949673.00) 
           -- OR (length(descr) > 128)
       $$
        
      , $$ CALL fsc_receipt_pcg.p_source_reestr_ins_0 (                            -- 11
                                    p_select := $_${0}$_$::text
                                   ,p_insert := $_${1}$_$::text    
           );
       $$
);       
-- SELECT * FROM dict.metadata;
