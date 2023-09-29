SELECT -- * FROM json_to_recordset (
json_array_length ( 
'[{"uuid":"561e3d6d-b174-4f3c-99a5-8a9af37f900d",
"error":null,
"status":"done",
"payload":{
             "total":7000.00,
             "fns_site":"www.nalog.ru",
             "fn_number": "1110000100238211",
             "shift_number":23,
             "receipt_datetime":"12.05.2023 20:16:00",
             "fiscal_receipt_number":6,
             "fiscal_document_number":133,
             "ecr_registration_number":"0000111118041361",
             "fiscal_document_attribute":3449555941,
             "ofd_inn":"7709364346",
             "ofd_receipt_url":"https://consumer.1-ofd.ru" 
},
"timestamp":"12.05.2023 00:00:00",
"group_code":"group1",
"daemon_code":"prod–agent–1",
"device_code":"KSR13.00–1–11",
"external_id":"7b7d9867-c88f-46bb-ade3-e93d861103f3",
"callback_url":"www.xxx.ru"
}
, {"uuid":"53b4a9e9-5440-4e36-85db-7e0a606496d8",
"error":null,
"status":"done",
"payload":{
             "total":7000.00,
             "fns_site":"www.nalog.ru",
             "fn_number":"1110000100238211",
             "shift_number":23,
             "receipt_datetime":"12.05.2023 20:16:00",
             "fiscal_receipt_number":7,
             "fiscal_document_number":135,
             "ecr_registration_number":"0000111118041361",
             "fiscal_document_attribute":3449555352,
             "ofd_inn":"7709364346",
             "ofd_receipt_url":"https://consumer.1-ofd.ru" 
},
"timestamp":"13.05.2023 00:00:00",
"group_code":"group1",
"daemon_code":"prod–agent–1",
"device_code":"KSR13.00–1–11",
"external_id":"320aafd4-e484-43d8-8135-959f6d98b54f",
"callback_url":"www.xxx.ru"
}
]'
	)-- ::json
-- ) AS x ( f1 json);


--select * from json_to_recordset('[{"a":1,"b":"foo"}, {"a":"2","c":"bar"}]') as x(a int, b text)
