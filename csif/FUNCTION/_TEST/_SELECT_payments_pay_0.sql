--
--  2023-06-06
--
BEGIN;
COMMIT;
ROLLBACK;

TRUNCATE TABLE fiscalization.fsc_source_reestr;
SELECT * FROM fiscalization.fsc_source_reestr WHERE (type_source_reestr = 1) AND (nullif (BTRIM(client_name), '') is null);
-- 59
delete FROM fiscalization.fsc_source_reestr WHERE (type_source_reestr = 1) AND (nullif (BTRIM(client_name), '') is null);

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
   ,type_source_reestr
)
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
               	 -- ,pmt_sum
                  , (pmt_sum::numeric(16,2)/100)::numeric(16,2) AS pmt_sum         
                  , inform           
                  , CASE sign_pmt
               	      WHEN '0' THEN false
               		  WHEN '1' THEN true
               		  ELSE true
                    END AS sign_pmt
                     
               FROM dict.pay_body                                                                                 -- {0}
  ) 
    
    --SELECT * FROM zz;
    
   SELECT 	 --  Клиент
           zz.pmt_date     AS dt_create
           -- Компания
         , 'email@ofd.ru'  AS company_email                                                                       -- {1}
         , 'osn'           AS company_sno     --  общая система налогообложения                                   -- {2}
         
         , x2.inn            AS company_inn
         , x2.nm_org_address AS company_payment_addr   -- !
         , x2.nm_org_phones  AS company_phones 
         , x2.nm_org_name    AS company_name   --- Добавлено   2023-06-09
         , x2.bik            AS company_bik        
         
           
         -- Клиент  
         , zz.client_name   AS client_name     --  1) У клиента нет ИНН, как быть
         , x2.inn           AS client_inn      --  2) Берём ИНН платёжного агента
         
         --Платёж 
         , 1           AS pmt_type -- безналичный                                                                 -- {3}
         , zz.pmt_sum  AS pmt_sum
         
         -- Услуга
         , zz.descr    AS item_name
         , zz.pmt_sum  AS item_price
         , 0           AS item_measure -- Единица измерения                                                       -- {4}
         , zz.pmt_sum  AS item_sum
         , 'full_payment'  AS item_payment_method     -- полный расчет.                                           -- {5}
         , 1      AS payment_object -- признак предмета расчёта (о реализуемом товаре)                            -- {6} 
          
         , 'none'::vat_t AS item_vat                                                                              -- {7} 
           
          --------------------------------------------------
          --       Опциональные.
          -- 
         , NULL     AS client_account      -- Если нет счетов, то к чему       
         , NULL     AS company_account     --   будут прилагаться фильтры фискализации.

         , true AS company_paying_agent                                                                           -- {8} 
         
         , x3.nm_org_name    AS bank_name  
         , x3.inn            AS bank_inn
         , x3.bik            AS bank_bik
         , x3.nm_org_phones  AS bank_phones
		 , x3.nm_org_address AS bank_addr 
         , 1 AS type_source_reestr                                                                                -- {9} 
         
        FROM zz 
		
           LEFT JOIN fiscalization.fsc_org x2 ON ( x2.id_org = 136) -- АО "Тинькофф Банк" г. Москва              -- {10}        

           LEFT JOIN fiscalization.fsc_org x3 ON ( x3.id_org = 135)  -- Центральный филиал АБ "РОССИЯ" г. Москва -- {11}
           
       WHERE (zz.pmt_sum < 1.0e8)                                                                                -- {12}
	   ;
--		;;   LIMIT 150;
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
