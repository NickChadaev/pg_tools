-- DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_order_crt (timestamp, text, json, boolean, text);
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_order_crt (timestamp, text, operation_t, json, boolean, text);

DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_order_crt (
      timestamp, text, operation_t, json, json, json, json, json, numeric(10,2)
    , json, text, text, text, json, json, json, boolean, text
);      
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_order_crt (
     
       p_timestamp        timestamp   -- Дата и время документа
     , p_external_id      text        -- Внешний идентификатолр документа 
     , p_operation        operation_t -- Тип выполняемой операции
     , p_correction_info  json        -- Информация о типе коррекции ОПЦИОНАЛЬНО МОЖЕТ БЫТЬ "NULL"
     
     -- ----------------------------------------------------------------
     
     , p_client                 json -- Покупатель / клиент 
     , p_company                json -- Компания
     , p_items                  json -- Товары, услуги
     , p_payments               json -- Оплаты
     , p_total                  numeric (10,2) -- Итоговая сумма чека в рублях
     
     , p_vats                   json  DEFAULT NULL -- Атрибуты налогов на чек
     , p_cashier                text  DEFAULT NULL -- ФИО кассира
     , p_cashier_inn            text  DEFAULT NULL -- ИНН кассира
     , p_additional_check_props text  DEFAULT NULL -- Дополнительный реквизит чека
     , p_additional_user_props  json  DEFAULT NULL -- Дополнительный реквизит пользователя
     , p_operating_check_props  json  DEFAULT NULL -- Операционныц реквизит чека
     , p_sectoral_check_props   json  DEFAULT NULL -- Отраслевой реквизит кассового чека
     
     -- ----------------------------------------------------------------
     
     , p_ism_optional boolean DEFAULT NULL -- Регистрация в случае недоступности проверки кода маркировки
     , p_callback_url text    DEFAULT NULL -- Адрес ответа, (используем после обработки чека)
 )
 
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ========================================================================================== --
   --  2023-05-29  Создание объекта "order", данные для POST-запроса на сервер фискализации.     --
   --  2023-06-01  Типизация запросов:  "Просто запрос"/"Корреция".  
   --      + Новый вариант функции, объединяющий в себе как "fsc_receipt_crt_0" 
   --        так и "fsc_correction_crt_0".  Сразу новый запрос на выполнение фискализации.                   
   -- ========================================================================================== --
   
   DECLARE
     JKEY   CONSTANT text := 'order';
     JKEY_0 CONSTANT text := 'service';
     
     RECEIPT    CONSTANT text := 'receipt';
     CORRECTION CONSTANT text := 'correction';
     
     JKEYS       text[] := array [ 'timestamp', 'external_id',  'XXXXX', 'ism_optional', 'callback_url', 'operation' ]::text[];  
     --                                 1            2             3           4               5               6 
     -- Перестал быть константой, JKEYS[3] принимает значения "receipt", "correction"
     
     JQ    CONSTANT integer[] := array [NULL,      128,          NULL,        NULL,           256,           NULL]::integer[];
    
     __lts_mess       text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess      text := '"%s": Эти данные являются обязательными: "%s", "%s", "%s"';
     __null_mess_corr text := '"%s": Данные о коррекции чека являются обязательными';

     __data    json;
     __result  json;
     
   BEGIN
   
     IF (p_timestamp IS NULL) OR (p_external_id IS NULL) OR (p_operation IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY, JKEYS[1], JKEYS[2],  JKEYS[6]);        
            
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
               __data := fsc_receipt_pcg.fsc_receipt_crt_0 (
              
                      p_client                 := p_client                 -- Покупатель / клиент 
                    , p_company                := p_company                -- Компания
                    , p_items                  := p_items                  -- Товары, услуги
                    , p_payments               := p_payments               -- Оплаты
                    , p_total                  := p_total                  -- Итоговая сумма чека в рублях
                    , p_vats                   := p_vats                   -- Атрибуты налогов на чек
                    , p_cashier                := p_cashier                -- ФИО кассира
                    , p_cashier_inn            := p_cashier_inn            -- ИНН кассира
                    , p_additional_check_props := p_additional_check_props -- Дополнительный реквизит чека
                    , p_additional_user_props  := p_additional_user_props  -- Дополнительный реквизит пользователя
                    , p_operating_check_props  := p_operating_check_props  -- Операционныц реквизит чека
                    , p_sectoral_check_props   := p_sectoral_check_props   -- Отраслевой реквизит кассового чека
               );
 
        ELSE
               IF (p_correction_info IS NULL)  
                 THEN
                       RAISE '%', format (__null_mess_corr, JKEY);
               END IF;
               
               JKEYS[3] := CORRECTION;
               
               __data := fsc_receipt_pcg.fsc_correction_crt_0 (
               
                             p_client                 :=  p_client                 -- Покупатель / клиент 
                           , p_company                :=  p_company                -- Компания
                           , p_correction_info        :=  p_correction_info        -- Информация о типе коррекции 
                           , p_items                  :=  p_items                  -- Товары, услуги
                           , p_payments               :=  p_payments               -- Оплаты
                           , p_total                  :=  p_total                  -- Итоговая сумма чека в рублях
                           , p_vats                   :=  p_vats                   -- Атрибуты налогов на чек
                           , p_cashier                :=  p_cashier                -- ФИО кассира
                           , p_cashier_inn            :=  p_cashier_inn            -- ИНН кассира
                           , p_additional_check_props :=  p_additional_check_props -- Дополнительный реквизит чека
                           , p_additional_user_props  :=  p_additional_user_props  -- Дополнительный реквизит пользователя
                           , p_operating_check_props  :=  p_operating_check_props  -- Операционныц реквизит чека
                           , p_sectoral_check_props   :=  p_sectoral_check_props   -- Отраслевой реквизит кассового чека
               ); 
     END IF;
       
     __result := json_strip_nulls (json_build_object (
                 JKEYS[1], to_char (p_timestamp, 'dd.mm.yyyy HH:MM::SS')
               , JKEYS[2], p_external_id
               , JKEYS[3], __data
               , JKEYS[4], p_ism_optional
               , JKEY_0, json_build_object (JKEYS[5], p_callback_url)
     ));

     RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_order_crt (
      timestamp, text, operation_t, json, json, json, json, json, numeric(10,2)
    , json, text, text, text, json, json, json, boolean, text
)     
    IS 'Создание объекта "order" (Данные для POST-запроса)';	
--
--  USE CASE:
--

