--
--  2023-05-29
-- ----------------------------------------------------------------------------------------
--      Вариант первый  Игнорируется всё, после "vats". 
-- ---------------------------------------------------------------------------------------
SELECT fsc_receipt_pcg.fsc_receipt_crt_0(
      -- Покупатель / клиент
      p_client  := fsc_receipt_pcg.fsc_client_crt_1 (p_name := 'ООО "МОСОБЛЕИРЦ"', p_inn := '5037008735')::json
      -- Компания
     ,p_company := fsc_receipt_pcg.fsc_company_crt_1 ('mail@1-ofd.ru', 'osn', '5037008735', 'shop-url.ru')::json 
     -- Товары, услуги
     , p_items := $$        
              [{  
                   "name":"ЛС 86427847; квартплата за март 2023  Госпитальная  10 кв.41 Игнатова Е.Н. НДС не облагается"
                  ,"price":20.00
                  ,"quantity":1.000
                  ,"measure":0
                  ,"sum":20.00
                  ,"payment_method":"full_prepayment"
                  ,"payment_object":1
                  ,"vat":{"type":"vat10","sum":2.02}
                  ,"user_data":"Дополнительный ревизит предмета расчёта"
                  ,"excise":10.00
                  ,"country_code":"063"
                  ,"declaration_number":"00289282828"
                  ,"mark_quantity":{"numerator":1
                                   ,"denominator":2
                   }
                  ,"mark_processing_mode":"0"
                  ,"sectoral_item_props":[{ "federal_id":"001"
                                           ,"date":"23.05.2023"
                                           ,"number":"123/43"
                                           ,"value":"Ид1=Знач1&Ид2=Знач2&Ид3=Знач3"
                                         }
                  ]
                  ,"mark_code":{"egais30":"12345678901234"}
                  ,"agent_info":{"type":"bank_paying_agent"
                                 ,"paying_agent":{"operation":"Платёж",
                                                  "phones":["9211773067","+38980935788","4953367178"]
                                                 }
                                 ,"receive_payments_operator":{"phones":["9211773067","+38980935788","4953367178"]}
                                 ,"money_transfer_operator":{"phones":["9211773067","+38980935788","4953367178"]
                                                            ,"name":"xxxxx"
                                                            ,"address":"г. Москва, ул. Складочная д.3"
                                                            ,"inn":"778907872311"
                                                     }   
                   },"supplier_info":{"phones":["9211773067","+38980935788","4953367178"]}
              }
             ]
        $$::json 
       --  Оплаты   
     , p_payments := fsc_receipt_pcg.fsc_payments_crt_1 (array[('1', 200.2)]::pmt_type_sum_t[])::json
     ,p_total := 202.2
     
     -- Атрибуты налогов на чек
     , p_vats := fsc_receipt_pcg.fsc_vats_crt_1 (array[('vat0', 200.2)]::vats_type_sum_t[])::json
     , p_cashier                := 'Лазарева Ю.Н'::text    -- ФИО кассира
     , p_cashier_inn            := '5034867638'::text  -- ИНН кассира
     , p_additional_check_props := 'ZZZZZZZZZZZZ'::text -- Дополнительный реквизит чека
       -- Дополнительный реквизит пользователя
     , p_additional_user_props := fsc_receipt_pcg.fsc_additional_user_props_crt_1 ('R2','V4444')::json 
       -- Операционныц реквизит чека
     , p_operating_check_props  := fsc_receipt_pcg.fsc_operating_check_props_crt_1 ('0', '888888', to_char (now(), 'dd.mm.yyyy HH:MM:SS'))::json
     , p_sectoral_check_props   := fsc_receipt_pcg.fsc_sectoral_check_props_crt_1 (
                 array[ ('001', to_char('2023-05-23'::date, 'DD.MM.YYYY'), '123/43', 'Ид1=Знач1&Ид2=Знач2&Ид3=Знач3')
                       ,('002', to_char('2023-03-20'::date, 'DD.MM.YYYY'), '923/43', 'Ид1=Знач1&Ид2=Знач2&Ид3=Знач3')  
                      ]::sectoral_item_props_t[]
       )::json -- Отраслевой реквизит кассового чека
);
-- =====================================================================================================
-- ERROR:  function fsc_receipt_pcg.fsc_receipt_crt_0 (
--                      p_client => json
--                    , p_company => json
--                    , p_items => json
--                    , p_payments => json
--                    , p_total => numeric
--                    , p_vats => json
--                    , p_cashier => text
--                    , p_cashier_inn => text
--                    , p_additional_check_props => text
--                    , p_additional_user_proips => json
--                    , p_operating_check_props => json,
--                    p_sectoral_check_props => json
--  ) --does not exist
-- LINE 6: SELECT fsc_receipt_pcg.fsc_receipt_crt_0(
	
--     p_client                  json -- Покупатель / клиент 
--   , p_company                 json -- Компания
--   , p_items                   json -- Товары, услуги
--   , p_payments                json -- Оплаты
--   , p_total                   numeric (10,2) -- Итоговая сумма чека в рублях
--   , p_vats                    json  DEFAULT NULL -- Атрибуты налогов на чек
--   , p_cashier                 text  DEFAULT NULL -- ФИО кассира
--   , p_cashier_inn             text  DEFAULT NULL -- ИНН кассира
--   , p_additional_check_props  text  DEFAULT NULL -- Дополнительный реквизит чека
--   , p_additional_user_props   json  DEFAULT NULL -- Дополнительный реквизит пользовател
--   , p_operating_check_props   json  DEFAULT NULL -- Операционныц реквизит чека
--   , p_sectoral_check_props    json  DEFAULT NULL -- Отраслевой реквизит кассового чека
