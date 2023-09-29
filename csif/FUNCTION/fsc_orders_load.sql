DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_orders_load (
              integer, integer, date, date, agent_info_t, text, integer, text, operation_t
);
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_orders_load (
              integer, date, date, agent_info_t, text, integer, text, operation_t
);

DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_orders_load (integer, date, date, agent_info_t, text, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_orders_load (
       p_reestr_type integer = 0 -- Тип реестра с исходными данными
      
      --диапазон, внутри которого фильтруются даты
      ,p_min_date  date = current_date 
      ,p_max_date  date = current_date 
     --
      --Дополнительные атрибуты
     ,p_agent_type          agent_info_t = 'bank_paying_agent'
     ,p_order_callback_url  text         = 'www.xxx.ru' 
      -- Оплата
     ,p_paying_agent_operation  text     = 'Платёж'
 )
 
    RETURNS integer 
    SECURITY DEFINER
    LANGUAGE plpgsql  
  AS
    $$
-- ------------------------------------------------------------------------------------
--     Загрузка из репестра исходных данных в секцию "0" -- запросы на фискализацию.
--      2023-05-31 -- 2023-06-13  -- Прототип оформленный в виде DO-блока.
--      2023-06-16 -- Первая версия. 
--      2023-07-17 -- Без ссылки на пару "Организация --Приложение".
--      2023-07-28 -- Ссылка на платёж, тип кассового чека загружается из butch
-- ------------------------------------------------------------------------------------
     DECLARE
      
       __item    item_t;
       __result  json;
       __x       record;
       __i       integer;
       __j       integer;
       --
       __company_phone  text;
       __external_id    uuid;
       
       RCP_STATUS constant integer := 0;  -- Начальное состояние чека.
       RESEND_PR  constant integer := 0;  -- В начальном состоянии количество повторных попыток = 0
     
      -- Далее набор констант, ограничивающий исходные данные,
      -- Хотя плохие исходные данные оставлены, всё равно фильтруем
      --
      MAX_ITEM_NAME_LEN constant integer := 128;
      MAX_ITEM_PRICE    constant numeric(10,2) := 42949673.00;
     
     BEGIN
       __j := 0;
       FOR  __x IN  SELECT    
   	                    x.id_source_reestr
                      , x.dt_create
                      --
                      , x.company_email
                      , x.company_sno
                      , x.company_inn
                      , x.company_payment_address
                      --
                      , x.client_name
                      , x.client_inn
                      , x.pmt_type
                      , x.pmt_sum
                      , substr (x.item_name, 1, MAX_ITEM_NAME_LEN) AS item_name  -- ???
                      , x.item_price
                      , x.item_measure
                      , x.item_quantity
                      , x.item_sum
                      , x.item_payment_method
                      , x.payment_object
                      , x.item_vat
                      , x.client_account
                      --
                      , x.company_account
                      , x.company_phones
                      , x.company_name
                      , z.id_org
                      , (SELECT k.id_org_app FROM fiscalization.fsc_org_app k WHERE (z.id_org = k.id_org) LIMIT 1
                        ) AS id_org_app                     
                      --
                      , x.company_bik
                      , x.company_paying_agent
                      --
                      , x.bank_name
                      , x.bank_addr
                      , x.bank_inn
                      , x.bank_bik
                      , x.bank_phones 
                      , x.external_id
                      , x.id_pay
                      , x.rcp_type -- Значение принадлежит типу public.operation_t
                          
                FROM fiscalization.fsc_source_reestr x 

                     INNER JOIN fiscalization.fsc_org z 
                             ON ( fsc_receipt_pcg.f_xxx_replace_char(x.company_name) =
                                                   fsc_receipt_pcg.f_xxx_replace_char(z.nm_org_name)
                                )
                        WHERE (x.type_source_reestr = p_reestr_type) AND
                              (x.dt_create BETWEEN p_min_date AND p_max_date) AND
                              (x.item_price <= MAX_ITEM_PRICE) 
                           
    			-- 8 ERROR:  "item": Длина "name" должна быть не больше 128 символов
    			--  ERROR:  "item": Величина "price" не должна превышать 42949673
     LOOP           
     
            __external_id  := __x.external_id;
     
           -- Товары, услуги:  элемент структуры
           __item.name     := __x.item_name::text;             
           __item.price    := __x.item_price::numeric(10,2);   
           __item.quantity := __x.item_quantity::numeric(8,3);     
           __item.measure  := __x.item_measure::integer;          
           __item.sum      := __x.item_sum::numeric(10,2);   
           
           __item.payment_method := __x.item_payment_method::payment_method_t; 
           __item.payment_object := __x.payment_object ::integer;         
           
           __item.vat := fsc_receipt_pcg.fsc_vat_crt_2 (
                                    p_type := __x.item_vat -- Номер налога в ККТ
           )::json; 
           ---------------------------------------
           __item.user_data            := NULL::text;         
           __item.excise               := NULL::numeric(10,2);
           __item.country_code         := NULL::text;         
           __item.declaration_number   := NULL::text;         
           __item.mark_quantity        := NULL::json;         
           __item.mark_processing_mode := NULL::text;         
           __item.sectoral_item_props  := NULL::json;         
           __item.mark_code            := NULL::json;  
           
           IF (__x.company_paying_agent)
             THEN
                __i := 1;
                --Уборка мусора из номеров телефонов
                FOREACH __company_phone IN ARRAY __x.company_phones
                 LOOP
                   __company_phone := fsc_receipt_pcg.f_xxx_replace_char(__x.company_phones[__i]);
                   __x.company_phones[__i] := __company_phone;
                   __i := __i + 1;
                END LOOP;
             
                 __item.agent_info := fsc_receipt_pcg.fsc_agent_info_crt_2 (
                       p_type := p_agent_type  -- Тип агента по предмету расчёта 
                      ,p_paying_agent := fsc_receipt_pcg.fsc_paying_agent_crt_3 (
                                   p_paying_agent_operation, __x.company_phones
                       )
                      ,p_receive_payments_operator := 
                           fsc_receipt_pcg.fsc_receive_payments_operators_crt_3 (__x.company_phones)
                      ,p_money_transfer_operator := fsc_receipt_pcg.fsc_money_transfer_operator_crt_3 
                                              ( __x.company_phones
                                               ,__x.company_name
                                               ,__x.company_payment_address
                                               ,__x.company_inn 
                                              )
                  );
                  
                  __item.supplier_info := fsc_receipt_pcg.fsc_supplier_info_crt_2(        
                        p_phones := __x.company_phones -- Номера телефонов        
                       ,p_name   := __x.company_name          
                       ,p_inn    := __x.company_inn      
                  ) ;
             ELSE
                  __item.agent_info    := NULL;
                  __item.supplier_info := NULL;
             END IF;
           
          __result := fsc_receipt_pcg.fsc_order_crt (
          
                 p_timestamp        := __x.dt_create::timestamp -- Дата и время документа
               , p_external_id      := __external_id::text      -- Внешний идентификатолр документа 
               , p_operation        := __x.rcp_type   -- Тип выполняемой операции, тип "public.operation_t"
               , p_correction_info  := NULL    -- Информация о типе коррекции ОПЦИОНАЛЬНО МОЖЕТ БЫТЬ "NULL"
                 --     
                -- Покупатель / клиент
               , p_client := fsc_receipt_pcg.fsc_client_crt_1 (
                                                                 p_name := __x.client_name
                                                                ,p_inn  := __x.client_inn
               )::json
              
               -- Компания
               , p_company := fsc_receipt_pcg.fsc_company_crt_1 (
                                p_email           := __x.company_email -- mail отправителя чека (адрес ОФД) 
                              , p_sno             := __x.company_sno   -- Система налогообложения
                              , p_inn             := __x.company_inn   -- ИНН организации
                              , p_payment_address := __x.company_payment_address  -- место расчётов                    
                )::json 
               
               -- Товары, услуги
               , p_items := fsc_receipt_pcg.fsc_items_crt_1 (ARRAY[__item]::item_t[])::json
                
                 --  Оплаты   
               , p_payments := fsc_receipt_pcg.fsc_payments_crt_1 (
                                 p_pmt_type_sum := ARRAY[(__x.pmt_type, __x.pmt_sum)]::pmt_type_sum_t[]
                )::json
                
               , p_total := __x.pmt_sum
               --
               , p_ism_optional := TRUE                 -- Регистрация в случае недоступности проверки кода маркировки  
               , p_callback_url := p_order_callback_url -- Адрес ответа, (используем после обработки чека)   
        
          );
        
         -- RAISE NOTICE '%', __result;   
         
         INSERT INTO fiscalization.fsc_receipt(
                  dt_create       -- d
                , rcp_status      -- 0
                , dt_update
                , inn             -- d
                , rcp_nmb         -- d
                , rcp_fp
                , dt_fp
                , id_org_app      -- 189
                , rcp_status_descr
                , rcp_order       -- d
                , rcp_receipt
                , rcp_type        -- 0  --Целое, типизация взята из  Orange
                , rcp_received    -- false
                , rcp_notify_send -- false
                , id_pay   -- d
                , resend_pr       -- 0    
           )
         VALUES (      	                      
                    __x.dt_create
                  , RCP_STATUS
                  , NULL
                  , __x.client_inn
                  , __external_id::text
                  , NULL
                  , NULL
                  , __x.id_org_app
                  , NULL
                  , __result::jsonb
                  , NULL
                  , CASE  -- Тип чека   Старая классификация, взятая из ORANGE            -- ??
                        WHEN (__x.rcp_type IN ('sell', 'buy'))               THEN 0 -- Кассовый чек
                        WHEN (__x.rcp_type IN ('sell_correction', 'buy_correction'
                                             , 'sell_refund_correction', 'buy_refund_correction'))
                                                                             THEN 1 -- Коррекция
                        WHEN (__x.rcp_type IN ('sell_refund', 'buy_refund')) THEN 2 -- Возврат 
			             ELSE
			                  NULL
                    END --  rcp_type
                    
                  , FALSE
                  , FALSE
                  , __x.id_pay
                  , RESEND_PR
               );          
        
        __j := __j + 1;
       END LOOP;
       
       RETURN __j;
    END;
    
   $$;
   
COMMENT ON FUNCTION fsc_receipt_pcg.fsc_orders_load (integer, date, date, agent_info_t, text, text)
              IS ' Загрузка из реестра исходных данных в секцию "0" -- запросы на фискализацию.';	   
 -- =====================================================================================================
-- USE CASE:
-- SELECT * FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0 );
--
-- select count (1), x.dt_create, x.type_source_reestr
--  from fiscalization.fsc_source_reestr x group by x.dt_create, x.type_source_reestr ORDER BY 3, 2;
-- ---------------------------
-- count	dt_create	type_source_reestr
-- 2556	2023-05-12 00:00:00	0
-- 73	    2023-05-13 00:00:00	0
-- 15232	2023-05-17 00:00:00	1
-- ==============================
-- 17861

