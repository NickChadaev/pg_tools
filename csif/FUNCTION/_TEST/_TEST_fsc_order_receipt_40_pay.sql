-- ---------------------------------------------------------------------------------------
--  2023-05-31/2023-06-09   --   Работаем с исходными данными.
--  2023-06-13  -- Создание записей в таблице запросов на фискализаци.
-- ---------------------------------------------------------------------------------------
-- BEGIN;
-- COMMIT;
-- ROLLBACK;

   DO
    $$
     DECLARE
       
       __item           item_t;
       __result         json;
       __x              record;
       __i              integer;
       --
       __company_phone  text;
       __external_id    uuid;
     
     
     BEGIN
       FOR  __x IN  SELECT    
   	                      x.id_source_reestr
                        , x.dt_create
                        , x.company_email
                        , x.company_sno
                        , x.company_inn
                        , x.company_payment_address
                        , x.client_name
                        , x.client_inn
                        , x.pmt_type
                        , x.pmt_sum
                        , substr (x.item_name,1, 128) AS item_name  
                        , x.item_price
                        , x.item_measure
                        , x.item_quantity
                        , x.item_sum
                        , x.item_payment_method
                        , x.payment_object
                        , x.item_vat
                        , x.client_account
                        , x.company_account
                        , x.company_phones
                        , x.company_name
                        , x.company_bik
                        , x.company_paying_agent
                        , x.bank_name
                        , x.bank_addr
                        , x.bank_inn
                        , x.bank_bik
                        , x.bank_phones                      
                          
   	            FROM fiscalization.fsc_source_reestr x 
   	                       WHERE (x.item_price <= 42949673.00) AND (x.type_source_reestr = 1) 
   				-- 8 ERROR:  "item": Длина "name" должна быть не больше 128 символов
   				--  ERROR:  "item": Величина "price" не должна превышать 42949673
   	 LOOP           
   	 
            __external_id := uuid_generate_v4();
   	 
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
                       p_type := 'bank_paying_agent'  -- Тип агента по предмету расчёта 
                      ,p_paying_agent := fsc_receipt_pcg.fsc_paying_agent_crt_3 (
                                                         'Платёж', __x.company_phones
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
                  , p_operation        := 'sell'  -- Тип выполняемой операции
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
                  , p_ism_optional := TRUE                -- Регистрация в случае недоступности проверки кода маркировки  
                  , p_callback_url := 'www.xxx.ru'::text  -- Адрес ответа, (используем после обработки чека)   
        
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
                , rcp_type        -- 0
                , rcp_received    -- false
                , rcp_notify_send -- false
                , id_pmt_reestr   -- d
                , resend_pr       -- 0    
           )
         VALUES (      	                      
                    __x.dt_create
                  , 0
                  , NULL
                  , __x.client_inn
                  , __external_id::text
                  , NULL
                  , NULL
                  , 189
                  , NULL
                  , __result::jsonb
                  , NULL
                  , 0                    -- ??
                  , FALSE
                  , FALSE
                  , __x.id_source_reestr
                  , 0
        );	      
       END LOOP;
    END;
   $$;
 -- =====================================================================================================
-- ERROR:  "item": Величина "price" не должна превышать 42'949'673
--
-- SELECT * FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0 );
