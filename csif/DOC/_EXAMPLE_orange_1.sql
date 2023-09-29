--
--   2023-08-16  Пример запроса с данными агента, дополнительным реквизитом пользователя, 
--               данными поставщика, номером автомата, адресом расчета и местом расчета:
--

{
"id": "12345678990",
"inn": "123456789012",
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
              "nomenclatureCode": "igQVAAADMTIzNDU2Nzg5MDEyMwAAAAAAAQ==",
              "agentType": 127,
              "agentInfo": {
              "paymentTransferOperatorPhoneNumbers": [ "+79200000001", "+74997870001" ],
              46"paymentAgentOperation": "Какая-то операция 1",
              "paymentAgentPhoneNumbers": [ "+79200000003" ],
              "paymentOperatorPhoneNumbers": [ "+79200000002", "+74997870002" ],
              "paymentOperatorName": "ООО \"Атлант\"",
              "paymentOperatorAddress": "Воронеж, ул. Недогонная, д. 84",
              "paymentOperatorINN": "7727257386"
              },
              "unitOfMeasurement": "Кг",
              "additionalAttribute": "Доп. атрибут и все тут",
              "manufacturerCountryCode": "643",
              "customsDeclarationNumber": "АД 11/77 от 01.08.2018",
              "excise": 23.45
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
              }
              }
47],
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
"agentType": 127,
"paymentTransferOperatorPhoneNumbers": [ "+79260000001", "+74957870001" ],
"paymentAgentOperation": "Какая-то операция",
"paymentAgentPhoneNumbers": [ "+79260000003" ],
"paymentOperatorPhoneNumbers": [ "+79260000002", "+74957870002" ],
"paymentOperatorName": "ООО \"Росинка\"",
"paymentOperatorAddress": "Москва, Мастеркова 4",
"paymentOperatorINN": "9715225506",
"supplierPhoneNumbers": [ "+74957870004" ],
"additionalUserAttribute": {
"name": "Любимая цитата",
48"value": "В здоровом теле здоровый дух, этот лозунг еще не потух!"
},
"automatNumber": "123456789",
"settlementAddress": "г.Москва, Красная площадь, д.1",
"settlementPlace": "Палата No6",
"additionalAttribute": "Доп атрибут чека",
"customer": "Кузнецов Иван Петрович",
"customerINN": "789456123488"
}
}
