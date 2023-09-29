DROP FUNCTION IF EXISTS fsc_orange_pcg.fsc_correction_crt_1(
      integer,integer,date,text 
     ,numeric(10,2),numeric(10,2),numeric(10,2)
     ,numeric(10,2),numeric(10,2),numeric(10,2)   
     ,numeric(10,2),numeric(10,2),numeric(10,2)
     ,numeric(10,2),numeric(10,2),numeric(10,2)     
     ,integer, text, text, text   
 );
CREATE OR REPLACE FUNCTION fsc_orange_pcg.fsc_correction_crt_1 (

       p_correction_type       integer -- Тип коррекции:   0. Самостоятельно, 1. По предписанию
     , p_type                  integer -- Признак расчета  1. Приход 3. Расход
     , p_cause_document_date   date    -- Дата документа основания для коррекции
     , p_cause_document_number text    -- Номер предписания налогового органа 
       --
     , p_total_sum numeric(10,2) -- Сумма расчета, указанного в чеке (БСО),
     , p_cash_sum  numeric(10,2) -- Сумма по чеку наличными
     , p_ecash_sum numeric(10,2) -- Сумма по чеку безналичными
       --
     , p_prepayment_sum         numeric(10,2) -- Сумма по чеку предоплатой
     , p_postpayment_sum        numeric(10,2) -- Сумма по чеку постоплатой (в кредит)
     , p_other_payment_type_sum numeric(10,2) -- Сумма по чеку встречным представлением
       --     
     , p_vat1_sum numeric(10,2) -- Сумма НДС чека по ставке 20%, 1102
     , p_vat2_sum numeric(10,2) -- Сумма НДС чека по ставке 10%, 1103     
     , p_vat3_sum numeric(10,2) -- Сумма расчета по чеку с НДС по ставке 0%, 1104     
     , p_vat4_sum numeric(10,2) -- Сумма расчета по чеку без НДС, 1105
     , p_vat5_sum numeric(10,2) -- Сумма НДС чека по расч. ставке 20/120, 1106     
     , p_vat6_sum numeric(10,2) -- Сумма НДС чека по расч. ставке 10/110, 1107  
       --
     , p_taxation_system  integer -- Применяемая система налогообложения
     --
     , p_automat_number     text DEFAULT NULL -- Номер автомата, 1036
     , p_settlement_address text DEFAULT NULL -- Адрес расчетов, 1009
     , p_settlement_place   text DEFAULT NULL -- Место расчетов, 1187
     
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --      2023-08-23  Создание объекта "correction", чек типа коррекция
   -- ============================================================================ --
   
   DECLARE
  
     JKEY  CONSTANT text   := 'correction';
     JKEYS CONSTANT text[] := array [ 
             'correctionType', 'type',                'causeDocumentDate', 'causeDocumentNumber'
     --           1               2                       3                     4      
           , 'totalSum',       'cashSum',             'eCashSum',          'prepaymentSum'
     --           5               6                       7                     8      
           , 'postpaymentSum', 'otherPaymentTypeSum', 'tax1Sum',           'tax2Sum'
     --           9               10                      11                   12      
           , 'tax3Sum',        'tax4Sum',             'tax5Sum',           'tax6Sum'
     --          13               14                      15                   16      
           , 'taxationSystem', 'automatNumber',       'settlementAddress', 'settlementPlace'
     --          17               18                      19                   20    
             ]::text[];  
                                       
     JQ  CONSTANT integer[] := array[ 
                NULL,             NULL,                  NULL,                32
               ,NULL,             NULL,                  NULL,                NULL
               ,NULL,             NULL,                  NULL,                NULL
               ,NULL,             NULL,                  NULL,                NULL                                          
               ,NULL,              20,                    243,                243                                          
     ]::integer[];
     
     CORRECTION_TYPE  CONSTANT int4range := fsc_orange_pcg.c_correction_type();     
     OPER_TYPE        CONSTANT int4range := fsc_orange_pcg.c_oper_type();
     TAXATION_SYSTEM  CONSTANT int4range := fsc_orange_pcg.c_taxation_system();
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess text := '"%s": Эти данные являются обязательными: '
	               '"%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", '
	               '"%s", "%s", "%s", "%s", "%s", "%s", "%s" ';
				   
     __corr_mess text := '"%s": Неправильный код типа коррекции: "%s" = %s'; 
     __oper_mess text := '"%s": Неправильный код типа операции: "%s" = %s';   
     __tax_mess  text := '"%s": Неправильный код системы налогообложения: "%s" = %s';      

     __result json;
      
   BEGIN
     IF 
      (p_correction_type     IS NULL) OR (p_type                   IS NULL) OR 
      (p_cause_document_date IS NULL) OR (p_cause_document_number  IS NULL) OR 
      (p_total_sum           IS NULL) OR (p_cash_sum               IS NULL) OR 
      (p_ecash_sum           IS NULL) OR (p_prepayment_sum         IS NULL) OR 
      (p_postpayment_sum     IS NULL) OR (p_other_payment_type_sum IS NULL) OR 
      (p_vat1_sum            IS NULL) OR (p_vat2_sum               IS NULL) OR 
      (p_vat3_sum            IS NULL) OR (p_vat4_sum               IS NULL) OR 
      (p_vat5_sum            IS NULL) OR (p_vat6_sum               IS NULL) OR 
      (p_taxation_system     IS NULL) 
     
     THEN
          RAISE '%', format (__null_mess, JKEY, JKEYS[ 1], JKEYS[ 2], JKEYS[ 3], JKEYS[ 4] 
                                              , JKEYS[ 5], JKEYS[ 6], JKEYS[ 7], JKEYS[ 8] 
                                              , JKEYS[ 9], JKEYS[10], JKEYS[11], JKEYS[12] 
                                              , JKEYS[13], JKEYS[14], JKEYS[15], JKEYS[16] 
                                              , JKEYS[17]
          );      
     ELSIF NOT (CORRECTION_TYPE @> p_correction_type) 
                 THEN
                     RAISE '%', format (__corr_mess, JKEY, JKEYS[1], p_correction_type);  
    
     ELSIF NOT (OPER_TYPE @> p_type) 
                 THEN
                     RAISE '%', format (__oper_mess, JKEY, JKEYS[2], p_type);  
                     
     ELSIF NOT (TAXATION_SYSTEM @> p_taxation_system) 
                 THEN
                     RAISE '%', format (__tax_mess, JKEY, JKEYS[17], p_taxation_system);                      
     --    
     ELSIF NOT (char_length (p_cause_document_number) <= JQ[4])
           THEN
               RAISE '%', format (__lts_mess, JKEY, JKEYS[4], JQ[4]);                 
     --         
     ELSIF NOT (char_length (p_automat_number) <= JQ[18])
           THEN
               RAISE '%', format (__lts_mess, JKEY, JKEYS[18], JQ[18]);                 
     --         
     ELSIF NOT (char_length (p_settlement_address) <= JQ[19])
           THEN
               RAISE '%', format (__lts_mess, JKEY, JKEYS[19], JQ[19]);                 
     --          
     ELSIF NOT (char_length (p_settlement_place) <= JQ[20])
           THEN
               RAISE '%', format (__lts_mess, JKEY, JKEYS[20], JQ[20]);                 
     END IF;       
     
     __result := json_strip_nulls (json_build_object (

         JKEYS [1], p_correction_type,        JKEYS [2], p_type,            JKEYS [3], (p_cause_document_date)::timestamp(0) without time zone 
        ,JKEYS [4], p_cause_document_number,  JKEYS [5], p_total_sum,       JKEYS [6], p_cash_sum 
        --                                                                  
        ,JKEYS [7], p_ecash_sum,              JKEYS [8], p_prepayment_sum,  JKEYS [9], p_postpayment_sum 
        ,JKEYS[10], p_other_payment_type_sum, JKEYS[11], p_vat1_sum ,       JKEYS[12], p_vat2_sum 
        ,JKEYS[13], p_vat3_sum,               JKEYS[14], p_vat4_sum,        JKEYS[15], p_vat5_sum 
        --
        ,JKEYS[16], p_vat6_sum ,              JKEYS[17], p_taxation_system, JKEYS[18], p_automat_number 
        ,JKEYS[19], p_settlement_address,     JKEYS[20], p_settlement_place
     ));
     
     RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_orange_pcg.fsc_correction_crt_1 (
      integer,integer,date,text 
     ,numeric(10,2),numeric(10,2),numeric(10,2)
     ,numeric(10,2),numeric(10,2),numeric(10,2)   
     ,numeric(10,2),numeric(10,2),numeric(10,2)
     ,numeric(10,2),numeric(10,2),numeric(10,2)     
     ,integer, text, text, text   
 )     
    IS 'Создание объекта "content", чек типа коррекция.';
--
--  USE CASE:
--
