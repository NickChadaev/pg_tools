--
--    2023-08-22
-- ------------------------------------------------------------------------------------

SELECT      x.uuid        
          , x.error       
          , x.status      
          , x.payload 
          --
          , (to_timestamp (x.timestamp, 'DD.MM.YYYY HH24:MI:SS'))::timestamp(0) without time zone   
          --
		  , (to_timestamp ((x.payload ->> 'receipt_datetime'), 'DD.MM.YYYY HH24:MI:SS'))::timestamp(0) without time zone AS ddt_fp  
          , (x.payload ->> 'fiscal_document_number')  AS fiscal_document_number
          , (x.payload ->> 'fiscal_document_attribute') AS fiscal_document_attribute
          
         -- , x.group_code  
         -- , x.daemon_code 
         -- , x.device_code 
          , x.external_id 
         -- , x.callback_url
          ,( json_strip_nulls (
                json_build_object (
                  'uuid ',        x.uuid     
                 ,'error',        x.error     
                 ,'status',       x.status    
                 ,'payload',      x.payload   
                 ,'timestamp',    x.timestamp 
                 ,'group_code',   x.group_code
                 ,'daemon_code',  x.daemon_code 
                 ,'device_code',  x.device_code 
                 ,'external_id',  x.external_id 
                 ,'callback_url', x.callback_url
               )
             )          
          ) AS js

FROM json_to_recordset ('[{"uuid":"561e3d6d-b174-4f3c-99a5-8a9af37f900d",
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
   "timestamp":"13.05.2023 00:00:00",
   "group_code":"group1",
   "daemon_code":"prod–agent–1",
   "device_code":"KSR13.00–1–11",
   "external_id":"320aafd4-e484-43d8-8135-959f6d98b54f",
   "callback_url":"www.xxx.ru"
}
]'::json -- 
)  -- AS x (f json) ;

AS x (  uuid         uuid
      , error        text
      , status       text
	  , payload      json
      , timestamp    text
      , group_code   text
      , daemon_code  text
      , device_code  text
      , external_id  text
      , callback_url text      
);

{"uuid ":"561e3d6d-b174-4f3c-99a5-8a9af37f900d","status":"done","payload":{"total":7000.00,"fns_site":"www.nalog.ru","fn_number":"1110000100238211","shift_number":23,"receipt_datetime":"12.05.2023 20:16:00","fiscal_receipt_number":6,"fiscal_document_number":133,"ecr_registration_number":"0000111118041361","fiscal_document_attribute":3449555941,"ofd_inn":"7709364346","ofd_receipt_url":"https://consumer.1-ofd.ru"},"timestamp":"12.05.2023 00:00:00","group_code":"group1","daemon_code":"prod–agent–1","device_code":"KSR13.00–1–11","external_id":"7b7d9867-c88f-46bb-ade3-e93d861103f3","callback_url":"www.xxx.ru"}
{"uuid ":"561e3d6d-b174-4f3c-99a5-8a9af37f900d","status":"done","payload":{"total":7000.00,"fns_site":"www.nalog.ru","fn_number":"1110000100238211","shift_number":23,"receipt_datetime":"12.05.2023 20:16:00","fiscal_receipt_number":6,"fiscal_document_number":133,"ecr_registration_number":"0000111118041361","fiscal_document_attribute":3449555941,"ofd_inn":"7709364346","ofd_receipt_url":"https://consumer.1-ofd.ru"},"timestamp":"12.05.2023 00:00:00","group_code":"group1","daemon_code":"prod–agent–1","device_code":"KSR13.00–1–11","external_id":"7b7d9867-c88f-46bb-ade3-e93d861103f3","callback_url":"www.xxx.ru"}

SELECT x, x.* FROM json_to_recordset ('[{"uuid":"561e3d6d-b174-4f3c-99a5-8a9af37f900d",
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
   "timestamp":"13.05.2023 00:00:00",
   "group_code":"group1",
   "daemon_code":"prod–agent–1",
   "device_code":"KSR13.00–1–11",
   "external_id":"320aafd4-e484-43d8-8135-959f6d98b54f",
   "callback_url":"www.xxx.ru"
}
]'::json -- 
)  -- AS x (f json) ;

AS x (  uuid         text
      , error        text
      , status       text
	  , payload      json
      , timestamp    text
      , group_code   text
      , daemon_code  text
      , device_code  text
      , external_id  text
      , callback_url text      
);




Name        |Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
x           |(561e3d6d-b174-4f3c-99a5-8a9af37f900d
             ,
             ,done
             ,   "{ "total":7000.00
                   ,"fns_site":"www.nalog.ru"
                   ,"fn_number": "1110000100238211"
                   ,"shift_number":23
                   ,"receipt_datetime":"12.05.2023 20:16:00"
                   ,"fiscal_receipt_number":6
                   ,"fiscal_document_number"":133
                   ,"ecr_registration_number":"0000111118041361"
                   ,"fiscal_document_attribute":3449555941
                   ,"ofd_inn":"7709364346"
                   ,"ofd_receipt_url":"https://consumer.1-ofd.ru"
                   }"
              ,"12.05.2023 00:00:00"
              ,group1,prod–agent–1
              ,KSR13.00–1–11
              ,7b7d9867-c88f-46bb-ade3-e93d861103f3
              ,www.xxx.ru
              )|
-- ---------+---------------------------------------------------------------------
uuid        |561e3d6d-b174-4f3c-99a5-8a9af37f900d                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
error       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
status      |done                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
payload     |{¶             "total":7000.00,¶             "fns_site":"www.nalog.ru",¶             "fn_number": "1110000100238211",¶             "shift_number":23,¶             "receipt_datetime":"12.05.2023 20:16:00",¶             "fiscal_receipt_number":6,¶             "fiscal_document_number":133,¶             "ecr_registration_number":"0000111118041361",¶             "fiscal_document_attribute":3449555941,¶             "ofd_inn":"7709364346",¶             "ofd_receipt_url":"https://consumer.1-ofd.ru" ¶}                                                                                                                                                                                         |
timestamp   |12.05.2023 00:00:00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
group_code  |group1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
daemon_code |prod–agent–1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
device_code |KSR13.00–1–11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
external_id |7b7d9867-c88f-46bb-ade3-e93d861103f3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
callback_url|www.xxx.ru                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
