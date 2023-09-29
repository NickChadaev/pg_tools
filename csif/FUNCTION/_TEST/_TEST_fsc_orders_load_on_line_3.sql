--
--  2023-08-14  Операции возврата
--
SELECT * from fiscalization.fsc_receipt WHERE (rcp_status = 2)  limit 10;

	SELECT id_receipt, dt_create, rcp_status, dt_update, inn, rcp_nmb, rcp_fp, dt_fp, id_org_app
     , rcp_status_descr, rcp_order, rcp_receipt, id_fsc_provider, rcp_type, rcp_received, rcp_notify_send, id_pay, resend_pr
	FROM fiscalization.fsc_receipt WHERE (rcp_status = 0) AND  (id_receipt = 8557733591)  
																		 
    -- id_pay 917969																	 
	
    SELECT row_to_json (x, true) FROM fiscalization.fsc_source_reestr x
	   WHERE (id_pay = 917969);
         --------------------------------------------------------------------------
                           {"id_source_reestr":35,
                            "dt_create":"2023-05-13T00:00:00",
                            "id_pay":917969,
                            "rcp_type":"sell",
                            "company_email":"email@ofd.ru",
                            "company_sno":"osn",
                            "company_inn":"7710140679",
                            "company_payment_address":"127287, г. Москва, ул. Хуторская 2-я, д. 38А, стр. 26",
                            "client_name":"ИНН 504224132484 КУЗЬМИНА МАДИНА МУБАРАКЗАНОВНА",
                            "client_inn":"504224132484",
                            "pmt_type":1,
                            "pmt_sum":594.78,
                            "item_name":"взнос на кап.ремонт лиц счёт 32208926. НДС не облагается",
                            "item_price":594.78,
                            "item_measure":0,
                            "item_quantity":1.000,
                            "item_sum":594.78,
                            "item_payment_method":"full_payment",
                            "payment_object":1,
                            "item_vat":"vat0",
                            "type_source_reestr":0,
                            "external_id":"320aafd4-e484-43d8-8135-959f6d98b54f",
                            "client_account":"40817810400007413806",
                            "company_account":"40702810446010006799",
                            "company_phones":["8 (800) 700-66-66"],
                            "company_name":"АО \"Тинькофф Банк\" г. Москва",
                            "company_bik":"044525974",
                            "company_paying_agent":true,
                            "bank_name":"Центральный филиал АБ \"РОССИЯ\" г. Москва",
                            "bank_addr":"121069, Москва, Мерзляковский пер., д. 18, стр. 2",
                            "bank_inn":"7831000122",
                            "bank_bik":"044525112",
                            "bank_phones":["8 (800) 100-11-11","+7 (812) 335-85-00"]
                            } 
 --------------------------------------------------------------------------
         --  "app_guid":"212f1d68-88ee-4d14-882b-1c945bcc785b",    А ты знаешь его априори ???
         -----------------------------------------------------------------------------------------------------------------------------------------
		 -- ('sell', 'buy', 'sell_refund', 'buy_refund', 'sell_correction', 'buy_correction', 'sell_refund_correction', 'buy_refund_correction');
         SELECT (enum_range('sell'::operation_t, 'buy_refund'::operation_t)::text[])	-- {sell,buy,sell_refund,buy_refund}
    	 SELECT (enum_range( 'sell_correction'::operation_t, 'buy_refund_correction'::operation_t)::text[])	-- {sell,buy,sell_refund,buy_refund}
         --  {sell_correction,buy_correction,sell_refund_correction,buy_refund_correction}	
	
          SELECT (enum_range( 'sell_refund'::operation_t, 'buy_refund'::operation_t)::text[])	--{sell_refund,buy_refund}
          SELECT (enum_range( 'sell'::operation_t, 'buy'::operation_t)::text[])	--{sell,buy}
		 --------
SELECT fsc_receipt_pcg.fsc_orders_load (
'{ 
  "dt_create":"2023-05-13T00:00:00",
  "id_pay":917969,
  "rcp_type":"sell_correction",
  "external_id":"320aafd4-e484-43d8-8135-959f6d98b54f",
	
  "company_email":"email@ofd.ru",
  "company_sno":"osn",
  "company_inn":"7710140679",
  "company_payment_address":"127287, г. Москва, ул. Хуторская 2-я, д. 38А, стр. 26",

 
 "company_phones":["8 (800) 700-66-66"],
 "company_name":"АО \"Тинькофф Банк\" г. Москва",
 "company_bik":"044525974",
 
 "company_paying_agent":true,
 "agent_type":"bank_paying_agent",
 "paying_agent_operation":"Коррекция Платежа",
 
 "client_name":"ИНН 504224132484 КУЗЬМИНА МАДИНА МУБАРАКЗАНОВНА",
 "client_inn":"504224132484",
 
 "pmt_type":1,
 "pmt_sum":594.78,
 "payment_object":1,
 
 "item_name":"Взнос на кап.ремонт лиц счёт 32208926. НДС не облагается",
 "item_price":594.78,
 "item_measure":0,
 "item_quantity":1.000,
 "item_sum":594.78,
 "item_payment_method":"full_payment",
 "item_vat":"vat0"

 ,"corr_type":"instruction" 
 ,"corr_date":"2023-06-01"
 ,"corr_doc ":"878/SD"
	
 }'::json 	

); -- 8557734614
 ------------------------------------------------------------------------------------------------------------------------
SELECT id_receipt, dt_create, rcp_status, dt_update, inn, rcp_nmb, rcp_fp, dt_fp, id_org_app, rcp_status_descr, rcp_order
, rcp_receipt, id_fsc_provider, rcp_type, rcp_received, rcp_notify_send, id_pay, resend_pr
	FROM fiscalization.fsc_receipt WHERE (rcp_status = 0) AND (id_pay = 917969);
--	
BEGIN ;
ROLLBACK;
COMMIT;
DELETE FROM	fiscalization.fsc_receipt WHERE (rcp_status = 0) AND (id_pay = 917969);

																		 -- 192, RCP_TYPE = 1


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


--
--   2023-08-14 --
--
SELECT id_receipt, dt_create, rcp_status, dt_update, inn, rcp_nmb, rcp_fp, dt_fp, id_org_app, rcp_status_descr, rcp_order
, rcp_receipt, id_fsc_provider, rcp_type, rcp_received, rcp_notify_send, id_pay, resend_pr
	FROM fiscalization.fsc_receipt WHERE (rcp_status = 0) AND (id_pay = 917969);

-------------------------------------------------------------------------------------------------
{
    "service": {
        "callback_url": "email@ofd.ru"
    },
    "timestamp": "13.05.2023 12:05::00",
    "correction": {
        "items": [
            {
                "sum": 594.78,
                "vat": {
                    "type": "vat0"
                },
                "name": "Взнос на кап.ремонт лиц счёт 32208926. НДС не облагается",
                "price": 594.78,
                "measure": 0,
                "quantity": 1,
                "agent_info": {
                    "type": "bank_paying_agent",
                    "paying_agent": {
                        "phones": [
                            "88007006666"
                        ],
                        "operation": "Коррекция Платежа"
                    },
                    "money_transfer_operator": {
                        "inn": "7710140679",
                        "name": "АО \"Тинькофф Банк\" г. Москва",
                        "phones": [
                            "88007006666"
                        ],
                        "address": "127287, г. Москва, ул. Хуторская 2-я, д. 38А, стр. 26"
                    },
                    "receive_payments_operator": {
                        "phones": [
                            "88007006666"
                        ]
                    }
                },
                "supplier_info": {
                    "inn": "7710140679",
                    "name": "АО \"Тинькофф Банк\" г. Москва",
                    "phones": [
                        "88007006666"
                    ]
                },
                "payment_method": "full_payment",
                "payment_object": 1
            }
        ],
        "total": 594.78,
        "client": {
            "inn": "504224132484",
            "name": "ИНН 504224132484 КУЗЬМИНА МАДИНА МУБАРАКЗАНОВНА"
        },
        "company": {
            "inn": "7710140679",
            "sno": "osn",
            "email": "email@ofd.ru",
            "payment_address": "127287, г. Москва, ул. Хуторская 2-я, д. 38А, стр. 26"
        },
        "payments": [
            {
                "pmt_sum": 594.78,
                "pmt_type": 1
            }
        ],
        "correction_info": {
            "type": "instruction",
            "base_date": "01.06.2023"
        }
    },
    "external_id": "320aafd4-e484-43d8-8135-959f6d98b54f",
    "ism_optional": true
}
````
-------------------------------------------------------------------------------------------------

SELECT * FROM fiscalization.fsc_org_app WHERE (id_org_app = 193); --
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
  
WHERE ( x0.id_org_app = 193);
--
--  ----------------------------------------------------------------------------------------------
--
{
    "receipt": {
        "items": [
            {
                "sum": 705.6,
                "vat": {
                    "type": "vat0"
                },
                "name": ", НДС не облагается, <ЛС 33504613>",
                "price": 705.6,
                "measure": 0,
                "quantity": 1,
                "agent_info": {
                    "type": "bank_paying_agent",
                    "paying_agent": {
                        "phones": [
                            "+74959258000"
                        ],
                        "operation": "Возврат Платежа"
                    },
                    "money_transfer_operator": {
                        "inn": "7702070139",
                        "name": "Филиал ЛС 7701 Банка ВТБ (ПАО) г. Москва",
                        "phones": [
                            "+74959258000"
                        ],
                        "address": "107031, Москва, ул. Кузнецкий мост, д.17, стр. 1"
                    },
                    "receive_payments_operator": {
                        "phones": [
                            "+74959258000"
                        ]
                    }
                },
                "supplier_info": {
                    "inn": "7702070139",
                    "name": "Филиал ЛС 7701 Банка ВТБ (ПАО) г. Москва",
                    "phones": [
                        "+74959258000"
                    ]
                },
                "payment_method": "full_payment",
                "payment_object": 1
            }
        ],
        "total": 705.6,
        "client": {
            "inn": "772374659607",
            "name": "ИНН 772374659607 Ганиев Равиль Хайдарович"
        },
        "company": {
            "inn": "7702070139",
            "sno": "osn",
            "email": "email@ofd.ru",
            "payment_address": "107031, Москва, ул. Кузнецкий мост, д.17, стр. 1"
        },
        "payments": [
            {
                "pmt_sum": 705.6,
                "pmt_type": 1
            }
        ]
    },
    "service": {
        "callback_url": "email@ofd.ru"
    },
    "timestamp": "12.05.2023 12:05::00",
    "external_id": "3ad2e7c8-c75c-4190-be08-b083963455b3",
    "ism_optional": true
}

