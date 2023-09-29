DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_orders_load (json);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_orders_load (
       p_source_data  json -- Исходные данные, формируем в приложении.      
 )
 
    RETURNS bigint
    SECURITY DEFINER
    LANGUAGE plpgsql  
  AS
    $$
-- -------------------------------------------------------------------------------------------
--   On_line загрузка  секцию "0" -- запросы на фискализацию.
--     2023-08-10  Прототип функции. Простите за громоздкий комментарий, 
--                 но это подробный  пример json'а с исходными данными.
--     2023-08-11  Первый  release
-- -------------------------------------------------------------------------------------------
--    { 
--        "dt_create":"2023-05-13T00:00:00",
--        "id_pay":382322,
--        "rcp_type":"sell",
--        "external_id":"a8c63070-b8f7-429d-a494-710d7fee87e0",
--        "app_guid":"212f1d68-88ee-4d14-882b-1c945bcc785b",         Пока Опционально
--        
--        "company_email":"email@ofd.ru",
--        "company_sno":"osn",
--        "company_inn":"7702070139",
--        "company_payment_address":"680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1",
--        "company_phones":["+7 (4212) 45-54-55"],
--        "company_name":"ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск",
--        "company_bik":"040813713",
--        
--        "company_paying_agent":true,
--        "agent_type":"bank_paying_agent",
--        "paying_agent_operation":"Платёж",
--        
--        "client_name":"ИНН 272011197560 Суворов Сергей Александрович",
--        "client_inn":"272011197560",
--        
--        "pmt_type":1,
--        "pmt_sum":10550.37,
--        "payment_object":1,
--        
--        "item_name":", НДС не облагается, <ЛС 81590188;ПРД04.2023>",
--        "item_price":10550.37,
--        "item_measure":0,
--        "item_quantity":1.000,
--        "item_sum":10550.37,
--        "item_payment_method":"full_payment",
--        "item_vat":"vat0",
--
-- --------- Только для чеков коррекции. -----------------------------
--
--        ,"corr_type":"instruction" 
--        ,"corr_date":"2023-06-01"
--        ,"corr_doc ":"878/SD"
-- }
-- -------------------------------------------------------------------------------------------

     DECLARE
       __i              integer;
       __result         json;
       __item           item_t;
       __x              record;
       __company_phone  text;
       __bank_phone     text;
       
       __id_receipt      bigint; 
       __id_fsc_provider integer;
       --
       RCP_STATUS constant integer := 0;  -- Начальное состояние чека.
       RESEND_PR  constant integer := 0;  -- В начальном состоянии количество повторных попыток = 0
     
       -- Далее набор констант, ограничивающий исходные данные,
       -- Хотя плохие исходные данные оставлены, всё равно фильтруем
       --
	   cFSC_PROVIDER     constant text := 'atol';  
       MAX_ITEM_NAME_LEN constant integer := 128;
       MAX_ITEM_PRICE    constant numeric(10,2) := 42949673.00;
     
     BEGIN 
       SELECT id_fsc_provider FROM fiscalization.fsc_provider INTO __id_fsc_provider 
       WHERE (lower(kd_fsc_provider) = cFSC_PROVIDER);
       
       WITH x AS 
          (
              SELECT  (p_source_data ->> 'dt_create')::timestamp(0) without time zone AS dt_create
                     ,(p_source_data ->> 'id_pay')::bigint                        AS id_pay
                     ,(p_source_data ->> 'rcp_type')::operation_t                 AS rcp_type
                     ,(p_source_data ->> 'external_id')::text                     AS external_id
                     ,(p_source_data ->> 'app_guid')::uuid                        AS app_guid                     
                       
                     ,(p_source_data ->> 'company_email')::text                   AS company_email  
                     ,(p_source_data ->> 'company_sno')::sno_t                    AS company_sno
                     ,(p_source_data ->> 'company_inn')::text                     AS company_inn
                     ,(p_source_data ->> 'company_payment_address')::text         AS company_payment_address 
                     ,(p_source_data -> 'company_phones')                         AS company_phones   
                     ,(p_source_data ->> 'company_name')::text                    AS company_name
                     ,(p_source_data ->> 'company_bik')::text                     AS company_bik
                                                                                  
                     ,(p_source_data ->> 'company_paying_agent')::boolean         AS company_paying_agent
                     ,(p_source_data ->> 'agent_type')::agent_info_t              AS agent_type
                     ,(p_source_data ->> 'paying_agent_operation')::text          AS paying_agent_operation
                                                               
                     ,(p_source_data ->> 'client_name')::text                     AS client_name
                     ,(p_source_data ->> 'client_inn')::text                      AS client_inn
                                                                                  
                     ,(p_source_data ->> 'pmt_type')::integer                     AS pmt_type
                     ,(p_source_data ->> 'pmt_sum')::numeric(10,2)                AS pmt_sum
                     ,(p_source_data ->> 'payment_object')::integer               AS payment_object
                                                      
                     ,(p_source_data ->> 'item_name')::text                       AS item_name
                     ,(p_source_data ->> 'item_price')::numeric(10,2)             AS item_price
                     ,(p_source_data ->> 'item_measure')::integer                 AS item_measure
                     ,(p_source_data ->> 'item_quantity')::numeric(8,3)           AS item_quantity
                     ,(p_source_data ->> 'item_sum')::numeric(10,2)               AS item_sum
                     ,(p_source_data ->> 'item_payment_method')::payment_method_t AS item_payment_method
                     ,(p_source_data ->> 'item_vat')::vat_t                       AS item_vat
                    --
                    -- Только для режима коррекции чека
                    --
                     ,(p_source_data ->> 'corr_type')::correction_type_t AS corr_type -- Тип коррекции. 
                     ,(p_source_data ->> 'corr_date')::date              AS corr_date -- Дата совершения корректируемого расчета
                     ,(p_source_data ->> 'corr_doc')::text               AS corr_doc  -- Номер документа основания для коррекции                       
          )
             SELECT    
                     x.dt_create
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
                   --
                   , (SELECT array_agg (value) FROM json_array_elements_text(x.company_phones)) AS company_phones
                   , x.company_name
                   , z.id_org
                   , (SELECT k.id_org_app FROM fiscalization.fsc_org_app k WHERE (z.id_org = k.id_org) LIMIT 1
                     ) AS id_org_app                     
                   --
                   , x.company_bik
                   , x.company_paying_agent
                   --
                   , x.external_id
                   , x.id_pay
                   , x.rcp_type -- Значение принадлежит типу public.operation_t
                    --
                   , x.agent_type    
                   , x.app_guid
                   , x.paying_agent_operation 
                    --
                    -- Только для режима коррекции чека
                    --
                   , x.corr_type -- Тип коррекции. 
                   , x.corr_date -- Дата совершения корректируемого расчета
                   , x.corr_doc  -- Номер документа основания для коррекции                       
                   
             FROM  x  INTO __x
             
                 INNER JOIN fiscalization.fsc_org z 
                         ON ( fsc_receipt_pcg.f_xxx_replace_char(x.company_name) =
                                               fsc_receipt_pcg.f_xxx_replace_char(z.nm_org_name)
                            )
             WHERE (x.item_price <= MAX_ITEM_PRICE); 
                   
            --  RAISE NOTICE '%', __x;                     
                   
             -- 8 ERROR:  "item": Длина "name" должна быть не больше 128 символов
             --  ERROR:  "item": Величина "price" не должна превышать 42949673

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
              --Уборка мусора из номеров телефонов
              __i := 1;
              FOREACH __company_phone IN ARRAY __x.company_phones
               LOOP
                 __company_phone := fsc_receipt_pcg.f_xxx_replace_char(__x.company_phones[__i]);
                 __x.company_phones[__i] := __company_phone;
                 __i := __i + 1;
              END LOOP;
           
               __item.agent_info := fsc_receipt_pcg.fsc_agent_info_crt_2 (
                     p_type := __x.agent_type  -- Тип агента по предмету расчёта 
                    ,p_paying_agent := fsc_receipt_pcg.fsc_paying_agent_crt_3 (
                                 __x.paying_agent_operation, __x.company_phones
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
             , p_external_id      := __x.external_id::text      -- Внешний идентификатолр документа 
             , p_operation        := __x.rcp_type   -- Тип выполняемой операции, тип "public.operation_t"
             
             , p_correction_info  := CASE  -- Информация о типе коррекции ОПЦИОНАЛЬНО МОЖЕТ БЫТЬ "NULL"
                                       WHEN (__x.rcp_type = ANY (enum_range ('sell_correction'::operation_t
                                                                   , 'buy_refund_correction'::operation_t)::operation_t[])
                                            )
                                              THEN  -- Коррекция
                                                   fsc_receipt_pcg.fsc_correction_info_crt_1 (
                                                        p_type        := __x.corr_type::correction_type_t -- Тип коррекции. 
                                                      , p_base_date   := __x.corr_date::date              -- Дата совершения корректируемого расчета
                                                      , p_base_number := __x.corr_doc::text               -- Номер документа основания для коррекции
                                                   )
                			             ELSE
			                                  NULL
                                     END
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
             , p_ism_optional := TRUE   -- Регистрация в случае недоступности проверки кода маркировки  
             , p_callback_url := fsc_receipt_pcg.f_get_notification_url ( -- Адрес ответа, (используем после обработки чека)   
                         __x.id_org_app
                        ,__x.app_guid
               )
            );
        
         -- RAISE NOTICE '%', __result;   
         
         INSERT INTO fiscalization.fsc_receipt (
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
			    , id_fsc_provider
           )
         VALUES (      	                      
                    __x.dt_create
                  , RCP_STATUS
                  , NULL
                  , __x.client_inn
                  , __x.external_id::text
                  , NULL
                  , NULL
                  , __x.id_org_app
                  , NULL
                  , __result::jsonb
                  , NULL
                  , CASE  -- Тип чека   Старая классификация, взятая из ORANGE            -- ??
                        WHEN (__x.rcp_type = ANY (enum_range( 'sell'::operation_t, 'buy'::operation_t)::operation_t[]))
                                     THEN 0 -- Кассовый чек   
                                     
                        WHEN (__x.rcp_type = ANY (enum_range( 'sell_correction'::operation_t, 'buy_refund_correction'::operation_t)::operation_t[]))
                                     THEN 1 -- Коррекция
                                                                             
                        WHEN (__x.rcp_type = ANY (enum_range( 'sell_refund'::operation_t, 'buy_refund'::operation_t)::operation_t[])) 
                                     THEN 2 -- Возврат 
			             ELSE
			                  NULL
                    END --  rcp_type
                    
                  , FALSE
                  , FALSE
                  , __x.id_pay
                  , RESEND_PR
			      , __id_fsc_provider
               )
               
         RETURNING id_receipt INTO __id_receipt;          
        
       RETURN __id_receipt;
    END;
    
   $$;
   
COMMENT ON FUNCTION fsc_receipt_pcg.fsc_orders_load (json)
              IS 'ON-line Загрузка исходных данных в секцию "0" -- (запросы на фискализацию).';	   
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

