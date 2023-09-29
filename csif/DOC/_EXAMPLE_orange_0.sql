--
--   2023-08-16 ПРИМЕР ЗАПРОСА
--
{
"id": "12345678990",
"inn": "123456789012",
"group": "Main",
"content": {
             "type": 1,
             "positions": [
                            {
                            "quantity": 1.000,
                            "price": 123.45,
                            "tax": 6,
                            "text": "Булка",
                            "paymentMethodType": 4,
                            "paymentSubjectType": 1
                            },
                            {
                            "quantity": 2.000,
                            "price": 4.45,
                            "tax": 4,
                            "text": "Спички",
                            "paymentMethodType": 3,
                            "paymentSubjectType": 13
                            }
                ],
             "checkClose": {
                            "payments": [
                                          {
                                          "type": 1,
                                          "amount": 123.45
                                          },
                                         {
                                         "type": 2,
                                         45"amount": 8.90000
                                         }
                                       ],
             "taxationSystem": 1
             },
             "customerContact": "foo@example.com"
          }
}

-- -----------------------------------------------------------------------------
---  OLD  Задача -- создать запрос. (как я буду его создавать -- другой вопрос)
--                  Поучить ответ от сервиса (изменить статус чека).

{ "id":"2015410"
 ,"inn":"7838056212"
 ,"group":"3010071"
 ,"key":"3010071"
 ,"content":{"type":1
             ,"positions":[
                   {"quantity":1
                   ,"price":86.62
                   ,"tax":1
                   ,"text":"ГАЗ (ЛС 721013989)"
                   ,"paymentMethodType":4
                   ,"paymentSubjectType":4
                   ,"nomenclatureCode":null
                   }
                   ],"checkClose":{"taxationSystem":0
                                  ,"payments":[{"type":2,"amount":86.62}]
                                  }
             ,"customerContact":"daryag245@gmail.com"}
}
