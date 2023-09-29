DROP FUNCTION IF EXISTS fsc_orange_pcg.fsc_content_crt_1(
      integer,json,json,text,json,text,text,text         
     ,text,json,text,text,text,numeric(10,2)
     ,numeric(10,2),numeric(10,2),numeric(10,2)   
     ,numeric(10,2),numeric(10,2),numeric(10,2)
     ,json,json         
 );

CREATE OR REPLACE FUNCTION fsc_orange_pcg.fsc_content_crt_1(
       p_type              integer -- Признак расчета
     , p_positions         json    -- Список предметов расчета, 1059
     , p_check_close       json    -- Параметры закрытия чека
     , p_customer_contact  text    -- Телефон или электронный адрес покупателя, 1008
       --------------------------------------------------------------------------------------
     , p_additional_user_attribute json  DEFAULT NULL -- Дополнительный реквизит пользователя
     , p_additional_attribute      text  DEFAULT NULL -- Дополнительный реквизит чека(БСО), 1192
       --
     , p_automat_number      text  DEFAULT NULL -- Номер автомата, 1036
     , p_settlement_address  text  DEFAULT NULL -- Адрес расчетов, 1009
     , p_settlement_place    text  DEFAULT NULL -- Место расчетов, 1187
     , p_customer_info       json  DEFAULT NULL -- Сведения о покупателе (клиенте), 1256
     , p_cashier             text  DEFAULT NULL -- Кассир
     , p_cashier_inn         text  DEFAULT NULL -- ИНН кассира, 1203
     , p_sender_email        text  DEFAULT NULL -- Адрес электронной почты отправителя чека, 1117 
       --
     , p_total_sum numeric(10,2) DEFAULT NULL -- Сумма расчета, указанного в чеке (БСО),
     , p_vat1_sum  numeric(10,2) DEFAULT NULL -- Сумма НДС чека по ставке 20%, 1102
     , p_vat2_sum  numeric(10,2) DEFAULT NULL -- Сумма НДС чека по ставке 10%, 1103     
     , p_vat3_sum  numeric(10,2) DEFAULT NULL -- Сумма расчета по чеку с НДС по ставке 0%, 1104     
     , p_vat4_sum  numeric(10,2) DEFAULT NULL -- Сумма расчета по чеку без НДС, 1105
     , p_vat5_sum  numeric(10,2) DEFAULT NULL -- Сумма НДС чека по расч. ставке 20/120, 1106     
     , p_vat6_sum  numeric(10,2) DEFAULT NULL -- Сумма НДС чека по расч. ставке 10/110, 1107  
       --
     , p_operational_attribute  json DEFAULT NULL -- Операционный реквизит чека, 1270
     , p_industry_attribute     json DEFAULT NULL -- Отраслевой реквизит чека, 1261
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --      2023-08-18  Создание объекта "content", чек типа приход-расход.
   -- ============================================================================ --
   
   DECLARE
     VKEY  CONSTANT text    := 'ffdVersion';
     VDATA CONSTANT integer := 4;
   
     JKEY  CONSTANT text   := 'content';
     JKEYS CONSTANT text[] := array [ 
                    'type',                    'positions',           'checkClose',     'customerContact'
     --                1                            2                        3                4      
                  , 'additionalUserAttribute', 'additionalAttribute',  'automatNumber', 'settlementAddress'
     --                5                            6                        7                8      
                  , 'settlementPlace',         'customerInfo',         'cashier',       'cashierINN'
     --                9                         10                         11               12      
                  , 'senderEmail',             'totalSum',             'vat1Sum',       'vat2Sum'
     --               13                         14                         15               16      
                  , 'vat3Sum',                 'vat4Sum',              'vat5Sum',       'vat6Sum'
     --               17                         18                         19               20    
                  , 'operationalAttribute',    'industryAttribute' 
     --               21                         22                
                    ]::text[];  
                                       
     JQ  CONSTANT integer[] := array[ 
                       NULL,                     NULL,                      NULL,             64
                      ,NULL,                     NULL,                      20,              243
                      , 243,                     NULL,                      64,             NULL
                      ,  64,                     NULL,                      NULL,           NULL                                          
                      ,NULL,                     NULL,                      NULL,           NULL                                          
                      ,NULL,                     NULL                                                                                                     
     ]::integer[];
     
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
     OPER_TYPE   CONSTANT int4range := fsc_orange_pcg.c_oper_type();
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s", "%s", "%s", "%s"';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';
     __oper_mess text := '"%s": Неправильный код типа операции: "%s" = %s'; 

     __result json;
      
   BEGIN
   
     IF 
        (p_type IS NULL)        OR (p_positions IS NULL) OR 
        (p_check_close IS NULL) OR (p_customer_contact IS NULL) 
       THEN
            RAISE '%', format (__null_mess, JKEY, JKEYS[1], JKEYS[2], JKEYS[3], JKEYS[4] 
            );      
            
       ELSIF NOT (OPER_TYPE @> p_type) 
                   THEN
                       RAISE '%', format (__oper_mess, JKEY, JKEYS[1], p_type);  
                       
       ELSIF NOT (p_cashier_inn ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[8], p_cashier_inn);   
       --    
       ELSIF NOT (char_length (p_customer_contact) <= JQ[4])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[4], JQ[4]);                 
       --         
       ELSIF NOT (char_length (p_automat_number) <= JQ[7])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[7], JQ[7]);                 
       --         
       ELSIF NOT (char_length (p_settlement_address) <= JQ[8])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[8], JQ[8]);                 
       --          
       ELSIF NOT (char_length (p_settlement_place) <= JQ[9])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[9], JQ[9]);                 
       --         
       ELSIF NOT (char_length (p_cashier) <= JQ[11])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[11], JQ[11]);                 
       --         
       ELSIF NOT (char_length (p_sender_email) <= JQ[13])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[13], JQ[13]);                   
       END IF;       
       
       __result := json_strip_nulls (json_build_object (
                 VKEY, VDATA 
                 -- 
                ,JKEYS[1], p_type,            JKEYS[2], p_positions, JKEYS[3], p_check_close
                ,JKEYS[4], p_customer_contact
                --
                ,JKEYS [5], p_additional_user_attribute,  JKEYS[6], p_additional_attribute
                --
                ,JKEYS [7], p_automat_number, JKEYS [8], p_settlement_address, JKEYS [9], p_settlement_place
                ,JKEYS[10], p_customer_info,  JKEYS[11], p_cashier,            JKEYS[12], p_cashier_inn  
                ,JKEYS[13], p_sender_email
                --
                ,JKEYS[14], p_total_sum, JKEYS[15], p_vat1_sum, JKEYS[16], p_vat2_sum
                ,JKEYS[17], p_vat3_sum,  JKEYS[18], p_vat4_sum, JKEYS[19], p_vat5_sum
                ,JKEYS[20], p_vat6_sum 
                --
                ,JKEYS[21], p_operational_attribute  
                ,JKEYS[22], p_industry_attribute  
       ));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_orange_pcg.fsc_content_crt_1 (
     integer,json,json,text,json,text,text,text,text,json,text,text,text,numeric(10,2)
    ,numeric(10,2),numeric(10,2),numeric(10,2) ,numeric(10,2),numeric(10,2),numeric(10,2)
    ,json,json         
 )     
    IS 'Создание объекта "content", чек типа приход-расход.';
--
--  USE CASE:
--
