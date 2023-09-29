--
--   2023-06-19
--
-- DELETE FROM dict.metadata WHERE (code_metadata = 'PAY1');
--
--  Заполнение временных таблиц
--
INSERT INTO dict.metadata (
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
VALUES ('PAY1'
      , 'Реестры типа PAY'
      , $$ CREATE TEMPORARY TABLE IF NOT EXISTS __pay_body_1 ( --  
             
                  id_pay           serial
                 ,personal_account text 
                 ,period           text 
                 ,doc_number       text
                 ,f1               text
                 ,f2               text
                 ,f3               text
                 ,s_code           text
                 ,pmt_date         text
                 ,pmt_sum          integer
                 ,inform           text
                 ,sign_pmt         text  
                 
             ) ON COMMIT PRESERVE ROWS; -- ON COMMIT DROP . | ON COMMIT DELETE ROWS
           -- 
           CREATE TEMPORARY TABLE IF NOT EXISTS __pay_body_bad_1 (   
             
                dt_create  timestamp(0) WITHOUT TIME ZONE NOT NULL DEFAULT now()
                 
             ) INHERITS (__pay_body_1) ON COMMIT PRESERVE ROWS;             
             
      $$
	  , $$  INSERT INTO __pay_body_1 ( 
		   
                  personal_account -- text 
                 ,period           -- text 
                 ,doc_number       -- text
                 ,f1               -- text
                 ,f2               -- text
                 ,f3               -- text
                 ,s_code           -- text
                 ,pmt_date         -- text
                 ,pmt_sum          -- integer
                 ,inform           -- text
                 ,sign_pmt         -- char(1) 
                 
		      )
		    VALUES (
		    
                %s --  personal_account -- text 
               ,%s -- ,period           -- text 
               ,%s -- ,doc_number       -- text
               ,%s -- ,f1               -- text
               ,%s -- ,f2               -- text
               ,%s -- ,f3               -- text
               ,%s -- ,s_code           -- text
               ,%s -- ,pmt_date         -- text
               ,%s -- ,pmt_sum          -- integer
               ,%s -- ,inform           -- text
               ,%s -- ,sign_pmt         -- char(1) 
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
	  , $$ INSERT INTO __pay_body_bad_1 ( 
	  
		          id_pay           -- integer 
                 ,personal_account -- text 
                 ,period           -- text 
                 ,doc_number       -- text
                 ,f1               -- text
                 ,f2               -- text
                 ,f3               -- text
                 ,s_code           -- text
                 ,pmt_date         -- text
                 ,pmt_sum          -- integer
                 ,inform           -- text
                 ,sign_pmt         -- char(1) 
                 
		      )
		    VALUES (
		    
		        %s --  id_pay 
               ,%s --  personal_account -- text 
               ,%s -- ,period           -- text 
               ,%s -- ,doc_number       -- text
               ,%s -- ,f1               -- text
               ,%s -- ,f2               -- text
               ,%s -- ,f3               -- text
               ,%s -- ,s_code           -- text
               ,%s -- ,pmt_date         -- text
               ,%s -- ,pmt_sum          -- integer
               ,%s -- ,inform           -- text
               ,%s -- ,sign_pmt         -- char(1) 
           
			);
    $$
    
      , $$ SELECT
                    id_pay
                  , personal_account
               	  , period 
                  , doc_number  
                  , f1
                  , f2
                  , f3
                  , s_code           
                  , pmt_date
               	  , pmt_sum
                  , inform           
                  , sign_pmt
                     
               FROM ONLY __pay_body_1 WHERE ({0});
        $$
      , $$ SELECT
                    personal_account
               	  , period 
                  , doc_number  
                  , f1
                  , f2
                  , f3
                  , s_code           
                  , pmt_date
               	  , pmt_sum
                  , inform           
                  , sign_pmt
                     
               FROM ONLY __pay_body_bad_1;
        $$        
        
      , $$  WITH zz (
                        personal_account
                      , period_txt
                      , period_date          
                      , doc_number  
                      , client_name
                      , descr
                      , s_code           
                      , pmt_date
                      , pmt_sum         
                      , inform           
                      , sign_pmt
           ) AS (
           
             SELECT
          
               personal_account
          	   ,substr (period,1, 2) || '.' || substr (period,3) AS period_txt
              ,ARRAY [to_date (period, 'MMYYYY'), (to_date (period, 'MMYYYY') + interval '1 month')]::date[] AS period_date          
              ,doc_number  
              
          	  , btrim (f1 || ' ' || f2 || ' ' || f3) AS client_name
          	  , (btrim (f1 || ' ' || f2 || ' ' || f3) || ', Оплата за период: ' || (substr (period,1, 2) || '.' || substr (period,3)) ||
            	    ', ЛС: ' || personal_account) AS descr
             , s_code           
             , to_date (pmt_date, 'DDMMYYYY') AS pmt_date
 
             , (pmt_sum::numeric(16,2)/100)::numeric(16,2) AS pmt_sum         
             , inform           
             , CASE sign_pmt::integer	
          	      WHEN 0 THEN false
          		  WHEN 1 THEN true
          		  ELSE true
               END AS sign_pmt
                
            FROM ONLY __pay_body_1 WHERE NOT ({0})
         ) 
    
        SELECT 	 --  Клиент
           zz.pmt_date     AS dt_create
           -- Компания
         , '{1}' AS company_email -- 'email@ofd.ru'
         , '{2}' AS company_sno   -- 'osn' общая система налогообложения
         
         , x2.inn            AS company_inn
         , x2.nm_org_address AS company_payment_addr   -- !
         , x2.nm_org_phones  AS company_phones 
         , x2.nm_org_name    AS company_name   --- Добавлено   2023-06-09
         , x2.bik            AS company_bik        
          
         -- Клиент  
         , zz.client_name   AS client_name     --  1) У клиента нет ИНН, как быть
         , x2.inn           AS client_inn      --  2) Берём ИНН платёжного агента
         
         --Платёж 
         , {3}          AS pmt_type -- безналичный  -- 1
         , zz.pmt_sum   AS pmt_sum
         
         -- Услуга
         , zz.descr     AS item_name
         , zz.pmt_sum   AS item_price
         , {4}          AS item_measure -- Единица измерения -- 0
         , zz.pmt_sum   AS item_sum
         , '{5}' AS item_payment_method  -- полный расчет.   -- 'full_payment'  
         , {6}   AS payment_object       -- признак предмета расчёта (о реализуемом товаре) -- 1      
          
         , '{7}'::vat_t AS item_vat      -- 'none'
           
          --------------------------------------------------
          --       Опциональные.
          -- 
         , NULL  AS client_account        -- Если нет счетов, то к чему       
         , NULL  AS company_account       --   будут прилагаться фильтры фискализации.

         , {8}   AS company_paying_agent  -- true 
         
         , x3.nm_org_name    AS bank_name  
         , x3.inn            AS bank_inn
         , x3.bik            AS bank_bik
         , x3.nm_org_phones  AS bank_phones
		 , x3.nm_org_address AS bank_addr 
         , {9}               AS type_source_reestr   -- 1
         , public.uuid_generate_v4()::text AS external_id
         
        FROM zz 
		
           LEFT JOIN fiscalization.fsc_org x2 ON ( x2.id_org = {10}) -- 136  АО "Тинькофф Банк" г. Москва
           LEFT JOIN fiscalization.fsc_org x3 ON ( x3.id_org = {11}) -- 135 -- Центральный филиал АБ "РОССИЯ" г. Москва 
           
        WHERE ({12});
       $$
       
      , $$ DROP TABLE IF NOT EXISTS __pay_body_1 CASCADE; 
       $$
       
      , $$ DELETE FROM ONLY __pay_body_1 WHERE ({0}); 
       $$
       
       , $$ (NULLIF (btrim (f1 || ' ' || f2 || ' ' || f3), '') IS NULL)	
               OR
            ((pmt_sum::numeric(16,2)/100)::numeric(16,2) > 42949673.00)
       $$
      );
-- ---------------------------------------------------------------------
--       SELECT * FROM dict.metadata;
