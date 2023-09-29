--
--  2023-05-25 
--
-- DROP TABLE IF EXISTS fsc_receipt_pcg.fsc_items_1;
-- CREATE TABLE fsc_receipt_pcg.item_t OF item_t;
-- COMMENT ON table fsc_receipt_pcg.item_t IS 'Описание товара/услуги';

TRUNCATE  fsc_receipt_pcg.item_t;
INSERT INTO fsc_receipt_pcg.item_t(
	  name            --   text              -- Наименование товара/услуги      
	, price           --   numeric (10,2)    -- Цена в рублях
	, quantity        --   numeric (8,3)     -- Количество
	, measure         --   integer           -- measure_t   -- Единица измерения  --!!! Значения контролирую в функции
	, sum             --   numeric (10,2)    -- Сумма в рублях
	, payment_method  --   payment_method_t  -- Способ расчёта
	, payment_object  --   integer           -- Признак предмета расчёта  !!! Значения контролирую в функции
	, vat             --   json              -- Атрибуты налога на позицию
	)
	VALUES (
        'Плата ООО "ГРК" за водоотведение и холодное в/с, НДС не облагается, <ЛС 34516583;ПРД04.2023'
      , 882.00
      , 1.0
      , 0
      , NULL -- 882.00
      , NULL --  'full_prepayment'
      , NULL --  1
      , NULL -- 'none'
    );      

SELECT fsc_receipt_pcg.fsc_items_crt_1(array_agg (x.*::item_t)) FROM fsc_receipt_pcg.item_t x;	
 
 -----------------------------------------------------------------------------------------------
 


