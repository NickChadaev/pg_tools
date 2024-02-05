-- ------------------------------------------------
--  2023-05-18  Базовые типы.   ATOL
--  2023-08-21  Состояние чека и состояние ошибки
-- ------------------------------------------------
DO
  $$
   BEGIN

         CREATE TYPE sno_t AS ENUM (
         	
          'osn'                 --  общая система налогообложения
         ,'usn_income'          --  упрощенная СН (доходы)
         ,'usn_income_outcome'  --  упрощенная СН (доходы минус расходы)
         ,'envd'                --  единый налог на вмененный доход
         ,'esn'                 --  единый сельскохозяйственный налог
         ,'patent'              --  патентная СН
         	
         );
         COMMENT ON TYPE sno_t IS 'Система налогообложения (АТОЛ)';
   
     EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;

 
DO
  $$
   BEGIN
   
      CREATE TYPE payment_method_t AS ENUM (   -- Признак способа расчёта. Возможные значения:
      
        'full_prepayment' -- предоплата 100%. Полная предварительная оплата до момента передачи предмета расчета.
      , 'prepayment'      -- предоплата. Частичная предварительная оплата до момента передачи предмета расчета.
      , 'advance'         -- аванс.
      , 'full_payment'    -- полный расчет. Полная оплата, в том числе с учетом аванса (предварительной оплаты) в момент передачи предмета расчета
      , 'partial_payment' -- частичный расчет и кредит. Частичная оплата предмета расчета в момент его передачи с последующей оплатой в кредит
      , 'credit'          -- передача в кредит. Передача предмета расчета без его оплаты в момент его передачи с последующей оплатой в кредит
      , 'credit_payment'  -- оплата кредита. Оплата предмета расчета после его передачи с оплатой в кредит (оплата кредита)
      	
      );
      COMMENT ON TYPE payment_method_t IS 'Признак способа расчёта (АТОЛ)';
      
     EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;

-- SELECT enum_range ((71::text)::measure_t, NULL); 

     
DO
  $$
   BEGIN
   
      CREATE TYPE vat_t AS ENUM (  
      	
        'none'   -- без НДС;
       ,'vat0'   -- НДС по ставке 0%;
       ,'vat10'  -- НДС чека по ставке 10%;
       ,'vat110' -- НДС чека по расчетной ставке 10/110;
       ,'vat20'  -- НДС чека по ставке 20%;
       ,'vat120' -- НДС чека по расчетной ставке 20/120
      
      );
      COMMENT ON TYPE vat_t IS 'Тип налоговой ставки (АТОЛ)';
      
     EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;
      

  -------------------------------------------------------------------------------------------------------------------------------------
 DO
  $$
   BEGIN
   
      CREATE TYPE agent_info_t AS ENUM (  
      	
        'bank_paying_agent'    -- Банковский платежный агент
       ,'bank_paying_subagent' -- Банковский платежный субагент 
       ,'paying_agent'         -- Оказание услуг покупателю (клиенту)
       ,'paying_subagent'      -- Платежный субагент. 
       ,'attorney'             -- Поверенный.
       ,'commission_agent'     -- Комиссионер
       ,'another'              -- Другой тип агента     
      );
      COMMENT ON TYPE agent_info_t IS 'Типы агентов (АТОЛ)';
      
     EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;

-- ------------------------------------------------
--     2023-05-31  Базовый тип для коррекции чека
-- -----------------------------------------------
 DO
  $$
   BEGIN
   
      CREATE TYPE correction_type_t AS ENUM (  
        'self'        -- Самостоятельная операция
       ,'instruction' -- Операция по предписанию налогового ргана 
      );
      COMMENT ON TYPE correction_type_t IS 'Типы коррекций (АТОЛ)';
      
     EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;
-- -----------------------------------------------------------------
-- WARNING:  42710, type "sno_t" already exists
-- NOTICE:  type "measure_t" does not exist, skipping
-- WARNING:  42710, type "payment_method_t" already exists
-- NOTICE:  type "payment_type_t" does not exist, skipping
-- WARNING:  42710, type "vat_t" already exists
-- NOTICE:  drop cascades to function fsc_receipt_pcg.fsc_payments_crt_1(pmt_type_sum_t[])
-- ---
-- WARNING:  42710, type "vats_type_sum_t" already exists
-- WARNING:  42710, type "sectoral_item_props_t" already exists
-- WARNING:  42710, type "agent_info_t" already exists
-- NOTICE:  drop cascades to 2 other objects
-- ПОДРОБНОСТИ:  drop cascades to function fsc_receipt_pcg.fsc_items_crt_1(item_t[])
-- drop cascades to table fsc_receipt_pcg.item_t
-- ---
-- NOTICE:  type "item_internal_t" does not exist, skipping
-- DO
--
-- ------------------------------
--        2023-06-01
-- ------------------------------
 DO
  $$
   BEGIN
   
      CREATE TYPE operation_t AS ENUM (  
        'sell'                   -- чек «Приход»
       ,'buy'                    -- чек «Расход»
       ,'sell_refund'            -- чек «Возврат прихода»
       ,'buy_refund'             -- чек «Возврат расхода»
       ,'sell_correction'        -- чек «Коррекция прихода»
       ,'buy_correction'         -- чек «Коррекция расхода»;  
       ,'sell_refund_correction' -- чек «Коррекция возврата прихода» 
       ,'buy_refund_correction'  -- чек «Коррекция возврата расхода» 
       
      );
      COMMENT ON TYPE operation_t IS 'Типы операций (АТОЛ)';
      
     EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;
-- ------------------------------
--        2023-08-21
-- ------------------------------
 DO
  $$
   BEGIN
   
      CREATE TYPE status_t AS ENUM (  
        'done' -- зарегистрирован
       ,'fail' -- ошибка
       ,'wait' -- ожидание
      );
      COMMENT ON TYPE status_t IS 'Перечень состояний чека (АТОЛ)';
      
     EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;
  --
 -- DROP TYPE error_type_t ;
 DO
  $$
   BEGIN
   
      CREATE TYPE error_type_t AS ENUM (  
        'system'  -- системная ошибка
       ,'driver'  -- ошибка при работе с ККТ
       ,'timeout' -- превышено время ожидания  300 ms
       ,'unknown' -- неизвестная ошибка
       ,'none'    -- Нет ошибки ????   
       ,'agent'   -- ?? Хрен его знает, доки по ошибкам очень склмканы.       
       
       
      );
     COMMENT ON TYPE error_type_t IS 'Перечень источников ошибок (АТОЛ)';
      
     EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
           
   END;
  $$;  
--
-- SELECT enum_range('sell'::operation_t, 'buy_refund'::operation_t)::text[];
-- SELECT enum_range('sell_correction'::operation_t, 'buy_refund_correction'::operation_t)::text[]; 
--
-- SELECT 'buy' = ANY (enum_range('sell'::operation_t, 'buy_refund'::operation_t)::text[]); -- true
-- SELECT 'sell_refund_correction' = ANY (enum_range('sell'::operation_t, 'buy_refund'::operation_t)::text[]); -- false
-- SELECT 'sell_refund_correction' = ANY (enum_range('sell_correction'::operation_t, 'buy_refund_correction'::operation_t)::text[]); -- true
--
-- =================================================================================================================
--
DO
  $$
   BEGIN
--   pmt_type '[1,9]'::int4range -- Виды оплаты
--   ------------------------------------------
--     '0' -- наличные 
--   , '1' -- безналичный 
--   , '2' -- предварительная оплата (зачет аванса и (или предыдущих платежей) 
--   , '3' -- постоплата (кредит) 
--   , '4' -- иная форма оплаты (встречное предоставление)  
--   , '5' -- расширенный вид оплаты 1  
--   , '6' -- расширенный вид оплаты 2 
--   , '7' -- расширенный вид оплаты 3 
--   , '8' -- расширенный вид оплаты 4 
--   , '9' -- расширенный вид оплаты 5 
   
      -- DROP TYPE IF EXISTS pmt_type_sum_t CASCADE;
      CREATE TYPE pmt_type_sum_t AS (   -- Вид и сумма к оплаты
      
          pmt_type integer -- int4range ('[0,9]') 
         ,pmt_sum  numeric (10,2)
      	
      );
      COMMENT ON TYPE pmt_type_sum_t IS 'Вид и сумма к оплаты (АТОЛ)';
      
     EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;

DO
  $$
   BEGIN
   
      CREATE TYPE vats_type_sum_t AS (   -- Налог на чек коррекции
      
          vats_type vat_t
         ,vats_sum  numeric (10,2)
      	
      );
      COMMENT ON TYPE vats_type_sum_t IS 'Налог на чек коррекции (АТОЛ)';
      
     EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;

DO
  $$
   BEGIN
      -- DROP TYPE IF EXISTS sectoral_item_props_t CASCADE;
      CREATE TYPE sectoral_item_props_t AS (    
      
            federal_id  text
           ,date        text
           ,number      text
           ,value       text      	
      );
      COMMENT ON TYPE sectoral_item_props_t IS 'Отраслевой реквизит товара/Кассового чека (АТОЛ)';
      
     EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;

 DO
  $$
   BEGIN
   
      -- DROP TYPE IF EXISTS item_t CASCADE;
      CREATE TYPE item_t AS (    
           name                  text              -- Наименование товара/услуги      
          ,price                 numeric (10,2)    -- Цена в рублях
          ,quantity              numeric (8,3)     -- Количество
          ,measure               integer           -- measure_t   -- Единица измерения  --!!! Значения контролирую в функции
          ,sum                   numeric (10,2)    -- Сумма в рублях
          ,payment_method        payment_method_t  -- Способ расчёта
          ,payment_object        integer           -- Признак предмета расчёта  !!! Значения контролирую в функции
          ,vat                   json              -- Атрибуты налога на позицию
          ,user_data             text              -- Дополнительный реквизит предмета расчёта
          ,excise                numeric (10,2)    -- Сумма акциза в рублях 
          ,country_code          text              -- Цифровой код страны происхождения товара 
          ,declaration_number    text              -- Номер таможенной декларации
          ,mark_quantity         json              -- Дробное количество маркированного товара
          ,mark_processing_mode  text              -- 
          ,sectoral_item_props   json              --
          ,mark_code             json              -- МАркировка средствами идентификации 
          ,agent_info            json              -- Атрибуты агента
          ,supplier_info         json              -- Поставщик 
      );
      COMMENT ON TYPE item_t IS 'Описание товара/услуги (АТОЛ)';

     EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;

