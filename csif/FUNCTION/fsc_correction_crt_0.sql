DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_correction_crt_0 
             (json, json, json, json, json, numeric (10,2), json, text, text, text, json, json, json);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_correction_crt_0(
       p_client                  json -- Покупатель / клиент 
     , p_company                 json -- Компания
     , p_correction_info         json -- Информация о типе коррекции 
     , p_items                   json -- Товары, услуги
     , p_payments                json -- Оплаты
     , p_total                   numeric (10,2) -- Итоговая сумма чека в рублях
     , p_vats                    json  DEFAULT NULL -- Атрибуты налогов на чек
     , p_cashier                 text  DEFAULT NULL -- ФИО кассира
     , p_cashier_inn             text  DEFAULT NULL -- ИНН кассира
     , p_additional_check_props  text  DEFAULT NULL -- Дополнительный реквизит чека
     , p_additional_user_props   json  DEFAULT NULL -- Дополнительный реквизит пользователя
     , p_operating_check_props   json  DEFAULT NULL -- Операционныц реквизит чека
     , p_sectoral_check_props    json  DEFAULT NULL -- Отраслевой реквизит кассового чека
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-05-30  Создание объекта "correction"
   -- ============================================================================ --
   
   DECLARE
     JKEY  CONSTANT text      := 'correction';
     JKEYS CONSTANT text[]    := array [ 'client',                 'company',            'correction_info',             'items'
     --                                     1                         2                         3                         4      
                                       , 'payments',               'total',                  'vats',                   'cashier'
     --                                     5                         6                         7                         8      
                                       , 'cashier_inn', 'additional_check_props', 'additional_user_proips', 'operating_check_props'
     --                                     9                         10                       11                        12      
                                       , 'sectoral_check_props'     
     --                                     13                                       
                                       ]::text[];  
                                       
     JQ    CONSTANT integer[] := array[    NULL,                     NULL,                      NULL,                    NULL
                                          ,NULL,                     NULL,                      NULL,                     64                     
                                          ,NULL,                       16,                      NULL,                     NULL
                                          ,NULL
     ]::integer[];
     
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s", "%s", "%s", "%s", "%s", "%s"';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';

     __result json;
      
   BEGIN
   
     IF (p_client IS NULL) OR (p_company IS NULL) OR (p_correction_info IS NULL) OR
        (p_items IS NULL) OR (p_payments IS NULL) OR (p_total IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY, JKEYS[1], JKEYS[2], JKEYS[3], JKEYS[4], JKEYS[5], JKEYS[6]);      
            
       ELSIF NOT (p_cashier_inn ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[9], p_cashier_inn);   
                 
       ELSIF NOT (char_length(p_cashier) <= JQ[8])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[8], JQ[8]);                 
                 
       ELSIF NOT (char_length(p_additional_check_props) <= JQ[10])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[10], JQ[10]);                 
                 
       END IF;       
       
       __result := json_strip_nulls (json_build_object (
                 JKEYS  [1], p_client,      JKEYS  [2], p_company, JKEYS [3], p_correction_info, JKEYS[4], p_items
                ,JKEYS  [5], p_payments,    JKEYS  [6], p_total,   JKEYS [7], p_vats,            JKEYS[8], p_cashier
                ,JKEYS  [9], p_cashier_inn, JKEYS [10], p_additional_check_props, JKEYS[11], p_additional_user_props 
                ,JKEYS [12], p_operating_check_props
                ,JKEYS [13], p_sectoral_check_props  
                                    )
       );
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_correction_crt_0 
            (json, json, json, json, json, numeric (10,2), json, text, text, text, json, json, json)     
    IS 'Создание объекта "correction"';
--
--  USE CASE:
--
-- SELECT fsc_receipt_pcg.fsc_correction_crt_0 (
--        p_client         := NULL -- Покупатель / клиент 
--      , p_company        := NULL -- Компания
--      , p_correction_info := NULL -- Информация о типе коррекции 
--      , p_items          := NULL -- Товары, услуги
--      , p_payments       := '{}' -- Оплаты
--      , p_total          := 9999.99 -- Итоговая сумма чека в рублях
-- );	
-- ERROR:  "correction": Эти данные являются обязательными: "client", "company", "correction_info", "items", "payments", "total"
