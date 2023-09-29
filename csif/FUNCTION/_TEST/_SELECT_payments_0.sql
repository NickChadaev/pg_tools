--
--  2023-06-06
--
BEGIN;
COMMIT;
ROLLBACK;

TRUNCATE TABLE fiscalization.fsc_source_reestr;
SELECT * FROM fiscalization.fsc_source_reestr;

INSERT INTO fiscalization.fsc_source_reestr (
    dt_create               --+ timestamp(0)  without time zone NOT NULL DEFAULT now()
   
   ,company_email           --+ text             NOT NULL 
   ,company_sno             --+ sno_t            NOT NULL 
   ,company_inn             --+ text             NOT NULL 
   ,company_payment_address -- text             NOT NULL 
   ,company_phones        -- text[]
   ,company_name          -- text
   ,company_bik           -- text	
    --
   ,client_name             -- text             NOT NULL 
   ,client_inn              -- text             NOT NULL 
    --
   ,pmt_type                -- Integer          NOT NULL 
   ,pmt_sum                 -- numeric(10,2)    NOT NULL 
    --
   ,item_name               -- text             NOT NULL 
   ,item_price              -- numeric(10,2)    NOT NULL 
   ,item_measure            -- integer          NOT NULL 
   ,item_sum                -- numeric(10,2)    NOT NULL 
   ,item_payment_method     -- payment_method_t NOT NULL 
   ,payment_object          -- integer          NOT NULL 
   ,item_vat                -- vat_t            NOT NULL 
   --------------------------------------------------
   --       Опциональные.
   -- 
   ,client_account        -- text
   ,company_account       -- text
   ,company_paying_agent  -- boolean NOT NULL DEFAULT false
   ,bank_name             -- text
   ,bank_inn              -- text
   ,bank_bik              -- text
   ,bank_phones           -- text[]
   ,bank_addr             -- text
)
SELECT 	 --  Клиент
           to_date (p_date_1, 'dd.mm.yyyy')  AS dt_create
           -- Компания
         , 'email@ofd.ru'  AS company_email
         , 'osn'           AS company_sno     --  общая система налогообложения
         
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
         , descr  AS item_name
         , sum_1  AS item_price
         , 0      AS item_measure -- Единица измерения
         , sum_1  AS item_sum
         , 'full_payment'  AS item_payment_method     -- полный расчет.
         , 1      AS payment_object -- признак предмета расчёта (о реализуемом товаре)
          
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
           
        FROM dict.pmt_body 
		
           LEFT JOIN fiscalization.fsc_org x2 ON (
                       fsc_receipt_pcg.f_xxx_replace_char(x2.nm_org_name) = 
                       fsc_receipt_pcg.f_xxx_replace_char(name_2)
           )
           LEFT JOIN fiscalization.fsc_org x3 ON (
                       fsc_receipt_pcg.f_xxx_replace_char(x3.nm_org_name) = 
                       fsc_receipt_pcg.f_xxx_replace_char(name_3)
           )
			   WHERE NOT (inn_1 = '0') AND (sum_1 < 1.0e8)
		;--  LIMIT 150;
-------------------------------------------------------------------------------------
--

		
        -- INSERT 0 2629/2652
		
-- ERROR:  numeric field overflow
-- ПОДРОБНОСТИ:  A field with precision 10, scale 2 must round to an absolute value less than 10^8.
-- SQL state: 22003
-- Detail: A field with precision 10, scale 2 must round to an absolute value less than 10^8.
--
        
-- SELECT * FROM dict.pmt_body WHERE NOT (inn_1 = '0') AND (sum_1 < 1.0e8);--  LIMIT 150;
-- SELECT NAME_3, COUNT(1) FROM dict.pmt_body GROUP BY name_3  ORDER BY 1
--     WHERE NOT (inn_1 = '0') AND (sum_1 < 1.0e8);
--
-- SELECT NAME_2, COUNT(1) FROM dict.pmt_body GROUP BY name_2  ORDER BY 1

--   , ( SELECT x1.inn FROM fiscalization.fsc_org x1 
--         WHERE (fsc_receipt_pcg.f_xxx_replace_char(x1.nm_org_name) =
--                fsc_receipt_pcg.f_xxx_replace_char(name_3)
--                )
--     )  AS bank_inn   
--   , ( SELECT x1.bik FROM fiscalization.fsc_org x1 
--         WHERE (fsc_receipt_pcg.f_xxx_replace_char(x1.nm_org_name) = 
--                fsc_receipt_pcg.f_xxx_replace_char(name_3)
--                )
--     )  AS bank_bik   
--   , (SELECT x1.nm_org_phones FROM fiscalization.fsc_org x1 
--         WHERE (fsc_receipt_pcg.f_xxx_replace_char(x1.nm_org_name) = 
--                fsc_receipt_pcg.f_xxx_replace_char(name_3)
--                )
--    )  AS bank_phones                      
