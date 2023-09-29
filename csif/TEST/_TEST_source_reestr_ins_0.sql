--
--    2023-06-29 
--

 CALL fsc_receipt_pcg.p_source_reestr_ins_0 (
            p_select := $$ 
               SELECT 	 --  Клиент
                 to_date (p_date_1, 'dd.mm.yyyy')  AS dt_create
                 -- Компания
               , 'email@ofd.ru' AS company_email
               , 'osn'  AS company_sno     --  общая система налогообложения
               
               , x2.inn            AS company_inn
               , x2.nm_org_address AS company_payment_addr   -- !
               , x2.nm_org_phones  AS company_phones 
               , name_2            AS company_name   --- Добавлено   2023-06-09
               , bik_2             AS company_bik        
               
                 
               -- Клиент  
               , name_1    AS client_name
               , inn_1     AS client_inn          -- '0' --отбрасываем
               
               --Платёж 
               , 1       AS pmt_type -- безналичный 
               , sum_1   AS pmt_sum
               
               -- Услуга
--               , descr  AS item_name
               , substr (descr, 1, 128) AS item_name 

               , sum_1  AS item_price
               , 0      AS item_measure -- Единица измерения
               , sum_1  AS item_sum
               , 'full_payment'  AS item_payment_method     -- полный расчет.  full_payment
               , 0  AS payment_object -- признак предмета расчёта (о реализуемом товаре)
                
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
			   , 0                 AS type_source_reestr   -- 
			   , public.uuid_generate_v4()::text AS external_id   
		
              FROM dict.pmt_body
      		
                 LEFT JOIN fiscalization.fsc_org x2 ON (
                             fsc_receipt_pcg.f_xxx_replace_char(x2.nm_org_name) = 
                             fsc_receipt_pcg.f_xxx_replace_char(name_2)
                 )
                 LEFT JOIN fiscalization.fsc_org x3 ON (
                             fsc_receipt_pcg.f_xxx_replace_char(x3.nm_org_name) = 
                             fsc_receipt_pcg.f_xxx_replace_char(name_3)
                 )
      			  WHERE NOT ((NULLIF (btrim(inn_1), '') IS NULL) OR
                             (NULLIF (inn_1, '0') IS NULL) OR
                             (sum_1 > 42949673.00) 
                  );
      		$$	  
           
           ,p_insert :=  $$ INSERT INTO fiscalization.fsc_source_reestr (
      
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
       );
    $$
);
