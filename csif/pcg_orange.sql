
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW fsc_orange_pcg.version
 AS
 SELECT '$Revision:5eed275$ modified $RevDate:2023-08-17$'::text AS version; 
                   
-- SELECT * FROM fsc_orange_pcg.version;
-- $Revision:52461ee$ modified $RevDate:2023-08-07$

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_orange_pcg.c_agent_type () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_agent_type (
)
    RETURNS integer[]
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- -------------------------------------------------------
      --   2023-08-17
      -- ------------
      SELECT ARRAY [
                            --   Признак агента по предмету расчета:
                          1 -- 0   – банковский платежный агент
                        , 2 -- 1   – банковский платежный субагент
                        , 4 -- 2   – платежный агент
                        , 8 -- 3   – платежный субагент
                        ,16 -- 4   – поверенный
                        ,32 -- 5   – комиссионер
                        ,64 -- 6   – иной агент     
                            -- 7 (128)-- Хрен его знает
 ];
 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_agent_type ()
    IS 'КОНСТАНТЫ. Признак агента по предмету расчета, 1222. Битовое поле';
-- ------------------------------------------------------------------------
--   USE CASE:
--             SELECT fsc_orange_pcg.c_agent_type ();   -- {1,2,4,8,16,32,64}
--             SELECT (fsc_orange_pcg.c_agent_type ())[5]; -- 16
--

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_orange_pcg.c_payment_method_type () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_payment_method_type (
)
    RETURNS int4range
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- ----------------------------------
      --   2023-08-17
      -- ---------------------------------
      --   Признак способа расчета, 1214:
      --   1 – Предоплата 100%
      --   2 – Частичная предоплата
      --   3 – Аванс
      --   4 – Полный расчет
      --   5 – Частичный расчет и кредит
      --   6 – Передача в кредит
      --   7 – Оплата кредита

      SELECT int4range('[1,7]'); 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_payment_method_type ()
    IS 'КОНСТАНТЫ. Признак способа расчета';
-- -------------------------------------------------------------------------------
--   USE CASE:
--        SELECT fsc_orange_pcg.c_payment_method_type ();
--        SELECT lower(fsc_orange_pcg.c_payment_method_type ()), upper(fsc_orange_pcg.c_payment_method_type ())-1;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_orange_pcg.c_payment_subject_type () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_payment_subject_type (
)
    RETURNS int4range
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- --------------------------------------------------------
      --   2023-08-17
      -- --------------------------------------------------------
      --    Признак предмета расчета, 1212:
      --     1 – Товар
      --     2 – Подакцизный товар
      --     3 – Работа
      --     4 – Услуга
      --     5 – Ставка азартной игры
      --     6 – Выигрыш азартной игры
      --     7 – Лотерейный билет
      --     8 – Выигрыш лотереи
      --     9 – Предоставление РИД
      --    10 – Платеж
      --    11 – Агентское вознаграждение
      --    12 – Выплата
      --    13 – Иной предмет расчета
      --    14 – Имущественное право
      --    15 – Внереализационный доход*
      --    16 – Иные платежи и взносы*
      --    17 – Торговый сбор
      --    18 – Курортный сбор
      --    19 – Залог
      --    20 – Расход
      --    21 – Взносы на обязательное пенсионное страхование ИП
      --    22 – Взносы на обязательное пенсионное страхование
      --    23 – Взносы на обязательное медицинское страхование ИП
      --    24 – Взносы на обязательное 1медицинское страховани
      --    25 – Взносы на обязательное социальное страхование
      --    26 – Платеж казино
      --    27 – Выдача денежных средств
      --    30 – АТНМ (не имеющем кода маркировки)
      --    31 – АТМ (имеющем код маркировки)
      --    32 – ТНМ
      --    33 – ТМ
      

      SELECT int4range('[1,33]'); 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_payment_subject_type ()
    IS 'КОНСТАНТЫ. Признак предмета расчета';
-- -------------------------------------------------------------------------------
--  USE CASE:
--    SELECT fsc_orange_pcg.c_payment_subject_type ();
--    SELECT lower(fsc_orange_pcg.c_payment_subject_type ()), upper(fsc_orange_pcg.c_payment_subject_type ())-1;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_orange_pcg.c_pmt_type () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_pmt_type (
)
    RETURNS integer[]
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- -------------------------------------------------------
      --   2023-08-17
      -- ------------
      SELECT ARRAY [
                     --     Тип оплаты:
                       1 -- сумма по чеку наличными,                                                1031
                     , 2 -- сумма по чеку безналичными,                                             1081
                     ,14 -- сумма по чеку предоплатой (зачетом аванса и (или) предыдущих платежей), 1215
                     ,15 -- сумма по чеку постоплатой (в кредит),                                   1216
                     ,16 -- сумма по чеку (БСО) встречным предоставлением,                          1217
     ];
 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_pmt_type ()
    IS 'КОНСТАНТЫ. Тип оплаты';
-- ------------------------------------------------------------------------
--   USE CASE:
--             SELECT fsc_orange_pcg.c_pmt_type ();   -- {1,2,14,15,16}
--             SELECT (fsc_orange_pcg.c_pmt_type ())[1]; -- 1
--

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_orange_pcg.c_quantity_measurement_unit () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_quantity_measurement_unit (
)
    RETURNS int4range
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- --------------------------------------------------------
      --   2023-08-17
      -- --------------------------------------------------------
      --    Мера количества предмета расчета

      SELECT int4range('[0,255]'); 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_quantity_measurement_unit ()
    IS 'КОНСТАНТЫ. Мера количества предмета расчета';
-- -------------------------------------------------------------------------------
--  USE CASE:
--    SELECT fsc_orange_pcg.c_quantity_measurement_unit ();
--    SELECT lower(fsc_orange_pcg.c_quantity_measurement_unit ()), upper(fsc_orange_pcg.c_quantity_measurement_unit ())-1;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_orange_pcg.c_taxation_system () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_taxation_system (
)
    RETURNS int4range
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- -------------------------------------------------------
      --   2023-08-17
      -- ------------
                             
      --  Система налогообложения, 1055:
      --  0 – Общая, ОСН
      --  1 – Упрощенная доход, УСН доход
      --  2 – Упрощенная доход минус расход, УСН доход - расход
      --  3 – Единый налог на вмененный доход, ЕНВД
      --  4 – Единый сельскохозяйственный налог, ЕСН
      --  5 – Патентная система налогообложения, Патент  


      SELECT int4range('[0,5]'); 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_taxation_system ()
    IS 'КОНСТАНТЫ. Система налогообложения';
-- ------------------------------------------------------------------------
--   USE CASE:
--        SELECT fsc_orange_pcg.c_taxation_system ();
--        SELECT lower(fsc_orange_pcg.c_taxation_system ()), upper(fsc_orange_pcg.c_taxation_system ())-1;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_orange_pcg.c_vat () CASCADE;
CREATE OR REPLACE FUNCTION fsc_orange_pcg.c_vat (
)
    RETURNS int4range
    LANGUAGE sql
    IMMUTABLE

AS $$
      -- -------------------------------------------------------
      --   2023-08-17
      -- ------------
      --     Ставка НДС, 1199:
      --     1 – ставка НДС 20%
      --     2 – ставка НДС 10%
      --     3 – ставка НДС расч. 20/120
      --     4 – ставка НДС расч. 10/110
      --     5 – ставка НДС 0%
      --     6 – НДС не облагается

      SELECT int4range('[0,6]'); 
$$;

COMMENT ON FUNCTION fsc_orange_pcg.c_vat ()
    IS 'КОНСТАНТЫ. Классификация ставок НДС';
-- -------------------------------------------------------------------------------
--   USE CASE:
--        SELECT fsc_orange_pcg.c_vat ();
--        SELECT lower(fsc_orange_pcg.c_vat ()), upper(fsc_orange_pcg.c_vat ())-1;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_orange_pcg.fsc_payments_crt_3 (public.payments_rt[]);
CREATE OR REPLACE FUNCTION fsc_orange_pcg.fsc_payments_crt_3(
       p_payments    public.payments_rt[] 
)
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-08-08 Создание объекта "payments" - Тип и сумма оплаты
   -- ============================================================================ --

   DECLARE
     JKEY     CONSTANT text       := 'payments';
     PMT_TYPE CONSTANT integer [] := fsc_orange_pcg.c_pmt_type();

     __pmt_type_sum  public.payments_rt;
     __result        json;
      
   BEGIN
      FOREACH __pmt_type_sum IN ARRAY p_payments
         LOOP
           IF NOT (__pmt_type_sum.type = ANY (PMT_TYPE))
             THEN
                RAISE '"payments": Вид оплаты должен принадлежать множеству "[%]"', PMT_TYPE;
		   END IF;	  
         END LOOP;
      
      __result := json_strip_nulls (to_json(p_payments));
      
      RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_orange_pcg.fsc_payments_crt_3 (public.payments_rt[])     
    IS 'Создание объекта "payments" - Тип и сумма оплаты';
--
--  USE CASE:
          -- ---------------------------------------------------------------------------------------------------
          --    SELECT fsc_orange_pcg.fsc_payments_crt_3 (array[(9, 200.2)]::public.payments_rt[]);
		  --       ERROR:  "payments": Вид оплаты должен принадлежать множеству "[{1,2,14,15,16}]"
--              SELECT fsc_orange_pcg.fsc_payments_crt_3 (array[(1, 200.2)]::public.payments_rt[]);
--                  [{"type":1,"amount":200.20}]
--              SELECT fsc_orange_pcg.fsc_payments_crt_3 (array[(1, 200.2), (2, 800.2)]::public.payments_rt[]);
--                  [{"type":1,"amount":200.20},{"type":2,"amount":800.20}]
          -- ---------------------------------------------------------------------------------------------------
		  

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_orange_pcg.fsc_check_close_crt_2 (integer, json, text);
CREATE OR REPLACE FUNCTION fsc_orange_pcg.fsc_check_close_crt_2 (
            p_taxationSystem   integer
           ,p_payments         json 
           ,p_customer_contact text
)
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-08-08 Создание объекта "Check_Close" - Параметры закрытия чека.
   -- ============================================================================ --

   DECLARE
     JKEY             CONSTANT text      := 'checkClose';
     JKEYS            CONSTANT text[]    := array['taxationSystem', 'payments', 'customerContact']::text[];       
     TAXATION_SYSTEM  CONSTANT int4range := fsc_orange_pcg.c_taxation_system();
                             
      --  Система налогообложения, 1055:
      --  0 – Общая, ОСН
      --  1 – Упрощенная доход, УСН доход
      --  2 – Упрощенная доход минус расход, УСН доход - расход
      --  3 – Единый налог на вмененный доход, ЕНВД
      --  4 – Единый сельскохозяйственный налог, ЕСН
      --  5 – Патентная система налогообложения, Патент                             
     
     __result  json;
      
   BEGIN
   
      IF NOT (TAXATION_SYSTEM @> p_taxationSystem)
        THEN
           RAISE '"check_close": Код системы налогобложения должен находится в диапазоне от "%" до "%"'
                          , lower(TAXATION_SYSTEM), upper(TAXATION_SYSTEM)-1;
      END IF;   
   
      __result := json_strip_nulls (
                      json_build_object ( JKEYS[1], p_taxationSystem::integer
                                         ,JKEYS[2], p_payments::json
                                         ,JKEYS[3], p_customer_contact
                                        )
      );     
      
      RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_orange_pcg.fsc_check_close_crt_2 (integer, json, text)    
    IS 'Создание объекта "Check_Close" - Параметры закрытия чека.';
--
--  USE CASE:
       -- ---------------------------------------------------------------------------------------------------
       --    SELECT fsc_orange_pcg.fsc_check_close_crt_2 (0, '[{"type":1,"amount":200.20}]', 'ggg@mal.ru');
       --   {"taxationSystem":0,"payments":[{"type":1,"amount":200.20}],"customerContact":"ggg@mal.ru"}	
       --
--           SELECT fsc_orange_pcg.fsc_check_close_crt_2 (0,  fsc_orange_pcg.fsc_payments_crt_3 (array[(1, 200.2)]::public.payments_rt[])
--           , 'ggg@mal.ru');	
       --    --
       --         {"taxationSystem":0,"payments":[{"type":1,"amount":200.20}],"customerContact":"ggg@mal.ru"}			 
       	    
--           SELECT fsc_orange_pcg.fsc_check_close_crt_2 (0,  fsc_orange_pcg.fsc_payments_crt_3 (array[(9, 200.2)]::public.payments_rt[])
--           , 'ggg@mal.ru');
       --    ERROR:  "payments": Вид оплаты должен принадлежать множеству "[{1,2,14,15,16}]"
	   --
       --    SELECT fsc_orange_pcg.fsc_check_close_crt_2 (8, '[{"type":1,"amount":200.20}]', 'ggg@mal.ru');
       --    ERROR:  "check_close": Код системы налогобложения должен находится в диапазоне от "0" до "5"	   
       -- ---------------------------------------------------------------------------------------------------

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_orange_pcg.fsc_positions_crt_2 (positions_rt[]);
CREATE OR REPLACE FUNCTION fsc_orange_pcg.fsc_positions_crt_2(
       p_item positions_rt[] 
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-05-18  Создание объекта  "item"
   -- ---------------------------------------------------------------------------- --
   --   Обязательные и опциональные аторибуты типа:
   --  
   --   CREATE TYPE positions_rt AS (    
   --      quantity                 numeric (16,6)  NOT NULL -- Количество
   --     ,price                    numeric (10,2)  NOT NULL -- Цена в рублях
   --     ,tax                      int4range       NOT NULL -- Ставка НДС, 1199:
   --     ,text                     text            NOT NULL -- Наименование товара/услуги      
   --     ,paymentMethodType        int4range       NOT NULL -- Признак способа расчета
   --     ,paymentSubjectType       int4range       NOT NULL -- Признак предмета расчета
   --     ,taxSum                   numeric (10,2)      NULL -- Сумма НДС в рублях
   --     ,nomenclatureCode         text                NULL -- Код товарной номенклатуры
   --     ,itemCode                 text                NULL -- Код маркировки
   --     ,supplierInfo             json                NULL -- Поставщик 
   --     ,supplierINN              text                NULL -- ИНН поставщика
   --     ,agentType                integer             NULL -- Признак агента по предмету расчета
   --     ,agentInfo                json                NULL -- Атрибуты агента
   --     ,unitOfMeasurement        text                NULL -- Единица измерения предмета расчета
   --     ,quantityMeasurementUnit  int4range           NULL -- Мера количества предмета расчета
   --     ,additionalAttribute      text                NULL -- Дополнительный реквизит предмета расчета 
   --     ,manufacturerCountryCode  text                NULL -- Код страны происхождения товара 
   --     ,customsDeclarationNumber text                NULL -- Номер таможенной декларации 
   --     ,excise                   numeric (10,2)      NULL -- Сумма акциза в рублях 
   --     ,unitTaxSum               numeric (10,2)      NULL -- Размер НДС за единицу предмета расчета
   --     ,fractionalQuantity       json                NULL -- Дробное количество маркированного товара 
   --     ,industryAttribute        json                NULL -- Отраслевой реквизит предмета расчета 
   --     ,barcodes                 json                NULL -- Штрих-коды предмета расчета 
   --   );
   --   COMMENT ON TYPE positions_rt IS 'Предмет расчёта (товар/услуга) (ORANGE)';
   -- ============================================================================ --

   DECLARE
     QTY_ITMS CONSTANT integer := 100; 
     
     JKEY     CONSTANT text := 'item'; --  1/7/13          2/8/14                   3/9/15                4/10/16       5/11/17             6/12/18                                
     JKEYS    CONSTANT text[]:= ARRAY [ 'name',           'price',                'quantity',            'measure',   'sum',          'payment_method'      
                                       ,'payment_object', 'vat',                  'user_data',           'excise',    'country_code', 'declaration_number'  
                                       ,'mark_quantity',  'mark_processing_mode', 'sectoral_item_props', 'mark_code', 'agent_info',   'supplier_info'
                                ]::text[];

     JMAX CONSTANT numeric (10,2)[]:= ARRAY [ 
                                        128.0,            42949672.95,              99999.99,               NULL,     42949672.95,     NULL      
                                       , NULL,              NULL,                     64.0,              42949672.95,    3.0,           32.0  
                                       , NULL,              NULL,                     NULL,                 NULL,        NULL,         NULL          
                                ]::text[];

     PAYMENT_OBJECT_0 CONSTANT int4range  := int4range('[1,27]');  
     PAYMENT_OBJECT_1 CONSTANT int4range  := int4range('[30,33]');                               
                                
     __lts_items_mess text := '"%s": Количество различных товаров/услуг не должно превышать: %s';
     __lts_mess       text := '"%s": Длина "%s" должна быть не больше %s символов';
     __eqs_mess       text := '"%s": Длина "%s" должна быть равна %s символам';     
     __ltn_mess       text := '"%s": Величина "%s" не должна превышать %s';
     __ptn_mess       text := '"%s": Величина "%s" не должна превышать %s и должна быть положительной';    
     __msr_mess       text := '"%s": Неправильный тип единицы измерения товара: "%s" = %s';           
     __mpo_mess       text := '"%s": Неправильный признак предмета расчёта: "%s" = %s';
     
     __null_mess text := '"%s[%s]": Все данные являются обязательными: "%s" = %L, "%s" = %L, "%s" = %L, "%s" = %L'
                         ', "%s" = %L, "%s" = %L, "%s" = %L, "%s" = %L';     
     __items positions_rt[];
     __item  positions_rt;
     __i  integer;
     
     __result json;
      
   BEGIN
      IF (array_length (p_item, 1) > QTY_ITMS) 
        THEN
          RAISE '%', format (__lts_items_mess, JKEY, QTY_ITMS);
      END IF;  
      
      -- Теперь цикл по входному массиву, на каждой итерации, выполняются проверки.
      
      __i := 1;
      FOREACH __item IN ARRAY p_item
      
          LOOP
             IF  (__item.name IS NULL) OR (__item.price IS NULL) OR (__item.quantity IS NULL) OR 
                 (__item.measure IS NULL) OR (__item.sum IS NULL) OR (__item.payment_method IS NULL) OR 
                 (__item.payment_object IS NULL) OR (__item.vat IS NULL)
               THEN
                    RAISE '%', format (__null_mess, JKEY, __i
                                              , JKEYS[1], __item.name  
                                              , JKEYS[2], __item.price
                                              , JKEYS[3], __item.quantity
                                              , JKEYS[4], __item.measure
                                              , JKEYS[5], __item.sum
                                              , JKEYS[6], __item.payment_method 
                                              , JKEYS[7], __item.payment_object  
                                              , JKEYS[8], __item.vat
                                      );

                ELSIF NOT (char_length(__item.name) <= JMAX[1]::integer)   
                    THEN
                         RAISE '%', format (__lts_mess, JKEY, JKEYS[1], JMAX[1]::integer);
                    
                ELSIF (__item.price > JMAX[2]) 
                    THEN
                         RAISE '%', format (__ltn_mess, JKEY, JKEYS[2], JMAX[2]::integer);
                         
                ELSIF (__item.quantity > JMAX[3]) 
                    THEN
                         RAISE '%', format (__ltn_mess, JKEY, JKEYS[3], JMAX[3]::integer);
                         
               -- ELSIF NOT (( MEASURE_0 @> __item.measure) OR ( MEASURE_1 @> __item.measure) OR ( MEASURE_2 @> __item.measure) OR 
               --            ( MEASURE_3 @> __item.measure) OR ( MEASURE_4 @> __item.measure) OR ( MEASURE_5 @> __item.measure) OR 
               --            ( MEASURE_6 @> __item.measure) OR ( MEASURE_7 @> __item.measure) OR ( MEASURE_8 @> __item.measure)
               --           )                                                                                   
               --     THEN
               --         RAISE '%', format (__msr_mess, JKEY, JKEYS[4], __item.measure);
     
                ELSIF (__item.sum > JMAX[5]) 
                    THEN
                         RAISE '%', format (__ltn_mess, JKEY, JKEYS[5], JMAX[5]::integer);           
             
                ELSIF NOT ((PAYMENT_OBJECT_0 @> __item.payment_object) OR (PAYMENT_OBJECT_1 @> __item.payment_object)) 
                    THEN                
                        RAISE '%', format (__mpo_mess, JKEY, JKEYS[7], __item.payment_object);
                
                ELSIF NOT (char_length(__item.user_data) <= JMAX[9]::integer)
                    THEN
                        RAISE '%', format (__lts_mess, JKEY, JKEYS[9], JMAX[9]::integer);               
             
                ELSIF NOT ((__item.excise <= JMAX[10]) AND (__item.excise > 0)) 
                    THEN
                         RAISE '%', format (__ptn_mess, JKEY, JKEYS[10], JMAX[10]::integer);

                ELSIF NOT (char_length(__item.country_code) = JMAX[11]::integer)
                    THEN                
                         RAISE '%', format (__eqs_mess, JKEY, JKEYS[11], JMAX[11]::integer); 
                    
                ELSIF NOT (char_length(__item.declaration_number) <= JMAX[12]::integer)
                    THEN
                         RAISE '%', format (__lts_mess, JKEY, JKEYS[12], JMAX[12]::integer);
             END IF;

             __items [__i] := __item ;
             __i := __i + 1;
          END LOOP;
      
       __result := json_strip_nulls (to_json(__items));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_orange_pcg.fsc_positions_crt_2 (positions_rt[])     
    IS 'Создание объекта "positions" -- Предмет расчета';
--
--  USE CASE:
--             SEE TESTS
--------------------------------------------------------------------------------------------------------------

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
