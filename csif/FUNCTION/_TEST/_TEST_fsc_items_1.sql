--
--  2023-05-25 
--
-- DROP TABLE IF EXISTS fsc_receipt_pcg.fsc_items_1;
-- CREATE TABLE fsc_receipt_pcg.item_t OF item_t;
-- COMMENT ON table fsc_receipt_pcg.item_t IS 'Описание товара/услуги';

TRUNCATE  fsc_receipt_pcg.item_t;
INSERT INTO fsc_receipt_pcg.item_t(
	  name                    --   text              -- Наименование товара/услуги      
	, price                   --   numeric (10,2)    -- Цена в рублях
	, quantity                --   numeric (8,3)     -- Количество
	, measure                 --   integer           -- measure_t   -- Единица измерения  --!!! Значения контролирую в функции
	, sum                     --   numeric (10,2)    -- Сумма в рублях
	, payment_method          --   payment_method_t  -- Способ расчёта
	, payment_object          --   integer           -- Признак предмета расчёта  !!! Значения контролирую в функции
	, vat                     --   json              -- Атрибуты налога на позицию
	, user_data               --   text              -- Дополнительный реквизит предмета расчёта
	, excise                  --   numeric (10,2)    -- Сумма акциза в рублях 
	, country_code            --   text              -- Цифровой код страны происхождения товара 
	, declaration_number      --   text              -- Номер таможенной декларации
	, mark_quantity           --   json              -- Дробное количество маркированного товара
	, mark_processing_mode    --   text              -- 
	, sectoral_item_props     --   json              --
	, mark_code               --   json              -- МАркировка средствами идентификации 
	, agent_info              --   json              -- Атрибуты агента
	, supplier_info           --   json              -- Поставщик 
	)
	VALUES (
	  'ЛС 86427847; квартплата за март 2023  Госпитальная  10 кв.41 Игнатова Е.Н. НДС не облагается'
	, 20.00
	, 1.0
	, 0
	, 20.0
	, 'full_prepayment'
	, 1
	, fsc_receipt_pcg.fsc_vat_crt_2 ('vat10',2.02)
	,'Дополнительный ревизит предмета расчёта'
	, 10.0
	, '063'
	, '00289282828'
	, fsc_receipt_pcg.fsc_mark_quantity_crt_2 (1,2)
	, '0'
	, fsc_receipt_pcg.fsc_sectoral_item_props_crt_2 (
	             array[ ('001', to_char('2023-05-23'::date, 'DD.MM.YYYY'), '123/43', 'Ид1=Знач1&Ид2=Знач2&Ид3=Знач3')
                        ]::sectoral_item_props_t[]
      )
	, fsc_receipt_pcg.fsc_mark_code_crt_2 (p_egais30 := '12345678901234')
	, fsc_receipt_pcg.fsc_agent_info_crt_2(
           p_type                      := 'bank_paying_agent'  -- Тип агента по предмету расчёта 
          ,p_paying_agent              := fsc_receipt_pcg.fsc_paying_agent_crt_3 ('Платёж', ARRAY['9211773067', '+38980935788', '4953367178'])
          ,p_receive_payments_operator := '{"phones":["9211773067","+38980935788","4953367178"]}' -- Константа
          ,p_money_transfer_operator   := fsc_receipt_pcg.fsc_money_transfer_operator_crt_3 (
                                                       ARRAY ['9211773067', '+38980935788', '4953367178']
                                                      ,'xxxxx', 'г. Москва, ул. Складочная д.3', '778907872311'
                                                      )
		  )
    , fsc_receipt_pcg.fsc_supplier_info_crt_2 (ARRAY['9211773067', '+38980935788', '4953367178'])   
	);
	
 SELECT fsc_receipt_pcg.fsc_items_crt_1(array_agg (x.*::item_t)) FROM fsc_receipt_pcg.item_t x;	
 
 -----------------------------------------------------------------------------------------------
 
 -----------------------------------------------------------------------------------------------
--  Величина "excise" не должна превышать 42949673 и должна быть положительной	
-- "excise" := NULL;

-- ERROR:  operator does not exist: text = integer
-- LINE 1: SELECT NOT (__item.country_code = JMAX[11]::integer)
--                                         ^
-- HINT:  No operator matches the given name and argument types. You might need to add explicit type casts.
-- QUERY:  SELECT NOT (__item.country_code = JMAX[11]::integer)
-- CONTEXT:  PL/pgSQL function fsc_receipt_pcg.fsc_items_crt_1(item_t[]) line 60 at IF
-- SQL state: 42883

-- 	,(
-- 	  ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	)
-- 	,(
-- 	  ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	, ?
-- 	);

