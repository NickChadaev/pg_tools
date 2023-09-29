--
--   2023-05-23
--
SELECT fsc_receipt_pcg.fsc_agent_info_crt_2(
       p_type  := 'bank_paying_agent'  -- Тип агента по предмету расчёта 
 );
-- {"agent_info":{"type":"bank_paying_agent"}}

SELECT fsc_receipt_pcg.fsc_agent_info_crt_2(
       p_type  := 'bank_paying_agent'  -- Тип агента по предмету расчёта 
      ,p_paying_agent := fsc_receipt_pcg.fsc_paying_agent_crt_3 ('Платёж', ARRAY['9211773067', '+38980935788', '4953367178'])
 );
--
-- {"agent_info":{"type":"bank_paying_agent"
--               ,"paying_agent":{"operation":"Платёж","phones":["9211773067","+38980935788","4953367178"]}
-- 			  }
-- }

-- Далее, вместо вывзова функции использую константу
--

SELECT fsc_receipt_pcg.fsc_agent_info_crt_2(
       p_type  := 'bank_paying_agent'  -- Тип агента по предмету расчёта 
      ,p_paying_agent := fsc_receipt_pcg.fsc_paying_agent_crt_3 ('Платёж', ARRAY['9211773067', '+38980935788', '4953367178'])
      ,p_receive_payments_operator := '{"phones":["9211773067","+38980935788","4953367178"]}'
 );
--
-
--
-- {"type":"bank_paying_agent"
--       ,"paying_agent":{"operation":"Платёж","phones":["9211773067","+38980935788","4953367178"]}
--       ,"receive_payments_operator":{"phones":["9211773067","+38980935788","4953367178"]}
-- }

--
-- Завершающий вызов функции
--
SELECT fsc_receipt_pcg.fsc_agent_info_crt_2(
       p_type                      := 'bank_paying_agent'  -- Тип агента по предмету расчёта 
      ,p_paying_agent              := fsc_receipt_pcg.fsc_paying_agent_crt_3 ('Платёж', ARRAY['9211773067', '+38980935788', '4953367178'])
      ,p_receive_payments_operator := '{"phones":["9211773067","+38980935788","4953367178"]}' -- Константа
      ,p_money_transfer_operator   := fsc_receipt_pcg.fsc_money_transfer_operator_crt_3 
                                                 ( ARRAY ['9211773067', '+38980935788', '4953367178']
                                                  ,'xxxxx', 'г. Москва, ул. Складочная д.3', '778907872311'
                                                  )
 );
-- -----------------------------------------------------
{"agent_info":{ "type":"bank_paying_agent"
               ,"paying_agent":{"operation":"Платёж","phones":["9211773067","+38980935788","4953367178"]}
               ,"receive_payments_operator":{"phones":["9211773067","+38980935788","4953367178"]}
               ,"money_transfer_operator":{"phones":["9211773067","+38980935788","4953367178"]
                                           ,"name":"xxxxx"
                                           ,"address":"г. Москва, ул. Складочная д.3"
                                           ,"inn":"778907872311"
                 }
            }
}

--
-- 2023-06-07 Завершающий вызов функции
--
SELECT fsc_receipt_pcg.fsc_agent_info_crt_2(
       p_type                      := 'bank_paying_agent'  -- Тип агента по предмету расчёта 
      ,p_paying_agent              := fsc_receipt_pcg.fsc_paying_agent_crt_3 ('Платёж', ARRAY['9211773067', '+38980935788', '4953367178'])
      ,p_receive_payments_operator := '{"phones":["9211773067","+38980935788","4953367178"]}' -- Константа
      ,p_money_transfer_operator   := fsc_receipt_pcg.fsc_money_transfer_operator_crt_3 
                                                 ( ARRAY ['9211773067', '+38980935788', '4953367178']
                                                  ,'xxxxx', 'г. Москва, ул. Складочная д.3', '778907872311'
                                                  )
);
--
-- 
{"type":"bank_paying_agent"
    ,"paying_agent":{ "operation":"Платёж"
                     ,"phones":["9211773067","+38980935788","4953367178"]}
                     ,"receive_payments_operator":{
                              "phones":["9211773067","+38980935788","4953367178"]}
                              ,"money_transfer_operator":{
                                 "phones":["9211773067","+38980935788","4953367178"]
                                 ,"name":"xxxxx"
                                 ,"address":"г. Москва, ул. Складочная д.3"
                                 ,"inn":"778907872311"}
}
--
SELECT fsc_receipt_pcg.fsc_agent_info_crt_2(
       p_type                      := 'bank_paying_agent'  -- Тип агента по предмету расчёта 
      ,p_paying_agent              := fsc_receipt_pcg.fsc_paying_agent_crt_3 ('Платёж', NULL)
      ,p_receive_payments_operator := NULL -- Константа
      ,p_money_transfer_operator   := fsc_receipt_pcg.fsc_money_transfer_operator_crt_3 
                                                 ( NULL
                                                  ,'xxxxx', 'г. Москва, ул. Складочная д.3', '778907872311'
                                                  )
);
-- 
{"type":"bank_paying_agent"
   ,"paying_agent":{"operation":"Платёж"}
   ,"money_transfer_operator":{"name":"xxxxx"
                              ,"address":"г. Москва, ул. Складочная д.3"
                              ,"inn":"778907872311"}
}
