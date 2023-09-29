--
--  2023-08-09  Макет входной структуры
--

   SELECT to_json (id_source_reestr, dt_create, id_pay, rcp_type, company_email
				, company_sno, company_inn, company_payment_address, client_name
				, client_inn, pmt_type, pmt_sum, item_name, item_price, item_measure
				, item_quantity, item_sum, item_payment_method, payment_object, item_vat
				, type_source_reestr, external_id, client_account, company_account, company_phones
				, company_name, company_bik, company_paying_agent, bank_name, bank_addr, bank_inn, bank_bik, bank_phones)
	FROM fiscalization.fsc_source_reestr LIMIT 1;
	
	SELECT to_json (x) FROM fiscalization.fsc_source_reestr x LIMIT 1;
	------------------------------------------------------------------
	{"id_source_reestr":1,"dt_create":"2023-05-13T00:00:00","id_pay":382322,"rcp_type":"sell","company_email":"email@ofd.ru","company_sno":"osn","company_inn":"7702070139","company_payment_address":"680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1","client_name":"ИНН 272011197560 Суворов Сергей Александрович","client_inn":"272011197560","pmt_type":1,"pmt_sum":10550.37,"item_name":", НДС не облагается, <ЛС 81590188;ПРД04.2023>","item_price":10550.37,"item_measure":0,"item_quantity":1.000,"item_sum":10550.37,"item_payment_method":"full_payment","payment_object":1,"item_vat":"vat0","type_source_reestr":0,"external_id":"a8c63070-b8f7-429d-a494-710d7fee87e0","client_account":"40817810026234001170","company_account":"40702810446010006799","company_phones":["+7 (4212) 45-54-55"],"company_name":"ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск","company_bik":"040813713","company_paying_agent":true,"bank_name":"Центральный филиал АБ \"РОССИЯ\" г. Москва","bank_addr":"121069, Москва, Мерзляковский пер., д. 18, стр. 2","bank_inn":"7831000122","bank_bik":"044525112","bank_phones":["8 (800) 100-11-11","+7 (812) 335-85-00"]}
	
	
    SELECT row_to_json (x, true) FROM fiscalization.fsc_source_reestr x LIMIT 1;
	-----------------------------------------------------------------
{--"id_source_reestr":1,
 "dt_create":"2023-05-13T00:00:00",
 "id_pay":382322,
 "rcp_type":"sell",
 "external_id":"a8c63070-b8f7-429d-a494-710d7fee87e0",
 "order_callback_url":"www.xxx.ru"
 
 "company_email":"email@ofd.ru",
 "company_sno":"osn",
 "company_inn":"7702070139",
 "company_payment_address":"680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1",
 "company_account":"40702810446010006799",
 "company_phones":["+7 (4212) 45-54-55"],
 "company_name":"ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск",
 "company_bik":"040813713",
 
 "company_paying_agent":true,
 "agent_type":"bank_paying_agent"
 "paying_agent_operation":"Платёж:
 
 "client_name":"ИНН 272011197560 Суворов Сергей Александрович",
 "client_inn":"272011197560",
 "client_account":"40817810026234001170",
 
 "pmt_type":1,
 "pmt_sum":10550.37,
 "payment_object":1,
 
 "item_name":", НДС не облагается, <ЛС 81590188;ПРД04.2023>",
 "item_price":10550.37,
 "item_measure":0,
 "item_quantity":1.000,
 "item_sum":10550.37,
 "item_payment_method":"full_payment",
 "item_vat":"vat0",
 
 --  "type_source_reestr":0,
 
 "bank_name":"Центральный филиал АБ \"РОССИЯ\" г. Москва",
 "bank_addr":"121069, Москва, Мерзляковский пер., д. 18, стр. 2",
 "bank_inn":"7831000122",
 "bank_bik":"044525112",
 "bank_phones":["8 (800) 100-11-11","+7 (812) 335-85-00"]
 }
 
 select array_agg(id_org) from fiscalization.fsc_org;
	
---
select array_agg ((
select array_agg (value) FROM json_array_elements_text
(
'{ 
 "dt_create":"2023-05-13T00:00:00",
 "id_pay":382322,
 "rcp_type":"sell",
 "external_id":"a8c63070-b8f7-429d-a494-710d7fee87e0",
 "order_callback_url":"www.xxx.ru",
 
 "company_email":"email@ofd.ru",
 "company_sno":"osn",
 "company_inn":"7702070139",
 "company_payment_address":"680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1",
 "company_account":"40702810446010006799",
 "company_phones":["+7 (4212) 45-54-55"],
 "company_name":"ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск",
 "company_bik":"040813713",
 
 "company_paying_agent":true,
 "agent_type":"bank_paying_agent",
 "paying_agent_operation":"Платёж",
 
 "client_name":"ИНН 272011197560 Суворов Сергей Александрович",
 "client_inn":"272011197560",
 "client_account":"40817810026234001170",
 
 "pmt_type":1,
 "pmt_sum":10550.37,
 "payment_object":1,
 
 "item_name":", НДС не облагается, <ЛС 81590188;ПРД04.2023>",
 "item_price":10550.37,
 "item_measure":0,
 "item_quantity":1.000,
 "item_sum":10550.37,
 "item_payment_method":"full_payment",
 "item_vat":"vat0",

 
 "bank_name":"Центральный филиал АБ \"РОССИЯ\" г. Москва",
 "bank_addr":"121069, Москва, Мерзляковский пер., д. 18, стр. 2",
 "bank_inn":"7831000122",
 "bank_bik":"044525112",
 "bank_phones":["8 (800) 100-11-11","+7 (812) 335-85-00"]
 }'::json -> 'bank_phones' 
)
))

	
 ["8 (800) 100-11-11","+7 (812) 335-85-00"]

SELECT 'r1' AS row_name, x.key, x.value FROM  json_each_text (
'{ 
 "dt_create":"2023-05-13T00:00:00",
 "id_pay":382322,
 "rcp_type":"sell",
 "external_id":"a8c63070-b8f7-429d-a494-710d7fee87e0",
 "order_callback_url":"www.xxx.ru",
 
 "company_email":"email@ofd.ru",
 "company_sno":"osn",
 "company_inn":"7702070139",
 "company_payment_address":"680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1",
 "company_account":"40702810446010006799",
 "company_phones":["+7 (4212) 45-54-55"],
 "company_name":"ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск",
 "company_bik":"040813713",
 
 "company_paying_agent":true,
 "agent_type":"bank_paying_agent",
 "paying_agent_operation":"Платёж",
 
 "client_name":"ИНН 272011197560 Суворов Сергей Александрович",
 "client_inn":"272011197560",
 "client_account":"40817810026234001170",
 
 "pmt_type":1,
 "pmt_sum":10550.37,
 "payment_object":1,
 
 "item_name":", НДС не облагается, <ЛС 81590188;ПРД04.2023>",
 "item_price":10550.37,
 "item_measure":0,
 "item_quantity":1.000,
 "item_sum":10550.37,
 "item_payment_method":"full_payment",
 "item_vat":"vat0",

  "bank_name":"Центральный филиал АБ \"РОССИЯ\" г. Москва",
 "bank_addr":"121069, Москва, Мерзляковский пер., д. 18, стр. 2",
 "bank_inn":"7831000122",
 "bank_bik":"044525112",
 "bank_phones":["8 (800) 100-11-11","+7 (812) 335-85-00"]
 }'::json 	
	) x
;	
-----------------------------------
SELECT fsc_receipt_pcg.fsc_orders_load (
'{ 
 "dt_create":"2023-05-13T00:00:00",
 "id_pay":382322,
 "rcp_type":"sell",
 "external_id":"a8c63070-b8f7-429d-a494-710d7fee87e0",
 "app_guid":"212f1d68-88ee-4d14-882b-1c945bcc785b",
 
 "company_email":"email@ofd.ru",
 "company_sno":"osn",
 "company_inn":"7702070139",
 "company_payment_address":"680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1",
 "company_phones":["+7 (4212) 45-54-55"],
 "company_name":"ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск",
 "company_bik":"040813713",
 
 "company_paying_agent":true,
 "agent_type":"bank_paying_agent",
 "paying_agent_operation":"Платёж",
 
 "client_name":"ИНН 272011197560 Суворов Сергей Александрович",
 "client_inn":"272011197560",
 
 "pmt_type":1,
 "pmt_sum":10550.37,
 "payment_object":1,
 
 "item_name":", НДС не облагается, <ЛС 81590188;ПРД04.2023>",
 "item_price":10550.37,
 "item_measure":0,
 "item_quantity":1.000,
 "item_sum":10550.37,
 "item_payment_method":"full_payment",
 "item_vat":"vat0"
	
 }'::json 	

);
-- 8557734611
-----------------------------------------------------------------
("2023-05-13 00:00:00"
 ,email@ofd.ru
 ,osn
 ,7702070139                                                       -- x.company_inn
 ,"680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1" -- x.company_payment_address
 ,"ИНН 272011197560 Суворов Сергей Александрович" -- x.client_name
 ,272011197560                                    --  x.client_inn
 ,1
 ,10550.37                   -- , x.pmt_sum
 ,", НДС не облагается, <ЛС 81590188;ПРД04.2023>" -- tem_name  -- ???
 ,10550.37                   --  x.item_price
 ,0
 ,1.000                      -- x.item_measure
 ,10550.37                   -- , x.item_sum
 ,full_payment               --  x.item_payment_method
 ,1                          --  x.payment_object
 ,vat0                       --  x.item_vat
 
 ,40817810026234001170                                 -- x.client_account
 ,40702810446010006799                                 -- x.company_account
 ,"[""+7 (4212) 45-54-55""]"                           -- x.company_phones
 ,"ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск"        -- x.company_name
 
 ,143                                                   -- z.id_org 
 ,195                                                   -- id_org_app 
 ,040813713                                             -- x.company_bik 
 ,t
 ,"Центральный филиал АБ ""РОССИЯ"" г. Москва"
 ,"121069, Москва, Мерзляковский пер., д. 18, стр. 2"   -- x.bank_addr
 ,7831000122
 ,044525112
 ,"[""8 (800) 100-11-11"",""+7 (812) 335-85-00""]"      -- x.bank_phones 
 ,a8c63070-b8f7-429d-a494-710d7fee87e0
 ,382322
 ,sell)
--

("2023-05-13 00:00:00"
 ,email@ofd.ru
 ,osn
 ,7702070139
 ,"680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1"
 ,"ИНН 272011197560 Суворов Сергей Александрович"
 ,272011197560
 ,1
 ,10550.37
 ,", НДС не облагается, <ЛС 81590188;ПРД04.2023>"
 ,10550.37
 ,0
 ,1.000
 ,10550.37
 ,full_payment
 ,1
 ,vat0
 ,40817810026234001170
 ,40702810446010006799
 ,"{""+7 (4212) 45-54-55""}"
 ,"ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск"
  ,143
 ,195
 ,040813713
 ,t
 ,"Центральный филиал АБ ""РОССИЯ"" г. Москва"
 ,"121069, Москва, Мерзляковский пер., д. 18, стр. 2"
 ,7831000122
 ,044525112
 ,"{""8 (800) 100-11-11"",""+7 (812) 335-85-00""}"
 ,a8c63070-b8f7-429d-a494-710d7fee87e0
 ,382322
 ,sell
)
--------------------------------------------------------------------------
SELECT id_receipt, dt_create, rcp_status, dt_update, inn, rcp_nmb, rcp_fp, dt_fp, id_org_app, rcp_status_descr, rcp_order
, rcp_receipt, id_fsc_provider, rcp_type, rcp_received, rcp_notify_send, id_pay, resend_pr
	FROM fiscalization.fsc_receipt WHERE (rcp_status = 0) AND (id_pay = 382322);
--	
BEGIN ;
ROLLBACK;
COMMIT;
DELETE FROM	fiscalization.fsc_receipt WHERE (rcp_status = 0) AND (id_pay = 382322);


NOTICE:  ("2023-05-13 00:00:00",email@ofd.ru,osn,7702070139,"680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1","ИНН 272011197560 Суворов Сергей Александрович",272011197560,1,10550.37,", НДС не облагается, <ЛС 81590188;ПРД04.2023>",10550.37,0,1.000,10550.37,full_payment,1,vat0,40817810026234001170,40702810446010006799,"{""+7 (4212) 45-54-55""}","ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск",143,195,040813713,t,"Центральный филиал АБ ""РОССИЯ"" г. Москва","121069, Москва, Мерзляковский пер., д. 18, стр. 2",7831000122,044525112,"{""8 (800) 100-11-11"",""+7 (812) 335-85-00""}",a8c63070-b8f7-429d-a494-710d7fee87e0,382322,sell,bank_paying_agent,www.xxx.ru,Платёж)

ERROR:  null value in column "id_fsc_provider" violates not-null constraint
ПОДРОБНОСТИ:  Failing row contains (8557734610, 2023-05-13 00:00:00+03, 0, null, 272011197560, a8c63070-b8f7-429d-a494-710d7fee87e0, null, null, 195, null, {"receipt": {"items": [{"sum": 10550.37, "vat": {"type": "vat0"}..., null, null, 0, f, f, 382322, 0).
КОНТЕКСТ:  SQL statement "INSERT INTO fiscalization.fsc_receipt(
                  dt_create       -- d
                , rcp_status      -- 0
                , dt_update
                , inn             -- d
                , rcp_nmb         -- d
                , rcp_fp
                , dt_fp
                , id_org_app      -- 189
                , rcp_status_descr
                , rcp_order       -- d
                , rcp_receipt
                , rcp_type        -- 0  --Целое, типизация взята из  Orange
                , rcp_received    -- false
                , rcp_notify_send -- false
                , id_pay   -- d
                , resend_pr       -- 0    
	            , id_fsc_provider
           )
         VALUES (      	                      
                    __x.dt_create
                  , RCP_STATUS
                  , NULL
                  , __x.client_inn
                  , __x.external_id::text
                  , NULL
                  , NULL
                  , __x.id_org_app
                  , NULL
                  , __result::jsonb
                  , NULL
                  , CASE  -- Тип чека   Старая классификация, взятая из ORANGE            -- ??
                        WHEN (__x.rcp_type IN ('sell', 'buy'))               THEN 0 -- Кассовый чек
                        WHEN (__x.rcp_type IN ('sell_correction', 'buy_correction'
                                             , 'sell_refund_correction', 'buy_refund_correction'))
                                                                             THEN 1 -- Коррекция
                        WHEN (__x.rcp_type IN ('sell_refund', 'buy_refund')) THEN 2 -- Возврат 
			             ELSE
			                  NULL
                    END --  rcp_type
                    
                  , FALSE
                  , FALSE
                  , __x.id_pay
                  , RESEND_PR
			      ,FSC_PROVIDER
               )
               
         RETURNING id_receipt"
PL/pgSQL function fsc_receipt_pcg.fsc_orders_load(json) line 278 at SQL statement
SQL state: 23502
Detail: Failing row contains (8557734610, 2023-05-13 00:00:00+03, 0, null, 272011197560, a8c63070-b8f7-429d-a494-710d7fee87e0, null, null, 195, null, {"receipt": {"items": [{"sum": 10550.37, "vat": {"type": "vat0"}..., null, null, 0, f, f, 382322, 0).
Context: SQL statement "INSERT INTO fiscalization.fsc_receipt(
                  dt_create       -- d
                , rcp_status      -- 0
                , dt_update
                , inn             -- d
                , rcp_nmb         -- d
                , rcp_fp
                , dt_fp
                , id_org_app      -- 189
                , rcp_status_descr
                , rcp_order       -- d
                , rcp_receipt
                , rcp_type        -- 0  --Целое, типизация взята из  Orange
                , rcp_received    -- false
                , rcp_notify_send -- false
                , id_pay   -- d
                , resend_pr       -- 0    
           )
         VALUES (      	                      
                    __x.dt_create
                  , RCP_STATUS
                  , NULL
                  , __x.client_inn
                  , __x.external_id::text
                  , NULL
                  , NULL
                  , __x.id_org_app
                  , NULL
                  , __result::jsonb
                  , NULL
                  , CASE  -- Тип чека   Старая классификация, взятая из ORANGE            -- ??
                        WHEN (__x.rcp_type IN ('sell', 'buy'))               THEN 0 -- Кассовый чек
                        WHEN (__x.rcp_type IN ('sell_correction', 'buy_correction'
                                             , 'sell_refund_correction', 'buy_refund_correction'))
                                                                             THEN 1 -- Коррекция
                        WHEN (__x.rcp_type IN ('sell_refund', 'buy_refund')) THEN 2 -- Возврат 
			             ELSE
			                  NULL
                    END --  rcp_type
                    
                  , FALSE
                  , FALSE
                  , __x.id_pay
                  , RESEND_PR
               )
               
         RETURNING id_receipt"
PL/pgSQL function fsc_receipt_pcg.fsc_orders_load(json) line 278 at SQL statement

--
--   2023-08-11 --
--
SELECT id_receipt, dt_create, rcp_status, dt_update, inn, rcp_nmb, rcp_fp, dt_fp, id_org_app, rcp_status_descr, rcp_order
, rcp_receipt, id_fsc_provider, rcp_type, rcp_received, rcp_notify_send, id_pay, resend_pr
	FROM fiscalization.fsc_receipt WHERE (rcp_status = 0) AND (id_pay = 382322);

SELECT * FROM fiscalization.fsc_org_app WHERE (id_org_app = 195);
--
EXPLAIN ANALYZE
SELECT  x0.id_org
       ,x1.inn
	   ,x1.bik
	   ,x1.nm_org_name
	   ,x1.nm_org_address
	   ,x1.nm_org_phones
	   ,x1.org_type
	   ---    Хорошо, но какое приложение при этом зацепили.Непонятно до конца, как приложение участвует в процессе
	   ,x0.id_app
	   ,x2.app_guid
	   ,x2.secret_key
	   ,x2.nm_app
	   ,x2.notification_url  -- Брать из приложения  ???
	   ,x2.provaider_key
        -- Как его зацепить ???
       ,x0.id_fsc_data_operator
	   ,x3.ofd_inn
	   ,x3.nm_ofd
	   ,x3.nm_ofd_full
	   ,x3.ofd_site
	   
       FROM fiscalization.fsc_org_app x0 
  
   JOIN fiscalization.fsc_org  x1 ON (x1.id_org = x0.id_org)
   JOIN fiscalization.fsc_app  x2 ON (x2.id_app = x0.id_app)
   JOIN fiscalization.fsc_data_operator x3 ON (x3.id_fsc_data_operator = x0.id_fsc_data_operator)
  
WHERE ( x0.id_org_app = 195);
--
--  ----------------------------------------------------------------------------------------------
--
EXPLAIN ANALYZE
SELECT k.*, x1.* FROM fiscalization.fsc_org_app k, fiscalization.fsc_app x1
WHERE (143 = k.id_org) AND (x1.app_guid = '212f1d68-88ee-4d14-882b-1c945bcc785b')
or 
(143 = k.id_org)


EXPLAIN ANALYZE
SELECT x1.notification_url FROM fiscalization.fsc_org_app k, fiscalization.fsc_app x1
WHERE (143 = k.id_org) AND (x1.app_guid = '212f1d68-88ee-4d14-882b-1c945bcc785b')

explain analyze
SELECT  x0.id_org
       ,x1.inn
	   ,x1.bik
	   ,x1.nm_org_name
	   ,x1.nm_org_address
	   ,x1.nm_org_phones
	   ,x1.org_type
	   ---    Хорошо, но какое приложение при этом зацепили.Непонятно до конца, как приложение участвует в процессе
	   ,x0.id_app
	   ,x2.app_guid
	   ,x2.secret_key
	   ,x2.nm_app
	   ,x2.notification_url  -- Брать из приложения  ???
	   ,x2.provaider_key
	   
       FROM fiscalization.fsc_org_app x0 
  
   JOIN fiscalization.fsc_org  x1 ON (x1.id_org = x0.id_org)
   JOIN fiscalization.fsc_app  x2 ON (x2.id_app = x0.id_app)
  
WHERE ( x0.id_org_app = 195) AND (x2.app_guid = '212f1d68-88ee-4d14-882b-1c945bcc785b')
  ORDER BY x2.id_app limit 1;
  
explain analyze
SELECT  
	    x2.notification_url  -- Брать из приложения  ???
   
       FROM fiscalization.fsc_org_app x0 
  
  -- JOIN fiscalization.fsc_org  x1 ON (x1.id_org = x0.id_org)
   JOIN fiscalization.fsc_app  x2 ON (x2.id_app = x0.id_app)
  
WHERE ( x0.id_org_app = 195) AND (x2.app_guid = '212f1d68-88ee-4d14-882b-1c945bcc785b')
  ORDER BY x0.id_app limit 1;  