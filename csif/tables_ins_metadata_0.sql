--
--   2023-06-17 Заполнение метаданных
--
DELETE FROM dict.metadata WHERE (code_metadata = 'ABR0');
INSERT INTO dict.metadata(
     code_metadata  -- char(4) NOT NULL 
    ,descr_metadata -- text    NOT NULL 
    ,crt_table      -- text    NOT NULL 
    ,ins_table_0    -- text    NOT NULL 
    ,ins_table_1    -- text    
    ,ins_table_2    -- text  
    
    ,sel_table_0    -- text    NOT NULL	
    ,sel_table_1    -- text    NOT NULL	
    ,sel_table_2    -- text    NULL   
    
    ,drop_table     -- text    NOT NULL
    ,delete_from    -- text    NOT NULL	
    ,where_bad      -- text
)
VALUES ('ABR0'
      , 'Реестры типа ABR (Банковские выписки)'
      , $$ CREATE TABLE IF NOT EXISTS __abr_body_0 ( -- TEMPORARY 
      
                file_type  text 
               ,id_pmt     integer 
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
               
           );

          -- ON COMMIT DROP ON COMMIT PRESERVE ROWS. | ON COMMIT DELETE ROWS
           CREATE TABLE IF NOT EXISTS __abr_body_bad_0 (   -- TEMPORARY 
             
                dt_create  timestamp(0) WITHOUT TIME ZONE NOT NULL DEFAULT now()
                 
             ) INHERITS (__abr_body_0); --  ON COMMIT PRESERVE ROWS; 
        $$
      , $$  INSERT INTO __abr_body_0 ( 
      
                file_type  -- text 
               ,id_pmt     -- integer 
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
		    
                %s -- file_type  -- text 
               ,%s -- id_pmt     -- integer 
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
  
     , $$ INSERT INTO fiscalization.fsc_source_reestr (
      
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
                 %s  --  dt_create               -- timestamp(0) without time zone NOT NULL DEFAULT now(),
                ,%s  --  company_email           -- text              NOT NULL 
                ,%s  --  company_sno             -- sno_t             NOT NULL 
                ,%s  --  company_inn             -- text              NOT NULL 
                ,%s  --  company_payment_address -- text              NOT NULL 
                ,%s  --  company_phones          -- text[]  
                ,%s  --  company_name            -- text  
                ,%s  --  company_bik             -- text  
                ,%s  --  client_name             -- text              NOT NULL 
                ,%s  --  client_inn              -- text              NOT NULL 
                ,%s  --  pmt_type                -- integer           NOT NULL 
                ,%s  --  pmt_sum                 -- numeric(10,2)     NOT NULL 
                ,%s  --  item_name               -- text              NOT NULL 
                ,%s  --  item_price              -- numeric(10,2)     NOT NULL 
                ,%s  --  item_measure            -- integer           NOT NULL
                ,%s  --  item_sum                -- numeric(10,2)     NOT NULL
                ,%s  --  item_payment_method     -- payment_method_t  NOT NULL 
                ,%s  --  payment_object          -- integer           NOT NULL 
                ,%s  --  item_vat                -- vat_t             NOT NULL 
                ,%s  --  client_account          -- text  
                ,%s  --  company_account         -- text  
                ,%s  --  company_paying_agent    -- boolean NOT NULL DEFAULT false
                ,%s  --  bank_name               -- text  
                ,%s  --  bank_inn                -- text  
                ,%s  --  bank_bik                -- text  
                ,%s  --  bank_phones             -- text[]  
                ,%s  --  bank_addr               -- text  
                ,%s  --  type_source_reestr      -- integer NOT NULL DEFAULT 0 
                ,%s  --  external_id             -- text    NOT NULL 
       );
    $$
   -----------------	
      , $$  INSERT INTO __abr_body_bad_0 ( 
      
                file_type  -- text 
               ,id_pmt     -- integer 
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
		    
                %s -- file_type  -- text 
               ,%s -- id_pmt     -- integer 
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

      , $$ SELECT   file_type -- text 
                   ,id_pmt    -- integer 
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

      , $$ SELECT   file_type -- text 
                   ,id_pmt    -- integer 
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
      
      , $$ SELECT 	 --  Клиент
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
        
      , $$ DROP TABLE IF NOT EXISTS __abr_body_0; 
       $$
       
      , $$ DELETE FROM __abr_body_0 WHERE({0}); 
       $$
       
      , $$ (NULLIF (btrim(inn_1), '') IS NULL) OR
           (NULLIF (inn_1, '0') IS NULL) OR
           (sum_1 > 42949673.00) 
           -- OR (length(descr) > 128)
        $$
 );
-- SELECT * FROM dict.metadata;
