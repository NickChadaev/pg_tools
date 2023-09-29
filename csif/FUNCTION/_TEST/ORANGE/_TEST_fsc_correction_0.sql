--
--   2023-08-23
--
SELECT fsc_orange_pcg.fsc_correction_crt_1 (

       p_correction_type       := 0::integer -- Тип коррекции:   0. Самостоятельно, 1. По предписанию
     , p_type                  := 3::integer -- Признак расчета  1. Приход 3. Расход
     , p_cause_document_date   := '2023-08-23'::date    -- Дата документа основания для коррекции
     , p_cause_document_number := 'XXXX'::text    -- Номер предписания налогового органа 
       --
     , p_total_sum := 100.00::numeric(10,2) -- Сумма расчета, указанного в чеке (БСО),
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
     , p_taxation_system := 1::integer -- Применяемая система налогообложения
     --
     , p_automat_number     := NULL -- Номер автомата, 1036
     , p_settlement_address := NULL -- Адрес расчетов, 1009
     , p_settlement_place   := NULL -- Место расчетов, 1187
 );
---
-- { "correctionType":0
--  ,"type":3
--  ,"causeDocumentDate":"2023-08-23"
--  ,"causeDocumentNumber":"XXXX"
--  ,"totalSum":100.00
--  ,"cashSum":90.00
--  ,"eCashSum":10.00
--  ,"prepaymentSum":0.00
--  ,"postpaymentSum":0.00
--  ,"otherPaymentTypeSum":0.00
--  ,"tax1Sum":0.00
--  ,"tax2Sum":0.00
--  ,"tax3Sum":0.00
--  ,"tax4Sum":0.00
--  ,"tax5Sum":0.00
--  ,"tax6Sum":0.00
--  ,"taxationSystem":1
--  }
 
--{"correctionType":0,"type":3,"causeDocumentDate":"2023-08-23T00:00:00","causeDocumentNumber":"XXXX","totalSum":100.00,"cashSum":90.00,"eCashSum":10.00,"prepaymentSum":0.00,"postpaymentSum":0.00,"otherPaymentTypeSum":0.00,"tax1Sum":0.00,"tax2Sum":0.00,"tax3Sum":0.00,"tax4Sum":0.00,"tax5Sum":0.00,"tax6Sum":0.00,"taxationSystem":1}


SELECT fsc_orange_pcg.fsc_correction_crt_1 (

       p_correction_type       := 0::integer -- Тип коррекции:   0. Самостоятельно, 1. По предписанию
     , p_type                  := 3::integer -- Признак расчета  1. Приход 3. Расход
     , p_cause_document_date   := '2023-08-23'::date    -- Дата документа основания для коррекции
     , p_cause_document_number := 'XXXX'::text    -- Номер предписания налогового органа 
       --
     , p_total_sum := NULL::numeric(10,2) -- Сумма расчета, указанного в чеке (БСО),
     , p_cash_sum  := NULL::numeric(10,2) -- Сумма по чеку наличными
     , p_ecash_sum := NULL::numeric(10,2) -- Сумма по чеку безналичными
       --
     , p_prepayment_sum         := 0.00::numeric(10,2) -- Сумма по чеку предоплатой
     , p_postpayment_sum        := 0.00::numeric(10,2) -- Сумма по чеку постоплатой (в кредит)
     , p_other_payment_type_sum := 0.00::numeric(10,2) -- Сумма по чеку встречным представлением
       --     
     , p_vat1_sum := NULL::numeric(10,2) -- Сумма НДС чека по ставке 20%, 1102
     , p_vat2_sum := NULL::numeric(10,2) -- Сумма НДС чека по ставке 10%, 1103     
     , p_vat3_sum := NULL::numeric(10,2) -- Сумма расчета по чеку с НДС по ставке 0%, 1104     
     , p_vat4_sum := NULL::numeric(10,2) -- Сумма расчета по чеку без НДС, 1105
     , p_vat5_sum := NULL::numeric(10,2) -- Сумма НДС чека по расч. ставке 20/120, 1106     
     , p_vat6_sum := NULL::numeric(10,2) -- Сумма НДС чека по расч. ставке 10/110, 1107  
       --
     , p_taxation_system := 1::integer -- Применяемая система налогообложения
     --
     , p_automat_number     := NULL -- Номер автомата, 1036
     , p_settlement_address := NULL -- Адрес расчетов, 1009
     , p_settlement_place   := NULL -- Место расчетов, 1187
 );
 
-- ERROR:  "correction": Эти данные являются обязательными: "correctionType", "type", "causeDocumentDate", "causeDocumentNumber"
-- , "totalSum", "cashSum", "eCashSum", "prepaymentSum", "postpaymentSum", "otherPaymentTypeSum", "tax1Sum", "tax2Sum", "tax3Sum"
-- , "tax4Sum", "tax5Sum", "tax6Sum", "taxationSystem" 
-- КОНТЕКСТ:  PL/pgSQL function 
ROLLBACK;
SELECT fsc_orange_pcg.fsc_correction_crt_1 (

       p_correction_type       := 0::integer -- Тип коррекции:   0. Самостоятельно, 1. По предписанию
     , p_type                  := 3::integer -- Признак расчета  1. Приход 3. Расход
     , p_cause_document_date   := '2023-08-23'::date    -- Дата документа основания для коррекции
     , p_cause_document_number := 'XXXX'::text    -- Номер предписания налогового органа 
       --
     , p_total_sum := 100.00::numeric(10,2) -- Сумма расчета, указанного в чеке (БСО),
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
     , p_taxation_system := 99::integer -- Применяемая система налогообложения
     --
     , p_automat_number     := NULL -- Номер автомата, 1036
     , p_settlement_address := NULL -- Адрес расчетов, 1009
     , p_settlement_place   := NULL -- Место расчетов, 1187
 );
-- ERROR:  "correction": Неправильный код системы налогообложения: "taxationSystem" = 99


select ('2023-08-20'::date)::timestamp(0) without time zone;

