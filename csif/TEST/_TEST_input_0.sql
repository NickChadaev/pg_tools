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
{"id_source_reestr":1,
 "dt_create":"2023-05-13T00:00:00",
 "id_pay":382322,
 "rcp_type":"sell",
 "company_email":"email@ofd.ru",
 "company_sno":"osn",
 "company_inn":"7702070139",
 "company_payment_address":"680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1",
 "client_name":"ИНН 272011197560 Суворов Сергей Александрович",
 "client_inn":"272011197560",
 "pmt_type":1,
 "pmt_sum":10550.37,
 "item_name":", НДС не облагается, <ЛС 81590188;ПРД04.2023>",
 "item_price":10550.37,
 "item_measure":0,
 "item_quantity":1.000,
 "item_sum":10550.37,
 "item_payment_method":"full_payment",
 "payment_object":1,
 "item_vat":"vat0",
 "type_source_reestr":0,
 "external_id":"a8c63070-b8f7-429d-a494-710d7fee87e0",
 "client_account":"40817810026234001170",
 "company_account":"40702810446010006799",
 "company_phones":["+7 (4212) 45-54-55"],
 "company_name":"ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск",
 "company_bik":"040813713",
 "company_paying_agent":true,
 "bank_name":"Центральный филиал АБ \"РОССИЯ\" г. Москва",
 "bank_addr":"121069, Москва, Мерзляковский пер., д. 18, стр. 2",
 "bank_inn":"7831000122",
 "bank_bik":"044525112",
 "bank_phones":["8 (800) 100-11-11","+7 (812) 335-85-00"]
 }
