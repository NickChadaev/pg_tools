-- ===========================================================================
--   2023-08-29  Запрос на коррекцию чека. Два ранее фискализированныз чека.
-- ===========================================================================

-- Чек №1
-- rcp_status	dt_update	inn	rcp_nmb	rcp_fp	dt_fp	id_org_app	rcp_status_descr
-- 2	NULL	5609032431	d18df966-75ba-4ba7-875a-d1ac9c26c2a5	9831876769	2024-09-18 07:09:41+03	148	Успешная фискализация
-- -----------------------------------------------------------------------------------------------------
-- {"id": "d18df966-75ba-4ba7-875a-d1ac9c26c2a5", "inn": "5609032431", "key": "3010071", "group": "3010071", "content": {"type": 1, "positions": [{"tax": 3, "text": "Аванс (ЛС: 14161806)", "price": 331.45, "quantity": 1.000000, "paymentMethodType": 3, "paymentSubjectType": 10}], "checkClose": {"payments": [{"type": 2, "amount": 331.45}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "ofd_org56@mail.org056.ru"}, "ignoreItemCodeCheck": false}
-- -----------------------------------------------------------------------------------------------------

-- Чек №2
----------------------------------------------------------------------------------------------------------
-- rcp_status	dt_update	inn	rcp_nmb	rcp_fp	dt_fp	id_org_app	rcp_status_descr
-- 2	NULL	3650004897	18d7ba91-7f0f-4ae9-89ce-f5ee39761d0a	8378513807	2024-09-17 10:45:53+03	85	Успешная фискализация
-- {"id": "18d7ba91-7f0f-4ae9-89ce-f5ee39761d0a", "inn": "3650004897", "key": "3010071", "group": "3010071", "content": {"type": 1, "positions": [{"tax": 1, "text": "Газоснабжение природным газом (ЛС: 0500006317)", "price": 274.32, "quantity": 1.000000, "paymentMethodType": 4, "paymentSubjectType": 4}], "checkClose": {"payments": [{"type": 2, "amount": 274.32}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "checkrgk@vrgaz.ru"}, "ignoreItemCodeCheck": false}
---------------------------------------------------------------------------------------------------------- 
DO
 $$
   DECLARE
     __org_cash    record;
     __correction  json;
     __order       json;   
   
   BEGIN
    __correction := fsc_orange_pcg.fsc_correction_crt_1 (
    
          p_correction_type       := 0::integer -- Тип коррекции:   0. Самостоятельно, 1. По предписанию
        , p_type                  := 3::integer -- Признак расчета  1. Приход 3. Расход
        , p_cause_document_date   := '2023-08-23'::date    -- Дата документа основания для коррекции
        , p_cause_document_number := 'XXXX'::text    -- Номер предписания налогового органа 
          --
        , p_total_sum := 331.45::numeric(10,2) -- Сумма расчета, указанного в чеке (БСО),
        , p_cash_sum  :=  90.00::numeric(10,2) -- Сумма по чеку наличными
        , p_ecash_sum :=  10.00::numeric(10,2) -- Сумма по чеку безналичными
          --
        , p_prepayment_sum         := 0.00::numeric(10,2) -- Сумма по чеку предоплатой
        , p_postpayment_sum        := 0.00::numeric(10,2) -- Сумма по чеку постоплатой (в кредит)
        , p_other_payment_type_sum := 0.00::numeric(10,2) -- Сумма по чеку встречным представлением
          --     
        , p_vat1_sum := 0.00::numeric(10,2) -- Сумма НДС чека по ставке 20%, 1102
        , p_vat2_sum := 0.00::numeric(10,2) -- Сумма НДС чека по ставке 10%, 1103     
        , p_vat3_sum := 0.00::numeric(10,2) -- Сумма расчета по чеку с НДС по ставке 0%, 1104     
        , p_vat4_sum := 0.00::numeric(10,2) -- Сумма расчета по чеку без НДС, 1105
        , p_vat5_sum := 0.00::numeric(10,2) -- Сумма НДС чека по расч. ставке 20/120, 1106     
        , p_vat6_sum := 0.00::numeric(10,2) -- Сумма НДС чека по расч. ставке 10/110, 1107  
          --
        , p_taxation_system := 0::integer -- Применяемая система налогообложения
        --
        , p_automat_number     := NULL -- Номер автомата, 1036
        , p_settlement_address := NULL -- Адрес расчетов, 1009
        , p_settlement_place   := NULL -- Место расчетов, 1187
    );
    --
    RAISE NOTICE '%', __correction;
    --
    SELECT id_org_cash, id_org, grp_cash, org_cash_params 
    FROM fsc_receipt_pcg.f_org_cash_get (  p_org_inn := '5609032431'
                                          ,p_id_fsc_provider := 2
    ) INTO __org_cash;      
    --
    RAISE NOTICE '%', __org_cash;
    --
    __order := fsc_orange_pcg.fsc_order_corr_crt (
       p_external_id := 'd18df966-75ba-4ba7-875a-d1ac9c26c2a5'::text -- Внешний идентификатолр документа 
      ,p_inn         := '5609032431'::text         -- ИНН организации, для которой пробивается чек
      ,p_group       :=  __org_cash.grp_cash::text -- Группа устройств, с помощью которых будет пробит чек
      ,p_content     :=  __correction              -- Содержимое документа
      ,p_key         :=  __org_cash.org_cash_params ->> 'provaider_key'::text -- Название ключа, который должен быть использован для проверки подписи
    );
    
    RAISE NOTICE '%', __order;
    
    INSERT INTO fiscalization.fsc_receipt (
                 dt_create
               , rcp_status
               , inn
               , rcp_nmb
               , id_org_app
               , rcp_order
               , id_fsc_provider
               , rcp_type
               )
             VALUES ( '2024-09-20 07:09:41'
                     , 0
                     , '5609032431'
                     , 'd18df966-75ba-4ba7-875a-d1ac9c26c2a5'
                     , 148
                     , __order
                     , 2
                     , 1
    );
	
   END;
 $$;
    SELECT * FROM fiscalization.fsc_receipt 
                   WHERE (rcp_status = 0) AND (rcp_nmb = 'd18df966-75ba-4ba7-875a-d1ac9c26c2a5');
-- NOTICE:  {"correctionType":0
--          ,"type":3
--          ,"causeDocumentDate":"2023-08-23T00:00:00"
--          ,"causeDocumentNumber":"XXXX"
--          ,"totalSum":331.45
--          ,"cashSum":90.00
--          ,"eCashSum":10.00
--          ,"prepaymentSum":0.00
--          ,"postpaymentSum":0.00
--          ,"otherPaymentTypeSum":0.00
--          ,"tax1Sum":0.00
--          ,"tax2Sum":0.00
--          ,"tax3Sum":0.00
--          ,"tax4Sum":0.00
--          ,"tax5Sum":0.00
--          ,"tax6Sum":0.00
--          ,"taxationSystem":0
--         }
--
-- NOTICE:  (27,33,3010071,"{""tax"": ""3"", ""prType"": ""1"", ""agentType"": ""0"", ""paymentType"": ""2"", ""supplierINN"": null, ""provaider_key"": ""3010071"", ""taxationSystem"": ""0"", ""paymentMethodType"": ""3"", ""paymentOperatorINN"": null, ""paymentSubjectType"": ""4"", ""paymentOperatorName"": null, ""supplierPhoneNumbers"": null, ""paymentAgentOperation"": null, ""paymentOperatorAddress"": null, ""paymentAgentPhoneNumbers"": null, ""paymentOperatorPhoneNumbers"": null, ""paymentTransferOperatorPhoneNumbers"": null}")
-- --
-- NOTICE:  {"id": "d18df966-75ba-4ba7-875a-d1ac9c26c2a5", "inn": "5609032431", "key": "3010071", "group": "3010071", "content": {"type": 3, "cashSum": 90.00, "tax1Sum": 0.00, "tax2Sum": 0.00, "tax3Sum": 0.00, "tax4Sum": 0.00, "tax5Sum": 0.00, "tax6Sum": 0.00, "eCashSum": 10.00, "totalSum": 331.45, "prepaymentSum": 0.00, "correctionType": 0, "postpaymentSum": 0.00, "taxationSystem": 0, "causeDocumentDate": "2023-08-23T00:00:00", "causeDocumentNumber": "XXXX", "otherPaymentTypeSum": 0.00}}
-- DO    
