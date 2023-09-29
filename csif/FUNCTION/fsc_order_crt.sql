DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_order_crt (timestamp, text, json, boolean, text);

DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_order_crt 
                                         (timestamp, text, operation_t, json, boolean, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_order_crt(
     
       p_timestamp    timestamp   -- Дата и время документа
     , p_external_id  text        -- Внешний идентификатолр документа 
     , p_operation    operation_t -- Тип выполняемой операции
     , p_data         json        -- Данные: Чек/Возврат/Коррекция
     , p_ism_optional boolean DEFAULT NULL -- Регистрация в случае недоступности проверки кода маркировки
     , p_callback_url text    DEFAULT NULL -- Адрес ответа, (используем после обработки чека)
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ========================================================================================== --
   --  2023-05-29  Создание объекта "order", данные для POST-запроса на сервер фискализации.     --
   --  2023-06-01  Типизация запросов:  "Просто запрос"/"Корреция".                              --                   
   -- ========================================================================================== --
   
   DECLARE
     JKEY   CONSTANT text := 'order';
     JKEY_0 CONSTANT text := 'service';
     
     RECEIPT    CONSTANT text := 'receipt';
     CORRECTION CONSTANT text := 'correction';
     
     JKEYS           text[] := array [ 'timestamp', 'external_id',  'receipt', 'ism_optional', 'callback_url' ]::text[];  
     --                                     1            2             3           4                5      
     -- Перестал быть константой, JKEYS[3] принимает значения "receipt", "correction"
     
     JQ    CONSTANT integer[] := array[ NULL,         128,          NULL,       NULL,            256]::integer[];
    
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s", "%s", "%s"';

     __result   json;
     
   BEGIN
   
     IF (p_timestamp IS NULL) OR (p_external_id IS NULL) OR (p_data IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY, JKEYS[1], JKEYS[2], JKEYS[3]);      
            
       ELSIF NOT (char_length(p_external_id) <= JQ[2])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[2], JQ[2]);                 
                 
       ELSIF NOT (char_length(p_callback_url) <= JQ[5])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[5], JQ[5]);                 
     END IF;       
       
     IF ( p_operation::text = ANY (enum_range('sell'::operation_t, 'buy_refund'::operation_t)::text[])) 
        THEN 
               JKEYS[3] := RECEIPT;             
        ELSE
               JKEYS[3] := CORRECTION;
     END IF;
       
     __result := json_strip_nulls (json_build_object (
                 JKEYS[1], to_char (p_timestamp, 'dd.mm.yyyy HH:MM::SS')
               , JKEYS[2], p_external_id
               , JKEYS[3], p_data
               , JKEYS[4], p_ism_optional
               , JKEY_0, json_build_object (JKEYS[5], p_callback_url)
     ));

     RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_order_crt (timestamp, text, operation_t, json, boolean, text)     
    IS 'Создание объекта "order" (Данные для POST-запроса)';	
--
--  USE CASE:
--
-- SELECT fsc_receipt_pcg.fsc_order_crt(now()::timestamp, '91292939934jsaz'::text, 'BUY_refund', '{}'::json, TRUE, 'www.xxx.ru'::text);
--
-- SELECT fsc_receipt_pcg.fsc_order_crt(now()::timestamp, '91292939934jsaz'::text, 'buy_refund', '{}'::json, TRUE, 'www.xxx.ru'::text);
-- SELECT fsc_receipt_pcg.fsc_order_crt(now()::timestamp, '91292939934jsaz'::text, 'sell', '{}'::json, TRUE, 'www.xxx.ru'::text);
--
-- SELECT fsc_receipt_pcg.fsc_order_crt(now()::timestamp, '91292939934jsaz'::text, 'buy_refund_correction', '{}'::json, TRUE, 'www.xxx.ru'::text);
-- SELECT fsc_receipt_pcg.fsc_order_crt(now()::timestamp, '91292939934jsaz'::text, 'sell_correction', '{}'::json, TRUE, 'www.xxx.ru'::text);


-- ERROR:  invalid input value for enum operation_t: "BUY_refund"
-- {"timestamp":"01.06.2023 01:06::44","external_id":"91292939934jsaz","receipt":{},"ism_optional":true,"service":{"callback_url":"www.xxx.ru"}}
-- {"timestamp":"01.06.2023 01:06::21","external_id":"91292939934jsaz","receipt":{},"ism_optional":true,"service":{"callback_url":"www.xxx.ru"}}

-- {"timestamp":"01.06.2023 01:06::54","external_id":"91292939934jsaz","correction":{},"ism_optional":true,"service":{"callback_url":"www.xxx.ru"}}
-- {"timestamp":"01.06.2023 01:06::40","external_id":"91292939934jsaz","correction":{},"ism_optional":true,"service":{"callback_url":"www.xxx.ru"}}

