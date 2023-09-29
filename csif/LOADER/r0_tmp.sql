  WITH zz (
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
                
            FROM ONLY __pay_body_1 WHERE NOT ( (NULLIF (btrim (f1 || ' ' || f2 || ' ' || f3), '') IS NULL)	
               OR
            ((pmt_sum::numeric(16,2)/100)::numeric(16,2) > 42949672.95)
       )
         ) 
    
        SELECT 	 --  Клиент
           zz.pmt_date     AS dt_create
           -- Компания
         , 'email@ofd.ru' AS company_email -- 'email@ofd.ru'
         , 'osn' AS company_sno   -- 'osn' общая система налогообложения
         
         , x2.inn            AS company_inn
         , x2.nm_org_address AS company_payment_addr   -- !
         , x2.nm_org_phones  AS company_phones 
         , x2.nm_org_name    AS company_name   --- Добавлено   2023-06-09
         , x2.bik            AS company_bik        
          
         -- Клиент  
         , zz.client_name   AS client_name     --  1) У клиента нет ИНН, как быть
         , x2.inn           AS client_inn      --  2) Берём ИНН платёжного агента
         
         --Платёж 
         , 1          AS pmt_type -- безналичный  -- 1
         , zz.pmt_sum   AS pmt_sum
         
         -- Услуга
         , zz.descr     AS item_name
         , zz.pmt_sum   AS item_price
         , 0          AS item_measure -- Единица измерения -- 0
         , zz.pmt_sum   AS item_sum
         , 'full_payment' AS item_payment_method  -- полный расчет.   -- 'full_payment'  
         , 1   AS payment_object       -- признак предмета расчёта (о реализуемом товаре) -- 1      
          
         , 'vat20'::vat_t AS item_vat      -- 'none'
           
          --------------------------------------------------
          --       Опциональные.
          -- 
         , NULL  AS client_account        -- Если нет счетов, то к чему       
         , NULL  AS company_account       --   будут прилагаться фильтры фискализации.

         , True   AS company_paying_agent  -- true 
         
         , x3.nm_org_name    AS bank_name  
         , x3.inn            AS bank_inn
         , x3.bik            AS bank_bik
         , x3.nm_org_phones  AS bank_phones
		 , x3.nm_org_address AS bank_addr 
         , 1               AS type_source_reestr   -- 1
         
        FROM zz 
		
           LEFT JOIN fiscalization.fsc_org x2 ON ( x2.id_org = 136) -- 136  АО "Тинькофф Банк" г. Москва
           LEFT JOIN fiscalization.fsc_org x3 ON ( x3.id_org = 135) -- 135 -- Центральный филиал АБ "РОССИЯ" г. Москва 
           
        WHERE (True);
