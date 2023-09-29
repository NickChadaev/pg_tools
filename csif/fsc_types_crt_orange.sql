-- --------------------------------------
--  2023-08-08  Базовые типы.  ORANGE
-- --------------------------------------
 --  DROP TYPE IF EXISTS public.payments_rt CASCADE;
 DO
  $$
   BEGIN
         CREATE TYPE public.payments_rt AS 
      (
             type   integer 
            ,amount numeric(10,2) 
      );

     EXCEPTION           
        WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;
  
  COMMENT ON TYPE public.payments_rt  IS 'Описание платежа (ORANGE)';
  
 --  DROP TYPE IF EXISTS public.positions_rt CASCADE;  
 DO
  $$
   BEGIN
      CREATE TYPE positions_rt AS (    
           "quantity"                 numeric (16,6)  -- Количество
          ,"price"                    numeric (10,2)  -- Цена в рублях
          ,"tax"                      integer         -- Ставка НДС, 1199:
          ,"text"                     text            -- Наименование товара/услуги      
          ,"paymentMethodType"        integer         -- Признак способа расчета
          ,"paymentSubjectType"       integer         -- Признак предмета расчета
		  -----------------------------------------------------------------------
          ,"taxSum"                   numeric (10,2)  -- Сумма НДС в рублях		  
          ,"itemCode"                 text            -- Код маркировки
          ,"supplierInfo"             json            -- Поставщик 
          ,"supplierINN"              text            -- ИНН поставщика
          ,"agentType"                integer         -- Признак агента по предмету расчета
          ,"agentInfo"                json            -- Атрибуты агента
          ,"quantityMeasurementUnit"  integer         -- Мера количества предмета расчета
          ,"additionalAttribute"      text            -- Дополнительный реквизит предмета расчета 
          ,"manufacturerCountryCode"  text            -- Код страны происхождения товара 
          ,"customsDeclarationNumber" text            -- Номер таможенной декларации 
          ,"excise"                   numeric (10,2)  -- Сумма акциза в рублях 
          ,"unitTaxSum"               numeric (10,2)  -- Размер НДС за единицу предмета расчета
          ,"fractionalQuantity"       json            -- Дробное количество маркированного товара 
          ,"industryAttribute"        json            -- Отраслевой реквизит предмета расчета 
          ,"barcodes"                 json            -- Штрих-коды предмета расчета 
      );
	  
     EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;

COMMENT ON TYPE positions_rt IS 'Предмет расчёта (товар/услуга) (ORANGE)';
