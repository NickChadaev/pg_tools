DROP FUNCTION IF EXISTS fsc_orange_pcg.fsc_positions_crt_2 (positions_rt[]);
CREATE OR REPLACE FUNCTION fsc_orange_pcg.fsc_positions_crt_2(
       p_item positions_rt[] 
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- =====================================================================================
   --    2023-05-18  Создание объекта  "Предмет расчета"
   -- -------------------------------------------------------------------------------------
   --                Обязательные и опциональные атрибуты:
   -- ------------------------------------------------------------------------------------- 
   --   CREATE TYPE positions_rt AS (    
   --      quantity                 numeric (16,6) NOT NULL -- Количество
   --     ,price                    numeric (10,2) NOT NULL -- Цена в рублях
   --     ,tax                      integer        NOT NULL -- Ставка НДС, 1199:         int4range
   --     ,text                     text           NOT NULL -- Наименование товара/услуги      
   --     ,paymentMethodType        integer        NOT NULL -- Признак способа расчета   int4range 
   --     ,paymentSubjectType       integer        NOT NULL -- Признак предмета расчета  int4range 
   -- -------------------------------------------------------------------------------------
   --     ,taxSum                   numeric (10,2)  NULL -- Сумма НДС в рублях
   --     ,itemCode                 text            NULL -- Код маркировки
   --     ,supplierInfo             json            NULL -- Поставщик 
   --     ,supplierINN              text            NULL -- ИНН поставщика
   --     ,agentType                integer         NULL -- Признак агента по предмету расчета
   --     ,agentInfo                json            NULL -- Атрибуты агента
   --     ,quantityMeasurementUnit  integer         NULL -- Мера количества предмета расчета  int4range
   --     ,additionalAttribute      text            NULL -- Дополнительный реквизит предмета расчета 
   --     ,manufacturerCountryCode  text            NULL -- Код страны происхождения товара 
   --     ,customsDeclarationNumber text            NULL -- Номер таможенной декларации 
   --     ,excise                   numeric (10,2)  NULL -- Сумма акциза в рублях 
   --     ,unitTaxSum               numeric (10,2)  NULL -- Размер НДС за единицу предмета расчета
   --     ,fractionalQuantity       json                NULL -- Дробное количество маркированного товара 
   --     ,industryAttribute        json                NULL -- Отраслевой реквизит предмета расчета 
   --     ,barcodes                 json                NULL -- Штрих-коды предмета расчета 
   --   );
   --   COMMENT ON TYPE positions_rt IS 'Предмет расчёта (товар/услуга) (ORANGE)';
   -- ============================================================================ --

   DECLARE
     QTY_ITMS CONSTANT integer := 100; 
     
     JKEY  CONSTANT text := 'positions'; --  1/7/13/19          2/8/14/20             3/9/15                     4/10/16                      5/11/17              6/12/18/21                                
     JKEYS CONSTANT text[]:= ARRAY [ 'quantity',                'price',               'tax',                     'text',                     'paymentMethodType', 'paymentSubjectType'      
                                    ,'taxSum',                  'itemCode',            'supplierInfo',            'supplierINN',              'agentType',         'agentInfo'  
                                    ,'quantityMeasurementUnit', 'additionalAttribute', 'manufacturerCountryCode', 'customsDeclarationNumber', 'excise',            'unitTaxSum'
                                    ,'fractionalQuantity',      'industryAttribute',   'barcodes'
                                ]::text[];

     JMAX CONSTANT numeric (10,2)[]:= ARRAY [ 
                                         NULL,                      NULL,                  NULL,                    128,                       NULL,                 NULL      
                                       , NULL,                      223,                   NULL,                   NULL,                       NULL,                 NULL  
                                       , NULL,                       64,                      3,                     32,                       NULL,                 NULL          
                                       , NULL,                      NULL,                  NULL
                                ]::text[];

     VAT                       CONSTANT int4range := fsc_orange_pcg.c_vat();
     PAYMENT_METHOD_TYPE       CONSTANT int4range := fsc_orange_pcg.c_payment_method_type();
     PAYMENT_SUBJECT_TYPE      CONSTANT int4range := fsc_orange_pcg.c_payment_subject_type();
     AGENT_TYPE                CONSTANT integer[] := fsc_orange_pcg.c_agent_type();
     QUANTITY_MEASUREMENT_UNIT CONSTANT int4range := fsc_orange_pcg.c_quantity_measurement_unit();
     
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';     
     
     __lts_items_mess text := '"%s": Количество различных товаров/услуг не должно превышать: %s';
     
     __null_mess text := '"%s[%s]": Все данные являются обязательными: "%s" = %L, "%s" = %L, "%s" = %L, "%s" = %L'
                         ', "%s" = %L, "%s" = %L';  
                         
     __lts_mess text := '"%s": Длина "%s" должна быть не больше %s символов';
     __eqs_mess text := '"%s": Длина "%s" должна быть равна %s символам';     

     __vat_mess text := '"%s": Неправильный код ставки НДС: "%s" = %s';      
     __pmt_mess text := '"%s": Неправильный код способа расчёта: "%s" = %s';      
     __pst_mess text := '"%s": Неправильный код предмета расчёта: "%s" = %s'; 
     
     __agt_mess text := '"%s": Неправильный признак агента по предмету расчёта: "%s" = %s';
     __mqp_mess text := '"%s": Неправильный код меры количества: "%s" = %s';
     
    __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';
     
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
             IF  (__item.quantity IS NULL) OR (__item.price IS NULL) OR (__item.tax IS NULL) OR 
                 (__item.text IS NULL) OR (__item."paymentMethodType" IS NULL) OR 
                 (__item."paymentSubjectType" IS NULL)   
               THEN
                    RAISE '%', format (__null_mess, JKEY, __i
                                              , JKEYS[1], __item.quantity          
                                              , JKEYS[2], __item.price             
                                              , JKEYS[3], __item.tax               
                                              , JKEYS[4], __item.text              
                                              , JKEYS[5], __item."paymentMethodType" 
                                              , JKEYS[6], __item."paymentSubjectType" 
                                      );
               ELSIF NOT (VAT @> __item.tax) 
                   THEN
                       RAISE '%', format (__vat_mess, JKEY, JKEYS[3], __item.tax);
               
               ELSIF NOT (char_length(__item.text) <= JMAX[4]::integer)   
                   THEN
                        RAISE '%', format (__lts_mess, JKEY, JKEYS[4], JMAX[4]::integer);
             
               ELSIF NOT (PAYMENT_METHOD_TYPE @> __item."paymentMethodType")
                   THEN
                       RAISE '%', format (__pmt_mess, JKEY, JKEYS[5], __item."paymentMethodType");
             
               ELSIF NOT (PAYMENT_SUBJECT_TYPE @> __item."paymentSubjectType")
                   THEN
                       RAISE '%', format (__pst_mess, JKEY, JKEYS[6], __item."paymentSubjectType");
             
               ELSIF NOT (char_length(__item."itemCode") <= JMAX[8]::integer)   
                   THEN
                        RAISE '%', format (__lts_mess, JKEY, JKEYS[8], JMAX[8]::integer);             
             
              -- ELSIF NOT (char_length(__item.supplierINN) = JMAX[10]::integer)   
              --     THEN
              --          RAISE '%', format (__eqs_mess, JKEY, JKEYS[10], JMAX[10]::integer); 
                        
               ELSIF NOT (__item."supplierINN" ~ INN_PATTERN)
                     THEN
                         RAISE '%', format (__inn_mess, JKEY, JKEYS[10], __item."supplierINN");                         
             
               ELSIF NOT (__item."agentType" = ANY(AGENT_TYPE))
                   THEN
                       RAISE '%', format (__agt_mess, JKEY, JKEYS[11], __item."agentType");
             
               ELSIF NOT (QUANTITY_MEASUREMENT_UNIT @> __item."quantityMeasurementUnit")
                   THEN
                       RAISE '%', format (__mqp_mess, JKEY, JKEYS[13], __item."quantityMeasurementUnit");
             
               ELSIF NOT (char_length(__item."additionalAttribute") <= JMAX[14]::integer)   
                   THEN
                        RAISE '%', format (__lts_mess, JKEY, JKEYS[14], JMAX[14]::integer); 
             
               ELSIF NOT (char_length(__item."manufacturerCountryCode") <= JMAX[15]::integer)   
                   THEN
                        RAISE '%', format (__lts_mess, JKEY, JKEYS[15], JMAX[15]::integer); 
             
               ELSIF NOT (char_length(__item."customsDeclarationNumber") <= JMAX[16]::integer)   
                   THEN
                        RAISE '%', format (__lts_mess, JKEY, JKEYS[16], JMAX[16]::integer); 
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
