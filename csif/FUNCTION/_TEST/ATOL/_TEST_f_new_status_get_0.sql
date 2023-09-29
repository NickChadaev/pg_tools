--
--  2023-09-01  Первый тест на обработку ошибок
--
SELECT 
'{
"error": {
            "error_id": "475d6d8d-844d-4d05-aa8b-e3dbdf4defd6",
            "code": 34,
            "text": "Состояние чека не найдено. Попробуйте позднее",
            "type": "system"
 },
"status": "wait",
"timestamp": "12.04.2022 18:58:38",
"callback_url": ""
}'::json #> '{error, type}';
-- }'::json ->> 'status'
--
-- ---------------------------------------------------------------
--
SELECT 
'{
"uuid": "2ea26f17–0884–4f08–b120–306fc096a58f",
"error": {
            "error_id": "475d6d8d-844d-4d05-aa8b-e3dbdf4defd6",
            "code": 34,
            "text": "Состояние чека не найдено. Попробуйте позднее",
            "type": "system"
 },
"status": "wait",
"timestamp": "12.04.2022 20:15:08",
"callback_url": "",
"payload": {
             "total": 1598,
             "fns_site": "www.nalog.ru",
             "fn_number": "1110000100238211",
             "shift_number": 23,
             "receipt_datetime": "12.04.2022 20:16:00",
             "fiscal_receipt_number": 6,
             "fiscal_document_number": 133,
             "ecr_registration_number": "0000111118041361",
             "fiscal_document_attribute": 3449555941,
             "ofd_inn": "7709364346",
             "ofd_receipt_url": "https://consumer.1-ofd.ru/v1?fn=9288000100014915&fp=3004144185&i=108&t=20180522T122800&s=4500.00&n=1",
             "marks_result": [{
                                "position": 0,
                                "mark_code":
                                "MDE1MDc1NDA0MTM5ODc0NTIxVVdqVXd5djQyNncxbFx1MDAxZDkxRkZEMFx1MDAxZDkyZEdWemRLSnc3ZXV3Ui8wZng1bzRpZFB5ZE5rcW15cFZMbkhEZ2ozTGV1WT0=",
                                "result": 15
                               }
             ]
},
"group_code": "group1",
"daemon_code": "prod–agent–1",
"device_code": "KSR13.00–1–11",
"external_id": "TRF10601_1" 
}
'::json #> '{error, type}';
