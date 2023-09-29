-- SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 0) AND (id_fsc_provider = 2);
-- SELECT count(1) FROM fiscalization.fsc_receipt WHERE (rcp_status = 0) AND (id_fsc_provider = 2); -- 98999
--
-- 2023-08-29  --  Ещё один тест
--
--SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 1) AND (id_fsc_provider = 2) AND (id_receipt > 3652976667); -- 998
-----------------------------------------------------------------------------------------------
BEGIN;
 TRUNCATE fiscalization.fsc_goback;
 INSERT INTO fiscalization.fsc_goback (goback_data)
 WITH x AS (
       SELECT
             z.rcp_nmb  AS id
            ,z.inn
            ,round(random() * 10000000000)::text AS "deviceSN"
            ,round(random() * 10000000000)::text AS "deviceRN"
            ,round(random() * 10000000000)::text AS "fsNumber" 
            ---
            ,'НТТ Контур'    AS "ofdName"
            ,'www.kontur.ru' AS "ofdWebsite"
            ,'7728699517'    AS "ofdinn"
            ,'www.nalog.ru'  AS "fnsWebsite"
            --
            ,z.inn           AS "companyINN"
            ,(SELECT nm_org_name FROM fiscalization.fsc_org WHERE (inn = z.inn)) AS "companyName"
            --
            ,round(random() * 1000)::integer  AS "documentNumber"
            ,round(random() * 100::integer)   AS "shiftNumber" 
            ,round(random() * 10)::integer    AS "documentIndex"         
            ,(z.dt_create + interval '1 day') AS "processedAt"
            ,(z.rcp_order -> 'content')::json AS "content"
            ,random()::numeric(10,2)          AS "change"
            ,round(random() * 10000000000)::text  AS "fp"
         
       FROM fiscalization.fsc_receipt z 
       WHERE (rcp_status = 1) AND (id_fsc_provider = 2) AND (id_receipt > 3652976667)
      -- LIMIT 500
)
  SELECT array_to_json (array_agg(row_to_json(x)), true) FROM x;
  
SELECT * FROM fiscalization.fsc_goback;
SELECT json_array_length(x.goback_data) FROM fiscalization.fsc_goback x; -- 998



COMMIT;
-- ROLLBACK;  
-- [{"id":"0eed7301-a188-44be-b071-8688450d0296","inn":"5834019424","deviceSN":"6111979183","deviceRN":"9519446874","fsNumber":"5705030367","ofdName":"НТТ Контур","ofdWebsite":"www.kontur.ru","ofdinn":"7728699517","fnsWebsite":"www.nalog.ru","companyINN":"5834019424","companyName":"ООО \"Газпром межрегионгаз Пенза\"","documentNumber":425,"shiftNumber":54,"documentIndex":5,"processedAt":"2023-08-09T14:02:24+03:00","content":{"type": 1, "positions": [{"tax": 1, "text": "Газоснабжение природным газом (ЛС: 41501696)", "price": 5.19, "quantity": 1.000000, "paymentMethodType": 4, "paymentSubjectType": 4}], "checkClose": {"payments": [{"type": 14, "amount": 5.19}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "lk_query@prg.sura.ru"},"change":0.79,"fp":"1670960729"},
--  {"id":"08f82811-a31a-4863-b834-59b089d0b12b","inn":"5834019424","deviceSN":"8918285924","deviceRN":"7773120114","fsNumber":"4031901473","ofdName":"НТТ Контур","ofdWebsite":"www.kontur.ru","ofdinn":"7728699517","fnsWebsite":"www.nalog.ru","companyINN":"5834019424","companyName":"ООО \"Газпром межрегионгаз Пенза\"","documentNumber":325,"shiftNumber":70,"documentIndex":8,"processedAt":"2023-08-09T14:02:24+03:00","content":{"type": 1, "positions": [{"tax": 1, "text": "Газоснабжение природным газом (ЛС: 62100455)", "price": 383.34, "quantity": 1.000000, "paymentMethodType": 4, "paymentSubjectType": 4}], "checkClose": {"payments": [{"type": 14, "amount": 383.34}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "lk_query@prg.sura.ru"},"change":0.68,"fp":"2374098444"},
--  {"id":"74d6b268-5e07-4e59-bc11-62066ea13abb","inn":"0276046524","deviceSN":"5890470344","deviceRN":"2467180409","fsNumber":"78515607","ofdName":"НТТ Контур","ofdWebsite":"www.kontur.ru","ofdinn":"7728699517","fnsWebsite":"www.nalog.ru","companyINN":"0276046524","companyName":"ООО \"Газпром межрегионгаз Уфа\"","documentNumber":659,"shiftNumber":42,"documentIndex":5,"processedAt":"2023-08-29T10:53:54+03:00","content":{"type": 1, "positions": [{"tax": 1, "text": "Платеж( ЛС11079815 )Башкирское отделение № 8598 ПАО Сбербанк(Договор  №8598/25-221 РЦ Стерлитамак)", "price": 86.40, "quantity": 1.000000, "paymentMethodType": 3, "paymentSubjectType": 10}], "checkClose": {"payments": [{"type": 2, "amount": 86.40}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "kassa_11@bashgaz.ru"},"change":0.44,"fp":"2231474242"},
--  {"id":"b1d6d426-ce93-426e-a3c4-4d3d454c7e2c","inn":"5501174543","deviceSN":"7523780466","deviceRN":"3090817153","fsNumber":"4141668910","ofdName":"НТТ Контур","ofdWebsite":"www.kontur.ru","ofdinn":"7728699517","fnsWebsite":"www.nalog.ru","companyINN":"5501174543","companyName":"ООО \"Газпром межрегионгаз Омск\"","documentNumber":600,"shiftNumber":61,"documentIndex":4,"processedAt":"2023-08-27T07:23:23+03:00","content":{"type": 1, "positions": [{"tax": 1, "text": "Газоснабжение природным газом", "price": 17.67, "quantity": 1.000000, "paymentMethodType": 3, "paymentSubjectType": 4}], "checkClose": {"payments": [{"type": 2, "amount": 17.67}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "a.nasonov@omskregiongaz.ru"},"change":0.35,"fp":"4095343768"},
--  {"id":"2feaefbf-e2b0-4929-baea-2aaebb939eef","inn":"5501174543","deviceSN":"7219986850","deviceRN":"3365645925","fsNumber":"4178061443","ofdName":"НТТ Контур","ofdWebsite":"www.kontur.ru","ofdinn":"7728699517","fnsWebsite":"www.nalog.ru","companyINN":"5501174543","companyName":"ООО \"Газпром межрегионгаз Омск\"","documentNumber":634,"shiftNumber":19,"documentIndex":1,"processedAt":"2023-08-09T15:37:29+03:00","content":{"type": 1, "positions": [{"tax": 1, "text": "Газоснабжение природным газом", "price": 78.21, "quantity": 1.000000, "paymentMethodType": 4, "paymentSubjectType": 4}], "checkClose": {"payments": [{"type": 14, "amount": 78.21}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "a.nasonov@omskregiongaz.ru"},"change":0.84,"fp":"3456470866"},
--  {"id":"21cef431-0124-4a55-86ac-7ea654400366","inn":"5948022406","deviceSN":"8838776399","deviceRN":"2524360736","fsNumber":"2143792672","ofdName":"НТТ Контур","ofdWebsite":"www.kontur.ru","ofdinn":"7728699517","fnsWebsite":"www.nalog.ru","companyINN":"5948022406","companyName":"ООО \"Газпром межрегионгаз Пермь\"","documentNumber":764,"shiftNumber":29,"documentIndex":3,"processedAt":"2023-08-27T07:27:46+03:00","content":{"type": 1, "positions": [{"tax": 1, "text": "Аванс", "price": 293.76, "quantity": 1.000000, "paymentMethodType": 3, "paymentSubjectType": 10}], "checkClose": {"payments": [{"type": 2, "amount": 293.76}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "bill_permrn@prg.perm.ru"},"change":0.19,"fp":"2804719055"},
--  {"id":"0ad6e0eb-8ab8-468c-bfe6-4d43d90985d5","inn":"5948022406","deviceSN":"4174921693","deviceRN":"5662004768","fsNumber":"2525638943","ofdName":"НТТ Контур","ofdWebsite":"www.kontur.ru","ofdinn":"7728699517","fnsWebsite":"www.nalog.ru","companyINN":"5948022406","companyName":"ООО \"Газпром межрегионгаз Пермь\"","documentNumber":553,"shiftNumber":49,"documentIndex":8,"processedAt":"2023-08-27T07:27:44+03:00","content":{"type": 1, "positions": [{"tax": 1, "text": "Аванс", "price": 220.32, "quantity": 1.000000, "paymentMethodType": 3, "paymentSubjectType": 10}], "checkClose": {"payments": [{"type": 2, "amount": 220.32}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "bill_permrn@prg.perm.ru"},"change":0.15,"fp":"5782094859"},
--  {"id":"e0f7e97d-a8a2-4b92-a8ad-79ff96e18eb5","inn":"5948022406","deviceSN":"4878132595","deviceRN":"971444065","fsNumber":"620570478","ofdName":"НТТ Контур","ofdWebsite":"www.kontur.ru","ofdinn":"7728699517","fnsWebsite":"www.nalog.ru","companyINN":"5948022406","companyName":"ООО \"Газпром межрегионгаз Пермь\"","documentNumber":822,"shiftNumber":1,"documentIndex":3,"processedAt":"2023-08-27T07:27:46+03:00","content":{"type": 1, "positions": [{"tax": 1, "text": "Аванс", "price": 400.00, "quantity": 1.000000, "paymentMethodType": 3, "paymentSubjectType": 10}], "checkClose": {"payments": [{"type": 2, "amount": 400.00}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "bill_permrn@prg.perm.ru"},"change":0.53,"fp":"7072151683"},
--  {"id":"ea971606-27bb-499b-98e7-e62af1be8837","inn":"5501174543","deviceSN":"4045387476","deviceRN":"4379706778","fsNumber":"7973481032","ofdName":"НТТ Контур","ofdWebsite":"www.kontur.ru","ofdinn":"7728699517","fnsWebsite":"www.nalog.ru","companyINN":"5501174543","companyName":"ООО \"Газпром межрегионгаз Омск\"","documentNumber":669,"shiftNumber":55,"documentIndex":9,"processedAt":"2023-08-09T15:37:27+03:00","content":{"type": 1, "positions": [{"tax": 1, "text": "Газоснабжение природным газом", "price": 575.24, "quantity": 1.000000, "paymentMethodType": 4, "paymentSubjectType": 4}], "checkClose": {"payments": [{"type": 14, "amount": 575.24}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "a.nasonov@omskregiongaz.ru"},"change":0.59,"fp":"5034116061"},
--  {"id":"e666be43-3de7-4bbb-8fd5-74ab3cd9947c","inn":"5501174543","deviceSN":"3740932065","deviceRN":"8869428694","fsNumber":"5049118979","ofdName":"НТТ Контур","ofdWebsite":"www.kontur.ru","ofdinn":"7728699517","fnsWebsite":"www.nalog.ru","companyINN":"5501174543","companyName":"ООО \"Газпром межрегионгаз Омск\"","documentNumber":70,"shiftNumber":8,"documentIndex":9,"processedAt":"2023-08-09T15:37:25+03:00","content":{"type": 1, "positions": [{"tax": 1, "text": "Газоснабжение природным газом", "price": 31.48, "quantity": 1.000000, "paymentMethodType": 4, "paymentSubjectType": 4}], "checkClose": {"payments": [{"type": 14, "amount": 31.48}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "a.nasonov@omskregiongaz.ru"},"change":0.93,"fp":"6717051212"}
-- ] 
 
