--
-- 2023-08-16 Пример запроса сформированного в соответствии с ФФД 1.2:
--

{
"id": "12345678990",
"inn": "7725327863",
"group": "Main",
"key": "1234567",
"content": {
            "type": 1,
            "positions": [
                            {
                             "quantity": 1.000,
                             "price": 123.45,
                             "tax": 6,
                             "text": "Булка",
                             
                             "paymentMethodType": 4,
                             "paymentSubjectType": 1,
                             
                             "agentType": 127,
                             
                             "agentInfo": {
                                          "paymentTransferOperatorPhoneNumbers": [ "+79200000001", "+74997870001" ],
                                          "paymentAgentOperation": "Какая-то операция 1",
                                          "paymentAgentPhoneNumbers": [ "+79200000003" ],
                                          "paymentOperatorPhoneNumbers": [ "+79200000002", "+74997870002" ],
                                          "paymentOperatorName": "ООО \"Атлант\"",
                                          "paymentOperatorAddress": "Воронеж, ул. Недогонная, д. 84",
                                          "paymentOperatorINN": "7727257386"
                             },
                             
                             "additionalAttribute": "Доп. атрибут и все тут",
                             
                             "manufacturerCountryCode": "643",
                             "customsDeclarationNumber": "АД 11/77 от 01.08.2018",
                             "
                             excise": 23.45,
                             "unitTaxSum": 0.23,
                             
                             "itemCode": "010460406000600021N4N57RSCBUZTQ\u001d2403004002910161218\u001d1724010191ffd0\u001d92tIAF/YVoU4roQS3M/m4z78yFq0fc/WsSmLeX5Qk
                             F/YVWwy8IMYAeiQ91Xa2z/fFSJcOkb2N+uUUmfr4n0mOX0Q==",
                             
                             "plannedStatus": 2,
                             
                             "fractionalQuantity": {
                             "numerator": 1,
                             "denominator": 2
                             },
                             
                             "industryAttribute": {
                             "foivId": "012",
                             "causeDocumentDate": "12.08.2021",
                             "causeDocumentNumber": "666",
                             "value": "position industry"
                             },
                             "barcodes": {
                                            "ean8": "46198532",
                                            "ean13": "4006670128002",
                                            "itf14": "14601234567890",
                                            "gs1": "010460043993125621JgXJ5.T",
                                            "mi": "RU-401301-AAA0277031",
                                            "egais20": "NU5DBKYDOT17ID980726019",
                                            "egais30": "13622200005881",
                                            "f1": null,
                                            "f2": null,
                                            "f3": null,
                                            "f4": null,
                                            "f5": null,
                                            "f6": null
                                         }
                             },
                             {
                                "quantity": 2.000,
                                "price": 4.45,
                                "tax": 4,
                                "text": "Спички",
                                "paymentMethodType": 3,
                                "paymentSubjectType": 13,
                                "supplierINN": "9715225506",
                                "supplierInfo": {
                                                  "phoneNumbers": [ "+79266660011", "+79266660022" ],
                                                  "name": "ПАО \"Адамас\""
                                                },
                                "quantityMeasurementUnit": 10
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
                                          "amount": 8.90000
                                          }
                            ],
                            "taxationSystem": 1
            },
            "customerContact": "foo@example.com",
            "additionalUserAttribute": {
                                     "name": "Любимая цитата",
                                     "value": "В здоровом теле здоровый дух, этот лозунг еще не потух!"
            },
            
            "automatNumber": "123456789",
            "settlementAddress": "г.Москва, Красная площадь, д.1",
            "settlementPlace": "Палата No6",
            "additionalAttribute": "Доп атрибут чека",
            "cashier": "Кассир",
            "senderEmail": "ru@example.mail",
            "customerInfo": {
                              "name": "Кузнецов Иван Петрович",
                              "inn": "7725327863",
                              "birthDate": "15.09.1988",
                              "citizenship": "643",
                              "identityDocumentCode": "01",
                              "identityDocumentData": "multipassport",
                              "address": "Басеенная 36"
            },
            "operationalAttribute": {
                                      "date": "2021-08-12T18:36:16",
                                      "id": 0,
                                      "value": "operational"
            },
            "industryAttribute": {
                                   "foivId": "010",
                                   "causeDocumentDate": "11.08.2021",
                                   "causeDocumentNumber": "999",
                                   "value": "industry"
            },
            "ffdVersion": 4
},

"meta": "some meta",
"callbackUrl": "http://call.back/?doc=2",
"ignoreItemCodeCheck": false
}

