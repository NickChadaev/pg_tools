--
--  2023-08-18
--
BEGIN;
   -- ROLLBACK;
   
DROP TABLE IF EXISTS fsc_orange_pcg.positions_rt;
CREATE TABLE fsc_orange_pcg.positions_rt OF positions_rt;
COMMENT ON table fsc_orange_pcg.positions_rt IS 'Описание товара/услуги';

TRUNCATE  fsc_orange_pcg.positions_rt;
INSERT INTO fsc_orange_pcg.positions_rt (
       quantity           -- numeric (16,6) NOT NULL -- Количество
      ,price              -- numeric (10,2) NOT NULL -- Цена в рублях
      ,tax                -- integer        NOT NULL -- Ставка НДС, 1199:         int4range
      ,text               -- text           NOT NULL -- Наименование товара/услуги      
      ,paymentMethodType  -- integer        NOT NULL -- Признак способа расчета   int4range 
      ,paymentSubjectType -- integer        NOT NULL -- Признак предмета расчета  int4range 
      ---------------------------------------------------------------------------------
      ,taxSum                   -- numeric (10,2) NULL -- Сумма НДС в рублях
      ,itemCode                 -- text           NULL -- Код маркировки
      ,supplierInfo             -- json           NULL -- Поставщик 
      ,supplierINN              -- text           NULL -- ИНН поставщика
      ,agentType                -- integer        NULL -- Признак агента по предмету расчета
      ,agentInfo                -- json           NULL -- Атрибуты агента
      ,quantityMeasurementUnit  -- integer        NULL -- Мера количества предмета расчета  int4range
      ,additionalAttribute      -- text           NULL -- Дополнительный реквизит предмета расчета 
      ,manufacturerCountryCode  -- text           NULL -- Код страны происхождения товара 
      ,customsDeclarationNumber -- text           NULL -- Номер таможенной декларации 
      ,excise                   -- numeric (10,2) NULL -- Сумма акциза в рублях 
      ,unitTaxSum               -- numeric (10,2) NULL -- Размер НДС за единицу предмета расчета
      ,fractionalQuantity       -- json           NULL -- Дробное количество маркированного товара 
      ,industryAttribute        -- json           NULL -- Отраслевой реквизит предмета расчета 
      ,barcodes                 -- json           NULL -- Штрих-коды предмета расчета 
	)
        -- =====================================================================================
        --    2023-08-18  Создание объекта  "Предмет расчета"
        -- =====================================================================================
    
    VALUES (
      1.0
    , 2000.00
    , 1
    , 'ЛС 86427847; квартплата за март 2023  Госпитальная  10 кв.41 Игнатова Е.Н. НДС не облагается'
    , 4
    , 10
    ---------------------------------------------------------------------
    , NULL::numeric (10,2) -- Сумма НДС в рублях
    , NULL::text           -- Код маркировки
    , NULL::json           -- Поставщик 
    , NULL::text           -- ИНН поставщика
    , NULL::integer        -- Признак агента по предмету расчета
    , NULL::json           -- Атрибуты агента
    , NULL::integer        -- Мера количества предмета расчета  int4range
    , NULL::text           -- Дополнительный реквизит предмета расчета 
    , NULL::text           -- Код страны происхождения товара 
    , NULL::text           -- Номер таможенной декларации 
    , NULL::numeric (10,2) -- Сумма акциза в рублях 
    , NULL::numeric (10,2) -- Размер НДС за единицу предмета расчета
    , NULL::json           -- Дробное количество маркированного товара 
    , NULL::json           -- Отраслевой реквизит предмета расчета 
    , NULL::json           -- Штрих-коды предмета расчета 	
  );

  
SELECT fsc_orange_pcg.fsc_content_crt_1 (  
       p_type             := 1    -- Признак расчета  
     , p_positions        := (SELECT fsc_orange_pcg.fsc_positions_crt_2 (array_agg (x.*::positions_rt)) FROM fsc_orange_pcg.positions_rt x
                             ) -- Список предметов расчета, 1059	
     , p_check_close      := (SELECT fsc_orange_pcg.fsc_check_close_crt_2 (0, '[{"type":1,"amount":2000.00}]')
                             ) -- Параметры закрытия чека	
     , p_customer_contact := 'ggg@mal.ru' -- Телефон или электронный адрес покупателя, 1008 
     
     );	
 
 -----------------------------------------------------------------------------------------------
 -- DROP TABLE IF EXISTS fsc_orange_pcg.positions_rt;
 -----------------------------------------------------------------------------------------------
{"ffdVersion":4,"type":1,"positions":[{"quantity":1.000000,"price":2000.00,"tax":1,"text":"ЛС 86427847; квартплата за март 2023  Госпитальная  10 кв.41 Игнатова Е.Н. НДС не облагается","paymentmethodtype":4,"paymentsubjecttype":10}],"checkClose":{"taxationSystem":0,"payments":[{"type":1,"amount":2000.00}]},"customerContact":"ggg@mal.ru"}
{"type":1,"positions":[{"quantity":1.000000,"price":2000.00,"tax":1,"text":"ЛС 86427847; квартплата за март 2023  Госпитальная  10 кв.41 Игнатова Е.Н. НДС не облагается","paymentmethodtype":4,"paymentsubjecttype":10}],"checkClose":{"taxationSystem":0,"payments":[{"type":1,"amount":2000.00}]},"customerContact":"ggg@mal.ru"}
{"type":1,"positions":[{"quantity":1.000000,"price":2000.00,"tax":1,"text":"ЛС 86427847; квартплата за март 2023  Госпитальная  10 кв.41 Игнатова Е.Н. НДС не облагается","paymentmethodtype":4,"paymentsubjecttype":10}],"checkClose":{"taxationSystem":0,"payments":[{"type":1,"amount":2000.00}],"customerContact":"ggg@mal.ru"},"customerContact":"ggg@mal.ru"}
 
-- { "type":1
--  ,"positions":[
--                 { "quantity":1.000000
--                  ,"price":2000.00
--                  ,"tax":1
--                  ,"text":"ЛС 86427847; квартплата за март 2023  Госпитальная  10 кв.41 Игнатова Е.Н. НДС не облагается"
--                  ,"paymentmethodtype":4
--                  ,"paymentsubjecttype":10
--                 }
--               ]
--   ,"checkClose":{
--                    "taxationSystem":0
--                   ,"payments":[
--                                 ,"{"type":1
--                                    ,"amount":2000.00
--                                    }
--                             ]
--                   ,"customerContact":"ggg@mal.ru"}
--                   ,"customerContact":"ggg@mal.ru"}
