DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_items_crt_1 (item_t[]);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_items_crt_1(
       p_item item_t[] 
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
   --   CREATE TYPE item_t AS (    
   --      name                 text             -- Наименование товара/услуги      
   --     ,price                numeric (10,2)   -- Цена в рублях
   --     ,quantity             numeric (8,3)    -- Количество
   --     ,measure              integer          -- measure_t   -- Единица измерения  --!!! Значения контролирую в функции
   --     ,sum                  numeric (10,2)   -- Сумма в рублях
   --     ,payment_method       payment_method_t -- Способ расчёта
   --     ,payment_object       integer          -- Признак предмета расчёта  !!! Значения контролирую в функции
   --     ,vat                  json             -- Атрибуты налога на позицию
   -- -------------------------------------------------------------------------
   --     ,user_data            text          DEFAULT NULL -- Дополнительный реквизит предмета расчёта
   --     ,excise               numeric(10,2) DEFAULT NULL -- Сумма акциза в рублях 
   --     ,country_code         text          DEFAULT NULL -- Цифровой код страны происхождения товара 
   --     ,declaration_number   text          DEFAULT NULL -- Номер таможенной декларации
   --     ,mark_quantity        json          DEFAULT NULL -- Дробное количество маркированного товара
   --     ,mark_processing_mode text          DEFAULT NULL -- 
   --     ,sectoral_item_props  json          DEFAULT NULL --
   --     ,mark_code            json          DEFAULT NULL -- МАркировка средствами идентификации 
   --     ,agent_info           json          DEFAULT NULL -- Атрибуты агента
   --     ,supplier_info        json          DEFAULT NULL -- Поставщик 
   --                                         Поле обязательно, если передан «agent_info». 
   -- );
   --   COMMENT ON TYPE item_t IS 'Описание товара/услуги';
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

     MEASURE_0 CONSTANT int4range  := int4range('[0,0]');                            
     MEASURE_1 CONSTANT int4range  := int4range('[10,12]');                            
     MEASURE_2 CONSTANT int4range  := int4range('[20,22]');                            
     MEASURE_3 CONSTANT int4range  := int4range('[30,32]');                            
     MEASURE_4 CONSTANT int4range  := int4range('[40,42]');                            
     MEASURE_5 CONSTANT int4range  := int4range('[50,51]');                            
     MEASURE_6 CONSTANT int4range  := int4range('[70,73]');                            
     MEASURE_7 CONSTANT int4range  := int4range('[80,83]');                            
     MEASURE_8 CONSTANT int4range  := int4range('[255,255]');   
     
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
     __items item_t[];
     __item  item_t;
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
                         
                ELSIF NOT (( MEASURE_0 @> __item.measure) OR ( MEASURE_1 @> __item.measure) OR ( MEASURE_2 @> __item.measure) OR 
                           ( MEASURE_3 @> __item.measure) OR ( MEASURE_4 @> __item.measure) OR ( MEASURE_5 @> __item.measure) OR 
                           ( MEASURE_6 @> __item.measure) OR ( MEASURE_7 @> __item.measure) OR ( MEASURE_8 @> __item.measure)
                          )                                                                                   
                    THEN
                        RAISE '%', format (__msr_mess, JKEY, JKEYS[4], __item.measure);
     
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

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_items_crt_1 (item_t[])     
    IS 'Создание объекта "item" -- описание товаров/услуг';
--
--  USE CASE:
--             SEE TESTS
--------------------------------------------------------------------------------------------------------------
