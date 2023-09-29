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
 
--     , p_vats                    json  DEFAULT NULL -- Атрибуты налогов на чек
--     , p_cashier                 text  DEFAULT NULL -- ФИО кассира
--     , p_cashier_inn             text  DEFAULT NULL -- ИНН кассира
--     , p_additional_check_props  text  DEFAULT NULL -- Дополнительный реквизит чека
--     , p_additional_user_proips  json  DEFAULT NULL -- Дополнительный реквизит пользователя
--     , p_operating_check_props   json  DEFAULT NULL -- Операционныц реквизит чека
--     , p_sectoral_check_props    json  DEFAULT NULL -- Отраслевой реквизит кассового чека
);
-- =====================================================================================================

	
