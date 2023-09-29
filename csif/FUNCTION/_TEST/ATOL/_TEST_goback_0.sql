--
-- 2023-08-21. Пример ответа на успешную фискализацию 
--
-- DROP TABLE fiscalization.fsc_goback;
CREATE TABLE fiscalization.fsc_goback (
   goback_data json
);

INSERT INTO  fiscalization.fsc_goback (goback_data)
    VALUES (
'[
{
  "uuid": "561e3d6d-b174-4f3c-99a5-8a9af37f900d"
 ,"error": null
 ,"status": "done"
 ,"payload": {
               "total": 7000.00
              ,"fns_site": "www.nalog.ru"
              ,"fn_number": "1110000100238211"
              ,"shift_number": 23
              ,"receipt_datetime": "13.05.2023 20:16:00"
              ,"fiscal_receipt_number": 6
              ,"fiscal_document_number": 133
              ,"ecr_registration_number": "0000111118041361"
              ,"fiscal_document_attribute": 3449555941
              ,"ofd_inn": "7709364346"
              ,"ofd_receipt_url": "https://consumer.1-ofd.ru"
} 
 ,"timestamp": "12.05.2023 00:00:00"
 ,"group_code": "group1"
 ,"daemon_code": "prod–agent–1"
 ,"device_code": "KSR13.00–1–11"
 ,"external_id": "f510abd4-4704-45d2-8f80-fd2bfb1d5896" 
 ,"callback_url": "www.xxx.ru"
}
, {
     "uuid": "53b4a9e9-5440-4e36-85db-7e0a606496d8"
    ,"error": null
    ,"status": "done"
    ,"payload": {
                  "total": 594.78
                 ,"fns_site": "www.nalog.ru"
                 ,"fn_number": "1110000100238211"
                 ,"shift_number": 24
                 ,"receipt_datetime": "13.05.2023 21:16:00"
                 ,"fiscal_receipt_number": 23
                 ,"fiscal_document_number": 135
                 ,"ecr_registration_number": "0000111118041370"
                 ,"fiscal_document_attribute": 3449555352
                 ,"ofd_inn": "7709364346"
                 ,"ofd_receipt_url": "https://consumer.1-ofd.ru" 
    } 
    ,"timestamp": "13.05.2023 12:05::00"
    ,"group_code": "group1"
    ,"daemon_code": "prod–agent–1"
    ,"device_code": "KSR13.00–1–11"
    ,"external_id": "476ccea5-c6ca-407d-8620-d7a000da4013"
    ,"callback_url": "www.xxx.ru"
 }
, {
     "uuid": "53b4a9e9-5440-4e36-85db-7e0a606496d8"
    ,"error": {
            "error_id": "475d6d8d-844d-4d05-aa8b-e3dbdf4defd6",
            "code": 34,
            "text": "Состояние чека не найдено. Попробуйте позднее",
            "type": "system"
      }   
    ,"status": "wait"
    ,"payload": {
                  "total": 594.78
                 ,"fns_site": "www.nalog.ru"
                 ,"fn_number": "1110000100238211"
                 ,"shift_number": 24
                 ,"receipt_datetime": "13.05.2023 21:16:00"
                 ,"fiscal_receipt_number": 23
                 ,"fiscal_document_number": 135
                 ,"ecr_registration_number": "0000111118041370"
                 ,"fiscal_document_attribute": 3449555352
                 ,"ofd_inn": "7709364346"
                 ,"ofd_receipt_url": "https://consumer.1-ofd.ru" 
    } 
    ,"timestamp": "13.05.2023 12:05::00"
    ,"group_code": "group1"
    ,"daemon_code": "prod–agent–1"
    ,"device_code": "KSR13.00–1–11"
    ,"external_id": "09342e56-7a04-4e0b-9fd9-5309e8e357cb"
    ,"callback_url": "www.xxx.ru"
 } 
]'
);
-- ------------------------------------------------------------------------------------------------
BEGIN;
SELECT * FROM fsc_receipt_pcg.fsc_receipt_status_upd (

              p_old_rcp_status  := 0 
            , p_new_rcp_status  := 1  
            , p_id_fsc_provider := 1
              --
            , p_ids_receipt := ARRAY [8557733567, 8557733569, 8557733570]::bigint []
);	
-- ROLLBACK;
COMMIT;
--
--
BEGIN;
ROLLBACK;
COMMIT;
SELECT * FROM fsc_receipt_pcg.fsc_receipt_upd (
	(SELECT k.goback_data  FROM fiscalization.fsc_goback k)
);	
	
-- ------------------------------------------------------------------------------------------------
-- {
-- "error": {
--             "error_id": "475d6d8d-844d-4d05-aa8b-e3dbdf4defd6",
--             "code": 34,
--             "text": "Состояние чека не найдено. Попробуйте позднее",
--             "type": "system"
--  },
-- "status": "wait",
-- "timestamp": "12.04.2022 18:58:38",
-- "callback_url": ""
-- }


SELECT k.* FROM fiscalization.fsc_goback k;
--------------------------------------------
-- [
-- {
--   "uuid": "561e3d6d-b174-4f3c-99a5-8a9af37f900d"
--  ,"error": null
--  ,"status": "done"
--  ,"payload": {
--                "total": 7000.00
--               ,"fns_site": "www.nalog.ru"
--               ,"fn_number": "1110000100238211"
--               ,"shift_number": 23
--               ,"receipt_datetime": "13.05.2023 20:16:00"
--               ,"fiscal_receipt_number": 6
--               ,"fiscal_document_number": 133
--               ,"ecr_registration_number": "0000111118041361"
--               ,"fiscal_document_attribute": 3449555941
--               ,"ofd_inn": "7709364346"
--               ,"ofd_receipt_url": "https://consumer.1-ofd.ru"
-- } 
--  ,"timestamp": "12.05.2023 00:00:00"
--  ,"group_code": "group1"
--  ,"daemon_code": "prod–agent–1"
--  ,"device_code": "KSR13.00–1–11"
--  ,"external_id": "7b7d9867-c88f-46bb-ade3-e93d861103f3" 
--  ,"callback_url": "www.xxx.ru"
-- }
-- , {
--      "uuid": "53b4a9e9-5440-4e36-85db-7e0a606496d8"
--     ,"error": null
--     ,"status": "done"
--     ,"payload": {
--                   "total": 594.78
--                  ,"fns_site": "www.nalog.ru"
--                  ,"fn_number": "1110000100238211"
--                  ,"shift_number": 24
--                  ,"receipt_datetime": "13.05.2023 21:16:00"
--                  ,"fiscal_receipt_number": 23
--                  ,"fiscal_document_number": 135
--                  ,"ecr_registration_number": "0000111118041370"
--                  ,"fiscal_document_attribute": 3449555352
--                  ,"ofd_inn": "7709364346"
--                  ,"ofd_receipt_url": "https://consumer.1-ofd.ru" 
--     } 
--     ,"timestamp": "13.05.2023 12:05::00"
--     ,"group_code": "group1"
--     ,"daemon_code": "prod–agent–1"
--     ,"device_code": "KSR13.00–1–11"
--     ,"external_id": "320aafd4-e484-43d8-8135-959f6d98b54f"
--     ,"callback_url": "www.xxx.ru"
--  }
-- ]
--
-- SELECT ('{"error": null}'::json ->> 'error') is null;